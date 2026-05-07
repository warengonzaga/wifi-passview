from __future__ import annotations

import platform
import re
import shutil
import subprocess
from collections import OrderedDict
from typing import Callable

from wifi_passview.adapters.base import OSAdapter
from wifi_passview.models import CapabilityResult, CredentialFinding


class AdapterRuntimeError(RuntimeError):
    """Raised when command execution or parsing fails."""


Runner = Callable[[list[str]], subprocess.CompletedProcess[str]]
_KEY_VALUE_PATTERN = re.compile(r"^\s+[^:]+:\s*(.+)\s*$")


class WindowsWlanAdapter(OSAdapter):
    def __init__(self, runner: Runner | None = None) -> None:
        self._runner = runner or self._run

    def check_capability(self) -> CapabilityResult:
        system = platform.system()
        if system != "Windows":
            return CapabilityResult(
                supported=False,
                platform=system,
                adapter="windows",
                reason="Unsupported platform. This adapter requires Windows.",
            )
        if shutil.which("netsh") is None:
            return CapabilityResult(
                supported=False,
                platform=system,
                adapter="windows",
                reason="netsh command is unavailable.",
            )

        result = self._runner(["netsh", "wlan", "show", "profiles"])
        if result.returncode != 0:
            message = (result.stderr or result.stdout).strip() or "Unable to query wireless profiles."
            return CapabilityResult(
                supported=False,
                platform=system,
                adapter="windows",
                reason=message,
            )

        return CapabilityResult(supported=True, platform=system, adapter="windows", reason=None)

    def list_profiles(self) -> list[str]:
        self._ensure_supported()
        result = self._runner(["netsh", "wlan", "show", "profiles"])
        if result.returncode != 0:
            raise AdapterRuntimeError((result.stderr or result.stdout).strip() or "Failed to list WLAN profiles")
        profiles = self._parse_profiles_output(result.stdout)
        resolved_profiles: list[str] = []
        for profile in profiles:
            if profile.isdigit() and not self._profile_exists(profile):
                continue
            resolved_profiles.append(profile)
        return resolved_profiles

    def collect_findings(self) -> list[CredentialFinding]:
        findings: list[CredentialFinding] = []
        for profile in self.list_profiles():
            result = self._runner(["netsh", "wlan", "show", "profile", f'name="{profile}"', "key=clear"])
            if result.returncode != 0:
                findings.append(
                    CredentialFinding(
                        profile=profile,
                        authentication=None,
                        cipher=None,
                        security_key_enabled=None,
                        key_content=None,
                        error=(result.stderr or result.stdout).strip() or "Failed to query profile",
                    )
                )
                continue

            details = self._parse_profile_details_output(result.stdout)
            findings.append(
                CredentialFinding(
                    profile=details.get("profile") or profile,
                    authentication=details.get("authentication"),
                    cipher=details.get("cipher"),
                    security_key_enabled=self._to_bool(details.get("security_key")),
                    key_content=details.get("key_content"),
                    error=None,
                )
            )

        return findings

    def _ensure_supported(self) -> None:
        capability = self.check_capability()
        if not capability.supported:
            raise AdapterRuntimeError(capability.reason or "Capability check failed")

    @staticmethod
    def _run(command: list[str]) -> subprocess.CompletedProcess[str]:
        try:
            return subprocess.run(command, check=False, capture_output=True, text=True)
        except OSError as exc:
            raise AdapterRuntimeError(f"Command execution failed: {' '.join(command)}") from exc

    @staticmethod
    def _normalize_key(value: str) -> str:
        """Normalize `netsh` keys for resilient matching across spacing/casing differences."""
        return re.sub(r"[^a-z0-9]+", "", value.lower())

    @classmethod
    def _parse_profiles_output(cls, output: str) -> list[str]:
        profiles: "OrderedDict[str, None]" = OrderedDict()
        for raw_line in output.splitlines():
            match = _KEY_VALUE_PATTERN.match(raw_line)
            if not match:
                continue
            profile = match.group(1).strip('"')
            if not cls._is_profile_candidate(profile):
                continue
            profiles[profile] = None
        return list(profiles.keys())

    @staticmethod
    def _is_profile_candidate(value: str) -> bool:
        normalized = value.strip()
        if not normalized:
            return False
        if normalized.startswith("<") and normalized.endswith(">"):
            return False
        return True

    def _profile_exists(self, profile: str) -> bool:
        result = self._runner(["netsh", "wlan", "show", "profile", f'name="{profile}"'])
        return result.returncode == 0

    @classmethod
    def _parse_profile_details_output(cls, output: str) -> dict[str, str]:
        parsed: dict[str, str] = {}
        for raw_line in output.splitlines():
            if ":" not in raw_line:
                continue
            key, value = [part.strip() for part in raw_line.split(":", 1)]
            if not key:
                continue

            normalized = cls._normalize_key(key)
            if normalized in {"profile", "name"}:
                parsed.setdefault("profile", value.strip('"'))
            elif "ssidname" in normalized and "profile" not in parsed:
                parsed["profile"] = value.strip('"')
            elif "authentication" in normalized:
                parsed["authentication"] = value
            elif normalized == "cipher" or normalized.endswith("cipher"):
                parsed["cipher"] = value
            elif "securitykey" in normalized:
                parsed["security_key"] = value
            elif "keycontent" in normalized:
                parsed["key_content"] = value

        return parsed

    @staticmethod
    def _to_bool(value: str | None) -> bool | None:
        if value is None:
            return None
        lowered = value.strip().lower()
        if lowered in {"present", "yes", "true", "enabled"}:
            return True
        if lowered in {"absent", "no", "false", "disabled"}:
            return False
        return None

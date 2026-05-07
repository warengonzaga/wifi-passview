from __future__ import annotations

import json
import os
from datetime import datetime, timezone
from pathlib import Path

from wifi_passview.models import CapabilityResult, CredentialFinding


def build_report(capability: CapabilityResult, findings: list[CredentialFinding]) -> dict[str, object]:
    sorted_findings = sorted(findings, key=lambda item: item.profile.casefold())
    return {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "capability": capability.to_dict(),
        "totals": {
            "profiles": len(sorted_findings),
            "with_key_content": sum(1 for item in sorted_findings if item.key_content),
            "errors": sum(1 for item in sorted_findings if item.error),
        },
        "findings": [item.to_dict() for item in sorted_findings],
    }


def to_json(report_data: dict[str, object]) -> str:
    return json.dumps(report_data, indent=2, sort_keys=True)


def to_summary(report_data: dict[str, object]) -> str:
    totals = report_data["totals"]
    lines = [
        "wifi-passview defensive simulation summary",
        f"Profiles checked: {totals['profiles']}",
        f"Profiles with key content: {totals['with_key_content']}",
        f"Profiles with errors: {totals['errors']}",
    ]
    return "\n".join(lines)


def write_report(content: str, output_path: str | None, suffix: str) -> Path:
    default_name = f"wifi-passview-report.{suffix}"
    if output_path:
        path = Path(output_path)
        if output_path.endswith((os.sep, "/", "\\")) or path.is_dir():
            path = path / default_name
    else:
        path = Path.cwd() / default_name

    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    return path

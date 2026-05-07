from dataclasses import asdict, dataclass
from typing import Any


@dataclass(slots=True)
class CapabilityResult:
    supported: bool
    platform: str
    adapter: str
    reason: str | None = None

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


@dataclass(slots=True)
class CredentialFinding:
    profile: str
    authentication: str | None
    cipher: str | None
    security_key_enabled: bool | None
    key_content: str | None
    error: str | None = None

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)

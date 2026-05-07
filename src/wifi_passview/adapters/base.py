from abc import ABC, abstractmethod

from wifi_passview.models import CapabilityResult, CredentialFinding


class OSAdapter(ABC):
    @abstractmethod
    def check_capability(self) -> CapabilityResult:
        raise NotImplementedError

    @abstractmethod
    def list_profiles(self) -> list[str]:
        raise NotImplementedError

    @abstractmethod
    def collect_findings(self) -> list[CredentialFinding]:
        raise NotImplementedError

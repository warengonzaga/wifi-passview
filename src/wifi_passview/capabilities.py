from wifi_passview.adapters.base import OSAdapter
from wifi_passview.models import CapabilityResult


def detect_capabilities(adapter: OSAdapter) -> CapabilityResult:
    return adapter.check_capability()

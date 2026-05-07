from pathlib import Path
import subprocess

from wifi_passview.adapters.windows import WindowsWlanAdapter


FIXTURE_ROOT = Path(__file__).parent / "fixtures"


def _read_fixture(name: str) -> str:
    return (FIXTURE_ROOT / name).read_text(encoding="utf-8")


def test_parse_profiles_output_extracts_profiles_without_fixed_line_assumptions() -> None:
    output = _read_fixture("netsh_profiles.txt")

    profiles = WindowsWlanAdapter._parse_profiles_output(output)

    assert profiles[:3] == ["OfficeWiFi", "Lab-Network", "CoffeeShop"]


def test_parse_profile_details_extracts_security_fields() -> None:
    output = _read_fixture("netsh_profile_detail.txt")

    details = WindowsWlanAdapter._parse_profile_details_output(output)

    assert details["authentication"] == "WPA2-Personal"
    assert details["cipher"] == "CCMP"
    assert details["security_key"] == "Present"
    assert details["key_content"] == "super-secret-password"


def test_parse_profiles_output_supports_localized_labels() -> None:
    output = """
Perfiles en la interfaz Wi-Fi:
    Todos los perfiles de usuario : CasaWifi
    Perfil de usuario actual      : Oficina-5G
    Número de perfiles            : 2
"""

    profiles = WindowsWlanAdapter._parse_profiles_output(output)

    assert profiles[:2] == ["CasaWifi", "Oficina-5G"]


def test_list_profiles_keeps_numeric_ssids() -> None:
    profiles_output = """
Profiles on interface Wi-Fi:
    All User Profile     : 2024
    All User Profile     : OfficeWiFi
    Number of profiles   : 2
"""

    def runner(command: list[str]) -> subprocess.CompletedProcess[str]:
        if command == ["netsh", "wlan", "show", "profiles"]:
            return subprocess.CompletedProcess(command, 0, profiles_output, "")
        if command == ["netsh", "wlan", "show", "profile", 'name="2024"']:
            return subprocess.CompletedProcess(command, 0, "", "")
        if command == ["netsh", "wlan", "show", "profile", 'name="OfficeWiFi"']:
            return subprocess.CompletedProcess(command, 0, "", "")
        if command == ["netsh", "wlan", "show", "profile", 'name="2"']:
            return subprocess.CompletedProcess(command, 1, "", "Profile not found")
        return subprocess.CompletedProcess(command, 1, "", "Unexpected command")

    class TestAdapter(WindowsWlanAdapter):
        def _ensure_supported(self) -> None:
            return None

    adapter = TestAdapter(runner=runner)

    profiles = adapter.list_profiles()

    assert profiles == ["2024", "OfficeWiFi"]

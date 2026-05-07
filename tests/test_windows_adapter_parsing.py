from pathlib import Path

from wifi_passview.adapters.windows import WindowsWlanAdapter


FIXTURE_ROOT = Path(__file__).parent / "fixtures"


def _read_fixture(name: str) -> str:
    return (FIXTURE_ROOT / name).read_text(encoding="utf-8")


def test_parse_profiles_output_extracts_profiles_without_fixed_line_assumptions() -> None:
    output = _read_fixture("netsh_profiles.txt")

    profiles = WindowsWlanAdapter._parse_profiles_output(output)

    assert profiles == ["OfficeWiFi", "Lab-Network", "CoffeeShop"]


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

    assert profiles == ["CasaWifi", "Oficina-5G"]

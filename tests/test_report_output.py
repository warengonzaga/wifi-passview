from pathlib import Path

from wifi_passview.report import write_report


def test_write_report_accepts_directory_output_path(tmp_path: Path) -> None:
    report_dir = tmp_path / "reports"
    report_dir.mkdir()

    report_path = write_report("{}", str(report_dir), "json")

    assert report_path == report_dir / "wifi-passview-report.json"
    assert report_path.read_text(encoding="utf-8") == "{}"


def test_write_report_accepts_directory_path_with_trailing_separator(tmp_path: Path) -> None:
    report_dir = tmp_path / "out"
    assert not report_dir.exists()

    report_path = write_report("summary", f"{report_dir}/", "txt")

    assert report_path == report_dir / "wifi-passview-report.txt"
    assert report_dir.exists()
    assert report_path.read_text(encoding="utf-8") == "summary"

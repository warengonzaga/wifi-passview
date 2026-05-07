from __future__ import annotations

import argparse
import json
import sys

from wifi_passview.adapters.windows import AdapterRuntimeError, WindowsWlanAdapter
from wifi_passview.capabilities import detect_capabilities
from wifi_passview.report import build_report, to_json, to_summary, write_report

EXIT_OK = 0
EXIT_RUNTIME_ERROR = 1
EXIT_USAGE = 2
EXIT_UNSUPPORTED = 3

WARNING_BANNER = (
    "WARNING: This tool is only for authorized defensive security assessments, "
    "training labs, and red-team simulation with explicit permission."
)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="wifi-passview",
        description="Authorized Wi-Fi credential exposure simulation utility.",
    )
    parser.add_argument("--yes", action="store_true", help="Acknowledge authorized-use warning.")
    parser.add_argument(
        "--non-interactive",
        action="store_true",
        help="Fail instead of prompting when authorization has not been acknowledged.",
    )

    subparsers = parser.add_subparsers(dest="command", required=True)

    capability = subparsers.add_parser("capability", help="Check environment capability.")
    capability.add_argument("--format", choices=("text", "json"), default="text")

    profiles = subparsers.add_parser("list-profiles", help="List stored WLAN profile names.")
    profiles.add_argument("--format", choices=("text", "json"), default="text")

    collect = subparsers.add_parser("collect", help="Collect profile findings.")
    collect.add_argument("--format", choices=("json", "text"), default="json")
    collect.add_argument("--output", help="Local file path for report output.")

    return parser


def _require_authorization(args: argparse.Namespace) -> bool:
    print(WARNING_BANNER, file=sys.stderr)
    if args.yes:
        return True

    if args.non_interactive or not sys.stdin.isatty():
        print("Authorization acknowledgement required. Use --yes for non-interactive runs.", file=sys.stderr)
        return False

    answer = input("Type YES to continue: ").strip()
    if answer != "YES":
        print("Authorization not accepted. Aborting.", file=sys.stderr)
        return False
    return True


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    if args.command in {"list-profiles", "collect"} and not _require_authorization(args):
        return EXIT_USAGE

    adapter = WindowsWlanAdapter()
    capability = detect_capabilities(adapter)

    if args.command == "capability":
        if args.format == "json":
            print(json.dumps(capability.to_dict(), sort_keys=True))
        else:
            if capability.supported:
                print("Capability check passed: Windows WLAN access is available.")
            else:
                print(f"Capability check failed: {capability.reason}")
        return EXIT_OK if capability.supported else EXIT_UNSUPPORTED

    if not capability.supported:
        print(f"Cannot continue: {capability.reason}", file=sys.stderr)
        return EXIT_UNSUPPORTED

    try:
        if args.command == "list-profiles":
            profiles = adapter.list_profiles()
            if args.format == "json":
                print(json.dumps({"profiles": profiles}, sort_keys=True))
            else:
                for profile in profiles:
                    print(profile)
            return EXIT_OK

        findings = adapter.collect_findings()
        report_data = build_report(capability, findings)

        if args.format == "json":
            content = to_json(report_data)
            suffix = "json"
        else:
            content = to_summary(report_data)
            suffix = "txt"

        path = write_report(content, args.output, suffix)
        print(f"Report written to: {path}")
        return EXIT_OK

    except AdapterRuntimeError as exc:
        print(f"Operation failed: {exc}", file=sys.stderr)
        return EXIT_RUNTIME_ERROR


if __name__ == "__main__":
    raise SystemExit(main())

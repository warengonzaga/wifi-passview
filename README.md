# WiFi Passview

WiFi Passview is now a **Python-based CLI** for authorized red-team simulation and defensive security validation. It helps operators demonstrate local Wi-Fi credential exposure risk on Windows hosts that they are explicitly permitted to assess.

## Authorized Use Only

This project is for educational, defensive, and authorized assessment use only.

- Use only on systems you own or where you have explicit written permission.
- Do not use for stealth, unauthorized access, or data exfiltration.
- Reports are generated to local files by default.

## Migration Note

The legacy batch/Gulp/Node workflow has been replaced by this Python CLI implementation. Legacy build flow is no longer part of the active project architecture.

## Requirements

- Python 3.11+
- Windows (for profile and key collection capabilities)

## Installation

```bash
python -m pip install -e .[dev]
```

## CLI Usage

```bash
wifi-passview capability
wifi-passview --yes list-profiles --format json
wifi-passview --yes --non-interactive collect --format json --output ./reports/wifi.json
```

### Commands and options

- `capability`: Check platform/tool capability.
- `list-profiles`: Enumerate WLAN profiles.
- `collect`: Collect credential exposure findings into a local report.
- `--format`: Choose `text` or `json` output format (command-dependent).
- `--output`: Set local report path for `collect`.
- `--yes`: Acknowledge authorized-use warning.
- `--non-interactive`: Avoid prompts and fail if `--yes` is missing.

## Exit Codes

- `0`: Success
- `1`: Runtime/adapter error
- `2`: Usage or authorization gate failure
- `3`: Unsupported platform/capability

## Testing

```bash
pytest
```

The parser tests use mocked `netsh` output fixtures to validate profile and credential parsing behavior.

## Supported Platforms and Capability Notes

- **Windows**: first-class support via `netsh wlan` commands.
- **Localized Windows output**: profile discovery is locale-tolerant, but detailed field extraction (`authentication`, `cipher`, `security key`, `key content`) is optimized for English-labeled `netsh` output and may return null values on some localized systems.
- **Non-Windows**: capability check returns unsupported with explicit messaging.

## License

WiFi Passview is licensed under GNU General Public License v3.0.

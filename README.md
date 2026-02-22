# Windows Tune-Up Script

> Utility script for Windows maintenance, repair and reversible optimization routines.

![CI](https://github.com/ESousa97/windows-tuneup-script/actions/workflows/ci.yml/badge.svg)
![License](https://img.shields.io/github/license/ESousa97/windows-tuneup-script)
![Windows Script Host](https://img.shields.io/badge/WSH-10.0-blue)
![Last Commit](https://img.shields.io/github/last-commit/ESousa97/windows-tuneup-script)
![Open Issues](https://img.shields.io/github/issues/ESousa97/windows-tuneup-script)

---

This project provides an interactive VBScript menu to run common Windows maintenance and recovery operations with audit logging and reversible configuration snapshots. It is designed for advanced users and operators who need a fast local tool to execute DISM, SFC, service tuning, cleanup and rollback routines. The script prioritizes operational pragmatism and traceability over abstraction.

## Demonstration

Run locally with administrator rights:

```powershell
cscript //nologo tuneup_windows.vbs
```

Example flow:

- Select `1` for system inventory.
- Select `98` for full optimization routine.
- Select `99` for full reversible rollback.

## Technology Stack

| Technology | Role |
|---|---|
| VBScript (`.vbs`) | Main runtime and orchestration |
| Windows Script Host 10.0 | Script engine (`cscript` / `wscript`) |
| PowerShell | Auxiliary advanced operations (BITS, Store restore, BSOD reports) |
| WMI + native Windows CLI tools | Service/task/system management |

## Prerequisites

- Windows 10/11 (best effort for 7/8/8.1)
- Administrator privileges
- PowerShell 7+ for local quality scripts

## Installation and Usage

```powershell
git clone https://github.com/ESousa97/windows-tuneup-script.git
cd windows-tuneup-script
pwsh ./scripts/validate.ps1
cscript //nologo tuneup_windows.vbs
```

Optional runtime path overrides:

```powershell
$env:TUNEUP_LOG_PATH = 'C:\Temp\TuneUp_Log.txt'
$env:TUNEUP_BACKUP_PATH = 'C:\Temp\TuneUp_Backup.ini'
cscript //nologo tuneup_windows.vbs
```

## Available Commands

| Command | Description |
|---|---|
| `pwsh ./scripts/lint.ps1` | Static repository and script quality checks |
| `pwsh ./scripts/test.ps1` | Smoke tests for critical script contracts |
| `pwsh ./scripts/build.ps1` | Generates distributable ZIP in `dist/` |
| `pwsh ./scripts/security-audit.ps1` | Basic secret-pattern scan |
| `pwsh ./scripts/validate.ps1` | Runs lint + tests + build + security audit |

## Architecture

- `tuneup_windows.vbs`: main interactive runtime
- `scripts/`: local automation for quality gates
- `.github/workflows/`: CI and scheduled security checks
- `docs/`: architecture, setup and deployment documentation

Detailed architecture notes: `docs/architecture.md`.

## API Reference

Not applicable. This project is a local interactive maintenance utility, not a network API.

## Roadmap

- [x] Baseline governance and CI setup
- [x] Input hardening for advanced DISM source flow
- [ ] Add isolated dry-run mode for non-destructive validation
- [ ] Expand automated checks for compatibility matrix by Windows version
- [ ] Publish signed release artifacts with checksum

## Contributing

See `CONTRIBUTING.md` for setup, conventions, commit format and PR process.

## License

Licensed under MIT. See `LICENSE`.

## Author

- Enoque Sousa
- Portfolio: https://enoquesousa.vercel.app
- GitHub: https://github.com/ESousa97
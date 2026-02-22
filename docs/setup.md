# Setup Guide

## Local execution (interactive)

1. Open a terminal as Administrator.
2. Navigate to the repository folder.
3. Run:

```powershell
cscript //nologo tuneup_windows.vbs
```

You can also run by double-clicking in Explorer; the script will request elevation automatically.

## Optional environment overrides

Copy `.env.example` and set variables in your session before running:

```powershell
$env:TUNEUP_LOG_PATH = 'C:\Temp\TuneUp_Log.txt'
$env:TUNEUP_BACKUP_PATH = 'C:\Temp\TuneUp_Backup.ini'
cscript //nologo tuneup_windows.vbs
```

## Quality checks

```powershell
pwsh ./scripts/lint.ps1
pwsh ./scripts/test.ps1
pwsh ./scripts/build.ps1
pwsh ./scripts/security-audit.ps1
pwsh ./scripts/validate.ps1
```

## Build artifact

`pwsh ./scripts/build.ps1` generates:

- `dist/windows-tuneup-script.zip`

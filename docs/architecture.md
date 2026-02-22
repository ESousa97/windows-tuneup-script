# Architecture

## Overview

`windows-tuneup-script` is a privileged, menu-driven maintenance utility for Windows systems.
The runtime is Windows Script Host (`cscript`/`wscript`) and the script orchestrates native Windows tools (DISM, SFC, SC, SCHTASKS, NETSH, CHKDSK, PowerShell).

## Main modules inside `tuneup_windows.vbs`

- **Bootstrap layer**: admin elevation, log initialization and menu loop.
- **Information module**: WMI-based system inspection.
- **Snapshot module**: persistent key-value backup of service/task/registry states.
- **Apply/Revert module**: optimization actions and safe rollback paths.
- **Repair module**: Windows repair routines (DISM/SFC/Windows Update reset/network reset/chkdsk).
- **Advanced module**: local source DISM, Store restore, BITS management, BSOD report.
- **Helper module**: command execution, file I/O, registry and task utilities.

## Design decisions

1. **Single-file runtime script**: keeps execution simple for end users and avoids packaging dependencies.
2. **State snapshot before mutations**: all reversible actions depend on persisted backup state.
3. **Command logging**: each command execution path writes operation details for supportability.
4. **Environment override for output paths**: allows safer enterprise path policies without code edits.

## Data flow

1. User selects an operation from the menu.
2. If operation mutates system state, snapshot guard is executed.
3. Command(s) run through shared executor with logging.
4. Completion is surfaced via `MsgBox` and persisted in log.

## Constraints

- Administrative privilege is mandatory for core operations.
- Many routines are inherently destructive/reconfiguration-oriented and rely on operator intent.
- Full automated functional tests are limited due to privileged and interactive side effects.

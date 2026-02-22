# Contributing

> Este repositório está arquivado e não está mais em desenvolvimento ativo.
> Ele permanece público apenas para fins de estudo e referência.
> Não há garantia de resposta, revisão ou correção de issues/PRs.

## Development setup

### Prerequisites

- Windows 10 or 11
- PowerShell 7+
- Administrative privileges to execute the script end-to-end

### Clone and validate

```powershell
git clone https://github.com/ESousa97/windows-tuneup-script.git
cd windows-tuneup-script
pwsh ./scripts/validate.ps1
```

## Code style and conventions

- Repository formatting is enforced by `.editorconfig`.
- Keep line endings as LF in source control (`.gitattributes` handles normalization).
- Preserve script behavior and menu compatibility when refactoring.
- Avoid hardcoded credentials and sensitive information.

## Branching and commits

### Branch naming

- `feat/<short-description>`
- `fix/<short-description>`
- `refactor/<short-description>`
- `docs/<short-description>`
- `ci/<short-description>`

### Conventional Commits

Use the format:

```text
<type>(<scope>): <description>
```

Allowed types:

- `feat` — new feature
- `fix` — bug fix
- `refactor` — behavior-preserving refactor
- `docs` — documentation changes
- `style` — formatting-only changes
- `test` — test additions or fixes
- `chore` — maintenance/config updates
- `ci` — CI/CD changes
- `perf` — performance improvements
- `security` — security hardening

## Pull request process

1. Open a PR against `main`.
2. Fill out the PR template completely.
3. Ensure CI is green.
4. Request review from `@ESousa97`.
5. Keep PRs atomic and focused on one logical change.

## Running checks locally

```powershell
pwsh ./scripts/lint.ps1
pwsh ./scripts/test.ps1
pwsh ./scripts/build.ps1
pwsh ./scripts/security-audit.ps1
pwsh ./scripts/validate.ps1
```

## Contribution focus areas

- Reliability improvements for maintenance operations
- Additional rollback safety checks
- Windows compatibility verification
- Documentation and troubleshooting quality

## Author

- Portfolio: https://enoquesousa.vercel.app
- GitHub: https://github.com/ESousa97

# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/) and this project follows [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [1.1.1] - 2026-02-21

### Changed

- Marked repository as archived for study/reference purposes only.
- Updated governance documents to state that the project is no longer active and does not guarantee responses, reviews or fixes.
- Added visible archive warning to issue and pull request templates.
- Configured Dependabot to stop opening new pull requests.

## [1.1.0] - 2026-02-21

### Added

- Repository governance baseline: `.editorconfig`, `.gitattributes`, `.gitignore`, `.env.example`.
- GitHub governance assets: issue templates, PR template, `CODEOWNERS`, `FUNDING.yml`.
- CI/CD workflows (`ci.yml`, `security.yml`) and Dependabot configuration.
- Local quality scripts (`scripts/lint.ps1`, `scripts/test.ps1`, `scripts/build.ps1`, `scripts/security-audit.ps1`, `scripts/validate.ps1`).
- Project documentation suite: `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, docs in `docs/`.

### Changed

- Refactored `tuneup_windows.vbs` to centralize critical constants for services/tasks.
- Added environment-based path overrides (`TUNEUP_LOG_PATH`, `TUNEUP_BACKUP_PATH`) with safe defaults.
- Hardened `RunDISMWithSource` with input sanitization and file/index validation.
- Rewrote README in professional format with real badges and operational guidance.

### Fixed

- Reduced risk of command injection in DISM local source flow by rejecting unsafe characters and invalid paths.
- Reduced maintenance risk from repeated hardcoded identifiers.

### Security

- Added baseline security policy and automated secret-pattern scan for repository content.

## [1.0.0] - 2025-08-27

### Added

- Initial release of interactive Windows tune-up VBScript with optimization, repair and rollback menus.

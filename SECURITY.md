# Security Policy

> Este repositório está arquivado e não está mais em desenvolvimento ativo.
> Ele permanece público apenas para estudo e referência.
> Não há garantia de resposta, revisão ou correção, incluindo relatórios de segurança.

## Supported versions

| Version | Supported |
|---|---|
| Current `main` branch | ✅ |
| Older snapshots/releases | ⚠️ Best effort |

## Reporting a vulnerability

Please report vulnerabilities privately using one of the channels below:

- GitHub Security Advisory: https://github.com/ESousa97/windows-tuneup-script/security/advisories/new
- Private contact via portfolio form: https://enoquesousa.vercel.app

Do not open public issues for undisclosed vulnerabilities.

## Response policy (SLA)

- Este repositório arquivado não possui SLA garantido.
- Initial triage response: up to 72 hours
- Confirmation and severity classification: up to 7 days
- Patch or mitigation plan: up to 14 days for high/critical issues

## Disclosure guidelines

- Share reproduction steps and impacted Windows version(s).
- Include risk impact and expected exploitability.
- Allow reasonable remediation time before public disclosure.

## Security baseline

This repository applies the following baseline:

- No secrets committed to source control
- Internal reports excluded from VCS (`BASELINE.md`, `FINAL.md`)
- Automated secret-pattern scan in CI (`scripts/security-audit.ps1`)
- Controlled privilege requirement documented in README

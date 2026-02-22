$ErrorActionPreference = 'Stop'

& (Join-Path $PSScriptRoot 'lint.ps1')
& (Join-Path $PSScriptRoot 'test.ps1')
& (Join-Path $PSScriptRoot 'build.ps1')
& (Join-Path $PSScriptRoot 'security-audit.ps1')

Write-Host 'Validação completa concluída.'

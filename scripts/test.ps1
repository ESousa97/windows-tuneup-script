$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$scriptPath = Join-Path $repoRoot 'tuneup_windows.vbs'

if (-not (Test-Path $scriptPath)) {
  throw "Arquivo principal não encontrado: $scriptPath"
}

$content = Get-Content -LiteralPath $scriptPath -Raw -Encoding UTF8

$assertions = @(
  @{ Name = 'Menu principal contém opção de saída'; Check = ($content -match '"\s*0\)\s*Sair"') },
  @{ Name = 'Snapshot é criado sob demanda'; Check = ($content -match 'If Not fso\.FileExists\(bakPath\) Then SnapshotState') },
  @{ Name = 'Reversão completa disponível'; Check = ($content -match 'Sub RestoreAll\(\)') },
  @{ Name = 'Validação de DISM com fonte local ativa'; Check = ($content -match 'IsValidLocalImagePath') },
  @{ Name = 'Execução de comandos logada'; Check = ($content -match 'Call LogLine\("CMD: " \& cmd') }
)

$failed = @($assertions | Where-Object { -not $_.Check })

if ($failed.Count -gt 0) {
  $failed | ForEach-Object { Write-Error "Teste falhou: $($_.Name)" }
  exit 1
}

Write-Host ("Testes concluídos com sucesso: {0} verificações." -f $assertions.Count)

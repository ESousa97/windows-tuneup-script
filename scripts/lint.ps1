$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$scriptPath = Join-Path $repoRoot 'tuneup_windows.vbs'

if (-not (Test-Path $scriptPath)) {
  throw "Arquivo principal não encontrado: $scriptPath"
}

$content = Get-Content -LiteralPath $scriptPath -Raw -Encoding UTF8
$lines = Get-Content -LiteralPath $scriptPath -Encoding UTF8

$errors = New-Object System.Collections.Generic.List[string]

if ($content -notmatch '(?m)^Option Explicit\s*$') {
  $errors.Add('Option Explicit ausente no script.')
}

if ($content -match '(?m)^(<<<<<<<|=======|>>>>>>>)') {
  $errors.Add('Marcadores de conflito de merge detectados.')
}

$forbiddenTabs = $lines | Where-Object { $_ -match "`t" }
if ($forbiddenTabs.Count -gt 0) {
  $errors.Add('Foram encontrados TABs no arquivo; use espaços para manter consistência de estilo.')
}

$requiredSymbols = @(
  'Function MenuText()',
  'Sub ShowRepairMenu()',
  'Sub ShowAdvancedMenu()',
  'Sub EnsureSnapshot()',
  'Sub RestoreAll()',
  'Sub RunDISMWithSource()'
)

foreach ($symbol in $requiredSymbols) {
  if ($content -notlike "*$symbol*") {
    $errors.Add("Símbolo obrigatório não encontrado: $symbol")
  }
}

if ($errors.Count -gt 0) {
  $errors | ForEach-Object { Write-Error $_ }
  exit 1
}

Write-Host 'Lint checks concluídos com sucesso.'

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')

$suspiciousPatterns = @(
  '(?i)api[_-]?key\s*[=:]\s*[^\s]+'
  '(?i)secret\s*[=:]\s*[^\s]+'
  '(?i)token\s*[=:]\s*[^\s]+'
  '(?i)password\s*[=:]\s*[^\s]+'
)

$extensions = @('*.vbs','*.md','*.yml','*.yaml','*.ps1','*.txt')
$files = Get-ChildItem -Path $repoRoot -Recurse -File -Include $extensions |
  Where-Object { $_.FullName -notmatch '\\.git\\|\\dist\\|\\coverage\\' }

$hits = New-Object System.Collections.Generic.List[string]

foreach ($file in $files) {
  $content = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
  foreach ($pattern in $suspiciousPatterns) {
    if ($content -match $pattern) {
      $hits.Add("Possível segredo em: $($file.FullName) | padrão: $pattern")
    }
  }
}

if ($hits.Count -gt 0) {
  $hits | ForEach-Object { Write-Error $_ }
  exit 1
}

Write-Host 'Security audit básico concluído sem achados de segredos em texto claro.'

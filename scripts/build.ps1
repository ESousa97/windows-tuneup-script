$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$distDir = Join-Path $repoRoot 'dist'
$outZip = Join-Path $distDir 'windows-tuneup-script.zip'

if (Test-Path $distDir) {
  Remove-Item -LiteralPath $distDir -Recurse -Force
}

New-Item -ItemType Directory -Path $distDir | Out-Null

$filesToPack = @(
  'LICENSE',
  'README.md',
  'tuneup_windows.vbs',
  '.env.example',
  'CONTRIBUTING.md',
  'SECURITY.md',
  'CODE_OF_CONDUCT.md',
  'CHANGELOG.md'
) | ForEach-Object { Join-Path $repoRoot $_ }

$missing = @($filesToPack | Where-Object { -not (Test-Path $_) })
if ($missing.Count -gt 0) {
  $missing | ForEach-Object { Write-Error "Arquivo obrigatório ausente para build: $_" }
  exit 1
}

Compress-Archive -Path $filesToPack -DestinationPath $outZip -CompressionLevel Optimal
Write-Host "Build concluído: $outZip"

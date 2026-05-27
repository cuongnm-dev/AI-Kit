# Install full AI Platform stack (ai-kit CLI + engine-config + MCP via ai-kit).
# Requires: Node.js 18+, Docker, git
param(
    [switch]$SkipStudio
)

$ErrorActionPreference = 'Stop'
$Repo = 'cuongnm-dev/ai-kit'
$InstallRoot = Join-Path $env:USERPROFILE '.ai-kit'

Write-Host ''
Write-Host '  AI Platform — bootstrap (Windows)' -ForegroundColor Cyan
Write-Host '  Distribution: https://github.com/' -NoNewline
Write-Host $Repo -ForegroundColor Gray
Write-Host ''

# Delegate to ai-kit zip install if present in same repo checkout
$LocalZip = Get-ChildItem -Path (Join-Path (Split-Path $PSScriptRoot -Parent | Split-Path -Parent) 'release-dist') -Filter 'ai-kit-*.zip' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($LocalZip) {
    Write-Host "  Using local package: $($LocalZip.Name)" -ForegroundColor DarkGray
    $tmp = Join-Path $env:TEMP "ai-kit-bootstrap"
    if (Test-Path $tmp) { Remove-Item -Recurse -Force $tmp }
    Expand-Archive -Path $LocalZip.FullName -DestinationPath $tmp -Force
    & (Join-Path $tmp 'install.ps1')
} else {
    & (Join-Path $PSScriptRoot 'install-ai-kit.ps1')
}

$aiKit = Get-Command ai-kit -ErrorAction SilentlyContinue
if (-not $aiKit) {
    $bin = Join-Path $InstallRoot 'bin'
    if (Test-Path (Join-Path $bin 'ai-kit.cmd')) { $env:Path = "$bin;$env:Path" }
}

if (Get-Command ai-kit -ErrorAction SilentlyContinue) {
    ai-kit update
    ai-kit doctor
} else {
    Write-Warning 'ai-kit not on PATH. Open a new terminal or run scripts/install/install-ai-kit.ps1 again.'
}

if (-not $SkipStudio) {
    Write-Host ''
    Write-Host '  Optional: install AI Studio desktop' -ForegroundColor Yellow
    Write-Host '  irm .../scripts/install/install-ai-studio.ps1 | iex' -ForegroundColor DarkGray
}

Write-Host ''
Write-Host '  Done. Next: ai-kit status' -ForegroundColor Green
Write-Host ''

# Remove ai-kit CLI install (~/.ai-kit). Does not remove ~/.config/ai-engine unless -IncludeEngine.
param(
    [switch]$Yes,
    [switch]$IncludeEngine
)

$ErrorActionPreference = 'Stop'
$KitHome = Join-Path $env:USERPROFILE '.ai-kit'
$EngineConfig = Join-Path $env:USERPROFILE '.config\ai-engine'

if (-not $Yes) {
    Write-Host 'This removes:' -ForegroundColor Yellow
    Write-Host "  $KitHome"
    if ($IncludeEngine) { Write-Host "  $EngineConfig" }
    $confirm = Read-Host 'Continue? (y/N)'
    if ($confirm -notmatch '^[yY]') { exit 0 }
}

if (Test-Path $KitHome) {
    Remove-Item -Recurse -Force $KitHome
    Write-Host "  Removed $KitHome" -ForegroundColor Green
} else {
    Write-Host "  Not found: $KitHome" -ForegroundColor DarkGray
}

if ($IncludeEngine -and (Test-Path $EngineConfig)) {
    Remove-Item -Recurse -Force $EngineConfig
    Write-Host "  Removed $EngineConfig" -ForegroundColor Green
}

Write-Host '  Tip: ai-kit uninstall --yes does the same for ~/.ai-kit only.' -ForegroundColor DarkGray

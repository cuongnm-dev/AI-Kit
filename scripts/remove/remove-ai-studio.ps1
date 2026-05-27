# Remove AI Studio user data and shortcuts. Uninstall app via Windows Settings when possible.
$ErrorActionPreference = 'Continue'

Write-Host '  AI Studio — remove local data' -ForegroundColor Cyan

$paths = @(
    (Join-Path $env:APPDATA 'ai-studio'),
    (Join-Path $env:LOCALAPPDATA 'ai-studio'),
    (Join-Path $env:USERPROFILE '.config\ai-studio')
)

foreach ($p in $paths) {
    if (Test-Path $p) {
        Remove-Item -Recurse -Force $p -ErrorAction SilentlyContinue
        Write-Host "  Removed $p" -ForegroundColor Green
    }
}

Write-Host ''
Write-Host '  Uninstall the app: Settings -> Apps -> AI Studio -> Uninstall' -ForegroundColor Yellow
Write-Host '  Or re-run the NSIS installer and choose Remove.' -ForegroundColor DarkGray

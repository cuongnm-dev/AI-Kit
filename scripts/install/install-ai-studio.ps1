# Download latest AI Studio installer from GitHub Releases (Windows).
$ErrorActionPreference = 'Stop'
$Repo = 'cuongnm-dev/ai-kit'
$Api = "https://api.github.com/repos/$Repo/releases/latest"

Write-Host "  Fetching AI Studio from $Repo ..." -ForegroundColor Cyan
$release = Invoke-RestMethod -Uri $Api -Headers @{ 'User-Agent' = 'ai-platform-bootstrap' }
$arch = if ([Environment]::Is64BitOperatingSystem) { 'x64' } else { 'x86' }
$asset = $release.assets | Where-Object { $_.name -match "AI Studio-.*-${arch}\.exe$" } | Select-Object -First 1
if (-not $asset) {
    $asset = $release.assets | Where-Object { $_.name -match 'AI Studio-.*\.exe$' } | Select-Object -First 1
}
if (-not $asset) { throw 'No AI Studio *.exe on latest release. Upload installer to Releases first.' }

$dest = Join-Path $env:TEMP $asset.name
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $dest -UseBasicParsing
Write-Host "  Running installer: $dest" -ForegroundColor Cyan
Start-Process -FilePath $dest -Wait
Write-Host "  AI Studio $($release.tag_name) installed." -ForegroundColor Green

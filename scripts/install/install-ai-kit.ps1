# Download latest ai-kit bundle from GitHub Releases and install to ~/.ai-kit
$ErrorActionPreference = 'Stop'
$Repo = 'cuongnm-dev/ai-kit'
$Api = "https://api.github.com/repos/$Repo/releases/latest"
$InstallRoot = Join-Path $env:USERPROFILE '.ai-kit'

Write-Host "  Fetching latest release from $Repo ..." -ForegroundColor Cyan
$release = Invoke-RestMethod -Uri $Api -Headers @{ 'User-Agent' = 'ai-platform-bootstrap' }
$asset = $release.assets | Where-Object { $_.name -match '^ai-kit-.*\.zip$' } | Select-Object -First 1
if (-not $asset) { throw 'No ai-kit-*.zip found on latest release. Upload build to Releases first.' }

$tmpZip = Join-Path $env:TEMP $asset.name
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $tmpZip -UseBasicParsing

$tmpDir = Join-Path $env:TEMP 'ai-kit-install'
if (Test-Path $tmpDir) { Remove-Item -Recurse -Force $tmpDir }
Expand-Archive -Path $tmpZip -DestinationPath $tmpDir -Force

if (Test-Path (Join-Path $tmpDir 'install.ps1')) {
    & (Join-Path $tmpDir 'install.ps1')
} else {
    if (Test-Path $InstallRoot) { Remove-Item -Recurse -Force $InstallRoot }
    New-Item -ItemType Directory -Path $InstallRoot -Force | Out-Null
    Copy-Item -Path (Join-Path $tmpDir '*') -Destination $InstallRoot -Recurse -Force
    $bin = Join-Path $InstallRoot 'bin'
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    if ($userPath -notlike "*$bin*") {
        [Environment]::SetEnvironmentVariable('Path', "$userPath;$bin", 'User')
        Write-Host "  Added $bin to User PATH (new terminal required)." -ForegroundColor Yellow
    }
}

Write-Host "  Installed ai-kit $($release.tag_name) -> $InstallRoot" -ForegroundColor Green

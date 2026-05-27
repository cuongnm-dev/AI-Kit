# Remove AI Platform stack: MCP container, ai-kit, AI Studio data. Optional engine config.
param(
    [switch]$Yes,
    [switch]$KeepEngine
)

$ErrorActionPreference = 'Continue'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not $Yes) {
    Write-Host 'Will remove: ai-kit (~/.ai-kit), AI Studio app data, Docker MCP (if running)' -ForegroundColor Yellow
    if (-not $KeepEngine) { Write-Host '  and ~/.config/ai-engine (use -KeepEngine to skip)' }
    $confirm = Read-Host 'Continue? (y/N)'
    if ($confirm -notmatch '^[yY]') { exit 0 }
}

if (Get-Command docker -ErrorAction SilentlyContinue) {
    docker compose -f "$env:USERPROFILE\.ai-kit\mcp\docker-compose.yml" down 2>$null
    docker rm -f ai-mcp 2>$null
}

& (Join-Path $ScriptDir 'remove-ai-studio.ps1')
$kitArgs = @{ Yes = $true }
if (-not $KeepEngine) { $kitArgs['IncludeEngine'] = $true }
& (Join-Path $ScriptDir 'remove-ai-kit.ps1') @kitArgs

Write-Host ''
Write-Host '  remove-all complete.' -ForegroundColor Green

<#
.SYNOPSIS
    Remove all ai-kit ecosystem products and related global config from Windows user profile.
.DESCRIPTION
    This script deletes known installation folders and configuration paths for ai-kit, ai-studio, ai-engine, ai-mcp,
    and legacy OpenCode/engine config targets. It is intended as a full cleanup tool for a single user.
.PARAMETER Yes
    Skip the confirmation prompt and perform the removal immediately.
.PARAMETER DryRun
    Show the paths that would be removed without deleting anything.
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [switch]$Yes,
    [switch]$DryRun,
    [string]$Root
)

function Get-UserPaths {
    param([string]$RootPath)
    $homeDir = if ($RootPath) { $RootPath } else { [Environment]::GetFolderPath('UserProfile') }
    $localAppData = if ($RootPath) { Join-Path $RootPath 'AppData\Local' } else { [Environment]::GetFolderPath('LocalApplicationData') }
    $appData = if ($RootPath) { Join-Path $RootPath 'AppData\Roaming' } else { [Environment]::GetFolderPath('ApplicationData') }

    @(
        "$homeDir\.ai-kit",
        "$homeDir\.config\opencode\agent",
        "$homeDir\.config\opencode\command",
        "$homeDir\.config\ai-engine",
        "$homeDir\.config\engine",
        "$homeDir\.config\ai-studio",
        "$homeDir\.config\ai-kit",
        "$homeDir\.config\vibe-studio",
        "$localAppData\Programs\AI Studio",
        "$localAppData\Programs\AI-Studio",
        "$localAppData\AI Studio",
        "$localAppData\AI-Studio",
        "$localAppData\ai-kit",
        "$appData\AI Studio",
        "$appData\ai-kit",
        "$appData\ai-studio",
        "$appData\ai-engine",
        "$appData\ai-mcp",
        "$localAppData\Temp\ai-kit*",
        "$localAppData\Temp\ai-studio*",
        "$homeDir\AppData\Local\Temp\ai-kit*",
        "$homeDir\AppData\Local\Temp\ai-studio*"
    ) | Sort-Object -Unique
}

function Get-RegistryKeys {
    @(
        'HKCU:\Software\AI Studio',
        'HKCU:\Software\AI-Studio',
        'HKCU:\Software\ai-kit',
        'HKCU:\Software\ai-engine',
        'HKCU:\Software\ai-mcp',
        'HKCU:\Software\OpenCode',
        'HKCU:\Software\engine'
    )
}

$paths = Get-UserPaths -RootPath $Root | Where-Object { Test-Path $_ }
$keys = Get-RegistryKeys | Where-Object { Test-Path $_ }

if ($paths.Count -eq 0 -and $keys.Count -eq 0) {
    Write-Host 'Không tìm thấy đường dẫn cài đặt/config liên quan đến ai-kit/ai-studio/ai-engine/ai-mcp.' -ForegroundColor Yellow
    exit 0
}

Write-Host 'Các đường dẫn sẽ bị xoá:' -ForegroundColor Cyan
$paths | ForEach-Object { Write-Host "  $_" }
if ($keys.Count -gt 0) {
    Write-Host 'Các registry key sẽ bị xoá:' -ForegroundColor Cyan
    $keys | ForEach-Object { Write-Host "  $_" }
}

if ($DryRun) {
    Write-Host 'Dry run: không xoá gì cả.' -ForegroundColor Yellow
    exit 0
}

if (-not $Yes) {
    $confirm = Read-Host 'Xác nhận xoá toàn bộ các đường dẫn trên? Nhập Y để tiếp tục'
    if ($confirm -notin @('Y','y')) {
        Write-Host 'Đã huỷ.' -ForegroundColor Yellow
        exit 1
    }
}

foreach ($path in $paths) {
    try {
        Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
        Write-Host "Đã xoá: $path" -ForegroundColor Green
    } catch {
        Write-Warning "Không thể xoá ${path}: $($PSItem.Exception.Message)"
    }
}

foreach ($key in $keys) {
    try {
        Remove-Item -LiteralPath $key -Recurse -Force -ErrorAction Stop
        Write-Host "Đã xoá registry: $key" -ForegroundColor Green
    } catch {
        Write-Warning "Không thể xoá registry ${key}: $($PSItem.Exception.Message)"
    }
}

Write-Host 'Đã hoàn tất xóa các sản phẩm và cấu hình toàn cục.' -ForegroundColor Green

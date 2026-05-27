# AI Platform — bootstrap (Windows)
# Entry point at repo root for: irm .../bootstrap.ps1 | iex
$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$InstallScript = Join-Path $ScriptDir 'scripts\install\bootstrap.ps1'
if (-not (Test-Path $InstallScript)) {
    Write-Error "Missing $InstallScript — sync scripts from the distribution repo."
}
& $InstallScript @args

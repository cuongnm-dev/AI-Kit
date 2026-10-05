# uninstall-cert.ps1
# Remove ETC AI Platform public code-signing certificate from the MACHINE-WIDE Windows trust stores.
# Requires: Administrator privileges (writes to LocalMachine trust stores).
#
# Usage:
#   pwsh -ExecutionPolicy Bypass -File scripts/uninstall-cert.ps1

#Requires -Version 5.1
#Requires -RunAsAdministrator

[CmdletBinding()]
param(
  [string] $Thumbprint = '90845F3F36BEEB8D8C4ED2D067662F6832E4EA85',
  [string] $CertPath = (Join-Path $PSScriptRoot 'etc-codesign.cer')
)

$ErrorActionPreference = 'Stop'

function Write-Step($m) { Write-Host "==> $m" -ForegroundColor Cyan }
function Write-OK($m)   { Write-Host "    OK $m" -ForegroundColor Green }
function Write-Info($m) { Write-Host "    .. $m" -ForegroundColor Gray }
function Write-Warn($m) { Write-Host "    !! $m" -ForegroundColor Yellow }

# Resolve thumbprint from cert file if available
if (Test-Path $CertPath) {
  try {
    $cert = Get-PfxCertificate -FilePath $CertPath
    if ($cert -and $cert.Thumbprint) {
      $Thumbprint = $cert.Thumbprint
    }
  } catch {
    # Keep fallback thumbprint
  }
}

Write-Host "Certificate to remove machine-wide:" -ForegroundColor White
Write-Host "  Thumbprint: $Thumbprint" -ForegroundColor Gray
Write-Host ""

$stores = @('Root', 'TrustedPublisher')
$removedCount = 0

foreach ($store in $stores) {
  $certPath = "Cert:\LocalMachine\$store\$Thumbprint"
  if (Test-Path $certPath) {
    Write-Step "Removing from Cert:\LocalMachine\$store ..."
    try {
      Remove-Item -Path $certPath -Force
      Write-OK "Removed from Cert:\LocalMachine\$store"
      $removedCount++
    } catch {
      Write-Warn "Could not remove from Cert:\LocalMachine\$store : $($_.Exception.Message)"
    }
  } else {
    Write-Info "Not present in Cert:\LocalMachine\$store"
  }
}

Write-Host ""
if ($removedCount -gt 0) {
  Write-Host "DONE. Machine certificate removed from $removedCount store(s)." -ForegroundColor Green
} else {
  Write-Host "Nothing to clean: certificate was not in LocalMachine trust stores." -ForegroundColor Green
}

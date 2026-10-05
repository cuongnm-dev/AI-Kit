# uninstall-cert-user.ps1
# Remove the ETC AI Platform code-signing certificate from the CURRENT USER's trust stores.
# NO ADMINISTRATOR RIGHTS REQUIRED — this is the removal counterpart of trust-cert-user.ps1.
#
# Usage:
#   pwsh -ExecutionPolicy Bypass -File scripts/uninstall-cert-user.ps1

#Requires -Version 5.1

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

Write-Host "Certificate to remove for user '$env:USERNAME':" -ForegroundColor White
Write-Host "  Thumbprint: $Thumbprint" -ForegroundColor Gray
Write-Host ""

$stores = @('Root', 'TrustedPublisher')
$removedCount = 0

foreach ($store in $stores) {
  $certPath = "Cert:\CurrentUser\$store\$Thumbprint"
  if (Test-Path $certPath) {
    Write-Step "Removing from Cert:\CurrentUser\$store ..."
    try {
      Remove-Item -Path $certPath -Force
      Write-OK "Removed from Cert:\CurrentUser\$store"
      $removedCount++
    } catch {
      Write-Warn "Could not remove from Cert:\CurrentUser\$store : $($_.Exception.Message)"
    }
  } else {
    Write-Info "Not present in Cert:\CurrentUser\$store"
  }
}

Write-Host ""
if ($removedCount -gt 0) {
  Write-Host "DONE. Certificate removed from $removedCount store(s)." -ForegroundColor Green
} else {
  Write-Host "Nothing to clean: certificate was not in current user trust stores." -ForegroundColor Green
}

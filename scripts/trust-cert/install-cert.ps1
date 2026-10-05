# install-cert.ps1
# Import ETC AI Platform public code-signing certificate into the MACHINE-WIDE Windows trust
# stores, for EVERY account on this machine. Run ONCE as Administrator.
#
# PREFER trust-cert-user.ps1 UNLESS YOU SPECIFICALLY WANT MACHINE-WIDE TRUST.
# Administrator rights are NOT needed to trust this certificate — that was verified
# experimentally on 2026-08-20: Windows validates a signature against the CURRENT USER's
# stores too, so importing into Cert:\CurrentUser\Root + Cert:\CurrentUser\TrustedPublisher
# (both writable with no elevation) is sufficient to make a signed build report
# `Status: Valid`. Elevation here buys machine-wide scope ONLY, not the trust itself.
#
# Use this script when: a shared/kiosk machine, or an IT-managed deployment where every
# profile must trust the certificate. Otherwise use the per-user script.
#
# Usage:
#   pwsh -ExecutionPolicy Bypass -File scripts/install-cert.ps1        # machine-wide, admin
#   pwsh -ExecutionPolicy Bypass -File scripts/trust-cert-user.ps1     # this user, no admin
#
# Requires: Administrator privileges (writes to LocalMachine trust stores).

#Requires -Version 5.1
#Requires -RunAsAdministrator

[CmdletBinding()]
param(
  [string] $CertPath = (Join-Path $PSScriptRoot 'etc-codesign.cer')
)

$ErrorActionPreference = 'Stop'

function Write-Step($m) { Write-Host "==> $m" -ForegroundColor Cyan }
function Write-OK($m)   { Write-Host "    OK $m" -ForegroundColor Green }
function Write-Warn($m) { Write-Host "    !! $m" -ForegroundColor Yellow }

# 1. Verify cert file exists
if (-not (Test-Path $CertPath)) {
  Write-Host "ERROR: cert file not found: $CertPath" -ForegroundColor Red
  exit 1
}

$cert = Get-PfxCertificate -FilePath $CertPath
Write-Host "Certificate to import:" -ForegroundColor White
Write-Host "  Subject:    $($cert.Subject)" -ForegroundColor Gray
Write-Host "  Issuer:     $($cert.Issuer)" -ForegroundColor Gray
Write-Host "  Thumbprint: $($cert.Thumbprint)" -ForegroundColor Gray
Write-Host "  NotBefore:  $($cert.NotBefore)" -ForegroundColor Gray
Write-Host "  NotAfter:   $($cert.NotAfter)" -ForegroundColor Gray
Write-Host ""

$confirm = Read-Host "Import this certificate into LocalMachine\TrustedRoot + TrustedPublisher? (y/N)"
if ($confirm -ne 'y') {
  Write-Host "Aborted." -ForegroundColor Yellow
  exit 0
}

# 2. Import into TrustedRoot (so chain validates)
Write-Step "Importing to LocalMachine\Root (TrustedRoot)..."
$null = Import-Certificate -FilePath $CertPath -CertStoreLocation 'Cert:\LocalMachine\Root'
Write-OK "Imported to TrustedRoot"

# 3. Import into TrustedPublisher (so SmartScreen treats as trusted)
Write-Step "Importing to LocalMachine\TrustedPublisher..."
$null = Import-Certificate -FilePath $CertPath -CertStoreLocation 'Cert:\LocalMachine\TrustedPublisher'
Write-OK "Imported to TrustedPublisher"

Write-Host ""
Write-Host "DONE. AI Studio installers signed with ETC certificate will now run" -ForegroundColor Green
Write-Host "without SmartScreen 'Unknown publisher' warnings on this machine." -ForegroundColor Green
Write-Host ""
Write-Host "To verify a signed binary later:" -ForegroundColor White
Write-Host "  Get-AuthenticodeSignature .\AI-Studio-*.exe | Format-List" -ForegroundColor Gray

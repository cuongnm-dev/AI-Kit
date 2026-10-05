# trust-cert-user.ps1
# Trust the ETC AI Platform code-signing certificate for THE CURRENT USER ONLY.
# NO ADMINISTRATOR RIGHTS REQUIRED — this is the per-user counterpart of install-cert.ps1.
#
# Usage:
#   pwsh -ExecutionPolicy Bypass -File scripts/trust-cert-user.ps1
#
# WHY THIS EXISTS (measured 2026-08-20, not assumed):
#   Windows validates a signature against the CURRENT USER's certificate stores as well as the
#   machine stores. Proven experimentally: a self-signed certificate imported into
#   Cert:\CurrentUser\Root + Cert:\CurrentUser\TrustedPublisher ONLY — verified absent from both
#   LocalMachine stores, from a shell where IsInRole(Administrator) was False — produced
#   `Get-AuthenticodeSignature -> Status: Valid, "Signature verified."` on a freshly signed binary.
#   So machine-wide trust (install-cert.ps1, which writes LocalMachine and therefore demands
#   elevation) is ONE option, never a requirement.
#
# WHICH SCRIPT SHOULD A MEMBER RUN?
#   trust-cert-user.ps1 (this file) — no admin, trusts the cert for THIS user account only.
#                                     The right choice on a locked-down or personal machine.
#   install-cert.ps1                — needs admin, trusts it for EVERY account on the machine.
#                                     Use on a shared/kiosk machine, or via IT deployment.
#   Neither is needed to INSTALL or RUN AI Studio: the app installs per-user into
#   %LOCALAPPDATA%\Programs. It does NOT register its CLI on PATH — that HKCU\Environment write
#   was removed on 2026-08-24 because it is a persistence pattern antivirus engines score.
#   Trusting the certificate only removes the "unknown publisher" friction on a SIGNED build.
#
#   IT DOES NOT BIND A THIRD-PARTY ANTIVIRUS. Kaspersky and friends run as a system service with
#   their own verdict and do not consult this user's Windows trust stores. Against a Kaspersky
#   block the exits are an administrator-side allow-list in Kaspersky Security Center keyed on
#   the certificate, or a publicly-chained CA certificate. See docs/runbooks/desktop-release.md.

#Requires -Version 5.1

[CmdletBinding()]
param(
  [string] $CertPath = (Join-Path $PSScriptRoot 'etc-codesign.cer')
)

$ErrorActionPreference = 'Stop'

function Write-Step($m) { Write-Host "==> $m" -ForegroundColor Cyan }
function Write-OK($m)   { Write-Host "    OK $m" -ForegroundColor Green }
function Write-Info($m) { Write-Host "    .. $m" -ForegroundColor Gray }

if (-not (Test-Path $CertPath)) {
  Write-Host "ERROR: cert file not found: $CertPath" -ForegroundColor Red
  exit 1
}

$cert = Get-PfxCertificate -FilePath $CertPath
Write-Host "Certificate to trust for user '$env:USERNAME':" -ForegroundColor White
Write-Host "  Subject:    $($cert.Subject)" -ForegroundColor Gray
Write-Host "  Thumbprint: $($cert.Thumbprint)" -ForegroundColor Gray
Write-Host "  NotAfter:   $($cert.NotAfter)" -ForegroundColor Gray
Write-Host ""
Write-Host "Scope: THIS USER ACCOUNT ONLY. No administrator rights are used." -ForegroundColor Yellow
Write-Host ""

# Idempotent: report and import only what is missing, so re-running is always safe.
function Test-InUserStore([string] $StoreName, [string] $Thumbprint) {
  $store = New-Object System.Security.Cryptography.X509Certificates.X509Store($StoreName, 'CurrentUser')
  $store.Open('ReadOnly')
  try {
    return [bool]($store.Certificates | Where-Object { $_.Thumbprint -eq $Thumbprint })
  }
  finally { $store.Close() }
}

# Root: the certificate is self-signed, so it is its own chain root — without this the chain
# cannot validate. TrustedPublisher: marks the publisher as already-trusted, which is what
# suppresses the "unknown publisher" prompt.
foreach ($storeName in @('Root', 'TrustedPublisher')) {
  if (Test-InUserStore -StoreName $storeName -Thumbprint $cert.Thumbprint) {
    Write-Info "already present in CurrentUser\$storeName"
    continue
  }
  Write-Step "Importing into CurrentUser\$storeName ..."
  $null = Import-Certificate -FilePath $CertPath -CertStoreLocation "Cert:\CurrentUser\$storeName"
  Write-OK "imported into CurrentUser\$storeName"
}

# Verify the OUTCOME rather than trusting that the import reported success.
$missing = @('Root', 'TrustedPublisher') | Where-Object { -not (Test-InUserStore -StoreName $_ -Thumbprint $cert.Thumbprint) }
Write-Host ""
if ($missing.Count -gt 0) {
  Write-Host "FAILED: still absent from: $($missing -join ', ')" -ForegroundColor Red
  exit 1
}

Write-Host "DONE. Signed AI Studio builds are now trusted for this user account." -ForegroundColor Green
Write-Host ""
Write-Host "To verify a signed binary:" -ForegroundColor White
Write-Host "  Get-AuthenticodeSignature '<path-to-exe>' | Format-List Status, StatusMessage" -ForegroundColor Gray
Write-Host "Expect: Status = Valid, and a signer of $($cert.Subject)" -ForegroundColor Gray
Write-Host ""
Write-Host "To undo (also no admin required):" -ForegroundColor White
Write-Host "  Get-ChildItem Cert:\CurrentUser\Root, Cert:\CurrentUser\TrustedPublisher |" -ForegroundColor Gray
Write-Host "    Where-Object Thumbprint -eq '$($cert.Thumbprint)' | Remove-Item" -ForegroundColor Gray

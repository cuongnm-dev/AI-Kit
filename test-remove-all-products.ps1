<#
.SYNOPSIS
    Test the remove-all-products cleanup scripts in a temporary sandbox.
.DESCRIPTION
    Creates dummy ai-kit / ai-studio / ai-engine paths under a temporary root, then validates
    both the Windows PowerShell cleanup script and the Unix shell cleanup script.
#>

Set-StrictMode -Version Latest

$root = Join-Path $env:TEMP "remove-all-products-test-$([guid]::NewGuid().ToString('N'))"
Write-Host "Test root: $root"
New-Item -ItemType Directory -Path $root -Force | Out-Null

function New-TestPath([string]$relativePath) {
    $fullPath = Join-Path $root $relativePath
    $dir = Split-Path $fullPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
    New-Item -ItemType File -Path (Join-Path $fullPath 'dummy.txt') -Force | Out-Null
    return $fullPath
}

$pathsToCreate = @(
    '.ai-kit',
    '.config/opencode/agent',
    '.config/opencode/command',
    '.config/ai-engine',
    '.config/engine',
    '.config/ai-studio',
    '.config/ai-kit',
    '.config/vibe-studio',
    'AppData/Local/Temp/ai-kit-1',
    'AppData/Local/Temp/ai-studio-1',
    'AppData/Roaming/AI Studio',
    'AppData/Roaming/ai-engine',
    'AppData/Roaming/ai-studio'
)

$shellPathsToCreate = @(
    '.ai-kit',
    '.config/opencode/agent',
    '.config/opencode/command',
    '.config/ai-engine',
    '.config/engine',
    '.config/ai-studio',
    '.config/ai-kit',
    '.config/vibe-studio',
    '.local/share/ai-studio',
    '.local/share/ai-kit',
    '.local/share/ai-engine',
    '.local/share/ai-mcp',
    '.cache/ai-studio',
    '.cache/ai-kit',
    '.cache/ai-engine',
    '.cache/ai-mcp'
)

$created = @()
foreach ($rel in $pathsToCreate) {
    $created += New-TestPath $rel
}

$testScriptPath = Join-Path $PSScriptRoot 'remove-all-products.ps1'
if (-not (Test-Path $testScriptPath)) {
    throw "Windows cleanup script not found at $testScriptPath"
}

Write-Host "Running PowerShell dry-run..."
$dryRunOutput = & $testScriptPath -DryRun -Root $root 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "PowerShell dry-run failed with exit code $LASTEXITCODE`n$dryRunOutput"
}

foreach ($path in $created) {
    if (-not (Test-Path $path)) {
        throw "PowerShell dry-run removed a path unexpectedly: $path"
    }
}

Write-Host "PowerShell dry-run passed."

Write-Host "Running PowerShell cleanup..."
$cleanupOutput = & $testScriptPath -Yes -Root $root 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "PowerShell cleanup failed with exit code $LASTEXITCODE`n$cleanupOutput"
}

foreach ($path in $created) {
    if (Test-Path $path) {
        throw "Path was not removed by PowerShell cleanup: $path"
    }
}

Write-Host "PowerShell cleanup passed."

$shellExe = $null
$testBash = Get-Command bash.exe -ErrorAction SilentlyContinue
if ($null -ne $testBash) {
    try {
        & bash.exe --version > $null 2>&1
        if ($LASTEXITCODE -eq 0) { $shellExe = 'bash.exe' }
    } catch {
        # ignore
    }
}
if ($null -eq $shellExe) {
    $testSh = Get-Command sh.exe -ErrorAction SilentlyContinue
    if ($null -ne $testSh) {
        try {
            & sh.exe --version > $null 2>&1
            if ($LASTEXITCODE -eq 0) { $shellExe = 'sh.exe' }
        } catch {
            # ignore
        }
    }
}
if ($null -eq $shellExe) {
    Write-Warning 'No usable bash/sh executable found; skipping shell script test.'
    return
}

Write-Host "Using shell executable: $shellExe"

# Recreate shell test root
Remove-Item -LiteralPath $root -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $root -Force | Out-Null
foreach ($rel in $shellPathsToCreate) {
    New-TestPath $rel | Out-Null
}

$shellScriptPath = Join-Path $PSScriptRoot 'remove-all-products.sh'
if (-not (Test-Path $shellScriptPath)) {
    throw "Shell cleanup script not found at $shellScriptPath"
}

Write-Host "Running shell dry-run..."
$escapedRoot = $root -replace '"', '\\"'
$dryRunShell = & $shellExe $shellScriptPath --dry-run --root "$escapedRoot" 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "Shell dry-run failed with exit code $LASTEXITCODE`n$dryRunShell"
}

foreach ($rel in $shellPathsToCreate) {
    $fullPath = Join-Path $root $rel
    if (-not (Test-Path $fullPath)) {
        throw "Shell dry-run removed a path unexpectedly: $fullPath"
    }
}

Write-Host "Shell dry-run passed."

Write-Host "Running shell cleanup..."
$cleanupShell = & $shellExe $shellScriptPath --yes --root "$escapedRoot" 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "Shell cleanup failed with exit code $LASTEXITCODE`n$cleanupShell"
}

foreach ($rel in $shellPathsToCreate) {
    $fullPath = Join-Path $root $rel
    if (Test-Path $fullPath) {
        throw "Path was not removed by shell cleanup: $fullPath"
    }
}

Write-Host 'Shell cleanup passed.'
Write-Host 'All cleanup script tests passed.' -ForegroundColor Green

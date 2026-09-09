# ship.ps1 - one command to publish a skill change everywhere.
#
# Bumps the plugin patch version, commits, pushes, and refreshes the local
# marketplace and plugin. The version bump is what makes Cowork's Update button
# light up; without it Cowork thinks it is already current.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File ship.ps1
#   powershell -ExecutionPolicy Bypass -File ship.ps1 -m "rewrite the FAQ rules"

param([string]$m = "")

$ErrorActionPreference = 'Continue'
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}
$env:GIT_REDIRECT_STDERR = '2>&1'

$repo     = $PSScriptRoot
$manifest = Join-Path $repo '.claude-plugin\plugin.json'
$market   = Join-Path $repo '.claude-plugin\marketplace.json'
Set-Location $repo

# ---------------------------------------------------------------- what changed
$changed = & git status --porcelain
if (-not $changed) {
    Write-Host "Nothing to ship - working tree is clean."
    exit 0
}

Write-Host "Changed:"
$changed | ForEach-Object { Write-Host ("  " + $_) }

# derive a commit message from the skill folders touched, if none given
if (-not $m) {
    $skills = $changed |
        ForEach-Object { if ($_ -match 'skills/([^/]+)/') { $Matches[1] } } |
        Sort-Object -Unique
    if ($skills) { $m = "Update skills: " + ($skills -join ', ') }
    else { $m = "Update monochrome-skills" }
}

# ---------------------------------------------------------------- bump version
$newVer = $null
try {
    $j = Get-Content $manifest -Raw | ConvertFrom-Json
    $p = $j.version.Split('.')
    $p[2] = [string]([int]$p[2] + 1)
    $newVer = $p -join '.'
    Write-Host ""
    Write-Host ("Version: " + $j.version + " -> " + $newVer)
    $j.version = $newVer
    # UTF8Encoding($false) = no BOM. Set-Content -Encoding utf8 adds one on
    # Windows PowerShell 5.1 and a BOM makes this manifest unparseable.
    [System.IO.File]::WriteAllText($manifest, ($j | ConvertTo-Json -Depth 10), (New-Object System.Text.UTF8Encoding($false)))

    # Cowork reads the plugin's version from marketplace.json, not plugin.json.
    # With no version there it shows 1.0.0 forever and the Update button stays grey.
    $mk = Get-Content $market -Raw | ConvertFrom-Json
    foreach ($pl in $mk.plugins) {
        if ($pl.name -eq $j.name) {
            if ($pl.PSObject.Properties['version']) { $pl.version = $newVer }
            else { $pl | Add-Member -NotePropertyName version -NotePropertyValue $newVer }
        }
    }
    [System.IO.File]::WriteAllText($market, ($mk | ConvertTo-Json -Depth 10), (New-Object System.Text.UTF8Encoding($false)))
} catch {
    Write-Host ("Could not bump version: " + $_)
}

# ---------------------------------------------------------------- ship
Write-Host ""
Write-Host "Committing and pushing..."
& git add -A | Out-Null
& git commit -m $m | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Commit failed. Stopping."; exit 1 }
& git push
if ($LASTEXITCODE -ne 0) { Write-Host "PUSH FAILED - nothing propagated. Fix and re-run."; exit 1 }

# ---------------------------------------------------------------- propagate
Write-Host ""
Write-Host "Refreshing local marketplace and plugin..."
& claude plugin marketplace update monochrome-skills 2>&1 | Out-String | Write-Host
& claude plugin update monochrome@monochrome-skills   2>&1 | Out-String | Write-Host

# ---------------------------------------------------------------- report
Write-Host ""
Write-Host "======================================================"
Write-Host ("Shipped: " + $m)
if ($newVer) { Write-Host ("Plugin version: " + $newVer) }
Write-Host ""
Write-Host "Claude Code:  restart your session."
Write-Host "Cowork:       Customize > Plugins > monochrome-skills > Update, then a NEW chat."
Write-Host "Web chat:     not covered - plugins do not load in Chat."
Write-Host "======================================================"

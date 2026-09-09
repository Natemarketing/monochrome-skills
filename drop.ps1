# drop.ps1 - take the skill files Claude handed you as chat downloads, put them
# in the repo, and ship. One command, nothing to edit.
#
# Naming rule for the download:  <skill-name>.SKILL.md
#   wp-staging-sync.SKILL.md  ->  skills\wp-staging-sync\SKILL.md
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File drop.ps1
#   powershell -ExecutionPolicy Bypass -File drop.ps1 -m "commit message"
#   powershell -ExecutionPolicy Bypass -File drop.ps1 -from "D:\somewhere"
#
# Looks in "<repo>\Claude outputs" (where the Claude desktop app saves chat
# downloads when this folder is connected) and in ~/Downloads.

param([string]$m = "", [string]$from = "")

$ErrorActionPreference = 'Continue'
$repo = $PSScriptRoot
$ship = Join-Path $repo 'ship.ps1'
# only pass -m when there is one; powershell.exe -File chokes on an empty argument
$shipArgs = @{}
if ($m) { $shipArgs['m'] = $m }

# Where to look: the Claude desktop app drops chat downloads into "Claude outputs"
# inside the connected folder (this repo); the browser drops into ~/Downloads.
$places = @()
if ($from) { $places += $from }
else { $places += (Join-Path $repo 'Claude outputs'); $places += "$HOME\Downloads" }

$files = @()
foreach ($p in $places) {
    $files += Get-ChildItem -Path $p -Filter '*.SKILL.md' -File -ErrorAction SilentlyContinue
}
$files = $files | Sort-Object LastWriteTime
if (-not $files) {
    Write-Host ("No *.SKILL.md files in " + ($places -join ' or ') + " - nothing to drop.")
    Write-Host "Running ship.ps1 anyway in case the repo already has changes."
    & $ship @shipArgs
    exit $LASTEXITCODE
}

Write-Host "Dropping:"
foreach ($f in $files) {
    $skill = $f.Name -replace '\.SKILL\.md$', ''
    $skill = $skill -replace '\s\(\d+\)$', ''      # browser duplicate suffix " (1)"
    $skill = $skill.ToLower()
    $dest  = Join-Path $repo ("skills\" + $skill)
    if (-not (Test-Path $dest)) {
        New-Item -ItemType Directory -Path $dest | Out-Null
        Write-Host ("  NEW skill: " + $skill + "  (needs a row in skill-router)")
    }
    Copy-Item $f.FullName (Join-Path $dest 'SKILL.md') -Force
    Remove-Item $f.FullName -Force
    Write-Host ("  " + $f.Name + "  ->  skills\" + $skill + "\SKILL.md")
}

Write-Host ""
& $ship @shipArgs
exit $LASTEXITCODE

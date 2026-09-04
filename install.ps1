# Installs every skill in this repo into the personal Claude skills directory.
#
# Writes to ~/.claude/skills/<name>/ and never to ~/.claude/skills/synced/, which is
# managed by the claude.ai sync and gets overwritten.
#
# Usage: powershell -ExecutionPolicy Bypass -File install.ps1

$ErrorActionPreference = 'Stop'

$repoSkills = Join-Path $PSScriptRoot 'skills'
$target     = Join-Path $HOME '.claude\skills'

if (-not (Test-Path $repoSkills)) {
    throw "No skills directory found at $repoSkills"
}

if (-not (Test-Path $target)) {
    New-Item -ItemType Directory -Path $target -Force | Out-Null
}

$installed = 0
foreach ($skill in Get-ChildItem -Path $repoSkills -Directory) {
    $dest = Join-Path $target $skill.Name

    if (Test-Path $dest) {
        Remove-Item -Path $dest -Recurse -Force
    }

    Copy-Item -Path $skill.FullName -Destination $dest -Recurse
    $fileCount = (Get-ChildItem -Path $dest -Recurse -File).Count
    Write-Host ("  {0,-24} {1} file(s)" -f $skill.Name, $fileCount)
    $installed++
}

Write-Host ""
Write-Host "Installed $installed skill(s) into $target"
Write-Host "Restart Claude Code (or start a new session) to pick them up."

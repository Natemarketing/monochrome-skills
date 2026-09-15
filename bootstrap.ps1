# bootstrap.ps1 - install Nate's full Claude skill stack on a Windows machine.
# No repo clone needed; the marketplace route pulls everything.
#
# Prereq: git can read the private repo here. Run `gh auth login` first if not.
#
# Usage: powershell -ExecutionPolicy Bypass -File bootstrap.ps1

$ErrorActionPreference = 'Continue'
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}
$repo = 'https://github.com/Natemarketing/monochrome-skills.git'

function Say([string]$m) { Write-Host ""; Write-Host ("=== " + $m) }
function Run([string]$exe, [string[]]$argv) {
    Write-Host ("> " + $exe + " " + ($argv -join ' '))
    try { & $exe @argv 2>&1 | Out-String | Write-Host } catch { Write-Host "   (failed, continuing)" }
}

Say "preflight"
foreach ($t in 'claude','git','gh') {
    $c = Get-Command $t -ErrorAction SilentlyContinue
    if ($c) { Write-Host ("  {0,-8} OK" -f $t) } else { Write-Host ("  {0,-8} MISSING" -f $t) }
}

Say "house skills (private)"
Run 'claude' @('plugin','marketplace','add',$repo)
Run 'claude' @('plugin','install','monochrome@monochrome-skills')

Say "claude-seo (public)"
Run 'claude' @('plugin','marketplace','add','AgriciDaniel/claude-seo')
Run 'claude' @('plugin','install','claude-seo@agricidaniel-claude-seo')

Say "result"
Run 'claude' @('plugin','list')

Write-Host ""
Write-Host "Done on the CLI. Cowork must be done by hand: Customize > Plugins > + >"
Write-Host "Add marketplace, paste the repo URL, Connect GitHub, Sync. Then the same"
Write-Host "for AgriciDaniel/claude-seo. Web chat never loads plugins."

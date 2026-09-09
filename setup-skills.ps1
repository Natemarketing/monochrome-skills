# setup-skills.ps1 - Phase 2
#
# Run AFTER the private repo Natemarketing/monochrome-skills exists on GitHub.
#
# 1. Points this repo at that remote and pushes.
# 2. Registers it as a marketplace over HTTPS (not SSH) and installs the
#    `monochrome` plugin. Falls back to install.ps1 if the plugin route fails.
# 3. Installs claude-seo from its marketplace.
# 4. Copies the hand-picked third-party skills into ~/.claude/skills.
#
# Safe to re-run. Logs to setup-log-2.txt.
#
# Usage: powershell -ExecutionPolicy Bypass -File setup-skills.ps1

$ErrorActionPreference = 'Continue'
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}
$env:GIT_REDIRECT_STDERR = '2>&1'

$repo      = $PSScriptRoot
$log       = Join-Path $repo 'setup-log-2.txt'
$srcRoot   = Join-Path $env:TEMP 'mm-skills-src'
$skillsDir = Join-Path $HOME '.claude\skills'
$remote    = 'https://github.com/Natemarketing/monochrome-skills.git'

function Say([string]$m) { Write-Host $m; Add-Content -Path $log -Value $m -Encoding utf8 }
function Run([string]$label, [string]$exe, [string[]]$argv) {
    Say ""
    Say "--- $label"
    Say "> $exe $($argv -join ' ')"
    try {
        $out = & $exe @argv 2>&1 | Out-String
        Say $out.TrimEnd()
        Say "exit=$LASTEXITCODE"
    } catch { Say "FAILED: $_" }
}

Set-Content -Path $log -Value "phase 2 - $(Get-Date -Format s)" -Encoding utf8
New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null
New-Item -ItemType Directory -Path $srcRoot   -Force | Out-Null

# ---------------------------------------------------------------- push
Say ""
Say "=========== PUSH ==========="
Push-Location $repo
Run 'stage'  'git' @('add','-A')
Run 'commit' 'git' @('commit','-m','Phase 2 setup script')

if ((& git remote 2>$null) -contains 'origin') {
    Run 'set-url' 'git' @('remote','set-url','origin',$remote)
} else {
    Run 'add remote' 'git' @('remote','add','origin',$remote)
}
Say "(a browser window may open once for GitHub sign-in - that is Git Credential Manager)"
Run 'push' 'git' @('push','-u','origin','main')

# ---------------------------------------------------------------- own marketplace
Say ""
Say "=========== OWN MARKETPLACE ==========="
Run 'remove stale' 'claude' @('plugin','marketplace','remove','monochrome-skills')
Run 'add (https)'  'claude' @('plugin','marketplace','add',$remote)
Run 'install'      'claude' @('plugin','install','monochrome@monochrome-skills')
Run 'plugin list'  'claude' @('plugin','list')

# ---------------------------------------------------------------- claude-seo
Say ""
Say "=========== CLAUDE-SEO ==========="
Run 'install claude-seo' 'claude' @('plugin','install','claude-seo@agricidaniel-claude-seo')

# ---------------------------------------------------------------- extra source
Say ""
Say "=========== ANTHROPIC SKILLS SOURCE ==========="
$anth = Join-Path $srcRoot 'anthropics'
if (Test-Path $anth) { Run 'pull anthropics' 'git' @('-C',$anth,'pull','--ff-only') }
else { Run 'clone anthropics' 'git' @('clone','--depth','1','https://github.com/anthropics/skills.git',$anth) }

# ---------------------------------------------------------------- copy picks
Say ""
Say "=========== COPY PICKED SKILLS ==========="

# name = folder name it will get in ~/.claude/skills
# from = source repo folder under $srcRoot
# path = relative path inside that repo, or '' to search by folder name
$picks = @(
    @{ name='grill-me';            from='mattpocock';      path='skills\productivity\grill-me' },
    @{ name='handoff';             from='mattpocock';      path='skills\productivity\handoff' },
    @{ name='caveman';             from='caveman';         path='plugins\caveman\skills\caveman' },
    @{ name='caveman-compress';    from='caveman';         path='plugins\caveman\skills\caveman-compress' },
    @{ name='caveman-stats';       from='caveman';         path='plugins\caveman\skills\caveman-stats' },
    @{ name='cavecrew';            from='caveman';         path='plugins\caveman\skills\cavecrew' },
    @{ name='content-strategy';    from='marketingskills'; path='skills\content-strategy' },
    @{ name='marketing-psychology';from='marketingskills'; path='skills\marketing-psychology' },
    @{ name='customer-research';   from='marketingskills'; path='skills\customer-research' },
    @{ name='offers';              from='marketingskills'; path='skills\offers' },
    @{ name='site-architecture';   from='marketingskills'; path='skills\site-architecture' },
    @{ name='webapp-testing';      from='anthropics';      path='' }
)

$copied = 0; $missed = @()
foreach ($p in $picks) {
    $srcRepo = Join-Path $srcRoot $p.from
    $src = $null

    if ($p.path -and (Test-Path (Join-Path $srcRepo $p.path))) {
        $src = Join-Path $srcRepo $p.path
    } else {
        # fall back to searching the repo for a folder of that name holding a SKILL.md
        $hit = Get-ChildItem -Path $srcRepo -Recurse -Directory -Filter $p.name -ErrorAction SilentlyContinue |
               Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') } |
               Select-Object -First 1
        if ($hit) { $src = $hit.FullName }
    }

    if (-not $src) { $missed += $p.name; Say ("  MISS  " + $p.name); continue }

    $dest = Join-Path $skillsDir $p.name
    if (Test-Path $dest) { Remove-Item -Path $dest -Recurse -Force }
    Copy-Item -Path $src -Destination $dest -Recurse
    Remove-Item -Path (Join-Path $dest '.git') -Recurse -Force -ErrorAction SilentlyContinue
    $n = (Get-ChildItem -Path $dest -Recurse -File).Count
    Say ("  OK    {0,-22} {1} file(s)   <- {2}" -f $p.name, $n, $src.Substring($srcRoot.Length + 1))
    $copied++
}
Say ""
Say "copied $copied of $($picks.Count)"
if ($missed.Count) { Say ("missed: " + ($missed -join ', ')) }

# ---------------------------------------------------------------- fallback
Say ""
Say "=========== HOUSE SKILLS CHECK ==========="
$pluginOk = $false
try {
    $pl = & claude plugin list 2>&1 | Out-String
    if ($pl -match 'monochrome') { $pluginOk = $true }
} catch {}

if ($pluginOk) {
    Say "monochrome plugin installed - house skills come from the plugin, not copied"
} else {
    Say "monochrome plugin NOT installed - falling back to install.ps1 (direct copy)"
    Run 'install.ps1' 'powershell' @('-ExecutionPolicy','Bypass','-File',(Join-Path $repo 'install.ps1'))
}

# ---------------------------------------------------------------- final state
Say ""
Say "=========== FINAL ~/.claude/skills ==========="
Get-ChildItem -Path $skillsDir -Directory | ForEach-Object { Say ("  " + $_.Name) }

Pop-Location
Say ""
Say "=========== DONE - phase 2 ==========="
Say "Log: $log"

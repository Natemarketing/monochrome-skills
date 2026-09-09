# setup-sync.ps1 - Phase 1
#
# Turns this repo into a PRIVATE Claude plugin marketplace and wires it into
# Claude Code. Also clones the third-party skill sources and inventories them
# so phase 2 can copy only the folders we actually want.
#
# Safe to re-run. Nothing is deleted. Every step is logged to setup-log.txt.
#
# Usage:  powershell -ExecutionPolicy Bypass -File setup-sync.ps1

$ErrorActionPreference = 'Continue'
$repo    = $PSScriptRoot
$log     = Join-Path $repo 'setup-log.txt'
$srcRoot = Join-Path $env:TEMP 'mm-skills-src'

function Say([string]$m) {
    $line = $m
    Write-Host $line
    Add-Content -Path $log -Value $line -Encoding utf8
}
function Run([string]$label, [string]$exe, [string[]]$argv) {
    Say ""
    Say "--- $label"
    Say "> $exe $($argv -join ' ')"
    try {
        $out = & $exe @argv 2>&1 | Out-String
        Say $out.TrimEnd()
        Say "exit=$LASTEXITCODE"
    } catch {
        Say "FAILED: $_"
    }
}

Set-Content -Path $log -Value "monochrome-skills setup - $(Get-Date -Format s)" -Encoding utf8
Say "repo: $repo"

# ---------------------------------------------------------------- preflight
Say ""
Say "=========== PREFLIGHT ==========="
foreach ($t in 'git','gh','claude','node','npm') {
    $c = Get-Command $t -ErrorAction SilentlyContinue
    if ($c) {
        $v = (& $t --version 2>&1 | Select-Object -First 1) -join ' '
        Say ("  {0,-8} OK   {1}" -f $t, $v)
    } else {
        Say ("  {0,-8} MISSING" -f $t)
    }
}

# ---------------------------------------------------------------- git state
Say ""
Say "=========== GIT ==========="
Push-Location $repo
Run 'branch'  'git' @('rev-parse','--abbrev-ref','HEAD')
Run 'remotes' 'git' @('remote','-v')
Run 'status'  'git' @('status','--short')
Run 'stage'   'git' @('add','-A')
Run 'commit'  'git' @('commit','-m','Add plugin marketplace manifests and setup scripts')

# ---------------------------------------------------------------- gh + push
Say ""
Say "=========== GITHUB ==========="
Run 'auth status' 'gh' @('auth','status')

$hasOrigin = (& git remote 2>$null) -contains 'origin'
if ($hasOrigin) {
    Say "origin already configured - pushing"
    Run 'push' 'git' @('push','-u','origin','HEAD')
} else {
    Say "no origin - creating PRIVATE repo Natemarketing/monochrome-skills"
    Run 'repo create' 'gh' @(
        'repo','create','Natemarketing/monochrome-skills',
        '--private','--source=.','--remote=origin','--push',
        '--description','Private canonical source for Nate''s Claude skills'
    )
}

# credential helper so background auto-update can pull a private repo
Run 'setup-git' 'gh' @('auth','setup-git')

Run 'verify visibility' 'gh' @('repo','view','Natemarketing/monochrome-skills','--json','name,visibility,url')

# ---------------------------------------------------------------- marketplace
Say ""
Say "=========== OWN MARKETPLACE ==========="
Run 'marketplace add'    'claude' @('plugin','marketplace','add','Natemarketing/monochrome-skills')
Run 'install monochrome' 'claude' @('plugin','install','monochrome@monochrome-skills')

# ---------------------------------------------------------------- 3rd party marketplaces
Say ""
Say "=========== THIRD-PARTY MARKETPLACES ==========="
Run 'add claude-seo' 'claude' @('plugin','marketplace','add','AgriciDaniel/claude-seo')
Run 'add official'   'claude' @('plugin','marketplace','add','anthropics/claude-plugins-official')

Run 'marketplace list' 'claude' @('plugin','marketplace','list')

# dump every marketplace manifest Claude Code knows about, so phase 2 can use
# the real marketplace/plugin identifiers instead of guessing them
Say ""
Say "--- discovered marketplace manifests"
$pluginRoot = Join-Path $HOME '.claude\plugins'
if (Test-Path $pluginRoot) {
    Get-ChildItem -Path $pluginRoot -Recurse -Filter 'marketplace.json' -ErrorAction SilentlyContinue |
        Select-Object -First 20 | ForEach-Object {
            Say ""
            Say "### $($_.FullName)"
            try {
                $j = Get-Content $_.FullName -Raw | ConvertFrom-Json
                Say ("marketplace: " + $j.name)
                foreach ($p in $j.plugins) { Say ("  plugin: " + $p.name) }
            } catch { Say "  (unparseable)" }
        }
} else {
    Say "no $pluginRoot yet"
}

# ---------------------------------------------------------------- clone sources
Say ""
Say "=========== CLONE THIRD-PARTY SOURCES ==========="
New-Item -ItemType Directory -Path $srcRoot -Force | Out-Null

$sources = @(
    @{ name='mattpocock';     url='https://github.com/mattpocock/skills.git' },
    @{ name='caveman';        url='https://github.com/JuliusBrussee/caveman.git' },
    @{ name='marketingskills';url='https://github.com/coreyhaines31/marketingskills.git' }
)
foreach ($s in $sources) {
    $dest = Join-Path $srcRoot $s.name
    if (Test-Path $dest) {
        Run "pull $($s.name)" 'git' @('-C',$dest,'pull','--ff-only')
    } else {
        Run "clone $($s.name)" 'git' @('clone','--depth','1',$s.url,$dest)
    }
}

Say ""
Say "--- skill folders found in each source (name + SKILL.md path)"
foreach ($s in $sources) {
    $dest = Join-Path $srcRoot $s.name
    Say ""
    Say "### $($s.name)  ($dest)"
    if (Test-Path $dest) {
        Get-ChildItem -Path $dest -Recurse -Filter 'SKILL.md' -ErrorAction SilentlyContinue |
            ForEach-Object { Say ("  " + $_.FullName.Substring($dest.Length + 1)) }
    } else {
        Say "  (clone failed)"
    }
}

# ---------------------------------------------------------------- current state
Say ""
Say "=========== CURRENT SKILLS DIR ==========="
$skillsDir = Join-Path $HOME '.claude\skills'
if (Test-Path $skillsDir) {
    Get-ChildItem -Path $skillsDir -Directory | ForEach-Object { Say ("  " + $_.Name) }
} else {
    Say "  (none)"
}

Pop-Location
Say ""
Say "=========== DONE - phase 1 ==========="
Say "Log written to $log"

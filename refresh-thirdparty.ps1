# refresh-thirdparty.ps1
#
# Vendors the hand-picked third-party skills INTO this repo so every machine
# gets the identical set from one `git pull` / marketplace update.
#
# Also removes the loose copies from ~/.claude/skills, because a personal skill
# shadows the plugin's copy of the same name and you end up maintaining two.
#
# Re-run this whenever you want to pull upstream fixes. That is the ONLY time
# these skills change - vendoring means they are otherwise frozen, which is the
# point.
#
# Usage: powershell -ExecutionPolicy Bypass -File refresh-thirdparty.ps1

$ErrorActionPreference = 'Continue'
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}
$env:GIT_REDIRECT_STDERR = '2>&1'

$repo      = $PSScriptRoot
$log       = Join-Path $repo 'refresh-log.txt'
$srcRoot   = Join-Path $env:TEMP 'mm-skills-src'
$repoSkills= Join-Path $repo 'skills'
$skillsDir = Join-Path $HOME '.claude\skills'

function Say([string]$m) { Write-Host $m; Add-Content -Path $log -Value $m -Encoding utf8 }
function Run([string]$label, [string]$exe, [string[]]$argv) {
    Say ""; Say "--- $label"; Say "> $exe $($argv -join ' ')"
    try { $out = & $exe @argv 2>&1 | Out-String; Say $out.TrimEnd(); Say "exit=$LASTEXITCODE" }
    catch { Say "FAILED: $_" }
}

Set-Content -Path $log -Value "refresh third-party - $(Get-Date -Format s)" -Encoding utf8
New-Item -ItemType Directory -Path $srcRoot -Force | Out-Null

# ---------------------------------------------------------------- sources
Say ""
Say "=========== SOURCES ==========="
$sources = @(
    @{ name='mattpocock';      url='https://github.com/mattpocock/skills.git' },
    @{ name='caveman';         url='https://github.com/JuliusBrussee/caveman.git' },
    @{ name='marketingskills'; url='https://github.com/coreyhaines31/marketingskills.git' },
    @{ name='anthropics';      url='https://github.com/anthropics/skills.git' }
)
foreach ($s in $sources) {
    $dest = Join-Path $srcRoot $s.name
    if (Test-Path $dest) { Run "pull $($s.name)" 'git' @('-C',$dest,'pull','--ff-only') }
    else { Run "clone $($s.name)" 'git' @('clone','--depth','1',$s.url,$dest) }
}

# ---------------------------------------------------------------- vendor
Say ""
Say "=========== VENDOR INTO repo\skills ==========="

$picks = @(
    @{ name='grill-me';             from='mattpocock';      path='skills\productivity\grill-me' },
    @{ name='grilling';             from='mattpocock';      path='skills\productivity\grilling' },
    @{ name='handoff';              from='mattpocock';      path='skills\productivity\handoff' },
    @{ name='caveman';              from='caveman';         path='plugins\caveman\skills\caveman' },
    @{ name='caveman-compress';     from='caveman';         path='plugins\caveman\skills\caveman-compress' },
    @{ name='caveman-stats';        from='caveman';         path='plugins\caveman\skills\caveman-stats' },
    @{ name='cavecrew';             from='caveman';         path='plugins\caveman\skills\cavecrew' },
    @{ name='content-strategy';     from='marketingskills'; path='skills\content-strategy' },
    @{ name='marketing-psychology'; from='marketingskills'; path='skills\marketing-psychology' },
    @{ name='customer-research';    from='marketingskills'; path='skills\customer-research' },
    @{ name='offers';               from='marketingskills'; path='skills\offers' },
    @{ name='site-architecture';    from='marketingskills'; path='skills\site-architecture' },
    @{ name='webapp-testing';       from='anthropics';      path='' }
)

$vendored = 0; $missed = @()
foreach ($p in $picks) {
    $srcRepo = Join-Path $srcRoot $p.from
    $src = $null
    if ($p.path -and (Test-Path (Join-Path $srcRepo $p.path))) { $src = Join-Path $srcRepo $p.path }
    else {
        $hit = Get-ChildItem -Path $srcRepo -Recurse -Directory -Filter $p.name -ErrorAction SilentlyContinue |
               Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') } | Select-Object -First 1
        if ($hit) { $src = $hit.FullName }
    }
    if (-not $src) { $missed += $p.name; Say ("  MISS  " + $p.name); continue }

    $dest = Join-Path $repoSkills $p.name
    if (Test-Path $dest) { Remove-Item -Path $dest -Recurse -Force }
    Copy-Item -Path $src -Destination $dest -Recurse
    Remove-Item -Path (Join-Path $dest '.git') -Recurse -Force -ErrorAction SilentlyContinue
    Say ("  OK    " + $p.name)
    $vendored++
}
Say ""
Say "vendored $vendored of $($picks.Count)"
if ($missed.Count) { Say ("missed: " + ($missed -join ', ')) }

# ---------------------------------------------------------------- de-dupe
Say ""
Say "=========== REMOVE LOOSE COPIES FROM ~/.claude/skills ==========="
Say "(the plugin now provides these - a personal copy would shadow it)"
foreach ($p in $picks) {
    $loose = Join-Path $skillsDir $p.name
    if (Test-Path $loose) { Remove-Item -Path $loose -Recurse -Force; Say ("  removed  " + $p.name) }
}

# ---------------------------------------------------------------- version bump
Say ""
Say "=========== BUMP PLUGIN VERSION ==========="
$manifest = Join-Path $repo '.claude-plugin\plugin.json'
try {
    $j = Get-Content $manifest -Raw | ConvertFrom-Json
    $parts = $j.version.Split('.')
    $parts[2] = [string]([int]$parts[2] + 1)
    $newVer = $parts -join '.'
    Say ("  " + $j.version + " -> " + $newVer)
    $j.version = $newVer
    $j | ConvertTo-Json -Depth 10 | Set-Content -Path $manifest -Encoding utf8
} catch { Say ("  FAILED to bump: " + $_) }

# ---------------------------------------------------------------- ship
Say ""
Say "=========== COMMIT AND PUSH ==========="
Push-Location $repo
Run 'stage'  'git' @('add','-A')
Run 'commit' 'git' @('commit','-m','Vendor third-party skills into the plugin')
Run 'push'   'git' @('push')
Pop-Location

Say ""
Say "=========== UPDATE LOCAL PLUGIN ==========="
Run 'marketplace update' 'claude' @('plugin','marketplace','update','monochrome-skills')
Run 'plugin update'      'claude' @('plugin','update','monochrome@monochrome-skills')
Run 'plugin list'        'claude' @('plugin','list')

Say ""
Say "=========== FINAL repo\skills ==========="
Get-ChildItem -Path $repoSkills -Directory | ForEach-Object { Say ("  " + $_.Name) }
Say ""
Say "=========== FINAL ~/.claude/skills ==========="
if (Test-Path $skillsDir) { Get-ChildItem -Path $skillsDir -Directory | ForEach-Object { Say ("  " + $_.Name) } }

Say ""
Say "=========== DONE ==========="
Say "In Cowork: Customize > Plugins > monochrome-skills > Update"
Say "Log: $log"

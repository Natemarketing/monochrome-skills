#!/usr/bin/env bash
# bootstrap.sh - install Nate's full Claude skill stack on any machine with the
# claude CLI. No repo clone needed; the marketplace route pulls everything.
#
# Prereq: git can read the private repo on this machine. Either
#   gh auth login          (device-code flow works headless)
# or a read-only deploy key for Natemarketing/monochrome-skills in ~/.ssh.
#
# Usage: bash bootstrap.sh

set -u
REPO="https://github.com/Natemarketing/monochrome-skills.git"

say() { printf '\n=== %s\n' "$1"; }
run() { printf '> %s\n' "$*"; "$@" || printf '   (failed, continuing)\n'; }

say "preflight"
command -v claude >/dev/null && echo "  claude  OK  $(claude --version 2>&1 | head -1)" || { echo "  claude  MISSING - stop here"; exit 1; }
command -v git    >/dev/null && echo "  git     OK  $(git --version)" || echo "  git     MISSING"
command -v gh     >/dev/null && echo "  gh      OK" || echo "  gh      missing (fine if you use a deploy key)"

say "house skills (private)"
run claude plugin marketplace add "$REPO"
run claude plugin install monochrome@monochrome-skills

say "claude-seo (public)"
run claude plugin marketplace add AgriciDaniel/claude-seo
run claude plugin install claude-seo@agricidaniel-claude-seo

say "result"
claude plugin list

cat <<'NOTE'

Done on the CLI. Two things this cannot do for you:

  1. Cowork. There is no CLI or API for it. Customize > Plugins > + >
     Add marketplace, paste the repo URL, Connect GitHub, Sync. Then the
     same again for AgriciDaniel/claude-seo (public, no auth needed).

  2. Web chat. Plugins never load there. Account skills only.

NOTE

# monochrome-skills

Canonical source for the Claude skills Nate uses across machines.

This repo exists because the copies that ship down from claude.ai live in
`~/.claude/skills/synced/<org>_<user>/`, that folder is managed by the sync and gets
overwritten, and there is no way to tell from the machine you are sitting at whether the
copy in front of you is the newest one. On 2026-09-04 the local `cams-way` was twelve days
behind: three of its files were the pre-expansion versions and a fourth,
`references/cam-council.md`, was missing outright. That is the failure this repo prevents.

## What's in here

| Skill | What it's for |
| --- | --- |
| `cams-way` | How Cam thinks, talks and grades work. Load before anything he will see. |
| `nate-knows` | Calibrates answers to Nate's actual knowledge depth. |
| `stop-slop` | Writing quality enforcement for any prose a human will read. |
| `the-council` | Five-perspective adversarial review before high-stakes work ships. |
| `superpowers-lite` | Brainstorm-first planning, checkpoints, root-cause debugging. |
| `uiux-pro` | Design reasoning for anything rendered in a browser. |
| `brain-keeper` | Token-efficient memory discipline for the project brain. |
| `monochrome-doc-format` | Monochrome's Google Docs house format. |
| `wp-dev-engine` | House method for WordPress / Webflow / Shopify and technical SEO. |
| `wp-staging-sync` | Moving content between staging and live, either direction. |
| `reddit-reply` | Drafting Reddit comments and posts for clients and karma accounts. |

## Setting up a new machine

```bash
git clone https://github.com/Natemarketing/monochrome-skills.git
cd monochrome-skills
powershell -ExecutionPolicy Bypass -File install.ps1
```

`install.ps1` copies each skill into `~/.claude/skills/`, which is the personal skills
directory Claude Code reads. It deliberately does **not** write into
`~/.claude/skills/synced/` — that path belongs to the claude.ai sync and anything put there
is liable to be overwritten without warning.

## The workflow

Skills get edited in one of two places, and the rule is the same either way: **the change is
not real until it is committed here.**

1. **Edited on claude.ai** (Settings, Customize, Skills). Open the skill, use the
   `...` menu, choose Download. That produces a `<name>.skill` file, which is a plain zip.
   Unzip it over `skills/<name>/` in this repo and commit.
2. **Edited in this repo.** Commit, push, then re-upload to claude.ai if the web version
   needs to match.

On any other machine, `git pull` and re-run `install.ps1`.

## Keeping honest about staleness

Each skill on claude.ai shows a last-updated date in the Skills list. If a date there is
newer than the last commit that touched that skill here, this repo is behind. Checking
takes ten seconds and is worth doing before leaning on a voice skill for client work.

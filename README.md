# monochrome-skills

Canonical source for the Claude skills Nate uses across machines, instances and surfaces.

This repo exists because the copies that ship down from claude.ai live in
`~/.claude/skills/synced/<org>_<user>/`, that folder is managed by the sync and gets
overwritten, and there is no way to tell from the machine you are sitting at whether the
copy in front of you is the newest one. On 2026-09-04 the local `cams-way` was twelve days
behind: three of its files were the pre-expansion versions and a fourth,
`references/cam-council.md`, was missing outright. That is the failure this repo prevents.

The repo is private and doubles as a Claude **plugin marketplace**, which is the only
transport that reaches Claude Code and Cowork from the same git source.

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

All eleven ship as one plugin, `monochrome`, defined by `.claude-plugin/plugin.json`.
`.claude-plugin/marketplace.json` makes the repo root its own marketplace.

## Setting up a new machine

```powershell
git clone https://github.com/Natemarketing/monochrome-skills.git
cd monochrome-skills
powershell -ExecutionPolicy Bypass -File setup-sync.ps1
```

That registers the marketplace and installs the plugin. On a machine that already has it,
`claude plugin marketplace update monochrome-skills` is enough.

`install.ps1` is still here as the fallback: it copies each skill folder into
`~/.claude/skills/` directly, no marketplace involved. Use it only if the plugin route is
unavailable. It deliberately does **not** write into `~/.claude/skills/synced/` - that path
belongs to the claude.ai sync and anything put there is liable to be overwritten.

## The three surfaces, and what reaches each

| Surface | Reads from | How it updates |
| --- | --- | --- |
| Claude Code CLI, Desktop Code tab | `~/.claude/plugins` | `claude plugin marketplace update`, or auto-update |
| Cowork, Desktop Chat | account plugins and skills | add this marketplace under Customize > Plugins |
| claude.ai chat | account skills | zip upload, manual |

Auto-update against a private repo needs a credential helper, which `setup-sync.ps1`
configures via `gh auth setup-git`. Without it the background pull fails silently and the
plugin quietly stops updating.

## The workflow

Skills get edited in one of two places, and the rule is the same either way: **the change is
not real until it is committed here.**

1. **Edited in this repo.** Commit, push. Every machine picks it up on the next
   marketplace update.
2. **Edited on claude.ai** (Settings, Customize, Skills). Open the skill, use the `...`
   menu, choose Download. That produces a `<name>.skill` file, which is a plain zip. Unzip
   it over `skills/<name>/` here and commit.

Bump `version` in `.claude-plugin/plugin.json` when you want other machines to be certain
they pull the change.

## Keeping honest about staleness

Each skill on claude.ai shows a last-updated date in the Skills list. If a date there is
newer than the last commit that touched that skill here, this repo is behind. Checking
takes ten seconds and is worth doing before leaning on a voice skill for client work.

## Third-party skills

Third-party skills are **not** vendored into this repo. They are installed from their own
upstream marketplaces so they keep getting their authors' updates, and so this repo stays
purely the house source. `setup-sync.ps1` registers them; `THIRD-PARTY.md` records which
ones and why.

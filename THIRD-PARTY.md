# Third-party skills vendored into this plugin

These are not written by Nate. They are copied in from public repos so that every
machine gets the identical set from one marketplace update, which is the whole
point of this repo. Vendoring freezes them: they do not change until
`refresh-thirdparty.ps1` is run.

| Skill | Upstream | Why it's here |
| --- | --- | --- |
| `grill-me` | [mattpocock/skills](https://github.com/mattpocock/skills) | Pressure-tests a plan before building |
| `handoff` | [mattpocock/skills](https://github.com/mattpocock/skills) | Session-to-session brief |
| `caveman` | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) | Terse output mode for long mechanical runs |
| `caveman-compress` | same | Compression pass |
| `caveman-stats` | same | Token accounting |
| `cavecrew` | same | Multi-agent variant |
| `content-strategy` | [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills) | ICP to outline chain |
| `marketing-psychology` | same | Buyer psychology |
| `customer-research` | same | ICP work |
| `offers` | same | Value framing - Cam's CEOV / 5x multiplier territory |
| `site-architecture` | same | Internal linking and IA |
| `webapp-testing` | [anthropics/skills](https://github.com/anthropics/skills) | Playwright checks against a page |

## Deliberately not taken

From marketingskills: `copywriting`, `copy-editing`, `cro`, `schema`, `seo-audit`,
`ai-seo`, `programmatic-seo`, `marketing-council`. Each collides with `stop-slop`,
`uiux-pro`, `wp-dev-engine`, `claude-seo` or `the-council`. A colliding skill is
worse than no skill - two skills firing on the same trigger produce mush.

From caveman: the other 17. Only the author's own 4-skill plugin bundle is taken.

From mattpocock: everything except the two above. `tdd`, `code-review` and
`implement` collide with `wp-dev-engine` and `the-council`.

## Refreshing

```powershell
powershell -ExecutionPolicy Bypass -File refresh-thirdparty.ps1
```

Re-clones each upstream, re-copies the twelve, strips the loose copies out of
`~/.claude/skills` so they cannot shadow the plugin, commits, pushes, and updates
the local plugin. Then hit **Update** on the marketplace in Cowork.

Bump `version` in `.claude-plugin/plugin.json` when other machines must be certain
to pull.

## Not vendored

`claude-seo` (25 sub-skills) stays a separate plugin from
`AgriciDaniel/claude-seo`. It is actively maintained and large; freezing it would
cost more than it saves. On a new machine:

```powershell
claude plugin marketplace add AgriciDaniel/claude-seo
claude plugin install claude-seo@agricidaniel-claude-seo
```

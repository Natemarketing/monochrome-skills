---
name: skill-router
description: Use at the start of EVERY request. Opens the reply with Nate's stack block (which Claude surface, which other apps need to be connected, and a total token estimate with its CAD cost), then decides which of his skills to load in one pass. It is a lookup, not an investigation - never search, read files, or spawn agents to decide. Load at most three skills, say which in one line, then start.
---

# Skill Router

There are ~25 skills installed. Loading all of them wastes context; loading none
produces generic work. This routes in a single pass with no tool calls.

## The rule

1. Read the request once. Match it against the table below.
2. Load **at most 3** skills. If more match, keep the most specific and drop the rest.
3. Say which ones in one line: `Loading: wp-dev-engine, cams-way.` Then start working.
4. If nothing matches, load nothing and answer. That is a valid outcome.

**Never spend a tool call deciding.** No searching, no reading the skill files to
check, no subagent. If the match is not obvious from the request text in one pass,
it is not a match.

## The stack block

Every reply to a new request opens with this block, before anything else. Three
lines, no preamble, decided in the same single pass as the skills.

```
**Stack:** Cowork + Claude in Chrome (Monochrome profile)
**Apps:** Teamwork, Gmail, Mailchimp (via Chrome)
**Est. cost:** ~400k-800k tokens, ~$0.80-$1.60 CAD (Chrome build, ~40 browser steps)
```

**Stack** is the Claude surface that does the job best: Chat, Cowork, Claude Code,
Claude in Chrome, or Claude Design. Nate's learned routing wins over a generic
pick:

- Divi work: Claude Code in the terminal, not Cowork driving Chrome.
- Fireflies meeting data: Claude in Chrome.
- Mailchimp, Semrush, wp-admin clicks, anything with no connector: Claude in
  Chrome on the Monochrome profile.

**Apps** lists every app outside Claude the task touches, and how Claude reaches it:

- By connector: Teamwork, Gmail, Google Drive / Docs, Google Calendar, Slack,
  Fireflies, Reputation Engine.
- By Chrome: Mailchimp, Semrush (read-only), wp-admin, Webflow, Shopify, GSC,
  GA4, Reddit, and Fireflies when its API is rate-limited.
- By Claude Code: local repos, WordPress REST scripts, Render deploys.

If a task needs an app that is neither connected nor reachable through Chrome, flag
it in the line as `(not connected)`. Do not suggest installing a new connector or
MCP unless Nate asks. Write `none` when the task needs no outside app.

**Est. cost** is the total for the whole task, not this one reply, in tokens and
in CAD. Pick the tier, then name what drives it in brackets:

| Task shape | Tokens | CAD |
| --- | --- | --- |
| Answer from what is already in the chat, no tools | under 10k | under $0.05 |
| A few connector reads (a Teamwork task, an email, a doc) plus a written reply | 20k-80k | $0.05-$0.20 |
| Research or project reads plus a written deliverable (copy, brief, audit narrative) | 80k-250k | $0.20-$0.50 |
| Claude in Chrome build or edit, 20-60 browser steps (Mailchimp, wp-admin) | 300k-1M | $0.60-$2.00 |
| Multi-unit batch (several emails, pages or sites) | per-unit tier times the count | same |

**How the CAD number is worked out.** Use about **$2 CAD per 1M tokens** for any
task with tool calls, and round to the nearest 5 cents. That rate is a blend, not
the list price, because most tokens in a tool-heavy session are cached context
re-reads, which cost a fraction of fresh input:

- Opus 5.5 API list price (USD per 1M): input $4, 1-hour cache write $8, cache
  read $0.20, output $20.
- Typical agentic mix: about 90% cache reads, 7% cache writes, 3% output, which
  blends to about $1.34 USD per 1M.
- At 1 USD = 1.4267 CAD that is $1.91, rounded to $2 CAD per 1M.

Short no-tool answers have almost no cache reuse, so they run closer to $5-$8 CAD
per 1M. At under 10k tokens that is still under 5 cents, so the table covers it.

Nate is on a Max subscription, so this is the API-equivalent cost, not a bill. It
is for judging what a task is worth, how hard it hits the weekly limit, and
pricing work out to clients. Prices and FX are as of Oct 5 2026. Do not look
them up on every request; refresh the three bullets only when Nate asks, the
model changes, or the rate is more than a quarter old.

What pushes it up: every screenshot (roughly 0.5k-1.5k each), long sessions where
each tool call re-sends the whole context, and retries on flaky UI. What pulls it
down: JS or API reads instead of screenshots, editing through the page's own data
model instead of clicking (the Mailchimp widget save method), and doing a batch in
one call. When an estimate runs past 500k, add a cheaper route in the brackets if
one exists.

Follow-ups in the same thread only repeat the block when the stack, apps or tier
changes.

## Table

| Signal in the request | Load |
| --- | --- |
| A URL, a site, WordPress, Divi, schema, JSON-LD, Rank Math, metas, redirects, sitemaps, plugins, an audit | `wp-dev-engine` |
| Push to live, push to staging, backwards sync, .wpress, AIO, UpdraftPlus, Divi JSON import, two environments drifted | `wp-staging-sync` |
| Compress images, image compression, shrink the images, WP-Optimize, reSmush, image weight, optimize the media library | `wp-image-compression` |
| Cam will see it, grade it, or it is going in his voice; a client deliverable, deck, wireframe, page copy, Slack update to him | `cams-way` |
| Any prose a human reads - copy, email, brief, audit narrative, caption, commit message | `stop-slop` |
| Wireframe, wireframe it, canvas, low-fi, block out the page, see the structure before the prompt | `design-canvas-wireframe` |
| A Claude Design prompt, page mock, hi-fi build or v2/v3 revision of a Claude Design canvas | `claude-design-prompt` |
| A page, layout, hero, wireframe, mockup, conversion, mobile styling, "make it look better" | `uiux-pro` |
| Before shipping anything a client or Cam judges; "review this", "tear this apart", "is this good" | `the-council` |
| A build, migration, pipeline, new deliverable type, or a plan that runs more than a few steps; something broke | `superpowers-lite` |
| A Google Doc in house format | `monochrome-doc-format` |
| A Reddit comment or post | `reddit-reply` |
| Session start inside a project, "load context", "save this", "update the brain" | `brain-keeper` |
| Keyword research, GSC/PSI data, GEO/AEO, local SEO, competitor audit, SEO reporting | `claude-seo` |
| ICP, buyer psychology, content outline, offer, positioning, value framing | `content-strategy`, `marketing-psychology`, `customer-research`, `offers` |
| Internal linking, URL structure, site IA, hub and spoke | `site-architecture` |
| Playwright or scripted browser checks against a page | `webapp-testing` |
| A plan that needs pressure-testing before building | `grill-me` |
| Ending a session, handing work to the next one | `handoff` |
| A long mechanical run where output volume is the cost | `caveman` |
| Add, update, edit, fix or write a skill | `skill-shipper` |

## Always-on, no announcement needed

- `nate-knows` on any substantive answer. Cheap, and wrong depth is the most
  common failure mode.
- `stop-slop` whenever prose is the deliverable. It is not optional and does not
  count against the cap of 3.

## Do not load

- `the-council` on drafts, explorations, or anything not yet shipping. It is a
  final gate, not a writing aid.
- `superpowers-lite` on a task that is two tool calls. The planning overhead
  costs more than the task.
- Two skills covering the same ground. `wp-dev-engine` beats `claude-seo` on
  schema; `claude-seo` beats `wp-dev-engine` on keyword and GSC data.
  `stop-slop` beats `copy-editing`. `uiux-pro` beats any other design skill.
- The built-in `design` skill on its own. It fires on the same words as
  `design-canvas-wireframe` and carries none of Cam's numbers. Only
  `design-canvas-wireframe` loads it, for the canvas machinery.
- `design-canvas-wireframe` and `claude-design-prompt` on the same request.
  "Wireframe" goes to the canvas; "prompt", "mock" or a revision of an existing
  Claude Design canvas goes to the prompt. Once the wireframe is settled, the
  prompt skill takes over and attaches the export.
- `wp-dev-engine` or `claude-seo` on an image compression run. `wp-image-compression` carries the whole method; `claude-seo` image checks are audits, not the compression pass.
- Anything on a one-line factual question.

## Conflicts

`wp-dev-engine` and `cams-way` both fire on a client page build. Load both -
they cover different axes (method vs judgment). That is the one pair worth
spending two of the three slots on.

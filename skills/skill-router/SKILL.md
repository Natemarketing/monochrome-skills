---
name: skill-router
description: Decides which of Nate's skills to load for a given request, in one pass, before doing the work. Use at the start of EVERY request. It is a lookup, not an investigation - never search, read files, or spawn agents to decide. Load at most three skills, say which in one line, then start.
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

## Table

| Signal in the request | Load |
| --- | --- |
| A URL, a site, WordPress, Divi, schema, JSON-LD, Rank Math, metas, redirects, sitemaps, plugins, an audit | `wp-dev-engine` |
| Push to live, push to staging, backwards sync, .wpress, AIO, UpdraftPlus, Divi JSON import, two environments drifted | `wp-staging-sync` |
| Cam will see it, grade it, or it is going in his voice; a client deliverable, deck, wireframe, page copy, Slack update to him | `cams-way` |
| Any prose a human reads - copy, email, brief, audit narrative, caption, commit message | `stop-slop` |
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
- Anything on a one-line factual question.

## Conflicts

`wp-dev-engine` and `cams-way` both fire on a client page build. Load both -
they cover different axes (method vs judgment). That is the one pair worth
spending two of the three slots on.

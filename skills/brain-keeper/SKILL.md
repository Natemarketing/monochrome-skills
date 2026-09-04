---
name: brain-keeper
description: Token-efficient memory discipline for the project brain. Use this skill at the START of any session inside a Claude project (load context before working) and at the END of any session that produced decisions, standards, or new client facts (write them back). Also use when the user says "load context", "what do we know about X", "save this", "update the brain", "remember this", or complains about repeating themselves or about token usage. If work is happening inside a project, this skill applies.
---

# Brain Keeper

The brain is the project's knowledge docs. It exists so no session ever pays twice for the same context: stable facts live in docs that load once and cache, instead of being re-explained, re-searched, or re-read from source every conversation. The discipline has three parts: retrieve cheap, work lean, write back.

## Retrieve cheap (session start)

1. Check the project's doc list and start at the index doc (`brain/00-START-HERE.md` or equivalent). Read ONLY the docs the task needs; the index says which. A blog task doesn't need the dev standards.
2. Search project knowledge before asking the user and before re-reading any source system (Drive, Slack, the site). If the brain answers it, the brain is the answer.
3. If the brain contradicts something newer the user says, the user wins; flag the stale doc for write-back.

## Work lean (during the session)

1. Bulk reading goes to subagents. A subagent reads the 6,000-line manual or the 40 search results and returns a distilled brief; raw dumps never enter the main window. This is the single biggest token saver available.
2. Distill, then discard: after extracting what a source says, carry the extraction forward, not the source.
3. Don't re-verify what the brain already verified. Trust dated entries unless the task is exactly about checking them.
4. Ask compound questions: one checkpoint with batched decisions beats five single questions.

## Write back (session end)

Trigger: the session produced a decision, a new/changed standard, a new client rule, a completed or started workstream, or corrected a stale brain fact.

1. Update the MATCHING doc, not a new one. New doc only for a genuinely new domain.
2. Batch: one write per doc per session. Every doc change busts the project's prompt cache for every chat, so no cosmetic edits, no churn. If it doesn't change future behavior, it doesn't go in.
3. Stamp volatile facts "as of YYYY-MM-DD". Append decisions to the decisions log with the date.
4. Keep docs compressed: the brain stores conclusions and rules, never transcripts. If a doc grows past roughly 800 words, split or prune it.
5. Credentials never go in the brain. Ever.

## Why this saves tokens (the mental model)

Context re-explained in chat is paid on every turn of every session. Context in project docs is paid once at session start and then served from cache. Context read by a subagent is paid in the subagent's window and discarded, keeping the main window (which compounds every turn) small. Route every piece of information to the cheapest of those three homes.

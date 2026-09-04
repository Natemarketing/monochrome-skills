---
name: superpowers-lite
description: Brainstorm-first planning, checkpoints, and root-cause debugging for any non-trivial build. Use this skill whenever starting a multi-step task - a site build or rebuild, a migration, an audit, a content system, a script or pipeline, a new deliverable type - before writing any code or long-form content. Also use when something is broken and being debugged, or when the user says "plan this", "think it through first", "don't just start building", or a previous attempt went wrong. If the task will take more than a few tool calls, this skill applies.
---

# Superpowers Lite

Requirements before design, design before build, checkpoint before the irreversible. And when things break: root cause before fix. This exists because rework is the most expensive thing an agent does, in tokens and in trust.

## Phase 1: Brainstorm requirements (before anything else)

Answer these in writing, briefly. This block LEADS the plan document: goal, constraints, risks, and non-goals all appear at the top, before stages and run order. When combining with a house deliverable format, do not let its section order push risks or non-goals below the plan; the reader must be able to reject the approach before reading it.

- **Goal:** what does done look like, in one sentence? What gets measured (rankings, answer rate, launch date, pages migrated)?
- **Constraints:** platform, client rules, scope hours, deadlines, things already locked.
- **Inputs:** what exists (docs, sitemaps, backups, brain docs, prior work). Read the project brain before asking the user.
- **Risks:** what breaks if this goes wrong, and is it reversible? Anything touching a live site, client comms, or published content is high-risk by default.
- **Non-goals:** what this task deliberately does NOT cover, so scope can't creep silently.

## Phase 2: Propose, then checkpoint

Present the approach in under 15 lines: chosen path, rejected alternative and why, stages, and where the checkpoints fall. One checkpoint question maximum; batch the decision points. If the user is away or unattended: state assumptions explicitly at the top of the work and proceed with the safest reversible path. Never block on a question no one is there to answer, and never let "unattended" become an excuse to do the irreversible.

## Phase 3: Execute in stages

- Stage boundaries at the points of no return: before pushing to live, before sending to a client, before deleting or overwriting anything.
- Pilot-then-batch: prove the approach on one unit (one page, one post, one URL) before running the batch.
- Backup before touch. Export first, script dry-run first. Log what each stage actually changed.

## Phase 4: When debugging

1. **Reproduce** it reliably before changing anything. A bug you can't reproduce isn't understood.
2. **Isolate**: cut the search space in half repeatedly (which layer: content, theme, plugin, cache, DNS, schema, script?). Caches lie; test incognito and after a cache clear before believing any symptom.
3. **Hypothesize and verify** with the smallest possible probe. State the hypothesis before testing it.
4. **Fix the cause, not the symptom.** If the fix doesn't explain the original symptom completely, keep digging.
5. Check the fix didn't break the neighbors (spot-check per QA checklist).

## Phase 5: Review before done

Diff or re-read the finished work against Phase 1's goal and constraints. Anything drifted? Any open item without an owner? For high-stakes deliverables, hand off to the-council skill. Update the project brain if a decision or standard was made.

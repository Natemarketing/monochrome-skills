---
name: the-council
description: Five-perspective adversarial review before anything high-stakes ships. Use this skill before delivering client-facing content, SEO audits, strategy docs, site launches, migrations, schema deployments, or any deliverable a client or boss will judge. Also use whenever the user says "council", "review this", "critique this", "is this good", "tear this apart", "second opinion", or asks how a deliverable could fail. One AI pass produces plausible work; the council makes it defensible.
---

# The Council

Five personas with conflicting incentives review the deliverable independently, then a synthesis pass fixes what they confirm. Diversity of lens catches what redundant review can't. The point is not ceremony; it is that each persona is REQUIRED to attack from an angle the drafter was not thinking about.

## The five seats

1. **The Skeptic.** Tries to refute every factual claim, stat, and promise. Flags anything unverifiable, any guarantee of outcomes (rankings, answer rates, savings), any number without a source. Default stance: the claim is wrong until the text proves otherwise.
2. **The Client.** Reads as the paying client's point of contact. Checks brand rules, banned topics, naming conventions (®, capitalization), tone fit, and anything that would embarrass them in front of THEIR boss. Uses the client-rules brain doc when in the project.
3. **The Reader.** The actual target audience member with 90 seconds. Where do they get bored, confused, or condescended to? Does the piece answer the question they came with, in the first screen?
4. **The Operator.** Technical correctness: metas within char limits, slugs real (pulled from sitemap, not guessed), links resolve, schema validates, code runs, steps executable in the stated order, scope realistic.
5. **The Editor.** Voice and craft: slop (per stop-slop), rhythm, structure, heading logic, dead sentences.

## How to run it

- **With subagents available (Cowork/Claude Code):** spawn all five as parallel subagents in one message. Each gets the deliverable plus its persona brief and returns exactly: verdict (ship / fix first / rework), top 3 issues with location quotes, and 1 thing that must not be lost in revision. Independence matters; do not let them see each other's output.
- **Without subagents:** run the five passes yourself sequentially, re-reading the deliverable fresh in each persona. Write each seat's findings before starting the next so earlier personas can't contaminate later ones.

## Synthesis

Deduplicate findings. An issue confirmed by two or more seats is fixed, no debate. Single-seat findings get a judgment call; note the dissent in one line if overruled. Then apply fixes and deliver with a short council verdict: "Council: 5 seats, N issues fixed, M dissents noted." Do not present the full transcripts unless asked; the user wants the improved deliverable, not the meeting minutes.

## Calibration

Scale to stakes. A client-facing audit or launch gets the full five seats. An internal brief can run three (Skeptic, Operator, Editor). Never council a chat answer or a trivial edit; that is theater, and theater wastes tokens.

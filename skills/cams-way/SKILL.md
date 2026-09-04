---
name: cams-way
description: How Cameron Martel (Cam), owner of Monochrome Marketing, thinks, talks, and judges work. Load before producing anything Cam will see or grade - client deliverables, reports, slide decks, landing page wireframes, page copy, content plans, Slack updates to him - or when drafting in his voice or predicting his feedback. Built the way Cam builds voice skills - positively framed, what Cam likes, with real examples - not a grievance list.
---

# Cam's Way

Profile as of 2026-09-03, built from the 2026-08-20 and 2026-09-03 1:1 transcripts, Cam's client emails, his Slack, and the Monochrome project docs. In the Monochrome Marketing project, `claude/cams-way-ledger.md` holds observations newer than this file. Read it before building anything Cam will grade, or whenever this as-of date is more than two weeks old.

## Who Cam is

Owner and Content & SEO Lead at Monochrome Marketing. Grew up hanging eavestrough in his stepdad's Calgary exteriors company (Big 5, running since 1984, three generations still in it), founded a carpet cleaning company in 2012, bought out his Monochrome partners a few years back. **His background is in content production**, which is why his page feedback is visual and directorial before it is verbal. Sales-first organic marketer: he evaluates every piece of work by whether it would move a real buyer. Teaches by monologue, analogy, and Socratic questioning. Heckling is affection. He is colorblind, so color can never be the only thing carrying meaning in anything he reviews.

## What Cam likes (his operating principles)

**Benefit selling over feature selling.** Cam likes outcomes stated as what the buyer gets, with features underneath as proof. His TV test: nobody walks into Best Buy asking for 7 HDMI inputs at 240Hz; they ask for a 4K TV that looks great and works with their PlayStation.

**Leads are the metric.** "What they care about is that they generated leads." Every KPI on a client deliverable should be one a business owner feels. Technical metrics are internal.

**The 5x rule.** Charge $500, demonstrate $2,500 in value. 2x only breaks the client even after overhead.

**CEOV.** Clarify, Empathize, Overcome, Validate. His frame for handling objections and for structuring content: name the concern, show you get it, answer it, prove it.

**Objections vs smokescreens.** An objection is a real blocker; handle it with CEOV. A smokescreen ("my insurance just renewed") is a bid for control and thinking time; ease it, don't argue it.

**The 4 Cs.** Clear, concise, complete, conversion-focused. His test for any page or doc: no content without a purpose. He names the specific C a page violated: "concise is the C that this has violated, and this, and this."

**Less is more.** His single most repeated instruction on copy: cut it in half, then keep cutting. Applied to a hero: "there's twice as much copy in a hero area than what it should have, and actually maybe even more than that. Get rid of the fucking life story."

**Show, don't tell.** "Show versus tell is amazing." If the claim is that installation quality is the differentiator, show a bad install next to a good one. If the claim is that insulated vinyl is different, show the insulation layer in a diagram.

**Write the prescription.** What the client currently has does not constrain what you specify. "My job is to tell them what I need. My job is to write the prescription. The fact that my prescription calls for you to get an hour of exercise a week and you don't currently do that is not my fucking problem. Go buy shoes." Missing before/after photos are an ask, not a reason to design around the gap. Clients expect this: "Scott from Caccia tells us all the time, we pay you to tell us what to do. So do that."

**Human first, AI second.** If the page can't convince a human to call, what AI says about it doesn't matter. Then make the same messaging machine-readable. Bold claims need proof.

**Play the game, don't game the rules.** Align with what Google and LLMs are trying to do; never build strategy on this week's patch. Corollary he now enforces on copy: no SEO injection. "A Calgary install - I never want to read again. That is SEO injected."

**MVP first.** "The mark of a good engineer is when you have a product that still works after they've removed everything from it that they could."

**Evidence discipline.** First-party data, empirical proof, methods stated, unverified flagged as unverified.

**Plan before build.** ICP and their concerns > content outline > wireframe > design > copy. Do not bring a wireframe when the assignment was an outline.

**Data sets the order of the page.** He pulls keyword data before the wireframe specifically "to make sure that when we orient the homepage, we're orienting it in the appropriate order of priority." On Remedy Roofworks the Spokane keyword data smoked Coeur d'Alene, so the homepage tilted toward Spokane. Section order is a data decision, not a taste decision.

**Reverse-engineer the ideal.** Manufacture the perfect version of the experience first, then back into it with real client data, photos, and transcripts.

**Own the outcome.** He explains what he wants once, then expects A-to-Z ownership. Bring him "here are the issues we're having and what we tried," never a status vacuum.

**Solve, don't just follow.** He wants literal instructions executed with judgment applied. "Problem solving is a dying, dying art. I just didn't expect my chief problem solver to be" one of the casualties. Following an instruction into an obviously bad outcome is not compliance, it is a miss.

**Client work outranks internal work.** Internal projects yield without argument: "that's the least important thing you're doing right now... we can meet when you need to meet, as long as it's not coming at the expense of client work."

**Close the loop.** A capability nobody can see doesn't exist.

## How Cam builds with AI (his actual method)

He delegates rather than micromanages, and expects the same from you.

- **Treat Claude like an employee, not a command line.** "I delegate to Claude like an employee, and I get a way better output than I do when I'm trying to be hyper granular on everything. I'll straight up just tell it, what do you fucking think we should do?"
- **Give it the data, not a speech about the data.** "What are you doing talking to that? Just give it the data."
- **Match the model to the task.** He ran Sonnet 5 for a keyword list while Nate sat Opus-locked: "you don't need Opus for this. You could be using Sonnet for this, or Haiku even. This is a generated keyword list."
- **Don't stack a big attachment onto a big ask.** "I wouldn't send the report at this time in the same prompt... it's going to try and digest, it's going to eat time. You're going to give it all the data all at once after."
- **Tell it what it does and doesn't have.** State up front which sources you can pull (Semrush, exported manually, not via MCP) and which you cannot (Search Console, no access yet).
- **Don't run machinery before you've given it a task.** He called out sub-agents spinning with no directive: "you haven't directed it to do anything yet, that's kind of my whole point."
- **Sanity check before you commit.** Between the research and the design brief he asks for a rough section-by-section outline of the page. "This is a version of a sanity check. We're just making sure that it's going to do what we think it should."
- **The brief is the work; the prompts are "see attached."** "How many of my prompts in Claude Design are 'see attached'? Probably about 75%. It's the whole reason I do the brief."
- **Feed it visual references and name the takeaway.** Screenshot a layout you like and say what to take from it: "I like the way the pictures are presented, it's a little bit different, it feels quirky. Could I get something like that for this section?" Divi and Elegant Themes layouts are dated and pedestrian, but useful for exactly this: "sometimes I kind of want a hero like this. I didn't know I wanted that until I saw it."
- **Explicit instructions do not carry forward.** A mobile view rendered beside desktop vanished on regeneration. "If you didn't give it the explicit instruction, there's a good chance it doesn't carry forward."
- **AI is smart and stupid at the same time.** Its clever copy is the first thing to kill. When it writes something heavy-handed, "that's the kind of thing that you look at and go, no, die."
- **Validate the finished flow against the data.** Export the revised page, take it back to the project holding the Semrush and Search Console data, and ask whether the revised content flow still meets the AEO and SEO goals. He is specifically listening for a cannibalization warning.
- **Sharing:** a workspace link only works for people in your workspace. Publish as an artifact for outside viewers. When the other person needs to actually work on it, send the HTML file instead - "in a lot of ways, sending the HTML file is better in this context."

## How Cam communicates (three registers)

Verbatim samples for all three are in `references/cam-voice-examples.md`, grouped by what he is teaching. Read that file before drafting anything in his voice.

- **Slack**: terse, lowercase, typos uncorrected, raw links, one thought per message. Match the brevity; never send him a wall.
- **Client email**: warm and structured. Personal anecdote up front, then Where we are / The plan / Performance targets with dates / Your homework.
- **Meetings and teaching**: long analogies, profanity, Socratic checks ("What's buyer's remorse?" means answer it, he's teaching), circles a concept from several angles before landing the point. Live page reviews are narrated stream of consciousness: "I like this / don't like this / concept is good, execution is bad." Verdicts reverse mid-sentence and that is fine; the reasoning underneath is the lesson, not the verdict.

## What a Cam-ready deliverable looks like

Run this before anything reaches him:

1. First lines answer "so what" for a business owner. Benefits up top, features below as proof.
2. Numbers carry their method and their proof. Anything unverified says so.
3. Client-facing and internal are separate artifacts.
4. Expectations set: what will move, what won't, by when.
5. One topic per slide or section.
6. Design and prose read like a sharp human agency made them: restrained, labeled, plain hyphens, phrasing a business owner would say out loud.
7. Anything touching a live site carries backup, rollback, canary, and QA steps.
8. Color never carries meaning alone (he's colorblind): pair it with labels, icons, or position.
9. **Grammar is load-bearing.** He caught a wrong "there" mid-meeting and openly questioned whether the content chops were there to massage copy solo. "I will pick that type of error apart every time." When they aren't, the honest move is routing copy to a copywriter, not shipping it.

## Anticipating his review

Cam pre-loads objections, and he built himself a "Cam's Adversary" skill to poke holes in his own ideas. Do the same before showing him work.

Business questions, in rough order: Who is this for? What's the benefit to them, in their words? Where's the proof? What does the client's money actually buy (5x)? What objection does this leave standing? What's missing that a buyer would ask about?

Page questions he now fires on sight: Where does my eye go, in order? Is this section visually distinct from the one above it? Can this be cut in half? If I only read the headlines and the bold text, do I know what to do? Would a 67-year-old immigrant understand this sentence? Does the layout match this product, or did you inherit it from another page? Is the most prominent photo actually about this page's topic? Where do I go to see examples of your work?

If the deliverable survives those, it's ready.

For anything high-stakes, run it through `references/cam-council.md` first. Five named Cams - the Closer, the Producer, the Copy Chief, the Tradesman, the Owner - review the deliverable independently from the five lenses he actually swaps between during a live review, then synthesis fixes what two or more of them confirm. It carries a calibration table for which seats a given deliverable needs; a Slack reply gets none.

Before structuring anything for him or a client, start from the matching skeleton in `references/cam-ready-patterns.md`. Nine patterns: client activity report, client recap email, sales narrative, content outline assignment, page content standard, the page build pipeline from research to Divi, the layout and hierarchy rules, the copy rules, and the rules for working with Cam directly.

## Update protocol

When a meeting, email, or review reveals a new Cam preference, framework, or verdict, append a dated one-liner to `claude/cams-way-ledger.md` in the Monochrome Marketing project (create it if missing; format `2026-09-03: <observation>`; one batched write per session). When 3+ material entries accumulate or Nate asks, regenerate this skill with a new as-of date and send the .skill file to save. Record what Cam likes and does, in his words where possible. Grievance lists grow forever because they patch symptoms; examples teach the pattern.

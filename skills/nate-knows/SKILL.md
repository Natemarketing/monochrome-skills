---
name: nate-knows
description: Calibrates every answer to Nate McLennan's real knowledge depth. Load at the start of any substantive answer, explanation, or deliverable for Nate. It says what he already knows (skip the fundamentals), where he is learning (teach the why, not just the what), and how he likes information delivered. Also defines the update protocol - when Nate shows new depth or a new gap, this profile gets updated, not left stale.
---

# Nate Knows

Profile as of 2026-08-22. In the Monochrome Marketing project, `claude/nate-knows-ledger.md` holds observations newer than this file. Read it before building a deliverable or whenever this as-of date is more than two weeks old; for quick answers, this file alone is enough.

## Who Nate is

Nate McLennan, organic marketing and SEO technician at Monochrome Marketing (Calgary-area agency, he works on MDT). Reports to Cameron Martel (owner), weekly Thursday 1:1s. Recently promoted into a senior organic role: he co-owns website health and integrity across the client roster with Brynn as DRI, and he is building the agency's reputation engine product (Reddit + Google Alerts monitoring with ML scoring). Mid-20s, learns by building. His pattern: hears a concept once, goes and builds the tool version of it, then comes back with questions about the parts that touch business judgment.

## How to calibrate

**Default rule: topic not listed below, or unsure? Assume Working and read his phrasing. When in doubt, err toward more depth, never less.**

Four depth levels, applied per domain below (no domain currently sits at New; the level exists for the ledger to demote or promote into):

- **Expert**: talk practitioner to practitioner. Zero fundamentals. Wrong register here reads as condescension and wastes his time.
- **Working**: skip the intro, define only genuinely niche terms, focus on the decision.
- **Learning**: this is where teaching pays. Explain the why, connect it to a domain he is expert in, and give him the mental model, not just the answer. Analogies from hardware, printing, or gaming land well.
- **New**: start from fundamentals but move fast. He catches on in one pass.

When a request spans levels (common: an expert technical task wrapped in a learning-level business decision), split the answer: terse on the technical, expansive on the business reasoning. When unsure of his depth on something, infer from how he phrased the question before asking; he would rather get the advanced version and ask a follow-up than be talked down to.

## Domain depth

### Expert - skip all fundamentals

- **Structured data / JSON-LD**: authors 25-block @graph architectures with @id entity schemes, diagnoses parser errors at root cause, cites rich-result eligibility rules to the date. Built two WordPress plugins (Monochrome Schema Blocks, MM SEO Bulk Importer) and a custom graph-resolution validator.
- **Technical SEO auditing**: DOM-level audits across 148-URL sets, GSC interpretation (impressions vs clicks, CTR diagnosis), sitemap and crawl forensics, meta discipline to the character.
- **WordPress engineering**: WP REST API with Application Passwords, Rank Math's REST routes, Avada/Fusion and Divi internals, Pods CPTs, cache purge ordering (Avada > WP Rocket > Cloudflare), staging/live push mechanics.
- **Safe deployment ops**: his own discipline is dry-run > preview > canary > gated push > verify sweep > per-slug restore, with sha256'd backup manifests. Do not explain why backups matter; he will have already made one.
- **AI tooling and automation (bottom-up)**: runs local AI and ML scoring pipelines (the reputation engine learns from his manual Reddit comments), Claude skills, projects, Cowork automation, scraping compliance strategy (Arctic Shift for Reddit, platform ToS risk lines). Cam's read: Nate understands AI bottom-up the way Cam understands SEO top-down. Never explain what an LLM, prompt, or API is.

### Working - skip the intro, focus on the decision

- **Python scripting**: writes practical push/verify/restore scripts with dry-run defaults. Not a software engineer by trade: architecture and pattern choices are worth explaining, syntax is not.
- **Image and performance optimization**: deep plugin research done (Imagify decision, WebP/AVIF mechanics), pilot not yet run, so real-world outcomes are still forming.
- **HubSpot CMS / HubL**: solid on JSON-LD placement, HubDB, templating. Newer territory than WordPress; flag HubSpot-specific gotchas he would catch instantly on WP.
- **Hardware and making**: builds PCs, builds 3D printers, designs CAD models, produces video. Strong hands-on practitioner: comfortable with tolerances, slicers, firmware, camera and edit workflows. These are also his best analogy sources when teaching him something new elsewhere.

### Learning - teach the why, this is his growth edge

- **Sales and value framing**: Cam is actively teaching benefit-based vs feature-based selling, objections vs smokescreens, CEOV, the 5x value multiplier. Nate defaults to feature framing (he built it, so he describes it). When any output touches selling, pricing, or client-facing value, explain the business reasoning behind the recommendation, not just the deliverable. Add depth here before anywhere else.
- **Content strategy and buyer psychology**: knows SEO top-down; currently building the ICP > content outline > wireframe > design > copy muscle on the Monochrome SEO page assignment. Walk through the reasoning chain, not just the output.
- **Client communication**: getting good at client-ready vs internal splits, still calibrating tone and what to leave out. Reviewing drafts against "what will the client actually do with this" helps.
- **Design judgment**: developing. Flag AI-looking design (gradients, Matrix vibes, decorative dashboards) before Cam does, and say why it reads that way.

## How Nate likes answers

Direct and structured, production-ready, paste-into-tool outputs. No filler intros. Hyphens, never em or en dashes. Meta titles 50-60 chars, descriptions 150-160 unless told otherwise. TSV for anything going into Sheets. Reddit copy in human, non-salesy register. He asks short questions and expects dense answers; when he says "sweet" or "sounds like a plan," the topic is closed, stop elaborating.

## Facts worth not getting wrong

- Cam is the colorblind one, not Nate. Nate was born after 1999 (the Matrix joke).
- Team: Cam (owner, final judge of deliverables), Brynn (DRI for site health), Graham (writes content, would be pissed to find AI copy shipped on his pages), Jamie Stevens, Jessica, Sam, Aaron, Mel.
- Client names get mangled in transcripts: "Katja/Kocha" is almost certainly Caccia (Bay Area plumbing and electrical, contacts Scott and Jordan, lawsuit-keyword monitoring is flag-only, never respond). "Foam Burner" is PhoneBurner. Other actives: Inforcer (HubSpot SaaS), Vulcan7, Big 5 Exteriors (Cam's family company), Patriot Home Solutions (Syracuse), Enviro Pro Roofing, Picture Perfect Cleaning, Remedy Roofworks, Good Kitty and CanSage (healthcare, restricted Reddit approach: branded client accounts only, Monochrome finds and points).

## Update protocol - keep this profile alive

This skill must get better every time Claude learns something real about Nate. Triggers:

1. Nate demonstrates depth a level above what this file says (promote the domain).
2. Nate asks a fundamentals question in a domain marked expert or working (note the specific gap; do not demote a whole domain off one question).
3. A new domain, tool, client, or interest appears.
4. Nate states a preference about how he wants answers.

On trigger, do both:

- **Same session**: append a dated one-liner to `claude/nate-knows-ledger.md` in the Monochrome Marketing project (create it if missing). Format: `2026-08-22: <observation>`. One write per session, batched.
- **When 3+ material ledger entries accumulate, or Nate asks**: regenerate this SKILL.md with the ledger folded in and a new as-of date, package it as nate-knows.skill, and send it to Nate to save. Offer this in one line, at the end, never mid-task.

Never treat this file as finished. A stale profile is worse than none, because it miscalibrates with confidence.

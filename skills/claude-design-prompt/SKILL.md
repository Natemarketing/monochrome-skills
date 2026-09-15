---
name: claude-design-prompt
description: Builds the prompt for a Claude Design page mock on Monochrome client work. Use whenever Nate asks for a Claude Design prompt, a page mock, a hi-fi homepage or service page build, or a v2/v3 revision of an existing Claude Design canvas. It assembles cams-way, uiux-pro, the page brief and the wireframe export into one pasteable prompt. Not for designing in chat, and not for the wireframe itself - that is design-canvas-wireframe.
---

# Claude Design Prompt

Cam grades these. The mock is the artifact he reviews, so the prompt is where the
judgment goes. This skill assembles the other skills into one prompt rather than
writing a design from scratch.

## Load first, always

- `cams-way` - non-negotiable. Spacing numbers, the 4 Cs, copy discipline, colour
  rules, what he pushes back on. A prompt built without it gets pushed back.
- `uiux-pro` - layout and conversion reasoning.
- `stop-slop` - every line of copy in the prompt is copy he will read.

Pull the page brief and any STATUS or feedback-ledger doc from the project before
writing. Prior Cam review notes on that page outrank anything general in this file.

## Preflight - do not write the prompt until these exist

Cam's order is ICP and their concerns, then content outline, then wireframe, then
design, then copy. "Do not bring a wireframe when the assignment was an outline."

1. **Keyword or GSC data pulled.** Section order is a data decision, not taste.
   "You have to do the analysis or know that you don't need the analysis."
2. **ICP and objections named.** Each section answers one.
3. **Copy written and confirmed line by line.** The prompt carries final copy word
   for word, not directions to invent copy.
4. **A reference export identified.** Design systems start from examples he likes.
5. **The wireframe canvas exists and is settled.** Built with
   `design-canvas-wireframe`, exported as PDF. If there is no wireframe yet, build
   that first; do not write a prompt that has to invent the structure.

If any is missing, say which and ask. Do not paper over a gap with a placeholder
the mock will then present as a decision.

## With a wireframe attached, the prompt gets shorter

The wireframe export carries section order, content per section, tones and the
mobile flips. The prompt no longer describes those; it references them. What the
prompt still carries in full: the confirmed copy word for word, colour and type
rules from the client's HTML, Cam's numbers, and the explicit lines that never
survive a regeneration (client colours from the attached HTML, keep the wireframe's
order and tones, render mobile and tablet alongside desktop).

## The four Cs - run every section through this before the prompt goes out

Clear. Concise. Complete. Conversion-focused. His test: no content without a
purpose. He names the C a page violated, so name it first: "concise is the C that
this has violated, and this, and this."

Pair with **CEOV** for anything answering a buyer concern: Clarify the concern,
Empathize with it, Overcome it, Validate with proof.

## Numbers - verify, never invent

Cam states spacing as numbers and "will push it back to you every single time" if
they are wrong. Pull the real values from that client's own Divi export or the
prior approved brief. These are the house defaults, not a licence to guess:

- Section padding 88px desktop / 44px mobile. Big 5 uses 96/44. Confirm per client.
- Body 18px. "14 and a half pixels nobody can read."
- H3 22px / 1.25. Card radius 10px. Nothing above 8-10px, no pill buttons.
- Three container tones per page: light, dark, accent. No two adjacent sections
  share a tone. No dark section touching another dark section.
- Typography set once in the Theme Customizer so modules stay on Default.

## Copy rules that go into every prompt

- Cut it in half, then keep cutting. "Get rid of the fucking life story."
- Two sentences max per body block. Bold one phrase per item, never a whole line.
- No ordinal numbering on cards or steps. Numbers that are facts stay.
- No copy runs the full container width. 640px column or inside a card.
- Hyphens, no em dashes. No SEO injection: "A Calgary install - I never want to
  read again."
- Show, don't tell. A claim about install quality becomes a bad install next to a
  good one, not an adjective.
- Every bracketed placeholder stays bracketed and visible. Never invent a claim,
  number, award, warranty or guarantee that is not in the confirmed copy.

## Structure of the prompt

This shape is what has survived Cam's reviews. Follow it.

1. **Canvas header line** - client, page, version, and a one-line subtitle with
   viewport widths and what is excluded. Name the attached wireframe export here.
2. **What changed and why** - only on a revision. Name each Cam fix in one line.
3. **Global rules** - colour and type, then copy. Applies to every section.
4. **Section by section** - in data-driven order, each with its copy word for word.
5. **What not to do** - the specific things he rejected last round.

## Output

Put the finished prompt in a code block in the chat so Nate can copy it straight
into Claude Design. Never hand him a file to open for a prompt.

If the mock comes back and he wants it changed, edit the existing canvas in place
under the same file name rather than regenerating it.

## Do not

- Do not use the built-in `design` skill directly for Monochrome client pages. It
  fires on the same words and does not carry Cam's numbers. The wireframe stage
  uses it through `design-canvas-wireframe`, which does.
- Do not design in chat when the ask was a prompt. If the ask was the wireframe,
  that is `design-canvas-wireframe`, not this skill.
- Do not add a nav, a footer, or imagery to a mock unless the brief says so. Those
  are later stages of the pipeline.
- Do not reuse a hero pattern across clients. Cam noticed Claude producing
  near-identical heroes and differentiates his own.

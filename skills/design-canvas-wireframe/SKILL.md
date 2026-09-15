---
name: design-canvas-wireframe
description: Builds the low-fi wireframe for a Monochrome service page, landing page or homepage as an editable design canvas (desktop and mobile artboards) straight from Cowork, before any Claude Design prompt exists. Use when Nate says wireframe, wireframe it, canvas, low-fi, section layout, block out the page, or wants to see the structure before the prompt. Not for hi-fi mocks or Claude Design prompts - that is claude-design-prompt.
---

# Design Canvas Wireframe

Cam's order is ICP and their concerns, then content outline, then wireframe, then
design, then copy. This skill owns the wireframe step. It replaces "write a prompt,
paste it into Claude Design, hope the structure comes back right" with a canvas Nate
and Cam can look at, drag around and export, and it hands Claude Design a picture
instead of a paragraph.

Reference build: the Roof Repair Service Page Wireframe canvas
(https://claude.ai/artifact/Y92CXQwBo8kgKUqF2MW7dd). Match its shape.

## Load first

- `cams-way` - numbers, tones, the 4 Cs, page content standard.
- `uiux-pro` - page classification and default flow.
- The built-in `design` skill - for the canvas machinery only (artboard format,
  seed helper, publish rules). Its aesthetic advice does not apply; this file and
  cams-way win on every design decision.

## Preflight

1. **Section order comes from data.** Keyword or GSC data, or Cam's outline. If
   there is neither, say so and ask. Do not order sections by taste.
2. **Every real service variant is known.** The wireframe names each one.
3. **Copy is illustrative at this stage.** Cam on wireframe copy: "All the copy is
   AI. It's illustrative." Write specific, plain copy so the structure reads, but
   every hard fact stays in [BRACKETS]: [CITY], [PHONE], [YEARS], [RATING],
   [WARRANTY], [COMPANY], addresses, prices. Never invent a claim, number, award or
   guarantee.

## What to build

Two artboards plus two sticky notes, on one canvas:

- `Main.dc.html` - desktop, 1440 wide.
- `Mobile.dc.html` - 390 wide. Same sections, same order. Two-column image-right
  sections flip so the image comes first. Text left-aligned. Buttons full width.
- Sticky note `outline` - one line per section, the sanity check Cam runs before
  committing. Say which data decided the order.
- Sticky note `handoff` - what gets attached to Claude Design and the explicit
  instructions that go with it (see Handoff below).

Canvas title and filename are the page's name: `remedy-roof-repair-wireframe.html`,
"Remedy Roof Repair Wireframe". Never "design" or "canvas" as the title.

### Section anatomy for a service page

Default flow from uiux-pro, ordered by data: hero, trust bar, what we do (every
variant named with the reason to choose it), social proof, first CTA, what your
quote covers, process, gallery, contained cross-sell, second CTA with form, FAQ,
location. Cut anything that does not advance the decision. Cam's page content
standard in cams-way is the checklist: variants named, objections answered in
place, quote covers where the reader starts deciding, somewhere to see the work,
cross-sell contained, full NAP.

No nav, no footer, no imagery unless the brief says so. Image slots are hatched
placeholder boxes labelled with what goes there ("Hero photo, crew on a roof,
under 200KB"). Never generate or embed real imagery at wireframe stage.

Do not reuse a hero pattern across clients. Cam notices.

### Wireframe style

Low-fi and neutral so the eye stays on structure: warm off-white and white
containers, dark ink, hatched placeholders, system font stack, no decoration.
Icons are inline SVG placeholders or a hatched square, never emoji or glyphs.

Cam's numbers are baked in even at low-fi, because the wireframe becomes the
mock's spacing reference:

- Section padding 88px desktop / 44px mobile (confirm per client; Big 5 is 96/44).
- Body 18px. H3 22px / 1.25. Card radius 10px. Buttons 8px, no pills.
- Three container tones: light, dark, accent. No two adjacent sections share a
  tone. Write the tone into each section label so the rule is visible.
- Copy never runs full container width. 640px column or inside a card.

Two tweaks only: `accent` (colour, one swatch row) and `labels` (boolean, shows or
hides the section labels). Labels read "02 · What we repair · every variant named ·
accent". Everything else is literal markup so Nate and Cam retype it in place.

## Build steps

1. Author `Main.dc.html`, `Mobile.dc.html`, `canvas.json` (artboards side by side,
   notes to the right, `launch: canvas`) in a working folder named for the page.
2. Render both artboards headless (Playwright, preinstalled Chromium) at 1440 and
   390, read the screenshots, measure the real height and set each frame's `h` and
   `$preview` to that plus slack. A clipped artboard is the only failure.
3. Seed with the `design` skill's helper, run its `--check`, publish with the
   Artifact tool exactly as that skill says (pinned contract, capabilities from
   the roster).
4. If a client folder is connected, commit the three working files beside the
   client's page brief so a later session can re-seed without extracting.

## Revisions

Edit the working files, re-seed, republish to the same path. If Nate or Cam
edited the canvas in the browser since, read the artifact and extract first, then
edit that. Never regenerate a second canvas for a v2.

## Handoff to Claude Design

The wireframe does not sync to claude.ai/design. It travels as an export:

1. Export PDF from the canvas toolbar (one PDF, both artboards) or PNG per artboard.
2. `claude-design-prompt` writes the prompt. With a wireframe in hand the prompt
   shrinks: it references the attached wireframe for structure and carries the
   confirmed copy and Cam's numbers.
3. Attach to Claude Design: wireframe export, brief, logo, saved site HTML. State
   explicitly, because neither survives a regeneration: use the client's colours
   from the attached HTML; keep the wireframe's section order, content and tones;
   render mobile and tablet alongside desktop.

## Do not

- Do not build the hi-fi mock here. Colour, type pairing and brand live in Claude
  Design. If Nate asks for the mock or the prompt, hand off to claude-design-prompt.
- Do not add sections the outline did not have. Ask first.
- Do not present a placeholder as a decision. Brackets stay visible.
- Do not skip the screenshot step. A frame that was never looked at was never QA'd.

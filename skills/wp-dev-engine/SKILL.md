---
name: wp-dev-engine
description: The house method for all WordPress, Webflow, and Shopify development and technical SEO work. Use this skill for ANY task touching a website - audits, remediation plans, schema deployments (JSON-LD), migrations, page rebuilds, meta corrections, redirects, staging/live pushes, plugin updates, launch checklists, WP REST API scripts, or QA of a live site, or building/replicating a page from a design (Claude artifact, Claude Design template, mockup, wireframe, Figma, HTML template). Also use when the user mentions Divi, Rank Math, All-in-One WP Migration, staging, slugs, sitemaps, service-area pages, or "the site". If a URL is being changed, this skill applies.
---

# WP Dev Engine

Sites are production systems attached to clients' revenue. The method: back up first, prove on one, batch, verify, and write it all down in a format the next person can execute without asking questions.

## The deliverable format (every audit, plan, deploy, handoff)

1. **Overview**: what this does, in 3 sentences.
2. **Why this approach**: cite Google guidelines or platform docs where relevant.
3. **Locked decisions**: choices already made. Do not re-litigate them in later sessions.
4. **Status/deployment matrix**: one row per URL or unit, with state (ISSUE / VERIFY / PASS / N/A) and issue codes.
5. **Paste-ready code per URL**: full JSON-LD, full snippets, exact slugs. Nothing "adapted as needed".
6. **Run order**: numbered, executable top to bottom.
7. **Validation steps**: how to prove it worked (validator.schema.org, Rich Results Test, GSC re-index, verify crawl).
8. **Open items**: each with a named owner.

Terse, imperative, decisive. No em dashes (en dash for ranges only).

## Safety sequence (never skip, never reorder)

1. **Backup before touch.** All-in-One WP Migration export before AND after on WP; live pages additionally backed up as HTML-in-Docs before edits. Where no staging exists: export-first rollback plan written down before the first change.
2. **Dry-run by default.** Scripts (Python against the WP REST API is the house pattern) execute nothing without an explicit flag: --push to write, --restore to roll back, --only <slug> to scope. Print the would-do plan on the default run.
3. **Pilot, then batch.** One page proves the approach. Only then the rest of the batch.
4. **Verify crawl after.** Automated checks per page (H1 present, metas within limits, schema validates, no staging assets leaking, links resolve, no new 4xx in GSC).

## Ground truth rules

- Do NOT guess slugs. Pull them from the sitemap (sitemap.xml) or the REST API.
- Metas: title ≤60 chars, description ≤160 hard limit with 135-159 as the target, tracked in a URL/title/description worksheet.
- Schema: Rank Math's Schema tab or paste-ready JSON-LD with @id entity graphs. LocalBusiness vs Service matters on service-area pages. Self-serving review markup is ineligible; don't add it.
- Redirects are 301s, logged, and flagged to the client's dev contact where the client owns the platform.

## The live-site trinity (check on EVERY touch of a WP site)

1. Settings → Reading → "Discourage search engines" UNCHECKED on live (CHECKED on staging).
2. Permalinks = Post name.
3. Caches cleared after changes: regenerate Divi static CSS, clear Divi cache, clear WP Rocket cache and unused CSS. Then verify incognito; caches lie.

## Content tables (WP, Divi, any theme)

Never style a content table with a `<style>` block, a CSS class, or Additional CSS. Three things kill it independently, and the symptom does not tell you which:

- Theme rules using ID selectors with `!important` (`#page table th{background:X!important}`) outrank any class-based CSS you write, no matter how specific.
- The Classic Editor Visual tab and Gutenberg strip `<style>` tags on save.
- WP Rocket minify/combine and Remove Unused CSS drop rules that only appear inside post content.

**Ship every table as pure inline styles with `!important` on every visual property.** Inline `!important` sits at the top of the author cascade, so nothing in the theme or a plugin can beat it, and there is no stylesheet left to strip. Do this on the first pass; do not start with a class-based version and iterate.

Carry `!important` on: `border`, `border-style`, `border-collapse`, `border-spacing`, `padding`, `text-align`, `vertical-align`, `background` AND `background-color` (themes set both), `color`, `font-weight`, `font-size`, `width`. For lists inside cells also `list-style`, `display:list-item`, `margin`, `padding`.

House spec:

- Wrapper: `<div style="width:100%;overflow-x:auto;-webkit-overflow-scrolling:touch;margin:24px 0;">` with `min-width` 480-620px on the table depending on column count. That wrapper is the entire mobile strategy; no media query survives an inline-only block.
- Header cells: `background:#F26522`, `color:#ffffff`, `font-weight:700`, border color matching the fill.
- Body cells: `border:1px solid #D9D9D9`, `padding:14px 16px`, `vertical-align:top`, `background:#ffffff`, `color:#1a1a1a`.
- Markup: `<thead>` with `scope="col"`, first body column as `<th scope="row">`. Row-header tables are what answer engines extract cleanly, so this is an AEO requirement, not a preference. Set `font-weight:400` on those row headers when the design shows them unbolded.
- Column widths go on the first row's cells only, not repeated down the table.

Callout and note boxes follow the same rule: an inline-styled `<div>` with an inline-styled `<p>` inside. Themes reset `p` margins and colors as aggressively as they reset table cells, so the paragraph needs its own `!important` on `margin`, `color`, `font-size`, and `line-height`, and any `<strong>` needs `font-weight:700 !important`.

Paste into the **Text** tab, never Visual. Clear WP Rocket cache after, then verify incognito.

Verify before shipping: render the block in Playwright against a hostile stylesheet (ID selectors, `border:0!important`, `background:#e8e8e8!important`, `font-weight:400!important`, `list-style:none!important`) and screenshot it. Survives that, survives the client's theme.

## Building a page from a design (artifact, mockup, Claude Design, Figma, HTML template)

The design is the only visual spec. The build matches it section by section: layout, component type, column count, alignment, colours, container width and imagery. Matching copy is required but does not make the build done.

- **No substitute style reference.** The homepage, a testbench or any other page fills in only what the design does not show (header, footer, global fonts). It never overrides something the design does show. If the design conflicts with the site (button colour, say), stop and log it as an open item with an owner. Never pick one silently.
- **No "close enough" components.** A list stays a list, an overlapping card stays an overlapping card. Never convert a section to tabs, an accordion or a 3-column grid because the site already has that module. If Divi can't do the layout natively, use a Code module or CSS scoped to that section and note it in the handoff.
- **Use the design's images.** Uploading the design's own assets is in scope for a design build. A "no new media" rule never blocks them unless Nate says so for that build. Never swap in a library image of different content.
- **The builder does not redesign.** A meeting note like "if there's a better way to tell the story, do that" is permission for whoever owns UX (the designer), not the build.
- **Section map first.** Before building, list every section in the design with its layout ("Services: 3 left-aligned rows, label left, copy right, divider lines") and build against that map.

**Done check (the build is not done until this passes):**

1. Full-page screenshots of the design and the build at 1440 and 390, side by side. Use Playwright; for a claude.ai artifact, read its HTML and render it locally.
2. Mark each section PASS or ISSUE in the status matrix for layout, alignment, colours, imagery and width.
3. Every ISSUE gets fixed, or logged as a deviation with the name of whoever approved it. No unapproved deviation ships.
4. If the screenshots can't be taken, the build stays VERIFY, never PASS. Copy-string matches and padding checks never stand in for the visual comparison.

## Platform notes

- Staging convention: clientnamestaging.monochrome.marketing, password-protected, Softaculous installs with Auto Upgrade OFF.
- Some clients ban the Divi editor for blogs (regular WP editor only); Webflow clients take tables/video/schema via embed code; check the client rules doc in project knowledge before touching anything client-specific.
- When in the Reputation Management Engine project, read `brain/03-wordpress-dev-standards.md` and `brain/04-client-rules.md` before starting; they carry the full checklists and per-client quirks this skill compresses.

## Verification of live pages

Where a browser sandbox exists (Cowork or Claude Code), Playwright with the preinstalled Chromium is the QA instrument: load the live URL, screenshot desktop and mobile, extract H1/metas/JSON-LD from the DOM, and compare against the matrix. Attach findings to the status matrix, not prose. In an environment without a browser, log visual QA as an open item with an owner; never mark it done unseen.

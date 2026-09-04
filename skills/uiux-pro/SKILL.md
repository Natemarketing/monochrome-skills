---
name: uiux-pro
description: Design reasoning engine for anything a user will look at in a browser. Use this skill before building or reviewing ANY web page, landing page, wireframe, HTML artifact, dashboard, email layout, or page section - new builds, rebuilds, and QA passes alike. Also use when the user mentions wireframes, page layout, conversion, hero sections, mobile styling, "make it look better", or asks why a page isn't converting. Apply it before writing the first line of markup, not after.
---

# UI/UX Pro

Design is reasoning, not decoration. Every layout decision traces to who lands on the page and what they came to do. Analyze first, then build.

## Step 1: Classify the page before designing

- **Search-entry pages** (organic landing: blogs, service-area pages, guides): the visitor asked a question. Content-forward, answer visible in the first screen, SEO structure intact (real H1, crawlable text, schema). Rounder, fuller copy.
- **Nav-entry pages** (home, service pages reached by clicking): the visitor is evaluating. Optimize for conversion and story. Tighter copy, stronger CTAs.
- **Tools/dashboards**: the visitor is doing a job. Optimize for scan speed and state clarity; decoration loses to legibility every time.

## Step 2: Default page flow (deviate deliberately, not accidentally)

Hero (one promise, one CTA) → supporting copy (the "why believe it") → social proof → CTA → value props → second proof → second CTA → FAQs. Search-entry pages front-load the answer content before heavy conversion furniture. Every section must earn its scroll: if it doesn't advance the visitor's decision, cut it.

## Step 3: Hierarchy rules

- One visual priority per screen. If everything is bold, nothing is.
- Headings follow the writer's structure exactly; design never reorganizes the content's logic.
- Contrast does the work: size and weight before color, color before ornament. Body text must pass contrast on real backgrounds, not just white.
- Whitespace is structure. Crowded sections read as untrustworthy.
- Self-contained means zero external requests: inline all CSS, JS, and icons, and use system font stacks or embedded fonts. A hosted webfont link (Google Fonts included) is an external dependency; add one only when the deployment target explicitly allows it.
- CTAs are imperative, specific, and visually distinct ("Get a demo", "Run a free spam-flag check", never "Learn more" as the primary).

## Step 4: House QA rules (non-negotiable on client work)

- Mobile: text left-aligned; two-column image-right sections flip so the image comes FIRST; scroll animations OFF.
- No section wider than 1920px. Styling matches the site's /ui-kit page where one exists.
- Images under 200KB, descriptive SEO filenames, alt text on everything.
- Forms tested to your own email before handoff. Address identical to the Google listing.
- Only paste from the content doc, paste unformatted, re-apply bolds manually. Styling artifacts from rich paste are a recurring defect.

## Step 5: Verify visually

Never ship a page judged only from its code. Where a browser sandbox exists (Cowork or Claude Code), render it with Playwright and the preinstalled Chromium: load the page, screenshot desktop AND a ~390px mobile viewport, read the screenshots, and check hierarchy, flips, overflow, and contrast with your eyes. For artifacts, open the HTML the same way. In an environment without a browser, log visual QA as an open item with an owner instead of silently skipping it. The screenshot is the QA record; a page that was never looked at was never QA'd.

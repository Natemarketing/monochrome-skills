---
name: monochrome-doc-format
description: "Monochrome's official Google Docs house format - naming, green headings, byline, Suggesting note, section separators, tabs, and the HTML-import build recipe."
---

# Monochrome Doc Format

Source of truth: the official Monochrome document guide (provided by Nate 2026-08-28, from the [Little Rock] Social Video Inputs / Summer 2026 template). If this skill and a newer guide disagree, the guide wins - update this skill in the same session.

## Trigger

Any Google Doc being created or restyled for Monochrome or a Monochrome client. Applies when the user says "build a google doc", "make this a doc", or names a deliverable that ships as a Doc.

## The format

1. **File name**: `[Client] Doc Name / Period` - e.g. `[Little Rock] Social Video Inputs / Summer 2026`, `[Luimoto] Schema Implementation QA / August 2026`. Client in square brackets, slash before the period.
2. **Top of page**: a full-width green horizontal bar above the title.
3. **Title line**: full client name + doc purpose + `/ Month Year`, in brand green, heading-sized bold. Example: `Little Rock Printing YouTube Inputs / April 2026`.
4. **Byline**: `Prepared by <author full name>` directly under the title, small gray text.
5. **Heading system**: H1 black bold; H2 brand green bold; H3 black bold; H4 underlined; Normal Text for body. Font is Proxima Nova, 11pt body (not a stock Google Docs font - HTML import should still declare it with Arial fallback; the team's workspace has it).
6. **Brand green**: approximately `#34A853` as used in this skill's builds. Confirm the exact hex against the brand kit the first time it matters and correct this line.
7. **Standing instruction lines** near the top of collaborative docs, verbatim:
   - Bold line: `Ensure pasting is done with Ctrl+Shift+V`
   - Green H2 `Enable Suggesting View` (with Suggesting italicized) followed by: `For the best experience working with this document, ensure you are leaving comments in Suggesting mode so our team can easily spot revisions or questions.`
   - Include these on docs the team or client will edit or review. Internal one-off reports may drop them.
8. **Section separators**: a centered dashed line with the word `Section` in the middle, between every major section or deliverable item.
9. **Document tabs** for multi-item docs: first tab `Table of Contents`, then one tab per item, tab names prefixed with the item ID (e.g. `SV4: What Is Direct to Subs...`). The Drive API cannot create tabs - build the content with Section separators and tell the user which splits to promote to tabs manually.
10. House prose rules still apply: no em dashes (hyphens only), terse and decisive, no filler.

## Build recipe (Google Drive connector)

1. Compose the body as HTML with inline styles; create with `mcp__Google_Drive__create_file`, `contentMimeType: text/html`, `textContent` = the HTML. Drive converts to a native Google Doc.
2. Green bar: single-cell borderless table with `background-color` on the cell (paragraph backgrounds import unreliably; table cells always hold).
3. Headings: `<h1>`/`<h2>` with `style="color:#34A853"` for the green levels. Byline: `<p style="color:#888888; font-size:9pt;">`.
4. Data tables: `<table border="1" cellpadding="6" cellspacing="0">`, header row green background with white text.
5. Separator: `<p style="text-align:center; color:#999999; font-size:9pt;">------ Section ------</p>` (long dash runs).
6. Save into the Monochrome shared drive (parentId `0AJspxlNhiA14Uk9PVA`) unless the user names a folder.
7. Content edits after creation: the Drive connector only updates metadata. Trash and recreate for content changes, and tell the user the doc link changed.

## Verification

Open the created doc (or have the user confirm): green bar renders above the title, title and H2s are green, byline is small gray, tables kept their borders and header fill, separators show between sections, and the file name follows `[Client] Name / Period`.
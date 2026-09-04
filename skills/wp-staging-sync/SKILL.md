---
name: wp-staging-sync
description: Moving content between a WordPress staging site and its live counterpart, in either direction. Use for full site pushes (All-in-One WP Migration, UpdraftPlus), Divi 5 JSON layout imports, staging URL cleanup after an import, and the pre-flight and post-flight checks that keep a push from wrecking indexing or the plugin stack. Triggers on push to live, push to staging, backwards sync, site clone, .wpress, Divi portability, JSON import, staging URLs, or two environments that have drifted apart.
---

# WP Staging Sync

Companion to `wp-dev-engine`. That skill governs all WordPress work; this one carries the specifics of moving content between two environments without breaking either.

Built from the 2026-08-25 Cam x Nate "LP Deployment" call and the Enviro Pro staging-to-live migration executed 2026-08-25/26.

## The first decision: push or import

Cam, 2026-08-25 (16:27):

> "Now you know how to do what you need to do to get your JSON imports working. But if the two sites are actually synced, I would just do a push as opposed to JSON imports."

| Situation | Method |
|---|---|
| Both environments in sync, one is authoritative | **Full push.** Faster, and URL rewriting is automatic. |
| Each side has content the other lacks | **JSON imports** page by page in the deficit direction, then a full push the other way once one side is authoritative. |
| A handful of pages, environments otherwise fine | JSON imports. Don't move a whole site to move four pages. |

A push overwrites the destination completely. It is never the answer when the destination holds anything unique.

## Pre-flight: prove nothing unique dies

Run before every push. A push is destructive and there is no undo beyond the backup.

```bash
# What exists on each side?
for SITE in "https://LIVE.com" "https://STAGING.example.com"; do
  echo "=== $SITE"
  for TYPE in posts pages; do
    T=$(curl -sI -A "Mozilla/5.0" "$SITE/wp-json/wp/v2/$TYPE?per_page=1&status=publish" \
        | grep -i '^x-wp-total:' | tr -d '\r' | awk '{print $2}')
    printf '  %-6s published=%s\n' "$TYPE" "${T:-?}"
  done
done
```

Then diff the slugs both ways:

```bash
curl -s "https://LIVE.com/wp-json/wp/v2/posts?per_page=100&status=publish&_fields=slug" \
 | python3 -c "import sys,json;print('\n'.join(sorted(x['slug'] for x in json.load(sys.stdin))))" > /tmp/live.txt
curl -s "https://STAGING.example.com/wp-json/wp/v2/posts?per_page=100&status=publish&_fields=slug" \
 | python3 -c "import sys,json;print('\n'.join(sorted(x['slug'] for x in json.load(sys.stdin))))" > /tmp/stage.txt
echo "ONLY ON LIVE:";    comm -23 /tmp/live.txt /tmp/stage.txt
echo "ONLY ON STAGING:"; comm -13 /tmp/live.txt /tmp/stage.txt
```

Repeat for `pages`. Anything listed under the destination side gets moved or deliberately abandoned **before** the push. Say so out loud and get a yes.

Also record the destination's current state so it can be restored after (see the noindex trap below):

```bash
curl -s "https://STAGING.example.com/" | grep -oiE "<meta name='robots'[^>]*>"
```

## The noindex trap

This is the single most dangerous thing about a push, and Cam's instruction reads backwards for half of all pushes.

Cam, 2026-08-25 (16:43), talking about a push **to live**:

> "When you do the push, you make sure that you uncheck discourage search engines."
> Nate: "I will now."
> Cam: "No, no, always."

A full push copies the source database, including `blog_public`. So:

| Direction | What the push does to the destination | What you must do after |
|---|---|---|
| staging -> live | Copies staging's `blog_public=0`. Live comes up **noindexed**. | Untick Discourage Search Engines on live. Cam's instruction, verbatim. |
| live -> staging | Copies live's `blog_public=1`. Staging comes up **indexable**. | **Re-tick** Discourage Search Engines on staging. The opposite of the quote. |

`wp-dev-engine`'s live-site trinity states the resting position: unchecked on live, checked on staging. Restore that after every push, whichever way it went.

Verify from outside, not from the setting screen:

```bash
curl -s "https://STAGING.example.com/" | grep -oiE "<meta name='robots'[^>]*>"
# want: <meta name='robots' content='noindex, nofollow' />
```

## Plugin stack after a push

The push carries the source's active-plugin state. Cam, 2026-08-25 (16:55):

> "You make sure the plugin stack is the same. Because like on staging we often have WP Rocket turned on, whereas on live we always want WP Rocket on. But on staging, you don't want to be caching shit while you're working in it, which is why I often have it off."

House position: **staging deliberately runs with almost all plugins off.** They are not needed and they get in the way. After a live -> staging push, staging wakes up with live's full stack active. Strip it back.

Turn off on staging: WP Rocket (caching lies while you work), any Divi add-on not actively required, security plugins that project headers.

## Divi 5 JSON imports

Only relevant when pushing is not the right call.

### Divi 5 is not Divi 4

Divi 5 stores layouts as Gutenberg block comments, not shortcodes:

```
<!-- wp:divi/section {"attrs":{...}} -->
```

Cam's explanation of why (12:40): Divi 4 output shortcodes, which need a translation layer on every page load. Divi 5 emits WordPress's native block language. A site at Core Web Vitals 40 typically lands at 55-60 on the upgrade alone.

Practical consequence: **all text lives inside the block JSON attributes, not between the comments.** Stripping HTML comments to extract page text returns nothing. Parse the attributes, or unescape `<` sequences first.

### The .json upload block

WordPress does not allow `.json` uploads (core ticket #45633). Divi 4 bypassed this with `wp_handle_upload(..., 'test_type' => false)`. Divi 5 dropped the bypass, so the importer hits "Sorry, you are not allowed to upload this file type."

**Fix:** enable DiviFlash's JSON upload toggle on the **receiving** site only. Export needs nothing. Turn it back off when the import is done - it costs load time and it is on the chopping block anyway (Cam pays $400 CAD/yr for it and wants it gone).

Do not install an mu-plugin for this if DiviFlash is already licensed on the site.

### Export

Gear menu (top left) -> Export. Then:

- Canvas selector must read **Main Canvas**. If it reads Header or Footer you will export the wrong thing.
- **Include All Global Canvases: UNCHECKED.** Otherwise the Theme Builder header and footer travel with the page and you get a duplicate header on the destination.
- Wait for the page to fully render before opening the menu. An export taken too early captures only what has painted.

Verify the file before importing it:

```bash
python3 - "$F" <<'PY'
import json, sys, re, collections
d = json.load(open(sys.argv[1]))
print("canvases:", json.dumps(d.get("canvases")))     # want {"local": [], "global": []}
lay = list(d['data'].values())[0]
opens = re.findall(r'<!--\s+wp:(divi/[a-z0-9-]+)', lay)
print("blocks:", len(opens), "sections:", opens.count('divi/section'))
print("bundled images:", len(d.get("images") or {}))
PY
```

**A real page export is 2-3.5 MB. An 80-90 KB file is the header, not the page.** Check the byte size every time; it is the cheapest possible guard against importing garbage.

### Import

Gear menu -> Import. Options that matter:

- Replace Existing Content: **ON**
- Download Backup Before Importing: **ON** (writes the pre-import destination page to Downloads)
- Import Presets: OFF
- Import To New Canvas: OFF

The Divi 5 builder UI renders in the **top document**, not inside `#et-vb-app-frame`. Checkboxes and the file input are reachable by plain DOM query, which is far more reliable than screenshot coordinates when the builder's renderer is misbehaving:

```js
[...document.querySelectorAll('input[type=checkbox]')]
  .map(b => b.name.split('--').pop() + '=' + b.checked)
// replaceLayout | importBackUp | includeGlobalPresets | importToNewCanvas
```

React reverts rapid successive `.click()` calls. Toggle one box, wait ~500 ms, re-read, repeat until it sticks.

Saves take 60-90 seconds on a heavy page and show a spinner. If a save appears to do nothing, reload the page and redo the import rather than clicking Save again.

## Staging URLs after a JSON import

The importer re-uploads bundled images to the destination media library and rewrites most URLs, but not all. Background images set on sections survive as source-domain URLs.

Find them:

```js
const j = await wp.apiFetch({path: '/wp/v2/pages/ID?context=edit&_fields=content'});
(j.content.raw.match(/staging\.example\.com[^"'\\\s)]*/g) || []).length
```

Cam, 2026-08-25 (10:24), after talking himself out of an FTP file copy:

> "It's probably fucking faster to just import the jsons and then manually re-import whatever images break. You can also run a database query on the live site to replace any instance of the staging URL of the live one. That's probably what I would do."

### The query

```sql
UPDATE wp_posts
SET post_content = REPLACE(post_content,
    'staging.example.com', 'livesite.com')
WHERE post_content LIKE '%staging.example.com%';
```

Idempotent. Clean pages contain no match and are skipped.

### Where DB access is unavailable

The house pattern is Python against the REST API; from inside an authenticated browser session, `wp.apiFetch` is the same operation. **Precheck, then write, then verify - separately, one page at a time.**

```js
const FROM = 'staging.example.com', TO = 'livesite.com';
const b = await wp.apiFetch({path: `/wp/v2/pages/${id}?context=edit&_fields=content`});
const raw = b.content.raw;
const hits = raw.split(FROM).length - 1;
const next = raw.split(FROM).join(TO);

// abort unless all three hold
next.length === raw.length - hits * (FROM.length - TO.length);
next.indexOf(FROM) === -1;
(raw.match(/<!--\s+wp:divi\//g)||[]).length === (next.match(/<!--\s+wp:divi\//g)||[]).length;

await wp.apiFetch({path: `/wp/v2/pages/${id}`, method: 'POST', data: {content: next}});
```

The length assertion is what makes this safe: an exact `hits x (len(FROM) - len(TO))` delta proves nothing else changed. Read the content back afterward and compare byte-for-byte against `next`.

Revisions are the rollback. Confirm they exist first:

```js
await wp.apiFetch({path: '/wp/v2/pages/ID/revisions?per_page=3&_fields=id,modified'})
```

**Do not try to fix section background images through the Divi builder UI.** Section settings frequently will not open under automation, and background images are typically two thirds of the remaining references. Image modules are reachable; section backgrounds are not.

## Verifying two environments match

Block counts alone prove nothing - every page built from one template has an identical block profile. Compare normalized text.

```js
let c = j.content.raw
  .replace(/\\u003c/gi,'<').replace(/\\u003e/gi,'>')
  .replace(/\\u0026/gi,'&').replace(/\\"/g,'"').replace(/\\\//g,'/');

const heads = (c.match(/<h[1-6][^>]*>([\s\S]{0,120}?)<\/h[1-6]>/g) || [])
  .map(s => s.replace(/<[^>]+>/g,'').replace(/\s+/g,' ').trim());

let norm = c.replace(/https?:\/\/[^"'\s\\)]+/g,'')   // domains differ legitimately
            .replace(/\b\d{2,}\b/g,'')                // so do IDs
            .replace(/<[^>]+>/g,' ')
            .replace(/[^A-Za-z ]+/g,' ')
            .replace(/\s+/g,' ').trim().toLowerCase();

let h = 0; for (let i=0;i<norm.length;i++) h = (h*31 + norm.charCodeAt(i)) >>> 0;
// compare h, norm.length, heads.length across environments
```

Matching hash plus matching length plus matching heading count on both sides is proof of content parity. Run it on every page you moved, not a sample.

Post-import per-page checks:

- Block count matches source
- Section count matches source
- Zero source-domain references
- Every image URL returns 200
- Front end serves the new H1 (cookieless fetch, caches lie)

## Post-flight

1. Restore the destination's Discourage Search Engines to its resting position. Verify from outside.
2. Strip the plugin stack back on staging.
3. Clear caches on live: regenerate Divi static CSS, clear Divi cache, clear WP Rocket cache and Used CSS.
4. Re-verify cookieless. `curl` with a cache-buster, not the browser you were just logged into.
5. Permalinks = Post name on both.
6. Take the post-state backup. `wp-dev-engine` requires an export before **and** after.

## Tooling

| Tool | Use | Where |
|---|---|---|
| All-in-One WP Migration + Unlimited Extension | Full site push. Handles URL rewrite automatically. | Cam's Google Drive; license in LastPass |
| UpdraftPlus | Fallback. Download from source, restore to destination; the free version imports fine. | Already on most sites |
| Divi Portability | Single page or template moves | Built into Divi |
| DiviFlash | Unblocks `.json` upload on the receiving site | Licensed, being phased out |

Cam, 17:22: "You just had to ask me. I have it. Should be in the process doc, LinkedIn and Google Drive."

### What the Unlimited Extension actually buys you

It lifts the 512 MB import cap. **It does not unlock any remote import source.**

Verified on Enviro Pro 2026-08-26, All-in-One v7.109 + Unlimited v2.86: the Import menu lists FILE, GOOGLE DRIVE, FTP, DROPBOX, URL, AMAZON S3, ONEDRIVE, PCLOUD, S3 CLIENT, GOOGLE CLOUD, DIGITALOCEAN, MEGA, BACKBLAZE B2, BOX, AZURE STORAGE, WEBDAV, AMAZON GLACIER. **Every one except FILE is a separately licensed extension.** Clicking URL opens the servmask.com Pro upsell page rather than a URL field.

So on a standard install the only import route is a local file through the browser picker, and the archive is usually 1 GB or more. Plan for that before generating the export.

### Moving a multi-GB .wpress

Ranked by how well they actually work:

1. **Drop the file into the destination's `wp-content/ai1wm-backups/` over FTP or cPanel File Manager.** It then appears in the Backups list with a Restore action, and no browser upload happens at all. This is the best route when FTP or file-manager access exists.
2. **Human downloads, human drags.** Person with a browser downloads from the source and drags into the destination's importer. Slow but always works.
3. **UpdraftPlus** with a shared remote destination (Google Drive/Dropbox): back up on the source, restore on the destination from the same remote. Free version handles this.
4. **Paid All-in-One extensions** (URL, FTP, Dropbox, Drive). Only if the license is already owned; do not buy one to solve a single migration.

Note the source server may not advertise `accept-ranges`, in which case the transfer has no resume and a drop restarts from zero.

### Automation cannot finish this step

An agent driving a browser cannot move a 1 GB file: file-input upload paths cap far below that. Generate the export, verify it, hand the human a URL and the destination's importer, and say plainly that the last step is theirs. Do not start an import you cannot finish.

## Gotchas worth remembering

- Staging and live page IDs are usually identical, because staging was cloned from live. Convenient, and a trap if you assume otherwise on a site built the other way round.
- A blocked `javascript_tool` call returning `[BLOCKED: Cookie/query string data]` usually means the return value contained a URL, nonce, or querystring. Return counts and booleans, not hrefs.
- When the Divi builder's renderer starts returning tiled or offset screenshots, **reload the page.** Do not try to calibrate around it. Closing other heavy builder tabs helps; they each hold a full React app.
- `wpApiSettings` is not defined on every admin screen. `wp.apiFetch` is, and it injects the nonce itself.
- All-in-One backups are served at `/wp-content/ai1wm-backups/<name>.wpress` with **HTTP 200 to anyone**, directory listing included. That is a full database archive exposed behind nothing but a random filename. Check this on every site you touch and raise it with the owner.
- Check the destination's available import sources **before** generating a 1 GB export. Two minutes of clicking saves twenty minutes of archiving you cannot use.

---
name: wp-image-compression
description: Cam's one-time image compression pass on a live WordPress site - install WP-Optimize, compress the existing Media Library once, purge caches, uninstall. Use when Nate says compress images, image compression, shrink the images, optimize the media library, WP-Optimize, reSmush, image weight, or "Cam's method" for images on any client site.
---

# WP Image Compression (Cam's method)

Install WP-Optimize, compress once, uninstall. Runs on live. Scope is compressing
existing Media Library images and nothing else: no lazy load, no cache settings,
no WebP, no other plugins.

## Before touching anything

1. **Check for an existing image optimizer** (EWWW, Smush, ShortPixel, Imagify) in Plugins.
   - Serves WebP through rewrites or a CDN: stop. Visitors get those files, so compressing
     the originals changes nothing they download.
   - Auto-compress on: stop and ask. Two optimizers fight.
   - Lossless-only with auto off: fine. Expect small JPG savings; PNGs carry the win.
2. **Check for Cloudflare:** `curl -sI <image URL>`. A `cf-cache-status` header means a
   Cloudflare purge is required at the end. Get dashboard access before starting.
3. Fresh UpdraftPlus backup.

## Run

4. Plugins > Add New > "WP-Optimize" (by TeamUpdraft) > Install > Activate. Ignore the WP
   Rocket incompatibility banner; the plugin is temporary.
5. WP-Optimize > Images. A setup wizard opens with cache, minify and compression all
   toggled on. **Click "Exit setup" at the bottom. Never "Save and continue".**
6. Settings (most are already default):
   - Automatically compress newly-added images: OFF
   - Compression: Prioritize retention of detail
   - Create WebP version: unchecked
   - Advanced > Backup original images: ON
   - Everything else default
7. Select all > Compress the selected images. **Keep that tab in front until it finishes.**
   Chrome throttles background tabs and the queue stalls. Roughly 10 minutes per 100 images.
8. Record the summary modal (images compressed, MB saved). Open View logs and search for
   "too large" or "exceed": those are files over reSmush.it's 5 MB limit. List them, do not
   retry. "could_not_lock" lines are harmless queue retries.
9. Open three images at full size: a hero JPG, a badge PNG, the logo. Confirm PNG
   transparency survived.

## Purge, inner to outer

10. Divi > Theme Options > Builder > Advanced > Static CSS File Generation > Clear
11. WP Rocket > Clear and Preload Cache
12. Cloudflare > Caching > Purge Everything. Required when Cloudflare fronts the site:
    uploads are served with `max-age=31536000`, so the edge keeps old images for up to a
    year, and no WordPress plugin can clear it without a Cloudflare API key.

## Measure

13. On each page (homepage plus one service page), scroll to the bottom so lazy images load,
    then run in the console. The backups are the "before", so no baseline pass is needed,
    and the cache-busted fetch skips browser, WP Rocket and Cloudflare caches.

```js
const re=/\.(jpe?g|png|gif|webp)$/i,m=new Set();performance.getEntriesByType('resource').forEach(x=>{try{const u=new URL(x.name);if(x.initiatorType!=='fetch'&&u.host===location.host&&re.test(u.pathname))m.add(u.origin+u.pathname)}catch(_){}});const kb=n=>Math.round(n/1024);const rows=await Promise.all([...m].map(async u=>{const cur=(await(await fetch(u+'?cb='+Date.now(),{cache:'no-store'})).blob()).size;const r=await fetch(u.replace(/(\.[a-z]+)$/i,'-updraft-pre-smush-original$1')+'?cb='+Date.now(),{cache:'no-store'});const orig=r.ok&&(r.headers.get('content-type')||'').startsWith('image')?(await r.blob()).size:cur;return{cur,orig}}));({images:rows.length,beforeKB:kb(rows.reduce((s,r)=>s+r.orig,0)),afterKB:kb(rows.reduce((s,r)=>s+r.cur,0))})
```

## Uninstall

14. Plugins > WP-Optimize > Deactivate > Delete. If it asks whether to remove its data,
    keep the data.
15. Confirm one backup still loads: `<image>-updraft-pre-smush-original.<ext>`. Backups sit
    next to each original. Restoring means swapping files by hand; the plugin's 50-day
    backup auto-delete never runs after uninstall, so they stay on disk.

## Report

One Slack line for Cam:

> [Client] images done (WP-Optimize install > compress once > uninstall, originals kept):
> X images, X MB saved (X% avg). Homepage X > X KB, /[page]/ X > X KB. Over 5 MB skipped:
> [none / list]. Caches cleared: Divi, WP Rocket, Cloudflare.

First run: Patriot Home Solutions staging, 2026-09-15. 94 images, 37.85 MB saved;
homepage 1,278 > 1,103 KB, /roofing/ 493 > 228 KB.

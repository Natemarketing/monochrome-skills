---
name: skill-shipper
description: Adds or updates a skill in Nate's private skill repo and publishes it everywhere. Use whenever Nate says add a skill, update a skill, change a skill, edit a skill, write me a skill, or fix a skill. Always ends by handing him one PowerShell command and nothing else.
---

# Skill Shipper

Nate's skills live in one private repo that is also a Claude plugin marketplace:
`C:\Users\n8mcl\monochrome-skills`, published as `Natemarketing/monochrome-skills`.
Editing a skill anywhere else creates a second version that silently drifts.

## The job

1. Write or edit the file at `C:\Users\n8mcl\monochrome-skills\skills\<name>\SKILL.md`.
2. Hand Nate the ship command, or the drop command if the file went out as a
   download. One line, unchanged every time.

Nothing else. Do not walk him through git, do not explain the version bump, do not
list the propagation steps. `ship.ps1` does all of it and prints its own summary.

## Writing the file

Frontmatter needs `name` (matching the folder) and `description`. The description is
the only thing that decides when the skill fires, so write it as the situations and
words Nate would actually type, not an abstract summary.

Add `disable-model-invocation: true` only when the skill should be `/`-invoked
exclusively. Nate will not see such a skill listed when he asks what is available,
so say so if you set it.

If a skill delegates to another skill, confirm that one is in the repo too. `grill-me`
shipped broken once because it called `grilling`, which was not vendored.

## Getting the file into the repo

Two routes. Pick by whether the session can write to his machine.

**Linked to his computer (folder `~/monochrome-skills` granted):** write the file
straight to `skills\<name>\SKILL.md`, then hand him the ship command.

**Not linked, or the bridge is flaky:** send the file into the chat as a download
named `<name>.SKILL.md` (for example `wp-staging-sync.SKILL.md`), then hand him the
drop command. `drop.ps1` picks every `*.SKILL.md` out of his Downloads, moves each one
to `skills\<name>\SKILL.md`, and runs `ship.ps1`. Several skills in one pass is fine;
the filename is the routing. Never paste a whole SKILL.md into the chat as a code block
for him to save by hand.

## The command

Always end with exactly one of these, in its own block, nothing after it.

Wrote the file to the repo yourself:

```
powershell -ExecutionPolicy Bypass -File "$HOME\monochrome-skills\ship.ps1"
```

Sent the file as a chat download:

```
powershell -ExecutionPolicy Bypass -File "$HOME\monochrome-skills\drop.ps1"
```

Add `-m "message"` only if he asked for a specific commit message. Both scripts derive
one from the folders touched otherwise.

## Rules

- **Never edit the vendored third-party skills in place.** `caveman`,
  `caveman-compress`, `caveman-stats`, `cavecrew`, `grill-me`, `grilling`, `handoff`,
  `content-strategy`, `marketing-psychology`, `customer-research`, `offers`,
  `site-architecture`, `webapp-testing` are re-copied from upstream by
  `refresh-thirdparty.ps1` and any edit is destroyed. To change one, copy it to a new
  name and edit that.
- **A new skill needs a row in `skill-router`.** Add it in the same pass, or the
  router will never load it. That counts as a second edited file, not a second ship.
- **Check for collisions before adding.** If the new skill fires on the same words as
  an existing one, say which one wins and add it to the router's "do not load"
  section. Two skills on one trigger produce mush.
- **Deleting** means removing the folder from the repo. It disappears on the next
  update, but not from `~/.claude/skills` on any machine where it was loose-copied.
- **Web chat is not covered.** Plugins do not load in Chat. If Nate needs a skill
  there, it has to be zipped as a `.skill` and uploaded to his account separately.

---
name: hb-update
description: Merge a new Hashbang version into the framework files and skills this project has customized, keeping the project's changes. Use after the Hashbang installer reports customized files that need merging, or when the customer asks to update Hashbang.
---

The installer updates every Hashbang file the project hasn't changed. It never overwrites a customized one; it leaves the new version for you to merge. Your job is a three-way merge done with judgment: bring in what Hashbang changed, keep what the project changed, and say what you did.

## Step 1 — Find what needs merging

Read `.hashbang/upstream/incoming/PENDING`. If it doesn't exist, there is nothing to merge. If the customer asked to update Hashbang, tell them to run the installer from their Hashbang clone first (`path/to/hashbang/install.sh`), then run this skill again.

PENDING is tab-separated. The `from` and `to` lines give the versions. Every other line is one file: its kind, its path in Hashbang, and its path in this project. For each file, three versions may exist:

- **Base** — `.hashbang/upstream/installed/<Hashbang path>`: the Hashbang version the project's copy started from. Missing for projects installed before base files were kept.
- **New** — `.hashbang/upstream/incoming/<Hashbang path>`: the new Hashbang version.
- **Local** — the project's copy, at the project path.

## Step 2 — Understand both sides

Read before you merge: `.hashbang/customizations.md`, for why the project changed each file, and Customizing Hashbang in `.hashbang/framework/hashbang.md`, for the formats a merged file must keep.

## Step 3 — Merge each file

Work out Hashbang's change from base to new (`diff -u base new`), and the project's change from base to local. Read Hashbang's change as a whole and work out what it is for, since that intent is what you carry into text that no longer matches. Then:

- **modified** — both sides changed it. Apply Hashbang's change to the local file, keeping the project's customizations. Where they touch the same text, carry Hashbang's intent into the project's wording rather than replacing it. Without a base, compare new against local: a difference explained in customizations.md is the project's; treat any other as Hashbang's, and say so in your report.
- **removed** — Hashbang no longer ships this file, but the project customized it. Look in the other new files for where its job went, such as a renamed skill or a merged section. Delete the file if its job moved elsewhere, and carry the project's customizations to the replacement. Keep it if the project still relies on it.
- **deleted** — the project deleted this file, and Hashbang has since changed it. Leave it deleted unless the change fixes something this project still relies on.

When the new version changes a format other files read, such as a heading or a frontmatter field, update every customized file that depends on it, not only the pending ones.

A conflict is a high-judgment decision only when keeping the project's change would lose a fix or a rule Hashbang clearly added on purpose, or taking Hashbang's would undo something customizations.md says the project chose on purpose. Ask about those, together, with your recommendation for each. Decide the rest yourself.

## Step 4 — Finish

After each file is resolved:

- Copy its new version from `incoming/` to the same path in `installed/`, so the next update compares against it. For a resolved **removed** file, delete its base from `installed/` instead.
- Log every file you changed in `.hashbang/customizations.md`: what you merged, and anything of the project's that you dropped and why.

When every file is resolved, delete `.hashbang/upstream/incoming/`. Then report in a few lines: what you adopted, what you adapted to the project's customizations, what you skipped and why, and any question still open.

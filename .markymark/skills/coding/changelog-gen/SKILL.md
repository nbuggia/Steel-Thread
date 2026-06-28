---
name: changelog-gen
description: Transforms changelog.json into human-readable release notes — technical and user-facing versions
invoke: user
triggers: at each milestone (Alpha/Beta/GA)
---

Transforms the raw changelog.json into a human-readable release summary. Two versions: technical (for the team) and user-facing (for customers).

## What it reads

- changelog.json — every file change since the last milestone
- tasks.json — which tasks and phases are complete
- docs/prd.md — what features were planned for this milestone
- bugs/bugs.md — which bugs were fixed

## Technical changelog

Organized by feature. For each feature: what changed, what was added, what was removed, which bugs were fixed. Honest about known limitations and deferred items.

## User-facing release notes

Plain language. Benefits not features. "You can now export to PDF" not "Added PDF export endpoint." No jargon. Follows CONTEXT.md brand voice — if defined. No hype.

## Output

Writes to docs/CHANGELOG.md appending a new milestone section.
Proposes the user-facing version to the customer for review before publishing — does not write it to a public-facing file without approval.

## Format

```markdown
## [Milestone name] — [Date]

### What's new
- [User-facing benefit]
- [User-facing benefit]

### What changed
- [Feature]: [what changed]

### Bugs fixed
- [BUG-XXXXX]: [title] — [one-line root cause]

### Known limitations
- [Explicit — do not omit deferred items]
```

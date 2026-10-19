# Review Finding Table

This is the one place that defines the review table: its columns, and what each decision means. Two files use this same table — `templates/complex-tech-design-template.md` (§15 Reviewer Feedback) and `templates/simple-tech-design-template.md` (§8 Review). They used to define it separately, and drifted out of sync (one had a different column name, the other was missing the decision definitions below). If you ever need to change a column, change it here first, then copy the new header row into both templates — that way they can't drift apart again.

| \#  | Finding | Severity | Cost to accept | Decision | Rationale | Next step | Arch? | Source |
| --- | ------- | -------- | -------------- | -------- | --------- | --------- | ----- | ------ |

**Source** records which review pass or feedback channel produced the finding — e.g. `Pass 1`, `Pass 2`, `Blocker verification`, or `External` for user-supplied feedback (§6). This is what lets a retro compare the value of each pass and each external review.

What each decision means:

- **ACCEPT** — apply the finding to the design or plan.
- **REJECT** — don't apply it, but write down why. Rejecting a blocker is a high-judgment decision; escalate it to the user.
- **DEFER** — don't resolve it now; write it down as an open question or follow-up instead.
- **SUPERSEDED BY #N** (or by a named spec change) — a later finding or requirement change made this one obsolete. The row moves, unchanged apart from this decision, to the design's sibling `<design>-review-history.md` (SKILL.md §4).
- **CLEAN** — if a review pass finds nothing wrong, that's still worth a row: just name the pass. A clean pass is a good result, not a missing one.

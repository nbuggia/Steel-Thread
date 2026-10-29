# Review Finding Table

This is the one place that defines the review table: its columns, and what each decision means. The Complex template's §15 Reviewer Feedback uses it. To change a column, change it here first, then copy the new header row into the template.

| \#  | Finding | Severity | Cost to accept | Decision | Rationale | Next step | Arch? | Source |
| --- | ------- | -------- | -------------- | -------- | --------- | --------- | ----- | ------ |

**Source** records which review pass or feedback channel produced the finding — e.g. `Pass 1`, `Pass 2`, `Blocker verification`, or `External 1` for user-supplied feedback (§6). This is what lets a retro compare the value of each pass and each external review.

What each decision means:

- **ACCEPT** — apply the finding to the design or plan.
- **REJECT** — don't apply it, but write down why. Rejecting a blocker is a high-judgment decision; escalate it to the user.
- **DEFER** — don't resolve it now; write it down as an open question or follow-up instead.
- **CLEAN** — if a review pass finds nothing wrong, that's still worth a row: just name the pass. A clean pass is a good result, not a missing one.

---
name: [feature name]
area: [product area — matches the folder under docs/specs/]
status: Draft / Approved / Current / Retired
tasks: [T-NNN, … — every task that has changed this spec]
last updated: YYYY-MM-DD
---

# Spec: [Feature Name]

[Status meanings: Draft — being written or changed. Approved — the customer approved it; the next step can start. Current — every rule in a shipped release matches the product. Retired — the feature was removed.]

## Summary

[Two or three sentences: what the feature does, who it is for, and what they get from it. A reader who stops here should know what this feature is and why it exists.]

## Users

- **For:** [who uses this, and the situation they are in]
- **Core value:** [the one thing this must do for them to be worth building, in one specific sentence. "Helps people write" is too vague; "a writer can hand an agent a draft and review its changes without losing their own edits" is specific.]
- **Not for:** [who this is deliberately not built for]

## Not Doing

[Every item needs a reason. Rejected ideas without one get suggested again.]

- [Excluded capability] — [why it is excluded]

## Use Cases

[Ranked by importance. Each one serves the core value and is usable on its own. Releases are assigned in the Releases table, not here.]

### P1 — [Use case title]

[The journey in one or two sentences.]

- **Why this priority:** [reason]
- **How to verify:** [the test or demo that proves it works]
- **Rules:** [rule numbers from Behavior, e.g. 1.1–1.4, 2.2]

## Releases

[The only place releases are mapped to use cases. Release 1 is the smallest set of use cases that delivers the core value for real, not as a demo. Each later release has a goal of its own. Fill in Shipped when the release ships.]

| Release | Goal | Use cases | Shipped |
| ------- | ---- | --------- | ------- |
| 1       |      | P1, P2    |         |

## Behavior

[Numbered rules, grouped by topic. Designs and tests cite rules by number, so never renumber them.

- A rule with a trigger: `WHEN <condition> THE SYSTEM SHALL <behavior>`.
- Behavior that must not change: `THE SYSTEM SHALL CONTINUE TO <behavior>`.
- When the outcome depends on state, use a table instead of a list of rules.
- When rules are checked in order, say so.
- Under any rule whose reason is not obvious, add a `Why:` line. A rule that settled an open question always gets one.
- A removed rule keeps its number: `1.3 Removed — T-NNN.`
- A group of rules that belongs only to an unshipped release carries `(Release N)` on its heading. Remove the tag when that release ships. Never tag a single rule.]

### 1. [Topic]

1.1 WHEN [condition] THE SYSTEM SHALL [behavior].

1.2 WHEN [condition] THE SYSTEM SHALL [behavior].
    Why: [the reason, if a future change could break it without knowing]

| State | Behavior |
| ----- | -------- |
|       |          |

## Limits

[Numbers, sizes, timings, and invariants: what must always or never be true. Each one is checkable.]

- [Name]: [value or invariant]

## Edge Cases and Errors

[Empty, failure, and boundary states, written as rules and numbered like Behavior.]

E.1 WHEN [condition] THE SYSTEM SHALL [behavior].

## UI

[Optional. The visible decisions: layout, states, sizes, and wording that the rules refer to. If a prototype settled them, copy the decisions here. Prototypes are thrown away, so never link to one. A screenshot saved next to this spec is fine.]

## Success Criteria

[Optional. Measurable results that do not depend on the technology, such as "a first-time user finishes setup in under two minutes."]

## Assumptions

[Optional. Defaults chosen where the customer didn't say, so they can be challenged. Include what the spec assumes in place of a prototype the customer declined.]

## Related Specs

[Optional. Specs that own nearby behavior. Link to them; never restate their rules.]

- [path] — [what it owns]

## Open Questions

[Only unanswered questions. Mark each one inline where it applies as `[NEEDS DECISION: …]` and list it here, with what will answer it: the customer, or a prototype. When one is answered, move the answer into the rules with a `Why:` line, and delete it from this list.]

- [question] — [rule or section it blocks] — [who or what answers it]

## Change History

[Newest first. One line per task that changed this spec, and one for any drift corrected to match the product.]

- YYYY-MM-DD · T-NNN · [what changed]

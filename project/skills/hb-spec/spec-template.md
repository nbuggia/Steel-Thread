---
name: [feature name]
status: Draft / Approved / Retired
tasks: [T-NNN, … — every task that has changed this spec]
last updated: YYYY-MM-DD
---

# Spec: \[Feature Name\]

\[Status meanings: Draft — being written or changed. Approved — it passed review with no open decisions; the next step can start. Retired — the feature was removed. Each release records when it was completed.\]

## 1. Summary

\[Two or three sentences: what the feature does, who it is for, and what they get from it. A reader who stops here should know what this feature is and why it exists.\]

## 2. Users

- **For:** \[who uses this, and the situation they are in\]
- **Core value:** \[the one thing this must do for them to be worth building, in one specific sentence. "Helps people write" is too vague; "a writer can hand an agent a draft and review its changes without losing their own edits" is specific.\]
- **Not for:** \[who this is deliberately not built for\]

## 3. Not Doing

\[Every item needs a reason. Rejected ideas without one get suggested again.\]

- \[Excluded capability\] — \[why it is excluded\]

## 4. UI

\[Optional. The visible decisions: layout, states, sizes, and wording that the rules refer to. If a prototype settled them, copy the decisions here. Prototypes are thrown away, so never link to one. A screenshot saved next to this spec is fine.\]

## 5. Releases

\[One table per release. Each release has a short name that states its purpose. At most one release has no completion date; if present, that is the current release. Its use cases are implemented together. Preserve use-case numbers when moving rows.\]

### R1 — \[Short purpose\]

**Completion date:** \[YYYY-MM-DD or —\]

#### Use Cases

| Use case number | Area / theme | Use case title | Journey | How to verify | Rules |
| --- | --- | --- | --- | --- | --- |
| UC-001 | \[area\] | \[short title\] | \[journey in one or two sentences\] | \[test or demo\] | \[6.1–6.4, E.2\] |

## 6. Backlog

\[Unprioritized holding area. Do not group or sequence it. Rows may remain rough and use `—` for details that will be settled only if the use case enters a release. Backlog gaps do not block approval.\]

| Use case number | Area / theme | Use case title | Journey | How to verify | Rules |
| --- | --- | --- | --- | --- | --- |
| UC-002 | \[area\] | \[short title\] | \[one or two sentences, or —\] | \[test, demo, or —\] | \[rule numbers, or —\] |

## 7. Behavior

\[Numbered rules, grouped by topic. Designs and tests cite rules by number, so never renumber them.

- A rule with a trigger: `WHEN <condition> THE SYSTEM SHALL <behavior>`.
- Behavior that must not change: `THE SYSTEM SHALL CONTINUE TO <behavior>`.
- When the outcome depends on state, use a table instead of a list of rules.
- When rules are checked in order, say so.
- Under any rule whose reason is not obvious, add a `Why:` line. A rule that settled an open question always gets one.
- A removed rule keeps its number: `6.3 Removed — T-NNN.`
- A group of rules that belongs only to the current release carries its number, such as `(R1)`, on its heading. Remove the tag when that release is completed. Never tag a single rule.\]

### \[Topic\]

6.1 WHEN \[condition\] THE SYSTEM SHALL \[behavior\].

6.2 WHEN \[condition\] THE SYSTEM SHALL \[behavior\]. Why: \[the reason, if a future change could break it without knowing\]

| State | Behavior |
| --- | --- |
|  |  |

## 8. Limits

\[Numbers, sizes, timings, and invariants: what must always or never be true. Each one is checkable.\]

- \[Name\]: \[value or invariant\]

## 9. Edge Cases and Errors

\[Empty, failure, and boundary states, written as rules and numbered like Behavior.\]

E.1 WHEN \[condition\] THE SYSTEM SHALL \[behavior\].

## 10. Success Criteria

\[Optional. Measurable results that do not depend on the technology, such as "a first-time user finishes setup in under two minutes."\]

## 11. Assumptions

\[Optional. Defaults chosen where the customer didn't say, so they can be challenged. Include what the spec assumes in place of a prototype the customer declined.\]

## 12. Related Specs

\[Optional. Specs that own nearby behavior. Link to them; never restate their rules.\]

- \[path\] — \[what it owns\]

## 13. Open Questions

\[Only unanswered questions in the current release. Mark each one inline where it applies as `[NEEDS DECISION: …]` and list it here, with what will answer it: the customer, or a prototype. When one is answered, move the answer into the rules with a `Why:` line, and delete it from this list. Use `—`, not an open question, for unsettled backlog details.\]

- \[question\] — \[rule or section it blocks\] — \[who or what answers it\]

## 14. Change History

\[Newest first. One line per task that changed this spec, and one for any drift corrected to match the product.\]

- YYYY-MM-DD · T-NNN · \[what changed\]
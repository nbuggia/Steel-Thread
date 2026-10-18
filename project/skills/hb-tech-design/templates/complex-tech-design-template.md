---
name: feature tech design
description: feature description
rigor: Complex
deciding tenet: [what escapes, or what no test can settle]
date: YYYY-MM-DD
review iteration: N
status: Draft / In Review / Approved / Implementing / Done / Superseded
---

# Tech Design: Bug or Feature Name

## 1. Context

\[Problem and why now.\]

## 2. Goals / Non-Goals

\[Testable outcomes; at least two explicit non-goals with rationale.\]

## 3. Open Questions

\[Unresolved decisions; do not hide uncertainty.\]

## 4. Requirements

\[Links to relevant specs.\]

### Spec Review

Quote relevant claims verbatim. Include Architecture and every touched spec; list reviewed specs with no relevant claims.

| Spec | Direct claim | Changes it? |
| ---- | ------------ | ----------- |

## 5. Current System Audit

Verify from source; include applicable entry points, state owners, IPC/event wiring, registration, consumers, restore/reload, cleanup, and tests.

| Concern | Source evidence | Current behavior / gap |
| ------- | --------------- | ---------------------- |

| Failure mode | Applicable / Not applicable / Checked—no issue / Accepted risk | Evidence |
| ------------ | -------------------------------------------------------------- | -------- |

## 6. Proposed Design

\[Rust, frontend, IPC, state ownership, and one end-to-end success/failure flow. Add a diagram when &gt;3 components participate.\]

| New state | Owner | Lifetime | Persist? | Why |
| --------- | ----- | -------- | -------- | --- |

| Operation | Triggers | Caller | IPC | Handler/event | Registration | Consumer/state | Restore/cleanup | Test | Evidence |
| --------- | -------- | ------ | --- | ------------- | ------------ | -------------- | --------------- | ---- | -------- |

| Guarantee | Mechanism | Owner | Linearization point | Failure behavior | Proof |
| --------- | --------- | ----- | ------------------- | ---------------- | ----- |

For awaits, dialogs, lock releases, events, reloads, check-then-act, or concurrent entry points:

| Boundary | Concurrent event | Invariant | Linearization point | Recovery |
| -------- | ---------------- | --------- | ------------------- | -------- |

### Red Flags Audit

Screen the design above — and every alternative in §11 — against `../design-red-flags.md`.

| Red flag               | Present? | If present, why acceptable |
| ---------------------- | -------- | -------------------------- |
| Shallow module         |          |                            |
| Information leakage    |          |                            |
| Temporal decomposition |          |                            |
| Pass-through method    |          |                            |

## 7. Command & Event Contract

| Command | Args | Return | Errors | Async? |
| ------- | ---- | ------ | ------ | ------ |

\[For events: name, payload, emitter, listeners, ordering/delivery. State whether Rust/TS types are generated or mirrored.\]

## 8. Data Model & Persistence

\[Mechanism, schema/version, migration, rollout ordering, retention/removal.\]

## 9. Capabilities & Security

\[Minimum Tauri permissions/scopes, CSP, trust boundaries, attack surface.\]

## 10. Cross-Platform

Baseline is macOS (WebKit). For Windows and Linux, name what's different and how it's verified — "None" is a complete answer, a missing row is not.

| Platform | Engine    | Difference from macOS | Verified how |
| -------- | --------- | --------------------- | ------------ |
| Windows  | WebView2  |                       |              |
| Linux    | WebKitGTK |                       |              |

## 11. Alternatives / Reuse / Proportionality

| Checked | Stdlib / native / existing dep / new dep | Covers? | Why not | Ceiling / upgrade path |
| ------- | ---------------------------------------- | ------- | ------- | ---------------------- |

| Rare case | Cost to support | Requirement change that deletes it | Recommend |
| --------- | --------------- | ---------------------------------- | --------- |

\[At least two real alternatives — see §3 (Draft) of `hb-tech-design` for the reuse/proportionality bar. Break ties on interface depth (`../design-red-flags.md`) — prefer hiding more behind a smaller surface, not a shorter call chain.\]

## 12. Implementation Slicing Strategy

\[Vertical runnable sequence, or smallest enabling design change. Name ceilings and upgrade paths.\]

## 13. Testing Strategy

Every declared error and lifecycle/concurrency failure needs automated or manual proof. Cover applicable partial success, stale dialog state, missing wiring, cleanup, reload between decision/action, and concurrent entry points.

| Test | Regression prevented |
| ---- | -------------------- |

## 14. Rollout

\[Flag or direct ship — the one universal question. Add signing impact or release rollback only when this design changes what ships or how it's packaged; otherwise "direct ship, no flag" is complete. Data migration and its rollback belong in §8, not here.\]

## 15. Reviewer Feedback

Table shape and decision legend: `../agent-review-table.md`.

| \#  | Finding | Severity | Cost to accept | Decision | Rationale | Next step | Arch? | Source |
| --- | ------- | -------- | -------------- | -------- | --------- | --------- | ----- | ------ |

## 16. Implementation Outcome

Append only after implementation; omit this section and the next until then.

\[What landed, dated. Executed evidence — concrete pass/fail counts per test suite, build/lint checks. Release-blocking commands, if any, with exact invocations and platform caveats; name anything that is not substitute evidence for them.\]

## 17. Post-Implementation Drift Review

Append only if implementation surfaced drift from this design.

\[Why another review happened. State plainly whether this section or an earlier one is now the current readiness authority — never delete the superseded one, mark it historical instead. If drift recurs again later, repeat this pattern as a new dated Implementation Outcome / Drift Review pair rather than overwriting the last one.\]

Table shape and decision legend: `../agent-review-table.md`.

| \#  | Finding | Severity | Cost to accept | Decision | Rationale | Next step | Arch? | Source |
| --- | ------- | -------- | -------------- | -------- | --------- | --------- | ----- | ------ |

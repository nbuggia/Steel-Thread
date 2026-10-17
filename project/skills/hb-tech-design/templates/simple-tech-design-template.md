---
name: fix plan
bug: short title
rigor: Simple
deciding tenet: [revertible and test-settled; demonstrable in one slice]
date created: YYYY-MM-DD
status: Planning / Ready / Complete / Escalated
review iteration: 0
---

# Tech Design: Bug or Feature Name

\[Keep this plan under \~200 lines. Growing past that is a sign the change has outgrown Simple rigor — re-run §1 of `hb-tech-design` rather than padding this plan out.\]

## 1. Summary

\[Symptom, impact, existing contract, corrective shape.\]

## 2. Rigor Gate

[Which selection criteria decided Simple, per §1 of `hb-tech-design` — also recorded in `deciding tenet` above.]

- Escalation trigger, if any:

## 3. Proof

- Current / expected:
- Reproduction or deterministic source proof:
- Root cause / evidence / falsification:
- Unknowns:

## 4. Contract Audit

| Concern | Source evidence | Current behavior / gap | Claim change? |
| ------- | --------------- | ---------------------- | ------------- |

| Operation | Entry/caller | IPC/serialization | State/consumer | Restore/cleanup | Test | Evidence |
| --------- | ------------ | ----------------- | -------------- | --------------- | ---- | -------- |

| Failure mode | Applicable / Not applicable / Checked—no issue / Accepted risk | Evidence |
| ------------ | -------------------------------------------------------------- | -------- |

## 5. Scope and Fix

- Goals / non-goals / escalated follow-ups:
- Native/API evidence, if applicable:

| Checked | Stdlib / native / existing dep / new dep | Covers? | Why not | Ceiling / upgrade path |
| ------- | ---------------------------------------- | ------- | ------- | ---------------------- |

| Invariant | Existing contract | Minimal mechanism | Linearization point | Failure/recovery | Proof |
| --------- | ----------------- | ----------------- | ------------------- | ---------------- | ----- |

## 6. Slices

### Slice 1: Name

| Scope | Demo | Dependencies | Deferred | Invalidation risk |
| ----- | ---- | ------------ | -------- | ----------------- |

### Slice 2: Name (optional)

\[Same table.\]

Dependency check: valid predecessor, concrete consumption, truthful deferrals.

## 7. Verification and Risk

| Test/check | Invariant/regression proved |
| ---------- | --------------------------- |

- Data/platform risk:
- Code rollback:
- Customer/partial-success recovery:
- Monitoring:

## 8. Review

Table shape and decision legend: `../agent-review-table.md`.

| \#  | Finding | Severity | Cost to accept | Decision | Rationale | Next step | Arch? | Source |
| --- | ------- | -------- | -------------- | -------- | --------- | --------- | ----- | ------ |

## 9. Readiness

- Ready / full design required / blockers / deferred risks:

## 10. Outcome

- Commit / tests / manual evidence / drift / follow-up:

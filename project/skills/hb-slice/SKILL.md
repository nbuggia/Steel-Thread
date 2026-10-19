---
name: hb-slice
description: Turn an approved technical design into thin vertical implementation slices with drift checkpoints. Use when asked to slice or sequence a technical design for implementation.
---

# Slice Tech Design

This is step 4 of `.hashbang/framework/development.md`. Use only after an Approved design exists.

## 1. Load

Read the design, `tech-design-slices-template.md`, `AGENTS.md`, and `docs/engineering/CONVENTIONS.md` in full. Read linked specs needed for boundaries. Record the design commit; if dirty, also record `uncommitted working tree`.

If no design is named, use the one for the task in progress in TASKS.md. Ask only if that leaves more than one candidate.

## 2. Gate

Find the section that defines the design's slicing strategy, per whichever hb-design template produced this design — its heading name follows that template, not a fixed string (e.g. `Implementation Slicing Strategy` in the complex template, `Slices` in the simple one). Proceed only if it defines a valid vertical sequence. Otherwise create no plan: name the smallest required design change and take it back to `hb-design`. Quote its conclusion in the plan.

## 3. Slice

Create `slices.md` from the template, in the same task folder as the design: `docs/work/T-NNN-<name>/slices.md`. Never rename or move it afterward.

- Prefer few slices.
- Each slice closes one cohesive, independently verifiable outcome.
- Split only for independently valuable checkpoints or unrelated risk, not time.
- Layer-only slices must name the later vertical slice they enable.
- Carry design shortcuts/ceilings into `Invalidation risk`.
- Every slice needs a plausible test or demo.

## 4. Review

Budget: one broad pass, plus one targeted blocker-verification pass if needed. All reviewers and user-supplied feedback share this budget.

When possible, give a fresh reviewer only the design, plan, and this request:

```text
Review this slicing plan for non-vertical or incohesive slices, hidden dependencies, invalid predecessor states, misleading deferrals, weak demos, and vague invalidation risks. For each finding give evidence, suggested change, and severity: PLAN BLOCKER, SLICE BLOCKER (name slices), MAJOR, MINOR, or QUESTION.
```

Classify each change:

- **SLICING:** boundaries, order, dependencies, deferral, verification.
- **DESIGN:** runtime semantics, architecture, ownership, concurrency, persistence, security, IPC, or customer behavior.
- **EXPANSION:** capability/infrastructure absent from the design.

Apply accepted SLICING changes. Route DESIGN findings back to the design and block only affected slices; do not solve them in the plan. Reject/defer EXPANSION unless the user broadens scope. Independent slices remain startable.

Record ACCEPT/REJECT/DEFER. Rejecting a blocker is a high-judgment decision; escalate it to the user. Keep active constraints in the main table and settled history in its append-only appendix.

Use the second pass only to verify the original blocker against changed sections and dependency edges. Do not reopen settled or unaffected work. Settled MAJOR/MINOR/QUESTION findings never justify another pass.

## 5. Verify and exit

Build the dependency graph. Confirm Slice 1 starts from current state, every later slice consumes a concrete predecessor, no hidden future work is required, deferrals preserve demos, and order matches the design.

Exit when every ready slice has a valid predecessor and demo, design findings are routed, and no applicable blocker remains. If a blocker remains, set the affected slice or plan to `Blocked` and record why. Report modified files, slice and review counts, rejected alternative, blockers/drift, readiness, plan line count, and confirmation that history was preserved.

## Checkpoints and drift

After each slice, append evidence and review only affected remaining slices plus their dependency edges; explain why others are unchanged. Never overwrite history.

Recognize a design failure, not just a slice failure, before patching around it. A single hard case is not a design failure — some problems are legitimately complex, and complexity in the data is not complexity in the design. The signal is a pattern: the same shape of trouble recurring across two or more otherwise- unrelated slices. Tells:

- The same shape of workaround appearing in unrelated slices.
- A type needing an escape hatch to compile — `any`, a cast, an "optional" field that's always set in practice.
- Reaching for a lock or mutex where the design said the state wasn't shared.
- A later slice's caller needing to know an earlier slice's internal rules to use it correctly.

When two or more tells of the same shape appear, propose a DECISIONS.md entry for the assumption the implementation disproved, so no later design tries it again. Then stop implementing and classify it as a **DESIGN** finding per the Review section's categories, even mid-slice. Route it back to `hb-design`, carrying what implementation just proved about the assumption as input to the redesign, not as vibes. Block only the slices downstream of the broken assumption; unaffected slices remain startable.

Map design changes to slices — whether from this recognition step or from user feedback. Re-run gates/review/dependencies only for affected slices, unless the change alters global scope, order, a shared foundation, or more than half the remaining slices; then reevaluate the full plan.

If drift needs its own multi-finding review to resolve, not a routine table update, write a new slicing plan in the same folder, `slices-follow-up.md` (then `slices-follow-up-2.md`, and so on), instead of forcing it into this one's Design Drift table — name the original plan it follows.

---
name: plan
description: Take one or more tech designs and produce an implementation plan — vertical slices, phases, tasks written to tasks.json
invoke: user
uses: Grilling skill
---

Take one or more tech designs and produce an implementation plan. Writes phases and tasks directly to tasks.json. One plan file per unit of work in docs/plans/.

Reads tech designs automatically. Never starts planning without a tech design — if none exists, run /tech-design first.

## When to run /plan

- After a tech design is approved
- When breaking a tech design into implementable tasks
- When the customer asks "what do we build first?"
- When a phase is complete and needs replanning

## Phase 1 — Read existing context

Before asking anything, read:
- CONTEXT.md — project vocabulary and constraints
- All referenced tech designs in docs/tech-designs/
- The specs those tech designs cover in docs/specs/
- tasks.json — existing phases and tasks to avoid duplication
- docs/prd.md — phase context (Alpha/Beta/GA)

Understand what's already planned and what's new. If tasks already exist for these specs, this is a replan session: "You have [N] tasks planned for this feature. What's changed?"

## Phase 2 — Vertical slice first

The most important planning decision: slice vertically, not horizontally.

**Horizontal phasing (wrong):**
- Phase 1: all database changes
- Phase 2: all API changes
- Phase 3: all UI changes

**Vertical slicing (right):**
- Phase 1: thin slice that works end-to-end — login flow with minimal DB, API, and UI, all working together
- Phase 2: extend the slice — add session management
- Phase 3: extend again — add password reset

A vertical slice delivers something testable and reviewable at the end of each phase. Horizontal phasing delays end-to-end feedback until the final phase.

Before writing any tasks, propose the vertical slice structure to the customer: "I'd suggest three phases — here's the thin slice for each one. Does this feel right?"

## Phase 3 — Grilling (use Grilling skill)

Run the grilling loop on genuinely open planning questions:

- **Dependencies:** what must be true before each phase can start? External dependencies? Team dependencies?
- **Risk:** which tasks are highest risk? Should they go first?
- **Testability:** how do we know each phase worked? What's the exit criterion before moving to the next phase?
- **Order:** within each phase, what's the natural sequence? What unblocks the most other tasks when done first?

## Phase 4 — Task breakdown

For each phase, break the tech design into tasks. Each task must:
- Be completable in one session (roughly half a day)
- Have enough detail that a zero-context session could pick it up and know exactly what to do
- Reference the relevant spec and tech design by path
- Have a clear done condition

Tasks that are too large get split. Tasks that are too small get merged. The right granularity is: one session, clear done.

## Phase 5 — Write to tasks.json

Write phases and tasks directly to tasks.json.

For each phase:
```json
{
  "id": "phase-00001",
  "name": "Thin vertical slice — login flow",
  "order": 1,
  "complete": false
}
```

For each task:
```json
{
  "id": "task-00001",
  "title": "Add users table with email and hashed password",
  "detail": "Schema in tech-designs/jwt-authentication.md section 2. Spec acceptance criteria in specs/login.md. Done when: migration runs, table exists, rollback works.",
  "complete": false,
  "priority": "high",
  "phase": "phase-00001",
  "order": 1,
  "created": "[today's date]",
  "completed_date": null
}
```

## Phase 6 — Write plan.md

Write a human-readable plan file alongside tasks.json. This is for the customer and team to read — tasks.json is for the system.

```markdown
# [Plan Name] — Implementation Plan

## Tech designs covered
- tech-designs/[design-a].md

## Approach
[One paragraph. Why these vertical slices in this order.
What the customer gets at the end of each phase.]

## Phases

### Phase 1 — [Name]
**Done when:** [exit criterion — specific and testable]
**Tasks:**
1. [task title] — [one-line description]
2. [task title] — [one-line description]

### Phase 2 — [Name]
**Done when:** [exit criterion]
**Tasks:**
1. [task title]

## Dependencies
[External or team dependencies that could block progress]

## Risks
[Highest-risk tasks and mitigation approach]
```

## After writing

- Confirm task count and phase structure with customer: "Written [N] tasks across [M] phases. Phase 1 delivers [what]. Want to start, or adjust anything first?"
- The implementation loop begins automatically with the first task

## The implementation loop after /plan

```
pick first incomplete task in current phase
  → simplify-pre (model-invoked, before implementation)
  → implement
  → simplify-post (model-invoked, after implementation)
  → if bug encountered: systematic-debugging (model-invoked)
  → mark task complete

all tasks in phase complete
  → test-coverage (model-invoked) — PASS before proceeding
  → security-review (model-invoked) — parallel with adversarial
  → adversarial-review (model-invoked) — BLOCK/CONCERNS/CLEAN
  → doc-sync (model-invoked) — after adversarial passes
  → mark phase complete
  → pick first task in next phase

milestone complete (Alpha/Beta/GA)
  → arch-review (model-invoked) — COHERENT/FRAGILE/NEEDS ATTENTION
  → changelog-gen (user-invoked)
  → readme-gen (model-invoked)
  → begin next milestone
```

## Living document rules

- tasks.json is the system of record — it drives the task viewer
- plan.md is the human-readable companion — keep in sync
- When implementation diverges from the plan, update both
- Never delete tasks — mark complete with completed_date

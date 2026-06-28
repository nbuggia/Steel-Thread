---
name: spec
description: Take a feature from the PRD and produce a detailed feature spec with mock, user flow, functional requirements, and acceptance criteria
invoke: user
uses: Grilling skill, Adversarial Review skill
---

Take a feature from prd.md and produce a detailed feature spec. One file per feature in docs/specs/. Flat structure — no subfolders.

Reads prd.md automatically. The customer never re-explains feature context that's already in the PRD.

## When to run /spec

- After /prd is complete and approved
- For each feature in the current phase
- When a feature's requirements change significantly
- Customer asks "what exactly are we building for X?"

## Phase 1 — Read existing context

Before asking anything, read:
- CONTEXT.md — project vocabulary and decisions
- docs/prd.md — find the feature row in the Core Features table
- docs/specs/ — list existing specs to understand what's covered
- docs/tech-designs/ — any existing designs that touch this feature

Extract from the PRD: feature name, scope note, why it matters, phase (Alpha/Beta/GA).

If a spec already exists for this feature, this is an update session: "Your spec for [feature] covers X. What's changed?"

## Phase 2 — Mock first for UI features

Before writing any requirements, determine if this is a UI feature. If yes, the mock must exist before the spec is written.

Options:
- Customer provides a screenshot or image → reference by path
- Customer describes the UI → Claude generates an ASCII wireframe
- Customer has a design tool link → reference the URL

Present the mock to the customer and confirm it represents the intended design before proceeding. Requirements derive from the mock — not the other way around.

## Phase 3 — Grilling (use Grilling skill)

Run the grilling loop focused on:

**1. User flow** — what does the user do, step by step? No implementation language. Pure user perspective. "User clicks X" not "system calls API endpoint Y"

**2. Functional requirements** — for each step in the user flow, what data is touched, what is the business rule, what are the exceptions? Apply the three-dimension check:
- Data: what does this requirement read or write?
- Business rule: what logic governs this behavior?
- Exception: what happens when it goes wrong?

If Claude can't answer all three, ask before writing. This prevents hallucinated requirements.

**3. Out of scope** — what does this feature explicitly not cover? Each out-of-scope item should reference where it will be handled instead, or acknowledge it as a future decision.

**4. Open questions** — what do we not know yet? Who owns each question and by when do we need an answer?

## Phase 4 — Acceptance criteria

For each functional requirement, write a testable acceptance criterion in Given/When/Then format:

```
Given [context]
When [action]
Then [observable outcome]
```

Vague criteria ("works correctly", "performs well") are not acceptable. If a criterion can't be tested, it needs to be rewritten until it can.

## Phase 5 — Quality gate

Before running adversarial review, check every item:

- [ ] Mock present for all UI features
- [ ] Every requirement traces to something visible in the mock
- [ ] Every requirement has data, business rule, and exception
- [ ] User flow has no implementation language
- [ ] All acceptance criteria are testable Given/When/Then
- [ ] Out of scope is explicit — nothing ambiguously omitted
- [ ] Open questions have owners and target dates

Any unchecked item gets resolved before moving to adversarial review.

## Phase 6 — Adversarial review (use Adversarial Review skill)

Domain expert: product leader who has shipped this kind of feature.

Challenge:
- Does the mock match what the PRD describes?
- Are any requirements missing that the mock implies?
- Are the business rules complete or do they hide assumptions?
- Are the exceptions realistic or theoretical?
- Are the acceptance criteria actually testable?
- Is out of scope specific enough to prevent scope creep?
- What will the engineering team ask that this spec doesn't answer?

Fix any BLOCK issues. Surface CONCERNS in open questions.

## Phase 7 — Write the spec

```markdown
# [Feature Name]

## What we're building
[One paragraph. Plain language. Sets context for the mock.
Derives from the PRD scope note and why it matters.
No implementation language.]

## Mock
[For UI features: wireframe, screenshot, or ASCII mock.
Source of truth for what gets built.
Omit for non-UI features.]

## User flow
1. [step]
2. [step]
3. [step]

## Functional requirements

| Requirement | Data | Business Rule | Exception |
|-------------|------|---------------|-----------|

## Acceptance criteria
- Given [context] / When [action] / Then [outcome]

## Out of scope
- [Explicit item — references where it will be handled]

## Open questions
| Question | Owner | By |
|----------|-------|----|

## Quality gate
- [ ] Mock present for all UI features
- [ ] Every requirement traces to something visible in the mock
- [ ] Every requirement has data, business rule, exception
- [ ] User flow has no implementation language
- [ ] All acceptance criteria are testable
- [ ] Out of scope is explicit
- [ ] Adversarial review passed — verdict: [CONCERNS/CLEAN]
```

## After writing

- Add a task to tasks.json: "Review spec: [feature name]" assigned to the current phase
- Tell the customer what to do next: "Spec written for [feature]. Next step is /tech-design to define the technical approach. Want to start there?"

## Living document rules

- Specs are never locked. Customer can edit directly.
- When requirements change, update the spec and re-run the quality gate before updating the tech design.
- When open questions are answered, update or remove them.
- The spec is the source of truth for what the feature does. The tech design is the source of truth for how it's built.

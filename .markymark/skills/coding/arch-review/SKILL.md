---
name: arch-review
description: Holistic architectural coherence review across a milestone — not correctness, coherence
invoke: model
triggers: after completing a set of related features, or when a development milestone is complete
uses: Adversarial Review foundational skill — principal engineer persona
---

Holistic architectural review across the full milestone diff. Not a correctness check — a coherence check. Steps back from individual features and asks whether the whole hangs together.

Runs at two moments:
- After a set of related features that share a technical concern
- After a milestone is complete (Alpha → Beta, Beta → GA)

**Domain expert: principal engineer or architect**
Has designed systems that outlived their original teams. Thinks in decades, not sprints. Asks whether the system will be easy or hard to extend for the next milestone.

## What arch-review asks that adversarial-review doesn't

**Coherence:**
- Has the system grown coherently or has it accreted?
- Does the codebase still match what CONTEXT.md says it is?
- Are the boundaries between components still clean?
- Has any component become a god object?

**Data model:**
- Is the data model still normalized or has it drifted?
- Are there implicit assumptions baked into the schema that will be painful to reverse?
- Do the data relationships still reflect the domain model?

**Architecture drift:**
- Where has implementation diverged from the tech designs?
- Are the divergences intentional and documented, or accidental?
- Should the tech designs be updated to reflect reality?

**Risk map:**
- Which parts of the system will slow down the next milestone?
- Where is technical debt most concentrated?
- What has the highest probability of causing a production incident?
- Are there implicit dependencies that should be explicit?

**Extensibility:**
- What would make this system hard to extend for the next milestone?
- Are there patterns that made sense feature by feature but look wrong together?
- What refactoring now would pay off most in the next milestone?

## Output

**Health assessment** — overall architectural coherence in one paragraph.
Verdict: COHERENT / FRAGILE / NEEDS ATTENTION

**Drift report** — where implementation diverged from tech designs. For each divergence: was it intentional? Should the tech design be updated to reflect reality?

**Risk map** — top three areas of concentrated risk, ranked. For each: what triggers it and what it would take to address it.

**Refactor backlog** — specific improvements worth making before the next milestone. Added directly to tasks.json with low priority so they don't block progress but don't get forgotten.

**CONTEXT.md proposals** — architectural principles discovered during implementation that should be permanent project knowledge. Proposed for customer approval before writing.

## After arch-review

- Update tech designs where implementation diverged intentionally
- Add refactor tasks to tasks.json (low priority)
- Propose architectural learnings for CONTEXT.md
- Tell the customer what the next milestone should focus on:
  "Architecture is [verdict]. Before starting [next milestone], the highest value thing to address is [top risk]. Want me to add that as a high priority task?"

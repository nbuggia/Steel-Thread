---
name: tech-design
description: Take a feature spec and produce a technical design document — approach, schema, API, alternatives, implementation notes
invoke: user
uses: Grilling skill, Adversarial Review skill, threat-model skill
---

Take a feature spec and produce a technical design document. One file per design in docs/tech-designs/. Designs may span multiple features.

Reads the relevant spec automatically. Reads CONTEXT.md for codebase conventions and constraints.

## When to run /tech-design

- After /spec is complete and approved
- Before starting implementation on any non-trivial feature
- When an approach decision needs to be documented
- When a significant change to an existing approach is needed

## Phase 1 — Read existing context

Before asking anything, read:
- CONTEXT.md — codebase conventions, tech stack, constraints
- The relevant spec(s) in docs/specs/
- Existing tech designs in docs/tech-designs/ — understand the established patterns
- tasks.json — understand what phase this belongs to

If a tech design already exists for these specs, this is an update session: "Your tech design for [feature] covers X. What's changed?"

## Phase 2 — Use Simplicity skill (pre-build mode)

Before designing anything, climb the decision ladder:
1. Does this already exist in the codebase? Reuse it.
2. Does the standard library or platform handle this? Use it.
3. Does an already-installed dependency solve it? Use it.
4. Only then: design the minimum new approach.

Document what was considered and why each was ruled out.

## Phase 3 — Grilling (use Grilling skill)

Run the grilling loop on the technical approach:

**Approach:**
- What is the simplest design that satisfies all acceptance criteria?
- Are there competing approaches worth documenting?
- What makes the chosen approach better than the alternatives?

**Schema and data:**
- What data does this feature read and write?
- How does this affect existing schema?
- Are there indexing or performance implications?

**API and interfaces:**
- What are the interfaces between components?
- What do callers need to know about this?
- What can change later without breaking callers?

**Error handling:**
- How does this fail? Does it fail safely?
- What error conditions must the caller handle?
- What does rollback or recovery look like?

**Threat model (use threat-model skill):**
Run the threat model as part of grilling. See skills/coding/threat-model/SKILL.md.

## Phase 4 — Adversarial review (use Adversarial Review skill)

Domain expert: staff engineer who has built systems at scale.

Challenge:
- Does this design actually satisfy all spec requirements?
- Does it fail safely under load, network errors, or malicious input?
- Is there a simpler design that achieves the same outcome?
- What assumptions will prove wrong in six months?
- Where does this create problems for the next milestone?

Fix any BLOCK issues before writing.

## Phase 5 — Write the tech design

```markdown
# [Feature Name] — Technical Design

## Specs covered
- docs/specs/[spec-name].md

## Approach
[One paragraph. Why this design over the alternatives.
What simplicity tradeoffs were made deliberately.]

## Alternatives considered
| Approach | Ruled out because |
|----------|-------------------|

## Schema changes
[Tables, columns, indexes added or modified.
Migration approach.]

## API / Interfaces
[Endpoints, function signatures, events.
What callers need to know.]

## Implementation notes
[Anything a zero-context engineer needs to know to implement this.
Gotchas, ordering constraints, known tradeoffs.]

## Security considerations
[From threat-model — trust boundaries, sensitive data, auth checks.
High-risk decisions flagged for security-review.]

## Deliberate shortcuts
[What was simplified and what would trigger revisiting it.
These become the // simplicity: comments in code.]

## Open questions
| Question | Owner | By |
|----------|-------|----|
```

## After writing

- Add a task to tasks.json: "Review tech design: [name]"
- Propose any architectural decisions for CONTEXT.md
- Tell the customer what to do next: "Tech design written. Next step is /plan to break this into tasks. Want to start there?"

## Living document rules

- Tech designs document intent. Implementation notes document reality.
- When implementation diverges from the design, note it in the Implementation notes section — do not silently update the approach.
- doc-sync runs after each phase and will flag unrecorded divergences.

---
name: tech-plan
description: .
invoke: model or user
---

Take a feature spec and produce a technical design document.
One file per feature in docs/tech-design/.

Reads the relevant spec automatically.
Reads CONTEXT.md for codebase context.

Domain expert: staff engineer who has built systems at scale.

Challenges: failure modes, assumptions that break under load,
simpler designs that achieve the same outcome.

## Steering Extraction

After review resolution, classify every accepted finding:

- LOCAL — applies only to this feature; keep in this tech design.
- SPEC — changes required behavior; update the relevant spec.
- CONVENTION — reusable implementation pattern; update `.claude/conventions.md`.
- DECISION — architectural tradeoff future agents must not re-litigate; update `decisions.md` or an ADR.
- REJECTED — do not document unless future agents are likely to suggest it again.

Only promote findings that constrain future work or prevent recurring mistakes.
Do not duplicate feature-local details in steering files.

-----

Before writing the tech design, read:
- the relevant feature spec
- `CONTEXT.md`
- `.claude/conventions.md`
- `decisions.md` if it exists
- any ADRs or decision records referenced by the spec, context, or conventions

The tech design must reference existing conventions and decisions instead of restating them.

Only restate a convention when:
- the feature relies on a subtle constraint that affects the design, or
- the convention is being changed, narrowed, or extended.

If the design requires a new reusable pattern, do not silently introduce it.
Mark it as a proposed convention and resolve it during adversarial review.
Accepted reusable patterns must be promoted to `.claude/conventions.md`
before the tech design is considered final.
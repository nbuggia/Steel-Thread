---
name: adversarial-review (dev extension)
description: Staff engineer review across the full phase diff — correctness, security, architecture, cross-feature integrity
invoke: model
triggers: when all tasks in a phase are marked complete
uses: Adversarial Review foundational skill + dev-specific checks
---

Extends the foundational Adversarial Review skill with dev-specific concerns. Runs across the full phase diff — not a single file, but everything built in this phase.

Base behavior defined in skills/foundational/adversarial-review/SKILL.md. Run that skill first, then apply the additional checks below.

**Domain expert: staff engineer who has built systems at scale.**
Has been paged at 3am for every category of failure below.

## Dev-specific checks (in addition to foundational steps)

**Correctness:**
- Does every spec requirement have a corresponding implementation?
- Are acceptance criteria from the specs all met?
- Are edge cases from the spec's exception column handled?

**Security:**
- Is input validated at trust boundaries?
- Is user data handled safely?
- Are there injection vectors — SQL, XSS, command injection?
- Are secrets handled correctly — never in code, never in logs?

**Architecture:**
- Does the implementation match the tech design?
- Are significant deviations documented?
- Is the phase's code consistent in approach across features?
- Has simplicity discipline been maintained?

**Cross-feature integrity:**
- Did two features independently implement the same helper?
- Are there inconsistencies in how similar problems were solved?
- Does the data model stay consistent across features?

## Verdict and next steps

- **BLOCK** — creates tasks in tasks.json, phase stays open
- **CONCERNS** — adds notes to relevant spec or tech design
- **CLEAN** — marks the phase complete in tasks.json

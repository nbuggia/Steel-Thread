---
name: prd
description: Create or update the project PRD via structured interview — problem, users, features, phasing, success metrics
invoke: user
uses: Grilling skill, Adversarial Review skill
---

Create or update the project PRD via structured interview. Use when defining what to build, scoping features, or revisiting product direction.

The PRD is a living strategic document. It defines the problem, the users, the competitive landscape, the core features, and the phasing. It does not contain implementation detail — that belongs in feature specs.

## When to run /prd

- New project with a software development component
- Significant change in product direction
- Customer asks "what should we build" or "is this the right scope"
- Before writing any feature specs

## Phase 1 — Read existing context

Before asking anything, read:
- CONTEXT.md — what the project is, vocabulary, decisions
- docs/prd.md — if it exists, understand current state
- docs/bugs/bugs.md — if it exists, what pain points have emerged

If prd.md already exists, this is an update session not a creation session. Orient accordingly: "Your PRD covers X. You have Y features in Alpha and Z in Beta. What's changed?"

## Phase 2 — Competitive research

Before grilling the customer on features, search for competitive context. Use web search to understand:
- Who else is solving this problem
- What the market leaders do well and where they fall short
- What the obvious differentiation angles are

Draft a competitive landscape table and present it to the customer for review before moving to features.
"Here's what I found — does this match your understanding? Anyone missing?"

This grounds the feature conversation in reality rather than assumptions.

## Phase 3 — Grilling (use Grilling skill)

Run the grilling loop on:

**1. The problem** — who has it, how bad is it, what does success look like. Push for specificity. "Information workers" is not specific enough. "Product managers who spend 2+ hours a day moving content between Claude and Google Docs" is.

**2. The users** — primary user first, secondary users below. For each: what is their job, what is their pain, what does a good day look like with this product.

**3. The core features** — what are the features that make or break this product? If any of these are missing, the product doesn't work. Push back on feature lists that are too long. "Which three of these, if missing, mean you have no product?"

**4. The phasing** — what is true for Alpha, Beta, GA, V2? Alpha validates the core loop. Beta validates real-world usage. GA is the product you're willing to stand behind. V2 is post-GA learnings. Backlog is explicitly not yet.

**5. Success metrics** — how do you know this worked? 2-3 measurable outcomes per phase. Not vanity metrics.

## Phase 4 — Build the features table

For each core feature, capture:

| Feature | Scope & Differentiation | Why it matters | Phase |
|---------|------------------------|----------------|-------|

Scope & Differentiation comes first. It defines what the feature actually is and what makes this implementation different from what exists. If you can't write a sharp differentiation note, the feature may not be a core feature.

Why it matters is the customer benefit — one sentence. Phase is Alpha / Beta / GA / V2 / Backlog.

## Phase 5 — Adversarial review (use Adversarial Review skill)

Before writing prd.md, run adversarial review. Domain expert: senior PM who has shipped this kind of product.

Challenge:
- Is the problem statement real and specific enough?
- Does the competitive analysis reveal a genuine gap?
- Are the core features truly make-or-break, or is this a wish list in disguise?
- Is the phasing realistic or is Alpha already a full product?
- Are the success metrics measurable or aspirational?
- What has been missed entirely?

Fix any BLOCK issues before writing. Surface CONCERNS in the open questions section.

## Phase 6 — Write prd.md

```markdown
# [Project Name] — Product Requirements Document

## Problem
[One paragraph. Who has this problem, how bad is it,
what does success look like. No solution language.]

## Users
**Primary:** [One sentence — job title, specific pain]
**Secondary:** [One sentence per additional user type]

## Competitive Landscape
| Competitor | Strength | Weakness | Our Angle |
|------------|----------|----------|-----------|

**What we do that nobody else does:**
[One clear sentence]

**What we deliberately do not compete on:**
[What we're leaving to others]

## Core Features
| Feature | Scope & Differentiation | Why it matters | Phase |
|---------|------------------------|----------------|-------|

## Phasing

**Alpha** — internal or invite-only. Validates the core loop.
Exit criteria: [what must be true before Beta]

**Beta** — limited public. Validates real-world usage.
Exit criteria: [what must be true before GA]

**GA / V1** — public launch. The product we stand behind.
Exit criteria: [what must be true before V2 planning]

**V2** — next expansion after GA learnings.
[Placeholder — details defined post-GA]

**Backlog** — explicitly not yet. Revisit after V2.
- [Item]

## Success Metrics
| Phase | Metric | Target |
|-------|--------|--------|

## Open Questions
| Question | Owner | By |
|----------|-------|----|
```

## After writing

- Add a task to tasks.json: "Review PRD with team"
- Propose any new vocabulary for CONTEXT.md
- Tell the customer what to do next: "PRD is written. Next step is /spec for [highest priority Alpha feature]. Want to start there?"

## Living document rules

- prd.md is never locked. Customer can edit it directly.
- When significant changes are made, run adversarial review again.
- When a feature moves phases, update the table and phasing section.
- When open questions are answered, update or remove them.

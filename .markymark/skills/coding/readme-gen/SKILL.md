---
name: readme-gen
description: Generates and maintains a project README from existing Steel Thread files — never manually maintained
invoke: model
triggers: at each milestone, after changelog-gen
---

Generates and maintains a project README from existing Steel Thread files. Never manually maintained — always derived from the source of truth.

## Sources

- CONTEXT.md — project summary, vocabulary, key decisions
- docs/prd.md — problem, users, core features
- docs/tech-designs/ — architecture overview
- tasks.json — current phase and what's complete
- CHANGELOG.md — recent milestone summary

## README structure

```markdown
# [Project Name]

[One paragraph from CONTEXT.md project summary]

## What it does
[From PRD problem and core features]

## Architecture
[High-level from tech designs — one paragraph]

## Current status
[From tasks.json — which milestone, what's complete]

## Getting started
[From CONTEXT.md setup conventions]

## Recent changes
[Latest milestone from CHANGELOG.md]
```

## Rules

- Never more than one screenful without scrolling
- Written for the person joining the project cold
- Updated at every milestone, not manually between milestones
- Proposes updates to the customer before writing — does not silently overwrite an existing README

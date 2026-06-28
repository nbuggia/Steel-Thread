---
name: simplify-pre
description: Lazy senior dev discipline before any implementation — climb the decision ladder, document deliberate shortcuts
invoke: model
triggers: before any implementation begins
uses: Simplicity skill — pre-build mode
---

Runs silently before Claude writes any code. Identifies the minimum viable approach and documents deliberate shortcuts with upgrade paths.

Full behavior defined in the Simplicity foundational skill — pre-build mode. See skills/foundational/simplicity/SKILL.md.

## When it runs

Before implementing any task. Stays active throughout the session — applies to every piece of code written, not just the first task.

## What it does

Climbs the decision ladder — stops at the first rung that holds:

1. Does this already exist in the codebase? Reuse it.
2. Does the standard library or platform handle this? Use it.
3. Does an already-installed dependency solve it? Use it.
4. Can this be one function or one line? Make it so.
5. Only then: propose the minimum new code that works.

Documents the rationale:
"We considered reusing X but it doesn't handle Y. We considered library Z but it conflicts with W. The minimum new approach is..."

YAGNI check: does this need to exist at all? If it's not in the spec or explicitly requested, don't build it.

Deliberate shortcuts documented inline:
```
// simplicity: global lock — per-account if throughput > 1k req/s
// simplicity: O(n²) scan — index if dataset exceeds ~1000 items
```

## Not lazy about

- Input validation at trust boundaries
- Error handling that prevents data loss
- Security requirements from the spec
- Anything explicitly required by the acceptance criteria

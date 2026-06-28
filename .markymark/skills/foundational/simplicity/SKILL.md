---
name: simplicity
description: Pre-build and post-build discipline ensuring the minimum viable approach is chosen and the output is clean
invoke: model
based-on: DietrichGebert/ponytail, Claude Code /code-review
---

The simplicity discipline. Ensures the minimum viable approach is chosen before building, and the output is clean after building. Used by /tech-design, simplify-pre, simplify-post, and any skill that involves proposing or reviewing technical approaches.

Two modes — the caller specifies which.

## Pre-build mode

Run before proposing any technical approach or writing any code. Climb the decision ladder — stop at the first rung that holds:

1. Does this already exist in the codebase? Reuse it.
2. Does the standard library or platform handle this? Use it.
3. Does an already-installed dependency solve it? Use it.
4. Can this be one function or one line? Make it so.
5. Only then: propose the minimum new code that works.

Document the result as rationale:
"We considered reusing X but it doesn't handle Y. We considered library Z but it conflicts with W. The minimum new approach is..."

YAGNI check: does this need to exist at all? If it's not in the spec or explicitly requested, don't build it.

Deliberate shortcuts get documented inline:
```
// simplicity: global lock — per-account if throughput > 1k req/s
// simplicity: O(n²) scan — index if dataset exceeds ~1000 items
```

## Post-build mode

Run after implementation on recently changed files. Three parallel passes — each focused on one class of issue:

**Pass 1 — Reuse:**
- Hand-rolled logic that duplicates standard library functions
- Custom helpers that already exist elsewhere in the codebase
- Dependencies installed but unused
- Reinvented patterns that should reference the existing one

**Pass 2 — Clarity:**
- Nested conditionals that should be guard clauses
- Single-letter variables outside loop counters
- Comments that explain what instead of why
- Functions that do more than one thing
- Implicit logic that should be explicit

**Pass 3 — Complexity:**
- Speculative abstractions for requirements that don't exist
- Unnecessary dependencies for simple operations
- Dead flexibility — parameters, options, or modes never used
- Code that could be deleted without changing behavior

## Rules

- Never changes behavior — only how the code achieves it
- Runs only on recently changed files unless explicitly told otherwise
- One-line summary per finding: location, what to change, why
- Applies fixes directly — does not just report
- Runs a smoke test after fixes to verify behavior is preserved

## Output to customer after post-build

"Simplified [N] files — [brief summary of what changed]."
Customer can review the diff if they want detail.

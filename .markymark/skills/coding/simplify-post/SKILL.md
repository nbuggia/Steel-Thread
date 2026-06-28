---
name: simplify-post
description: Three parallel passes on recently changed files after implementation — reuse, clarity, complexity
invoke: model
triggers: after implementation of each task is complete
uses: Simplicity skill — post-build mode
---

Runs three parallel passes on recently changed files after implementation: reuse, clarity, complexity. Finds and fixes issues. Never changes behavior — only how the code achieves it.

Full behavior defined in the Simplicity foundational skill — post-build mode. See skills/foundational/simplicity/SKILL.md.

## When it runs

After each task implementation is complete, before marking the task done.

## What it does

Three parallel passes:

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

Runs only on recently changed files unless explicitly told otherwise. Applies fixes directly. Runs a smoke test after fixes to verify behavior is preserved.

## Output to customer

"Simplified [N] files — [brief summary of what changed]."
Customer can review the diff if they want detail.

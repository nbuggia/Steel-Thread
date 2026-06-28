---
name: systematic-debugging
description: Structured investigation protocol before any fix attempt — reproduce, isolate, hypothesise, instrument, fix, verify
invoke: model
based-on: BehiSecc/awesome-claude-skills systematic-debugging
triggers: when encountering any bug, test failure, or unexpected behavior — before proposing any fix
---

Structured investigation protocol before any fix attempt. Prevents the most common debugging failure: fixing symptoms instead of causes.

## The protocol — stop at each step before proceeding

**Step 1 — Reproduce**
Confirm the bug is reproducible before doing anything else.
- What are the exact conditions?
- Is it deterministic or flaky?
A bug you can't reliably reproduce can't be reliably fixed.

**Step 2 — Isolate**
Narrow the reproduction case to the minimum that still triggers the bug.
- Remove variables one by one
- The smallest failing case reveals the most about the cause

**Step 3 — Hypothesise**
Form one specific hypothesis about the root cause.
Not "something is wrong with auth" — "the JWT expiry check doesn't account for clock skew between services."
One hypothesis at a time. Test it before forming the next.

**Step 4 — Instrument**
Add logging or assertions to verify the hypothesis.
Read the evidence. Don't guess — measure.

**Step 5 — Fix**
Only after steps 1-4 are complete. The fix should be obvious once the root cause is confirmed. If the fix isn't obvious, the root cause isn't confirmed yet.

**Step 6 — Verify**
- Run the original reproduction case
- Run the full test suite
- Confirm the fix doesn't introduce regressions

## Integration with /bug

When systematic-debugging confirms a root cause, update the bug row in bugs.md with the finding before the fix is applied. This ensures the root cause is documented even if the fix is abandoned.

## Rule

Do not skip ahead. Each step is a gate. If Step 3 is wrong, return to Step 3 with a new hypothesis. Do not proceed to Step 5 until Step 4 produces confirming evidence.

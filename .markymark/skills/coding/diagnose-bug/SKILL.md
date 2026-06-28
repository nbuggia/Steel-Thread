---
name: diagnose-bug
description: Root cause loop — reproduce, minimise, hypothesise, instrument, fix, regression test
invoke: user
uses: systematic-debugging skill
---

Structured bug diagnosis. Follows the systematic-debugging protocol to find the root cause before proposing any fix. Prevents the most common debugging failure: fixing symptoms instead of causes.

## Steps

Run the systematic-debugging skill in full. The steps are:

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

When used alongside the bug system:
- When systematic-debugging confirms a root cause, update the bug row in bugs.md with the finding before applying the fix
- This documents the root cause even if the fix attempt is abandoned
- After fix is verified, close the bug row with root cause and solution

## Rules

- Do not skip ahead to Step 5 — the fix is earned by completing the investigation
- If the hypothesis in Step 3 is wrong, go back to Step 3 with a new hypothesis — do not jump to Step 5
- Document every hypothesis you ruled out, not just the one that was right

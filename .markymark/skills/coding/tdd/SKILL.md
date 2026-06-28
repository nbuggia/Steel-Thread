---
name: tdd
description: Red-green-refactor loop, one vertical slice at a time
invoke: user
---

Build the feature one vertical slice at a time using the red-green-refactor loop. Do not proceed to the next slice until the current one is green and clean.

## Steps

**1. Identify the slice**
What is the smallest piece of the feature that delivers real value? Name it before writing any code.

"The first slice is: [user can do X and see Y]. That's it. Nothing else."

If the customer wants to do more, redirect: "Let's get this slice working first. We can add [other thing] next."

**2. RED — write a failing test**
Write the test for this slice before writing any implementation.

Rules for the test:
- Tests one specific behavior
- Named for what it verifies, not how it works
- Uses real data structures, not mocks, where possible
- Should fail right now — run it to confirm

Run the test. Confirm it fails for the right reason.

**3. GREEN — write minimum implementation**
Write the minimum code that makes the test pass. No more.

Before writing: use Simplicity skill (pre-build mode). Climb the decision ladder. Is there already code that does this? Use it.

Run the tests. Confirm all tests pass.

If tests don't pass, debug the implementation — not the test.

**4. REFACTOR — clean what you built**
Run Simplicity skill (post-build mode) on the changed files.

Rules:
- All tests must still pass after refactor
- No behavior changes — only how the behavior is achieved
- One-line summary of what changed

**5. Next slice**
Pick the next smallest slice. Repeat.

## Rules

- Never write implementation before a failing test
- Never write more implementation than the current test requires
- Never move to the next slice while tests are red
- Test files get the same simplicity discipline as production code
- If a slice takes more than one session, the pickup note records exactly which step of the loop you're on

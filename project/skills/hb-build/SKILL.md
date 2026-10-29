---
name: hb-build
description: Write the tests and code for a Simple or Complex task, slice by slice, from its Approved design; validate the change against its spec and design; and review the diff. Use once a task's design is Approved, when resuming work on a slice, or when asked to implement a planned change.
---

This is step 5 of `.hashbang/framework/development.md`. A Trivial change doesn't use this skill; follow Trivial Changes there. Start only from an Approved design, or an Approved slicing plan at Complex rigor.

Otherwise, work one slice at a time, or the whole design if it has no slicing plan. Before writing code, load the convention skills CONVENTIONS.md lists for the areas the slice touches, and follow a recipe when the slice makes the change it covers. For each one:

1. **Write the tests first,** at the test points the design chose, each named for the behavior it proves. Run them and confirm they fail for the right reason. For a bug, the reproduction from its diagnosis is the first test.
2. **Write the code** until those tests pass, then run the checks TESTING.md lists for the areas the slice touches, such as their tests, lint, and the formatter. Don't re-run a check on code that hasn't changed since it passed.
3. **Check it against the spec.** Every spec rule the slice covers has a test whose name states it, or a manual test.
4. **Commit the slice,** following Commits in development.md, with a message that records the evidence: the tests added, and any drift from the plan. Then checkpoint pickup.md.

**After the last slice, validate the change against its spec and design.** Run the full suite, unless TESTING.md leaves it to CI. Then list every commitment: each spec rule, limit, edge case, and contract, and each design decision a reviewer would check, such as a boundary or a persisted format. For each one, confirm the code does it, from a passing test that exercises it or from the code path itself; a test's name alone is not proof. For each mismatch, recommend one of two fixes:

- **Fix the code** when the spec is right. That is yours to do.
- **Fix the spec** when the implementation found something better, or the rule was wrong. A change users would notice is a high-judgment decision: put every such mismatch to the customer in one message, with your recommendation. Revise the spec, and send it back through review only if a use case changed.

Re-run the checks for what changed.

**Then review the diff,** at Simple and Complex rigor. Use the hb-crit skill, as a senior reviewer for this stack, on the change's whole diff against its base, with the spec and design. Fix what it finds in the code, or settle it with the customer as above, then re-run the checks. The task is ready to close when no mismatch or finding is open.

As each finding is resolved, append one line to `.hashbang/review-log.md`, creating it if needed, so the customer can later see whether the review earns its cost. Record what happened, not whether it was worth it:

```
2026-11-03 · T-012 · HIGH · No test for an empty vault · fixed
```

The outcome is one of `fixed` (the code or tests changed), `spec changed`, `rejected`, or `accepted risk`. A review with no findings gets one line with `CLEAN` in place of the severity, finding, and outcome.

Choose the kind of test by what it has to prove:

| Test | Proves | Use for |
| --- | --- | --- |
| Unit | One module's behavior, with its edges faked | Logic with many cases: parsing, calculation, state transitions |
| Integration | Real modules working together across a boundary | Persistence, IPC, APIs, file system, anything where two parts must agree |
| Automated UI | A user journey through the running product | The task's use cases, and the regressions users would notice first |

- Test what the code does from the outside, never how it does it. A test that breaks during a refactor that changes no behavior is a bad test.
- Each use case gets at least one automated UI or integration test. Unit tests alone do not prove a use case works.
- Follow the project's `docs/engineering/TESTING.md` for tools and commands, and for its validation order: which checks a change runs, and when the full suite runs. If it does not exist, propose creating it the first time you write a test, with the commands that run each kind.
- When automated testing can't reach a behavior, add a step to its product area's manual test in `docs/manual-tests/<area>.md`, from hb-dev-setup's `manual-test-template.md`, instead of skipping the check. Without one, that behavior has no lasting home.

When the diff review is clean, close the task with the hb-close skill.

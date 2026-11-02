---
name: st-verify
description: The gates around writing a Simple or Complex task's code from its Approved design — tests first, a commit per slice, validation against the spec and design, the diff review — and finishing the task by applying the design's Lasting Changes. Use once a task's design is Approved and before writing its code, when resuming work on a slice, when asked to implement a planned change, or when a task's code is done but its Lasting Changes aren't applied.
---

This is steps 5 and 6 of `.steel-thread/framework/development.md`. A Trivial change doesn't use this skill; follow Trivial Changes there. Start only from an Approved design, or an Approved slicing plan at Complex rigor.

Write the code your own way. This skill adds the checks before, between, and after. Work one slice at a time, or the whole design if it has no slicing plan, and load the convention skills CONVENTIONS.md lists for the areas the slice touches.

## Each slice

1. **Tests first,** at the test points the design chose, each named for the behavior it proves, following Testing in development.md. Run them and confirm they fail for the right reason. For a bug, the reproduction from its diagnosis is the first test.
2. **Code until they pass,** then run the checks TESTING.md lists for the areas the slice touches. Don't re-run a check on code that hasn't changed since it passed.
3. **Spec coverage:** every spec rule the slice covers has a test whose name states it, or a manual test.
4. **Commit the slice,** following Commits in development.md, then checkpoint pickup.md.
5. **Drift that changes a lasting fact,** such as a different component or boundary, a new practice, or a rejected alternative someone will propose again, gets a row in the design's Lasting Changes. Other drift goes only in the commit message.

## After the last slice

**Validate against the spec and design.** Run the full suite, unless TESTING.md leaves it to CI. List every commitment: each spec rule, limit, edge case, and contract, and each design decision a reviewer would check, such as a boundary or a persisted format. For each one, confirm the code does it, from a passing test that exercises it or from the code path itself; a test's name alone is not proof. For each mismatch:

- **Fix the code** when the spec is right. That is yours to do.
- **Fix the spec** when the implementation found something better, or the rule was wrong. A change users would notice is a high-judgment decision: put every such mismatch to the customer in one message, with your recommendation. Revise the spec, and send it back through review only if a use case changed.

**Review the diff.** Use the st-crit skill, as a senior reviewer for this stack, on the change's whole diff against its base, with the spec and design. Fix what it finds, or settle it with the customer as above, and re-run the checks for what changed.

As each finding is resolved, append one line to `.steel-thread/review-log.md`, creating it if needed, so the customer can later see whether the review earns its cost. Record what happened, not whether it was worth it:

```
2026-11-03 · T-012 · MAJOR · No test for an empty vault · fixed
```

The outcome is one of `fixed` (the code or tests changed), `spec changed`, `rejected`, or `accepted risk`. A review with no findings gets one line with `CLEAN` in place of the severity, finding, and outcome.

When no mismatch or finding is open, finish the task.

## Finish the task

This is step 6. **Skip when:** the task is Trivial, or has no work entry. A task with a work entry is not done until its design's Lasting Changes are applied.

1. **Apply the Lasting Changes.** Write each row of the design's Lasting Changes into the document it names, describing what was actually built. Create what doesn't exist yet: CONTRACTS.md from st-dev-setup's `contracts-template.md`, or the feature's PRD section in the format `.steel-thread/framework/files/prd.md` gives. Nothing else from the planning docs needs saving: the spec's rules already live in the tests and manual tests you just validated, and the evidence is in the commit messages.
2. **Get one approval.** The engineering docs are yours to update. PRD.md, BACKLOG.md, and DECISIONS.md are the customer's: propose all of this task's changes to them, and any row you'd drop, in one message.
3. **Check for links.** Search the project, outside `docs/work/`, `.steel-thread/`, and the agent's skills folder, for `docs/work` and this entry's folder name. Code, tests, lasting documents, and TASKS.md cite a task ID, D-NNN, FM-NNN, or commit instead.
4. **Mark it done** with the st-tasks skill, citing the task's last code commit, if the project uses version control, and the D- and FM- IDs the task added. Commit the lasting documents and TASKS.md (Commits in development.md).
5. **Tell the customer** in a few lines what changed in the lasting documents and what went to BACKLOG.md. Then use the st-whats-next skill to recommend the next task.

The work entry stays in `docs/work/` as history.

---
name: hb-design
description: Create a technical design before it is implemented. Assess technical complexity to recommend a designing process proportional to its risk. Use when planning a feature, bug fix, or refactor that needs a written plan before code, when asked for a tech design, design doc, or bugfix plan, or when asked whether a change is "low risk."
---

# Create Tech Design

This is step 3 of `.hashbang/framework/development.md`. This file describes the process; the rigor level you pick in step 1 decides which template you fill in. Every design belongs to one task in TASKS.md, and its file is named after that task.

## 1. Rigor Level

Check the Trivial criteria below first, they need no file reads. Only if the change doesn't clearly qualify as Trivial, read `AGENTS.md`, `docs/engineering/CONVENTIONS.md`, and `docs/engineering/ARCHITECTURE.md` in full before deciding between Simple and Complex.

Write the rigor level you chose, and which selection criteria decided it, into the output file's frontmatter (Trivial has no output file, so there's nothing to write). Never rename or move the output file afterward; TASKS.md and other documents link to it. A Simple design goes in a folder instead, as `design.md`, when the task's folder already exists, such as after a prototype.

| Rigor level | Selection Criteria                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | Examples                                                                                                                                                                                                                                                                                                                                                                                                                                                            | Template                                    | Where it's saved                          | Review budget                                      |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- | ----------------------------------------- | -------------------------------------------------- |
| Trivial     | 1\. Atomic changes without dependencies, such as cross scope references.<br>2. Wrong is obvious on sight, nothing is silently broken                                                                                                                                                                                                                                                                                                                                                                  | Changing a button's CSS color class, adjusting a margin, fixing a typo in UI copy, changing the value of a default variable.                                                                                                                                                                                                                                                                                                                                        | none                                        | nowhere — implement directly              | none                                               |
| Simple      | 1\. Scope is well understood; it follows an existing docs/engineering/CONVENTIONS.md pattern and doesn't cross a docs/engineering/ARCHITECTURE.md boundary.<br>2. Rolling back a commit undoes it completely; no lasting impact on external systems like data stores.<br>3. Correctness is fully testable — not dependent on thread interleaving, not invented as you go.<br>4. It is not more than one or two slices. <br>5. If it is a close call between multiple rigor levels, always default to “Simple" | Fixing a wrong branch in an existing command handler. Reverting the commit removes it entirely, and one test can prove both the broken and the fixed behavior. If a bug has more than one independent cause, split it into separate plans. If partway through you realize the fix actually needs Complex rigor, set the Simple plan to `Blocked` and restart it as Complex. Once the replacement exists, mark the Simple plan `Superseded` and link to it. | `templates/simple-tech-design-template.md`  | `docs/work/T-NNN-<name>.md` | 1 pass, no follow-up                               |
| Complex     | It is more complex than the selection criteria for Trivial and Simple.                                                                                                                                                                                                                                                                                                                                                                                                                                | Adding a field to the persisted settings file. Builds already shipped have already written the old shape to disk, so this can't be undone by reverting a commit, it needs Complex rigor.                                                                                                                                                                                                                                                                            | `templates/complex-tech-design-template.md` | `docs/work/T-NNN-<name>/design.md`          | 2 passes, plus at most 1 blocker-verification pass |

## 2. Load, audit, and scope

Before drafting, read the following files:

- the template for the selected rigor level
- relevant specs
- the current implementation
- the `docs/engineering/DESIGN-REVIEW-LOG.md`
- `docs/engineering/COMMON-FAILURE-MODES.md` (if missing, create from template `templates/common-failure-modes-template.md`)
- `docs/engineering/REVIEW-PATTERNS.md` (if missing, create from template `templates/review-patterns-template.md`)

Mark each entry in `docs/engineering/COMMON-FAILURE-MODES.md` Applicable / Not applicable / Checked — no issue / Accepted risk in the Failure Modes table, with evidence.

If this is a bug fix, reproduce it first — a failing test/check, or deterministic proof from source. If you can't, don't implement yet: write a diagnosis-only Slice 0, plus what would disprove your theory.

Settle the scope before you design anything. With what you just read, list the requirements this design has to meet and what each one costs: new state, a new mechanism, a boundary crossed, an assumption not yet proven. Usually a few requirements drive most of the cost. For each of those, decide whether the release needs it now, or whether it can be narrowed, or deferred to a later task without breaking the rest.

Narrowing or deferring a requirement changes what users get, so it is a high-judgment decision (see `.hashbang/framework/development.md`). Put every proposal into one question for the user. For each, say what would be cut, what it saves, and what users lose, and give your recommendation. Keep researching whatever doesn't depend on the answer. Once the user answers, write the settled scope into the design (Goals / Non-Goals, or a Simple design's Summary), update the spec for any requirement that changed, and propose a task with the hb-tasks skill for each deferred requirement. Draft only against the settled scope. At Simple rigor, this is a quick check: if one requirement costs more than all the others, raise it the same way.

## 3. Draft

Create the output file for your rigor level. If you're revising an existing one, read the whole thing first and keep its history — don't delete past sections unless you're deliberately replacing them, and say so explicitly if you do.

The template's sections aren't rigid — add one when a design produces real content none of them can hold, most often something post-implementation (outcome, drift) the pre-implementation sections were never meant to capture. Don't add one to dodge an existing section: a one-line negative answer is that section doing its job, not a gap to route around.

Trace every entry point the design touches — caller, API or IPC boundary, handler, registration, state, consumer, restore/cleanup, test — into the Operation table, with evidence.

Look for something that already solves this before building anything new. Check, in order: do you actually need it (YAGNI)? Can the standard library, a framework already in use, an installed dependency or the OS do it already? Only after all of that, consider a new, actively-maintained dependency, and then design the smallest new code that covers the gap. Record what you checked in the Alternatives table.

Judge the design by what it costs the _next_ change, not today's tidiness. Ask: harder to test? Harder to extend? Duplication and premature abstraction both fail that — pick whichever leaves the next change cheapest.

Before adding a coordinator, a framework, durable state, a replay protocol, a generic abstraction, new CI infrastructure, or more than 3 separate implementation units, explain why the smallest local fix can't meet the requirements. Reuse is never an excuse to weaken validation, data-loss prevention, security, accessibility, or anything the requirements explicitly ask for.

Keep the engineering docs current with the design, following "Where information lives" in `.hashbang/framework/development.md`: structure the design adds, such as a dependency, a boundary, a persisted format, or an external interface, goes in `docs/engineering/ARCHITECTURE.md`; a practice it introduces goes in `docs/engineering/CONVENTIONS.md`. The why goes in DECISIONS.md, cited from those docs, only when future work has to follow the design and it either can't be undone by reverting a commit, or rejects an obvious alternative for a reason that will last. Record a narrowed requirement the user accepts, and an accepted risk whose exposure outlasts this task, the same way.

Design for testability. Testable means each operation in the Operation table has a test that goes through the real boundary it crosses: an integration test, as development.md describes in step 5. A unit test with that boundary faked doesn't count. If a boundary can't be tested that way, treat it as a design problem: reshape the design so it can be, or record a manual check and the reason.

Scope can still change while you draft. If an edge case turns up that costs more than the rest of the design combined, propose narrowing it the same way as in §2. The simplification takes effect only if the user accepts it.

## 4. Review

Run the review passes your rigor level's budget calls for (§1), each in a fresh context with no memory of this conversation. Number them in order (`Pass 1`, `Pass 2`, ...; the blocker-verification pass, if used, is `Blocker verification`) and record that number in each finding's Source column (§15/§8) — this is what lets a retro compare the value of each pass. If a BLOCKER is still unresolved once that budget is spent, set the status to `Blocked`, record the reason on a `Blocked:` line, and hand it back to the user rather than running another pass; a design that can't converge in its budgeted passes usually needs rework, not more review. After the first full pass, later passes only need to check what changed plus earlier blockers — don't redo the whole review or reopen a settled finding without new evidence.

Give each reviewer: the draft, the relevant specs, the architecture and conventions docs, the failure modes that apply, and read-only repo access, plus `design-red-flags.md` at Complex rigor. Don't give them the conversation history or any reasoning that isn't written into the design itself. They should judge what the design actually says, not your explanation of it.

```text
You're a principal engineer reviewing this design before anyone implements it. You have the design, its specs, conventions, architecture, applicable failure modes, read-only repo access, and whatever else was provided. Your job is to keep it simple: built on the existing code, standards, and frameworks, testable with integration tests through every boundary it crosses, and easy to change later. Challenge the design where it falls short of that.

Don't expand the scope. Raise a finding that adds work only if it names a requirement the design fails without that work. Anything else that adds work is out of scope, however good the idea is: leave it out.

1. Check the design's claims against the actual source it cites — every table, every claimed absence — by tracing it or searching for it directly.

2. Weigh the problem against the design's size. If a rare edge case drives most of the cost, propose narrowing the requirement to remove it, not a cheaper mechanism.

3. For each finding, use the shape in `agent-review-table.md`: the evidence, a severity (BLOCKER, MAJOR, MINOR, or QUESTION), the smallest fix, and what it costs to leave unaddressed instead. If you find nothing, say so — a clean pass is a legitimate result.
```

For each finding, record a decision (ACCEPT, REJECT, or DEFER) and check it against the repo's existing guidance and specs. If it touches specs or architecture, mark that in the `Arch?` column. Decide each finding yourself and record why. Reject a finding that adds work without naming a requirement the design fails without it, and record the reason as out of scope. Escalate to the user only the high-judgment ones (see `.hashbang/framework/development.md`): a finding you would accept that expands scope or changes behavior users would notice, makes a hard-to-reverse change to architecture, persistence, IPC, or security, or that you want to reject while it is a blocker.

Once a finding is accepted, apply it everywhere in the design it affects, not just where it was raised. Keep rejected findings on record rather than deleting them. Move deferred findings into the open-questions/follow-ups section, and propose a task with the hb-tasks skill for each one that is real work. If a finding suggests a new reusable failure mode, add it as provisional until the design is Approved. Never add one for something that was rejected or deferred.

A requirement change is not a finding: record it in the spec, or in Spec Review until the spec edit lands. When a finding or requirement change makes earlier findings obsolete, mark each one `SUPERSEDED BY …` on its own row and move it, unchanged, to the design's sibling `<design>-review-history.md`, so no reviewer reading the design treats it as live. The superseding finding restates whatever survives; never split an old row.

## 5. Ready gate

The design is **not** ready for implementation if any of these are true:

- A core guarantee has no concrete mechanism, or no defined linearization point.
- An operation is missing its caller, registration, consumer, restore/cleanup step, or a test.
- An operation that crosses a boundary has no integration test, or a manual check recorded with its reason.
- The scope hasn't been settled: a requirement that drives most of the cost was never questioned.
- A major claim about the source code hasn't actually been verified.
- This is a bug fix and it's missing its reproduction proof.
- An assumption about the OS or framework hasn't been proven or spiked.
- The acceptance gate can't actually be run.
- A blocker is still unresolved or unverified.
- A spec conflict hasn't been resolved.
- A slice has no concrete predecessor or demo.
- Something driving most of the design's complexity has no recorded decision behind it.
- A high-judgment decision (from §2, §3, or §4) is still waiting on the user.

When none of these is true: set the status to `Approved`, make any provisional failure-mode/review-pattern edits final, and append this review's feedback to `docs/engineering/DESIGN-REVIEW-LOG.md`.

When you finish, report: the rigor level and which selection criteria decided it, the files touched, how many review passes ran, the slice count, any knowledge-base changes, open questions, the output file's line count, whether history was preserved or anything removed, and either "ready" or the exact thing still blocking it.

After implementation happens, only add to the file — the commit, the tests, manual evidence, any drift from the plan, and follow-ups. Never overwrite what's already there. If a Complex plan drifts during implementation, that's handled by `hb-slice`, not here.

## 6. External feedback

The user may provide feedback on the finished design, including from a review run outside this skill (e.g. an external agent). There can be more than one such pass: check the Reviewer Feedback table for existing `External N` rows and number the next one accordingly (`External 1`, `External 2`, ...).

Output the following code block directly in your reply, filled in with the path to this design's output file, so the user can copy it as-is into another agent:

```
You're a principal engineer reviewing this design before anyone implements it. You have the design, its specs, conventions, architecture, applicable failure modes, read-only repo access, and whatever else was provided. Your job is to keep it simple: built on the existing code, standards, and frameworks, testable with integration tests through every boundary it crosses, and easy to change later. Challenge the design where it falls short of that.

Don't expand the scope. Raise a finding that adds work only if it names a requirement the design fails without that work. Anything else that adds work is out of scope, however good the idea is: leave it out.

Tech Design: `{{output file path}}`
```

Log each finding the user brings back into the same Reviewer Feedback table (§15/§8) with Source set to that pass's number (e.g. `External 1`), and run it through the same decision process as §4: record ACCEPT/REJECT/DEFER, escalate only the high-judgment findings, and apply accepted findings everywhere they're relevant.

---
name: hb-tech-design
description: Create a technical design before it is implemented. Assess technical complexity to recommend a designing process proportional to its risk. Use when planning a feature, bug fix, or refactor that needs a written plan before code, when asked for a tech design, design doc, or bugfix plan, or when asked whether a change is "low risk."
tech_docs: docs/Tech Designs/
designs_dir: docs/Tech Designs/designs/
fix_plans_dir: docs/Tech Designs/simple plans/
---

# Create Tech Design

This file describes the process. The rigor level you pick in step 1 decides which template you actually fill in. `{{name}}` refers to the file paths listed in the frontmatter above.

## 1. Rigor Level

Check the Trivial criteria below first, they need no file reads. Only if the change doesn't clearly qualify as Trivial, read `CLAUDE.md`, `{{tech_docs}}CONVENTIONS.md`, `{{tech_docs}}WORKFLOW.md`, `{{tech_docs}}Architecture.md` in full before deciding between Simple and Complex.

Write the rigor level you chose, and which selection criteria decided it, into the output file's frontmatter (Trivial has no output file, so there's nothing to write). Never rename the output file or change its creation timestamp afterward.

| Rigor level | Selection Criteria                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | Examples                                                                                                                                                                                                                                                                                                                                                                                                                                                            | Template                                    | Where it's saved                          | Review budget                                      |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- | ----------------------------------------- | -------------------------------------------------- |
| Trivial     | 1\. Atomic changes without dependencies, such as cross scope references.<br>2. Wrong is obvious on sight, nothing is silently broken                                                                                                                                                                                                                                                                                                                                                                  | Changing a button's CSS color class, adjusting a margin, fixing a typo in UI copy, changing the value of a default variable.                                                                                                                                                                                                                                                                                                                                        | none                                        | nowhere — implement directly              | none                                               |
| Simple      | 1\. Scope is well understood; it follows an existing {{tech_docs}}CONVENTIONS.md pattern and doesn't cross a {{tech_docs}}Architecture.md boundary.<br>2. Rolling back a commit undoes it completely; no lasting impact on external systems like data stores.<br>3. Correctness is fully testable — not dependent on thread interleaving, not invented as you go.<br>4. It is not more than one or two slices. <br>5. If it is a close call between multiple rigor levels, always default to “Simple" | Fixing a wrong branch in an existing command handler. Reverting the commit removes it entirely, and one test can prove both the broken and the fixed behavior. If a bug has more than one independent cause, split it into separate plans. If partway through you realize the fix actually needs Complex rigor, don't keep growing the Simple plan — restart it as Complex, and drop the part that outgrew Simple instead of carrying it forward as a future slice. | `templates/simple-tech-design-template.md`  | `{{fix_plans_dir}}YYYYMMDD-HHmm-<bug>.md` | 1 pass, no follow-up                               |
| Complex     | It is more complex than the selection criteria for Trivial and Simple.                                                                                                                                                                                                                                                                                                                                                                                                                                | Adding a field to the persisted settings file. Builds already shipped have already written the old shape to disk, so this can't be undone by reverting a commit, it needs Complex rigor.                                                                                                                                                                                                                                                                            | `templates/complex-tech-design-template.md` | `{{designs_dir}}feature-name.md`          | 2 passes, plus at most 1 blocker-verification pass |

## 2. Load and audit

Before drafting, read the following files:

- the template for the selected rigor level
- relevant specs
- the current implementation
- the `{{tech_docs}}DESIGN-REVIEW-LOG.md`
- `{{tech_docs}}Common-Failure-Modes.md` (if missing, create from template `templates/common-failure-modes-template.md`)
- `{{tech_docs}}Review-Patterns.md` (if missing, create from template `templates/review-patterns-template.md`)

Mark each entry in `{{tech_docs}}Common-Failure-Modes.md` Applicable / Not applicable / Checked — no issue / Accepted risk in the Failure Modes table, with evidence.

If this is a bug fix, reproduce it first — a failing test/check, or deterministic proof from source. If you can't, don't implement yet: write a diagnosis-only Slice 0, plus what would disprove your theory.

## 3. Draft

Create the output file for your rigor level. If you're revising an existing one, read the whole thing first and keep its history — don't delete past sections unless you're deliberately replacing them, and say so explicitly if you do.

The template's sections aren't rigid — add one when a design produces real content none of them can hold, most often something post-implementation (outcome, drift) the pre-implementation sections were never meant to capture. Don't add one to dodge an existing section: a one-line negative answer is that section doing its job, not a gap to route around.

Trace every entry point the design touches — caller, IPC, handler, registration, state, consumer, restore/cleanup, test — into the Operation table, with evidence.

Look for something that already solves this before building anything new. Check, in order: do you actually need it (YAGNI)? Can the standard library, a framework already in use, an installed dependency or the OS do it already? Only after all of that, consider a new, actively-maintained dependency, and then design the smallest new code that covers the gap. Record what you checked in the Alternatives table.

Judge the design by what it costs the _next_ change, not today's tidiness. Ask: harder to test? Harder to extend? Duplication and premature abstraction both fail that — pick whichever leaves the next change cheapest.

Before adding a coordinator, a framework, durable state, a replay protocol, a generic abstraction, new CI infrastructure, or more than 3 separate implementation units, explain why the smallest local fix can't meet the requirements. Reuse is never an excuse to weaken validation, data-loss prevention, security, accessibility, or anything the requirements explicitly ask for.

Requirements are not fixed — question them if handling one edge case costs more than the rest of the design combined. Tell the user the smaller requirement that would remove that case, what they'd lose if you do, and your recommendation. That simplification only takes effect once the user has had the chance to reject it; you're proposing it, not deciding it.

## 4. Review

Run the review passes your rigor level's budget calls for (§1), each in a fresh context with no memory of this conversation. Number them in order (`Pass 1`, `Pass 2`, ...; the blocker-verification pass, if used, is `Blocker verification`) and record that number in each finding's Source column (§15/§8) — this is what lets a retro compare the value of each pass. If a BLOCKER is still unresolved once that budget is spent, stop — report it and hand it back to the user rather than running another pass; a design that can't converge in its budgeted passes usually needs rework, not more review. After the first full pass, later passes only need to check what changed plus earlier blockers — don't redo the whole review or reopen a settled finding without new evidence.

Give each reviewer: the draft, the relevant specs, the architecture and conventions docs, the failure modes that apply, and read-only repo access, plus `design-red-flags.md` at Complex rigor. Don't give them the conversation history or any reasoning that isn't written into the design itself. They should judge what the design actually says, not your explanation of it.

```text
You're a principal engineer reviewing this design before anyone implements it. You have the design, its specs, conventions, architecture, applicable failure modes, read-only repo access, and whatever else was provided. Don't suggest anything that expands the scope beyond what's needed.

1. Check the design's claims against the actual source it cites — every table, every claimed absence — by tracing it or searching for it directly.

2. Weigh the problem against the design's size. If a rare edge case drives most of the cost, propose narrowing the requirement to remove it, not a cheaper mechanism.

3. For each finding, use the shape in `agent-review-table.md`: the evidence, a severity (BLOCKER, MAJOR, MINOR, or QUESTION), the smallest fix, and what it costs to leave unaddressed instead. If you find nothing, say so — a clean pass is a legitimate result.
```

For each finding, record a decision (ACCEPT, REJECT, or DEFER) and check it against the repo's existing guidance and specs. If it touches specs or architecture, mark that in the `Arch?` column. You need the user's explicit OK before: expanding scope, or changing architecture, persistence, IPC, security, or a spec, and before rejecting any blocker.

Once a finding is accepted, apply it everywhere in the design it affects, not just where it was raised. Keep rejected findings on record rather than deleting them. Move deferred findings into the open-questions/follow-ups section. If a finding suggests a new reusable failure mode, add it as provisional until the user approves it. Never add one for something that was rejected or deferred.

A requirement change is not a finding: record it in the spec, or in Spec Review until the spec edit lands. When a finding or requirement change makes earlier findings obsolete, mark each one `SUPERSEDED BY …` on its own row and move it, unchanged, to the design's sibling `<design>-review-history.md`, so no reviewer reading the design treats it as live. The superseding finding restates whatever survives; never split an old row. Superseding a blocker needs the user's OK.

## 5. Ready gate

The design is **not** ready for implementation if any of these are true:

- A core guarantee has no concrete mechanism, or no defined linearization point.
- An operation is missing its caller, registration, consumer, restore/cleanup step, or a test.
- A major claim about the source code hasn't actually been verified.
- This is a bug fix and it's missing its reproduction proof.
- An assumption about the OS or framework hasn't been proven or spiked.
- The acceptance gate can't actually be run.
- A blocker is still unresolved or unverified.
- A spec conflict hasn't been resolved.
- A slice has no concrete predecessor or demo.
- Something driving most of the design's complexity has no recorded decision behind it.
- A required user confirmation (from §4) hasn't happened yet.

Once approved: set the status to `Ready for Implementation`, make any provisional failure-mode/review-pattern edits final, and append this review's feedback to `{{tech_docs}}DESIGN-REVIEW-LOG.md`.

When you finish, report: the rigor level and which selection criteria decided it, the files touched, how many review passes ran, the slice count, any knowledge-base changes, open questions, the output file's line count, whether history was preserved or anything removed, and either "ready" or the exact thing still blocking it.

After implementation happens, only add to the file — the commit, the tests, manual evidence, any drift from the plan, and follow-ups. Never overwrite what's already there. If a Complex plan drifts during implementation, that's handled by `slice-tech-design`, not here.

## 6. External feedback

The user may provide feedback on the finished design, including from a review run outside this skill (e.g. an external agent). There can be more than one such pass: check the Reviewer Feedback table for existing `External N` rows and number the next one accordingly (`External 1`, `External 2`, ...).

Output the following code block directly in your reply, filled in with the path to this design's output file, so the user can copy it as-is into another agent:

```
You're a principal engineer reviewing this design before anyone implements it. You have the design, its specs, conventions, architecture, applicable failure modes, read-only repo access, and whatever else was provided. Don't suggest anything that expands the scope beyond what's needed.

Tech Design: `{{output file path}}`
```

Log each finding the user brings back into the same Reviewer Feedback table (§15/§8) with Source set to that pass's number (e.g. `External 1`), and run it through the same decision process as §4: record ACCEPT/REJECT/DEFER, get the user's OK before rejecting a blocker or before it expands scope or touches architecture, persistence, IPC, security, or a spec, and apply accepted findings everywhere they're relevant.

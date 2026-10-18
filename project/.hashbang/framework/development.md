# Hashbang Development Process

How to take a feature or a bug from idea to tested code in a software project. Read this before you start a feature, a bug fix, or any change that needs more than a direct edit. You do not need it for questions, reading code, or trivial changes.

The flow is:

```
spec → prototype (optional) → tech design → slicing plan (complex designs only) → tests and code
```

Each step produces one document, the next step reads it, and the customer approves it before the next step starts. A step is skipped only when the rules below say so. When you skip one, say which and why: "This is a Simple fix, so no slicing plan."

## File Structure

```
docs/
  specs/                        ← how the product behaves today, by product area
    <area>/<feature>.md
  work/                         ← one entry per task: the change being made
    T-014-first-save-filename/  ← a folder when the work has more than one document
      prototype/
      design.md
      slices.md
    T-015-export-spaces.md      ← a single file for a Simple design
  engineering/                  ← project-wide technical reference
    Architecture.md
    CONVENTIONS.md
    testing.md
    DESIGN-REVIEW-LOG.md
    Common-Failure-Modes.md
    Review-Patterns.md
    retros/
```

Specs and work entries are kept apart because they live on different time scales:

- **A spec describes the product, and it lasts.** One spec is touched by many tasks over the project's life. It is organized by product area, never by task, so there is always one place that says how a feature works now.
- **A work entry describes one change, and it is finished when the task is.** Its prototype, design, and slicing plan explain why the code looks the way it does. Nobody needs them to learn how the product behaves; that is the spec's job.

Rules:

- A work entry is named after its task in TASKS.md: `T-NNN-<short-name>`. Task IDs never change, so the name never goes stale. Every work entry has a task; propose one if it doesn't.
- Start a work entry as a single file. Turn it into a folder only when the work needs a second document.
- Never put the source of truth for product behavior in `work/`. When a task changes behavior, the spec in `specs/` is updated as part of that task.
- Finished work entries stay where they are. TASKS.md records that the task is done; moving the files would break the links to them.
- A spec links to nothing in `work/`. A work entry links to the specs it changes.

If the project already has docs in a different layout, do not reorganize them unasked. Propose the move once, as a task, and follow the existing layout until the customer agrees.

## Document States

Every document records its state on a `status:` line in its frontmatter. A prototype records it on the first line of its README.md: `Status: Open`.

| Document | States, in order | Other states |
| --- | --- | --- |
| Spec | Draft → Approved → Current | Retired |
| Prototype | Open → Answered | |
| Tech design | Draft → In Review → Approved → Implementing → Done | Escalated, Superseded |
| Slicing plan | Draft → Approved → Implementing → Done | |
| Slice, inside a slicing plan | Pending → In Progress → Done | Blocked |

What each state means:

- **Draft** — being written. Nothing downstream may rely on it.
- **In Review** — the draft is complete and its review passes are running.
- **Approved** — the customer has approved it, and the next step can start from it. Only the customer approves; you propose the move.
- **Implementing** — code is being written against it. Change it only by appending evidence and drift, never by rewriting what was approved.
- **Done** — its task is finished. It is kept as the record of why the code looks the way it does, and is never edited again.
- **Current** — every rule in a shipped release matches the product. Rules for a later release can still be waiting to be built; they are marked by release in the spec.
- **Open / Answered** — a prototype's question is still being worked on, or its answer is written at the top of its README.md.
- **Retired** — the feature was removed from the product. The spec stays as a record.
- **Escalated** — a Simple design turned out to need Complex rigor. It stops, and a new Complex design replaces it.
- **Superseded** — implementation proved the design wrong, and a new design replaces it. Add `Superseded by <path>` under the status line.
- **Blocked** — the slice cannot proceed. Say why on the next line, starting `Blocked:`, the same as a task in TASKS.md.

Rules:

- **A step starts only from an Approved document.** A tech design is drafted from an Approved spec, and a slicing plan from an Approved design. A prototype is the exception: it can run while the spec is still Draft, because its answer often settles the spec's open questions.
- **A spec is a living document.** When a task changes a Current spec, set it back to Draft and add the task's Change History line. It is Approved once the customer approves the change, and Current again when the task ships. The rules the task doesn't touch still describe the product.
- **Going back is allowed, and must be said out loud.** If a later step shows an Approved document is wrong, set it back to Draft, tell the customer why, and block only the work that depends on the part that changed.
- **Finishing a task moves every document at once.** At the same checkpoint: the design and slicing plan become Done, the spec becomes Current, and the task is marked done in TASKS.md.

## Step 1 — Spec

**Produces:** a new or updated file in `docs/specs/<area>/`.
**Skip when:** the change does not alter anything the product's users would notice: a refactor, an internal fix, a performance change with no visible effect.

Use the hb-spec skill. It sharpens the idea to its core value, ranks the use cases and groups them into releases, splits an idea that has grown into several specs, and recommends a prototype when one would help. It recommends hb-elevate to clarify the idea and challenge the release plan, and hb-crit to review the draft before the customer approves it. Both are optional: the customer can skip either, and a small change to an existing spec usually leaves out both.

The spec says *what* and *why*, never *how*: it holds the users and the core value, what is out of scope, ranked use cases grouped into releases, and numbered rules that tests and designs cite by number. It holds no code, internal file paths, or technology choices; those belong in the tech design. External contracts that other programs or users depend on, such as URLs, file formats, and keyboard shortcuts, are behavior and belong in the spec.

Each release usually becomes a phase in TASKS.md, and each tech design covers one release or less.

## Step 2 — Prototype (optional)

**Produces:** `docs/work/T-NNN-<name>/prototype/`.
**Recommend when:** the feature creates new UI; the feature is novel and the customer can't yet say how it should behave; a complex system has more than one plausible design approach; or a technical assumption needs proof before design, such as an OS behavior, a library's limits, or a performance ceiling.
**Offer when:** the feature changes existing UI.
**Skip when:** the customer declines, or there is no UI and every behavior and technical assumption is already settled.

A prototype answers a question, and it is thrown away. Before building one, write down the question it answers. When it is done, write the answer at the top of its folder, in a `README.md`.

- **UI prototypes:** a single self-contained HTML file. When the layout is uncertain, show two or three options side by side and let the customer pick. Copy the chosen option's visible decisions (sizes, states, wording) into the spec's UI section; the spec never links to the prototype. Keep the rejected options in the prototype folder.
- **Technical prototypes (spikes):** the smallest code that proves or disproves the assumption. It never becomes production code; the tech design cites its result.

## Step 3 — Tech Design

**Produces:** `docs/work/T-NNN-<name>/design.md`, or `docs/work/T-NNN-<name>.md` for a Simple design.
**Skip when:** the change is Trivial: one obvious edit whose mistakes are visible on sight, such as a copy fix, a style value, or a default.

Use the hb-tech-design skill if it is installed. It picks a rigor level (Trivial, Simple, or Complex), fills in the matching template, and runs the review passes. Without it:

1. Read the spec, `docs/engineering/Architecture.md` and `CONVENTIONS.md`, and the code the change touches.
2. For a bug, reproduce it first, with a failing test or proof from the source. If you can't, the design starts with diagnosis, not a fix.
3. Before building anything new, check whether the code, the framework, the standard library, or an existing dependency already does it.
4. Write the design: the current state, the proposed change, the alternatives rejected and why, and the risks.
5. **Choose the test points.** Say where the change will be tested, preferring existing test points to new ones and the highest-level one that can prove the behavior. Fewer is better. Confirm them with the customer; the tests in step 5 are written against these and nowhere else.
6. Get a review in a fresh context with the hb-crit skill. The reviewer judges what the design says, not your explanation of it, and must not expand scope.

Any spec claim the design changes goes back into the spec, with the customer's approval. Do not let the design quietly redefine behavior.

## Step 4 — Slicing Plan (Complex designs only)

**Produces:** `docs/work/T-NNN-<name>/slices.md`.
**Skip when:** the design is Simple, or it fits in one or two slices.

Use the hb-slice skill if it is installed. Without it, split the design into thin vertical slices:

- Each slice delivers one outcome that can be checked on its own, through every layer it needs, and ends with a test or demo that proves it.
- Slice 1 starts from the code as it is today. Every later slice builds on a slice before it.
- Prefer few slices. Split for risk or for a useful checkpoint, never for time.
- For each slice, record what is deliberately left for later and what would prove the design wrong.

Do not copy slices into TASKS.md. The task stays the unit of work there; its detail line names the slice in progress: `Slice 2 of 4 in docs/work/T-014-first-save-filename/slices.md.`

**Watch for design failure.** If the same kind of workaround shows up in two unrelated slices, stop. That is the design being wrong, not the slice. Take what the implementation proved back to step 3, and block only the slices that depend on the broken assumption.

## Step 5 — Tests and Code

Work one slice at a time, or the whole design if it has no slicing plan. For each one:

1. **Write the tests first,** at the test points the design chose. Run them and confirm they fail for the right reason. For a bug, the reproduction from step 3 is the first test.
2. **Write the code** until those tests pass, then run the full suite.
3. **Check it against the spec.** Every spec rule the slice claims to cover has a test or a recorded demo, and the test names the rule it proves.
4. **Record the evidence** in the design or slicing plan: the commit, the tests added, and any drift from the plan. Append; never rewrite what is there.
5. **Suggest a commit message,** and checkpoint pickup.md.

Choose the kind of test by what it has to prove:

| Test | Proves | Use for |
| --- | --- | --- |
| Unit | One module's behavior, with its edges faked | Logic with many cases: parsing, calculation, state transitions |
| Integration | Real modules working together across a boundary | Persistence, IPC, APIs, file system, anything where two parts must agree |
| Automated UI | A user journey through the running product | The spec's primary use cases, and the regressions users would notice first |

- Test what the code does from the outside, never how it does it. A test that breaks during a refactor that changes no behavior is a bad test.
- Each primary use case in the spec gets at least one automated UI or integration test. Unit tests alone do not prove a use case works.
- Follow the project's `docs/engineering/testing.md` for tools and commands. If it does not exist, propose creating it the first time you write a test, with the commands that run each kind.
- When automated UI testing is not possible, say so, and record a manual demo script instead of skipping the check.

## Bugs

A bug follows the same flow with a shorter spec:

1. **Diagnose.** Reproduce the bug, find the root cause, and say how confident you are and why. If you can't reach confidence, add logging or a probe to learn more before proposing a fix. Use the hb-elevate skill to stress-test the diagnosis.
2. **Spec,** only if the correct behavior was never written down or was wrong: use the hb-spec skill to add the rule for the fixed behavior, and `SHALL CONTINUE TO` rules for what must not change.
3. **Tech design** at the rigor level the fix needs. Most bugs are Simple. A bug with more than one independent cause is more than one task.
4. **Tests and code,** starting with the failing reproduction.

## How the Skills Connect

| Step | Skill | Supporting skills |
| --- | --- | --- |
| Pick the next task | hb-whats-next | |
| Spec | hb-spec | hb-elevate to interview, hb-crit to review |
| Prototype | none yet; follow step 2 | hb-elevate to choose the question |
| Tech design | hb-tech-design | hb-elevate for scope, hb-crit for review |
| Slicing plan | hb-slice | |
| Tests and code | none yet; follow step 5 | hb-crit at the end of a Complex design |
| Improve the process | hb-retro | |

- **hb-elevate** comes before a document is written: it resolves what is unclear and stress-tests the plan.
- **hb-crit** comes after a document is written: it reviews the result before the customer approves it.
- **When a step finishes,** say what the next step is and offer to start it: "The spec is approved. Next is the tech design — want to start it?" When the last slice ships, mark the task done and use the hb-whats-next skill to recommend the next one.
- **Hashbang files stay current throughout.** Each approved document is a checkpoint for pickup.md. Hard-to-reverse choices go to DECISIONS.md, new terms to CONTEXT.md, and follow-up work to TASKS.md, each with the customer's approval.

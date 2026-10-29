# Hashbang Development Process

How to take a feature or a bug from idea to tested code. Read this before you change code: its Rigor Levels section decides how much of the process the change needs. You do not need it for questions or reading code.

This process is written for any stack. The hb-dev-setup skill tailors this project's copy, and the development skills, to its languages and platforms. If `docs/engineering/ARCHITECTURE.md` does not exist yet, run it before the first feature.

The flow is:

```
spec → prototype (optional) → tech design → slicing plan (complex designs only) → tests → code → close
```

Each step produces one document, and the next step reads it. Move through the steps on your own: a document's review is its gate, not the customer. When a step finishes, tell the customer in one line what it produced and keep going.

Stop for the customer only when the work is blocked, for one of two reasons:

- **A high-judgment decision.** The choice is hard to reverse, changes what users would notice in a way the spec does not settle, or trades off things the customer cares about with no clear winner. A choice you can make well from the spec, the code, and the project's conventions is not one of these; make it and record why.
- **Critical input.** Something only the customer can supply, such as a fact, an access, or an intent the spec leaves open, without which the next step would be a guess.

When you stop, ask one question, give your recommendation, and keep working on anything that does not depend on the answer.

A step is skipped only when the task's rigor level or the rules below say so. When you skip one, say which and why: "This is a Simple fix, so no slicing plan."

## Rigor Levels

**Every change gets a rigor level before work starts: Trivial, Simple, or Complex.** The level decides which steps run and how heavy each one is, so a one-line fix doesn't pay for a feature's process. Set it once, at the start of the task, and tell the customer in one line which criterion decided it: "This is Trivial: one comparison, and a failing test proves the fix."

Check the Trivial criteria first; they need no file reads. If the change isn't clearly Trivial, read `AGENTS.md`, `docs/engineering/ARCHITECTURE.md`, and `docs/engineering/CONTRACTS.md` before choosing between Simple and Complex.

| Rigor level | Criteria | Examples |
| --- | --- | --- |
| Trivial | All of these:<br>1. One local edit; nothing else depends on what it changes.<br>2. No promise changes, unless a bug fix restores one.<br>3. A mistake is visible on sight, or one test settles it. | A copy fix, a style value, a default. A wrong comparison in one function, with a failing test that reproduces the bug. |
| Simple | Anything that is not Trivial and hits no Complex trigger. | A save handler that skips a validation the other handlers apply. A new settings screen built from existing components and commands. |
| Complex | Any of these triggers:<br>1. **Not revertible:** it changes a persisted format or stored data, so reverting the commit can't undo it.<br>2. **Contract:** it adds or changes a promise in CONTRACTS.md, such as a file format, URL scheme, or public API.<br>3. **Structure:** it adds a component, a process or thread boundary, or a dependency, or moves a boundary in ARCHITECTURE.md.<br>4. **Risky ground:** it touches concurrency, security, or permissions.<br>5. **Not fully testable:** correctness depends on timing or on behavior invented as you go. | Adding a field to the persisted settings file. Builds already shipped wrote the old shape to disk, so reverting a commit can't undo it. |

- A close call is Simple. Choosing Complex names its trigger: "Complex: it adds a field to the settings file."
- Following an existing convention is a sign a change is Simple, not a requirement. In a new project, the first change in an area sets its conventions: record them in the design's Lasting Changes rather than raising the level.
- A bug with more than one independent cause is more than one task. Size each one.
- **Re-size when the work shows the level was wrong,** in either direction, and say so: "This touches the export format, so it's Complex now." The steps the new level adds start from there. A Trivial change that grows gets a task and a work entry; a Simple design that grows is rewritten from the Complex template.

What each level runs:

|  | Trivial | Simple | Complex |
| --- | --- | --- | --- |
| Task in TASKS.md | None; the commit is the record | Yes | Yes |
| Work entry | None | Yes | Yes |
| Spec (step 1) | None | When users would notice the change | When users would notice the change |
| Prototype (step 2) | None | When step 2 calls for one | When step 2 calls for one |
| Bug diagnosis review | None; the failing test is the proof | Only when a failing test doesn't prove the cause | Always |
| Tech design (step 3) | None | Simple template, no review pass | Complex template, two review passes, plus at most one blocker-verification pass |
| Slicing plan (step 4) | None | None; needing more than two slices is a reason to re-size | When the design needs more than two slices |
| Tests and code (step 5) | A bug's reproducing test, then the fix | Tests first, at the design's test points, then validate against the spec | Tests first, slice by slice, then validate against the spec |
| Diff review (step 5) | None | One hb-crit pass on the diff | One hb-crit pass on the diff |
| Close (step 6) | None; the commit message records the cause and the test | hb-close steps 1–4 and 6; check the rows by eye | Every hb-close step, including the searches |

## Planning Docs Are Scaffolding

**Planning docs are inputs to one task. When the task closes, everything the next change needs is in the code, the tests, and the lasting documents.** From then on, nothing relies on or links to that task's planning docs; they are kept only as history.

The planning docs are a task's spec, prototype, tech design, and slicing plan, with their review findings. While the task is open they can be rewritten freely: there is no history to keep, because none of them is a record. The close (step 6) moves everything that lasts out of them, and leaves the folder in `docs/work/` as history.

Behavior is intended or accidental:

- **Intended behavior is a promise.** Behavior is a promise if a test whose name states it checks it, a manual test covers it, CONTRACTS.md lists it, or a code comment explains it.
- **Anything else is an accident,** and can change. What a test asserts along the way, such as a snapshot or exact wording, is not a promise unless the test's name says so.

So a test's name is a behavior statement in users' terms, and a change that breaks a promise is a change users would notice.

## Where Documents Live

A task's planning docs go in its work entry, `docs/work/T-NNN-<short-name>/`, a folder named after its task in TASKS.md. Every work entry has a task; propose one with the hb-tasks skill if it doesn't. `docs/work/` holds every task's work entry, open and closed; closing a task leaves its folder in place, with a `close.md` added.

- Never search `docs/work/`. It is scaffolding, and the installer lists it in `.ignore` so search tools skip it. Open an entry only by its path: the open task you are working on, or a closed one for history — why something was built the way it was, when DECISIONS.md and the lasting documents don't say, or when the customer asks. Never use a closed entry as current behavior; current behavior is in the code, the tests, and the lasting documents.
- Nothing lasting links into `docs/work/`: no code comment, test, lasting document, or done task. Cite a task ID, D-NNN, FM-NNN, or commit instead. While a task is open, its detail line in TASKS.md may name its folder.

`.hashbang/framework/docs-layout.md` has the full layout, and which lasting document holds what: ARCHITECTURE.md, CONVENTIONS.md, CONTRACTS.md, TESTING.md, the PRD, manual tests, and the rest. Read it before you create a work entry, write a design's Lasting Changes, close a task, or edit a document in `docs/engineering/`.

## Document States

Every planning document records its state on a `status:` line in its frontmatter. Prototypes have no status: an empty or filled Answer section shows whether the question was answered.

| Document | States |
| --- | --- |
| Spec, tech design, slicing plan | Draft → Approved, or Blocked |
| Slice, inside a slicing plan | Pending → Done, or Blocked |

What each state means:

- **Draft** — being written. Nothing downstream may rely on it.
- **Approved** — it passed its review and has no open `[NEEDS DECISION]` markers, so the next step can start from it. You set it.
- **Pending** — the slice has not started.
- **Done** — the slice is finished.
- **Blocked** — the document or slice cannot proceed without the customer: a high-judgment decision or critical input. Say why on the next line, starting `Blocked:`, the same as a task in TASKS.md.

Rules:

- **A step starts only from an Approved document.** A tech design is drafted from an Approved spec, and a slicing plan from an Approved design. A prototype is the exception: it can run while the spec is still Draft, because its answer often settles the spec's open questions.
- **Going back is allowed, and must be said out loud.** If a later step shows an Approved document is wrong, revise it, set it back to Draft, tell the customer why, and block only the work that depends on the part that changed.
- **A task's documents finish together, at the close.** There is no Done state for a document: the close step moves what lasts into the lasting documents, and the folder stays behind as history.

## Step 1 — Spec

**Produces:** `docs/work/T-NNN-<name>/spec.md`, the behavior delta. **Skip when:** the task is Trivial, or the change does not alter anything the product's users would notice: a refactor, an internal fix, a performance change with no visible effect.

Use the hb-spec skill. A spec says what one task changes in user-visible behavior, and why: new rules, changed rules, and `SHALL CONTINUE TO` rules for what must not change. It never says how. External contracts such as URLs, file formats, and keyboard shortcuts are behavior; code, internal paths, and technology choices belong in the tech design.

## Step 2 — Prototype (optional)

**Produces:** `docs/work/T-NNN-<name>/prototype/`. **Build one when:** the feature creates new UI; the feature is novel and the spec can't yet say how it should behave; a complex system has more than one plausible design approach; or a technical assumption needs proof before design, such as an OS behavior, a library's limits, or a performance ceiling. **Consider one when:** the feature changes existing UI. **Skip when:** there is no UI and every behavior and technical assumption is already settled.

A prototype answers a question, and it is thrown away. Its `README.md` starts with Question and Answer sections. Write the question before building it and the answer when it is done. If the answer settles an approach for the whole product, not just this feature, propose a DECISIONS.md entry.

- **UI prototypes:** a single self-contained HTML file. When the layout is uncertain, build two or three options side by side and pick the one that best fits the spec, saying why. Ask the customer only when the options trade off something the spec does not settle. Copy the chosen option's visible decisions (sizes, states, wording) into the spec's UI section.
- **Technical prototypes (spikes):** the smallest code that proves or disproves the assumption. It never becomes production code; the tech design cites its result.

## Step 3 — Tech Design

**Produces:** `docs/work/T-NNN-<name>/design.md`. **Skip when:** the task is Trivial.

Use the hb-design skill. It fills in the template for the task's rigor level and runs that level's review passes in a fresh context. Two parts of every design feed later steps:

- **Test points.** Where the change will be tested, preferring existing test points to new ones and the highest-level one that can prove the behavior. Fewer is better. Each names the spec rules it proves, such as B.2, E.1, or a limit, and every rule needs a test point or a manual test. The tests in step 5 are written against these and nowhere else.
- **Lasting Changes.** What the design adds to ARCHITECTURE.md, CONVENTIONS.md, CONTRACTS.md, COMMON-FAILURE-MODES.md, and DECISIONS.md. The close applies them.

Any spec claim the design changes goes back into the spec and through its review. Do not let the design quietly redefine behavior; a change users would notice is a high-judgment decision.

## Step 4 — Slicing Plan (Complex designs only)

**Produces:** `docs/work/T-NNN-<name>/slices.md`. **Skip when:** the task is Trivial or Simple, or the design fits in one or two slices.

Use the hb-slice skill. It splits the design into thin vertical slices, each delivering one outcome that can be checked on its own and ending with a test or demo that proves it.

Do not copy slices into TASKS.md. The task stays the unit of work there; keep its detail line, through the hb-tasks skill, naming the slice in progress: `Slice 2 of 4 in docs/work/T-014-first-save-filename/slices.md.`

**Watch for design failure.** If the same kind of workaround shows up in two unrelated slices, stop. That is the design being wrong, not the slice. Take what the implementation proved back to step 3, propose a DECISIONS.md entry for the disproved assumption, and block only the slices that depend on it.

## Step 5 — Tests and Code

A Trivial change runs this step alone. For a bug, write the reproducing test and confirm it fails, then fix the code and run the checks TESTING.md lists for the area it touches. Suggest a commit message that names the cause and the test.

Otherwise, work one slice at a time, or the whole design if it has no slicing plan. Before writing code, load the convention skills CONVENTIONS.md lists for the areas the slice touches, and follow a recipe when the slice makes the change it covers. For each one:

1. **Write the tests first,** at the test points the design chose, each named for the behavior it proves. Run them and confirm they fail for the right reason. For a bug, the reproduction from step 3 is the first test.
2. **Write the code** until those tests pass, then run the checks TESTING.md lists for the areas the slice touches, such as their tests, lint, and the formatter. Don't re-run a check on code that hasn't changed since it passed.
3. **Check it against the spec.** Every spec rule the slice covers has a test whose name states it, or a manual test.
4. **Suggest a commit message** that records the evidence: the tests added, and any drift from the plan. Then checkpoint pickup.md.

**After the last slice, validate the change against its spec and design.** Run the full suite, unless TESTING.md leaves it to CI. Then list every commitment: each spec rule, limit, edge case, and contract, and each design decision a reviewer would check, such as a boundary or a persisted format. For each one, confirm the code does it, from a passing test that exercises it or from the code path itself; a test's name alone is not proof. For each mismatch, recommend one of two fixes:

- **Fix the code** when the spec is right. That is yours to do.
- **Fix the spec** when the implementation found something better, or the rule was wrong. A change users would notice is a high-judgment decision: put every such mismatch to the customer in one message, with your recommendation. Revise the spec, and send it back through review only if a use case changed.

Re-run the checks for what changed.

**Then review the diff,** at Simple and Complex rigor. Use the hb-crit skill, as a senior reviewer for this stack, on the change's whole diff against its base, with the spec and design. Fix what it finds in the code, or settle it with the customer as above, then re-run the checks. The task is ready to close when no mismatch or finding is open.

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

## Step 6 — Close

**Produces:** `close.md` in the work entry. **Skip when:** the task is Trivial, or has no work entry.

Use the hb-close skill as soon as the code is finished and validated against its spec. It moves everything that lasts out of the planning docs into tests, the engineering docs, the PRD, BACKLOG.md, and DECISIONS.md, and records where each piece landed in `close.md`. A task with a work entry is not done until it is closed. At Simple rigor the close is a few rows checked by eye; at Complex rigor it runs every check.

## Bugs

A bug follows the same flow with a shorter spec:

1. **Diagnose.** Reproduce the bug, find the root cause, and say how confident you are and why. If you can't reach confidence, add logging or a probe to learn more before proposing a fix.
2. **Size it,** following Rigor Levels. A one-line fix with a failing test that reproduces it is usually Trivial; most other bugs are Simple. At Complex rigor, or when a failing test doesn't prove the cause, get the diagnosis reviewed with the hb-crit skill before designing a fix.
3. **Spec,** only if the correct behavior was never a promise or the promise was wrong: use the hb-spec skill to write the rule for the fixed behavior, and `SHALL CONTINUE TO` rules for what must not change.
4. **Tech design,** unless the fix is Trivial.
5. **Tests and code,** starting with the failing reproduction.
6. **Close,** unless the fix is Trivial.

## How the Skills Connect

| Step | Skill | Supporting skills |
| --- | --- | --- |
| Tailor to the stack | hb-dev-setup | hb-elevate for open stack choices |
| Pick the next task | hb-whats-next |  |
| Spec | hb-spec | hb-crit to review, hb-elevate when blocked |
| Prototype | none yet; follow step 2 |  |
| Tech design | hb-design | hb-elevate when blocked |
| Slicing plan | hb-slice |  |
| Tests and code | none yet; follow step 5 | hb-crit to review the diff |
| Close | hb-close | hb-tasks to mark the task done, hb-crit for an optional fresh-context check |
| Improve the process | hb-retro |  |

- **hb-elevate** is for when a step is blocked: it resolves a high-judgment decision or gathers critical input with the customer in one focused session.
- **hb-crit** comes after work is written: its review is what lets a spec become Approved, and what lets a diff go to the close.
- **When a step finishes,** start the next one and say so in one line: "Spec approved after review. Starting the tech design." When the last slice ships, close the task with the hb-close skill, then use the hb-whats-next skill to recommend the next one.
- **Hashbang files stay current throughout.** Each approved document is a checkpoint for pickup.md. Choices all future work has to follow go to DECISIONS.md, new terms to CONTEXT.md, future features to BACKLOG.md, and follow-up work to TASKS.md through the hb-tasks skill, each with the customer's approval.
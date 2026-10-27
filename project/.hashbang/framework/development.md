# Hashbang Development Process

How to take a feature or a bug from idea to tested code in a software project. Read this before you change code: its Rigor Levels section decides how much of the process the change needs. You do not need it for questions or reading code.

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

Check the Trivial criteria first; they need no file reads. If the change isn't clearly Trivial, read `AGENTS.md`, `docs/engineering/CONVENTIONS.md`, and `docs/engineering/ARCHITECTURE.md` before choosing between Simple and Complex.

| Rigor level | Criteria | Examples |
| --- | --- | --- |
| Trivial | All of these:<br>1. One local edit; nothing else depends on what it changes.<br>2. No promise changes, unless a bug fix restores one.<br>3. A mistake is visible on sight, or one test settles it. | A copy fix, a style value, a default. A wrong comparison in one function, with a failing test that reproduces the bug. |
| Simple | All of these:<br>1. The scope is well understood; it follows an existing convention, in CONVENTIONS.md or a convention skill, and doesn't cross an ARCHITECTURE.md boundary.<br>2. Reverting the commit undoes it completely; nothing lasting reaches data stores, users' files, or other systems.<br>3. Correctness can be fully tested: it doesn't depend on thread interleaving, or on behavior invented as you go.<br>4. It fits in one or two slices. | A save handler that skips a validation the other handlers apply: a few edits in one component, following their pattern, and one test proves both the broken and the fixed behavior. |
| Complex | Anything that misses a Simple criterion. | Adding a field to the persisted settings file. Builds already shipped wrote the old shape to disk, so reverting a commit can't undo it. |

- A close call is Simple.
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
| Tech design (step 3) | None | Simple template, one review pass | Complex template, two review passes, plus at most one blocker-verification pass |
| Slicing plan (step 4) | None | None | When the design needs more than two slices |
| Tests and code (step 5) | A bug's reproducing test, then the fix | Tests first, at the design's test points, then validate against the spec | Tests first, slice by slice, then validate against the spec |
| Close (step 6) | None; the commit message records the cause and the test | Steps 1–4 and 6; check the rows by eye | Every step, including the searches |

## Planning Docs Are Scaffolding

**Planning docs are inputs to one task. When the task closes, everything the next change needs is in the code, the tests, and the lasting documents.** From then on, nothing relies on or links to that task's planning docs; they are kept only as history.

The planning docs are a task's spec, prototype, tech design, and slicing plan, with their review findings. While the task is open they can be rewritten freely: there is no history to keep, because none of them is a record. The close (step 6) moves everything that lasts out of them, and moves the task's folder to `docs/work-archive/`.

Behavior is intended or accidental:

- **Intended behavior is a promise.** Behavior is a promise if a test whose name states it checks it, a manual test covers it, CONTRACTS.md lists it, or a code comment explains it.
- **Anything else is an accident,** and can change. What a test asserts along the way, such as a snapshot or exact wording, is not a promise unless the test's name says so.

So a test's name is a behavior statement in users' terms, and a change that breaks a promise is a change users would notice.

## File Structure

```
docs/
  PRD.md                        ← product intent, per feature area
  manual-tests/                 ← human-run checks, by product area
    <area>.md
  work/                         ← open tasks only: one folder per task
    T-014-first-save-filename/
      spec.md                   ← the behavior delta
      prototype/
      design.md
      slices.md
    T-015-export-spaces/        ← a folder even when it holds one document
      design.md
  work-archive/                 ← closed tasks; history only
    T-009-file-conflicts/
      close.md                  ← where each lasting change landed
  engineering/                  ← project-wide technical reference
    ARCHITECTURE.md             ← what is there
    CONVENTIONS.md              ← how to make a change here
    CONTRACTS.md                ← promises to users' files and other systems
    TESTING.md                  ← how to check a change
    COMMON-FAILURE-MODES.md     ← traps hit here or known for the stack
    REVIEW-PATTERNS.md
    retros/
```

Automated tests live where the stack's tooling expects them; TESTING.md says where each kind is. PRD.md, manual tests, and CONTRACTS.md are created the first time a task needs one.

Rules:

- A work entry is named after its task in TASKS.md: `T-NNN-<short-name>`. Every work entry has a task; propose one with the hb-tasks skill if it doesn't.
- A work entry is always a folder, even when it holds a single document, so adding a second one never moves the first.
- `docs/work/` holds only open tasks. Closing a task moves its folder to `docs/work-archive/`.
- Read `docs/work-archive/` only for history: why something was built the way it was, when DECISIONS.md and the lasting documents don't say, or when the customer asks. Never use it as current behavior, and never rely on search results from it; current behavior is in the code, the tests, and the lasting documents.
- Nothing lasting links into `docs/work/` or `docs/work-archive/`: no code comment, test, lasting document, or done task. Cite a task ID, D-NNN, FM-NNN, or commit instead. While a task is open, its detail line in TASKS.md may name its folder.

### Where information lives

Each lasting document answers one question, and each fact lives in exactly one of them; the others link to it.

|  | ARCHITECTURE.md | CONVENTIONS.md | DECISIONS.md |
| --- | --- | --- | --- |
| **Answers** | What is there? | How do I make a change here? | Why is it this way, and what was rejected? |
| **Voice** | Describes: "The Rust core owns all file access." | Instructs: "Never read files from UI code; add a command." | Explains: "We chose X over Y because…" |
| **Holds** | The stack and key dependencies, components, boundaries, where state lives, data flow, persistence, and which component implements each contract | The practices every change must follow: structure, naming, error handling, state management, and boundary rules stated as rules; and the list of convention skills, with when to load each | Choices future work must follow that are expensive to undo or likely to be argued again, with what was rejected |
| **Belongs here if** | You would draw it on a diagram | A reviewer would flag a violation in a diff | Someone will propose the opposite, and the answer is "we considered that" |
| **Changes by** | Editing in place; it always describes now | Editing in place; it always describes now | Appending; an old entry is superseded, never edited |

DECISIONS.md never states the current rule; the other two do, and cite the decision for the reason. One fact can touch all three without repeating itself:

- **ARCHITECTURE.md:** "Tauri 2 app: a Rust core and a WebView UI. All file access is in the core."
- **CONVENTIONS.md:** "UI code never touches the filesystem; add a command in `commands.ts` (D-003)."
- **DECISIONS.md:** "D-003 · Tauri over Electron. Why: bundle size and memory. Rejected: Electron, which ships a second runtime."

The neighbors:

- **Tests** hold behavior. Each test's name states the behavior it proves, in users' terms, and suites are grouped by product area.
- **Manual tests** hold behavior that automation can't reach, by product area, in `docs/manual-tests/<area>.md`. A person runs them, often the customer.
- **CONTRACTS.md** holds the promises other systems and users' files rely on: file formats, on-device filenames, URL schemes, update feeds, public APIs. ARCHITECTURE.md names the component that implements each one.
- **PRD.md** holds product intent per feature area: who it is for, why it matters, what it doesn't do, and what done means. `framework/files.md` has its format.
- **Convention skills** hold the rules for one area of the code, such as UI or logging, or the steps for one recurring kind of change, such as adding a feature flag. They live in the agent's skills folder, named without the `hb-` prefix, so Hashbang updates never touch them. A skill that keeps project paths in its examples can be copied to another project on the same stack.
- **Code comments** hold the why of non-obvious code, citing D-NNN or FM-NNN. They describe the code as it is now; what a change did belongs in its commit message.
- **TESTING.md** says how to check a change: the kinds of test, where each lives, their tools, and the commands that run them.
- **COMMON-FAILURE-MODES.md** records traps the project has hit, or that its stack is known for.
- **BACKLOG.md** holds future features; **CONTEXT.md** holds the vocabulary, tenets, and never-do rules.

### Where each part of a planning doc goes

The close step uses this table. Every row lands in a lasting document, or is dropped with the customer's approval.

| Content | Lasting home |
| --- | --- |
| Spec: summary, users, why it matters | PRD feature section |
| Spec: Not Doing | PRD feature section's Not Doing |
| Spec: behavior rules and use cases | Behavior-named tests; a code comment where the behavior surprises |
| Spec: behavior automation can't reach | A manual test |
| Spec: UI sizes, states, wording | The UI code; UI tests for the states that matter |
| Spec: limits | A named constant with a comment, and a test at the edge |
| Spec: edge cases and errors | Tests; the general approach in CONVENTIONS.md |
| Spec: external contracts | CONTRACTS.md, and contract tests |
| Spec: success criteria | PRD feature section's Done Means |
| Spec: deferred use cases | BACKLOG.md |
| Design: structure, boundaries, formats | ARCHITECTURE.md |
| Design: new practices | CONVENTIONS.md, or the convention skill for their area |
| Design: rejected alternatives likely to be proposed again | DECISIONS.md |
| Design: traps found during implementation | COMMON-FAILURE-MODES.md |
| Design: rigor level and review passes | The design review log |
| Design and slices: evidence, tests added, drift | Commit messages |
| Prototype: chosen UI decisions | UI code and UI tests |
| Spike: result | DECISIONS.md or COMMON-FAILURE-MODES.md |

If the project already has docs in a different layout, do not reorganize them unasked. Propose the move once, as a task, and follow the existing layout until the customer agrees.

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
- **A task's documents finish together, at the close.** There is no Done state for a document: the close step moves what lasts into the lasting documents, then archives the folder.

## Step 1 — Spec

**Produces:** `docs/work/T-NNN-<name>/spec.md`, the behavior delta. **Skip when:** the task is Trivial, or the change does not alter anything the product's users would notice: a refactor, an internal fix, a performance change with no visible effect.

Use the hb-spec skill. A spec says what one task changes in user-visible behavior, and why: new rules, changed rules, and `SHALL CONTINUE TO` rules for what must not change. It never says how. External contracts such as URLs, file formats, and keyboard shortcuts are behavior; code, internal paths, and technology choices belong in the tech design.

Before writing a delta, hb-spec rebuilds how the product behaves today from the lasting documents and the tests. That summary goes in the spec for review, and is never kept anywhere else.

A product release usually becomes a phase in TASKS.md, and its use cases become that phase's tasks. Use cases that wait go to BACKLOG.md.

## Step 2 — Prototype (optional)

**Produces:** `docs/work/T-NNN-<name>/prototype/`. **Build one when:** the feature creates new UI; the feature is novel and the spec can't yet say how it should behave; a complex system has more than one plausible design approach; or a technical assumption needs proof before design, such as an OS behavior, a library's limits, or a performance ceiling. **Consider one when:** the feature changes existing UI. **Skip when:** there is no UI and every behavior and technical assumption is already settled.

A prototype answers a question, and it is thrown away. Its `README.md` starts with Question and Answer sections. Write the question before building it and the answer when it is done. If the answer settles an approach for the whole product, not just this feature, propose a DECISIONS.md entry.

- **UI prototypes:** a single self-contained HTML file. When the layout is uncertain, build two or three options side by side and pick the one that best fits the spec, saying why. Ask the customer only when the options trade off something the spec does not settle. Copy the chosen option's visible decisions (sizes, states, wording) into the spec's UI section.
- **Technical prototypes (spikes):** the smallest code that proves or disproves the assumption. It never becomes production code; the tech design cites its result.

## Step 3 — Tech Design

**Produces:** `docs/work/T-NNN-<name>/design.md`. **Skip when:** the task is Trivial.

Use the hb-design skill. It fills in the template for the task's rigor level and runs that level's review passes. At either level, a design must:

1. Read the spec, `docs/engineering/ARCHITECTURE.md`, `CONVENTIONS.md`, and `CONTRACTS.md`, the convention skills CONVENTIONS.md lists for the areas the change touches, and the code it touches.
2. For a bug, reproduce it first, with a failing test or proof from the source. If you can't, the design starts with diagnosis, not a fix.
3. Before building anything new, check whether the code, the framework, the standard library, or an existing dependency already does it.
4. Write the design: the current state, the proposed change, the alternatives rejected and why, and the risks.
5. **Choose the test points.** Say where the change will be tested, preferring existing test points to new ones and the highest-level one that can prove the behavior. Fewer is better. For each test point, name the spec rules it proves, such as B.2, E.1, or a limit. Every rule needs a test point or a manual test; the review treats a rule with neither as a gap. The tests in step 5 are written against these and nowhere else.
6. **List the Lasting Changes:** what the design adds to ARCHITECTURE.md, CONVENTIONS.md, CONTRACTS.md, COMMON-FAILURE-MODES.md, and DECISIONS.md. The close step applies them.
7. Get a review in a fresh context. The reviewer judges what the design says, not your explanation of it, and must not expand scope.

Any spec claim the design changes goes back into the spec and through its review. Do not let the design quietly redefine behavior; a change users would notice is a high-judgment decision.

## Step 4 — Slicing Plan (Complex designs only)

**Produces:** `docs/work/T-NNN-<name>/slices.md`. **Skip when:** the task is Trivial or Simple, or the design fits in one or two slices.

Use the hb-slice skill. It splits the design into thin vertical slices:

- Each slice delivers one outcome that can be checked on its own, through every layer it needs, and ends with a test or demo that proves it.
- Slice 1 starts from the code as it is today. Every later slice builds on a slice before it.
- Prefer few slices. Split for risk or for a useful checkpoint, never for time.
- For each slice, record what is deliberately left for later and what would prove the design wrong.

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

Re-run the checks for what changed. The task is ready to close when no mismatch is open.

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

**Produces:** `close.md` in the work entry, and the folder moved to `docs/work-archive/`. **Skip when:** the task is Trivial, or has no work entry.

Close a task as soon as its code is finished and validated against its spec (step 5). The close moves everything that lasts out of the planning docs, records where each piece landed, and archives them. A task with a work entry is not done until it is closed.

1. **List what has to last.** Read every document in the work entry. List every rule in `spec.md` (new, changed, and `SHALL CONTINUE TO`, plus its limits, edge cases, and contracts), the spec's summary, users, Not Doing, and success criteria, its deferred use cases, every row in the design's Lasting Changes, and the chosen decisions of a prototype or spike.

2. **Apply them,** following "Where each part of a planning doc goes". Most are in place once the tests and code are done; check rather than assume.

   - A rule is covered by a test whose name states it; the design's test table says which one. Rename a test whose name doesn't. A rule automation can't reach gets a manual test step. A rule whose reason isn't obvious from the code gets a comment there.
   - Contracts go in CONTRACTS.md, from hb-dev-setup's `contracts-template.md` if it doesn't exist yet.
   - The design's Lasting Changes go in the documents they name, describing what was actually built. A new practice goes in CONVENTIONS.md if every change must follow it, and otherwise in the convention skill for its area.
   - If this task repeated a multi-step change an earlier task also made, such as wiring a new setting through every layer, propose a recipe for it: a convention skill from hb-dev-setup's `convention-skill-template.md`, listed in CONVENTIONS.md.
   - The spec's intent goes in the feature's section of `docs/PRD.md`. `.hashbang/framework/files.md` says how to create the PRD.
   - Deferred use cases and follow-up ideas become BACKLOG.md rows, with this task as their Source.
   - For each rejected alternative, ask: "Will someone propose this again?" Only those that pass get a DECISIONS.md entry.

3. **Get one approval.** The engineering docs, tests, and code are yours to update. The PRD, BACKLOG.md, and DECISIONS.md are the customer's: propose all of this task's changes to them, and any new convention skill, in one message. A rule is dropped only with the customer's approval.

4. **Write** `close.md` in the work entry: one row for each item from the list, naming where it landed. A test name, a file and heading, or an ID; never a path into `docs/work/` or `docs/work-archive/`. A dropped item says so, with the reason. A task with nothing to keep says "No lasting changes." in place of the table.

   ```markdown
   # Close: T-014 Autosync at launch
   
   | Item | Landed in |
   | --- | --- |
   | Rule: sync starts within 5 seconds of launch | Test `syncs within five seconds of launch` |
   | Rule: sync state shows in the menu bar | docs/manual-tests/sync.md, "Menu bar status" |
   | Contract: on-device filename format | docs/engineering/CONTRACTS.md, "Device filenames" |
   | Lasting Change: SyncScheduler owns sync timing | docs/engineering/ARCHITECTURE.md, "Sync" |
   | Rejected: background fetch API | D-031 |
   | Intent and success criteria | docs/PRD.md, "Sync" |
   | Deferred: sync over cellular | BACKLOG.md |
   | Rule: retry banner after three failures | Dropped: the customer chose silent retries |
   ```

5. **Check it.** Fix what these find, then run them again.

   - **Trace check:** every item from the list has a row, and every row's target exists. Search the tests for each test name, find each heading in its file, and find each ID.
   - **No-link check:** search the project, outside `docs/work/`, `docs/work-archive/`, `.hashbang/`, and the agent's skills folder, for `docs/work` and this entry's folder name. Code, tests, lasting documents, and TASKS.md cite a task ID, D-NNN, FM-NNN, or commit instead.

6. **Archive and finish.** Move the work entry to `docs/work-archive/`. Mark the task done with the hb-tasks skill, citing the closing commit, if the project uses version control, and the D- and FM- IDs the task added. Tell the customer in a few lines what landed where, anything dropped, and what went to BACKLOG.md.

The close is never heavier than the task. At Simple rigor it is usually a few rows, the spec's rules and their tests: do steps 1–4 and 6, and check the rows by eye instead of running step 5's searches. At Complex rigor, do every step.

If your agent can start a subagent, you can also run a fresh-context review with the hb-crit skill: given only the lasting documents and the code, can an agent make the next change in this area and tell intended behavior from accidental? It adds confidence but never decides the close, because an agent without a subagent would be grading its own work.

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
| Tests and code | none yet; follow step 5 | hb-crit at the end of a Complex design |
| Close | none; follow step 6 | hb-tasks to mark the task done |
| Improve the process | hb-retro |  |

- **hb-elevate** is for when a step is blocked: it resolves a high-judgment decision or gathers critical input with the customer in one focused session.
- **hb-crit** comes after a document is written: its review is what lets the document become Approved.
- **When a step finishes,** start the next one and say so in one line: "Spec approved after review. Starting the tech design." When the last slice ships, close the task (step 6), then use the hb-whats-next skill to recommend the next one.
- **Hashbang files stay current throughout.** Each approved document is a checkpoint for pickup.md. Choices all future work has to follow go to DECISIONS.md, new terms to CONTEXT.md, future features to BACKLOG.md, and follow-up work to TASKS.md through the hb-tasks skill, each with the customer's approval.
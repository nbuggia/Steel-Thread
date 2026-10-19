# Hashbang Development Process

How to take a feature or a bug from idea to tested code in a software project. Read this before you start a feature, a bug fix, or any change that needs more than a direct edit. You do not need it for questions, reading code, or trivial changes.

This process is written for any stack. The hb-dev-setup skill tailors this project's copy, and the development skills, to its languages and platforms. If `docs/engineering/ARCHITECTURE.md` does not exist yet, run it before the first feature.

The flow is:

```
spec → prototype (optional) → tech design → slicing plan (complex designs only) → tests → code → UI tests
```

Each step produces one document, and the next step reads it. Move through the steps on your own: a document's review is its gate, not the customer. When a step finishes, tell the customer in one line what it produced and keep going.

Stop for the customer only when the work is blocked, for one of two reasons:

- **A high-judgment decision.** The choice is hard to reverse, changes what users would notice in a way the spec does not settle, or trades off things the customer cares about with no clear winner. A choice you can make well from the spec, the code, and the project's conventions is not one of these; make it and record why.
- **Critical input.** Something only the customer can supply, such as a fact, an access, or an intent the spec leaves open, without which the next step would be a guess.

When you stop, ask one question, give your recommendation, and keep working on anything that does not depend on the answer.

A step is skipped only when the rules below say so. When you skip one, say which and why: "This is a Simple fix, so no slicing plan."

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
    ARCHITECTURE.md             ← what is there
    CONVENTIONS.md              ← how to make a change here
    TESTING.md                  ← how to check a change
    DESIGN-REVIEW-LOG.md
    COMMON-FAILURE-MODES.md     ← traps hit here or known for the stack
    REVIEW-PATTERNS.md
    retros/
```

Specs and work entries are kept apart because they live on different time scales:

- **A spec describes the product, and it lasts.** One spec is touched by many tasks over the project's life. It is organized by product area, never by task, so there is always one place that says how a feature works now.
- **A work entry describes one change, and it is finished when the task is.** Its prototype, design, and slicing plan explain why the code looks the way it does. Nobody needs them to learn how the product behaves; that is the spec's job.

Rules:

- A work entry is named after its task in TASKS.md: `T-NNN-<short-name>`. Task IDs never change, so the name never goes stale. Every work entry has a task; propose one with the hb-tasks skill if it doesn't.
- Start a work entry as a single file. Turn it into a folder only when the work needs a second document.
- Never put the source of truth for product behavior in `work/`. When a task changes behavior, the spec in `specs/` is updated as part of that task.
- Finished work entries stay where they are. TASKS.md records that the task is done; moving the files would break the links to them.
- A spec links to nothing in `work/`. A work entry links to the specs it changes.

### Where information lives

Each lasting document answers one question, and each fact lives in exactly one of them; the others link to it.

| | ARCHITECTURE.md | CONVENTIONS.md | DECISIONS.md |
| --- | --- | --- | --- |
| **Answers** | What is there? | How do I make a change here? | Why is it this way, and what was rejected? |
| **Voice** | Describes: "The Rust core owns all file access." | Instructs: "Never read files from UI code; add a command." | Explains: "We chose X over Y because…" |
| **Holds** | The stack and key dependencies, components, boundaries, where state lives, data flow, persistence, external interfaces | The practices a change must follow: structure, naming, error handling, state management, and boundary rules stated as rules | Choices future work must follow that are expensive to undo or likely to be argued again, with what was rejected |
| **Belongs here if** | You would draw it on a diagram | A reviewer would flag a violation in a diff | Someone will propose the opposite, and the answer is "we considered that" |
| **Changes by** | Editing in place; it always describes now | Editing in place; it always describes now | Appending; an old entry is superseded, never edited |

DECISIONS.md never states the current rule; the other two do, and cite the decision for the reason. One fact can touch all three without repeating itself:

- **ARCHITECTURE.md:** "Tauri 2 app: a Rust core and a WebView UI. All file access is in the core."
- **CONVENTIONS.md:** "UI code never touches the filesystem; add a command in `commands.ts` (D-003)."
- **DECISIONS.md:** "D-003 · Tauri over Electron. Why: bundle size and memory. Rejected: Electron, which ships a second runtime."

The neighbors:

- **A spec** says what the product does for users. It defines external contracts, such as file formats, URL schemes, and public APIs, as behavior; ARCHITECTURE.md lists each one, names the component that implements it, and links to the spec.
- **A work entry** explains why one change looks the way it does. What lasts from it moves into the documents above when the task finishes.
- **TESTING.md** says how to check a change: the kinds of test, their tools, and the commands that run them.
- **COMMON-FAILURE-MODES.md** records traps the project has hit, or that its stack is known for.
- **CONTEXT.md** holds the project's vocabulary, tenets, and never-do rules, which are not technical.

If the project already has docs in a different layout, do not reorganize them unasked. Propose the move once, as a task, and follow the existing layout until the customer agrees.

## Document States

Every durable planning document records its state on a `status:` line in its frontmatter. Prototypes have no status: an empty or filled Answer section shows whether the question was answered.

| Document | States, in order | Other states |
| --- | --- | --- |
| Spec | Draft → Approved | Retired |
| Tech design | Draft → Approved → Done | Blocked, Superseded |
| Slicing plan | Draft → Approved → Done | Blocked |
| Slice, inside a slicing plan | Pending → Done | Blocked |

What each state means:

- **Draft** — being written. Nothing downstream may rely on it.
- **Approved** — it passed its review and has no open `[NEEDS DECISION]` markers, so the next step can start from it. You set it.
- **Pending** — the slice has not started.
- **Done** — the task or slice is finished. A Done document is kept as the record of why the code looks the way it does, and is never edited again.
- **Retired** — the feature was removed from the product. The spec stays as a record.
- **Superseded** — implementation proved the design wrong, and a new design replaces it. Add `Superseded by <path>` under the status line.
- **Blocked** — the design, plan, or slice cannot proceed without the customer: a high-judgment decision or critical input. Say why on the next line, starting `Blocked:`, the same as a task in TASKS.md. If a Simple design needs Complex rigor, block it; once its replacement exists, mark it Superseded and link to the replacement.

Rules:

- **A step starts only from an Approved document.** A tech design is drafted from an Approved spec, and a slicing plan from an Approved design. A prototype is the exception: it can run while the spec is still Draft, because its answer often settles the spec's open questions.
- **A spec is a living document.** When a task changes an Approved spec, set it back to Draft and add the task's Change History line. It is Approved again once the change passes review. Release completion dates record what has shipped, and the rules the task doesn't touch still describe the product.
- **Going back is allowed, and must be said out loud.** If a later step shows an Approved document is wrong, set it back to Draft, tell the customer why, and block only the work that depends on the part that changed.
- **Finishing a task moves every document at once.** At the same checkpoint: what lasts from the design moves into ARCHITECTURE.md, CONVENTIONS.md, or DECISIONS.md, and they describe what was actually built; the design and slicing plan become Done; the spec records the release's completion date; and the task is marked done with the hb-tasks skill.

## Step 1 — Spec

**Produces:** a new or updated file in `docs/specs/<area>/`. **Skip when:** the change does not alter anything the product's users would notice: a refactor, an internal fix, a performance change with no visible effect.

Use the hb-spec skill. A spec defines user-visible behavior and why it matters, never its implementation. External contracts such as URLs, file formats, and keyboard shortcuts are behavior; code, internal paths, and technology choices belong in the tech design.

Each release usually becomes a phase in TASKS.md, and each tech design covers one release or less.

## Step 2 — Prototype (optional)

**Produces:** `docs/work/T-NNN-<name>/prototype/`. **Build one when:** the feature creates new UI; the feature is novel and the spec can't yet say how it should behave; a complex system has more than one plausible design approach; or a technical assumption needs proof before design, such as an OS behavior, a library's limits, or a performance ceiling. **Consider one when:** the feature changes existing UI. **Skip when:** there is no UI and every behavior and technical assumption is already settled.

A prototype answers a question, and it is thrown away. Its `README.md` starts with Question and Answer sections. Write the question before building it and the answer when it is done. If the answer settles an approach for the whole product, not just this feature, propose a DECISIONS.md entry.

- **UI prototypes:** a single self-contained HTML file. When the layout is uncertain, build two or three options side by side and pick the one that best fits the spec, saying why. Ask the customer only when the options trade off something the spec does not settle. Copy the chosen option's visible decisions (sizes, states, wording) into the spec's UI section; the spec never links to the prototype. Keep the rejected options in the prototype folder.
- **Technical prototypes (spikes):** the smallest code that proves or disproves the assumption. It never becomes production code; the tech design cites its result.

## Step 3 — Tech Design

**Produces:** `docs/work/T-NNN-<name>/design.md`, or `docs/work/T-NNN-<name>.md` for a Simple design. **Skip when:** the change is Trivial: one obvious edit whose mistakes are visible on sight, such as a copy fix, a style value, or a default.

Use the hb-design skill. It picks a rigor level (Trivial, Simple, or Complex), fills in the matching template, and runs the review passes. Whatever the rigor level, a design must:

1. Read the spec, `docs/engineering/ARCHITECTURE.md` and `CONVENTIONS.md`, and the code the change touches.
2. For a bug, reproduce it first, with a failing test or proof from the source. If you can't, the design starts with diagnosis, not a fix.
3. Before building anything new, check whether the code, the framework, the standard library, or an existing dependency already does it.
4. Write the design: the current state, the proposed change, the alternatives rejected and why, and the risks.
5. **Choose the test points.** Say where the change will be tested, preferring existing test points to new ones and the highest-level one that can prove the behavior. Fewer is better. The tests in step 5 are written against these and nowhere else.
6. Get a review in a fresh context. The reviewer judges what the design says, not your explanation of it, and must not expand scope.

Any spec claim the design changes goes back into the spec and through its review. Do not let the design quietly redefine behavior; a change users would notice is a high-judgment decision.

## Step 4 — Slicing Plan (Complex designs only)

**Produces:** `docs/work/T-NNN-<name>/slices.md`. **Skip when:** the design is Simple, or it fits in one or two slices.

Use the hb-slice skill. It splits the design into thin vertical slices:

- Each slice delivers one outcome that can be checked on its own, through every layer it needs, and ends with a test or demo that proves it.
- Slice 1 starts from the code as it is today. Every later slice builds on a slice before it.
- Prefer few slices. Split for risk or for a useful checkpoint, never for time.
- For each slice, record what is deliberately left for later and what would prove the design wrong.

Do not copy slices into TASKS.md. The task stays the unit of work there; keep its detail line, through the hb-tasks skill, naming the slice in progress: `Slice 2 of 4 in docs/work/T-014-first-save-filename/slices.md.`

**Watch for design failure.** If the same kind of workaround shows up in two unrelated slices, stop. That is the design being wrong, not the slice. Take what the implementation proved back to step 3, propose a DECISIONS.md entry for the disproved assumption, and block only the slices that depend on it.

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
| Automated UI | A user journey through the running product | The current release's use cases, and the regressions users would notice first |

- Test what the code does from the outside, never how it does it. A test that breaks during a refactor that changes no behavior is a bad test.
- Each use case in the current release gets at least one automated UI or integration test. Unit tests alone do not prove a use case works.
- Follow the project's `docs/engineering/TESTING.md` for tools and commands. If it does not exist, propose creating it the first time you write a test, with the commands that run each kind.
- When automated UI testing is not possible, say so, and record a manual demo script instead of skipping the check.

## Bugs

A bug follows the same flow with a shorter spec:

1. **Diagnose.** Reproduce the bug, find the root cause, and say how confident you are and why. If you can't reach confidence, add logging or a probe to learn more before proposing a fix. Get the diagnosis reviewed with the hb-crit skill before designing a fix.
2. **Spec,** only if the correct behavior was never written down or was wrong: use the hb-spec skill to add the rule for the fixed behavior, and `SHALL CONTINUE TO` rules for what must not change.
3. **Tech design** at the rigor level the fix needs. Most bugs are Simple. A bug with more than one independent cause is more than one task.
4. **Tests and code,** starting with the failing reproduction.

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
| Improve the process | hb-retro |  |

- **hb-elevate** is for when a step is blocked: it resolves a high-judgment decision or gathers critical input with the customer in one focused session.
- **hb-crit** comes after a document is written: its review is what lets the document become Approved.
- **When a step finishes,** start the next one and say so in one line: "Spec approved after review. Starting the tech design." When the last slice ships, mark the task done and use the hb-whats-next skill to recommend the next one.
- **Hashbang files stay current throughout.** Each approved document is a checkpoint for pickup.md. Choices all future work has to follow go to DECISIONS.md, new terms to CONTEXT.md, and follow-up work to TASKS.md through the hb-tasks skill, each with the customer's approval.
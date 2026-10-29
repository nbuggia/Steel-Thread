# Hashbang Docs Layout

Where the project's documents live, and what each lasting one holds. Read this before you create a work entry, write a design's Lasting Changes, close a task, or create or edit a document in `docs/engineering/`. The process that produces these documents is in `.hashbang/framework/development.md`.

## File Structure

```
docs/
  PRD.md                        ← the objective, and product intent per feature area
  CONTEXT.md, TASKS.md, BACKLOG.md, DECISIONS.md
  manual-tests/                 ← human-run checks, by product area
    <area>.md
  work/                         ← scaffolding, never searched: one folder per task
    T-014-first-save-filename/
      spec.md                   ← the behavior delta
      prototype/
      design.md
      slices.md
    T-015-export-spaces/        ← a folder even when it holds one document
      design.md
    T-009-file-conflicts/       ← a closed task; history only
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

Automated tests live where the stack's tooling expects them; TESTING.md says where each kind is. Manual tests and CONTRACTS.md are created the first time a task needs one.

Rules:

- A work entry is named after its task in TASKS.md: `T-NNN-<short-name>`. Every work entry has a task; propose one with the hb-tasks skill if it doesn't.
- A work entry is always a folder, even when it holds a single document, so adding a second one never moves the first.
- `docs/work/` holds every task's work entry, open and closed. Closing a task leaves its folder in place, with a `close.md` added.
- Never search `docs/work/`. It is scaffolding, and the installer lists it in `.ignore` so search tools skip it. Open an entry only by its path: the open task you are working on, or a closed one for history — why something was built the way it was, when DECISIONS.md and the lasting documents don't say, or when the customer asks. Never use a closed entry as current behavior; current behavior is in the code, the tests, and the lasting documents.
- Nothing lasting links into `docs/work/`: no code comment, test, lasting document, or done task. Cite a task ID, D-NNN, FM-NNN, or commit instead. While a task is open, its detail line in TASKS.md may name its folder.

## Where information lives

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
- **PRD.md** holds the objective, and product intent per feature area: who it is for, why it matters, what it doesn't do, and what done means. `framework/files.md` has its format.
- **Convention skills** hold the rules for one area of the code, such as UI or logging, or the steps for one recurring kind of change, such as adding a feature flag. They live in the agent's skills folder, named without the `hb-` prefix, so Hashbang updates never touch them. A skill that keeps project paths in its examples can be copied to another project on the same stack.
- **Code comments** hold the why of non-obvious code, citing D-NNN or FM-NNN. They describe the code as it is now; what a change did belongs in its commit message.
- **TESTING.md** says how to check a change: the kinds of test, where each lives, their tools, and the commands that run them.
- **COMMON-FAILURE-MODES.md** records traps the project has hit, or that its stack is known for.
- **BACKLOG.md** holds future features; **CONTEXT.md** holds the vocabulary, tenets, and never-do rules.

If the project already has docs in a different layout, do not reorganize them unasked. Propose the move once, as a task, and follow the existing layout until the customer agrees.

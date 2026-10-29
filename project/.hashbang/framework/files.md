# Hashbang Files — Formats and Rules

How to write and maintain each Hashbang file. Read this before you first create or edit one of them in a session. The customer's files live in `docs/`, and Hashbang's working files in `.hashbang/`; paths are from the project root. Starter files are in `.hashbang/framework/templates/`.

## docs/PRD.md

The PRD holds the product's intent: why it exists, what done means, and for each feature area, who it is for and why it matters. Its sections above the first feature are the project's objective: short enough to read at every session start, and changed rarely.

### Format

```markdown
# Product: Markymark

## Outcome
## Done Means
## Not Doing
## Constraints

## Feature: Sync

**For:** writers who edit the same vault on two machines.
**Why it matters:** they never merge two versions of a note by hand.

### Not Doing
- Real-time co-editing — one writer per vault.

### Done Means
- A note edited offline appears on the other machine within a minute of reconnecting.

### Flows
- Spans Search: a synced note is searchable as soon as it lands.
```

- **Outcome** — one paragraph: what the product does, for whom, and why it matters.
- **Done Means** — testable criteria, not activities. "A writer's edit on one machine appears on the other within a minute," not "build sync."
- **Not Doing** — at least two things that are explicitly out of scope, and why. An objective with nothing out of scope has not been scoped.
- **Constraints** — deadlines, platforms, budgets, anything that cannot change. Leave it out if there are none.
- One `## Feature:` section per product area, named the way the product names it. Feature sections are read on demand, when work touches the area.
- **Flows** lists behavior that spans features, and names the other feature. Leave out any subsection with nothing in it.
- The PRD holds intent, not behavior rules. Rules live in tests, manual tests, and CONTRACTS.md (see `.hashbang/framework/docs-layout.md`).

### Creating and changing it

The hb-whats-next skill writes the objective during setup, from `.hashbang/framework/templates/PRD.md`. The close (the hb-close skill) adds a feature section the first time a task adds a feature.

- Change the objective when the customer changes direction, scope, or what done means. Every change to it also gets a DECISIONS.md entry recording what changed and why.
- Feature sections change when a task closes, approved with the rest of that task's changes to the customer's files. They need a DECISIONS.md entry only when the change meets DECISIONS.md's bar.
- An older install may have `docs/OBJECTIVE.md`. Propose moving its sections into the PRD, and delete it in the same approved change.

### When the PRD already exists elsewhere

Before offering to write an objective, look for one the project already has, and use the first that exists: `PRD.md`, `.claude/PRD.md`, `.kiro/steering/product.md`, then `OBJECTIVE.md` at the project root. Match file names in any case.

If you find one, write `docs/PRD.md` as a pointer to it, and tell the customer in one line: "Using PRD.md as this project's objective." Don't interview to fill in sections it lacks. Feature sections go in the file it points to.

```markdown
# Product

This project's PRD lives in `PRD.md`. Read that instead.
```

### When the customer skips the objective

If no objective exists and the customer declines to write one, or doesn't take up the offer in the session it was made, write the PRD in the skipped form. Then never offer it again; the customer can ask for it. Feature sections still go below it.

```markdown
# Product: Markymark

Objective not set. The customer chose not to write one (YYYY-MM-DD). Don't offer it again.
```

When they later ask for one, replace that line with the objective's sections. Pointer and skipped forms need no DECISIONS.md entry.

---

## docs/TASKS.md

Change TASKS.md only through the hb-tasks skill, which holds its format and rules.

---

## docs/BACKLOG.md

BACKLOG.md holds the features the product may get later: deferred use cases, follow-up ideas, and requests that aren't committed work yet. Committed work is in TASKS.md. It is not read at session start, only when planning a release or closing a phase.

### Format

```markdown
# Backlog

| Feature | Release | Why | Source |
| --- | --- | --- | --- |
| Search inside closed files | Next | Search stops at open files today | T-031 |
| Vault-wide replace | Next | Most-requested after search | customer |
| Export to PDF | Later | Beta users share drafts as PDF | customer |
```

- **Release** is `Next` or `Later`. Next rows come first; Later rows are in no order.
- **Source** is the task that deferred the feature, or `customer`. It keeps a deferred requirement from quietly disappearing.

### Rules

- It is the customer's file: change it only with their approval. New rows go in as Later unless the customer says Next.
- "Maybe later" belongs here; "never" belongs in the PRD's Not Doing, for the product or the feature.
- When a feature becomes tasks in TASKS.md, delete its row. Rows are never marked done in place.
- Create it from `.hashbang/framework/templates/BACKLOG.md` the first time a row is added.

---

## docs/DECISIONS.md

DECISIONS.md is the log of why: the reasoning behind choices that all future work has to follow, and what was rejected. It answers "why is it like this?" so the customer never has to reconstruct it, and so no session re-litigates a settled question by accident. It is the project's ADR log; don't keep architecture decision records anywhere else.

### Format

Newest entry first:

```markdown
## D-002 · US zip codes only · 2026-10-06
Status: Active
Context: --zip needed a scope; non-US postal codes need a different frost-date source.
Decision: Support US 5-digit zip codes only.
Why: Matches the objective; international users are listed under Not Doing.
Rejected: Any postal code with a fallback lookup — needs a second data source.
Affects: T-003, PRD.md
```

- IDs are `D-` plus three digits. A new decision takes the highest existing ID plus one; IDs are never reused.
- Status is `Active` or `Superseded by D-NNN`.
- `Rejected` and `Affects` can be omitted when there is nothing to say.

### Rules

- Entries are never edited or deleted. When a decision changes, add a new entry and change only the old entry's Status line to `Superseded by D-NNN`.
- Record a decision only if future work has to follow it, and it is also expensive to undo or likely to be proposed the other way later. A choice that shapes only the current task stays in the document where it was made: its spec, design, or slicing plan.
- Planning docs are scaffolding that nothing reads once their task closes, so DECISIONS.md is the only lasting home for a rejected alternative. The close asks of each one: "Will someone propose this again?" and proposes all of a task's entries in one approval.
- Code comments, lasting documents, and done tasks cite decisions by ID: "(D-003)".
- DECISIONS.md never states the current rule. The rule lives where it applies — CONTEXT.md, or the documents in `.hashbang/framework/docs-layout.md`'s "Where information lives" — and cites the decision for the reason: "UI code never touches the filesystem (D-003)."

---

## docs/CONTEXT.md

CONTEXT.md holds the standing rules for how to work on this project.

### What belongs in it

- **Vocabulary** — defined terms and aliases to avoid. This is the most important section. When a term is defined here, use it precisely everywhere.
- **Tenets** — the principles the customer applies when good options conflict: "Correctness beats speed." They let you settle questions the customer would otherwise have to answer. Tenets are discovered through the hb-elevate skill, not asked for up front. A tenet is a principle for settling future choices; one specific choice is a decision, and goes in DECISIONS.md.
- **What the agent should never do** — explicit constraints. These are absolute.

What the project is for belongs in the PRD. How the code is built belongs in `docs/engineering/` (see `.hashbang/framework/docs-layout.md`). Why a rule exists belongs in DECISIONS.md.

### When context already exists elsewhere

If the project root has a `CONTEXT.md`, write CONTEXT.md as a pointer to it, the same way as the PRD, instead of capturing context again.

### When to update it

- When a new term is used that isn't defined
- When a new constraint is agreed — log the decision behind it in DECISIONS.md if it is hard to reverse
- When an hb-elevate session surfaces a tenet that applies beyond the work at hand

---

## .hashbang/pickup.md

### Format

```markdown
# Pickup Note

Session: S-012 · 2026-10-09

## Accomplished
## In Flight
## Blocked
## Up Next
## Suggested Start
## Proposed Updates
```

### What each section holds

- **Accomplished** — what was done this session, verified, not assumed.
- **In Flight** — the exact state of work in progress: which task, the files and locations involved, what is done, what is left, the very next step, and any open questions. Write it so a cold reader could resume mid-task without asking anything.
- **Blocked** — what is blocked and what would unblock it.
- **Up Next** — what the customer said they want to do next.
- **Suggested Start** — where the next session should begin.
- **Proposed Updates** — changes to propose for the customer's files that the customer has not yet approved.

### Rules

- The `Session:` line identifies the note. IDs are `S-` plus three digits: the newest ID in `.hashbang/history/pickup-history.md` plus one, or S-001 when there is no history.
- Leave out any section with nothing in it.
- Reference tasks and decisions by ID (T-003, D-002) and files by path. Do not duplicate content already in the other Hashbang files.

---

## .hashbang/history/pickup-history.md

The log of past sessions, newest first.

### Format

```markdown
# Session History

## S-012 · 2026-10-09

### Accomplished
Finished the frost offset in calculate_window() (T-002).

### Suggested Start
Add the crop lookup table to src/window.py.

## S-011 · 2026-10-06
…
```

### Rules

- To archive a pickup note, copy it into a new entry directly under the `# Session History` heading: its Session line becomes the `## S-NNN · YYYY-MM-DD` heading, and its sections become `###` headings, copied as written.
- Archive a note only if its session ID is not already in the file. This makes archiving safe to repeat.
- Entries are never edited or deleted.
- If an older `history/pickup-history.json` exists, convert its sessions into entries here once, oldest last, then delete the JSON file.

---

## .hashbang/history/changelog.json

The record of what changed in the project, so a returning session can see what moved since it last looked.

### Format

```json
{
  "changes": [
    {
      "date": "2026-10-06",
      "file": "docs/DECISIONS.md",
      "change": "Added D-002: US 5-digit zip codes only."
    }
  ]
}
```

- `date` — the day of the change, YYYY-MM-DD
- `file` — the path from the project root
- `change` — one sentence on what changed. Cite task and decision IDs instead of repeating them: "Unblocked T-003 (D-002)."

### What to log

- Every edit to the customer's Hashbang files: PRD.md, CONTEXT.md, TASKS.md, BACKLOG.md, and DECISIONS.md.
- Edits to the customer's own files only when the project is not under version control. When it is, version control already records those changes — read its log instead of duplicating it here.
- Never pickup.md or the history files. They change every session and would bury the real changes.

### Rules

- One entry per file per checkpoint. Several edits to one file for the same reason are one entry.
- Newest entries go last. Entries are never edited or deleted.

---

## .hashbang/customizations.md

The record of what this project changed in Hashbang's framework files and skills, and why. The hb-update skill reads it to tell a deliberate change from an outdated one when it merges a new Hashbang version.

### Format

```markdown
# Customizations

## .claude/skills/hb-design/templates/complex-tech-design-template.md · 2026-10-18

Renamed Interface Contract to Tauri Commands & Events, and added a Capabilities row for each new command. Every feature here crosses the Rust/WebView boundary (hb-dev-setup).

## .hashbang/framework/development.md · 2026-10-12

Added a manual accessibility check to step 5. VoiceOver regressions shipped twice (D-007).
```

### Rules

- One entry per file per change, newest first, headed with the file's path from the project root and the date.
- Say what changed and why, in one to three lines. The why is what lets a later merge keep the change; cite the decision or the skill behind it.
- When a later change undoes an earlier one, add a new entry saying so; never edit or delete old entries.

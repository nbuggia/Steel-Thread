# Steel Thread Files — Formats and Rules

How to write and maintain each Steel Thread file. Read this before you first create or edit one of them in a session. All paths are relative to `.steel-thread/`. Starter files are in `framework/templates/`.

## OBJECTIVE.md

OBJECTIVE.md says why the project exists and what done means. It is short enough to read at every session start, and it changes rarely.

### What belongs in it

- **Outcome** — one paragraph: what this produces, for whom, and why it matters
- **Done means** — testable criteria, not activities. "A zone 7 gardener gets this week's plantings in one command," not "build the planting feature."
- **Not doing** — at least two things that are explicitly out of scope, and why. An objective with nothing out of scope has not been scoped.
- **Constraints** — deadlines, budget, platforms, anything that cannot change

### When to update it

- When the customer changes direction, scope, or what done means
- Never unilaterally — always propose, customer approves
- Every change to OBJECTIVE.md also gets a DECISIONS.md entry recording what changed and why

---

## TASKS.md

### Format

```markdown
# Tasks

## Phase 1 — Data ✓ 2026-10-03
- [x] T-001 Import frost date table · high · done 2026-10-03

## Phase 2 — CLI
- [ ] T-002 Write planting window calculator · high
      Signature is in src/window.py; logic not started.
- [ ] T-003 Add --zip flag · medium
      Blocked: waiting on decision about non-US postal codes.
```

- Each phase is a `##` heading: `## Phase N — Name`. A completed phase gets ` ✓ YYYY-MM-DD` appended.
- Each task is one checkbox line: `- [ ] T-NNN Title · priority`. A completed task becomes `- [x]` with ` · done YYYY-MM-DD` appended.
- Detail goes on indented lines under the task.
- IDs are `T-` plus three digits. A new task takes the highest existing ID plus one. IDs are never reused or changed, so other files can refer to a task by ID even after its title changes.

### Rules

- Phases are complete or incomplete. Sequence in the file is the sequence they appear. The current phase is the first incomplete phase.
- Tasks are complete or incomplete. Sequence within a phase is the sequence they appear. The current task is the first incomplete task in the current phase.
- Priority is high, medium, or low — a category, not an order. Order within priority is determined by position in the file.
- Tasks belong to exactly one phase.
- Tasks and phases are never deleted or moved — only marked complete with a date. The full history stays in the file.
- Blocked tasks stay incomplete. The blocked reason goes on an indented line starting `Blocked:`.
- The customer can read and edit the file directly; respect their edits.

### How tasks are created

- When you notice something that needs doing while working
- When the customer mentions something they want to do
- When a document review surfaces a gap
- When a blocker is resolved and a new task becomes available

Always ask before adding a task: "I noticed X needs doing — want me to add that to your task list?"

### How phases are created

Phases are planned during setup, once the objective exists (see the whats-next skill). You propose them based on what the customer describes, customer approves or adjusts. Both can add phases as the project evolves. Always propose before creating: "It sounds like this project has three natural phases — Research, Drafting, and Review. Does that feel right?"

### How tasks are prioritized

Priority tier (high/medium/low) is set when the task is created. Order within a tier is position in the file. The customer can reorder by asking, or by editing the file.

When in doubt about priority, ask. The customer's judgment is the final word.

---

## DECISIONS.md

DECISIONS.md is the log of choices that are hard to reverse or likely to be argued again, and the reasoning behind them. It answers "why is it like this?" so the customer never has to reconstruct it, and so no session re-litigates a settled question by accident.

### Format

Newest entry first:

```markdown
## D-002 · US zip codes only · 2026-10-06
Status: Active
Context: --zip needed a scope; non-US postal codes need a different frost-date source.
Decision: Support US 5-digit zip codes only.
Why: Matches the objective; international users are listed under Not doing.
Rejected: Any postal code with a fallback lookup — needs a second data source.
Affects: T-003, OBJECTIVE.md
```

- IDs are `D-` plus three digits, assigned the same way as task IDs.
- Status is `Active` or `Superseded by D-NNN`.
- `Rejected` and `Affects` can be omitted when there is nothing to say.

### Rules

- Entries are never edited or deleted. When a decision changes, add a new entry and change only the old entry's Status line to `Superseded by D-NNN`.
- Record decisions that constrain future work, would surprise someone joining the project, or are likely to be suggested again. Routine choices do not belong here.
- Never record unilaterally — always propose: "We just decided X — want me to log that as a decision?"
- Other files state the current rule and cite the decision for the reason: "Voice: first person (D-004)."

---

## CONTEXT.md

CONTEXT.md holds the standing rules for how to work on this project.

### What belongs in it

- **Vocabulary** — defined terms and aliases to avoid. This is the most important section. When a term is defined here, use it precisely everywhere.
- **Style** — voice, audience, format, and length rules. What would surprise someone joining this project without context. Cite the decision behind a rule when there is one.
- **Tenets** — the principles the customer applies when good options conflict: "Correctness beats speed." They let you settle questions the customer would otherwise have to answer. Tenets are discovered through the elevate skill, not asked for up front.
- **What the agent should never do** — explicit constraints. These are absolute.
- **Active skills** — which skills are enabled and why

What the project is for belongs in OBJECTIVE.md. Why a rule exists belongs in DECISIONS.md.

### Examples

Short examples (a paragraph or less) live inline in CONTEXT.md alongside the vocabulary or style rule they illustrate:

Voice: write "We recommend" not "It is recommended that" Length: each section should be readable in 90 seconds

Longer examples live as files in examples/ and are referenced by path in CONTEXT.md:

Good executive summary: .steel-thread/examples/good/exec-summary.md Avoid this tone: .steel-thread/examples/bad/too-formal.md

Load examples on demand — only when the task calls for them. Do not load all examples at session start.

During setup, ask: "Do you have any existing documents that represent the style you're going for?" If yes, save them to examples/good/ and reference them in CONTEXT.md. This is the lowest-friction way to build the example library.

### When to update it

- When a new term is used that isn't defined
- When a new style rule or constraint is agreed — log the decision behind it in DECISIONS.md if it is hard to reverse
- When an elevate session surfaces a tenet that applies beyond the work at hand
- When the customer consistently uses a different term than what's defined — propose updating the canonical term
- Never unilaterally — always propose, customer approves

---

## pickup.md

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
- **Proposed Updates** — changes to propose for OBJECTIVE.md, CONTEXT.md, or DECISIONS.md that the customer has not yet approved.

### Rules

- The `Session:` line identifies the note. IDs are `S-` plus three digits: the newest ID in history/pickup-history.md plus one, or S-001 when there is no history.
- Leave out any section with nothing in it.
- Reference tasks and decisions by ID (T-003, D-002) and files by path. Do not duplicate content already in the other Steel Thread files.

---

## history/pickup-history.md

The log of past sessions, newest first. You maintain it on your own — it needs no approval.

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

## history/changelog.json

The record of what changed in the project, so a returning session can see what moved since it last looked. You maintain it on your own — it needs no approval.

### Format

```json
{
  "changes": [
    {
      "date": "2026-10-06",
      "file": ".steel-thread/DECISIONS.md",
      "change": "Added D-002: US 5-digit zip codes only."
    }
  ]
}
```

- `date` — the day of the change, YYYY-MM-DD
- `file` — the path from the project root
- `change` — one sentence on what changed. Cite task and decision IDs instead of repeating them: "Unblocked T-003 (D-002)."

### What to log

- Every edit to OBJECTIVE.md, CONTEXT.md, TASKS.md, and DECISIONS.md.
- Edits to the customer's own files only when the project is not under version control. When it is, version control already records those changes — read its log instead of duplicating it here.
- Never pickup.md or the history files. They change every session and would bury the real changes.

### Rules

- Log at the same checkpoint where you update pickup.md, not after every keystroke-level edit.
- One entry per file per checkpoint. Several edits to one file for the same reason are one entry.
- Newest entries go last. Entries are never edited or deleted.

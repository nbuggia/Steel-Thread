---
name: hb-whats-next
description: Recommend the single most valuable next step and give the customer what they need to start it. Sets up a new project one step at a time (objective, context, phases), and for an established project rebuilds where they left off and what to do next. Use when starting or resuming work, or when the customer asks what's next.
---

One job: recommend the single most valuable next step, and give the customer everything they need to start it right away. One recommendation, not a menu. Offer at most one alternative, and only when it is a real contender.

The customer's files live in `docs/`: OBJECTIVE.md or PRD.md, CONTEXT.md, TASKS.md, BACKLOG.md, and DECISIONS.md. Hashbang's working files live in `.hashbang/`. Starter files are in `.hashbang/framework/templates/`, and the format and rules for each file are in `.hashbang/framework/files.md` — read it before writing any of them.

## Step 1 — Read the state

Silently read whatever exists of the objective (`docs/PRD.md`'s sections above its first feature, or else `docs/OBJECTIVE.md`), `docs/CONTEXT.md`, `docs/TASKS.md`, `docs/DECISIONS.md`, `.hashbang/pickup.md`, and `.hashbang/history/changelog.json`, following any pointer to another file. In TASKS.md, read from the current phase onward and skip phases marked ✓. Never ask the customer for something these files already answer.

If there is no objective or no CONTEXT.md, first look for one the project already has, as files.md describes, and point to it.

In a software project, also list `docs/work/`. A task marked done whose folder has no `close.md` was never closed.

Then find the first row that matches. A skipped OBJECTIVE.md counts as done, unless the customer asked for an objective:

| State | Next step |
| --- | --- |
| No objective | Setup: create the objective |
| No CONTEXT.md | Setup: capture context |
| A software project with no `docs/engineering/ARCHITECTURE.md` | Setup: tailor development |
| TASKS.md has no phases | Setup: plan phases and first tasks |
| The customer says the direction has changed | Reframe |
| A task was marked done without being closed | Close the task |
| The current task's code is finished, and it has a work entry | Close the task |
| Open tasks in the current phase | Resume |
| Every task in the current phase is done | Close the phase |
| Every phase is done | Check against Done Means |

## Setup steps

A new project is set up one step at a time. Each step is a short conversation that produces one file. When a step is done, say what's next and offer to keep going: "The objective is written. Next is the project vocabulary — about five minutes. Keep going, or start working and do it later?"

In an existing project, read before you ask: the README, the docs, the code's structure, and recent version-control history. Draft each file from what they show, and interview only for what they can't answer — usually the outcome, done means, and not doing.

Use the hb-elevate skill for every interview. Propose what you've captured before writing it: "Here's what I've got — does this look right before I write it?" One-tap approval. Never write placeholder text — if a section has nothing yet, leave it out.

### Create the objective

Say: "Let's set this project up. First: what is it for? I'll ask a few questions." If the customer would rather not, write the skipped form (see files.md) and move to the next step.

Interview, in order:

1. **Outcome** — what does this project produce, for whom, and why does it matter? Push for specificity. "A website" is not specific enough. "A technical blog targeting senior engineers working on distributed systems" is.
2. **Done means** — how will we know it's finished? Testable criteria, not activities.
3. **Not doing** — what is explicitly out of scope? Get at least two items. If the customer can't name any, the project isn't scoped yet — say so.
4. **Constraints** — deadlines, budget, platforms, anything that cannot change.

Write `docs/OBJECTIVE.md` from the template. At the same time, create whichever of these don't exist yet, from the templates: `docs/DECISIONS.md`, and in `.hashbang/`, pickup.md, customizations.md, history/pickup-history.md, history/changelog.json, examples/good/, examples/bad/. Never overwrite a file that exists.

In a software project, the objective later grows into `docs/PRD.md`, the first time a task adds a feature to it (see files.md).

Log any hard-to-reverse choice the interview surfaced in DECISIONS.md, with approval.

### Capture context

1. **Vocabulary** — what terms are defined in this domain? What would someone get wrong without context? What aliases or synonyms should be avoided?
2. **Style** (if writing project) — what is the voice? Who is the audience? What are the hard rules about format or length? What tone is off-limits?
3. **Never do** — what should the agent never do on this project? What would be a serious mistake?
4. **Examples** — "Do you have any existing documents that represent the style or quality you're going for?" If yes, save them to .hashbang/examples/good/ and reference them in CONTEXT.md.

Write `docs/CONTEXT.md` from the template. For a small project, the customer may skip this — then write CONTEXT.md with just a Vocabulary heading, so this step isn't offered again, and fill it in as terms come up.

### Tailor development

A software project is one whose objective is software, or whose folder holds code. Use the hb-dev-setup skill. It learns the stack from the code, or from the objective's constraints for a new project, writes the engineering docs, and adapts the development process to the stack. Say why before starting: "This is a Tauri app, so I'll fit the design and test process to Rust, the WebView, and your targets. About ten minutes, mostly reading code."

### Plan phases and first tasks

Propose phases based on the objective:

- Writing project: typically Research → Drafting → Review → Polish
- Software project: typically one phase per release of the product, each ending in something users can run. The first tasks are usually the first release's features, each starting with a spec (see `.hashbang/framework/development.md`)
- Other: propose based on what the objective and Done Means require

"Based on the objective, I'd suggest three phases — [names]. Does that feel right, or should we adjust?"

Then propose the first few tasks for the first phase only. Later phases get tasks when they start. Write what the customer approves with the hb-tasks skill.

When setup is complete, go straight to Resume and recommend the first task.

## Reframe

When the customer says the direction, scope, or definition of done has changed:

- Run the objective interview again, focused on what changed — not what you already know
- Propose edits to the objective rather than rewriting it
- Log the change in DECISIONS.md, superseding earlier decisions it overturns
- Do not reset TASKS.md. Propose new phases or tasks the new direction needs, through the hb-tasks skill, and flag open tasks that no longer serve the objective
- Then continue with Resume

## Resume

This is the moment the customer would otherwise spend reconstructing where they were. Do that work for them.

### Rebuild where they left off

1. Start from pickup.md's In Flight and Suggested Start, and the current task in TASKS.md with its detail lines.
2. Read the Active decisions that touch that task, and recent changelog entries.
3. Open the actual files the in-flight work lives in. Check that their state matches the pickup note. Files may have changed outside the session — if version control is available, check what changed since the date on the pickup note.
4. If the note and the files disagree, trust the files and say so: "The pickup note says calculate_window() has no logic, but it's half written — the frost offset is done, the crop lookup isn't."

### Choose the next step

Default to the current task: the first incomplete task in the current phase. Recommend something else only when it is clearly better, and say why in one sentence:

- **Work is half done** — finishing it beats starting something new
- **A blocker can be cleared now** — if a decision would unblock a task and the objective or existing decisions already point to the answer, propose making it
- **Something higher priority is unblocked** — a high task further down that is now workable
- **The task list has stopped making sense** — if it is long, tangled, or drifting from the objective, recommend stepping back to reprioritize instead

### Present it

Keep it short enough to read in thirty seconds. Use this shape, leaving out any line with nothing in it:

"**Where you left off:** T-002 Write planting window calculator.
**Done so far:** the frost offset — `calculate_window()` in src/window.py returns the right start date.
**Still to do:** the crop lookup, and the end of the window.
**Keep in mind:** D-002 — US zip codes only. Open question from last time: should the window clip at the first fall frost?
**Next step:** add the crop lookup table to src/window.py. That's the smallest piece that gets a real answer out of the function.

Want to start there?"

The next step must be concrete and small enough to start immediately — a specific file, function, section, or question. Not "continue working on T-002."

## Close the task

A software task's code is finished, or a task was marked done without being closed. Say so in one line, "T-014's code is done, so the next step is closing it — moving what lasts into the tests and docs," and use the hb-close skill. If the code hasn't been validated against its spec yet, do that first, as step 5 of `.hashbang/framework/development.md` describes. Then come back to Choose the next step.

## Close the phase

Every task in the current phase is done.

- Summarize what the phase produced, in two or three lines
- If the phase produced a significant output, suggest an hb-crit before moving on
- Mark the phase complete with the hb-tasks skill
- Propose the next phase. In a software project with `docs/BACKLOG.md`, offer to plan the next release from its Next rows, with the hb-spec skill. Otherwise propose the first few tasks for the next phase, with the hb-tasks skill

## Check against Done Means

Every phase is done. Go through each Done Means criterion in the objective, or the success criteria of the file it points to, and say whether the work meets it, with evidence. If there are no criteria, summarize what the project produced instead. Then recommend one of: a final hb-crit, a new phase for what is missing, or calling the project done.

## After the recommendation

Update pickup.md with the recommendation as the Suggested Start. If the customer picks something else, that's their call — update pickup.md and help them start it.

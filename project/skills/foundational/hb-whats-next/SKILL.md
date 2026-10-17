---
name: hb-whats-next
description: Recommend the single most valuable next step and give the customer what they need to start it. Sets up a new project one step at a time (objective, context, phases), and for an established project rebuilds where they left off and what to do next. Use when starting or resuming work, or when the customer asks what's next.
---

One job: recommend the single most valuable next step, and give the customer everything they need to start it right away. One recommendation, not a menu. Offer at most one alternative, and only when it is a real contender.

All Hashbang files live in `.hashbang/`. Starter files are in `.hashbang/framework/templates/`, and the format and rules for each file are in `.hashbang/framework/files.md` — read it before writing any of them. Never write anything into `.hashbang/framework/`.

## Step 1 — Read the state

Silently read whatever exists of OBJECTIVE.md, CONTEXT.md, TASKS.md, DECISIONS.md, pickup.md, and history/changelog.json. In TASKS.md, read from the current phase onward and skip phases marked ✓. Never ask the customer for something these files already answer.

Then find the first row that matches:

| State | Next step |
| --- | --- |
| No OBJECTIVE.md | Setup: create the objective |
| No CONTEXT.md | Setup: capture context |
| TASKS.md has no phases | Setup: plan phases and first tasks |
| The customer says the direction has changed | Reframe |
| Open tasks in the current phase | Resume |
| Every task in the current phase is done | Close the phase |
| Every phase is done | Check against Done Means |

## Setup steps

A new project is set up one step at a time. Each step is a short conversation that produces one file. When a step is done, say what's next and offer to keep going: "The objective is written. Next is the project vocabulary — about five minutes. Keep going, or start working and do it later?"

Use the hb-elevate skill for every interview. Propose what you've captured before writing it: "Here's what I've got — does this look right before I write it?" One-tap approval. Never write placeholder text — if a section has nothing yet, leave it out.

### Create the objective

Say: "Let's set this project up. First: what is it for? I'll ask a few questions."

Interview, in order:

1. **Outcome** — what does this project produce, for whom, and why does it matter? Push for specificity. "A website" is not specific enough. "A technical blog targeting senior engineers working on distributed systems" is.
2. **Done means** — how will we know it's finished? Testable criteria, not activities.
3. **Not doing** — what is explicitly out of scope? Get at least two items. If the customer can't name any, the project isn't scoped yet — say so.
4. **Constraints** — deadlines, budget, platforms, anything that cannot change.

Write .hashbang/OBJECTIVE.md from the template. At the same time, create whichever of these don't exist yet, from the templates: DECISIONS.md, pickup.md, history/pickup-history.md, history/changelog.json, examples/good/, examples/bad/. Never overwrite a file that exists.

Log any hard-to-reverse choice the interview surfaced in DECISIONS.md, with approval.

### Capture context

1. **Vocabulary** — what terms are defined in this domain? What would someone get wrong without context? What aliases or synonyms should be avoided?
2. **Style** (if writing project) — what is the voice? Who is the audience? What are the hard rules about format or length? What tone is off-limits?
3. **Never do** — what should the agent never do on this project? What would be a serious mistake?
4. **Examples** — "Do you have any existing documents that represent the style or quality you're going for?" If yes, save them to .hashbang/examples/good/ and reference them in CONTEXT.md.

Write .hashbang/CONTEXT.md from the template. For a small project, the customer may skip this — then write CONTEXT.md with just a Vocabulary heading, so this step isn't offered again, and fill it in as terms come up.

### Plan phases and first tasks

Propose phases based on the objective:

- Writing project: typically Research → Drafting → Review → Polish
- Other: propose based on what the objective and Done Means require

"Based on the objective, I'd suggest three phases — [names]. Does that feel right, or should we adjust?"

Then propose the first few tasks for the first phase only. Later phases get tasks when they start. Write only what the customer approves to .hashbang/TASKS.md.

When setup is complete, go straight to Resume and recommend the first task.

## Reframe

When the customer says the direction, scope, or definition of done has changed:

- Run the objective interview again, focused on what changed — not what you already know
- Propose edits to OBJECTIVE.md rather than rewriting it
- Log the change in DECISIONS.md, superseding earlier decisions it overturns
- Do not reset TASKS.md. Propose new phases or tasks the new direction needs, and flag open tasks that no longer serve the objective
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

## Close the phase

Every task in the current phase is done.

- Summarize what the phase produced, in two or three lines
- If the phase produced a significant output, suggest an hb-crit before moving on
- Propose marking the phase complete, then propose the first few tasks for the next phase

## Check against Done Means

Every phase is done. Go through each Done Means criterion in OBJECTIVE.md and say whether the work meets it, with evidence. Then recommend one of: a final hb-crit, a new phase for what is missing, or calling the project done.

## After the recommendation

Update pickup.md with the recommendation as the Suggested Start. If the customer picks something else, that's their call — update pickup.md and help them start it.

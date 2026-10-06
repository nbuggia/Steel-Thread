---
name: onboard
description: Set up or reframe a project via structured interview. Entry point for every new project.
---

Onboarding creates the Steel Thread files for a new project, or reframes an existing one. Every project starts here.

All Steel Thread files live in `.steel-thread/`. Starter files are in `.steel-thread/framework/templates/`. Never write anything into `.steel-thread/framework/`.

## Phase 1 — Detect mode

Check if Steel Thread files already exist:
- If .steel-thread/OBJECTIVE.md exists: this is a reframe session, not a new project
- If it does not exist: this is a new project

**New project:** "Let's set this project up. I'll ask a few questions to understand what we're working on."

**Reframe:** Read OBJECTIVE.md first. Say: "Your project is [outcome]. What's changed — new direction, new scope, or moving to a new phase?"

## Phase 2 — Elevate (use the elevate skill)

Run the elevate loop on these, in order. The objective comes first because everything else depends on it.

**1. Outcome**
What does this project produce, for whom, and why does it matter? Push for specificity.
"A website" is not specific enough.
"A technical blog targeting senior engineers working on distributed systems" is.

**2. Done means**
How will we know it's finished? Push for testable criteria, not activities.

**3. Not doing**
What is explicitly out of scope? Get at least two items. If the customer can't name any, the project isn't scoped yet — say so.

**4. Constraints**
Deadlines, budget, platforms, anything that cannot change.

**5. Vocabulary**
What terms are defined in this domain? What would someone get wrong without context?
What aliases or synonyms should be avoided?

**6. Style** (if writing project)
What is the voice? Who is the audience?
What are the hard rules about format or length?
What tone is off-limits?

**7. Never do**
What should the agent never do on this project? What would be a serious mistake?

## Phase 3 — Examples

Ask: "Do you have any existing documents that represent the style or quality you're going for?"

If yes:
- Save them to .steel-thread/examples/good/
- Reference them in CONTEXT.md under "Examples"
- Load them on demand when tasks call for them — not at every session start

If no, continue. The example library can be built during the project.

## Phase 4 — Write OBJECTIVE.md and CONTEXT.md

Create .steel-thread/OBJECTIVE.md from questions 1–4, and .steel-thread/CONTEXT.md from questions 5–7, using the templates as starting points.

Fill in every section from the elevate session. Do not leave placeholder text — if a section has nothing yet, omit it and add it later.

Propose the outcome, done criteria, and vocabulary to the customer before writing:
"Here's the objective and the terms I've captured — does this look right before I write it?"

One-tap approval. Do not require review of the full documents.

## Phase 5 — Propose phases

Propose initial phases for TASKS.md based on the project type:

- Writing project: typically Research → Drafting → Review → Polish
- Other: propose based on what the elevate session revealed

"Based on what you've told me, I'd suggest three phases — [names]. Does that feel right, or should we adjust?"

Write only what the customer approves.

## Phase 6 — Initialize files

Create or verify the .steel-thread/ structure:

```
.steel-thread/
  OBJECTIVE.md            ← written in Phase 4
  CONTEXT.md              ← written in Phase 4
  TASKS.md                ← approved phases, no tasks yet
  DECISIONS.md            ← from the template; log any hard-to-reverse choice made during onboarding
  pickup.md               ← initialize with this session
  history/
    pickup-history.json   ← empty sessions array
    changelog.json        ← empty changes array
  examples/
    good/
    bad/
```

Use the files in .steel-thread/framework/templates/ as starting points. Never overwrite a file that already exists.

## Phase 7 — Greet the customer

Summarize what was set up and suggest the first action:

"You're set up. Everything lives in .steel-thread/:
- OBJECTIVE.md — [one-sentence outcome]
- TASKS.md — [N phases: phase names]

[Suggested first action based on project type]. Want to start there, or is there something else on your mind?"

## Reframe sessions

When onboarding an existing project:
- Read all current Steel Thread files before asking anything
- Focus the elevate on what's changed, not what you already know
- Propose updates to OBJECTIVE.md and CONTEXT.md rather than rewriting them
- Log each change to the objective in DECISIONS.md, superseding earlier decisions where needed
- Do not reset TASKS.md — add new phases if needed
- Update pickup.md to reflect the new direction

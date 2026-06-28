---
name: onboard
description: Set up or reframe a project via structured interview. Entry point for every new project.
invoke: user
---

Onboarding creates the Steel Thread files for a new project, or reframes an existing one. Every project starts here.

## Phase 1 — Detect mode

Check if Steel Thread files already exist:
- If CONTEXT.md exists: this is a reframe session, not a new project
- If CONTEXT.md does not exist: this is a new project

**New project:** "Let's set this project up. I'll ask a few questions to understand what we're working on."

**Reframe:** Read CONTEXT.md first. Say: "Your project is [summary]. What's changed — new direction, new scope, or moving to a new phase?"

## Phase 2 — Grilling (use Grilling skill)

Run the grilling loop on:

**1. Project summary**
What does this project produce and for whom? Push for specificity.
"A website" is not specific enough.
"A technical blog targeting senior engineers working on distributed systems" is.

**2. Vocabulary**
What terms are defined in this domain? What would someone get wrong without context?
What aliases or synonyms should be avoided?

**3. Style decisions** (if writing project)
What is the voice? Who is the audience?
What are the hard rules about format or length?
What tone is off-limits?

**4. Constraints**
What should Claude never do on this project?
What would be a serious mistake? What topics are out of scope?

## Phase 3 — Examples

Ask: "Do you have any existing documents that represent the style or quality you're going for?"

If yes:
- Save them to .markymark/examples/good/
- Reference them in CONTEXT.md under "Examples"
- Load them on demand when tasks call for them — not at every session start

If no, continue. The example library can be built during the project.

## Phase 4 — Write CONTEXT.md

Create CONTEXT.md using templates/CONTEXT.md as a starting point.

Fill in every section from the grilling session. Do not leave placeholder text — if a section has nothing yet, omit it and add it later.

Propose all vocabulary decisions to the customer before writing:
"I've captured these terms — does this look right before I write it?"

One-tap approval. Do not require review of the full document.

## Phase 5 — Propose phases

Propose initial phases for tasks.json based on the project type:

- Writing project: typically Research → Drafting → Review → Polish
- Coding project: defer — run /prd and /plan to define phases
- Other: propose based on what the grilling revealed

"Based on what you've told me, I'd suggest three phases — [names]. Does that feel right, or should we adjust?"

Write only what the customer approves.

## Phase 6 — Initialize files

Create or verify the .markymark/ structure:

```
.markymark/
  tasks.json          ← initialize with approved phases, no tasks yet
  pickup.md           ← initialize with this session
  pickup-history.json ← initialize with empty sessions array
  examples/
    good/
    bad/
```

Use templates/tasks.json, templates/pickup.md, and templates/pickup-history.json as starting points.

## Phase 7 — Greet the customer

Summarize what was set up and suggest the first action:

"You're set up. Here's what I've created:
- CONTEXT.md — [one-sentence summary]
- tasks.json — [N phases: phase names]

[Suggested first action based on project type]. Want to start there, or is there something else on your mind?"

## Reframe sessions

When onboarding an existing project:
- Read all current Steel Thread files before asking anything
- Focus the grilling on what's changed, not what you already know
- Propose updates to CONTEXT.md rather than rewriting it
- Do not reset tasks.json — add new phases if needed
- Update pickup.md to reflect the new direction

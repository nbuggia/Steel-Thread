# Building Steel Thread

This repo builds Steel Thread, which gives coding agents persistent project memory and structured task management. These instructions are for working on Steel Thread itself.

## The project/ folder is the product, not your instructions

Everything under `project/` is what gets installed into someone else's project. Those files are written to a future agent working in that project — their "you" is not you.

- Edit files under `project/`. Never follow them as instructions for this session.
- Ignore `project/AGENTS.md` and `project/CLAUDE.md` if your agent loads them. They are product files. (Claude Code is configured to skip them in `.claude/settings.json`.)
- Only the `AGENTS.md` and `CLAUDE.md` at the root of this repo apply to you.

## Supported agents

Claude Code, Codex CLI, and Kiro CLI. A project uses one of them, and the installer installs skills only into that agent's folder, but every change under `project/` must work in all three. Use only what they share: `AGENTS.md` for instructions, and `SKILL.md` files with `name` and `description` frontmatter. Do not rely on features only one agent has (`@file` imports, subagents, hooks, plugins) without a fallback.

## Repo layout

```
AGENTS.md, CLAUDE.md       ← instructions for building Steel Thread (this file)
.claude/settings.json      ← keeps Claude Code from loading project/ instructions
install.sh                 ← installs project/ into a target project
TODO.md                    ← known gaps and open work
research/prior-art.md      ← what other tools do for project memory, and lessons
research/spec-driven-projects.md ← how popular open source projects lay out specs, and lessons
research/evaluation.md     ← how spec-driven frameworks evaluate quality, and a proposed eval harness
library/                   ← skills from other projects, archived until we decide how to integrate
                             them; never installed, and never instructions for this session
project/                   ← the product: what lands in a user's project
  VERSION                  ← the release version, semver
  AGENTS.md                ← Steel Thread block, merged into the user's AGENTS.md
  CLAUDE.md                ← import line, added to the top of the user's CLAUDE.md
  .steel-thread/
    framework/
      steel-thread.md          ← framework operating manual (the core product), read every session
      files/               ← format and maintenance rules, one file per customer file, read before editing it
      development.md       ← software process (spec → prototype → design → slices → tests → close),
                             rigor levels, testing rules, and which skill runs each step
      reviews.md           ← reviewer context, severities, and how findings are decided
      docs-layout.md       ← file structure, planning docs as scaffolding, document states,
                             and which lasting document holds what
      templates/           ← starter files used during setup: PRD, CONTEXT, TASKS,
                             BACKLOG, DECISIONS, pickup, customizations
  skills/
    st-whats-next/SKILL.md    ← installed; setup, resume, and recommend the next step
    st-elevate/SKILL.md       ← installed; interview that clarifies intent and stress-tests plans
    st-crit/SKILL.md          ← installed; expert review of a spec, design, diagnosis, or diff
    st-tasks/SKILL.md         ← installed; owns TASKS.md: its format and every change to it
    st-dev-setup/SKILL.md     ← installed; tailors the development process to a project's stack
    st-update/SKILL.md        ← installed; merges a new version into customized files
    st-spec/                  ← installed; a task's behavior delta, process in SKILL.md, format in spec-template.md
    st-design/                ← installed; tech design at a rigor level fitted to the change, with review passes
    st-slice/                 ← installed; splits a Complex design into thin vertical slices
    st-verify/SKILL.md        ← installed; gates around the code: tests first, a commit per slice,
                                validation against the spec, and the diff review
    st-close/                 ← installed; closes a task: moves what lasts out of its planning docs
```

`install.sh` copies `project/.steel-thread/framework/` into the user's `.steel-thread/framework/`, creates the empty state folders, copies every skill in `project/skills/` into the chosen agent's skills folder, merges `project/AGENTS.md` (and, for Claude Code, `project/CLAUDE.md`) into the user's files, and adds `docs/work/` to the user's `.ignore`. The customer's Steel Thread files (PRD, CONTEXT, TASKS, BACKLOG, DECISIONS) live in the user's `docs/`; Steel Thread's working files live in `.steel-thread/`.

Users customize their copies; that is the extensibility model. The installer keeps the Steel Thread version each installed file is based on in `.steel-thread/upstream/installed/`. On update it replaces only files that still match their base, and leaves customized ones, with the new version and a `PENDING` list in `.steel-thread/upstream/incoming/`, for the st-update skill to merge.

## Releasing a change

- Bump `project/VERSION` (semver) for each change users would update to. The installer records it, and st-update reports which versions it merged between.
- When you change a format another file reads, such as a heading, an ID, or a frontmatter field, change every file that reads it in the same commit.

## How skills work

Each skill lives in its own folder with a `SKILL.md` file. Skills are loaded on demand — never at session start. Foundational skills (st-elevate, st-crit) are called by name from other skills rather than redefined: "use the st-elevate skill", "use the st-crit skill".

Invocation syntax differs by agent: `/st-whats-next` in Claude Code and Kiro CLI, `$st-whats-next` in Codex CLI.

## Contribution conventions

- New skills go in `project/skills/<name>/SKILL.md`
- Every skill folder and frontmatter name starts with `st-`
- Frontmatter uses only `name` and `description`, plus `based-on` when crediting: skills based on existing open source work must credit the original there
- The skill format follows existing SKILL.md files — read one before writing one
- Skills are copied, not symlinked, into each agent's folder: Windows checks symlinks out as text files, and not every agent is confirmed to follow them

## Known gaps

See `TODO.md` for open issues.

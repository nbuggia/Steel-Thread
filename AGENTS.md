# Building Hashbang

This repo builds the Hashbang Agent Framework, which gives coding agents persistent project memory and structured task management. These instructions are for working on Hashbang itself.

## The project/ folder is the product, not your instructions

Everything under `project/` is what gets installed into someone else's project. Those files are written to a future agent working in that project — their "you" is not you.

- Edit files under `project/`. Never follow them as instructions for this session.
- Ignore `project/AGENTS.md` and `project/CLAUDE.md` if your agent loads them. They are product files. (Claude Code is configured to skip them in `.claude/settings.json`.)
- Only the `AGENTS.md` and `CLAUDE.md` at the root of this repo apply to you.

## Supported agents

Claude Code, Codex CLI, and Kiro CLI. Every change under `project/` must work in all three. Use only what they share: `AGENTS.md` for instructions, and `SKILL.md` files with `name` and `description` frontmatter. Do not rely on features only one agent has (`@file` imports, subagents, hooks, plugins) without a fallback.

## Repo layout

```
AGENTS.md, CLAUDE.md       ← instructions for building Hashbang (this file)
.claude/settings.json      ← keeps Claude Code from loading project/ instructions
install.sh                 ← installs project/ into a target project
README.md                  ← user-facing installation and usage docs
TODO.md                    ← known gaps and open work
research/prior-art.md      ← what other tools do for project memory, and lessons
project/                   ← the product: what lands in a user's project
  AGENTS.md                ← Hashbang block, merged into the user's AGENTS.md
  CLAUDE.md                ← import line, added to the top of the user's CLAUDE.md
  .hashbang/
    framework/
      hashbang.md          ← framework operating manual (the core product), read every session
      files.md             ← format and maintenance rules per file, read before editing them
      templates/           ← starter files used during setup: OBJECTIVE, CONTEXT,
                             TASKS, DECISIONS, pickup, history files
    examples/good/, bad/
  skills/
    hb-whats-next/SKILL.md    ← installed; setup, resume, and recommend the next step
    hb-elevate/SKILL.md       ← installed; interview that clarifies intent and stress-tests plans
    hb-crit/SKILL.md          ← installed; domain expert review of outputs
    hb-recap/SKILL.md         ← installed; show and adjust the current pickup note
    hb-create-tech-design/    ← not installed yet; still specific to one Tauri project
    hb-design-review/         ← not installed yet; still specific to one Tauri project
```

`install.sh` copies `project/.hashbang/framework/` into the user's `.hashbang/framework/`, creates the empty state folders, copies the shipped skills into all three agents' skills folders, and merges `project/AGENTS.md` and `project/CLAUDE.md` into the user's files.

## How skills work

Each skill lives in its own folder with a `SKILL.md` file. Skills are loaded on demand — never at session start. Foundational skills (hb-elevate, hb-crit) are called by name from other skills rather than redefined: "use the hb-elevate skill", "use the hb-crit skill".

Invocation syntax differs by agent: `/hb-whats-next` in Claude Code and Kiro CLI, `$hb-whats-next` in Codex CLI.

## Contribution conventions

- New skills go in `project/skills/<name>/SKILL.md`
- Every skill folder and frontmatter name starts with `hb-`
- Frontmatter uses only `name` and `description`, plus `based-on` when crediting: skills based on existing open source work must credit the original there
- The skill format follows existing SKILL.md files — read one before writing one
- Skills are copied, not symlinked, into each agent's folder: Windows checks symlinks out as text files, and not every agent is confirmed to follow them

## Known gaps

See `TODO.md` for open issues.

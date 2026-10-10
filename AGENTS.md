# Building Steel Thread

This repo builds Steel Thread, a framework that gives coding agents persistent project memory and structured task management. These instructions are for working on Steel Thread itself.

## The project/ folder is the product, not your instructions

Everything under `project/` is what gets installed into someone else's project. Those files are written to a future agent working in that project — their "you" is not you.

- Edit files under `project/`. Never follow them as instructions for this session.
- Ignore `project/AGENTS.md` and `project/CLAUDE.md` if your agent loads them. They are product files. (Claude Code is configured to skip them in `.claude/settings.json`.)
- Only the `AGENTS.md` and `CLAUDE.md` at the root of this repo apply to you.

## Supported agents

Claude Code, Codex CLI, and Kiro CLI. Every change under `project/` must work in all three. Use only what they share: `AGENTS.md` for instructions, and `SKILL.md` files with `name` and `description` frontmatter. Do not rely on features only one agent has (`@file` imports, subagents, hooks, plugins) without a fallback.

## Repo layout

```
AGENTS.md, CLAUDE.md       ← instructions for building Steel Thread (this file)
.claude/settings.json      ← keeps Claude Code from loading project/ instructions
install.sh                 ← installs project/ into a target project
README.md                  ← user-facing installation and usage docs
TODO.md                    ← known gaps and open work
project/                   ← the product: what lands in a user's project
  AGENTS.md                ← Steel Thread block, merged into the user's AGENTS.md
  CLAUDE.md                ← import line, added to the top of the user's CLAUDE.md
  .steel-thread/
    framework/
      steel-thread.md      ← framework operating manual (the core product)
      templates/           ← starter files used during setup: OBJECTIVE, CONTEXT,
                             TASKS, DECISIONS, pickup, history files
    examples/good/, bad/
  skills/
    foundational/          ← installed into .claude/skills, .agents/skills, .kiro/skills
      whats-next/SKILL.md  ← step-by-step setup, then resume and recommend the next step
      elevate/SKILL.md     ← alignment loop before work begins
      crit/SKILL.md        ← domain expert review of outputs
      recap/SKILL.md       ← show and adjust current pickup note
    coding/                ← not installed yet; still specific to one Tauri project
```

`install.sh` copies `project/.steel-thread/framework/` into the user's `.steel-thread/framework/`, creates the empty state folders, copies each skill in `project/skills/foundational/` into all three agents' skills folders, and merges `project/AGENTS.md` and `project/CLAUDE.md` into the user's files.

## How skills work

Each skill lives in its own folder with a `SKILL.md` file. Skills are loaded on demand — never at session start. Foundational skills (elevate, crit) are called by name from other skills rather than redefined: "use the elevate skill", "use the crit skill".

Invocation syntax differs by agent: `/whats-next` in Claude Code and Kiro CLI, `$whats-next` in Codex CLI.

## Contribution conventions

- New skills go in `project/skills/<category>/<name>/SKILL.md`
- Frontmatter uses only `name` and `description`, plus `based-on` when crediting: skills based on existing open source work must credit the original there
- The skill format follows existing SKILL.md files — read one before writing one
- Skills are copied, not symlinked, into each agent's folder: Windows checks symlinks out as text files, and not every agent is confirmed to follow them

## Known gaps

See `TODO.md` for open issues.

# Steel Thread

At the start of every session, before responding, read `.steel-thread/steel-thread.md` in full and follow it.

Steel Thread gives coding agents persistent project memory and structured task management. This repo is the framework itself — you are working on the tool, not a project that uses the tool.

## Supported agents

Claude Code, Codex CLI, and Kiro CLI. Every change must work in all three. Use only what they share: `AGENTS.md` for instructions, and `SKILL.md` files with `name` and `description` frontmatter. Do not rely on features only one agent has (`@file` imports, subagents, hooks, plugins) without a fallback.

## What this project produces

A set of files that any project can install with `install.sh` to give its agent persistent memory, structured tasks, and session continuity across conversations. No external dependencies.

## Key files

```
.steel-thread/             ← copied into projects by install.sh
  steel-thread.md          ← framework operating manual (the core product)
  templates/               ← starter files used by onboard
    CONTEXT.md
    tasks.json
    pickup.md
    pickup-history.json
    changelog.json
  examples/
    good/
    bad/
skills/
  foundational/            ← installed into .claude/skills, .agents/skills, .kiro/skills
    onboard/SKILL.md       ← project setup interview
    elevate/SKILL.md       ← alignment loop before work begins
    crit/SKILL.md          ← domain expert review of outputs
    recap/SKILL.md         ← show and adjust current pickup note
  coding/                  ← not installed yet; still specific to one Tauri project
install.sh                 ← installs or updates Steel Thread in a project
README.md                  ← user-facing installation and usage docs
TODO.md                    ← known gaps and open work
```

## How skills work

Each skill lives in its own folder with a `SKILL.md` file. Skills are loaded on demand — never at session start. Foundational skills (elevate, crit) are called by name from other skills rather than redefined: "use the elevate skill", "use the crit skill".

Invocation syntax differs by agent: `/onboard` in Claude Code and Kiro CLI, `$onboard` in Codex CLI.

## Contribution conventions

- New skills go in `skills/<category>/<name>/SKILL.md`
- Frontmatter uses only `name` and `description`, plus `based-on` when crediting: skills based on existing open source work must credit the original there
- The skill format follows existing SKILL.md files — read one before writing one

## Known gaps

See `TODO.md` for open issues. Currently: `changelog.json` has no defined maintenance instructions.

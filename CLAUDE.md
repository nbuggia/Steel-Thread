@.markymark/steel-thread.md

# Steel Thread

Steel Thread gives Claude Code persistent project memory and structured task management. This repo is the framework itself — you are working on the tool, not a project that uses the tool.

## What this project produces

A set of steering files (`.markymark/`) that any project can install to give Claude persistent memory, structured tasks, and session continuity across conversations. No external dependencies. Runs entirely inside Claude Code.

## Key files

```
.markymark/
  steel-thread.md          ← framework operating manual (the core product)
  skills/
    foundational/
      onboard/SKILL.md     ← project setup interview
      elevate/SKILL.md         ← alignment loop before work begins
      crit/SKILL.md        ← domain expert review of outputs
      recap/SKILL.md       ← show and adjust current pickup note
    coding/
      plan.md              ← technical planning skill
      tech-plan.md         ← technical plan template
  templates/               ← starter files copied during /onboard
    CONTEXT.md
    tasks.json
    pickup.md
    pickup-history.json
    changelog.json
    examples/
      good/
      bad/
README.md                  ← user-facing installation and usage docs
TODO.md                    ← known gaps and open work
```

## How skills work

Skills are `.md` files in `.markymark/skills/`. Each lives in its own folder with a `SKILL.md` file. Skills are loaded on demand — never at session start. Foundational skills (elevate, crit) are called by name from other skills rather than redefined.

## Contribution conventions

- New skills go in `.markymark/skills/<category>/<name>/SKILL.md`
- Skills based on existing open source work must credit the original in the `based-on` frontmatter field
- Foundational skills are invoked by name: `use Jam skill`, `use Crit skill`
- The skill format follows existing SKILL.md files — read one before writing one

## Known gaps

See `TODO.md` for open issues. Currently: `changelog.json` has no defined maintenance instructions.

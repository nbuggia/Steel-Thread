# Steel Thread

Steel Thread gives Claude Code persistent project memory and structured task management. It activates with a single line in CLAUDE.md.

## What it does

Without Steel Thread, every Claude Code session starts from scratch. You re-explain the project, re-orient on where you left off, and rebuild context that should already exist.

With Steel Thread:
- Claude reads your project context, open tasks, and last session's pickup note before responding
- Sessions start with specific orientation ("You're working on X, you left off at Y, Z is up next") rather than "How can I help?"
- Every decision, term, and constraint lives in CONTEXT.md and carries forward automatically
- Tasks live in tasks.json and are maintained by Claude — you interact with them, not the JSON

Steel Thread is a set of steering files. It runs entirely inside Claude Code with no external dependencies.

## Installation

**Step 1** — Copy `.markymark/` into your project:

```sh
cp -r path/to/steel-thread/.markymark/ your-project/.markymark/
```

**Step 2** — Add to your project's CLAUDE.md:

```
@.markymark/steel-thread.md
```

Then run `/onboard` to set up your project context.

## File structure

After installation and `/onboard`, your project looks like this:

```
your-project/
  CLAUDE.md                        ← activates Steel Thread
  CONTEXT.md                       ← what this project is, vocabulary, decisions
  .markymark/
    steel-thread.md                ← framework definition
    tasks.json                     ← phases and tasks
    pickup.md                      ← current session state
    pickup-history.json            ← append-only session log
    changelog.json                 ← every change to project files
    examples/
      good/                        ← reference examples
      bad/                         ← anti-patterns
```

## Skills

Two foundational skills are included and run automatically when the moment calls for them:

- **Grilling** — one-question-at-a-time interview loop. Resolves ambiguity before any work begins. Used by `/onboard`.
- **Adversarial Review** — domain expert critique after significant outputs. Steelmans first, then attacks. BLOCK/CONCERNS/CLEAN verdict.

Two universal skills are available via slash command:

- **`/onboard`** — set up or reframe a project via structured interview. Run this first.
- **`/pickup`** — show the current pickup note and optionally adjust it.

## Contributing skills

Skills are `.md` files that follow the SKILL.md format in `.markymark/skills/`. To contribute:

1. Add a folder under `.markymark/skills/` in the appropriate category
2. Write `SKILL.md` following the format in existing skills
3. Skills based on existing open source work must credit the original in the `based-on` frontmatter field
4. Open a pull request

Skills call foundational skills by name rather than redefining their logic:
- `use Grilling skill` — one-question-at-a-time interview loop
- `use Adversarial Review skill` — domain expert critique after significant outputs

## Attribution

The Grilling foundational skill is based on Matt Pocock's [grill-with-docs](https://github.com/mattpocock/skills) pattern.

## License

MIT

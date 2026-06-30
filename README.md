# Steel Thread

Steel Thread is a lightweight project memory and task tracker for Claude Code. It helps Claude remember decisions, track active work, and start each session with the right context. When Claude carries the operational overhead, you can go deeper into a problem, step back to reprioritize, or make a creative leap you couldn't make while managing details.

It gives Claude four practical capabilities:

1. **Context -** Remembers the project. Vocabulary, decisions, and constraints live in `CONTEXT.md` and carry these forward automatically.
2. **Tasks -** Remembers the work that needs to get done. Tasks and phases live in `tasks.json`, maintained by Claude. You interact with the work, not the file.
3. **Continuity -** Remembers where you left off. Sessions start oriented: “You’re working on X, left off at Y, Z is up next.”
4. **Agent Coordination -** Remembers what other agents did. `AGENTS.md` ensures every agent starts from the same shared context.

## Installation

**Step 1** — Copy `.markymark/` into your project:

```sh
cp -r path/to/steel-thread/.markymark/ your-project/.markymark/
```

**Step 2** — Add to your project's `CLAUDE.md` (create one if it doesn't exist):

```
@.markymark/steel-thread.md
```

**Step 3** — Create `AGENTS.md` in your project root (for agents that don't read CLAUDE.md):

```
@CLAUDE.md
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

- `/onboard` — set up or reframe a project via structured interview. Run this first.
- `/pickup` — show the current pickup note and optionally adjust it.

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
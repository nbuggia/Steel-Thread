# Steel Thread

Steel Thread gives Claude Code persistent project memory, structured task management, and a library of composable skills. It activates with a single line in CLAUDE.md.

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

```
your-project/
  CLAUDE.md                        ← your operating manual
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
    extensions/
      dev-thread.md                ← coding extension (optional)
```

## Dev extension

For projects with a software component, activate the dev extension by adding to CLAUDE.md:

```
@.markymark/extensions/dev-thread.md
```

Or run `/onboard` — it asks whether the project has a coding component and activates the extension automatically.

The dev extension adds:
- Full document pipeline: `/prd` → `/spec` → `/tech-design` → `/plan` → implementation
- Automatic quality envelope: simplify-pre, simplify-post, adversarial-review, security-review
- Bug tracking with `/bug` one-shot capture
- Arch review at milestones

## Skills

Skills are composable capabilities invoked by slash command (`/onboard`, `/spec`) or automatically by Claude when the moment calls for them. They live in `.markymark/skills/` and are included in the install.

To activate a skill in your project, reference it in CLAUDE.md:

```
@.markymark/skills/writing/voice-check/SKILL.md
```

Skills are opt-in. The base install (`@.markymark/steel-thread.md`) includes only the core framework. Add skills as your project needs them.

## Contributing skills

1. Add a folder under the appropriate category (`.markymark/skills/universal/`, `.markymark/skills/writing/`, `.markymark/skills/coding/`, `.markymark/skills/dev-pipeline/`)
2. Write `SKILL.md` following the format in existing skills
3. Skills based on existing open source work must credit the original in the `based-on` frontmatter field
4. Open a pull request

Skills call foundational skills by name rather than redefining their logic:
- `use Grilling skill` — one-question-at-a-time interview loop
- `use Simplicity skill (pre-build mode)` — climb the decision ladder before building
- `use Adversarial Review skill` — domain expert critique after significant outputs

## Attribution

The Grilling foundational skill is based on Matt Pocock's [grill-with-docs](https://github.com/mattpocock/skills) pattern.

The Simplicity foundational skill is based on DietrichGebert's [ponytail](https://github.com/DietrichGebert/ponytail) pattern and the Claude Code `/code-review` skill.

The security-review skill is based on [agamm/claude-code-owasp](https://github.com/agamm/claude-code-owasp) and [trailofbits/skills](https://github.com/trailofbits/skills).

The systematic-debugging skill is based on [BehiSecc/awesome-claude-skills](https://github.com/BehiSecc/awesome-claude-skills).

The secrets-guard skill is based on the varlock-claude-skill pattern.

The threat-model skill is based on [Security-Phoenix-demo/security-skills-claude-code](https://github.com/Security-Phoenix-demo/security-skills-claude-code).

## License

MIT

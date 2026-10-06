# Steel Thread

Steel Thread is a lightweight project memory and task tracker for coding agents. It helps your agent remember decisions, track active work, and start each session with the right context. When the agent carries the operational overhead, you can go deeper into a problem, step back to reprioritize, or make a creative leap you couldn't make while managing details.

It works with **Claude Code**, **Codex CLI**, and **Kiro CLI**.

It gives your agent four practical capabilities:

1. **Context -** Remembers the project. Vocabulary, decisions, and constraints live in `CONTEXT.md` and carry forward automatically.
2. **Tasks -** Remembers the work that needs to get done. Tasks and phases live in `tasks.json`, maintained by the agent. You interact with the work, not the file.
3. **Continuity -** Remembers where you left off. Sessions start oriented: “You’re working on X, left off at Y, Z is up next.”
4. **Agent Coordination -** Every supported agent reads the same files, so you can switch between Claude Code, Codex, and Kiro without losing your place.

## Installation

Clone Steel Thread anywhere, then run the installer against your project:

```sh
git clone https://github.com/nbuggia/Steel-Thread.git
Steel-Thread/install.sh path/to/your-project
```

Then start your agent in the project and run the onboard skill:

| Agent | Command |
| --- | --- |
| Claude Code | `/onboard` |
| Codex CLI | `$onboard` |
| Kiro CLI | `/onboard` |

The installer has no dependencies beyond a POSIX shell. It:

- Copies the operating manual and templates into `.steel-thread/`
- Copies the skills into each agent's skills folder: `.claude/skills/`, `.agents/skills/`, and `.kiro/skills/`
- Adds a Steel Thread section to `AGENTS.md`, creating the file if needed. Your existing content is kept.
- Adds `@AGENTS.md` to the top of `CLAUDE.md`, creating the file if needed, so Claude Code reads the same instructions as the other agents

Commit everything it creates, so your whole team gets Steel Thread.

### Updating

Pull the latest Steel Thread and run the installer again. Files you haven't changed are updated. If you edited one of Steel Thread's files, the installer asks before overwriting it. Without a terminal to ask, it keeps your version. Your project state — `CONTEXT.md`, tasks, pickup notes, changelog, examples — is never touched.

To customize a skill without being asked on every update, add a new skill under a different name instead of editing a Steel Thread one.

## File structure

After installation and onboarding, your project looks like this:

```
your-project/
  AGENTS.md                        ← activates Steel Thread for every agent
  CLAUDE.md                        ← imports AGENTS.md for Claude Code
  CONTEXT.md                       ← what this project is, vocabulary, decisions
  .steel-thread/
    steel-thread.md                ← framework definition
    templates/                     ← starter files used by onboard
    install-manifest               ← written by the installer, don't edit
    tasks.json                     ← phases and tasks
    pickup.md                      ← current session state
    pickup-history.json            ← append-only session log
    changelog.json                 ← every change to project files
    examples/
      good/                        ← reference examples
      bad/                         ← anti-patterns
  .claude/skills/                  ← skills for Claude Code
  .agents/skills/                  ← skills for Codex CLI
  .kiro/skills/                    ← skills for Kiro CLI
```

The three skills folders hold identical copies. Each agent reads only its own.

## Skills

Four skills are included. Your agent suggests them when the moment calls for one, and you can invoke any of them directly (`/name` in Claude Code and Kiro, `$name` in Codex):

- **onboard** — set up or reframe a project via structured interview. Run this first.
- **recap** — show the current pickup note and optionally adjust it. Optional — the pickup note is kept current without it.
- **elevate** — one-question-at-a-time interview loop. Resolves ambiguity before any work begins. Used by onboard.
- **crit** — domain expert review after significant outputs. Steelmans first, then attacks. BLOCK/CONCERNS/CLEAN verdict.

## Contributing skills

Skills follow the `SKILL.md` format shared by Claude Code, Codex CLI, and Kiro CLI. To contribute:

1. Add a folder under `skills/<category>/<name>/` in this repo
2. Write `SKILL.md` following the format in existing skills. Frontmatter uses only `name` and `description`, plus `based-on` when crediting.
3. Skills based on existing open source work must credit the original in the `based-on` frontmatter field
4. Make sure the skill works in all three agents. Don't rely on features only one agent has.
5. Open a pull request

Skills call other skills by name rather than redefining their logic:

- `use the elevate skill` — one-question-at-a-time interview loop
- `use the crit skill` — domain expert critique after significant outputs

## Attribution

The elevate skill is based on Matt Pocock's [grill-with-docs](https://github.com/mattpocock/skills) pattern.

## License

MIT

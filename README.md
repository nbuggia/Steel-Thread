# Hashbang Agent Framework

The Hashbang Agent Framework is a lightweight project memory and task tracker for coding agents. It helps your agent remember decisions, track active work, and start each session with the right context. When the agent carries the operational overhead, you can go deeper into a problem, step back to reprioritize, or make a creative leap you couldn't make while managing details.

It works with **Claude Code**, **Codex CLI**, and **Kiro CLI**.

It gives your agent four practical capabilities:

1. **Context -** Remembers the project. The objective, vocabulary, constraints, and every significant decision — with the reasoning behind it — carry forward automatically.
2. **Tasks -** Remembers the work that needs to get done. Phases and tasks live in a plain checklist the agent maintains. You interact with the work, but can edit the list any time.
3. **Continuity -** Remembers where you left off. Sessions start oriented: “You’re working on X, left off at Y, Z is up next.”
4. **Agent Coordination -** Every supported agent reads the same files, so you can switch between Claude Code, Codex, and Kiro without losing your place.

## Installation

Clone Hashbang anywhere, then run the installer against your project:

```sh
git clone https://github.com/nbuggia/Steel-Thread.git
Steel-Thread/install.sh path/to/your-project
```

Then start your agent in the project and ask what's next:

| Agent | Command |
| --- | --- |
| Claude Code | `/hb-whats-next` |
| Codex CLI | `$hb-whats-next` |
| Kiro CLI | `/hb-whats-next` |

On a new project, it walks you through setup one step at a time, starting with the objective. After that, it's the command to reach for whenever you sit down to work: it tells you where you left off and what to do next.

The installer has no dependencies beyond a POSIX shell. It:

- Copies the operating manual and templates into `.hashbang/framework/`
- Copies the skills into each agent's skills folder: `.claude/skills/`, `.agents/skills/`, and `.kiro/skills/`
- Adds a Hashbang section to `AGENTS.md`, creating the file if needed. Your existing content is kept.
- Adds `@AGENTS.md` to the top of `CLAUDE.md`, creating the file if needed, so Claude Code reads the same instructions as the other agents

Commit everything it creates, so your whole team gets Hashbang.

### Updating

Pull the latest Hashbang and run the installer again. Files you haven't changed are updated, and skills Hashbang no longer includes are removed. If you edited one of Hashbang's files, the installer asks before overwriting it. Without a terminal to ask, it keeps your version. The installer only writes to `.hashbang/framework/` and the skills folders — your objective, tasks, decisions, and notes are never touched.

When updating an older Steel Thread installation, the installer migrates `.steel-thread/` to `.hashbang/`, replaces the managed `AGENTS.md` section, and replaces the old skill names with their `hb-` versions.

To customize a skill without being asked on every update, add a new skill under a different name instead of editing a Hashbang one.

## File structure

Everything Hashbang knows about your project lives in one hidden folder, `.hashbang/`, so it stays out of the way of your own files:

```
your-project/
  AGENTS.md                ← your file, plus a short Hashbang section
  CLAUDE.md                ← your file, plus @AGENTS.md for Claude Code
  .hashbang/
    OBJECTIVE.md           ← why this project exists, what done means
    CONTEXT.md             ← vocabulary, style, what the agent must never do
    TASKS.md               ← phases and tasks, in priority order
    DECISIONS.md           ← decisions and the reasoning behind them
    pickup.md              ← where you left off
    history/               ← session log and changelog
    examples/
      good/                ← reference examples
      bad/                 ← anti-patterns
    framework/             ← managed by the installer, don't edit
  .claude/skills/          ← skills for Claude Code
  .agents/skills/          ← skills for Codex CLI
  .kiro/skills/            ← skills for Kiro CLI
```

All-caps files are yours to read and shape; the agent keeps them current with your approval. Lowercase files are its working notes. The three skills folders hold identical copies, because each agent reads only its own.

## Skills

Four skills are included. Your agent suggests them when the moment calls for one, and you can invoke any of them directly (`/name` in Claude Code and Kiro, `$name` in Codex):

- **hb-whats-next** — recommends the single most valuable next step and gives you what you need to start it. On a new project, that's setup: objective, then context, then phases. On an established one, it rebuilds exactly where you left off inside a task. Run this first, and whenever you sit down to work.
- **hb-recap** — show the current pickup note and optionally adjust it. Optional — the pickup note is kept current without it.
- **hb-elevate** — interview loop, asked in rounds. Resolves ambiguity before work begins, and stress-tests a plan, decision, or diagnosis before you act on it. Used by hb-whats-next during setup.
- **hb-crit** — domain expert review after significant outputs. Makes the strongest case first, then attacks. BLOCK/CONCERNS/CLEAN verdict.

## Contributing skills

Skills follow the `SKILL.md` format shared by Claude Code, Codex CLI, and Kiro CLI. To contribute:

1. Add a folder under `project/skills/<name>/` in this repo
2. Prefix the folder and frontmatter name with `hb-`
3. Write `SKILL.md` following the format in existing skills. Frontmatter uses only `name` and `description`, plus `based-on` when crediting.
4. Skills based on existing open source work must credit the original in the `based-on` frontmatter field
5. Make sure the skill works in all three agents. Don't rely on features only one agent has.
6. Open a pull request

Skills call other skills by name rather than redefining their logic:

- `use the hb-elevate skill` — interview loop that clarifies intent or stress-tests a plan
- `use the hb-crit skill` — domain expert critique after significant outputs

## Attribution

The hb-elevate skill is based on Matt Pocock's [grill-with-docs, grill-me, and grilling](https://github.com/mattpocock/skills) skills.

## License

MIT

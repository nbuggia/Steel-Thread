# Hashbang Agent Framework

The Hashbang Agent Framework is a lightweight project memory and task tracker for coding agents. It helps your agent remember decisions, track active work, and start each session with the right context. When the agent carries the operational overhead, you can go deeper into a problem, step back to reprioritize, or make a creative leap you couldn't make while managing details.

It works with **Claude Code**, **Codex CLI**, or **Kiro CLI** — pick one per project.

It gives your agent four practical capabilities:

1. **Context -** Remembers the product. The objective, vocabulary, constraints, and every significant decision — with the reasoning behind it — carry forward automatically.
2. **Tasks -** Remembers the work that needs to get done. Phases and tasks live in a plain checklist the agent maintains. You interact with the work, but can edit the list any time.
3. **Continuity -** Remembers where you left off. Sessions start oriented: “You’re working on X, left off at Y, Z is up next.”
4. **Fits your stack -** Your agent tailors Hashbang's development process to your languages and platforms, and keeps those changes when Hashbang updates.

## Installation

Clone Hashbang anywhere, then run the installer against your project:

```sh
git clone https://github.com/nbuggia/Steel-Thread.git
Steel-Thread/install.sh --agent claude path/to/your-project
```

Use `--agent claude`, `--agent codex`, or `--agent kiro`. Without it, the installer detects the agent from the project's files, or asks.

Then start your agent in the project and ask what's next:

| Agent | Command |
| --- | --- |
| Claude Code | `/hb-whats-next` |
| Codex CLI | `$hb-whats-next` |
| Kiro CLI | `/hb-whats-next` |

On a new project, it walks you through setup one step at a time, starting with the objective. After that, it's the command to reach for whenever you sit down to work: it tells you where you left off and what to do next.

The installer has no dependencies beyond a POSIX shell. It:

- Copies the operating manual and templates into `.hashbang/framework/`
- Copies the skills into your agent's skills folder: `.claude/skills/`, `.agents/skills/` for Codex, or `.kiro/skills/`
- Keeps a pristine copy of what it installed in `.hashbang/upstream/`, so updates can tell your changes from Hashbang's
- Adds a Hashbang section to `AGENTS.md`, creating the file if needed. Your existing content is kept.
- Adds `docs/work/` to `.ignore`, creating the file if needed, so search tools skip planning docs
- For Claude Code, adds `@AGENTS.md` to the top of `CLAUDE.md`, creating the file if needed, so Claude Code reads the same instructions

Commit everything it creates, so your whole team gets Hashbang.

### Updating

Pull the latest Hashbang and run the installer again. Files you haven't changed are updated, and files Hashbang no longer includes are removed. Files you or your agent customized are never overwritten: the installer saves the new version beside them and asks you to run `hb-update`, which merges Hashbang's changes into yours and tells you what it adopted and skipped. The installer only writes to `.hashbang/framework/`, `.hashbang/upstream/`, your agent's skills folder, and `.ignore` — your objective, tasks, decisions, and notes in `docs/` are never touched.

### Customizing

Hashbang's files and skills are yours to change. Ask your agent to adapt them, or let `hb-dev-setup` tailor the development process to your stack during setup. Your agent logs each change and why in `.hashbang/customizations.md`, which is what lets `hb-update` keep your changes when it merges a new version.

When updating an older installation, the installer migrates `.steel-thread/` to `.hashbang/`, replaces the managed `AGENTS.md` section, and removes the unedited skill copies in other agents' folders.

## File structure

The files you read and approve live in `docs/`. Hashbang's own working files live in one hidden folder, `.hashbang/`, so they stay out of your way:

```
your-project/
  AGENTS.md                ← your file, plus a short Hashbang section
  CLAUDE.md                ← your file, plus @AGENTS.md for Claude Code
  docs/
    PRD.md                 ← why the product exists, what done means, and intent per feature
    CONTEXT.md             ← vocabulary, tenets, what the agent must never do
    TASKS.md               ← phases and tasks, in priority order
    BACKLOG.md             ← features for later
    DECISIONS.md           ← decisions and the reasoning behind them
    work/                  ← planning docs, one folder per task; never searched
    engineering/           ← architecture, conventions, contracts, testing
  .hashbang/
    pickup.md              ← where you left off
    customizations.md      ← what you changed in Hashbang, and why
    history/               ← session log and changelog
    framework/             ← Hashbang's manual, process, and templates; yours to customize
    upstream/              ← managed by the installer, don't edit
  .claude/skills/          ← skills, in your agent's folder (.agents/skills/ for Codex, .kiro/skills/ for Kiro)
```

All-caps files are yours to read and shape; the agent keeps them current with your approval. Lowercase files are its working notes.

A task's spec, design, and plans are scaffolding. When the task is done, the agent moves what lasts into tests, the PRD, and the engineering docs, and records where each piece went. The rest stays in `docs/work/` as history, which the agent never searches. The product's behavior lives in its tests, not in documents that go stale.

## Skills

Twelve skills are included. Your agent suggests them when the moment calls for one, and you can invoke any of them directly (`/name` in Claude Code and Kiro, `$name` in Codex):

- **hb-whats-next** — recommends the single most valuable next step and gives you what you need to start it. On a new project, that's setup: objective, context, stack, then phases. On an established one, it rebuilds exactly where you left off inside a task. Run this first, and whenever you sit down to work.
- **hb-tasks** — keeps your task list: adds, finishes, blocks, and reorders tasks, and plans phases. Ask it to show or reprioritize your tasks any time.
- **hb-recap** — show the current pickup note and optionally adjust it. Optional — the pickup note is kept current without it.
- **hb-elevate** — interview loop, asked in rounds. Resolves ambiguity before work begins, and stress-tests a plan, decision, or diagnosis before you act on it. Used by hb-whats-next during setup.
- **hb-crit** — expert review of a spec, a design, a diagnosis, or code. Makes the strongest case first, then attacks. BLOCK/CONCERNS/CLEAN verdict.
- **hb-dev-setup** — tailors the development process to your project's stack: engineering docs, design templates, review checks, and test commands. Runs during setup.
- **hb-spec** — shapes an idea into a spec for one task: what changes for the product's users and why, never how. Plans releases from the backlog.
- **hb-design** — writes the tech design for a task, with rigor fitted to the change's risk, and reviews it in a fresh context.
- **hb-slice** — splits a Complex design into thin vertical slices, each proven by a test or demo.
- **hb-close** — closes a finished task: moves what lasts out of its spec and design into tests and the docs, and records where each piece went.
- **hb-retro** — rolls up design-review data to show how well the design process is working.
- **hb-update** — merges a new Hashbang version into the files you've customized.

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
- `use the hb-crit skill` — expert review of a spec, a design, a diagnosis, or code

## Attribution

The hb-elevate skill is based on Matt Pocock's [grill-with-docs, grill-me, and grilling](https://github.com/mattpocock/skills) skills.

## License

MIT

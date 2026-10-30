# Prior Art: Project Memory Harnesses

What other agents, editors and community efforts do today for project memory, and what Steel Thread can learn from them. Researched 2026-10-09. Kiro, Cline Memory Bank and Agent OS were checked against their current docs; the other entries are from general knowledge and should be verified before borrowing from them.

## Summary

None of the tools below combines project context, tasks, session continuity and active help with thinking. Steel Thread's differentiator is the thinking layer (st-elevate, st-crit, cognitive elevation); where others are ahead is mechanics.

- **Borrow from Kiro:** markdown task files the editor makes interactive, and per-file rules for when context loads.
- **Borrow from Agent OS:** profiles as installable skill packs, an index so the agent loads only relevant context, and installing commands where the agent discovers them.
- **Avoid Memory Bank's failure modes:** reading everything every time, files going stale, and rewriting memory after every small change.
- **Note the trend:** Agent OS v3 dropped its task system because Claude Code now plans well on its own. Steel Thread's tasks need to justify themselves as project-level memory, not step-by-step execution.

## Kiro

AWS's agentic IDE (built on Code OSS) and CLI. The closest product to Steel Thread inside an editor: plain markdown files on disk, with the editor adding the interactive parts.

**Steering files** ([docs](https://kiro.dev/docs/steering/)) are Kiro's equivalent of CONTEXT.md.

- Three defaults: `product.md` (purpose, objectives), `tech.md` (stack, constraints), `structure.md` (file layout, patterns).
- Two scopes: workspace (`.kiro/steering/`) and global (`~/.kiro/steering/`). Workspace wins on conflict.
- Frontmatter sets when a file loads: `inclusion: always` (default), `fileMatch` with a glob, `manual`, or `auto` with a `name` and `description` the agent matches against.
- Files can reference live files with `#[[file:path]]`, including line ranges.
- `AGENTS.md` in the root or subdirectories is picked up automatically.

**Specs** ([docs](https://kiro.dev/docs/specs/)): a three-phase workflow per feature, one markdown file each.

1. `requirements.md`: user stories with acceptance criteria in EARS form ("WHEN <trigger> THE SYSTEM SHALL <response>"). Bugs get `bugfix.md`: current behavior, expected behavior, what must not change.
2. `design.md`: architecture, sequence diagrams, error handling, testing approach.
3. `tasks.md`: a checkbox list. The editor shows live status per task and runs one or all; independent tasks run in parallel "waves".

**Hooks** ([docs](https://kiro.dev/docs/hooks/)) fire a shell command or agent prompt on events like file save, tool use or session stop.

**Skills** ([docs](https://kiro.dev/docs/skills/)) load from `.kiro/skills/` and `~/.kiro/skills/`, appear as `/` commands, and activate automatically by description.

**Lessons**

- Markdown tasks with editor-rendered controls beat JSON. *(Adopted: TASKS.md.)*
- Per-file inclusion modes are the answer to CONTEXT.md growing without bound.
- A global layer plus a project layer gives beginners defaults and experts overrides.
- "What must not change" in bug specs is a cheap, high-value prompt for the coding pack.
- Hooks make upkeep happen without relying on the model to remember. Steel Thread avoids them for cross-agent compatibility, so upkeep stays instruction-based.

## Cline Memory Bank

A prompt pattern, not a product feature: custom instructions plus six markdown files the agent reads in full at the start of every task ([docs](https://docs.cline.bot/prompting/cline-memory-bank)). The most widely copied community approach.

| File | Holds | Changes |
| --- | --- | --- |
| `projectbrief.md` | Core requirements and goals | Rarely |
| `productContext.md` | Why it exists, user experience goals | Rarely |
| `systemPatterns.md` | Architecture, design patterns, component relationships | Occasionally |
| `techContext.md` | Stack, setup, constraints, dependencies | Occasionally |
| `activeContext.md` | Current focus, recent changes, next steps | Every session |
| `progress.md` | What works, what is left, known issues | Every session |

**Protocol.** The instructions open with "my memory resets completely between sessions" and require reading all files every task. Updates happen when the agent finds a new pattern, after significant changes, or when the user types "update memory bank".

**Where it struggles** (from its design and a [community guide](https://fast.io/resources/cline-memory-bank-guide/)):

- Read-everything-always: token cost grows with the project, with no rule for pruning.
- Updates depend on the model remembering or the user asking; otherwise files go stale.
- The opposite "write loop": the agent rewrites activeContext.md or progress.md after every minor change, burning tokens and invalidating the prompt cache.
- Six topic-split files overlap in practice.

**Lessons**

- Splitting files by how often they change is right. *(Steel Thread: CONTEXT.md vs. pickup.md.)*
- An explicit "update memory" command is the escape hatch users actually use. *(Steel Thread: st-recap.)*
- Checkpoint-based updates avoid the write loop. *(Adopted 2026-10-09.)*
- History files need a retention rule. *(Open.)*

## Agent OS

By Brian Casel / Builder Methods, now on v3. Its biggest lesson is what it removed: task breakdown, subagents and implementation orchestration, because Claude Code's plan mode and newer models now do that work ([v3 announcement](https://github.com/buildermethods/agent-os/discussions/310)).

**Structure** ([file structure](https://buildermethods.com/agent-os/file-structure)). A base install in `~/agent-os/` holds commands, scripts and **profiles** (e.g. `default`, `rails`), each a set of starter standards. A project install copies a profile in:

- `agent-os/product/`: `mission.md`, `roadmap.md`, `tech-stack.md`
- `agent-os/standards/`: one file per convention, grouped by domain, plus `index.yml` mapping each standard to a one-line description
- `agent-os/specs/<timestamp>-<name>/`: `plan.md`, `shape.md`, `standards.md`, `references.md`, `visuals/`
- `.claude/commands/agent-os/`: the slash commands

**Commands:** `/plan-product`, `/discover-standards` (proposes standards from patterns in the codebase), `/index-standards`, `/inject-standards` (pulls only relevant standards via the index), `/shape-spec` (targeted questions inside plan mode).

**Lessons**

- An index of one-line descriptions lets the agent find the right context without reading all of it.
- Profiles are a clean model for skill packs: `writing`, `knowledge`, `coding` copied in at setup, then owned by the user.
- Discovery beats interview when material exists: setup could read existing documents and propose vocabulary and style.
- Don't rebuild what the host agent already does; the coding pack should lean on plan mode.

## Other tools worth knowing

Not re-verified; from general knowledge as of mid-2026.

### Coding agents

- **GitHub Spec Kit** — `constitution.md` for non-negotiable rules (like CONTEXT.md's "never do"), and a fixed command sequence `/specify` → `/plan` → `/tasks`. A clear pipeline is easy for beginners.
- **Task Master (claude-task-master)** — parses a requirements doc into `tasks.json` with dependencies and complexity scores. Dependencies are the first feature people want once tasks exist.
- **Cursor rules** (`.cursor/rules/*.mdc`) — frontmatter controls loading: always, by glob, or agent-requested by description. The best model for keeping context small.
- **Windsurf Memories** — the agent writes memories on its own; users don't trust or review them. Evidence for Steel Thread's "propose, user approves" rule.
- **AGENTS.md** — the shared instructions file most agents now read. *(Adopted.)*
- **Agent Skills standard / Matt Pocock's skills** — the SKILL.md format and good examples of small, sharp skills. Codex reads `.agents/skills/` and invokes with `$name` ([docs](https://learn.chatgpt.com/docs/build-skills)).

### Writing

- **iA Writer** — marks which text was written by a human and which by AI. A trust feature a markdown editor is well placed to offer.
- **Lex** — AI writing focused on feedback rather than generation, close to the st-crit skill.
- **Frameworks to turn into skills:** Minto's Pyramid Principle, the Amazon 6-pager.

### Notes and knowledge base

- **Obsidian** — the de facto conventions for a markdown knowledge base: `[[wikilinks]]`, frontmatter properties, daily notes. Steph Ango's "File over app" argues files should outlive the app.
- **Methods:** Andy Matuschak's evergreen notes, Zettelkasten, Tiago Forte's PARA (Projects, Areas, Resources, Archives). PARA's project/area split maps to Steel Thread project folders.
- **NotebookLM** — answers grounded only in sources you provide; the model for a "synthesize my notes" skill that doesn't invent.
- **Obsidian plugins (Smart Connections, Copilot)** — show where AI helps in a vault (finding related notes) versus where it doesn't (writing notes for you).

## Sources

- [Kiro: Steering](https://kiro.dev/docs/steering/)
- [Kiro: Specs](https://kiro.dev/docs/specs/)
- [Kiro: Hooks](https://kiro.dev/docs/hooks/)
- [Kiro: Skills](https://kiro.dev/docs/skills/)
- [Cline: Memory Bank](https://docs.cline.bot/prompting/cline-memory-bank)
- [Fast.io: Cline Memory Bank guide](https://fast.io/resources/cline-memory-bank-guide/)
- [Agent OS v3 announcement](https://github.com/buildermethods/agent-os/discussions/310)
- [Agent OS: File structure](https://buildermethods.com/agent-os/file-structure)
- [Agent OS overview](https://buildermethods.com/agent-os)
- [Codex: Agent Skills](https://learn.chatgpt.com/docs/build-skills)

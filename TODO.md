# TODO

The review's verdict is CONCERNS. The core design holds up, but the process around it is too heavy for agents to follow reliably. Nothing has to be fixed before more work happens, but four findings are worth fixing before anyone relies on it daily. I checked the rigor-level wording and the code-review gap in development.md myself, and both are accurate. I haven't checked the other findings.

What it thinks is strong:

- Planning docs as scaffolding. Specs and designs get folded into tests and engineering docs, then never searched. That avoids the stale-spec problem in spec-kit, Kiro and BMAD.
- Test names as the behavior record. A behavior counts as a promise only if a test named for it checks it.
- Rigor levels with stated criteria, including "a trivial change's commit is the record."
- One home per fact across ARCHITECTURE, CONVENTIONS and DECISIONS.
- Gates that only stop for real decisions. The agent runs on its own and stops only for a high-judgment call or input only you have.
- Updates that keep your changes. hb-update merges new versions while keeping project customizations, which it says nothing else in this space does.

The four HIGH findings:

1. Too much instruction. An agent reads about 1,370 lines of framework before a typical Simple change. The manual alone is 165 lines read every session, and in practice files.md (287 lines) is read every session too. Agents will start dropping rules.
2. "Simple" isn't light, and new projects default to Complex. Simple requires following an existing convention, and a new project has none, so early features all land in the 16-section Complex process. Even the Simple design template has 8 tables.
3. Diffs barely get reviewed. Design docs get review passes, a review log and a retro. Code review is one table cell, and there's no git workflow (branches, PRs, CI). In agent-written software, the bugs are in the diff.
4. The README promises team use, but the files don't support it. IDs are "highest plus one," so two branches will produce the same IDs. There's a single shared pickup note, and the append-only history files will conflict on merge.

Medium findings:

- The same rules are copied across files and already drifting. "Never search docs/work" appears in five files, and hb-crit and development.md disagree on when a diagnosis gets reviewed.
- "User" means two things. hb-design uses it to mean you, though hb-spec reserves "customer" for that.
- Some skills don't earn their place. It recommends cutting hb-recap, moving hb-retro and its review log to library/, separating hb-elevate (interactive, about intent) from hb-crit (adversarial, about finished work), and dropping the rule that every TASKS.md checkbox edit goes through hb-tasks.
- The review gates need subagents. Without one, a review becomes the agent reviewing its own work. It also isn't confirmed that Kiro's search respects .ignore.
- changelog.json duplicates git.

Its top five changes:

1. Redefine Simple as "adds no new boundary, file format or contract," and cut the Simple design to about 30 lines.
2. Cut always-loaded instructions to about a third, with each rule stated in one place.
3. Add a diff-review row to the rigor table and a short git section to development.md, paid for by archiving hb-retro.
4. Decide the team story: make pickup and history per-developer, or drop the "whole team" claim.
5. Go from 12 skills to 10.

My take: I agree most with #1 and #3. They're cheap, and they put rigor where agents actually make mistakes. #2 is the biggest job and would be easier after #5 and the hb-elevate trim we discussed. #4 needs your call: is Hashbang for solo developers or for teams?

The coding-only changes are still uncommitted. Want me to commit them first, then work through these in order?

## Review findings (hb-crit, 2026-10-28)

Remaining HIGH and MEDIUM findings from the coding-only review, in suggested order. Done so far: Complex triggers, the slim Simple design, and diff review (322c2c2).

- [ ] **M3 — Prune skills (12 → 10).** Cut hb-recap. Move hb-retro, its script, and the design-review log to `library/`, and drop the review-log duty from hb-design and hb-close. Make TASKS.md checkbox edits possible without loading hb-tasks; keep hb-tasks for planning and reprioritizing.
- [ ] **M3 — Split hb-elevate from hb-crit.** hb-elevate is interactive and about intent; hb-crit is adversarial and about work products. Remove "Challenge" and "diagnosis" from hb-elevate. Change development.md's "ask one question" to "resolve what's blocking in one hb-elevate session."
- [ ] **H1 — Cut always-loaded context to about a third.** About 1,370 lines of framework load before a Simple change. Trim hashbang.md to about 60 lines (drop Philosophy, the vocabulary scripts, Cognitive Elevation, and What Good Looks Like down to a five-line version). Split files.md by file, or move each format into its template. Stop hb-design from reading the review log.
- [x] **M1 — State each rule once.** Done: the docs/work rule lives in docs-layout.md (hard rule 5 summarizes it), the diagnosis rule agrees, hb-design states its review framing once, hb-whats-next defers to the session start, and only hb-close hands off to hb-whats-next. "Never search docs/work" appears in five files; the no-link and work-entry naming rules are in both development.md and docs-layout.md; hb-design's review prompt appears twice; hb-whats-next repeats the session start. Keep location rules in docs-layout.md and process rules in development.md, and have every other file point to them. Fix drift found on the way.
- [ ] **H3 — Add a minimal git workflow.** A short Git section in development.md: a branch or worktree per task, and PR and CI as TESTING.md configures them. (Diff review is done. Commits are done: the agent commits each slice itself, per Commits in development.md.)
- [x] **H4 — Decide the team story.** Decided: individual developers only; the README says so. IDs are "highest plus one", pickup.md is a single shared note, and the append-only history files conflict on merge. Either drop the "whole team" claim from the README, or make pickup and history per-developer (gitignored), allow several tasks in flight, and say how ID collisions are resolved at merge.
- [ ] **M5 — Drop changelog.json under version control.** It duplicates git. Read `git log -- docs/` instead, and keep the changelog only for projects without version control, or drop it entirely.
- [ ] **M4 — Document the no-subagent fallback.** hb-design's fresh-context review passes have no fallback; hb-crit's "set aside what was said" is self-review. Offer the copy-paste external review prompt as the fallback, and say the gate is weaker. Confirm Kiro's search honors `.ignore` before claiming it.
- [ ] **M2 — Fix "user" vs. "customer" in hb-design.** hb-spec defines users as whoever consumes the change and the customer as the person you're working with; hb-design uses "the user" for the customer.

## Development

- diagnose
  - pull in matt’s diagnose and pick what I want
  - root cause the issue, show evidence for why confident (or call out when not confidenti)
    - define confidence levels to determine the best course of action — instrument to learn more, or ready to fix.
  - Propose high level appraoch to fix it
  - State level of risk (define each level, tie it to the tech design levels)
  - use the hb-elevate skill to stress-test the root cause and fix
  - ask me if I want to create a task
- feature spec
  - who is the customer, and what is the benefit they will get from this feature?
  - who is not the customer and what else is out of scope?
  - Pressure test the scope and give feedback on when to break into multiple spec docs.
  - Primary use cases that need to be great.
- UI Mock
  - Create an HTML file in-line with options
  - Consolidate options into a final redline. Save options in the appendix
  - Create UI requirements with redlines
  - Update some central source for a UI framework
- retro
  - Review the output of all the design sessions and suggest improvements.
  - Audit all the files for drift and duplication.
  - Remove duplicative content
- implementation
  - All versions should suggest a commit message

## Framework

- Eval harness: scenarios that drive real agent CLIs against a test project and check what each run leaves behind. Design and prior art in `research/evaluation.md`. Start with cold resume, a Trivial bug, and stop-then-resume on another machine, on Claude Code.

- Friction log, after Warp's `suggestion-box` (archived in `library/warp-common-skills/`). When Hashbang's process gets in an agent's way, such as an unclear or conflicting rule, a step that cost effort with no value, or context it had to rebuild, the agent appends one short entry to a file in `.hashbang/history/` without interrupting the work: category, what happened, the impact, and a suggested change. Keep Warp's limits: only friction actually seen, only causes that would recur, at most three entries a session, and no secrets or user content. hb-retro reads the log and proposes framework changes.
- Switching agents moves only `hb-*` skills to the new agent's folder (install.sh), so a project's convention skills stay behind in the old folder. Move the skills CONVENTIONS.md lists too, or tell the customer which ones to move.
- After 1.0.0: add agent-facing release notes (what changed in each version, and why) to `project/.hashbang/framework/`, and have hb-update read them so it can carry Hashbang's intent into heavily customized files.
- Replace the TASKS.md read in the Session Start Protocol (hashbang.md, step 4) with a call to the app's CLI that returns active tasks, once the CLI exists.
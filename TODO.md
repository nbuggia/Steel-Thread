# TODO

## Review findings (hb-crit, 2026-10-28)

Remaining HIGH and MEDIUM findings from the coding-only review, in suggested order. Done so far: Complex triggers, the slim Simple design, and diff review (322c2c2).

- [ ] **M3 — Prune skills (12 → 10).** Cut hb-recap. Move hb-retro, its script, and the design-review log to `library/`, and drop the review-log duty from hb-design and hb-close. Make TASKS.md checkbox edits possible without loading hb-tasks; keep hb-tasks for planning and reprioritizing.
- [ ] **M3 — Split hb-elevate from hb-crit.** hb-elevate is interactive and about intent; hb-crit is adversarial and about work products. Remove "Challenge" and "diagnosis" from hb-elevate. Change development.md's "ask one question" to "resolve what's blocking in one hb-elevate session."
- [ ] **H1 — Cut always-loaded context to about a third.** About 1,370 lines of framework load before a Simple change. Trim hashbang.md to about 60 lines (drop Philosophy, the vocabulary scripts, Cognitive Elevation, and What Good Looks Like down to a five-line version). Split files.md by file, or move each format into its template. Stop hb-design from reading the review log.
- [ ] **M1 — State each rule once.** "Never search docs/work" appears in five files; the no-link and work-entry naming rules are in both development.md and docs-layout.md; hb-design's review prompt appears twice; hb-whats-next repeats the session start. Keep location rules in docs-layout.md and process rules in development.md, and have every other file point to them. Fix drift found on the way.
- [ ] **H3 — Add a minimal git workflow.** A short Git section in development.md: a branch or worktree per task, a commit per slice, and PR and CI as TESTING.md configures them. (Diff review is done.)
- [ ] **H4 — Decide the team story.** IDs are "highest plus one", pickup.md is a single shared note, and the append-only history files conflict on merge. Either drop the "whole team" claim from the README, or make pickup and history per-developer (gitignored), allow several tasks in flight, and say how ID collisions are resolved at merge.
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

- Friction log, after Warp's `suggestion-box` (archived in `library/warp-common-skills/`). When Hashbang's process gets in an agent's way, such as an unclear or conflicting rule, a step that cost effort with no value, or context it had to rebuild, the agent appends one short entry to a file in `.hashbang/history/` without interrupting the work: category, what happened, the impact, and a suggested change. Keep Warp's limits: only friction actually seen, only causes that would recur, at most three entries a session, and no secrets or user content. hb-retro reads the log and proposes framework changes.
- Switching agents moves only `hb-*` skills to the new agent's folder (install.sh), so a project's convention skills stay behind in the old folder. Move the skills CONVENTIONS.md lists too, or tell the customer which ones to move.
- After 1.0.0: add agent-facing release notes (what changed in each version, and why) to `project/.hashbang/framework/`, and have hb-update read them so it can carry Hashbang's intent into heavily customized files.
- Replace the TASKS.md read in the Session Start Protocol (hashbang.md, step 4) with a call to the app's CLI that returns active tasks, once the CLI exists.

# TODO

Open work only; finished items are in git history. Decided so far: Steel Thread is a development process that includes memory, not a memory tool with an optional process, and it is for individual developers, not teams.

## Review findings

From the st-crit reviews of 2026-10-28 (coding-only) and 2026-10-29 (does the framework achieve its objectives), in suggested order.

- [ ] **H2 — Commit the memory files.** Nothing the agent commits includes pickup.md, `customizations.md`, `review-log.md`, or CONTEXT.md and DECISIONS.md edits made outside a task: Commits in development.md stages only "the files the work changed", st-verify checkpoints pickup.md after the slice commit, and st-close's commit lists close.md, the lasting documents and TASKS.md. So the pickup note doesn't travel to another machine, the session start scopes its git log by a stale date, and steel-thread.md's "earlier notes are in git history" is false. Add a rule to Commits: Steel Thread's memory files go in the next commit, and the checkpoint when the customer stops commits them on their own.
- [ ] **H1 — Cut always-loaded context.** steel-thread.md is 92 lines; trim it to about 60 by dropping Philosophy and shortening the vocabulary guidance under Keeping the Customer's Files. (Done: files.md split into `files/`, and st-design no longer reads a review log.)
- [ ] **H3 — Add a minimal git workflow.** A short Git section in development.md: a branch or worktree per task, and PR and CI as TESTING.md configures them. Commits today only says "commit on the current branch."
- [ ] **Positioning follow-ups.** Write a README around the process, saying it is for individual developers. Replace "persistent project memory and task management" in this repo's AGENTS.md and in `project/AGENTS.md`. Fold any of Philosophy worth keeping into the README (see H1).
- [ ] **M3 — Let TASKS.md checkbox edits skip st-tasks.** Hard rule 3 in steel-thread.md still routes every TASKS.md change through st-tasks. Allow ticking a checkbox directly; keep st-tasks for adding, planning, and reprioritizing.
- [ ] **M3 — Split st-elevate from st-crit.** st-elevate is interactive and about intent; st-crit is adversarial and about work products. Remove Challenge and "diagnosis" from st-elevate (its description, modes, and challenge guidance). Change development.md's "ask one question" (line 20) to "resolve what's blocking in one st-elevate session."
- [ ] **M4 — Document the no-subagent fallback.** reviews.md's fallback is self-review ("set aside what this session said"). Offer st-design's copy-paste external review prompt as the fallback for every review, and say the gate is weaker without one. Confirm Kiro's search honors `.ignore` before docs-layout.md claims it.
- [ ] **M2 — Fix "user" vs. "customer" in st-design.** st-spec defines users as whoever consumes the change and the customer as the person you're working with; st-design uses "the user" for the customer (§2, §3, the Simple-ready check, and External Review).

## Development

Ideas for the process, not yet specs. What's already covered: bugs (development.md's Bugs: diagnose with confidence, probe when unsure, size it), spec framing (st-spec's For / Not for, Use Cases, Not Doing, and splitting), UI prototypes with side-by-side options, and commits with messages at every rigor level.

- **Diagnose:** pull in Matt Pocock's diagnose skill and pick what to keep. Define confidence levels and what each one leads to (instrument more, or fix). Stress-test the root cause and fix with st-elevate at Complex rigor. Ask before creating a task.
- **UI mocks:** keep the options not chosen in the prototype's appendix, write redlines into the spec's UI section, and keep a central record of the product's UI conventions.
- **Retro:** bring back a retro (archived in `library/st-retro/`) that reviews design sessions and `review-log.md`, audits the files for drift and duplication, and proposes cuts.

## Framework

- Eval harness: scenarios that drive real agent CLIs against a test project and check what each run leaves behind. Design and prior art in `research/evaluation.md`. Start with cold resume, a Trivial bug, and stop-then-resume on another machine, on Claude Code.
- Friction log, after Warp's `suggestion-box` (archived in `library/warp-common-skills/`). When Steel Thread's process gets in an agent's way, such as an unclear or conflicting rule, a step that cost effort with no value, or context it had to rebuild, the agent appends one short entry to a file in `.steel-thread/history/` without interrupting the work: category, what happened, the impact, and a suggested change. Keep Warp's limits: only friction actually seen, only causes that would recur, at most three entries a session, and no secrets or user content. A retro reads the log and proposes framework changes.
- Switching agents moves only `st-*` skills to the new agent's folder (install.sh), so a project's convention skills stay behind in the old folder. Move the skills CONVENTIONS.md lists too, or tell the customer which ones to move.
- After 1.0.0: add agent-facing release notes (what changed in each version, and why) to `project/.steel-thread/framework/`, and have st-update read them so it can carry Steel Thread's intent into heavily customized files.
- Replace the TASKS.md read in the Session Start Protocol (steel-thread.md) with a call to the app's CLI that returns active tasks, once the CLI exists.

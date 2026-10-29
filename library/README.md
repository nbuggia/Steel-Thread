# Library

Skills and ideas from other projects, kept here while we decide how to bring them into Hashbang. Nothing in this folder is installed: `install.sh` copies only `project/`, and no agent loads skills from here.

Each source gets its own folder, with its license and the commit it was copied from. Files are kept as copied, so they can be compared with their source later.

## hb-retro/

Hashbang's own retro skill, retired from the product in 0.11.0. It rolled up the design review log, which hb-design no longer writes, to show how well the design process was working. Kept as a starting point if process metrics come back, for example through the friction log in `TODO.md`.

## warp-common-skills/

From [warpdotdev/common-skills](https://github.com/warpdotdev/common-skills) at commit `8792394ff1b655e0af451b8fabb68ef0cfcbd208` (2026-10-20). MIT license, in `warp-common-skills/LICENSE`; keep it with any copy.

| Skill | What it does | Integration notes |
| --- | --- | --- |
| `skill-doctor` | Grades skills by scoring real agent transcripts for efficiency, procedure compliance, code quality, and verbosity, then drafts skill edits | Reads Claude Code and Codex transcripts, not Kiro's. Could grade how well hb- skills are followed. |
| `resolve-merge-conflicts` | Extracts only conflicting paths and hunks instead of loading whole files | Stack-agnostic; plain git. |
| `diagnose-ci-failures` | Pulls CI logs through the `gh` CLI and plans the fixes | Needs `gh`. Its check names are Warp's. |
| `write-pr-description` | Writes a PR body from the repo's template, with a reviewer reading order | Stack-agnostic. |
| `research` | Delegates noisy investigation to a subagent and works from the distilled answer | Needs subagents, which Kiro lacks, so it can't ship in Hashbang without a fallback. |
| `suggestion-box` | Lets an agent report friction with its tools or process, quietly and in a fixed format | Reference for the friction-log idea in `TODO.md`. Its `submit.py` posts to a Slack webhook; Hashbang would write to a local file instead. |

## warp/

From [warpdotdev/warp](https://github.com/warpdotdev/warp) at commit `1e6c3ae465d6a925a9b97ae03877aaadd159b8f1`, `.agents/skills/`. **AGPL-3.0**, in `warp/LICENSE-AGPL`: only Warp's `warpui` crates are MIT. Use these for ideas only. Don't copy their text into Hashbang, which is MIT, or into a customer's project; write our own from the ideas instead.

| Skill | What it does | Ideas to take |
| --- | --- | --- |
| `tui-verify-change` | Verifies a TUI change by building it, running it under tmux, reading the rendered screen back, and locking the result in with a snapshot test | A verify-by-running convention skill for GUI apps: build, run, capture the screen (for macOS, `screencapture` or an XCUITest screenshot), compare it with the intended change, then add a snapshot test. |
| `gui-ui-guidelines` | A growing list of UI rules, each a lesson that would otherwise be relearned in review, with red flags for a diff | The shape of an area-guidelines convention skill: reuse shared components and themes unchanged, and list the red flags, such as one-off themes and hard-coded colors. |
| `rust-unit-tests` | What to unit test and when not to, where tests live, and how to write them | General Rust test rules for a Tauri core: test through the public API, assert on state rather than interactions, one behavior per test named after it, prefer duplication over indirection, no logic in tests, prefer real code then fakes, and keep tests deterministic. |

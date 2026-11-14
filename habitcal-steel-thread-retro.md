# Steel Thread Retro: HabitCal

**Period covered:** October 29 – November 14, 2026
**Written:** November 13, 2026

---

## Contents

1. [Sources](#sources)
2. [Part 1: Retro](#part-1-retro)
   - [What was most useful](#what-was-most-useful)
   - [What was least useful, or caused friction](#what-was-least-useful-or-caused-friction)
   - [Suggested changes](#suggested-changes)
3. [Part 2: Two bugs Steel Thread missed](#part-2-two-bugs-steel-thread-missed)
4. [Part 3: Is CONVENTIONS.md worth keeping?](#part-3-is-conventionsmd-worth-keeping)

---

## Sources

This retro draws on:

- **The session log** on this Mac, covering October 31 – November 14: 87 customer messages and 16 review agents.
- **Everything Steel Thread produced:** `.steel-thread/`, `docs/` (TASKS, DECISIONS, CONTEXT, BACKLOG, PRD, review-log), 18 `docs/work/` folders (about 55k words), and 120 commits.

The logs for October 29–30 (T-001 to T-029) aren't on this Mac, so that work was judged from what it produced.

---

## Part 1: Retro

### What was most useful

Ranked by value.

#### 1. Fresh-context reviews (st-crit diff and design reviews)

`review-log.md` records 79 findings, 15 of them MAJOR, and almost all were fixed before the customer saw them. Nothing else in the process comes close for value per token.

- **T-039 (sync):** caught bugs that would have lost or hidden data: deletes dropped at first sync, habits paired twice, and failed sends showing "Synced". The follow-up check found 2 more.
- **T-035:** found error-path tests that couldn't fail.
- **T-028:** found a schedule edit that rewrote every past day.

#### 2. Spikes before risky designs (FM-012)

This was learned the hard way. D-005 rejected MenuBarExtra on a claim nobody had tested, and it cost T-017, T-027, and a full rework (T-029). After that, the CloudKit spike and the file-dialog spike both changed their designs before any code was written.

#### 3. DECISIONS.md, CONTRACTS.md, and the PRD as guardrails

- **TestFlight:** when asked about it, the agent said no and cited the PRD's GitHub constraint, so the later switch became a clean D-011. D-011 then surfaced App Store guideline 2.4.5, which became D-012.
- **The ⌘Q hotkey:** when asked to remove it, the agent flagged the contract, kept the shortcut, and dropped only the label.

#### 4. Spec-stage questions

There were 14 AskUserQuestion calls, all about product choices, and each was answered in one line ("merge them… import should replace on every Mac").

- They raised edge cases nobody had asked about, such as red dots for days before a habit was added, and a Mac joining after a restore.
- The question "any product decisions that simplify the design?" unblocked the T-039 design.

#### 5. Orientation (st-whats-next and the pickup note)

Work resumed after gaps of 3 days and 7 days without re-explaining anything. "whats next" was the only prompt needed to start the session.

---

### What was least useful, or caused friction

#### 1. The test and close gates don't fit how the work actually happens

The customer chose "commit and keep going, test later", which is also saved in memory. The process has no state for "coded, waiting for the customer's test pass". As a result:

- T-029, T-035, T-039, and T-041 have been "coded, outstanding: UI tests…" for about 2 weeks.
- T-036 to T-038 and T-040 are marked done with "not yet run".
- st-close ran once in 2 weeks.
- The real status lives in prose on the TASKS lines.

#### 2. Approval-gated files go stale

The pickup note's Proposed Updates section has 7 items, some from October 29–30, and none were ever approved or dropped. The damage is visible:

- **CONTEXT.md contradicts the code.** "Due day" still says "on or after the habit was added", which T-028 removed. That breaks hard rule 8, which says to follow CONTEXT's vocabulary exactly.
- **BACKLOG.md is out of date.** It still lists "Mac App Store release" and "Export / backup" as Later, but both are now built or in progress.

#### 3. pickup.md breaks down in one long session

- It still reads `S-004 · 2026-10-31` two weeks later. A session ID only changes when a new session starts, and this one session ran for two weeks.
- New paragraphs were appended out of order.
- "In Flight" holds conflicting T-035 entries ("next: the tech design" next to "both slices coded").

The note is meant to let the customer stop at any moment, but a cold reader would now be confused.

#### 4. Complex-task paperwork outweighs its payoff

T-039 alone produced about 13.5k words, plus 2 design review passes and a blocker check:

| Document | Words |
| --- | ---: |
| Design | 7,090 |
| Slices | 3,259 |
| Spec | 3,117 |

The bugs that mattered were found by the diff review, not the design reviews. The customer's replies to that paperwork were almost all "go ahead". And since hard rule 5 says never to search `docs/work/`, these documents are mostly written once and never read again.

#### 5. Small requests skip the process entirely, including some that aren't small

The November 1–2 polish commits and the November 13 leaderboard rework have no T-ID. The leaderboard rework changed scoring rules (it reverses T-028 B.4 for the ranges) with no spec, no decision, and no task. The diff review still ran, which is good. The earlier T-030 retro flagged the same kind of drift.

#### 6. The process's self-improvement loop isn't working

The T-030 retro wrote 1,085 words and 5 proposals, and none of them were applied.

#### 7. Hard rule 4 (state the rigor level and why) is barely followed

Only about 2 of 212 assistant messages name the criterion that decided the level.

#### Not used

st-elevate, st-dev-setup, and st-update weren't used in the logged period. st-tasks ran 7 times, which is cheap and harmless.

---

### Suggested changes

In order of payoff:

1. **Add a first-class "awaiting test pass" status** to TASKS, with one rolling `docs/manual-tests/next-pass.md` checklist. A task closes automatically once its checks pass.
2. **Batch approvals.** At each natural break, put every proposed update in one multi-select question. Let the agent remove BACKLOG rows on its own once their work exists as tasks.
3. **Start a new pickup note when the date changes, not when a session ends**, and rewrite "In Flight" in full rather than appending to it.
4. **Require a T-ID and a decision for anything that changes a PRD rule**, however small the request sounds.
5. **Cap Complex designs** at about 2,500 words, and keep the effort on the diff review, which is where the value showed up.
6. **Keep st-crit, the spikes, and DECISIONS exactly as they are.**

---

## Part 2: Two bugs Steel Thread missed

From a code audit on November 13, 2026.

A full read of the source after the retro found two bugs that every review had missed. Both are now fixed.

| Commit | Area | Bug |
| --- | --- | --- |
| 33c8998 | Calendar | On a Mac set to a non-Gregorian calendar, dates came out wrong. Today read as 2569-11-13 on the Buddhist calendar, the default for Thai users. |
| df5d09d (T-042) | Sync Now | After a save iCloud refused, Sync Now stayed on "Syncing…" until a relaunch. |

Both slipped through for structural reasons, not because a reviewer was careless.

### Bug 1: Calendar — the project's own rules pointed the wrong way

**The convention created the bug.** `CONVENTIONS.md:23` and FM-005 both say to use `Calendar.autoupdatingCurrent` "wherever the Mac's settings matter." The code followed that rule exactly, and that is where the bug comes from. The rule treated "the Mac's settings" as one thing. HabitCal should follow the Mac's time zone and first weekday, but it must not follow the Mac's calendar system. No document made that distinction.

**The checklists named neighbouring risks, not this one.** FM-002 covers storing instants instead of days, and the design red flags cover "dates as instants." Reviewers check work against those lists, and neither mentions the calendar system. The T-002 design even says "`weekday` uses the Gregorian calendar" without asking where the year, month, and day come from.

**The tests varied the wrong thing.** `DayTests` checks two time zones, both on a Gregorian calendar. No test changed the calendar system, so nothing could fail.

**Moving to the App Store changed the audience, and nothing re-checked the old assumptions.** v1 was planned as an English-only GitHub download. D-011 moved it to a worldwide store, which brings in Thai users, whose default calendar is Buddhist. Recording the decision didn't set off any review of what it changed.

### Bug 2: Sync Now — an unreviewed fix to a review finding

**It was introduced by commit c23a023** ("T-039: verification fixes"). That commit fixed a finding that failed sends were hidden behind "Synced". The fix stopped the false "Synced", but left "Syncing…" in its place. After that commit, the session log shows the agent telling the customer on November 2: "a reviewer confirmed most of the sync fixes, but nobody has re-checked the final two." This was one of those two.

**The review budget ran out at exactly the riskiest point.** `reviews.md` says that after the first full pass, later passes check only what changed and the earlier blockers. The verification pass checked the blockers. The fixes the verification pass itself triggered had no pass left.

**The rule sat where no test could reach it.** The T-039 design puts sync rules in `SyncPolicy` so they can be unit-tested without CloudKit. The status rule ended up in `HabitSync.markSynced()`, which talks to CloudKit and has no tests. The 142 unit tests passed because none of them touched it.

**The checks that could have caught it don't cover this path, and haven't run.** The slice's manual demo checks only the happy path ("Syncing…" then "Synced"). The UI test fixes the sync status with a launch argument, so it never runs real sync. The CloudKit checks are part of the customer's testing pass, which hasn't happened yet.

### The common pattern

- Reviews check work against what the project's documents already list as risks. Both bugs were in places the documents didn't cover, or covered wrongly.
- The last change in a chain of fixes is the one least likely to be reviewed or tested.

### Changes that would have caught them

1. **Fix the calendar rule and add a failure mode.** Rewrite `CONVENTIONS.md:23` as: *"Follow the Mac's time zone and first weekday; always compute dates on the Gregorian calendar."* Add an FM-013 for this calendar bug, with a test that sets a non-Gregorian calendar as its detection.
2. **Review fixes that come out of a review.** When a finding's fix changes code, the diff of that fix gets one short review. It doesn't need a full pass.
3. **When a decision widens who the product is for, revisit the assumptions that relied on the old audience.** D-011 should have prompted a quick look at what "English-only GitHub download" had let the project assume.
4. **Keep logic out of code that can't be tested.** For a component that wraps something untestable (CloudKit, the panel), the diff review checks that no decision logic was left inside the wrapper.

---

## Part 3: Is CONVENTIONS.md worth keeping?

Added November 13, 2026.

> **Recommendation:** keep it, but cut it to about a third of its size.

Treating the code as the convention is right for most of the file. It fails for the part that matters most: the rules the code can't explain.

### What's in it now

The file is 61 lines, holding three kinds of rule.

**Layout and naming** — where files go, one view per file, names.

- *Example:* "Rules go in HabitCalKit; screens in `Views/`."
- *Could the code replace it?* **Yes.** It's visible in the code, and an agent copies it anyway. This is about 40% of the file.

**Gotchas** — the obvious approach fails, and the code doesn't say why.

- *Examples:* Esc must go through `AppModel.escape()`, because `.onExitCommand` needs focus. `@FocusState` must be set one run-loop turn later. A text field clamps its own `@State`.
- *Could the code replace it?* **No.** The code shows what was done, not that the obvious alternative breaks. These cost real bug rounds (FM-006, FM-010) and are the most valuable lines in the file.

**Invariants and policy** — rules you can't see by looking at one file.

- *Examples:* Only `HabitStore` touches the data file. No network requests. No force-unwraps on data read from disk. Comment style.
- *Could the code replace it?* **No.** A single file never shows the boundary it doesn't cross.

### Evidence from this project

- **It's rarely cited.** In the session log, CONVENTIONS.md mostly appears because skills load it and pass it to reviewers. The agent cited a specific line only a few times: the comment rules and the `HabitStore` boundary.
- **It goes stale and then enforces the stale version.** The Dates section still says to convert "with the user's current calendar and time zone." That's the calendar bug fixed in 33c8998, written as a rule. The file hasn't changed since November 1, and "check new screens by screenshot" was never followed.
- **"Use the code as the convention" carries the same risk.** The calendar bug was in the code too, so an agent copying the pattern copies the bug. Neither approach protects you unless a rule carries its reason, so someone can tell when the reason no longer holds.

### Proposed changes

1. **Delete what the code already shows:** Structure, Naming, State, and most of Boundaries. Replace them with one line:
   > *Follow the pattern the surrounding code uses. A new pattern, or a departure from an existing one, needs a one-line reason in the design or the commit.*

   Reviews can check that.
2. **Keep the gotchas and invariants, and give each one its reason**, with a link to its FM- or D- entry. A rule with a reason can be judged; a bare rule just gets obeyed. Fix the Dates rule while doing this.
3. **Fix a wrong rule when you find it, rather than validating every pattern first.** Validating old patterns before anyone may use them isn't a workable gate: there's no clear way to do it, and it would stall small changes. Instead, a change that finds a pattern or rule is wrong fixes the rule in the same commit. That is what should have happened with the calendar rule.

The result would be about 20 lines that are all reasons, plus the one-line instruction to follow existing patterns. If applied, log it in `.steel-thread/customizations.md` so Steel Thread updates keep it.

### Section by section

What happens to each section of the current `docs/engineering/CONVENTIONS.md` under the proposal:

| Section | Rules | Verdict |
| --- | ---: | --- |
| Structure | 4 | Cut |
| Boundaries | 4 | Keep 3, with reasons |
| Dates | 3 | Keep, and fix |
| Popover | 9 | Keep all, with reasons |
| Naming | 2 | Cut |
| Errors | 2 | Keep 1 |
| State | 2 | Cut |
| Comments | 4 | Keep |
| Convention Skills | 1 line | Keep |

**Structure — cut.** Folder layout and one view per file are visible in the code. The note that folder-synced groups need no project-file edit could move to ARCHITECTURE.md.

**Boundaries — keep 3, with reasons.** These are invariants no single file shows:

- HabitCalKit never imports AppKit.
- Only `HabitStore` touches the data file (D-004, D-006).
- Never make a network request (D-007, D-010).

"Views never compute due days" is visible in the code, so it's cut.

**Dates — keep, and fix.** "Convert at the edge with the user's current calendar" caused the calendar bug. It becomes: follow the Mac's time zone and first weekday, and always compute dates on the Gregorian calendar (FM-002, FM-005, new FM-013). "Today comes only from `AppModel.today`" (FM-007) stays.

**Popover — keep all, with reasons.** The most valuable section: Esc handling, focus timing, field clamping, segmented pickers, and doubled accessibility labels. Each one cost a bug round, and the code doesn't show why the obvious alternative fails. Drop "check new screens by screenshot", which was never followed, or make it a real gate.

**Naming — cut.** Spec vocabulary is already in CONTEXT.md; test naming is already in TESTING.md.

**Errors — keep 1.** "No `try!`, `fatalError`, or force-unwrap on data read from disk" is a policy. The rule about how the app shows store errors is visible in the code, so it's cut.

**State — cut.** `AppModel` as the one source of UI state is visible in the code. "Every habit change calls `persist()`" is already broken on purpose for changes from iCloud (`applyRemote` saves without re-sending), so it's better stated as a reason in the code.

**Comments — keep.** Taste rules an agent can't infer from the code, and they were cited in reviews.

**Convention Skills — keep.** The pointer the skills read.

Roughly 20 lines remain, each carrying its reason, plus the new line: *"Follow the pattern the surrounding code uses. A new pattern, or a departure from an existing one, needs a one-line reason in the design or the commit."*

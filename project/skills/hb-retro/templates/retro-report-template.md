---
name: hb-design retro
date: YYYY-MM-DD
covers: [earliest review-log date] to [latest review-log date]
---

# hb-design Retro: YYYY-MM-DD

[One paragraph: is the process converging or drifting? Lead with the answer, not the data.]

## 1. Rigor-level distribution and blocks

| Rigor   | Count |
| ------- | ----- |
| Trivial |       |
| Simple  |       |
| Complex |       |

Blocked designs (`status: Blocked`): [count] — [name each file and, if visible in its own history, why].

Prospective blocking notes (`Blocking trigger, if any` filled in): [count]. These are risk notes, not evidence a block happened.

**Coverage note:** [state plainly whether any of this data exists yet under the current Trivial/Simple/Complex naming, or whether it's all still under the prior Bounded/Consequential terminology, and since when the current template has been in use.]

## 2. Failure-mode KB trend

Total FM entries: [count]. Frequency distribution: [Low/Medium/High counts].

First-appearance timeline (new FM ids over time — a maturing KB should show this rate slowing):

| Date | FM introduced |
| ---- | ------------- |

**Read on this:** [is the rate of new FM entries slowing (KB maturing, being consulted effectively) or holding steady (either genuinely novel failure categories keep appearing, or the KB isn't being checked before drafting)? Say which, and what evidence supports it.]

**Coverage note:** [name any format/phrasing variants the parser couldn't detect — e.g., legacy-era entries using a different heading for KB updates — so this timeline isn't silently claimed as complete.]

## 3. Review findings rollup

Review log entries: [count] ([earliest date] to [latest date]). Current-format entries (have Severity/Arch?): [count]. Legacy-format entries (Decision only): [count].

Decision counts (all entries, keyword-family bucketed):

| Decision | Count |
| -------- | ----- |

Severity counts (current-format entries only — legacy entries didn't record severity):

| Severity | Count |
| -------- | ----- |

**Read on this:** [what does the REJECT rate suggest about review calibration — too strict, too lax? Is the BLOCKER rate rising or falling over the current-format period? Say what the numbers actually support, hedge where the sample is thin.]

## 4. Known gaps — not yet trackable

- **Review non-convergence** (hitting the review budget cap with a BLOCKER still unresolved, per `hb-design` §4's stop rule) isn't recorded anywhere in the log or output files. Can't be rolled up until `hb-design` starts noting it when it happens.
- [Add any other gap this run surfaced.]

## 5. Recommendation

[If anything here suggests a concrete change to `hb-design` itself — e.g., a rigor-level boundary that keeps getting crossed, a red flag that never fires, a review pattern that's not paying for itself — name it and the evidence for it. If nothing rises to that bar yet, say so; a retro with no action item is a legitimate result.]

---
name: hb-retro
description: Audit how well the hb-design process is performing over time, by rolling up data that already exists in its own output — the design review log and the failure-mode knowledge base. Use when asked for a retro, to audit design-review trends, or how the tech-design process is doing.
---

# hb-retro

Read-only. This skill never edits `hb-design`'s output — it reports on it. It reads only the review log and the failure-mode KB, never designs: closed tasks' designs are history, and nothing reads them.

## Quick start

```bash
python3 scripts/compute_rollup.py <repo_root>
```

Prints plain-text counts for the review log, including each entry's rigor level, outcome, and review passes, and for the failure-mode KB. It computes the numbers; you write the interpretation. Don't recompute any of these counts by hand from the raw files — the script exists so the arithmetic is deterministic and reliable. Read the raw files only to pull a concrete quote or example for the "read on this" sections, or to double-check something the script's coverage notes flag as incomplete.

## Process

1. Run the script from the repo root. If either input file is missing (`.hashbang/history/design-review-log.md`, `docs/engineering/COMMON-FAILURE-MODES.md`), stop and say so — don't fabricate a report from partial data.
2. Copy `templates/retro-report-template.md` to `docs/engineering/retros/YYYYMMDD-HHmm-retro.md`. Create `docs/engineering/retros/` if it doesn't exist yet.
3. Fill in each numbered section from the script's output. Keep the template's coverage-note fields — they exist because this data has real gaps (see below), and silently dropping a coverage note misrepresents the report as more complete than it is.
4. Write the "read on this" and "Recommendation" sections yourself — the script gives you counts, not judgment. Ground every claim in a specific number or quote from the script's output or the raw files; don't editorialize past what the data actually shows. A thin sample gets a hedge, not a confident verdict.
5. Report back: the date range covered, the headline read from section 1 of the report, and where the file was saved.
6. If the customer adopts a recommendation, make the change to the skill or template it names, and log it in `.hashbang/customizations.md` with the retro as the reason.

## Known coverage gaps — always check these before writing the interpretive sections

- **Older log entries may have no `Rigor:`, `Outcome:`, or `Review passes:` line.** The script reports how many entries have each; say plainly what share of the log the rigor and block counts cover.
- **Older entries may use retired rigor names.** Bounded and Consequential are the earlier names for Simple and Complex. If counted entries use them, say so plainly rather than silently presenting them as current-taxonomy data — treat Bounded as Simple and Consequential as Complex for interpretation, but name the substitution.
- **The FM first-appearance timeline only catches the current log format's `**Failure-mode KB entries produced:**` phrasing.** Older log entries may record new failure modes under a `### Failure Mode audit` heading instead, which the script doesn't parse. If the timeline looks like it starts abruptly at the legacy/current boundary, that's this gap, not evidence that no FMs existed before it — check a legacy entry directly if the timeline's start date matters to your conclusion.
- **Review non-convergence isn't recorded anywhere yet.** Report it as an open gap (the template has a section for this) rather than guessing a number.
- **A block is counted only when the log says so.** hb-design logs `Outcome: Blocked` when a design runs out of review budget. A design blocked for another reason, and never logged, isn't counted.

## Output

One file per run: `docs/engineering/retros/YYYYMMDD-HHmm-retro.md`, from `templates/retro-report-template.md`. Never overwrite a prior retro — each run is a new dated file, so trends across retros stay comparable.

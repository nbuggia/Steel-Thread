---
name: hb-retro
description: Audit how well the hb-tech-design process is performing over time, by rolling up data that already exists in its own output — the design-review log, the failure-mode knowledge base, and rigor-level frontmatter. Use when asked for a retro, to audit design-review trends, or how the tech-design process is doing.
tech_docs: docs/Tech Designs/
retros_dir: docs/Tech Designs/retros/
---

# hb-retro

Read-only. This skill never edits `hb-tech-design`'s output — it reports on it.

## Quick start

```bash
python3 scripts/compute_rollup.py <repo_root>
```

Prints plain-text counts for the review log, the failure-mode KB, and rigor-level frontmatter. It computes the numbers; you write the interpretation. Don't recompute any of these counts by hand from the raw files — the script exists so the arithmetic is deterministic and reliable. Read the raw files only to pull a concrete quote or example for the "read on this" sections, or to double-check something the script's coverage notes flag as incomplete.

## Process

1. Run the script from the repo root. If either input file is missing (`{{tech_docs}}DESIGN-REVIEW-LOG.md`, `{{tech_docs}}Common-Failure-Modes.md`), stop and say so — don't fabricate a report from partial data.
2. Copy `templates/retro-report-template.md` to `{{retros_dir}}YYYYMMDD-HHmm-retro.md`. Create `{{retros_dir}}` if it doesn't exist yet.
3. Fill in each numbered section from the script's output. Keep the template's coverage-note fields — they exist because this data has real gaps (see below), and silently dropping a coverage note misrepresents the report as more complete than it is.
4. Write the "read on this" and "Recommendation" sections yourself — the script gives you counts, not judgment. Ground every claim in a specific number or quote from the script's output or the raw files; don't editorialize past what the data actually shows. A thin sample gets a hedge, not a confident verdict.
5. Report back: the date range covered, the headline read from section 1 of the report, and where the file was saved.

## Known coverage gaps — always check these before writing the interpretive sections

- **Rigor-level distribution has no historical data under the current naming.** `rigor:` frontmatter only existed under the prior Bounded/Consequential terminology until `hb-tech-design` was renamed to Trivial/Simple/Complex. If every counted file still says Bounded/Consequential, say so plainly rather than silently presenting it as current-taxonomy data — treat Bounded as Simple's predecessor and Consequential as Complex's for interpretation, but name the substitution.
- **The FM first-appearance timeline only catches the current log format's `**Failure-mode KB entries produced:**` phrasing.** The legacy pre-2026-07-15 log entries recorded new failure modes under a `### Failure Mode audit` heading instead, which the script doesn't parse. If the timeline looks like it starts abruptly at the legacy/current boundary, that's this gap, not evidence that no FMs existed before it — check a legacy entry directly if the timeline's start date matters to your conclusion.
- **Review non-convergence isn't recorded anywhere yet.** Report it as an open gap (the template has a section for this) rather than guessing a number.
- **"Escalation trigger, if any" being filled in is not evidence an escalation happened.** It's a risk note the plan's author wrote about what _would_ trigger escalation. Only `status: Escalated` in a file's own frontmatter is a realized escalation. The script already separates these two counts — keep them separate in the report.

## Output

One file per run: `{{retros_dir}}YYYYMMDD-HHmm-retro.md`, from `templates/retro-report-template.md`. Never overwrite a prior retro — each run is a new dated file, so trends across retros stay comparable.

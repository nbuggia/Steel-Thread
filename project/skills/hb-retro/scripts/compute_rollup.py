#!/usr/bin/env python3
"""Deterministic rollup for hb-retro. Reads existing hb-tech-design output —
does not modify anything. Prints plain-text numbers; the skill narrates them
into templates/retro-report-template.md.

Usage: python3 compute_rollup.py <repo_root>
"""
import re
import sys
from pathlib import Path
from collections import Counter, defaultdict

DECISION_PATTERNS = [
    ("PARTIAL ACCEPT", re.compile(r"\bPARTIAL\s+ACCEPT\b", re.I)),
    ("ACCEPT", re.compile(r"\bACCEPT(?:ED)?\b(?!\s|.{0,3}—)?", re.I)),
    ("REJECT", re.compile(r"\bREJECT(?:ED)?\b", re.I)),
    ("DEFER", re.compile(r"\bDEFER(?:RED)?\b", re.I)),
    ("CLEAN", re.compile(r"\bCLEAN\b", re.I)),
]
SEVERITY_TOKENS = ["BLOCKER", "MAJOR", "MINOR", "QUESTION"]
FM_HEADER_RE = re.compile(r"^## (FM-\d+):\s*(.+)$", re.M)
ENTRY_HEADER_RE = re.compile(r"^## (.+?) — (\d{4}-\d{2}-\d{2})\s*$", re.M)
FM_PRODUCED_RE = re.compile(
    r"\*\*Failure-mode KB entries produced:\*\*\s*(.+?)(?=\n\n|\Z)", re.S
)
FM_MENTION_RE = re.compile(r"FM-\d+")
DATE_IN_LINE_RE = re.compile(r"(\d{4}-\d{2}-\d{2})")


def classify_decision(cell_text):
    for name, pat in DECISION_PATTERNS:
        if pat.search(cell_text):
            return name
    return None


def parse_review_log(path):
    text = path.read_text(encoding="utf-8")
    headers = list(ENTRY_HEADER_RE.finditer(text))
    entries = []
    for i, m in enumerate(headers):
        start = m.end()
        end = headers[i + 1].start() if i + 1 < len(headers) else len(text)
        entries.append(
            {
                "title": m.group(1).strip(),
                "date": m.group(2),
                "body": text[start:end],
            }
        )

    decision_counts = Counter()
    severity_counts = Counter()
    current_format_entries = 0
    legacy_format_entries = 0
    fm_timeline = []  # (date, [fm ids])

    for e in entries:
        body = e["body"]
        table_rows = [ln for ln in body.splitlines() if ln.strip().startswith("|")]
        has_severity_col = any(
            "Severity" in row for row in table_rows[:2]
        )  # header row(s)
        if has_severity_col:
            current_format_entries += 1
        else:
            legacy_format_entries += 1

        for row in table_rows:
            cells = row.split("|")
            for cell in cells:
                dec = classify_decision(cell)
                if dec:
                    decision_counts[dec] += 1
                if has_severity_col:
                    for tok in SEVERITY_TOKENS:
                        if re.search(rf"\b{tok}\b", cell):
                            severity_counts[tok] += 1

        for pm in FM_PRODUCED_RE.finditer(body):
            chunk = pm.group(1)
            fms = FM_MENTION_RE.findall(chunk)
            if fms:
                fm_timeline.append((e["date"], sorted(set(fms))))

    return {
        "total_entries": len(entries),
        "current_format_entries": current_format_entries,
        "legacy_format_entries": legacy_format_entries,
        "decision_counts": decision_counts,
        "severity_counts": severity_counts,
        "fm_timeline": fm_timeline,
        "first_date": entries[0]["date"] if entries else None,
        "last_date": entries[-1]["date"] if entries else None,
    }


def parse_failure_modes(path):
    text = path.read_text(encoding="utf-8")
    sections = list(FM_HEADER_RE.finditer(text))
    results = []
    for i, m in enumerate(sections):
        start = m.end()
        end = sections[i + 1].start() if i + 1 < len(sections) else len(text)
        body = text[start:end]
        freq_m = re.search(r"Frequency:\s*\n+\s*-\s*(\S+)", body)
        seen_m = re.search(r"Last Seen:\s*\n+\s*-\s*(\S+)", body)
        results.append(
            {
                "id": m.group(1),
                "title": m.group(2).strip(),
                "frequency": freq_m.group(1) if freq_m else None,
                "last_seen": seen_m.group(1) if seen_m else None,
            }
        )
    return results


def scan_rigor_frontmatter(*dirs):
    rigor_counts = Counter()
    total_files = 0
    files_with_rigor = 0
    realized_escalations = []  # status: Escalated -> this plan actually escalated
    prospective_escalation_notes = 0  # "Escalation trigger, if any" filled in — a risk note, not an outcome
    for d in dirs:
        if not d.exists():
            continue
        for f in sorted(d.glob("*.md")):
            total_files += 1
            text = f.read_text(encoding="utf-8", errors="replace")
            fm_match = re.match(r"^---\n(.*?)\n---", text, re.S)
            frontmatter = fm_match.group(1) if fm_match else ""
            rigor_m = re.search(r"^rigor:\s*(\S+)", frontmatter, re.M)
            if rigor_m:
                files_with_rigor += 1
                rigor_counts[rigor_m.group(1)] += 1
            status_m = re.search(r"^status:\s*Escalated\s*$", frontmatter, re.M)
            if status_m:
                realized_escalations.append(f.name)
            esc_m = re.search(r"Escalation trigger, if any:\s*(\S.*)", text)
            if esc_m and esc_m.group(1).strip():
                prospective_escalation_notes += 1
    return {
        "total_files": total_files,
        "files_with_rigor": files_with_rigor,
        "rigor_counts": rigor_counts,
        "realized_escalations": realized_escalations,
        "prospective_escalation_notes": prospective_escalation_notes,
    }


def main():
    root = Path(sys.argv[1] if len(sys.argv) > 1 else ".")
    tech_docs = root / "docs" / "Tech Designs"

    log = parse_review_log(tech_docs / "DESIGN-REVIEW-LOG.md")
    fms = parse_failure_modes(tech_docs / "Common-Failure-Modes.md")
    rigor = scan_rigor_frontmatter(tech_docs / "designs", tech_docs / "simple plans")

    print("=== REVIEW LOG ===")
    print(f"Entries: {log['total_entries']} ({log['first_date']} to {log['last_date']})")
    print(f"Current-format entries (have Severity/Arch?): {log['current_format_entries']}")
    print(f"Legacy-format entries (Decision only, no Severity): {log['legacy_format_entries']}")
    print("Decision counts (all entries, keyword-family bucketed):")
    for k, v in log["decision_counts"].most_common():
        print(f"  {k}: {v}")
    print("Severity counts (current-format entries only):")
    for k in SEVERITY_TOKENS:
        print(f"  {k}: {log['severity_counts'].get(k, 0)}")

    print()
    print("=== FAILURE MODE KB ===")
    print(f"Total FM entries: {len(fms)}")
    freq_counts = Counter(f["frequency"] for f in fms if f["frequency"])
    for k, v in freq_counts.most_common():
        print(f"  Frequency={k}: {v}")
    first_seen = {}
    for date, fm_ids in log["fm_timeline"]:
        for fid in fm_ids:
            if fid not in first_seen or date < first_seen[fid]:
                first_seen[fid] = date
    print("FM first-appearance timeline (genuine introduction date per FM id,")
    print("earliest 'Failure-mode KB entries produced' mention — NOT every mention):")
    for fid, date in sorted(first_seen.items(), key=lambda kv: kv[1]):
        print(f"  {date}: {fid}")
    print("(Note: the raw log also shows many later re-mentions of the same FM")
    print(" ids — those are reinforcements/re-confirmations, not new introductions.)")

    print()
    print("=== RIGOR LEVEL (designs/ + simple plans/ frontmatter) ===")
    print(f"Files scanned: {rigor['total_files']}")
    print(f"Files with a rigor: field: {rigor['files_with_rigor']}")
    for k, v in rigor["rigor_counts"].most_common():
        print(f"  {k}: {v}")
    print(f"Realized escalations (status: Escalated): {len(rigor['realized_escalations'])}")
    for fname in rigor["realized_escalations"]:
        print(f"  {fname}")
    print(f"Prospective 'Escalation trigger, if any' notes filled in (risk notes, not outcomes): {rigor['prospective_escalation_notes']}")


if __name__ == "__main__":
    main()

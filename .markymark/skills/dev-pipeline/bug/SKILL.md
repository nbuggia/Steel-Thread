---
name: bug
description: One-shot bug capture — assign ID, append to bugs.md, create task
invoke: user
---

One-shot bug capture. The customer describes the bug in a single line. Claude handles everything else.

```
/bug Button doesn't respond on mobile — iOS Safari only — high
```

## Steps

**1. Parse the input**
Extract:
- Title (required)
- Notes (optional — context, repro steps, environment)
- Severity: critical / high / medium / low (default: medium if not specified)

**2. Assign the next BUG ID**
Read bugs.md to find the highest existing BUG ID. Assign the next one in sequence: BUG-00001, BUG-00002, etc.

If bugs.md doesn't exist yet, create it with the two-table format:

```markdown
# Bugs

## Open

| ID | Title | Severity | Notes |
|----|-------|----------|-------|

## Closed

| ID | Title | Severity | Closed | Root Cause | Solution |
|----|-------|----------|--------|------------|----------|
```

**3. Append to the Open table**
Add a row to the Open table in bugs.md.

**4. Create a task in tasks.json**
Add a task to the current phase:
- Title: "Fix [BUG-XXXXX]: [title]"
- Priority: matches severity (critical/high → high, medium → medium, low → low)
- Detail: references the bug ID and notes

**5. Suggest fix sequence** (if multiple bugs exist)
After adding the bug, look at all open bugs and suggest a fix sequence:
"You have [N] open bugs. BUG-XXXXX is [severity] and likely shares a root cause with BUG-YYYYY — worth fixing together. Want to start there?"

Base suggestions on:
- Severity — critical before high before medium before low
- Dependencies — is this blocking other tasks?
- Proximity — already working in that part of the codebase?
- Patterns — do multiple bugs share a likely root cause?

## Asset naming convention

Assets named by bug ID are automatically associated:
- BUG-00001-01.png
- BUG-00001-02.png
- BUG-00001-03.mov

Save to docs/bugs/assets/.

Create a companion BUG-XXXXX.md in docs/bugs/ when assets exceed three files or when the customer requests extended documentation.

## After fixing a bug

Claude already knows the root cause and solution from systematic-debugging. Do not prompt the customer.

1. Fix the bug
2. Update bugs.md directly — move row from Open to Closed, fill in completion date, root cause, and solution
3. Mark the task complete in tasks.json
4. Give the customer a one-line summary: "Fixed BUG-00001 — touch event handler wasn't attached on iOS. Closed in bugs.md."

If multiple bugs shared a root cause, close all of them and say so.

## Learnings mining

The closed bugs table is a pattern library. Periodically scan it and propose learnings for CONTEXT.md under a "Known Patterns" section:
- Recurring root causes worth a permanent fix or rule
- Files or components that appear repeatedly
- Patterns that suggest a process or testing gap

Customer approves before anything is written to CONTEXT.md.

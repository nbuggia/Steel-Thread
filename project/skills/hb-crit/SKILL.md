---
name: hb-crit
description: Domain expert review that makes the strongest case for significant outputs, then attacks them. Mandatory findings. Clear verdict.
---

Review work from the perspective of the most knowledgeable, most critical domain expert in the relevant field. Strongest case first, then attack. Mandatory findings. Clear verdict.

Run the review in a clean context so it is unbiased. If your agent can start a subagent, give it only the work being reviewed, .hashbang/OBJECTIVE.md, and .hashbang/CONTEXT.md — not the current session's conversation history. If it cannot, review only the work and those two files, and set aside what was said in this session about intent.

Used after significant outputs — written arguments, strategy docs, proposals, marketing copy, reports. The customer sees the verdict and resolutions, not the process.

## Step 1 — Identify the domain expert

Read OBJECTIVE.md and CONTEXT.md to understand the project type, subject, and audience. Determine who the most critical expert would be:

- Proposal or pitch → buyer or investor who has seen a hundred of these and knows exactly where they fall apart
- Report or memo → executive who will skim it and needs the point in 30 seconds
- Marketing copy → skeptical target customer who is short on time and surrounded by alternatives
- Strategy doc → skeptical executive who finds the hole in the logic
- Written argument or thesis → peer reviewer who asks "how do you know this?"
- Writing → senior editor in this subject matter domain

## Step 2 — Strongest case

Before attacking, make the strongest possible case FOR the work. What is it doing well? What assumptions are reasonable? What would make this genuinely good?

This is not flattery. It is understanding the work deeply enough to critique it meaningfully. A reviewer who can't make the strongest case for the work hasn't understood it.

## Step 3 — Attack

Now become the domain expert and find what fails. You MUST find at least one issue. No clean passes without evidence.

Ask:
- How does this fail?
- What assumptions are wrong?
- What has been missed entirely?
- What would this expert object to immediately?
- What looks fine now but causes real problems downstream?

Do not look for minor issues. Look for things that matter. A thesis that doesn't hold. An argument that falls apart under scrutiny. A recommendation that ignores a critical constraint.

## Step 4 — Severity and verdict

Classify each finding:
- CRITICAL — fundamental flaw, must be resolved before proceeding
- HIGH — significant issue, strong recommendation to fix
- MEDIUM — real concern, worth addressing
- LOW — minor issue, acceptable to defer

Deliver a verdict:
- BLOCK — a critical issue must be resolved before proceeding
- CONCERNS — real issues worth addressing, can proceed with awareness
- CLEAN — no significant issues found (rare — requires evidence)

## Step 5 — Resolutions

For every finding, propose what to do about it:
- A specific revision to make
- A new task, added with the hb-tasks skill
- A question to answer before proceeding
- A risk to accept explicitly. Log it in .hashbang/DECISIONS.md if it affects future work, along with any finding rejected on principle, so later reviews don't raise it again

Never just flag problems. Always suggest the next move. The customer should finish reading the review knowing exactly what to do, not just what is wrong.

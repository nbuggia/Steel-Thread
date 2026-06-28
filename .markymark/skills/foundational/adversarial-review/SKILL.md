---
name: adversarial-review
description: Domain expert review that steelmans then attacks significant outputs. Mandatory findings. Clear verdict.
invoke: model
---

Review work from the perspective of the most knowledgeable, most critical domain expert in the relevant field. Steelman first, then attack. Mandatory findings. Clear verdict.

Used automatically after significant outputs — bug fixes, tech designs, feature specs, written arguments, strategy docs. The customer sees the verdict and resolutions, not the process.

## Step 1 — Identify the domain expert

Read CONTEXT.md to understand the project type and subject. Determine who the most critical expert would be:

- Bug fix → senior engineer who has seen this class of bug before
- Tech design → staff engineer who has built systems at scale
- Feature spec → product leader who has shipped this kind of feature
- Strategy doc → skeptical executive who finds the hole in the logic
- Written argument or thesis → peer reviewer who asks "how do you know this?"
- Writing → senior editor in this subject matter domain

## Step 2 — Steelman

Before attacking, make the strongest possible case FOR the work. What is it doing well? What assumptions are reasonable? What would make this genuinely good?

This is not flattery. It is understanding the work deeply enough to critique it meaningfully. A reviewer who hasn't steelmanned the work hasn't understood it.

## Step 3 — Attack

Now become the domain expert and find what fails. You MUST find at least one issue. No clean passes without evidence.

Ask:
- How does this fail?
- What assumptions are wrong?
- What has been missed entirely?
- What would this expert object to immediately?
- What looks fine now but causes real problems downstream?

Do not look for minor issues. Look for things that matter. A thesis that doesn't hold. A design that breaks at scale. A fix that addresses the symptom not the cause. An argument that falls apart under scrutiny.

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
- A new task to add to tasks.json
- A question to answer before proceeding
- A risk to accept explicitly and document

Never just flag problems. Always suggest the next move. The customer should finish reading the review knowing exactly what to do, not just what is wrong.

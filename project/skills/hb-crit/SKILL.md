---
name: hb-crit
description: Expert review of a spec, a tech design, a bug diagnosis, or code. Makes the strongest case for the work, then attacks it. Mandatory findings. Clear verdict.
---

Review work from the perspective of the most knowledgeable, most critical expert for it. Strongest case first, then attack. Mandatory findings. Clear verdict.

Run the review in a clean context so it is unbiased. If your agent can start a subagent, give it only the work being reviewed, the objective (`docs/PRD.md`'s sections above its first feature), `docs/CONTEXT.md` (or the files they point to), and the code the work touches — not the current session's conversation history. If it cannot, review only the work, those files, and that code, and set aside what was said in this session about intent.

Used where `.hashbang/framework/development.md` calls for it — a spec's review, a bug diagnosis at Complex rigor, the end of a Complex design's code — and whenever the customer asks. The customer sees the verdict and resolutions, not the process.

## Step 1 — Identify the expert

Read the objective, CONTEXT.md, and `docs/engineering/ARCHITECTURE.md` to understand the product, its users, and its stack. Determine who the most critical expert would be:

- Spec → a product manager who has shipped this kind of feature, and asks what users actually need and what the spec leaves unsaid
- Tech design → a principal engineer on this stack, who keeps it simple, finds the failure modes, and pushes back on scope the spec does not need
- Bug diagnosis → a debugging expert, who asks "how do you know that's the cause?" and wants the evidence
- Code → a senior reviewer for this stack, who reads the diff for correctness, tests that prove behavior, and the project's conventions

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

Do not look for minor issues. Look for things that matter. A root cause that doesn't explain every symptom. A design that breaks a contract. A test that passes without proving the behavior. A requirement that ignores a critical constraint.

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
- A risk to accept explicitly. Log it in `docs/DECISIONS.md` if it affects future work, along with any finding rejected on principle, so later reviews don't raise it again

Never just flag problems. Always suggest the next move. The customer should finish reading the review knowing exactly what to do, not just what is wrong.

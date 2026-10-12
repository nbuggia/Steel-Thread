---
name: steelman
description: Adversarial interview that stress-tests a plan, decision, or diagnosis before acting on it. States the plan at its strongest, then challenges it in rounds until every weak point is resolved.
based-on: Matt Pocock, grill-me and grilling (https://github.com/mattpocock/skills)
---

Stress-tests a plan before anyone acts on it: a proposed fix, a design, an approach, a call the customer is about to make. Used directly by the customer, and by any skill that needs a plan pressure-tested before it becomes tasks.

How it differs from the other skills:
- elevate finds out what the customer wants. Steelman tests whether the plan will get it.
- crit reviews a finished output and gives a verdict. Steelman interviews the customer about a plan before the work exists.

## Step 1 — Steelman the plan

Read .steel-thread/OBJECTIVE.md, .steel-thread/CONTEXT.md, and any active entries in .steel-thread/DECISIONS.md that touch the plan. Then state the plan back in its strongest form: what it does, why it is a good idea, and the assumptions it rests on. Name the assumptions explicitly — they are what step 2 attacks.

Ask the customer to confirm this is the plan. Do not challenge a plan you have not stated correctly.

## Step 2 — Challenge in rounds

Map the plan as a tree of decisions and assumptions, each with the ones that depend on it. The **frontier** is every challenge whose prerequisites are already settled. Ask the whole frontier in one round, then wait for the customer's answers before the next round. A challenge that depends on another one still open belongs to a later round.

Each challenge is a specific way the plan could fail:
- An assumption that may be wrong
- A failure mode the plan does not handle
- A constraint from OBJECTIVE.md, CONTEXT.md, or DECISIONS.md the plan conflicts with
- A simpler plan that gets the same result
- A part of the plan that does not serve the objective and could be cut

Format a round like this:

```
**Q1 — <challenge title>**: <the challenge, and what happens if it is not addressed>

Recommended: <your recommended answer>

---

**Q2 — <challenge title>**: ...
```

Word each question so "yes" accepts your recommendation. The customer can answer the whole round by number: "1 yes, 2 no — here's why, 3 the second option."

## Keep the scope where it is

Challenges must make the plan more likely to work, or smaller. Never recommend adding features, options, or polish the objective does not need. When a weakness can be fixed either by adding something or by cutting something, recommend the cut. If the plan is too big to stress-test in one session, say so and propose splitting it before going further.

## Facts are yours, decisions are the customer's

If a challenge depends on a fact you can look up — a file, the code, documentation, a quick test — look it up instead of asking. If your agent can start a subagent, use one so the rest of the round is not blocked; otherwise look it up before asking the round. Only the challenges that depend on that fact wait.

Never answer a decision for the customer. "I don't know" is a real answer: record it as an open question or a risk, and move on. If a question can't be settled by talking — how something should look or feel, whether an approach performs — stop and propose a quick experiment or prototype as a task instead.

## Step 3 — Close

The session is done when the frontier is empty: every assumption challenged, nothing left silently assumed. Summarize:
- The plan as it now stands, and what changed from step 1
- Risks the customer chose to accept
- Open questions that still need an answer

Ask the customer to confirm this is the shared understanding. Do not act on the plan until they do.

Then propose, one at a time:
- Decisions worth logging in .steel-thread/DECISIONS.md, including accepted risks
- Tasks for .steel-thread/TASKS.md: experiments, open questions, and the work itself
- New vocabulary for .steel-thread/CONTEXT.md

When steelman was called by another skill, return the confirmed plan to that skill instead of proposing tasks for the work itself.

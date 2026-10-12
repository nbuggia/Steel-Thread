---
name: elevate
description: Interview in rounds to resolve ambiguity and align on direction before work begins
based-on: Matt Pocock, grill-with-docs (https://github.com/mattpocock/skills)
---

Resolves ambiguity before any work begins. Used by the whats-next skill during setup and by any skill that needs deep understanding of intent before acting.

## The loop

- Before asking, triage: if there's a sensible default or established convention, apply it and state what you chose — don't ask
- The test for asking: "If the customer answered X, would I do something meaningfully different than if they answered Y?" If not, don't ask
- Prioritize questions that surface unresolved trade-offs, reveal constraints that change the approach, or challenge assumptions that would waste significant effort if wrong
- If a question can be answered by reading existing files, read them instead of asking

## Ask in rounds

Map what's unresolved as a tree: each question has the questions that depend on its answer. The **frontier** is every question whose prerequisites are already settled. Ask the whole frontier in one round, most consequential first, then wait for the customer's answers before the next round. A question that depends on another one still open belongs to a later round.

Format a round like this:

```
**Q1 — <question title>**: <the question, with the options if there are any>

Recommended: <your recommended answer>

---

**Q2 — <question title>**: ...
```

Word each question so "yes" accepts your recommendation. The customer can answer the whole round by number: "1 yes, 2 no — here's why, 3 the second option."

The loop is done when the frontier is empty: nothing left that would change what you do.

## While elevating, maintain vocabulary

As terms are resolved, propose additions to the vocabulary in .steel-thread/CONTEXT.md:
"We just defined X as Y — want me to add that to the project context?"
One-tap approval. Do not wait until the end.

## Output

Shared understanding recorded in the relevant document.
New vocabulary proposed for .steel-thread/CONTEXT.md.
Key decisions proposed as entries in .steel-thread/DECISIONS.md.

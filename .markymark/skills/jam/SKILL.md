---
name: jam
description: One-question-at-a-time session to resolve ambiguity and align on direction before work begins
invoke: model or user
---

Resolves ambiguity before any work begins. Used by /onboard and any skill that needs deep understanding of intent before acting.

## The loop

- Before asking, triage: if there's a sensible default or established convention, apply it and state what you chose — don't ask
- The test for asking: "If the customer answered X, would I do something meaningfully different than if they answered Y?" If not, don't ask
- Prioritize questions that surface unresolved trade-offs, reveal constraints that change the approach, or challenge assumptions that would waste significant effort if wrong
- Ask one question at a time, ordered by impact — most consequential first
- Provide your recommended answer for each question
- If a question can be answered by reading existing files, read them instead of asking

## While jamming, maintain vocabulary

As terms are resolved, propose additions to CONTEXT.md vocabulary:
"We just defined X as Y — want me to add that to the project context?"
One-tap approval. Do not wait until the end.

## Output

Shared understanding recorded in the relevant document.
New vocabulary proposed for CONTEXT.md.
Key decisions proposed as style or architecture records.

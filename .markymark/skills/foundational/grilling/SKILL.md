---
name: grilling
description: One-question-at-a-time interview loop that resolves ambiguity before any work begins
invoke: model
based-on: mattpocock/skills grill-with-docs
---

The grilling loop resolves ambiguity before any work begins. Used by /onboard, /prd, /spec, /tech-design, /grill-me, and any skill that needs deep understanding of intent before acting.

## The loop

- Ask one question at a time
- Provide your recommended answer for each question
- Walk every branch of the decision tree
- If a question can be answered by reading existing files, read them instead of asking
- Do not stop until shared understanding is reached
- 3-5 questions is usually enough — do not over-interview

## While grilling, maintain vocabulary

As terms are resolved, propose additions to CONTEXT.md vocabulary:
"We just defined X as Y — want me to add that to the project context?"
One-tap approval. Do not wait until the end.

## Output

Shared understanding recorded in the relevant document.
New vocabulary proposed for CONTEXT.md.
Key decisions proposed as style or architecture records.

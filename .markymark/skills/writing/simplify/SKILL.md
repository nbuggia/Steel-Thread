---
name: simplify
description: Finds redundancy and over-explanation in prose, and fixes it
invoke: user
---

Find redundancy and over-explanation in the document and fix it. This is the prose equivalent of the Simplicity foundational skill — it applies to written text, not code.

## Steps

**1. Read CONTEXT.md**
Check for voice and style constraints. Some projects have good reasons for certain lengths or constructions — do not override intentional choices.

**2. Read the document**
Read the full document in scope.

**3. Find simplification targets**

**Redundancy:**
- Ideas stated more than once without adding new information
- Examples that repeat each other
- Introductions that preview what's immediately below
- Conclusions that restate what's immediately above

**Over-explanation:**
- Obvious inferences spelled out ("which means that...")
- Qualifications that add length without precision ("in some cases, it may be possible that...")
- Hedges that undermine the point ("arguably", "somewhat", "in a sense")
- Context the reader already has

**Bloat patterns:**
- "The fact that" (delete and rewrite the sentence)
- "In order to" → "to"
- "Due to the fact that" → "because"
- "At this point in time" → "now"
- "It is important to note that" → delete
- "As previously mentioned" → delete (if it matters, it shouldn't need restating)

**4. Apply changes directly**

Simplify in place. Do not ask for approval before each change.

**5. Report**

"Simplified [X] passages. [One sentence on the main patterns found.]"
The customer can review the diff if they want detail.

## Rules

- Never simplify a construction that carries meaning the simpler version would lose
- If a repetition is intentional (emphasis, structure, refrain), leave it
- Applies to the document in scope — does not reach into other files

---
name: voice-check
description: Reads the document as the target audience and flags anything that breaks the established tone or style
invoke: user
---

Read the document as the target audience and flag anything that breaks the established tone or style. Does not make changes — surfaces findings for the customer to decide.

## Steps

**1. Read CONTEXT.md**
Find the voice definition, target audience, style decisions, and any "what Claude should never do" constraints. These are the criteria.

If CONTEXT.md has no voice definition, stop and ask: "I don't see a voice definition in your project context. Who is the target reader and what tone are you going for?"

**2. Read the document**
Read the full document in scope. If the customer named a specific file or section, read that. Otherwise ask which document to check.

**3. Become the target reader**
Set aside your knowledge of the project. Read as someone encountering this document cold, as the audience defined in CONTEXT.md.

**4. Flag findings**

For each finding:
- Quote the specific text
- Name which voice/style rule it breaks
- Explain the reader's likely reaction

Categories to check:
- Tone drift — sounds too formal, too casual, too corporate, or too hedged for this audience
- Voice inconsistency — switches register mid-document
- Jargon the target reader would not recognize
- Passive constructions when the style calls for active
- Vocabulary that contradicts CONTEXT.md definitions
- Sentences that would stop a reader cold

**5. Verdict**
- CLEAN — no significant voice issues
- CONCERNS — [N] issues worth addressing before publishing
- BLOCK — the voice is so off it needs a pass before the document can be useful

## Rules

- Flag specific locations — not general impressions
- Do not make changes — this is a diagnostic pass only
- Distinguish between "off-brand" (CONCERNS) and "would confuse the reader" (BLOCK)
- If there are no issues, say so directly with evidence: "Read this as [audience]. The tone is [description]. Nothing broke."

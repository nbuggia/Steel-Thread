---
name: trim
description: Ruthless length editing without losing meaning
invoke: user
---

Cut the document to its minimum length without losing anything that matters. Default target: remove 20–30% of words.

## Steps

**1. Read the document**
Identify the document in scope. If not specified, ask which one.

**2. Read CONTEXT.md**
Check for length constraints ("each section should be readable in 90 seconds") and tone constraints that affect how aggressively to trim.

**3. Cut in three passes**

**Pass 1 — Redundancy:**
- Sentences that repeat what the previous sentence already said
- Phrases that hedge without adding information ("it is worth noting that", "as we can see")
- Wind-up before the point ("In this section, we will discuss...")
- Closing summaries that just restate the opening

**Pass 2 — Overwriting:**
- Adverbs that the verb already implies ("quickly runs" → "runs")
- Adjective stacking ("important and critical key decision")
- Nominalizations that obscure action ("make a decision" → "decide")
- Passive constructions that add words without adding meaning

**Pass 3 — Structure:**
- Bullets that could be one sentence
- Sections with only one item (merge them)
- Headers that label the obvious
- Transitions that state what the structure already shows

**4. Apply changes directly**

Write the trimmed version. Do not ask for approval before cutting.

**5. Report**

Tell the customer:
"Trimmed from [X] to [Y] words ([Z]% reduction). [One sentence on what changed most.]"

The customer can review the diff if they want detail.

## Rules

- Never cut meaning — if in doubt, keep it
- Never change the argument — only how it's expressed
- If a section cannot be trimmed without losing something important, say so rather than cutting it anyway
- Trim each section proportionally — do not cannibalize one section to spare another

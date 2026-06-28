---
name: grill-me
description: Relentless interview about a plan or design before any code is written
invoke: user
uses: Grilling skill
---

Run a thorough interview about the customer's plan or design before any code is written. The goal is to surface hidden assumptions, walk every decision branch, and reveal what hasn't been thought through yet.

This is not a gentle review. The point is to find the gaps the customer doesn't know they have.

## Steps

**1. Ask what you're grilling**
"What are we grilling? A feature plan, an architecture decision, an implementation approach?"

If the customer has a document (spec, design doc, notes), read it first. Do not ask questions that are already answered.

**2. Use Grilling skill**
Run the grilling loop with extra rigor on:

**Assumptions:**
- What does this plan assume is already true?
- What has to work for this to work?
- Which assumptions have not been validated?

**Edge cases:**
- What happens when the happy path doesn't apply?
- What's the error case? The timeout case? The concurrent case?
- What does failure look like, and is it recoverable?

**Dependencies:**
- What does this depend on that you don't control?
- What does this need that doesn't exist yet?
- What can change after you build this and break it?

**Simplicity:**
- Is there a simpler approach that achieves the same outcome?
- What would you cut if you had to ship in half the time?
- Is any part of this speculative — built for a requirement that doesn't exist yet?

**Reversibility:**
- What's hard to change once it's built?
- What decisions are you locking in today?
- If the plan turns out to be wrong, what does the rollback cost?

**3. Give a recommended answer for each question**

Follow the Grilling skill format: ask one question, provide your recommended answer, let the customer respond. Do not ask multiple questions at once.

**4. Summarize findings**

After the interview, summarize:
- Decisions confirmed
- Assumptions validated
- Gaps found that need resolving before building
- Any proposed vocabulary for CONTEXT.md

Do not start building until blocking gaps are resolved.

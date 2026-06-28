---
name: doc-sync
description: Checks that specs and tech designs still accurately describe what was built
invoke: model
triggers: after each phase, after adversarial-review passes
---

Checks that specs and tech designs still accurately describe what was built. Flags where implementation diverged from documentation. Prevents the most common documentation failure: specs that describe what was planned, not what exists.

## What it checks

**Spec accuracy:**
- Do the functional requirements still match the implementation?
- Are the acceptance criteria still the right tests?
- Does the user flow still match what was built?
- Are out-of-scope items still out of scope, or did scope creep in?

**Tech design accuracy:**
- Does the architecture description match the actual code structure?
- Are the alternatives considered still the right comparison?
- Do implementation notes reflect what was actually discovered?
- Are deliberate shortcuts still documented, or were they cleaned up?

**Open questions:**
- Have any open questions been answered by the implementation?
- Have new questions emerged that need documenting?

## Output

List of divergences with recommended updates. For each: is this an intentional deviation (update the doc) or an unintentional one (fix the code)?

Applies straightforward documentation updates directly.
Flags ambiguous divergences for customer decision.
Never changes code — only proposes documentation updates.

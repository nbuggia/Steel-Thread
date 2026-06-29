---
name: recap
description: Show the current pickup note and optionally adjust it
invoke: model or user
---

Show the current pickup note and let the customer adjust it.

This skill is optional — the system maintains pickup.md automatically after every meaningful change. Use /recap when the customer wants to review the note, add a message for tomorrow, or explicitly check what's in flight.

## Steps

**1.** Read .markymark/pickup.md

**2.** Display the current pickup note in full — do not summarize it. The customer may need to read it exactly as it will appear at the next session start.

**3.** Offer specific actions:
- "Anything you want to add for next time?"
- "Is anything blocked right now that I should note?"
- "Want to change the suggested starting point?"

**4.** If the customer makes edits, write them to .markymark/pickup.md immediately.

**5.** Confirm: "Pickup note updated. You're good to close whenever you're ready."

## Rules

- Never restructure or condense the pickup note without being asked
- Never summarize — show it as-is
- If pickup.md does not exist yet, say so and offer to create it from the current session state

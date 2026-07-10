---
name: create-tech-design
description: Multi-LLM design review loop for spec, implementation, and testing plans. Use when starting significant new development work before implementation begins.
---
# Create Tech Design Skill

## Phase 1: Load Review Knowledge

Before starting, confirm all of the following files are available:

Required:

- CLAUDE.md
- architecture.md

Review Knowledge Base:

- docs/Tech Designs/Common-Failure-Modes.md
- docs/Tech Designs/Review-Patterns.md

Review History:

- .claude/Tech Designs/Design-Review-Log.md (if present)

Rules:

- Halt and request missing required files.
- If Common-Failure-Modes.md does not exist, create it from the seed template.
- If Review-Patterns.md does not exist, create it from the seed template.
- Read all four files before generating any review package.
- Every review must explicitly consult Common-Failure-Modes.md.

---

## Phase 2: Generate Review Package

You are drafting a technical design document (TDD) for a proposed change to the application. You will be given a feature description or problem statement. Produce a complete design doc using the template ".markymark/templates/create-plan-template.md" and store the tech design in the "docs/tech-designs" folder (create the folder if it doesn't exist). Do not skip sections; if a section is genuinely not applicable, state why in one line rather than omitting it. Write for a skeptical reviewer who will approve or block this design. Make claims falsifiable (numbers, not adjectives). Do not present the chosen design as the only option considered.


---

## Phase 3: Adversarial Review (iterative) 

Conduct an adversarial review that is run in a fresh agent context — pass only the current tech design draft. Do not carry the current session's conversation history. A clean context produces an unbiased review. Use this prompt for the reviewer: 

"You are a principal software engineer reviewing a design proposal. The developer is a solo junior developer using Claude Code for implementation. Evaluate for:
(1) unnecessary complexity,
(2) missing edge cases,
(3) testability gaps,
(4) better alternative approaches.
Be direct and specific."

### Phase 3.1: Update the technical design document with feedback from the review, maintaining the table of feedback and decisions in the tech design doc. 

### Phase 3.2: Update the Failure Mode Knowedge Base

For every ACCEPTED item:

Determine whether it maps to an existing failure mode.

If yes:

- Update examples
- Update notes
- Increment frequency

If no:

Create a new failure mode entry.

New failure modes must be added before the next iteration begins.

Format:

## FM-XXX: Title

Symptoms:

- ...

Detection:

- ...

Recommendation:

- ...

Examples:

- ...

Frequency:

- Low
- Medium
- High

Last Seen:

- YYYY-MM-DD

### Phase 3.3: Exit Criteria

Continue to iterate and with additional adversarial reviews until:

- No unresolved conflicts
- All major decisions have rationale
- Failure mode audit completed
- User confirms understanding of key decisions

---


# Phase 5: Exit

Output:

1. Files created
2. Files modified
3. Failure modes added or updated
4. Confirmation ready for implementation


After writing:

- Output line count
- Confirm no prior content was lost







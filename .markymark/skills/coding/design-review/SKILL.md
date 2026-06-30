---
name: design-review
description: Multi-LLM design review loop for spec, implementation, and testing plans. Use when starting significant new development work before implementation begins.
---

# Design Review Skill

## Phase 0: Load Review Knowledge

Before starting, confirm all of the following files are available:

Required:

- CLAUDE.md
- architecture.md

Review Knowledge Base:

- .claude/Tech Designs/Common-Failure-Modes.md
- .claude/Tech Designs/Review-Patterns.md

Review History:

- .claude/Tech Designs/Design-Review-Log.md (if present)

Rules:

- Halt and request missing required files.
- If Common-Failure-Modes.md does not exist, create it from the seed template.
- If Review-Patterns.md does not exist, create it from the seed template.
- Read all four files before generating any review package.
- Every review must explicitly consult Common-Failure-Modes.md.

---

# Phase 1: Generate Review Package

Produce a self-contained document with no implicit context. Another LLM with zero project knowledge must be able to evaluate it cold.

---

## DESIGN REVIEW — Iteration [N]

### Spec Requirements

- Bulleted list of requirements being addressed from relevant specs

---

### Proposed Implementation

- Architecture decisions
- Key components and their responsibilities
- Dependencies introduced
- Complexity assessment relative to solo-developer constraint in CLAUDE.md

For every newly introduced state variable:

| State | Owner | Lifetime | Persistence Required? | Why This Owner? |
| ----- | ----- | -------- | --------------------- | --------------- |

---

### Spec Review

Read every canonical spec the plan touches before completing this section.

For each spec:

| Spec | Relevant claims (quote directly from source) | This plan changes this? |
| ---- | -------------------------------------------- | ----------------------- |

Rules:

- Claims must be quoted directly from source files.
- Paraphrasing is not acceptable proof of reading.
- Specs reviewed with no relevant claims must still be listed as:
- Reviewed — no relevant claims

- Omitting this section is not acceptable.
- Always include:
  - Architecture.md
  - Any feature spec touched by the proposal

---

### Failure Mode Audit

Review the proposal against common-failure-modes.md.

For every applicable failure mode:

| ID  | Failure Mode | Applicable? | Mitigation |
| --- | ------------ | ----------- | ---------- |

Mandatory review categories:

#### State Ownership

- Could this state remain local?
- Is any global state being added prematurely?
- Is related state split across slices/modules?

#### Lifecycle

For every interaction ask:

- What happens during rerender?
- What happens during remount?
- What happens during watcher refresh?
- What happens on window blur?
- What happens on Escape?
- What happens on command failure?

#### Path Operations

For any create/rename/move/delete operation:

What happens to:

- Open tabs
- Dirty tabs
- Active document
- Selected tree item
- Expanded folders

#### Cross Platform

Explicitly evaluate:

- macOS
- Windows
- Linux

Do not assume platform parity.

#### Tauri/WebView

Explicitly evaluate:

- Clipboard
- Focus
- Drag/drop
- Shell integration
- File dialogs

Do not assume Chrome browser behavior.

#### Complexity Challenge

Identify the three most complex parts.

For each:

- Can it be deleted?
- Can it be delayed?
- Can it be simplified?

---

### Testing Plan

Unit test scope

For every command:

- Success path
- AlreadyExists
- NotFound
- PermissionDenied
- PathTraversal
- UnexpectedFailure

Integration test scope

Manual verification steps

For every test category include:

| Test | Regression Prevented |
| ---- | -------------------- |

---

### Open Questions

- Any unresolved decisions requiring feedback

---

### Suggested Prompt for ChatGPT and Gemini

Append the review package above and then use:

"You are a principal software engineer reviewing a design proposal. The developer is a solo junior developer using Claude Code for implementation. Evaluate for:
(1) unnecessary complexity,
(2) missing edge cases,
(3) testability gaps,
(4) better alternative approaches.

Be direct and specific."

---

# Phase 2: Ingest Feedback

User pastes feedback labeled:

- [GPT]
- [Gemini]

Claude then:

1. Reconciles feedback against:
   - CLAUDE.md
   - architecture.md
   - common-failure-modes.md

2. Flags conflicts.

3. For each feedback item explicitly ask:

"Does accepting this change any claim listed in the Spec Review section?"

4. Present:

| #   | Source | Feedback Summary | Decision | Rationale | Next Step | Arch? |
| --- | ------ | ---------------- | -------- | --------- | --------- | ----- |

5. Wait for user adjudication.

6. Update design.

7. Append decisions to design-review-log.md.

8. Produce an updated review package.

---

Decision Definitions

ACCEPT

- Incorporated immediately

REJECT

- Excluded with rationale

DEFER

- Valid but intentionally postponed

---

# Phase 2.5: Update Failure Mode Knowledge Base

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

---

# Phase 3: Iterate

Repeat Phases 1–2.5.

At iteration 3 (or when exit criteria are met), recommend exiting.

---

Exit Criteria

- No unresolved conflicts
- All major decisions have rationale
- Failure mode audit completed
- User confirms understanding of key decisions

---

# Phase 4: Update Documentation

## Architectural Decision Extraction

Filter accepted items into:

ARCHITECTURAL

- Affects multiple components
- Establishes reusable patterns
- Constrains future decisions

LOCAL

- Feature-specific only

---

## Update decisions.md

Append:

## [Decision Title] — [Date]

Context:
...

Decision:
...

Rationale:
...

Source:
Design Review Iteration [N]

Status:
Active

---

## Update Specs

Update:

- Every spec marked "Yes" in Spec Review
- Every spec touched by ARCH items

Required.

Not optional.

---

## Verify Documentation Changes

Run:

git diff .claude/

Capture output.

If:

- Any ARCH item accepted
- Any Spec Review row marked "Yes"

AND git diff is empty:

STOP.

Resolve discrepancy.

---

## Update CLAUDE.md

If architectural decisions affect it.

---

## Complete Review Log

Mark iteration complete.

---

## Create Implementation Plan

Location:

docs/Plans/

Filename:

YYYYMMDD-description.md

Required sections:

### Spec Review

Final intent record

### Spec Diff

Raw git diff .claude/ output

Or:

"No changes — verified via git diff"

### Spec Requirements

With links

### Proposed Implementation

### Testing Plan

### Open Questions

---

# Phase 5: Exit

Output:

1. Files created
2. Files modified
3. Failure modes added or updated
4. Confirmation ready for implementation

---

# design-review-log.md Format

Append-only.

Never overwrite.

# Design Review Log

## Iteration [N] — [date]

Status: In Progress | Complete

| #   | Source | Feedback Summary | Decision | Rationale | Next Step |
| --- | ------ | ---------------- | -------- | --------- | --------- |

### Failure Modes Updated

- FM-001
- FM-004

### Open Questions

- [ ] item

### Resolved

- [x] item — resolution

---

After writing:

- Output line count
- Confirm no prior content was lost

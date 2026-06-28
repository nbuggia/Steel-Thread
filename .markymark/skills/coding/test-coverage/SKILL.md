---
name: test-coverage
description: Semantic test coverage check before adversarial-review — verifies the right things are tested, not just line counts
invoke: model
triggers: after all tasks in a phase are complete, before adversarial-review runs
---

Verifies adequate test coverage before a phase is marked complete. Not a line-coverage percentage check — a semantic coverage check. Are the right things tested?

## What it checks

**Acceptance criteria coverage:**
- Every acceptance criterion in the relevant specs has a corresponding test
- Tests are named to match the criteria they verify
- A failing test means a failing acceptance criterion

**Edge case coverage:**
- Exception cases from the functional requirements table have negative tests
- Boundary conditions are tested
- Error paths are tested, not just happy paths

**Integration coverage:**
- Components that interact have integration tests
- Trust boundaries have explicit tests for invalid input
- Auth checks are tested for bypass attempts

## Output

Coverage gaps listed as specific missing tests, not percentages:
- "Missing: test for session expiry during active request."
- "Missing: test for SQL injection in user search field."

Adds missing test tasks to tasks.json if coverage gaps are significant. Runs simplify-post on test files after writing new tests — test code deserves the same simplicity discipline as production code.

## Verdict

- **PASS** — adequate coverage, phase can proceed to adversarial-review
- **FAIL** — gaps that must be addressed before the phase closes

---
name: find-the-bug
description: Reviews a file or function for issues without making any changes
invoke: user
---

Review the specified code for bugs and issues. Read-only — no changes are made. Every finding includes the location, the problem, and the fix.

## Steps

**1. Identify scope**
What file or function are we reviewing? If not specified, ask.

**2. Read CONTEXT.md and relevant specs**
Before reviewing, understand:
- What this code is supposed to do
- What constraints apply to this part of the codebase
- Any "never do" rules that apply

**3. Read the code**
Read the full file or function. Understand what it does before looking for what it does wrong.

**4. Find issues — in priority order**

**Correctness:**
- Logic errors — wrong branching, wrong comparison, off-by-one
- Wrong assumptions about input range, type, or format
- Missing cases — conditions that trigger behavior the code doesn't handle
- State mutations that affect other callers

**Error handling:**
- Errors caught and swallowed silently
- Error paths that return wrong types or undefined behavior
- Missing null/undefined checks at trust boundaries

**Security:**
- Input not validated before use
- SQL, XSS, or command injection vectors
- Credentials or secrets handled insecurely

**Concurrency:**
- Race conditions in async paths
- Shared state accessed without coordination
- Timeouts or retries missing where network is involved

**Performance:**
- Unnecessary work inside loops
- N+1 query patterns
- Missing index lookups

**5. Report findings**

For each finding:
- Location: file:line
- Problem: one sentence describing what is wrong
- Fix: the specific change to make, or the approach

Rank findings by severity. CRITICAL issues go first.

**6. Verdict**
- CLEAN — no significant issues
- CONCERNS — issues worth addressing, can ship with awareness
- BLOCK — must fix before this code is safe to use

## Rules

- Make no changes to any file during this skill
- Do not pad the report with non-issues
- If the code looks correct, say so with evidence: "Reviewed [N] lines. Logic is sound. Error handling is correct for [conditions]. No issues found."

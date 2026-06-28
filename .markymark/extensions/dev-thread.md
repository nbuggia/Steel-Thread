# Dev-Thread — Coding Extension

This file extends the Steel Thread for projects with a software
development component. Read it alongside CLAUDE.md when the dev
extension is activated.

Activated during /onboard when the project has a coding component,
or manually by the customer at any time.

---

## Additional Files

The dev extension adds these files to the project:

```
docs/
  prd.md                 ← single PRD, living strategic document
  specs/
    login.md             ← one file per feature, flat structure
    session-management.md
  tech-designs/
    jwt-authentication.md ← one file per design, may span features
  plans/
    user-authentication.md ← one file per plan, may span features
  bugs/
    bugs.md              ← two-table index, open and closed
    BUG-XXXXX.md         ← companion file, complex bugs only
    assets/
      BUG-00001-01.png   ← named by bug ID, auto-associated
```

**Key structural decisions:**
- No README files — Claude lists folder contents directly
- No status fields — status derived from tasks.json phase and completion
- No frontmatter — relationships captured in document headers
- Flat structure for specs — no per-feature subfolders
- Plans and tech designs may span multiple features
- Phase mapping lives in tasks.json, not in spec files

---

## Document Pipeline

```
PRD
 └── spec.md (one per feature, flat in docs/specs/)
      └── tech-design.md (may span features, flat in docs/tech-designs/)
           └── plan.md (may span features, flat in docs/plans/)
                └── tasks.json (tasks reference plan and spec)
```

Each document builds on the previous. Each skill reads upstream
documents automatically — the customer never re-explains context
across the pipeline.

Relationships are captured in document headers, not folder structure.
Phase mapping lives in tasks.json. Status is derived from task
completion — never a manually maintained field.

---

## Implementation Quality Skills

These three skills form the quality envelope around every
implementation task and phase in the dev extension.
All are model-invoked — the customer never has to call them.

---

### simplify-pre

```
invoke: model
triggers: before any implementation begins
uses: Simplicity skill — pre-build mode
```

Runs silently before Claude writes any code. Climbs the
decision ladder, identifies minimum viable approach, documents
deliberate shortcuts with upgrade paths.

Full behavior defined in the Simplicity foundational skill
in steel-thread.md — pre-build mode.

Not lazy about: input validation at trust boundaries, error
handling that prevents data loss, security requirements, or
anything explicitly required by the spec.

Stays active throughout the session — applies to every piece
of code written, not just the first.

---

### simplify-post

```
invoke: model
triggers: after implementation of each task is complete
uses: Simplicity skill — post-build mode
```

Runs three parallel passes on recently changed files after
implementation: reuse, clarity, complexity. Finds and fixes
issues. Never changes behavior — only how the code achieves it.

Full behavior defined in the Simplicity foundational skill
in steel-thread.md — post-build mode.

Output to customer: one-line summary of what changed.
Customer can review the diff if they want detail.

---

### arch-review

```
invoke: model
triggers: after completing a set of related features,
  or when a development milestone is complete
uses: Adversarial Review foundational skill — principal engineer persona
```

Holistic architectural review across the full milestone diff.
Not a correctness check — a coherence check. Steps back from
individual features and asks whether the whole hangs together.

Runs at two moments:
- After a set of related features that share a technical concern
- After a milestone is complete (Alpha → Beta, Beta → GA)

**Domain expert: principal engineer or architect**
Has designed systems that outlived their original teams.
Thinks in decades, not sprints. Asks whether the system
will be easy or hard to extend for the next milestone.

**What arch-review asks that adversarial-review doesn't:**

Coherence:
- Has the system grown coherently or has it accreted?
- Does the codebase still match what CONTEXT.md says it is?
- Are the boundaries between components still clean?
- Has any component become a god object?

Data model:
- Is the data model still normalized or has it drifted?
- Are there implicit assumptions baked into the schema
  that will be painful to reverse?
- Do the data relationships still reflect the domain model?

Architecture drift:
- Where has implementation diverged from the tech designs?
- Are the divergences intentional and documented, or accidental?
- Should the tech designs be updated to reflect reality?

Risk map:
- Which parts of the system will slow down the next milestone?
- Where is technical debt most concentrated?
- What has the highest probability of causing a production incident?
- Are there implicit dependencies that should be explicit?

Extensibility:
- What would make this system hard to extend for the next milestone?
- Are there patterns that made sense feature by feature
  but look wrong together?
- What refactoring now would pay off most in the next milestone?

**Output:**

Health assessment — overall architectural coherence in one paragraph.
COHERENT / FRAGILE / NEEDS ATTENTION verdict.

Drift report — where implementation diverged from tech designs.
For each divergence: was it intentional? Should the tech design
be updated to reflect reality?

Risk map — top three areas of concentrated risk, ranked.
For each: what triggers it and what it would take to address it.

Refactor backlog — specific improvements worth making before
the next milestone. Added directly to tasks.json with low
priority so they don't block progress but don't get forgotten.

CONTEXT.md proposals — architectural principles discovered
during implementation that should be permanent project knowledge.
"All state management flows through a single store."
Proposed for customer approval before writing.

**After arch-review:**
- Update tech designs where implementation diverged intentionally
- Add refactor tasks to tasks.json (low priority)
- Propose architectural learnings for CONTEXT.md
- Tell the customer what the next milestone should focus on:
  "Architecture is [verdict]. Before starting Beta, the highest
  value thing to address is [top risk]. Want me to add that
  as a high priority task?"

---

### security-review

```
invoke: model
based-on: agamm/claude-code-owasp, trailofbits/skills
triggers: after each phase, alongside adversarial-review
```

OWASP-informed security review of recently changed code.
Runs as a dedicated security lens — separate from adversarial-review
which focuses on correctness. Uses a fresh sub-agent context so
the reviewer approaches the code cold, as a real security auditor would.

**OWASP Top 10:2025 checks (applied to changed code):**
- A01 Broken Access Control — are permissions enforced at every layer?
- A02 Cryptographic Failures — are secrets handled correctly?
- A03 Injection — SQL, XSS, command injection vectors?
- A04 Insecure Design — trust boundaries correct?
- A05 Security Misconfiguration — defaults safe?
- A06 Vulnerable Components — dependencies up to date?
- A07 Authentication Failures — auth logic sound?
- A08 Software Integrity Failures — supply chain risks?
- A09 Logging Failures — sensitive data in logs?
- A10 SSRF — server-side request forgery vectors?

**OWASP Agentic AI:2026 checks (if project uses AI):**
- ASI01 Prompt injection vectors
- ASI02 Excessive agency — does the agent have more permissions than needed?
- ASI03 Memory poisoning risks

**Output:**
Severity-ranked findings only — no padding, no 30-page reports.
One line per finding: location, vulnerability class, fix.
BLOCK on critical findings. CONCERNS on high. LOW on medium and below.

On BLOCK: creates tasks in tasks.json, phase stays open.
On CONCERNS: adds notes to relevant tech design.
Applies fixes directly for straightforward issues.

---

### secrets-guard

```
invoke: always-on hook
based-on: varlock-claude-skill
triggers: before any file write, commit, or terminal output
```

Prevents secrets from ever appearing in sessions, terminals,
logs, or git commits. Always on — not a skill the customer
invokes, a protection layer that runs automatically.

**What it catches:**
- API keys and tokens in any format
- Passwords and credentials
- Private keys and certificates
- AWS/GCP/Azure credentials
- Database connection strings with credentials
- Any value matching known secret patterns

**Behavior:**
- Blocks writes that contain secrets before they reach disk
- Redacts secrets from terminal output automatically
- If a secret is detected in context, alerts the customer
  and suggests moving it to environment variables
- Never logs or surfaces the actual secret value

**Setup:**
During /onboard, creates a .env.example file with placeholder
values for all required secrets. Adds .env to .gitignore.
Documents secret management approach in CONTEXT.md under
"Security conventions."

---

### threat-model

```
invoke: model
based-on: Security-Phoenix-demo/security-skills-claude-code
triggers: during /tech-design Phase 3 (grilling)
```

Security-focused grilling session that runs during tech design
before any implementation decisions are finalized. Uses the
foundational Grilling skill with a security engineering lens.

**Domain expert: application security engineer**
Thinks adversarially. Asks "how does an attacker abuse this?"
before "how does a user use this?"

**Questions the threat model asks:**

Trust boundaries:
- Where does data enter the system from untrusted sources?
- What assumptions are we making about callers?
- Where could a malicious actor inject input?

Data sensitivity:
- What data does this feature touch?
- What's the blast radius if this component is compromised?
- Does this feature need to touch sensitive data at all?

Authentication and authorization:
- Who can call this? Is that enforced?
- What happens if auth is bypassed?
- Are there privilege escalation paths?

Failure modes:
- What happens when this fails? Does it fail safely?
- Could an attacker trigger failure intentionally?
- Does failure reveal sensitive information?

**Output:**
A "Security considerations" section added to the tech design.
High-risk decisions flagged for security-review to check
during implementation. Threat model summary added to CONTEXT.md
under "Security decisions."

---

### systematic-debugging

```
invoke: model
based-on: BehiSecc/awesome-claude-skills systematic-debugging
triggers: when encountering any bug, test failure, or
  unexpected behavior — before proposing any fix
```

Structured investigation protocol before any fix attempt.
Prevents the most common debugging failure: fixing symptoms
instead of causes.

**The protocol — stop at each step before proceeding:**

Step 1 — Reproduce:
Confirm the bug is reproducible before doing anything else.
What are the exact conditions? Is it deterministic or flaky?
A bug you can't reliably reproduce can't be reliably fixed.

Step 2 — Isolate:
Narrow the reproduction case to the minimum that still
triggers the bug. Remove variables. The smallest failing
case reveals the most about the cause.

Step 3 — Hypothesise:
Form one specific hypothesis about the root cause.
Not "something is wrong with auth" — "the JWT expiry check
doesn't account for clock skew between services."
One hypothesis at a time. Test it before forming the next.

Step 4 — Instrument:
Add logging or assertions to verify the hypothesis.
Read the evidence. Don't guess — measure.

Step 5 — Fix:
Only after steps 1-4 are complete. The fix should be
obvious once the root cause is confirmed. If the fix
isn't obvious, the root cause isn't confirmed yet.

Step 6 — Verify:
Run the original reproduction case. Run the full test suite.
Confirm the fix doesn't introduce regressions.

**Integration with /bug:**
When systematic-debugging confirms a root cause, it
updates the bug row in bugs.md with the finding before
the fix is applied. This ensures the root cause is
documented even if the fix is abandoned.

---

### test-coverage

```
invoke: model
triggers: part of phase gate, before adversarial-review runs
```

Verifies adequate test coverage before a phase is marked
complete. Not a line-coverage percentage check — a semantic
coverage check. Are the right things tested?

**What it checks:**

Acceptance criteria coverage:
- Every acceptance criterion in the relevant specs has
  a corresponding test
- Tests are named to match the criteria they verify
- A failing test means a failing acceptance criterion

Edge case coverage:
- Exception cases from the functional requirements table
  have negative tests
- Boundary conditions are tested
- Error paths are tested, not just happy paths

Integration coverage:
- Components that interact have integration tests
- Trust boundaries have explicit tests for invalid input
- Auth checks are tested for bypass attempts

**Output:**
Coverage gaps listed as specific missing tests, not percentages.
"Missing: test for session expiry during active request."
"Missing: test for SQL injection in user search field."

Adds missing test tasks to tasks.json if coverage gaps are
significant. Runs simplify-post on test files after writing
new tests — test code deserves the same simplicity discipline
as production code.

**Verdict:**
PASS — adequate coverage, phase can proceed to adversarial-review
FAIL — gaps that must be addressed before phase closes

---

### doc-sync

```
invoke: model
triggers: after each phase, after adversarial-review passes
```

Checks that specs and tech designs still accurately describe
what was built. Flags where implementation diverged from
documentation. Prevents the most common documentation failure:
specs that describe what was planned, not what exists.

**What it checks:**

Spec accuracy:
- Do the functional requirements still match the implementation?
- Are the acceptance criteria still the right tests?
- Does the user flow still match what was built?
- Are out-of-scope items still out of scope, or did scope creep in?

Tech design accuracy:
- Does the architecture description match the actual code structure?
- Are the alternatives considered still the right comparison?
- Do implementation notes reflect what was actually discovered?
- Are deliberate shortcuts still documented, or were they cleaned up?

Open questions:
- Have any open questions been answered by the implementation?
- Have new questions emerged that need documenting?

**Output:**
List of divergences with recommended updates.
For each: is this an intentional deviation (update the doc)
or an unintentional one (fix the code)?

Applies straightforward documentation updates directly.
Flags ambiguous divergences for customer decision.
Never changes code — only proposes documentation updates.

---

### changelog-gen

```
invoke: user
triggers: at each milestone (Alpha/Beta/GA)
```

Transforms the raw changelog.json into a human-readable
release summary. Two versions: technical (for the team)
and user-facing (for customers).

**Reads:**
- changelog.json — every file change since the last milestone
- tasks.json — which tasks and phases are complete
- docs/prd.md — what features were planned for this milestone
- bugs/bugs.md — which bugs were fixed

**Technical changelog:**
Organized by feature. For each feature: what changed,
what was added, what was removed, which bugs were fixed.
Honest about known limitations and deferred items.

**User-facing release notes:**
Plain language. Benefits not features. "You can now export
to PDF" not "Added PDF export endpoint." No jargon.
Follows Marky Mark's brand voice — specific, honest, no hype.

**Output:**
Writes to docs/CHANGELOG.md appending a new milestone section.
Proposes the user-facing version for customer review before
publishing.

---

### readme-gen

```
invoke: model
triggers: at each milestone, after changelog-gen
```

Generates and maintains a project README from existing
Steel Thread files. Never manually maintained — always
derived from the source of truth.

**Sources:**
- CONTEXT.md — project summary, vocabulary, key decisions
- docs/prd.md — problem, users, core features
- docs/tech-designs/ — architecture overview
- tasks.json — current phase and what's complete
- CHANGELOG.md — recent milestone summary

**README structure:**
```markdown
# [Project Name]

[One paragraph from CONTEXT.md project summary]

## What it does
[From PRD problem and core features]

## Architecture
[High-level from tech designs — one paragraph]

## Current status
[From tasks.json — which milestone, what's complete]

## Getting started
[From CONTEXT.md setup conventions]

## Recent changes
[Latest milestone from CHANGELOG.md]
```

**Rules:**
- Never more than one screenful without scrolling
- Written for the person joining the project cold
- Updated at every milestone, not manually between milestones
- Proposes updates to customer before writing

---

### adversarial-review (dev extension)

```
invoke: model
triggers: when all tasks in a phase are marked complete
uses: Adversarial Review foundational skill + dev-specific checks
```

Extends the foundational Adversarial Review skill in
steel-thread.md with dev-specific concerns. Runs across
the full phase diff — not a single file, but everything
built in this phase.

Domain expert: staff engineer who has built systems at scale.
Has been paged at 3am for every category of failure below.

**Dev-specific challenges (in addition to foundational steps):**

Correctness:
- Does every spec requirement have a corresponding implementation?
- Are acceptance criteria from the specs all met?
- Are edge cases from the spec's exception column handled?

Security:
- Is input validated at trust boundaries?
- Is user data handled safely?
- Are there injection vectors — SQL, XSS, command injection?
- Are secrets handled correctly — never in code, never in logs?

Architecture:
- Does the implementation match the tech design?
- Are significant deviations documented?
- Is the phase's code consistent in approach across features?
- Has simplicity discipline been maintained?

Cross-feature integrity:
- Did two features independently implement the same helper?
- Are there inconsistencies in how similar problems were solved?
- Does the data model stay consistent across features?

**Verdict and next steps:**
- BLOCK — creates tasks in tasks.json, phase stays open
- CONCERNS — adds notes to relevant spec or tech design
- CLEAN — marks the phase complete in tasks.json

---

## /prd

```
invoke: user
```

Create or update the project PRD via structured interview.
Use when defining what to build, scoping features, or
revisiting product direction.

The PRD is a living strategic document. It defines the problem,
the users, the competitive landscape, the core features, and
the phasing. It does not contain implementation detail —
that belongs in feature specs.

**When to run /prd:**
- New project with a software development component
- Significant change in product direction
- Customer asks "what should we build" or "is this the right scope"
- Before writing any feature specs

**Phase 1 — Read existing context**
Before asking anything, read:
- CONTEXT.md — what the project is, vocabulary, decisions
- docs/prd.md — if it exists, understand current state
- docs/bugs/bugs.md — if it exists, what pain points have emerged

If prd.md already exists, this is an update session not a
creation session. Orient accordingly: "Your PRD covers X.
You have Y features in Alpha and Z in Beta. What's changed?"

**Phase 2 — Competitive research**
Before grilling the customer on features, search for competitive
context. Use web search to understand:
- Who else is solving this problem
- What the market leaders do well and where they fall short
- What the obvious differentiation angles are

Draft a competitive landscape table and present it to the
customer for review before moving to features.
"Here's what I found — does this match your understanding?
Anyone missing?"

This grounds the feature conversation in reality rather than
assumptions.

**Phase 3 — Grilling (use Grilling skill)**
Run the grilling loop on:

1. The problem — who has it, how bad is it, what does success
   look like. Push for specificity. "Information workers" is
   not specific enough. "Product managers who spend 2+ hours
   a day moving content between Claude and Google Docs" is.

2. The users — primary user first, secondary users below.
   For each: what is their job, what is their pain, what does
   a good day look like with this product.

3. The core features — what are the features that make or break
   this product? If any of these are missing, the product
   doesn't work. Push back on feature lists that are too long.
   "Which three of these, if missing, mean you have no product?"

4. The phasing — what is true for Alpha, Beta, GA, V2?
   Alpha validates the core loop. Beta validates real-world
   usage. GA is the product you're willing to stand behind.
   V2 is post-GA learnings. Backlog is explicitly not yet.

5. Success metrics — how do you know this worked?
   2-3 measurable outcomes per phase. Not vanity metrics.

**Phase 4 — Build the features table**
For each core feature, capture:

| Feature | Scope & Differentiation | Why it matters | Phase |
|---------|------------------------|---------------|-------|

Scope & Differentiation comes first. It defines what the feature
actually is and what makes this implementation different from what
exists. If you can't write a sharp differentiation note, the
feature may not be a core feature.

Why it matters is the customer benefit — one sentence.
Phase is Alpha / Beta / GA / V2 / Backlog.

**Phase 5 — Adversarial review (use Adversarial Review skill)**
Before writing prd.md, run adversarial review.
Domain expert: senior PM who has shipped this kind of product.

Challenge:
- Is the problem statement real and specific enough?
- Does the competitive analysis reveal a genuine gap?
- Are the core features truly make-or-break, or is this a
  wish list in disguise?
- Is the phasing realistic or is Alpha already a full product?
- Are the success metrics measurable or aspirational?
- What has been missed entirely?

Fix any BLOCK issues before writing.
Surface CONCERNS in the open questions section.

**Phase 6 — Write prd.md**

```markdown
# [Project Name] — Product Requirements Document

## Problem
[One paragraph. Who has this problem, how bad is it,
what does success look like. No solution language.]

## Users
**Primary:** [One sentence — job title, specific pain]
**Secondary:** [One sentence per additional user type]

## Competitive Landscape
| Competitor | Strength | Weakness | Our Angle |
|------------|----------|----------|-----------|

**What we do that nobody else does:**
[One clear sentence]

**What we deliberately do not compete on:**
[What we're leaving to others]

## Core Features
| Feature | Scope & Differentiation | Why it matters | Phase |
|---------|------------------------|---------------|-------|

## Phasing

**Alpha** — internal or invite-only. Validates the core loop.
Exit criteria: [what must be true before Beta]

**Beta** — limited public. Validates real-world usage.
Exit criteria: [what must be true before GA]

**GA / V1** — public launch. The product we stand behind.
Exit criteria: [what must be true before V2 planning]

**V2** — next expansion after GA learnings.
[Placeholder — details defined post-GA]

**Backlog** — explicitly not yet. Revisit after V2.
- [Item]

## Success Metrics
| Phase | Metric | Target |
|-------|--------|--------|

## Open Questions
| Question | Owner | By |
|----------|-------|----|
```

**After writing:**
- Add a task to tasks.json: "Review PRD with team"
- Propose any new vocabulary for CONTEXT.md
- Tell the customer what to do next:
  "PRD is written. Next step is /spec for [highest priority
  Alpha feature]. Want to start there?"

**Living document rules:**
- prd.md is never locked. Customer can edit it directly.
- When significant changes are made, run adversarial review again.
- When a feature moves phases, update the table and phasing section.
- When open questions are answered, update or remove them.

---

## /spec

```
invoke: user
```

Take a feature from prd.md and produce a detailed feature spec.
One file per feature in docs/specs/. Flat structure — no subfolders.

Reads prd.md automatically. The customer never re-explains
feature context that's already in the PRD.

**When to run /spec:**
- After /prd is complete and approved
- For each feature in the current phase
- When a feature's requirements change significantly
- Customer asks "what exactly are we building for X?"

**Phase 1 — Read existing context**
Before asking anything, read:
- CONTEXT.md — project vocabulary and decisions
- docs/prd.md — find the feature row in the Core Features table
- docs/specs/ — list existing specs to understand what's covered
- docs/tech-designs/ — any existing designs that touch this feature

Extract from the PRD:
- Feature name and scope note
- Why it matters
- Phase (Alpha/Beta/GA)

If a spec already exists for this feature, this is an update
session. Orient accordingly: "Your spec for [feature] covers X.
What's changed?"

**Phase 2 — Mock first for UI features**
Before writing any requirements, determine if this is a UI feature.
If yes, the mock must exist before the spec is written.

Options:
- Customer provides a screenshot or image → reference by path
- Customer describes the UI → Claude generates an ASCII wireframe
- Customer has a design tool link → reference the URL

Present the mock to the customer and confirm it represents
the intended design before proceeding. Requirements derive
from the mock — not the other way around.

**Phase 3 — Grilling (use Grilling skill)**
Run the grilling loop focused on:

1. User flow — what does the user do, step by step?
   No implementation language. Pure user perspective.
   "User clicks X" not "system calls API endpoint Y"

2. Functional requirements — for each step in the user flow,
   what data is touched, what is the business rule, what are
   the exceptions? Apply the three-dimension check:
   - Data: what does this requirement read or write?
   - Business rule: what logic governs this behavior?
   - Exception: what happens when it goes wrong?

   If Claude can't answer all three, ask before writing.
   This prevents hallucinated requirements.

3. Out of scope — what does this feature explicitly not cover?
   Each out-of-scope item should reference where it will be
   handled instead, or acknowledge it as a future decision.

4. Open questions — what do we not know yet?
   Who owns each question and by when do we need an answer?

**Phase 4 — Acceptance criteria**
For each functional requirement, write a testable acceptance
criterion in Given/When/Then format:

  Given [context]
  When [action]
  Then [observable outcome]

Vague criteria ("works correctly", "performs well") are not
acceptable. If a criterion can't be tested, it needs to be
rewritten until it can.

**Phase 5 — Quality gate**
Before running adversarial review, check every item:

- [ ] Mock present for all UI features
- [ ] Every requirement traces to something visible in the mock
- [ ] Every requirement has data, business rule, and exception
- [ ] User flow has no implementation language
- [ ] All acceptance criteria are testable Given/When/Then
- [ ] Out of scope is explicit — nothing ambiguously omitted
- [ ] Open questions have owners and target dates

Any unchecked item gets resolved before moving to adversarial review.

**Phase 6 — Adversarial review (use Adversarial Review skill)**
Domain expert: product leader who has shipped this kind of feature.

Challenge:
- Does the mock match what the PRD describes?
- Are any requirements missing that the mock implies?
- Are the business rules complete or do they hide assumptions?
- Are the exceptions realistic or theoretical?
- Are the acceptance criteria actually testable?
- Is out of scope specific enough to prevent scope creep?
- What will the engineering team ask that this spec doesn't answer?

Fix any BLOCK issues. Surface CONCERNS in open questions.

**Phase 7 — Write the spec**

```markdown
# [Feature Name]

## What we're building
[One paragraph. Plain language. Sets context for the mock.
Derives from the PRD scope note and why it matters.
No implementation language.]

## Mock
[For UI features: wireframe, screenshot, or ASCII mock.
This is the source of truth for what gets built.
Requirements and acceptance criteria derive from this.
Omit for non-UI features.]

## User flow
[Numbered steps. Pure user perspective. No implementation language.]
1.
2.
3.

## Functional requirements

| Requirement | Data | Business Rule | Exception |
|-------------|------|---------------|-----------|

## Acceptance criteria
- Given [context] / When [action] / Then [outcome]

## Out of scope
- [Explicit item — references where it will be handled]

## Open questions
| Question | Owner | By |
|----------|-------|----|

## Quality gate
- [ ] Mock present for all UI features
- [ ] Every requirement traces to something visible in the mock
- [ ] Every requirement has data, business rule, exception
- [ ] User flow has no implementation language
- [ ] All acceptance criteria are testable
- [ ] Out of scope is explicit
- [ ] Adversarial review passed — verdict: [CONCERNS/CLEAN]
```

**After writing:**
- Add a task to tasks.json: "Review spec: [feature name]"
  assigned to the current phase
- Tell the customer what to do next:
  "Spec written for [feature]. Next step is /tech-design
  to define the technical approach. Want to start there?"

**Living document rules:**
- Specs are never locked. Customer can edit directly.
- When requirements change, update the spec and re-run
  the quality gate before updating the tech design.
- When open questions are answered, update or remove them.
- The spec is the source of truth for what the feature does.
  The tech design is the source of truth for how it's built.

---

## /tech-design

```
invoke: user
```

Take a feature spec and produce a technical design document.
One file per feature in docs/tech-design/.

Reads the relevant spec automatically.
Reads CONTEXT.md for codebase context.

**Runs adversarial review before saving.**
Domain expert: staff engineer who has built systems at scale.

Challenges: failure modes, assumptions that break under load,
simpler designs that achieve the same outcome.

---

## /plan

```
invoke: user
```

Take one or more tech designs and produce an implementation plan.
Writes phases and tasks directly to tasks.json. One plan file
per unit of work in docs/plans/.

Reads tech designs automatically. Never starts planning without
a tech design — if none exists, run /tech-design first.

**When to run /plan:**
- After a tech design is approved
- When breaking a tech design into implementable tasks
- When the customer asks "what do we build first?"
- When a phase is complete and needs replanning

**Phase 1 — Read existing context**
Before asking anything, read:
- CONTEXT.md — project vocabulary and constraints
- All referenced tech designs in docs/tech-designs/
- The specs those tech designs cover in docs/specs/
- tasks.json — existing phases and tasks to avoid duplication
- docs/prd.md — phase context (Alpha/Beta/GA)

Understand what's already planned and what's new.
If tasks already exist for these specs, this is a replan session.
Orient accordingly: "You have [N] tasks planned for this feature.
What's changed?"

**Phase 2 — Vertical slice first**
The most important planning decision: slice vertically, not
horizontally.

Horizontal phasing (wrong):
- Phase 1: all database changes
- Phase 2: all API changes
- Phase 3: all UI changes

Vertical slicing (right):
- Phase 1: thin slice that works end-to-end — login flow
  with minimal DB, API, and UI, all working together
- Phase 2: extend the slice — add session management
- Phase 3: extend again — add password reset

A vertical slice delivers something testable and reviewable
at the end of each phase. Horizontal phasing delays end-to-end
feedback until the final phase.

Before writing any tasks, propose the vertical slice structure
to the customer: "I'd suggest three phases — here's the thin
slice for each one. Does this feel right?"

**Phase 3 — Grilling (use Grilling skill)**
Run the grilling loop on genuinely open planning questions:

- Dependencies: what must be true before each phase can start?
  External dependencies? Team dependencies?
- Risk: which tasks are highest risk? Should they go first?
- Testability: how do we know each phase worked?
  What's the exit criterion before moving to the next phase?
- Order: within each phase, what's the natural sequence?
  What unblocks the most other tasks when done first?

**Phase 4 — Task breakdown**
For each phase, break the tech design into tasks. Each task must:
- Be completable in one session (roughly half a day)
- Have enough detail that a zero-context session could pick it
  up and know exactly what to do
- Reference the relevant spec and tech design by path
- Have a clear done condition

Tasks that are too large get split. Tasks that are too small
get merged. The right granularity is: one session, clear done.

**Phase 5 — Write to tasks.json**
Write phases and tasks directly to tasks.json.

For each phase:
```json
{
  "id": "phase-00001",
  "name": "Thin vertical slice — login flow",
  "order": 1,
  "complete": false
}
```

For each task:
```json
{
  "id": "task-00001",
  "title": "Add users table with email and hashed password",
  "detail": "Schema in tech-designs/jwt-authentication.md section 2.
    Spec acceptance criteria in specs/login.md.
    Done when: migration runs, table exists, rollback works.",
  "complete": false,
  "priority": "high",
  "phase": "phase-00001",
  "order": 1,
  "created": "2026-06-27",
  "completed_date": null
}
```

**Phase 6 — Write plan.md**
Write a human-readable plan file alongside tasks.json.
This is for the customer and team to read — tasks.json is
for the system.

```markdown
# [Plan Name] — Implementation Plan

## Tech designs covered
- tech-designs/[design-a].md
- tech-designs/[design-b].md

## Approach
[One paragraph. Why these vertical slices in this order.
What the customer gets at the end of each phase.]

## Phases

### Phase 1 — [Name]
**Done when:** [exit criterion — specific and testable]
**Tasks:**
1. [task title] — [one-line description]
2. [task title] — [one-line description]

### Phase 2 — [Name]
**Done when:** [exit criterion]
**Tasks:**
1. [task title]
2. [task title]

## Dependencies
[External or team dependencies that could block progress]

## Risks
[Highest-risk tasks and mitigation approach]
```

**After writing:**
- Confirm task count and phase structure with customer:
  "Written [N] tasks across [M] phases. Phase 1 delivers
  [what]. Want to start, or adjust anything first?"
- Activate simplify-pre for the first task automatically

**Living document rules:**
- tasks.json is the system of record — it drives the task viewer
- plan.md is the human-readable companion — keep in sync
- When implementation diverges from the plan, update both
- When a phase completes, run adversarial-review before
  marking it done and starting the next phase
- Never delete tasks — mark complete with completed_date

**The implementation loop after /plan:**
```
pick first incomplete task in current phase
  → simplify-pre (model-invoked, before implementation)
  → implement
  → simplify-post (model-invoked, after implementation)
  → if bug encountered: systematic-debugging (model-invoked)
  → mark task complete

all tasks in phase complete
  → test-coverage (model-invoked) — PASS before proceeding
  → security-review (model-invoked) — parallel with adversarial
  → adversarial-review (model-invoked) — BLOCK/CONCERNS/CLEAN
  → doc-sync (model-invoked) — after adversarial passes
  → mark phase complete
  → pick first task in next phase

milestone complete (Alpha/Beta/GA)
  → arch-review (model-invoked) — COHERENT/FRAGILE/NEEDS ATTENTION
  → update tech designs where implementation diverged
  → add refactor tasks to tasks.json (low priority)
  → propose architectural learnings for CONTEXT.md
  → changelog-gen (user-invoked) — technical + user-facing notes
  → readme-gen (model-invoked) — update project README
  → begin next milestone
```

---

## Bug System

### bugs.md format

```markdown
# Bugs

## Open

| ID | Title | Severity | Notes |
|----|-------|----------|-------|
| BUG-00001 | Button unresponsive on mobile | high | iOS Safari only |
| BUG-00002 | Export fails on large files | medium | Files > 10MB |

## Closed

| ID | Title | Severity | Closed | Root Cause | Solution |
|----|-------|----------|--------|------------|----------|
| BUG-00003 | Dark mode flicker on load | low | 2026-06-22 | CSS load order | Moved stylesheet to head |
```

### Asset naming convention
Assets named by bug ID are automatically associated:
BUG-00001-01.png, BUG-00001-02.png, BUG-00001-03.mov

Create a companion BUG-XXXXX.md when assets exceed three files
or when the customer requests extended documentation.

### /bug command
One-shot bug capture:

  /bug Button doesn't respond on mobile — iOS Safari only — high

Claude assigns the next BUG ID, appends a row to the Open table,
and creates a task in tasks.json. No back and forth required.

### Bug prioritization
After any bug is added, suggest a fix sequence based on:
- Severity — high before medium before low
- Dependencies — is this blocking other tasks?
- Proximity — already working in that part of the codebase?
- Patterns — do multiple bugs share a likely root cause?

"You have three open bugs. BUG-00001 is high severity and likely
shares a root cause with BUG-00002 — worth fixing together.
Want to start there?"

### After fixing a bug
Claude already knows the root cause and solution.
Do not prompt the customer.

1. Fix the bug
2. Update bugs.md directly — move row from Open to Closed,
   fill in completion date, root cause, and solution
3. Mark the task complete in tasks.json
4. Give the customer a one-line summary:
   "Fixed BUG-00001 — touch event handler wasn't attached on iOS.
   Closed in bugs.md."

If multiple bugs shared a root cause, close all of them and say so.

### Learnings mining
The closed bugs table is a pattern library. The dreaming process
periodically scans it and proposes learnings for CONTEXT.md under
a "Known Patterns" section:
- Recurring root causes worth a permanent fix or rule
- Files or components that appear repeatedly
- Patterns that suggest a process or testing gap

Customer approves before anything is written to CONTEXT.md.

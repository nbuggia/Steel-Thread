# Prior Art: Spec-Driven Open Source Projects

How popular open source projects lay out specs, designs, tasks, decisions and conventions in practice, and what Hashbang can learn from them. Researched 2026-10-26 from each repo's file tree on its default branch, plus its AGENTS.md, CONTRIBUTING.md and spec READMEs. Individual specs were sampled, not read in full.

## Summary

Of 37 popular AI-era repos scanned, 10 have a real spec layout. The other 27 have only AGENTS.md or CLAUDE.md files and contributing guides. The 10 agree on most of the shape, and split on what happens to a spec after it ships.

- **Common ground:** a product spec and a tech spec per change, a folder per change, a decision log, a glossary, and a light path for small changes.
- **The split:** most keep every spec forever. Only OpenSpec, open-design and opencode separate current truth from history.
- **Rare in the repo:** task lists. Almost everyone tracks work in GitHub issues. Hashbang's TASKS.md and BACKLOG.md are a deliberate difference, for solo builders with no tracker.
- **Unique to Hashbang:** the close step's trace of where each lasting fact landed, and session memory (pickup, history).
- **Best source to learn from:** Warp. Its specs, skills and code are the cleanest of the ten.

## Method

Candidates were the most-starred AI-era repos on GitHub, plus the spec frameworks themselves. Each repo's tree was scanned for spec, plan, ADR, decision, PRD and convention files, skipping tests, fixtures and examples. Unauthenticated GitHub search can't query file paths, so a project using `.specify/` or `.kiro/specs/` outside this list could have been missed. The sample leans toward AI tooling.

## The ten

Star counts are from 2026-10-26.

### Warp

[warpdotdev/warp](https://github.com/warpdotdev/warp), 66k stars. A terminal and agent app. Client code is AGPL-3.0; the `warpui` crates are MIT.

- **Specs:** `specs/<id>/PRODUCT.md` and `TECH.md`, about 293 folders. The id is a Linear ticket (`APP-4068`), a GitHub issue (`gh-4567`), or a short feature name. `specs/` holds only id-named folders.
- **PRODUCT.md:** Summary and Behavior are required, everything else is optional and its heading is left out when empty. Behavior is numbered, testable invariants from the consumer's point of view, and "user" means whoever consumes the surface: people, API callers, CLI users, or code. Sized to the feature: no spec for a trivial fix, about 30–60 lines for a small feature, 80–150 for a medium one.
- **TECH.md:** Context, Proposed changes, and Testing and validation, which maps each numbered behavior to a test. Code references are pinned to a commit SHA.
- **Process:** GitHub labels gate the work: `ready-to-spec`, then `ready-to-implement`. Bug fixes skip the spec unless the scope is unclear. Specs and code ship in the same PR and are kept in sync. Oz, Warp's own agent platform, automates triage, spec writing, implementation and review.
- **Skills:** 21 in `.agents/skills/`, plus 29 shared from [warpdotdev/common-skills](https://github.com/warpdotdev/common-skills) (MIT) and pinned in `skills-lock.json`. About a third are conventions for an area or a recurring change, a third are test and verification procedures, and the rest are process and operations.
- **Conventions:** rules for every change in AGENTS.md, including comment rules: why, never what; describe the code as it is; explain each thing once. Rules for one area or one kind of change are skills.
- **Framework:** its own. No `.specify/`, `.kiro/`, `openspec/`, or BMAD files.

**Lessons**

- Size the process to the change. *(Adopted: Rigor Levels in development.md.)*
- Conventions as skills, by area and by recurring change. *(Adopted: convention skills.)*
- Validate the code against the spec before calling it done, deciding per mismatch whether to fix the code or the spec. *(Adopted: step 5 validation.)*
- Map each test to the spec rules it proves. *(Adopted: "Spec rules proved" in the design templates.)*
- An edge-case checklist for specs. *(Adopted: hb-spec step 3.)*
- Comment rules, and running only the checks a change touches. *(Adopted: conventions template, TESTING.md validation order.)*
- A spec sized to the change, and a broad meaning of "users". *(Adopted: hb-spec.)*
- `-local` skills specialize a core skill only at extension points the core declares. An alternative to hb-update's merging; not adopted yet.
- `scan-new-specs` was retired for documenting specs that never shipped. Lasting docs have to come from what was built, as Hashbang's close already requires.
- Skills archived for reference in `library/`.

### open-design

[nexu-io/open-design](https://github.com/nexu-io/open-design), 104k stars. A local-first AI design workspace.

- **Specs:** `specs/current/`, the system as it is now, and `specs/change/YYYYMMDD-slug/`, a `spec.md` plus notes for each phase. Also `docs/plans/`, `docs/design/`, and Superpowers-style `docs/superpowers/`.
- **Decisions:** `docs/adr/0001-*.md`.
- **Context:** a root `CONTEXT.md` that "records domain language only, not implementation details." Nested AGENTS.md per app. Old baseline docs are marked "explicitly archived; do not treat their dated decisions as current behavior."

**Lessons**

- Separating current truth from change deltas, as OpenSpec does, without the tooling.
- A domain glossary at the root, like Hashbang's CONTEXT.md.

### deer-flow

[bytedance/deer-flow](https://github.com/bytedance/deer-flow), 84k stars. An agent harness.

- **Specs and plans:** `docs/superpowers/specs/YYYY-MM-DD-*-design.md`, `docs/superpowers/plans/`, and `docs/plans/` with RFCs and implementation plans. All kept.
- **Tasks:** checkbox steps inside each plan.
- **Conventions:** AGENTS.md in about 15 folders, and `backend/docs/ARCHITECTURE.md`.

**Lessons**

- Superpowers' layout spreads to projects that install it.
- Conventions next to the code they govern.

### opencode

[anomalyco/opencode](https://github.com/anomalyco/opencode), formerly sst/opencode, 222k stars. A coding agent.

- **Specs:** `specs/v2/`, whose README sorts each document as a current contract, a decision record, or historical context, and names which package owns each concern.
- **Tasks:** none in the repo. "GitHub issues own active work; Git history preserves removed plans and scratchpads." The README forbids implementation checklists.

**Lessons**

- The closest match to Hashbang's planning docs as scaffolding, except that opencode deletes them and relies on git, where Hashbang archives them in `docs/work-archive/`.
- An index that states each document's job keeps current and historical docs apart.

### get-shit-done

[gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done), 64k stars. A spec-driven framework, used on itself.

- **Specs:** `docs/prd/<issue#>-slug.md` holds the what and why. ADRs hold the how.
- **Decisions:** `docs/adr/<issue#>-slug.md`, append-only, amended with dated sections, with a status index.
- **Context:** a root `CONTEXT.md` and `docs/ARCHITECTURE.md`.

**Lessons**

- Local sequential IDs collide across branches: `0010-*` exists twice and `0011-*` three times, so they switched to GitHub issue numbers. Hashbang's T-NNN and D-NNN have the same risk with parallel branches or agents.

### Strands Agents

[strands-agents/harness-sdk](https://github.com/strands-agents/harness-sdk), formerly sdk-python, 9k stars. An agent SDK.

- **Designs:** `team/designs/NNNN-feature.md`. An accepted design becomes part of the decision history.
- **Decisions:** one `team/DECISIONS.md`, like Hashbang's.
- **Process:** `team/TENETS.md`, `FEATURE_LIFECYCLE.md`, `COMPLEXITY.md`, `API_BAR_RAISING.md`. "Skip the design process for bug fixes, small improvements, documentation updates."

**Lessons**

- A single decision log works at this size.
- Process and tenets written down as team docs, as Hashbang's development.md and CONTEXT.md do.

### OpenSpec

[Fission-AI/OpenSpec](https://github.com/Fission-AI/OpenSpec), 73k stars. A spec framework, used on itself.

- **Specs:** `openspec/specs/<capability>/spec.md` is the current truth, 36 capabilities.
- **Changes:** `openspec/changes/<id>/` holds `proposal.md`, `tasks.md`, an optional `design.md`, and spec deltas.
- **After shipping:** the deltas merge into `specs/`, and the change moves to `changes/archive/YYYY-MM-DD-<id>/`, 85 so far.

**Lessons**

- The cleanest separation of current truth and history among the ten, at the cost of writing every change as a delta.

### Task Master

[eyaltoledano/claude-task-master](https://github.com/eyaltoledano/claude-task-master), 28k stars. A task framework, used on itself.

- **Tasks:** `.taskmaster/tasks/tasks.json`, one task graph with dependencies, generated from `.taskmaster/docs/prd.txt`. Research notes in `docs/research/`.
- **Context:** CLAUDE.md and `.kiro/steering/`.

**Lessons**

- The only one of the ten that keeps the full task list in the repo, as Hashbang does.

### ruflo

[ruvnet/ruflo](https://github.com/ruvnet/ruflo), 80k stars. Agent orchestration.

- **Decisions:** more than 380 `ADR-NNN-*.md` files across `v3/docs/adr/`, `v3/implementation/adrs/`, and each plugin's `docs/adrs/`, with README indexes.
- **Specs:** `v3/docs/spec/` with schemas and conformance tests.

**Lessons**

- One file per decision without curation becomes hundreds of files in several places.

### Superpowers

[obra/superpowers](https://github.com/obra/superpowers), 306k stars. A skills framework.

- **Specs:** the brainstorming skill writes `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`, committed.
- **Plans:** the writing-plans skill writes `docs/superpowers/plans/YYYY-MM-DD-<feature>.md`, with checkbox steps that end in a commit.

**Lessons**

- A framework's default paths become the field's layout: deer-flow, open-design and get-shit-done all use this one.

## Patterns

1. **Product and tech are separate documents.** PRODUCT and TECH, proposal and design, PRD and ADR. *(Hashbang: spec.md and design.md.)*
2. **Folders are named by tracker ID** when a tracker exists, or by date or slug when not.
3. **Active work lives in GitHub issues** or in checkboxes inside each plan. Only Task Master keeps a task list in the repo.
4. **Decisions are one log or one file each.** One log at Strands' size; one file each scales badly without an index.
5. **Conventions live next to the code,** in nested AGENTS.md files or skills. None of the ten has a central CONVENTIONS.md.
6. **A root glossary is emerging:** open-design and get-shit-done both have `CONTEXT.md`.
7. **Small changes skip the process.** Warp and Strands both say so in their contribution rules.
8. **Most keep everything.** Only OpenSpec, open-design and opencode separate what is true now from what was planned.

## Open ideas for Hashbang

- **ID collisions.** Allow a tracker issue number in place of a local T-NNN or D-NNN when the project has one (get-shit-done).
- **Delete instead of archive.** Drop `docs/work-archive/` and rely on git history, moving close.md's table into the closing commit message. Projects without git would still need the archive (opencode).
- **Core skills with declared extension points,** specialized by thin project skills, instead of merging customized copies (Warp's `-local` skills).
- **A friction log** hb-retro reads, after Warp's `suggestion-box`. In TODO.md.
- **Grading skills from transcripts,** after Warp's `skill-doctor`, to see which hb- skills agents actually follow. Archived in `library/warp-common-skills/`.

## The other 27

Scanned, with no spec layout beyond AGENTS.md or CLAUDE.md files and contributing guides:

- **Coding agents and IDE tools:** openai/codex, google-gemini/gemini-cli, Aider-AI/aider, cline/cline, RooCodeInc/Roo-Code, continuedev/continue, block/goose, All-Hands-AI/OpenHands.
- **Agent frameworks and SDKs:** microsoft/autogen, browser-use/browser-use, mastra-ai/mastra, vercel/ai, awslabs/mcp.
- **Apps and platforms:** langgenius/dify, lobehub/lobe-chat, open-webui/open-webui, supabase/supabase, unclecode/crawl4ai, cheaper-inference/OmniRoute, storytold/photocraft, tt-a1i/archify.
- **Spec and skills frameworks:** github/spec-kit, bmad-code-org/BMAD-METHOD, buildermethods/agent-os, addyosmani/agent-skills.

Near misses: photocraft has `docs/decisions.md` and `docs/architecture.md`, archify a small `docs/specs/`, and vercel/ai `contributing/decisions/`. Spec Kit and BMAD barely use their own layouts: Spec Kit has a `design/` folder, and BMAD a `docs/plan/`.

## Sources

- [warpdotdev/warp](https://github.com/warpdotdev/warp): [CONTRIBUTING.md](https://github.com/warpdotdev/warp/blob/HEAD/CONTRIBUTING.md), [AGENTS.md](https://github.com/warpdotdev/warp/blob/HEAD/AGENTS.md)
- [warpdotdev/common-skills](https://github.com/warpdotdev/common-skills)
- [nexu-io/open-design](https://github.com/nexu-io/open-design)
- [bytedance/deer-flow](https://github.com/bytedance/deer-flow)
- [anomalyco/opencode](https://github.com/anomalyco/opencode): [specs/v2/README.md](https://github.com/anomalyco/opencode/blob/HEAD/specs/v2/README.md)
- [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done): [docs/adr/README.md](https://github.com/gsd-build/get-shit-done/blob/HEAD/docs/adr/README.md)
- [strands-agents/harness-sdk](https://github.com/strands-agents/harness-sdk): [team/designs/README.md](https://github.com/strands-agents/harness-sdk/blob/HEAD/team/designs/README.md)
- [Fission-AI/OpenSpec](https://github.com/Fission-AI/OpenSpec)
- [eyaltoledano/claude-task-master](https://github.com/eyaltoledano/claude-task-master)
- [ruvnet/ruflo](https://github.com/ruvnet/ruflo)
- [obra/superpowers](https://github.com/obra/superpowers)

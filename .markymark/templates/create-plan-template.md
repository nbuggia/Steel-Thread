---
name: feature name tech design
description: feature description.
date: YYYY-MM-DDDD
review iteration: [N]
status: [In Progress / Ready for Review / Ready for Implementation / Complete]
---

# Tech Design: Feature Name


## 1. Context

State what's broken, missing, or newly required, and why this is being addressed now. One paragraph. If there's no clear problem being solved, say so explicitly — don't manufacture urgency.

---

## 2. Goals / Non-Goals

List goals as testable outcomes, not activities ("editor supports live preview with <50ms input-to-render latency," not "improve the editor"). Non-goals are mandatory — list at least two things this design explicitly will not address, and why they're out of scope. A design with no non-goals has not been scoped.

---

## 3. Open Questions

List unresolved issues explicitly. A design doc with no open questions is more likely hiding uncertainty than lacking it — do not suppress this section to look complete.

---

## 4. Requirements

- Bulleted list of the relevant specs, with a link to each one

### Spec Review

Read every canonical spec the plan touches before completing this section. For each spec, list the relevant claims and whether this plan changes them:

| Spec                      | Relevant claims (quote directly from source)           | This plan changes this?   |
| ------------------------- | ------------------------------------------------------ | ------------------------- |
| (e.g. Architecture.md §5) | "terminal runs inside the RightPanel via portable-pty" | No                        |
| (e.g. reliability.md)     | "files &gt;10 MB open in Raw mode only; no hard cap"   | Yes → \[state new claim\] |

Rules:

- Claims must be **quoted directly** from the source file — paraphrasing is not acceptable proof of reading
- Specs reviewed but with no relevant claims must still be listed as "Reviewed — no relevant claims"
- Omitting this section entirely is not acceptable; it is the primary mechanism for keeping specs current
- At minimum, always include `Architecture.md` and any feature spec the plan touches

---

## 5. Proposed Design

Cover both sides of the IPC boundary explicitly — do not describe the Rust backend and React frontend as if they were separate features:

- **Rust backend**: modules/structs touched or added, ownership of state (`tauri::State`, `Mutex`/`RwLock` usage and why), any new async tasks or background threads.
- **Frontend**: components touched or added, state management approach (local component state vs. a store), what triggers re-renders.
- **IPC contract** (required — see §5).
- **Data flow**: trace one concrete user action end-to-end — UI event → `invoke()` call → Rust command → state/disk mutation → response or emitted event → UI update. If the flow can fail at any hop, say what happens.

Include a diagram (even ASCII) if more than 3 components are involved.

For every newly introduced state variable:

| State | Owner | Lifetime | Persistence Required? | Why This Owner? |
| ----- | ----- | -------- | --------------------- | --------------- |

---

## 5. Command & Event Contract

This is Markymark's equivalent of an API contract — treat it with the same rigor. For each new or changed Tauri command:

| Command | Args (serde types) | Return type | Error variants | Async? |
|---|---|---|---|---|

For each event emitted/listened to: event name, payload shape, emitter, listener(s), and ordering/delivery guarantees (can it be missed if no listener is attached yet?).

State explicitly whether frontend TypeScript types are hand-mirrored from Rust structs or generated (e.g. via `specta`/`ts-rs`) — hand-mirrored types are a drift risk worth flagging even if accepted.

---

## 6. Data Model & Persistence

- Storage mechanism (SQLite, flat files, `tauri-plugin-store`, in-memory only) and why.
- Schema or file format, including version field if the on-disk format can change across app versions.
- Migration plan: what happens when a user with data written by an older app version opens a newer one? This is mandatory for any on-disk format change — Markymark cannot assume a clean install.

---

## 7. Capabilities & Security

Tauri 2's permission system means this is not optional boilerplate:

- Which capabilities/permissions does this feature require (filesystem scope, shell, dialog, updater, etc.)?
- Is the requested scope the *minimum* needed, or broader for convenience? Justify anything broader than strictly required.
- CSP implications if the feature touches remote content or `dangerouslySetInnerHTML`-style rendering (relevant for markdown rendering/preview).
- Any new attack surface (e.g., rendering untrusted markdown/HTML, executing shell commands, opening arbitrary file paths).

---

## 8. Cross-Platform Considerations

WebKit (macOS/Linux) vs WebView2 (Windows) can diverge on CSS, clipboard, file dialogs, and keyboard shortcuts. Note any behavior in this design known or suspected to differ by platform, and how it'll be verified (manual test matrix, CI runners, etc.).

---

## 9. Alternatives Considered

At least two real alternatives, each with genuine trade-offs — not strawmen. For Tauri-specific decisions, this often includes: doing it in the frontend vs. moving logic to Rust (and why that boundary was drawn where it was), or using an existing plugin vs. hand-rolling.

---

## 10. Testing Strategy

- Rust: unit tests for command logic (`cargo test`), especially error paths.
- Frontend: component/behavior tests, with `invoke` mocked — specify what the mock returns for success and failure cases.
- Integration: how is the actual IPC boundary tested, if at all (this is the layer most bugs will hide in).

For every command:
- Success path
- AlreadyExists
- NotFound
- PermissionDenied
- PathTraversal
- UnexpectedFailure

- Manual verification steps

For every test category include:

| Test | Regression Prevented |
| ---- | -------------------- |

---

## 11. Rollout & Migration

- Is this gated behind a flag/setting, or shipped directly?
- Interaction with `tauri-plugin-updater`: does the update path need special handling (e.g., data migration must complete before the new UI can assume new schema)?
- Rollback: if this ships broken, what's the recovery path for a user who already has a signed, installed build? (Unlike a web app, you cannot silently redeploy — treat this as effectively one-way unless a fast follow-up update is guaranteed.)
- Code signing / notarization impact, if packaging changes.

---

## 12. Reviewer Feedback

Record a list of feedback from the review and the outcome of the feedback

1. Reconcile each item against CLAUDE.md and architecture.md
2. Flag conflicts between sources or with design principals for user adjudication
3. For each feedback item, explicitly asks: "Does accepting this change any claim listed in the Phase 1 Spec Review?" Items that do are marked Yes in the `ARCH?` column in the table, with the affected spec and claim noted.

| \#  |  Feedback Summary | Decision | Rationale    | Next Step               | Arch?    |
| --- | ----------------- | -------- | ------------ | ----------------------- | -------- |
| 1   | Issue description | ACCEPT / REJECT / DEFER | One sentence | Details | Yes / — |

5. Waits for user to confirm, override, or adjudicate conflicts
6. Updates design and appends confirmed table to design-review-log.md
7. Produces updated Phase 1 review package reflecting all ACCEPTed items

**Decision definitions:**

- ACCEPT — incorporated into updated design
- REJECT — excluded with rationale logged
- DEFER — valid but out of scope; logged as open question
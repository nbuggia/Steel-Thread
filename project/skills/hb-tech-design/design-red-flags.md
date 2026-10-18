# Design Red Flags

Screen the proposed design (§6) and every alternative (§11) against this list before marking a design `In Review`. A red flag is a reason to revise the shape — not an automatic rejection. Some are justified; if one survives, record why in the design's rationale rather than silently dropping it.

## Shallow module

A shallow module exposes a large interface while hiding little behavior behind it. Judge depth by how much capability or policy sits behind the public surface relative to the size of that surface. A deep call chain (many layers) is not the same defect as a shallow module (thin behavior) — a deep module can still have a long call chain underneath it, as long as the caller never has to see it.

Signs:

- A caller has to invoke several Tauri commands in a specific order to complete one logical operation, instead of one command that owns the sequencing.
- A command's parameters expose an internal implementation choice the caller shouldn't have to know about (`save_file(path, use_atomic_write: bool)` — atomic-write is a strategy the command should just pick, not a knob the caller sets).
- Reading a `commands.ts` function's signature doesn't save the caller from also reading the Rust handler to know how to call it safely.

Example: if pasting an image requires the React component to call `resolve_relative`, then `save_asset`, then `update_document_links`, in that exact order, that's a shallow module. Collapse it into one command that owns the whole operation and returns the result.

## Information leakage

Multiple places depend on the same internal decision, so changing that decision means editing all of them in lockstep.

Watch for:

- A **wire path** (vault-relative string) appearing anywhere outside `src/lib/commands.ts` — in a React component, a Zustand slice, or editor state. This is exactly what CLAUDE.md's Three Path Spaces rule forbids; if you see one, it's leakage, not just a style violation.
- A Rust struct's internal field shape driving a `match` in more than one command handler. If the struct changes shape, every one of those match arms has to change with it.
- A `bindings.ts` (specta-generated) type being reshaped, narrowed, or partially hand-copied inside a component instead of imported as-is.

## Temporal decomposition

Modules organized by _when_ code runs (load → validate → transform → save) instead of _what they know_, so the same invariant gets re-checked or re-encoded at every stage.

Example: a "load document" path and a "restore after webview reload" path that each re-implement their own frontmatter-parsing logic are one module in disguise — the thing that owns frontmatter parsing — not two pipeline stages that happen to both need it. Give ownership of that invariant one home and call it from both places.

## Pass-through method

A function or command that forwards the same arguments to another function with the same shape, adding a layer without adding behavior.

Every `commands.ts` wrapper does this by design — that's the required IPC boundary (CLAUDE.md rule 2), not a red flag. The red flag is a _second_ layer with no new policy: a Rust command that only calls another Rust command with the same args, or a `commands.ts` function that adds no error mapping, no path translation (see Three Path Spaces), and no logging beyond the `invoke()` call it wraps. Merge it into the layer that actually does something.

## Interface depth (tie-breaker for §11 alternatives)

When two real alternatives are otherwise comparable, prefer the one that hides more complexity behind a smaller, simpler public surface — not the one with the shorter call chain. One Tauri command with a richer internal implementation beats three thin commands the frontend has to orchestrate itself; the frontend orchestration is exactly the shallow-module pattern above, spread across a call site instead of a module.

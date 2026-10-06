---
title: Here is some content
---

# Here is some Text Edit content

Another paragraph

the native OS menu (AppShell.tsx + src-tauri/src/menu.rs) each independently decide whether a Format/Insert action is currently valid, and they've already drifted twice: the toolbar correctly disables Table/Horizontal Rule/Lists inside a table cell (isInTable, now shared via src/lib/wysiwygEditorState.ts) while the native menu didn't until a recent fix, and the toolbar also disables entirely while focus is inside the frontmatter block (frontmatterFocused, DOM-focus-tracked in FormattingToolbar.tsx) — a guard the native menu still doesn't replicate. Beyond that specific gap, the native menu's enabled/disabled appearance only updates on document/mode changes, not on live cursor movement, so it can visually claim an action is available when clicking would just no-op. Needs a proper design (not another one-off patch) for pushing/sharing validity state between the two surfaces, including whether live selection-state needs to reach Rust for real-time menu greying and what that costs perf-wise on every selection change. Related but separate from the keyboard-shortcut-dispatch-table follow-up (that's about who fires an action; this is about whether it's currently valid).

## Hi, I'm a heading

the native OS menu (AppShell.tsx + src-tauri/src/menu.rs) each independently decide whether a Format/Insert action is currently valid, and they've already drifted twice: the toolbar correctly disables Table/Horizontal Rule/Lists inside a table cell (isInTable, now shared via src/lib/wysiwygEditorState.ts) while the native menu didn't until a recent fix, and the toolbar also disables entirely while focus is inside the frontmatter block (frontmatterFocused, DOM-focus-tracked in FormattingToolbar.tsx) — a guard the native menu still doesn't replicate. Beyond that specific gap, the native menu's enabled/disabled appearance only updates on document/mode changes, not on live cursor movement, so it can visually claim an action is available when clicking would just no-op. Needs a proper design (not another one-off patch) for pushing/sharing validity state between the two surfaces, including whether live selection-state needs to reach Rust for real-time menu greying and what that costs perf-wise on every selection change. Related but separate from the keyboard-shortcut-dispatch-table follow-up (that's about who fires an action; this is about whether it's currently valid).

| Table | Table | Table | Table |
| --- | --- | --- | --- |
| Ho | Bo | No | Go |
| Ho | Bo | No | Bg |
| 33 | B3 | N3 | B3 |

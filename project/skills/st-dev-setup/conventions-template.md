# Conventions

\[The patterns a change here follows, and why. Format and rules: `.steel-thread/framework/files/conventions.md`. New patterns are agreed with the customer first: discuss, add here, then implement. Leave out any section with nothing in it.\]

## Changelog

| Date | Change |
| --- | --- |
| \[YYYY-MM-DD\] | \[Initial conventions: Tauri commands, path checks, IME guard.\] |

## \[Pattern or area, such as IME Composition Guard\]

**\[The rule, as an instruction: every `Enter` key handler checks `isComposing` and drops the event if true.\]**

\[Why, in a sentence or two: during IME composition, Enter confirms a character, not a submit.\]

\[Where it applies: every component that handles Enter, including inline rename inputs.\]

\[A short example written for the rule, when it's about the shape of code: only the lines the rule is about, with generic names. Never copied from the project.\]

```typescript
if (e.key === "Enter") {
  if (e.nativeEvent.isComposing) return; // Enter confirms a character during IME composition
  submit();
}
```

\[Optionally, a file that follows it: "for example, `FilterList.tsx`".\]

\[A narrow exception, if any: what it covers exactly, and why it's needed.\]

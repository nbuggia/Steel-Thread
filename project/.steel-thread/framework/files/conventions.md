# docs/engineering/CONVENTIONS.md — Format and Rules

CONVENTIONS.md holds the patterns a change in this project follows, and why. The customer agrees to every pattern before code uses it, so this file is how they see and steer how the code is built. st-dev-setup writes the first version from its `conventions-template.md`.

## Format

- **Changelog** at the top: one dated line per change, newest first, naming the section it touched.
- **One section per pattern or area:** the rule in bold, why it exists, where it applies, and a short example when the rule is about the shape of code. A narrow exception goes in its rule's section, with why it's needed and exactly what it covers.

## Rules

- **Agree first.** A new pattern, a change to a rule, or an exception is agreed with the customer before code uses it. A new pattern is something like a new library, a new place for state, a new way to handle errors, or a new way across a boundary. Explain it the way someone who hasn't seen it needs: what it is, why, and what you'd do instead. Then add it here with a changelog line, then implement. In a design, ask as soon as the design needs it, in the same message as any other question the design has.
- **Write examples for the rule; don't copy the project's code.** An example holds only the lines the rule is about, with generic names, showing the right shape and, where it helps, the wrong one. It stays true as long as the rule does. Copied code, such as a file tree, an interface field by field, or a whole function, describes the code rather than the rule: it goes stale with every edit, and the next change copies the stale version. The code's current shape belongs in ARCHITECTURE.md or in the code itself.
- **Naming real code is optional:** "for example, `FilterList.tsx`". It's a lead, not a promise, so it can drift without making the rule wrong.
- **When code breaks a rule, the rule stands.** Don't copy that code. Fix it in this change if it's in scope, or propose a task with the st-tasks skill. If you think the rule itself is wrong, that's a change to a rule: agree it first.
- **Correcting a fact isn't a change to a rule.** A stale name, a field that no longer exists, or a pointer to moved code can be fixed without approval. Add a changelog line, and mention it to the customer.
- **A reason too long for its section** goes in DECISIONS.md, when it meets the bar there, and the rule cites it: "(D-003)".
- **The steps of a recurring change,** such as adding a command or a setting, go in a convention skill; the rules those steps rely on stay here.

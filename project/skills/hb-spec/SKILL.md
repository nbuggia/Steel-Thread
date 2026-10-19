---
name: hb-spec
description: Shape an idea into a feature spec that says what the product does and why, never how. Sharpens the idea to its core value, organizes use cases into the current release or backlog, splits a growing idea into several specs, and recommends a prototype when one would clarify it. Use when the customer wants to spec a feature, write requirements, plan what goes in a release, or change how a feature behaves.
based-on: Matt Pocock, to-spec (https://github.com/mattpocock/skills); GitHub Spec Kit, spec-template (https://github.com/github/spec-kit); Kiro, feature and bugfix specs (https://kiro.dev/docs/specs/)
---

A spec describes how one feature of the product behaves for its users, and why. It lasts: many tasks change it over the project's life. The format and most of the guidance are in `spec-template.md`; follow it closely. This is step 1 of `.hashbang/framework/development.md`.

In this skill, **users** are the people the feature is built for. The **customer** is the person you are working with.

## Step 1 — Find the spec

Specs live in `docs/specs/<area>/<feature>.md`, unless the project already keeps them elsewhere. Read CONTEXT.md, the Active decisions that touch the feature, and the specs next to it.

- **No spec yet:** go to step 2.
- **The spec exists:** update it; never start a second spec for the same feature. First check any touched rules from shipped releases against the product. Fix drift with its own Change History line.
- **A small change** leaves the core value, users, and releases as they are, such as a bug fix's rule or a changed limit. Go straight to step 3. In step 4, recommend hb-crit only if a current-release use case changed.

## Step 2 — Shape the idea

Work from what the customer, the conversation, and the project have already told you, and settle what you can yourself. A gap only the customer can fill, such as who the users are or what the feature is for, is critical input (see `.hashbang/framework/development.md`): collect those gaps and resolve them together in one hb-elevate session, never one question at a time. Settle these, in this order:

1. **Core value:** who the users are, and the one thing the feature must do for them to be worth building.
2. **Use cases:** give each a stable `UC-NNN` number and put it in the current release or the backlog. Do not prioritize or organize the backlog.
3. **Current release:** give it a short purpose name. For a new feature, choose the smallest complete set of use cases that delivers the core value for real. For a later release, pull only the related backlog items, add what that purpose is missing, and leave the rest alone.

Then challenge the current release. Does the first release deliver the core value, or only demo it? Does a later release fulfill its stated purpose? Could anything wait, and is anything required missing? Write its rules once it holds up. Moving a use case the customer asked for out of the current release is a high-judgment decision; ask before you do it. Backlog items may stay rough and do not block approval.

While shaping, watch for two things:

- **The idea has become several specs.** Keep the split check short:
  - Split when a group of use cases and rules can be understood, changed, and tested independently; never split only because it belongs to another release or platform.
  - Choose the boundaries, and tell the customer what you split and why.
  - Move each use case with its rules, preserve their numbers, and give each one exactly one owning spec.
  - Link related specs, update their task and change history, and list their ownership in `<area>/README.md`.
- **A prototype would answer it faster.** Apply the prototype criteria in `.hashbang/framework/development.md`, step 2. If they call for one, write a Draft spec with what is settled, put the prototype's questions under Open Questions, and propose a task for the prototype. Pick the spec back up when it is answered.

## Step 3 — Write it

Fill in the template, leaving out optional sections with nothing in them. Then check:

- **No implementation:** no code identifiers, internal file paths, components, libraries, or test plans. External contracts are behavior and belong in the spec, such as URLs, file formats, keyboard shortcuts, and commands users type. For the ones other systems rely on, such as file formats and APIs, ARCHITECTURE.md names the component that implements each and links to the spec.
- **Release placement:** each use case appears in exactly one release or the backlog. Each release has its own use-case table, a short purpose name, and a completion date. At most one release may have no completion date; if present, that is the current release.
- **No schedule in the rules:** a group of rules may carry the current release's number on its heading until that release is completed.
- **One owner:** no rule restates a rule another spec owns; link to it instead.
- **Stable numbers:** existing use-case and rule numbers are unchanged, including when they move between the backlog and a release or between specs. Change History has a line for this task.
- **Vocabulary:** terms match CONTEXT.md; propose any new term.

## Step 4 — Review and approve

Run an hb-crit review unless step 1 classified this as a small change that does not alter the current release; then go straight to approval. For the review, give the critic the draft, its Related Specs, and the Active decisions that touch it. The critic is a user of the feature, joined by a product lead who has watched specs like this fail. They attack the first release's core value or a later release's purpose, its size, and any rule that is ambiguous, untestable, or missing for a current-release use case. They do not organize the backlog.

Revise the spec for each finding, or record it as an accepted risk. A finding becomes a `[NEEDS DECISION]` marker only when it is a choice the customer has to make, not a reviewer's preference.

A current release with open markers stays Draft and is blocked on them; ask the customer to resolve them together. Rough backlog items do not block approval. Otherwise, set the spec to Approved and tell the customer in a few lines: the Summary, the current release, and what the review changed. Propose a DECISIONS.md entry for each rule that applies to the whole product rather than this feature, such as who the product is not for, the accessibility level, or how long data is kept; rules for this feature stay in the spec. Then, with the hb-tasks skill, a phase for the current release if it has none. Then start the next step: the prototype if one is pending, otherwise the tech design for the current release.

---
name: hb-spec
description: Shape an idea into a feature spec that says what the product does and why, never how. Sharpens the idea to its core value, ranks the use cases into releases, splits a growing idea into several specs, and recommends a prototype when one would clarify it. Use when the customer wants to spec a feature, write requirements, plan what goes in a release, or change how a feature behaves.
based-on: Matt Pocock, to-spec (https://github.com/mattpocock/skills); GitHub Spec Kit, spec-template (https://github.com/github/spec-kit); Kiro, feature and bugfix specs (https://kiro.dev/docs/specs/)
---

A spec describes how one feature of the product behaves for its users, and why. It lasts: many tasks change it over the project's life. The format and most of the guidance are in `spec-template.md`; follow it closely. This is step 1 of `.hashbang/framework/development.md`.

In this skill, **users** are the people the feature is built for. The **customer** is the person you are working with.

The hb-elevate interview (step 2) and the hb-crit review (step 4) are optional. Recommend them for a new spec or a large change, and say what each would add. The customer can skip either one at any time, and a small change can leave out both.

## Step 1 — Find the spec

Specs live in `docs/specs/<area>/<feature>.md`, unless the project already keeps them elsewhere. Read CONTEXT.md, the Active decisions that touch the feature, and the specs next to it.

- **No spec yet:** go to step 2.
- **The spec exists:** update it; never start a second spec for the same feature. If it is Current, first check the rules this change touches against the product. Fix any drift you find, with its own Change History line.
- **A small change** leaves the core value, users, and releases as they are, such as a bug fix's rule or a changed limit. Go straight to step 3. Offer the hb-crit review only if the rules of a P1 use case changed.

## Step 2 — Shape the idea

Recommend an hb-elevate session that first clarifies, then challenges. If the customer skips it, work from what they have told you and turn the gaps into `[NEEDS DECISION]` markers. Either way, settle these, in this order, without re-asking anything the conversation already answered:

1. **Core value:** who the users are, and the one thing the feature must do for them to be worth building.
2. **Use cases,** ranked. Any that don't serve the core value move to Not Doing or a later release.
3. **Release 1:** the smallest set of use cases that delivers the core value for real.

Then state the plan back and challenge it. Does Release 1 deliver the core value, or only demo it? Could anything in it wait? Would users really miss the top-ranked use case most? Write rules only once the customer agrees with the plan.

While shaping, watch for two things:

- **The idea has become several specs.** Propose a split when groups of use cases share no rules and no users, or when a reader can no longer hold the Summary in their head. Length alone is a reason to consider splitting, not a reason to split. Releases stay inside one spec. An area with several specs gets a routing spec, `<area>/README.md`, that lists which spec owns what.
- **A prototype would answer it faster.** Recommend one for new UI, for a novel feature whose behavior the customer can't yet describe, or for a complex system with more than one plausible design. Offer one for a change to existing UI. If the customer agrees, write a Draft spec with what is settled, put the prototype's questions under Open Questions, and propose a task for the prototype (`development.md` step 2). Pick the spec back up when it is answered.

## Step 3 — Write it

Fill in the template, leaving out optional sections with nothing in them. Then check what the template can't enforce:

- **No implementation:** no code identifiers, internal file paths, components, libraries, or test plans. External contracts are behavior and belong in the spec, such as URLs, file formats, keyboard shortcuts, and commands users type.
- **No schedule in the rules:** releases are mapped to use cases in the Releases table only. A group of rules may carry a `(Release N)` tag on its heading until that release ships.
- **One owner:** no rule restates a rule another spec owns; link to it instead.
- **Stable numbers:** existing rule numbers are unchanged, and Change History has a line for this task.
- **Vocabulary:** terms match CONTEXT.md; propose any new term.

## Step 4 — Review and approve

Recommend an hb-crit review before approval; if the customer skips it, go straight to approval. For the review, give the critic the draft, its Related Specs, and the Active decisions that touch it. The critic is a user of the feature, joined by a product lead who has watched specs like this fail. They attack the core value, the size of Release 1, and any rule that is ambiguous, untestable, or missing for a P1 use case.

Revise the spec for each finding, or record it as an accepted risk. A finding becomes a `[NEEDS DECISION]` marker only when it is a choice the customer has to make, not a reviewer's preference.

Show the customer the Summary, Releases, and Not Doing, plus the verdict and what changed because of it if a review ran. A spec with open markers stays Draft. When the customer approves it, set it to Approved. Propose DECISIONS.md entries for choices that are hard to reverse, and TASKS.md phases for releases that have none. Then offer the next step: the prototype if one is pending, otherwise the tech design for Release 1.

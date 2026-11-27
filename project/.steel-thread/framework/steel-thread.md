# Steel Thread

You are working inside a software project that uses Steel Thread. This file is your operating manual. Read it fully at the start of every session.

## Hard Rules

These never bend. The rest of this manual explains them and covers the judgment calls.

1. **Orient before you respond.** Run the Session Start Protocol before your first reply.
2. **The customer's files change only with their approval:** PRD.md, CONTEXT.md, TASKS.md, BACKLOG.md, DECISIONS.md, and `docs/engineering/CONVENTIONS.md`. Marking progress on a task, and correcting a stale fact in CONVENTIONS.md, are the exceptions.
3. **Change TASKS.md only through the st-tasks skill.** Before you first create or edit PRD.md, CONTEXT.md, BACKLOG.md, DECISIONS.md, CONVENTIONS.md, or customizations.md in a session, read its rules in `.steel-thread/framework/files/`.
4. **Size every code change before you start it.** Read `.steel-thread/framework/development.md`, set the rigor level, and say which criterion decided it.
5. **Never search `docs/work/`.** It is scaffolding. Open an entry only by its path, and never treat a done one as current behavior.
6. **Every Simple and Complex diff gets an st-crit review before the task is done.**
7. **Keep state in the files that own it,** as Where State Lives says. The customer can stop at any moment.
8. **Use CONTEXT.md's vocabulary exactly, and never do what it forbids.**
9. **Don't reopen an Active decision** unless the customer does, or new information undercuts its reasoning — and then say so. Before you propose a choice the project may already have made, check the headings in `docs/DECISIONS.md`.
10. **The framework and the skills are this project's to adapt.** Before changing one, read `.steel-thread/framework/files/customizations.md`. Never edit `.steel-thread/upstream/`.

## Steel Thread Files

The project's memory lives in files; keep them current as you work. The customer's files live in `docs/`, and Steel Thread's own in `.steel-thread/`. `.steel-thread/framework/docs-layout.md` maps every file and what it holds.

All-caps files are the customer's: they read and shape them, and you maintain them with their approval. Lowercase files are working files you maintain on your own.

**The objective** is the sections of `docs/PRD.md` above its first feature. Wherever this manual or a skill says to read the objective, read those.

## Session Start Protocol

Run this silently.

1. **Read docs/CONTEXT.md.** When a tenet settles a question, apply it and name the tenet instead of asking.
2. **Find the work in flight:** the `in progress` tasks in docs/TASKS.md, with their Notes, and `git status` for uncommitted changes. Read nothing else of TASKS.md, and not the git log.
3. **If something is in flight, open with one line about it,** then answer what the customer said: "T-012 is mid-slice 2 — the crop lookup — with uncommitted changes in `src/lookup.rs`. Pick up there?" If nothing is, say nothing about it.

Uncommitted changes belong to the work in flight. Don't mix them into unrelated work or commit them with it; ask first.

When the customer asks what's next or where things stand, or wants to resume without saying where, run the st-whats-next skill. It reads the rest: the plan, the recent history, and what to do next.

## Where State Lives

The customer can close the terminal at any moment, so keep the project's state in the files that own it, as you work: TASKS.md, DECISIONS.md, the work entry, and git. There is no separate session note.

- **Before a stop or a long step,** make sure the task in progress names its very next step in Notes, and commit finished work and Steel Thread's files (Commits in development.md).
- **Write anything a returning session needs into the document it belongs to:** the spec, the design, or a task's Notes. If it fits none of them, it probably doesn't need keeping.

## Keeping the Customer's Files

- **Propose as things happen, not as a wrap-up ritual,** so approval is one tap: "We just decided X — want me to log it so it's remembered next session?"
- **Respect their edits.** They can edit any of these files directly; treat what they wrote as current.
- **Guard the objective.** If work drifts from it, ask whether the objective is changing or this is a detour.
- **When in doubt about priority, ask.** The customer's judgment is the final word.

**Vocabulary.** Correct your own slips inline. When the customer uses a non-canonical term, confirm it gently: "Just to confirm — by 'the folder' you mean the vault?" If they keep using it, propose changing the vocabulary: the goal is the right terms, not the first ones.

## Skills

Skills load on demand, and their names and descriptions are already in your context. The customer only needs to know **st-whats-next**, the entry point for every project; task, decision, and context upkeep happen in the background, so the system feels like it just works. `development.md` names the skill for each development step.

Suggest a skill naturally when the moment calls for one — "This is a good moment for an st-crit — want me to run one?" — rather than telling the customer to invoke it.

# Prior Art: Evaluating Spec-Driven Frameworks

How spec-driven and agent-process frameworks evaluate whether they work, and what Steel Thread can learn for its own eval harness. Researched 2026-10-29 from web search and each source's docs. The superpowers harness details come from its testing docs, which describe it two slightly different ways; the exact checks its post-run scripts make weren't confirmed.

## Summary

Mostly they don't. A 2026 survey found that most of these frameworks have never been independently evaluated, and names the lack of benchmarks for the full spec-to-code process as a recurring gap. Spec Kit calls itself "an experiment designed to test how well the methodologies… actually work", but publishes no results.

- **Closest to what Steel Thread needs:** superpowers, which drives real agent CLIs through scenarios and grades the results.
- **Best outcome data:** Uvik's 50-ticket benchmark, run by Uvik itself. Specs helped on features, and often didn't pay for themselves on small changes.
- **Most common complaint:** ceremony on small changes.

## Approaches

### Self-check steps in the workflow

Spec Kit asks the agent targeted questions about its own plan, such as logical flaws or unclear requirements. Like st-crit, it improves the documents but says nothing about whether the framework works.

### Behavior evals that drive real agents (superpowers)

- `evals/scenarios/<name>/`, run by a harness that drives real Claude Code, Codex and Gemini CLI sessions.
- Graded against each scenario's acceptance criteria, plus scripted checks after the run.
- Scenarios take 3–30+ minutes each, so only static checks (structure, frontmatter, word budgets) run in CI. Live runs are on demand or nightly.
- Writing a skill is test-driven. Run the scenario without the skill to see the natural failure. Add pressure scenarios that tempt the agent to break the rule, such as "production is down, $5k a minute". Then close each loophole the agent found.

### Head-to-head outcome benchmarks (Uvik)

- The same 50 production Python tickets through Spec Kit, Kiro, BMAD, OpenSpec, and a no-spec control. All runs used the same model, and senior engineers reviewed the results without knowing which framework produced them.
- Measured tickets merged, defects found in review, and time spent on the spec. OpenSpec merged 42, Kiro 41, Spec Kit 40, and the control 36.
- The median spec phase ran from 12 minutes (OpenSpec) to 28 minutes (BMAD).
- Specs helped on features, but often didn't pay for themselves on bug fixes, refactors and test-writing.

### Anecdotal practitioner reviews

These mostly measure the cost of the process:

- BMAD's full pipeline took 5.5 hours for a dashboard that OpenSpec did in 12 minutes. This is cited second-hand and not traced to a primary report.
- Kiro turned one small bug into four user stories with 16 acceptance criteria.
- One tester was about 10× faster with plain iterative prompting than with Spec Kit.

### Specs that compile into evals (proposal)

gptme proposes parsing Given/When/Then scenarios from a spec straight into evals, then having the agent fix code until they pass. The parser exists; generating eval cases from it doesn't yet.

### Metrics the survey recommends

- **Process:** spec completeness, consistency between artifacts, rate of human review needed, corrections per phase, how stable decisions stay, and audit-trail quality.
- **Grounding:** coverage of the relevant files, citing internal sources, no invented APIs, and following architectural decisions.
- **Living artifacts:** drift between specs, plans, tasks, tests and code.
- **Long-term studies** on real teams: productivity, defects, review quality, token cost.

## Lessons for Steel Thread

- An eval harness would put Steel Thread ahead of most of the field. Model it on superpowers: one scenario per folder, real agent CLIs, scripted checks first, and model grading only for the conversation.
- Run a no-Steel Thread baseline. Without one, there's no evidence the framework beats a bare agent.
- Add pressure scenarios for the hard rules: "just ship it, skip the review", or "quickly fix this" on a change that is actually Complex.
- Measure time and tokens per rigor level, not only pass rates. Ceremony on small changes is the field's most common failure.
- Several of the survey's metrics can be checked by script in Steel Thread: the close's trace check for drift, and whether the agent re-proposes something a D-NNN entry rejected.

## Proposed harness

A starting design, from the 2026-10-29 review. Scenarios check what a run leaves in the project (files and commits), because Steel Thread's behavior spans sessions.

```
evals/
  fixtures/tiny-cli/       ← a small real project, about 200 lines plus tests
  scenarios/NN-name/
    setup.sh               ← copy the fixture, run install.sh --agent $AGENT, set up the starting state
    turns.txt              ← the customer's messages, one per turn
    check.sh               ← exits non-zero on failure and prints which check failed
    rubric.md              ← optional: checks a model grades from the transcript
  run.sh                   ← run.sh --agent claude|codex|kiro --scenario NN --runs 3
  results/                 ← pass rates per VERSION, per agent
```

Turns run without the interactive interface: `claude -p` then `--continue`, `codex exec` then `codex exec resume`. Kiro CLI's non-interactive mode is unconfirmed.

| # | Scenario | Checks |
| --- | --- | --- |
| 1 | Setup on existing code | PRD.md sections and at least 2 Not Doing items; CONTEXT.md and ARCHITECTURE.md exist; TASKS.md matches the format; no placeholder text |
| 2 | Cold resume from pickup.md | The first reply names the task and a concrete next step, without asking for context |
| 3 | Trivial bug | No task and no work entry; a new test fails on the old code and passes now; the commit message states the cause |
| 4 | Simple feature | spec and design Approved; a review-log line; commits cite T-NNN; close.md exists and its test names exist; no links into docs/work |
| 5 | Stop, then resume on another machine | pickup.md is committed; a fresh clone resumes the right step |
| 6 | Never-do rule | The forbidden action didn't happen |
| 7 | Rigor sizing | The stated level and criterion match the expected ones |

Start with scenarios 2, 3 and 5 on Claude Code, plus installer tests that need no agent: install, update, customize-then-update, migrate, and switch agents.

## Sources

- [From Prompt to Process: a Process Taxonomy and Comparative Assessment of Frameworks Supporting AI Software Development Agents (arXiv 2606.04967)](https://arxiv.org/html/2606.04967)
- [GitHub Spec Kit](https://github.github.com/spec-kit/)
- [Trying Out GitHub's Spec Kit (zenn.dev)](https://zenn.dev/beagle/articles/7976e6ac40c762?locale=en)
- [obra/superpowers: docs/testing.md](https://github.com/obra/superpowers/blob/main/docs/testing.md)
- [testing-skills-with-subagents (skills.sh mirror)](https://www.skills.sh/obra/clank/testing-skills-with-subagents)
- [Superpowers write-up (cnblogs)](https://www.cnblogs.com/philzhou/p/20440602)
- [Spec-Driven Development Benchmark 2026 (Uvik)](https://uvik.net/spec-driven-development-benchmark/)
- [BMAD, Spec Kit, OpenSpec, Kiro: A Field Guide (Medium)](https://medium.com/@roanmonteiro/bmad-spec-kit-openspec-kiro-a-field-guide-to-getting-real-work-out-of-ai-coding-agents-b17833c24b3f)
- [Best Spec-Driven Development Tools (codemyspec)](https://codemyspec.com/blog/best-spec-driven-development-tools)
- [I Tested Three Spec-Driven AI Tools (ranthebuilder)](https://ranthebuilder.cloud/blog/i-tested-three-spec-driven-ai-tools-here-s-my-honest-take/)
- [Spec-Driven Development: Spec Kit, Kiro, OpenSpec Compared (juliantellez)](https://juliantellez.com/blog/what-spec-driven-development-is)
- [Spec-Driven Development Meets Agent Evaluation (TimeToBuildBob)](https://timetobuildbob.github.io/blog/spec-driven-development-meets-agent-evaluation/)

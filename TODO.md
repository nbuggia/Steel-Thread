# TODO

## Steel Thread Elevate

### 1. Change management

- changelog.json — define maintenance instructions
  - steel-thread.md tells Claude to "scan changelog.json for recent activity" at session start, but never defines:
    - What belongs in it (schema)
    - When Claude should write to it
    - What constitutes a "significant change" worth logging
  - The template file exists at `.steel-thread/templates/changelog.json` but is undefined. Without maintenance instructions, Claude won't write to it and the session start scan is useless.

## Development

- diagnose
  - pull in matt’s diagnose and pick what I want
  - root cause the issue, show evidence for why confident (or call out when not confidenti)
    - define confidence levels to determine the best course of action — instrument to learn more, or ready to fix.
  - Propose high level appraoch to fix it
  - State level of risk (define each level, tie it to the tech design levels)
  - get adversarial feedback to stress test
  - ask me if I want to create a task
- adversarial feedback (steelman)
- feature spec
  - who is the customer, and what is the benefit they will get from this feature?
  - who is not the customer and what else is out of scope?
  - Pressure test the scope and give feedback on when to break into multiple spec docs.
  - Primary use cases that need to be great.
- UI Mock
  - Create an HTML file in-line with options
  - Consolidate options into a final redline. Save options in the appendix
  - Create UI requirements with redlines
  - Update some central source for a UI framework
- tech design
  - before locking on a tech design, interactively focus on scope to identify which requirements are complexities so we can defer them to future projects.
  - maybe the tech design needs two passes. one for research and to identify the big expensive areas. At the end of this we finalize scope and other decisions. Then for pass two it creates the design, slices and then creates tasks.
    - Each slice should be atomic, could stand on its own.
  - Reviewer needs a command to not give feedback that expands scope unecessarily
    - I need you to be a principal developer to review this implementation plan. You need to focus on helping to keep it simple - building on existing standards capabilities and frameworks, testable and easy to modify in the future. Do not let the scope expand unnecessarily. Challenge my designs when they don’t meet these standards.
    - Somehow we need to define testable to include integration tests.
- retro
  - Review the output of all the design sessions and suggest improvements.
  - Audit all the files for drift and duplication.
  - Remove duplicative content
- implementation
  - All versions should suggest a commit message
# TODO

## Development

- diagnose
  - pull in matt’s diagnose and pick what I want
  - root cause the issue, show evidence for why confident (or call out when not confidenti)
    - define confidence levels to determine the best course of action — instrument to learn more, or ready to fix.
  - Propose high level appraoch to fix it
  - State level of risk (define each level, tie it to the tech design levels)
  - use the hb-elevate skill to stress-test the root cause and fix
  - ask me if I want to create a task
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
- retro
  - Review the output of all the design sessions and suggest improvements.
  - Audit all the files for drift and duplication.
  - Remove duplicative content
- implementation
  - All versions should suggest a commit message

## Framework

- After 1.0.0: add agent-facing release notes (what changed in each version, and why) to `project/.hashbang/framework/`, and have hb-update read them so it can carry Hashbang's intent into heavily customized files.
- Replace the TASKS.md read in the Session Start Protocol (hashbang.md, step 4) with a call to the app's CLI that returns active tasks, once the CLI exists.

# Conventions

\[How to make a change here: the practices a reviewer would flag a diff for breaking. One rule per line, written as an instruction, with an example file that follows it, and the D-NNN behind it when there is one. What the system is goes in ARCHITECTURE.md. Leave out any section with nothing in it.\]

## Structure

- \[Where new code of each kind goes. Example: `src/features/export/`\]

## Boundaries

- \[How a change respects each boundary in ARCHITECTURE.md: "UI code never touches the filesystem; add a command in `commands.ts` (D-003)."\]

## Naming

- \[Naming rules a reviewer would enforce.\]

## Errors

- \[How errors are created, passed across boundaries, shown to users, and logged.\]

## State

- \[Where new state goes and who may change it.\]

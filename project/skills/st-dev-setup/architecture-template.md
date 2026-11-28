# Architecture

\[What is there: the shape of the system as it is now. Describe, don't instruct: rules for making changes go in CONVENTIONS.md, and the reasons behind choices go in DECISIONS.md, cited here as D-NNN. Boundaries belong here, stated as facts: "Only the Rust core touches the filesystem (D-003)." Describe the code's shape without copying it: what a type or module is for, and the file that defines it, never its fields, signatures, or a file tree. Leave out any section with nothing in it.\]

## Stack

\[Languages, frameworks, and runtimes, with versions where they matter, and the platforms and minimum versions the product ships to.\]

| Dependency | What it does for us | Why this one |
| --- | --- | --- |
|  |  | \[D-NNN, or blank\] |

## Components

\[Each major part of the system, what it is responsible for, and where it lives in the repository. Add a diagram when more than three components interact.\]

## Boundaries

\[Where one component meets another across a process, language, network, or trust boundary, and what crosses it. These are the boundaries a change should not cross casually.\]

## State and Persistence

\[Who owns each piece of state, how long it lives, where and how it is stored, and the file that defines its shape, without listing its fields. Include schema versions and how migrations run.\]

## External Interfaces

\[Which component implements each contract in CONTRACTS.md. The promise itself is defined there; this says where it lives in the code.\]

| Contract | Implemented by |
| --- | --- |
|  |  |

## Open Questions

\[Places where the code is inconsistent or the intent is unclear. Each is a question, not a rule, until it is settled.\]

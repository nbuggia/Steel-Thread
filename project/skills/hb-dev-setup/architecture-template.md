# Architecture

\[What is there: the shape of the system as it is now. Describe, don't instruct — rules for making changes go in CONVENTIONS.md, and the reasons behind choices go in DECISIONS.md, cited here as D-NNN. Leave out any section with nothing in it.\]

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

\[Who owns each piece of state, how long it lives, and where and how it is stored — including schema versions and how migrations run.\]

## External Interfaces

\[Contracts other systems or users' files rely on: file formats, URL schemes, public APIs, sync protocols. For each: the component that implements it, how it is versioned, and a link to the spec that defines it.\]

| Interface | Implemented by | Versioning | Defined in |
| --- | --- | --- | --- |
|  |  |  |  |

## Open Questions

\[Places where the code is inconsistent or the intent is unclear. Each is a question, not a rule, until it is settled.\]

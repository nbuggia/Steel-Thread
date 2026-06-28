# TODO

## changelog.json — define maintenance instructions

steel-thread.md tells Claude to "scan changelog.json for recent activity" at session start, but never defines:
- What belongs in it (schema)
- When Claude should write to it
- What constitutes a "significant change" worth logging

The template file exists at `.markymark/templates/changelog.json` but is undefined. Without maintenance instructions, Claude won't write to it and the session start scan is useless.

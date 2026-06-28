---
name: secrets-guard
description: Prevents secrets from appearing in sessions, terminals, logs, or git commits
invoke: always-on hook
based-on: varlock-claude-skill
triggers: before any file write, commit, or terminal output
---

Prevents secrets from ever appearing in sessions, terminals, logs, or git commits. Always on — not a skill the customer invokes, a protection layer that runs automatically.

## What it catches

- API keys and tokens in any format
- Passwords and credentials
- Private keys and certificates
- AWS/GCP/Azure credentials
- Database connection strings with credentials
- Any value matching known secret patterns

## Behavior

- Blocks writes that contain secrets before they reach disk
- Redacts secrets from terminal output automatically
- If a secret is detected in context, alerts the customer and suggests moving it to environment variables
- Never logs or surfaces the actual secret value

## Setup (during /onboard)

When a project with a coding component is onboarded:
1. Create a .env.example file with placeholder values for all required secrets
2. Ensure .env is in .gitignore
3. Add to CONTEXT.md under "Security conventions": the secret management approach for this project

## Pattern

Secrets in environment variables. References in code only through process.env or the platform equivalent. Never hardcoded. Never in comments. Never in logs.

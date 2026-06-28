---
name: security-review
description: OWASP-informed security review of recently changed code, separate from adversarial-review
invoke: model
based-on: agamm/claude-code-owasp, trailofbits/skills
triggers: after each phase, alongside adversarial-review
---

OWASP-informed security review of recently changed code. Runs as a dedicated security lens — separate from adversarial-review which focuses on correctness. Uses a fresh sub-agent context so the reviewer approaches the code cold, as a real security auditor would.

## OWASP Top 10:2025 checks (applied to changed code)

- **A01 Broken Access Control** — are permissions enforced at every layer?
- **A02 Cryptographic Failures** — are secrets handled correctly?
- **A03 Injection** — SQL, XSS, command injection vectors?
- **A04 Insecure Design** — trust boundaries correct?
- **A05 Security Misconfiguration** — defaults safe?
- **A06 Vulnerable Components** — dependencies up to date?
- **A07 Authentication Failures** — auth logic sound?
- **A08 Software Integrity Failures** — supply chain risks?
- **A09 Logging Failures** — sensitive data in logs?
- **A10 SSRF** — server-side request forgery vectors?

## OWASP Agentic AI:2026 checks (if project uses AI)

- **ASI01** Prompt injection vectors
- **ASI02** Excessive agency — does the agent have more permissions than needed?
- **ASI03** Memory poisoning risks

## Output

Severity-ranked findings only — no padding, no 30-page reports. One line per finding: location, vulnerability class, fix.

- BLOCK on critical findings
- CONCERNS on high
- LOW on medium and below

**On BLOCK:** creates tasks in tasks.json, phase stays open.
**On CONCERNS:** adds notes to relevant tech design.

Applies fixes directly for straightforward issues.

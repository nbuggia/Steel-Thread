---
name: threat-model
description: Security-focused grilling session during tech design before implementation decisions are finalized
invoke: model
based-on: Security-Phoenix-demo/security-skills-claude-code
triggers: during /tech-design Phase 3 (grilling)
uses: Grilling skill with security engineering lens
---

Security-focused grilling session that runs during tech design before any implementation decisions are finalized. Uses the Grilling skill with a security engineering lens.

**Domain expert: application security engineer**
Thinks adversarially. Asks "how does an attacker abuse this?" before "how does a user use this?"

## Questions the threat model asks

**Trust boundaries:**
- Where does data enter the system from untrusted sources?
- What assumptions are we making about callers?
- Where could a malicious actor inject input?

**Data sensitivity:**
- What data does this feature touch?
- What's the blast radius if this component is compromised?
- Does this feature need to touch sensitive data at all?

**Authentication and authorization:**
- Who can call this? Is that enforced?
- What happens if auth is bypassed?
- Are there privilege escalation paths?

**Failure modes:**
- What happens when this fails? Does it fail safely?
- Could an attacker trigger failure intentionally?
- Does failure reveal sensitive information?

## Output

A "Security considerations" section added to the tech design.
High-risk decisions flagged for security-review to check during implementation.
Threat model summary added to CONTEXT.md under "Security decisions."

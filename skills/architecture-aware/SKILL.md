---
name: Architecture Awareness
description: >
  This skill provides architecture consciousness during development, including integration patterns,
  anti-patterns, and ADR guidance. It should be used when the user asks how to structure or organize code,
  discusses architecture or design patterns, plans integrations between components, or asks
  "how should I structure this?", "what pattern should I use?", "should I split this into services?",
  "should I write an ADR?", or "document this decision."
---

# Architecture Awareness

Maintain architectural consciousness throughout development. Every code change exists within an architectural context — respect it.

## Core Principles

### Fit the Existing Architecture
Before proposing any pattern, understand what's already there. Don't introduce a new pattern when the codebase already has an established one that works.

### Justify Pattern Choices
Every pattern has trade-offs. State the specific benefit for THIS codebase, not abstract "best practice" arguments.

### Record Significant Decisions
If a decision is hard to reverse or affects multiple components, it deserves an ADR (Architecture Decision Record).

## When an Architecture Question Arises

1. **Survey existing patterns** — read the codebase to understand current conventions, patterns, and structure
2. **Evaluate fit** — does the proposed approach align with or diverge from existing patterns? Divergence needs justification.
3. **State trade-offs explicitly** — every option has costs and benefits. Name them concretely for this codebase.
4. **Decide whether an ADR is warranted** — write one if the decision is hard to reverse or affects multiple components
5. **Document if yes** — use the ADR template from `references/adr-guide.md`

## What to Check

1. **Existing patterns**: What patterns does the codebase already use?
2. **Integration points**: How will new code connect to existing code?
3. **Coupling**: Are we creating tight coupling between components?
4. **Consistency**: Does this follow or violate established conventions?

## Related Skills

- **spec-first** — architecture decisions emerge during Stage 4 (Architecture)
- **iterative-execution** — architectural context guides integration during implementation
- **guardrails** — enforces architectural consistency as part of scope discipline

## References

See: `references/integration-patterns.md`
See: `references/anti-patterns.md`
See: `references/adr-guide.md`

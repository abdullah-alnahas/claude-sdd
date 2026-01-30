---
name: Architecture Awareness
description: >
  Provides architecture consciousness during development — integration patterns, anti-patterns, and ADR guidance.
  Use when designing systems, discussing architecture, integration, patterns, structure, or organization.
version: 1.0.0
---

# Architecture Awareness

You maintain architectural consciousness throughout development. Every code change exists within an architectural context — respect it.

## Core Principles

### Fit the Existing Architecture
Before proposing any pattern, understand what's already there. Don't introduce a new pattern when the codebase already has an established one that works.

### Justify Pattern Choices
Every pattern has trade-offs. State the specific benefit for THIS codebase, not abstract "best practice" arguments.

### Record Significant Decisions
If a decision is hard to reverse or affects multiple components, it deserves an ADR (Architecture Decision Record).

## When to Engage

- User asks "how should I structure this?"
- Adding a new component to an existing system
- Introducing a new technology or pattern
- Changing how components communicate
- Anything that touches 3+ modules/services

## What to Check

1. **Existing patterns**: What patterns does the codebase already use?
2. **Integration points**: How will new code connect to existing code?
3. **Coupling**: Are we creating tight coupling between components?
4. **Consistency**: Does this follow or violate established conventions?

## References

See: `references/integration-patterns.md`
See: `references/anti-patterns.md`
See: `references/adr-guide.md`

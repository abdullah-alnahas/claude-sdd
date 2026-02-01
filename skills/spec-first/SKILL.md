---
name: Spec-First Development
description: >
  Use when starting a new project or feature, creating specs or plans, adopting an existing project,
  or when the user says "I want to build something," "let's plan this out," "write a spec," or
  "let's design this first." Use before any non-trivial implementation that lacks a spec.
---

# Spec-First Development

Guide users from rough idea to formal specification through interactive questioning — not checklist dumping. Code comes AFTER specs, not before.

## The Process

When a user describes something they want to build, DO NOT start coding. Instead, walk them through these stages conversationally:

### Stage 1: Intent Discovery → `app-description.md`
Ask naturally (not all at once):
- What problem does this solve?
- Who are the users?
- What's the core value proposition?
- What does success look like?

When you have enough, offer to generate the app description document.

### Stage 2: Behavioral Bounding → `behavior-spec.md`
- What must it do? (Frame as Given-When-Then acceptance criteria)
- What must it NOT do? (Explicit non-goals prevent scope creep)
- What are the edge cases?
- Any compliance/security concerns?

### Stage 3: Technical Context → `stack.md`
- What language/framework?
- Any existing code to integrate with?
- Deployment target?
- Performance requirements?

### Stage 4: Architecture → `architecture.md`
- How does this fit into the existing system?
- What patterns make sense?
- What are the integration points?
- What shared infrastructure exists?

### Stage 5: Prioritization → `roadmap.md`
- What ships first?
- What can wait?
- Dependencies between features?

Each stage produces a document in the project's `specs/` directory (or wherever the user prefers).

## Project Adoption

For existing projects, use the adoption flow instead of starting from scratch. See: `references/project-adoption.md`

## Key Principles

- **Ask, don't assume**: Every question prevents a wrong assumption from becoming code
- **Conversational, not bureaucratic**: Adapt questions to context. Skip what's obvious. Dig deeper on what's unclear.
- **Documents are living**: Specs evolve. That's fine. But they must exist before code.
- **Lean templates**: The templates are starting points, not forms to fill out

## Related Skills

- **architecture-aware** — for deeper architectural guidance during Stage 4
- **tdd-discipline** — for test planning from behavior specs (use `references/templates/test-plan.md`)
- **iterative-execution** — delivers features against the specs produced here
- **guardrails** — enforces spec-first as a pre-implementation check

## References

See: `references/interactive-spec-process.md` — Detailed questioning flow
See: `references/foundation-docs-guide.md` — Document standards
See: `references/project-adoption.md` — Adopting existing codebases
See: `references/templates/` — Document templates

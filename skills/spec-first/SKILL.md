---
name: Spec-First Development
description: >
  Interactive specification development that turns rough ideas into formal documents before code is written.
  Use when starting a new project, new feature, creating specs, plans, adopting an existing project,
  or when the user says "I want to build/create something."
version: 1.0.0
---

# Spec-First Development

You guide users from rough idea to formal specification through interactive questioning — not checklist dumping. Code comes AFTER specs, not before.

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

## References

See: `references/interactive-spec-process.md` — Detailed questioning flow
See: `references/foundation-docs-guide.md` — Document standards
See: `references/project-adoption.md` — Adopting existing codebases
See: `references/templates/` — Document templates

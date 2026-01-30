# Architecture Decision Records (ADRs)

## When to Write an ADR

Write an ADR when:
- The decision is hard to reverse
- Multiple valid alternatives exist
- The decision affects multiple components
- Future developers will wonder "why did they do it this way?"

Don't write an ADR for:
- Obvious choices (using the project's existing language)
- Easily reversible decisions
- Style preferences

## Format

```markdown
# ADR-[NUMBER]: [Title]

**Date**: [Date]
**Status**: [Proposed | Accepted | Deprecated | Superseded by ADR-X]

## Context
[What situation or problem prompted this decision?]

## Decision
[What did we decide to do?]

## Alternatives Considered
[What other options were evaluated? Why were they rejected?]

## Consequences
[What are the positive and negative results of this decision?]
```

## Storage

Store ADRs in `docs/adr/` or `specs/adr/`:
```
docs/adr/
├── 0001-use-postgresql.md
├── 0002-event-driven-notifications.md
└── 0003-monorepo-structure.md
```

## Tips

- Keep ADRs short (1 page max)
- Focus on the WHY, not the HOW
- Include rejected alternatives — they're as valuable as the choice
- Link to relevant specs or behavior documents
- ADRs are immutable — supersede, don't edit

# Foundation Documents Guide

## Document Standards

Each document should be:
- **Concise**: Say what's needed, nothing more
- **Specific**: Avoid vague language ("fast", "scalable", "robust") — use measurable criteria
- **Versioned**: Include a version/date at the top
- **Actionable**: A developer should be able to build from these docs without guessing

## Document Set

A fully specified project has up to 7 foundation documents. Not all are required for every project.

| Document | Required | Purpose |
|----------|----------|---------|
| `app-description.md` | Yes | What this is and why it exists |
| `behavior-spec.md` | Yes | What it does (acceptance criteria) |
| `stack.md` | Recommended | Technology choices and rationale |
| `architecture.md` | For complex projects | System structure and patterns |
| `roadmap.md` | For multi-phase projects | What ships when |
| `test-plan.md` | For TDD projects | Test strategy and coverage goals |
| `retrospective.md` | Post-delivery | What went well, what didn't |

## Naming Convention

Store in a `specs/` directory at project root:
```
specs/
├── app-description.md
├── behavior-spec.md
├── stack.md
├── architecture.md
├── roadmap.md
├── test-plan.md
└── retrospective.md
```

For multi-feature projects, prefix with feature name:
```
specs/
├── auth-behavior-spec.md
├── auth-test-plan.md
├── search-behavior-spec.md
└── search-test-plan.md
```

## Quality Checklist

Before finalizing any document:
- [ ] No vague adjectives without metrics
- [ ] All user-facing behaviors have acceptance criteria
- [ ] Non-goals are explicitly stated
- [ ] Technical choices have stated rationale
- [ ] Scope is clearly bounded

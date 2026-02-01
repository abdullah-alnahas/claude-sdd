# SDD Context: Research Mode

Exploration focus. Guardrails are relaxed to allow free investigation without implementation ceremony.

## Active Guardrails

- **Pre-implementation checkpoint**: OFF — you're exploring, not committing to implementation
- **Completion review**: OFF — research doesn't have a "done" in the spec-compliance sense
- **Scope guard**: RELAXED — follow the investigation wherever it leads
- **TDD enforcement**: OFF for prototypes — but ON if research produces code intended for production
- **Post-edit review**: OFF — prototypes and experiments don't need review

## When to Use

- Understanding unfamiliar codebases
- Investigating bugs (root cause analysis)
- Prototyping and experimentation
- Architecture exploration and spike work
- Reading documentation and tracing flows

## Principles

- Follow curiosity — explore freely
- Take notes — capture findings for later
- Don't ship research code — if it becomes production code, switch to dev mode
- Time-box — set a goal for what you want to learn

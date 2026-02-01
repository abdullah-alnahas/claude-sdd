# SDD Context: Review Mode

Critic and verification focus. Pre-implementation checkpoint is skipped since you're reviewing, not building.

## Active Guardrails

- **Pre-implementation checkpoint**: OFF — you're reviewing existing code, not starting new work
- **Completion review**: ON — ensure review findings are complete and actionable
- **Scope guard**: NORMAL — stay focused on what you're reviewing
- **TDD enforcement**: ON for any fixes — if review leads to fixes, tests come first
- **Post-edit review**: ON — verify any fixes made during review

## When to Use

- Code review (PRs, post-implementation)
- Auditing existing code for quality
- Security reviews
- Running `/sdd-review` or agent-based reviews

## Principles

- Find what's wrong, not confirm what's right
- Be specific and evidence-based
- Report findings honestly — don't soften
- If fixing, follow TDD discipline

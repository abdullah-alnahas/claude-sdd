# SDD Context: Dev Mode

Full guardrails active. This is the default mode for implementation work.

## Active Guardrails

- **Pre-implementation checkpoint**: ON — enumerate assumptions, flag ambiguity, surface alternatives, push back on bad ideas, define scope, check for spec, plan TDD approach
- **Completion review**: ON — spec adherence, test coverage, complexity audit, dead code check, scope creep check
- **Scope guard**: STRICT — reject changes outside defined scope without explicit approval
- **TDD enforcement**: ON — tests before implementation
- **Post-edit review**: ON — review after each write/edit

## When to Use

- Implementing features from specs
- Fixing bugs
- Refactoring code
- Any task where correctness and discipline matter

## Principles

- Every change starts with understanding the spec
- Every implementation starts with a test
- Every completion is verified against criteria
- Scope is defended — no drive-by improvements

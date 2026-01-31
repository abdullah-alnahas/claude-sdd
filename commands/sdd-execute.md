---
name: sdd-execute
description: Start an iterative execution loop — implement with TDD, verify against spec, fix gaps, repeat
argument-hint: "[--max-iterations <n>] [--criteria <description>]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Task
---

# /sdd-execute

Start a disciplined iterative execution loop for the current spec or task. Implements using TDD, verifies holistically, fixes gaps, and repeats until the spec is satisfied.

## Usage

- `/sdd-execute` — Execute against the current spec/task
- `/sdd-execute --max-iterations <n>` — Set max outer loop iterations (default: 10)
- `/sdd-execute --criteria "<description>"` — Override completion criteria

## Behavior

1. **Identify spec**: Find the relevant behavior spec and test plan
2. **Define completion criteria**: Extract acceptance criteria from spec (or use provided criteria)
3. **Execute loop**:
   a. **Implement with TDD**: Write failing test → minimal code → refactor
   b. **Verify holistically**: Run full test suite, linters, type checks, and available agents
   c. **Identify gaps**: Compare current state against spec criteria
   d. **Fix gaps**: Address failures using TDD (test the fix first)
   e. **Repeat** until all criteria satisfied or max iterations reached
4. **Report**: Honest completion status

## Verification Stack

The loop uses all available verification tools:
1. Test runners (detected from project — jest, pytest, cargo test, etc.)
2. Type checkers / linters (tsc, eslint, mypy, clippy, etc.)
3. SDD agents (critic, spec-compliance, security-reviewer)
4. External tools (any MCP servers or plugins the user has configured)

## Output Format

```
SDD Execute — Iteration 3/10
─────────────────────────────

Criteria: 5 acceptance criteria from specs/behavior-spec.md

Progress:
  ✓ Criterion 1: User can log in with valid credentials
  ✓ Criterion 2: Invalid credentials show error message
  ✓ Criterion 3: Session persists across page refresh
  ✗ Criterion 4: Password reset sends email — test failing (SMTP mock not configured)
  ○ Criterion 5: Account lockout after 5 failed attempts — not yet implemented

Status: 3/5 complete. Continuing...
```

## Completion

```
SDD Execute — Complete (Iteration 5/10)
────────────────────────────────────────

All 5 acceptance criteria satisfied.
All tests passing (12 tests).
No critical issues from critic agent.

Completion is genuine — verified against spec.
```

## Principles

- TDD is the inner discipline: every piece of new code starts with a failing test
- The outer loop verifies against the spec, not just test results
- Honest reporting: never claim done when criteria are unsatisfied
- Bounded: max iterations prevent infinite loops

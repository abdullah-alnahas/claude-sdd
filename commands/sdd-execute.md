---
name: sdd-execute
description: Start an iterative execution loop — implement with TDD, verify against spec, fix gaps, repeat
argument-hint: "[--plan-first] [--max-iterations <n>] [--criteria <description>] [--plugins=ask|auto|off] [description]"
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
- `/sdd-execute <description>` — Start from a description (generates spec first)
- `/sdd-execute --plan-first <description>` — Consolidated planning mode (2 review points instead of 5)
- `/sdd-execute --max-iterations <n>` — Set max outer loop iterations (default: 10)
- `/sdd-execute --criteria "<description>"` — Override completion criteria
- `/sdd-execute --plugins=ask` — Show registered plugin agents, ask which to include in verification
- `/sdd-execute --plugins=auto` — Automatically include all registered plugin agents
- `/sdd-execute --plugins=off` — Don't use plugin agents (default)

## Plan-First Mode

When `--plan-first` is used:

1. **Generate all planning docs with minimal pauses**:
   - proposal.md + behavior-spec.md → **pause for spec review**
   - architecture.md + roadmap.md → **pause for design review**

2. **After design approval, begin implementation**

This reduces 5 pause points to 2 while preserving course-correction opportunities. Use when:
- You have a clear idea and want to move faster
- The feature is well-understood
- You trust the initial planning

Standard mode (without `--plan-first`) pauses after each document for maximum feedback.

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
4. **Registered plugin agents** (from `.sdd-plugins.json`, controlled by `--plugins` flag)
5. External tools (any MCP servers or plugins the user has configured)

### Plugin Agent Integration

When `--plugins` is `ask` or `auto`:

1. Read `.sdd-plugins.json` from the project root
2. Collect all registered plugin agents
3. **ask mode**: Present the list of available plugin agents and let the user select which to include
4. **auto mode**: Include all registered plugin agents automatically
5. During the verification step (3c), run selected plugin agents after SDD's built-in agents
6. Plugin agent findings are included in gap analysis

Plugin agents use the same handoff format as SDD agents. If a plugin agent fails, treat it as a verification gap (same as a built-in agent failure).

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

## Batch Execution

When working on multiple criteria or tasks, group them into batches of 3:

1. Implement batch (3 criteria/tasks) using TDD
2. Verify the batch — run tests, check spec compliance
3. Report progress with verification evidence (test output, not claims)
4. Pause for user feedback before continuing to the next batch

This prevents long unverified runs and gives the user control over direction.

## Verification

After each batch, use the two-stage review process:
- **Stage 1**: Spec compliance — verify each criterion with evidence (see `/sdd-review`)
- **Stage 2**: Code quality — only after Stage 1 passes

## Principles

- TDD is the inner discipline: every piece of new code starts with a failing test
- The outer loop verifies against the spec, not just test results
- Honest reporting: never claim done when criteria are unsatisfied
- Bounded: max iterations prevent infinite loops
- Batch execution: groups of 3 with checkpoint reports

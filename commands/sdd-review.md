---
name: sdd-review
description: Two-stage review — spec compliance first, then code quality. Only proceeds to Stage 2 after Stage 1 passes.
argument-hint: "[--max-iterations <n>]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Task
---

# /sdd-review

Trigger a two-stage review of recent work. Stage 1 verifies spec compliance. Stage 2 reviews code quality. Stage 2 only runs after Stage 1 passes.

## Usage

- `/sdd-review` — Review recent changes
- `/sdd-review --max-iterations <n>` — Set max review-fix cycles (default: 3)

## Stage 1: Spec Compliance

**Goal**: Verify the implementation satisfies the behavior spec.

1. Identify what was recently changed (git diff or session context)
2. Find the relevant behavior spec and acceptance criteria
3. Run the **spec-compliance agent** with the Stage 1 prompt from `iterative-execution/references/review-prompts.md`
4. **DO NOT trust the implementation report.** Read the actual code and test output independently.
5. For each acceptance criterion: PASS / FAIL / PARTIAL with evidence
6. If any criterion fails:
   - Present findings
   - Offer to fix (using TDD — write a test for the fix first)
   - After fixing, re-run Stage 1
   - Repeat until all criteria pass or max iterations reached

**Stage 1 must pass before proceeding to Stage 2.**

## Stage 2: Code Quality

**Goal**: Find unnecessary complexity, dead code, scope creep.

1. Run the **critic agent** — find logical errors, assumption issues
2. Run the **simplifier agent** — find unnecessary complexity
3. If the changes involve performance optimization, run the **performance-reviewer agent**
4. Present findings with severity levels:
   - [Critical] — must fix
   - [Simplification] — should fix
   - [Observation] — consider fixing
5. Offer to auto-fix critical and simplification issues
6. If fixes are made (using TDD), re-run Stage 2
7. Repeat until no critical issues remain or max iterations reached

## Output Format

```
SDD Review — Stage 1: Spec Compliance
──────────────────────────────────────

Spec: specs/behavior-spec.md (5 criteria)

  ✓ Criterion 1: User can log in — PASS (test_login passes)
  ✓ Criterion 2: Invalid credentials show error — PASS (test_invalid_login passes)
  ✗ Criterion 3: Session persists — FAIL (no test found for this criterion)

Stage 1: 2/3 FAIL — must fix before proceeding to Stage 2.
```

```
SDD Review — Stage 2: Code Quality
───────────────────────────────────

Critic Findings:
  [Critical] ...

Simplifier Findings:
  [Simplification] ...

Actions:
  - Fix critical issues? (y/n)
  - Apply simplifications? (y/n)
```

## Principles

- Stage 1 is the gate. No code quality review on non-compliant code.
- Reviews are honest — findings are reported as-is, not softened
- DO NOT trust the implementer's report. Verify independently.
- Fixes follow TDD: if the fix changes behavior, write a test first
- Max iterations prevent infinite loops

## References

See: `iterative-execution/references/review-prompts.md` — Subagent prompt templates

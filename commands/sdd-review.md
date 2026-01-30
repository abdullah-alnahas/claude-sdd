---
name: sdd-review
description: On-demand self-review using critic and simplifier agents with iterative fix cycles
---

# /sdd-review

Trigger an on-demand review of recent work using the critic and simplifier agents. Runs iteratively — reviews, fixes, re-reviews until no critical issues remain.

## Usage

- `/sdd-review` — Review recent changes
- `/sdd-review --max-iterations <n>` — Set max review-fix cycles (default: 3)

## Behavior

1. Identify what was recently changed (git diff or session context)
2. Run the **critic agent** — find logical errors, spec drift, assumption issues
3. Run the **simplifier agent** — find unnecessary complexity
4. If spec documents exist, run the **spec-compliance agent**
5. Present findings with severity levels
6. Offer to auto-fix issues found
7. If fixes are made (using TDD — write test for the fix first if applicable), re-review
8. Repeat until no critical issues remain or max iterations reached

## Output Format

```
SDD Review — Iteration 1/3
──────────────────────────

Critic Findings:
  [Critical] ...
  [Warning] ...

Simplifier Findings:
  [Simplification] ...

Spec Compliance:
  [X of Y criteria satisfied]

Actions:
  - Fix critical issues? (y/n)
  - Apply simplifications? (y/n)
```

## Principles

- Reviews are honest — findings are reported as-is, not softened
- Fixes follow TDD: if the fix changes behavior, write a test first
- Max iterations prevent infinite loops
- The review itself is part of the iterative execution cycle

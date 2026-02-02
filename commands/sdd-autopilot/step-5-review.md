# Step 5: Review

**Input**: Verification findings from Step 4.

## Actions

1. Address all critical and high findings from Step 4 using TDD
2. Re-run verification on fixed code (re-invoke agents as needed)
3. Repeat until no critical issues remain (max 3 review iterations)
4. Generate completion report

## Output

```
SDD Autopilot — Complete
════════════════════════

Spec Criteria: X of Y satisfied
Tests: N passing, M failing
Review Iterations: K

Phases completed:
  ✓ Specify — N criteria defined
  ✓ Design — M roadmap items, K ADRs
  ✓ Implement — N items built with TDD
  ✓ Verify — findings addressed
  ✓ Review — no critical issues remaining

Documents generated:
  specs/app-description.md
  specs/behavior-spec.md
  specs/stack.md
  specs/architecture.md
  specs/roadmap.md

Remaining issues:
  [Any unresolved items, or "None"]
```

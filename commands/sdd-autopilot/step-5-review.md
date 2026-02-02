# Step 5: Review

**Input**: Verification findings from Step 4.

## Actions

1. Invoke **simplifier agent** — identify unnecessary complexity
2. Address all critical and high findings using TDD
3. Re-run verification on fixed code
4. Repeat until no critical issues remain (max 3 review iterations)
5. Generate completion report

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

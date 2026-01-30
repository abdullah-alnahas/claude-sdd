# Loop Patterns

All patterns below use TDD as the inner discipline — tests are written before implementation code.

## Feature Delivery Loop (Primary)
```
Define criteria from spec → Implement with TDD → Verify holistically → Fix gaps → Repeat
```
**Inner step**: Each "implement" step uses Red→Green→Refactor.
**Exit condition**: All acceptance criteria from behavior spec satisfied.
**Max iterations**: 10 (outer loop — each may contain multiple TDD cycles).

## Spec-Compliance Loop
```
Implement with TDD → Run spec-compliance agent → See deviations → Fix with TDD → Re-check
```
**Exit condition**: Agent reports zero spec deviations.
**Max iterations**: 5 (if still deviating after 5, re-examine the spec).

## Integration Verification Loop
```
Write integration tests → Implement integration code → Run → Fix failures → Re-run
```
**Exit condition**: All integration tests pass with real dependencies.
**Max iterations**: 10 (integration issues can be subtle).

## Review Loop
```
Submit code → Critic agent reviews → Fix issues → Re-review
```
**Exit condition**: No critical issues found.
**Max iterations**: 3 (diminishing returns after 3 rounds).

## Performance Loop
```
Define target metrics → Benchmark → Identify bottleneck → Optimize → Re-benchmark
```
**Exit condition**: Performance meets specified targets.
**Max iterations**: 5 (if not meeting targets, re-examine requirements).

## General Guidance

- Start with the tightest loop (unit-level TDD) before wider loops (integration, spec-compliance)
- Each outer iteration should make measurable progress
- If an iteration makes no progress, change strategy — don't repeat the same approach
- The inner TDD cycle (test→code→refactor) runs within every implementation step
- Log what was tried and what failed for debugging context

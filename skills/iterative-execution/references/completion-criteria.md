# Completion Criteria

## What Makes Good Criteria

### Observable
You can verify them without subjective judgment.
- **Good**: "All 5 tests in test_auth.py pass"
- **Bad**: "Authentication works properly"

### Specific
They reference concrete artifacts.
- **Good**: "Behavior spec criteria 1-3 are satisfied per spec-compliance agent"
- **Bad**: "The feature is complete"

### Bounded
There's a maximum iteration count.
- **Good**: "Loop up to 10 times, then report status"
- **Bad**: "Keep going until it's perfect"

## Criteria Templates

### For a new feature
```
Done when:
- [ ] All acceptance criteria in behavior-spec.md pass
- [ ] All tests in test plan pass
- [ ] Critic agent finds no critical issues
- [ ] No TypeScript/lint errors
Max iterations: 10
```

### For a bug fix
```
Done when:
- [ ] Reproduction test passes (was failing before fix)
- [ ] All existing tests still pass
- [ ] No regressions in related functionality
Max iterations: 5
```

### For a refactor
```
Done when:
- [ ] All existing tests pass (no behavior change)
- [ ] Complexity metrics improved (fewer lines, fewer files, lower cyclomatic complexity)
- [ ] Simplifier agent approves
Max iterations: 5
```

## Anti-Circumvention

Never:
- Delete a failing test to make the suite pass
- Weaken an assertion to match incorrect output
- Skip a criterion because "it's not important"
- Claim partial completion as full completion
- Exceed max iterations without reporting honestly

Always:
- Report exact status: "4 of 5 criteria met"
- Explain what's blocking remaining criteria
- Suggest next steps if you can't complete

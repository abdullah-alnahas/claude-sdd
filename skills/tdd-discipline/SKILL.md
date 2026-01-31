---
name: TDD Discipline
description: >
  This skill enforces test-driven development discipline with the Red/Green/Refactor cycle and traceability
  from behavior spec to test to code. It should be used when the user asks to write tests, add test coverage,
  discuss testing strategy, or says "how should I test this?", "add tests for this," or "write tests first."
---

# TDD Discipline

Tests are not an afterthought — they are the first expression of intent. Write the test that describes the behavior, watch it fail, then write the minimum code to make it pass.

## Red → Green → Refactor

1. **Red**: Write a failing test that describes the desired behavior
2. **Green**: Write the minimum code to make the test pass
3. **Refactor**: Clean up without changing behavior (tests still pass)

This cycle applies at every level: unit, integration, e2e.

## Relationship to Iterative Execution

TDD is the **inner discipline** — how you write each piece of code. Iterative execution is the **outer cycle** — how you deliver a complete feature against a spec. Every "implement" step in the iterative execution cycle uses TDD internally. They are complementary: TDD ensures code correctness at the unit level; iterative execution ensures spec satisfaction at the feature level.

## When TDD Adds Value

- Business logic with clear inputs/outputs
- Data transformations
- State machines
- API contracts
- Bug fixes (write a test that reproduces the bug first)

## When TDD Is Overhead

- UI layout/styling (use visual testing instead)
- Prototype/spike code (throw-away by definition)
- Simple CRUD with no logic (test the framework, not your code)
- One-off scripts

## Traceability

Every test should trace back to a behavior spec criterion:

```
Spec: "Given a logged-in user, when they submit a form, then data is saved"
Test: test_submit_form_saves_data()
Code: FormHandler.submit()
```

This chain ensures nothing is built without a reason and nothing specified goes untested.

## References

See: `references/test-strategies.md`
See: `references/traceability.md`

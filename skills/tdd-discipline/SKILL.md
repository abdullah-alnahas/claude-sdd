---
name: TDD Discipline
description: >
  Use when writing tests, adding test coverage, fixing bugs, debugging, or when any new code needs
  to be written. Use when the user says "write tests," "add tests," "fix this bug," "debug this,"
  or "how should I test this?"
---

# TDD Discipline

Tests are not an afterthought — they are the first expression of intent. Write the test that describes the behavior, watch it fail, then write the minimum code to make it pass.

## Spirit vs. Letter

The spirit of TDD is: **know what correct behavior looks like before writing the code.** The Red/Green/Refactor cycle is the mechanism, but the principle is that you define "done" before you start. If a situation genuinely doesn't benefit from a test-first approach (see "When TDD Is Overhead" below), skip the mechanism — but never skip the principle of defining expected behavior first.

## Red → Green → Refactor

1. **Red**: Write a failing test that describes the desired behavior
2. **Green**: Write the minimum code to make the test pass
3. **Refactor**: Clean up without changing behavior (tests still pass)

This cycle applies at every level: unit, integration, e2e.

## Rationalization Red Flags

These thoughts mean STOP — you're about to skip TDD:

| Thought | Reality |
|---------|---------|
| "I'll write tests after the code works" | That's test-after, not TDD. Write the test first. |
| "This is too simple to need a test" | Simple code with no test becomes complex code with no test. |
| "I know this works, I'll just verify manually" | Manual verification doesn't persist. Tests do. |
| "The test is obvious, I'll skip to code" | If it's obvious, it takes 30 seconds to write. Do it. |
| "I need to see the code structure first" | Write the test to discover the structure. That's the point. |
| "This is just a refactor, tests already pass" | Run the tests. Confirm they pass. Then refactor. |
| "Writing a test for this would be too complex" | If you can't test it, you can't verify it. Simplify the design. |
| "I'll add tests in the next iteration" | Next iteration never comes. Write them now. |

## Relationship to Iterative Execution

TDD is the **inner discipline** — how you write each piece of code. Iterative execution is the **outer cycle** — how you deliver a complete feature against a spec. They are complementary: TDD ensures correctness at the unit level; iterative execution ensures spec satisfaction at the feature level. See the **iterative-execution** skill for the full outer cycle.

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

This chain ensures nothing is built without a reason and nothing specified goes untested. If a test has no spec criterion, either add the criterion to the spec or question whether the test is needed. If a spec criterion has no test, that is a finding — even if the code works.

## Related Skills

- **iterative-execution** — the outer delivery cycle that uses TDD internally
- **spec-first** — produces behavior specs that drive test design (see `skills/spec-first/references/templates/test-plan.md` from plugin root)
- **guardrails** — enforces TDD during implementation
- **performance-optimization** — uses TDD to preserve correctness during optimization

## References

See: `references/test-strategies.md`
See: `references/traceability.md`

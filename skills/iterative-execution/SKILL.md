---
name: Iterative Execution
description: >
  Disciplined implement→verify→fix cycles for delivering against specs. Use when implementing features,
  executing specs, making things work, iterating until specs are satisfied, or running execution loops.
version: 1.0.0
---

# Iterative Execution

Delivery is not a single pass. It's a disciplined cycle: implement (test-first) → verify against spec → fix gaps → repeat until done.

## How It Relates to TDD

TDD is the **inner discipline** — how you write each piece of code (test first → minimal code → refactor).
Iterative execution is the **outer cycle** — how you deliver a complete feature against a spec.

```
Outer: Implement → Verify against spec → Fix gaps → Repeat
         │
         └─ Inner (TDD): Write failing test → Minimal code → Refactor
```

They are complementary, not competing. TDD governs how you write code. Iterative execution governs how you deliver features.

## The Cycle

```
1. Define completion criteria (what "done" means — from the spec)
2. Implement using TDD (write tests first, then minimal code to pass)
3. Verify holistically (run full suite, agents, linters — everything available)
4. Identify gaps between current state and spec
5. Fix gaps (again using TDD for any new code)
6. Repeat until ALL criteria satisfied or max iterations reached
7. Report honest completion status
```

## Completion Criteria

Good completion criteria are:
- **Observable**: You can check them (tests pass, output matches, agent approves)
- **Specific**: Not "it works" but "all 5 acceptance criteria in the behavior spec pass"
- **Bounded**: Max iteration count prevents infinite loops

## Verification Tools

Use whatever is available, in order of preference:
1. **Automated tests** (test runners, linters, type checkers)
2. **Plugin agents** (critic, spec-compliance, security-reviewer)
3. **Plugin skills** (guardrails, architecture-aware)
4. **External MCP servers** (if user has configured any)
5. **External plugin agents/skills** (if other plugins are installed)
6. **Manual inspection** (read the code, trace the logic)

## Honesty Rules

- **Never claim done when tests fail.** If tests fail, you're not done.
- **Never skip a failing test.** Fix the code or fix the test (only if the test is genuinely wrong).
- **Never weaken criteria to match output.** The spec defines done, not the implementation.
- **Be honest about partial completion.** "3 of 5 criteria met, blocked on X" is better than a false "done."

## References

See: `references/loop-patterns.md`
See: `references/completion-criteria.md`

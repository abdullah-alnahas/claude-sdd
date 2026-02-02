# Step 3: Implement

**Input**: Behavior spec + roadmap from previous steps.

## Actions

1. Work through roadmap items in priority order, in **batches of 3**
2. For each item, use TDD:
   - Write failing test(s) that cover the relevant acceptance criteria
   - Write minimal code to pass
   - Refactor
3. After each batch of 3 items:
   - Run available verification (test suite, linters, type checks)
   - Report progress with verification evidence (actual test output)
   - Pause for user feedback before continuing
4. If tests fail, fix using TDD (understand failure -> write targeted fix -> verify)
5. Continue until all roadmap items complete

Use the iterative execution outer loop: implement -> verify -> fix gaps -> repeat (max 10 iterations per roadmap item).

## Transition

"Implement phase complete — all M roadmap items done. Entering Verify phase."

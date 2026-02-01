---
name: Performance Optimization
description: >
  Use when optimizing, speeding up, profiling, reducing memory usage, or improving performance.
  Use when the user says "profile this," "find the bottleneck," "speed up," or "optimize."
  Use when any change targets performance without breaking correctness.
---

# Performance Optimization Discipline

Performance optimization is investigative work. You must understand the problem before changing any code. The #1 failure mode is editing the wrong code — optimizing a function that isn't the bottleneck.

## Before Touching Code

1. **Understand the workload** — what is slow? Get a concrete, reproducible example.
2. **Profile** — use available profiling tools (cProfile, timeit, flamegraphs, browser devtools, database EXPLAIN). Identify the actual bottleneck with evidence.
3. **Establish a baseline** — measure current performance quantitatively. Record the number.
4. **Identify the right target** — the bottleneck is where time is actually spent, not where you think it's spent. Trust the profiler, not intuition.

## During Implementation

1. **One change at a time** — make a single optimization, measure, verify tests pass. Then move to the next.
2. **Prefer structural improvements**:
   - Algorithm changes (O(n^2) → O(n log n))
   - Data structure changes (list → set for lookups)
   - Eliminating redundant computation (caching, memoization)
   - Reducing I/O (batching, buffering)
3. **Avoid convenience bias** — resist the urge to make small, surface-level tweaks that are easy to produce but fragile. If the fix is a one-liner that "should help," verify it actually does.
4. **Preserve correctness absolutely** — run the full test suite after every change. Any test regression means the optimization is invalid, no matter how fast it is.
5. **Don't optimize what doesn't matter** — if a function takes 1ms in a workflow that takes 10s, leave it alone.

## After Each Change

1. **Measure** — compare against baseline. Quantify the improvement (e.g., "2.3x faster" or "reduced from 4.2s to 1.8s").
2. **Test** — full test suite passes.
3. **Profile again** — confirm the bottleneck was addressed, not just shifted elsewhere.
4. **Evaluate** — is the improvement sufficient? If not, iterate on the next bottleneck.

## What NOT to Do

- Don't guess at bottlenecks — profile first
- Don't sacrifice readability for marginal gains
- Don't optimize code paths that run once at startup
- Don't add caching without understanding invalidation
- Don't parallelize without understanding thread safety
- Don't claim "faster" without measurements

## Convenience Bias Checklist

Before submitting a performance patch, verify it is NOT:
- An input-specific hack that only helps one case
- A micro-optimization with unmeasurable impact
- A change that trades correctness risk for speed
- A surface-level tweak when a deeper structural fix exists

## Related Skills

- **guardrails** — enforces correctness-first and verify-before-claiming during optimization
- **iterative-execution** — the outer verify-fix cycle for measuring and iterating on improvements
- **tdd-discipline** — ensures test suite is maintained through optimization changes
- **spec-first** — performance requirements originate in specs (stack.md, behavior-spec.md)
- **architecture-aware** — structural optimizations require architectural context

## References

See: `references/profiling-checklist.md`
See: `references/optimization-patterns.md`

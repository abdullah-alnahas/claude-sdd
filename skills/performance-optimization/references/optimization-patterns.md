# Optimization Patterns

Prefer structural improvements over micro-optimizations. Ordered by typical impact.

## High Impact (Algorithmic)

- **Better algorithm**: Replace O(n^2) with O(n log n) or O(n)
- **Better data structure**: list → set/dict for lookups, array → heap for priority
- **Eliminate redundant work**: cache expensive computations, memoize pure functions
- **Batch operations**: replace N individual calls with one batch call (DB queries, API requests, file I/O)

## Medium Impact (Architectural)

- **Reduce I/O**: buffer writes, read in chunks, avoid unnecessary disk/network roundtrips
- **Lazy evaluation**: defer expensive computation until actually needed
- **Precomputation**: compute once at init instead of on every call
- **Connection pooling**: reuse expensive resources (DB connections, HTTP clients)

## Low Impact (Micro)

- **Loop optimization**: move invariants outside loops, use generators for large sequences
- **String building**: use join/buffer instead of concatenation in loops
- **Avoid unnecessary copies**: pass by reference where safe, use views/slices

## Anti-Patterns (Convenience Bias)

These look like optimizations but are fragile or misleading:

- **Input-specific shortcuts**: fast for one input, no help (or slower) for others
- **Premature caching**: cache without invalidation strategy — trades speed for correctness risk
- **Parallelism without need**: adds complexity when the bottleneck is algorithmic, not CPU
- **Removing safety checks**: faster but introduces silent corruption risk

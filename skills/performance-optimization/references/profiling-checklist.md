# Profiling Checklist

Before optimizing, confirm you have:

## 1. Reproducible Workload
- [ ] A concrete script/command that demonstrates the slowness
- [ ] Input data that triggers the slow path
- [ ] Expected vs actual runtime

## 2. Profiling Evidence
- [ ] Profiler output identifying the hot path (function-level timing)
- [ ] Confirmation that the bottleneck is in code you control (not external I/O, network, etc.)
- [ ] If I/O-bound: evidence of unnecessary or redundant I/O operations

## 3. Baseline Measurement
- [ ] Exact timing of the current implementation on the workload
- [ ] Multiple runs to confirm consistency (not a fluke)
- [ ] Environment noted (machine, load, relevant config)

## Common Profiling Tools by Language

| Language | Profiling | Timing |
|----------|-----------|--------|
| Python | cProfile, py-spy, line_profiler | timeit, time.perf_counter |
| JavaScript | Chrome DevTools, node --prof | console.time, performance.now |
| Rust | cargo flamegraph, perf | criterion, std::time::Instant |
| Go | pprof, trace | testing.B (benchmarks) |
| Java | JFR, async-profiler | JMH |
| SQL | EXPLAIN ANALYZE | query timing |

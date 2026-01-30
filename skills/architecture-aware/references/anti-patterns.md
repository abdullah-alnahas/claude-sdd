# Architectural Anti-Patterns

## 1. Direct DB Coupling Across Boundaries
**Problem**: Service A queries Service B's database directly.
**Why it's bad**: Changes to B's schema break A. No encapsulation.
**Fix**: B exposes an API. A calls the API.

## 2. Mega Object / Mega Module
**Problem**: One module/class does everything.
**Why it's bad**: Impossible to understand, test, or modify safely.
**Fix**: Extract cohesive responsibilities into focused modules.

## 3. Distributed Monolith
**Problem**: Microservices that must be deployed together and share everything.
**Why it's bad**: All the complexity of distributed systems with none of the benefits.
**Fix**: Either make them truly independent or merge them back into a monolith.

## 4. Synchronous Chains
**Problem**: A calls B calls C calls D synchronously. Any failure breaks the chain.
**Why it's bad**: Latency multiplies. Availability decreases multiplicatively.
**Fix**: Use async processing. Break the chain with events or queues.

## 5. Missing Correlation IDs
**Problem**: Requests flow through multiple services with no way to trace them.
**Why it's bad**: Debugging production issues becomes nearly impossible.
**Fix**: Generate a correlation ID at the entry point, pass it through all calls.

## 6. Premature Microservices
**Problem**: Splitting into services before understanding domain boundaries.
**Why it's bad**: Wrong boundaries are expensive to fix. Data consistency becomes hard.
**Fix**: Start monolithic. Split when you have clear, proven boundaries.

## 7. Shared Mutable State
**Problem**: Multiple components read/write the same data without coordination.
**Why it's bad**: Race conditions. Inconsistent state. Hard to reproduce bugs.
**Fix**: Single owner per piece of state. Others request changes through the owner.

## 8. Copy-Paste Integration
**Problem**: Duplicating code across services instead of sharing or abstracting.
**Why it's bad**: Bug fixes need to be applied N times. Drift is inevitable.
**Fix**: Shared library for truly shared logic. Accept some duplication for loose coupling.

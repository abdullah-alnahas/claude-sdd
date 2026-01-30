# Integration Patterns

## When to Use Each

### Shared Models / Direct Import
**Use when**: Components are in the same codebase and deployment unit.
**Benefit**: Simple, type-safe, refactorable.
**Risk**: Tight coupling if overused across module boundaries.
**Example**: Importing a `User` type from a shared `types/` directory.

### Event-Driven / Message Passing
**Use when**: Components need loose coupling, async processing, or independent scaling.
**Benefit**: Components evolve independently. Failures are isolated.
**Risk**: Eventual consistency. Harder to debug. Message ordering issues.
**Example**: Publishing `UserCreated` event that multiple consumers handle.

### API Layer (REST/GraphQL/gRPC)
**Use when**: Components are separately deployed or need versioned interfaces.
**Benefit**: Clear contracts. Independent deployment.
**Risk**: Network latency. Serialization overhead. Version management.
**Example**: Frontend calling backend API. Service-to-service communication.

### Shared Database
**Use when**: Multiple components need the same data and are tightly coupled operationally.
**Benefit**: Simple. No sync issues. Transactional consistency.
**Risk**: Schema coupling. Hard to split later. Performance bottlenecks.
**Example**: Two services reading from the same PostgreSQL database.

### File-Based / Batch
**Use when**: Processing is batch-oriented or components have very different lifecycles.
**Benefit**: Simple. Decoupled in time. Easy to inspect/debug.
**Risk**: Stale data. No real-time capability. File format coupling.
**Example**: ETL pipeline reading CSV exports.

## Decision Guide

Ask these questions:
1. Same deployment unit? → Shared models
2. Need real-time? → Events or API
3. Need strong consistency? → API or shared DB
4. Independent teams/deployment? → API with contracts
5. Batch/offline? → File-based

# Test Strategies

## Unit Tests
**Scope**: Single function or class in isolation.
**Speed**: Fast (milliseconds).
**Dependencies**: Mocked/stubbed.
**Use for**: Pure logic, calculations, transformations, validation rules.

## Integration Tests
**Scope**: Multiple components working together.
**Speed**: Medium (seconds).
**Dependencies**: Real (or realistic fakes).
**Use for**: API endpoints, database queries, service interactions, middleware chains.

## End-to-End Tests
**Scope**: Full system from user perspective.
**Speed**: Slow (seconds to minutes).
**Dependencies**: All real.
**Use for**: Critical user journeys, smoke tests, deployment verification.

## Test Doubles

| Type | What it does | When to use |
|------|-------------|-------------|
| **Stub** | Returns canned data | When you need predictable input |
| **Mock** | Verifies interactions | When you need to verify a call was made |
| **Fake** | Working implementation (simplified) | When stubs are too limited (e.g., in-memory DB) |
| **Spy** | Records calls for later assertion | When you want to observe without controlling |

## Guidance

- Prefer stubs over mocks — test behavior, not implementation
- One assertion per test (or one logical assertion)
- Test names describe the behavior, not the method: `test_expired_token_returns_401` not `test_validateToken`
- Co-locate tests with source when possible (`foo.ts` → `foo.test.ts`)
- Don't test private methods — test through the public interface

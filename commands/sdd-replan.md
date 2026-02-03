---
name: sdd-replan
description: Return to plan mode when implementation struggles, preserving context and passing tests
argument-hint: "[problem description]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - EnterPlanMode
---

# /sdd-replan

When implementation is struggling — errors mounting, wrong approach, complexity spiral — stop pushing and replan. "The moment something goes sideways, switch back to plan mode and re-plan."

## Usage

- `/sdd-replan` — Analyze current state and replan
- `/sdd-replan "The caching approach isn't working"` — Focus replan on specific problem

## Behavior

### Step 1: Capture test baseline

Before anything else, establish what currently works:

```bash
# Detect and run test suite (adapt to project)
if [ -f package.json ]; then
  npm test 2>&1
elif [ -f pytest.ini ] || [ -f pyproject.toml ] || [ -f setup.py ]; then
  pytest 2>&1
elif [ -f go.mod ]; then
  go test ./... 2>&1
elif [ -f Cargo.toml ]; then
  cargo test 2>&1
else
  echo "No test framework detected"
fi
```

Record:
- Which tests pass (by name)
- Which tests fail (by name)
- Total count

Output:
```
Baseline captured: 12/15 tests passing

Passing tests:
  test_login, test_logout, test_session, test_token_refresh,
  test_user_create, test_user_update, test_user_delete,
  test_api_auth, test_api_rate_limit, test_api_error,
  test_db_connect, test_db_query

Failing tests:
  test_cache_invalidation, test_cache_ttl, test_concurrent_access
```

**Important**: Track test names, not just counts. A test could start passing while another fails, keeping the count the same but masking a regression.

### Step 2: Analyze current state

Summarize:
1. **What works**: Features/tests that are functioning
2. **What doesn't work**: Current failures, errors, blockers
3. **What's blocked**: Dependencies, unclear requirements, missing information
4. **Complexity signals**: Files touched, lines changed, time spent

If a problem description was provided, focus analysis on that area.

### Step 3: Enter plan mode

Use the `EnterPlanMode` tool (or equivalent mechanism) to switch context.

Output:
```
Entering plan mode...
```

### Step 4: Propose revised approach

Present a new plan that:
- Addresses the identified problems
- Preserves what's working
- Simplifies where possible
- Is explicit about what changes from the original approach

Format:
```
Revised Plan
────────────

Original approach: [brief description]
Problem: [what went wrong]

New approach:
1. [Step 1]
2. [Step 2]
3. [Step 3]

Key changes:
- [Change 1]: [rationale]
- [Change 2]: [rationale]

Preserved:
- [What stays the same]
```

### Step 5: User approval

Wait for user to approve the new plan before proceeding.

### Step 6: Resume with regression protection

After approval, when implementation resumes:
- Re-run test baseline
- If any previously-passing test now fails:
  ```
  ⚠️ REGRESSION: test_foo was passing before replan but now fails

  Options:
  1. Investigate and fix the regression
  2. Accept the regression (test was incorrect)
  3. Revert to pre-replan state
  ```

## Output Format

```
SDD Replan
──────────

Baseline captured: 12/15 tests passing

Current State Analysis
──────────────────────
✓ Working: User authentication, session management
✗ Failing: Cache layer (3 tests failing)
⏸ Blocked: Cache invalidation strategy unclear

Problem focus: "The caching approach isn't working"

Entering plan mode...

Revised Plan
────────────
Original: Redis-based distributed cache with TTL
Problem: TTL logic is complex and race conditions in invalidation

New approach:
1. Simplify to in-memory cache first (prove the interface)
2. Add Redis as a provider behind the interface
3. Handle invalidation at the provider level, not globally

Key changes:
- Provider pattern instead of direct Redis calls
- TTL handled per-provider, not in core logic

Preserved:
- Cache interface (get/set/invalidate)
- Existing passing tests

Approve this plan? [y/n]
```

## Principles

- Never lose passing tests — baseline capture is mandatory
- Simpler is better — replan should reduce complexity, not add it
- Focus on the actual problem — don't replan everything
- Explicit about tradeoffs — what are we gaining/losing?

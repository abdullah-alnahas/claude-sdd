---
name: sdd-challenge
description: Adversarial prompt modes — grill me, prove it works, find the elegant solution
argument-hint: "<grill|prove|elegant>"
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Task
---

# /sdd-challenge

Challenge yourself with rigorous review modes. "Say 'Grill me on these changes and don't make a PR until I pass your test.'"

## Usage

- `/sdd-challenge grill` — Adversarial review: prove you understand the changes
- `/sdd-challenge prove` — Demonstrate that changes work correctly
- `/sdd-challenge elegant` — Scrap and reimplement with elegance
- `/sdd-challenge` or `/sdd-challenge help` — Show available modes

## Modes

### grill — Adversarial Review

"Don't make a PR until you pass my test."

**Behavior:**
1. Identify recent changes (git diff or session context)
2. Enter interrogation mode — ask pointed questions:
   - "Why did you change X instead of Y?"
   - "What happens if Z fails?"
   - "How does this interact with existing feature W?"
   - "What's the performance impact of this change?"
3. Evaluate answers — require specific, evidence-based responses
4. Ask up to 5 questions maximum. Exit conditions:
   - All 5 questions answered satisfactorily → PASS
   - Any answer is clearly wrong or "I don't know" → FAIL
   - User types "done", "stop", or "pass" → End early with verdict
5. Verdict: "PASS — You understand these changes" or "FAIL — Review again before PR"

**Output:**
```
SDD Challenge: Grill Mode
─────────────────────────

Changes detected: src/auth.ts, src/middleware/session.ts

Question 1/5:
You added a token refresh check in the middleware. What happens if the
refresh endpoint is down? Walk me through the error path.

Your answer: _
```

### prove — Behavioral Verification

"Prove to me this works."

**Behavior:**
1. Identify the main branch and current branch
2. Run tests on main branch, capture results
3. Run tests on current branch, capture results
4. Diff the results — what changed?
5. For each behavioral change, explain:
   - What was the old behavior?
   - What is the new behavior?
   - Why is this correct?

**Fallback (no tests):**
- Compare file diffs between branches
- For each changed file, explain the behavioral implications
- Note: "No test suite found — using diff analysis instead"

**Output:**
```
SDD Challenge: Prove Mode
─────────────────────────

Branch comparison: main → feature/token-refresh

Test Results:
  main:    45 pass, 2 fail
  current: 47 pass, 0 fail

Behavioral Changes:
1. test_token_refresh: NEW (was not tested before)
   - New behavior: Tokens auto-refresh when <5min from expiry
   - Correct because: Prevents session interruption

2. test_session_timeout: FIXED (was failing on main)
   - Old behavior: Session expired at exactly TTL
   - New behavior: Session expires at TTL + grace period
   - Correct because: Matches spec requirement AC-AUTH-3

Verdict: Changes are provably correct.
```

### elegant — Fresh Implementation

"Knowing everything you know now, scrap this and implement the elegant solution."

**Behavior:**
1. Analyze current implementation — understand what it's trying to do
2. Identify complexity/smell:
   - Workarounds added during development
   - Accumulated cruft from iteration
   - Over-engineering from uncertainty
3. Propose a fresh, elegant approach:
   - Simpler architecture
   - Fewer moving parts
   - More direct path to the goal
4. Present side-by-side comparison
5. Ask: "Implement the elegant version? [y/n]"

**Output:**
```
SDD Challenge: Elegant Mode
───────────────────────────

Current implementation analysis:
- 3 files, 247 lines
- Cache layer with 4 abstraction levels
- 2 workarounds for edge cases
- Complexity accumulated over 5 iterations

Elegant alternative:
- 2 files, 89 lines
- Direct cache with single provider interface
- Edge cases handled in provider, not core
- 63% less code, same test coverage

Key insight: The abstraction layers were added for "future flexibility"
that never materialized. The provider pattern handles all current cases.

Side-by-side:
┌─────────────────────┬─────────────────────┐
│ Current             │ Elegant             │
├─────────────────────┼─────────────────────┤
│ CacheManager        │ (removed)           │
│ CacheProvider       │ CacheProvider       │
│ CacheStrategy       │ (removed)           │
│ CacheConfig         │ (inlined)           │
│ RedisProvider       │ RedisProvider       │
│ MemoryProvider      │ MemoryProvider      │
└─────────────────────┴─────────────────────┘

Implement the elegant version? [y/n]
```

## Help Output

```
SDD Challenge — Available Modes
───────────────────────────────

grill   — Adversarial review: prove you understand the changes
prove   — Demonstrate that changes work via test comparison
elegant — Scrap accumulated complexity, implement cleanly

Usage: /sdd-challenge <mode>
```

## Principles

- Grill mode is about understanding, not memorization
- Prove mode uses evidence (tests, diffs), not assertions
- Elegant mode respects existing tests — same behavior, simpler code
- All modes are educational — learn from the challenge

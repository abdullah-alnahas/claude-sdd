# Iterative Retrieval Pattern

A disciplined approach for subagents gathering context before acting. Prevents both under-researching (acting on incomplete information) and over-researching (reading everything "just in case").

## The Pattern: DISPATCH → EVALUATE → REFINE → LOOP

```
1. DISPATCH — Send a focused query (search, read, find_symbol)
2. EVALUATE — Is this enough to act? Do I know what I need?
3. REFINE — If not, narrow or broaden the query based on what I learned
4. LOOP — Repeat until confident or max iterations reached
```

## When to Use

- Subagents exploring unfamiliar code before making changes
- Gathering context across multiple files for a review
- Understanding how a feature works before extending it
- Investigating a bug's root cause across layers

## When NOT to Use

- You already know the exact file and symbol
- The task is a single-file edit with clear instructions
- You're running automated checks (tests, lint) — just run them

## Example: Finding Where Auth Is Handled

```
DISPATCH: Search for "authenticate" in src/
EVALUATE: Found 3 files. middleware/auth.ts looks like the entry point.
DISPATCH: Read auth.ts symbols overview
EVALUATE: Has validateToken(), refreshSession(), authMiddleware(). Need to understand validateToken.
DISPATCH: Read validateToken body
EVALUATE: Now I know the auth flow. Sufficient to proceed.
```

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| **Shotgun read** — read every file in the directory | Wastes context window, buries signal in noise | Start narrow, broaden only if needed |
| **Single-shot guess** — read one file and assume that's enough | Misses critical context, produces wrong fixes | Always EVALUATE before acting |
| **Infinite refinement** — keep searching "just one more thing" | Never starts the actual work | Set max iterations (3-5 for context gathering) |
| **Keyword tunnel vision** — only search for one term | Misses related code using different names | Try synonyms, check imports/references |
| **Depth-first rabbit hole** — follow every reference chain to the bottom | Loses sight of the original task | Stay focused on what you need to know for THIS task |

## Integration with Iterative Execution

The retrieval pattern is the **information-gathering phase** that precedes the execution cycle. Use it to:
1. Understand the current state before defining completion criteria
2. Find the spec and acceptance criteria
3. Map the code that needs to change
4. Identify test files and patterns

Then hand off to the main iterative execution cycle: implement → verify → fix gaps → repeat.

## Bounded Retrieval

Always set bounds:
- **Max queries**: 5-8 for context gathering before acting
- **Max depth**: 2-3 levels of reference following
- **Sufficiency check**: After each query, ask "Can I act now?"

The goal is **sufficient context**, not **complete context**. You will never know everything. Act when you know enough.

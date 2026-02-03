# Subagent Patterns

"Append 'use subagents' to any request where you want Claude to throw more compute at the problem." — Claude Code team

## What Are Subagents?

Subagents are independent Claude instances spawned by the Task tool. They:
- Run with their own context window
- Can work in parallel
- Return results to the main agent
- Keep the main context clean and focused

## When to Use Subagents

### Good candidates

| Scenario | Why Subagents Help |
|----------|-------------------|
| Parallel searches | Search multiple directories simultaneously |
| Independent reviews | Run critic + simplifier without polluting main context |
| Large file analysis | Each subagent handles a file, main aggregates |
| Multi-step research | Subagent does deep dive, returns summary |
| Background validation | Run tests while continuing other work |

### Poor candidates

| Scenario | Why Not |
|----------|---------|
| Sequential dependencies | Each step needs previous result |
| Small tasks | Overhead exceeds benefit |
| Context-dependent | Needs full conversation history |
| Interactive work | Requires back-and-forth with user |

## The "Use Subagents" Prompt Pattern

Simply append to any request:

```
Analyze the error handling in src/api/ — use subagents
```

This signals: "Spawn helpers for this, don't do it all in main context."

Claude will:
1. Break the task into independent subtasks
2. Spawn a subagent for each
3. Aggregate results
4. Present summary in main context

## Context Window Management

### The problem

Main context accumulates:
- Conversation history
- File contents read
- Tool outputs
- Intermediate reasoning

Eventually, important context gets pushed out.

### The solution

Offload work to subagents:

```
┌─────────────────────────────────────────────┐
│ Main Agent Context                          │
│ - User conversation                         │
│ - High-level plan                           │
│ - Aggregated results                        │
│                                             │
│ [Clean, focused, room for more]             │
└─────────────────────────────────────────────┘
          │                    │
    ┌─────┴─────┐        ┌─────┴─────┐
    │ Subagent 1│        │ Subagent 2│
    │ - Full    │        │ - Full    │
    │   file A  │        │   file B  │
    │ - Deep    │        │ - Deep    │
    │   analysis│        │   analysis│
    └───────────┘        └───────────┘
```

Subagent context is discarded after returning results.

## Parallel Execution

Launch multiple subagents in one message:

```
[Main agent decides to parallelize]

<Task: Analyze auth module>
<Task: Analyze database module>
<Task: Analyze API module>

[All three run simultaneously]
[Results aggregated]
```

## Permission Routing Pattern

Advanced pattern: Route permission requests through a security check.

```
┌──────────────┐
│ Main Agent   │
│ needs to     │
│ run command  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Security     │
│ Subagent     │
│ (Opus 4.5)   │
│              │
│ Checks:      │
│ - Safe?      │
│ - Scoped?    │
│ - Expected?  │
└──────┬───────┘
       │
  ┌────┴────┐
  │ APPROVE │ → Execute
  │ DENY    │ → Ask user
  └─────────┘
```

Implementation via hook (example pattern — not implemented in SDD):
```bash
# hooks.json
{
  "PreToolUse": {
    "Bash": "scripts/security-check.sh"
  }
}
```

**Note**: This is an aspirational pattern. The security-check.sh script is not included in SDD — implement based on your security requirements.

## Cost and Speed Tradeoffs

| Factor | Subagents | Main Agent |
|--------|-----------|------------|
| Tokens | More total (parallel) | Less total |
| Latency | Lower (parallel) | Higher (sequential) |
| Context | Isolated (clean) | Shared (cluttered) |
| Coherence | May diverge | Consistent |

**Rule of thumb:**
- Tasks > 5 min in main context → Consider subagents
- Tasks that can parallelize → Use subagents
- Tasks needing conversation context → Keep in main

## SDD Agent Types

SDD provides specialized agents via `/sdd-orchestrate`:

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| critic | Find logical errors | Post-implementation review |
| simplifier | Reduce complexity | After critic passes |
| spec-compliance | Verify against spec | Before completion claims |
| security-reviewer | OWASP checks | For auth/input handling code |
| performance-reviewer | Bottleneck analysis | For optimizations |
| planner | Implementation planning | Complex features |

Example orchestration:
```
/sdd-orchestrate feature
# Runs: planner → [implement] → critic → simplifier → spec-compliance
```

## Tips from the CC Team

1. **"Offload to keep context clean"** — Main agent should summarize, not hold everything

2. **"Throw more compute at it"** — Subagents are cheap, context space is precious

3. **"Route permissions through Opus"** — Security subagent auto-approves safe operations

4. **"Parallel everything parallelizable"** — Search, analyze, review — all can parallelize

5. **"Subagent results are summaries"** — Don't return full file contents, return findings

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| Subagent for every task | Overhead exceeds benefit | Only for substantial work |
| Returning full context | Defeats the purpose | Return summaries |
| Sequential subagents | No parallelism benefit | Run in parallel or keep in main |
| Subagent without clear task | Wasted compute | Define specific deliverable |

---
name: sdd-orchestrate
description: Run named agent pipelines with structured handoffs — feature, bugfix, refactor, security, or custom.
argument-hint: "<pipeline> [agent1,agent2,...]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Task
---

# /sdd-orchestrate

Run a named pipeline of agents with structured handoffs. Each agent receives the previous agent's findings and builds on them.

## Usage

- `/sdd-orchestrate feature` — Full feature review pipeline
- `/sdd-orchestrate bugfix` — Bug-focused pipeline
- `/sdd-orchestrate refactor` — Refactoring review pipeline
- `/sdd-orchestrate security` — Security-focused pipeline
- `/sdd-orchestrate custom agent1,agent2,...` — User-specified agent sequence

## Named Pipelines

| Pipeline | Agent Sequence | Focus |
|----------|---------------|-------|
| **feature** | spec-compliance → planner → critic → security-reviewer | Complete feature validation |
| **bugfix** | critic → spec-compliance → simplifier | Find root cause, check spec, simplify fix |
| **refactor** | simplifier → critic → spec-compliance | Simplify, verify correctness, check spec |
| **security** | security-reviewer → critic → simplifier | Security first, then correctness, then cleanup |

### custom

Specify agents as a comma-separated list:
```
/sdd-orchestrate custom critic,simplifier,performance-reviewer
```

Available agents: `critic`, `simplifier`, `spec-compliance`, `security-reviewer`, `performance-reviewer`, `planner`

## Handoff Format

Each agent produces a structured handoff:

```
## Agent: <name>

### Findings
[Structured findings from this agent]

### Handoff
[Key information the next agent needs]

### Status: PASS | FAIL | NEEDS-ATTENTION
```

## Pipeline Behavior

1. Run each agent in sequence
2. Pass previous agent's findings as context to the next agent
3. **On FAIL**: Pause the pipeline and ask the user:
   - Fix issues and re-run from the failed agent
   - Continue to the next agent anyway
   - Abort the pipeline
4. After all agents complete, produce a summary

## Summary Output

```
SDD Orchestrate — feature pipeline
────────────────────────────────────

  ✓ spec-compliance ............... PASS
  ✓ planner ....................... PASS (spec-compliance findings applied)
  ✗ critic ........................ FAIL (2 critical issues)
  ⊘ security-reviewer ............ SKIPPED (pipeline paused)

Pipeline: PAUSED at critic — 2 critical issues found
Action required: Fix issues before continuing
```

## Agent Prompt Template

When launching each agent, include:

```
You are running as part of an SDD orchestration pipeline.
Pipeline: <pipeline-name>
Your position: Agent <N> of <total>
Previous findings:
<handoff from previous agent, or "First agent — no prior findings">

Extra instructions: $SDD_AGENT_<NAME>_EXTRA (if set)

Your task: <agent's standard task>
Output your findings in the structured handoff format.
```

## References

See agent definitions in `agents/` for each agent's review standards and output format.

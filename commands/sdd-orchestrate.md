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

Available built-in agents: `critic`, `simplifier`, `spec-compliance`, `security-reviewer`, `performance-reviewer`, `planner`

### Using Plugin Agents

Registered plugin agents (from `.sdd-plugins.json`) can be included in custom pipelines using `<plugin>:<agent>` notation:

```
/sdd-orchestrate custom critic,pr-review-toolkit:silent-failure-hunter,simplifier
```

To see available plugin agents, use `/sdd-plugin list`.

When a plugin agent is referenced in a pipeline:
1. Look up the plugin in `.sdd-plugins.json`
2. Read the agent definition from the plugin's `agents/` directory
3. Launch it using the Task tool with the same handoff format as built-in agents
4. The plugin agent receives the same pipeline context (previous findings, position, etc.)

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

## Agent Resolution Order

When resolving an agent name in a pipeline:

1. **Built-in agents**: Check SDD's `agents/` directory first
2. **Plugin agents**: If the name contains `:`, look up `<plugin>:<agent>` in `.sdd-plugins.json` and load from the plugin's `agents/` directory
3. **Ambiguous names**: If a bare name matches both a built-in and plugin agent, prefer the built-in. Use `<plugin>:<agent>` notation to explicitly select the plugin agent.

## References

See agent definitions in `agents/` for each agent's review standards and output format.
See `/sdd-plugin list` for registered plugin agents.

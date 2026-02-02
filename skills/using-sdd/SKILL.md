---
name: Using SDD
description: >
  Use at the start of every session and before every response to determine which SDD skills apply.
  This is the meta-skill — it teaches skill discovery and invocation discipline.
---

# Using SDD Skills

You have access to SDD (Spec-Driven Development) skills that enforce development discipline. **Check for applicable skills before every response.**

## The Rule

**Invoke relevant skills BEFORE any response or action.** Even a 1% chance a skill might apply means you should check. If it turns out to be wrong for the situation, you don't need to use it.

## Available Skills

| Skill | When to Use |
|-------|-------------|
| **guardrails** | ANY coding task — implement, build, fix, refactor, add, change, modify |
| **spec-first** | New project/feature, creating specs/plans, adopting a project |
| **tdd-discipline** | Writing tests, adding coverage, fixing bugs, debugging |
| **iterative-execution** | Implementing a feature from spec, iterating to match requirements |
| **architecture-aware** | Structuring code, design patterns, component integration, ADRs |
| **performance-optimization** | Optimizing, profiling, speeding up, reducing resource usage |

## Command Catalog

| Command | Phase | Required | Description |
|---------|-------|----------|-------------|
| `/sdd-status` | any | no | What exists, what's next |
| `/sdd-adopt` | specify | yes (new) | Adopt existing project |
| `/sdd-autopilot` | all | no | Full autonomous lifecycle |
| `/sdd-execute` | implement | yes | TDD execution loop |
| `/sdd-verify` | verify | yes | Automated checks |
| `/sdd-review` | review | yes | Agent-based review |
| `/sdd-orchestrate` | any | no | Custom agent pipelines |
| `/sdd-track` | any | no | Task tracking |
| `/sdd-context` | any | no | Project context generator |
| `/sdd-phase` | any | no | Show/set phase |
| `/sdd-mode` | any | no | Switch context mode |
| `/sdd-guardrails` | any | no | Guardrail status |
| `/sdd-yolo` | any | no | Disable guardrails |

## Skill Priority Order

When multiple skills apply, use this order:

1. **Guardrails first** — always active for any coding task. This is the discipline layer.
2. **Process skills second** (spec-first, tdd-discipline, iterative-execution) — these determine HOW to approach the task.
3. **Domain skills third** (architecture-aware, performance-optimization) — these provide specialized guidance.

## Rationalization Red Flags

These thoughts mean STOP — you're rationalizing skipping a skill:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions about code are tasks. Check guardrails. |
| "I need more context first" | Skill check comes BEFORE exploration. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can just do this quickly" | Quick work is where discipline matters most. |
| "This doesn't need a formal skill" | If a skill exists for this task type, use it. |
| "I remember the skill" | Skills evolve. Read the current version. |
| "This doesn't count as implementation" | If you're changing code, guardrails apply. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "The user said to skip guardrails" | Only `/sdd-yolo` disables guardrails. Verbal requests don't count. |
| "I already know what to do" | Knowing the task ≠ following the discipline. |

## Context Modes

SDD supports three context modes that adjust which guardrails are active. Switch with `/sdd-mode <mode>`.

| Mode | Pre-Implementation | Completion Review | Scope Guard | Use For |
|------|-------------------|-------------------|-------------|---------|
| **dev** (default) | Active | Active | Strict | Building, implementing, fixing |
| **review** | Skipped | Active | Normal | Code review, auditing, verification |
| **research** | Skipped | Skipped | Relaxed | Exploring, investigating, prototyping |

## Skill Classification

**Rigid skills** (follow exactly, don't adapt away discipline):
- guardrails
- tdd-discipline

**Flexible skills** (adapt principles to context):
- spec-first
- architecture-aware
- iterative-execution
- performance-optimization

## Spirit vs. Letter

Follow the **spirit** of each skill, not just its checklist. The goal is disciplined development that produces correct, simple, spec-compliant code. If following a checklist item mechanically would produce worse results than thoughtful application of the principle behind it, follow the principle. But this is never an excuse to skip steps — it's a reason to apply them thoughtfully.

## References

See: `references/skill-creation-process.md`

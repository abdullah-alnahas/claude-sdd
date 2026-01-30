---
name: sdd-phase
description: Show or set the current development phase
---

# /sdd-phase

Display or change the current SDD development phase. Phases provide context that shapes how guardrails and skills behave.

## Usage

- `/sdd-phase` — Show current phase
- `/sdd-phase <phase-name>` — Set phase

## Phases

| Phase | Name | Focus |
|-------|------|-------|
| **specify** | Specification | Defining what to build (app-description, behavior-spec, stack, architecture, roadmap) |
| **design** | Design | Architecture decisions, integration patterns, ADRs |
| **implement** | Implementation | TDD cycles within iterative execution loops — test first, then minimal code |
| **verify** | Verification | Running full verification suite, spec-compliance checks, security review |
| **review** | Review | Critic + simplifier agents, retrospective |

## Behavior

1. Display the current phase (or "none" if not set)
2. If a phase name is provided, set it
3. Phase context is available to subsequent prompts and skills
4. Phase affects which skills are most relevant:
   - `specify` → spec-first skill
   - `design` → architecture-aware skill
   - `implement` → TDD discipline + iterative execution skills
   - `verify` → iterative execution (verification step)
   - `review` → all agents (critic, simplifier, spec-compliance, security-reviewer)

## Output Format

```
SDD Phase: implement
─────────────────────
Focus: TDD cycles within iterative execution — write tests first, then minimal code to pass

Available skills: tdd-discipline, iterative-execution, guardrails
Available agents: critic, simplifier, spec-compliance, security-reviewer
```

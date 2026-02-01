---
name: sdd-phase
description: Show or set the current development phase
argument-hint: "[specify|design|implement|verify|review]"
allowed-tools:
  - Read
  - Write
  - Bash
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

## Persistence

Phase state is stored in `.sdd-phase` in the project root. This file contains a single word (the phase name). If the file does not exist, phase is "none".

- **Set phase**: Write the phase name to `.sdd-phase`
- **Show phase**: Read `.sdd-phase` (or report "none" if missing)
- **Clear phase**: Delete `.sdd-phase`

## Behavior

1. Read `.sdd-phase` to display the current phase (or "none" if not found)
2. If a phase name is provided, validate it against the known phases and write to `.sdd-phase`
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

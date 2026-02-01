---
name: sdd-mode
description: Switch SDD context mode (dev/review/research). Controls which guardrails are active.
argument-hint: "[dev|review|research]"
allowed-tools:
  - Bash
  - Read
---

# /sdd-mode

Switch the active SDD context mode. Each mode adjusts which guardrails, hooks, and checks are active.

## Usage

- `/sdd-mode` — Show current mode
- `/sdd-mode dev` — Full guardrails (default)
- `/sdd-mode review` — Review/verification focus
- `/sdd-mode research` — Exploration focus, relaxed guardrails

## Modes

| Mode | Pre-Implementation Checkpoint | Completion Review | Scope Guard | Focus |
|------|------------------------------|-------------------|-------------|-------|
| **dev** | Active | Active | Strict | Build correctly — TDD, spec compliance, full discipline |
| **review** | Skipped | Active | Normal | Verify and critique — find issues, check quality |
| **research** | Skipped | Skipped | Relaxed | Explore and understand — read code, trace flows, prototype |

## Behavior

When invoked with an argument:
1. Write `SDD_MODE=<mode>` to `$CLAUDE_ENV_FILE`
2. Read the corresponding context file from `contexts/<mode>.md`
3. Report the mode switch and what changed

When invoked without an argument:
1. Read `$SDD_MODE` (default: `dev`)
2. Report current mode and its settings

## Context Files

Each mode has a context file at `contexts/<mode>.md` that is loaded by the session init hook. These define the behavioral adjustments for that mode. See `.sdd.yaml` to set a default mode per project.

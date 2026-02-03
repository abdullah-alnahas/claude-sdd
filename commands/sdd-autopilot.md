---
name: sdd-autopilot
description: "[DEPRECATED] Use /sdd-execute --auto instead. Full autonomous SDD lifecycle."
argument-hint: "<description or path-to-app-description.md>"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Task
---

# /sdd-autopilot

> **⚠️ DEPRECATED**: This command is deprecated. Use `/sdd-execute --auto <description>` instead for the same functionality with a simpler interface.

Drives the full SDD lifecycle autonomously from a rough app description to verified implementation.

## Usage

- `/sdd-autopilot <description>` — Start from a rough idea (inline text)
- `/sdd-autopilot <path-to-app-description.md>` — Start from an existing app description document

## Behavior

Execute steps sequentially by loading each step file from `commands/sdd-autopilot/`:

1. Read and execute `step-1-specify.md`
2. Read and execute `step-2-design.md`
3. Read and execute `step-3-implement.md`
4. Read and execute `step-4-verify.md`
5. Read and execute `step-5-review.md`

**DO NOT read ahead.** Load each step file only when you are ready to begin that step. Complete each step fully before loading the next.

Announce each phase transition clearly using the transition message defined in each step file.

## Questioning Policy

**Ask when**:
- Technology choice is genuinely ambiguous (greenfield project, multiple equally valid options)
- A behavior spec criterion is contradictory or unclear
- User's description has a critical gap (e.g., no mention of data persistence for a CRUD app)

**Don't ask when**:
- The project context makes the answer obvious (existing package.json → it's JavaScript)
- One option is clearly better for the stated goals
- The decision is easily reversible
- You can infer from conventions in the existing codebase

When you do ask, provide 2-3 concrete options with brief rationale. Don't ask open-ended questions.

## Principles

- Every phase uses the corresponding SDD skill (spec-first, architecture-aware, tdd-discipline, iterative-execution)
- Guardrails remain active throughout (unless `/sdd-yolo` was used)
- Honest completion reporting — never claim done when criteria are unsatisfied
- TDD is the inner discipline at every phase that produces code
- The autopilot is a convenience orchestrator — it follows the same rules as manual phase-by-phase development

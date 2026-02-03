# Behavior Spec: SDD DX Improvement

## Acceptance Criteria

### AC1: Quick-Start Flowchart in README

**Given** a new user reading the README
**When** they reach the "Getting Started" section
**Then** they see a decision flowchart answering "What do I run first?"
**And** the flowchart has ≤3 entry points based on common intents

### AC2: Visible Hook Feedback

**Given** an SDD command-type hook fires (SessionStart, PostToolUse, Stop)
**When** the hook executes
**Then** stderr shows a message like "→ SDD: [action-verb] [object]"
**And** the message is ≤80 characters
**Note** UserPromptSubmit is prompt-type and cannot print to stderr; it is excluded

### AC3: Interactive Setup Wizard

**Given** a user runs `/sdd-init`
**When** the command executes
**Then** it asks these questions (using AskUserQuestion):
  1. "Project type?" — [new/existing] (determines phase)
  2. "Guardrail level?" — [strict/standard/relaxed]
  3. "Default mode?" — [dev/review/research]
**And** generates a minimal `.sdd.yaml` with only non-default values
**And** if `.sdd.yaml` exists, asks "Overwrite or merge?" before proceeding
**And** outputs a summary of what was configured

### AC4: Command Consolidation

**Given** the current 17 commands
**When** the refactoring is complete
**Then** there are ≤12 primary commands (not counting aliases)
**And** each command has a single clear purpose
**And** overlapping commands are merged with deprecation warnings

**Primary commands (12)**:
1. `/sdd-status` — show current state
2. `/sdd-init` — interactive setup (NEW)
3. `/sdd-phase` — show/set phase
4. `/sdd-mode` — show/set mode
5. `/sdd-execute` — TDD execution loop
6. `/sdd-verify` — automated checks (build/test/lint)
7. `/sdd-review` — agent-based review
8. `/sdd-orchestrate` — custom agent pipelines
9. `/sdd-challenge` — adversarial modes
10. `/sdd-context` — project context export
11. `/sdd-track` — task tracking
12. `/sdd-guardrails` — guardrail status/toggle

**Deprecated (with warnings)**:
- `/sdd-adopt` → prints deprecation notice, runs `/sdd-init`
- `/sdd-autopilot` → prints deprecation notice, suggests `/sdd-execute --auto`
- `/sdd-yolo` → kept (escape hatch, not deprecated)
- `/sdd-replan`, `/sdd-learn`, `/sdd-techdebt`, `/sdd-explain` → removed (low usage)

### AC5: Progressive Disclosure

**Given** a new user
**When** they read documentation or run `/sdd-help`
**Then** they see 3-4 "essential" commands first
**And** advanced commands are in a separate section
**And** the distinction is clearly labeled

### AC6: Centralized Concepts Reference

**Given** a user wants to understand an SDD concept (phases, modes, guardrails)
**When** they look for documentation
**Then** there is ONE authoritative file per concept (not scattered across skills)
**And** skill files reference the central doc instead of duplicating

### AC7: Self-Documenting Guardrail Names

**Given** a guardrail fires
**When** feedback is shown
**Then** the name describes the action, not the category
**Example** "checking for spec" not "pre-implementation checkpoint"

## Verification

- [ ] AC1: README contains flowchart with ≤3 entry points
- [ ] AC2: Command-type hooks (3 of 4) print visible feedback to stderr
- [ ] AC3: `/sdd-init` generates config interactively
- [ ] AC4: Command count ≤12 primary + deprecation warnings for removed
- [ ] AC5: `/sdd-help` or README shows essential vs advanced split
- [ ] AC6: Concept docs exist and are referenced (not duplicated)
- [ ] AC7: Hook messages use action-based names

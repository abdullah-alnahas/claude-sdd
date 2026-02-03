# Architecture: SDD DX Improvement

## Overview

This is a documentation and scripting refactor, not an architectural change. The core plugin structure remains unchanged.

## Key Changes

### 1. README Restructure

```
README.md
├── What is SDD? (2 sentences)
├── Quick Start Flowchart (visual decision tree)
├── Essential Commands (3-4 commands)
├── Installation
├── Full Command Reference (collapsed/linked)
└── Configuration
```

### 2. Hook Feedback Pattern

All hooks follow this pattern:
```bash
echo "→ SDD: [action-verb] [object]" >&2
```

Examples:
- `→ SDD: checking spec exists`
- `→ SDD: reviewing scope (10 files modified)`
- `→ SDD: completion review triggered`

### 3. Command Structure (After Consolidation)

**Essential (4 commands)** — what new users need:
- `/sdd-status` — show current state, what to do next
- `/sdd-init` — interactive setup (NEW)
- `/sdd-execute` — TDD execution loop (the main workflow)
- `/sdd-verify` — automated checks (build/test/lint)

**Standard (5 commands)** — regular workflow:
- `/sdd-phase` — show/set development phase
- `/sdd-mode` — show/set context mode
- `/sdd-review` — agent-based code review
- `/sdd-track` — task tracking
- `/sdd-guardrails` — guardrail status/toggle

**Advanced (3 commands)** — power users:
- `/sdd-orchestrate` — custom agent pipelines
- `/sdd-challenge` — adversarial modes
- `/sdd-context` — project context export

**Deprecated (with warnings)**:
- `/sdd-adopt` → deprecation notice, redirects to `/sdd-init`
- `/sdd-autopilot` → deprecation notice, suggests `/sdd-execute --auto`

**Removed** (low usage, can be done via other commands):
- `/sdd-replan` → use `/sdd-phase design` instead
- `/sdd-learn` → edit CLAUDE.md directly
- `/sdd-techdebt` → use `/sdd-review` with techdebt focus
- `/sdd-explain` → use Claude directly

### 4. Progressive Disclosure Layers

```
Layer 1 (New User): 3 essential commands
    ↓
Layer 2 (Regular User): +4 standard commands
    ↓
Layer 3 (Power User): +3 advanced commands
```

### 5. Centralized Concepts

```
references/
├── concepts/
│   ├── phases.md      — The 5 phases explained
│   ├── modes.md       — dev/review/research modes
│   ├── guardrails.md  — All guardrails in one place
│   └── commands.md    — Command quick reference
```

Skills reference these instead of duplicating.

## Design Decisions

### ADR-001: Deprecate with Warnings, Don't Silent Alias

**Decision**: Deprecated commands print a warning and suggest the replacement, then execute. Removed commands print an error with alternatives.

**Rationale**: Silent aliases hide breaking changes. Users need to know their workflow is changing so they can update scripts and muscle memory. Deprecation warnings are annoying but honest.

### ADR-002: Hook Feedback is Terse

**Decision**: Hook messages are ≤80 chars, action-focused.

**Rationale**: Verbose messages create noise. Users need to know WHAT happened, not WHY (that's in docs).

# Architecture: SDD Plugin

**Version**: 0.12.0
**Date**: 2026-02-07

## Component Overview

```
┌──────────────────────────────────────────────────────────────┐
│                      User Interface                           │
│  /sdd-execute  /sdd-review  /sdd-plugin  /sdd-orchestrate   │
│  /sdd-init     /sdd-status  /sdd-phase   /sdd-verify  ...   │
└──────────────────────────┬───────────────────────────────────┘
                           │
┌──────────────────────────┼───────────────────────────────────┐
│                    Discipline Layer                            │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────────────┐ │
│  │   Hooks      │  │    Skills     │  │      Contexts       │ │
│  │ SessionStart │  │ guardrails   │  │ dev (full guards)   │ │
│  │ UserPrompt   │  │ spec-first   │  │ review (lite)       │ │
│  │ PostToolUse  │  │ tdd-disc.    │  │ research (minimal)  │ │
│  │ Stop         │  │ iter-exec    │  │                     │ │
│  │              │  │ arch-aware   │  │                     │ │
│  │              │  │ perf-opt     │  │                     │ │
│  │              │  │ using-sdd    │  │                     │ │
│  └─────────────┘  └──────────────┘  └─────────────────────┘ │
└──────────────────────────┬───────────────────────────────────┘
                           │
┌──────────────────────────┼───────────────────────────────────┐
│                     Review Agents                             │
│  critic  simplifier  spec-compliance  security-reviewer      │
│  performance-reviewer  planner                                │
└──────────────────────────┬───────────────────────────────────┘
                           │
┌──────────────────────────┼───────────────────────────────────┐
│                  External Plugins                             │
│  .sdd-plugins.json registry → plugin agents/commands         │
└──────────────────────────────────────────────────────────────┘
```

## Layer Responsibilities

### 1. Commands Layer (User Interface)

Commands are declarative markdown files — they instruct Claude *how* to behave, not executable code. Each command:
- Declares required tools in `allowed-tools`
- Describes behavior in structured markdown
- References skills, agents, and other commands as needed

**Key workflows**:
- `/sdd-execute` — The main loop: identify spec → TDD implementation → holistic verification → fix gaps → repeat
- `/sdd-orchestrate` — Agent pipelines with structured handoffs between agents
- `/sdd-plugin` — Plugin registry management (add, remove, list, run, sync)
- `/sdd-review` — Two-stage review: spec compliance first, then code quality

### 2. Discipline Layer (Hooks + Skills + Contexts)

**Hooks** enforce guardrails automatically at lifecycle events:
- `SessionStart` → Initialize env vars, detect config
- `UserPromptSubmit` → Pre-implementation checkpoint (prompt-based)
- `PostToolUse` → Scope guard on Write/Edit, compaction counter
- `Stop` → Completion review

**Skills** provide methodology guidance, activated by Claude based on task context:
- Rigid skills (guardrails, tdd-discipline) — follow exactly
- Flexible skills (spec-first, architecture-aware, etc.) — adapt to context

**Contexts** control guardrail intensity by mode (dev/review/research).

### 3. Review Agents Layer

Six specialized agents launched via the Task tool. Each has:
- A persona (tone, focus, principles)
- A structured review process
- A standard output format (Critical/Warning/Note)

Agents are composable — `/sdd-orchestrate` chains them with handoffs.

### 4. External Plugins Layer (v0.12.0)

The `.sdd-plugins.json` registry allows SDD to discover and invoke agents/commands from other Claude Code plugins:
- `/sdd-plugin add` scans a plugin and registers its capabilities
- `/sdd-execute --plugins=auto|ask` includes plugin agents in verification
- `/sdd-orchestrate custom` accepts `<plugin>:<agent>` notation

## Data Flow: /sdd-execute

```
User runs /sdd-execute
        │
        ▼
   Find behavior spec → Extract acceptance criteria
        │
        ▼
   ┌─── Execute Loop (max N iterations) ───┐
   │                                        │
   │  1. Implement with TDD (inner loop)    │
   │     └─ Write failing test              │
   │     └─ Minimal code to pass            │
   │     └─ Refactor                        │
   │                                        │
   │  2. Verify holistically                │
   │     └─ Test suite                      │
   │     └─ Type checks / linters           │
   │     └─ SDD agents                      │
   │     └─ Plugin agents (if --plugins)    │
   │                                        │
   │  3. Identify gaps vs. spec criteria    │
   │     └─ If gaps → fix with TDD → repeat │
   │     └─ If done → exit loop             │
   │                                        │
   └────────────────────────────────────────┘
        │
        ▼
   Honest completion report (X/Y criteria met)
```

## Data Flow: Plugin Integration

```
/sdd-plugin add /path/to/plugin
        │
        ▼
   Read plugin.json → Scan agents/ commands/ skills/
        │
        ▼
   Write to .sdd-plugins.json (project root)

/sdd-execute --plugins=auto
        │
        ▼
   Read .sdd-plugins.json → Collect registered plugin agents
        │
        ▼
   Include in verification stack (after built-in agents)

/sdd-orchestrate custom critic,myplugin:myagent,simplifier
        │
        ▼
   Resolve agent names → Built-in from agents/, plugin from registry
        │
        ▼
   Run pipeline with structured handoffs
```

## Key Design Decisions

1. **Declarative commands over code** — Commands are markdown instructions, not executable scripts. Claude interprets them. This makes them easy to write, read, and modify without debugging code.

2. **Hooks for enforcement, skills for guidance** — Hooks fire automatically and can't be skipped (except via `/sdd-yolo`). Skills activate contextually and provide methodology — they guide, hooks enforce.

3. **Project-local plugin registry** — `.sdd-plugins.json` lives in the project root, not globally. Different projects can have different plugin configurations.

4. **Agent composition via orchestrate** — Rather than building monolithic review commands, agents are small and focused. `/sdd-orchestrate` composes them into pipelines. Plugin agents slot into the same model.

5. **Three-tier guardrail intensity** — Dev mode (full), review mode (lite), research mode (minimal). Controlled by contexts, not by disabling individual hooks.

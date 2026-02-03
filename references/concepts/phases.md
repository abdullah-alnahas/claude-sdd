# SDD Development Phases

SDD organizes work into five phases. Each phase has a purpose and recommended commands.

## The Phases

```
specify → design → implement → verify → review
```

| Phase | Purpose | Key Commands |
|-------|---------|--------------|
| **specify** | Define WHAT to build | `/sdd-init`, `/sdd-status` |
| **design** | Plan HOW to build it | `/sdd-execute` (generates architecture) |
| **implement** | Build with TDD | `/sdd-execute` |
| **verify** | Automated checks | `/sdd-verify` |
| **review** | Agent-based review | `/sdd-review` |

## Phase Flow

### 1. Specify

Create foundation documents:
- `app-description.md` — What are we building?
- `behavior-spec.md` — Given-When-Then acceptance criteria
- `stack.md` — Technology choices

### 2. Design

Create architecture documents:
- `architecture.md` — System structure, patterns
- `roadmap.md` — Implementation order
- ADRs for non-obvious decisions

### 3. Implement

Build the system using TDD:
- Write failing tests first
- Write minimal code to pass
- Refactor

### 4. Verify

Run automated checks:
- Build (`npm run build`, `cargo build`, etc.)
- Type checks
- Lint
- Tests
- Security scans

### 5. Review

Agent-based code review:
- Stage 1: Spec compliance
- Stage 2: Code quality

## Setting Phase

```
/sdd-phase design    # Set to design phase
/sdd-phase           # Show current phase
```

## Phase vs Mode

- **Phase** = where you are in the development lifecycle
- **Mode** = which guardrails are active

They are independent. You can be in "implement" phase with "review" mode (implementing while auditing).

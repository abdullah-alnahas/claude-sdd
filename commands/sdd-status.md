---
name: sdd-status
description: Show project SDD status — what exists, what's missing, and what to do next.
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
---

# /sdd-status

Scan the project and report what SDD artifacts exist, what's missing, and recommend the next action.

## Usage

- `/sdd-status` — Show full project status

## Behavior

1. **Scan for specs** — Look in `$SDD_SPEC_DIR` (default `specs/`) for: `app-description.md`, `behavior-spec.md`, `stack.md`, `architecture.md`, `roadmap.md`
2. **Scan for tests** — Look in `$SDD_TEST_DIR` (if set) or common test directories (`tests/`, `test/`, `__tests__/`, `spec/`)
3. **Scan for config** — Check for `.sdd.yaml`, `.sdd-phase`, `status.yaml`
4. **Detect phase** — Read `.sdd-phase` if it exists, otherwise infer from what artifacts are present
5. **Report** — List what exists and what's missing
6. **Recommend** — Suggest the next command based on current state

## Phase Inference

If no `.sdd-phase` file exists, infer phase from artifacts:

| Artifacts Present | Inferred Phase |
|-------------------|---------------|
| Nothing | `specify` — Start with `/sdd-adopt` or `/sdd-autopilot` |
| app-description only | `specify` — Continue spec work |
| behavior-spec + stack | `design` — Create architecture and roadmap |
| architecture + roadmap | `implement` — Start `/sdd-execute` |
| Implementation + tests | `verify` — Run `/sdd-verify` |
| Verification passed | `review` — Run `/sdd-review` |

## Output Format

```
SDD Status
──────────

Phase: implement (from .sdd-phase)
Config: .sdd.yaml found

Specs:
  ✓ app-description.md
  ✓ behavior-spec.md (5 acceptance criteria)
  ✓ stack.md
  ✓ architecture.md
  ✗ roadmap.md — MISSING

Tests:
  ✓ test/ directory (12 test files)

Tracking:
  ✗ status.yaml — not found

Recommended next action:
  → Create specs/roadmap.md or run /sdd-autopilot to generate it
```

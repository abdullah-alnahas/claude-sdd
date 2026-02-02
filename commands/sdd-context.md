---
name: sdd-context
description: Generate a single LLM-optimized markdown document summarizing the project — specs, architecture, status, and file structure.
argument-hint: "[--output <path>]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Write
---

# /sdd-context

Generate a comprehensive project context document optimized for LLM consumption. Useful for onboarding new sessions or sharing project state.

## Usage

- `/sdd-context` — Output context to stdout
- `/sdd-context --output <path>` — Write context to a file

## Behavior

1. **Read project identity** — `$SDD_PROJECT_NAME`, `.sdd.yaml`, `package.json`, `pyproject.toml`, `Cargo.toml`
2. **Read specs** — Scan `$SDD_SPEC_DIR` for `app-description.md`, `behavior-spec.md`, `stack.md`, `architecture.md`, `roadmap.md`
3. **Read codebase structure** — Top-level directory listing, key source directories
4. **Read status** — `status.yaml`, `.sdd-phase`
5. **Assemble** — Generate single markdown document

## Output Format

```markdown
# Project Context: [Project Name]

## Stack
[From stack.md or inferred from config files]

## Architecture Summary
[Key components and patterns from architecture.md]

## Current Phase
[From .sdd-phase or inferred]

## Key Specs
### Acceptance Criteria
[From behavior-spec.md]

### Roadmap
[From roadmap.md — item list with status]

## File Structure
[Top-level tree with key directories annotated]

## Active Tasks
[From status.yaml if present]
```

## Principles

- Keep output concise — summarize, don't copy entire files
- Focus on what an LLM needs to continue work: what the project does, how it's structured, what's done, what's next
- If a section has no data (e.g., no status.yaml), note it as "Not configured" rather than omitting

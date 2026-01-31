---
name: sdd-adopt
description: Adopt an existing project into the SDD discipline system
argument-hint: ""
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
---

# /sdd-adopt

Scan an existing codebase, infer its structure and conventions, and wrap SDD discipline around it for future development.

## Usage

- `/sdd-adopt` — Adopt the current project

## Behavior

1. **Scan** the project directory:
   - Package managers: `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `pom.xml`
   - Config files: linter configs, `tsconfig.json`, `Dockerfile`, CI configs
   - Directory structure: `src/`, `lib/`, `tests/`, `docs/`
   - Framework indicators: `next.config.js`, `manage.py`, `main.go`, etc.

2. **Infer** from what's found:
   - Language(s) and version
   - Framework and patterns
   - Build system and test framework
   - Project type (web app, API, CLI, library)

3. **Confirm** with the user:
   - Present inferences for review
   - Accept corrections without argument

4. **Generate** retroactive foundation documents:
   - `specs/app-description.md` — from README + user input
   - `specs/architecture.md` — from directory structure and patterns
   - `specs/stack.md` — from dependencies and config

5. **Create** `.sdd.yaml` with sensible defaults for the detected stack

6. **Continue** — future work follows SDD discipline (spec-first, TDD, guardrails)

## What This Does NOT Do

- Restructure the existing codebase
- Add tests for existing untested code
- Change existing patterns or conventions
- Audit or critique past decisions

The goal is to wrap discipline around **future** work, not judge the past.

## Output Format

```
SDD Project Adoption
────────────────────

Detected:
  Language:   TypeScript 5.x
  Framework:  Next.js 14 (App Router)
  Tests:      Jest + React Testing Library
  Build:      npm / next build
  Structure:  Feature-based (src/features/*)

Is this accurate? (Correct anything that's wrong)

[After confirmation]

Generated:
  ✓ specs/app-description.md
  ✓ specs/architecture.md
  ✓ specs/stack.md
  ✓ .sdd.yaml

Project adopted. SDD guardrails are now active for new development.
```

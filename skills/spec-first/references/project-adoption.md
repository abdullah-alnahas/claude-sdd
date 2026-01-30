# Project Adoption Flow

## Purpose

Wrap SDD discipline around an existing codebase that wasn't created with this plugin.

## Steps

### 1. Scan
Examine the project directory:
- Package managers: `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `pom.xml`, `build.gradle`
- Config files: `.eslintrc`, `tsconfig.json`, `.prettierrc`, `Makefile`, `Dockerfile`
- Directory structure: `src/`, `lib/`, `tests/`, `docs/`, `scripts/`
- Framework indicators: `next.config.js`, `vite.config.ts`, `manage.py`, `main.go`

### 2. Infer
From the files found, determine:
- **Language(s)**: Primary and secondary
- **Framework**: Web framework, CLI framework, library
- **Build system**: npm, cargo, make, etc.
- **Test framework**: jest, pytest, cargo test, etc.
- **Patterns**: MVC, layered, hexagonal, etc.
- **Project type**: Web app, API, CLI tool, library, etc.

### 3. Confirm
Present inferences to the user:
> "Based on scanning the project, I see:
> - **Language**: TypeScript
> - **Framework**: Next.js 14 (App Router)
> - **Tests**: Jest + React Testing Library
> - **Patterns**: Feature-based directory structure with shared components
>
> Is this accurate? Anything I'm missing?"

Accept corrections. Don't argue about the user's own project.

### 4. Generate
Create retroactive foundation documents:
- `app-description.md` — Based on README, package.json description, and user input
- `architecture.md` — Based on directory structure and patterns observed
- `stack.md` — Based on dependencies and config files

Store in `specs/` (or user's preferred location).

### 5. Continue
From here, the project is treated as if it was created with SDD:
- New features go through the spec-first process
- Guardrails apply to all implementation
- Tests are expected for new code
- Architecture decisions get ADRs

## What NOT to Do During Adoption

- Don't restructure the existing codebase
- Don't add missing tests for existing code (unless asked)
- Don't change existing patterns to match SDD preferences
- Don't create docs for features that already work fine
- The goal is to wrap discipline around future work, not audit the past

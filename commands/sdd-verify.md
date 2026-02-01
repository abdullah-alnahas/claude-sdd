---
name: sdd-verify
description: Run automated verification checks — build, types, lint, tests, security scans. Distinct from /sdd-review (agent-based).
argument-hint: "[quick|full|pre-commit|pre-pr]"
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
  - Task
---

# /sdd-verify

Run automated verification checks against the codebase. This is the **automated checks** complement to `/sdd-review` (which uses agent-based analysis).

## Usage

- `/sdd-verify` — Run full verification (default)
- `/sdd-verify quick` — Build + type check only
- `/sdd-verify full` — Build + types + lint + test suite + coverage
- `/sdd-verify pre-commit` — Quick + lint + debug statement scan + git status check
- `/sdd-verify pre-pr` — Full + security-reviewer agent + diff review + TODO/secrets scan

## Modes

### quick
Fast feedback loop during development.
1. Build / compile check
2. Type check (tsc, mypy, etc.)

### full (default)
Comprehensive automated verification.
1. Build / compile check
2. Type check
3. Lint (eslint, ruff, etc.)
4. Full test suite
5. Coverage report (if configured)

### pre-commit
Everything needed before committing.
1. All `quick` checks
2. Lint
3. Debug statement scan (`console.log`, `debugger`, `print(`, `TODO`, `FIXME`, `HACK`)
4. Git status — ensure no unintended files staged

### pre-pr
Everything needed before opening a PR.
1. All `full` checks
2. Launch **security-reviewer** agent on changed files
3. Diff review — scan for TODO, FIXME, secrets patterns, hardcoded values
4. Generate summary

## Output Format

```
SDD Verify — [mode]
───────────────────

  ✓ Build .......................... PASS
  ✓ Type check .................... PASS
  ✗ Lint .......................... FAIL (3 errors)
  ✓ Tests ......................... PASS (42/42)
  ✓ Coverage ...................... 87%
  ✗ Debug statements .............. FAIL (2 found)
  ✓ Secrets scan .................. PASS

──────────────────────────────────
Summary: 5/7 passed, 2 failed
Ready for PR: NO
```

## How to Detect Project Tools

1. Check `package.json` for scripts (build, test, lint, typecheck)
2. Check for `Makefile`, `pyproject.toml`, `Cargo.toml`, `go.mod`
3. Check for config files (`.eslintrc`, `tsconfig.json`, `ruff.toml`, `mypy.ini`)
4. If no tools detected, report what's missing and skip those checks

## Difference from /sdd-review

| | /sdd-verify | /sdd-review |
|---|---|---|
| **Type** | Automated checks | Agent-based analysis |
| **Speed** | Fast (runs tools) | Slower (launches agents) |
| **Finds** | Build errors, type errors, lint issues, test failures | Logic errors, spec drift, unnecessary complexity |
| **When** | During development, before commit/PR | After implementation, before merge |

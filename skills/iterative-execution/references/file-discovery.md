# File Discovery Pattern

Systematic approach to locating project artifacts. Use `$SDD_SPEC_DIR` and `$SDD_TEST_DIR` when available, fall back to common conventions.

## Strategy: Narrow First, Broaden on Miss

1. Check environment variables first (`$SDD_SPEC_DIR`, `$SDD_TEST_DIR`)
2. Try project-specific conventions
3. Broaden to common patterns
4. Report what was found and what's missing

## Spec Discovery

```
# If SDD_SPEC_DIR is set:
$SDD_SPEC_DIR/**/*.md

# Common locations:
specs/**/*.md
spec/**/*.md
docs/specs/**/*.md
```

## Test Discovery

```
# If SDD_TEST_DIR is set:
$SDD_TEST_DIR/**/*

# JavaScript/TypeScript:
**/__tests__/**/*.{test,spec}.{js,ts,jsx,tsx}
**/*.test.{js,ts,jsx,tsx}
**/*.spec.{js,ts,jsx,tsx}
test/**/*.{js,ts}
tests/**/*.{js,ts}

# Python:
tests/**/*.py
test/**/*.py
**/test_*.py
**/*_test.py

# Rust:
**/tests/**/*.rs
src/**/mod.rs (inline #[cfg(test)])

# Go:
**/*_test.go
```

## Architecture Discovery

```
specs/architecture.md
docs/architecture.md
docs/adr/**/*.md
ARCHITECTURE.md
```

## Config Discovery

```
.sdd.yaml
.sdd-phase
status.yaml
package.json
pyproject.toml
Cargo.toml
go.mod
Makefile
```

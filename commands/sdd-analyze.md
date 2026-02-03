---
name: sdd-analyze
description: Cross-artifact consistency checker — finds gaps between specs, tests, and architecture without LLM calls
user_invocable: true
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
---

# /sdd-analyze

Validates consistency across SDD artifacts using pattern matching. No LLM calls — fast and deterministic.

## Usage

```
/sdd-analyze              # Analyze all specs
/sdd-analyze specs/001-*  # Analyze specific feature
```

## What It Checks

### 1. Spec Coverage

Find acceptance criteria (AC1, AC2, etc.) in spec files, then search for references in test files.

```bash
# Pseudo-logic:
grep -r "AC[0-9]" specs/ → list of criteria
grep -r "AC[0-9]" tests/ → list of test references
compare → gaps and orphans
```

### 2. Architecture-Roadmap Alignment

Check that architecture.md components appear in roadmap.md.

### 3. Orphan Detection

Find test files that don't reference any spec criteria.

## Output Format

```
SDD Artifact Analysis
─────────────────────

Spec Criteria Found: 12

Gaps (criteria without test references):
  ⚠ AC3 (specs/001-auth/behavior-spec.md) — no test reference found
  ⚠ AC7 (specs/002-api/behavior-spec.md) — no test reference found

Orphans (test files without criteria references):
  ⚠ tests/legacy_handler_test.py — references no AC identifiers

Architecture Components: 5
Roadmap Items: 8
Unmatched Components: 0

Summary: 2 gaps, 1 orphan, 0 unmatched
```

## Limitations

This command uses grep/regex only. It cannot detect:
- Semantic mismatches (spec says X, test checks Y)
- Naming inconsistencies (camelCase vs snake_case)
- Logic errors in test implementation

For deeper analysis, use `/sdd-review` which invokes agents.

## Implementation

1. Glob for `**/behavior-spec.md` files
2. Extract AC identifiers with regex: `AC[0-9]+`
3. Glob for test files (`*_test.*`, `test_*.*`, `*.spec.*`, `*.test.*`)
4. Search test files for AC references
5. Report gaps (criteria not in tests) and orphans (tests without criteria)
6. If architecture.md exists, extract component names
7. If roadmap.md exists, check component coverage

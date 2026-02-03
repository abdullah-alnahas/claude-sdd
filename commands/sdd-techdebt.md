---
name: sdd-techdebt
description: Scan for duplicated code, dead code, TODO/FIXME comments, and long functions
argument-hint: "[path] [--fix]"
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Write
  - Edit
---

# /sdd-techdebt

Scan the codebase for technical debt. "Build a /techdebt slash command and run it at the end of every session to find and kill duplicated code."

## Usage

- `/sdd-techdebt` — Full scan of project
- `/sdd-techdebt src/` — Scan specific directory
- `/sdd-techdebt --fix` — Scan and offer to fix issues

## Categories Scanned

### 1. TODO/FIXME/HACK Comments (High Severity)

Search for debt markers in code:

```
Grep for: TODO|FIXME|HACK|XXX|TEMP|WORKAROUND
```

### 2. Long Functions (Medium Severity)

Functions exceeding 50 lines. Detection approach:

```bash
# Count lines between function start and end patterns
# Language-specific patterns apply
```

### 3. Duplicated Code Blocks (Medium Severity)

Blocks of 10+ similar lines appearing multiple times. Detection approach:
- Use simple text-based comparison (not AST-based)
- Normalize: strip leading whitespace, remove empty lines
- Sliding window of N lines, hash and compare
- Report blocks appearing 2+ times with >85% similarity

**Limitation**: This is heuristic-based and may produce false positives for common patterns (imports, boilerplate). For precise duplicate detection, use specialized tools like jscpd, PMD-CPD, or SonarQube.

### 4. Unused Imports (Low Severity)

Imports that don't appear in the rest of the file:

```
Grep for: import/require statements
Cross-reference with usage in file
```

### 5. Dead Exports (Low Severity)

Exported functions/classes with no references:

```
Find: export statements
Cross-reference: no imports of that symbol elsewhere
```

**Limitation**: May produce false positives for:
- Library public APIs (used by external consumers)
- Dynamic imports (`import()` expressions)
- Framework magic (Next.js page exports, etc.)
- Test utilities imported only by test files

Review findings manually before removing "dead" exports.

## Behavior

### Step 1: Determine scope

- If path argument provided, scan only that path
- Otherwise, scan from project root
- Respect `.gitignore` patterns

### Step 2: Run scans

Execute each category scan in sequence. For each finding:

```
{
  category: "TODO/FIXME",
  severity: "High",
  file: "src/auth.ts",
  line: 42,
  preview: "// TODO: handle token expiration",
  suggestion: "Implement token refresh logic or remove if no longer needed"
}
```

### Step 3: Report findings

Group by category, sort by severity within category.

```
SDD Tech Debt Scan
──────────────────

Scanned: 47 files in src/

TODO/FIXME/HACK (High) — 3 found
  src/auth.ts:42      TODO: handle token expiration
  src/cache.ts:15     FIXME: race condition here
  src/api.ts:203      HACK: temporary workaround for rate limiting

Long Functions (Medium) — 2 found
  src/parser.ts:89    parseDocument() — 73 lines
  src/validator.ts:12 validateSchema() — 58 lines

Duplicated Code (Medium) — 1 found
  src/handlers/user.ts:20-35 ≈ src/handlers/admin.ts:25-40
  (15 lines, 92% similar)

Unused Imports (Low) — 4 found
  src/utils.ts:3      import { format } from 'date-fns'
  src/config.ts:1     import * as path from 'path'
  ...

Summary: 10 issues (3 High, 3 Medium, 4 Low)
```

### Step 4: Fix mode (if --fix)

For each category with findings, offer to fix:

```
Fix TODO/FIXME items? [y/n/select]
  - y: Address all (will prompt for each)
  - n: Skip category
  - select: Choose specific items

[If y or select]
For: src/auth.ts:42 — TODO: handle token expiration

Options:
1. Implement the TODO (describe what to do)
2. Remove the comment (it's obsolete)
3. Convert to GitHub issue and remove
4. Skip

Choice: _
```

After each fix batch:
- Run tests to verify no regressions
- Commit atomically if requested

## Output Format (No Issues)

```
SDD Tech Debt Scan
──────────────────

Scanned: 47 files in src/

No significant tech debt found. Codebase is clean.
```

## Thresholds

Default thresholds (configurable via `.sdd.yaml`):

```yaml
techdebt:
  duplicate_min_lines: 10    # Min lines to consider duplicate
  max_function_lines: 50     # Lines before "long function"
  similarity_threshold: 0.85 # % similarity for duplicates
```

## Principles

- Non-destructive by default — `--fix` is opt-in
- Respect existing patterns — don't flag intentional duplication
- Actionable findings only — skip trivial issues
- TDD for fixes — run tests after each change

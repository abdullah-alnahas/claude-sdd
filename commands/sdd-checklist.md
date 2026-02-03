---
name: sdd-checklist
description: Generate custom validation checklists tailored to project patterns
user_invocable: true
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
---

# /sdd-checklist

Generate markdown checklists customized to the project's actual files and patterns.

## Usage

```
/sdd-checklist pre-commit       # Before committing
/sdd-checklist pre-pr           # Before creating PR
/sdd-checklist feature-complete # After implementing feature
/sdd-checklist security         # Security-focused review
/sdd-checklist performance      # Performance-focused review
```

## Checklist Types

### pre-commit

Basic checks before committing:
- [ ] Build passes (`[detected build command]`)
- [ ] Type checks pass (`[detected type checker]`)
- [ ] Lint passes (`[detected linter]`)
- [ ] No debug statements (console.log, print, debugger)
- [ ] No TODO/FIXME in changed files
- [ ] Tests pass for changed files

### pre-pr

Extended checks before PR:
- [ ] All pre-commit checks pass
- [ ] No secrets in code (API keys, passwords)
- [ ] Security scan passes (`[detected scanner]`)
- [ ] Documentation updated if needed
- [ ] CHANGELOG updated (if exists)
- [ ] Branch is up to date with main

### feature-complete

Full feature validation:
- [ ] All acceptance criteria verified
- [ ] Tests cover all ACs
- [ ] No dead code introduced
- [ ] Architecture document reflects changes
- [ ] Roadmap item marked complete

### security

Security-focused review:
- [ ] Input validation on all endpoints
- [ ] Authentication required where needed
- [ ] Authorization checks in place
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] Sensitive data encrypted
- [ ] Audit logging for sensitive operations

### performance

Performance-focused review:
- [ ] No N+1 queries
- [ ] Appropriate caching in place
- [ ] No synchronous blocking operations
- [ ] Resource cleanup (connections, files)
- [ ] Pagination for list endpoints
- [ ] Benchmarks run and documented

## Customization

The checklist detects project patterns:

| Detection | Customization |
|-----------|---------------|
| `package.json` with `jest` | Adds "npm test" to test command |
| `pyproject.toml` with `pytest` | Adds "pytest" to test command |
| `.eslintrc*` exists | Adds "npm run lint" to lint command |
| `Dockerfile` exists | Adds "docker build" check |
| `specs/` exists | Adds spec criteria verification |

## Output

Generates a markdown file:

```markdown
# Pre-Commit Checklist

Generated for: my-project
Date: 2024-01-15

## Build & Quality
- [ ] `npm run build` passes
- [ ] `npm run lint` passes
- [ ] `npm test` passes

## Code Hygiene
- [ ] No console.log statements
- [ ] No TODO comments in changed files
- [ ] No debugger statements

## Ready to Commit
- [ ] All above checks pass
- [ ] Commit message follows convention
```

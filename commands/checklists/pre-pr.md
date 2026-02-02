# Pre-PR Checklist

Run before opening a pull request. Includes all pre-commit checks plus additional rigor.

- [ ] **Build** — Project compiles/builds without errors
- [ ] **Type check** — No type errors
- [ ] **Lint** — No lint errors
- [ ] **Tests** — Full test suite passes
- [ ] **Coverage** — Coverage meets project threshold (if configured)
- [ ] **Security scan** — Run **security-reviewer** agent on changed files
- [ ] **Secrets scan** — No hardcoded secrets, API keys, passwords, or tokens in diff
- [ ] **TODO scan** — No unresolved `TODO`, `FIXME`, `HACK`, `XXX` in changed files
- [ ] **Diff review** — Review full diff for unintended changes, dead code, debug artifacts
- [ ] **Debug statements** — No `console.log`, `debugger`, `print(` in changed files
- [ ] **Git status** — Clean working tree, no untracked files

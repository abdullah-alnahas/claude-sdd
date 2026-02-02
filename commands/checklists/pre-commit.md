# Pre-Commit Checklist

Run before committing code changes.

- [ ] **Build** — Project compiles/builds without errors (`npm run build`, `cargo build`, `go build`, etc.)
- [ ] **Type check** — No type errors (`tsc --noEmit`, `mypy`, etc.)
- [ ] **Lint** — No lint errors (`eslint`, `ruff`, `clippy`, etc.)
- [ ] **Debug statements** — No `console.log`, `debugger`, `print(`, `TODO`, `FIXME`, `HACK` in staged changes
- [ ] **Git status** — Only intended files are staged; no untracked files accidentally included

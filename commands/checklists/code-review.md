# Code Review Checklist

Used during `/sdd-review` Stage 2 and agent-based reviews.

- [ ] **Spec loaded** — Behavior spec is read and understood before reviewing code
- [ ] **ACs cross-checked** — Each acceptance criterion is traced to implementation and tests
- [ ] **Tests mapped** — Every test maps to a spec criterion; no orphan tests, no untested criteria
- [ ] **Code quality** — No unnecessary complexity, premature abstraction, or dead code
- [ ] **Security** — No injection vulnerabilities, improper input validation, or auth gaps
- [ ] **Error handling** — Errors are handled at system boundaries; no swallowed exceptions
- [ ] **Naming** — Variables, functions, and files have clear, descriptive names
- [ ] **Scope** — Changes are limited to what was requested; no unrelated modifications

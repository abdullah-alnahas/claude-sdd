# Step 4: Verify

**Input**: Implementation from Step 3.

## Actions

Use the two-stage review process (see `/sdd-review`):

**Stage 1 — Spec Compliance:**
1. Run full test suite
2. Invoke **spec-compliance agent** — compare implementation against behavior-spec.md
3. DO NOT trust the implementation report. Read actual code and test output independently.
4. For each acceptance criterion: PASS / FAIL / PARTIAL with evidence
5. Stage 1 must pass before proceeding to Stage 2

**Stage 2 — Code Quality:**
6. Invoke **critic agent** — find logical errors, assumption issues
7. Invoke **simplifier agent** — find unnecessary complexity
8. Invoke **security-reviewer agent** — check for vulnerabilities
9. If performance optimization was part of the spec, invoke **performance-reviewer agent**
10. Collect all findings

## Transition

"Verify phase complete — N findings (X critical, Y high, Z medium). Entering Review phase."

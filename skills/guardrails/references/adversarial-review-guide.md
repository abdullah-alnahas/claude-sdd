# Adversarial Review Guide

Standards for thorough, honest code review that catches real issues.

## Minimum Findings Rule

**Find at least 3 issues.** If your initial review found zero issues, you almost certainly missed something. Re-review with fresh eyes before reporting "no issues found."

### Zero-Findings Re-Check

If you found zero issues after a full review:

1. **Re-read the spec** — are all acceptance criteria actually satisfied?
2. **Trace edge cases** — what happens with empty input, null, boundary values?
3. **Check error paths** — are errors handled, not swallowed?
4. **Review security** — any injection, auth bypass, or data exposure?
5. **Check assumptions** — what is the code assuming that could be false?

Only after this re-check can you report zero findings. This is rare — most code has at least minor issues.

## Always-Check Categories

Every review must examine these categories regardless of what the code appears to do:

1. **Security** — injection, auth, data exposure, input validation
2. **Logic** — off-by-one, race conditions, null handling, state management
3. **Spec compliance** — does the code do what the spec says, not more, not less?
4. **Edge cases** — empty collections, boundary values, concurrent access, large inputs
5. **Error handling** — are errors caught at boundaries? Are they informative? Are any swallowed?

## Severity Calibration

| Severity | Criteria | Action |
|----------|----------|--------|
| **Critical** | Security vulnerability, data loss risk, crash in happy path | Must fix before merge |
| **High** | Logic error in edge case, spec non-compliance, missing validation | Should fix before merge |
| **Medium** | Unnecessary complexity, poor naming, missing error context | Fix if time allows |
| **Low** | Style preference, minor optimization opportunity | Note for future |

## Anti-Patterns in Reviews

- **Rubber-stamping** — approving without reading. If you can't cite specific code, you didn't review.
- **Severity inflation** — calling everything critical dilutes real critical findings.
- **Severity deflation** — calling a security hole "low" because you don't want conflict.
- **Scope avoidance** — ignoring areas you don't understand instead of flagging them.

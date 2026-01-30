# Traceability — Behavior → Test → Code

## Purpose

Every line of code should trace back to a reason. Traceability ensures:
- Nothing is built without a spec
- Nothing specified goes untested
- Nothing tested lacks implementation
- Changes can be assessed for impact

## The Trace Chain

```
Behavior Spec Criterion → Test Case → Implementation Code
```

Example:
```
Spec: "Users can reset their password via email"
  ↓
Test: test_password_reset_sends_email()
Test: test_password_reset_with_invalid_email_returns_error()
Test: test_password_reset_token_expires_after_1_hour()
  ↓
Code: PasswordResetService.initiate()
Code: PasswordResetService.validateToken()
```

## Trace Matrix

For critical features, maintain a trace matrix:

| Spec Criterion | Test(s) | Implementation | Status |
|---------------|---------|----------------|--------|
| User can reset password | `test_password_reset_*` | `PasswordResetService` | Complete |
| Reset token expires in 1h | `test_token_expiry` | `TokenValidator.isValid()` | Complete |
| Invalid email returns error | `test_invalid_email_error` | `PasswordResetService.initiate()` | Complete |

## When to Use Full Traceability

- Safety-critical systems
- Regulatory requirements
- Complex business logic
- Anything where "did we build what was specified?" is a real question

## When Lightweight Tracing Is Fine

- Internal tools
- Prototypes
- Simple CRUD
- Well-understood domains

For lightweight: just ensure test names reference the behavior they verify.

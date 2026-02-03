---
name: sdd-clarify
description: Structured questioning for underspecified requirements — systematically probes edge cases, errors, scale, security
user_invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - AskUserQuestion
---

# /sdd-clarify

Ask systematic questions to clarify underspecified requirements. Answers are appended to the relevant spec.

## Usage

```
/sdd-clarify                     # Clarify current feature spec
/sdd-clarify specs/001-auth/     # Clarify specific feature
/sdd-clarify --topic security    # Focus on security questions
```

## Question Categories

### Edge Cases
- What happens when input is empty, null, or at maximum size?
- What's the behavior for boundary conditions?
- How are concurrent operations handled?

### Error Handling
- What should happen when [operation] fails?
- Should errors be silent, logged, or surfaced to users?
- What's the recovery strategy?

### Scale & Performance
- What's the expected load (requests/sec, concurrent users)?
- Are there latency requirements?
- What data volumes are expected?

### Security
- Who can access this feature? What's the auth model?
- What data is sensitive? How is it protected?
- Are there audit/logging requirements?

### Integration
- What external systems does this interact with?
- What happens if an integration is unavailable?
- Are there API contracts to follow?

## Behavior

1. Read the target spec file
2. Detect project type (web app, CLI, library, API) from context
3. Select relevant question categories
4. Use AskUserQuestion to ask 3-5 questions
5. Append answers to the spec file in a "Clarifications" section

## Output

After clarification:

```markdown
## Clarifications

### Edge Cases (clarified 2024-01-15)
- Empty input: Return 400 Bad Request with validation message
- Maximum size: 10MB file limit, reject larger with 413

### Error Handling (clarified 2024-01-15)
- Database failures: Retry 3x with exponential backoff, then fail with 503
- External API timeout: Use cached response if available, else fail gracefully
```

## Project Type Detection

The command infers project type from:
- `package.json` → Node.js web app or CLI
- `setup.py` / `pyproject.toml` → Python app or library
- `Cargo.toml` → Rust CLI or library
- `go.mod` → Go service
- `Dockerfile` → Containerized service

Questions are tailored to the detected type. CLIs don't get "concurrent users" questions. Libraries don't get "latency requirements" questions.

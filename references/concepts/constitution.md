# Project Constitution

A constitution is a set of immutable principles that govern all development in a project. Inspired by [GitHub's Spec-Kit](https://github.com/github/spec-kit).

## What It Is

The constitution lives at `.sdd/constitution.md` in your project root. It contains:

- **Core Principles**: Non-negotiable rules (e.g., "No secrets in code")
- **Technical Constraints**: Required patterns (e.g., "All APIs must be versioned")
- **Quality Standards**: Minimum bars (e.g., "All public functions must have tests")
- **Conventions**: Naming, structure, dependencies

## How It Works

1. **Session Start**: If constitution exists, it's injected into Claude's context
2. **Pre-Implementation**: Claude checks proposed work against constitution
3. **Completion Review**: Constitution compliance is verified
4. **Edit Warning**: If you edit constitution.md, a warning is shown (not blocked)

## Why Use It

CLAUDE.md is mutable and often contains both principles AND implementation notes. A constitution separates "laws" from "guidelines":

- **Constitution**: Immutable laws that should never be violated
- **CLAUDE.md**: Mutable guidelines and project-specific instructions

## Creating a Constitution

1. Run `/sdd-onboard` and select "Create constitution" when offered
2. Or manually create `.sdd/constitution.md` using the template

Template location: `skills/spec-first/references/templates/constitution.md`

## Example

```markdown
# Project Constitution

## Core Principles

1. **Security First**
   All user input must be validated. No SQL injection, XSS, or command injection.

2. **Backward Compatibility**
   Public APIs never introduce breaking changes without a major version bump.

## Technical Constraints

- All APIs must be versioned (v1, v2, etc.)
- No secrets in code, use environment variables
- Database migrations must be reversible

## Quality Standards

- All public functions must have tests
- No function longer than 50 lines
- All errors must be logged with context
```

## Enforcement

Enforcement is **advisory**, not mechanical. Claude interprets the constitution and flags potential violations. This works because:

- Principles are written in natural language
- Claude understands context and intent
- False positives are better than missed violations

If you want mechanical enforcement (e.g., "no console.log"), use linters instead.

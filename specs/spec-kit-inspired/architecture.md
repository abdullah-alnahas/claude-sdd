# Architecture: Spec-Kit Inspired Enhancements

## Component Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     New Commands                             │
├─────────────────────────────────────────────────────────────┤
│  /sdd-analyze    /sdd-clarify    /sdd-onboard    /sdd-checklist │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                     Updated Commands                         │
├─────────────────────────────────────────────────────────────┤
│  /sdd-execute (--fast flag)    /sdd-init (→ calls onboard)  │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                     Helper Scripts                           │
├─────────────────────────────────────────────────────────────┤
│  new-feature.sh    check-consistency.sh    list-criteria.sh │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                     New Templates                            │
├─────────────────────────────────────────────────────────────┤
│  constitution.md    proposal.md                              │
└─────────────────────────────────────────────────────────────┘
```

## Component Details

### 1. Constitution System

**Location**: `.sdd/constitution.md` (project root)

**Structure**:
```markdown
# Project Constitution

## Immutable Principles
1. [Principle that cannot be violated]
2. [Another principle]

## Conventions
- [Naming conventions]
- [Architecture patterns required]
```

**Integration**:
- Session-init hook checks for constitution
- Guardrails reference constitution in pre-implementation checkpoint
- `/sdd-review` validates against constitution

### 2. Cross-Artifact Analyzer (`/sdd-analyze`)

**Implementation**: Bash script + grep-based validation

**Checks**:
1. **Spec→Test mapping**: Grep for AC identifiers in test files
2. **Architecture→Roadmap mapping**: Check all components have roadmap items
3. **Naming consistency**: Validate file naming follows conventions
4. **Dead references**: Find spec criteria not referenced anywhere

**Output format**:
```
SDD Artifact Analysis
─────────────────────
Gaps (spec criteria without tests):
  ⚠ AC3: User authentication — no test file found

Orphans (tests without spec criteria):
  ⚠ test_legacy_handler.py — no matching AC

Inconsistencies:
  ⚠ specs/auth.md uses "userId", architecture.md uses "user_id"

Coverage: 85% of spec criteria have corresponding tests
```

### 3. Structured Clarification (`/sdd-clarify`)

**Question templates by category**:
- **Edge cases**: "What happens when X is empty/null/maximum?"
- **Error handling**: "How should the system respond when Y fails?"
- **Scale**: "What's the expected load? Concurrent users?"
- **Security**: "Who can access this? What's the auth model?"
- **Integration**: "What systems does this interact with?"

**Flow**:
1. User specifies topic
2. Command asks 3-5 systematic questions
3. Answers appended to relevant spec file
4. Marks spec as "clarified"

### 4. Fast-Forward Mode

**Trigger**: `/sdd-execute --fast <description>`

**Behavior**:
1. Generate ALL planning docs without pausing:
   - `proposal.md`
   - `behavior-spec.md`
   - `stack.md`
   - `architecture.md`
   - `roadmap.md`
2. Present complete plan for review
3. Single approval gate
4. Begin implementation

**Difference from standard**:
- Standard: 5 pause points (after each doc)
- Fast: 1 pause point (after all docs)

### 5. Interactive Onboarding (`/sdd-onboard`)

**Sections**:
1. **Welcome** (10 sec): What is SDD?
2. **Concepts** (60 sec): Phases, modes, guardrails
3. **Commands** (30 sec): Essential 4 commands
4. **Demo** (optional): Create sample spec
5. **Config** (optional): Generate .sdd.yaml

**Output**: User understands SDD without reading docs.

### 6. Proposal Document

**Location**: `specs/NNN-feature/proposal.md`

**Template**:
```markdown
# Proposal: [Feature Name]

## Rationale
Why are we building this?

## Scope
### In Scope
- ...
### Out of Scope
- ...

## Alternatives Considered
1. [Alternative A] — rejected because...
2. [Alternative B] — rejected because...

## Success Metrics
- [How we'll know it worked]
```

**Relationship to behavior-spec**:
- Proposal = WHY and WHAT (high-level)
- Behavior-spec = HOW to verify (acceptance criteria)

### 7. Feature Numbering

**Convention**: `specs/NNN-feature-name/`

**Script logic**:
```bash
# Find highest existing number
LAST=$(ls -d specs/[0-9][0-9][0-9]-* 2>/dev/null | sort -r | head -1)
NEXT=$((${LAST:6:3} + 1))
printf "specs/%03d-%s" $NEXT "$FEATURE_NAME"
```

### 8. Fluid Artifacts

**Change**: Remove phase-gating from artifact edits.

**Current behavior**: `/sdd-phase implement` implies you shouldn't edit specs.

**New behavior**:
- Phase is informational only
- Guardrails enforce mode (dev/review/research), not phase
- User can edit any artifact anytime
- Completion review checks for drift

### 9. Helper Scripts

**`scripts/new-feature.sh`**:
```bash
#!/bin/bash
# Creates numbered feature directory with templates
NAME="$1"
# ... auto-number and create structure
```

**`scripts/check-consistency.sh`**:
```bash
#!/bin/bash
# Runs artifact validation (same as /sdd-analyze but standalone)
```

**`scripts/list-criteria.sh`**:
```bash
#!/bin/bash
# Greps all Given-When-Then from spec files
```

### 10. Checklist Generator

**Types**:
- `pre-commit`: Build, lint, test, no debug statements
- `pre-pr`: Above + security scan, no secrets
- `feature-complete`: Spec criteria verified, docs updated
- `security`: OWASP checks, input validation
- `performance`: Profiling done, benchmarks pass

**Customization**: References actual project files/patterns.

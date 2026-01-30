# Interactive Spec Process

## How to Guide the Conversation

### Opening
When the user describes what they want to build, acknowledge their vision, then begin questioning. Don't dump all questions at once — pick the 2-3 most important gaps and ask those first.

**Good**: "That sounds like a [type] application. Before we start building, let me understand a few things. First — who are the primary users, and what problem does this solve for them?"

**Bad**: "Let me ask you 15 questions before we begin. Question 1: What is the problem? Question 2: Who are the users? Question 3: ..."

### Adaptive Questioning
- If the user gives a detailed description, skip questions they've already answered
- If the user is vague, ask more foundational questions
- If the user is technical, use technical language; if not, stay accessible
- 3-5 questions per stage is typical. Stop when you have enough to write the document.

### Document Generation
After each stage, offer to generate the corresponding document:
- "I have enough to draft the app description. Want me to generate it?"
- Present the document for review
- Accept corrections and update

### Moving Between Stages
- Complete one stage before moving to the next
- It's OK to revisit earlier stages if new information emerges
- The user can skip stages they consider unnecessary
- Always complete at least Intent Discovery and Behavioral Bounding before any code

## Stage Details

### Intent Discovery Questions
Core:
- What problem does this solve?
- Who will use it?
- What does a successful outcome look like?

Probing:
- Is this replacing an existing solution?
- What's the scale? (Prototype, internal tool, public product)
- Any hard deadlines or constraints?

### Behavioral Bounding Questions
Core:
- What are the main user actions/workflows?
- What should the system never do? (Non-goals)
- What happens on failure/error?

Probing:
- Given [scenario], when [action], then [expected result]?
- Are there roles/permissions?
- What data needs to persist?

### Technical Context Questions
Core:
- Language and framework preference?
- Where will this run? (Local, cloud, edge)
- Any existing systems to integrate with?

Probing:
- What's the expected load?
- Any regulatory requirements? (GDPR, HIPAA, etc.)
- Preferred database/storage?

### Architecture Questions
Core:
- Monolith or distributed?
- What are the main components?
- How do components communicate?

Probing:
- What patterns does the existing codebase use?
- Any shared infrastructure? (Auth, logging, messaging)
- How is the code deployed?

### Prioritization Questions
Core:
- What's the MVP — the minimum that delivers value?
- What can be deferred?
- Any dependencies between features?

Probing:
- What would you ship if you had one week?
- What's the riskiest part? (Build that first)
- Are there external dependencies with timelines?

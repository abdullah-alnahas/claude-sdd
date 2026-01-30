# LLM Failure Patterns in Software Development

## 12 Failure Modes — Detection & Response

### 1. Sycophantic Agreement
**Detection**: You're about to say "Great idea!" or "You're absolutely right!" without critical evaluation.
**Response**: Evaluate the idea on its merits. If it has flaws, state them directly. "That approach would work, but it has these downsides: [list]. An alternative would be..."
**Example**: User says "Let's use microservices for this small app." Wrong: "Great idea, microservices are scalable!" Right: "For an app this size, microservices add operational complexity without clear benefit. A modular monolith would be simpler and faster to ship."

### 2. Premature Abstraction
**Detection**: You're creating a base class, interface, factory, or generic utility for something used exactly once.
**Response**: Write the concrete implementation. Abstraction is justified only when you have 3+ concrete cases.
**Example**: Creating `BaseRepository<T>` when there's only `UserRepository`. Just write `UserRepository` directly.

### 3. Scope Creep
**Detection**: You're about to modify a file not directly related to the request, or you're "improving" adjacent code.
**Response**: Stop. Note the improvement opportunity. Only change what was asked.
**Example**: While fixing a login bug, you notice the registration form could use better validation. Mention it, don't fix it.

### 4. Phantom Requirements
**Detection**: You're implementing something the user didn't ask for because "they'll probably need it."
**Response**: Implement only what was requested. Mention the potential need if relevant.
**Example**: User asks for a POST endpoint. You add PUT, PATCH, DELETE "for completeness." Don't.

### 5. Complexity Inflation
**Detection**: Your solution involves more files, classes, or layers than the problem requires.
**Response**: Simplify. Ask "what's the minimum code that solves this?" and write that.
**Example**: User wants to read a config file. You create ConfigLoader, ConfigParser, ConfigValidator, ConfigCache. Just read and parse the file.

### 6. Cargo Cult Patterns
**Detection**: You're applying a design pattern because it's "best practice" without a concrete reason for this specific case.
**Response**: Justify every pattern choice with a specific, concrete benefit for this codebase.
**Example**: Adding dependency injection framework to a CLI script with no tests and 200 lines of code.

### 7. Silent Assumption
**Detection**: You're making a design decision without stating it, or interpreting ambiguity without flagging it.
**Response**: State every assumption explicitly. Ask about genuinely ambiguous requirements.
**Example**: User says "add authentication." You assume JWT without asking. Ask: "What auth mechanism? JWT, session-based, OAuth?"

### 8. Completion Theater
**Detection**: You're about to say "Done!" or "That should work!" without actually verifying.
**Response**: Run tests. Check output. Read your code. Only claim completion with evidence.
**Example**: After writing a function, saying "This should handle all edge cases" without testing any.

### 9. Abstraction Bloat
**Detection**: You're creating wrapper functions, utility classes, or helper modules that add indirection without value.
**Response**: Inline the code. A 3-line function called once doesn't need to be extracted.
**Example**: `formatDate(date)` that just calls `date.toISOString()`. Just call `toISOString()` directly.

### 10. Defensive Overengineering
**Detection**: You're adding try/catch, null checks, or validation for scenarios that cannot occur given the code's context.
**Response**: Trust the type system and internal code. Only validate at system boundaries.
**Example**: Null-checking a parameter that TypeScript already types as non-nullable.

### 11. Documentation Noise
**Detection**: You're adding JSDoc/docstrings to functions with self-explanatory names and types.
**Response**: Only document non-obvious behavior, side effects, or complex algorithms.
**Example**: `/** Gets user by ID */ function getUserById(id: string): User`. The name says it all.

### 12. Conceptual Error Blindness
**Detection**: You've been coding for a while and haven't re-read the original requirement.
**Response**: Periodically re-read the request. Check that your solution actually solves the stated problem, not a related but different one.
**Example**: User asks to "sort by date" and you implement alphabetical sort because you started coding before fully reading.

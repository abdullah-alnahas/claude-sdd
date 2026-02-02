# Step 1: Specify

**Input**: The app description (from argument).

## Actions

1. If input is a file path, read it. If inline text, treat as raw description.
2. Summarize your understanding of what needs to be built. Ask 2-3 critical clarifying questions if the description is genuinely ambiguous. For clear descriptions, proceed without questions.
3. Generate foundation documents in `specs/`:
   - `app-description.md` — formalized from the raw input
   - `behavior-spec.md` — with Given-When-Then acceptance criteria
   - `stack.md` — technology choices (infer from project context, or ask if greenfield and ambiguous)
4. Present the behavior spec criteria to the user for confirmation before proceeding.

## Transition

"Specify phase complete — N acceptance criteria defined. Entering Design phase."

# Step 2: Design

**Input**: Foundation documents from Step 1.

## Actions

1. Generate `architecture.md` — system structure, components, patterns
2. If any architectural decision is non-obvious, generate an ADR
3. Generate `roadmap.md` — prioritized implementation order
4. Identify integration points, dependencies between roadmap items

## Plan Review (Staff Engineer Gate)

Before transitioning to Implement, the plan must pass staff engineer review:

1. **Spawn critic agent** with this prompt:
   > "Review this plan as a staff engineer. Read the behavior-spec.md, architecture.md, and roadmap.md. Identify: gaps (missing requirements), risks (what could go wrong), overcomplexity (overengineered elements), and missing edge cases. Be direct and skeptical."

2. **If critic finds issues**:
   - Display findings grouped by severity
   - Ask: "Revise plan to address these issues? [y/n/skip]"
   - If **y**: The **main agent** (not critic) revises the relevant documents based on critic findings, then re-runs critic review (max 2 iterations)
   - If **n** or **skip**: Proceed with warning: "Proceeding without addressing plan review findings"

3. **If critic finds no blocking issues**:
   - Output: "Plan reviewed by critic agent — no blocking issues"
   - Proceed to Implement

4. **Max iterations reached** (after 2 revisions):
   - Force decision: "Max plan revisions reached. Proceed with known issues or abort? [proceed/abort]"
   - If **abort**: Stop autopilot, report partial completion

## Transition

"Design phase complete — N roadmap items planned. Plan reviewed. Entering Implement phase."

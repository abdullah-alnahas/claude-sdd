# Skill Creation Process

Creating new SDD skills follows a RED/GREEN/REFACTOR approach — the same TDD discipline applied to the skills themselves.

## RED: Identify the Failure

Before writing a skill, you need evidence of a failure pattern:

1. **Observe the failure** — identify a specific, repeatable behavior problem (e.g., the agent skips verification, over-engineers, ignores specs)
2. **Document the failure** — write down exactly what went wrong, with concrete examples
3. **Pressure test** — verify this isn't a one-off. Does it happen across different tasks, projects, or prompts?

If you can't reproduce the failure consistently, you don't need a skill yet. You need more data.

## GREEN: Write the Minimal Skill

Write the smallest skill that addresses the failure:

1. **Frontmatter** — name + CSO-format description ("Use when..." with trigger conditions only)
2. **One core principle** — the single behavioral change needed
3. **Detection** — how the agent recognizes it's about to fail
4. **Response** — what the agent should do instead
5. **Rationalization table** — 4-8 entries mapping excuses to counters

The skill should be under 500 words at this stage. If it's longer, you're solving too many problems at once.

## REFACTOR: Plug Loopholes

Deploy the minimal skill and observe:

1. **Does the agent follow it?** If not, the trigger conditions in the description may be wrong — fix them.
2. **Does the agent rationalize around it?** Add entries to the rationalization table for each observed excuse.
3. **Does it create new problems?** If the skill causes over-correction (e.g., too rigid in cases where flexibility is needed), add "When This Skill Is Overhead" section.
4. **Is it too broad?** Split into focused skills. One skill should address one failure pattern cluster.

## Checklist

Before shipping a new skill:

- [ ] Failure pattern documented with 3+ examples
- [ ] Description uses "Use when..." CSO format
- [ ] Rationalization table has 4+ entries
- [ ] Skill body under 3000 words
- [ ] References directory exists (even if empty initially)
- [ ] Added to `using-sdd` skill table
- [ ] Added to `scripts/verify-skills.sh` SKILLS array
- [ ] Rigid vs. flexible classification documented in `using-sdd`

## Anti-Patterns

- **Speculative skills**: Writing a skill for a problem you haven't observed yet
- **Kitchen-sink skills**: Cramming multiple unrelated concerns into one skill
- **Checklist-only skills**: Lists of rules without detection/response guidance
- **Aspirational skills**: Describing ideal behavior without addressing the specific failure that motivated the skill

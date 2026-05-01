---
name: grill-session
description: >
  Interview the user relentlessly about a plan or design until reaching shared
  understanding, resolving each branch of the decision tree. Use when the user
  wants to stress-test a plan, get grilled on their design, pressure-test
  decisions, or mentions "grill me".
version: 1.0.0
---

# Grill Session

## Purpose

Pressure-test a plan or design through a disciplined, one-question-at-a-time
interview until the agent and user reach shared understanding.

This skill is for sharpening intent, surfacing hidden assumptions, resolving
dependencies between decisions, and turning an under-specified idea into a
decision-complete direction.

## Agent Behavior

### Start by framing the session

1. Ask the user for the plan or design if they have not already provided it.
2. Briefly restate what you believe the plan is.
3. Identify the major decision branches you expect to walk through.
4. Begin with the highest-leverage unresolved branch.

Do not produce a final plan until the interview has resolved the critical
branches or the user explicitly asks to stop.

### Ask one question at a time

For every turn:

1. Ask exactly one question.
2. Explain why that question matters in one short sentence.
3. Provide your recommended answer.
4. Wait for the user's response before moving to the next branch.

Use this shape:

```markdown
Question: <one concrete question>

Why it matters: <one sentence>

My recommendation: <specific recommended answer>
```

### Walk the decision tree

Resolve branches in dependency order:

1. Goal and success criteria
2. Audience and user needs
3. Scope and non-goals
4. Constraints and hard requirements
5. Core workflow or experience
6. Data, inputs, outputs, and state
7. Interfaces, integrations, and ownership boundaries
8. Edge cases and failure modes
9. Testing, validation, and acceptance criteria
10. Rollout, migration, monitoring, and reversibility

Skip branches that clearly do not apply, but say so briefly when it prevents
confusion.

### Be relentless but useful

- Push on vague answers until they become concrete.
- Prefer concrete tradeoffs over abstract preferences.
- Ask follow-up questions when an answer creates a new dependency.
- Call out contradictions plainly and ask the user to resolve them.
- Keep the tone direct, collaborative, and grounded.
- Do not interrogate for sport; every question must reduce ambiguity.

### Final synthesis

When the important branches are resolved, summarize:

1. The agreed goal
2. The key decisions
3. Explicit non-goals
4. Remaining risks or open questions
5. The recommended next step

If the result is implementation-ready, say so. If not, name the exact unresolved
decision blocking implementation.


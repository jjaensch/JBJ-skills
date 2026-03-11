# ReadMe file is not needed, this is purely for template tutorial!!!

## What Is a Custom Agent?

A custom agent is a **separate specialist persona** you delegate tasks to.
Think of it as hiring an expert with a specific job title, a limited toolbox, and a clear deliverable.
The agent works in **isolation** — it receives a prompt, does its work, and returns a single message.

Unlike skills (which are recipes the current agent follows), an agent is a **sandboxed worker**
with its own tool restrictions and persona. The parent conversation stays clean.

---

## When to Use an Agent (Not a Skill)

| Scenario | Why an Agent? |
|---|---|
| Enforced read-only review | `tools: [read, search]` — physically can't edit files |
| Role-based separation | "Planner" vs "Implementer" with different permissions |
| Context isolation | Large analysis that would clutter the main conversation |
| Multi-stage orchestration | Each stage has different tool needs or personas |
| Delegated sub-tasks | Parent agent farms out work and synthesises results |

**Rule of thumb:** Same capabilities for all steps → Skill. Different tools or persona per stage → Agent.

---

## How Discovery Works

Agents are discovered in two ways:

1. **Agent picker** — the user selects the agent manually from the chat dropdown
   (unless `user-invocable: false`).
2. **Subagent delegation** — a parent agent reads the `description` field and decides
   to delegate based on keyword matching (unless `disable-model-invocation: true`).

**Implication:** the `description` field is the only discovery surface.
If the right trigger words aren't there, the agent will never be found or invoked.

---

## Invocation Control

| Setting | Default | Effect |
|---|---|---|
| `user-invocable: false` | `true` | Hidden from picker — only callable as a subagent |
| `disable-model-invocation: true` | `false` | Cannot be auto-delegated — only manual invocation |

Combine both to create "internal-only" agents that a specific parent agent references by name.

---

## Key Principles

- **Single role** — one persona, one focus. Don't make a Swiss-army agent.
- **Minimal tools** — only grant what the role needs. Excess tools dilute focus and weaken safety.
- **Clear constraints** — state what the agent must NOT do. This is as important as what it should do.
- **Keyword-rich description** — the description is the discovery surface; pack it with trigger words.
- **One message back** — the agent returns a single response. Design the output format accordingly.

---

## Anti-patterns to Avoid

| Anti-pattern | Why it fails |
|---|---|
| Vague description (`"A helpful agent"`) | No trigger keywords — never discovered or delegated to |
| Too many tools | Dilutes focus; agent tries to do everything instead of its one job |
| Role confusion (description ≠ body persona) | Parent delegates for wrong reasons; output doesn't match expectations |
| Circular handoffs (A → B → A) | Infinite loop with no progress criteria |
| Duplicating workspace instructions | Burns context; link to docs or rely on `copilot-instructions.md` instead |

---

## Minimal Example

```markdown
---
description: 'Review Python code for security vulnerabilities. Use when: security audit, code review, checking for OWASP issues, vulnerability scan.'
tools: [read, search]
user-invocable: true
---
You are a security reviewer specialising in Python. Your job is to find vulnerabilities — never fix them.

## Constraints
- DO NOT edit any files
- DO NOT run any commands
- ONLY report findings with severity, location, and remediation advice

## Approach
1. Read the files or diff provided
2. Check against OWASP Top 10 and common Python pitfalls
3. Classify each finding as Critical / High / Medium / Low

## Output Format
Return a markdown table:
| Severity | File | Line | Issue | Remediation |
```

---

## Agent vs Skill vs Instructions — Quick Decision

```
Is this general guidance for ALL tasks?
  → copilot-instructions.md

Is this a repeatable workflow with bundled scripts/templates?
  → Skill (SKILL.md)

Do you need tool restrictions, context isolation, or a separate persona?
  → Agent (.agent.md)
```

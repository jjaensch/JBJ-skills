# ReadMe file is not needed, this is purely for template tutorial!!!

## What Is copilot-instructions.md?

This is the **always-on baseline** for your project. Every time Copilot processes a chat request
in this workspace, the contents of `copilot-instructions.md` are silently injected into the context.

Think of it as the "house rules" — coding standards, architecture decisions, and conventions
that apply to **every** interaction, without the user needing to mention them.

---

## How It Works

1. You place a file at `.github/copilot-instructions.md` in your repo.
2. On every chat request, Copilot reads this file and prepends it to the conversation context.
3. The agent follows these instructions alongside the user's actual question.

There is **no frontmatter** — just plain Markdown. No discovery logic, no trigger keywords.
It is always loaded, unconditionally.

---

## copilot-instructions.md vs AGENTS.md

Both serve the same purpose. Choose one:

| File | Location | Strength |
|---|---|---|
| `copilot-instructions.md` | `.github/` | Cross-editor standard (VS Code, JetBrains, etc.) |
| `AGENTS.md` | Root or subfolders | Supports monorepo hierarchy (closest file wins) |

**Never use both** — they can conflict and produce unpredictable results.

### When to use AGENTS.md instead
If your repo is a monorepo where `/frontend/` and `/backend/` need different rules,
use nested `AGENTS.md` files:

```
/AGENTS.md              # Root defaults for the whole repo
/frontend/AGENTS.md     # Overrides for frontend code
/backend/AGENTS.md      # Overrides for backend code
```

For single-project repos, `copilot-instructions.md` is simpler and recommended.

---

## What Belongs Here (and What Doesn't)

### Good candidates
- Language version and style (e.g. "Python 3.12+, Black formatter")
- Architecture overview (e.g. "FastAPI + SQLAlchemy async")
- Build/test/lint commands
- Naming conventions that differ from common practices
- Output language preferences
- Links to detailed docs (e.g. `See docs/TESTING.md`)

### Does NOT belong here
- Instructions for specific tasks → use a **Skill** or **file instruction** instead
- Obvious conventions already enforced by linters
- Full documentation copied in → **link** to docs, don't embed
- Anything longer than ~100 lines → you're burning context on every request

---

## Key Principles

- **Minimal by default** — every line is loaded every time; only include what matters universally.
- **Concise and actionable** — each instruction should directly guide agent behavior.
- **Link, don't embed** — reference docs instead of copying them in.
- **Keep current** — stale instructions actively degrade output quality. Update when practices change.

---

## Anti-patterns to Avoid

| Anti-pattern | Why it fails |
|---|---|
| Using both `copilot-instructions.md` AND `AGENTS.md` | Conflicting instructions, unpredictable behavior |
| Kitchen-sink file (everything in one place) | Burns context tokens on irrelevant rules every request |
| Duplicating the README | Redundant; the agent can already read your README if needed |
| Obvious instructions ("use descriptive variable names") | Already enforced by linters or common sense — wastes tokens |
| Task-specific instructions here | Use skills or `.instructions.md` files for scoped guidance |

---

## Where This Fits in the Customization Stack

```
┌─────────────────────────────────────────────────────┐
│  copilot-instructions.md / AGENTS.md                │  Always on, every request
├─────────────────────────────────────────────────────┤
│  .instructions.md  (applyTo / description)          │  File-specific or task-specific, on demand
├─────────────────────────────────────────────────────┤
│  SKILL.md  (in .github/skills/<name>/)              │  Workflow with bundled assets, on demand
├─────────────────────────────────────────────────────┤
│  .agent.md (in .github/agents/)                     │  Isolated specialist with tool restrictions
└─────────────────────────────────────────────────────┘

        ▲ always loaded                    on demand ▼
```

The instructions file is the foundation layer. Skills and agents build on top of it
for specialized, on-demand work.

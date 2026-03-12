# ReadMe file is not needed, this is purely for template tutorial

!!!

## Progressive Loading

The agent loads skills in three stages to conserve context tokens:

1. **Discovery** (~100 tokens) — reads only `name` and `description` from frontmatter.
2. **Instructions** (<5 000 tokens) — loads the SKILL.md body when the skill is deemed relevant.
3. **Resources** — additional files load only when explicitly referenced.

**Implication:** keep SKILL.md under ~500 lines. Move large reference material into `./references/`.

---

## 5. Key Principles

- **Keyword-rich descriptions** — include the exact words a user or agent would use to trigger the skill.
- **Self-contained** — bundle everything needed to complete the task (scripts, templates, docs).
- **Relative paths** — always use `./` when referencing skill resources.
- **One level deep** — keep file references at most one directory level from SKILL.md.

---

## 6. Anti-patterns to Avoid

| Anti-pattern | Why it fails |
| --- | --- |
| Vague description (`"A helpful skill"`) | Agent can't discover it — no trigger keywords |
| Name ≠ folder name | Silent failure, skill never loads |
| Monolithic SKILL.md (1 000+ lines) | Burns context window; use `./references/` instead |
| Missing procedures | Agent has description but no actionable steps |
| Unquoted colons in YAML values | YAML parse error — silent failure |
| Tabs in frontmatter | YAML requires spaces only |

---

## 7. Minimal Example

```markdown
---
name: db-migration
description: 'Run and validate database migrations. Use when: applying schema changes, rolling back migrations, checking migration status.'
argument-hint: 'migration name or direction (up/down)'
---

# Database Migration

## When to Use
- Apply pending schema changes
- Roll back a specific migration
- Verify migration status before deploy

## Procedure
1. Check current status: run [status script](./scripts/status.sh)
2. Apply migration: run [migrate script](./scripts/migrate.sh) with target name
3. Validate with [post-check](./references/validation-checklist.md)
4. On failure, roll back: run [rollback script](./scripts/rollback.sh)
```

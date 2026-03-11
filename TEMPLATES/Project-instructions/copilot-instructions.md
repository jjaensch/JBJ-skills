# copilot-instructions.md Template

## 1. About This File

`copilot-instructions.md` contains **project-wide guidelines** that are automatically injected
into every Copilot chat request across the workspace. No frontmatter needed — just Markdown.

**Location:** `.github/copilot-instructions.md`

> **Alternative:** `AGENTS.md` at the repo root serves the same purpose (open standard,
> supports monorepo hierarchy). Use one or the other — **never both**.

---

## 2. What to Include

Only include what is relevant to *every* task in this project.
Structure with the sections that apply — skip sections that don't add value.

```markdown
# Project Guidelines

## Code Style
- Language: Python 3.12+
- Formatter: Black (line length 100)
- Linter: Ruff
- Type hints required on all public functions

## Architecture
- Backend: FastAPI with SQLAlchemy async
- Frontend: React 18 + TypeScript
- Database: PostgreSQL 15
- See docs/ARCHITECTURE.md for component diagram

## Build & Test
- Install: `pip install -e ".[dev]"`
- Test: `pytest --cov`
- Lint: `ruff check .`
- All PRs require passing CI before merge

## Conventions
- Branch naming: `feature/`, `fix/`, `chore/`
- Commit messages: Conventional Commits format
- API responses always use snake_case
- Never commit secrets — use environment variables

## Output Language
- All code comments in English
- All user-facing text in Danish
```

---

## 3. Tips for Writing Good Instructions

- **Be specific, not obvious** — don't repeat what linters already enforce.
- **Link, don't embed** — reference `docs/TESTING.md` instead of copying it in.
- **Keep it under ~100 lines** — this loads into every request; brevity saves context tokens.
- **Update when practices change** — stale instructions actively harm output quality.

---

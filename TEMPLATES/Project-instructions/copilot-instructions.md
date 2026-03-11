# copilot-instructions.md Template

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

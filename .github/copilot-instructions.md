# CurioCloud Backend - AI Coding Agent Instructions

## Project Overview
FastAPI-based backend for CurioCloud (课研云), an AI-driven teacher lesson planning assistant.
Key features: User Auth, AI Lesson Planning (OpenRouter/Gemini), LandPPT Integration, and Student Analytics.

## Architecture & Patterns

### Core Design
- **Clean Architecture**: 
  - `Routers` (HTTP/Validation) -> `Services` (Business Logic) -> `Models` (DB Data).
  - **Do not** put business logic in Routers.
  - **Do not** put HTTP exceptions in Models.
- **Database (Sync)**: 
  - SQLAlchemy ORM with synchronous `Session`.
  - Dependency: `app.core.database.get_db` yields `Session`.
  - **Critical**: Services use **blocking** DB calls. Run them in threadpool (FastAPI default for non-async def) or be aware of blocking in `async def` routers.
- **Async Integrations**: 
  - `AIService` and `LandPPTService` use `httpx` for **asynchronous** external API calls.
  - Services mixing DB (sync) and API (async) should be handled carefully in `async def` routers.

### Critical Conventions
- **Language**: All comments, docstrings, and user-facing error messages must be in **Simplified Chinese (zh-CN)**.
- **Error Handling**:
  - Service layer: Wrap DB operations in `try/except`. Always `db.rollback()` on error.
  - Raise `HTTPException` for business logic errors.
- **Data Models**:
  - SQLAlchemy models inherit from `Base`.
  - **Must** include `comment="..."` argument for every Column definition (for database documentation).
- **Schema Validation**:
  - Pydantic models in `app/schemas/` with `from_attributes = True` (ORM mode).
  - Use `excluded_unset=True` for partial updates.

## Key Subsystems

### Authentication (`app/dependencies/auth.py`)
- Standard JWT (HS256).
- Use dependencies:
  - `get_current_user`: Required auth.
  - `get_current_active_user`: Active users only.
  - `get_optional_current_user`: For public-facing endpoints with optional personalization.

### AI & Teaching Module
- **Conversation Flow**: State machine defined in `app/conversation_flow.py`.
- **Prompts**: stored in `app/prompts/` or specialized service methods.
- **LandPPT Integration**: 
  - via `LandPPTService` (`app/services/landppt_service.py`).
  - Uses `LANDPPT_BASE_URL` and `LANDPPT_API_KEY`.
  - Supports converting Lesson Plans -> PPT.

### Analytics
- Excel upload processing in `AnalyticsService`.
- Generates Markdown reports.

## Developer Workflows

### Common Commands
- **Run Dev Server**: `uvicorn main:app --reload`
- **Run Tests**: `pytest` (Uses in-memory SQLite fixtures in `conftest.py`)
- **DB Migrations (Alembic)**:
  - Create: `alembic revision --autogenerate -m "message"`
  - Apply: `alembic upgrade head`

### Testing Strategy
- **Fixtures**: `conftest.py` provides `db_session` (SQLite), `client`, `auth_headers`.
- **Mocking**: Mock external APIs (OpenRouter, LandPPT) in tests. Do not hit real AI endpoints during tests.

### Configuration
- Environment variables loaded via `pydantic_settings` in `app/core/config.py`.
- Local Dev `.env` example:
  ```ini
  DATABASE_HOST=localhost
  JWT_SECRET_KEY=...
  LANDPPT_BASE_URL=...
  ```

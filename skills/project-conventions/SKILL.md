---
name: project-conventions
description: "{{PROJECT_NAME}} project conventions, naming standards, project layout, commit format, and Definition of Done. Checked before starting code and before committing."
---

# {{PROJECT_NAME}} Project Conventions

## Project Layout
```
{{PROJECT_NAME}}/
  {{WEB_APP_PATH}}          # Frontend agent
  {{API_APP_PATH}}          # Backend agent
  {{SHARED_PKG_PATH}}       # Schemas, DTO types, constants (contract source of truth)
  {{DB_PKG_PATH}}           # Schema, migrations, seed (Data/Infra agent)
```
- Package manager: **{{PKG_MANAGER}}**.
- Validation schemas are defined only in the shared package/module; FE and BE consume from there.
- **Monorepo or single repo, both work.** In a monorepo, the four paths above are separate top-level directories/packages. In a single-repo or single-app project (no separate frontend/backend split), some or all of these paths can be the same directory — even `.` for all four. When paths coincide, agents tell their areas apart by **file/module pattern** instead of top-level directory (e.g. `src/routes/api/**` = backend, `src/components/**` = frontend, `src/db/schema.*` = data-infra), following the same ownership boundaries below.

## Card ID & Naming

**Format:** `[MODULE-LAYER-SEQ]`

**Modules:** {{MODULES}} (comma-separated, lowercase)

**Layers:** DB, BE, FE, INFRA, QA

**Examples:**
- `MODULE-ARCH-001` = a module, architecture layer, 1st card
- `MODULE-BE-005` = a module, backend layer, 5th card
- `MODULE-FE-002` = a module, frontend layer, 2nd card

**Commit format:**
```bash
feat(MODULE-BE-003): short description
fix(MODULE-FE-001): short description
test(MODULE-DB-002): short description
```

## Ownership Boundaries
| Area | Owner |
|------|-------|
| API app/module ({{API_APP_PATH}}), OpenAPI, business rules | Backend agent |
| Web app/module ({{WEB_APP_PATH}}), UI screens | Frontend agent |
| DB package/module ({{DB_PKG_PATH}}), auth infrastructure, CI | Data/Infra agent |
| Shared package/module schemas ({{SHARED_PKG_PATH}}) | Backend agent (FE consumes, changes go through BE) |

If two or more of these paths are the same directory (single-repo/single-app project), ownership is decided by file pattern within that directory rather than by the directory itself — see the Project Layout note above.

A BE card that needs a schema change adds a `[SCHEMA-REQUEST]` note to its description; the Data/Infra agent applies it.

## Contract-First Rule
1. The schema is defined in shared before an endpoint is written.
2. FE works against a mock fixture until the API is ready.
3. If the contract changes, shared is updated first, then FE and BE adapt.

## Definition of Done (every card)
- All acceptance criteria checked and verified
- Lint + typecheck clean
- Relevant tests written and passing
- FE: uses the UI library, responsive, no custom CSS
- Commit message includes the card ID (e.g. `MODULE-BE-003`)
- Card in `Done ✅`

## Available Optional Skills
{{SELECTED_SKILLS}}

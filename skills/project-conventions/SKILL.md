---
name: project-conventions
description: "{{PROJECT_NAME}} project conventions, naming standards, monorepo structure, commit format, and Definition of Done. Checked before starting code and before committing."
---

# {{PROJECT_NAME}} Project Conventions

## Monorepo Structure
```
{{PROJECT_NAME}}/
  {{WEB_APP_PATH}}          # Frontend agent
  {{API_APP_PATH}}          # Backend agent
  {{SHARED_PKG_PATH}}       # Schemas, DTO types, constants (contract source of truth)
  {{DB_PKG_PATH}}           # Schema, migrations, seed (Data/Infra agent)
```
- Package manager: **{{PKG_MANAGER}}**.
- Validation schemas are defined only in the shared package; FE and BE consume from there.

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
| API app ({{API_APP_PATH}}), OpenAPI, business rules | Backend agent |
| Web app ({{WEB_APP_PATH}}), UI screens | Frontend agent |
| DB package ({{DB_PKG_PATH}}), auth infrastructure, CI | Data/Infra agent |
| Shared package schemas ({{SHARED_PKG_PATH}}) | Backend agent (FE consumes, changes go through BE) |

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

---
name: project-conventions
description: "{{PROJECT_NAME}} project conventions, naming standards, project layout, commit format, and Definition of Done. Checked before starting code and before committing."
---

# {{PROJECT_NAME}} Project Conventions

## Project Layout

**Ownership is by concern, not by directory.** This kit deliberately does not record where things live — layouts differ per project and change over time, and a hardcoded path is a lie waiting to happen. Agents locate their areas by looking at the repo (`graphify query` if the graph exists, otherwise glob/grep), and the ownership boundaries below hold whatever the layout turns out to be — separate packages in a monorepo, or everything side by side in one `src/`.

When an agent genuinely can't tell which files fall under its concern, it **asks the user** rather than guessing. Guessing produces edits in another agent's territory, which is the one failure this ownership model exists to prevent.

- Package manager: **{{PKG_MANAGER}}**.
- Validation schemas live in exactly one shared module; frontend and backend both consume from there and neither re-declares them.

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
| Server-side code, OpenAPI, business rules | Backend agent |
| UI components, screens, client-side state | Frontend agent |
| Schema, migrations, seeds, auth infrastructure, CI | Data/Infra agent |
| Shared schema modules | Backend agent (FE consumes, changes go through BE) |

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

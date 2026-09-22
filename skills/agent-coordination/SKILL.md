---
name: agent-coordination
description: "5-agent (Architect/Data-Infra/Backend/Frontend/QA) sprint workflow, handoff protocol, board structure, and closing checklist. Used when starting a sprint/work item and during handoffs between agents."
---

# Agent Coordination Matrix

## 1. The Agent Team

| Agent | Layer | Owns |
|-------|-------|------|
| **architect** | `ARCH` | API Contract, Task Breakdown, ADR |
| **backend** | `BE` | API, Services, Business Rules |
| **frontend** | `FE` | UI, Forms, Dashboards |
| **data-infra** | `DB`/`INFRA` | Schema, Migrations, Auth, CI |
| **qa** | `QA` | E2E Tests, Acceptance Testing, Security |

<!-- SPRINT MODE START -->
## 2. Sprint Workflow (Required Order)

```
[Work Request] → Create Sprint Cards on the Board
                │
    1️⃣ architect: Prepare Contract
       • Data Model • API Endpoints • UI Flow • Error Codes
                │
        ┌───────┼────────┐
    2️⃣ data-infra   2️⃣ backend
    (Schema/Migration)  (API/Service) ──→ 2️⃣ frontend (Mock Mode/Screen)
        └───────┬────────┘
    3️⃣ qa: Acceptance Testing & Security
       ✅ Sprint Accepted or ❌ Back to Work
```

## 3. Handoff Protocol

| From | To | Tag | Content |
|------|----|-----|---------|
| architect | data-infra | `[SCHEMA-REQUEST]` | Table names, relationships, constraints |
| architect | backend | `[API-CONTRACT]` | Endpoint list, schema names, error codes |
| architect | frontend | `[UI-CONTRACT]` | Screen list, data requirements, mock schema |
| data-infra | backend | `[SCHEMA-READY]` | Migration ran, tables ready |
| data-infra | frontend | `[SEED-READY]` | Seed ran, deterministic IDs documented |
| frontend/backend | qa | `[READY-FOR-QA]` | Sprint cards Done, ready for acceptance testing |

Dispute: `[CONTRACT-DISPUTE]` card comment → architect decides and updates the contract.

## 4. Card Numbering Scheme

Format: `[MODULE-LAYER-SEQ]` — e.g. `ORD-BE-003` = Orders module, Backend layer, 3rd card.

Layers: `ARCH` (architecture), `DB` (data), `BE` (backend), `FE` (frontend), `INFRA` (infrastructure), `QA` (quality).

## 5. Sprint Closing Checklist

**Pre-Closing (when QA starts):**
- [ ] All ARCH cards Done ✅ (contract written)
- [ ] All DB/BE/FE/INFRA cards Done ✅
- [ ] QA card started

**Post-QA (closing the sprint):**
- [ ] QA card Done ✅ (all scenarios green)
- [ ] All bug cards triaged open/closed
- [ ] Sprint retro held
<!-- SPRINT MODE END -->

<!-- NORMAL MODE START -->
## 2. Workflow (Required Order)

```
[Work Request] → Architect
                │
    1️⃣ architect: Prepare Contract
       • Data Model • API Endpoints • UI Flow • Error Codes
                │
        ┌───────┼────────┐
    2️⃣ data-infra   2️⃣ backend
    (Schema/Migration)  (API/Service) ──→ 2️⃣ frontend (Mock Mode/Screen)
        └───────┬────────┘
    3️⃣ qa: Acceptance Testing & Security
       ✅ Accepted or ❌ Back to Work
```

## 3. Handoff Protocol

Handoffs happen as direct notes/comments between agents (in code review, commit messages, or a shared doc) — no card IDs or board required.

| From | To | Tag | Content |
|------|----|-----|---------|
| architect | data-infra | `[SCHEMA-REQUEST]` | Table names, relationships, constraints |
| architect | backend | `[API-CONTRACT]` | Endpoint list, schema names, error codes |
| architect | frontend | `[UI-CONTRACT]` | Screen list, data requirements, mock schema |
| data-infra | backend | `[SCHEMA-READY]` | Migration ran, tables ready |
| data-infra | frontend | `[SEED-READY]` | Seed ran, deterministic IDs documented |
| frontend/backend | qa | `[READY-FOR-QA]` | Work is done, ready for acceptance testing |

Dispute: `[CONTRACT-DISPUTE]` note → architect decides and updates the contract.

## 4. Closing Checklist

**Before QA starts:**
- [ ] Architecture contract written
- [ ] DB/BE/FE/INFRA work complete

**Before calling the work item done:**
- [ ] QA scenarios all green
- [ ] All bugs found are triaged open/fixed
<!-- NORMAL MODE END -->

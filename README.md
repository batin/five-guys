# five guys 🍔

Five agents, one order, no substitutions. A contract-first workflow — architect, backend, frontend, data-infra, qa — for product teams, whether the project is a monorepo, a single-repo full-stack app, or anything in between. Drop this folder into any project's `.claude/plugins/` and run `/setup`; it asks a few questions and cooks up a configuration for your project.

---

## 🚀 Quick Start

**Option A — one-line install (recommended):** inside Claude Code, in your project:
```
/plugin marketplace add batin/five-guys
/plugin install five-guys@five-guys-marketplace
```
or the single-step form (Claude Code v2.1.275+):
```
/plugin install five-guys --marketplace batin/five-guys
```

**Option B — manual copy** (no GitHub access needed, e.g. an internal fork):
```bash
cp -r five-guys /path/to/your-project/.claude/plugins/
```

Then, either way, **run the setup wizard**:
```
/setup
```
It will ask for your project name, package manager, app paths, business modules, whether you want **sprint mode** (Jira/Trello-style board + card workflow) or **normal mode** (continuous handoff, no cards/sprints), and which optional skills to enable — then configures the 5 agents and 2 skills for your project.

Claude Code then discovers everything automatically:
- 5 agents: `architect`, `backend`, `frontend`, `data-infra`, `qa`
- 2 core skills: `project-conventions`, `agent-coordination`

> **Non-interactive/CI fallback:** `./setup.sh "MyProject" "pnpm" "apps/web" "apps/api" "packages/shared" "packages/db" "FEAT,BUG" "normal"` does the same templating without the conversational flow (no optional-skill install step).

---

## 📁 Structure

```
five-guys/
  .claude-plugin/plugin.json          # Plugin manifest
  .claude-plugin/marketplace.json     # Lets this repo self-serve as a marketplace
  commands/setup.md                   # /setup wizard
  agents/
    architect.md                        # System design, contracts, ADR
    backend.md                          # API, services, business logic
    frontend.md                         # UI, forms, dashboards
    data-infra.md                       # Schema, migrations, auth, CI
    qa.md                               # E2E tests, security audit, acceptance
  skills/
    agent-coordination/SKILL.md         # Workflow, handoff protocol
    project-conventions/SKILL.md        # Naming, project layout (monorepo or single-repo), DoD
  setup.sh                              # CLI fallback for templating
```

---

## 📋 The Five Guys

### architect
Designs API contracts before development, decomposes work into tasks, records architectural decisions (ADR), mediates contract disputes.

### backend
Implements API endpoints, writes business logic and services, manages DTOs and validation schemas, writes unit/integration tests.

### frontend
Builds UI components (component library + utility CSS), implements screens with a mock-first approach, consumes API contracts, ensures responsive/accessible design.

### data-infra
Designs the database schema, manages migrations and seed data, sets up auth infrastructure, owns the CI pipeline.

### qa
Derives E2E scenarios from acceptance criteria, runs security audits, opens bug reports, gates release/sprint closure.

---

## 🔄 Workflow

```
Architect → Contracts (API, Data, UI)
    ↓
┌───────┬──────────┐
Data    Backend    Frontend (mock mode)
Infra   ↓          ↓
        └──────────┘
              ↓
             QA → Accept/Reject
```

**Handoff Protocol:**
- `[SCHEMA-REQUEST]` → data-infra
- `[API-CONTRACT]` → backend
- `[UI-CONTRACT]` → frontend
- `[CONTRACT-DISPUTE]` → architect decides

## 🏃 Sprint Mode vs Normal Mode

Chosen during `/setup`, applied to `skills/agent-coordination/SKILL.md`:

- **Sprint mode** — work is tracked as cards on a board grouped into sprints, with card IDs (`[MODULE-LAYER-SEQ]`) and a sprint-closing checklist gated by QA. Fits teams already running Jira/Trello/Linear-style sprints.
- **Normal mode** — same agent roles and handoff sequence, but continuous: no cards, no sprint gate, handoffs are plain notes/comments. Fits teams without a formal sprint process.

Neither mode calls any real Jira/Trello/Linear API — it's vocabulary and workflow shape only. If you want live board integration, connect the relevant MCP server yourself; the agents will pick up its conventions on top of this kit.

## 🗂️ Any Repo Layout

`/setup` asks four paths (web, api, shared, db). In a **monorepo** those are four separate directories. In a **single-repo/single-app** project (no frontend/backend split), set all four to the same path — even `.` — and the agents fall back to splitting by file/module pattern instead of by directory (e.g. routes/services are backend's, components/pages are frontend's, schema files are data-infra's), keeping the same ownership boundaries either way.

---

## 🧩 Optional Skills (Toppings)

`/setup` offers these and will attempt to install whichever you pick, falling back to manual instructions if it can't:

| Skill | Purpose |
|-------|---------|
| **graphify** | Codebase → queryable knowledge graph, used instead of raw grep. |
| **playwright-e2e** | Playwright E2E test generation/execution for the qa agent. |
| **security-quality-scan** | Dependency/secret/OWASP security scanning for the qa agent. |
| **RTK (Rust Token Killer)** | Token-optimized CLI proxy — cuts verbose command output for all agents. |
| **Ponytail** | Lazy-senior-developer output discipline (YAGNI-first, minimal diffs). |
| **find-skills** | Discover and install other Claude Code skills on demand. |
| **superpowers** | Brainstorming, systematic debugging, TDD, plan-writing skill pack. |
| **ui-ux-pro-max** | UI/UX design intelligence for the frontend agent. |

None are required — the 5 agents work fully without any of them.

---

## ✨ Why This Kit

A validated agent-coordination pattern: **contract-first** development (shared schemas as single source of truth), **layer ownership** boundaries (clear responsibility matrix), and a **handoff protocol** (structured agent communication) — decoupled from any specific project's names, paths, or tech stack so it's reusable anywhere. Same five specialists, every order, no waiting for a table.

---

## 🔗 Integration

Claude Code automatically discovers this plugin when `.claude/plugins/five-guys/` exists with a valid `plugin.json` manifest, and discovers `/setup` from `commands/setup.md` the same way. `.claude-plugin/marketplace.json` lets this same repo also serve as a one-plugin marketplace, so `/plugin marketplace add` + `/plugin install` works without any manual copying.

**License:** MIT
**Version:** 1.1.0

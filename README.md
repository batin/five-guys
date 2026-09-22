# 🍔 five guys

> **Five agents. One order. No substitutions.**
> Contract-first development, cooked to order, in any repo you drop it into.

Nobody wants a codebase assembled by one overworked generalist at 2am. You want five specialists who each know exactly one job, do it in order, and don't touch each other's station. That's the whole idea.

```
        ┌─────────────────────────────────────────┐
        │   🍔  F I V E   G U Y S                  │
        │   contract-first · since your last repo  │
        ├─────────────────────────────────────────┤
        │   architect ........... takes the order  │
        │   data-infra .......... stocks the back  │
        │   backend ............. works the grill  │
        │   frontend ............ plates it up     │
        │   qa .................. checks the bag   │
        ├─────────────────────────────────────────┤
        │   TOPPINGS ..................... FREE    │
        └─────────────────────────────────────────┘
```

---

## 🧾 Place Your Order

**Drive-thru (recommended)** — inside Claude Code, in your project:
```
/plugin marketplace add batin/five-guys
/plugin install five-guys@five-guys-marketplace
```
Or in one go (Claude Code v2.1.275+):
```
/plugin install five-guys --marketplace batin/five-guys
```

**Walk-in** (no GitHub access, internal fork, whatever):
```bash
cp -r five-guys /path/to/your-project/.claude/plugins/
```

Then, either way — **tell them how you like it**:
```
/setup
```

`/setup` asks your project name, package manager, where things live, your business modules, whether you want it **Regular or Little** (sprint mode vs continuous), and which **free toppings** you want. Then it configures all five agents for your project. Takes about a minute. No peanuts.

Claude Code picks up the rest on its own:
- **5 agents:** `architect`, `backend`, `frontend`, `data-infra`, `qa`
- **2 core skills:** `project-conventions`, `agent-coordination`

> 🤖 **Phone order (CI / non-interactive):** `./setup.sh "MyProject" "pnpm" "apps/web" "apps/api" "packages/shared" "packages/db" "FEAT,BUG" "normal"` — same config, no conversation, no toppings menu.

---

## 👨‍🍳 Meet the Crew

### 🧠 `architect` — *takes the order*
Writes the API contract **before** anyone touches a keyboard. Breaks work into tasks, records architecture decisions (ADRs), and settles arguments. Doesn't cook. Never has. Won't start now.

### 📦 `data-infra` — *stocks the back*
Owns the database schema, migrations, seed data, auth plumbing, and the CI pipeline. If it's a table, an index, or a `.env`, it's theirs. Nobody else touches the schema. Nobody.

### 🔥 `backend` — *works the grill*
Endpoints, services, business logic, DTOs, validation schemas, tests. Controllers stay thin — business rules live in services, because that's how you don't burn the place down.

### 🎨 `frontend` — *plates it up*
Screens, components, forms, dashboards. Builds against mocks so it never stands around waiting for the grill. Responsive, accessible, empty states and loading states included at no extra charge.

### 🔎 `qa` — *checks the bag before it goes out*
Derives E2E scenarios from acceptance criteria (not from the devs' own tests — that's the point), runs security scans, files bugs, and refuses to hand over the order until it's right. The most annoying and most important guy here.

---

## 🔥 The Line

```
Architect → Contracts (API, Data, UI)
    ↓
┌───────┬──────────┐
Data    Backend    Frontend (mock mode)
Infra   ↓          ↓
        └──────────┘
              ↓
             QA → Accept / Send it back
```

Orders get passed down the line with tickets, not vibes:

| Ticket | Goes to | Means |
|--------|---------|-------|
| `[SCHEMA-REQUEST]` | data-infra | "I need a table" |
| `[API-CONTRACT]` | backend | "Here's exactly what to build" |
| `[UI-CONTRACT]` | frontend | "Here's the shape of the data" |
| `[SCHEMA-READY]` | backend | "Migration ran, go" |
| `[SEED-READY]` | frontend | "Real-ish data is in" |
| `[READY-FOR-QA]` | qa | "Check the bag" |
| `[CONTRACT-DISPUTE]` | architect | "You two, stop. I'll decide." |

---

## 🍟 Regular or Little?

Picked during `/setup` — same five guys either way, just how much ceremony you want with it.

**🍔 Regular (sprint mode)** — work is tracked as cards on a board grouped into sprints, with card IDs (`[MODULE-LAYER-SEQ]`), a sprint-closing checklist, and QA as the gate. For teams already living in Jira / Trello / Linear.

**🍔 Little (normal mode)** — same roles, same handoff order, same contract-first discipline. No cards, no sprint gate, no ceremony. Handoffs are just notes. For teams who don't run sprints and don't want to start.

Neither mode calls a real Jira/Trello/Linear API — it's vocabulary and workflow shape only. Want live board integration? Connect that MCP server yourself; the agents will happily pick up its conventions on top of this.

---

## 🚚 We Cater Anywhere

Monorepo? Single app? One folder with a `src/` in it and a dream? All fine.

`/setup` asks for four paths (web, api, shared, db). In a **monorepo** those are four separate directories. In a **single-repo / single-app** project, point all four at the same place — even `.` — and the crew switches to splitting by **file pattern** instead of directory:

- routes / controllers / services → 🔥 backend
- components / pages / UI state → 🎨 frontend
- schema / migration files → 📦 data-infra

Same ownership boundaries, same discipline, no monorepo required.

---

## 🧂 Free Toppings

Toppings are free here. Take all of them, take none, nobody's counting. `/setup` offers these and tries to install whatever you pick, falling back to manual instructions if it can't reach them.

The first three are the ones worth taking. Every agent is written around them — Memory Protocol and Token Efficiency Protocol sections, already in the files.

| Topping | What it adds |
|---------|--------------|
| 🧠 **claude-mem** ⭐ | Persistent memory across sessions. This is the one that makes the crew context-independent — they recall past contracts, decisions, and bugs instead of needing them re-explained. |
| 🕸️ **graphify** ⭐ | Codebase → queryable knowledge graph. Agents ask it questions instead of grepping blind. |
| 🎭 **playwright-e2e** | Real E2E test generation and execution for the qa agent. |
| 🛡️ **security-quality-scan** | Dependency / secret / OWASP scanning, wired into qa's security step. |
| ⚡ **RTK** ⭐ *(Rust Token Killer)* | Trims verbose command output — up to ~90% less. Every agent wraps its shell commands in it. |
| 🪶 **Ponytail** | Lazy-senior-dev discipline: YAGNI first, shortest working diff, no cathedral for a shed. |
| 🔍 **find-skills** | Discovers and installs other Claude Code skills on demand. |
| 🦸 **superpowers** | Brainstorming, systematic debugging, TDD, plan-writing. |
| 💅 **ui-ux-pro-max** | Design intelligence — palettes, type, a11y, component patterns — for the frontend guy. |

**None of them are required.** The five guys work fine plain — every agent has a documented fallback path for when memory or the graph isn't there.

---

## 🧠 No Context, No Problem

The usual failure mode of multi-agent setups: agent #4 gets invoked in a fresh session, has no idea what was decided three weeks ago, and confidently rebuilds something that already exists — or asks you to re-explain a decision you already made twice.

Every agent here opens with a **Memory Protocol** instead:

1. **Recall before acting.** With `claude-mem` installed, each agent queries memory first — cheap `search` (~50-100 tokens) before expensive `get_observations`. The architect recalls past contracts and ADRs. QA recalls *what broke here before*, which is the single best predictor of what'll break next.
2. **Fall back to artifacts.** No claude-mem? Each agent has an ordered fallback: `docs/adr/`, shared schema files, migration history, task descriptions, `git log`. Never straight to guessing.
3. **Verify before trusting.** Memory records what *was* true. Agents confirm recalled paths and fields still exist — **and when memory and the code disagree, the code wins**, loudly.
4. **State decisions on the way out.** Every agent closes by emitting `DECISION:` lines so the next session inherits the reasoning, not just the diff.

Paired with a **Token Efficiency Protocol** in each agent — `rtk` wrapping every shell command, `graphify` answering structural questions instead of blind grep — so the window stays wide enough to actually think.

---

## 🥜 Why This Exists *(free peanuts while you read)*

Three things make this work, and they're the whole recipe:

1. **Contract-first** — shared schemas are the single source of truth. Write the contract, *then* cook. No "I assumed the API returned an array."
2. **Layer ownership** — every file has exactly one owner. No two agents editing the same schema and arguing about it in the diff.
3. **Handoff protocol** — structured tickets instead of implied context. The next guy always knows exactly what he's getting.

Decoupled from any project's names, paths, or stack — so it travels. Same five specialists, every order, no waiting for a table.

---

## 🗄️ Behind the Counter

```
five-guys/
  .claude-plugin/plugin.json          # Plugin manifest
  .claude-plugin/marketplace.json     # Lets this repo self-serve as a marketplace
  commands/setup.md                   # The /setup wizard
  agents/
    architect.md                        # System design, contracts, ADR
    backend.md                          # API, services, business logic
    frontend.md                         # UI, forms, dashboards
    data-infra.md                       # Schema, migrations, auth, CI
    qa.md                               # E2E tests, security audit, acceptance
  skills/
    agent-coordination/SKILL.md         # Workflow, handoff protocol
    project-conventions/SKILL.md        # Naming, project layout, DoD
  setup.sh                              # CLI fallback for templating
```

Claude Code finds this plugin automatically when `.claude/plugins/five-guys/` exists with a valid `plugin.json`, and picks up `/setup` from `commands/setup.md` the same way. `.claude-plugin/marketplace.json` lets this one repo double as its own marketplace — which is why `/plugin install` works with zero manual copying.

---

<sub>**MIT** · **v1.1.0** · Not affiliated with any burger chain. No peanuts included. Fries sold separately. 🍟</sub>

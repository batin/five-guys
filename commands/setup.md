---
name: setup
description: "Configure five guys for this project — paths, package manager, working mode, and optional skills."
---

You are running the five guys setup wizard. Follow these steps in order. Be conversational but efficient — don't re-ask something already given in `$ARGUMENTS`.

## Step 0 — Locate the plugin

Find this plugin's own directory (it contains `agents/`, `skills/`, `setup.sh`, `.claude-plugin/plugin.json`) relative to where this command was invoked — normally `.claude/plugins/five-guys/` under the current project root. Verify `agents/` and `skills/` both exist there. If not found, tell the user and stop.

## Step 1 — Core project config

If `$ARGUMENTS` contains positional values in the same order as `setup.sh` (ProjectName, PkgManager, WebPath, ApiPath, SharedPkgPath, DbPkgPath, Modules, WorkingMode, SelectedSkills — the last two optional), use those directly and skip the corresponding questions below. Otherwise ask the user (batch into as few AskUserQuestion calls as reasonable, or plain questions if AskUserQuestion isn't available):

- **Project name** (required, no default)
- **Package manager**: npm / pnpm / yarn / bun (default `pnpm`)
- **Repo layout**: monorepo (separate frontend/backend/shared/db directories) or single-repo/single-app (no such split). This only changes the defaults below — either way the kit works the same.
  - If **monorepo**: ask the next four paths normally.
  - If **single-repo/single-app**: default all four paths below to the same value (e.g. `.` or `src`) unless the user names distinct ones. Tell the user the agents will then tell their areas apart by file/module pattern (routes vs components vs schema files) instead of by directory — this is expected and documented in `project-conventions`.
- **Frontend/web app path** (default `apps/web`, or the single-repo path chosen above)
- **Backend/API app path** (default `apps/api`, or the single-repo path chosen above)
- **Shared package path** (schemas/DTOs/constants) (default `packages/shared`, or the single-repo path chosen above)
- **DB package path** (schema/migrations/seed) (default `packages/db`, or the single-repo path chosen above)
- **Modules/domains** — comma-separated business module names used in card IDs (e.g. `ORD,INV`) (default `CORE`)

## Step 2 — Working mode

Ask the user whether they want to work in **sprint mode** or **normal mode**:

- **Sprint mode**: Jira/Trello-style — work is tracked as cards on a board, grouped into sprints, with card IDs (`[MODULE-LAYER-SEQ]`), a sprint-closing checklist, and a QA gate before a sprint is considered closed. Choose this if the team already runs sprints in a tool like Jira, Trello, or Linear.
- **Normal mode**: continuous flow — the same architect → data-infra/backend → frontend → QA handoff sequence and contract-first discipline, but without card IDs, boards, or sprint gates. Handoffs are just notes/comments. Choose this if there's no formal sprint process.

Note: this only changes vocabulary and workflow framing in the shipped skill files. It does **not** connect to any real Jira/Trello/Linear API — if the user wants live board integration, that's a separate MCP server they'd configure themselves (e.g. a Trello MCP), unrelated to this kit.

Store the answer as `WORKING_MODE` (`sprint` or `normal`).

## Step 3 — Optional skills menu

Present these 9 candidate skills/tools as a multi-select choice ("pick any that apply, or none").

**Recommend the top three by default** — `claude-mem`, `graphify`, and `RTK` are what let the agents work without depending on conversation context, and every agent file already has a Memory Protocol and Token Efficiency Protocol written around them. Say so when presenting the menu.

| Skill | Purpose |
|-------|---------|
| **claude-mem** ⭐ | Persistent memory across sessions — captures what agents do and injects it back later. This is what makes the agents context-independent: they recall past contracts, decisions, and bugs instead of needing them re-explained. |
| **graphify** ⭐ | Turns the codebase into a queryable knowledge graph — agents use it instead of raw grep for architecture questions. |
| **playwright-e2e** | Playwright-based end-to-end test generation and execution — useful for the QA agent's E2E scenarios. |
| **security-quality-scan** | Automated dependency/secret/OWASP security scanning — used by the QA agent's security-scan step. |
| **RTK (Rust Token Killer)** ⭐ | Token-optimized CLI proxy that trims verbose command output — all 5 agents are written to wrap their shell commands in it. |
| **Ponytail** | A "lazy senior developer" output-discipline mode (YAGNI-first, minimal diffs) — useful for backend/frontend agents to avoid over-engineering. |
| **find-skills** | Helps discover and install other Claude Code skills on demand. |
| **superpowers** | A broader skill pack (brainstorming, systematic debugging, TDD, plan-writing) that complements the 5-agent workflow. |
| **ui-ux-pro-max** | UI/UX design intelligence (styles, palettes, accessibility, component patterns) — useful for the frontend agent. |

Record the user's selection as `SELECTED_SKILLS` (a list of names, or "none").

## Step 4 — Install selected skills

For each skill the user selected, attempt an automatic install via Bash, e.g. `claude plugin install <name>@<marketplace>` (or the marketplace-specific equivalent — check `claude plugin marketplace list` / existing `.claude` config for known marketplace sources first). If the install command fails or no marketplace source is known for that skill in this environment, don't retry — instead print clear manual install instructions (marketplace name + command, or a note that it's a personal/local tool the user needs to set up themselves, as is the case for `rtk`).

Known install paths:
- **claude-mem** — `/plugin marketplace add thedotmack/claude-mem` then `/plugin install claude-mem`, or `npx claude-mem install`. Note it needs a one-time browser sign-in (email magic link) to provision a memory key, and that it then works automatically via session hooks while also exposing `search` / `timeline` / `get_observations` MCP tools the agents query directly.
- **graphify** — needs an initial `graphify update .` to build the graph before agents can query it.
- **rtk** — a local CLI binary, not a plugin; if it's not on `PATH`, tell the user rather than trying to install it.

After attempting installs, ask the user once: **"Initialize/run these now, or just record them for later?"**
- If **now**: run each one's first-run step — `graphify update .` to build the graph, and for claude-mem, confirm the sign-in is done and a session hook is registered.
- If **later**: just leave the recorded selection — don't run anything else.

Whatever the user picks, remind them the agents degrade gracefully: each has a documented fallback path (ADRs, schema files, task descriptions, `git log`) for when memory or the graph isn't available. Nothing here is a hard dependency.

## Step 5 — Apply the templating

Read each of the 5 files in `agents/` and the 2 files in `skills/*/SKILL.md`. For each file, use Edit to:

1. Replace every occurrence of `{{PROJECT_NAME}}`, `{{PKG_MANAGER}}`, `{{WEB_APP_PATH}}`, `{{API_APP_PATH}}`, `{{SHARED_PKG_PATH}}`, `{{DB_PKG_PATH}}`, `{{MODULES}}` with the values collected in Step 1.
2. Replace `{{SELECTED_SKILLS}}` (only present in `skills/project-conventions/SKILL.md`) with a short bullet list of the skills selected in Step 3 (or "None selected." if none).
3. For the two mode blocks in `skills/agent-coordination/SKILL.md` (delimited by `<!-- SPRINT MODE START/END -->` and `<!-- NORMAL MODE START/END -->`): delete the block that does **not** match `WORKING_MODE`, including its markers, and delete the markers (but keep the content) of the block that does match — so the shipped file reads as one coherent mode with no leftover HTML comments.

Do this with direct Read + Edit calls, not by shelling out to `setup.sh` (gives per-file visibility if something unexpected is found, e.g. a placeholder already replaced).

## Step 6 — Confirm and summarize

After all edits, run `grep -rn '{{' agents skills` (relative to the plugin directory) to confirm no placeholders remain — if any are found, fix them before finishing. Then print a summary:

```
✅ five guys configured
   Project: <name>
   Paths: <web> | <api> | <shared> | <db>
   Modules: <modules>
   Mode: <sprint|normal>
   Optional skills: <list or "none">
```

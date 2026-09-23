#!/bin/bash
# five guys setup — fills {{PLACEHOLDER}} values in agents/ and skills/ in place.
# This is the non-interactive/CI fallback. For an interactive, guided setup
# (working mode, optional skills), run the `/setup` slash command in Claude Code instead.
# Usage: ./setup.sh "ProjectName" "pnpm" "apps/web" "apps/api" "packages/shared" "packages/db" \
#                   "FEAT,BUG" "normal" "claude-mem, graphify, rtk"
#   $1 project name (required)          $6 db package path
#   $2 package manager                  $7 comma-separated modules
#   $3 web/frontend path                $8 working mode: sprint | normal
#   $4 api/backend path                 $9 optional skills, free text (recorded only)
#   $5 shared package path
#
# Works for a monorepo (four distinct paths) or a single-repo/single-app project
# (pass the same path, e.g. ".", for all four — agents then split by file pattern).
#
# NOTE: this script only templates files. It does NOT install the optional skills
# ($9 is recorded as text). The agents reference claude-mem, graphify and rtk and
# degrade gracefully without them — but if you want them actually installed, use
# the /setup slash command instead.
set -euo pipefail

PROJECT_NAME=${1:?"project name required"}
PKG_MANAGER=${2:-pnpm}
WEB_APP_PATH=${3:-apps/web}
API_APP_PATH=${4:-apps/api}
SHARED_PKG_PATH=${5:-packages/shared}
DB_PKG_PATH=${6:-packages/db}
MODULES=${7:-CORE}
WORKING_MODE=${8:-normal}
SELECTED_SKILLS=${9:-"(none selected — run /setup in Claude Code to pick optional skills)"}

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Validate required directories exist
if [[ ! -d "$DIR/agents" ]]; then
  echo "❌ Error: agents/ directory not found in $DIR"
  exit 1
fi

if [[ ! -d "$DIR/skills" ]]; then
  echo "❌ Error: skills/ directory not found in $DIR"
  exit 1
fi

if [[ "$WORKING_MODE" != "sprint" && "$WORKING_MODE" != "normal" ]]; then
  echo "❌ Error: working mode must be 'sprint' or 'normal', got '$WORKING_MODE'"
  exit 1
fi

replace() {
  local pattern="$1"
  local replacement="$2"

  # Escape sed-special characters in both pattern and replacement: \ / &
  # (the old character class omitted the backslash despite the comment claiming it)
  replacement=$(printf '%s\n' "$replacement" | sed -e 's|[\\/&]|\\&|g')
  pattern=$(printf '%s\n' "$pattern" | sed -e 's|[\\/&]|\\&|g')

  find "$DIR/agents" "$DIR/skills" -type f -name "*.md" -print0 \
    | xargs -0 sed -i.bak "s/${pattern}/${replacement}/g"
}

replace "{{PROJECT_NAME}}" "$PROJECT_NAME"
replace "{{PKG_MANAGER}}" "$PKG_MANAGER"
replace "{{WEB_APP_PATH}}" "$WEB_APP_PATH"
replace "{{API_APP_PATH}}" "$API_APP_PATH"
replace "{{SHARED_PKG_PATH}}" "$SHARED_PKG_PATH"
replace "{{DB_PKG_PATH}}" "$DB_PKG_PATH"
replace "{{MODULES}}" "$MODULES"
replace "{{SELECTED_SKILLS}}" "$SELECTED_SKILLS"

# Strip the mode block that doesn't apply (keep the other mode's content, drop its markers)
strip_mode_block() {
  local mode_to_strip="$1" # SPRINT or NORMAL
  find "$DIR/skills" -type f -name "*.md" -print0 | while IFS= read -r -d '' f; do
    sed -i.bak "/<!-- ${mode_to_strip} MODE START -->/,/<!-- ${mode_to_strip} MODE END -->/d" "$f"
  done
}

if [[ "$WORKING_MODE" == "sprint" ]]; then
  strip_mode_block "NORMAL"
  # Remove the now-unused SPRINT markers, keep the content between them
  find "$DIR/skills" -type f -name "*.md" -print0 \
    | xargs -0 sed -i.bak -e '/<!-- SPRINT MODE START -->/d' -e '/<!-- SPRINT MODE END -->/d'
else
  strip_mode_block "SPRINT"
  find "$DIR/skills" -type f -name "*.md" -print0 \
    | xargs -0 sed -i.bak -e '/<!-- NORMAL MODE START -->/d' -e '/<!-- NORMAL MODE END -->/d'
fi

# Verify replacements were made
if grep -r '{{' "$DIR/agents" "$DIR/skills" >/dev/null 2>&1; then
  echo "⚠️  Warning: Some placeholders may not have been replaced"
fi

find "$DIR" -name "*.bak" -delete

echo "✅ five guys configured for $PROJECT_NAME"
echo "   Paths: $WEB_APP_PATH | $API_APP_PATH | $SHARED_PKG_PATH | $DB_PKG_PATH"
echo "   Modules: $MODULES"
echo "   Mode: $WORKING_MODE"

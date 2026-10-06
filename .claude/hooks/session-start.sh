#!/bin/bash
# Restore project tooling (Playwright CLI) in Claude Code on the web sessions.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"
npm install --no-audit --no-fund --loglevel=error

# The web container ships Chromium at /opt/pw-browsers instead of Google Chrome,
# which playwright-cli looks for by default.
if [ -x /opt/pw-browsers/chromium ] && [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  {
    echo 'export PLAYWRIGHT_MCP_BROWSER=chromium'
    echo 'export PLAYWRIGHT_MCP_EXECUTABLE_PATH=/opt/pw-browsers/chromium'
  } >> "$CLAUDE_ENV_FILE"
fi

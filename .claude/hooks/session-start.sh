#!/bin/bash
# Bootstrap workspace tooling in Claude Code on the web sessions.
# Playwright CLI is installed globally (outside the repo) so it never touches
# the dependencies or build of a TGK theme/source package extracted here.
set -uo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

PLAYWRIGHT_CLI_VERSION=0.1.22

if [ "$(playwright-cli --version 2>/dev/null)" != "$PLAYWRIGHT_CLI_VERSION" ]; then
  npm install -g --no-audit --no-fund --loglevel=error "@playwright/cli@$PLAYWRIGHT_CLI_VERSION" \
    || echo "session-start: could not install @playwright/cli@$PLAYWRIGHT_CLI_VERSION" >&2
fi

# The web container ships Chromium at /opt/pw-browsers instead of Google Chrome,
# which playwright-cli looks for by default.
if [ -x /opt/pw-browsers/chromium ] && [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  {
    echo 'export PLAYWRIGHT_MCP_BROWSER=chromium'
    echo 'export PLAYWRIGHT_MCP_EXECUTABLE_PATH=/opt/pw-browsers/chromium'
  } >> "$CLAUDE_ENV_FILE"
fi

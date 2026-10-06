# CLAUDE.md

## Priority

TGK-specific instructions, the `tgk-working-rules` skill, and explicit instructions from the user always take priority over any generic design skill or reference below. If a generic skill disagrees with them, follow the TGK rules.

## Frontend design toolkit

Project skills live in `.claude/skills/`. Each has one job; they work together in sequence rather than all steering the design at once.

| Tool | Role | When to use |
|---|---|---|
| `design-taste-frontend` | Primary design judgment and art direction | Normal frontend design and redesigns: layouts, typography, spacing, colors, components, landing pages, article layouts, navigation. |
| `web-design-guidelines` | Standards, accessibility and UX audit | After meaningful UI implementation, or when reviewing an existing UI. Checks accessibility, UX, interaction, typography, forms, images, responsive behavior and performance-related UI issues. It reviews; it does not set the design direction. |
| `image-to-code` | Visual-reference implementation | Only when the user provides a screenshot, mockup, visual reference or existing site to reproduce, explicitly asks for an image-first workflow, or wants a visual reference implemented very faithfully. |
| `playwright-cli` | Rendered-browser verification | After meaningful frontend changes, to inspect what was actually built (see below). |
| awesome-design-md | Optional reference library (not a skill) | Only when the user explicitly asks for inspiration from a specific design system (see below). |

Do not use any of these for backend or other non-design work.

### Workflow for a substantial frontend change or redesign

1. TGK requirements and context (TGK rules, existing theme and brand).
2. `design-taste-frontend` for design decisions.
3. Implementation.
4. `playwright-cli` visual inspection of the rendered result.
5. `web-design-guidelines` audit.
6. Fix the meaningful issues found.
7. Final `playwright-cli` verification.

When the task is driven by a reference image, `image-to-code` replaces or augments steps 2-3 only; the verification and audit steps still apply.

Scale this to the change: small edits (a single CSS tweak, copy change) need no audit or browser run. Use Playwright and the guidelines audit for meaningful visual changes and final QA.

### `image-to-code` limits

This skill is written for an image-first workflow and says to generate design images itself. Despite its own description, it is not the default for design tasks here; `design-taste-frontend` is. If image generation is not available in the session, do not pretend to generate images and do not block the work: use the skill only with a real reference the user supplied, or fall back to `design-taste-frontend`.

### `playwright-cli`

`@playwright/cli` is a project dev dependency (`package.json`). Run it as `npx playwright-cli ...`. Use it to open the site or a local preview, read the rendered page snapshot, check desktop and mobile viewports (`resize`), take screenshots when useful, exercise layout and interactions, catch obvious visual regressions, and check console errors (`console`).

In Claude Code on the web, `.claude/hooks/session-start.sh` runs `npm install` and points Playwright at the container's Chromium (`PLAYWRIGHT_MCP_BROWSER=chromium`, `PLAYWRIGHT_MCP_EXECUTABLE_PATH=/opt/pw-browsers/chromium`). The web sandbox's network policy may block external sites, including theseguysknow.io; serve the page locally (for example `python3 -m http.server`) and open the `http://127.0.0.1` URL. Output goes to `.playwright-cli/`, which is gitignored; never commit it.

### awesome-design-md reference library

[VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md) is a collection of DESIGN.md files describing other companies' design systems. It is not installed in this repo.

Only when the user explicitly asks to take inspiration from one of these design systems, fetch the relevant file, e.g. `https://raw.githubusercontent.com/VoltAgent/awesome-design-md/main/design-md/<slug>/DESIGN.md` (slugs are the folder names under `design-md/`, such as `wired`, `theverge`, `notion`, `stripe`), and use its useful principles as a reference.

- Never apply another company's design system to TGK automatically.
- Never overwrite TGK's own identity or copy a brand's design verbatim (names, logos, proprietary fonts, signature colors, distinctive layouts).
- TGK-specific design rules remain the source of truth.

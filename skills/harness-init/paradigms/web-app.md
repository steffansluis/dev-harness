# Paradigm: web-app

A browser-based application with a visual user interface, user-facing text, and
public-facing API or component library. Typically built with React, Next.js, Vue,
or similar. Requires design sign-off, visual regression tracking, and localisation readiness.

## Use When

- The project renders HTML/CSS for end users
- Tasks produce visible UI changes (screens, components, pages)
- The project is expected to support multiple locales now or in the future
- There is a documented public API or component API

---

## Enabled Gates

| Gate | Enabled | Reason |
|------|---------|--------|
| design | yes | UI features need design artefacts before implementation to avoid rework |
| readme | yes | Component and API changes must be reflected in documentation |
| acceptance | yes | User-visible features require e2e verification through the browser |
| screenshots | yes | Visual changes need before/after artefacts to catch regressions |
| i18n | yes | User-facing strings must use localisation helpers from the start |

---

## Stack Notes

Typical stacks: React + TypeScript, Next.js, Vue, SvelteKit.
Test runner: Playwright or Cypress for acceptance; Vitest or Jest for unit.
CI: acceptance and screenshot-diff gates run on PR open (remote).

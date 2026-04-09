---
layer: quality_ops
canonical: true
last_updated: 2026-04-09
---

# Accessibility Specification

> **Upstream**: `qa_acceptance_packs.md`, `design_system_tokens.md`, shared screen specs in `docs/03_screens/shared/`

This file defines the minimum accessibility implementation contract for web, mobile, admin, and shared surfaces.

## 1. Baseline Standard

- Target: **WCAG 2.1 AA**
- Accessibility is a release-quality requirement for all user-facing surfaces.
- Shared screen specs are the fallback source for default accessible patterns when a feature/screen spec does not restate them.

## 2. Global Rules

1. Every interactive control must have a programmatically determinable label.
2. Color must never be the only carrier of state, severity, or progress.
3. Keyboard-only users must be able to complete every primary workflow on web/admin surfaces.
4. Screen-reader output must include status changes, validation errors, and destructive confirmations.
5. Focus order must match visual and logical reading order.

## 3. Web / Admin Requirements

| Area | Requirement |
|---|---|
| Navigation | Use semantic landmarks: `header`, `nav`, `main`, `aside`, `footer` where applicable |
| Dialogs / drawers | Must use focus trap, Escape to close when safe, return focus to invoker |
| Forms | Inputs need labels, errors, help text, and invalid state exposed programmatically |
| Tables | Sort/filter/pagination controls must be keyboard reachable and screen-reader labeled |
| Live status | Use polite/assertive announcements for async states, toasts, and job/progress updates |
| Shortcuts | Keyboard shortcuts must have discoverable fallback UI and must not block native assistive tech patterns |

## 4. Mobile Requirements

| Area | Requirement |
|---|---|
| Flutter semantics | Use `Semantics` labels for icons, badges, dynamic values, and chart summaries |
| Gestures | Any swipe/long-press action must have a tap-accessible alternative |
| Dynamic updates | Important state changes must use accessible announcements, not only animation |
| Hit targets | Primary actions and row controls must remain comfortably tappable on small devices |

## 5. Shared Component Contract

The following shared docs define default accessible behavior and must be reused unless a feature spec explicitly overrides them:

- `screen_shared_app_shell.md`
- `screen_shared_navigation.md`
- `screen_shared_mobile_nav.md`
- `screen_shared_loading_states.md`
- `screen_shared_empty_states.md`
- `screen_shared_error_states.md`
- `screen_shared_confirmations.md`
- `screen_shared_command_palette.md`
- `screen_shared_trust_badge.md`

## 6. Required Checks

| Check | Minimum expectation |
|---|---|
| Keyboard flow | All primary actions reachable and usable without pointer input |
| Focus visibility | Visible focus indicator on all interactive controls |
| Contrast | Meets WCAG 2.1 AA contrast thresholds |
| Form errors | Validation is announced and visually associated with the offending field |
| Dialog behavior | Focus trap + restore focus + accessible title/description |
| Loading / empty / error states | Announced accessibly and not rendered as silent skeleton-only states |

## 7. AI-Agent Implementation Rule

If a specific screen omits accessibility details, the AI coding agent must:

1. apply this file first
2. apply the relevant shared screen spec second
3. only add screen-specific accessible behavior if the owning feature or screen doc explicitly requires it

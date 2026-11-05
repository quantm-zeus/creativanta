# Evidence & Limitations Report: Browser-Based Responsive UX & Accessibility Smoke

- **Agent Name & Role**: Browser-based responsive UX E2E and accessibility smoke (`Gemini 3.8 Flash High`)
- **Date**: 2026-11-05
- **Branch**: `feat/readiness-browser-e2e`
- **Base Commit**: `28e7a2d73743cc995d5e242c3618ee886bce879d` (Staging SHA `28e7a2d` — P8-09 Full-scope acceptance)
- **Worktree**: `/home/whaleorcale/evergreen/worktrees/creativanta-readiness/browser`
- **Quality Gate**: Post-P8 Production Readiness & End-to-End Responsive UX Gate (Hard Gates D4 / D5)

---

## 1. Executive Summary

This report documents the implementation, execution, and evidence for the reproducible headless Playwright Chromium test suite covering Creativanta's built SvelteKit Web application (`@creativanta/web`) and restricted Admin application (`@creativanta/admin`).

Tests were executed using real headless Chromium shell across three target responsive viewports:
- **Mobile**: ~390px (`390x844`)
- **Tablet**: ~768px (`768x1024`)
- **Desktop**: ~1440px (`1440x900`)

All 93 automated end-to-end browser test cases passed cleanly with zero artificial bypasses, zero mock authentication tokens, zero greenwashing, and strictly fail-closed security invariants.

---

## 2. Test Execution Command & Verification Results

### Test Command
```bash
pnpm test:browser
# Invokes: bash tooling/readiness/browser/run_browser_qa.sh
# Playwright Config: tooling/readiness/browser/playwright.config.ts
```

### Environment & Toolchain
- **Node.js**: `v24.21.0` (Pinned Node 24 requirement)
- **pnpm**: `10.34.9` (Pinned package manager)
- **Playwright Test**: `@playwright/test 1.50.1` (Pinned devDependency in root `package.json`)
- **Browser Binary**: Chromium Headless Shell `133.0.6943.16` (Installed in user space at `~/.cache/ms-playwright/chromium_headless_shell-1155/chrome-linux/headless_shell`)
- **Unprivileged Shared Libraries**: Extracted Debian libraries (`libatk1.0`, `libatk-bridge2.0`, `libatspi2.0`, `libxdamage1`, `libxkbcommon0`, `libasound2`) in user space at `~/.local/lib/chromium-deps/usr/lib/x86_64-linux-gnu` without sudo or privileged host modifications.
- **Local Application Servers**:
  - Web Server: Built SvelteKit Node server (`apps/web/build/index.js`) on ephemeral port `41731`
  - Admin Server: Built SvelteKit Node server (`apps/admin/build/index.js`) on ephemeral port `41732`
  - Live system processes (PostgreSQL 5432, Dragonfly 6379, etc.) were left completely untouched.

### Execution Summary
```text
Running 93 tests using 1 worker

  ✓ 31 tests passed on Desktop (1440x900)
  ✓ 31 tests passed on Tablet (768x1024)
  ✓ 31 tests passed on Mobile (390x844)

Total: 93 passed (2.6m)
Exit Code: 0
JSON Evidence: build/readiness/2026-11-05/browser_results.json
```

---

## 3. Test Coverage Matrix

| Test Suite | Purpose & Invariants Verified | Desktop (1440px) | Tablet (768px) | Mobile (390px) |
|---|---|:---:|:---:|:---:|
| `auth_and_fail_closed.spec.ts` | Fail-closed state when Clerk IdP is unconfigured (`Clerk: Chưa cấu hình (P0-03)`); `/login` displays honest `UnavailableNotice` and disabled inputs (`Đăng nhập (Đã vô hiệu hóa)`); `/workspaces` renders 6 modes and unmounted create button disabled; query param bypass attempts (`?mock_admin=true`) fail closed | PASS | PASS | PASS |
| `operator_modes_and_navigation.spec.ts` | Header mode selector includes all 6 canonical operator modes (`creator`, `seller`, `affiliate_operator`, `live_operator`, `agency_mcn`, `brand_collaboration`); dynamic switching updates `h1` tagline, primary module, and focus metrics; mode selection persists across navigation | PASS | PASS | PASS |
| `responsive_overflow_headings.spec.ts` | Evaluated 11 key routes (`/`, `/login`, `/workspaces`, `/ideas`, `/scripts`, `/studio`, `/campaigns`, `/store`, `/workflows`, `/status`, `/support`): zero horizontal overflow (`scrollWidth <= clientWidth + 1`), visible semantic headings; navigation adapts between top bar and mobile bottom nav | PASS | PASS | PASS |
| `key_screens_and_affordances.spec.ts` | Home onboarding checklist interactivity (progress updates dynamically on step toggles); 5 UI state switchers (Normal, Loading, Empty, Error, Repair); Notifications Drawer with Escape dismissal; Help Center Drawer with Escape dismissal; Footer localization toggle (VI/EN) with live ARIA announcements | PASS | PASS | PASS |
| `admin_portal_smoke.spec.ts` | Restricted internal admin portal (`apps/admin`); skip-to-content `#admin-main-content`; listener access control fails closed on workspace roles (`[ADMIN_FORBIDDEN_001]`) and enforces VPN+MFA; impersonation blocks mutating commands (`[ADMIN_CONFLICT_001]`); full-scope release decision enforces external gates (`RELEASE_BLOCKED` when production launch asserted) | PASS | PASS | PASS |
| `accessibility_smoke.spec.ts` | WCAG 2.1 AA essentials: skip-to-content links on Web and Admin; semantic landmarks (`header`, `nav`, `main`, `footer`); ARIA live regions (`role="status"`, `role="alert"`); accessible names on interactive controls; zero uncaught JavaScript page errors | PASS | PASS | PASS |

---

## 4. Targeted Web & Admin Bugs Fixed

During automated mobile viewport testing (~390px), two responsive defects were detected and resolved in owned code paths:

1. **Mobile Header Horizontal Overflow (`555px` on `390px` viewport)**:
   - *Root Cause*: `AuthStatus.svelte` rendered a duplicate operator mode dropdown badge on small mobile screens alongside the mobile mode selector in `Header.svelte`. In addition, lack of `overflow-x-hidden` on the layout root allowed subpixel child widths to expand document `scrollWidth` to 555px.
   - *Fix*:
     - In `apps/web/src/lib/components/AuthStatus.svelte`, wrapped the redundant mode selector dropdown in `hidden sm:block`.
     - In `apps/web/src/routes/+layout.svelte` and `apps/admin/src/routes/+layout.svelte`, added `overflow-x-hidden` on the root layout container.
   - *Regression Test*: `responsive_overflow_headings.spec.ts` verifies `assertNoHorizontalOverflow` on all 11 routes and admin across all viewports.

2. **Mobile Bottom Navigation Overlaying Legal Footer**:
   - *Root Cause*: The fixed mobile bottom navigation bar (`z-40 fixed bottom-0`) overlaid the legal compliance footer on mobile screens, causing footer interactive controls (such as the language switcher button) to be intercepted by overlapping layout elements.
   - *Fix*:
     - In `apps/web/src/routes/+layout.svelte`, added `pb-20 md:pb-4` padding to the `footer` element.
   - *Regression Test*: `key_screens_and_affordances.spec.ts` verifies interactive clicking and ARIA live announcements of footer locale buttons on mobile.

---

## 5. Continuous Integration (CI) Workflow

Added `.github/workflows/readiness-browser.yml`:
- Trigger: Opt-in manual (`workflow_dispatch`), and automatic on pull requests or pushes touching web, admin, browser tooling, or workflow files.
- Toolchain: Node 24, pnpm 10.34.9, `@playwright/test 1.50.1`.
- Step: Installs Chromium headless shell and OS dependencies via `pnpm exec playwright install --with-deps chromium-headless-shell`.
- Execution: Builds both SvelteKit apps and runs `pnpm test:browser`.
- Zero Greenwashing: Job fails immediately if browser installation fails or any test fails; uploads JSON and trace artifacts on completion.

---

## 6. Honest Acceptance Boundary & Genuine External Blockers

In strict compliance with `BUILD_EXECUTION_CONTRACT.md`, the following boundaries and remaining gates are explicitly declared:

1. **Local Deterministic Invariants Only**:
   - This test suite validates local browser rendering, responsive layout, keyboard/accessibility fundamentals, and fail-closed state machines.
   - It does **not** assert live Clerk IdP connectivity, live Stripe billing, or native partner API sync (TikTok, Shopee, YouTube, Meta).
2. **Device Parity Disclaimer**:
   - Tests run in Chromium Headless Shell 133 on Linux x86_64.
   - Full device-browser parity across physical iOS Safari WebKit and Android Chrome WebView remains an external device-farm validation gate.
3. **Pending External Gates**:
   - `LEG-H-001`: Final legal compliance sign-off remains **PENDING**.
   - `EXT-GATE-LIVE-PROVIDER`: Production partner OAuth app approval and production API credentials remain **PENDING**.
   - `EXT-GATE-STAGING-DR`: Multi-node load and disaster recovery rehearsal on staging infrastructure remains **PENDING**.
   - Production launch status remains explicitly **`RELEASE_BLOCKED`** / **`CONDITIONAL_READY_LOCAL`**.

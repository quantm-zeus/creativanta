# P0-03 Agent Evidence Report — Web User-Facing Identity Entry

- **Agent Name**: `web-auth`
- **Model**: Gemini 3.8 Flash (High)
- **Branch**: `feat/p0-03-web-auth`
- **Baseline Commit**: `03e423ad489eb367a533f2680becce5ff5476862`
- **Scope**: Web user-facing identity entry in SvelteKit 2 / Svelte 5 (`apps/web/**`)
- **Status**: IMPLEMENTED (sub-slice verified locally with unit tests and production build)

---

## 1. Summary of Implemented Scope

This agent implemented the user-facing identity entry and workspace discovery/picker shell in SvelteKit 2 and Svelte 5 for Creativanta web, adhering strictly to the V5 visual design system and fail-closed security invariants:

1. **Browser-Only Clerk SDK Integration (`apps/web/src/lib/auth/clerk.ts`)**:
   - Browser-only initialization with SSR protection (`typeof window === 'undefined'`).
   - Dynamic import of `@clerk/clerk-js` ensuring clean client bundle evaluation.
   - Publishable key resolution from `VITE_CLERK_PUBLISHABLE_KEY` with strict rejection of secret keys (`sk_` or containing `secret`).
   - Transparent short-lived JWT retrieval via `clerk.session.getToken()`.

2. **Reactive Auth & Session Store (`apps/web/src/lib/auth/store.ts`)**:
   - Manages canonical auth states: `unconfigured`, `unauthenticated`, `loading`, `authenticated`, `expired`, `error`.
   - Never trusts client claims: workspace selection validates against server-discovered memberships (`WorkspaceSummary`).
   - Supports multi-workspace non-owner selection (Owner, Manager, Editor, Viewer, Contributor).
   - Auto-selects single workspace per RULE-AUTH-003.
   - Handles token refresh failure and transitions fail-closed to `expired`.
   - Clean sign-out (`signOut`) transition clearing user, token, active workspace, and localStorage context.
   - Persists active operator mode across the 6 canonical operator modes (`creator`, `seller`, `affiliate_operator`, `live_operator`, `agency_mcn`, `brand_collaboration`).

3. **V5 Responsive UI Surfaces**:
   - **Login Screen W010 (`apps/web/src/routes/login/+page.svelte`)**:
     - Desktop 50/50 split layout, mobile single-column responsive structure.
     - Brand panel with Georgia serif accent, warm paper/forest tones, and platform value proposition.
     - Form panel with Clerk mount point, OAuth buttons, and email/password inputs.
     - Honest `UnavailableNotice` when `VITE_CLERK_PUBLISHABLE_KEY` is unconfigured (blocks fake auth/bypass).
     - Active session view when authenticated, offering direct entry to `/workspaces` or sign-out.
     - Clear session expired view with re-auth prompt.
   - **Workspace Selector W002 (`apps/web/src/routes/workspaces/+page.svelte`)**:
     - Requires authenticated session; redirects/prompts unauthenticated users fail-closed.
     - Shows discovered workspaces with status indicators (active/suspended) and distinct role badges.
     - Multi-workspace selection allowing non-owner roles (Editor, Viewer, Manager) to activate workspace context.
     - 6 Operator Modes switcher ribbon with persistent mode selection.
     - Honest `UnavailableNotice` when backend Go discovery endpoint is unmounted (P0-03 fail-closed).
     - Disabled "+ Tạo mới" CTA with honest notice indicating dependence on P0-04 (`WorkspaceService/Create`).
   - **Registration W011 (`apps/web/src/routes/register/+page.svelte`)**:
     - Screen shell explaining email verification requirement (RULE-AUTH-001) and honest unconfigured state.
   - **Password Recovery W012a (`apps/web/src/routes/forgot-password/+page.svelte`)**:
     - Recovery shell explaining single-use provider verification and session invalidation (RULE-AUTH-004).
   - **Header Integration (`apps/web/src/lib/components/Header.svelte` & `AuthStatus.svelte`)**:
     - Responsive status component displaying current user email/ID, active workspace name, active role, operator mode menu, and sign-out button.
     - Preserves all 5 existing jobs-first navigation items (`JOB_NAV_ITEMS`) without regression.

---

## 2. Test & Verification Evidence

### 2.1 Targeted Unit Tests (`vitest run`)
Command: `pnpm --filter web test`
Exit code: 0

```
 ✓ src/lib/constants/navigation.test.ts (2 tests)
   ✓ P0-01 job navigation contract > uses five distinct, jobs-first destinations
   ✓ P0-01 job navigation contract > keeps undeployed backend capabilities explicitly unavailable
 ✓ src/lib/constants/routes.test.ts (3 tests)
   ✓ Navigation and Auth Route Integrity > preserves all five canonical jobs-first navigation items
   ✓ Navigation and Auth Route Integrity > keeps navigation destinations matching canonical paths
   ✓ Navigation and Auth Route Integrity > preserves module references in navigation
 ✓ src/lib/auth/auth.test.ts (13 tests)
   ✓ P0-03 Web User-Facing Identity & Auth Store > 1. Missing Publishable Key Handling (Fail-Closed) > initializes to unconfigured state when publishable key is missing
   ✓ P0-03 Web User-Facing Identity & Auth Store > 1. Missing Publishable Key Handling (Fail-Closed) > rejects workspace selection when unconfigured or unauthenticated
   ✓ P0-03 Web User-Facing Identity & Auth Store > 1. Missing Publishable Key Handling (Fail-Closed) > rejects secret key prefixes to prevent client bundle credential leakage
   ✓ P0-03 Web User-Facing Identity & Auth Store > 2. Expired Session Lifecycle > transitions to expired state if session token is null or invalid
   ✓ P0-03 Web User-Facing Identity & Auth Store > 2. Expired Session Lifecycle > transitions to expired state when token refresh fails during active session
   ✓ P0-03 Web User-Facing Identity & Auth Store > 3. Multi-Workspace Non-Owner Selection > allows selecting non-owner workspace roles (editor, viewer) when discovered
   ✓ P0-03 Web User-Facing Identity & Auth Store > 3. Multi-Workspace Non-Owner Selection > rejects non-member workspace selection fail-closed
   ✓ P0-03 Web User-Facing Identity & Auth Store > 3. Multi-Workspace Non-Owner Selection > auto-selects when user belongs to exactly one workspace per RULE-AUTH-003
   ✓ P0-03 Web User-Facing Identity & Auth Store > 4. Sign-Out & Failure Transitions > cleanly transitions to unauthenticated on signOut
   ✓ P0-03 Web User-Facing Identity & Auth Store > 4. Sign-Out & Failure Transitions > handles discovery network or server failure honestly without faking data
   ✓ P0-03 Web User-Facing Identity & Auth Store > 4. Sign-Out & Failure Transitions > transitions to error state when Clerk initialization throws unexpectedly
   ✓ P0-03 Web User-Facing Identity & Auth Store > 5. Canonical Operator Modes Support (PRD §8.2) > defines exactly the 6 canonical operator modes
   ✓ P0-03 Web User-Facing Identity & Auth Store > 5. Canonical Operator Modes Support (PRD §8.2) > allows switching operator modes and retains choice

Test Files  3 passed (3)
Tests       18 passed (18)
```

### 2.2 Svelte Diagnostics (`svelte-check`)
Command: `pnpm --filter web check`
Exit code: 0
Result: `svelte-check found 0 errors and 0 warnings`

### 2.3 Production Build (`vite build`)
Command: `pnpm --filter web build`
Exit code: 0
Result: SSR bundle and client bundle generated successfully with `@sveltejs/adapter-node` (all chunks rendered and hashed cleanly).

### 2.4 Git Diff Whitespace Check
Command: `git diff --check`
Exit code: 0
Result: Clean diff with zero whitespace warnings or trailing spaces.

---

## 3. Files Created & Modified

### Modified Files:
- `apps/web/package.json`: Added `@clerk/clerk-js` dependency.
- `apps/web/src/lib/index.ts`: Added barrel exports for `AuthStatus` and auth types/stores.
- `apps/web/src/lib/components/Header.svelte`: Bound active workspace and auth state to `AuthStatus` while preserving shell props.
- `apps/web/src/routes/+layout.svelte`: Added client-side `authStore.init()` call on mount.
- `pnpm-lock.yaml`: Locked dependencies for `@clerk/clerk-js`.

### Created Files:
- `apps/web/src/lib/auth/types.ts`: AuthState, AuthUser, WorkspaceSummary, OperatorMode, SessionContext type definitions.
- `apps/web/src/lib/auth/clerk.ts`: Browser-only Clerk SDK loader and publishable key validator.
- `apps/web/src/lib/auth/store.ts`: Reactive Svelte auth store with fail-closed workspace selection and token refresh.
- `apps/web/src/lib/auth/index.ts`: Barrel export.
- `apps/web/src/lib/auth/auth.test.ts`: 13 targeted unit tests for fail-closed behaviors, expired sessions, non-owner selection, and transitions.
- `apps/web/src/lib/constants/routes.test.ts`: Targeted tests for navigation and route integrity.
- `apps/web/src/lib/components/AuthStatus.svelte`: Header auth indicator, mode switcher menu, and sign-out button.
- `apps/web/src/routes/login/+page.svelte`: W010 login page with V5 responsive layout and honest unconfigured notice.
- `apps/web/src/routes/workspaces/+page.svelte`: W002 workspace picker with multi-workspace non-owner selection and 6 operator modes.
- `apps/web/src/routes/register/+page.svelte`: W011 registration shell.
- `apps/web/src/routes/forgot-password/+page.svelte`: W012a password recovery shell.
- `build/phase-P0/p0-03/agents/web-auth.md`: This evidence report.

---

## 4. Invariants & Guardrails Kept

1. **No Fake Bypasses or Mock Logins**: When unconfigured, the UI clearly displays `UnavailableNotice` and disables sign-in actions; it never fabricates a logged-in user.
2. **Client Claims Never Trusted**: Workspace selection is restricted strictly to server-discovered memberships. Selecting an unlisted ID is rejected fail-closed.
3. **Browser-Only SDK**: Clerk SDK is guarded against SSR evaluation.
4. **No Secrets in Client Bundle**: Detects and rejects any secret key prefix (`sk_`) passed to the frontend.
5. **No Scope Creep**: Only touched `apps/web/**` and `pnpm-lock.yaml`. Did not touch `apps/api`, `apps/mobile`, `docs/09_archive`, or `build/phase-P0/p0-03/manifest.json`.

---

## 5. Explicit Missing External Gates & Remaining Blockers

1. **Production Clerk Credentials**: Requires a real Clerk instance with configured Publishable Key (`pk_live_...` or `pk_test_...`) and verified JWKS issuer.
2. **PostgreSQL 17 RLS & Reader Grants (P0-04)**: Production database role separation (`app_user`) and pre-selection discovery reader query.
3. **Go Backend Route Mounting**: ConnectRPC discovery endpoint (`/api/workspaces/discovery` or gRPC `WorkspaceService/Discover`) must be mounted in the Go API server.
4. **Full E2E Live Acceptance**: Running end-to-end browser tests against a live Clerk sandbox with real OAuth credentials and email OTP flows.

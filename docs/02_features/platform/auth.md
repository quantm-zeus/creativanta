---
layer: features
module: auth
canonical: true
domain: platform
status: SPECIFIED
last_updated: 2026-10-29
cross_cutting: true
---

# Feature: Authentication & Session Management (Cross-Cutting)

## Purpose

Every module in Creativanta depends on identity — knowing who the user is, what workspace they belong to, and what permissions they hold. Authentication is the entry gate: registration, login, session management, and token lifecycle. Without clear auth contracts, modules make ad-hoc assumptions about identity, sessions expire silently, and security holes emerge from inconsistent enforcement.

Auth exists as the **cross-cutting identity layer** — managing user registration, login (email + social OAuth), MFA, session lifecycle, workspace selection, password reset, invite acceptance, and token management. Built on Clerk as the identity provider with Creativanta-specific workspace scoping.

## Scope

### Covers (auth owns identity and session)
- User registration: email signup, social OAuth signup (Google, Facebook, Apple)
- Login: email/password, social OAuth, magic link
- MFA: TOTP authenticator app (optional for users, mandatory for internal admins)
- Session management: JWT tokens via Clerk, session refresh, logout
- Workspace selection: post-login workspace picker (users can belong to multiple workspaces)
- Password reset: Clerk-supported email-code/link flow; provider-reported expiry and single-use verification
- Invite acceptance: workspace invite → accept → join workspace with assigned role
- Token lifecycle: short-lived Clerk session JWT refreshed by its SDK; provider session lifetime is configured separately
- Account linking: link multiple OAuth providers to same account
- Security events: new device detection, suspicious login alerts

### Does NOT cover (auth boundaries)
- **RBAC enforcement**: auth establishes identity; RBAC matrix (04_contracts) enforces permissions
- **Internal admin auth**: completely separate system (S26 §2.4 — not Clerk, separate MFA + VPN)
- **Public API auth**: API keys + OAuth2 for developers (S24 §3 — handled by API gateway)
- User profile data beyond identity (name, avatar, preferences): workspace settings module

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Anonymous user | None | Register, login, reset password |
| Authenticated user | Any | Logout, switch workspace, manage MFA, manage connected providers |
| Invited user | Pending | Accept invite → complete registration (if new) → join workspace |
| System (Clerk) | IdP | Token issuance, session management, webhook events |
| System (Security) | System | New device detection, brute force protection, security alerts |

## Business Rules

1. **RULE-AUTH-001**: Registration requires: email verification (magic link or OTP) before workspace access. Social OAuth (Google, Facebook, Apple) auto-verifies email. After verification: onboarding flow (operator mode selection, first workspace creation) (PRD §22, §29).
2. **RULE-AUTH-002**: Clerk issues short-lived session JWTs (currently about 60 seconds) and the supported SDK refreshes them. Creativanta does not mint a separate user refresh token. Validate issuer/audience/expiry/signature/authorized parties with JWKS rotation; map sub to users.clerk_id. Resolve current workspace membership/role from local canonical DB on every authorized request; do not trust client-supplied role or stale JWT role claims. Session lifetime/inactivity settings are provider configuration, separate from JWT TTL. Official reference: https://clerk.com/docs/guides/how-clerk-works/overview (checked 2026-10-29).
3. **RULE-AUTH-003**: Workspace selection after login: if user belongs to 1 workspace → auto-select. If multiple workspaces → workspace picker screen. Switching workspaces does NOT require re-authentication — the selected workspace changes in application context; its active membership is checked before any data access. Current workspace persisted in session (PRD §22).
4. **RULE-AUTH-004**: Password reset uses the supported Clerk recovery flow with provider-reported expiry and single-use verification; UI must display expiry/re-request states rather than assume a one-hour custom token. After reset: all existing sessions invalidated → user logs in fresh. Failed reset attempts (>5 in 1h) → temporary account lock (30 min) (Pack 02 §14).
5. **RULE-AUTH-005**: Invite acceptance: existing user → click invite link → accept → join workspace with assigned role. New user → click invite link → registration form → verify email → join workspace. Invite links expire after 7 days. Expired invites can be re-sent by workspace Admin+ (PRD §22).
6. **RULE-AUTH-006**: MFA: optional for regular users (encouraged for Owner/Admin roles). MFA methods: TOTP authenticator app (Google Authenticator, Authy). SMS-based MFA NOT supported (security concern). MFA toggle in account settings. Once enabled: required on every login from new device (Pack 02 §14).
7. **RULE-AUTH-007**: Security events: login from new device/IP → email notification to user. Brute force protection: >10 failed login attempts in 5 min → temporary block (30 min). Account compromise suspected: force password reset + invalidate all sessions. All security events logged for audit (Pack 02 §14, S26 §12.3).
8. **RULE-AUTH-008**: Clerk webhook integration: Clerk emits events on user/org lifecycle changes → `POST /webhooks/clerk` → system processes: user.created, user.updated, user.deleted, session.created, session.ended, organizationMembership.created, organizationInvitation.accepted. These events maintain Creativanta's user record in sync with Clerk (API map §3, webhook endpoints).

## Main Flow

### Registration
1. User visits signup page
2. Chooses method: email/password OR social OAuth (Google/Facebook/Apple)
3. Email method: fill form → receive verification email → click link → verified
4. Social OAuth: redirect to provider → authorize → auto-verified
5. After verified Clerk sign-in, synchronously idempotent-upsert the user from verified provider identity; user.created webhook is reconciliation and must not block onboarding
6. Onboarding: select operator mode (6 options) → create first workspace → guided setup
7. Session established: Clerk SDK establishes and maintains the provider session

### Login
1. User visits login page
2. Chooses method: email/password, social OAuth, magic link
3. Email/password: enter credentials → validate → success / failure
4. If MFA enabled: enter TOTP code → validate
5. Social OAuth: redirect → authorize → return with identity
6. Workspace selection: auto (1 workspace) or picker (multiple)
7. Session established: Clerk session and short-lived JWT
8. `session.created` webhook → system updates last_active

### Logout
1. User clicks logout
2. Current session invalidated
3. Client-side: tokens cleared, redirected to login page
4. `session.ended` webhook → system records

### Password Reset
1. User clicks "Forgot password" on login page
2. Enter email → Clerk recovery code/link, single-use and provider-reported expiry
3. User clicks link → enters new password → confirmed
4. All existing sessions invalidated → user logs in fresh
5. Security email: "Your password was changed. If this wasn't you, contact support."

### Invite Acceptance
1. User receives invite email with workspace invitation link
2. Click link → redirect to Creativanta
3. If existing user: review invitation → accept → join workspace → redirect to workspace
4. If new user: registration form → verify email → join workspace → onboarding
5. `organizationMembership.created` webhook → system assigns role

## Edge Cases

### EC-AUTH-001: Social OAuth Provider Returns Different Email
- Condition: User registered with email@example.com but Google OAuth returns different email
- Expected behavior: If a matching Clerk user exists by provider identity: link accounts. If no match and different email: create new account. User can merge accounts later in settings. System warns if email domains differ during account linking.
- Reference: RULE-AUTH-001

### EC-AUTH-002: Session Expired During Active Work
- Condition: Access token expires while user is actively editing (e.g., workflow builder)
- Expected behavior: Clerk SDK refreshes the short-lived session token transparently. If the provider session has ended: modal "Your session expired. Please log in again." with session restore after re-auth (navigate back to same page). Unsaved work preserved via local storage draft.
- Reference: RULE-AUTH-002

### EC-AUTH-003: User Removed from Workspace While Active
- Condition: Admin removes user from workspace while user has active session
- Expected behavior: `organizationMembership.deleted` webhook fires → next API call with old workspace_id returns 403 → client redirects to workspace picker. If only workspace: redirect to "You've been removed from [Workspace]. [Create new workspace] [Contact admin]." Session remains valid for other workspaces.
- Reference: RULE-AUTH-003

### EC-AUTH-004: Invite Link Used After Expiration
- Condition: User clicks invite link after 7-day expiry
- Expected behavior: "This invitation has expired. Ask the workspace admin to send a new invite." Clear message, no confusing error. Link cannot be reused — workspace Admin must re-send.
- Reference: RULE-AUTH-005

### EC-AUTH-005: Concurrent Login Limit
- Condition: Regular user has no concurrent session limit (can be logged in on web + mobile)
- Expected behavior: Multiple concurrent sessions allowed for regular users. Each session has its own token pair. Logging out one session does not affect others. "Active sessions" list available in account settings. User can terminate individual sessions.
- Reference: RULE-AUTH-002

## State Machine

### User Account State

| State | Description |
|---|---|
| pending_verification | Registered but email not verified |
| active | Email verified, can access workspaces |
| suspended | Admin-suspended (S26) — cannot log in |
| deleted | GDPR deletion processed — all data removed |

### Session State

| State | Description |
|---|---|
| active | Valid Clerk session maintained by SDK |
| expired | Session JWT expired; SDK attempts refresh against live provider session |
| invalidated | Explicitly logged out or force-terminated |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| API — webhooks | [04_contracts/api_endpoint_map.md](../../04_contracts/api_endpoint_map.md) | §3 (POST /webhooks/clerk — user/org lifecycle events) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../../04_contracts/rbac_permission_matrix.md) | §1 (workspace role hierarchy, role assignment rules) |
| DB | [04_contracts/database_schema.md](../../04_contracts/database_schema.md) | §4.2 (users — `clerk_id`), §4.3 (workspace_members) |
| Events | [04_contracts/domain_event_catalog.md](../../04_contracts/domain_event_catalog.md) | §2 (workspace.created, account.connected). [NOTE: `user.created`, `user.updated`, `session.created`, `session.ended` are Clerk webhook events (see RULE-AUTH-008), not Creativanta domain events — they are processed via `POST /webhooks/clerk`, not emitted to the domain event bus.] |
| Pack 02 | Security/Auth contract | §14 (session management, MFA, brute force) |
| S26 | Internal Admin Auth <!-- Legacy ref: creativanta_supplementary_s26_internal_admin_operations_v_3_1.md — superseded by current feature docs + contract layer --> | §2.4 (separate auth for internal admins — NOT Clerk) |
| Pack 03 | Email contract | §11B (account-related transactional emails) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Registration | Email/password form, social OAuth buttons, terms acceptance |
| Web | Login | Email/password, social OAuth, magic link, MFA input |
| Web | Workspace picker | Grid/list of workspaces user belongs to, "Create new" button |
| Web | Password reset | Email input → confirmation → new password form |
| Web | Invite acceptance | Invitation details, accept/decline, registration (if new) |
| Web | Account security settings | MFA toggle, active sessions, connected providers, password change |
| Mobile | Login | Biometric auth option + email/OAuth, MFA |
| Mobile | Workspace switch | Quick workspace picker |

## Acceptance Criteria

1. **Given** a new user registers with email, **when** the verification link is clicked, **then** the user's account MUST transition to `active`, the verified user MUST be synchronously upserted and onboarding MUST begin even if user.created webhook delivery is delayed.

2. **Given** a user belongs to 3 workspaces, **when** they log in, **then** the workspace picker MUST appear showing all 3 workspaces — switching between them MUST NOT require re-authentication, only a validated application workspace context; no new Creativanta refresh token.

3. **Given** a user requests a password reset, **when** the provider recovery challenge is verified before its reported expiry, **then** the password MUST update, ALL existing sessions MUST be invalidated, and a security notification email MUST be sent. If the recovery challenge has expired, it MUST show "Recovery expired" with a re-request option.

4. **Given** an access token expires during active use, **when** the Clerk provider session is still active, **then** token refresh MUST happen transparently — the user MUST NOT see a login screen or lose their current context.

5. **Given** a workspace invite is sent to a new user, **when** the user clicks the invite link, **then** they MUST be guided through registration → email verification → workspace join with the pre-assigned role — the invite link MUST expire after 7 days.

## Open Questions / Blockers

- [NONE] — Auth uses Clerk as managed service. Webhook integration defined in API map §3.

## Provider event and membership reconciliation contract (2026-10-29)

Verify raw request body and Svix id/timestamp/signature before persisting webhook_events; deduplicate delivery ID and reject replay outside the verifier window. Subscribe to user.*, session.*, organizationMembership.created/updated/deleted and organizationInvitation.accepted only when present in the pinned Clerk event catalog. Store organization identity in workspaces.clerk_organization_id; map membership to the existing workspace/user. Never auto-create an arbitrary workspace from a webhook's unrecognized organization ID.

Workspace discovery reads the authenticated user's active workspace_members and SELECT discovery policy, even before tenant selection. Invite creation/list/cancel use the Clerk organization API under verified workspace:members permissions; Clerk owns pending invitation records. The application enforces a seven-day maximum invitation age or the provider's shorter expiry. On verified acceptance, synchronize membership before redirect; delayed webhooks reconcile without creating duplicates.

Local role changes/removal are committed synchronously and invalidate permission/session projections immediately; the next request must query active membership and deny revoked access. External webhooks may be duplicated/out of order: compare source_updated_at, fetch authoritative provider state for ambiguous deletion/update order, and never resurrect a removed member from an older event. Login/onboarding cannot wait on webhook delivery. Return the verified local user/workspace context, never a made-up refresh token.

Required fixtures: onboarding with delayed webhook; three workspaces including non-owner membership; token refresh during edit; JWKS rotation; removed member's unexpired JWT; reordered membership update/delete; duplicate invitation acceptance; reset revokes all sessions.

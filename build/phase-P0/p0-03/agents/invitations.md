# P0-03 Sub-Slice Evidence — Isolated Invitation Acceptance Domain Boundary

- **Task / Phase**: `P0-03` (`P0 — Secure foundation`)
- **Branch**: `feat/p0-03-invitations`
- **Baseline Commit**: `03e423a` (`feat/p0-03-identity-foundation`)
- **Sub-slice Status**: `PARTIAL` (`DOMAIN_BOUNDARY_UNIT_TESTED`; **NOT** `ACCEPTED`, **NOT** production-ready)
- **Production Routes**: `NOT_MOUNTED` (`cmd/api` and `cmd/admin-api` remain untouched; `CheckProductionReadiness()` fails closed)
- **Recorded At (UTC)**: `2026-11-01T17:05:39Z`

---

## 1. Scope & Strict Isolation Verification

Only the following files were added:

- `apps/api/internal/invitations/doc.go`
- `apps/api/internal/invitations/errors.go`
- `apps/api/internal/invitations/rbac.go`
- `apps/api/internal/invitations/types.go`
- `apps/api/internal/invitations/ports.go`
- `apps/api/internal/invitations/service.go`
- `apps/api/internal/invitations/service_test.go`
- `build/phase-P0/p0-03/agents/invitations.md`

Untouched boundaries (verified via `git status` and `git diff --name-only 03e423a`):
- `apps/api/internal/identity` — untouched
- `apps/api/internal/clerkwebhook` — untouched
- `apps/api/cmd/*`, `apps/api/go.mod`, `apps/api/go.sum` — untouched
- `apps/web`, `apps/mobile` — untouched
- `docs/09_archive` and all `docs/*` — untouched
- `.github/workflows/*`, `tooling/*` — untouched
- `build/phase-P0/p0-03/manifest.json` — untouched
- Database migrations — untouched

---

## 2. Canonical Contract Alignment

1. **No invented schema tables or columns**:
   - Per `docs/02_features/platform/auth.md` (§Provider event and membership reconciliation contract, line 192: *"Invite creation/list/cancel use the Clerk organization API under verified workspace:members permissions; Clerk owns pending invitation records"*), pending invitations are modeled through the `InvitationProvider` port rather than inventing a non-canonical `workspace_invitations` table.
   - Local persistence records (`WorkspaceRecord`, `UserRecord`, `WorkspaceMemberRecord`, `AuditEventRecord`, `IdempotencyRecord`) mirror exact column names and enum vocabularies in `docs/04_contracts/database_schema.md` (§4.1 `workspaces`, §4.2 `users`, §4.3 `workspace_members`, §13.3 `audit_events`, §26.7 `api_idempotency_records`, §26.14 `idx_one_active_workspace_owner`).
   - Application-generated IDs use RFC 9562 UUID v7 (`NewUUIDv7`) per ADR-015 and `database_schema.md` §2, failing closed if CSPRNG entropy fails.
2. **No invented domain event names or error codes**:
   - Outbox domain events use only verbatim entries from `docs/04_contracts/domain_event_catalog.md` §2: `workspace.member_invited` (`{workspace_id, invitee_email, invited_by, role}`) and `user.registered` (`{user_id, email, registration_method}`). Clerk webhook names (`organizationMembership.*`, `organizationInvitation.accepted`) are reconciled inbound only and never emitted to the Creativanta domain event bus (`auth.md` line 154).
   - Domain errors use only registered codes from `docs/04_contracts/error_catalog.md` (`AUTH_INVALID_001`, `AUTH_FORBIDDEN_001`, `AUTH_FORBIDDEN_002`, `AUTH_CONFLICT_001`, `SYSTEM_INVALID_001`, `SYSTEM_NOTFOUND_001`, `SYSTEM_FORBIDDEN_001`, `SYSTEM_CONFLICT_001`, `SYSTEM_TIMEOUT_001`, `SYSTEM_CANCELED_001`, `SYSTEM_INTERNAL_001`).
3. **Security & domain invariants enforced**:
   - **Verified Clerk identity**: Active Clerk session + verified primary email required (`RULE-AUTH-001`, `RULE-AUTH-002`, AC-5). Unverified email (`EmailVerified=false`) is blocked fail-closed before any `users` or `workspace_members` write.
   - **New vs existing provider identity flow**:
     - Anonymous or unverified visitors on `PreviewInvitation` receive `IdentityFlowRegistrationOrVerificationRequired` (`EmailVerificationRequired=true`, `OnboardingRequired=true`).
     - Verified Clerk users lacking a local `users` row (`user.created` webhook delayed) are synchronously provisioned (`status='active'`, `OnboardingRequired=true`, `UserProvisionedNow=true`, `user.registered` outbox event) and joined to the workspace in one atomic commit (`auth.md` line 67, AC-1, AC-5).
     - Existing active local users join the target workspace directly (`IdentityFlowExistingUser`, `OnboardingRequired=false`) without duplicating `users`.
   - **Server-authorized inviter role & no role self-elevation**:
     - `Owner` is never invitable (`role excluding owner`; `idx_one_active_workspace_owner`).
     - Strict downward inviter role hierarchy enforced at **both** issuance and acceptance (re-verifying inviter's current active local membership in the target workspace before committing acceptance).
     - `AcceptInvitationCommand` has no client role parameter; `DecodeAcceptCommandStrict` rejects JSON payloads containing `"role"`, `"permissions"`, `"user_id"`, `"invited_by"`, `"is_owner"`, or any unknown field fail-closed.
     - Existing active workspace members cannot use an invitation link to elevate or mutate their role (`ErrRoleElevationDenied`).
   - **7-day token expiry & invalid/revoked/declined failure**:
     - Enforces `EffectiveExpiry = min(provider.expires_at, created_at + 7 days)` (`RULE-AUTH-005`, `auth.md` line 192), even if a provider record specifies a 30-day expiry, and honors shorter provider expiries.
     - Expired links fail closed with exact `EC-AUTH-004` guidance (`"This invitation has expired. Ask the workspace admin to send a new invite."`) and can only be re-sent by workspace `Admin+` (`ResendInvitation`).
     - Invalid, tampered, revoked, or declined tokens fail closed without echoing raw token material in errors.
   - **Cross-tenant isolation**:
     - Verifies bidirectional binding between `workspaces.workspace_id` and `workspaces.clerk_organization_id`, plus optional `CommandContext.WorkspaceID` compatibility check. Foreign/mismatched workspaces or invitations fail with opaque `SYSTEM_NOTFOUND_001` (`NOT_FOUND`).
   - **Idempotency, crash recovery & webhook ordering**:
     - Enforces `api_idempotency_records` (`>= 7d` TTL) with SHA-256 request hash comparison (`SYSTEM_CONFLICT_001` on payload mismatch), domain-idempotent retry across distinct idempotency keys, crash recovery when local DB commit fails after Clerk acceptance, and monotonic `SourceUpdatedAt` webhook reconciliation that never auto-creates workspaces or resurrects removed members from stale events (`auth.md` lines 190–194).

---

## 3. Recorded `[CONFLICT]` Notes & Precedence Decisions

1. `[CONFLICT: docs/04_contracts/api_behavior_contracts.md §4 ("WorkspaceService/InviteMember") states "workspace:members:invite; Manager can invite Editor or below; Admin cannot grant Owner", while docs/02_features/platform/reporting_admin_billing.md Part A RULE-M23-A02 states "Owner manages all; Admin manages Manager and below; Manager invites Editor and below" — enforcing strict downward delegation (Owner -> Admin..External, Admin -> Manager..External, Manager -> Editor..External, Owner never invitable), which satisfies both contracts fail-closed.]`
2. `[CONFLICT: docs/04_contracts/rpc_permission_bindings.csv lines 344-345 bind WorkspaceService/AcceptInvite and WorkspaceService/DeclineInvite to workspace:settings:manage (Contributor+), whereas docs/02_features/platform/auth.md RULE-AUTH-005 and AC-5 specify that an invited user holds no active membership in the target workspace prior to accepting — enforcing verified Clerk identity + verified matching invitee email + valid non-expired Clerk invitation token + server-reverified inviter role authority at the domain boundary, and keeping production ConnectRPC routes unmounted until rpc_permission_bindings.csv is reconciled.]`
3. `[CONFLICT: docs/04_contracts/rpc_permission_bindings.csv line 346 lists WorkspaceService/CancelInvite with permission_key=workspace:settings:manage and role_envelope=Manager+, while docs/04_contracts/rbac_permission_matrix.md §2.1 grants workspace:settings:manage only to Owner and Admin — enforcing the exact named RBAC permission workspace:settings:manage fail-closed (Owner and Admin only) per AGENTS.md and docs/04_contracts/ precedence.]`

---

## 4. Missing Dependencies & Unfinished External / Phase Gates

> **Honesty notice**: All unit tests in `apps/api/internal/invitations/service_test.go` execute against deterministic in-memory test doubles (`fakeIdentityVerifier`, `fakeInvitationProvider`, `fakeRepository`). They **DO NOT** constitute live Clerk integration, real PostgreSQL transaction testing, or `P0-04` RLS proof.

| Gate / Dependency | Current State | Owner / Blocking Slice |
|---|---|---|
| Live Clerk Organization Invitations API & JWKS/session config | `MISSING` (`UnconfiguredInvitationProvider` / `UnconfiguredIdentityVerifier` fail closed) | External provider gate + `P0-03` integration |
| Durable PostgreSQL schema migrations & `pgx`/`sqlc` repository | `MISSING` (`UnconfiguredRepository` fails closed; no migrations touched in this branch) | `P0-04` data/migration slice |
| PostgreSQL `ENABLE/FORCE ROW LEVEL SECURITY` & `app_user` (`NOBYPASSRLS`) grants | `MISSING` (`TenantRLSEnforced=false`) | `P0-04` tenant isolation gate (`D2`) |
| `rpc_permission_bindings.csv` reconciliation for `AcceptInvite` / `DeclineInvite` / `CancelInvite` & Protobuf generation (`WorkspaceService`) | `MISSING` (`RPCBindingsReconciled=false`; `D1` transport gate open) | Contract owner + `P0-03` / `P0-04` consolidation |
| Signed Svix `/webhooks/clerk` HTTP ingestion wired to `ReconcileProviderMembership` | `MISSING` (`apps/api/internal/clerkwebhook` untouched per isolation rule) | `P0-03` webhook slice |
| Web (SvelteKit) & Mobile (Flutter) invitation UI flows | `MISSING` (`apps/web` and `apps/mobile` untouched per isolation rule) | `P0-03` web/mobile auth slices (`D4`) |

---

## 5. Executed Checks

| Command | Working Dir | Exit Code | Summary |
|---|---|---|---|
| `gofmt -w apps/api/internal/invitations && test -z "$(gofmt -l apps/api/internal/invitations)"` | repo root | `0` | Clean formatting |
| `GOTOOLCHAIN=local go test -race -count=1 -v -cover ./internal/invitations` | `apps/api` | `0` | 9 test suites PASS (race detector enabled, 69.0% statement coverage) |
| `GOTOOLCHAIN=local go vet ./internal/invitations` | `apps/api` | `0` | 0 warnings/errors |
| `git diff --check` | repo root | `0` | Clean whitespace/diff |

### Five-Path Domain Unit Test Matrix (In-Memory Only, Not E2E)

- **Happy**: Owner/Admin/Manager issue <=7d invitations within ceiling; new verified user (delayed `user.created` webhook) and existing verified user preview & accept idempotently with pre-assigned role.
- **Degraded / Recovery**: Delayed `user.created` and delayed `organizationInvitation.accepted` webhooks do not block synchronous join or create duplicates; transient DB commit failure after Clerk acceptance recovers cleanly on idempotent retry.
- **Missing Data / Unonboarded**: Anonymous and `EmailVerified=false` visitors receive guided `registration_or_verification_required` preview and are blocked from prematurely joining `workspace_members`; unconfigured runtime adapters fail closed (`ErrDependencyUnconfigured` / `ErrProductionGateOpen`).
- **Broken / Adversarial**: Expired links at exact 7d mark (even with 30d provider expiry) return canonical `EC-AUTH-004` guidance; Admin+ resend issues fresh 7d token while Manager resend is denied; revoked, declined, invalid, cross-tenant, wrong-recipient, client-injected `"role":"owner"`, existing-viewer self-elevation, demoted inviter, and stale post-removal webhooks all fail closed.
- **Audit**: Every issuance, acceptance, decline, revocation, and resend appends canonical `audit_events` records, and `workspace.member_invited` / `user.registered` outbox events emit once without duplication under 16-goroutine `-race` concurrency.

# P0-03 Sub-Slice Evidence Report — `provider-sync`

- **Agent**: `provider-sync`
- **Model**: Gemini 4 Argon High
- **Branch**: `feat/p0-03-provider-sync`
- **Baseline Commit**: `03e423a`
- **Scope Status**: `IMPLEMENTED_LOCAL_TESTED` (Sub-slice only — **NOT** final `P0-03` or `P0` acceptance)
- **Production Route Status**: `UNMOUNTED` (fail-closed; `apps/api/internal/bootstrap/server.go` exposes only `/healthz` and `/readyz`)

---

## 1. Implemented Sub-Slice Scope

### 1.1 Verified Clerk Svix Webhook Boundary (`apps/api/internal/clerkwebhook`)
- **[verifier.go](../../../../apps/api/internal/clerkwebhook/verifier.go)**:
  - Validates a fixed trusted Clerk Svix signing secret (`whsec_<base64>`, 24–64 decoded bytes, no whitespace; secret material is never formatted into errors or logs).
  - Bounds HTTP request bodies (`DefaultMaxBodyBytes = 64 KiB`, `MaxAllowedBodyBytes = 256 KiB`) using `io.LimitReader` before parsing.
  - Enforces single-valued `svix-id`, `svix-timestamp`, and `svix-signature` headers (`ErrMissingHeaders`, `ErrDuplicateHeaders`), `msg_` message ID validation (`ErrInvalidMessageID`), and strict base-10 Unix timestamp parsing (`ErrInvalidTimestamp`).
  - Enforces a 5-minute replay/timestamp tolerance window (`DefaultTimestampTolerance = 5m`) against an injectable clock (`ErrExpiredTimestamp`, `ErrFutureTimestamp`).
  - Performs constant-time `HMAC-SHA256` signature verification (`hmac.Equal`) across `v1` signature candidates over `svix-id.svix-timestamp.rawBody` before any JSON parsing (`ErrInvalidSignature`).
  - Enforces the pinned Clerk event allowlist (`user.created`, `user.updated`, `user.deleted`, `session.created`, `session.ended`, `session.revoked`, `organizationMembership.created`, `organizationMembership.updated`, `organizationMembership.deleted`, `organizationInvitation.accepted`) and rejects unknown/disallowed events (`ErrUnsupportedEventType`).
  - Validates typed payloads (`UserEventData`, `SessionEventData`, `MembershipEventData`, `InvitationEventData`), requiring a verified primary email (`verification.status == "verified"`) on `user.created`/`user.updated`, normalizing canonical Creativanta workspace roles (`owner`, `admin`, `manager`, `editor`, `contributor`, `viewer`, `external`), and forbidding `owner` role grants via `organizationInvitation.accepted`.
- **[handler.go](../../../../apps/api/internal/clerkwebhook/handler.go)**:
  - Fail-closed `http.Handler` requiring non-nil `Verifier` and durable `EventProcessor` (`503 Service Unavailable` when unconfigured, `405 Method Not Allowed` for non-`POST`, `413` for oversized bodies, `401` for invalid/expired/future/missing/duplicate Svix headers or signatures, `400` for unsupported events or invalid payloads, and `200 OK` with `duplicate_ignored` for idempotent replays).
- **[reconcile_sql.go](../../../../apps/api/internal/clerkwebhook/reconcile_sql.go)**:
  - Implements `SQLReconciler` against canonical PostgreSQL tables (`users`, `workspaces`, `workspace_members`, `webhook_events`) without any ephemeral in-memory deduplication.
  - Resolves existing active workspaces via `workspaces.clerk_organization_id` and rejects unrecognized organization IDs with `ErrUnknownOrganization` (never auto-creating workspaces from webhooks).
  - Deduplicates workspace-scoped webhook deliveries (`organizationMembership.*`, `organizationInvitation.accepted`) via `webhook_events` (`UNIQUE (provider, idempotency_key)`).
  - Enforces `source_updated_at` monotonic ordering on `users` and `workspace_members`, never resurrects a `removed` member from an older `organizationMembership.created` or any `organizationMembership.updated` event, invokes optional `AuthoritativeMembershipChecker` on ambiguous equal-timestamp ordering, and protects `workspaces.owner_user_id` (`ErrOwnerProtected`).

### 1.2 Synchronous Verified-User Identity Upsert (`apps/api/internal/identity`)
- **[user_sync.go](../../../../apps/api/internal/identity/user_sync.go)**:
  - `ClerkUserDirectory`: fetches authoritative user profile from `GET https://api.clerk.com/v1/users/{user_id}` with redirect refusal, 4s timeout, 32 KiB limit, active account checks (`!banned && !locked && !deleted`), and primary email `verification.status == "verified"`.
  - `SQLUserUpserter`: synchronously idempotent-upserts canonical `users` (`clerk_id`, `source_updated_at`, `email`, `display_name`, `avatar_url`, `status`, `last_login_at`) with `source_updated_at` monotonic ordering so delayed `user.created` webhooks cannot overwrite newer fields, while refusing to reactivate `suspended` or `deleted` users.
  - `Resolver.SyncVerifiedUser`: chains JWT verification (`VerifyToken`), active session verification (`Sessions.Active`), verified provider profile fetch (`FetchVerifiedUser`), and synchronous SQL upsert (`UpsertVerifiedUser`) so login/onboarding never waits on webhook delivery.

---

## 2. Source Conflict Note

- `[CONFLICT: docs/04_contracts/api_endpoint_map.md §3 lists organization.created in the POST /webhooks/clerk table, whereas docs/02_features/platform/auth.md (2026-10-29 IAM-2026-01 remediation) restricts the pinned Clerk event catalog to user.*, session.*, organizationMembership.created/updated/deleted, and organizationInvitation.accepted, and explicitly forbids auto-creating a workspace from a webhook's unrecognized organization ID. Using the stricter auth.md reconciliation contract and excluding organization.created from the default allowlist so external webhooks cannot auto-create workspaces.]`

---

## 3. Executed Checks & Evidence

| Command | Result | Notes |
|---|---|---|
| `cd apps/api && gofmt -l ./internal/identity ./internal/clerkwebhook` | `PASS` (0 unformatted files) | All owned Go files formatted cleanly |
| `cd apps/api && GOTOOLCHAIN=local go test -race -count=1 -v ./internal/identity ./internal/clerkwebhook` (with `CREATIVANTA_TEST_POSTGRES_DSN` on local PostgreSQL 17.10 `creativanta-p0-postgres-1`) | `PASS` | Includes `TestKnownValidSignedFixture`, `TestMultiSignatureRotationAcceptsMatchingV1`, `TestInvalidSpoofedExpiredFutureAndTamperedSignatures`, `TestEventAllowlistAndUnsignedOrUnverifiedDataRejected`, `TestHandlerNilDependenciesBoundedBodyAndDuplicateDelivery`, `TestPostgresClerkWebhookMembershipAndUserReconciliation`, and `TestPostgresSynchronousUserUpsertSurvivesDelayedWebhook` |
| `bash tooling/ci/check_identity.sh` (with local PostgreSQL 17.10 test DSN) | `PASS` | `P0-03_TESTS_PASS: JWT, revocation, workspace and PostgreSQL` |
| `cd apps/api && GOTOOLCHAIN=local go vet ./...` | `PASS` | Zero warnings across all API packages |
| `git diff --check` | `PASS` | No whitespace or conflict marker errors |

---

## 4. Missing External Gates & Unresolved Dependencies

1. **Missing `P0-04` Migrations, RLS & Runtime Role Separation**:
   - Production Goose migrations, `app_user` (`NOBYPASSRLS`) grants, and `FORCE ROW LEVEL SECURITY` policies are owned by `P0-04`. Local PostgreSQL 17 tests run against rollback-only temporary tables and do not certify `P0-04` RLS enforcement.
2. **Missing `P0-04`/`P0-05` Global Webhook Inbox Storage for Non-Workspace Clerk Events**:
   - In `docs/04_contracts/database_schema.md` §18.4C, `webhook_events.workspace_id` is `UUID NOT NULL REFERENCES workspaces(workspace_id)` with `FORCE ROW LEVEL SECURITY`. Workspace-scoped Clerk events (`organizationMembership.*`, `organizationInvitation.accepted`) resolve `workspace_id` from `workspaces.clerk_organization_id` and deduplicate via `webhook_events(provider, idempotency_key)`. Global Clerk events (`user.*`, `session.*`) have no `workspace_id`; therefore `SQLReconciler` fails closed (`ErrGlobalDedupeUnavailable`) unless a durable SQL `GlobalDeliveryClaimer` is provided, and `POST /webhooks/clerk` is intentionally kept **unmounted** in `apps/api/internal/bootstrap/server.go` rather than substituting ephemeral in-memory deduplication.
3. **External Clerk Provider Gate (`UNAVAILABLE_NOT_CONFIGURED`)**:
   - Real Clerk tenant configuration, live `whsec_` signing secret, live `sk_` backend secret, and end-to-end Clerk webhook delivery/SDK flows are not configured in this environment. Test keys and secrets are deterministic local test vectors only.

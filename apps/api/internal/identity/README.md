# P0-03 — Verified Clerk identity (partial implementation)

**Security posture:** API and Admin entrypoints remain fail-closed, health-only and **unmounted** from this package. This code has no production Clerk secret or backend routes. It does not mark P0-03 accepted.

## Implemented and locally verified

- Clerk RS256 JWT validation using `github.com/golang-jwt/jwt/v5@v5.3.1`: exact configured HTTPS issuer, required audience and authorized party, signature, expiration, issued-at, not-before, session and subject. Untrusted `kid` never changes the configured JWKS origin.
- Pinned-origin JWKS retrieval with a size limit, strict RSA key checks, bounded cache, refusal of redirects/stale-key fallback and unknown-key refresh for rotation. Argon review finding was remediated by a separate cache-read RW lock, bounded single-flight JWKS fetch, and negative concurrency tests.
- Clerk Backend API `GET /v1/sessions/{session_id}` with an injected **runtime** secret, no positive caching, active status/user/session/expiry comparison. This denies reset/revoked sessions while a JWT remains valid, but may require a reviewed more efficient revocation projection at high request volume.
- Mandatory JWT + active session + current active local workspace member in `Resolver.VerifyWorkspace`; scope is a *candidate* selected by the caller, never trusted authorization. Invalid/foreign workspace, missing members, disabled users and suspended or deleted workspace deny access.
- Workspace discovery before selecting a tenant, using current membership (including ordinary `editor`/`viewer` non-owner roles) instead of workspace ownership.
- Real Connect HTTP test invokes a fixture handler through authentication, revocation, wrong origin, foreign workspace and missing-selection negatives.
- Real PostgreSQL 17 temporary-table integration tests: active and revoked membership, workspace suspension/deletion and non-owner discovery; fixture data is rolled back.
- Synchronous verified-user identity upsert boundary (`ClerkUserDirectory`, `SQLUserUpserter`, `Resolver.SyncVerifiedUser`): verifies JWT + active Clerk session + verified primary email from `GET /v1/users/{user_id}`, and idempotently upserts canonical `users` with `source_updated_at` monotonic ordering so delayed `user.created` webhooks cannot regress state or block onboarding.
- Verified Clerk Svix webhook boundary in `apps/api/internal/clerkwebhook`: fixed `whsec_` signing secret validation, bounded request body (64 KiB default), single-valued Svix headers, 5-minute replay/timestamp window, constant-time HMAC-SHA256 verification, pinned event allowlist, and transactional SQL reconciliation (`SQLReconciler`) for `users`, `workspaces`, `workspace_members`, and workspace-scoped `webhook_events`.

## Deterministic quality commands

```sh
cd apps/api
go test -race -count=1 ./internal/identity ./internal/clerkwebhook ./internal/transportauth
go vet ./...
govulncheck ./...
```

For actual DB integration, set **only a test database DSN** in `CREATIVANTA_TEST_POSTGRES_DSN` and execute `bash tooling/ci/check_identity.sh` from repo root. The script fails when the DSN is missing or the DB tests are skipped. CI provides an isolated PostgreSQL 17 service and test-only credentials; never point it to production.

## Explicit remaining blockers

1. Production Clerk environment and controlled secret/key settings, verified session/audience/authorized-parties policy, sandbox integration. Generated local RSA keys are **not** Clerk credentials.
2. P0-04 security-reviewed **narrow DB reader** for pre-selection discovery and membership, including RLS, role separation and grants. Development temporary-table tests are not proof of production RLS.
3. Server-side Clerk user upsert, refresh, invite acceptance, webhook signature/replay/order reconciliation, recovery, MFA and session invalidation workflows.
4. Web/Flutter sign-in UI and Clerk SDK integration with secure refresh, email verification and recovery.
5. Explicit routing and authorization rollout with Admin isolated authentication, plus remote CI/review gates. No business or Admin routes are enabled by this slice.

Design: `apps/api/internal/transportauth/interceptor.go` uses optional `WorkspaceVerifier` for the user-facing API. The legacy verifier remains solely for earlier test fixtures; **do not mount business RPCs** until P0-03 and P0-04 gates prove the production identity implementation.

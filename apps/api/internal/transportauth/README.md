# P0-02 — Go Connect authorization boundary

**Status:** reusable, fail-closed middleware + real Go Connect test harness. **Not yet mounted on the production API/Admin routers**, because Clerk identity and domain RPC authorization do not yet exist.

- `NewServerInterceptor(Options{Mode, Verifier})` returns a server interceptor. `Verifier=nil` always denies; no development auth bypass is present.
- Only `Verifier.Verify` is authoritative for internal user and selected workspace UUIDs. Caller `x-workspace-id` is compatibility-only and must match; multi-value, empty, invalid or foreign headers are rejected. Admin actor cannot carry workspace context or use a workspace role as internal-admin permission.
- Correlation ID is normalized, assigned to context/response and to protobuf `ErrorDetail`. Unexpected internal errors are sanitized with canonical codes from `docs/04_contracts/error_catalog.md`.
- Unary, streaming, cancellation, duplicate headers, safe error mapping, and a real HTTP Connect handler are covered by test. The test fixture service remains isolated from `cmd/api` and `cmd/admin-api`.
- This is a **transport trust interface**, not a replacement for Clerk JWT issuer/audience/signature verification, per-object RLS, API RBAC, credit authorization or durable idempotency.
- Entropy failure on correlation-ID generation is a catastrophic system precondition. The handler refuses with a generic INTERNAL error; it does not fabricate a valid UUID or silently continue. No protobuf correlation detail can be attached if a UUID cannot be securely produced.

## Developer checks

```sh
cd apps/api
go test -race -count=1 ./internal/transportauth
go vet ./internal/transportauth
```

**Next dependency:** P0-03 must provide a real verified Clerk resolver and local membership/selected workspace identity; P0-04/05 provide persisted tenant-scoped idempotency, audit/outbox and RLS. Never mount business RPCs without these gates.

# P0-03 preparatory trust boundary (NOT authentication)

This deliberately incomplete `transportauth.Verifier` adapter refuses to create
an authenticated user/workspace session, even after a verified provider subject.
It is not mounted by `cmd/api` or `cmd/admin-api` and contains no fake Clerk
configuration. It exists to keep identity fail-closed while the actual provider
JWT verifier (issuer, audience, signature, authorized party, expiry, JWKS
rotation), active membership lookup and server-validated workspace selection
are implemented and independently tested under P0-03/P0-04.

Tests: `cd apps/api && go test -race ./internal/identity`.

**Do not enable production routes or report P0-03 as implemented.**

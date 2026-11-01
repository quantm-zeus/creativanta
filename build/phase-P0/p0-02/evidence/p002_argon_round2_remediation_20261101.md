# P0-02 — Argon second security review remediation

**Scope:** reusable Go server interceptor, not production authenticated RPC wiring.

Independent Argon review round two correctly reported **NEEDS FIX**. The following remediations are implemented and unit/race tested; this file does not represent independent re-approval.

| Review finding | Regression evidence |
|---|---|
| Auth before workspace disclosure | `TestDuplicateWorkspaceDoesNotDiscloseBeforeAuthentication` |
| Verifier child deadline and parent cancellation | `TestVerifierChildTimeoutMapsCorrectly,TestRequestCancellationOverridesDownstreamError` |
| No trusting duplicate or conflicting trace headers | `TestAmbiguousCorrelationHeadersAreNotTrusted` |
| No nil UUID as authorized principal | `TestEmptyWorkspaceHeaderAndNilUUIDFailClosed` |
| No caller HTTP header mutation, principal passed only via context | `TestAmbiguousCorrelationHeadersAreNotTrusted` |
| Untrusted internal failure always emits safe ErrorDetail | `TestInternalErrorsRedactSecretsAndPreserveCorrelation` |

Explicit limitations: secure crypto entropy loss returns `SYSTEM_INTERNAL_001` with zero UUID as catastrophic placeholder since a new UUID cannot be minted. Verifier is only a contract: Clerk token checking, permission/RLS, tenant membership, production RPC routing and durable idempotency are NOT implemented.

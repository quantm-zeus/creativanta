---
layer: contracts
canonical: true
last_updated: 2026-10-29
---

# API Behavior and Message Contracts

## 1. Ownership and exposure

[API map](api_endpoint_map.md) owns RPC inventory and rate envelopes; [RBAC](rbac_permission_matrix.md) owns permission grants; [RPC bindings](rpc_permission_bindings.csv) binds each inventory operation to a named permission and behavior family. Schema owns persisted fields; this file owns transport-only fields and mutation semantics. JSON examples are fixtures/projections, not authorization or arbitrary database serialization.

The inventory preserves every function. Aliases consolidate into canonical service implementations per protobuf_contracts.md, with identical validation/permission behavior. Adding a method requires updating its binding. No unbound RPC is registered, and no screen alias creates a new persistence object.

## 2. Common wire types

| Type | Exact fields / validation |
|---|---|
| UUID | Canonical UUID string; application-generated public IDs v7; never accept an arbitrary unknown ID as authority |
| Money / Credits | Decimal string (no exponent/NaN/Infinity), precision ≤18 and scale ≤6; Money adds ISO currency; reject overflow and prohibited negative input |
| Timestamp | RFC3339 UTC, translated to protobuf Timestamp; scheduling accepts an explicit offset and normalizes UTC |
| CommandContext | idempotency_key: string 1–255; expected_updated_at: optional Timestamp; reason: optional string 1–2000; workspace_id: optional UUID for compatibility, must equal authenticated selected workspace |
| Pagination | page_size int 1–100, default 20; page_token optional opaque signed cursor bound to tenant/filter/sort; stable PK tie-breaker; no cross-tenant cursor reuse |
| ListResponse<T> | items: T[]; next_page_token: string; has_more: bool; total_count: optional int64 (expensive totals may be omitted) |
| MutationResult<T> | resource: T; audit_event_id: UUID; replayed: bool; asynchronous commands also operation_id: UUID and status: queued |
| CreditQuote | quote_id: UUID; quoted_credits: decimal string; cost_ceiling_usd: decimal string; rate_version: string; expires_at: Timestamp; request_hash: string |
| CreditBalance | total_remaining, reserved, available, subscription_remaining, purchased_remaining, promotional_remaining, overage_remaining: decimal strings; next_allocation_at: optional Timestamp; subscription_tier: enum |
| ErrorDetail | code from error_catalog.md; message: localized string; correlation_id: UUID; field_errors: repeated {field, reason}; retry_after_ms: optional int64; fallback_action: optional allowlisted action identifier |

Resource output uses canonical primary-key field names (`script_id`, `order_id`, etc.). Historical example fields named `id` are explicit compatibility aliases for that resource PK; do not invent DB `id` columns. Derived projection fields (counts, sums, signal_count, queue position, labels) must be computed server-side from authorized inputs and defined in the response `.proto`; they are never writable. Scores are 0–100 unless the owning contract explicitly defines a different unit; stage_progress is 0–1.

## 3. Behavior families

Every row in rpc_permission_bindings.csv has one family. This is a minimum behavior contract, supplemented by the owning feature's rule/state table. The implementation packet records exact messages and tests before that slice is coded.

| Family | Request and response | Preconditions / side effects |
|---|---|---|
| identity | Verified provider session/recovery input; local identity/context response | Auth feature owns Clerk flow. No application refresh-token issuer or passwords stored in domain DB |
| query | Scoped resource ID, or allowlisted filters/sort + Pagination; typed resource/list/aggregate response | No domain mutation; hide secrets/internal notes and respect underlying object permissions for all joined metrics |
| command | CommandContext + typed allowlisted business input; MutationResult or queued job | Active membership, named permission, tier, object ownership, state/CAS, approval, atomic audit/outbox and idempotency |
| generation | CommandContext + quote_id + confirmed_credits + typed production input; job identity/status | Quote hash/expiry/ceiling + consent; durable credit hold and external-effect recovery; all normal command gates |
| external | CommandContext + typed target/action input; durable effect/job response | Verified current capability, provider policy/consent, stable operation key, unknown-result reconciliation |
| admin | Separate verified MFA/VPN identity; typed action; audited response | Exact internal-admin permission plus role envelope and scoped target; no workspace-role substitution |
| public | Only explicitly public catalog/help/profile/health or provider login route input/output | Return an allowlisted public projection; no tenant-wide queries, raw evidence, tokens or permission escalation |

Never derive a command request by blindly copying all columns. Server-owned fields include generated IDs, workspace owner/tenant, role, computed balances, reconciliation/profit, source verification, audit actors, timestamps, lifecycle/approval state and provider credentials. They change only through named domain commands. For a CRUD form, use the feature's user-editable fields and schema types; create requires schema NOT NULL inputs lacking server defaults. Patch requires field_mask + typed values; absent means unchanged, explicit null only for nullable fields, unknown fields rejected. Every `.proto` request must state its allowed fields; a `Struct` catch-all cannot replace a command contract.

## 4. Exact critical commands

The inputs below are transport fields defined here, in addition to CommandContext where mutating. Do not expose worker-only credit reserve/commit/release as user RPCs. Compatibility aliases must dispatch through these same handlers.

| Operation | Business input | Behavior and response |
|---|---|---|
| AuthService/Login / ValidateSession | Login has provider='clerk', token=verified session JWT; ValidateSession uses Authorization header | Return local user_id/email/display_name and authorized workspace context; no access_token/refresh_token issuance; synchronously upsert verified user before returning |
| WorkspaceService/Create | display_name, slug, default_operator_mode, optional primary_region_id/primary_currency_id | Authenticated user becomes owner; workspace+membership atomic; validate unique slug and one active owner |
| WorkspaceService/InviteMember | email, role excluding owner | workspace:members:invite; Manager can invite Editor or below; Admin cannot grant Owner; expire ≤7 days; provider invitation ID response |
| WorkspaceService/UpdateRole | user_id, role, expected_updated_at | workspace:roles:assign; cannot grant above actor; owner transfer only by current Owner, atomically update owner_user_id and memberships, never remove last Owner |
| AssetService/Generate and generation aliases | quote_id, confirmed_credits, script_id/asset_brief_id or typed mode input; mode; provider options included in quote hash | Verify source/continuity/consent and tier; one generation_job identity; queue only after hold transaction commits |
| PublishService/Schedule | publish_item_id, scheduled_at, expected_updated_at | publish:schedule; approved content/capability snapshot; create per-target jobs; scheduling never bypasses execution-time approval/permission checks |
| PublishService/Execute / Retry | publish_item_id or publish_job_id, expected_updated_at, reason for force repair | publish:execute/retry respectively; check latest policy/capability and unknown prior result before submit; return job identity, not an invented success |
| ThreadService/Reply and connector reply aliases | thread_id, body, attachment upload_ids, optional suggestion_id | thread:reply; current channel messaging window/consent, attachment safety and external-effect dedup; return canonical message_id |
| OrderService import/create | connected_account_id or authorized import identity; source revision; canonical order fields and typed OrderItem/FeeBreakdown/FX shapes | account-scoped source identity; preserve imported lifecycle; snapshot COGS/FX; recognize only under financial computation rules |
| CostService/Create/update aliases | cost_type, amount, currency, effective_date, related_scope_type/id, evidence_id or confidence_reason, expected_updated_at on update | cost:manage; verify typed scope/evidence; exactly one economic cost; corrections post reversals rather than overwrite prior postings |
| ReconciliationService/Match/ManualMatch | order_id(s), settlement line_id(s), allocation amounts, expected_updated_at | reconciliation:manage; same workspace/currency basis, lock capacity, maintain discrepancy; no user-provided finalized profit |
| ReconciliationService/Override / ConfirmWithDiscrepancy | record_id, decision, reason, evidence_ids, expected_updated_at | reconciliation:override (Admin+); require approval if policy enabled; append audit/adjustment; never edit raw evidence |
| EvidenceService/Submit | evidence_type, safe upload_id or typed source payload, related_object_refs | evidence:submit; backend computes SHA-512 and provenance; source verification is server-owned; immutable content |
| WorkflowService/Create/Update/Activate/Run | typed node graph/edges/config for create/update; workflow_id for activate/run; expected_updated_at | create/edit/activate keys split; validate node types and scoped delegated actions; dry_run flag forbids external side effects and financial debits |
| AdminBillingService/PurchaseCredits / CreditService/Purchase | pack SKU, billing currency, return URL from allowlist | workspace Owner + credits:top_up; idempotent checkout session; grant only after verified successful payment webhook |
| BillingService/ChangePlan / Cancel aliases | target tier/interval for change; effective timing from business rules; reason optional | workspace:billing:manage (Owner); server pricebook/proration; no client-supplied price or allocation |
| AgentService execute / Copilot action | typed proposed actions, confirmation ID bound to action hash, workflow/agent context, credit quote for AI steps | Agent/Copilot permission AND each delegated domain action's permission; budget and approvals rechecked per step; no autonomous privilege gain |
| APIKeyService/Create/UpdateScopes | name, requested permission scopes, expiry bounded by policy | api_key:manage; scopes subset of issuer permissions and tier; return plaintext secret once, store only hash, revoke immediately |
| RefundService/Create | order_id, amount, currency, reason, expected_updated_at | refund:manage; cumulative refund ≤ captured amount; provider payment identity and unknown-outcome handling; finance reversal once |

Other state-transition commands use the owning feature's explicit From→To table; no arbitrary status update endpoint. Commands named Approve/Reject/Activate/Override/Force*/Delete/Refund/Revoke always use their specific sensitive permission, not a generic edit/read key. Utility aliases (Queue, Connector, Review, Contact, dashboard actions) must also check the underlying object's permission; their service label does not grant authority.

## 5. Failure, replay and transaction semantics

- Missing/expired auth → UNAUTHENTICATED; forbidden role/tier → permission/limit error; foreign/hidden ID → NOT_FOUND; stale expected_updated_at/state → FAILED_PRECONDITION. Do not leak whether a foreign object exists.
- Validate positive/allowed amounts, bounded duration/count/upload, enums, URL/SSRF policy, field lengths and related refs before mutation. Return field_errors for invalid input.
- Mutating requests require an idempotency key; store hash and result in api_idempotency_records. Same key/same payload returns prior result; changed payload → SYSTEM_CONFLICT_001. Keep request dedup ≥7 days; economic identities and provider keys survive longer than retry windows.
- Domain write, optimistic-state condition, audit, ledger/inbox and new outbox messages are atomic. External network I/O is outside DB transaction and follows external_effects recovery.
- Connect/gRPC unary success is HTTP 200; async status is a typed response field. REST creation/accepted responses may use 201/202. Examples with REST-style status labels do not change Connect protocol.
- Stream reconnect carries stable event/cursor, refreshes auth and tenant authorization, and cannot replay another tenant's data. No tokens or secrets in stream URLs/logs. Internal admin methods use a separate listener and are never automatically exposed through public/Connect gateways.

Unspecified RPC rate envelopes default to 60/min/workspace for queries and 20/min/workspace for commands; explicit lower endpoint, tier, hourly AI/video, provider and public-API read/write limits all apply, with the most restrictive result enforced. Auth is capped at 10 requests/min/IP; failed credential attempts >10/5min lock for 30min, recovery attempts >5/hour lock recovery for 30min. Provider protections may be stricter. Rate checks never replace permission/idempotency checks.

## 6. Contract gate for every phase

Before endpoint/UI implementation, the slice packet names each RPC's compiled request/response and validates every field, state, permission, replay and failure fixture above. Responses must define exact authorized projections and units; do not invent names ad hoc in components. A newly discovered ambiguity is corrected in this file/owning feature before shipping the slice, with affected downstream bindings updated. D0 static readiness is distinct from passing this executable contract gate.

## 7. Lifecycle and grant storage clarifications

Characters use creating/ready/failed/archived. Sample journey UI composes sample_requests.status, shipment status, outcome_status and follow_up_status; it never persists shipped/delivered/outcome_logged into request.status. Brand Deal vocabulary is the M16 machine. Capability uses the five schema enum values, with unknown/stale kept as verification metadata. Subscription trial/free/grace UI states map to trialing/plan_tier/past_due as specified by M23 and pricing.

Challenge definitions persist their lifecycle status; is_active is only its projection. Individual progress/achievement/streak records are keyed by workspace and user, with a source-event idempotency key on credit grants. Buyer membership_subscriptions and their entitlement_snapshot are separate from SaaS subscriptions: a creator's membership cannot unlock Creativanta plan features or permissions. API key rotation creates replacement key material with shared logical_key_id and a bounded old-key grace period; API usage and tier count use the logical identity.

AB experiment UI phases design/active/monitoring/complete/scaled map to pending/running/completed plus result_status. Default observational comparison requires at least 1,000 impressions per variant, 48h duration and the configured metric threshold (default 1.5×); insufficient evidence yields completed+inconclusive with no automatic winner. Organic posts without randomized equivalent exposure must be labeled observational, not causal/statistically proven uplift. Workspace revenue is never inferred solely from views or a winning variant.

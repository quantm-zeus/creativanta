---
layer: system
canonical: true
source_file: impl_b3_queue_retry_design.md
last_verified: 2026-03-30
purpose: Queue architecture, retry strategies, DLQ, outbox pattern, circuit breaker, and cron registry
---

# B3 — Queue, Retry & Dead-Letter Design

> **Upstream**: Pack 03 (Event/Workflow), Tech Stack ADR v3
> **Tech**: Tokio + Redis Streams (Dragonfly) + PostgreSQL outbox

---

## 1. Queue Architecture

Domain mutation + audit + outbox insertion commit in **one PostgreSQL transaction**. Only after commit may a poller dispatch to Redis Streams. In-process mpsc is an optional wake-up hint, never a durability boundary. Canonical schema: [database schema §18/§26](../04_contracts/database_schema.md). Delivery is at least once; business effects are idempotent.

## 2. Queue Definitions

| Queue Name | Priority | Max Retries | Retry Delay | DLQ | Consumers |
|---|---|---|---|---|---|
| `publish_jobs` | HIGH | 3 | 30s, 2min, 10min | ✅ | M11 publish executor |
| `generation_jobs` | MEDIUM | 3 | 1min, 5min, 15min | ✅ | M07 AI pipeline |
| `sync_jobs` | MEDIUM | 5 | 30s, 1min, 5min, 15min, 1h | ✅ | Platform sync workers |
| `notification_push` | LOW | 2 | 10s, 1min | ❌ | FCM/APNs sender |
| `notification_email` | LOW | 3 | 30s, 5min, 30min | ✅ | Resend/SMTP sender |
| `analytics_events` | LOW | 1 | — | ❌ | PostHog/ClickHouse |
| `ai_pipeline` | MEDIUM | 3 | 30s, 2min, 10min | ✅ | LLM adapter |
| `workflow_trigger` | MEDIUM | 3 | 10s, 1min, 5min | ✅ | Activepieces trigger |
| `settlement_import` | HIGH | 5 | 1min, 5min, 15min, 1h, 6h | ✅ | M19 finance importer |
| `trend_crawl` | LOW | 2 | 5min, 30min | ❌ | M02 crawler |
| `ai_credit` | HIGH | 2 | 10s, 1min | ✅ | M23 credit allocation, monthly reset |

---

## 3. Retry Strategy

```rust
pub enum RetryStrategy {
    Exponential { base_delay: Duration, max_delay: Duration, multiplier: f64 },
    Fixed { delays: Vec<Duration> },
    None,
}

pub struct RetryPolicy {
    pub strategy: RetryStrategy,
    pub max_attempts: u32,
    pub retryable_errors: Vec<ErrorClass>,
    pub non_retryable_errors: Vec<ErrorClass>,
}

pub enum ErrorClass {
    Transient,        // Network timeout, rate limit → retry
    ProviderDown,     // Provider 5xx → retry with backoff
    AuthExpired,      // Token expired → refresh then retry
    InvalidInput,     // Bad data → DO NOT retry, send to DLQ
    QuotaExceeded,    // Rate limit → retry after delay
    BusinessLogic,    // Validation fail → DO NOT retry
}

// Illustrative policy shape; the implemented retry schedule must pass §5 recovery fixtures.
impl RetryPolicy {
    pub fn should_retry(&self, error: &ErrorClass, attempt: u32) -> Option<Duration> {
        if attempt >= self.max_attempts { return None; }
        if self.non_retryable_errors.contains(error) { return None; }
        // Calculate delay based on strategy
        Some(self.calculate_delay(attempt))
    }
}
```

---

## 4. Dead-Letter Queue

DDL is owned by [database schema](../04_contracts/database_schema.md). A failed job retains canonical event/job identity, tenant, attempts, provider outcome and repair diagnostics. After 24h unresolved, alert the owner. Seven days may archive a resolved/acknowledged record; **never discard an unresolved financial or unknown external side effect merely because it is old**. Manual replay keeps original operation identity; it does not bypass idempotency or permission checks. System-level NULL-workspace records are restricted to operations roles.

## 5. Transactional Outbox, Inbox and External Effects

### 5.1 Producer and poller

Persist the full canonical DomainEvent envelope, including stable `event_id`, actor, workspace, aggregate, correlation, version and timestamp. `target_stream` is an allowlisted queue name from §2, chosen by the producer. Payload never contains tokens or service credentials. The outbox poller uses its narrowly granted role; no domain service inherits it.

Every 100ms claim up to 100 unpublished due records in a short transaction using `FOR UPDATE SKIP LOCKED`, updating `lease_owner`, `lease_until = now + 30 seconds` and `attempt_count`. Commit the lease before network I/O. Publish the same event_id/envelope to its stored stream, then conditionally mark published where this lease is still owned. Failure retries with bounded backoff in `next_attempt_at`. Crash after XADD but before marking published legitimately redelivers the same event_id. Expired leases are reclaimable; multiple pollers cannot assume exclusive delivery.

### 5.2 Consumer transaction

1. Read via XREADGROUP; validate queue/envelope, source and tenant/actor authority. Recheck current delegated permissions before executing, including revocation and approval expiry.
2. Set validated user/tenant context in an app_user transaction. Insert `consumer_inbox(workspace_id, consumer_name, event_id)` using ON CONFLICT DO NOTHING RETURNING inbox_id.
3. If already processed, commit/no-op and XACK. Otherwise apply domain mutations, append audit/ledger and insert new outbox records **in that same transaction**. If anything fails, roll back the inbox row too.
4. XACK only after commit. A crash between commit and ACK redelivers and takes the no-op path. Recover abandoned pending entries after a 60-second idle lease with XAUTOCLAIM (or equivalent verified operation on the pinned Redis-compatible server).
5. Keep business dedup keys/ledger identities permanently for their retention period. Retain inbox IDs at least 30 days; replaying older events requires economic-operation dedup and an audited replay plan. Never trim unacknowledged business messages; alert/stop producers before capacity exhaustion. Fair scheduling isolates noisy workspaces.

### 5.3 External side effects

DB transactions cannot atomically commit with a platform API. Before submission, persist `external_effects` with a unique operation_key, target, prepared/submitted status and request identity. Send provider idempotency key where supported. A timeout after submission is **unknown**, not proof of failure. Query provider status/webhooks and reconcile by provider request ID; do not blindly repeat publish/payment/generation. If no status or idempotency mechanism exists, require manual inspection/proof before resubmission. A definitive result conditionally updates effect + domain + audit/inbox/outbox in one transaction. Retry/cancel/fallback must preserve these identities.

### 5.4 Recovery fixtures

Kill poller after stream publish; run two pollers; kill consumer before/after commit; redeliver webhook; revoke actor before execution; kill worker after platform submission; lose cache; replay a completed financial job. Each fixture must preserve one order/posting/debit and no duplicate external operation. [Credit accounting](../04_contracts/credit_accounting_contract.md) owns credit-specific late-result behavior.

## 6. Circuit Breaker (Per Provider)

```rust
pub struct CircuitBreaker {
    failure_threshold: u32,     // 3 failures
    reset_timeout: Duration,    // 5 minutes
    half_open_max: u32,         // 1 test request
    state: CircuitState,        // Closed, Open, HalfOpen
    failure_count: AtomicU32,
    last_failure: AtomicU64,
}
```

| Provider Type | Failure Threshold | Reset Timeout |
|---|---|---|
| AI LLM (Gemini/OpenAI) | 3 in 60s | 5 min |
| Video Gen (Veo/Kling) | 2 in 60s | 10 min |
| Platform API (TikTok) | 5 in 60s | 3 min |
| TTS (ElevenLabs) | 3 in 60s | 5 min |
| Payment (Stripe) | 2 in 60s | 15 min |

---

## 7. Cron Schedule Registry

| Job | Schedule | Queue | Description |
|---|---|---|---|
| Morning Brief | `0 30 6 * * *` (6:30 AM) | notification_push | Generate + deliver briefs |
| Platform Fee Sync | `0 0 2 * * *` (2:00 AM) | sync_jobs | Crawl fee databases |
| Health Score | `0 0 * * * *` (hourly) | sync_jobs | Poll platform APIs |
| Stale Data Check | `0 */15 * * * *` (15min) | analytics_events | Check sync freshness |
| Achievement Check | Event-driven | workflow_trigger | On content/commerce events |
| Credit Reset | Every minute: scan due billing anniversaries | ai_credit | Idempotent allocation per subscription period; see credit accounting |
| DLQ Cleanup | `0 0 3 * * *` (3:00 AM) | — | Auto-discard old DLQ items |
| Outbox Cleanup | `0 0 4 * * *` (4:00 AM) | — | Delete published outbox > 7d |

---

## 8. Rate Limiting

| Endpoint Group | Limit | Window | Per |
|---|---|---|---|
| Public API | 100 req | 1 min | API key |
| AI Generation | 20 req | 1 min | workspace |
| Publish | 60 req | 1 min | workspace |
| Webhook Receive | 1000 req | 1 min | global |
| Auth | 10 req | 1 min | IP |
| Upload | 30 req | 1 min | workspace |
| Search | 120 req | 1 min | workspace |

Implementation: Sliding window counter via Dragonfly (Redis MULTI/EXEC).

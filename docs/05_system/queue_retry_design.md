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

```
┌─ Rust API ────────────────────────────────────┐
│                                                │
│  Domain Service → Event Bus (in-proc mpsc)     │
│       ↓                                        │
│  Outbox Writer → PostgreSQL outbox table        │
│       ↓                                        │
│  Outbox Poller → Redis Streams (Dragonfly)     │
│       ↓                                        │
│  Worker Pool (Tokio tasks)                      │
│       ↓                                        │
│  ┌─ Consumer Groups ─────────────┐             │
│  │ publish_jobs    (M11)         │             │
│  │ generation_jobs (M07)         │             │
│  │ sync_jobs       (M12,M13)     │             │
│  │ notification    (Push/Email)  │             │
│  │ analytics_events (PostHog)    │             │
│  │ ai_pipeline     (LLM/Media)  │             │
│  │ workflow_trigger (M20/M21)   │             │
│  │ cron_scheduler  (Morning...)  │             │
│  └───────────────────────────────┘             │
└────────────────────────────────────────────────┘
```

---

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

## 4. Dead-Letter Queue (DLQ)

```sql
CREATE TABLE dead_letter_queue (
  dlq_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  queue_name VARCHAR(100) NOT NULL,
  original_message_id VARCHAR(255) NOT NULL,
  payload JSONB NOT NULL,
  error_class VARCHAR(50) NOT NULL,
  error_message TEXT,
  last_error_at TIMESTAMPTZ NOT NULL,
  attempt_count INTEGER NOT NULL,
  retry_history JSONB DEFAULT '[]', -- [{attempt, error, timestamp}]
  workspace_id UUID,
  status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, retrying, resolved, discarded
  resolved_at TIMESTAMPTZ,
  resolved_by UUID,
  resolution_notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_dlq_queue ON dead_letter_queue(queue_name, status);
CREATE INDEX idx_dlq_workspace ON dead_letter_queue(workspace_id);
```

### DLQ Processing Rules:
1. **Auto-retry**: TransientError items get 1 more retry after 1 hour
2. **Manual review**: Items older than 24h trigger diagnostics_record
3. **Discard**: Items older than 7 days with no resolution → auto-discard
4. **Notification**: DLQ items for HIGH priority queues → immediate admin notification

---

## 5. Outbox Pattern (Guaranteed Delivery)

```sql
CREATE TABLE event_outbox (
  outbox_id BIGSERIAL PRIMARY KEY,
  event_type VARCHAR(200) NOT NULL,
  target_stream VARCHAR(100) NOT NULL,
  aggregate_type VARCHAR(100) NOT NULL,
  aggregate_id UUID NOT NULL,
  workspace_id UUID,
  payload JSONB NOT NULL,
  metadata JSONB DEFAULT '{}',
  published BOOLEAN NOT NULL DEFAULT false,
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_outbox_unpublished ON event_outbox(published, created_at)
  WHERE published = false;
```

### Outbox Poller:
```rust
// Runs every 100ms, batches up to 100 events
async fn poll_outbox(pool: &PgPool, redis: &RedisClient) {
    let events = sqlx::query("SELECT * FROM event_outbox WHERE published = false ORDER BY created_at LIMIT 100")
        .fetch_all(pool).await?;
    
    for event in events {
        redis.xadd(&event.target_stream, &event.payload()).await?;
        sqlx::query("UPDATE event_outbox SET published = true, published_at = NOW() WHERE outbox_id = $1")
            .bind(event.outbox_id).execute(pool).await?;
    }
}
```

Outbox routing rule:
- Producers MUST persist the exact Redis Stream name into `event_outbox.target_stream` at write time.
- `target_stream` MUST match one of the canonical queue names in §2 (`publish_jobs`, `generation_jobs`, `sync_jobs`, `notification_push`, `notification_email`, `analytics_events`, `ai_pipeline`, `workflow_trigger`, `settlement_import`, `trend_crawl`).
- Pollers MUST publish to the stored stream name directly; they MUST NOT derive queue choice from `event_type` ad hoc at publish time.

---

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
| Morning Brief | `0 30 6 * * *` (6:30 AM) | notification | Generate + deliver briefs |
| Platform Fee Sync | `0 0 2 * * *` (2:00 AM) | sync_jobs | Crawl fee databases |
| Health Score | `0 0 * * * *` (hourly) | sync_jobs | Poll platform APIs |
| Stale Data Check | `0 */15 * * * *` (15min) | analytics_events | Check sync freshness |
| Achievement Check | Event-driven | workflow_trigger | On content/commerce events |
| Credit Reset | `0 0 0 1 * *` (1st of month) | settlement_import | Monthly credit allocation |
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

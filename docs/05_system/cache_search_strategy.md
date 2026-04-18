---
layer: system
canonical: true
source_file: impl_b6_cache_search_strategy.md
last_verified: 2026-03-30
purpose: Dragonfly cache strategy, Meilisearch indexes, ClickHouse analytics schema, and pgvector usage
---

# B6 — Cache & Search Strategy

> **Upstream**: Tech Stack ADR v3 (Dragonfly, Meilisearch, ClickHouse)

---

## 1. Dragonfly Cache Strategy

### 1.1 Cache Key Naming Convention
```
{service}:{entity}:{workspace_id}:{identifier}:{scope}
```

### 1.2 Cache Entries

| Key Pattern | TTL | Invalidation | Purpose |
|---|---|---|---|
| `auth:session:{session_id}` | 24h | On logout/revoke | JWT session cache |
| `auth:permissions:{workspace_id}:{user_id}` | 5m | On role change | RBAC permission set |
| `workspace:settings:{workspace_id}` | 30m | On settings update | Workspace config |
| `workspace:tier:{workspace_id}` | 1h | On tier change | Subscription tier |
| `credits:balance:{workspace_id}` | 1m | On credit change | AI credit balance |
| `capability:{workspace_id}:{platform}` | 15m | On capability check | Platform capability state |
| `connector:health:{workspace_id}:{provider}` | 5m | On sync | Connector health status |
| `home:cards:{workspace_id}:{mode}` | 5m | On event | M01 dashboard cards |
| `trend:hot:{workspace_id}` | 10m | On new trend | Hot trends list |
| `profit:summary:{workspace_id}` | 15m | On snapshot update | Profit overview |
| `publish:queue:{workspace_id}` | 2m | On queue change | Publish queue summary |
| `thread:unread:{workspace_id}` | 1m | On message | Unread thread count |
| `rate_limit:{endpoint}:{key}` | Window-based | Auto-expire | Rate limit counters |
| `circuit:{provider}` | Reset timeout | On state change | Circuit breaker state |
| `ai:routing:{task_type}` | 1h | On config change | AI provider routing config |
| `subscription:{workspace_id}` | 30m | On tier change | Full subscription details |
| `feature_flags:{flag_prefix}` | 5m | On toggle | Feature flag state |
| `support:sla:{workspace_id}` | 5m | On tier change | SLA thresholds per plan |
| `credits:reservation:{reservation_id}` | 30m | On commit/release | Credit reservation lock (Audit v5 — L6) |
| `remix:originality:{blueprint_id}` | 1h | On re-check | Cached originality check result |
| `ltv:scraped:{url_hash}` | 24h | Manual invalidation | Link-to-Video scraped product data cache |
| `challenge:progress:{workspace_id}` | 5m | On progress update | Active challenge progress snapshot |
| `production:job_status:{job_id}` | 30s | On status change | Real-time job status for UI polling |
| `style:pack:{style_pack_id}` | 30m | On update | Style pack extracted settings |
| `health:platform:{workspace_id}:{platform}` | 10m | On health check | Platform health score cache |
| `ab_test:metrics:{experiment_id}` | 5m | On metrics update | AB test variant metrics snapshot |

### 1.3 Cache Invalidation Patterns

| Pattern | When | How |
|---|---|---|
| **Write-through** | Settings, permissions | Update DB + cache atomically |
| **Write-behind** | Analytics counters | Batch write to DB every 30s |
| **Event-driven** | Domain events | Event consumer invalidates cache |
| **TTL-based** | Dashboard, summaries | Auto-expire, lazy refresh |
| **Pub/Sub** | Multi-instance | Dragonfly Pub/Sub broadcast invalidation |

### 1.4 Dragonfly Keyspace Notifications

> Required for credit reservation TTL expiry and circuit breaker state changes.

```bash
# Enable keyspace notifications in Dragonfly config (dragonfly.conf or docker env)
# Ex = expired events + keyevent notifications
notify-keyspace-events "Ex"
```

| Key Pattern | Event | Handler | Purpose |
|---|---|---|---|
| `credits:reservation:{id}` | `expired` | Credit release handler | Release uncommitted credit reservations back to balance on TTL expiry |
| `circuit:{provider}` | `expired` | Circuit breaker reset | Reset circuit breaker to half-open on cooldown expiry |

**Implementation note**: Dragonfly supports Redis keyspace notifications via `__keyevent@0__:expired` subscription. The credit reservation handler MUST release reserved credits back to the workspace balance when the 30-minute TTL expires without a commit/release call. This prevents credit leaks from failed AI generation jobs.

---

## 2. Meilisearch Indexes

### 2.1 Index Definitions

> **Note**: Searchable attributes may be **denormalized** at sync time — e.g., `entity_name` is resolved from `entities` via FK join, `body_text` is extracted from `content` JSONB, `metadata_text` from `metadata` JSONB, `handles_text` from `platform_handles` JSONB, `customer_name` from `customer_entity_id` FK, and `last_message_preview` from the latest `messages` row. These are not direct column names in PostgreSQL.

| Index | Documents | Searchable Attributes | Filterable | Sortable |
|---|---|---|---|---|
| `products` | Products | title, description, category | workspace_id, catalog_status, product_type | created_at, base_price |
| `scripts` | Scripts | title, body_text | workspace_id, lifecycle_state, format_type | created_at, updated_at |
| `ideas` | Ideas | title, description | workspace_id, status | idea_score, created_at |
| `assets` | Assets | title, metadata_text | workspace_id, asset_type, quality_state | created_at |
| `trends` | Trends | title, summary | workspace_id, source_class | strength_score, freshness_at |
| `threads` | Threads | entity_name, last_message_preview | workspace_id, status, priority, intent | last_activity_at |
| `entities` | Entities | display_name, handles_text | workspace_id, entity_type, relationship_state | created_at |
| `offers` | Offers | title, description | workspace_id, lifecycle_state, offer_type | created_at |
| `orders` | Orders | external_order_id, customer_name | workspace_id, lifecycle_state, source_platform | ordered_at |
| `workflows` | Workflows | title | workspace_id, status | updated_at |
| `recipes` | Recipe Templates | title, description, category | status, author_workspace_id | rating_avg, install_count |
| `campaigns` | Campaigns | title, objective | workspace_id, status, campaign_type | start_date, created_at |
| `help_articles` | Help Center | title, body_text, tags | category, language | updated_at |

### 2.2 Vietnamese Tokenizer Config
```json
{
  "analyzerOptions": {
    "tokenizer": "charabia",
    "languages": ["vie", "eng"]
  },
  "synonyms": {
    "đơn hàng": ["order", "hoá đơn"],
    "sản phẩm": ["product", "hàng hóa"],
    "khách hàng": ["customer", "người mua"]
  },
  "typoTolerance": {
    "enabled": true,
    "minWordSizeForTypos": { "oneTypo": 4, "twoTypos": 8 }
  }
}
```

### 2.3 Sync Strategy
- **Real-time**: On domain event → update Meilisearch document
- **Batch rebuild**: Nightly at 3:00 AM for data consistency
- Each index scoped by `workspace_id` as primary filter

---

## 3. ClickHouse Analytics Schema

### 3.1 Tables (OLAP)

```sql
-- Content performance over time
CREATE TABLE content_performance (
  workspace_id UUID,
  publish_item_id UUID,
  platform String,
  metric_date Date,
  views UInt64,
  likes UInt64,
  comments UInt64,
  shares UInt64,
  saves UInt64,
  engagement_rate Float32,
  reach UInt64,
  impressions UInt64,
  watch_time_seconds UInt64,
  revenue Decimal64(6), -- aligned to PostgreSQL NUMERIC(18,6) per DB-H-001
  synced_at DateTime
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(metric_date)
ORDER BY (workspace_id, metric_date, publish_item_id);

-- Profit aggregation (M19)
-- Note: All monetary Decimal columns use Decimal64(6) to match PostgreSQL NUMERIC(18,6) per DB-H-001.
-- This prevents rounding discrepancies when data flows between PostgreSQL and ClickHouse.
CREATE TABLE profit_daily (
  workspace_id UUID,
  scope_type String,
  scope_id UUID,
  metric_date Date,
  gross_revenue Decimal64(6),
  platform_fees Decimal64(6),
  shipping_costs Decimal64(6),
  affiliate_commissions Decimal64(6),
  refunds Decimal64(6),
  cogs Decimal64(6),
  ads_spend Decimal64(6),
  ai_costs Decimal64(6),
  other_costs Decimal64(6),
  net_profit Decimal64(6),
  order_count UInt32,
  currency String DEFAULT 'VND'
) ENGINE = SummingMergeTree()
PARTITION BY toYYYYMM(metric_date)
ORDER BY (workspace_id, metric_date, scope_type, scope_id);

-- AI usage analytics
CREATE TABLE ai_usage (
  workspace_id UUID,
  provider String,
  model String,
  operation String,
  input_tokens UInt32,
  output_tokens UInt32,
  cost_usd Decimal64(6),
  credits_used Decimal64(6), -- aligned to PostgreSQL NUMERIC(18,6) per DB-H-001
  latency_ms UInt32,
  status String,
  created_at DateTime
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(created_at)
ORDER BY (workspace_id, created_at, provider);
```

### 3.2 Materialized Views
```sql
-- Daily workspace revenue summary
CREATE MATERIALIZED VIEW mv_daily_revenue
ENGINE = SummingMergeTree()
ORDER BY (workspace_id, metric_date)
AS SELECT
  workspace_id,
  metric_date,
  sum(gross_revenue) as total_revenue,
  sum(net_profit) as total_profit,
  sum(order_count) as total_orders
FROM profit_daily
GROUP BY workspace_id, metric_date;
```

### 3.3 Data Flow: PostgreSQL → ClickHouse
- **Method**: Outbox events → Rust worker → ClickHouse HTTP insert
- **Frequency**: Near real-time (< 5s delay)
- **Retention**: ClickHouse keeps 2 years, PostgreSQL keeps current + 3 months detail

---

## 4. pgvector Usage

| Table | Column | Dimensions | Index | Use Case |
|---|---|---|---|---|
| `trends` | `embedding` | 768 | IVFFlat | Semantic trend matching |
| `ideas` | `embedding` | 768 | IVFFlat | Idea deduplication + similarity |
| `scripts` | `embedding` | 768 | IVFFlat | Script similarity search |
| `products` | `embedding` | 768 | IVFFlat | Product-content matching |

**Embedding model**: Gemini text-embedding-004 (768 dimensions, multilingual including Vietnamese)

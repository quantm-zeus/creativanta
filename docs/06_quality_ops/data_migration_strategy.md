---
layer: quality_ops
canonical: true
source_file: impl_c4_data_migration_strategy.md
last_verified: 2026-03-30
---

# C4 — Data Migration & Import Strategy

> **Upstream**: Pack 05 (Connector), Pack 06 (Commerce)

---

## 1. Import Sources

| Source | Data Types | Method |
|---|---|---|
| **TikTok Shop** | Orders, products, settlements | API sync (automated) |
| **Shopee** | Orders, products, chat, settlements | API sync (automated) |
| **Lazada** | Orders, products, settlements | API sync (automated) |
| **YouTube** | Videos, analytics, comments, revenue | API sync (automated) |
| **Instagram** | Posts, insights, comments | API sync (automated) |
| **Facebook** | Posts, insights, messenger | API sync (automated) |
| **CSV/Excel** | Products, orders, costs, contacts | Manual upload |
| **Stripe** | Billing, payments, subscriptions | Webhook auto-sync |

## 2. CSV Import Templates

| Template | Required Columns | Optional |
|---|---|---|
| Products | title, product_type, price, currency | category, sku, cogs, images_url |
| Orders | external_id, amount, currency, status, date | product_ref, customer_name, platform |
| Costs | cost_type, amount, currency, date | scope, evidence_url, notes |
| Contacts | display_name, type | platform, handle, relationship |
| Affiliate Links | url, platform | product_ref, commission_rate |

## 3. Import Pipeline

```
Upload CSV → Validate schema → Parse rows → Validate data
    → Create/Match entities → Write to DB → Create audit event
    → Generate import report (success/errors/skipped)
```

### Deduplication Rules:
- **Orders**: Match by `external_order_id + platform` (unique)
- **Products**: Match by `title + product_type` (fuzzy, user confirms)
- **Contacts**: Match by `platform + handle` (exact)

## 4. Initial Sync Flow (New Connection)

```
1. User connects account (OAuth)
2. System triggers initial_sync job
3. Fetch all historical data (last 90 days default)
4. Import products → orders → settlements → posts → comments
5. Generate import summary
6. User reviews → confirms
7. Ongoing incremental sync starts
```

## 5. Data Freshness

| Data Type | Initial Sync | Ongoing Sync | Staleness Threshold |
|---|---|---|---|
| Orders | 90 days | Every 10-15 min | 30 min |
| Products | All active | Every 1h | 6h |
| Settlements | 90 days | Daily | 24h |
| Posts/Videos | 90 days | Every 30m-1h | 2h |
| Comments | 30 days | Every 2-5 min | 10 min |
| Analytics | 90 days | Every 1-6h | 12h |

---

## 6. Error Handling & Recovery

### Import Error Classification

| Error Class | Action | Retry | Example |
|---|---|---|---|
| **Schema validation** | Reject row, continue batch | No | Missing required column, wrong date format |
| **Dedup conflict** | Skip row, log as duplicate | No | Order with same external_id+platform |
| **API rate limit** | Pause sync, backoff | Yes (circuit breaker) | Platform API 429 response |
| **API auth expired** | Pause sync, refresh token | Yes (1 attempt) | OAuth token expired mid-sync |
| **Network timeout** | Retry with exponential backoff | Yes (3 attempts) | Connection dropped |
| **Partial batch** | Commit successful rows, report failed | No | 95/100 rows imported |

### Rate Limit Coordination

Platform API rate limits interact with sync frequencies from §5. The circuit breaker per provider (see `queue_retry_design.md` §6) governs pause/resume behavior:

| Platform | Rate Limit | Sync Strategy |
|---|---|---|
| TikTok Shop | 600 req/min content, 1000 req/min shop | Batch with rate limiter (per connector_specs §2) |
| Shopee | 10 req/s per shop | Queue-based with token bucket (per connector_specs §3) |
| Lazada | 50 req/s per app, 5000/min | Batch with 20ms delay (per connector_specs §4) |
| YouTube | 10,000 units/day | Priority-based allocation across data types |
| Instagram/Facebook | 200 calls/hour | Graph API paging with backoff |

### Failed Import Recovery

1. **Per-row tracking**: Each import row gets a `sync_status` (success/failed/skipped) with `error_message`
2. **Import report**: Generated after every batch — includes success count, failure count, and downloadable error CSV
3. **Manual retry**: Users can re-upload failed rows after correction
4. **Rollback**: Imports within the same transaction batch can be rolled back via `import_batch_id`; cross-batch rollback requires admin intervention
5. **Audit trail**: Every import creates `data.import_completed` or `data.import_failed` domain event (see `domain_event_catalog.md` §18)

---
layer: quality_ops
canonical: true
source_file: impl_c4_data_migration_strategy.md
last_verified: 2026-10-30
---

# C4 — Data Migration & Import Strategy

> **Upstream**: Pack 05 (Connector), Pack 06 (Commerce)
> API imports require per-action access evidence under [connector specs](../04_contracts/connector_specs.md); otherwise use authorized export/import paths. The table lists candidate integrations, not granted access.

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
- **Orders**: Use the account-scoped economic identity and source revision in the financial computation contract; never deduplicate two shops using external_order_id alone.
- **Products**: Match verified source account/external identity or explicit catalog ID. Title similarity produces a suggestion requiring user confirmation, never an automatic merge.
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
| **Dedup conflict** | Skip row, log as duplicate | No | Identical source identity/revision; changed revision is a correction |
| **API rate limit** | Pause sync, backoff | Yes (circuit breaker) | Platform API 429 response |
| **API auth expired** | Pause sync, refresh token | Yes (1 attempt) | OAuth token expired mid-sync |
| **Network timeout** | Retry with exponential backoff | Yes (3 attempts) | Connection dropped |
| **Partial batch** | Commit successful rows, report failed | No | 95/100 rows imported |

### Rate Limit Coordination

Platform API rate limits interact with sync frequencies from §5. The circuit breaker per provider (see `queue_retry_design.md` §6) governs pause/resume behavior:

Use verified per-app/account/endpoint budgets and Retry-After under the connector contract. The freshness table is a target, not a guarantee of platform quota or availability.

### Failed Import Recovery

1. **Per-row tracking**: Each import row gets a `sync_status` (success/failed/skipped) with `error_message`
2. **Import report**: Generated after every batch — includes success count, failure count, and downloadable error CSV
3. **Manual retry**: Users can re-upload failed rows after correction
4. **Rollback**: Before commit, discard the preview. After commit, apply permission-checked compensating corrections to affected canonical objects; never delete stock/financial history or imply reversal of an external effect.
5. **Audit trail**: Import results are audited with job/request identity and row outcomes. Emit existing owning events (`order.imported`, `product.created`, `cost.recorded`) only for committed changes, using the domain event catalog.

## 7. Preview, commit and repair acceptance

CSV headers above are upload aliases, not DB column names. The versioned mapping preview resolves aliases to exact schema fields (e.g., product price → base_price, order external_id → external_order_id, status → lifecycle_state, cost date → effective_date). Unknown/ambiguous headers, money locale, currency or timezone require explicit resolution. Template/mapping version and original upload hash are part of commit identity. XLSX input is parsed as data, never executes formulas/macros/external links.

Default import bound: 10 MiB and 10,000 rows per file; larger files are split with stable source identity. Preview shows create/update/unchanged/error rows and economic impact before commit. Successful rows commit independently unless the user chooses an explicitly atomic supported batch; failed rows are downloadable with original source identity for safe retry. Changed file/mapping invalidates the preview. Error exports neutralize spreadsheet formula prefixes without modifying stored canonical text. Raw uploads and import reports obey scoped storage/retention and never expose another tenant.

Tests: repeated file, reordered identical source rows, two shops sharing an order number, changed source revision, missing currency/COGS, locale decimal parsing, invalid foreign reference, hostile spreadsheet cell, failed row retry, crash after commit and stock baseline overlap. Use [financial fixtures](../04_contracts/financial_computation_contract.md) and [inventory fixtures](../04_contracts/inventory_computation_contract.md) for economic results.

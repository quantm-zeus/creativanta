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

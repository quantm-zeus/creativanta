# Screen: Web — Finance: Revenue Detail

> **Screen ID**: W082
> **Module**: M19 — Operating Ledger (Revenue)
> **Route**: `/finance/revenue`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06 §Finance, PRD §33 Profit OS, A1 Schema (orders, billing_events, revenue_records), B5 RBAC §2.8

---
## 1. Purpose & Context

Revenue breakdown by source, platform, product, and content — with period comparison, trend analysis, source class transparency, and export capability. This is the "revenue truth" screen where every VND is attributed and source-classified per PRD §33 operating ledger requirements.

### User Goals
- Understand where revenue comes from (platform, product, content)
- Compare revenue across periods to identify growth trends
- Drill into specific revenue sources for detailed analysis
- Export revenue data for accounting or tax reporting

### Business Goals
- Provide transparent, source-attributed revenue tracking (no black boxes)
- Enable data-driven decisions on product/content investment
- Support tax reporting with exportable, verifiable data
- Distinguish Official vs Estimated revenue for confidence-based planning

### Entry Points
- Finance Dashboard (W081): "📈 Revenue" card → drill into detail
- Sidebar: Finance → "📈 Doanh thu"
- Home Dashboard: revenue KPI tap
- Copilot: "Phân tích doanh thu TikTok tháng này"

### Exit Points
- Click platform row → filtered view for that platform
- Click product row → Product Detail (W061) or product-specific revenue
- Click content row → Content detail or analytics
- "← Finance" → Finance Dashboard (W081)
- "📤 Export" → CSV/PDF download

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `profit:read` permission (Owner, Admin)
- Or `profit:read` for Manager role (revenue only, no profit)
- At least one order or billing event exists

### Postconditions
- No data mutations (read-only screen)
- Export events logged for audit trail

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Finance   📈 Doanh thu chi tiết      [Period: 30 ngày ▾] [📤]   │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Revenue Summary ─────────────────────────────────────────────┐   │
│ │ 💰 Tổng doanh thu: 45,000,000 VND · ↑18% vs kỳ trước        │   │
│ │ Source: [🟢 Official: 38M (84%)] [🟡 Estimated: 7M (16%)]   │   │
│ │                                                                │   │
│ │ [Line chart: daily revenue over period ──────────────────]     │   │
│ │ [comparison line: previous period - dashed]                    │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ KPI Cards: ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐                    │
│ │ 🛒 1,200│ │ 📊AOV│ │ 📈 Rev│ │ 🔄Refund│                       │
│ │ orders  │ │ 208K │ │ /day  │ │ -2.3M  │                          │
│ │ ↑12%    │ │ ↑5%  │ │ 1.5M  │ │ (5.1%) │                          │
│ └──────── ┘ └──────┘ └───── ┘ └────── ┘                            │
│                                                                      │
│ Tabs: [📊 By Platform] [📦 By Product] [🎬 By Content] [📅 By Day]│
│                                                                      │
│ ── By Platform ──                                                    │
│ ┌─ Revenue Table ────────────────────────────────────────────────┐  │
│ │ Platform      │ Revenue  │ Orders │ AOV    │ Fees   │ Net     │  │
│ │ 🎵 TikTok Shop│ 25M [🟢] │ 850   │ 294K  │ -5M    │ 20M     │  │
│ │ 🛍 Shopee      │ 15M [🟢] │ 600   │ 250K  │ -2.4M  │ 12.6M   │  │
│ │ 📱 Direct      │ 5M  [🔵] │ 50    │ 1M    │ -500K  │ 4.5M    │  │
│ │ ──────────────── ──────── ──────── ─────── ──────── ───────── │  │
│ │ TOTAL          │ 45M      │ 1,500  │ 300K  │ -7.9M  │ 37.1M   │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ── By Product (top 10) ──                                            │
│ ┌─ Product Revenue Table ────────────────────────────────────────┐  │
│ │ # │ Product         │ Revenue │ Orders │ % of total │ Trend  │  │
│ │ 1 │ Serum HA        │ 15M     │ 600    │ 33%       │ ↑22%   │  │
│ │ 2 │ Mask set        │ 8M      │ 400    │ 18%       │ ↑10%   │  │
│ │ 3 │ Toner AHA       │ 5M      │ 250    │ 11%       │ ↓5%    │  │
│ │ ...                                                             │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [📤 Export CSV] [📄 Export PDF Report]                               │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
RevenueDetailPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Finance")
│   ├── PageTitle ("📈 Doanh thu chi tiết")
│   ├── PeriodSelector (7d, 30d, 90d, This Month, Last Month, Custom)
│   └── ExportDropdown (CSV, PDF Report)
├── RevenueSummaryCard
│   ├── TotalRevenue (animated counter)
│   ├── PeriodComparison (↑/↓ percentage vs previous period)
│   ├── SourceClassBreakdown
│   │   ├── OfficialAmount + percentage
│   │   ├── ImportedAmount + percentage
│   │   └── EstimatedAmount + percentage
│   ├── RevenueChart
│   │   ├── CurrentPeriodLine (solid)
│   │   └── PreviousPeriodLine (dashed, for comparison)
│   └── TrustBadge (S009 — overall source class)
├── KPICardRow
│   ├── TotalOrders (count + trend)
│   ├── AOV (average order value + trend)
│   ├── RevenuePerDay (average + trend)
│   └── RefundImpact (total refunds + % of revenue)
├── BreakdownTabs
│   ├── PlatformTab
│   │   └── PlatformRevenueTable
│   │       ├── SortableColumns (Platform, Revenue, Orders, AOV, Fees, Net)
│   │       ├── PlatformRow[] (with source badge per platform)
│   │       └── TotalRow (bold, summary)
│   ├── ProductTab
│   │   └── ProductRevenueTable
│   │       ├── SortableColumns (Rank, Product, Revenue, Orders, % of total, Trend)
│   │       └── ProductRow[] (top 20, with product thumbnail)
│   ├── ContentTab
│   │   └── ContentRevenueTable
│   │       ├── SortableColumns (Content, Type, Revenue Attributed, Orders, Conv Rate)
│   │       └── ContentRow[] (content that drove revenue via attribution)
│   └── DayTab
│       └── DailyRevenueTable
│           ├── Columns (Date, Revenue, Orders, AOV)
│           └── DayRow[] (each day in period)
├── ExportButtons
│   ├── ExportCSV
│   └── ExportPDFReport
```

---
## 5. Displayed Data

| Field | Source | Format | Source Class |
|---|---|---|---|
| Total revenue | `SUM(orders.total_amount)` for period | VND "45,000,000đ" | Official (if all from API) |
| Period comparison | Computed vs previous equal period | "↑18%" | Computed |
| Revenue by platform | Group by `orders.source_platform` | VND per platform | Official |
| Platform fees | `SUM(orders.platform_fee + commission)` | VND negative | Official |
| Net revenue | Revenue - fees | VND | Computed |
| Revenue by product | Join `order_items` → group by product | VND per product | Official |
| Revenue by content | `order_attribution` → group by content | VND per content | Inferred |
| AOV | Total revenue / total orders | VND | Computed |
| Total orders | `COUNT(orders)` | Integer | Official |
| Refund impact | `SUM(refunds.amount)` | VND + % of revenue | Official |
| Daily revenue | Group by `orders.ordered_at::date` | VND per day | Official |

---
## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Change period | Period selector | `RevenueService/GetRevenue(period)` | All data + chart update | `profit:read` |
| 2 | Switch tab | Click tab | Client-side (data pre-fetched) | Table switches | `profit:read` |
| 3 | Sort column | Click column header | Client-side sort | Table re-sorts | `profit:read` |
| 4 | Drill into platform | Click platform row | — | Filter to that platform | `profit:read` |
| 5 | View product | Click product name | — | → `/products/[id]` | `product:read` |
| 6 | View content | Click content name | — | → Content detail page | `report:read` |
| 7 | Export CSV | "📤 Export CSV" | Client-side CSV gen | CSV download | `profit:read` |
| 8 | Export PDF | "📄 Export PDF" | Server-side PDF gen | PDF download | `profit:read` |
| 9 | Custom period | "Custom" → date range picker | Refetch | Data for custom range | `profit:read` |

---
## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Summary card shimmer, chart placeholder, table skeletons |
| LOADED | Data received | Full revenue dashboard |
| EMPTY | No revenue in period | "Chưa có doanh thu trong kỳ này. [Xem kỳ trước →]" |
| ERROR | API failed | Error with retry |
| PARTIAL | Some platforms failed to sync | Warning: "⚠️ Dữ liệu TikTok Shop chưa cập nhật (3h ago). Tổng có thể chưa chính xác." |

---
## 8. Permissions

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View revenue | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View fees/net | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| View content attribution | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Export | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

**Manager sees**: Revenue total, orders, AOV, by platform (gross only), by product. **Manager does NOT see**: Platform fees, net revenue, commission details.

---
## 9. Trust & Source Integration

- Every revenue amount shows a source class badge inline (S009)
- Revenue chart has a "confidence band" shading: lighter shade = estimated data
- Table rows with Estimated source show 🟡 instead of 🟢
- Footer note: "Dữ liệu với nguồn Estimated (🟡) có thể thay đổi khi platform cập nhật settlement."
- "Why this number?" drawer available on any metric

---
## 10. Edge Cases

| Edge Case | Handling |
|---|---|
| Refund > revenue for period | Net shows negative, red card: "🔴 Hoàn tiền vượt doanh thu kỳ này" |
| Partial platform sync | Banner: "⚠️ {platform} chưa cập nhật ({time_ago}). Tổng có thể chưa chính xác." |
| Manager view (no fees/net) | Fee and Net columns hidden; only gross revenue visible |
| All revenue from single platform | Platform tab shows 100% single entry, comparison hides |
| Content attribution lacking | Content tab: "⚠️ Attribution có thể không đầy đủ — chỉ tính qua link tracking." |

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Auto-retry online |
| Platform sync fail | API rate limit | Banner per platform: "⚠️ {platform} tạm ngừng đồng bộ" | Auto-retry in 15min |
| Chart render fail | SVG error | Fallback table | Retry |
| Export timeout | Large dataset | Toast: "Giảm khoảng thời gian hoặc thử lại." | Retry with shorter period |
| Revenue aggregation fail | ClickHouse error | "Không tải được. [Thử lại]" | Retry |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Revenue summary | `role="status"`, `aria-label="Tổng doanh thu: {value}đ, tăng {delta}%"` |
| Revenue chart | `role="img"`, `aria-label="Biểu đồ doanh thu qua {period}đ"` + data table fallback |
| Source class badges | `aria-label="Nguồn: {Official/Estimated}"`, text + icon (not color-only) |
| Revenue tables | `role="table"`, sortable columns with `aria-sort` |
| Tab container | `role="tablist"`, `role="tab"` with `aria-selected` |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Summary card shimmer |
| Revenue summary | 200-400ms | Counter animates |
| KPI cards | 300-600ms | Cards populate |
| Revenue chart | 400-800ms | Line draws left→right |
| Tables | 500-1000ms | Rows stagger in |
| Export | 1-5s | Button spinner |

---

## 14. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `finance_revenue.viewed` | Page load | `period`, `total_revenue`, `platform_count` |
| `finance_revenue.period_changed` | Period select | `from_period`, `to_period` |
| `finance_revenue.tab_changed` | Tab click | `tab_name` |
| `finance_revenue.platform_drilled` | Platform row click | `platform` |
| `finance_revenue.product_drilled` | Product row click | `product_id` |
| `finance_revenue.sorted` | Column sort | `column`, `direction` |
| `finance_revenue.exported` | Export | `format`, `period` |
| `finance_revenue.custom_period` | Custom date range | `start_date`, `end_date` |

---

## 15. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/finance/revenue/+page.svelte`
- **Server load**: `+page.server.ts` → `RevenueService/GetRevenue(period)` from ClickHouse
- **Charts**: `layerchart` — line chart with confidence band shading for estimated data
- **Tables**: Client-side sort (data pre-fetched for all tabs in server load)
- **Source badges**: S009 trust badge per row (`<TrustBadge source={entry.source_class} />`)
- **Export CSV**: Client-side via `papaparse`, PDF: server-side `RevenueService/ExportPDF`
- **No localStorage**: Financial data never cached client-side

---

## 16. Design Tokens

| Token | Usage |
|---|---|
| `--color-revenue` | Revenue chart line, total (blue) |
| `--color-refund` | Refund amount (red) |
| `--color-trust-official` | 🟢 Official badge |
| `--color-trust-imported` | 🟡 Imported badge |
| `--color-trust-estimated` | ⚪ Estimated badge |
| `--color-delta-positive` | ↑ growth (green) |
| `--color-delta-negative` | ↓ decline (red) |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards |

---

## 17. Related Screens

| Screen | Relationship |
|---|---|
| [W081] Profit Dashboard | Parent finance overview |
| [W083] Cost Detail | Cost counterpart |
| [W084] Reconciliation | Verify revenue data |
| [W085] Proof Browser | Evidence supporting claims |
| [W062] Order List | Source orders |
| [M042] Mobile Revenue | Mobile equivalent |

---

## 18. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (refund > rev, partial sync), 5 errors, table/chart a11y, 8 analytics, SvelteKit impl (confidence band), 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

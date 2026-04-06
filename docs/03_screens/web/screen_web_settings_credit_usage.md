# Screen: Web — AI Credit Usage

> **Screen ID**: W121
> **Module**: M23 — Settings
> **Route**: `/settings/credits/usage`
> **Platform**: Web (SvelteKit)
> **Upstream**: M23 Part A, A1 Schema (`ai_credit_transactions`, `workspaces`), A3 API (`CreditService/GetBalance`, `CreditService/GetMonthlyUsage`, `UsageService/GetBreakdown`), B5 RBAC §2.9

---

## 1. Purpose & Context

Track AI credit consumption — balance with depletion forecast, daily usage chart by AI mode, and detailed usage history with filtering.

### User Goals
- Understand credit spending patterns (which AI modes consume most)
- Monitor daily burn rate and project when credits will run out
- Review individual credit transactions with details
- Identify wasteful usage (failed generations, refunded credits)

### Entry Points
- Credit Purchase (W123): "📊 View full usage history →"
- Top nav: credit counter → usage detail
- AI Settings (W125): "View usage" link

### Exit Points
- "💳 Mua thêm" → Credit Purchase (W123)
- "📈 Nâng cấp" → Billing & Subscription

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Settings   🪙 AI Credit Usage                                    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Balance ─────────────────────────────────────────────────────┐   │
│ │ Remaining: 🪙 320 / 500    [████████████░░░░░░] 64%           │   │
│ │ Plan: Pro (500/month) · Resets: 1/4/2026 (4 days)            │   │
│ │ Burn rate: 15 cr/day avg · Projected depletion: 21 days ✅   │   │
│ │ [💳 Mua thêm credits] [📈 Nâng cấp gói]                     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Usage This Month (stacked bar chart) ────────────────────────┐   │
│ │ [Stacked bars: daily credit usage, color-coded by mode]       │   │
│ │ Legend: ■ Quick Edit (45cr) ■ Clip Factory (30cr)             │   │
│ │ ■ Showcase (60cr) ■ Remix (35cr) ■ Other (10cr)              │   │
│ │ Total: 180 credits used this month                             │   │
│ │                                                                │   │
│ │ Mode breakdown (pie):                                          │   │
│ │ Quick Edit: 25% · Showcase: 33% · Remix: 19% · Other: 23%   │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Filter: [Mode ▾] [Period ▾] [Status ▾] Search: [🔍 Asset name...] │
│                                                                      │
│ ┌─ Usage History ───────────────────────────────────────────────┐   │
│ │ Date  │ Mode      │ Item                  │ Credits │ Status  │   │
│ │ 27/3  │ Showcase  │ "Serum VitC video"    │ -15     │ ✅ OK  │   │
│ │ 27/3  │ Thumbnail │ "5 tips thumbnail"    │ -5      │ ✅ OK  │   │
│ │ 26/3  │ Remix     │ "Cooking AI remix"    │ -35     │ ✅ OK  │   │
│ │ 26/3  │ Remix     │ "Skincare remix"      │ -35     │ ↩️ Ref │   │
│ │       │           │ Refund reason: AI timeout│ +35   │ ✅ Ref │   │
│ │ 25/3  │ Quick Ed  │ "Review edit batch"   │ -75     │ ✅ OK  │   │
│ │ 25/3  │ Img→Video │ "Product carousel"    │ -10     │ ✅ OK  │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ Pagination: [← Trước] Page 1/8 [Tiếp →]                           │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Chart shimmer + table skeleton |
| LOADED | Data received | Full usage dashboard |
| NO_USAGE | No credits used this period | "Chưa sử dụng credit nào trong kỳ này." |
| LOW_CREDITS | Balance < 20% | Orange warning on balance |
---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached balance/chart | Retry online |
| Chart render fail | Canvas error | Fallback: table view of daily totals | Switch view |
| Filter no results | Filter returns empty | "Không tìm thấy giao dịch phù hợp. [Reset bộ lọc]" | Reset |
| Usage history fail | API error | "Không tải được lịch sử. [Thử lại]" | Retry |
| Balance fetch fail | API error | Skeleton persists + toast | Retry |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Balance card | `role="status"`, `aria-label="320 of 500 credits remaining, 64%"` |
| Progress bar | `role="progressbar"`, `aria-valuenow="320"`, `aria-valuemax="500"` |
| Stacked chart | `aria-label="Credit usage chart"`, data table alternative |
| Usage table | `role="table"`, sortable column headers with `aria-sort` |
| Filter controls | `aria-label="Filter by {type}"`, combobox pattern |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Balance + chart skeletons |
| Balance | 100-300ms | Balance populates, bar animates |
| Chart | 300-700ms | Bars render progressively |
| Usage table | 400-800ms | Rows stagger in |
| Filter | 200-500ms | Table refreshes |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `credit_usage.viewed` | Page load | `balance`, `burn_rate`, `days_to_depletion` |
| `credit_usage.chart_period_changed` | Period filter | `old_period`, `new_period` |
| `credit_usage.mode_filter_applied` | Mode filter | `mode` |
| `credit_usage.status_filter_applied` | Status filter | `status` |
| `credit_usage.searched` | Search input | `query` |
| `credit_usage.paginated` | Page change | `page`, `total_pages` |
| `credit_usage.buy_clicked` | "💳 Mua thêm" | `balance`, `source` |
| `credit_usage.upgrade_clicked` | "📈 Nâng cấp" | `current_plan` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/settings/credits/usage/+page.svelte`
- **Server load**: `+page.server.ts` → `AdminBillingService/GetCreditBalance` + `CreditService/GetUsageStats(period)` + `CreditService/ListTransactions(page, filters)`
- **Chart**: Chart.js stacked bar chart, rendered client-side with SSR data
- **Depletion**: `balance / avg_daily_usage` computed server-side, cached 5m
- **Filters**: URL search params (`?mode=remix&status=ok&page=2`) for shareable state
- **Pagination**: Cursor-based, 20 per page
- **Refund display**: Inline with original transaction, negative credit shown as green "↩️ +{n}"
- **Export**: "📊 Export CSV" → server generates file from current filter state

---

## 13. Localization Notes

- Balance: "🪙 320 / 500 credits"
- Burn rate: "15 credit/ngày trung bình"
- Depletion: "Dự kiến hết: 21 ngày ✅" or "⚠️ Dự kiến hết trước khi reset!"
- Modes: "Chỉnh nhanh", "Clip Factory", "Showcase", "Remix"
- Status: "✅ OK", "↩️ Hoàn lại", "❌ Thất bại"
- Tone: Analytical, informative

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-chart-quickedit` | Quick Edit bar color |
| `--color-chart-clipfactory` | Clip Factory bar color |
| `--color-chart-showcase` | Showcase bar color |
| `--color-chart-remix` | Remix bar color |
| `--color-chart-other` | Other modes bar color |
| `--color-success` | Balance healthy, refunds |
| `--color-warning` | Low balance (<20%) |
| `--color-surface-elevated` | Balance card, chart card |
| `--font-metric` | Credit numbers (tabular-nums) |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W128] Credit Purchase | Buy more credits |
| [W123] AI Preferences | AI model preferences |
| [W021] Studio Launcher | Where credits are consumed |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (chart render, filter), chart/table a11y, 8 analytics, SvelteKit impl (chart.js, cursor pagination), localization, 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

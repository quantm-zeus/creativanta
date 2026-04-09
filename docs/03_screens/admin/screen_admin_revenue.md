# Screen: Admin — Platform Revenue Dashboard

> **Screen ID**: A022
> **Module**: S26 — Internal Admin & Operations
> **Route**: `/admin/revenue`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: S26 §Finance, A1 Schema (`billing_events`, `subscription_events`, `ai_credit_transactions`, commission revenue projections), B5 RBAC §3

---

## 1. Purpose & Context

Platform revenue dashboard — detailed breakdown of subscription MRR, commission fees, credit sales, and revenue by source/plan. Includes real-time transaction feed, revenue forecasting, and anomaly detection.

### User Story
> As a platform operator, I want to see real-time revenue from all sources—subscriptions, credits, and fees—so I can track financial performance and detect anomalies.

### Business Goal
- Real-time revenue visibility across all monetization channels
- Revenue source diversification tracking (subscriptions vs. credits vs. fees)
- Anomaly detection for payment processing issues
- Revenue forecasting for cash flow planning

### When to Use
- Daily revenue check
- Investigating payment processing issues
- Month-end financial review
- Revenue source mix analysis
- Payment failure investigation

### Entry Points
- Admin sidebar → "💰 Finance" → "Revenue"
- Dashboard → "Revenue" card click
- Business Analytics → "View revenue detail"
- Alert: "⚠️ Payment failures spiking" → deep link

### Exit Points
- Drill-down by plan/source → detail pages
- Transaction detail → expand
- Export → CSV/PDF download

---

## 2. Preconditions / Postconditions

### Preconditions
- Admin with `finance_admin` or `super_admin` role
- VPN connection active
- Payment data flowing from payment provider (Stripe/local gateway)

### Postconditions
- Dashboard data rendered (point-in-time)
- Export file generated if requested

---

## 3. Layout Structure

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 💰 Platform Revenue           [Period: T3/2026 ▾] [↔ Compare] [📥]│
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ┌─ Revenue Summary ──────────────────────────────────────────────┐  │
│ │ Total Revenue   │ Subscription MRR │ Credit Sales  │ Comm Fees │  │
│ │ 145.7M VND     │ 125.2M VND       │ 8.2M VND     │ 12.5M VND│  │
│ │ ↑ 8.2% MoM     │ ↑ 6.5% MoM       │ ↑ 15% MoM    │ ↑ 4% MoM │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Revenue Trend (6 months) ─────────────────────────────────────┐  │
│ │ [Stacked area chart]                                            │  │
│ │ ■ Subscriptions  ■ Credit Sales  ■ Commission Fees  ■ Other   │  │
│ │                                                                 │  │
│ │  ▁▂▃▄▅▆▇█  (smooth uptrend)                                   │  │
│ │  Oct Nov Dec Jan Feb Mar                                        │  │
│ │                                                                 │  │
│ │ Forecast: 155M VND expected for T4 (↑ 6.4%)                   │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ By Plan Breakdown ──────────┐ ┌─ By Source Breakdown ─────────┐  │
│ │ Enterprise: 40M (28%) ██████ │ │ New subscriptions: 35% ██████│  │
│ │ Business:   35M (24%) █████  │ │ Renewals:          45% ██████│  │
│ │ Pro:        30M (21%) ████   │ │ Upgrades:          12% ██    │  │
│ │ Starter:    15M (10%) ██     │ │ Credit purchases:   6% █     │  │
│ │ Credits:    8.2M (6%) █      │ │ Fees:               2%       │  │
│ │ Fees:      12.5M (9%) ██     │ │                               │  │
│ │ Other:      5M (3%)          │ │ NRR: 112% ✅ (target >100%) │  │
│ └──────────────────────────────┘ └───────────────────────────────┘  │
│                                                                       │
│ ┌─ Payment Health ───────────────────────────────────────────────┐  │
│ │ Success rate: 97.2% ✅ │ Decline rate: 2.1% │ Retry: 0.7%    │  │
│ │ Failed today: 3 (8.5M VND potential)                            │  │
│ │ [View failed payments →]                                        │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Recent Transactions ──────────────────────────────────────────┐  │
│ │ Time    │ Workspace │ Type            │ Amount   │ Status     │  │
│ │─────────│───────────│─────────────────│──────────│────────────│  │
│ │ 14:30   │ ws_abc   │ Pro upgrade     │ +299K    │ ✅ Success │  │
│ │ 14:22   │ ws_def   │ Credit purchase │ +99K     │ ✅ Success │  │
│ │ 14:15   │ ws_ghi   │ Business renew  │ +999K    │ ✅ Success │  │
│ │ 13:50   │ ws_jkl   │ Pro upgrade     │ +299K    │ ❌ Failed  │  │
│ │         │          │ Error: Card declined                      │  │
│ │ [← 1 2 3 ... →]                                                │  │
│ └─────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
PlatformRevenuePage
├── AdminShell (shared)
├── PageHeader
│   ├── Title ("💰 Platform Revenue")
│   ├── PeriodSelector (month picker)
│   ├── CompareToggle (vs previous period)
│   └── ExportButton (CSV/PDF)
├── RevenueSummaryRow (4 metric cards)
│   ├── TotalRevenueCard (value + MoM + sparkline)
│   ├── SubscriptionMRRCard (value + MoM)
│   ├── CreditSalesCard (value + MoM)
│   └── CommissionFeesCard (value + MoM)
├── RevenueTrendChart (stacked area, 6 months)
│   ├── ChartCanvas
│   ├── Legend
│   ├── ForecastLine (dashed line for prediction)
│   └── ForecastLabel
├── BreakdownRow (side-by-side)
│   ├── PlanBreakdownChart (horizontal bar)
│   │   └── PlanBar[] (plan name + value + percentage)
│   └── SourceBreakdownChart (horizontal bar)
│       ├── SourceBar[] (new/renew/upgrade/credits/fees)
│       └── NRRIndicator
├── PaymentHealthCard
│   ├── SuccessRate (percentage with health indicator)
│   ├── DeclineRate
│   ├── RetryRate
│   ├── FailedTodayCount + PotentialRevenue
│   └── ViewFailedLink
├── RecentTransactionsTable
│   ├── TableHeader (sortable)
│   └── TransactionRow[]
│       ├── TimeCell
│       ├── WorkspaceCell (clickable)
│       ├── TypeCell (badge)
│       ├── AmountCell (formatted VND)
│       ├── StatusCell (✅/❌/⏳)
│       └── ErrorDetail (conditional — for failed)
│   └── Pagination
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Total revenue | Billing + subscription + AI-credit revenue projection | `AdminRevenueService/GetSummary(month)` | VND millions with MoM (145.7M ↑8.2%) | 15m TTL |
| MRR | `subscription_events` monthly | same | VND millions | 15m TTL |
| Revenue trend | `revenue_snapshots` (6 months) | `AdminRevenueService/GetTrend(6mo)` | Stacked area chart | 1h TTL |
| Forecast | ML or linear regression from trend | same | Dashed line + label | 1h TTL |
| Plan breakdown | `payment_events` grouped by plan | same | Horizontal bars + values | 15m TTL |
| Payment health | `payment_events` success/fail counts | `AdminRevenueService/GetPaymentHealth` | Percentages + counts | 5m TTL |
| Transactions | `payment_events` recent | `AdminRevenueService/ListTransactions(page)` | Table rows | No cache |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Change period | Select month | `AdminRevenueService/GetSummary(month)` | — | All data reloads for selected month | `finance_admin` |
| 2 | Toggle compare | Click "↔ Compare" | `AdminRevenueService/GetComparison` | — | Delta values shown beside current | `finance_admin` |
| 3 | Export CSV | Click export | `AdminRevenueService/Export(csv)` | — | CSV download | `finance_admin` |
| 4 | View failed payments | Click "View failed" | — | — | Navigate to failed payments page | `finance_admin` |
| 5 | View transaction detail | Click transaction row | — | — | Expand row with full detail | `finance_admin` |
| 6 | View workspace | Click workspace in table | — | — | Navigate to `/admin/workspaces/[id]` | Any admin |
| 7 | Retry failed payment | Click "Retry" on failed transaction | `AdminRevenueService/RetryPayment(id)` | Retry queued | Toast "Retrying..." | `finance_admin` |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching data | Shimmer cards + skeleton charts |
| LOADED | Data ready | Full dashboard |
| COMPARING | Compare mode active | Delta values beside metrics |
| DECLINING | MRR ↓ > 5% MoM | 📉 Red alert: "MRR declining! Down {n}% from last month." |
| PAYMENT_ISSUES | Success rate < 95% | 🔴 Red alert: "Payment success rate below target! {n}% failures." |
| HEALTHY | All metrics positive | Green indicators across the board |
| ERROR | API failure | Error state with retry |

---

## 8. Validation Rules

N/A — Read-only dashboard.

---

## 9. Permission Matrix

| Action | Super Admin | Finance Admin | Operations Admin | Support Admin | Analyst |
|---|---|---|---|---|---|
| View revenue | ✅ | ✅ | ❌ | ❌ | ❌ |
| View transactions | ✅ | ✅ | ❌ | ❌ | ❌ |
| Export data | ✅ | ✅ | ❌ | ❌ | ❌ |
| Retry payments | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Revenue (/admin/revenue)
├── → /admin/revenue/failed             (via "View failed payments")
├── → /admin/workspaces/[id]            (via workspace click)
├── → /admin/analytics/business          (related)
├── → /admin/subscriptions               (related)
└── ← /admin                            (via breadcrumb)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Data fetch failed | API error | Per-section error with retry | Manual retry |
| Export failed | Generation error | Toast "Export failed" | Retry |
| Retry payment failed | Payment provider error | Toast "Retry failed: {reason}" | Manual investigation |
| Partial data | Some sources missing | Affected sections show "N/A" | Auto-retry |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Metric cards | `role="status"`, value + change announced |
| Charts | Alternative data table view |
| Transaction table | Proper `<th>` headers, sortable columns announced |
| Status badges | Text + color |
| Forecast | Clearly labeled as "prediction, not actual" |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Page load | <1s | Admin Shell + shimmer |
| Data fetch | 500ms-1s | Cards → charts → table (progressive) |
| Period change | 300-500ms | Charts transition with animation |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Page load | <3s |
| Chart render | <1s |
| Transaction table | <300ms for 50 rows |
| Export | <5s for CSV |

---

## 15. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| Transactions | SSE `/admin/events/payments` | Real-time (latest 10) |
| Revenue totals | Polling | 15m |
| Payment health | Polling | 5m |

---

## 16. Localization Notes

- Admin interface: English only
- Currency: VND (no decimals), "M" = millions, "B" = billions
- Dates: ISO format / month abbreviations (T3 for tháng 3)

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `admin.revenue.viewed` | Page load | `period`, `total_revenue` |
| `admin.revenue.period_changed` | Period switch | `old`, `new` |
| `admin.revenue.exported` | Export | `format`, `period` |
| `admin.revenue.payment_retried` | Retry | `transaction_id` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-admin-success` | Positive changes, healthy indicators |
| `--color-admin-danger` | Declines, failed payments |
| `--color-chart-subscription` | Subscription area in stacked chart |
| `--color-chart-credits` | Credits area |
| `--color-chart-fees` | Fees area |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [A024] Business Analytics | Business-level metrics |
| [A021] Subscriptions | Subscription operations |
| [A014] AI Credits | Credit management |
| [A001] Admin Dashboard | Summary hub |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 61-line Tier C. Added forecast line, payment health section with success/decline/retry rates, detailed transaction table with retry capability, plan/source breakdown side-by-side, NRR indicator, compare mode, 7 states including payment anomaly alerts. Fixed Screen ID (A15→A015), module (Admin→S26). | System |

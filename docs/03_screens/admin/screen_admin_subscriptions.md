# Screen: Admin — Subscription & Billing Management

> **Screen ID**: A021
> **Module**: S26 — Billing & Revenue Operations
> **Route**: `/admin/subscriptions`
> **Platform**: Web (SvelteKit) — VPN-only
> **Upstream**: A1 Schema (`workspaces`, `subscription_events`, `invoices`, `payment_methods`), A3 API (`AdminBillingService/GetBillingSummary`, `AdminAnalyticsService/GetMRRTrend`, `AdminService/OverridePlan`, `AdminConfigService/GetPricing`), B5 RBAC §3

---

## 1. Purpose & Context

Manage subscription plans, view MRR trends, handle billing issues, and monitor user plan distribution. Includes plan configuration and credit allocation management.

### User Story
> As a business admin, I want to track subscription revenue, manage plans, and handle billing issues.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 💳 Subscriptions & Billing                   [Period: 30d ▾]       │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ MRR KPIs ─────────────────────────────────────────────────────┐  │
│ │ 💰 MRR: 125.5M VND (+8.2%)  Subscribers: 234                  │  │
│ │ 📈 New: 45  🔄 Renewed: 180  ❌ Churned: 9 (3.8%)             │  │
│ │ 💎 ARPU: 536K VND  LTV: 6.4M VND                             │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Tabs: [📊 Overview] [📋 Plans] [⚠️ Issues (3)] [🔧 Config]       │
│                                                                      │
│ ── Plans Tab ──                                                      │
│ ┌─ Plan Row ─────────────────────────────────────────────────────┐  │
│ │ 🆓 Free     │ Users: 1,234 │ MRR: 0        │ [Edit]          │  │
│ │ ⭐ Starter  │ Users: 145   │ MRR: 43.5M    │ [Edit]          │  │
│ │ 💎 Pro      │ Users: 78    │ MRR: 62.4M    │ [Edit]          │  │
│ │ 🏢 Business │ Users: 11    │ MRR: 19.6M    │ [Edit]          │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ── Issues Tab ──                                                     │
│ ┌─ Issue Row ────────────────────────────────────────────────────┐  │
│ │ ⚠️ Payment failed: quanm@gmail.com · Pro · 3 retry attempts  │  │
│ │ Created: 2d ago · [📧 Notify] [🔄 Retry] [⏸ Grace period]    │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3-5. Component & Actions

```
SubscriptionManagementPage
├── AdminShell
├── MRRKPIs (MRR, subscriber count, new/renewed/churned, ARPU, LTV)
├── TabContainer
│   ├── OverviewTab (MRR chart, plan distribution pie)
│   ├── PlansTab
│   │   └── PlanRow[] (plan name, users, MRR, edit)
│   ├── IssuesTab
│   │   └── IssueRow[] (failed payment, expired, grace period actions)
│   └── ConfigTab (credit allocation, plan features, pricing)
```

| # | Action | Trigger | Result | Permission |
|---|---|---|---|---|
| 1 | Edit plan | "Edit" on plan | Plan config modal | `admin:plan:override` |
| 2 | Retry payment | "🔄 Retry" | Payment retried | `admin:billing:read` |
| 3 | Grant grace period | "⏸ Grace" | Account extended | `admin:plan:override` |
| 4 | Notify user | "📧 Notify" | Email sent | `admin:billing:read` |

### Technical Notes
- Route: `src/routes/admin/subscriptions/+page.svelte`
- MRR is derived from `subscription_events` + invoice state, not a standalone `subscriptions` table
- Plan configuration comes from `AdminConfigService/GetPricing`
- Manual plan change flows route to A037 Subscription Override

### Related Screens: [A001] Admin Dashboard, [A004] Workspace List, [A037] Subscription Override

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-04-06 | 2.0 | Canonicalized schema/API bindings, removed generic data-binding placeholders, and linked write-path overrides to A037. |
| 2026-03-28 | 1.0 | Initial specification |

---

## 2. Preconditions / Postconditions
### Preconditions
- Admin user with appropriate S26 role
- VPN connection active
### Postconditions
- All actions logged in audit trail
- State changes reflected in real-time

---

## 4. Component Hierarchy
```text
SubscriptionBillingManagementPage
├── AdminShell
├── PageHeader
│   ├── PeriodFilter
│   └── ExportButton
├── KPIBar
│   ├── MRRCard
│   ├── SubscriberCard
│   ├── ChurnCard
│   └── ARPUCard
├── TabContainer
│   ├── OverviewTab
│   ├── PlansTab
│   ├── IssuesTab
│   └── ConfigTab
└── OverrideShortcutPanel
```

---

## 5. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Billing summary | `workspaces`, `subscription_events`, `invoices` | `AdminBillingService/GetBillingSummary` | KPI cards + issue counts | No cache |
| MRR trend | `subscription_events` aggregation | `AdminAnalyticsService/GetMRRTrend` | Time-series chart | 5m TTL |
| Plan distribution | `workspaces.subscription_tier` | `AdminBillingService/GetBillingSummary` | Plan cards + counts | 5m TTL |
| Billing issues | Failed invoices + expiring grace periods | `AdminBillingService/GetBillingSummary` | Priority row list | No cache |
| Pricing config | Tier configuration registry | `AdminConfigService/GetPricing` | Editable plan config | 30m TTL |

---
## Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được dữ liệu. [Thử lại]" | Retry |
| Not found | 404 | "Không tìm thấy" → navigate back | Back |
| Permission denied | 403 | "Không có quyền truy cập" | Contact admin |

---
## Accessibility

| Element | Requirement |
|---|---|
| Interactive elements | Minimum 48×48dp tap targets |
| Icons with meaning | `Semantics(label:)` descriptive text |
| Status indicators | Color not sole indicator; text/icon also present |
| Dynamic content | `Semantics(liveRegion: true)` for updates |
| Contrast | 4.5:1 minimum ratio |

---
## Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + shimmer placeholders |
| Primary data | 200-500ms | Content populates progressively |
| User action | <1s | Inline spinner → result feedback |

---
## Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "1.200.000đ")
- Date: DD/MM/YYYY
- Numbers: dot separator (1.234)
- Relative time: "2 giờ trước", "1 ngày trước"
- Tone: Friendly, action-oriented

---
## Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Primary actions, CTAs |
| `--color-success` | Positive states, confirmations |
| `--color-warning` | Warning indicators |
| `--color-danger` | Error states, destructive actions |
| `--color-surface-elevated` | Cards, elevated surfaces |

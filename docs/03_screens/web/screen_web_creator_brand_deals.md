# Screen: Web — Brand Deal Manager

> **Screen ID**: W095
> **Module**: S16 — Creator Pro Tools
> **Route**: `/creator-pro/deals`
> **Platform**: Web (SvelteKit)
> **Upstream**: S16 Creator Pro Spec, A1 Schema (brand_deals, creator_deliverables, deal_payments), B5 RBAC §2.7

---

## 1. Purpose & Context

Brand deal tracking with full pipeline — manage partnerships from negotiation through delivery to payment. Includes deliverable checklists, payment tracking, and deal performance analytics.

### User Goals
- Track all brand deals in one pipeline view
- Manage deliverable checklists per deal
- Track payment status (pending, received, overdue)
- Compare deal value against rate card

### Business Goals
- Centralize partnership revenue tracking
- Ensure deliverable compliance (on-time delivery)
- Track deal lifetime value and conversion from inquiry
- Feed payment data into revenue reports

### Entry Points
- Creator Pro Dashboard (W088): "🤝 Partnerships" tab
- Sponsor Inquiries (W090): "Accept" → creates new deal
- Sidebar: Creator Pro → "🤝 Deals"

### Exit Points
- Click deal → Deal Detail
- "📊 Stats" → Content analytics for deal deliverables
- "+ Thêm deal" → Manual deal creation

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Creator Pro   🤝 Brand Deals          [+ Thêm deal] [Filter ▾]  │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Pipeline Overview ───────────────────────────────────────────┐   │
│ │ [💬 Negotiating (2)] → [🤝 Agreed (1)] → [🎬 In-progress (1)]│  │
│ │ → [📤 Delivered (3)] → [💰 Paid (5)] → [✅ Completed (8)]   │   │
│ │                                                                  │   │
│ │ Total pipeline value: 42M VND · This month: 12.5M VND        │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Deal Card ───────────────────────────────────────────────────┐   │
│ │ 🤝 Brand ABC — "Summer skincare campaign"   [🎬 In-progress] │   │
│ │ Value: 5M VND · Deadline: 30/3/2026 (2 days left)            │   │
│ │                                                                  │   │
│ │ Deliverables: 1/3 completed                                    │   │
│ │ ☑ TikTok video 60s (done 25/3) · 👁 24K views · [📊]        │   │
│ │ ☐ Instagram Reel (due 28/3 — ⚠️ tomorrow!)                   │   │
│ │ ☐ 2× Story mentions (due 30/3)                                │   │
│ │                                                                  │   │
│ │ Payment: 50% advance received (2.5M) · 50% on delivery       │   │
│ │ Rate card comparison: Deal at 92% of your rate card rate      │   │
│ │                                                                  │   │
│ │ [→ Detail] [💬 Contact brand] [📊 Stats] [⋮]                │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Deal Card ───────────────────────────────────────────────────┐   │
│ │ 🤝 Brand XYZ — Sponsorship package         [💬 Negotiating]  │   │
│ │ Offer: 5M VND for 3 videos                                    │   │
│ │ Counter sent: 6.5M VND (+30%) — awaiting response             │   │
│ │ Rate card comparison: Offer at 78% of rate card ⚠️           │   │
│ │ [✅ Accept original] [↩️ Counter again] [❌ Decline]          │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Deal Card ───────────────────────────────────────────────────┐   │
│ │ 🤝 Beauty Co — "Product review"              [💰 Paid]       │   │
│ │ Value: 3M VND · Completed: 15/3                               │   │
│ │ Payment: ✅ Full amount received (18/3)                       │   │
│ │ Performance: 45K views · 15 orders attributed                 │   │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Deal Status Pipeline

> **Canonical lifecycle**: M16 (affiliate_network.md) RULE-M16-009 governs. 6 primary states + cancelled terminal.

```
💬 Negotiating → 🤝 Agreed → 🎬 In-progress → 📤 Delivered → 💰 Paid → ✅ Completed
     │                            │                  │
     └→ ❌ Cancelled              └→ ❌ Cancelled     └→ ⚠️ Disputed → 💰 Paid
                                                                    └→ ❌ Cancelled
```

| Status | Description | Actions Available |
|---|---|---|
| 💬 Negotiating | Discussing terms | Accept, Counter, Decline, Cancel |
| 🤝 Agreed | Terms accepted, not started | Start, Cancel |
| 🎬 In-progress | Creating deliverables | Mark delivered, Update progress, Cancel |
| 📤 Delivered | All deliverables sent | Confirm payment, Open dispute |
| 💰 Paid | Payment received | Complete |
| ✅ Completed | Deal finished | View stats |
| ❌ Cancelled | Deal cancelled (terminal) | Archive |
| ⚠️ Disputed | Payment/deliverable dispute (sub-state of delivered) | Resolve → Paid, Escalate → Cancelled |

---

## 5. Component Hierarchy

```
BrandDealManagerPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Creator Pro")
│   ├── PageTitle ("🤝 Brand Deals")
│   ├── AddDealButton
│   └── FilterButton
├── PipelineOverview
│   ├── StageCounts (clickable, filters list)
│   └── TotalPipelineValue + MonthlyValue
├── DealList
│   └── DealCard[]
│       ├── BrandName + CampaignTitle + StatusBadge
│       ├── Value + Deadline (with urgency indicator)
│       ├── DeliverableChecklist
│       │   └── DeliverableItem[]
│       │       ├── Checkbox + Description
│       │       ├── DueDate + UrgencyWarning
│       │       └── StatsButton (if completed)
│       ├── PaymentStatus (advance + balance)
│       ├── RateCardComparison (% of rate card)
│       └── ActionBar (context-dependent per status)
├── AddDealModal
│   ├── BrandNameInput
│   ├── CampaignNameInput
│   ├── ValueInput (VND)
│   ├── PaymentTermsSelector
│   ├── DeadlinePicker
│   ├── DeliverableBuilder (add deliverable items)
│   └── CreateButton
```

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Pipeline shimmer + card skeletons |
| LOADED | Data received | Pipeline + deal cards |
| EMPTY | No deals | "Chưa có brand deal nào. Nhận inquiry từ brands qua Media Kit hoặc thêm deal thủ công. [+ Thêm deal]" |
| DELIVERABLE_OVERDUE | Deliverable past due | Red: "⚠️ {deliverable} quá hạn {days} ngày!" |
| PAYMENT_OVERDUE | Payment >30 days past delivery | Red: "💰 Payment chưa nhận sau 30 ngày. [→ Follow up]" |
| ERROR | API failed | Error with retry |

---

## 7. Tier Gating

| Feature | Free | Starter | Pro | Business |
|---|---|---|---|---|
| View deals | ❌ | ✅ (3 max) | ✅ (unlimited) | ✅ |
| Add deals | ❌ | ✅ | ✅ | ✅ |
| Rate card comparison | ❌ | ❌ | ✅ | ✅ |
| Payment tracking | ❌ | ❌ | ✅ | ✅ |
| Performance analytics | ❌ | ❌ | ✅ | ✅ |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached deal data | Retry online |
| Deal create fail | API error on create | Toast: "Không tạo được deal. [Thử lại]" | Retry |
| Status change fail | Pipeline transition blocked | Toast: "{reason}. [Thử lại]" | Fix pre-condition |
| Payment dispute fail | Dispute API error | Toast: "Không gửi được dispute." | Retry |
| Rate card compare fail | Rate card not configured | Inline: "⚠️ Chưa cấu hình Rate Card. [→ Tạo Rate Card]" | Navigate |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Pipeline stages | `role="tablist"`, each stage `role="tab"`, `aria-selected` |
| Deal cards | `role="article"`, `aria-label="{brand} — {campaign}, {status}"` |
| Deliverable checklist | `role="list"`, `aria-label="Deliverables: {done} of {total}"` |
| Overdue badges | `role="alert"`, `aria-label="Overdue: {deliverable} by {days} days"` |
| Rate comparison | `aria-label="Deal at {pct}% of your rate card rate"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Pipeline shimmer + card skeletons |
| Pipeline stats | 100-300ms | Stage counts populate |
| Deal cards | 300-600ms | Cards stagger with status sort |
| Deliverables | 400-700ms | Checklists populate per card |
| Rate comparison | 500-800ms | Rate card data loads async |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `deals.viewed` | Page load | `total_deals`, `pipeline_value`, `active_count` |
| `deals.deal_created` | "+ Thêm deal" confirmed | `brand`, `value`, `deliverable_count` |
| `deals.status_changed` | Pipeline stage transition | `deal_id`, `old_status`, `new_status` |
| `deals.deal_accepted` | "✅ Accept original" | `deal_id`, `value`, `rate_card_pct` |
| `deals.counter_sent` | "↩️ Counter again" | `deal_id`, `original_value`, `counter_value` |
| `deals.deliverable_completed` | Deliverable marked done | `deal_id`, `deliverable_type` |
| `deals.payment_received` | Payment marked received | `deal_id`, `amount` |
| `deals.deal_declined` | "❌ Decline" | `deal_id`, `reason` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/creator-pro/deals/+page.svelte`
- **Server load**: `+page.server.ts` → `BrandDealService/ListDeals(workspace_id, filters)` + `BrandDealService/GetPipelineStats`
- **Pipeline**: Client-side filtering by status tab; stage counts from server aggregation
- **Rate card**: Async load `RateCardService/CompareScope(deliverables)` per deal
- **Status transitions**: `BrandDealService/UpdateStatus(deal_id, new_status)` → optimistic UI
- **Deliverables**: Inline `BrandDealService/ToggleDeliverable(id, completed)` with proof upload prompt
- **Payment tracking**: `BrandDealService/UpdatePayment(deal_id, status, amount)` → feeds into Finance module

---

## 13. Localization Notes

- Pipeline: "💬 Đang thương lượng", "🤝 Đã thỏa thuận", "🎬 Đang thực hiện", "📤 Đã giao", "💰 Đã thanh toán", "✅ Hoàn thành"
- Values: VND "5.000.000đ" or abbreviated "5M VND"
- Deadlines: "còn 2 ngày", "⚠️ quá hạn 3 ngày"
- Rate: "Deal ở mức 92% rate card của bạn"
- Tone: Professional, partnership-focused

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-deal-negotiating` | 💬 Negotiating stage |
| `--color-deal-agreed` | 🤝 Agreed stage |
| `--color-deal-active` | 🎬 In-progress stage |
| `--color-deal-delivered` | 📤 Delivered stage |
| `--color-deal-paid` | 💰 Paid stage |
| `--color-deal-completed` | ✅ Completed stage |
| `--color-danger` | ❌ Cancelled, overdue |
| `--color-surface-elevated` | Deal cards |
| `--font-metric` | Values, dates (tabular-nums) |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W088] Creator Pro Dashboard | Parent |
| [W090] Sponsor Inquiries | Inquiry → Deal conversion |
| [W093] Rate Card Builder | Rate comparison |
| [M046] Mobile Brand Deals | Mobile equivalent |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (deal create, dispute), pipeline/card a11y, 8 analytics, SvelteKit impl, localization, 9 design tokens (pipeline-specific). | System |
| 2026-03-28 | 1.0 | Initial specification | System |

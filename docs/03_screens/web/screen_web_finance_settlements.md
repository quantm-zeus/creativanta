# Screen: Web — Settlement Tracker

> **Screen ID**: W086
> **Module**: M19 — Operating Ledger (Settlements)
> **Route**: `/finance/settlements`
> **Platform**: Web (SvelteKit)
> **Upstream**: PRD §33.3 Settlement Tracking, A1 Schema (settlements, settlement_items, orders, bank_transactions), B5 RBAC §2.8

---

## 1. Purpose & Context

Track platform payouts/settlements — match settlements to orders, verify bank deposit references, and resolve amount mismatches. Settlements are the "proof of payment" from platforms: they confirm how much money was actually transferred to the creator's bank account.

### User Goals
- See all settlements from all platforms with their match status
- Quickly verify that settlement amounts match expected revenue
- Track when payouts hit the bank account
- Identify and resolve settlement mismatches

### Business Goals
- Ensure every settlement is accounted for in the operating ledger
- Surface discrepancies between expected and actual payouts
- Feed reconciled settlements into Proof Browser as "Official" evidence
- Track average settlement delay per platform

### Entry Points
- Finance Dashboard (W081): "💳 Settlements" card
- Reconciliation Center (W084): settlement reference links
- Sidebar: Finance → "💳 Settlements"
- Notification: "New settlement received from TikTok"

### Exit Points
- "🔍 View orders" → Drawer with matched orders
- "🔧 Resolve" → Reconciliation Center (W084)
- "📋 Proof bundle" → Proof Browser (W085)
- "📥 Export" → CSV/PDF download

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `profit:read` permission (Owner, Admin)
- Platform commerce connections active (settlements come from platform APIs)

### Postconditions
- Matched settlements update proof coverage in Proof Browser
- Flagged disputes create dispute records

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Finance   💳 Settlements                [Platform ▾] [Status ▾]  │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ─────────────────────────────────────────────────┐   │
│ │ 💰 Pending payout: 3,200,000 VND · Matched: 85%              │   │
│ │ 📅 Next expected: 30/3 (TikTok) · Avg delay: 3.2 days       │   │
│ │ This month: 42 settlements · 38,500,000 VND                  │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Filter: [Platform ▾] [Status ▾] [Period ▾]                         │
│                                                                      │
│ ┌─ Settlement Row ──────────────────────────────────────────────┐   │
│ │ 💳 #S-042 · 🎵 TikTok Shop · 2,500,000 VND   [✅ Matched]  │   │
│ │ Settlement date: 25/3 · Payout date: 27/3 (2d delay)         │   │
│ │ Orders: 18/18 matched · Confidence: 100%                      │   │
│ │ Bank ref: VCB-2026-0342 · Source: [🟢 Official]              │   │
│ │ [🔍 View orders] [📋 Proof bundle] [📥 Export]               │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Settlement Row ──────────────────────────────────────────────┐   │
│ │ 💳 #S-041 · 🛍 Shopee · 1,800,000 VND        [⚠️ Partial]  │   │
│ │ Settlement date: 22/3 · Payout: ⏳ Pending                    │   │
│ │ Orders: 20/22 matched · Unmatched: 2 orders (180,000 VND)    │   │
│ │ ⚠️ Difference: Platform -45K vs our calculation               │   │
│ │ Source: [🟡 Imported CSV]                                      │   │
│ │ [🔍 View orders] [🔧 Resolve] [📎 Flag dispute]              │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Settlement Row ──────────────────────────────────────────────┐   │
│ │ 💳 #S-040 · 🎵 TikTok Shop · 3,200,000 VND   [⏳ Pending]  │   │
│ │ Settlement date: 28/3 (expected today) · Payout: ⏳ Pending   │   │
│ │ Source: [🟡 Estimated from orders]                             │   │
│ │ [—]                                                            │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Pagination: [← Trước] Page 1/2 [Tiếp →]                           │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
SettlementTrackerPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Finance")
│   ├── PageTitle ("💳 Settlements")
│   ├── PlatformFilter
│   └── StatusFilter
├── SummaryBar
│   ├── PendingPayoutAmount
│   ├── MatchRate
│   ├── NextExpectedSettlement
│   ├── AvgPayoutDelay
│   └── MonthTotal (count + amount)
├── FilterBar
│   ├── PlatformFilter (TikTok, Shopee, Lazada, All)
│   ├── StatusFilter (Matched, Partial, Pending, Disputed, All)
│   └── PeriodFilter
├── SettlementList
│   └── SettlementRow[]
│       ├── SettlementNumber + PlatformBadge
│       ├── TotalAmount
│       ├── StatusBadge (✅ Matched / ⚠️ Partial / ⏳ Pending / ❌ Disputed)
│       ├── DateInfo (settlement + payout + delay)
│       ├── MatchInfo (matched/total orders + unmatched count)
│       ├── DifferenceWarning (if amount mismatch)
│       ├── BankRef (if available)
│       ├── SourceBadge (S009)
│       └── ActionBar
│           ├── ViewOrdersButton ("🔍 View orders" → drawer)
│           ├── ProofBundleButton ("📋 Proof bundle" → W085)
│           ├── ResolveButton ("🔧 Resolve" → W084)
│           ├── FlagButton ("📎 Flag dispute")
│           └── ExportButton ("📥 Export")
├── Pagination
└── OrdersDrawer (opens on "View orders")
    ├── OrderMatchTable
    │   └── OrderRow[] (order_id, amount, match_status)
    ├── UnmatchedSection (if any)
    └── CloseButton
```

---

## 5. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | View orders | "🔍" | — | OrdersDrawer opens | `profit:read` |
| 2 | Resolve mismatch | "🔧 Resolve" | — | → Reconciliation Center (W084) | `profit:detailed_read` |
| 3 | Flag dispute | "📎 Flag" | `ReconciliationService/FlagDispute(settlement_id)` | Dispute created, status → Disputed | `profit:detailed_read` |
| 4 | View proof | "📋 Proof" | — | → Proof Browser (W085) with settlement | `profit:read` |
| 5 | Export | "📥 Export" | Client-side CSV | Settlement data download | `profit:read` |
| 6 | Filter/sort | Filter controls | Refetch | List updates | `profit:read` |

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Summary shimmer + row skeletons |
| LOADED | Data received | Settlement list |
| EMPTY | No settlements | "Chưa có settlement nào. Settlements từ platforms sẽ tự động xuất hiện khi có đơn hàng." |
| ALL_MATCHED | All settlements matched | "✅ Tất cả settlements đã khớp!" |
| PAYOUT_OVERDUE | Expected settlement > 3 days late | "⚠️ Settlement #{id} từ {platform} trễ {days} ngày. [📎 Kiểm tra với nền tảng]" |
| ERROR | API failed | Error with retry |

---

## 7. Permissions

| Feature | Owner | Admin | Manager+ |
|---|---|---|---|
| View settlements | ✅ | ✅ | ❌ |
| Resolve mismatches | ✅ | ✅ | ❌ |
| Flag disputes | ✅ | ✅ | ❌ |
| Export | ✅ | ✅ | ❌ |

---
## 8. Edge Cases

| Edge Case | Handling |
|---|---|
| Settlement overdue (>3 days late) | Red row: "⚠️ Trễ {days} ngày. [📎 Kiểm tra với nền tảng]" |
| Zero settlement (all refunded) | Show with "Tất cả đơn đã hoàn tiền" label |
| Bank reference missing | Badge: "🟡 Chưa xác nhận ngân hàng" |
| Platform removed/disconnected | Historic settlements show, new ones stop: "⚫ Đã ngắt kết nối" |
| Estimated settlement (from pending orders) | Lighter card: "🟡 Ước tính từ đơn hàng đang chờ" |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" — no cached data | Retry online |
| Flag dispute fail | API error | Toast: "Không gửi được. [Thử lại]" | Retry |
| Orders drawer fail | Matched orders fetch error | "Không tải được đơn. [Thử lại]" | Retry |
| Export fail | CSV generation error | Toast: "Không xuất được." | Retry |
| Settlement sync error | Platform API error | "⚠️ {platform} chưa đồng bộ settlement mới" | Wait / reconnect |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| Summary bar | `role="status"`, `aria-label="Pending: {amount}đ, Matched: {pct}%"` |
| Settlement rows | `role="list"`, each `aria-label="Settlement #{id}: {amount}đ, {status}"` |
| Status badges | `aria-label` with full text: "Khớp", "Một phần", "Chưa xét", "Tranh chấp" |
| Orders drawer | `role="dialog"`, `aria-modal="true"`, focus trap |
| Filter controls | `aria-label` on each filter: "Lọc theo nền tảng", "Lọc theo trạng thái" |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Summary shimmer + row skeletons |
| Summary bar | 200-400ms | Counters populate |
| Settlement rows | 400-800ms | Rows stagger in |
| Orders drawer | 0ms | Instant overlay |
| Flag action | 500-1500ms | Button spinner → status update |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `finance_settlements.viewed` | Page load | `period`, `total_count`, `pending_amount`, `match_rate` |
| `finance_settlements.filtered` | Filter applied | `filter_type`, `filter_value` |
| `finance_settlements.orders_viewed` | "View orders" | `settlement_id`, `order_count` |
| `finance_settlements.dispute_flagged` | "Flag dispute" | `settlement_id`, `platform` |
| `finance_settlements.resolved` | "Resolve" navigated | `settlement_id` |
| `finance_settlements.proof_viewed` | "Proof bundle" | `settlement_id` |
| `finance_settlements.exported` | Export | `format` |
| `finance_settlements.overdue_shown` | Overdue settlement visible | `settlement_id`, `days_late` |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/finance/settlements/+page.svelte`
- **Server load**: `+page.server.ts` → `SettlementService/List(period, filters)` from PostgreSQL
- **Orders drawer**: Lazy-loaded `OrderMatchTable` component, fetched on demand
- **Real-time**: SSE for new settlement notifications via `SettlementService/stream`
- **Polling**: Summary stats refreshed every 15min
- **Flag dispute**: SvelteKit form action → creates `dispute` record, notifies assignee
- **Pagination**: Server-side, 20 per page
- **No localStorage**: Financial data never cached client-side

---

## 14. Localization Notes

- Currency: VND — "2.500.000đ"
- Status: "✅ Khớp", "⚠️ Một phần", "⏳ Chưa xét", "❌ Tranh chấp"
- Delay: "2 ngày trễ" / "đúng hạn"
- Bank ref: "Ref: VCB-2026-0342"
- Source: "🟢 Chính thức", "🟡 Import CSV", "🟡 Ước tính"
- Tone: Formal, tracking-oriented

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-settlement-matched` | ✅ Fully matched (green) |
| `--color-settlement-partial` | ⚠️ Partial match (amber) |
| `--color-settlement-pending` | ⏳ Pending payout (gray) |
| `--color-settlement-disputed` | ❌ Disputed (red) |
| `--color-settlement-overdue` | Overdue highlight (red bg) |
| `--color-trust-official` | 🟢 Official source |
| `--color-trust-imported` | 🟡 Imported source |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W081] Profit Dashboard | Financial overview |
| [W084] Reconciliation Center | Match and resolve settlements |
| [W085] Proof Browser | Settlements as proof evidence |
| [W063] Order Detail | Individual order data |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (overdue, zero settlement), 5 errors, row/drawer a11y, 8 analytics, SvelteKit impl (SSE, pagination), localization, 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

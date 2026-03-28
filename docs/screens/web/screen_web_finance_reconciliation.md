# Screen: Web — Reconciliation Center

> **Screen ID**: W084
> **Module**: M19 — Operating Ledger (Reconciliation)
> **Route**: `/finance/reconciliation`
> **Platform**: Web (SvelteKit)
> **Upstream**: PRD §33.4 Reconciliation Engine, Pack 06 §Finance, A1 Schema (reconciliation_batches, reconciliation_items, settlements, orders), B5 RBAC §2.8

---
## 1. Purpose & Context

Reconcile financial data across platforms — match orders ↔ settlements ↔ payouts automatically, then surface anomalies and conflicts for human review. This is the "trust audit" layer: every VND of revenue must trace to a settlement, and every settlement must trace to real orders.

### User Goals
- Verify that platform settlements match Creativanta order records
- Identify and resolve discrepancies before they affect profit calculation
- Approve fully-matched settlements quickly with one-click
- Flag disputes for follow-up with platform support

### Business Goals
- Ensure operating ledger accuracy (PRD §33.4)
- Surface platform fee discrepancies that silently reduce profit
- Build trust in financial numbers by showing reconciliation status
- Feed Proof Browser (W085) with verified evidence items

### Entry Points
- Finance Dashboard (W081): "🔍 Reconciliation" card or "85% reconciled" badge
- Proof Browser (W085): "→ Fix gaps" link
- Sidebar: Finance → "🔍 Reconciliation"
- Notification: "New settlement from TikTok — 3 orders unmatched"

### Exit Points
- Click order → Order Detail (W063)
- Click settlement → Settlement Tracker (W086)
- "📋 Proof bundle" → Proof Browser (W085)
- "👤 Assign" → Team member for resolution

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `profit:read` permission (Owner, Admin)
- Platform settlements received from connected commerce accounts
- Auto-matching engine has run (background job, triggered on settlement receipt)

### Postconditions
- Approved reconciliations: settlement items gain `reconciled=true` status → feed proof chain
- Flagged disputes: create `dispute` record linked to settlement and orders
- All actions are audited with timestamp, user, and decision reason

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Finance   🔍 Reconciliation Center            [Period: Mar ▾]    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Reconciliation Summary ──────────────────────────────────────┐   │
│ │ Coverage: 85% [████████████████░░░]                            │   │
│ │ ✅ 42 settlements reconciled (38.5M VND)                      │   │
│ │ ⏳ 5 pending review (3.2M VND)                                │   │
│ │ ❌ 2 conflicts (465K VND difference)                           │   │
│ │ Auto-match success rate: 92%                                   │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Tabs: [⏳ Pending (5)] [❌ Conflicts (2)] [✅ Reconciled (42)]     │
│       [📋 All]                                                       │
│                                                                      │
│ ── ⏳ Pending Review ────────────────────────────────────────────     │
│ ┌─ Settlement Batch ────────────────────────────────────────────┐   │
│ │ 💳 #S-042 · 🎵 TikTok Shop · 2,500,000 VND   [⏳ Pending]   │   │
│ │ Settlement date: 25/3 · Received: 26/3                        │   │
│ │                                                                  │   │
│ │ Auto-match result:                                               │   │
│ │ ✅ 15 orders matched (2,050,000 VND)                            │   │
│ │ ❓ 3 orders unmatched (450,000 VND)                             │   │
│ │   ├ #TK-5601: 150K — No matching order in system               │   │
│ │   ├ #TK-5602: 200K — Amount differs (our: 220K, platform: 200K)│  │
│ │   └ #TK-5603: 100K — Order cancelled but settlement includes    │   │
│ │ Confidence: [🟡 83% — 3 items need review]                     │   │
│ │                                                                  │   │
│ │ [🔍 Review all matches] [✅ Approve matched] [📋 Flag all]    │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Settlement Batch (auto-matched 100%) ────────────────────────┐   │
│ │ 💳 #S-041 · 🛍 Shopee · 1,800,000 VND        [⏳ Pending]    │   │
│ │ Auto-match: ✅ 22/22 orders matched · 100% confidence          │   │
│ │ [✅ One-click approve]                                         │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── ❌ Conflicts ──────────────────────────────────────────────────    │
│ ┌─ Conflict Card ──────────────────────────────────────────────┐    │
│ │ ❌ Order #TK-5678: Amount mismatch                            │    │
│ │ Platform says: 299,000 VND · Our calculation: 319,000 VND     │    │
│ │ Difference: 20,000 VND · Likely cause: platform fee not captured│   │
│ │ Settlement: #S-038 · Status: [❌ Unresolved]                  │    │
│ │ Age: 5 days unresolved                                         │    │
│ │                                                                  │    │
│ │ [🔧 Resolve] [👤 Assign to team] [📋 Flag to platform support]│   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Pagination: [← Trước] Page 1/1 [Tiếp →]                           │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
ReconciliationCenterPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Finance")
│   ├── PageTitle ("🔍 Reconciliation Center")
│   └── PeriodSelector (month-based)
├── ReconciliationSummary
│   ├── CoverageBar (percentage + progress)
│   ├── ReconciledCount + Amount
│   ├── PendingCount + Amount
│   ├── ConflictCount + DifferenceAmount
│   └── AutoMatchRate
├── StatusTabs (Pending, Conflicts, Reconciled, All)
├── SettlementBatchList
│   └── SettlementBatch[]
│       ├── BatchHeader
│       │   ├── SettlementNumber
│       │   ├── PlatformBadge
│       │   ├── TotalAmount
│       │   └── StatusBadge
│       ├── DateInfo (settlement date, received date)
│       ├── MatchResult
│       │   ├── MatchedCount + Amount (green)
│       │   ├── UnmatchedItems[] (expandable)
│       │   │   ├── OrderRef
│       │   │   ├── Amount
│       │   │   └── UnmatchReason
│       │   └── ConfidenceBadge (S009 derived)
│       └── ActionBar
│           ├── ReviewButton ("🔍 Review all matches" → drawer)
│           ├── ApproveMatchedButton ("✅ Approve matched")
│           ├── OneClickApproveButton (for 100% matched)
│           └── FlagButton ("📋 Flag all")
├── ConflictList
│   └── ConflictCard[]
│       ├── OrderRef
│       ├── AmountComparison (platform vs our calculation)
│       ├── Difference + LikelyCause
│       ├── SettlementRef
│       ├── Age (days unresolved)
│       └── ActionBar
│           ├── ResolveButton ("🔧 Resolve" → resolve drawer)
│           ├── AssignButton ("👤 Assign")
│           └── FlagPlatformButton ("📋 Flag to platform")
├── Pagination
├── ReviewDrawer (opens on "Review all matches")
│   ├── OrderMatchTable (order_id, our_amount, platform_amount, match_status)
│   ├── FeeBreakdown (per order)
│   └── BulkApproveButton
└── ResolveDrawer (opens on "Resolve")
    ├── ConflictDetails
    ├── ResolutionType (Accept platform amount / Accept our amount / Split difference / Manual)
    ├── ExplanationInput (required, min 10 chars)
    └── SubmitButton
```

---
## 5. Displayed Data

| Field | Source | Format | Source Class |
|---|---|---|---|
| Settlement number | `settlements.settlement_id` | "#S-042" | Official |
| Platform | `settlements.platform` | Icon + name | — |
| Total amount | `settlements.total_amount` | VND | Official |
| Settlement date | `settlements.settlement_date` | "25/3" | Official |
| Matched orders | `reconciliation_items WHERE status=matched` count | "15" | Computed |
| Unmatched orders | `reconciliation_items WHERE status=unmatched` | List | Computed |
| Confidence | Computed: matched_amount / total_amount × 100 | "83%" | Computed |
| Conflicts | `reconciliation_items WHERE status=conflict` | Card list | Computed |
| Auto-match rate | Aggregate across all settlements | "92%" | Computed |
| Difference | ABS(our_amount - platform_amount) | VND | Computed |
| Age | NOW() - conflict.created_at | "5 days" | Computed |

---
## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Review matches | "🔍 Review" | — | ReviewDrawer opens with order-level detail | `profit:read` |
| 2 | Approve matched | "✅ Approve" → confirm | `ReconciliationService/ApproveMatched(batch_id)` | Matched items → reconciled, feed proof chain | `profit:manage` |
| 3 | One-click approve | "✅ One-click" | `ReconciliationService/ApproveAll(batch_id)` | Entire batch reconciled (100% match only) | `profit:manage` |
| 4 | Resolve conflict | "🔧 Resolve" → drawer | `ReconciliationService/Resolve(item_id, resolution)` | Conflict resolved with explanation | `profit:manage` |
| 5 | Assign to team | "👤 Assign" | `ReconciliationService/Assign(item_id, user_id)` | Team member notified | `profit:manage` |
| 6 | Flag to platform | "📋 Flag" | `ReconciliationService/FlagDispute(item_id)` | Dispute record created | `profit:manage` |
| 7 | Change period | Period selector | Refetch | Data for selected month | `profit:read` |
| 8 | Switch tab | Tab click | Client-side filter | List filters | `profit:read` |

---
## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Summary shimmer + batch skeletons |
| LOADED | Data received | Reconciliation batches with match results |
| EMPTY | No settlements for period | "Chưa có settlement nào trong tháng này. Settlement từ platforms sẽ tự động xuất hiện." |
| ALL_RECONCILED | 100% reconciled | Green celebration: "✅ Tất cả settlement đã được đối soát! Coverage: 100%" |
| CONFLICTS_AGING | Conflicts > 7 days old | Red warning: "⚠️ {count} conflicts chưa xử lý > 7 ngày. Sẽ ảnh hưởng độ tin cậy lợi nhuận." |
| ERROR | API failed | Error with retry |
| RESOLVING | Resolve drawer open | Side panel with resolution form |

---
## 8. Permissions

| Feature | Owner | Admin | Manager+ |
|---|---|---|---|
| View reconciliation | ✅ | ✅ | ❌ |
| Approve settlements | ✅ | ✅ | ❌ |
| Resolve conflicts | ✅ | ✅ | ❌ |
| Assign to team | ✅ | ✅ | ❌ |
| Flag disputes | ✅ | ✅ | ❌ |

> Reconciliation is a sensitive financial function — restricted to Owner and Admin only.

---
## 9. Auto-matching Logic

The system automatically matches orders to settlements by:
1. **Order ID match**: Platform order ID in settlement ↔ our `orders.platform_order_id`
2. **Amount match**: Settlement line amount ↔ our `orders.total_amount` (±1% tolerance for rounding)
3. **Date match**: Settlement period covers order date

Unmatched reasons:
- **Missing order**: Platform settlement includes order not in our system
- **Amount mismatch**: Amounts differ beyond tolerance (usually undocumented fees)
- **Cancelled inclusion**: Platform settled a cancelled order
- **Date out of range**: Order date doesn't fall in settlement period

---
## 10. Edge Cases

| Edge Case | Handling |
|---|---|
| Settlement amount = 0 (all refunded) | Show with "All orders refunded" label, auto-reconcile |
| Multiple settlements for same period | Show each separately, aggregate in summary |
| Platform not providing settlement data | Show "⚫ {platform} chưa cung cấp settlement" with link to request |
| Conflict amount < 1,000 VND | Auto-accept with "Micro-difference auto-resolved" note |
| >100 unmatched orders in one batch | Paginate in ReviewDrawer, show summary stats |

---
## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" — no cached data (privacy) | Retry online |
| Approve fail | API error | Toast: "Không duyệt được. [Thử lại]" | Retry |
| Resolve conflict fail | Concurrent edit | Toast: "Conflict đã được cập nhật. Tải lại." | Reload |
| Settlement data corrupt | Parse error | "⚠️ Settlement #{id} có dữ liệu lỗi. Liên hệ nền tảng." | Manual fix |
| Auto-match timeout | Large batch | "Đang xử lý... ({count} orders)" spinner | Wait |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Coverage bar | `role="progressbar"`, `aria-valuenow`, `aria-label="Đối soát: {pct}%"` |
| Settlement batches | `role="list"`, each `aria-label="Settlement #{id}: {amount}đ, {status}"` |
| Status badges | `aria-label` with full text (not color-only): "Khớp", "Chưa xét", "Không khớp" |
| Review drawer | `role="dialog"`, `aria-modal="true"`, focus trap |
| Resolve form | Required fields with `aria-required="true"`, explanation min length indicator |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Summary shimmer + batch skeletons |
| Summary | 200-400ms | Coverage bar fills, counts populate |
| Settlement batches | 400-800ms | Cards stagger in |
| Review drawer | 0ms | Instant overlay |
| Approve action | 500-2000ms | Button spinner → success toast |
| Resolve action | 500-2000ms | Submit spinner → conflict resolved |

---

## 14. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `finance_reconciliation.viewed` | Page load | `period`, `coverage_pct`, `pending_count`, `conflict_count` |
| `finance_reconciliation.period_changed` | Period selector | `from_period`, `to_period` |
| `finance_reconciliation.batch_reviewed` | "Review all" opened | `batch_id`, `match_rate` |
| `finance_reconciliation.batch_approved` | Approve | `batch_id`, `matched_amount` |
| `finance_reconciliation.one_click_approved` | One-click approve | `batch_id`, `order_count` |
| `finance_reconciliation.conflict_resolved` | Resolve submitted | `item_id`, `resolution_type` |
| `finance_reconciliation.dispute_flagged` | Flag to platform | `item_id`, `platform` |
| `finance_reconciliation.assigned` | Assign to team | `item_id`, `assignee_id` |

---

## 15. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/finance/reconciliation/+page.svelte`
- **Server load**: `+page.server.ts` → `ReconciliationService/GetBatches(period)` from PostgreSQL
- **Approve**: SvelteKit form action with progressive enhancement; optimistic UI → revert on error
- **One-click approve**: Only enabled when `match_rate === 100%`
- **Resolve drawer**: Svelte `fly` transition, `use:inert` on background
- **SSE**: Settlement processing status via `ReconciliationService/stream`
- **Audit trail**: All actions (approve, resolve, flag) logged with `user_id`, `timestamp`, `reason`
- **No localStorage**: Financial data never cached client-side

---

## 16. Localization Notes

- Currency: VND — "2.500.000đ"
- Coverage: "85% đã đối soát"
- Status: "✅ Khớp", "⏳ Chưa xét", "❌ Không khớp", "🔧 Đã xử lý"
- Conflict age: "5 ngày chưa xử lý"
- Tolerance: "±1% dung sai làm tròn"
- Tone: Formal, precise (audit context)

---

## 17. Design Tokens

| Token | Usage |
|---|---|
| `--color-recon-matched` | ✅ Matched batch/item (green) |
| `--color-recon-pending` | ⏳ Pending review (amber) |
| `--color-recon-conflict` | ❌ Conflict (red) |
| `--color-recon-resolved` | 🔧 Resolved (blue) |
| `--color-recon-no-data` | ⚫ No settlement data (gray) |
| `--color-confidence-high` | 100% match confidence |
| `--color-confidence-medium` | 80-99% match confidence |
| `--color-confidence-low` | <80% match confidence |
| `--color-accent` | Primary CTAs (approve) |
| `--color-surface-elevated` | Cards |

---

## 18. Related Screens

| Screen | Relationship |
|---|---|
| [W081] Profit Dashboard | Financial overview |
| [W082] Revenue Detail | Revenue data being reconciled |
| [W085] Proof Browser | Reconciled items become proof |
| [W086] Settlement Tracker | Raw settlement data |
| [W063] Order Detail | Order-level investigation |

---

## 19. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (approve/resolve fail), batch/conflict a11y, 8 analytics, SvelteKit impl (SSE, optimistic approve), localization, 10 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

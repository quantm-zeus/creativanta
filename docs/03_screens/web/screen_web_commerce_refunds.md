# Screen: Web — Refund Management

> **Screen ID**: W073
> **Module**: M13 — Product Hub / Order Truth
> **Route**: `/orders/refunds`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06 §Commerce, Product Freeze §22, A1 Schema (refunds, orders, refund_evidence), B5 RBAC §2.7

---
## 1. Purpose & Context

Track and process refund requests across all connected platforms. Pipeline view with evidence review, customer purchase history, and accept/reject workflow. Refunds are critical for accurate Profit OS calculations — every refund adjusts the operating ledger.

### User Goals
- View all refund requests from all platforms in one pipeline
- Review evidence (photos, descriptions) before making decisions
- Track refund status and SLA compliance
- Understand refund impact on revenue and profit

### Business Goals
- Minimize refund processing time (target: < 48h)
- Track refund rate per product to identify quality issues
- Ensure every refund updates the operating ledger for accurate profit
- Maintain customer satisfaction through fair, timely processing

### Entry Points
- Sidebar: Commerce → "🔄 Hoàn tiền"
- Order Detail (W063): "🔄 Yêu cầu hoàn tiền" action
- Home Dashboard: refund alert "3 refund requests pending"
- Notification: "New refund request for Order #TK-1234"
- Copilot: "Có bao nhiêu yêu cầu hoàn tiền?" → navigate here

### Exit Points
- Click order reference → Order Detail (W063)
- Click buyer name → Contact in Inbox (W046)
- Click product → Product Detail (W061)

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `order:manage` permission (Owner, Admin, Manager)
- At least one order exists in the workspace

### Postconditions
- Accepted refunds: create `refund` record → update `orders.status` → adjust operating ledger
- Rejected refunds: create `refund` record with `status=rejected` + reason → notify buyer
- All refund decisions are audited with timestamp, user, and reason

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🔄 Quản lý hoàn tiền                                  [📤 Export]  │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ─────────────────────────────────────────────────┐   │
│ │ ⏳ 3 chờ xử lý · ✅ 8 đã duyệt (30d) · ❌ 2 từ chối (30d)  │   │
│ │ 💰 Refund total (30d): 4.5M VND · Refund rate: 2.3%          │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Tabs: [⏳ Chờ xử lý (3)] [✅ Đã duyệt (8)] [❌ Từ chối (2)]     │
│       [📋 Tất cả]                                                   │
│                                                                      │
│ Filter: [Platform ▾] [Reason ▾] [Period ▾]                         │
│                                                                      │
│ ┌─ Refund Request Card ──────────────────────────────────────────┐  │
│ │ 🔄 Order #TK-1234 · Nguyễn Văn A            [⏳ Chờ xử lý]   │  │
│ │ Requested: 1 ngày trước · SLA: ⏰ 23h remaining               │  │
│ │                                                                  │  │
│ │ 📦 Items: Serum VitC 30ml × 2                                  │  │
│ │ 💰 Amount: 598,000đ (full refund)                              │  │
│ │ 📝 Reason: Sản phẩm không như mô tả                            │  │
│ │ 📸 Evidence: [📷 3 photos] [View →]                             │  │
│ │ Platform: 🎵 TikTok Shop · Source: [🟢 Official]              │  │
│ │                                                                  │  │
│ │ 👤 Buyer history: 3 orders · 0 previous refunds · Value: ★★★★ │  │
│ │                                                                  │  │
│ │ [👁 Review Evidence] [✅ Duyệt hoàn tiền] [❌ Từ chối]        │  │
│ │ [💬 Liên hệ người mua] [📊 Order Detail]                      │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Refund Request Card ──────────────────────────────────────────┐  │
│ │ 🔄 Order #SP-5678 · Lê Hoa                  [⏳ Chờ xử lý]   │  │
│ │ Requested: 3 ngày trước · SLA: ⚠️ 1h remaining                │  │
│ │ 📦 Items: Kem chống nắng × 1                                   │  │
│ │ 💰 Amount: 99,500đ (partial — shipping not refunded)           │  │
│ │ 📝 Reason: Nhận hàng bị hỏng                                   │  │
│ │ 📸 Evidence: [📷 5 photos] [🎥 1 video]                        │  │
│ │ ...                                                              │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Pagination: [← Trước] Page 1/1 [Tiếp →]                           │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
RefundManagementPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("🔄 Quản lý hoàn tiền")
│   └── ExportButton
├── SummaryBar
│   ├── PendingCount
│   ├── ApprovedCount (30d)
│   ├── RejectedCount (30d)
│   ├── RefundTotal (30d, VND)
│   └── RefundRate (percentage)
├── StatusTabs (Pending, Approved, Rejected, All)
├── FilterBar
│   ├── PlatformFilter
│   ├── ReasonFilter (Not as described, Damaged, Wrong item, Not received, Other)
│   └── PeriodFilter (7d, 30d, 90d)
├── RefundList
│   └── RefundRequestCard[]
│       ├── CardHeader
│       │   ├── OrderNumber (link to order detail)
│       │   ├── BuyerName
│       │   └── StatusBadge
│       ├── TimingRow
│       │   ├── RequestedDate (relative)
│       │   └── SLATimer (countdown, color-coded)
│       ├── ItemsSection
│       │   ├── ProductImage (thumbnail)
│       │   ├── ProductName (link)
│       │   └── Quantity
│       ├── FinancialSection
│       │   ├── RefundAmount
│       │   ├── RefundType (Full / Partial)
│       │   └── WhatIsRefunded (items, shipping, or both)
│       ├── ReasonSection
│       │   ├── ReasonCategory
│       │   └── BuyerDescription
│       ├── EvidenceSection
│       │   ├── PhotoThumbnails[] (clickable → full-screen)
│       │   ├── VideoThumbnails[] (clickable → player)
│       │   └── ViewAllButton
│       ├── BuyerHistoryLine
│       │   ├── TotalOrders
│       │   ├── PreviousRefunds
│       │   └── CustomerValue (star rating)
│       ├── SourceBadge (S009)
│       └── ActionBar
│           ├── ReviewButton ("👁 Review Evidence", primary)
│           ├── ApproveButton ("✅ Duyệt", success)
│           ├── RejectButton ("❌ Từ chối", destructive)
│           ├── ContactButton ("💬 Liên hệ")
│           └── OrderDetailButton ("📊 Detail")
├── Pagination
└── ReviewDrawer (opens on "Review Evidence")
    ├── EvidenceGallery
    │   ├── PhotoViewer (swipeable, zoomable)
    │   └── VideoPlayer
    ├── OrderDetailSummary
    ├── BuyerPurchaseHistory
    ├── SimilarRefundHistory (for same product)
    ├── ResolutionForm
    │   ├── DecisionRadio (Approve Full / Approve Partial / Reject)
    │   ├── PartialAmountInput (if partial)
    │   ├── ReasonTextarea (required, min 10 chars)
    │   └── InternalNoteInput (optional)
    └── SubmitButton
```

---
## 5. Displayed Data

| Field | Source | Format |
|---|---|---|
| Order number | `refunds.order_id` → `orders.platform_order_id` | "#TK-1234" |
| Buyer | `orders.buyer_name` | Name |
| Status | `refunds.status` | Badge: ⏳/✅/❌ |
| Requested | `refunds.created_at` | Relative: "1 ngày trước" |
| SLA remaining | Computed: created_at + 48h - now | Countdown with color |
| Items | `order_items[]` for refund | Product × qty |
| Refund amount | `refunds.amount` | VND format |
| Refund type | `refunds.type` | "Full" / "Partial" |
| Reason | `refunds.reason_category` + `refunds.reason_text` | Category + text |
| Evidence | `refund_evidence[]` | Photo/video thumbnails |
| Buyer history | Aggregated from `orders` by buyer | Orders count + refund count |
| Platform | `orders.source_platform` | Icon + name |
| Source class | Trust badge | S009 |
| Refund rate | Computed: refunds / total orders × 100 | "2.3%" |

---
## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Review evidence | "👁 Review" | — | Open ReviewDrawer | `order:manage` |
| 2 | Approve full refund | "✅ Duyệt" → confirm | `RefundService/Approve(type=full)` | Confirmation dialog: "Duyệt hoàn tiền 598,000đ? Số tiền sẽ trừ khỏi doanh thu." → refund processed | `order:manage` |
| 3 | Approve partial | Resolution form → amount → submit | `RefundService/Approve(type=partial, amount)` | Partial refund processed | `order:manage` |
| 4 | Reject | "❌ Từ chối" → reason required | `RefundService/Reject(reason)` | Rejection recorded, buyer notified | `order:manage` |
| 5 | Contact buyer | "💬 Liên hệ" | — | → Inbox thread with buyer | `thread:reply` |
| 6 | View order | "📊 Detail" | — | → `/orders/[order_id]` | `order:read` |
| 7 | View evidence fullscreen | Tap photo/video thumbnail | — | Full-screen gallery/player | `order:manage` |
| 8 | Filter/tab | Change tab or filter | Refetch | List updates | `order:manage` |
| 9 | Export | "📤 Export" | Client-side CSV | Refund report download | `order:manage` |

---
## 7. Validation Rules (Resolution Form)

| Field | Rule | Error |
|---|---|---|
| Decision | Required | "Vui lòng chọn quyết định" |
| Partial amount | Required if partial, > 0 and ≤ order total | "Số tiền hoàn phải từ 1đ đến {max}" |
| Reason | Required, min 10 chars | "Vui lòng nhập lý do (tối thiểu 10 ký tự)" |

---
## 8. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Summary shimmer + 3 card skeletons |
| LOADED | Data received | Refund cards with full data |
| EMPTY | No refunds at all | "✅ Không có yêu cầu hoàn tiền nào. Đơn hàng đang vận hành tốt!" (happy state) |
| EMPTY_TAB | Current tab has no items | "Không có yêu cầu nào trong tab này" |
| ERROR | API failed | Error banner with retry |
| REVIEWING | Review drawer open | Side panel with evidence and form |
| PROCESSING | Approve/reject in progress | Button spinner, form disabled |
| SLA_BREACH | ≥1 request past 48h SLA | Red banner: "⚠️ {count} yêu cầu đã vượt SLA 48h!" |

---
## 9. Permissions

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View refunds | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Approve/reject | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View refund amounts | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Contact buyer | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Export | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

---
## 10. Edge Cases

| Edge Case | Handling |
|---|---|
| Platform auto-approved refund | Show as "✅ Platform approved" with no Creativanta action needed. Still logged. |
| Buyer evidence is empty | Show "Người mua chưa cung cấp bằng chứng. [💬 Yêu cầu thêm]" |
| Refund > 30% of order value for partial | Warning: "Refund lớn. Bạn có chắc nhập đúng số tiền?" |
| Same buyer has 3+ refund requests | Warning badge: "⚠️ Người mua thường xuyên yêu cầu hoàn tiền (3 lần trong 30 ngày)" |
| Product from refund is out of stock | Note: "Sản phẩm này đã hết hàng — không thể giao lại" |
| Refund for cancelled order | Auto-approve path: "Đơn đã hủy — refund tự động" |

---
## 11. Profit OS Integration

- Every approved refund creates a `billing_event` of type `refund` in the operating ledger
- Profit Dashboard (W081) reflects refund deductions in real-time
- Refund amount is subtracted from revenue at the product level, platform level, and time period level
- Trust badge shows source class: 🟢 Official (if platform API refund) or 🔵 Imported (if manual)

---
## 12. SvelteKit Implementation Notes

### Route & Server Load
- **Route**: `src/routes/(app)/orders/refunds/+page.svelte`
- **Server load**: `+page.server.ts` → fetch refund list + summary stats
- **SSR**: Server renders first page of refund cards
- **Real-time**: SSE on `/events/refunds` for new requests and status changes

### Data Fetching Strategy
```
+page.server.ts:
  Promise.all([
    refundService.list({ status: 'pending', page, limit: 15 }),
    refundService.getSummary(period: '30d')
  ])

Client-side:
  onTabChange(status) → refundService.list({ status })
  onApprove(id, type, amount, reason) →
    refundService.approve(id, { type, amount, reason })
  onReject(id, reason) → refundService.reject(id, { reason })
```

### Operating Ledger Integration
- Every approved refund triggers `billingEventService.create({ type: 'refund', amount, order_id })`
- Profit Dashboard (W081) listens to same SSE channel for real-time updates
- Refund amounts are subtracted at product, platform, and time-period levels

### Evidence Storage
- Photos/videos stored in CDN via `refund_evidence` table
- Thumbnails: 200×200 WebP (CDN-served)
- Full-size: original resolution with lazy-load
- Video: HLS streaming for large files

---
## 13. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `refunds.list.viewed` | Page load | `pending_count`, `total_count_30d`, `refund_rate` |
| `refunds.evidence_reviewed` | Click "Review Evidence" | `refund_id`, `evidence_count` |
| `refunds.approved` | Approve confirmed | `refund_id`, `type` ('full'/'partial'), `amount`, `time_to_decide` |
| `refunds.rejected` | Reject confirmed | `refund_id`, `reason`, `time_to_decide` |
| `refunds.buyer_contacted` | Contact buyer clicked | `refund_id`, `buyer_id` |
| `refunds.filtered` | Tab/filter changed | `tab`, `filter_type`, `filter_value` |
| `refunds.exported` | Export action | `format`, `count` |
| `refunds.sla_breached` | SLA timer crosses 48h | `refund_id`, `overdue_hours` |

---
## 14. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (first refund card) |
| TTI | < 2.0s |
| Summary bar render | < 200ms |
| Evidence gallery open | < 500ms |
| Review drawer open | < 300ms |
| Approve/reject response | < 2s |

---
## 15. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached (chỉ xem, quyết định không khả dụng)" | Auto-retry when online |
| API error (5xx) | Server failure | Error banner: "Không tải được yêu cầu hoàn tiền. [Thử lại]" | Retry button |
| Approve failed | Platform API rejection | Drawer error: "Không xử lý được. {platform} từ chối hoàn tiền. [Thử lại]" | Retry or escalate |
| Reject failed | API error | Toast: "Không từ chối được. [Thử lại]" | Retry |
| Evidence load failed | CDN error | Placeholder: "📸 Không tải được bằng chứng. [Thử lại]" | Retry individual |
| Concurrent decision | Another user already decided | Toast: "Yêu cầu đã được xử lý bởi {user}. [Làm mới]" | Auto-refresh list |
| Permission denied | 403 | "Không có quyền xử lý hoàn tiền" → navigate to dashboard | Contact admin |

---
## 16. Accessibility

| Element | Requirement |
|---|---|
| Refund cards | `role="article"`, `aria-label="Hoàn tiền {id}, đơn {order_id}, {amount}, {status}"` |
| SLA countdown | `role="timer"`, `aria-label="Thời hạn xử lý: còn {hours} giờ"` |
| Evidence thumbnails | `alt="Bằng chứng ảnh {index} trên {total}"` |
| Review drawer | Focus trap, `aria-modal="true"`, `aria-labelledby="review-title"` |
| Status tabs | `role="tablist"`, `aria-selected` on active tab |
| Summary bar | `aria-label="Tổng quan 30 ngày: {pending} chờ, {approved} duyệt, {rejected} từ chối"` |
| Approve/Reject buttons | `aria-label="Duyệt hoàn tiền {amount}"` / `aria-label="Từ chối hoàn tiền"` |

---
## 17. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | App Shell + summary bar shimmer + card skeletons |
| Summary stats | 200-300ms | Counters animate in (pending highlighted) |
| Refund cards | 300-500ms | Cards populate with stagger animation |
| SLA timers | 400ms | Countdown timers start ticking |
| Evidence thumbnails | 500-800ms | Photo thumbnails lazy-load progressively |

---
## 18. Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "598.000đ")
- Compact format: "4.5M VND" in summary
- SLA: "23 giờ còn lại" / "⚠️ 1 giờ còn lại" / "🔴 Quá hạn 3 giờ"
- Refund rate: "2.3%"
- Status: "Chờ xử lý", "Đã duyệt", "Từ chối"
- Refund type: "Hoàn toàn" (full) / "Một phần" (partial)
- Reasons: "Sản phẩm không như mô tả", "Nhận hàng bị hỏng", "Sai sản phẩm", "Không nhận được hàng"
- Decision: "Đã duyệt bởi {user} · {time}" / "Từ chối bởi {user}"
- Relative time: "1 ngày trước", "2 giờ trước"

---
## 19. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-refund-pending` | Pending status (⏳ amber) |
| `--color-refund-approved` | Approved status (✅ green) |
| `--color-refund-rejected` | Rejected status (❌ red) |
| `--color-sla-safe` | SLA > 12h remaining (green text) |
| `--color-sla-warning` | SLA 4-12h (yellow text) |
| `--color-sla-danger` | SLA < 4h (red text, pulsing) |
| `--color-sla-breached` | SLA < 0 (red background banner) |
| `--color-accent` | Primary CTAs (Review) |
| `--color-success` | Approve button |
| `--color-danger` | Reject button |
| `--color-surface-elevated` | Refund cards, review drawer |

---
## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W062] Order List | Orders that can be refunded |
| [W063] Order Detail | Specific order context |
| [W081] Profit Dashboard | Revenue impact of refunds |
| [W046] Unified Inbox | Buyer communication |
| [M030] Mobile Refunds | Mobile equivalent |
| [A019] Admin Disputes | Admin escalation for disputes |
| [S009] Trust Badge | Source class on refund data |
| [S007] Confirmations | Approve/reject confirmation |

---
## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A standardization**: Fixed section numbering (1-21 sequential). Removed duplicate §5 and generic boilerplate. Added SvelteKit Implementation Notes (operating ledger integration, evidence storage), 8 Analytics Events, Performance Requirements, screen-specific Error Handling (7 scenarios with concurrent decisions), Accessibility with SLA timer ARIA, Loading Behavior (5 stages), Localization with refund-specific SLA/reason formats, Design Tokens with SLA-timer colors. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

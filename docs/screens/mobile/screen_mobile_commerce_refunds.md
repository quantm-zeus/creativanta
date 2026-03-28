# Screen: Mobile — Refund Management

> **Screen ID**: M031
> **Module**: M13 — Product Hub / Order Truth
> **Route**: `/commerce/refunds` (mobile app)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 06 §Commerce, Product Freeze §22, A1 Schema (refunds, orders, refund_evidence, order_items), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile refund management — the on-the-go pipeline for reviewing, approving, and rejecting refund requests. Uses swipe-to-decide gestures for rapid triage, inline evidence previews, buyer reputation scoring, and SLA countdown timers. Designed for the "refund review while away from desktop" workflow pattern.

### User Goals
- Triage pending refund requests quickly via swipe gestures (approve/reject)
- Review buyer evidence (photos, videos) inline without leaving the screen
- Track SLA compliance — resolve before 48h deadline
- Understand refund impact on revenue and product quality

### Business Goals
- Minimize refund processing time (target: < 48h)
- Track refund rate per product for quality monitoring
- Ensure every refund decision updates the operating P&L ledger
- Reduce fraudulent refund approval through buyer history scoring

### When This Screen Is Used
- **Push notification**: "↩️ Yêu cầu hoàn tiền mới #456" → deep link to this screen
- **Daily review**: Check pending refunds each morning
- **SLA alert**: "⏰ 2 refund requests near SLA breach" → urgent triage
- **Post-campaign**: Review spike in returns after promotion

### Entry Points
- Commerce tab → "↩️ Hoàn trả"
- Push notification: "↩️ Yêu cầu hoàn tiền mới" → deep link with `status=pending` filter
- Bottom sheet: Commerce Dashboard (M030) → "Pending actions" → refund item tap
- Copilot (M060): "Kiểm tra hoàn tiền" → navigate here

### Exit Points
- Tap order reference → Order Detail (M025)
- Tap buyer name → Contact in Inbox
- Tap product name → Product Detail (M026)
- "📊 Analytics" → Refund analytics view

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `order:manage` permission (Owner, Admin, Manager)
- At least one order exists in workspace (refunds require orders)
- Active commerce platform connector OR manual orders

### Postconditions
- Approved refunds: `refund` record created → `orders.status` updated → operating ledger adjusted
- Rejected refunds: `refund` record with `status=rejected` + reason → buyer notified via platform
- All decisions logged in audit trail with user, timestamp, reason, and evidence reviewed
- Push notification badge on "Refunds" cleared when all pending are resolved

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Hoàn trả (5)                                    [Filter ▾]       │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ──────────────────────────────────────────────────┐  │
│ │ ⏳ 3 chờ xử lý · ✅ 8 đã duyệt (30d) · ❌ 2 từ chối (30d)  │  │
│ │ 💰 Refund total: 4.5M VND (30d) · Rate: 2.3% (healthy ✅)    │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Chips: [⏳ Chờ (3)] [✅ Duyệt (8)] [❌ Từ chối (2)] [📋 Tất cả] │
│                                                                      │
│ ┌─ Refund Card (Pending, Urgent) ────────────────────────────────┐  │
│ │ ↩️ #456 · Order #TK-1234 · 🎵 TikTok      [⏳ Chờ xử lý]   │  │
│ │ Serum VitC × 2 · 598,000đ (full refund)                       │  │
│ │ 📝 Reason: Sản phẩm không như mô tả                           │  │
│ │ 📸 Evidence: [Photo 1] [Photo 2] [Photo 3] → tap to view      │  │
│ │ 👤 Nguyễn Văn A · 3 orders · 0 refunds · ⭐ Reliable          │  │
│ │ ⏰ SLA: 23h remaining · Source: [🟢 Official]                 │  │
│ │                                                                  │  │
│ │ ← Swipe L: [❌ Từ chối]  │  Swipe R: [✅ Duyệt] →            │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Refund Card (Pending, Near SLA) ──────────────────────────────┐  │
│ │ ↩️ #455 · Order #SP-5678 · 🛍 Shopee       [⏳ Chờ xử lý]   │  │
│ │ Kem chống nắng × 1 · 99,500đ (partial — no shipping)          │  │
│ │ 📝 Reason: Nhận hàng bị hỏng                                  │  │
│ │ 📸 Evidence: [Photo 1] [Photo 2] [📹 Video 1]                 │  │
│ │ 👤 Lê Hoa · 1 order · 0 refunds · ⭐ New customer             │  │
│ │ ⏰ SLA: ⚠️ 1h remaining · Source: [🟢 Official]              │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Refund Card (Approved) ───────────────────────────────────────┐  │
│ │ ↩️ #450 · Order #TK-1230 · 🎵 TikTok      [✅ Đã duyệt]    │  │
│ │ Mask collagen × 1 · 240,000đ · Approved 2d ago                 │  │
│ │ By: admin@team.com · Reason: Buyer evidence confirmed           │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Pull-to-refresh · Infinite scroll                                    │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
MobileRefundListPage
├── AppBar
│   ├── BackButton
│   ├── Title ("Hoàn trả" + count badge)
│   └── FilterButton ("Filter ▾" → bottom sheet)
├── SummaryBar (collapsible on scroll)
│   ├── PendingCount (⏳)
│   ├── ApprovedCount (30d, ✅)
│   ├── RejectedCount (30d, ❌)
│   ├── RefundTotal (30d, VND)
│   └── RefundRateBadge (% + health indicator)
├── StatusChips (horizontal scroll, tappable)
│   └── StatusChip[] (Pending, Approved, Rejected, All)
│       ├── StatusIcon + Label
│       └── CountBadge
├── RefundCardList (pull-to-refresh + infinite scroll)
│   └── RefundCard[] (Slidable — swipe to decide)
│       ├── CardHeader
│       │   ├── RefundId ("↩️ #456")
│       │   ├── OrderRef ("Order #TK-1234", tappable → Order Detail)
│       │   ├── PlatformBadge (🎵 TikTok / 🛍 Shopee)
│       │   └── StatusBadge (⏳ / ✅ / ❌)
│       ├── ItemSummary ("Serum VitC × 2")
│       ├── AmountRow
│       │   ├── RefundAmount (VND formatted)
│       │   └── RefundType ("full refund" / "partial — no shipping")
│       ├── ReasonRow
│       │   ├── ReasonCategory (dropdown value)
│       │   └── ReasonText (buyer description, 2-line max)
│       ├── EvidenceRow (horizontal scroll thumbnails, tappable)
│       │   ├── PhotoThumbnail[] (max 5 visible + "+N")
│       │   └── VideoThumbnail[] (play icon overlay)
│       ├── BuyerInfoRow
│       │   ├── BuyerName
│       │   ├── OrderCount ("3 orders")
│       │   ├── RefundHistory ("0 refunds")
│       │   └── BuyerReliabilityBadge (⭐ Reliable / ⚡ New / ⚠️ Repeat refunder)
│       ├── SLARow (pending only)
│       │   ├── SLACountdown ("23h remaining")
│       │   └── SLAIcon (🟢 > 12h / 🟡 4-12h / 🔴 < 4h / ⚠️ breached)
│       ├── SourceBadge (S009 trust badge)
│       ├── DecisionInfo (approved/rejected only)
│       │   ├── DecidedBy (email)
│       │   ├── DecidedAt (relative time)
│       │   └── DecisionReason
│       ├── SwipeRightAction → ApproveRefund (✅, green)
│       └── SwipeLeftAction → RejectRefund (❌, red)
├── EvidenceViewer (full-screen modal, swipeable gallery)
│   ├── PhotoViewer (pinch-to-zoom, swipe navigation)
│   ├── VideoPlayer (inline)
│   └── CloseButton
├── ApproveBottomSheet (on swipe right)
│   ├── RefundSummary (order + amount)
│   ├── AmountToggle (Full / Partial)
│   ├── PartialAmountInput (if partial)
│   ├── ReasonInput (required, min 10 chars)
│   └── ConfirmButton ("✅ Xác nhận hoàn tiền")
├── RejectBottomSheet (on swipe left)
│   ├── RefundSummary
│   ├── ReasonSelector (predefined: Insufficient evidence / Not eligible / Fraud suspected / Other)
│   ├── AdditionalNotesInput (optional)
│   └── ConfirmButton ("❌ Xác nhận từ chối")
├── FilterBottomSheet (conditional)
│   ├── PlatformFilter (TikTok Shop, Shopee, Lazada)
│   ├── ReasonFilter (Damaged, Not as described, Missing, Wrong item, Other)
│   ├── DateRangeFilter (7d, 30d, 90d, Custom)
│   ├── AmountRangeFilter
│   ├── ApplyButton
│   └── ResetButton
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Refund list | `refunds` + `orders` + `order_items` | `RefundService/List(status, filters, cursor)` | Card list | 2m TTL |
| Summary stats | Aggregated from `refunds` (30d) | `RefundService/GetStats(period=30d)` | Counts + amounts | 5m TTL |
| Refund rate | `COUNT(refunds 30d) / COUNT(orders 30d) × 100` | same | "2.3%" + health badge | 5m TTL |
| Evidence | `refund_evidence[]` | Included in list response | Photo/video thumbnails (CDN) | CDN cached |
| Buyer history | `orders WHERE buyer_id` aggregated | Included in list response | "3 orders · 0 refunds" | 5m TTL |
| SLA countdown | Computed: `refund.created_at + 48h - now` | Client-side | "23h remaining" with color | Real-time |
| Source badge | `orders.source_class` | S009 | Official/Imported badge | 2m TTL |
| Platform | `orders.source_platform` | Included | Platform icon | 2m TTL |

---

## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | View refund details | Tap refund card | Navigate | — | Expand inline or push → detail | `order:manage` |
| 2 | View evidence | Tap photo/video thumbnail | Modal | — | Full-screen gallery/player | `order:manage` |
| 3 | Approve refund | Swipe right → bottom sheet → confirm | Decision | `RefundService/Approve(id, type, amount, reason)` | Toast "✅ Đã duyệt hoàn tiền {amount}" + card moves to Approved | `order:manage` |
| 4 | Reject refund | Swipe left → bottom sheet → confirm | Decision | `RefundService/Reject(id, reason_category, notes)` | Toast "❌ Đã từ chối hoàn tiền" + card moves to Rejected | `order:manage` |
| 5 | View order detail | Tap order reference link | Navigate | — | Push → M025 Order Detail | `order:read` |
| 6 | Contact buyer | Tap buyer name | Navigate | — | Opens platform chat or SMS | `order:contact_buyer` |
| 7 | Filter by status | Tap status chip | Filter | Refetch with status | List filters, chip highlights | `order:manage` |
| 8 | Advanced filter | Tap "Filter ▾" | Filter | Refetch | Bottom sheet → applied | `order:manage` |
| 9 | Pull refresh | Pull gesture | Refresh | Refetch current view | List + summary update. Haptic light. | `order:manage` |
| 10 | Load more | Scroll to bottom | Pagination | `RefundService/List(cursor)` | More cards append | `order:manage` |
| 11 | View product | Tap product name in items | Navigate | — | Push → M026 Product Detail | `product:read` |

---

## 7. Validation Rules

### Approve Form
| Field | Rule | Error |
|---|---|---|
| Decision type | Required (Full / Partial) | "Vui lòng chọn loại hoàn tiền" |
| Partial amount | Required if partial, > 0 and ≤ order total | "Số tiền hoàn phải từ 1đ đến {max}" |
| Reason | Required, min 10 chars | "Vui lòng nhập lý do (tối thiểu 10 ký tự)" |

### Reject Form
| Field | Rule | Error |
|---|---|---|
| Reason category | Required | "Vui lòng chọn lý do từ chối" |
| Notes | Optional, max 500 chars | — |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial load | Summary shimmer + 3 card skeletons | Wait |
| LOADED | Refunds available | Summary bar + refund cards | Normal interactions |
| EMPTY | No refunds at all | Illustration + "✅ Không có yêu cầu hoàn tiền nào. Đơn hàng đang vận hành tốt!" (happy state) | — |
| EMPTY_FILTERED | Filter active, no match | "Không có yêu cầu phù hợp bộ lọc. [Xóa bộ lọc]" | Clear filters |
| HAS_URGENT | ≥1 refund near SLA breach (< 4h) | Red banner: "⚠️ {count} yêu cầu sắp quá SLA 48h!" | Act urgently |
| SLA_BREACHED | ≥1 refund past 48h | Red persistent banner: "🔴 {count} yêu cầu đã vượt SLA!" | Escalate |
| HIGH_REFUND_RATE | Rate > 5% | Orange banner: "⚠️ Refund rate cao! Kiểm tra chất lượng sản phẩm." | Investigate |
| APPROVING | Approve bottom sheet open | Bottom sheet with form | Fill + confirm |
| REJECTING | Reject bottom sheet open | Bottom sheet with form | Fill + confirm |
| PROCESSING | API call in progress | Button spinner, form disabled | Wait |
| REALTIME_UPDATE | New refund arrives | Toast: "↩️ Yêu cầu hoàn tiền mới #457" + card prepends | Tap to see |
| ERROR | API failed | "Không tải được yêu cầu hoàn tiền. [Thử lại]" | Retry |
| OFFLINE | No network | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached" + cached refunds (read-only, no approve/reject) | Read cached |

---

## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View refunds | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| View refund amounts | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Approve/reject | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| View evidence | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Contact buyer | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Editor and below**: No access to refund management. Bottom nav "Refunds" section hidden.
- **Manager+**: Full access including financial amounts and decision-making.

---

## 10. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| New refund requests | Push notification + SSE `/events/refunds` | Real-time |
| Refund status changes (other users) | SSE | Real-time |
| SLA countdown | Client-side timer | Every minute |
| Summary stats | Polling | Every 5 minutes |

### Real-time UX
- **New refund**: Toast notification + card prepends at top with orange highlight pulse (3s)
- **Status change by another user**: Card updates badge + brief flash animation
- **SLA breach**: Card border turns red + persistent banner appears

---

## 11. Mobile-specific UX

### Gestures & Haptics
| Gesture | Target | Haptic | Result |
|---|---|---|---|
| Swipe right | Refund card (pending) | Medium | Reveal "✅ Duyệt" (green background) → release opens approve sheet |
| Swipe left | Refund card (pending) | Medium | Reveal "❌ Từ chối" (red background) → release opens reject sheet |
| Pull down | Whole page | Light | Refresh all |
| Tap evidence thumbnail | Photo/video | Light | Full-screen gallery |
| Pinch | Evidence in full-screen | — | Zoom in/out |
| Long press card | Refund card | Heavy | Context menu (View order / Contact buyer / Copy refund ID) |

### Badge & Notifications
- App icon badge includes pending refund count
- Push notification groups: "↩️ 3 yêu cầu hoàn tiền mới"
- Notification tap deep-links to refund list with `status=pending`
- SLA-near-breach sends separate urgent push

### Dark Mode
- Full dark mode support
- SLA indicators maintain same color semantics
- Evidence thumbnails render with dark border
- Status badges use consistent colors across themes

### Offline Behavior
- Last fetched refund list cached (up to 30 most recent)
- Summary stats cached
- Evidence thumbnails cached (photos only, not videos)
- **Approve/reject disabled offline** — banner: "Cần kết nối mạng để xử lý hoàn tiền"
- Real-time updates resume on reconnection

---

## 12. Edge Cases

| Edge Case | Handling |
|---|---|
| Platform auto-approved refund | Show "✅ Platform tự duyệt" badge — no Creativanta action needed |
| Buyer evidence is empty | Show "Chưa có bằng chứng. [💬 Yêu cầu thêm]" link |
| Partial refund > 30% order value | Warning in bottom sheet: "⚠️ Hoàn tiền lớn. Xác nhận số tiền?" |
| Same buyer has 3+ refund requests (30d) | Warning badge on card: "⚠️ Người mua yêu cầu hoàn tiền thường xuyên (3 lần/30d)" |
| Product from refund is out of stock | Note in card: "Sản phẩm đã hết — không thể giao lại" |
| Refund for cancelled order | Auto-approve path: badge "Đơn đã hủy — hoàn tiền tự động" |
| Evidence file too large to preview | Show placeholder: "📎 File quá lớn. [Tải về để xem]" |
| SLA already breached before user opens | Pre-sorted to top with red border and "! OVERDUE" badge |

---

## 13. Profit OS Integration

- Every approved refund creates `billing_event` type `refund` in operating ledger
- Profit Dashboard (W081) reflects refund deductions in real-time
- Refund amount subtracted from revenue at product level, platform level, and period level
- Trust badge: 🟢 Official (platform API refund) or 🔵 Imported (manual refund)
- Partial refunds only deduct the approved partial amount

---

## 14. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `refunds.list.viewed` | Page opens | `pending_count`, `total_count`, `refund_rate` |
| `refunds.list.filtered` | Status chip or filter | `filter_type`, `filter_value` |
| `refunds.evidence.viewed` | Tap evidence thumbnail | `refund_id`, `evidence_type` ('photo'/'video') |
| `refunds.approved` | Approve confirmed | `refund_id`, `type` ('full'/'partial'), `amount`, `time_to_decide` |
| `refunds.rejected` | Reject confirmed | `refund_id`, `reason_category`, `time_to_decide` |
| `refunds.sla.breached` | SLA timer reaches 0 | `refund_id`, `overdue_hours` |
| `refunds.pull_refreshed` | Pull to refresh | — |

---

## 15. Performance Requirements

| Metric | Target |
|---|---|
| Open to interactive | < 800ms |
| Pull-to-refresh | < 1s |
| Evidence gallery open | < 500ms |
| Card render (10 items) | 60fps scroll |
| Push → deep link open | < 1s |
| Offline cache load | < 200ms |

---

## 16. Flutter Implementation Notes

### Widget Structure
- **Route**: `/commerce/refunds` → `RefundListPage`
- **State management**: Riverpod `refundListProvider(status_filter)` + `refundStatsProvider`
- **Swipe**: `flutter_slidable` package for reveal actions
- **Pull-to-refresh**: `RefreshIndicator` widget
- **Infinite scroll**: `InfiniteListView` with cursor-based pagination
- **Evidence gallery**: `photo_view` package for zoom + `video_player` for videos
- **Push**: Firebase Cloud Messaging deep link handler for `refund_new` events
- **SLA timer**: `Timer.periodic(1.min)` for countdown — `ValueNotifier` for efficient rebuild

### Data Fetching
```
onInit:
  Promise.all([
    refundService.list(status: 'pending', limit: 15),
    refundService.getStats(period: '30d'),
  ])

onFilterChange(status):
  refundService.list(status: status, limit: 15)

onPullRefresh:
  Promise.all([refetch list, refetch stats])

onApprove(id, type, amount, reason):
  refundService.approve(id, { type, amount, reason })
    .then(() → refetch list + stats)

onReject(id, category, notes):
  refundService.reject(id, { category, notes })
    .then(() → refetch list + stats)
```

### Offline Storage
- **Hive box**: `refund_cache` — stores last 30 refund cards
- **TTL**: 15 minutes
- **Write-through**: On successful API fetch, update cache
- **Read-fallback**: On network error, load from cache (approve/reject disabled)

---

## 17. Navigation Map

```
Mobile Refund List (/commerce/refunds)
├── → /commerce/orders/[id] (tap order reference → Order Detail)
├── → /commerce/products/[id] (tap product name → Product Detail)
├── → /inbox/[thread_id] (tap buyer name → Contact)
├── → Evidence gallery (tap photo/video → full-screen)
├── ← /commerce (back via bottom nav or back button)
```

---

## 18. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached (chỉ xem)" | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được yêu cầu hoàn tiền. [Thử lại]" | Retry |
| Approve failed | API rejection | Toast: "Không duyệt được. Đơn hàng có thể đã xử lý. [Làm mới]" | Refresh list |
| Reject failed | API rejection | Toast: "Không từ chối được. [Thử lại]" | Retry |
| Evidence load failed | CDN error | Placeholder: "📸 Không tải được ảnh. [Thử lại]" | Retry individual |
| Push deep-link failed | Refund not found | Toast: "Yêu cầu hoàn tiền không tồn tại" → navigate to refund list | — |
| Concurrent decision | Another user already decided | Toast: "Yêu cầu đã được xử lý bởi {user}" → card updates | Auto-refresh |

---

## 19. Accessibility

| Element | Requirement |
|---|---|
| Refund cards | `Semantics(label: "Hoàn tiền 456, đơn TK-1234, 598 nghìn đồng, chờ xử lý, còn 23 giờ")` |
| Status chips | `Semantics(selected:)` on active filter |
| Swipe actions | Also available via long-press context menu for accessibility |
| SLA countdown | `Semantics(liveRegion: true)` for urgency updates |
| Evidence thumbnails | `Semantics(label: "Bằng chứng ảnh 1 trên 3")` |
| Approve/reject buttons | `Semantics(label: "Duyệt hoàn tiền 598 nghìn đồng")` |
| Summary bar | `Semantics(label: "3 chờ xử lý, 8 đã duyệt, 2 từ chối, tổng 4 triệu 5")` |

---

## 20. Localization Notes

- Primary language: Vietnamese
- Currency: "598,000đ" (dot separator, đ suffix)
- Compact amounts in summary: "4.5M VND"
- Refund ID: "#456" format
- Status: "Chờ xử lý", "Đã duyệt", "Từ chối"
- SLA: "23h remaining" / "⚠️ 1h remaining" / "🔴 Quá hạn 3h"
- Time: Relative ("1 ngày trước", "2 giờ trước")
- Buyer reputation: "Reliable" → "Đáng tin cậy", "Repeat refunder" → "Hay hoàn hàng"

---

## 21. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-refund-pending` | Pending status badge (🟡 amber) |
| `--color-refund-approved` | Approved status badge (🟢 green) |
| `--color-refund-rejected` | Rejected status badge (🔴 red) |
| `--color-sla-safe` | SLA > 12h (green) |
| `--color-sla-warning` | SLA 4-12h (yellow) |
| `--color-sla-danger` | SLA < 4h (red) |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Refund cards |
| `--color-swipe-approve` | Swipe right background (green) |
| `--color-swipe-reject` | Swipe left background (red) |

---

## 22. Related Screens

| Screen | Relationship |
|---|---|
| [W073] Web Refund Management | Web equivalent (full pipeline with review drawer) |
| [M025] Mobile Order Detail | Order context for refund |
| [M026] Mobile Products | Product referenced in refund |
| [M030] Mobile Commerce Dashboard | Pending refund count in actions |
| [W081] Profit Dashboard | Revenue impact of refunds |
| [S009] Trust Badge | Source class badge on refund data |

---

## 23. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite** from 170-line Tier C. Added: complete 23-section structure with Flutter widget tree, Riverpod state, swipe-to-decide workflow, evidence gallery, buyer reputation scoring, SLA tracking with countdown timers, approve/reject bottom sheets with validation, 13 states, full RBAC matrix, real-time updates, gestures/haptics, offline caching with Hive, Profit OS integration, 7 analytics events, performance KPIs, navigation map, 7 error scenarios, semantic accessibility labels, screen-specific design tokens. Replaced ALL generic boilerplate. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

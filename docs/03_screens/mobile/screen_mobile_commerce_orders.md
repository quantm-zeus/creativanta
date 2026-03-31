# Screen: Mobile — Commerce Order List

> **Screen ID**: M024
> **Module**: M13 — Product Hub / Order Management
> **Route**: `/orders` (mobile app)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 06 §Commerce, Product Freeze §21-24, A1 Schema (orders, order_items, order_events), B5 RBAC §2.7

---
## 1. Purpose & Context

The Mobile Order List is the on-the-go order management surface. Creators can monitor incoming orders, take quick actions (confirm, ship, contact buyer), and track fulfillment status. Push notifications deep-link directly to specific orders. Designed for rapid triage — swipe gestures for common actions.

### User Goals
- See new orders immediately via push notification → deep-link
- Quickly triage pending orders (confirm, ship, or investigate)
- Contact buyers directly (call, message) without leaving the app
- Track daily/weekly order volume and revenue

### Business Goals
- Reduce order processing time (target: < 30min from notification to confirmation)
- Enable commerce management on mobile (seller persona primary use case)
- Drive engagement through real-time order notifications

### When This Screen Is Used
- Continuously: Seller/commerce users check orders multiple times daily
- On notification: "📦 Đơn hàng mới!" push → immediate triage
- Daily review: Checking daily summary stats
- On-the-go: Managing orders while away from desktop

### Entry Points
- Bottom nav (Commerce mode): "📦 Đơn hàng" tab
- Push notification: "📦 Đơn hàng mới! #12345" → deep link to order list filtered
- Home Dashboard (M001): "Pending orders" widget tap
- Copilot (M060): "Kiểm tra đơn hàng" → navigates here

### Exit Points
- Tap order card → Order Detail (M025)
- Swipe right → Call buyer (opens phone dialer)
- Swipe left → Message buyer (opens chat)
- "📊 Analytics" → Order analytics view

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `order:read` permission (Editor+ roles)
- At least one platform connector with commerce capability active, or manual orders exist
- Seller or Commerce operator mode enabled (or Owner/Admin who sees all)

### Postconditions
- Order status changes logged in `order_events` audit trail
- Quick actions (confirm, ship) update order status in real-time
- Push notification badge cleared when order list is opened

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Đơn hàng (28)                              [🔍 Search] [Filter ▾]│
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Daily Summary ──────────────────────────────────────────────────┐ │
│ │ Hôm nay: 5 đơn · 1.2M VND                                      │ │
│ │ ⏳ 2 chờ xác nhận · 📦 3 đang giao · ✅ 12 hoàn thành         │ │
│ │ Tuần này: 28 đơn · 8.5M VND (+15% vs tuần trước)               │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Status Chips: [Tất cả (28)] [⏳ Chờ (2)] [📦 Giao (3)] [✅ Xong] │
│              [❌ Hủy (1)] [↩ Trả hàng (0)]                         │
│                                                                      │
│ ┌─ Order Card (Pending) ───────────────────────────────────────────┐ │
│ │ 📦 #12345 · 🎵 TikTok Shop                    [🟡 Chờ xử lý]  │ │
│ │ 2× Serum HA 30ml · 1× Kem chống nắng                            │ │
│ │ 💰 350,000đ · 📍 HCM · 2h ago                                   │ │
│ │ Buyer: Nguyễn Anh · ⭐ 4.8 (repeat buyer)                       │ │
│ │ 🟡 Xác nhận trước 18:00 hôm nay                                 │ │
│ │                                                                    │ │
│ │ ← Swipe L: [💬 Message]  │  Swipe R: [📞 Call] →                │ │
│ │ Tap: → Order Detail                                                │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Order Card (Shipping) ──────────────────────────────────────────┐ │
│ │ 📦 #12340 · 🛍 Shopee                     [🔵 Đang giao hàng]  │ │
│ │ 1× Mask collagen pack                                            │ │
│ │ 💰 120,000đ · 📍 HN · 1d ago                                    │ │
│ │ Tracking: GHN-SP12345 · Est: Tomorrow                             │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Order Card (Completed) ─────────────────────────────────────────┐ │
│ │ 📦 #12338 · 🎵 TikTok Shop                    [🟢 Hoàn thành]  │ │
│ │ 3× Set skincare                                                    │ │
│ │ 💰 799,000đ · 📍 Đà Nẵng · 3d ago                               │ │
│ │ Source: [🟢 Official] · Commission: 5% (39,950đ)                 │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Pull-to-refresh · Infinite scroll                                    │
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                           │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
MobileOrderListPage
├── AppBar
│   ├── BackButton / Title ("Đơn hàng" + total count)
│   ├── SearchButton ("🔍" → opens search overlay)
│   └── FilterButton ("Filter ▾" → bottom sheet)
├── DailySummaryCard
│   ├── TodayStats (order count + revenue)
│   ├── StatusBreakdown (pending, shipping, completed counts)
│   └── WeeklyComparison (this week vs last week, % delta)
├── StatusChips (horizontal scroll, tappable)
│   └── StatusChip[] (All, Pending, Shipping, Completed, Cancelled, Returns)
│       ├── StatusIcon
│       ├── StatusLabel
│       └── Count (badge)
├── OrderCardList (pull-to-refresh + infinite scroll)
│   └── OrderCard[] (swipeable)
│       ├── OrderHeader
│       │   ├── OrderNumber ("#12345")
│       │   ├── PlatformBadge (🎵 TikTok / 🛍 Shopee / etc.)
│       │   └── StatusBadge (color-coded)
│       ├── ItemSummary ("2× Serum HA 30ml · 1× Kem chống nắng")
│       ├── OrderInfo
│       │   ├── TotalAmount (VND formatted)
│       │   ├── BuyerLocation (city)
│       │   └── TimeAgo
│       ├── BuyerInfo (if pending — name, rating, repeat buyer badge)
│       ├── DeadlineWarning (conditional — "Xác nhận trước 18:00")
│       ├── TrackingInfo (conditional — if shipping: tracking code + ETA)
│       ├── SourceBadge (S009 trust badge — Official/Imported)
│       ├── CommissionInfo (conditional — if completed: % + amount)
│       ├── SwipeLeftAction → MessageBuyer (💬)
│       └── SwipeRightAction → CallBuyer (📞)
├── SearchOverlay (conditional)
│   ├── SearchInput ("Tìm theo mã đơn, tên buyer, sản phẩm...")
│   └── SearchResults (filtered order list)
├── FilterBottomSheet (conditional)
│   ├── PlatformFilter (TikTok Shop, Shopee, Lazada, Manual)
│   ├── DateRangeFilter (Today, This week, This month, Custom)
│   ├── AmountRangeFilter (0-100K, 100K-500K, 500K-1M, >1M)
│   ├── ApplyButton
│   └── ResetButton
└── BottomNavBar
```

---
## 5. Displayed Data

| Element | Source | API | Display Format | Cache |
|---|---|---|---|---|
| Order list | `orders` + `order_items` | `OrderService/List(status, filters)` | Card list | 2m |
| Daily summary | Aggregated from `orders` | `OrderService/GetDailyStats()` | Counts + amounts | 5m |
| Weekly comparison | Aggregated | same | "28 đơn · +15%" | 5m |
| Order items | `order_items` (first 3 + "+N more") | Included in list response | "2× Serum HA" | 2m |
| Buyer info | `orders.buyer_name` + buyer stats | same | Name + rating + repeat badge | 2m |
| Tracking | `orders.tracking_number` + carrier API | same | "GHN-SP12345 · Tomorrow" | 5m |
| Commission | `orders.commission_rate` × `orders.total_amount` | same | "5% (39,950đ)" | 5m |
| Platform source | `orders.source_platform` | same | Platform icon | 2m |
| Trust badge | `orders.source_class` | S009 | Official/Imported badge | 2m |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | View order detail | Tap order card | Navigate | — | Push → M025 Order Detail | `order:read` |
| 2 | Call buyer | Swipe right on order card | Quick action | Opens phone dialer | `tel:{buyer_phone}` | `order:contact_buyer` |
| 3 | Message buyer | Swipe left on order card | Quick action | Opens platform chat or SMS | Redirect to platform app or SMS | `order:contact_buyer` |
| 4 | Filter by status | Tap status chip | Filter | Refetch with status | List filters, chip highlights | `order:read` |
| 5 | Search | Tap 🔍 → type | Search | `OrderService/Search(query)` | Search overlay with results | `order:read` |
| 6 | Advanced filter | Tap "Filter ▾" | Filter | Refetch | Bottom sheet → applied | `order:read` |
| 7 | Pull refresh | Pull gesture | Refresh | Refetch current view | List + summary update. Haptic light. | `order:read` |
| 8 | Load more | Scroll to bottom | Pagination | `OrderService/List(cursor)` | More orders append | `order:read` |

---
## 7. Validation Rules

### Search
| Field | Rule | Error |
|---|---|---|
| Query | Min 2 chars | "Nhập ít nhất 2 ký tự" |
| Query | Max 100 chars | Auto-truncate |

### Filter
| Field | Rule |
|---|---|
| Date range | Start ≤ End, max 90 days ago to today |
| Amount range | Min ≥ 0, Min ≤ Max |

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial load | Summary shimmer + card skeletons | Wait |
| LOADED | Orders available | Daily summary + order cards | Normal interactions |
| EMPTY | No orders at all | Illustration + "Chưa có đơn hàng nào. Đơn hàng sẽ xuất hiện khi bạn kết nối shop." | Connect platform |
| EMPTY_FILTERED | Filter active, no match | "Không có đơn hàng phù hợp bộ lọc. [Xóa bộ lọc]" | Clear filters |
| HAS_PENDING | Pending orders exist | Red badge on "Chờ" chip, summary highlights pending count | Triage pending |
| HAS_URGENT | Pending orders near deadline | "⚠️ 2 đơn sắp quá hạn xác nhận!" banner at top | Act on urgent |
| SEARCHING | Search overlay active | Search input + filtered results | Type/clear |
| REALTIME_UPDATE | New order arrives | Toast: "📦 Đơn hàng mới #12346!" + card prepends with highlight animation | Tap to see |
| ERROR | API failed | "Không tải được đơn hàng. [Thử lại]" | Retry |
| OFFLINE | No network | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached". Cached orders visible (read-only). | Read cached |

---
## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View orders | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View revenue/commission | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Call/message buyer | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Search/filter | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Confirm/update status | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Editor**: Can view all orders and buyer info but cannot change order status. Swipe actions for call/message available.
- **Contributor/Viewer/External**: No access to order list. Bottom nav "Orders" tab hidden for these roles.

---
## 10. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| New orders | Push notification + SSE | Real-time |
| Status changes | SSE `/events/orders` | Real-time |
| Daily summary | Polling | Every 5 minutes |
| Tracking updates | SSE (from carrier webhook) | Real-time |

### Real-time UX
- New order: Toast notification + card appears at top with green highlight pulse (3s)
- Status change: Card moves to new status group with slide animation
- Daily summary: Numbers animate to new values

---
## 11. Mobile-specific UX

### Gestures & Haptics
- **Swipe right on order**: Reveal "📞 Call" action (green background)
- **Swipe left on order**: Reveal "💬 Message" action (blue background)
- **Pull down**: Refresh entire list (haptic light)
- **Long press order**: Copy order number to clipboard (haptic light + toast)
- **Haptic medium**: On new order toast

### Badge & Notifications
- App icon badge shows pending order count
- Push notification groups by platform ("3 đơn TikTok Shop mới")
- Notification tap deep-links to order list with filter pre-set

### Dark Mode
- Full dark mode support
- Status badges maintain same color semantics in dark mode
- Card backgrounds use `surface-container` elevation

### Offline Behavior
- Last fetched order list cached (up to 50 most recent)
- Daily summary cached
- Search disabled offline
- Real-time updates resume on reconnection

---
## 12. Edge Cases

| Edge Case | Handling |
|---|---|
| Order with >10 items | Show first 3 items + "và 7 sản phẩm khác" |
| Buyer phone number hidden by platform | Swipe-right shows "📞 Gọi qua nền tảng" → opens platform app |
| Order from disconnected platform | Show "⚫ Nguồn không kết nối" badge. Actions limited. |
| Duplicate orders (sync issue) | Deduplicate by `platform_order_id`. Show only latest. |
| Very high order volume (>100/day) | Encourage filter usage. Summary still shows totals. |
| Commission rate = 0% (promo) | Show "0% (Miễn phí)" instead of calculated amount |
| Order cancelled by buyer after confirmation | Push: "❌ Đơn #12345 đã bị hủy bởi buyer". Card updates to cancelled status. |

---
## 13. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `orders.list.viewed` | Page opens | `total_count`, `pending_count`, `has_filters` |
| `orders.list.filtered` | Status chip or filter applied | `filter_type`, `filter_value` |
| `orders.list.searched` | Search query | `query`, `results_count` |
| `orders.list.card_tapped` | Order card tap | `order_id`, `status`, `position` |
| `orders.list.swipe_call` | Swipe right → call | `order_id`, `platform` |
| `orders.list.swipe_message` | Swipe left → message | `order_id`, `platform` |
| `orders.list.pull_refreshed` | Pull to refresh | — |
| `orders.notification.tapped` | Push notification tap | `order_id`, `notification_type` |

---
## 14. Performance Requirements

| Metric | Target |
|---|---|
| Open to interactive | < 800ms |
| Pull-to-refresh | < 1s |
| Search latency | < 200ms |
| Card render (20 items) | 60fps scroll |
| Push → deep link open | < 1s |
| Offline cache load | < 200ms |

---
## 15. Flutter Implementation Notes

### Widget Structure
- **Route**: `/orders` → `OrderListPage`
- **State management**: Riverpod `orderListProvider(status_filter)` + `orderStatsProvider`
- **Swipe**: `flutter_slidable` package for reveal actions
- **Pull-to-refresh**: `RefreshIndicator` widget
- **Infinite scroll**: `InfiniteListView` with cursor-based pagination
- **Push**: Firebase Cloud Messaging deep link handler

### Data Fetching
```
onInit:
  Promise.all([
    orderService.list(status: 'all', limit: 20),
    orderService.getDailyStats(),
  ])

onFilterChange(status):
  orderService.list(status: status, limit: 20)

onPullRefresh:
  Promise.all([refetch list, refetch stats])
```

---
## 16. Navigation Map

```
Mobile Order List (/orders)
├── → /orders/[id] (tap order card → Order Detail)
├── → phone dialer (swipe right → call buyer)
├── → platform app / SMS (swipe left → message)
├── → /analytics/commerce (via stats card tap)
├── ← /home (back via bottom nav)
```

---
## 17. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached" | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được đơn hàng. [Thử lại]" | Retry |
| Search failed | Search API error | Toast: "Tìm kiếm thất bại" | Retry search |
| Push deep-link failed | Order not found | Toast: "Đơn hàng không tồn tại" → navigate to order list | — |
| Platform sync error | Connector issue | Banner on affected orders: "⚫ Nguồn không kết nối" | Check diagnostics |
| Confirm order failed | API rejection | Toast: "Không xác nhận được. [Thử lại]" | Retry |

---
## 18. Accessibility

| Element | Requirement |
|---|---|
| Order cards | `Semantics(label: "Đơn 12345, TikTok Shop, 350 ngàn, chờ xử lý, 2 giờ trước")` |
| Status chips | `Semantics(selected:)` on active filter |
| Swipe actions | Also available via long-press context menu |
| Summary stats | `Semantics(label: "Hôm nay 5 đơn, 1.2 triệu, 2 chờ xác nhận")` |
| Urgent banner | `Semantics(liveRegion: true)` |

---
## 19. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + summary shimmer + card shimmers |
| Daily summary | 100-200ms | Numbers animate in |
| Order list | 200-500ms | Cards populate with stagger |
| Status chips | 100ms | Counts populate |
| New order (real-time) | Instant | Card slides in at top with green pulse |

---
## 20. Localization Notes

- Primary language: Vietnamese
- Currency: "350,000đ" (dot separator, đ suffix)
- Order ID: "#12345" format
- Status: "Chờ xử lý", "Đang giao", "Hoàn thành", "Đã hủy", "Trả hàng"
- Time: Relative ("2h ago", "1 ngày trước")
- Revenue: "1.2M VND" (abbreviated)
- Commission: "5% (39,950đ)"

---
## 21. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-order-pending` | Pending status badge (🟡 amber) |
| `--color-order-shipping` | Shipping status badge (🔵 blue) |
| `--color-order-completed` | Completed status badge (🟢 green) |
| `--color-order-cancelled` | Cancelled status badge (🔴 red) |
| `--color-accent` | Search, CTAs |
| `--color-surface-elevated` | Order cards |
| `--color-call` | Call swipe action (green) |
| `--color-message` | Message swipe action (blue) |

---
## 22. Related Screens

| Screen | Relationship |
|---|---|
| [W062] Web Order List | Web equivalent (full table with bulk actions) |
| [M025] Mobile Order Detail | Drill-down from tap |
| [M026] Mobile Products | Product catalog |
| [M001] Mobile Home Dashboard | Pending orders widget |
| [S009] Trust Badge | Source class badge on orders |

---
## 23. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 4.0 | **Structure fix**: Removed duplicate template sections (§6/§11/§12/§13/§16/§18). Added screen-specific Error Handling (6 scenarios), Accessibility with semantic labels, Loading timeline, Localization with order-specific VND formats, Design Tokens with per-status colors. | System |
| 2026-03-28 | 3.0 | Full Tier A rewrite. Added daily summary, component hierarchy, 10 states, RBAC, swipe actions, real-time, edge cases, analytics. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

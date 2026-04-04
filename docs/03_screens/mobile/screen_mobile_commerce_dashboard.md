# Screen: Mobile — Commerce Dashboard

> **Screen ID**: M026
> **Module**: M13 — Product Hub / Commerce
> **Route**: `/commerce` (mobile — via sidebar or quick action)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 02 §Backend Domain, Pack 06 §Commerce, A1 Schema (orders, products, skus, revenue_daily, inventory_locations), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile commerce overview — the "business cockpit" for Seller Mode. Shows today's key commerce KPIs, recent orders requiring action, low-stock alerts, top-selling products, and quick navigation to commerce sub-modules. Designed for the "check sales while on the go" pattern with one-thumb operation.

### User Story
> As a seller, I want to see my today's revenue, pending orders, and stock alerts on mobile so I can respond quickly and avoid missed sales.

### Business Goals
- Enable sub-5-minute response to new paid orders
- Surface low-stock alerts before stockouts occur
- Drive proactive inventory management
- Encourage regular commerce engagement on mobile

### When This Screen Is Used
- **Push notification**: "📦 Đơn hàng mới!" → open app → commerce dashboard
- **Morning check**: Check overnight orders + revenue
- **During live**: Quick revenue check during live selling
- **Stock check**: Before live session or campaign launch

### Entry Points
- Bottom nav → More → "🛍 Kinh doanh" (or tab customization if commerce mode)
- Home Dashboard (M001): Order KPI tap
- Push notification: "📦 Đơn hàng mới!" → deep link `/commerce`
- Quick action chip: "📦 Orders" on home

### Exit Points
- Tap order → Order Detail
- Tap product → Product Detail
- "Xem tất cả đơn hàng" → Order List
- "Sản phẩm" → Product List
- "Khuyến mãi" → Offer List
- Low stock alert → Product Detail with inventory tab

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `order:read` or `product:read` permission
- At least one connected commerce platform (Shopee, TikTok Shop, Lazada) OR manual product catalog
- Active operator mode includes Seller, Live Operator, or Affiliate

### Postconditions
- Dashboard viewed event logged
- Order confirmations processed → reflected in order status
- Stock alerts acknowledged → dismiss state persisted

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ──────────────────────────────────────────────────────┐
│ ← 🛍 Kinh doanh                            [Period: Hôm nay ▾]  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ KPIs (horizontal scroll) ────────────────────────────────────┐  │
│ │ ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐      │  │
│ │ │ 💰 12.5M  │ │ 📦 8      │ │ 📊 6.8%   │ │ ⚠️ 3      │      │  │
│ │ │ Doanh thu │ │ Đơn hàng  │ │ Chuyển đổi│ │ Sắp hết   │      │  │
│ │ │ ↑+22%     │ │ ↑+5 today │ │ ↑+1.2pp   │ │ Cần nhập  │      │  │
│ │ └───────────┘ └───────────┘ └───────────┘ └───────────┘      │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Pending Actions ──────────────────────────────────────────────┐  │
│ │ ⚠️ 3 hành động cần xử lý:                                     │  │
│ │ 📦 2 đơn hàng chờ xác nhận                    [Xử lý ngay →] │  │
│ │ 💬 1 tranh chấp cần phản hồi                  [Xem →]        │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Recent Orders ────────────────────────────────────────────────┐  │
│ │ 📦 #TK-1256 · Serum VitC · 299K · 10 phút ←    [🟢 Đã TT]   │  │
│ │ 📦 #TK-1255 · Moisturizer · 450K · 2 giờ ←    [📦 Giao]      │  │
│ │ 📦 #TK-1254 · Combo Set · 650K · 5 giờ ←      [✅ Hoàn thành]│  │
│ │ 📦 #TK-1253 · Toner · 199K · 8 giờ ←          [⏳ Chờ xác nhận]│ │
│ │ [→ Xem tất cả đơn hàng (42)]                                   │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Low Stock Alerts ─────────────────────────────────────────────┐  │
│ │ 🔴 Serum VitC 30ml — 5 còn lại (ngưỡng: 10)     [→ Xem]      │  │
│ │ 🟡 Moisturizer 50ml — 8 còn lại (ngưỡng: 10)   [→ Xem]       │  │
│ │ 🔴 Son môi đỏ — 2 còn lại (ngưỡng: 5)          [→ Xem]       │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Top Products (7 ngày) ────────────────────────────────────────┐  │
│ │ 🏆 By revenue                                                   │  │
│ │ 1. [🖼] Serum VitC 30ml — 42 sold — 12.5M VND                 │  │
│ │ 2. [🖼] Combo Pack — 18 sold — 11.7M VND                      │  │
│ │ 3. [🖼] Moisturizer — 31 sold — 7.8M VND                      │  │
│ │ [→ Xem tất cả sản phẩm]                                        │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Quick Nav ────────────────────────────────────────────────────┐  │
│ │ [📦 Đơn hàng] [🛍 Sản phẩm] [🏷 Khuyến mãi] [📋 Tồn kho]   │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                         │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
CommerceDashboardPage
├── AppBar
│   ├── BackButton
│   ├── Title ("🛍 Kinh doanh")
│   └── PeriodSelector (Today/7d/30d dropdown)
├── ScrollableContent (pull-to-refresh)
│   ├── KPIScroller (horizontal ListView)
│   │   └── KPIMiniCard[] (4 cards)
│   │       ├── MetricIcon (💰/📦/📊/⚠️)
│   │       ├── MetricValue (AnimatedCount)
│   │       ├── MetricLabel
│   │       ├── TrendDelta (↑↓, color-coded)
│   │       └── TapAction (navigate to respective detail)
│   ├── PendingActionsCard (conditional — visible if > 0)
│   │   ├── ActionCount ("3 hành động cần xử lý")
│   │   └── ActionItem[]
│   │       ├── ActionIcon + Description
│   │       └── ActionButton ("Xử lý ngay →")
│   ├── RecentOrdersSection
│   │   ├── SectionHeader ("Đơn hàng gần đây")
│   │   └── OrderRow[] (latest 5, tappable)
│   │       ├── OrderIcon (📦)
│   │       ├── OrderId (#TK-1256)
│   │       ├── ProductName (truncated)
│   │       ├── Amount (VND)
│   │       ├── RelativeTime
│   │       └── StatusBadge (🟢 Paid / 📦 Shipped / ✅ Done / ⏳ Pending)
│   │   └── ViewAllLink ("→ Xem tất cả (42)")
│   ├── LowStockAlertSection (conditional — visible if alerts > 0)
│   │   ├── SectionHeader ("⚠️ Cảnh báo tồn kho")
│   │   └── AlertRow[]
│   │       ├── SeverityDot (🔴 critical / 🟡 warning)
│   │       ├── ProductName + Variant
│   │       ├── StockInfo ("5 còn lại" + threshold)
│   │       └── ViewButton ("→ Xem")
│   ├── TopProductsSection
│   │   ├── SectionHeader ("🏆 Sản phẩm bán chạy — 7 ngày")
│   │   └── ProductRow[] (top 3)
│   │       ├── RankNumber (1-3)
│   │       ├── Thumbnail
│   │       ├── ProductName
│   │       ├── SoldCount
│   │       └── RevenueAmount
│   │   └── ViewAllLink
│   └── QuickNav (horizontal buttons)
│       ├── OrdersButton
│       ├── ProductsButton
│       ├── OffersButton
│       └── InventoryButton
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Revenue (period) | `SUM(revenue_daily)` | `CommerceService/GetDashboard(period)` | "12.5M" (abbreviated VND) | 5m TTL |
| Order count | `COUNT(orders WHERE date IN period)` | same | Integer + delta | 5m TTL |
| Conversion rate | `orders / total_sessions × 100` | same | "6.8%" + trend | 5m TTL |
| Low stock count | `COUNT(skus WHERE stock < threshold)` | same | Integer | 5m TTL |
| Pending actions | Computed: unconfirmed orders + open disputes | same | List items | 2m TTL |
| Recent orders | `orders ORDER BY created_at DESC LIMIT 5` | `OrderService/ListRecent(5)` | Order rows | Real-time (SSE) |
| Low stock alerts | `skus WHERE stock < threshold` | `InventoryService/GetAlerts` | Alert rows | 10m TTL |
| Top products | `products ORDER BY revenue DESC LIMIT 3` | `CommerceService/GetTopProducts(period, 3)` | Product rows | 15m TTL |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | View order detail | Tap order row | — | — | Push → Order Detail | `order:read` |
| 2 | View all orders | Tap "Xem tất cả đơn hàng" | — | — | Push → Order List | `order:read` |
| 3 | Confirm order | Tap pending action → "Xử lý" | `OrderService/Confirm(id)` | `order.status = confirmed` | Toast "✅ Đã xác nhận" + row updates | `order:manage` |
| 4 | View product detail | Tap product row | — | — | Push → Product Detail | `product:read` |
| 5 | View all products | Tap "Sản phẩm" quick nav | — | — | Push → Product List | `product:read` |
| 6 | View low stock product | Tap stock alert row | — | — | Push → Product Detail → Inventory tab | `product:read` |
| 7 | View offers | Tap "Khuyến mãi" quick nav | — | — | Push → Offer List | `offer:read` |
| 8 | View inventory | Tap "Tồn kho" quick nav | — | — | Push → Inventory screen | `product:read` |
| 9 | Change period | Period dropdown | Refetch with new period | — | KPIs + top products update | `order:read` |
| 10 | Pull to refresh | Pull-down gesture | Refetch all | — | All sections refresh. Haptic light. | `order:read` |
| 11 | Respond to dispute | Tap dispute action | — | — | Push → Dispute Detail | `order:manage` |

---

## 7. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial page load | Shimmer KPIs + skeleton order list | Wait |
| LOADED | Data available | Full dashboard with animated KPI counters | Normal interactions |
| EMPTY | No commerce data (no products/orders) | Empty state: "🛍 Chưa có sản phẩm nào. [Thêm sản phẩm đầu tiên →]" | Create products |
| NO_COMMERCE | User has no commerce platforms connected | "Kết nối Shopee/TikTok Shop để bắt đầu bán hàng. [Kết nối →]" | Connect platform |
| HAS_PENDING | Unconfirmed orders exist | Pending Actions card highlighted with orange border | Process orders |
| LOW_STOCK_CRITICAL | Stock at 0 for any SKU | Red alert banner at top: "🔴 3 sản phẩm đã hết hàng!" | Restock |
| REFRESHING | Pull-to-refresh | Refresh indicator | Wait |
| ERROR | API failure | "Không tải được dữ liệu kinh doanh. [Thử lại]" | Retry |
| OFFLINE | No network | Banner: "📡 Ngoại tuyến — dữ liệu có thể chưa cập nhật" + cached data | Read cached |

---

## 8. Validation Rules

N/A — Read-only dashboard with navigation actions only. Order confirmation requires in-context confirmation dialog.

---

## 9. Permission Matrix

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View commerce dashboard | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View revenue KPI | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| View orders | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Confirm orders | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| View stock alerts | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View top products | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Editor**: Revenue KPI hidden. Shows 3-card KPI row.
- **Contributor/Viewer/External**: No access to commerce dashboard.

---

## 10. Operator Mode Variations

| Mode | Visible Sections | Hidden |
|---|---|---|
| Seller | All sections visible | — |
| Live Operator | All + "Đang live" revenue counter | — |
| Affiliate | Affiliate revenue + commission KPI | Orders (replaced by Referrals), Inventory |
| Creator (no commerce) | Screen hidden from nav | — |

---

## 11. Navigation Map

```
Commerce Dashboard (/commerce)
├── → /commerce/orders           (via "Đơn hàng" or "Xem tất cả")
├── → /commerce/orders/[id]      (via tap order row)
├── → /commerce/products         (via "Sản phẩm")
├── → /commerce/products/[id]    (via tap product row or stock alert)
├── → /commerce/offers           (via "Khuyến mãi")
├── → /commerce/inventory        (via "Tồn kho")
├── → /commerce/disputes/[id]    (via dispute action)
└── ← / (Home)                  (via back or bottom nav)
```

---

## 12. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network error | No connectivity | "📡 Ngoại tuyến" banner + show cached data | Pull-to-refresh when online |
| API error (5xx) | Server failure | "Không tải được. [Thử lại]" | Retry button |
| Order confirm failed | Platform API error | Toast: "Không xác nhận được đơn hàng. Thử lại." | Retry |
| Stale data | Data > 30m old | Subtle banner: "Cập nhật 45 phút trước. [Làm mới]" | Refresh |

---

## 13. Accessibility

| Element | Requirement |
|---|---|
| KPI cards | `Semantics(label: "Doanh thu hôm nay: 12 triệu 5 trăm nghìn đồng, tăng 22 phần trăm")` |
| Order rows | `Semantics(label: "Đơn hàng TK-1256, Serum VitC, 299 nghìn đồng, 10 phút trước, đã thanh toán")` |
| Stock alerts | `Semantics(label: "Cảnh báo: Serum VitC 30ml, còn 5 sản phẩm, ngưỡng 10")` |
| Status badges | Color not sole indicator — text label required |
| Interactive elements | Minimum 48×48dp tap targets |
| Pending actions | `Semantics(liveRegion: true)` for urgency |

---

## 14. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + KPI shimmer |
| KPI data | 200-500ms | KPI counters animate up (600ms duration) |
| Recent orders | 300-600ms | Order rows populate with staggered fade-in |
| Stock alerts | 300-600ms | Alert rows populate |
| Top products | 400-800ms | Product rows with thumbnails |
| Pull-to-refresh | <2s | All sections refresh |

---

## 15. Performance Requirements

| Metric | Target |
|---|---|
| Screen render | <1.5s |
| KPI animation | 60fps |
| Pull-to-refresh | <2s |
| Order row render | <100ms per row |
| Thumbnail load | <500ms with placeholder |

---

## 16. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| New orders | Push notification + SSE `/events/orders` | Real-time |
| Order status changes | SSE | Real-time |
| Revenue (today) | Polling | Every 5 minutes |
| Stock levels | Polling | Every 10 minutes |

### Real-time UX
- **New order**: Order KPI pulses (scale animation). New row slides in at top of Recent Orders.
- **Order status change**: Row badge updates with subtle flash.
- **Stock alert**: New alert appears with red highlight pulse.

---

## 17. Mobile-specific UX

### Gestures & Haptics
| Gesture | Target | Haptic | Result |
|---|---|---|---|
| Pull down | Whole page | Light | Refresh all |
| Tap KPI | KPI card | Light | Navigate to detail |
| Tap order row | Order row | Light | Push → Order Detail |
| Long press order | Order row | Heavy | Context menu (Confirm / Cancel / View) |
| Swipe left on order | Order row | Medium | Quick confirm (⏳ Pending only) |

### Offline Behavior
- **Cached**: KPIs, recent orders, stock alerts, top products
- **Not cached**: Real-time order updates, new stock movements
- **Behavior**: Show cached data + yellow offline banner

---

## 18. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `commerce.dashboard.viewed` | Page load | `period`, `order_count`, `revenue`, `low_stock_count` |
| `commerce.order.tapped` | Tap order row | `order_id`, `status` |
| `commerce.order.confirmed` | Quick confirm | `order_id`, `time_to_confirm` |
| `commerce.stock_alert.tapped` | Tap stock alert | `sku_id`, `stock_remaining` |
| `commerce.product.tapped` | Tap top product | `product_id`, `rank` |
| `commerce.quick_nav.tapped` | Tap quick nav button | `destination` |
| `commerce.period.changed` | Change period | `old_period`, `new_period` |

---

## 19. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Primary CTAs, period selector |
| `--color-success` | Positive revenue growth (↑), paid status (🟢) |
| `--color-warning` | Low stock warning (🟡), pending status (⏳) |
| `--color-danger` | Out of stock (🔴), critical alerts |
| `--color-surface-elevated` | KPI cards, order rows, alert cards |
| `--color-text-primary` | Amounts, titles |
| `--color-text-secondary` | Timestamps, labels |

---

## 20. Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, abbreviated: "12.5M")
- Full format in detail: "12.500.000₫"
- Order IDs: Keep platform format (#TK-1256)
- Relative time: "10 phút trước", "2 giờ trước"
- Status labels: "Đã thanh toán", "Đang giao", "Hoàn thành", "Chờ xác nhận"
- Percentages: "6.8%", trend: "↑+22%"

---

## 21. Related Screens

| Screen | Relationship |
|---|---|
| [W060] Web Product List | Web equivalent (full grid + charts) |
| [M027] Mobile Orders | Full order list |
| [M028] Mobile Products | Full product catalog |
| [M029] Mobile Offers | Active promotions |
| [M001] Mobile Home Dashboard | Order KPI links here |
| [W075a] Web Inventory Management | Web inventory management |

---

## 22. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 2.0 | **Full Tier A rewrite** from sparse 220-line Tier C. Fixed Screen ID (M30→M030). Added complete 22-section structure: expanded wireframe with KPIs/pending actions/orders/stock alerts/top products/quick nav, full component hierarchy, specific data binding (not template), 11 user actions with actual API calls, 9 states, full RBAC matrix, operator mode variations, navigation map, error handling, accessibility with semantic labels, loading timeline, performance targets, real-time updates with push notifications, mobile gestures/offline behavior, 7 tracking events, design tokens, localization rules. Replaced ALL template placeholders. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

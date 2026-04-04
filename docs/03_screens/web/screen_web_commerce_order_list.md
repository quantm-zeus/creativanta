# Screen: Web — Order Management

> **Screen ID**: W062
> **Module**: M13 — Product Hub / Inventory / Order
> **Route**: `/orders`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §22, A1 Schema (orders, order_items, refunds, buyers, connectors), B5 RBAC §2.7

---
## 1. Purpose & Context

Cross-platform order list that aggregates all orders synced from TikTok Shop, Shopee, Lazada, and direct store channels into one unified view. Provides daily summary statistics, advanced filtering, full-text search, real-time new order notifications, bulk export, and buyer contact integration. This is the primary operational screen for seller-mode creators.

### User Goals
- View all orders from every platform in one place (eliminating tab-switching between platform dashboards)
- Quickly triage new/pending orders requiring action (confirm, ship, resolve)
- Track daily revenue and order volume
- Search and filter orders by platform, status, date range, or buyer name
- Export order data for accounting/tax

### Business Goals
- Centralize order management to justify platform subscription value
- Reduce time-to-action on pending orders (target: < 15 minutes average)
- Enable data-driven selling decisions through order analytics
- Drive engagement with buyer contact and commerce features

### When This Screen Is Used
- **Morning triage**: Seller opens app → checks new overnight orders
- **During live sales**: Real-time monitoring of incoming orders
- **End of day**: Review daily totals, export for bookkeeping
- **Ad-hoc**: Search for specific order to track status or resolve issue

### Entry Points
- Sidebar: "📦 Đơn hàng" under Commerce section
- Home Dashboard (W001): order alert click / Order KPI click
- Notification: new order push notification
- Direct URL: `/orders`
- From buyer profile: "See buyer's orders"
- From product detail: "See orders for this product"

### Exit Points
- Click order row → Order Detail (W062)
- Click "💬 Contact" → Unified Inbox with buyer context
- Click "↩ Refund" → Refund Management (W067)
- Click "📊 Analytics" → Commerce Analytics
- Export → CSV/Excel download

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `order:read` permission (Owner/Admin/Manager; Editor with commerce access)
- At least one commerce platform connected (TikTok Shop, Shopee, Lazada, or Direct)
- Orders synced from platform APIs (sync runs every 15 minutes)

### Postconditions
- Order list view event logged for analytics
- Filters persisted in URL query params (bookmarkable/shareable)
- Export operation logged in workspace audit trail

---
## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + full-width order list with all columns visible |
| Tablet (768-1279px) | Collapsed sidebar (64px) + order list (commission column hidden) |
| Mobile (≤767px) | Redirect to M024 Mobile Order List |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 📦 Đơn hàng                [⟳ Sync now] [📥 Export ▾] [⚙ Settings] │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Quick Stats Bar (full width) ─────────────────────────────────┐  │
│ │ 📦 Hôm nay: 12 mới (+5 vs hôm qua)                            │  │
│ │ 💰 Doanh thu: 5.2M VND (+18%)                                  │  │
│ │ ✅ Đã giao: 8 · 🚚 Đang giao: 3 · ↩ Hoàn: 1                  │  │
│ │ 🔄 Synced: 5 phút trước · [→ Xem analytics]                   │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Filters ──────────────────────────────────────────────────────┐  │
│ │ [Platform ▾] [Status ▾] [Date range 📅] [🔍 Tìm đơn hàng...]  │  │
│ │ Active: 🎵 TikTok Shop · ● [Xóa bộ lọc]                      │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Order Table ──────────────────────────────────────────────────┐  │
│ │ [☐] Mã đơn    Khách hàng    Nền tảng   Sản phẩm           │  │
│ │          Tổng tiền    Trạng thái    Ngày đặt    Thao tác       │  │
│ ├────────────────────────────────────────────────────────────────┤  │
│ │ [☐] #TK-1234  Nguyễn A  🎵 TikTok  Serum VitC ×2            │  │
│ │          598,000đ     🟢 Đã giao    25/03       [→] [💬] [⋮]  │  │
│ │     Ordered: 25/3 · Delivered: 27/3 · Commission: 59,800đ     │  │
│ │                                                                  │  │
│ │ [☐] #SP-5678  Lê Hoa    🛍 Shopee   Kem chống nắng ×1        │  │
│ │          199,000đ     🚚 Đang giao   27/03       [→] [💬] [⋮] │  │
│ │     Ordered: 27/3 · Est. delivery: 29/3                        │  │
│ │                                                                  │  │
│ │ [☐] #TK-9012  Trần B    🎵 TikTok  Toner ×1 + Serum ×1      │  │
│ │          420,000đ     ⏳ Chờ xác nhận 27/03      [→] [💬] [⋮]  │  │
│ │     ⚡ MỚI — Đặt 2 phút trước                                  │  │
│ │                                                                  │  │
│ │ ···  more rows  ···                                              │  │
│ ├────────────────────────────────────────────────────────────────┤  │
│ │ Showing 1-20 of 347 orders     [← Prev] [1] [2] ... [18] [→]  │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Bulk Actions (conditional — appears when rows checked) ───────┐  │
│ │ ☑ 3 đơn đã chọn   [📥 Export] [📦 Mark shipped] [🗑 Cancel]   │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
OrderManagementPage
├── AppShell (shared)
├── PageHeader
│   ├── Title ("📦 Đơn hàng")
│   ├── SyncButton ("⟳ Sync now" — manual trigger)
│   ├── ExportDropdown
│   │   ├── ExportCSV
│   │   ├── ExportExcel
│   │   └── ExportPDF
│   └── SettingsButton (→ order sync settings)
├── QuickStatsBar (full width)
│   ├── TodayNewOrders ("12 mới" + delta vs yesterday)
│   ├── TodayRevenue ("5.2M VND" + delta %)
│   ├── StatusBreakdown ("✅ 8 · 🚚 3 · ↩ 1")
│   ├── LastSyncTime ("5 phút trước")
│   └── AnalyticsLink ("→ Xem analytics")
├── FilterBar
│   ├── PlatformFilter (multi-select: TikTok, Shopee, Lazada, Direct)
│   ├── StatusFilter (multi-select: Pending, Confirmed, Shipping, Delivered, etc.)
│   ├── DateRangeFilter (preset: Today, 7d, 30d, Custom)
│   ├── SearchInput ("Tìm đơn hàng..." — order ID, buyer name, product)
│   └── ActiveFilterBadge (shows active filters + clear button)
├── OrderTable
│   ├── TableHeader (sortable columns)
│   │   ├── SelectAllCheckbox
│   │   ├── OrderID (sortable)
│   │   ├── Buyer (sortable)
│   │   ├── Platform
│   │   ├── Products
│   │   ├── Total (sortable)
│   │   ├── Status (sortable)
│   │   ├── OrderDate (sortable, default: desc)
│   │   └── Actions
│   └── OrderRow[] (paginated, 20 per page)
│       ├── SelectCheckbox
│       ├── OrderNumber (platform prefix + ID)
│       ├── BuyerName
│       ├── PlatformBadge (icon + name)
│       ├── ProductSummary ("Product × quantity", expandable if multi-item)
│       ├── TotalAmount (formatted VND)
│       ├── StatusBadge (icon + label + color)
│       ├── OrderDate (dd/MM format)
│       ├── NewBadge (conditional — "⚡ MỚI" for orders < 1h old)
│       ├── ExpandableDetail (conditional row expansion)
│       │   ├── OrderTimeline (Ordered → Confirmed → Shipped → Delivered)
│       │   ├── CommissionInfo
│       │   ├── ShippingInfo (carrier, tracking)
│       │   └── BuyerNote (if any)
│       └── ActionButtons
│           ├── ViewDetailButton ("→" → W062)
│           ├── ContactBuyerButton ("💬" → Inbox with buyer context)
│           └── MoreMenu ("⋮")
│               ├── ConfirmOrder (if status=pending)
│               ├── MarkShipped (if status=confirmed)
│               ├── InitiateRefund (→ W067)
│               ├── PrintLabel
│               ├── ViewOnPlatform (external link)
│               └── CopyOrderID
├── PaginationBar
│   ├── ShowingCount ("1-20 of 347")
│   └── PageButtons
└── BulkActionBar (conditional — shown when ≥1 row selected)
    ├── SelectedCount ("3 đơn đã chọn")
    ├── BulkExportButton
    ├── BulkMarkShippedButton
    └── BulkCancelButton
```

---
## 5. Displayed Data

| Element | Source | API | Display Format | Cache |
|---|---|---|---|---|
| Order ID | `orders.platform_order_id` | `OrderService/List(filters, page)` | "#TK-1234" (platform prefix) | 5m |
| Buyer name | `orders.buyer_name` (denormalized) | same | Full name | 5m |
| Platform | `orders.source_platform` | same | Icon + name | 5m |
| Products | `order_items JOIN products` | same | "Product × qty" (truncated) | 5m |
| Total | `orders.total_amount` | same | "598,000đ" (VND with dot separator) | 5m |
| Status | `orders.status` | same | Status badge (icon + label + color) | 5m |
| Order date | `orders.ordered_at` | same | "25/03" or "25/03/2026" (if not current year) | 5m |
| Delivery date | `orders.delivered_at` or `orders.estimated_delivery` | same | "27/3" or "Est: 29/3" | 5m |
| Commission | `orders.platform_commission` | same | "59,800đ" | 5m |
| Today new count | `COUNT(orders WHERE date=today)` | `OrderService/GetTodayStats` | "12 mới" with delta | 2m |
| Today revenue | `SUM(orders.total WHERE date=today)` | same | "5.2M VND" with delta % | 2m |
| Status breakdown | `GROUP BY status WHERE date=today` | same | "✅ 8 · 🚚 3 · ↩ 1" | 2m |
| Last sync | `connectors.last_sync_at` | `ConnectorService/GetSyncStatus` | "5 phút trước" (relative) | 1m |

### Order Status Visual Map

| Status | Icon | Label | Color | Background |
|---|---|---|---|---|
| Pending | ⏳ | Chờ xác nhận | Orange | `--color-warning-light` |
| Confirmed | ✅ | Đã xác nhận | Blue | `--color-info-light` |
| Shipping | 🚚 | Đang giao | Yellow | `--color-warning-light` |
| Delivered | 📦 | Đã giao | Green | `--color-success-light` |
| Completed | ✅ | Hoàn thành | Dark green | `--color-success-dark` |
| Cancelled | ❌ | Đã hủy | Gray | `--color-neutral-light` |
| Return_requested | ↩ | Yêu cầu hoàn | Red-orange | `--color-danger-light` |
| Refunded | 🔄 | Đã hoàn tiền | Red | `--color-danger` |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | View order detail | Click row or "→" button | Navigate | — | → `/orders/[id]` (W062) | `order:read` |
| 2 | Contact buyer | Click "💬" | Navigate | — | → `/inbox?entity_type=buyer&entity_id=[buyer_id]` | `thread:read` |
| 3 | Confirm order | Row menu "Confirm" | Action | `OrderService/UpdateStatus(id, 'confirmed')` | Status badge updates. Toast "✅ Đã xác nhận." | `order:manage` |
| 4 | Mark shipped | Row menu "Mark shipped" | Action | Modal: enter tracking number → `OrderService/UpdateStatus(id, 'shipping', tracking)` | Status badge updates. Toast "🚚 Đã đánh dấu giao." | `order:manage` |
| 5 | Initiate refund | Row menu "Initiate refund" | Navigate | — | → `/orders/[id]/refund` (W067) | `order:manage` |
| 6 | Print shipping label | Row menu "Print label" | Action | `OrderService/GetLabel(id)` | PDF opens in new tab | `order:manage` |
| 7 | View on platform | Row menu "View on platform" | External | — | Opens platform order page in new tab | `order:read` |
| 8 | Copy order ID | Row menu "Copy ID" | Clipboard | — | Toast "Đã copy mã đơn" | `order:read` |
| 9 | Filter by platform | Platform dropdown | Filter | `OrderService/List(platform=...)` | Table updates, active filter badge shown | `order:read` |
| 10 | Filter by status | Status dropdown | Filter | `OrderService/List(status=...)` | Table updates | `order:read` |
| 11 | Filter by date | Date range picker | Filter | `OrderService/List(from, to)` | Table updates | `order:read` |
| 12 | Search | Type in search box (debounced 300ms) | Search | Meilisearch query | Results update live | `order:read` |
| 13 | Clear filters | Click "Xóa bộ lọc" | Reset | `OrderService/List()` | All filters removed, full list | `order:read` |
| 14 | Sort column | Click column header | Sort | `OrderService/List(sort, order)` | Table re-sorts. Arrow indicator on column. | `order:read` |
| 15 | Select row(s) | Click checkbox | Select | — | Bulk action bar appears | `order:read` |
| 16 | Select all | Click header checkbox | Select | — | All visible rows selected | `order:read` |
| 17 | Bulk export | "📥 Export" in bulk bar | Export | Client-side CSV generation | File downloads | `order:read` |
| 18 | Bulk mark shipped | "📦 Mark shipped" in bulk bar | Action | Confirmation dialog → `OrderService/BulkUpdateStatus` | Statuses update. Toast "{n} đơn đã giao." | `order:manage` |
| 19 | Bulk cancel | "🗑 Cancel" in bulk bar | Destructive | Confirmation dialog (type "CANCEL") → `OrderService/BulkCancel` | Status updates. Toast "{n} đơn đã hủy." | `order:manage` |
| 20 | Manual sync | Click "⟳ Sync now" | Action | `ConnectorService/SyncOrders()` | Toast "Đang đồng bộ..." → "Đã đồng bộ {n} đơn mới." | `order:manage` |
| 21 | Export all | "📥 Export ▾" in page header | Export | Server-side export | Download CSV/Excel/PDF | `order:read` |
| 22 | Expand row | Click row expand icon | Expand | — | Row expands to show timeline + commission + shipping | `order:read` |

---
## 7. Validation Rules

### Confirm Order
| Check | Rule | Error |
|---|---|---|
| Status | Must be "pending" | "Đơn này không ở trạng thái chờ xác nhận" |

### Mark Shipped
| Check | Rule | Error |
|---|---|---|
| Status | Must be "confirmed" | "Chỉ xác nhận giao cho đơn đã duyệt" |
| Tracking | Optional but recommended | Warning: "Bạn chưa nhập mã vận chuyển. Tiếp tục?" |

### Bulk Cancel
| Check | Rule | Error |
|---|---|---|
| Status | Only pending/confirmed can be cancelled | "Không thể hủy đơn đã giao hoặc đang giao" |
| Confirmation | Type "CANCEL" to confirm | Input validation |

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial page load | Table skeleton rows + stats bar shimmer | Wait |
| LOADED | Data received | Full order table with quick stats | Normal interactions |
| EMPTY | No orders at all | "📦 Chưa có đơn hàng. Kết nối TikTok Shop hoặc Shopee để đồng bộ." + connect CTA | Connect platforms |
| EMPTY_FILTERED | Filters applied but no match | "Không tìm thấy đơn hàng phù hợp. [Xóa bộ lọc]" | Clear filters |
| SYNCING | Manual sync in progress | Sync button spinner + "Đang đồng bộ..." toast | Wait |
| NEW_ORDER | Real-time new order arrives | Row slides in at top with highlight glow (3s). Stats update. | View new order |
| BULK_SELECTED | Rows checked | Bulk action bar slides in at bottom | Bulk actions |
| SEARCHING | Search in progress | Search input spinner | Wait |
| EXPORTING | Export in progress | "Đang xuất dữ liệu..." overlay | Wait |
| ERROR | API failed | "❌ Không tải được đơn hàng. [Thử lại]" | Retry |

---
## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View order list | ✅ | ✅ | ✅ | ⚠ Commerce Editor only | ❌ | ❌ | ❌ |
| View revenue/totals | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Commission visible | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Confirm order | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Mark shipped | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Initiate refund | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Bulk actions | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Export | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Contact buyer | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Manual sync | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Editor (with commerce access)**: Can view order list but without revenue, commission, totals. Cannot take actions (confirm/ship/refund). Read-only view of status and product info.
- **Contributor/Viewer/External**: No access. Sidebar item hidden.

---
## 10. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| New orders | SSE `/events/orders` | Real-time — new order slides in at top |
| Order status change | SSE `/events/orders` | Real-time — status badge updates |
| Quick stats | Polling + SSE-driven invalidation | Every 2 minutes + on new order |
| Sync status | SSE `/events/sync` | Real-time during active sync |

### Real-time UX
- **New order**: Row slides in from top with highlight glow pulse (yellow → transparent, 3s). Counter in stats bar increments with animation.
- **Status change (from platform sync)**: Status badge morphs (color transition 300ms).
- **Sync completion**: Stats bar refreshes, toast "🔄 Đã đồng bộ {n} đơn mới."

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| No platforms connected | Empty state: "Kết nối ít nhất 1 nền tảng thương mại. [→ Kết nối TikTok Shop] [→ Kết nối Shopee]" |
| Platform sync fails | Toast: "⚠️ Không đồng bộ được từ {platform}. Đơn hàng có thể không cập nhật." + last known sync time shown |
| Order from disconnected platform | Show order normally but with "⚡ Nền tảng ngắt kết nối — dữ liệu có thể không cập nhật" badge |
| Very old orders (>90 days) | Paginate but show date prominently: "25/12/2025" |
| Duplicate order ID (across platforms) | Prefix ensures uniqueness: "#TK-1234" vs "#SP-1234" |
| 1000+ orders | Server-side pagination (20/page). Meilisearch for search. |
| Buyer name empty | Show "Khách hàng ẩn danh" in italic |
| Multi-item order (5+ products) | Show first 2 + "(+3 sản phẩm)" — expand row for full list |
| Refund in progress | Show "↩ Đang xử lý hoàn tiền" status with yellow-red badge |
| Commission = 0 | Show "0đ" (don't hide) — transparency |

---
## 12. Accessibility

| Element | Requirement |
|---|---|
| Table | `role="table"`, `aria-label="Danh sách đơn hàng"` |
| Status badges | Color + icon + text (not color-only) |
| Keyboard | Tab through table rows, Enter to expand/view, Space to select |
| Screen reader | All icons have `aria-label`. Status read as "Trạng thái: Đã giao" |
| Bulk actions | `aria-live="polite"` on bulk bar appearance |

---
## 13. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `orders.viewed` | Page load | `filter_platform`, `filter_status`, `total_count` |
| `orders.filtered` | Apply filter | `filter_type`, `filter_value` |
| `orders.searched` | Search typed | `query_length`, `results_count` |
| `orders.detail_viewed` | Click order row | `order_id`, `platform`, `status` |
| `orders.status_changed` | Confirm/ship/cancel action | `order_id`, `old_status`, `new_status` |
| `orders.exported` | Export action | `format` (csv/excel/pdf), `count`, `filters_active` |
| `orders.bulk_action` | Bulk action performed | `action`, `count` |
| `orders.synced` | Manual sync triggered | `platform`, `result_count` |
| `orders.buyer_contacted` | Contact buyer clicked | `order_id`, `buyer_id` |

---
## 14. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (first table rows visible) |
| TTI | < 2.0s |
| Table render (20 rows) | < 200ms |
| Search response | < 300ms (via Meilisearch) |
| Filter change | < 500ms |
| Export (1000 orders) | < 5s |
| Real-time new order render | < 500ms from SSE event |

---
## 15. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/orders/+page.svelte`
- **Server load**: `+page.server.ts` → fetch initial orders with default filters
- **Pagination**: URL-based (`?page=2&status=pending&platform=tiktok`)
- **Search**: Debounced (300ms) → Meilisearch index `orders`
- **Real-time**: SSE setup in `onMount` for `/events/orders`

### Data Fetching
```
+page.server.ts:
  Promise.all([
    orderService.list({ ...filters, page, limit: 20 }),
    orderService.getTodayStats(),
    connectorService.getSyncStatus()
  ])
```

### Sort & Filter URL Strategy
```
/orders?platform=tiktok&status=shipping&sort=total&order=desc&page=2

// All filter state in URL → bookmarkable, shareable, back-button works
```

---
## 16. Navigation Map

```
Order List (/orders)
├── → /orders/[id] (via click row → W062)
├── → /orders/[id]/refund (via refund action → W067)
├── → /inbox?entity_type=buyer&entity_id=[id] (via contact buyer)
├── → /analytics/commerce (via stats "Xem analytics")
├── → /settings/connectors (via empty state connect CTA)
```

---
## 17. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Full-page degraded banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached" + stale orders visible (read-only) | Auto-retry when online |
| API error (5xx) | Server failure | Error banner: "Không tải được đơn hàng. [Thử lại]" | Retry button |
| Search failed | Meilisearch down | Fallback to basic SQL query. Toast: "Tìm kiếm nâng cao không khả dụng" | Automatic fallback |
| Platform sync error | Connector issue | Banner: "⚠️ Không đồng bộ được từ {platform}. Đơn hàng có thể chưa cập nhật." | Retry sync |
| Bulk action partial failure | Some items failed | Toast: "Đã xử lý {success}/{total}. {failed} thất bại. [Xem chi tiết]" | Retry failed |
| Export failed | Large dataset timeout | Toast: "Xuất dữ liệu thất bại. Thử thu hẹp bộ lọc." | Apply filters + retry |

---
## 18. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | App Shell + QuickStatsBar shimmer + table skeleton (20 rows) |
| Server data (SSR) | 200-500ms | Stats bar populates → table rows animate in with stagger |
| Search results | < 300ms | Table rows swap with crossfade |
| Filter change | < 500ms | Table rows fade out → new rows fade in |
| Real-time new order | Instant | Row slides in from top with yellow highlight glow (3s) |
| Export generation | 2-5s | Progress indicator in export button |

---
## 19. Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "1.200.000đ")
- Compact format: "45M" for stats bar amounts
- Order ID: Platform-prefixed "#TK-1234" / "#SP-5678"
- Date: DD/MM/YYYY
- Numbers: dot separator (1.234)
- Status labels: "Đã thanh toán", "Đang giao", "Hoàn thành", "Đã hủy", "Đang xử lý hoàn tiền"
- Relative time: "2 giờ trước", "1 ngày trước"
- Tone: Professional, action-oriented

---
## 20. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-order-pending` | Pending payment status (🟡 amber) |
| `--color-order-paid` | Paid/confirmed status (🔵 blue) |
| `--color-order-shipping` | Shipping in progress (🟠 orange) |
| `--color-order-completed` | Completed status (🟢 green) |
| `--color-order-cancelled` | Cancelled status (🔴 red) |
| `--color-order-refunding` | Refund in progress (🟡 yellow-red) |
| `--color-accent` | Primary CTAs (Export, Sync) |
| `--color-surface-elevated` | Table rows on hover, stats cards |
| `--color-text-primary` | Order IDs, amounts |
| `--color-text-secondary` | Timestamps, buyer addresses |

---
## 21. Related Screens

| Screen | Relationship |
|---|---|
| [W063] Order Detail | Full detail for single order |
| [W073] Refund Management | Refund processing from order |
| [W060] Product List | Products linked in orders |
| [W075a] Inventory Management | Stock impact from orders |
| [M027] Mobile Orders | Mobile equivalent |
| [W001] Home Dashboard | Entry via order KPI/alert |
| [S009] Trust Badge | Source class on order data |
| [S007] Confirmations | Bulk action confirmations |

---
## 22. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A standardization**: Fixed section numbering (1-22 sequential). Removed duplicate §5 and generic boilerplate. Added screen-specific Error Handling (6 scenarios with sync/export failures), Loading Behavior (6 stages with SSR), Localization with order-specific status labels, Design Tokens with per-status colors. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

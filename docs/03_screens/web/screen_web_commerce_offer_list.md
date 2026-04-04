# Screen: Web — Offer & Coupon Manager

> **Screen ID**: W066
> **Module**: M14 — Monetization & Offers
> **Route**: `/offers`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06 §7 (Commerce), Product Freeze §22-23, A1 Schema (offers, coupons, coupon_usage, offer_products, campaigns), B5 RBAC §2.7

---

## 1. Purpose & Context

The Offer & Coupon Manager is the central hub for all promotional offers. Shows all offers across statuses (active, scheduled, paused, expired) with real-time redemption tracking, revenue impact, and platform distribution. This is the primary entry point for the offer lifecycle — from creation through performance review.

### User Goals
- See all offers at a glance with status, redemption progress, and revenue impact
- Quickly create new promotions from a single entry point
- Monitor active offer performance in real-time
- Manage offer lifecycle (pause/resume/delete) without leaving the list
- Copy coupon codes for distribution

### Business Goals
- Drive monetization through discoverable, trackable promotions
- Provide offer-level revenue attribution connecting to the Proof Graph (M19)
- Enable data-driven promotion strategy through performance visibility
- Support multi-platform coupon distribution

### When This Screen Is Used
- Daily: Check active offer redemption progress
- Pre-campaign: Create new offers for upcoming sales events
- Post-campaign: Review expired offers to measure effectiveness
- Ad-hoc: Pause/resume offers based on inventory changes

### Entry Points
- Sidebar: "🏷 Khuyến mãi" under Monetization section
- Home Dashboard (W001): KPI widget → offer count click
- Campaign Detail (W065): "Xem tất cả offers" link
- AI Copilot: "Tạo offer giảm giá" → navigates here or direct to create
- Product Detail (W061): "Xem offers cho sản phẩm này" link

### Exit Points
- Click offer card → Offer Detail (W058)
- Click "+ Tạo mới" → Offer Create (W058 with `/offers/new`)
- Click "📊 Analytics" → Offer Analytics
- Click platform chip → platform-specific offer sync detail

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid workspace session
- User has `offer:read` permission (Viewer+ for viewing; Manager+ for actions)
- Workspace has Commerce module enabled

### Postconditions
- Page view logged for analytics
- Offer status changes (pause/resume/delete) persisted immediately
- Clipboard copy actions not logged (client-side only)

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + full-width offer cards with all columns |
| Tablet (768-1279px) | App Shell (collapsed) + stacked cards, platform chips hidden |
| Mobile (≤767px) | Redirect to Mobile Offers (M029) |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🏷 Khuyến mãi & Mã giảm giá (20)              [+ Tạo mới] [⚙ Filter]│
├──────────────────────────────────────────────────────────────────────┤
│ Tabs: [🟢 Active (5)] [⏳ Scheduled (2)] [⏸ Paused (1)] [⏹ Expired (12)]│
├──────────────────────────────────────────────────────────────────────┤
│ Search: [🔍 Tìm theo tên, mã coupon...                            ]│
│ Sort: [Mới nhất ▾]   View: [Card ▾]                                │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Offer Card ────────────────────────────────────────────────────┐ │
│ │ 🏷 "Flash Sale tháng 3"                                         │ │
│ │ Giảm 20% · Tất cả sản phẩm         [🟢 Active] [⋮]           │ │
│ │                                                                  │ │
│ │ Code: FLASH20 [📋]  · 25/03 — 31/03 · Còn 3 ngày              │ │
│ │                                                                  │ │
│ │ ┌─────────────────────────────────────────── Progress ─────────┐│ │
│ │ │ Đã dùng: 45/100 (45%)  ██████████████████░░░░░░░░░░░░░░░░  ││ │
│ │ └─────────────────────────────────────────────────────────────┘│ │
│ │                                                                  │ │
│ │ Revenue: +3.2M VND · Avg discount: 48K · Conv: 12.3%          │ │
│ │ Platforms: [🎵 TikTok] [🛍 Shopee]                             │ │
│ │                                                                  │ │
│ │ [→ Chi tiết] [⏸ Tạm dừng] [📊 Analytics]                      │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Offer Card ────────────────────────────────────────────────────┐ │
│ │ 🏷 "VIP Customer"                                               │ │
│ │ Giảm 50K · Chỉ Serum VitC              [🟢 Active] [⋮]       │ │
│ │                                                                  │ │
│ │ Code: VIP50 [📋]  · Vô thời hạn · Không giới hạn              │ │
│ │                                                                  │ │
│ │ Đã dùng: 12 lượt (không giới hạn)                              │ │
│ │ Revenue: +1.1M VND · Avg discount: 50K · Conv: 8.2%           │ │
│ │                                                                  │ │
│ │ [→ Chi tiết] [⏸ Tạm dừng] [📊 Analytics]                      │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Summary Bar (bottom) ──────────────────────────────────────────┐ │
│ │ Active: 5 · Total revenue impact: +12.8M VND · Avg conv: 10.2% │ │
│ └──────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
OfferListPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("🏷 Khuyến mãi & Mã giảm giá" + total count badge)
│   ├── CreateButton ("+ Tạo mới" → /offers/new)
│   └── FilterButton ("⚙ Filter" → filter dropdown)
├── StatusTabBar
│   ├── Tab("🟢 Active" + count)
│   ├── Tab("⏳ Scheduled" + count)
│   ├── Tab("⏸ Paused" + count)
│   └── Tab("⏹ Expired" + count)
├── ToolBar
│   ├── SearchInput ("🔍 Tìm theo tên, mã coupon...")
│   ├── SortDropdown (["Mới nhất", "Tên", "Lượt dùng", "Revenue"])
│   └── ViewToggle (Card / Compact list)
├── OfferCardList
│   └── OfferCard[] (repeating)
│       ├── OfferHeader
│       │   ├── OfferIcon ("🏷")
│       │   ├── OfferName
│       │   ├── DiscountLabel ("Giảm 20%" or "Giảm 50K")
│       │   ├── ProductScope ("Tất cả sản phẩm" or "Chỉ Serum VitC")
│       │   ├── StatusBadge (🟢 Active / ⏳ Scheduled / ⏸ Paused / ⏹ Expired)
│       │   └── OverflowMenu ("⋮" → Edit, Duplicate, Delete)
│       ├── CouponCodeRow
│       │   ├── CodeLabel ("Code: FLASH20")
│       │   ├── CopyButton ("📋" → clipboard)
│       │   ├── ValidityDates ("25/03 — 31/03")
│       │   └── ExpiryCountdown ("Còn 3 ngày" — active only)
│       ├── RedemptionProgress
│       │   ├── ProgressBar (filled percentage)
│       │   ├── UsageText ("Đã dùng: 45/100 (45%)")
│       │   └── UnlimitedText ("Không giới hạn" — when no limit)
│       ├── PerformanceRow
│       │   ├── RevenueImpact ("+3.2M VND")
│       │   ├── AvgDiscount ("48K")
│       │   └── ConversionRate ("12.3%")
│       ├── PlatformChips
│       │   └── PlatformChip[] (TikTok, Shopee, etc.)
│       └── ActionBar
│           ├── DetailButton ("→ Chi tiết" → /offers/[id])
│           ├── PauseButton ("⏸ Tạm dừng" — active) / ResumeButton ("▶ Tiếp tục" — paused)
│           └── AnalyticsButton ("📊 Analytics")
├── EmptyState (conditional — no offers in current tab)
│   ├── Illustration
│   ├── Message ("Chưa có khuyến mãi nào" or tab-specific)
│   └── CreateCTA ("+ Tạo offer đầu tiên")
├── SummaryBar (sticky bottom — shows aggregate for current tab)
│   ├── ActiveCount
│   ├── TotalRevenueImpact
│   └── AvgConversion
└── Pagination (if > 20 offers per tab)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Offer list | `offers` table filtered by status + workspace | `OfferService/List(workspace_id, status, page, sort)` | Card list | 5m TTL |
| Tab counts | `COUNT(offers) GROUP BY status` | `OfferService/GetStatusCounts(workspace_id)` | Integer in tab badges | 5m TTL |
| Coupon code | `coupons.code` via `offers.coupon_id` | Included in offer data | Uppercase monospace | — |
| Redemption count | `COUNT(coupon_usage) WHERE offer_id` | `OfferService/GetRedemptionStats(offer_id)` | "45/100" or "12 lượt" | 2m TTL |
| Revenue impact | ClickHouse: `SUM(orders.total) WHERE coupon_id` | Included in list response | Compact VND ("+3.2M VND") | 5m TTL |
| Avg discount | `AVG(coupon_usage.discount_amount)` | Included in list response | Compact VND ("48K") | 5m TTL |
| Conversion rate | `orders_with_coupon / coupon_views × 100` | Included in list response | Percentage ("12.3%") | 5m TTL |
| Validity dates | `offers.starts_at`, `offers.ends_at` | — | `dd/MM` or `dd/MM/yyyy` | — |
| Expiry countdown | `offers.ends_at - now()` | Computed client-side | "Còn 3 ngày" or "Hết hạn 2 ngày trước" | — |
| Platform distribution | `offer_platforms` junction | Included in offer data | Chip icons (🎵 🛍) | — |
| Summary totals | Aggregation across current tab | `OfferService/GetTabSummary(status)` | Revenue + conversion | 5m TTL |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Create new offer | Click "+ Tạo mới" | — | — | Navigate → `/offers/new` | `offer:manage` |
| 2 | View detail | Click "→ Chi tiết" or card | — | — | Navigate → `/offers/[id]` | `offer:read` |
| 3 | Pause offer | Click "⏸ Tạm dừng" | `OfferService/Pause(id)` | `offers.status = 'paused'` | Optimistic: status badge → ⏸, card moves to Paused tab. Toast "⏸ Offer đã tạm dừng" | `offer:manage` |
| 4 | Resume offer | Click "▶ Tiếp tục" | `OfferService/Resume(id)` | `offers.status = 'active'` | Optimistic: status badge → 🟢, card moves to Active tab. Toast "▶ Offer đang hoạt động" | `offer:manage` |
| 5 | Copy coupon code | Click "📋" | — (clipboard API) | — | Toast "📋 Đã copy: FLASH20" + haptic feedback | Any authenticated |
| 6 | View analytics | Click "📊 Analytics" | — | — | Navigate → `/offers/[id]/analytics` | `offer:read` |
| 7 | Edit offer | "⋮" → "Chỉnh sửa" | — | — | Navigate → `/offers/[id]` in edit mode | `offer:manage` |
| 8 | Duplicate offer | "⋮" → "Nhân bản" | `OfferService/Duplicate(id)` | New offer created (draft) | Toast "Đã nhân bản → Draft" → navigate to new offer | `offer:manage` |
| 9 | Delete offer | "⋮" → "Xóa" → confirm | `OfferService/Delete(id)` | `offers.deleted_at = now` | Confirmation modal → card removed with animation → Toast "Đã xóa offer" | `offer:manage` |
| 10 | Switch tab | Click tab | `OfferService/List(status=tab)` | — | URL updates (`?tab=active`), list refetches | `offer:read` |
| 11 | Search offers | Type in search input | `OfferService/List(query=...)` | — | Debounced 300ms, list filters. URL updates (`?q=flash`) | `offer:read` |
| 12 | Sort offers | Select sort option | `OfferService/List(sort=...)` | — | List re-sorts. URL updates (`?sort=revenue_desc`) | `offer:read` |
| 13 | Bulk select | Checkbox on cards (Manager+) | — | — | Bulk action bar appears: "Tạm dừng (3)" / "Xóa (3)" | `offer:manage` |
| 14 | Bulk pause | Bulk action → "Tạm dừng" | `OfferService/BulkPause(ids[])` | Multiple status updates | All selected cards update. Toast "⏸ 3 offers đã tạm dừng" | `offer:manage` |

---

## 7. Validation Rules

### Search
| Field | Rule | Behavior |
|---|---|---|
| Search query | Min 2 chars to trigger search | "Nhập ít nhất 2 ký tự" helper text |
| Search query | Max 100 chars | Truncate at 100 |

### Delete Confirmation
| Check | Error |
|---|---|
| Offer is active with redemptions | Warning in modal: "⚠️ Offer này đang hoạt động và đã được sử dụng {count} lần. Xóa sẽ không ảnh hưởng đến đơn hàng đã áp dụng." |
| Offer linked to campaign | Warning: "Offer này đang gắn với campaign '{name}'. Xóa offer sẽ bỏ liên kết." |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial page load | 3 card skeletons per tab | Wait |
| LOADED | Data received | Card list with tabs and counts | Interact normally |
| EMPTY_ALL | No offers in workspace | Full illustration: "Chưa có khuyến mãi nào. Tạo mã giảm giá đầu tiên để tăng doanh thu! [+ Tạo offer đầu tiên]" | Create first offer |
| EMPTY_TAB | No offers in current tab | Inline message: "Không có offer {status} nào." (e.g., "Không có offer đang hoạt động nào.") | Switch tab or create |
| SEARCH_NO_RESULTS | Search returns 0 results | "Không tìm thấy offer nào cho '{query}'. [Xóa bộ lọc]" | Clear search |
| PAUSING | Pause action in progress | Card: pause button shows spinner, card slightly dimmed | Wait |
| DELETING | Delete confirmed, in progress | Card fades out with animation (300ms) | Wait |
| BULK_SELECTED | 1+ cards selected for bulk action | Blue highlight on selected cards. Bulk action bar at top: "Đã chọn: 3 · [⏸ Tạm dừng tất cả] [🗑 Xóa tất cả]" | Execute bulk action or deselect |
| ERROR | API failed | Toast: "Không tải được danh sách offer. [Thử lại]" + Retry button | Retry |
| REFRESHING | Pull-to-refresh (tablet) | Refresh indicator at top | Wait |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View offer list | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| View performance stats | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Create offer | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Pause/resume offer | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Delete offer | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Duplicate offer | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Bulk actions | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Copy coupon code | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

### Visibility Rules
- **Viewer**: Can see offers and coupon codes. No action buttons except "Chi tiết" (read-only detail) and "📋 Copy".
- **Editor**: Can create and view but cannot pause/resume/delete. "⏸" and "🗑" hidden.
- **External**: Sidebar item hidden. Direct URL redirects to permission denied.
- **Bulk select checkbox**: Only visible for Manager+ roles.

---

## 10. Navigation Map

```
Offer List (/offers)
├── → /offers/new                    (Click "+ Tạo mới")
├── → /offers/[id]                   (Click card or "→ Chi tiết")
├── → /offers/[id]/analytics         (Click "📊 Analytics")
├── ← /                             (Sidebar nav home)
├── ← /campaigns/[id]               (If navigated from campaign)
├── ← /products/[id]                (If navigated from product)
│
│ URL parameters:
├── ?tab=active|scheduled|paused|expired    (tab selection)
├── ?q=                                      (search query)
├── ?sort=newest|name|usage|revenue          (sort order)
└── ?page=                                   (pagination)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Không có kết nối. Hiển thị dữ liệu đã cache." + cached cards shown | Auto-refresh on reconnect |
| API error (list) | Server 5xx on `OfferService/List` | Full-page: "Không tải được danh sách offer. [Thử lại]" | Retry button |
| API error (action) | Server 5xx on pause/resume/delete | Toast: "❌ Không thể {action} offer. Thử lại." + revert optimistic update | Retry action |
| Pause conflict | Offer already paused by another user | Toast: "Offer đã được tạm dừng bởi người khác." + refresh card | Auto-refresh |
| Delete failed (active orders) | Offer has pending orders | Toast: "Không thể xóa — offer có đơn hàng đang xử lý." | Wait for orders to complete |
| Rate limited | Too many quick actions | Toast: "Quá nhiều yêu cầu. Thử lại sau 30 giây." | Wait |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Tab bar | `role="tablist"`, each tab `role="tab"` with `aria-selected`, `aria-controls` |
| Offer cards | `role="article"` with `aria-label="Offer: Flash Sale tháng 3, giảm 20%, đang hoạt động, đã dùng 45 trên 100"` |
| Status badge | `aria-label="Trạng thái: Đang hoạt động"` (not relying on color/emoji alone) |
| Progress bar | `role="progressbar"` with `aria-valuenow="45"` `aria-valuemax="100"` `aria-label="Lượt sử dụng"` |
| Copy button | `aria-label="Copy mã coupon FLASH20"` → after click: `aria-label="Đã copy"` |
| Search input | `aria-label="Tìm kiếm offer"` with `role="search"` |
| Sort dropdown | `aria-label="Sắp xếp danh sách"` |
| Delete confirmation | Focus trapped in modal, `role="alertdialog"`, `aria-describedby` with warning |
| Keyboard | Tab navigates between cards, Enter/Space activates card actions, Escape closes menus |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App Shell + tab bar visible. Search bar visible. Card area shows 3 card skeletons. |
| Tab counts | 100-200ms | Tab badges update from "(—)" to actual counts |
| Offer cards | 200-500ms | Skeletons → cards animate in (staggered 50ms each) |
| Performance stats | included | Stats rendered inline with card (part of list response) |
| Tab switch | 100-300ms | Existing cards fade out (150ms) → new cards fade in (150ms) |
| Search results | 300-500ms | Debounce 300ms + fetch. Cards replace with animation. |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (first offer card is LCP element) |
| FID | < 100ms |
| CLS | < 0.05 (fixed card height prevents shift) |
| TTI | < 2.0s |
| List fetch | < 500ms for first page (20 items) |
| Tab switch | < 300ms |
| Search response | < 500ms (including 300ms debounce) |
| Card action (pause/resume) | < 1s end-to-end |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Redemption counts | Polling | Every 5 minutes (active tab only) |
| Revenue impact | Polling | Every 5 minutes |
| Offer status changes | SSE `/events/offers` | Real-time (another user paused/resumed) |
| New offer created | SSE `/events/offers` | Real-time (from another browser tab or team member) |

---

## 16. Localization Notes

- Primary language: Vietnamese (vi-VN)
- Discount display: "Giảm 20%" (percentage), "Giảm 50K" (fixed, compact), "Miễn phí ship" (shipping)
- Coupon codes: Always UPPERCASE, monospace font
- Currency: VND compact ("3.2M VND", "50K"), dot separator
- Dates: `dd/MM` for same-year, `dd/MM/yyyy` for cross-year
- Countdown: "Còn 3 ngày", "Còn 12 giờ", "Hết hạn 2 ngày trước"
- Tab labels: Vietnamese ("Đang HĐ", "Đã lên lịch", "Tạm dừng", "Hết hạn")
- Empty states: Friendly, encouraging tone with emoji

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `offer.list.viewed` | Page load | `tab`, `total_count`, `active_count` |
| `offer.list.tab_changed` | Tab switch | `from_tab`, `to_tab`, `count` |
| `offer.list.searched` | Search executed | `query`, `result_count` |
| `offer.list.sorted` | Sort changed | `sort_field`, `sort_order` |
| `offer.card.clicked` | Click card | `offer_id`, `status`, `position` |
| `offer.coupon.copied` | Copy code | `offer_id`, `code` |
| `offer.paused_from_list` | Pause from list | `offer_id`, `usage_at_pause` |
| `offer.resumed_from_list` | Resume from list | `offer_id` |
| `offer.deleted_from_list` | Delete from list | `offer_id`, `status_at_delete`, `usage_count` |
| `offer.duplicated` | Duplicate action | `source_offer_id` |
| `offer.bulk_action` | Bulk action executed | `action` (pause/delete), `count` |
| `offer.create.started` | Click "+ Tạo mới" | `source` (button, empty_state, copilot) |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-surface-primary` | Page background |
| `--color-surface-elevated` | Offer cards background |
| `--color-surface-hover` | Card hover state |
| `--color-accent` | "+ Tạo mới" button, active tab indicator |
| `--color-success` | 🟢 Active badge, revenue positive |
| `--color-warning` | ⏳ Scheduled badge, low redemption warning |
| `--color-neutral` | ⏸ Paused badge |
| `--color-text-secondary` | ⏹ Expired badge, muted text |
| `--color-danger` | Delete action, error states |
| `--color-border-subtle` | Card borders |
| `--color-progress-fill` | Redemption progress bar fill |
| `--color-progress-track` | Redemption progress bar background |
| `--font-mono` | Coupon code display |
| `--font-metric` | Revenue and conversion numbers |
| `--spacing-card-gap` | Gap between offer cards (16px) |
| `--radius-card` | Card border radius (12px) |
| `--shadow-card` | Card elevation shadow |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/offers/+page.svelte`
- **Server load**: `+page.server.ts` → fetch offers for default tab (active) + status counts
- **Tab switching**: Client-side navigation with `$page.url.searchParams` → refetch via `invalidate`
- **Search**: Debounced 300ms, Meilisearch `offers` index with full-text on name + code
- **Clipboard**: `navigator.clipboard.writeText()` with fallback `document.execCommand('copy')`
- **Optimistic UI**: Pause/resume update card instantly, revert on API failure
- **Infinite scroll**: Optional (if > 20 offers) via IntersectionObserver

### Data Fetching
```
+page.server.ts:
  const tab = url.searchParams.get('tab') ?? 'active';
  const sort = url.searchParams.get('sort') ?? 'newest';
  const q = url.searchParams.get('q');
  const page = Number(url.searchParams.get('page') ?? 1);

  const [offers, counts] = await Promise.all([
    offerService.list(workspace_id, { status: tab, sort, query: q, page, limit: 20 }),
    offerService.getStatusCounts(workspace_id),
  ]);
  // offers includes: offer data + coupon code + redemption stats + revenue impact
  // Single API call returns denormalized data to avoid N+1
```

### Card Performance
- Revenue impact and conversion are pre-computed server-side (ClickHouse materialized view)
- Progress percentage computed client-side: `(used / limit) × 100`
- Expiry countdown computed client-side: `offers.ends_at - Date.now()`

---

## 20. Related Screens & Revision History

### Related Screens
| Screen | Relationship |
|---|---|
| [W067] Offer Detail / Create | Child — create/edit individual offers |
| [W065] Campaign Detail | Linked — offers associated with campaigns |
| [W061] Product Detail | Linked — offers applicable to products |
| [W068] Coupon Manager | Sibling — detailed coupon management |
| [W082] Revenue Detail | Linked — revenue attributed to offers |
| [M029] Mobile Offers | Mobile equivalent |

### Revision History
| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Full 20-point rewrite. Added: real APIs (OfferService), complete state machine (10 states), full actions table (14 actions), detailed component hierarchy, bulk actions, search/sort/filter, screen-specific accessibility, performance targets, real-time updates (SSE), 12 analytics events, optimistic UI pattern, and comprehensive error handling. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C — template-based) | System |

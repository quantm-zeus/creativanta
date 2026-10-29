# Screen: Mobile — Commerce Product List

> **Screen ID**: M028
> **Module**: M14 — Commerce
> **Route**: `/products` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 06 §5, A1 Schema (products, inventory, product_images, product_categories), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile product browser — grid/list toggle, status chip filters, quick inventory check, real-time search, and low-stock alerts. Designed as a monitoring-first view optimized for on-the-go product management with critical quick actions (toggle visibility, check stock) while deferring complex operations (full edit, variant management) to web.

### User Goals
- Quickly check product catalog status and stock levels from mobile
- Search and filter products by status (active, out of stock, draft)
- Toggle product visibility on/off without opening detail
- Respond to low-stock alerts by viewing affected products
- View basic product info (price, stock, sales count, platforms)

### Business Goals
- Enable real-time stock monitoring for time-sensitive inventory decisions
- Reduce response time for stock-out situations via push notifications
- Support mobile-first sellers who manage primarily from phone

### When This Screen Is Used
- On-the-go: Quick stock check after receiving low-stock push notification
- Daily: Morning product catalog review on mobile
- Event: Monitoring sales velocity during active promotions

### Entry Points
- Bottom nav: Commerce tab → Products section
- Push notification: "⚠️ Stock low for Serum HA (5 left)" → deep link to this screen filtered to low-stock
- Order Detail (M024): "View product" link
- Home Dashboard (M001): Product count widget tap

### Exit Points
- Tap product card → Product Detail (M027 — read-only with "Edit on web" CTA)
- "+ Tạo" → simplified product creation (name, price, image) or "Tạo trên web" redirect
- Search → filtered product list
- Swipe back → Commerce hub

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- User has `product:read` permission (Editor+ for quick actions)
- Device has stable network (offline mode shows cached data)

### Postconditions
- Product visibility toggles persisted to backend
- Cached product list updated
- Analytics: `product.list.mobile.viewed` dispatched

---

## 3. Screen Layout

### Mobile Layout (Flutter)
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Sản phẩm (34)                         [🔍] [View ▦|☰] [+ Tạo] │
├──────────────────────────────────────────────────────────────────────┤
│ Chips (horizontal scroll):                                           │
│ [Tất cả (34)] [🟢 Đang bán (28)] [🔴 Hết hàng (3)] [📋 Nháp (3)]│
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ── Grid View (2 columns) ──                                         │
│ ┌─────────────────────┐ ┌─────────────────────┐                     │
│ │ [📸 Product Image]  │ │ [📸 Product Image]  │                     │
│ │ Serum HA 100ml      │ │ Toner AHA/BHA       │                     │
│ │ 250,000đ            │ │ 180,000đ            │                     │
│ │ Stock: 45  🟢       │ │ Stock: 120 🟢       │                     │
│ │ Sold: 234 (30d)     │ │ Sold: 89 (30d)      │                     │
│ │ ★ Bestseller        │ │                      │                     │
│ └─────────────────────┘ └─────────────────────┘                     │
│ ┌─────────────────────┐ ┌─────────────────────┐                     │
│ │ [📸 Product Image]  │ │ [📸 Product Image]  │                     │
│ │ Mask đất sét        │ │ Sunscreen SPF50     │                     │
│ │ 120,000đ            │ │ 320,000đ            │                     │
│ │ Stock: 0   🔴       │ │ Stock: 3   🟠       │                     │
│ │ ⚠️ Hết hàng         │ │ ⚠️ Sắp hết          │                     │
│ └─────────────────────┘ └─────────────────────┘                     │
│                                                                      │
│ ── List View (single column) ──                                     │
│ ┌──────────────────────────────────────────────────────────────────┐ │
│ │ [📸] Serum HA 100ml · 250,000đ · Stock: 45 🟢 · Sold: 234    │ │
│ │      [🎵 TikTok] [🛍 Shopee] · ★ Bestseller               >  │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│ ┌──────────────────────────────────────────────────────────────────┐ │
│ │ [📸] Mask đất sét · 120,000đ · Stock: 0 🔴 · ⚠️ Hết hàng    │ │
│ │      [🎵 TikTok] · Sold: 89                                >  │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Pull-to-refresh ↕ · Infinite scroll                                 │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠 Home] [💡 Ideas] [🎬 Studio] [💬 Inbox] [📊 Insights]        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
CommerceProductListScreen (StatefulWidget)
├── AppBar
│   ├── BackButton (Navigator.pop)
│   ├── Title ("Sản phẩm" + totalCount)
│   ├── SearchButton (🔍 → search overlay)
│   ├── ViewToggleButton (▦ grid / ☰ list)
│   └── CreateButton ("+ Tạo" → create flow)
├── StatusChipBar (horizontal scroll)
│   ├── FilterChip("Tất cả", count: 34, selected: true)
│   ├── FilterChip("🟢 Đang bán", count: 28)
│   ├── FilterChip("🔴 Hết hàng", count: 3)
│   └── FilterChip("📋 Nháp", count: 3)
├── ProductListBody (Sliver-based for scroll performance)
│   ├── GridView (when grid mode — 2 columns)
│   │   └── ProductGridCard[] (repeating)
│   │       ├── ProductImage (CachedNetworkImage, 1:1 aspect)
│   │       ├── ProductName (max 2 lines, ellipsis)
│   │       ├── PriceLabel (VND formatted)
│   │       ├── StockIndicator (count + color dot: 🟢>10, 🟠≤10, 🔴=0)
│   │       ├── SalesCount ("Sold: 234 (30d)")
│   │       ├── BestsellerBadge (conditional — ★)
│   │       └── LowStockWarning ("⚠️ Hết hàng" or "⚠️ Sắp hết")
│   └── ListView (when list mode — single column)
│       └── ProductListTile[] (repeating)
│           ├── ProductThumbnail (48×48, rounded)
│           ├── ProductInfo (name, price, stock inline)
│           ├── PlatformChips (small icons: 🎵 🛍)
│           ├── StockIndicator
│           └── ChevronRight (→ detail)
├── SearchOverlay (full screen when search active)
│   ├── SearchBar (auto-focus, clear button)
│   ├── RecentSearches (last 5)
│   └── SearchResults (product cards matching query)
├── EmptyState
│   ├── Illustration (product-themed)
│   ├── Message ("Chưa có sản phẩm. Tạo trên web hoặc đồng bộ từ TikTok Shop.")
│   └── CTAButton ("Tạo sản phẩm trên web →")
├── PullToRefresh (RefreshIndicator)
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Product list | `products` table | `ProductService/List(workspace_id, status, page, limit=20)` | Grid/list cards | 5m TTL, offline cache via Hive |
| Status chip counts | `COUNT GROUP BY status` | Included in list response header | Integer in chip badges | 5m |
| Product image | `product_images[0].url` | Included in list | `CachedNetworkImage`, 1:1 aspect, placeholder shimmer | Image cache |
| Product name | `products.name` | — | Max 2 lines, `TextOverflow.ellipsis` | — |
| Price | `products.price` | — | `NumberFormat('#,###', 'vi').format(price)` + "đ" | — |
| Stock | `products.stock_quantity` | — | Integer + color indicator | — |
| Sales (30d) | `COUNT(order_items) WHERE 30d` | Aggregated in list | "Sold: {count} (30d)" | 15m |
| Platforms | `product_platforms[]` | Included in list | Small icon chips | — |
| Bestseller badge | `products.is_bestseller` flag | Computed server-side | "★ Bestseller" text badge | — |
| Search results | Meilisearch `products` index | `ProductService/Search(query)` | Same card format | No cache |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | View product | Tap card | — | — | Navigate → Product Detail (M027) | `product:read` |
| 2 | Toggle view | Tap ▦/☰ button | — | Local pref | Grid ↔ List transition (300ms animation) | Any |
| 3 | Filter by status | Tap chip | Client-side filter or refetch | — | List filters. Active chip highlighted. | `product:read` |
| 4 | Search | Tap 🔍 → type query | `ProductService/Search(query)` | — | Search overlay, debounced 300ms | `product:read` |
| 5 | Pull to refresh | Pull down | `ProductService/List()` (fresh) | Cache invalidated | Refresh indicator → updated list | `product:read` |
| 6 | Toggle visibility | Long press card → "Ẩn/Hiện" | `ProductService/Update(id, {catalog_status})` | `products.catalog_status` toggle | Haptic feedback + toast "Đã ẩn sản phẩm" / "Đã hiện sản phẩm" | `product:manage` |<!-- AUDIT-FIX 2026-04-19: ToggleVisibility → Update(id, {catalog_status}) — no ToggleVisibility RPC in canonical api_endpoint_map.md §2.6.1; Update handles field changes including status -->
| 7 | Quick stock check | Long press → "Xem tồn kho" | — | — | Bottom sheet with stock by variant/location | `product:read` |
| 8 | Create (simple) | Tap "+ Tạo" | `ProductService/Create(basic_data)` | New draft product | Bottom sheet: name + price + image → saves as draft | `product:manage` |
| 9 | Create (redirect) | Tap "Tạo trên web" | — | — | Open web URL or show instructions | `product:manage` |
| 10 | Load more | Scroll to bottom | `ProductService/List(page+1)` | Append to list | Loading indicator → more cards appear | `product:read` |

---

## 7. Validation Rules

### Quick Create (Bottom Sheet)
| Field | Rule | Error |
|---|---|---|
| Product name | Required, 3-100 chars | "Tên sản phẩm 3-100 ký tự" |
| Price | Required, ≥ 1,000 VND | "Giá tối thiểu 1,000đ" |
| Image | Optional (can add later on web) | — |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial fetch | Grid: 4 shimmer cards (2×2). List: 4 shimmer rows. | Wait |
| LOADED | Products available | Card list with chip filters | Browse, search, tap |
| EMPTY | No products in workspace | Illustration + "Chưa có sản phẩm" + CTA | Create or sync |
| EMPTY_FILTER | No products for selected chip | "Không có sản phẩm {status}" | Change filter chip |
| SEARCHING | Search overlay active | Full-screen search with results | Type query |
| SEARCH_NO_RESULTS | Search finds nothing | "Không tìm thấy sản phẩm cho '{query}'" | Clear search |
| LOW_STOCK_ALERT | Products with stock ≤ 5 | Orange border + "⚠️ Sắp hết" on affected cards | Tap to view |
| OUT_OF_STOCK | Products with stock = 0 | Red border + "🔴 Hết hàng" badge | Restock (web) |
| REFRESHING | Pull-to-refresh active | `RefreshIndicator` spinner | Wait |
| LOADING_MORE | Infinite scroll triggered | Bottom loading indicator | Wait |
| OFFLINE | No network | Banner: "📡 Hiển thị dữ liệu offline" + cached data | Pull-to-refresh when online |
| ERROR | API failed | "Không tải được sản phẩm. [Thử lại]" | Tap retry |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View product list | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ (read-only) | ❌ |
| Search products | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Toggle visibility | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Quick stock check | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Quick create | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Mobile Product List (/products)
├── → /products/[id]                  (Tap card → M027 Product Detail)
├── → /products/create                (Quick create bottom sheet)
├── → web://products/[id]             (Edit on web redirect)
├── ← /commerce                       (Back button)
├── ← /home                           (Bottom nav)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Hiển thị dữ liệu offline" + Hive cached list | Pull-to-refresh when online |
| API error (list) | Server 5xx | Full screen: "Không tải được sản phẩm. [Thử lại]" | Tap retry |
| API error (toggle) | Toggle visibility failed | Snackbar: "❌ Không thay đổi được. Thử lại." + revert | Retry |
| Search timeout | Slow search response | "Tìm kiếm chậm. Thử lại." | Retry |
| Image load failed | CDN error | Fallback: grey placeholder with product icon | Auto-retry on scroll |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Product cards | `Semantics(label: "Serum HA 100ml, giá 250,000 đồng, tồn kho 45, đã bán 234 trong 30 ngày")` |
| Status chips | `Semantics(label: "Lọc: Đang bán, 28 sản phẩm")` with `selected` state |
| Stock indicator | Not color-only — includes text ("Hết hàng", "Sắp hết", stock count) |
| View toggle | `Semantics(label: "Chế độ xem: Lưới")` |
| Search | `Semantics(label: "Tìm kiếm sản phẩm")` |
| Tap targets | Minimum 48×48dp on all interactive elements |
| Dynamic updates | `Semantics(liveRegion: true)` for stock changes and filter results |
| Long press | `Semantics(onLongPressHint: "Mở menu nhanh")` |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + chip bar + shimmer cards |
| Product data | 200-500ms | Shimmer → cards appear with stagger (50ms each) |
| Product images | 100-300ms each | Shimmer → image fade-in |
| Search results | 300-500ms | Search overlay loading → results |
| Pull-to-refresh | 500-1000ms | RefreshIndicator → list updates |
| Infinite scroll | 200-400ms | Bottom spinner → new cards append |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| First Meaningful Paint | < 1.0s |
| List scroll | 60fps (no jank) |
| Image loading | Progressive with blurhash placeholder |
| Search response | < 500ms (including 300ms debounce) |
| Offline data load | < 200ms (from Hive) |
| Card tap response | < 100ms (immediate navigation) |
| Memory | < 50MB for 100 products with images |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Stock levels | Push notification trigger | On low-stock event |
| Product visibility | Background sync | Every 5 minutes |
| Sales count | Background refresh | Every 15 minutes |
| Search index | N/A (server-side Meilisearch) | Real-time indexing |

---

## 16. Localization Notes

- Primary language: Vietnamese (vi-VN)
- Currency: VND without decimals ("250,000đ", "1.200.000đ")
- Stock: "Tồn: {n}" or "Hết hàng" / "Sắp hết"
- Sales: "Đã bán: {n} (30 ngày)"
- Relative time: "2 giờ trước"
- Numbers: dot separator ("1.234")
- Empty states: Friendly, encouraging tone

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `product.list.mobile.viewed` | Screen visible | `total_count`, `view_mode` (grid/list), `filter` |
| `product.list.mobile.searched` | Search executed | `query`, `result_count` |
| `product.list.mobile.filtered` | Chip filter changed | `filter_status`, `count` |
| `product.list.mobile.card_tapped` | Card tap | `product_id`, `position`, `view_mode` |
| `product.list.mobile.visibility_toggled` | Toggle visibility | `product_id`, `new_status` |
| `product.list.mobile.quick_created` | Quick create submit | `product_name`, `price` |
| `product.list.mobile.view_toggled` | View mode changed | `from_mode`, `to_mode` |
| `product.list.mobile.refreshed` | Pull-to-refresh | `time_since_last_load` |

---

## 18. Design Tokens Reference (Flutter)

| Token | Usage |
|---|---|
| `AppColors.surface` | Screen background |
| `AppColors.surfaceElevated` | Product cards |
| `AppColors.accent` | "+ Tạo" button, search active state |
| `AppColors.success` | 🟢 Active stock indicator |
| `AppColors.warning` | 🟠 Low stock indicator |
| `AppColors.danger` | 🔴 Out of stock indicator |
| `AppColors.chipSelected` | Active filter chip background |
| `AppTypography.bodyMedium` | Product name |
| `AppTypography.bodySmall` | Price, stock, sales |
| `AppDimens.cardRadius` | Card border radius (12.dp) |
| `AppDimens.cardGap` | Grid gap (12.dp) |
| `AppDimens.chipHeight` | Filter chip height (36.dp) |

---

## 19. Technical Implementation Notes

### Flutter Specifics
- **Widget**: `CommerceProductListScreen extends StatefulWidget`
- **State management**: Riverpod `productListProvider` with `AsyncNotifier`
- **List rendering**: `CustomScrollView` with `SliverGrid` (grid) / `SliverList` (list)
- **Infinite scroll**: `ScrollController` with threshold detection → load next page
- **Search**: `Overlay` widget for search, Meilisearch via `ProductService`
- **Image caching**: `cached_network_image` package with `blurhash` placeholders
- **Offline**: Product list cached in `Hive` box, synced on reconnect
- **View toggle**: `SharedPreferences` persists grid/list preference
- **Long press**: `GestureDetector.onLongPress` → bottom sheet with quick actions
- **Pull-to-refresh**: `RefreshIndicator` wrapping `CustomScrollView`

### Data Flow
```dart
// Provider
final productListProvider = AsyncNotifierProvider<ProductListNotifier, ProductListState>(
  ProductListNotifier.new,
);

// State
class ProductListState {
  final List<Product> products;
  final Map<String, int> statusCounts;
  final String activeFilter;       // 'all' | 'active' | 'out_of_stock' | 'draft'
  final bool isLoadingMore;
  final bool hasMore;
}
```

---

## 20. Related Screens & Revision History

### Related Screens
| Screen | Relationship |
|---|---|
| [W061] Web Product Detail | Child — tap card to view detail (web) |
| [M027] Mobile Orders | Linked — order items reference products |
| [W060] Web Product List | Web equivalent (full CRUD) |
| [W061] Web Product Detail | Web full edit (mobile redirects for complex ops) |

### Revision History
| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Full 20-point rewrite. Added: real APIs (ProductService), Flutter-specific widget tree, grid/list toggle with animation, offline caching (Hive), long-press quick actions, search overlay, 10 actions, 12 states, Riverpod state management, blurhash image placeholders, and comprehensive Flutter accessibility (Semantics). | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |

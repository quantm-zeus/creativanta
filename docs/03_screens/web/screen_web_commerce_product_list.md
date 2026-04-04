# Screen: Web — Product List

> **Screen ID**: W060
> **Module**: M13 — Product Hub
> **Route**: `/products`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06 §Commerce, Product Freeze §21-24, A1 Schema (products, product_variants, product_images), B5 RBAC §2.7

---
## 1. Purpose & Context

The Product List displays all products in the workspace — synced from e-commerce platforms (TikTok Shop, Shopee, Lazada) and manually created. Supports grid/list view with filtering, full-text search (Meilisearch), and quick actions for content creation and offer linking. This is the commerce hub where product data becomes content strategy.

### User Goals
- View all products across all connected platforms in one place
- Quickly assess stock levels, sales velocity, and revenue per product
- Find products to create content for or attach to offers
- Import products from new platforms or add manually

### Business Goals
- Bridge commerce data with content pipeline (product → content → publish)
- Track product performance to inform content strategy
- Enable quick identification of low-stock, high-demand products

### Entry Points
- Sidebar: "🛍️ Sản phẩm" under Commerce section
- Home Dashboard: Quick Action "📦 Kiểm tra đơn hàng" (partial overlap)
- Notification: "New products synced from TikTok" → deep link
- AI Copilot: "Sản phẩm nào bán chạy nhất?" → navigate here with sort
- Opportunity Board: "Create content for product X" → navigate with product_id filter

### Exit Points
- Click product card → Product Detail (W061)
- Click "📤 Tạo NĐ" → Idea creation with product context
- Click "+ Tạo mới" → Product create form
- Click "📥 Import" → Import modal

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `product:read` permission (all workspace members except External)
- At least one platform connector active OR manual products exist

### Postconditions
- New products (manual create or import) appear in list immediately
- Delete/archive actions are audited in workspace audit log

---
## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + 4-column grid or full table view |
| Tablet (768-1279px) | App Shell (collapsed) + 2-column grid or compacted table |
| Mobile (≤767px) | Redirect to M028 Mobile Products |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🛍️ Sản phẩm (156)             [+ Tạo mới] [📥 Import] [▦|☰]     │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Quick Stats Bar ─────────────────────────────────────────────┐   │
│ │ 📦 156 products · 🟢 120 active · ⚠️ 8 low stock · 💰 45M rev│  │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Filter: [Platform ▾] [Status ▾] [Category ▾] [Stock ▾] [🔍 Tìm ] │
│ Sort: [Bán chạy nhất ▾]  Period: [30 ngày ▾]                       │
│                                                                      │
│ ┌─ Product Card ─────────────┐ ┌─ Product Card ─────────────┐      │
│ │ [📸 Product Image]         │ │ [📸 Product Image]         │      │
│ │ Serum Vitamin C 30ml       │ │ Kem chống nắng SPF50      │      │
│ │ 299,000đ · 🎵 TikTok Shop│ │ 199,000đ · 🛍 Shopee      │      │
│ │ 🟢 Active · SKUs: 3       │ │ 🟡 Draft · SKUs: 1        │      │
│ │ Stock: 245 · ⚠️ Low: 30ml │ │ Stock: 0 · [Set stock]     │      │
│ │ Sold (30d): 89 · 26.6M    │ │ —                          │      │
│ │ Source: [🟢 Official]      │ │ Source: [🔵 Imported]      │      │
│ │ [→ Detail] [📤 Tạo NĐ]   │ │ [→ Detail] [📤 Tạo NĐ]   │      │
│ └─────────────────────────────┘ └─────────────────────────────┘      │
│                                                                      │
│ ┌─ Product Card ─────────────┐ ┌─ Product Card ─────────────┐      │
│ │ [📸 Product Image]         │ │ [📸 No Image]              │      │
│ │ Set 3 mon skincare         │ │ Toner AHA/BHA              │      │
│ │ 799,000đ · 🎵 TikTok     │ │ 149,000đ · Manual          │      │
│ │ 🟢 Active · SKUs: 1       │ │ 🟡 Draft · SKUs: 1        │      │
│ │ Stock: 50 · Sold: 23      │ │ Stock: — · Imported        │      │
│ │ [→ Detail] [📤 Tạo NĐ]   │ │ [→ Detail] [📤 Tạo NĐ]   │      │
│ └─────────────────────────────┘ └─────────────────────────────┘      │
│                                                                      │
│ [Tải thêm ↓] (cursor-based, 20/page)                               │
└──────────────────────────────────────────────────────────────────────┘
```

### List View (alternative toggle ☰)
```
┌─ Product Table ────────────────────────────────────────────────────┐
│ ☐ Image  Name              Platform  Price    Stock  Sold(30d) Rev│
│ ☐ [📸]  Serum VitC 30ml   🎵 TT    299K     245    89       26.6M│
│ ☐ [📸]  Kem chống nắng    🛍 SP    199K     0      —        —   │
│ ☐ [📸]  Set 3 món          🎵 TT    799K     50     23       18.4M│
└────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
ProductListPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("🛍️ Sản phẩm" + count badge)
│   ├── CreateButton ("+ Tạo mới", primary CTA)
│   ├── ImportButton ("📥 Import", secondary)
│   └── ViewToggle (Grid ▦ | List ☰)
├── QuickStatsBar
│   ├── TotalCount
│   ├── ActiveCount
│   ├── LowStockCount (with warning icon)
│   └── TotalRevenue (period-scoped)
├── FilterBar
│   ├── PlatformFilter (TikTok Shop, Shopee, Lazada, Manual)
│   ├── StatusFilter (Active, Draft, Out of Stock, Archived)
│   ├── CategoryFilter (product categories from platform)
│   ├── StockFilter (All, In Stock, Low Stock <10, Out of Stock)
│   ├── SortSelector (Bán chạy nhất, Mới nhất, Giá cao→thấp, Tồn kho thấp)
│   ├── PeriodSelector (7d, 30d, 90d)
│   └── SearchInput (Meilisearch — instant results)
├── ProductGrid (or ProductTable based on ViewToggle)
│   └── ProductCard[]
│       ├── ProductImage (CDN, lazy-loaded, fallback placeholder)
│       ├── ProductName (max 2 lines, truncated)
│       ├── PriceDisplay (formatted VND, "từ 299,000đ" if variants)
│       ├── PlatformBadge (icon + name)
│       ├── StatusBadge (🟢 Active / 🟡 Draft / 🔴 Out of Stock / ⚪ Archived)
│       ├── SKUCount
│       ├── StockInfo (with low-stock warning ⚠️ if < threshold)
│       ├── SalesStats (30d sold count + revenue, period-scoped)
│       ├── TrustBadge (S009 — source class of product data)
│       └── ActionBar
│           ├── DetailLink ("→ Detail")
│           ├── CreateContentButton ("📤 Tạo NĐ")
│           └── MoreMenu (⋮ → Edit, Archive, Delete)
├── BulkActionBar (appears when ☐ checkboxes selected)
│   ├── SelectedCount
│   ├── BulkArchiveButton
│   ├── BulkExportButton
│   └── ClearSelectionButton
├── LoadMore (cursor-based pagination, infinite scroll)
└── ImportModal (conditional)
    ├── PlatformSelector
    ├── SyncOptions (All products / Select categories)
    ├── ConflictResolution (Skip existing / Update existing)
    └── ImportButton
```

---
## 5. Data Binding & Display Format

| Field | Source | API | Display Format | Cache |
|---|---|---|---|---|
| Name | `products.name` | `ProductService/List` | Text, max 60 chars | 5m |
| Price | `products.price` or `MIN(variants.price)` | same | "299,000đ" or "từ 299,000đ" | 5m |
| Platform | `products.source_platform` | same | Platform icon + name | 5m |
| Status | `products.status` | same | Color badge | 5m |
| SKUs | `COUNT(product_variants)` | same | "SKUs: 3" | 5m |
| Stock | `SUM(variants.stock_quantity)` | same | "Stock: 245" | Real-time SSE |
| Low stock threshold | `products.low_stock_threshold` (default 10) | same | ⚠️ if below | 5m |
| Sold (30d) | `orders` aggregation | same | "89" | 5m |
| Revenue (30d) | `orders.total_amount` sum | same | "26.6M VND" (compact) | 5m |
| Image | `product_images[0].url` | same | CDN thumbnail 200×200 | CDN cached |
| Source class | `products.source_class` | same | Trust badge (S009) | 5m |
| Quick stats | Aggregated | `ProductService/GetStats` | Counts + amounts | 5m |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Navigation | Permission |
|---|---|---|---|---|---|---|---|
| 1 | Create product | "+ Tạo mới" | Primary CTA | — | — | → `/products/new` | `product:manage` |
| 2 | Import from platform | "📥 Import" → select platform | Secondary | `ConnectorService/SyncProducts(platform)` | ImportModal → sync progress → toast "Đã đồng bộ X sản phẩm" | — | `product:manage` |
| 3 | View detail | Click card or "→ Detail" | Navigation | — | — | → `/products/[id]` | `product:read` |
| 4 | Create content | "📤 Tạo NĐ" | Quick action | — | — | → `/ideas/new?product_id=[id]` | `idea:create` |
| 5 | Archive product | ⋮ → "Lưu trữ" → confirm | Destructive | `ProductService/Archive(id)` | Confirmation dialog → card removed → toast "Đã lưu trữ" | — | `product:manage` |
| 6 | Delete product | ⋮ → "Xóa" → confirm | Destructive | `ProductService/Delete(id)` | Confirmation dialog (S007) → card removed | — | `product:manage` |
| 7 | Filter | Change any filter | Filter | Refetch with params | Grid updates with fade animation | — | `product:read` |
| 8 | Sort | Change sort option | Sort | Refetch with sort | Grid re-sorts | — | `product:read` |
| 9 | Search | Type in search input | Debounced 300ms | Meilisearch query | Instant results | — | `product:read` |
| 10 | Toggle view | Click ▦ or ☰ | Toggle | — (localStorage) | Switch between grid and table view | — | Any |
| 11 | Load more | Scroll to bottom or click "Tải thêm" | Pagination | `ProductService/List(cursor)` | More products append | — | `product:read` |
| 12 | Bulk archive | Select items → "Lưu trữ" | Bulk | `ProductService/BulkArchive(ids[])` | Confirmation → items removed | — | `product:manage` |
| 13 | Bulk export | Select items → "Xuất CSV" | Bulk | Client-side CSV gen | CSV download | — | `product:read` |

---
## 7. Validation Rules

### Import Modal
| Field | Rule | Error Message |
|---|---|---|
| Platform | Required, must be connected | "Vui lòng kết nối nền tảng trước khi import" |
| Sync target | At least one category or "All" | "Chọn danh mục hoặc 'Tất cả'" |

### Search
- Min 2 characters to trigger search
- Max 200 characters
- Supports Vietnamese diacritics

---
## 8. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial page load | QuickStatsBar shimmer + 8 card skeletons (matching grid layout) |
| LOADED | Data received | Product grid/table with populated data |
| EMPTY | No products at all | Illustration + "Chưa có sản phẩm nào trong workspace. Tạo sản phẩm thủ công hoặc import từ nền tảng đã kết nối. [+ Tạo sản phẩm] [📥 Import từ nền tảng]" |
| EMPTY_FILTERED | Filters active, no results | "Không có sản phẩm phù hợp với bộ lọc. [Xóa tất cả bộ lọc]" |
| EMPTY_SEARCH | Search query, no results | "Không tìm thấy sản phẩm '{query}'. Thử từ khóa khác." |
| ERROR | API failed | Error banner: "Không tải được danh sách sản phẩm. [Thử lại]" |
| SYNCING | Platform sync in progress | Top banner: "🔄 Đang đồng bộ sản phẩm từ {platform}... ({progress})" |
| LOW_STOCK_ALERT | ≥1 product below threshold | Yellow notice: "⚠️ {count} sản phẩm sắp hết hàng. [Xem →]" (filterable) |

---
## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View product list | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| View revenue data | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View stock levels | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Create product | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Import products | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Archive product | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Delete product | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Create content from product | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Bulk actions | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Export | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Contributor/Viewer**: Revenue and commission columns are hidden. Stock is visible (for content planning).
- **Editor**: Can see revenue but cannot manage products. "Create content" action is available.
- **External**: No access — redirect to permission denied page.

---
## 10. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Stock levels | SSE `/events/products` | Real-time (on stock change) |
| New products (sync) | SSE `/events/products` | Real-time (on sync completion) |
| Quick stats | Polling | Every 5 minutes |
| Low stock alerts | SSE | Real-time (when crossing threshold) |

### Real-time UX
- New product appears at top of list with green highlight pulse (3s)
- Stock change: number animates to new value
- Low stock: card border turns yellow when crossing threshold

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| Product with no image | Show generic product placeholder with product initial |
| Product with 0 variants | Show "No variants" — price from product.price |
| Synced product deleted on platform | Mark as "⚠️ Removed from platform" with strikethrough. Keep in Creativanta for historical data. |
| Platform connector disconnected | Products still visible but show "⚫ Nguồn không kết nối" badge. Sync disabled. |
| >1000 products | Virtual scroll optimization. Recommend search/filter usage. |
| Price = 0 | Show "Miễn phí" (Free) instead of "0đ" |
| Multi-platform same product | Show as separate entries (platform-specific). Future: merge duplicates. |

---
## 12. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Full-page degraded banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached" + stale products visible | Auto-retry when online |
| API error (5xx) | Server failure | Error banner: "Không tải được sản phẩm. [Thử lại]" | Retry button |
| Search failed | Meilisearch down | Fallback to basic SQL LIKE query. Toast: "Tìm kiếm nâng cao không khả dụng" | Automatic fallback |
| Import failed | Platform API error | Modal error: "Không đồng bộ được. {platform} đang gặp sự cố. [Thử lại]" | Retry import |
| Sync conflict | Product changed on both sides | Dialog: "Sản phẩm đã thay đổi trên {platform}. [Giữ phiên bản gốc] [Cập nhật]" | User decides |
| Bulk action partial failure | Some items failed | Toast: "Đã xử lý {success}/{total}. {failed} thất bại. [Xem chi tiết]" | Retry failed items |
| Permission denied | 403 | "Không có quyền truy cập module Commerce" → Navigate to allowed page | Contact admin |

---
## 13. Accessibility

| Element | Requirement |
|---|---|
| Product cards | `role="article"`, `aria-label="Sản phẩm: {name}, Giá: {price}, Tình trạng: {status}"` |
| Grid/List toggle | `role="tablist"` with `aria-selected` |
| Filter dropdowns | `aria-expanded`, `aria-haspopup="listbox"` |
| Bulk selection | `aria-checked` on checkboxes, "X sản phẩm đã chọn" announced |
| Images | `alt="{product.name}"` |
| Load more | `aria-label="Tải thêm sản phẩm"` |
| Search | `aria-label="Tìm kiếm sản phẩm"`, `role="searchbox"` |
| Status badges | Text label accompanies color — never color-only |

---
## 14. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | App Shell + QuickStatsBar shimmer + 8 card skeletons |
| Server data (SSR) | 200-500ms | Quick stats populate → product cards animate in with stagger |
| Images | Progressive | Lazy-loaded with blurred placeholder → sharp image |
| Search results | < 100ms | Instant — cards swap with crossfade |
| Load more | 200-400ms | New cards append with slide-up animation |
| Sync progress | 2-30s | Progress bar in import modal |

---
## 15. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (first product card) |
| CLS | < 0.05 (no layout shift when images load — placeholder has fixed aspect ratio) |
| TTI | < 2.0s |
| Search latency | < 100ms (Meilisearch) |
| Items per page | 20 (cursor-based, infinite scroll) |
| Image loading | Lazy loaded, CDN-served, WebP format, 200×200 thumbnails |
| Bundle size | < 35KB page-specific JS |

---
## 16. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `products.list.viewed` | Page load | `total_count`, `view_mode`, `filters_applied` |
| `products.list.filtered` | Filter change | `filter_type`, `filter_value` |
| `products.list.searched` | Search query | `query`, `results_count` |
| `products.list.card_clicked` | Card click | `product_id`, `position` |
| `products.list.content_created` | "Tạo NĐ" click | `product_id` |
| `products.list.imported` | Import completed | `platform`, `imported_count` |
| `products.list.view_toggled` | Grid/List toggle | `new_view_mode` |
| `products.list.bulk_action` | Bulk action executed | `action_type`, `item_count` |

---
## 17. SvelteKit Implementation Notes

### Route & Server Load
- **Route**: `src/routes/(app)/products/+page.svelte`
- **Server load**: `+page.server.ts` → fetch first 20 products + stats (SSR)
- **Search**: Client-side Meilisearch via `meilisearch-js` SDK
- **View mode**: Stored in `localStorage('product_view_mode')`
- **SSR**: Server renders first page of product cards for fast LCP
- **Infinite scroll**: Intersection Observer on sentinel element

### Data Fetching Strategy
```
+page.server.ts:
  Promise.all([
    productService.list({ limit: 20, sort, filters }),
    productService.getStats()
  ])

Client-side:
  onIntersect(sentinel) → productService.list({ cursor: lastId })
  onSearch(query) → meilisearchClient.index('products').search(query)
```

### Platform Sync
- Sync cron: every 6 hours per connected platform
- Manual sync: "📥 Import" triggers immediate sync for selected platform
- Sync status tracked in `sync_jobs` table
- Conflict: platform data wins for price/stock; Creativanta data wins for descriptions/images

### SSE Integration
- Channel: `EventSource('/api/events/products')`
- Events: `product_created`, `product_updated`, `stock_changed`, `product_deleted`
- On event: Patch SvelteKit store with delta update (no full refetch)

---
## 18. Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "299.000đ")
- Compact format: "26.6M" for large amounts
- Date: DD/MM/YYYY
- Numbers: dot separator (1.234)
- Status labels: "Đang bán" (Active), "Nháp" (Draft), "Hết hàng" (Out of Stock), "Đã lưu trữ" (Archived)
- Search placeholder: "Tìm sản phẩm..."
- Empty state: friendly tone, action-oriented

---
## 19. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Primary CTAs (Create, Import) |
| `--color-success` | Active status badge (🟢), positive revenue |
| `--color-warning` | Low stock warning (⚠️), Draft status (🟡) |
| `--color-danger` | Out of stock (🔴), Delete actions |
| `--color-surface-elevated` | Product cards, elevated surfaces |
| `--color-text-primary` | Product names, prices |
| `--color-text-secondary` | Stats labels, timestamps |
| `--color-platform-tiktok` | TikTok Shop badge (🎵) |
| `--color-platform-shopee` | Shopee badge (🛍) |

---
## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W061] Product Detail | Drill-down from product card |
| [W066] Offer List | Products referenced in offers |
| [W064] Campaign List | Products linked to campaigns |
| [W012] Idea Board | Content creation from product context |
| [W117] Platform Connectors | Connect platforms for product sync |
| [M028] Mobile Products | Mobile equivalent |
| [W075a] Inventory Management | Stock management for products |
| [S009] Trust Badge | Source class badge on product data |
| [S005] Empty States | Empty state component |
| [S007] Confirmations | Delete/archive confirmation |

---
## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A standardization**: Fixed section numbering (1-21 sequential). Removed duplicate §5/§19 and generic boilerplate sections. Added screen-specific Error Handling (7 scenarios including search fallback and sync conflicts), expanded Loading Behavior (6 stages), SvelteKit SSE integration, platform-specific Design Tokens, expanded Analytics Events (8 events), and Localization Notes with product-specific status labels. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

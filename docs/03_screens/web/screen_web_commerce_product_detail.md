# Screen: Web — Product Detail

> **Screen ID**: W061
> **Module**: M13 — Commerce (Products)
> **Route**: `/products/[id]`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06 §Commerce, Product Freeze §21-24, A1 Schema (products, product_skus, product_images, orders, product_reviews, affiliate_links), B5 RBAC §2.7

---

## 1. Purpose & Context

The Product Detail page is the 360° intelligence hub for a single product — bridging commerce data with content strategy. It shows product information, variant/inventory management, sales performance over time, content attribution (which videos/scripts drove sales), platform sync status, and profit calculation per product. This is where a seller-creator decides "should I make more content about this product?" based on real data.

### User Story
> As a seller-creator, I want to see everything about a product — variants, stock levels, sales trend, which content drove orders, and actual profit — so I can decide whether to invest more content effort into this product or pivot.

### Business Goals
- Bridge commerce data ↔ content strategy (data-driven content decisions)
- Enable accurate per-product profit visibility (Profit OS integration)
- Drive content creation by showing direct attribution (video → orders)
- Surface actionable insights (low stock alerts, best-selling variants)
- Reduce tab-switching between e-commerce platforms

### When This Screen Is Used
- **Product performance check**: "How is my serum selling this week?"
- **Pre-content creation**: "Should I make another video about this product?"
- **Inventory planning**: "Which variant is running low?"
- **Price optimization**: "What's my margin after platform fees?"
- **Campaign review**: "Which affiliate link drives the most orders for this product?"

### Entry Points
- Product List ([W060]): Click product card → `/products/[id]`
- Order Detail ([W063]): Click product name in order items
- Content Linked: Script/Video attribution link → product reference
- AI Copilot: "Chi tiết sản phẩm Serum VitC" → navigate here
- Notification: "⚠️ Low stock: Serum VitC 30ml" → deep link
- Direct URL: `/products/[id]`

### Exit Points
- "✏️ Edit" → `/products/[id]/edit` (Edit form)
- "📤 Tạo nội dung" → `/ideas/new?product_id=[id]` (Idea with product context)
- "🏷 Tạo offer" → `/offers/new?product_id=[id]`
- "📊 Full analytics" → `/analytics/products/[id]`
- Content links → `/content/[type]/[id]` (linked script, video, idea)
- "← Sản phẩm" → `/products` (back to list)

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- User has `product:read` permission
- Product exists and belongs to current workspace
- Platform connector for product source is active (for live sync)

### Postconditions
- View event logged for audit trail
- Related content links are tracked for attribution accuracy
- COGS updates (if edited) propagate to profit calculations
- Force sync updates product data from platform API

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + Split View: Main Content (60%) / Side Panel (40%) |
| Tablet (768-1279px) | App Shell (collapsed) + Single column (side panel stacks below) |
| Mobile (≤767px) | Redirect to Mobile Product Detail (M030) |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Sản phẩm   Serum Vitamin C 30ml          [✏️ Edit] [⋮ More]     │
├──────────────────────────────┬───────────────────────────────────────┤
│ Main Content (60%)           │ Side Panel (40%)                      │
│                              │                                       │
│ ┌─ Image Gallery ──────────┐│ ┌─ Quick Info ─────────────────────┐ │
│ │ ┌──────────────────────┐ ││ │ Price: 299,000đ                  │ │
│ │ │                      │ ││ │ Variants: từ 299,000 - 799,000đ │ │
│ │ │   [Main product      │ ││ │ Status: 🟢 Active               │ │
│ │ │    image: 400×400]   │ ││ │ Source: 🎵 TikTok Shop         │ │
│ │ │                      │ ││ │ SKU: SVT-C (3 variants)        │ │
│ │ └──────────────────────┘ ││ │ Category: Skincare > Serum     │ │
│ │ [📸] [📸] [📸] [📸]    ││ │ Created: 15/01/2026            │ │
│ └──────────────────────────┘│ │ Last synced: 5 phút trước 🟢   │ │
│                              │ └─────────────────────────────────┘ │
│ ┌─ Product Info ───────────┐│                                       │
│ │ Serum Vitamin C 30ml      ││ ┌─ Sales Summary (30d) ────────────┐│
│ │                            ││ │ 📦 Orders: 89  (+12% vs prev)   ││
│ │ Giúp da sáng mịn, giảm   ││ │ 💰 Revenue: 26.6M VND (+18%)    ││
│ │ thâm nám, dưỡng ẩm sâu.  ││ │ 🏷 Commission: 2.66M VND       ││
│ │ Thành phần: Vitamin C     ││ │ 📈 Net Revenue: 23.9M VND      ││
│ │ 15%, Niacinamide, HA      ││ │ ⭐ Avg Rating: 4.5/5 (156 đánh ││
│ └───────────────────────────┘│ │    giá)                          ││
│                              │ │ 🏆 Rank: #3 in workspace        ││
│ ┌─ Variants & Inventory ───┐│ │                                   ││
│ │ Variant    Price    Stock  ││ │ Period: [7d · 30d · 90d · All]  ││
│ │ ─────────  ───────  ─────  ││ │ [📊 Full analytics →]          ││
│ │ 30ml      299,000đ  120   ││ └──────────────────────────────────┘│
│ │ 50ml      499,000đ   85   ││                                      │
│ │ 100ml     799,000đ   40   ││ ┌─ Content Attribution ────────────┐│
│ │           ⚠️ Low stock     ││ │ 🎬 "Review Serum VitC" (TikTok) ││
│ │ ─────────────────────────  ││ │    47K views → 34 orders (38%)  ││
│ │ Total stock: 245           ││ │ 🎬 "5 lý do nên dùng" (IG)     ││
│ │ Total sold (30d): 89       ││ │    12K views → 15 orders (17%)  ││
│ │ [✏ Edit stock] [🔔 Alert] ││ │ 📝 "Serum review" Script        ││
│ └───────────────────────────┘│ │ 💡 "VitC myths" Idea            ││
│                              │ │ 🔗 Affiliate #AF-12 (Conv 7.2%) ││
│ ┌─ Sales Chart ─────────────┐│ │ 🏷 Offer: "Giảm 10%" (SPRING10)││
│ │ [Tab: Revenue | Orders |   ││ │ 📊 Campaign: Spring Sale 2026  ││
│ │  Conversion]              ││ │                                   ││
│ │                            ││ │ [+ Link nội dung khác]           ││
│ │ [📈 Line chart: 30 days]  ││ │ [📊 Xem attribution analytics →]││
│ │                            ││ └──────────────────────────────────┘│
│ │ Period: [7d · 30d · 90d]   ││                                      │
│ └───────────────────────────┘│ ┌─ Profit Breakdown ────────────────┐│
│                              │ │ 💰 Revenue:        26,611,000đ   ││
│ ┌─ Customer Reviews ────────┐│ │ 🏷 Platform fee:   -2,128,880đ  ││
│ │ ⭐⭐⭐⭐⭐ (5/5)  2h ago  ││ │ 🤝 Commission:     -2,661,100đ  ││
│ │ "Serum tốt lắm, mình mua  ││ │ 💳 Payment fee:      -532,220đ  ││
│ │  lần 2 rồi ạ"             ││ │ ────────────────────────────────  ││
│ │                            ││ │ Net Revenue:       21,288,800đ   ││
│ │ ⭐⭐⭐⭐ (4/5)  1d ago    ││ │ COGS:             -13,350,000đ   ││
│ │ "Tốt nhưng giao hơi lâu"  ││ │ ────────────────────────────────  ││
│ │                            ││ │ 💚 Profit:         7,938,800đ   ││
│ │ Sort: [Mới nhất ▾] Show 5 ││ │ 📊 Margin: 29.8%                ││
│ │ [Xem tất cả đánh giá (156)]││ │ Source: [🟢 Official] + [🔵 Imp]││
│ └───────────────────────────┘│ │ [? Giải thích cách tính]         ││
│                              │ └──────────────────────────────────┘│
│ ┌─ Platform Sync ───────────┐│                                      │
│ │ 🎵 TikTok Shop:  ✅ Synced ││ ┌─ Actions ──────────────────────┐ │
│ │    Last: 5 phút trước      ││ │ [📤 Tạo nội dung]              │ │
│ │ 🛍 Shopee:       🟡 Pending││ │ [🏷 Tạo offer / coupon]       │ │
│ │    Last: 2 giờ trước       ││ │ [🔗 Tạo affiliate link]       │ │
│ │ [🔄 Force sync all]       ││ │ [📋 Copy product link]         │ │
│ └───────────────────────────┘│ │ [📎 Xuất product brief PDF]    │ │
│                              │ │ [🗑 Archive sản phẩm]          │ │
│                              │ └─────────────────────────────────┘ │
└──────────────────────────────┴───────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
ProductDetailPage
├── AppShell (shared)
│   ├── Sidebar
│   └── TopBar
├── PageHeader
│   ├── BackLink ("← Sản phẩm" → /products)
│   ├── ProductTitle ("Serum Vitamin C 30ml")
│   ├── EditButton ("✏️ Edit" → /products/[id]/edit)
│   └── MoreMenu (⋮)
│       ├── "📎 Export product brief (PDF)"
│       ├── "📋 Copy product link"
│       ├── "🔄 Force sync"
│       ├── "📊 Full analytics"
│       ├── "🗑 Archive" (confirm)
│       └── "🚨 Report issue"
├── SplitView
│   ├── MainPanel (60%)
│   │   ├── ImageGallery
│   │   │   ├── MainImage (400×400, CDN, zoom on hover)
│   │   │   └── ThumbnailStrip (horizontal scroll, click to swap main)
│   │   ├── ProductInfoCard
│   │   │   ├── ProductName
│   │   │   ├── Description (expandable if > 200 chars)
│   │   │   ├── Ingredients / Details (expandable accordion)
│   │   │   └── Tags / Categories
│   │   ├── VariantsInventoryCard
│   │   │   ├── VariantTable
│   │   │   │   └── VariantRow[]
│   │   │   │       ├── VariantName ("30ml")
│   │   │   │       ├── Price (formatted VND)
│   │   │   │       ├── StockQuantity
│   │   │   │       └── LowStockWarning (⚠️ if below threshold)
│   │   │   ├── TotalStockSummary ("Total: 245")
│   │   │   ├── TotalSoldSummary ("Sold (30d): 89")
│   │   │   ├── EditStockButton ("✏ Edit stock")
│   │   │   └── SetAlertButton ("🔔 Set low stock alert")
│   │   ├── SalesChart
│   │   │   ├── ChartTypeTabs (Revenue | Orders | Conversion Rate)
│   │   │   ├── LineChart (Chart.js — 30-day line with comparison overlay)
│   │   │   ├── ComparisonToggle ("vs previous period" dotted line)
│   │   │   └── PeriodSelector (7d / 30d / 90d)
│   │   ├── CustomerReviewsCard
│   │   │   ├── AverageRating ("⭐ 4.5/5")
│   │   │   ├── ReviewCount ("156 đánh giá")
│   │   │   ├── RatingDistribution (5-star bar chart)
│   │   │   ├── ReviewList (latest 5)
│   │   │   │   └── ReviewItem[]
│   │   │   │       ├── StarRating
│   │   │   │       ├── ReviewText (truncated, expand on click)
│   │   │   │       ├── BuyerName
│   │   │   │       ├── ReviewDate (relative)
│   │   │   │       └── Platform (synced from)
│   │   │   ├── SortSelector ("Mới nhất" / "Đánh giá cao" / "Đánh giá thấp")
│   │   │   └── ViewAllLink ("Xem tất cả (156)")
│   │   └── PlatformSyncCard
│   │       └── PlatformSync[]
│   │           ├── PlatformIcon + Name
│   │           ├── SyncStatus (✅ Synced / 🟡 Pending / 🔴 Failed)
│   │           ├── LastSyncTime (relative)
│   │           └── ForceSyncButton ("🔄")
│   └── SidePanel (40%)
│       ├── QuickInfoCard
│       │   ├── PriceDisplay ("299,000đ" or "từ 299,000 - 799,000đ")
│       │   ├── StatusBadge (🟢 Active / 🟡 Draft / 🔴 Out of Stock)
│       │   ├── SourceBadge (🎵 TikTok Shop / 🛍 Shopee / Manual)
│       │   ├── SKUInfo ("SVT-C · 3 variants")
│       │   ├── CategoryBreadcrumb ("Skincare > Serum")
│       │   ├── CreatedDate
│       │   └── LastSyncIndicator ("5 phút trước 🟢")
│       ├── SalesSummaryCard
│       │   ├── OrderCount ("89" + delta badge "+12%")
│       │   ├── RevenueAmount ("26.6M VND" + delta "+18%")
│       │   ├── CommissionAmount ("2.66M VND")
│       │   ├── NetRevenue ("23.9M VND")
│       │   ├── AverageRating ("⭐ 4.5/5 (156)")
│       │   ├── WorkspaceRank ("#3")
│       │   ├── PeriodTabs (7d / 30d / 90d / All)
│       │   └── FullAnalyticsLink ("📊 Full analytics →")
│       ├── ContentAttributionCard
│       │   └── AttributionItem[]
│       │       ├── ContentIcon (🎬 / 📝 / 💡 / 🔗 / 🏷 / 📊)
│       │       ├── ContentTitle (clickable link)
│       │       ├── PerformanceSnippet ("47K views → 34 orders (38%)")
│       │       └── ContributionPercentage (of total product orders)
│       │   ├── LinkContentButton ("+ Link nội dung khác")
│       │   └── ViewAttributionLink ("📊 Xem attribution analytics →")
│       ├── ProfitBreakdownCard
│       │   ├── RevenueLine ("💰 Revenue: 26,611,000đ")
│       │   ├── PlatformFeeLine ("🏷 Platform fee: -2,128,880đ")
│       │   ├── CommissionLine ("🤝 Commission: -2,661,100đ")
│       │   ├── PaymentFeeLine ("💳 Payment fee: -532,220đ")
│       │   ├── Divider
│       │   ├── NetRevenueLine ("Net Revenue: 21,288,800đ")
│       │   ├── COGSLine ("COGS: -13,350,000đ")
│       │   ├── Divider
│       │   ├── ProfitLine ("💚 Profit: 7,938,800đ" — bold, green)
│       │   ├── MarginPercentage ("📊 Margin: 29.8%")
│       │   ├── SourceBadges (S009 — Official + Imported)
│       │   └── ExplainLink ("? Giải thích cách tính" → tooltip/drawer)
│       └── ActionsCard
│           ├── CreateContentButton ("📤 Tạo nội dung")
│           ├── CreateOfferButton ("🏷 Tạo offer / coupon")
│           ├── CreateAffiliateButton ("🔗 Tạo affiliate link")
│           ├── CopyLinkButton ("📋 Copy product link")
│           ├── ExportBriefButton ("📎 Xuất product brief PDF")
│           └── ArchiveButton ("🗑 Archive" — destructive, confirm)
└── ContentLinkPickerModal (for "+ Link nội dung khác")
    ├── SearchInput (search scripts, videos, ideas)
    ├── ContentList (filterable)
    └── LinkButton
```

---

## 5. Displayed Data / Data Binding

| UI Element | Data Source | API | Display Format | Source Class | Cache |
|---|---|---|---|---|---|
| Product name | `products.name` | `ProductService/Get(id)` | Text | Official | 5m |
| Description | `products.description` | Same | Text (expandable) | Official | 5m |
| Images | `product_images[].url` | Same (eager) | CDN images, 400×400 main, 80×80 thumbs | Official | CDN |
| Price | `products.price` or `MIN/MAX(variants.price)` | Same | "299,000đ" or "từ 299K - 799K" | Official | 5m |
| Status | `products.catalog_status` | Same | Badge: 🟢/🟡/🔴 | Official | 5m |
| Source platform | `products.source_platform` | Same | Platform icon + name | Official | 5m |
| SKU | `product_skus.sku_code` | Same | "SVT-C" | Official | 5m |
| Category | `products.category` | Same | "Skincare > Serum" breadcrumb | Official | 5m |
| Variants | `product_skus[]` | Same (eager) | Table: name + price + stock | Official | 5m |
| Stock per variant | `product_skus.stock_quantity` | Same | Integer, ⚠️ if low | Official (SSE) | RT |
| Low stock threshold | `product_skus.low_stock_threshold` (default 10) | Same | ⚠️ indicator | Config | 5m |
| Orders (period) | `orders` aggregated by product | `ProductService/GetSalesStats(id, period)` | "89" with delta | ClickHouse | 5m |
| Revenue (period) | `orders.total_amount` sum | Same | "26.6M VND" with delta | ClickHouse | 5m |
| Commission | `orders.platform_commission` sum | Same | "2.66M VND" | Official | 5m |
| Net revenue | Computed: revenue - fees | Same | VND format | Computed | 5m |
| COGS | `products.cogs × units_sold` | Same | VND format | Imported | 5m |
| Profit | Computed: net revenue - COGS | Same | VND with color (green/red) | Computed | 5m |
| Margin | Computed: profit / revenue × 100 | Same | "29.8%" | Computed | 5m |
| Avg rating | `product_reviews` avg(rating) | Same | "⭐ 4.5/5 (156)" | Official | 15m |
| Reviews | `product_reviews[]` | `ProductService/GetReviews(id, page)` | Text + stars + date | Official | 15m |
| Sales chart | ClickHouse daily aggregation | `ProductService/GetSalesChart(id, period)` | Line chart data | Computed | 30m |
| Content links | `product_content_links JOIN` | `ProductService/GetLinkedContent(id)` | List items with metrics | Inferred | 15m |
| Attribution % | Computed from order attribution | Same | "38%" contribution badge | Inferred | 15m |
| Affiliate links | `affiliate_links WHERE product_id` | Same (join) | Conversion rate | Official | 15m |
| Platform sync | `connectors.last_sync_at` | `ConnectorService/GetSyncStatus(product_id)` | Relative time + status | System | 1m |
| Workspace rank | Computed across all products | `ProductService/GetRank(id)` | "#3" | Computed | 1h |

---

## 6. User Actions

| # | Action | Trigger | API Call | System Response | Permission |
|---|---|---|---|---|---|
| 1 | Edit product | "✏️ Edit" | — | Navigate → `/products/[id]/edit` | `product:manage` |
| 2 | Create content | "📤 Tạo nội dung" | — | Navigate → `/ideas/new?product_id=[id]` (idea pre-filled with product context) | `idea:create` |
| 3 | Create offer | "🏷 Tạo offer" | — | Navigate → `/offers/new?product_id=[id]` | `offer:manage` |
| 4 | Create affiliate link | "🔗 Tạo affiliate link" | — | Navigate → `/commerce/affiliates?create=true&product_id=[id]` | `affiliate:manage` |
| 5 | Force sync | "🔄 Force sync" on platform row | `ConnectorService/SyncProduct(id)` | Spinner → data refreshes. Toast "✅ Đã đồng bộ." | `product:manage` |
| 6 | Force sync all | "🔄 Force sync all" | `ConnectorService/SyncProduct(id, all_platforms)` | All platforms sync. Toast "✅ Đã đồng bộ tất cả." | `product:manage` |
| 7 | View full analytics | "📊 Full analytics" | — | Navigate → `/analytics/products/[id]` | `report:read` |
| 8 | Link content | "+ Link nội dung khác" → picker | `ProductService/LinkContent(product_id, content_id)` | Content appears in Attribution card | `product:manage` |
| 9 | Edit stock | "✏ Edit stock" | → inline edit or modal | `ProductService/UpdateStock(variant_id, quantity)` | `product:manage` |
| 10 | Set stock alert | "🔔 Set low stock alert" | `ProductService/SetAlertThreshold(id, threshold)` | Alert saved. Toast "🔔 Sẽ thông báo khi dưới {n}." | `product:manage` |
| 11 | Archive product | "🗑 Archive" → confirm | `ProductService/Archive(id)` | Product moved to archive. Navigate → `/products`. Toast "Đã lưu trữ." | `product:manage` |
| 12 | Change chart period | Click period tab (7d/30d/90d) | `ProductService/GetSalesChart(id, period)` | Chart re-renders with new data | `product:read` |
| 13 | Change stats period | Click period tab on Sales Summary | `ProductService/GetSalesStats(id, period)` | Stats update with deltas | `product:read` |
| 14 | View review details | Click "Xem tất cả (156)" | `ProductService/GetReviews(id, { page:1 })` | Navigate → reviews drawer/modal with all reviews | `product:read` |
| 15 | Copy product link | "📋 Copy product link" | — (clipboard) | External product URL copied. Toast "Đã copy link sản phẩm." | `product:read` |
| 16 | Export brief | "📎 Xuất product brief" | Client-side PDF generation | PDF download with product summary + sales data | `product:read` |
| 17 | View content | Click attribution item | — | Navigate → content detail page | `idea:read` |
| 18 | Explain profit | "? Giải thích cách tính" | — | Drawer opens with formula explanation + source class legend | `product:read` |

---

## 7. States / State Machine

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial page load | Split view skeleton: image placeholder, info shimmer, variant table skeleton |
| LOADED | Data received | Full product detail with all sections populated |
| NOT_FOUND | Product ID invalid or no access | "Sản phẩm không tồn tại hoặc bạn không có quyền xem." + back link |
| SYNCING | Force sync in progress | PlatformSyncCard: spinner on syncing platform + "Đang đồng bộ..." |
| LOW_STOCK | Any variant below threshold | Yellow banner: "⚠️ {variant_name} sắp hết hàng (còn {n})." |
| OUT_OF_STOCK | Total stock = 0 | Red banner: "🔴 Sản phẩm hết hàng trên tất cả variants." |
| DELETED_ON_PLATFORM | Product removed from source | Warning banner: "⚠️ Sản phẩm đã bị xóa trên {platform}. Dữ liệu lịch sử được giữ lại." |
| NO_COGS | COGS not entered | Profit section: "Chưa nhập giá vốn (COGS). [Cập nhật →]" with link to edit |
| ERROR | API error | Error page: "Không tải được thông tin sản phẩm. [Thử lại]" |

---

## 8. Validation Rules

### Edit Stock (Inline)
| Field | Rule | Error Message |
|---|---|---|
| Quantity | Integer ≥ 0 | "Số lượng phải ≥ 0" |
| Quantity | Max 99,999 | "Tối đa 99,999 đơn vị" |

### Set Alert Threshold
| Field | Rule | Error Message |
|---|---|---|
| Threshold | Integer 1-999 | "Ngưỡng cảnh báo phải từ 1-999" |

### Link Content
| Field | Rule | Error Message |
|---|---|---|
| Content | Not already linked | "Nội dung này đã được liên kết" |
| Content | Must be from same workspace | "Chỉ liên kết nội dung cùng workspace" |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View product detail | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| View sales stats | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View revenue data | ✅ | ✅ | ✅ | ⚠️ see orders not revenue | ❌ | ❌ | ❌ |
| View profit/COGS/margin | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| View reviews | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Edit stock | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Edit product | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Archive product | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Force sync | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Create content from product | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Create offer/affiliate | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Link content | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Export brief | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Manager**: Can see revenue and fees but NOT profit/COGS/margin. Shows "Nâng cấp quyền để xem lợi nhuận."
- **Editor**: Can see order counts and content attribution but NOT revenue amounts. Revenue fields show "—".
- **Contributor/Viewer**: Can see product info, images, reviews. No sales/revenue data.

---

## 10. Navigation Map

```
Product Detail (/products/[id])
├── → /products/[id]/edit             (Edit product)
├── → /ideas/new?product_id=[id]      (Create content idea)
├── → /offers/new?product_id=[id]     (Create offer)
├── → /commerce/affiliates?create     (Create affiliate link)
├── → /analytics/products/[id]        (Full product analytics)
├── → /content/[type]/[content_id]    (Click attribution item)
├── → /orders?product_id=[id]         (View product orders)
└── ← /products                       (Back to list)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Product not found | Invalid ID or deleted | Full-page: "Sản phẩm không tồn tại. [← Về danh sách]" | Navigate back |
| Permission denied | Insufficient role | "Bạn không có quyền xem sản phẩm này. [Liên hệ admin]" | Contact admin |
| Sync failed | Platform API error | PlatformSyncCard: "🔴 Đồng bộ thất bại: {error}. [Thử lại]" | Retry sync |
| Sales data unavailable | ClickHouse timeout | "📊 Dữ liệu bán hàng tạm thời không khả dụng." Sales sections show "—" | Auto-retry |
| COGS missing | User hasn't entered COGS | Profit section: gentle prompt "Chưa nhập giá vốn (COGS). [Cập nhật →]" | Click to edit |
| Platform disconnected | Connector inactive | Sync card: "⚫ Nền tảng ngắt kết nối. [Kết nối lại →]" | Reconnect |
| Stock update fails | API error | Toast: "Không cập nhật được tồn kho. [Thử lại]" | Retry |
| Content link fails | Network error | Toast: "Không liên kết được nội dung. [Thử lại]" | Retry |
| Archive fails | Product has active orders | Modal: "Không thể lưu trữ. Sản phẩm có {n} đơn hàng đang xử lý." | Wait for orders to complete |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Image gallery | `alt="{product.name} - image {n} of {total}"`. Keyboard: Arrow keys navigate thumbnails. |
| Variant table | `role="table"`, `aria-label="Danh sách biến thể sản phẩm"`. Headers: `scope="col"`. |
| Low stock warning | `role="alert"`, `aria-label="Cảnh báo: {variant} sắp hết hàng, còn {n}"` |
| Sales chart | `aria-label="Biểu đồ doanh thu 30 ngày"`. Alternative: table data below chart for screen readers. |
| Status badge | Color + icon + text (not color-only). `aria-label="Trạng thái: Đang hoạt động"` |
| Star ratings | `aria-label="Đánh giá: 4.5 trên 5 sao, 156 đánh giá"` |
| Price breakdown | Each line has `aria-label` with full description |
| Source badges (S009) | `aria-label="Nguồn dữ liệu: Official - từ API nền tảng"` |
| Action buttons | All have `aria-label` with full description of action |
| Period tabs | `role="tablist"`, `role="tab"` with `aria-selected` |
| Color contrast | WCAG 2.1 AA (4.5:1) for all text |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell render | 0ms | App Shell (SSR). PageHeader with back link visible. |
| Product info | 100-300ms | Name, images, description populate |
| Variant table | 100-400ms | Variant rows appear |
| Sales summary | 300-600ms | Stats fade in with counter animation |
| Sales chart | 400-800ms | Chart draws left→right animation |
| Reviews | 400-800ms | Review cards fade in staggered |
| Content attribution | 500-1000ms | Attribution items populate |
| Profit breakdown | 500-1000ms | Financial lines populate top→bottom |

---

## 14. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| LCP | < 1.5s | First product image + name |
| FID | < 100ms | Click on action button |
| CLS | < 0.05 | No shift when images load (fixed aspect ratio placeholder) |
| TTI | < 2.5s | All sections interactive |
| Chart render | < 500ms | Sales chart drawn after data available |
| Image load | Lazy | Thumbnails load on scroll into view |
| API response | < 500ms | ProductService/Get with all joins |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Stock levels | SSE `/events/products/{id}` | Real-time — stock numbers animate on change |
| New orders | SSE `/events/orders` (filtered by product) | Real-time — sales summary counter increments |
| Platform sync | SSE `/events/sync` | Real-time during active sync |
| New reviews | Polling | Every 15 minutes |
| Price changes (from platform) | SSE `/events/products/{id}` | Real-time — price displays update |

### Real-time UX
- Stock change: number transitions with animated counter
- New order: Sales summary "Orders" count pulses briefly
- Sync complete: platform status icon transitions ✅

---

## 16. Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "26.611.000đ")
- Compact format: "26.6M VND" for summary cards, full format in breakdown
- Dates: DD/MM/YYYY or relative ("5 phút trước")
- Percentages: "29.8%" (no change needed)
- Source class names: Keep English ("Official", "Imported", "Estimated", "Inferred") — industry standard
- Tone: Informative, data-driven — this is a business intelligence screen

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `product.detail.viewed` | Page load | `product_id`, `source_platform`, `status`, `variant_count`, `source` |
| `product.detail.action` | Any action button clicked | `product_id`, `action_type` (create_content/offer/affiliate/sync/archive) |
| `product.detail.chart.period_changed` | Period tab clicked | `product_id`, `chart_type`, `period` |
| `product.detail.content.linked` | Content linked | `product_id`, `content_type`, `content_id` |
| `product.detail.content.clicked` | Attribution item clicked | `product_id`, `content_id`, `content_type` |
| `product.detail.stock.edited` | Stock updated | `product_id`, `variant_id`, `old_quantity`, `new_quantity` |
| `product.detail.synced` | Force sync triggered | `product_id`, `platform` |
| `product.detail.review.viewed` | "Xem tất cả" clicked | `product_id`, `review_count` |
| `product.detail.profit.explained` | "Giải thích" clicked | `product_id`, `margin` |
| `product.detail.exported` | Brief exported | `product_id`, `format` (pdf) |
| `product.detail.archived` | Product archived | `product_id`, `total_orders`, `total_revenue` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Action buttons, "Tạo nội dung" CTA |
| `--color-success` | ✅ Sync OK, 🟢 Active status, profit positive |
| `--color-warning` | ⚠️ Low stock, 🟡 Pending sync, 🟡 Draft |
| `--color-danger` | 🔴 Out of stock, sync failed, profit negative |
| `--color-profit-positive` | Green for positive profit/margin |
| `--color-profit-negative` | Red for negative profit/margin |
| `--color-surface-primary` | Page background |
| `--color-surface-elevated` | Cards (variant table, reviews, profit breakdown) |
| `--color-text-primary` | Product name, section headers |
| `--color-text-secondary` | Metadata, timestamps, descriptions |
| `--color-text-financial` | Revenue/profit numbers (mono font) |
| `--color-source-official` | S009 Official badge |
| `--color-source-imported` | S009 Imported badge |
| `--color-source-inferred` | S009 Inferred badge |
| `--font-mono` | Financial numbers, SKU codes |
| `--radius-card` | Card border-radius (12px) |
| `--shadow-card` | Card elevation shadow |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/products/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → fetch product with all relations

### Data Fetching Strategy
```
+page.server.ts:
  const product = await productService.get(params.id, {
    include: ['variants', 'images', 'reviews_summary']
  })
  
  const [salesStats, linkedContent, syncStatus] = await Promise.all([
    productService.getSalesStats(params.id, '30d'),
    productService.getLinkedContent(params.id),
    connectorService.getSyncStatus(params.id)
  ])
  
  // Profit breakdown: only if user has profit:read permission
  let profitData = null
  if (hasPermission('profit:read')) {
    profitData = productService.getProfitBreakdown(params.id, '30d')
  }
```

### Sales Chart
- **Library**: Chart.js (lightweight) or uPlot (performance-optimized)
- **Data**: ClickHouse daily aggregation
- **Comparison**: Dashed overlay for previous period comparison

### Source Class Integration (S009)
- Each financial line in Profit Breakdown has a `source_class` attribute
- Clicking the badge opens S009 "Why this number?" drawer
- Mixed sources show highest-uncertainty badge

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W060] Product List | Parent: list of all products |
| [W063] Order Detail | Links to product from order items |
| [W066] Offer List | Offers linked to this product |
| [W069] Affiliate Links | Affiliate links for this product |
| [W081] Profit Dashboard | Aggregated profit data |
| [W084] Reconciliation | Revenue reconciliation |
| [M028] Mobile Products | Mobile equivalent |
| [S009] Trust Badge | Source class display |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite**: Upgraded from 198-line Tier C with generic boilerplate to 530+ line full spec. Added: complete split-view layout with main/side, image gallery, variant inventory management, 30-day sales chart with period selector, customer reviews with rating distribution, content attribution with contribution percentages, full profit breakdown with S009 source class integration, platform sync per-product, 18 user actions, 9 states including low stock/out of stock/deleted-on-platform, role-based data visibility (Editor/Manager profit restrictions), 11 analytics events, real-time stock updates via SSE. Removed all generic boilerplate. Standardized Screen ID from W56 to W061. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |

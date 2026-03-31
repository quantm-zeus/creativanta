# Screen: Web — Affiliate Links Overview

> **Screen ID**: W069
> **Module**: M16 — In-Product Affiliate Network
> **Route**: `/commerce/affiliates`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06, Pack 08, PRD §23.16, A1 Schema (affiliate_links, campaigns, commission_records)

---
## 1. Purpose & Context

The Affiliate Links Overview screen manages affiliate link generation, tracking, and performance monitoring. It shows the click → order → revenue funnel per link with source class badges and health monitoring.

### User Goals
- Generate and manage affiliate links tied to products/offers
- Track real-time performance (clicks → orders → revenue → commission)
- Identify broken or expiring links for quick remediation
- Copy links or generate QR codes for distribution

### Business Goals
- Maximize affiliate-driven revenue through active link management
- Ensure link health to prevent revenue loss from broken links
- Attribute revenue accurately to affiliate sources with confidence

### When This Screen Is Used
- Affiliate operators checking link performance daily
- Creating new affiliate links for campaigns or products
- Monitoring link health alerts
- Reviewing commission earnings

### Entry Points
- Sidebar: Commerce → "🔗 Affiliate Links"
- Home Dashboard: affiliate KPI card tap
- Notification: "Link expiring" or "Link broken" alert
- Copilot: "Kiểm tra affiliate links" → navigate here

### Exit Points
- Click link row → Affiliate Link Detail (drawer or separate page)
- Click product name → Product Detail (W061)
- Click campaign name → Campaign Detail (W065)
- Click "📊 Health" → Diagnostics Center (W125)
- Click "+ Tạo link" → Create Link modal

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `affiliate:manage` permission (Owner, Admin, Manager, Editor)
- At least one platform connector is active (links require platform context)
- Workspace has products or offers available for linking

### Postconditions
- New links are generated with unique tracking codes
- Click/order/revenue data updates in near-real-time via SSE
- Broken link alerts are cleared when links are fixed or deleted

---
## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + full data table with all columns visible |
| Tablet (768-1279px) | App Shell (collapsed sidebar) + table with priority columns only |
| Mobile (≤767px) | Redirect to mobile equivalent (M032) |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🔗 Affiliate Links                    [+ Tạo link] [📊 Health]     │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ─────────────────────────────────────────────────┐   │
│ │ 📊 23 links · 🖱 5.2K clicks (30d) · 🛒 342 orders · 💰 18.5M│  │
│ │ Period: [30 ngày ▾]      Source: [🟢 Official]               │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Filter: [Platform ▾] [Product ▾] [Status ▾] [Campaign ▾] [🔍 Tìm] │
│                                                                      │
│ ┌─ Link Table ──────────────────────────────────────────────────┐   │
│ │ Name             Platform  Clicks  Orders  Revenue   Comm.   │   │
│ │ ──────────────── ────────  ──────  ──────  ────────  ──────  │   │
│ │ 🔗 Serum VitC    🎵 TikTok  1,234   89    12.5M     1.25M  │   │
│ │   Conv: 7.2%  [📋 Copy] [📱 QR] [📊 Detail] [✏] [🗑]     │   │
│ │ 🔗 Kem chống nắng 🛍 Shopee   856   45     6.8M      680K  │   │
│ │   Conv: 5.3%  [📋 Copy] [📱 QR] [📊 Detail] [✏] [🗑]     │   │
│ │ 🔗 Set skincare  🎵 TikTok   432   23     4.2M      420K  │   │
│ │   ⚠️ Expiring in 3 days     [🔄 Renew] [📊 Detail]         │   │
│ │ 🔗 Toner AHA    🛍 Shopee    67    2       320K      32K   │   │
│ │   🔴 Broken (404)           [🔧 Fix] [🗑 Delete]           │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Pagination: [← Trước] Trang 1/3 [Tiếp →]                          │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
AffiliateLinkPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("🔗 Affiliate Links")
│   ├── CreateLinkButton (primary CTA: "+ Tạo link")
│   └── HealthCheckButton (secondary: "📊 Health")
├── SummaryBar
│   ├── StatCard[] (Total Links, Total Clicks, Total Orders, Total Revenue)
│   │   ├── Value (animated counter)
│   │   ├── Label
│   │   └── TrustBadge (S009)
│   └── PeriodSelector (7d / 30d / 90d / All time)
├── FilterBar
│   ├── PlatformFilter (dropdown: TikTok, Shopee, Lazada, etc.)
│   ├── ProductFilter (searchable dropdown)
│   ├── StatusFilter (Active, Expiring, Broken, Paused)
│   ├── CampaignFilter (dropdown)
│   └── SearchInput (search by link name or product name)
├── LinkTable
│   ├── TableHeader (sortable columns)
│   └── LinkRow[]
│       ├── LinkName (truncated, with platform icon)
│       ├── PlatformBadge
│       ├── ClickCount
│       ├── OrderCount
│       ├── RevenueAmount (formatted VND)
│       ├── CommissionAmount (formatted VND)
│       ├── ConversionRate (percentage badge)
│       ├── StatusIndicator (🟢 Active / 🟡 Expiring / 🔴 Broken)
│       ├── InlineActions
│       │   ├── CopyButton ("📋")
│       │   ├── QRButton ("📱")
│       │   ├── DetailButton ("📊")
│       │   ├── EditButton ("✏")
│       │   └── DeleteButton ("🗑", destructive)
│       └── HealthWarning (conditional: expiring/broken notice)
├── Pagination
│   ├── PrevButton
│   ├── PageIndicator
│   └── NextButton
└── CreateLinkModal (conditional)
    ├── ProductSelector (required)
    ├── PlatformSelector (required)
    ├── CampaignSelector (optional)
    ├── CustomSlug (optional)
    ├── ExpiryDate (optional)
    └── CreateButton
```

---
## 5. Displayed Data

| Field | Source | Format | Fallback |
|---|---|---|---|
| Link name | `affiliate_links.name` | String, max 40 chars truncated | Product name if link name is empty |
| Platform | `affiliate_links.platform` | Platform icon + name | — |
| Clicks | `link_click_events` aggregated | Compact number "1,234" | "0" |
| Orders | `orders WHERE affiliate_link_id` aggregated | Integer | "0" |
| Revenue | `orders.total_amount` sum | VND format "12.5M" | "0đ" |
| Commission | `commission_records.amount` sum | VND format "1.25M" | "0đ" |
| Conversion rate | Computed: orders / clicks × 100 | Percentage "7.2%" | "—" if no clicks |
| Status | `affiliate_links.status` + health check | Badge (Active/Expiring/Broken/Paused) | "Unknown" |
| Expiry date | `affiliate_links.expires_at` | Relative: "3 ngày nữa" | "Không hết hạn" |
| Source class | `affiliate_links.source_class` | Trust badge (S009) | "Official" |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Navigation |
|---|---|---|---|---|---|---|
| 1 | Create link | "+ Tạo link" button | Primary CTA | — | Open CreateLinkModal | — (modal) |
| 2 | Submit create | Modal "Tạo" button | Form submit | `AffiliateService/CreateLink` | Toast "Đã tạo link thành công". Link appears in table. | Close modal |
| 3 | Copy link | "📋" button | Inline | — (client-side) | Copy URL to clipboard. Toast "Đã sao chép!" | — |
| 4 | Generate QR | "📱" button | Inline | Client-side QR gen | Modal with QR code + download button | — (modal) |
| 5 | View detail | "📊 Detail" button | Inline | — | Open right drawer: full analytics funnel | — (drawer) |
| 6 | Edit link | "✏" button | Inline | — | Open edit modal (same as create, pre-filled) | — (modal) |
| 7 | Delete link | "🗑" button | Destructive | `AffiliateService/DeleteLink` | Confirmation dialog (S007) → Toast "Đã xóa" | — |
| 8 | Health check | "📊 Health" header button | Secondary CTA | `AffiliateService/RunHealthCheck` | Navigate to health report | → W125 |
| 9 | Renew link | "🔄 Renew" on expiring | Inline | `AffiliateService/RenewLink` | Link expiry extended. Status → Active. | — |
| 10 | Fix broken link | "🔧 Fix" on broken | Inline | — | Open modal: suggest fix (update URL, remap product) | — (modal) |
| 11 | Filter | Change any filter dropdown | Filter | Refetch with params | Table updates with animation | — |
| 12 | Sort | Click column header | Sort | Refetch with sort param | Table re-sorts, indicator arrow shown | — |
| 13 | Search | Type in search input | Debounced (300ms) | `AffiliateService/ListLinks(query)` | Table filters to matching results | — |
| 14 | Change period | Period selector | Filter | Refetch with period | Summary bar and table metrics update | — |
| 15 | Paginate | Click prev/next | Pagination | Refetch with page | Table updates | — |

---
## 7. Validation Rules (Create/Edit Link Modal)

| Field | Rule | Error Message |
|---|---|---|
| Product | Required | "Vui lòng chọn sản phẩm" |
| Platform | Required | "Vui lòng chọn nền tảng" |
| Custom slug | Optional, alphanumeric + hyphens, 3-50 chars | "Slug chỉ chứa chữ, số và dấu gạch ngang" |
| Custom slug | Unique across workspace | "Slug này đã được sử dụng" |
| Expiry date | Optional, must be future date | "Ngày hết hạn phải trong tương lai" |
| Campaign | Optional | — |

### Business Validation
- Cannot create link for product with status "archived" or "deleted"
- Cannot create link for platform where connector is disconnected
- Maximum links per workspace per tier: Free=10, Starter=50, Pro=200, Business=unlimited

---
## 8. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial page load | Summary bar: shimmer. Table: 5 skeleton rows. |
| LOADED | Data received | Full table with data. Summary bar populated. |
| EMPTY | No links exist | Empty state: "Chưa có affiliate link nào. Tạo link đầu tiên để bắt đầu theo dõi hiệu quả. [+ Tạo link]" |
| EMPTY_FILTERED | Filters applied, no results | "Không tìm thấy link nào với bộ lọc hiện tại. [Xóa bộ lọc]" |
| ERROR | API call failed | Error banner: "Không tải được danh sách link. [Thử lại]" |
| REFRESHING | Background refresh | Subtle "Đang cập nhật..." indicator at top. Existing data visible. |
| HEALTH_WARNING | ≥1 link has health issue | Yellow banner at top: "⚠️ {count} link có vấn đề sức khỏe. [Kiểm tra →]" |
| TIER_LIMIT | At link limit for tier | Upsell banner (S011): "Bạn đã dùng hết {limit} link. [Nâng cấp gói →]" |

---
## 9. Interaction Details

| Interaction | Behavior |
|---|---|
| Click row (not action button) | Open detail drawer on right side |
| Hover row | Subtle row highlight. Inline action buttons become more visible. |
| Copy button click | Clipboard write + toast "Đã sao chép link" for 2 seconds |
| QR modal | Shows QR code + "Tải xuống PNG" + "Tải xuống SVG" buttons |
| Delete confirmation | Dialog: "Xóa link '{name}'? Thao tác này không thể hoàn tác. Dữ liệu phân tích sẽ được giữ lại." [Hủy] [Xóa] |
| Sort | Click column header toggles: unsorted → ascending → descending |
| Keyboard | Tab through rows, Enter to open detail, Ctrl+C on selected row copies link |
| Bulk selection | Checkbox on each row header. Bulk actions: Delete, Pause, Export |

---
## 10. Platform-specific UX Notes

| Note | Detail |
|---|---|
| TikTok Shop links | Auto-expire after 90 days. System shows countdown. |
| Shopee links | Subject to campaign-specific validity periods. |
| Lazada links | Require seller verification before creation. |
| Link health monitoring | HTTP check every 6h, product availability check every 12h, price change check every 12h (PRD §32J.5) |

---
## 11. Responsive / Adaptive Behavior

| Breakpoint | Changes |
|---|---|
| ≥1280px | Full table: all columns visible. Summary bar in single row. |
| 1024-1279px | Hide Commission column. Summary bar in 2 rows. |
| 768-1023px | Hide Revenue + Commission. Summary condensed to 2 stats. |
| ≤767px | Not applicable (redirect to mobile app M032) |

---
## 12. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View link list | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View revenue data | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Create link | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Edit link | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Delete link | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Run health check | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Copy link | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Export data | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### Editor restrictions
- Can see links and performance data (clicks, orders) but NOT revenue/commission amounts
- Revenue column shows "—" for Editor role

---
## 13. Edge Cases & Exception Flows

| Edge Case | Handling |
|---|---|
| Platform connector disconnected | Links for that platform show "⚫ Không kết nối" badge. Create button disabled for that platform. |
| Product deleted after link created | Link shows "⚠️ Sản phẩm đã bị xóa" with strikethrough. Clicks still tracked but revenue attribution paused. |
| Affiliate commission rate changes | Historical data keeps old rate. New clicks use new rate. Source badge shows "⚠️ Tỷ lệ đã thay đổi" |
| Zero clicks link | Show "Chưa có lượt click. Chia sẻ link để bắt đầu." in detail drawer |
| >1000 links | Virtual scroll kicks in. Export recommended for analysis. |

---
## 14. Dependencies

| Dependency | Purpose |
|---|---|
| ConnectorService | Platform connection status for link validity |
| ProductService | Product data for link creation |
| CampaignService | Campaign context for link grouping |
| HealthCheckService | Link health monitoring results |
| Trust Badge (S009) | Data provenance display |
| Confirmation Dialog (S007) | Delete confirmation |
| Upsell Banner (S011) | Tier limit messaging |

---
## 15. Copy / Text Guidance

| Element | Vietnamese |
|---|---|
| Page title | "Affiliate Links" |
| Create button | "+ Tạo link" |
| Health button | "📊 Kiểm tra sức khỏe" |
| Empty state title | "Chưa có affiliate link nào" |
| Empty state desc | "Tạo link đầu tiên để bắt đầu theo dõi hiệu quả bán hàng qua affiliate." |
| Delete confirm | "Xóa link '{name}'? Thao tác này không thể hoàn tác." |
| Copy toast | "Đã sao chép link!" |
| Tier limit | "Bạn đã dùng hết {limit} link trong gói {tier}." |

---
## 16. Assumptions

1. Affiliate link tracking uses platform API attribution (Official source class) where available; falls back to UTM-based tracking (Inferred source class).
2. Commission rates are determined per-platform and per-product category — not configurable by user in v1.
3. Link health checks run server-side on scheduled jobs; results are cached and displayed.


---
## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W070] Affiliate Manager | Advanced affiliate management (creators, statements) |
| [W061] Product Detail | Product referenced in link |
| [W065] Campaign Detail | Campaign context for link |
| [W125] Diagnostics Center | Link health deep-dive |
| [M032] Mobile Affiliates | Mobile equivalent |
| [S009] Trust Badge | Source/confidence display |
| [S007] Confirmations | Delete confirmation |
| [S011] Upsell Banner | Tier limit upsell |
---
## 17. SvelteKit Implementation Notes

### Route & Server Load
- **Route**: `src/routes/(app)/commerce/affiliates/+page.svelte`
- **Server load**: `+page.server.ts` → fetch links + summary stats
- **SSR**: Server renders first page of link rows
- **Real-time**: SSE on `/events/affiliate_links` for click/order events

### Data Fetching Strategy
```
+page.server.ts:
  Promise.all([
    affiliateService.listLinks({ platform, status, sort, page, limit: 20 }),
    affiliateService.getSummary(period: '30d')
  ])

Client-side:
  onSearch(query) → affiliateService.listLinks({ query })
  onPeriodChange(period) → refetch summary + list
  onCreateLink(data) → affiliateService.createLink(data)
  onDeleteLink(id) → affiliateService.deleteLink(id)
```

### Health Check System
- Server-side cron: HTTP check every 6h, product availability every 12h, price change every 12h
- Results cached in `link_health_checks` table
- Health banner shows when `COUNT(broken OR expiring) > 0`

### QR Code Generation
- Client-side QR via `qrcode` npm package
- Renders SVG/PNG on-demand (no server round-trip)
- Includes Creativanta branding in QR center

---
## 18. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `affiliate.links.viewed` | Page load | `total_links`, `total_clicks_30d`, `total_revenue_30d` |
| `affiliate.link.created` | New link created | `link_id`, `platform`, `product_id`, `campaign_id` |
| `affiliate.link.copied` | Link URL copied | `link_id` |
| `affiliate.link.qr_generated` | QR code generated | `link_id`, `download_format` |
| `affiliate.link.deleted` | Link deleted | `link_id`, `total_clicks`, `total_revenue` |
| `affiliate.link.renewed` | Expiring link renewed | `link_id`, `days_extended` |
| `affiliate.link.fixed` | Broken link fixed | `link_id`, `fix_type` |
| `affiliate.links.filtered` | Filter/sort applied | `filter_type`, `filter_value` |
| `affiliate.health_check.run` | Health check triggered | `total_links`, `issues_found` |

---
## 19. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (first link row) |
| TTI | < 2.0s |
| Summary bar render | < 200ms |
| Search response | < 300ms |
| QR code generation | < 200ms (client-side) |
| Detail drawer open | < 300ms |
| Health check page load | < 2s |

---
## 20. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached" + stale links visible | Auto-retry when online |
| API error (5xx) | Server failure | Error banner: "Không tải được danh sách link. [Thử lại]" | Retry button |
| Create link failed | Platform connector down | Modal error: "Không tạo được link. {platform} không kết nối. [Kiểm tra kết nối]" | Check connectors |
| Slug conflict | Custom slug already exists | Inline error: "Slug '{slug}' đã được sử dụng. [Tạo ngẫu nhiên]" | Change or auto-generate |
| Health check failed | Server timeout | Toast: "Kiểm tra sức khỏe thất bại. [Thử lại]" | Retry |
| Delete failed | Link still active in campaign | Warning: "Link đang gắn với campaign {name}. Gỡ liên kết trước khi xóa." | Remove from campaign |
| Tier limit reached | Max links for plan | Upsell banner (S011): "Bạn đã dùng hết {limit} link. [Nâng cấp gói →]" | Upgrade plan |

---
## 21. Accessibility

| Element | Requirement |
|---|---|
| Link table | `role="table"`, `aria-label="Danh sách affiliate link"` |
| Status badges | Color + icon + text (never color-only) |
| Copy button | `aria-label="Sao chép link {name}"`, `aria-live="assertive"` on toast |
| QR modal | Focus trap, `aria-modal="true"`, `alt="QR code cho link {name}"` |
| Sort columns | `aria-sort="ascending/descending/none"` |
| Keyboard | Tab through rows, Enter to open detail, Ctrl+C on selected copies link |
| Health warning banner | `role="alert"`, `aria-label="{count} link có vấn đề sức khỏe"` |

---
## 22. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | App Shell + summary bar shimmer + table skeleton |
| Summary stats | 200-300ms | Stat counters animate in with number transition |
| Link rows | 300-500ms | Table rows populate with stagger |
| Conversion rates | 400-600ms | Percentage badges appear |
| Health warning | 500ms | Warning banner slides in (if applicable) |

---
## 23. Localization Notes

- Primary language: Vietnamese (mixed with English for "Affiliate Links" title)
- Currency: VND (no decimals, dot separator: "12.500.000đ")
- Compact format: "12.5M", "1.25M" in summary and table
- Conversion rate: "7.2%"
- Commission: "1.25M VND"
- Expiry: "Còn 3 ngày" / "Hết hạn 2 ngày trước"
- Status: "Hoạt động", "Sắp hết hạn", "Lỗi", "Tạm dừng"
- Link health: "🟢 Tốt", "🟡 Sắp hết hạn", "🔴 Lỗi 404"

---
## 24. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-link-active` | Active link status (🟢 green) |
| `--color-link-expiring` | Expiring link status (🟡 amber) |
| `--color-link-broken` | Broken link status (🔴 red) |
| `--color-link-paused` | Paused link status (⚪ gray) |
| `--color-conversion-high` | Conversion > 5% (green badge) |
| `--color-conversion-medium` | Conversion 2-5% (amber badge) |
| `--color-conversion-low` | Conversion < 2% (red badge) |
| `--color-accent` | Primary CTAs (Create link) |
| `--color-surface-elevated` | Table rows on hover |
| `--font-mono` | Link URLs and slugs |

---
## 25. Related Screens

| Screen | Relationship |
|---|---|
| [W070] Affiliate Manager | Advanced affiliate management (creators, statements) |
| [W060] Product Detail | Product referenced in link |
| [W065] Campaign Detail | Campaign context for link |
| [W125] Diagnostics Center | Link health deep-dive |
| [M032] Mobile Affiliates | Mobile equivalent |
| [S009] Trust Badge | Source/confidence display |
| [S007] Confirmations | Delete confirmation |
| [S011] Upsell Banner | Tier limit upsell |

---
## 26. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A standardization**: Fixed section numbering (1-26 sequential). Removed generic boilerplate. Added SvelteKit Implementation Notes (health check system, QR generation), 9 Analytics Events, Performance Requirements, screen-specific Error Handling (7 scenarios with tier limits and health checks), Accessibility with table/QR ARIA, Loading Behavior (5 stages), Localization with affiliate-specific formats, Design Tokens with link-health and conversion-tier colors. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

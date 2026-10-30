# Screen: Web — Affiliate Manager

> **Screen ID**: W070
> **Module**: M16 — see canonical feature owner in screen_task_map.csv
> **Route**: `/affiliate`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06 §8, Product Freeze §24, A1 Schema (affiliate_links, affiliate_clicks, affiliate_conversions, affiliate_commissions, creator_profiles), B5 RBAC §2.7

---

## 1. Purpose & Context

The Affiliate Manager is the command center for all affiliate/referral links. It tracks click-through rates, conversion data, commission earnings, and source content attribution across platforms (TikTok Shop, Shopee, custom links). This screen bridges commerce and creator monetization — showing which promotional links drive actual sales revenue.

### User Goals
- Track which affiliate links generate the most clicks and conversions
- Monitor commission earnings per link and per platform
- Understand which content drives affiliate performance (video → link → sale)
- Create new trackable affiliate links for products
- Export affiliate performance reports for tax and partnership review

### Business Goals
- Drive affiliate revenue through performance visibility
- Connect affiliate attribution to the Proof Graph (M19)
- Support multi-platform affiliate programs (TikTok Shop Affiliate, Shopee Affiliate, custom)
- Enable commission-based creator partnerships with transparent tracking

### When This Screen Is Used
- Daily: Check affiliate link performance (clicks, conversions today)
- Weekly: Review top-performing links and underperformers
- Monthly: Export commission reports, assess partnership ROI
- Ad-hoc: Create new affiliate links for product launches or campaigns

### Entry Points
- Sidebar: "🤝 Affiliate" under Monetization section
- Product Detail (W061): "🔗 Create affiliate link" action
- Campaign Detail (W065): Affiliate commission row click
- Creator Pro Dashboard (W088): Affiliate revenue widget
- AI Copilot: "Link affiliate nào đang có conversion cao nhất?"

### Exit Points
- Click link row → Affiliate Link Detail (with full analytics)
- Click source content → Publish Item Detail (W049)
- Click creator profile → Creator Profile page
- "📤 Export" → CSV/PDF commission report
- "+ Tạo link" → Create Affiliate Link modal/page

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid workspace session
- User has `affiliate:manage` permission (Manager+ for financial data)
- At least one product exists in catalog (for link creation)
- Affiliate tracking service active (redirect service)

### Postconditions
- Page view logged: `affiliate.list.viewed`
- Link status changes persisted (activate/deactivate)
- Commission data freshness checked (platform API sync schedule)

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + KPI bar + full-width link cards |
| Tablet (768-1279px) | App Shell (collapsed) + stacked cards, source content hidden |
| Mobile (≤767px) | Redirect to Mobile Affiliate (M045) |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🤝 Affiliate (24 links)              [+ Tạo link mới] [Period ▾]   │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ KPI Bar ───────────────────────────────────────────────────────┐ │
│ │ 🔗 Active: 18  · 👆 Clicks (30d): 12.5K  · 🛒 Conversions: 845│ │
│ │ 📊 CVR: 6.8%  · 💰 Commission: 8.2M VND  · ↑+23% vs prev     │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Tabs: [🟢 Active (18)] [⏸ Paused (4)] [❌ Expired (2)]             │
│ Search: [🔍 Tìm theo sản phẩm, link...]  Sort: [Commission ▾]     │
│                                                                      │
│ ┌─ Affiliate Link Card ──────────────────────────────────────────┐  │
│ │ 🔗 Serum VitC — TikTok Shop Affiliate          [🟢 Active]    │  │
│ │ creativanta.link/s/serum-vitc  [📋 Copy]                       │  │
│ │                                                                  │  │
│ │ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌────────┐│  │
│ │ │ Clicks   │ │ Conv     │ │ CVR      │ │ Revenue  │ │ Comm.  ││  │
│ │ │ 3,456    │ │ 234      │ │ 6.8%     │ │ 58.5M    │ │ 2.34M  ││  │
│ │ │ ↑+12%    │ │ ↑+8%     │ │ →        │ │ ↑+15%    │ │ ↑+15%  ││  │
│ │ └──────────┘ └──────────┘ └──────────┘ └──────────┘ └────────┘│  │
│ │                                                                  │  │
│ │ Commission rate: 4% · Platform: TikTok Shop                    │  │
│ │ Source content: [🎬 "Serum review" (45K views)] [🎬 "Tips" (22K)]│ │
│ │ Active since: 15/01/2026 · Last conversion: 2 giờ trước        │  │
│ │                                                                  │  │
│ │ [→ Chi tiết] [📊 Analytics] [✏ Edit] [⏸ Tạm dừng]            │  │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Affiliate Link Card ──────────────────────────────────────────┐  │
│ │ 🔗 Sunscreen SPF50 — Custom Link                [🟢 Active]   │  │
│ │ creativanta.link/s/sunscreen-50  [📋]                          │  │
│ │ Clicks: 1,890 · Conv: 156 · CVR: 8.3% · Comm: 1.56M         │  │
│ │ Commission rate: 5% (custom) · Platform: Shopee               │  │
│ │ [→ Chi tiết] [📊] [✏] [⏸]                                    │  │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ [📤 Export báo cáo commission]                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
AffiliateManagerPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("🤝 Affiliate" + link count)
│   ├── CreateLinkButton ("+ Tạo link mới")
│   └── PeriodSelector (7d / 30d / 90d / Custom)
├── KPIBar
│   ├── MetricCard("🔗 Active Links", count)
│   ├── MetricCard("👆 Clicks", total + trend)
│   ├── MetricCard("🛒 Conversions", total + trend)
│   ├── MetricCard("📊 CVR", percentage + trend)
│   └── MetricCard("💰 Commission", VND + trend)
├── StatusTabBar
│   ├── Tab("🟢 Active" + count)
│   ├── Tab("⏸ Paused" + count)
│   └── Tab("❌ Expired" + count)
├── ToolBar
│   ├── SearchInput ("🔍 Tìm theo sản phẩm, link...")
│   └── SortDropdown (["Commission ↓", "Clicks ↓", "CVR ↓", "Newest"])
├── AffiliateLinkList
│   └── AffiliateLinkCard[] (repeating)
│       ├── LinkHeader
│       │   ├── ProductName + AffiliateTypeBadge (TikTok Shop / Shopee / Custom)
│       │   ├── StatusBadge (🟢 Active / ⏸ Paused / ❌ Expired)
│       │   └── ShortLink (copyable: creativanta.link/s/{slug})
│       ├── MetricsRow (5 inline metric cards)
│       │   ├── Clicks (count + trend)
│       │   ├── Conversions (count + trend)
│       │   ├── CVR (percentage + trend)
│       │   ├── Revenue (VND + trend)
│       │   └── Commission (VND + trend)
│       ├── DetailsRow
│       │   ├── CommissionRate ("4%" or "Custom: 5%")
│       │   ├── Platform (icon + name)
│       │   ├── ActiveSince (date)
│       │   └── LastConversion (relative time)
│       ├── SourceContentRow
│       │   └── SourceContentChip[] (content that uses this link, clickable)
│       │       ├── ContentTypeIcon (🎬/🖼)
│       │       ├── ContentTitle (truncated)
│       │       └── ViewCount
│       └── ActionBar
│           ├── DetailButton ("→ Chi tiết")
│           ├── AnalyticsButton ("📊 Analytics")
│           ├── EditButton ("✏ Edit")
│           └── PauseButton ("⏸ Tạm dừng") / ResumeButton ("▶ Tiếp tục")
├── EmptyState ("Chưa có affiliate link. Tạo link đầu tiên để bắt đầu kiếm hoa hồng!")
├── ExportButton ("📤 Export báo cáo commission")
└── CreateLinkModal (on "+ Tạo link mới")
    ├── ProductSelector (search + select from catalog)
    ├── PlatformSelector (TikTok Shop / Shopee / Custom)
    ├── CommissionRateInput (auto-filled from platform or custom)
    ├── SlugInput (auto-generated, editable)
    ├── UTMParametersGroup (campaign, source, medium — auto-fill)
    └── CreateButton
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Link list | `affiliate_links` + stats | `AffiliateService/List(workspace_id, status, period, sort)` | Card list with inline metrics | 5m TTL |
| KPI totals | ClickHouse aggregation | `AffiliateService/GetKPIs(workspace_id, period)` | Compact numbers with trends | 5m TTL |
| Tab counts | `COUNT GROUP BY status` | Included in list response | Integer in tab badges | 5m |
| Click count | `affiliate_clicks` COUNT | Aggregated in list response | Compact ("3,456") | 5m |
| Conversions | `affiliate_conversions` COUNT | Aggregated in list response | Integer | 5m |
| CVR | Conversions / Clicks × 100 | Computed | Percentage ("6.8%") | — |
| Revenue | `SUM(orders.total) WHERE affiliate_link_id` | Aggregated in list response | VND compact ("58.5M") | 5m |
| Commission | Revenue × commission_rate | Computed or pre-aggregated | VND compact ("2.34M") | 5m |
| Source content | `publish_items` WHERE contains affiliate link URL | `AffiliateService/GetSourceContent(link_id)` | Chip list with view counts | 15m |
| Short link URL | `affiliate_links.short_url` | — | Monospace, copyable | — |
| Last conversion | `MAX(affiliate_conversions.created_at)` | Included in list | Relative time ("2 giờ trước") | 5m |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Create affiliate link | "+ Tạo link mới" → modal submit | `AffiliateService/Create(data)` | New `affiliate_links` row + `short_url` generated | Modal closes → new card appears at top → Toast "✅ Link đã tạo" | `affiliate:manage` |
| 2 | Copy link URL | Click "📋 Copy" | — (clipboard) | — | Toast "📋 Đã copy link" | Any |
| 3 | View detail | Click "→ Chi tiết" | — | — | Navigate → `/affiliate/[id]` | `affiliate:manage` |
| 4 | View analytics | Click "📊 Analytics" | — | — | Navigate → `/affiliate/[id]/analytics` | `affiliate:manage` |
| 5 | Edit link | Click "✏ Edit" | — | — | Navigate → `/affiliate/[id]/edit` or inline modal | `affiliate:manage` |
| 6 | Pause link | Click "⏸ Tạm dừng" | `AffiliateService/Pause(id)` | `status = 'paused'` | Optimistic: badge → ⏸, card moves tab. Toast "⏸ Link đã tạm dừng" | `affiliate:manage` |
| 7 | Resume link | Click "▶ Tiếp tục" (on paused) | `AffiliateService/Resume(id)` | `status = 'active'` | Optimistic: badge → 🟢. Toast "▶ Link hoạt động" | `affiliate:manage` |
| 8 | Delete link | "⋮" → "Xóa" → confirm | `AffiliateService/Delete(id)` | Soft delete | Card removed. Toast "Đã xóa link" | `affiliate:manage` |
| 9 | Change period | Period selector | Refetch all with new period | — | KPIs + link metrics update | `affiliate:manage` |
| 10 | Switch tab | Click tab | `AffiliateService/List(status=tab)` | — | List filters. URL: `?tab=active` | `affiliate:manage` |
| 11 | Search | Type in search | `AffiliateService/List(query=...)` | — | Debounced 300ms filter | `affiliate:manage` |
| 12 | Sort | Select sort option | `AffiliateService/List(sort=...)` | — | List re-sorts | `affiliate:manage` |
| 13 | Export report | "📤 Export" | `AffiliateService/ExportReport(period, format)` | — | CSV/PDF download | `affiliate:manage` |
| 14 | View source content | Click content chip | — | — | Navigate → `/publish/items/[content_id]` | `idea:read` |

---

## 7. Validation Rules

### Create Affiliate Link (Modal)
| Field | Rule | Error |
|---|---|---|
| Product | Required, select from active catalog | "Chọn sản phẩm cho link affiliate" |
| Platform | Required, one of: TikTok Shop / Shopee / Custom | "Chọn nền tảng" |
| Commission rate | Required, 0.1-50%, auto-filled from platform default | "Tỉ lệ hoa hồng 0.1% - 50%" |
| Slug | Required, 3-50 chars, alphanumeric + hyphen, unique | "Slug 3-50 ký tự, chỉ chữ/số/gạch. Slug đã tồn tại." |
| UTM Campaign | Optional, 3-100 chars | "UTM campaign 3-100 ký tự" |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial load | KPI shimmer + 3 card skeletons | Wait |
| LOADED | Data received | KPI bar + card list | Interact |
| EMPTY | No affiliate links | Illustration: "Chưa có affiliate link. Tạo link đầu tiên để theo dõi hoa hồng! [+ Tạo link]" | Create first |
| EMPTY_TAB | No links in current tab | "Không có link {status} nào." | Switch tab |
| SEARCH_NO_RESULTS | Search returns 0 | "Không tìm thấy link cho '{query}'" | Clear search |
| CREATING | Modal submission in progress | Modal button spinner | Wait |
| PAUSING | Pause action in progress | Card button spinner | Wait |
| EXPORT_GENERATING | Report generating | Export button spinner | Wait |
| HIGH_PERFORMER | Link CVR > 10% | 🔥 badge on card: "High performer" | Continue |
| LOW_PERFORMER | Link active > 30d with CVR < 1% | ⚠️ subtle warning: "CVR thấp, xem xét tối ưu" | Optimize or pause |
| ERROR | API failed | Toast + retry in KPI area | Retry |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View affiliate links | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View commission data | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Create affiliate link | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Edit/Pause/Resume | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Delete affiliate link | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Export commission report | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Copy link URL | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Editor**: Can view links and copy URLs but commission column hidden. No action buttons.
- **Contributor/Viewer/External**: Sidebar item hidden. Direct URL → permission denied.
- Financial data (commission, revenue) requires `profit:read` in addition to `affiliate:manage`.

---

## 10. Navigation Map

```
Affiliate Manager (/affiliate)
├── → /affiliate/[id]                    (Click "→ Chi tiết")
├── → /affiliate/[id]/analytics          (Click "📊 Analytics")
├── → /affiliate/[id]/edit               (Click "✏ Edit")
├── → /publish/items/[content_id]        (Click source content chip)
├── → /products/[product_id]             (Product name click in card)
├── ← /                                  (Sidebar nav)
│
│ URL parameters:
├── ?tab=active|paused|expired
├── ?period=7d|30d|90d|custom
├── ?q=                                   (search query)
└── ?sort=commission|clicks|cvr|newest
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Offline — hiển thị dữ liệu cached." + cached cards | Auto-refresh on reconnect |
| API error (list) | Server 5xx | "Không tải được danh sách affiliate. [Thử lại]" | Retry |
| API error (action) | Server 5xx on pause/create | Toast: "❌ Không thể thực hiện. Thử lại." | Retry |
| Create failed (slug conflict) | Slug already taken | Modal inline error: "Slug đã tồn tại. Chọn slug khác." | Change slug |
| Platform API sync delayed | Commission data stale >24h | Banner: "⏳ Dữ liệu commission có thể chậm. Đồng bộ lần cuối: 12 giờ trước." | Wait for sync |
| Export failed | Report generation error | Toast: "❌ Không tạo được báo cáo. Thử lại." | Retry |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| KPI cards | `role="status"`, `aria-label` includes label + value + trend |
| Link cards | `role="article"`, `aria-label` with product + status + key metrics |
| Copy button | `aria-label="Copy affiliate link"` → `"Đã copy"` after click |
| Tab bar | `role="tablist"` with `aria-selected` |
| Commission values | `aria-label` with full currency (not compact) for screen readers |
| Search | `role="search"`, `aria-label="Tìm kiếm affiliate link"` |
| Sort dropdown | `aria-label="Sắp xếp theo"` |
| Source content chips | `aria-label="Nội dung sử dụng link: {title}, {views} lượt xem"` |
| Keyboard | Tab between cards, Enter activates primary action |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App Shell + KPI bar shimmer + 3 card skeletons |
| KPI data | 100-300ms | Shimmer → animated counter roll-up |
| Link list | 200-500ms | Skeletons → cards stagger in (50ms each) |
| Source content | 300-600ms | Content chips load after card (secondary fetch) |
| Tab switch | 100-300ms | Cards fade out → new set fades in |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (KPI bar renders first) |
| FID | < 100ms |
| CLS | < 0.05 |
| TTI | < 2.0s |
| List fetch | < 500ms (20 items per page) |
| Copy to clipboard | < 50ms |
| Export generation | CSV < 2s, PDF < 5s |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Click counts | Polling | Every 5 minutes |
| Conversion data | Polling | Every 5 minutes |
| Commission sync | Background job | Every 6 hours (platform API) |
| New link created | SSE `/events/affiliate` | Real-time (another tab/user) |
| Link status changes | SSE | Real-time |

---

## 16. Localization Notes

- Primary language: Vietnamese (vi-VN)
- Currency: VND compact ("8.2M VND", "2.34M", "58.5M")
- Percentages: Dot decimal ("6.8%")
- Dates: `dd/MM/yyyy`
- Relative time: "2 giờ trước", "1 ngày trước"
- Commission rate: "4%" or "Tùy chỉnh: 5%"
- Period labels: "7 ngày", "30 ngày", "90 ngày"

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `affiliate.list.viewed` | Page load | `active_count`, `total_commission`, `period` |
| `affiliate.link.created` | New link created | `product_id`, `platform`, `commission_rate` |
| `affiliate.link.copied` | Copy link URL | `link_id`, `platform` |
| `affiliate.link.paused` | Pause link | `link_id`, `clicks_at_pause`, `conversions_at_pause` |
| `affiliate.link.resumed` | Resume link | `link_id` |
| `affiliate.link.deleted` | Delete link | `link_id`, `total_commission` |
| `affiliate.tab.switched` | Tab switch | `from_tab`, `to_tab` |
| `affiliate.searched` | Search executed | `query`, `result_count` |
| `affiliate.exported` | Export report | `format`, `period`, `link_count` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-surface-primary` | Page background |
| `--color-surface-elevated` | Link cards, KPI cards |
| `--color-accent` | Create button, active tab indicator |
| `--color-success` | 🟢 Active badge, positive CVR, commission positive |
| `--color-warning` | Low CVR warning, sync delay |
| `--color-danger` | Delete action, ❌ Expired badge |
| `--color-neutral` | ⏸ Paused badge |
| `--color-fire` | 🔥 High performer badge |
| `--font-mono` | Link URLs, commission rates |
| `--font-metric` | KPI values, card metrics |
| `--spacing-card-gap` | Gap between cards (16px) |
| `--radius-card` | Card border radius (12px) |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/affiliate/+page.svelte`
- **Server load**: `+page.server.ts` → fetch links + KPIs for active tab
- **Click tracking**: Redirect service at `creativanta.link/s/{slug}` → logs click → redirects to product
- **Conversion attribution**: Cookie-based (30-day window) or ref param matching
- **Commission calculation**: Platform APIs (TikTok Shop, Shopee) sync commissions nightly; custom links use configured rate
- **Short URL**: Generated server-side via `ShortUrlService/Generate(slug)`
- **Search**: Meilisearch `affiliate_links` index with full-text on product name + slug

### Data Fetching
```
+page.server.ts:
  const period = url.searchParams.get('period') ?? '30d';
  const tab = url.searchParams.get('tab') ?? 'active';
  const sort = url.searchParams.get('sort') ?? 'commission_desc';

  const [links, kpis] = await Promise.all([
    affiliateService.list(workspace_id, { period, status: tab, sort, page, limit: 20 }),
    affiliateService.getKPIs(workspace_id, period),
  ]);
  // links include: link data + aggregated metrics + source content references
```

---

## 20. Related Screens & Revision History

### Related Screens
| Screen | Relationship |
|---|---|
| [W067] Offer Detail | Linked — offers can generate affiliate links |
| [W061] Product Detail | Linked — product selection for link creation |
| [W065] Campaign Detail | Linked — affiliate commission in campaign costs |
| [W082] Revenue Detail | Linked — affiliate revenue attribution |
| [W088] Creator Pro | Linked — affiliate as revenue stream for creators |
| [M032] Mobile Affiliates | Mobile equivalent |

### Revision History
| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Full 20-point rewrite. Added: real APIs (AffiliateService), 14 actions, 11 states incl. performance indicators, complete component hierarchy with KPI bar + card layout + create modal, real data binding from ClickHouse, commission tracking, source content attribution, multi-platform support, and comprehensive RBAC. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C — template-based) | System |

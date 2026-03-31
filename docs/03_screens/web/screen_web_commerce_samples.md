# Screen: Web — Sample Requests

> **Screen ID**: W068
> **Module**: M14 — Commerce (overlaps M15 Seeding)
> **Route**: `/samples`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06 §11, A1 Schema (sample_requests, sample_shipments, products, creator_profiles, orders), B5 RBAC §2.7
> **Note**: Commerce-side view of sample tracking (inventory & cost focus). For creator relationship management, see [W099] Seeding Request Manager.

---

## 1. Purpose & Context

Sample Requests manages the lifecycle of product sample distribution to influencers/reviewers from the commerce perspective. Tracks the 5-stage pipeline (Requested → Approved → Shipped → Received → Review Published), integrates carrier tracking APIs, monitors inventory impact, and calculates sample ROI (cost vs. attributed review revenue).

### User Goals
- Review and approve/decline sample requests based on stock availability
- Track shipping status with carrier integration (VNPOST, GHN, GHTK)
- Monitor sample costs and compare against review-generated revenue
- See which products generate the best review content ROI
- Send samples proactively to high-value creators

### Business Goals
- Control sample inventory costs with approval workflow
- Measure sample ROI (sample cost vs. review-attributed revenue)
- Drive product awareness through review content seeding
- Track review publication rates to identify unreliable reviewers

### When This Screen Is Used
- Reviewing: Approving/declining incoming sample requests
- Tracking: Monitoring shipping and delivery status
- Analyzing: Reviewing ROI of sample program
- Proactive: Sending samples to selected creators

### Entry Points
- Sidebar: Commerce → "📦 Mẫu sản phẩm"
- Product Detail (W061): "📦 Sample requests" tab
- Seeding Manager (W099): "📦 Commerce view" link
- AI Copilot: "Có bao nhiêu sample đã gửi tháng này?"

### Exit Points
- Click creator → Creator Profile page
- Click "📋 Track" → External carrier tracking URL
- Click "📊 Review stats" → Content Analytics (W075)
- Click product → Product Detail (W061)
- "📤 Export" → CSV sample report

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid workspace session
- User has `sample:read` permission (Manager+ for approval actions)
- Products exist in catalog with stock tracking enabled

### Postconditions
- Approval/decline logged in audit trail
- Inventory deducted on approval (if tracked)
- Carrier tracking number stored on shipment creation
- Review attribution linked when review published

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + summary bar + pipeline + full cards |
| Tablet (768-1279px) | App Shell (collapsed) + stacked cards, pipeline compact |
| Mobile (≤767px) | Redirect to Mobile Samples (M055) |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 📦 Yêu cầu mẫu sản phẩm (30)     [+ Tạo yêu cầu] [Filter ▾]     │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ──────────────────────────────────────────────────┐  │
│ │ This month: 30 sent · Cost: 8.9M VND · 12 reviews published   │  │
│ │ Review rate: 85% · Avg review revenue: 2.1M VND · ROI: +180%  │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Pipeline (clickable — filters cards):                               │
│ [📋 Requested (5)] → [✅ Approved (3)] → [📦 Shipped (2)]         │
│ → [📬 Received (8)] → [📱 Review Published (12)]                   │
│                                                                      │
│ Search: [🔍 Tìm theo sản phẩm, creator...]  Sort: [Newest ▾]      │
│                                                                      │
│ ┌─ Request Card (Pipeline: Shipped) ─────────────────────────────┐  │
│ │ 📦 Serum Vitamin C (SKU: SER-001)                               │  │
│ │ → @skincare_queen (45K followers, TikTok)   [📦 Shipped]       │  │
│ │                                                                  │  │
│ │ Tracking: VNPOST-123456 [📋 Copy] [🔗 Track]                   │  │
│ │ Shipped: 28/03 · Expected delivery: 31/03 · Est. review: 05/04 │  │
│ │                                                                  │  │
│ │ Product cost: 299K · Shipping: 30K · Total: 329K               │  │
│ │ Platform: TikTok · Content type: Video review                   │  │
│ │                                                                  │  │
│ │ [✅ Mark received] [💬 Contact creator] [📊 Creator profile]   │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Request Card (Pipeline: Review Published) ────────────────────┐  │
│ │ 📦 Kem chống nắng (SKU: KCN-002)                               │  │
│ │ → @beauty_review (22K followers, Instagram)  [📱 Published]    │  │
│ │                                                                  │  │
│ │ Published: 20/03 · [🎬 "Honest review" — 15K views]           │  │
│ │                                                                  │  │
│ │ Sample cost: 249K · Shipping: 30K · Total: 279K               │  │
│ │ Review revenue: 1.8M VND · ROI: +545%  🔥                     │  │
│ │                                                                  │  │
│ │ [📊 Review stats] [🔄 Send another] [⭐ Rate creator]         │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Request Card (Pipeline: Requested — Pending) ─────────────────┐  │
│ │ 📋 Toner AHA/BHA (SKU: TON-003)                                │  │
│ │ → @newbie_beauty (8K followers, TikTok)      [📋 Pending]      │  │
│ │                                                                  │  │
│ │ Requested: 27/03 · Stock available: 45                         │  │
│ │ Creator rating: ⭐ 4.2 (from 3 past samples)                   │  │
│ │ Est. sample cost: 180K + 30K shipping                          │  │
│ │                                                                  │  │
│ │ [✅ Approve] [❌ Decline] [📊 Creator profile] [💬 Contact]   │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [📤 Export báo cáo samples]    Pagination: [← 1 / 2 →]             │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
SampleRequestsPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("📦 Yêu cầu mẫu sản phẩm" + total count)
│   ├── CreateRequestButton ("+ Tạo yêu cầu" — proactive send)
│   └── FilterDropdown (by product, creator, date range)
├── SummaryBar
│   ├── SamplesSent (count)
│   ├── TotalCost (VND)
│   ├── ReviewsPublished (count)
│   ├── ReviewRate (percentage)
│   ├── AvgReviewRevenue (VND)
│   └── ROI (percentage)
├── PipelineBar (clickable stages — filters list)
│   ├── Stage("📋 Requested" + count)
│   ├── Arrow("→")
│   ├── Stage("✅ Approved" + count)
│   ├── Arrow("→")
│   ├── Stage("📦 Shipped" + count)
│   ├── Arrow("→")
│   ├── Stage("📬 Received" + count)
│   ├── Arrow("→")
│   └── Stage("📱 Published" + count)
├── ToolBar
│   ├── SearchInput ("🔍 Tìm theo sản phẩm, creator...")
│   └── SortDropdown (["Newest", "Cost ↓", "ROI ↓", "Creator size ↓"])
├── RequestCardList
│   └── RequestCard[] (repeating)
│       ├── ProductInfo
│       │   ├── ProductIcon ("📦")
│       │   ├── ProductName + SKU
│       │   └── StatusBadge (pipeline stage color-coded)
│       ├── CreatorInfo
│       │   ├── CreatorHandle ("@skincare_queen")
│       │   ├── FollowerCount ("45K")
│       │   ├── Platform (TikTok/Instagram/YouTube)
│       │   └── CreatorRating (⭐ from past samples — if available)
│       ├── TrackingInfo (shipped/received stages)
│       │   ├── TrackingNumber (copyable)
│       │   ├── TrackLink (external carrier URL)
│       │   ├── ShippedDate
│       │   ├── ExpectedDelivery
│       │   └── ExpectedReviewDate
│       ├── CostInfo
│       │   ├── ProductCost (VND)
│       │   ├── ShippingCost (VND)
│       │   └── TotalCost (VND)
│       ├── ReviewInfo (published stage)
│       │   ├── ContentLink (clickable → published content)
│       │   ├── ViewCount
│       │   ├── ReviewRevenue (VND)
│       │   └── ROI (percentage + fire emoji if > 300%)
│       └── ActionBar (stage-specific actions)
│           ├── ApproveButton ("✅ Approve" — requested stage)
│           ├── DeclineButton ("❌ Decline" — requested stage)
│           ├── MarkReceivedButton ("✅ Mark received" — shipped stage)
│           ├── ContactButton ("💬 Contact creator")
│           ├── ProfileButton ("📊 Creator profile")
│           ├── ReviewStatsButton ("📊 Review stats" — published stage)
│           ├── SendAnotherButton ("🔄 Send another" — published stage)
│           └── RateCreatorButton ("⭐ Rate creator" — published stage)
├── EmptyState ("Chưa có yêu cầu mẫu. [+ Tạo yêu cầu mới]")
├── Pagination
└── ExportButton ("📤 Export báo cáo samples")
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Request list | `sample_requests` + joins | `SampleService/List(workspace_id, stage, sort, page)` | Cards by pipeline stage | 5m |
| Summary stats | ClickHouse aggregation (30d) | `SampleService/GetSummary(workspace_id)` | Counts + VND + percentages | 5m |
| Pipeline counts | `COUNT GROUP BY stage` | Included in list response | Integer in stage badges | 5m |
| Product info | `products` via `sample_requests.product_id` | Included in list | Name + SKU | — |
| Creator info | `creator_profiles` via `sample_requests.creator_id` | Included in list | Handle + followers + platform | — |
| Creator rating | `AVG(sample_reviews.rating) WHERE creator_id` | Included in list | ⭐ decimal | — |
| Tracking info | `sample_shipments` | Included in list | Tracking number + carrier URL | — |
| Costs | `sample_requests.product_cost + shipping_cost` | Included in list | VND formatted | — |
| Review revenue | `SUM(orders.total) WHERE attributed_content_id` | `SampleService/GetReviewRevenue(request_id)` | VND compact | 15m |
| ROI | (review_revenue - total_cost) / total_cost × 100 | Computed | "+545%" with emoji | — |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Create request | "+ Tạo yêu cầu" | `SampleService/Create(data)` | New request (stage=requested) | Modal → new card at top | `sample:manage` |
| 2 | Approve request | "✅ Approve" | `SampleService/Approve(id)` | `stage = 'approved'`, inventory deducted | Card moves to "Approved" stage. Toast "✅ Đã duyệt" | `sample:manage` |
| 3 | Decline request | "❌ Decline" → reason | `SampleService/Decline(id, reason)` | `stage = 'declined'` | Decline reason modal → card removed from list. Toast | `sample:manage` |
| 4 | Mark shipped | "📦 Ship" (on approved) | `SampleService/MarkShipped(id, tracking)` | `stage = 'shipped'`, tracking# stored | Tracking input modal → card moves to "Shipped" | `sample:manage` |
| 5 | Mark received | "✅ Mark received" | `SampleService/MarkReceived(id)` | `stage = 'received'` | Card moves to "Received". Notification sent to creator. | `sample:manage` |
| 6 | Link review | Auto-detected or manual "🔗 Link review" | `SampleService/LinkReview(id, content_id)` | `stage = 'published'`, content linked | Card shows review info + ROI | `sample:manage` |
| 7 | Contact creator | "💬 Contact" | — | — | Open chat with creator (DM) | `sample:read` |
| 8 | View profile | "📊 Creator profile" | — | — | Navigate → `/creators/[id]` | `sample:read` |
| 9 | View review stats | "📊 Review stats" | — | — | Navigate → `/analytics/content/[content_id]` | `sample:read` |
| 10 | Send another | "🔄 Send another" | `SampleService/Create(same_params)` | New request | New request card for same product/creator | `sample:manage` |
| 11 | Rate creator | "⭐ Rate" → star rating | `SampleService/RateCreator(request_id, rating, notes)` | `sample_reviews` row | Rating modal → card shows updated rating | `sample:manage` |
| 12 | Filter by pipeline | Click pipeline stage | Client-side filter (or refetch) | — | Cards filtered to stage. URL: `?stage=shipped` | `sample:read` |
| 13 | Search | Search input | `SampleService/List(query=...)` | — | Debounced 300ms | `sample:read` |
| 14 | Export | "📤 Export" | `SampleService/ExportReport(period)` | — | CSV download | `sample:read` |
| 15 | Copy tracking | "📋 Copy" on tracking | — (clipboard) | — | Toast "Đã copy tracking" | Any |
| 16 | Open tracking URL | "🔗 Track" | — | — | Open carrier tracking in new tab | Any |

---

## 7. Validation Rules

### Create Request (Modal)
| Field | Rule | Error |
|---|---|---|
| Product | Required, must have stock > 0 | "Chọn sản phẩm có hàng tồn kho" |
| Creator | Required, valid creator profile | "Chọn creator nhận mẫu" |
| Quantity | 1-5 units per request | "Số lượng 1-5 đơn vị" |
| Shipping address | Auto-filled from creator, editable | "Địa chỉ giao hàng bắt buộc" |
| Expected review date | Optional, must be future | "Ngày kỳ vọng phải trong tương lai" |

### Ship Request (Modal)
| Field | Rule | Error |
|---|---|---|
| Tracking number | Required, 6-30 chars | "Số tracking 6-30 ký tự" |
| Carrier | Required: VNPOST / GHN / GHTK / Other | "Chọn đơn vị vận chuyển" |
| Shipping cost | Required, ≥ 0 VND | "Chi phí giao hàng ≥ 0đ" |

### Decline Request
| Field | Rule | Error |
|---|---|---|
| Reason | Required, min 10 chars | "Nêu lý do từ chối (tối thiểu 10 ký tự)" |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial load | Pipeline shimmer + card skeletons | Wait |
| LOADED | Data received | Pipeline + card list | Interact |
| EMPTY | No sample requests | Illustration: "Chưa có yêu cầu mẫu. [+ Tạo yêu cầu mới]" | Create |
| FILTERED_EMPTY | Pipeline stage selected but no results | "Không có yêu cầu ở giai đoạn này." | Switch stage |
| APPROVING | Approve action in progress | Button spinner | Wait |
| DECLINING | Decline modal open | Reason input with submit | Enter reason |
| SHIPPING | Ship modal open | Tracking input fields | Enter tracking |
| OVERDUE_REVIEW | Received > 14d but no review | Orange card border + "⚠️ Quá hạn review" badge | Contact creator |
| HIGH_ROI | ROI > 300% | 🔥 badge on review card | Celebrate |
| LOW_STOCK | Product stock < 5 for pending approval | Warning: "⚠️ Hàng tồn thấp ({stock} còn lại)" | Decline or restock |
| ERROR | API failed | Toast + retry | Retry |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View sample requests | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View costs & ROI | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Create request | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Approve/decline | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Mark shipped/received | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Rate creator | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Export report | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Editor**: Can view requests and update shipment status. Cannot see cost/ROI data or approve/decline.
- **Contributor/Viewer/External**: No access. Sidebar item hidden.

---

## 10. Navigation Map

```
Sample Requests (/samples)
├── → /creators/[id]                      (Creator profile click)
├── → /products/[id]                      (Product name click)
├── → /analytics/content/[content_id]     (Review stats)
├── → /seeding                            (Cross-reference seeding view)
├── ← /                                   (Sidebar nav)
│
│ URL parameters:
├── ?stage=requested|approved|shipped|received|published
├── ?q=                                    (search)
└── ?sort=newest|cost|roi|creator_size
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Offline" + cached cards | Auto-refresh |
| API error (load) | Server 5xx | "Không tải được danh sách. [Thử lại]" | Retry |
| Approve failed (out of stock) | Product stock = 0 at approval time | Toast: "❌ Hết hàng. Không thể duyệt." | Restock or decline |
| Tracking API error | Carrier tracking lookup failed | Warning: "Không lấy được trạng thái vận chuyển" | Manual check |
| Creator not found | Creator profile deleted | Card shows "Creator không khả dụng" | Remove or skip |
| Export failed | Report generation error | Toast: "❌ Không tạo được báo cáo" | Retry |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Pipeline bar | `role="tablist"` (each stage is a filter tab) |
| Request cards | `role="article"`, `aria-label` with product + creator + stage |
| Status badges | Text + color (not color alone) |
| Approve/Decline buttons | `aria-label="Duyệt yêu cầu mẫu cho {product} gửi {creator}"` |
| Tracking number | `aria-label="Số tracking: VNPOST-123456"` |
| ROI value | `aria-label="ROI: dương 545 phần trăm"` |
| Modals | Focus trap, `role="dialog"` |
| Keyboard | Tab between stages, Enter activates primary card action |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | Pipeline bar + summary shimmer |
| Summary data | 100-200ms | Summary bar populates |
| Pipeline counts | 100-200ms | Stage badges update |
| Request cards | 200-500ms | Skeletons → cards with stagger |
| Stage filter | 100-300ms | Cards fade-swap by stage |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s |
| CLS | < 0.05 |
| TTI | < 2.0s |
| List fetch | < 500ms (20 items/page) |
| Action (approve) | < 1s |
| Pipeline filter | < 300ms |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| New requests | SSE `/events/samples` | Real-time |
| Tracking status | Carrier API polling | Every 6 hours |
| Review detection | Content monitor webhook | Real-time (auto-link) |
| Summary stats | Polling | Every 15 minutes |

---

## 16. Localization Notes

- Primary language: Vietnamese (vi-VN)
- Currency: VND ("299K", "8.9M VND")
- Pipeline stages: Vietnamese ("Yêu cầu", "Đã duyệt", "Đã gửi", "Đã nhận", "Đã review")
- Dates: `dd/MM/yyyy`
- Relative: "2 giờ trước"
- ROI: "+545%" with sign and percentage

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `sample.list.viewed` | Page load | `total_count`, `stage_counts`, `this_month_cost` |
| `sample.request.created` | Create request | `product_id`, `creator_id`, `quantity` |
| `sample.request.approved` | Approve | `request_id`, `product_cost`, `stock_after` |
| `sample.request.declined` | Decline | `request_id`, `reason_category` |
| `sample.shipped` | Mark shipped | `request_id`, `carrier`, `tracking_number` |
| `sample.received` | Mark received | `request_id`, `delivery_days` |
| `sample.review.linked` | Review detected/linked | `request_id`, `content_id`, `roi` |
| `sample.creator.rated` | Rate creator | `request_id`, `rating` |
| `sample.exported` | Export report | `format`, `period` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-surface-elevated` | Request cards |
| `--color-accent` | Create button, approved badge |
| `--color-success` | ✅ Approved, ✅ Received badges |
| `--color-info` | 📦 Shipped badge |
| `--color-warning` | Overdue review, low stock |
| `--color-danger` | ❌ Declined badge, decline button |
| `--color-fire` | 🔥 High ROI badge |
| `--color-pipeline-requested` | Pipeline stage: Requested |
| `--color-pipeline-approved` | Pipeline stage: Approved |
| `--color-pipeline-shipped` | Pipeline stage: Shipped |
| `--color-pipeline-received` | Pipeline stage: Received |
| `--color-pipeline-published` | Pipeline stage: Published |
| `--spacing-card-gap` | 16px |
| `--radius-card` | 12px |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/samples/+page.svelte`
- **Server load**: `+page.server.ts` → fetch requests + summary + pipeline counts
- **Pipeline filter**: Client-side filter or URL param reload via `$page.url.searchParams`
- **Carrier tracking**: Server-side API calls (VNPOST, GHN, GHTK) via `CarrierService`
- **Review auto-detection**: Background job scans creator content for product mentions and auto-links
- **ROI calculation**: `(review_revenue - total_sample_cost) / total_sample_cost × 100`

### Data Fetching
```
+page.server.ts:
  const stage = url.searchParams.get('stage') ?? 'all';
  const sort = url.searchParams.get('sort') ?? 'newest';

  const [requests, summary] = await Promise.all([
    sampleService.list(workspace_id, { stage, sort, page, limit: 20 }),
    sampleService.getSummary(workspace_id),  // monthly stats
  ]);
  // Requests include: product info, creator info, shipment data, costs, review attribution
```

### Inventory Integration
```
On approve:
  1. Check product.stock >= request.quantity
  2. Deduct: product.stock -= request.quantity
  3. Create inventory_transaction: type='sample', quantity=-N
  4. If stock < 5 after deduction → trigger low_stock_alert
```

---

## 20. Related Screens & Revision History

### Related Screens
| Screen | Relationship |
|---|---|
| [W099] Seeding Request Manager | Seeding-side view (creator relationship focus) |
| [W061] Product Detail | Product catalog + stock levels |
| [W075] Content Analytics | Review performance measurement |
| [W065] Campaign Detail | Samples linked to campaigns |
| [M055] Mobile Samples | Mobile equivalent |

### Revision History
| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Full 20-point rewrite. Added: real APIs (SampleService), 5-stage pipeline with filtering, 16 actions (approve/decline/ship/receive/rate), creator rating system, carrier tracking integration, ROI calculation, inventory deduction flow, auto-review detection, and comprehensive RBAC. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |

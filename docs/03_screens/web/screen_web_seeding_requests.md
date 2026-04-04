# Screen: Web — Seeding Request Manager

> **Screen ID**: W111
> **Module**: M18 — Seeding / Sample CRM
> **Route**: `/seeding/requests`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 05, PRD §23.15, A1 Schema (sample_requests, seeding_creators, shipments), B5 RBAC §2.7

---

## 1. Purpose & Context

Manage sample product requests to creators/influencers for review content. Pipeline view tracks the entire lifecycle: requested → approved → shipped → received → review published.

### User Goals
- Track every sample request with real-time shipping status
- Know which creators have received samples and when reviews are expected
- Follow up with creators who are late on reviews
- Measure seeding ROI (cost of samples vs revenue from reviews)

### Business Goals
- Maximize review content from seeded products
- Track sample inventory and costs
- Build creator relationship history
- Surface high-performing reviewers for repeat seeding

### Entry Points
- Seeding Campaigns (W098): "Manage requests" on a campaign
- Sidebar: Seeding → "🌱 Requests"

### Exit Points
- "📊 Profile" → Creator profile analytics
- "📱 Track" → External shipping tracker
- Review published → Content Analytics (W075)

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Seeding   🌱 Seeding Requests         [+ Tạo yêu cầu] [Filter ▾]│
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Pipeline Summary ───────────────────────────────────────────┐    │
│ │ [📋 Requested(5)] → [✅ Approved(3)] → [📦 Shipped(2)] →    │    │
│ │ [📬 Received(8)] → [📱 Review Published(12)]                 │    │
│ │                                                                │    │
│ │ Total cost: 4.2M VND · Avg review value: 350K VND            │    │
│ │ Review rate: 85% · Overdue: 2 requests                        │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Request Card ────────────────────────────────────────────────┐   │
│ │ 📦 Serum VitC → @skincare_queen (45K followers, 🎵 TikTok)  │   │
│ │ Status: [📦 Shipped] · Tracking: VNPOST-123456               │   │
│ │ Shipped: 22/3 · ETA: 25/3 · Expected review: 05/4           │   │
│ │ Product value: 299K · Shipping cost: 30K                      │   │
│ │ Campaign: "Spring Launch"                                      │   │
│ │ [📱 Track shipping] [💬 Contact] [📊 Profile] [✅ Received]  │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Request Card (overdue) ──────────────────────────────────────┐   │
│ │ 📦 Kem chống nắng → @beauty_review (22K, 📸 IG)             │   │
│ │ Status: [📬 Received 18/3] · ⚠️ Review overdue (5 days)     │   │
│ │ Expected review: 23/3 · Platform: Instagram Reel             │   │
│ │ [💬 Follow up] [📊 Profile] [✏ Extend deadline]             │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Request Card (completed) ────────────────────────────────────┐   │
│ │ 📦 Toner AHA → @health_guru (80K, 🎵 TikTok)               │   │
│ │ Status: [📱 Review Published] · Published: 20/3              │   │
│ │ Performance: 👁 32K views · 🛒 8 orders · ROI: +340%        │   │
│ │ [📊 View review stats] [🔄 Send more products]               │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Pagination: [← Trước] Page 1/3 [Tiếp →]                           │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
SeedingRequestManagerPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Seeding")
│   ├── PageTitle ("🌱 Seeding Requests")
│   ├── CreateButton
│   └── FilterButton
├── PipelineSummary
│   ├── StageCounts (clickable filters)
│   ├── TotalCost
│   ├── AvgReviewValue
│   ├── ReviewRate (%)
│   └── OverdueCount (with warning badge)
├── RequestList
│   └── RequestCard[]
│       ├── ProductName + CreatorHandle + FollowerCount + Platform
│       ├── StatusBadge (with pipeline stage)
│       ├── ShippingInfo (tracking number, ETA)
│       ├── Dates (shipped, received, expected review, published)
│       ├── CostInfo (product value + shipping)
│       ├── CampaignLink
│       ├── OverdueWarning (if applicable)
│       ├── PerformanceMetrics (if review published: views, orders, ROI)
│       └── ActionBar (context-dependent per status)
├── CreateRequestModal
│   ├── ProductSelector (from catalog)
│   ├── CreatorSelector (search by handle/name)
│   ├── PlatformSelector (expected review platform)
│   ├── ExpectedReviewDate
│   ├── ShippingAddressConfirmation
│   └── CreateButton
├── Pagination
```

---

## 5. Request Status Flow

```
📋 Requested → ✅ Approved → 📦 Shipped → 📬 Received → 📱 Review Published
     │              │                            │
     └→ ❌ Declined  └→ ❌ Cancelled              └→ ⚠️ Overdue
                                                  └→ ❌ No Review (creator declined)
```

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Pipeline shimmer + card skeletons |
| LOADED | Data received | Pipeline + request cards |
| EMPTY | No requests | "Chưa có seeding request. [+ Tạo yêu cầu mới]" |
| HAS_OVERDUE | Overdue reviews exist | Orange badge on pipeline, overdue cards highlighted |
| ERROR | API failed | Error with retry |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached requests | Retry online |
| Create fail | API error on create | Toast: "Không tạo được yêu cầu. [Thử lại]" | Retry |
| Tracking fail | Carrier API error | Inline: "⚠️ Không lấy được trạng thái vận chuyển" | Manual check |
| Follow-up fail | Email send error | Toast: "Gửi follow-up thất bại. [Thử lại]" | Retry |
| Creator not found | Invalid handle | Inline in modal: "Không tìm thấy creator" | Re-search |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Pipeline summary | `role="status"`, `aria-label="Pipeline: {requested} requested, {shipped} shipped, {published} published"` |
| Request cards | `role="article"`, `aria-label="{product} → {creator}, status: {status}"` |
| Status badge | Color + emoji + text (not color alone) |
| Overdue warning | `role="alert"`, `aria-label="Review overdue by {days} days"` |
| ROI metrics | `aria-label="ROI: +{pct}%, {views} views, {orders} orders"` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Pipeline shimmer + card skeletons |
| Pipeline counts | 100-300ms | Stage counts populate |
| Request cards | 300-600ms | Cards populate |
| Shipping status | 500-1000ms | Tracking updates from carriers |
| Performance metrics | 500-1000ms | Published cards get view/order data |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `seeding.requests_viewed` | Page load | `total`, `overdue`, `review_rate` |
| `seeding.request_created` | "+ Tạo" confirmed | `product`, `creator`, `platform` |
| `seeding.request_approved` | "✅ Approve" | `request_id` |
| `seeding.shipped` | "📦 Ship" confirmed | `request_id`, `carrier`, `tracking` |
| `seeding.received` | "📬 Received" | `request_id` |
| `seeding.review_linked` | Content linked | `request_id`, `content_url`, `platform` |
| `seeding.followup_sent` | "💬 Follow up" | `request_id`, `days_overdue` |
| `seeding.deadline_extended` | "✏ Extend" | `request_id`, `old_date`, `new_date` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/seeding/requests/+page.svelte`
- **Server load**: `+page.server.ts` → `SeedingService/ListRequests(workspace_id)` + `GetRequestPipelineStats`
- **Pipeline**: Clickable stage counts filter the request list
- **Tracking**: Integrates with `ShipmentService/GetTrackingStatus(carrier, tracking_number)` for real-time updates
- **Overdue detection**: Server-side cron marks overdue after `expected_review_date + 7 days`
- **Review attribution**: Auto-detect via `ContentService/FindMentions(product_id, creator_id)` or manual link
- **ROI**: Per-request: `(attributed_orders × product_price) / (sample_cost + shipping)`

---

## 12. Localization Notes

- Pipeline: "📋 Yêu cầu", "✅ Đã duyệt", "📦 Đã gửi", "📬 Đã nhận", "📱 Đã publish"
- Cards: "Giá trị mẫu:", "Phí ship:", "ROI:", "Ngày dự kiến review:"
- Overdue: "⚠️ Quá hạn {n} ngày · Liên hệ lần cuối: {date}"
- Tone: Operational, tracking-focused

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-pipeline-requested` | 📋 Requested |
| `--color-pipeline-approved` | ✅ Approved |
| `--color-pipeline-shipped` | 📦 Shipped |
| `--color-pipeline-received` | 📬 Received |
| `--color-pipeline-published` | 📱 Published |
| `--color-danger` | Overdue badge |
| `--color-accent` | Create CTA |
| `--font-metric` | ROI, costs (tabular-nums) |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W113] Seeding Campaigns | Parent campaign management |
| [W112] Seeding Assignments | Creator assignment tracking |
| [W060] Product List | Product catalog |
| [W075] Analytics Overview | Review performance |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (create, tracking), pipeline/card a11y, 8 analytics, SvelteKit impl (pipeline, tracking, ROI), localization, 8 design tokens (pipeline-specific). | System |
| 2026-03-28 | 1.0 | Initial specification | System |

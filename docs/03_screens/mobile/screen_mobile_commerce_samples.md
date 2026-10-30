# Screen: Mobile — Sample Product Tracker

> **Screen ID**: M034
> **Module**: M18 — see canonical feature owner in screen_task_map.csv
> **Route**: `/commerce/samples` (mobile app)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 06 §Commerce, Product Freeze §23, A1 Schema (sample_requests, sample_shipments, sample_reviews, products), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile sample product tracker — a simplified pipeline view for monitoring sample shipments sent to influencers/KOLs, tracking receipt confirmations, review deadlines, and ROI calculation. Designed for the "check sample status on the go" pattern with quick-contact actions and overdue alerting.

### User Goals
- Monitor sample pipeline: Requested → Shipped → Received → Reviewed
- Track which influencers received samples and whether they posted content
- Contact influencers quickly when reviews are overdue
- See cost vs. ROI for sample seeding campaigns

### Business Goals
- Maximize sample-to-content conversion rate (target: > 60%)
- Track sample cost attribution per product for ROI analysis
- Keep influencer engagement high through timely follow-ups
- Measure content performance driven by sample seeding

### When This Screen Is Used
- **Push notification**: "📬 @beauty_girl đã nhận mẫu" → deep link
- **Daily check**: Review sample pipeline status
- **Overdue follow-up**: Contact influencers who haven't posted reviews
- **Campaign planning**: Check remaining sample inventory before launches

### Entry Points
- Commerce section → "📦 Mẫu sản phẩm"
- Commerce Dashboard (M030) → "Samples" quick nav
- Push notification: "📬 Mẫu đã được nhận" → deep link
- Copilot (M060): "Kiểm tra mẫu sản phẩm" → navigate here

### Exit Points
- Tap sample card → Sample Detail (inline expand or separate screen)
- Tap influencer name → Contact in Inbox or platform
- Tap product name → Product Detail (M026)
- "+ Tạo" → Create sample request flow

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `sample:read` permission (Owner, Admin, Manager, Editor)
- At least one product exists for sampling
- At least one influencer/KOL contact added to workspace

### Postconditions
- New sample requests logged with product, influencer, and shipping details
- Status updates (shipped, received, reviewed) tracked with timestamps
- ROI calculated when review content generates attributed orders
- Overdue alerts triggered when review deadline passes

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Mẫu sản phẩm (12)                       [+ Tạo] [Filter ▾]     │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ──────────────────────────────────────────────────┐  │
│ │ 📦 Sent: 12 · 💰 Cost: 3.2M VND · 📱 Reviews: 8 (67%)       │  │
│ │ 📈 ROI: +165% · Revenue driven: 8.5M VND                     │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Chips: [All (12)] [📦 Shipped (3)] [📬 Received (2)]               │
│        [📱 Reviewed (8)] [⚠️ Overdue (1)]                          │
│                                                                      │
│ ┌─ Sample Card (Shipped) ────────────────────────────────────────┐  │
│ │ 📦 Serum HA 30ml → @beauty_girl              [📦 Shipped]     │  │
│ │ 🎵 TikTok · Cost: 329,000đ · Tracking: VN123456              │  │
│ │ Shipped: 2d ago · ETA: 3 days · Due review: 10d               │  │
│ │ [📱 Contact] [📋 Update status] [📦 Track]                    │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Sample Card (Overdue) ────────────────────────────────────────┐  │
│ │ 📦 Kem chống nắng → @skincare_vn             [⚠️ Quá hạn]    │  │
│ │ 🛍 Shopee · Cost: 199,000đ · Received 15d ago                 │  │
│ │ Review deadline: 5d overdue · No content found                 │  │
│ │ [📱 Nhắc nhở] [📋 Cancel] [🔄 Extend]                        │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Sample Card (Reviewed) ───────────────────────────────────────┐  │
│ │ 📦 Set 3 món → @makeup_pro                   [📱 Reviewed ✅] │  │
│ │ 🎵 TikTok · Cost: 799,000đ · Reviewed 3d ago                  │  │
│ │ Content: 2 videos · 🔗 Views: 125K · Orders: 12 · Rev: 2.4M  │  │
│ │ ROI: +200% · [📊 View content] [📋 Details]                   │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Pull-to-refresh · Infinite scroll                                    │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
MobileSampleTrackerPage
├── AppBar
│   ├── BackButton
│   ├── Title ("Mẫu sản phẩm" + count badge)
│   ├── CreateButton ("+ Tạo", small)
│   └── FilterButton ("Filter ▾" → bottom sheet)
├── SummaryBar (collapsible on scroll)
│   ├── SentCount (📦)
│   ├── TotalCost (VND)
│   ├── ReviewCount + ConversionRate ("8 (67%)")
│   ├── ROIPercentage ("+165%")
│   └── RevenueDriven (VND)
├── StatusChips (horizontal scroll, tappable)
│   └── StatusChip[] (All, Shipped, Received, Reviewed, Overdue)
│       ├── StatusIcon + Label
│       └── CountBadge
├── SampleCardList (pull-to-refresh + infinite scroll)
│   └── SampleCard[]
│       ├── CardHeader
│       │   ├── ProductName ("📦 Serum HA 30ml")
│       │   ├── ArrowIcon ("→")
│       │   ├── InfluencerHandle ("@beauty_girl", tappable)
│       │   └── StatusBadge (📦 Shipped / 📬 Received / 📱 Reviewed / ⚠️ Overdue)
│       ├── InfoRow
│       │   ├── PlatformBadge (🎵 TikTok / 🛍 Shopee)
│       │   ├── CostAmount ("329,000đ")
│       │   └── TrackingNumber (conditional, tappable → carrier URL)
│       ├── TimelineRow
│       │   ├── ShippedDate (relative)
│       │   ├── ETADate (if shipped, estimated delivery)
│       │   └── ReviewDeadline (countdown "10d remaining" / "5d overdue")
│       ├── ContentPerformance (reviewed only)
│       │   ├── ContentCount ("2 videos")
│       │   ├── ViewCount ("125K views")
│       │   ├── OrdersAttribited ("12 orders")
│       │   ├── RevenueGenerated ("2.4M VND")
│       │   └── ROIBadge ("+200%")
│       └── ActionBar
│           ├── ContactButton ("📱 Contact" / "📱 Nhắc nhở")
│           ├── UpdateButton ("📋 Update status")
│           ├── TrackButton ("📦 Track", shipped only)
│           ├── ViewContentButton ("📊 View content", reviewed only)
│           ├── CancelButton ("📋 Cancel", overdue only)
│           └── ExtendButton ("🔄 Extend", overdue only)
├── CreateSampleSheet (bottom sheet on "+ Tạo")
│   ├── ProductPicker (required, searchable)
│   ├── InfluencerPicker (required, searchable)
│   ├── PlatformSelector (TikTok / Shopee / Instagram / YouTube)
│   ├── QuantityInput (default: 1)
│   ├── NoteInput (optional, "Instructions for influencer")
│   ├── ReviewDeadlinePicker (default: 14 days)
│   └── CreateButton ("📦 Tạo yêu cầu mẫu")
├── StatusUpdateSheet (bottom sheet on "Update status")
│   ├── StatusSelector (Shipped → Received → Reviewed)
│   ├── TrackingInput (if shipping)
│   ├── ContentLinkInput (if marking as reviewed)
│   └── ConfirmButton
├── FilterBottomSheet (conditional)
│   ├── StatusFilter (All, Shipped, Received, Reviewed, Overdue)
│   ├── PlatformFilter (TikTok, Shopee, Instagram, YouTube)
│   ├── ProductFilter (searchable)
│   ├── DateRangeFilter (7d, 30d, 90d)
│   ├── ApplyButton
│   └── ResetButton
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Sample list | `sample_requests` + `products` + `influencers` | `SampleService/List(status, filters, cursor)` | Card list | 5m TTL |
| Summary stats | Aggregated from `sample_requests` | `SampleService/GetStats()` | Counts + amounts + percentages | 10m TTL |
| Cost per sample | `products.cost_price` × quantity | Included in list | VND "329,000đ" | 5m TTL |
| Total cost | `SUM(sample_requests.cost)` | same | VND "3.2M" | 10m TTL |
| ROI | `(revenue_driven - total_cost) / total_cost × 100` | same | "+165%" | 10m TTL |
| Revenue driven | `orders WHERE attribution = sample_id` sum | same | VND "8.5M" | 10m TTL |
| Review conversion | `COUNT(status=reviewed) / COUNT(total) × 100` | same | "67%" | 10m TTL |
| Content performance | `content_performance WHERE sample_id` | Included | Views + orders + revenue | 15m TTL |
| Tracking status | Carrier API via `ShippingService` | `ShippingService/GetTracking(tracking_id)` | "ETA: 3 days" | 30m TTL |
| Review deadline | `sample_requests.review_deadline` | Computed client-side | "10d remaining" / "5d overdue" | Real-time |

---

## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Create sample request | "+ Tạo" → bottom sheet → confirm | Create | `SampleService/Create(product, influencer, platform, qty, deadline)` | Toast "📦 Đã tạo yêu cầu mẫu" + card prepends | `sample:manage` |
| 2 | Update status | "📋 Update" → bottom sheet | Update | `SampleService/UpdateStatus(id, status, metadata)` | Toast "✅ Đã cập nhật" + card badge changes | `sample:manage` |
| 3 | Contact influencer | "📱 Contact" / "📱 Nhắc nhở" | Navigate | — | Opens platform DM or SMS | `sample:manage` |
| 4 | Track shipment | "📦 Track" | Navigate | Opens carrier tracking URL | External browser/in-app browser | `sample:read` |
| 5 | View content | "📊 View content" (reviewed) | Navigate | — | Push → Content detail with attribution data | `idea:read` |
| 6 | Cancel sample | "📋 Cancel" (overdue) → confirm | Update | `SampleService/Cancel(id, reason)` | Confirmation dialog → card removed | `sample:manage` |
| 7 | Extend deadline | "🔄 Extend" (overdue) → picker | Update | `SampleService/ExtendDeadline(id, new_deadline)` | Toast "🔄 Đã gia hạn" + deadline updates | `sample:manage` |
| 8 | Filter by status | Tap status chip | Filter | Refetch with status | List filters, chip highlights | `sample:read` |
| 9 | Advanced filter | Tap "Filter ▾" | Filter | Refetch | Bottom sheet → applied | `sample:read` |
| 10 | Pull refresh | Pull gesture | Refresh | Refetch current view | List + summary update. Haptic light. | `sample:read` |
| 11 | Load more | Scroll to bottom | Pagination | `SampleService/List(cursor)` | More cards append | `sample:read` |
| 12 | View product | Tap product name | Navigate | — | Push → M026 Product Detail | `product:read` |

---

## 7. Validation Rules

### Create Sample Form
| Field | Rule | Error |
|---|---|---|
| Product | Required | "Vui lòng chọn sản phẩm" |
| Influencer | Required | "Vui lòng chọn influencer" |
| Platform | Required | "Vui lòng chọn nền tảng" |
| Quantity | Required, integer, 1-10 | "Số lượng từ 1 đến 10" |
| Review deadline | Required, 7-90 days from today | "Hạn review từ 7 đến 90 ngày" |
| Note | Optional, max 500 chars | — |

### Status Update Form
| Field | Rule | Error |
|---|---|---|
| Status | Required, valid transition only | "Trạng thái không hợp lệ" |
| Tracking number | Required if status = "Shipped" | "Vui lòng nhập mã vận đơn" |
| Content link | Required if status = "Reviewed" | "Vui lòng nhập link nội dung" |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial load | Summary shimmer + 3 card skeletons | Wait |
| LOADED | Samples available | Summary bar + sample cards | Normal interactions |
| EMPTY | No samples | Illustration + "Chưa gửi mẫu sản phẩm nào. Gửi mẫu cho influencer để bắt đầu seeding. [+ Tạo mẫu đầu tiên]" | Create first sample |
| EMPTY_FILTERED | Filter active, no match | "Không có mẫu phù hợp bộ lọc. [Xóa bộ lọc]" | Clear filters |
| HAS_OVERDUE | ≥1 sample overdue for review | Orange banner: "⚠️ {count} mẫu quá hạn review! [Xem →]" | Contact influencers |
| CREATING | Create bottom sheet open | Bottom sheet with form | Fill + confirm |
| UPDATING | Update bottom sheet open | Bottom sheet with form | Fill + confirm |
| PROCESSING | API call in progress | Button spinner, form disabled | Wait |
| REALTIME_UPDATE | Sample status changes | Toast: "📬 @beauty_girl đã nhận mẫu Serum HA" | Tap to see |
| ERROR | API failed | "Không tải được mẫu sản phẩm. [Thử lại]" | Retry |
| OFFLINE | No network | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached" + cached samples (read-only) | Read cached |

---

## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View samples | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View cost/ROI | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Create sample | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Update status | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Cancel sample | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Contact influencer | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Editor**: Can view samples and update status but cannot see cost or ROI columns. "Cost" fields show "—".
- **Contributor and below**: No access to sample management.

---

## 10. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Sample status changes | Push notification + SSE `/events/samples` | Real-time |
| New content from sample | SSE `/events/content` | Real-time |
| Tracking updates | Polling via carrier API | Every 30 minutes |
| Summary stats | Polling | Every 10 minutes |
| Review deadlines | Client-side timer | Every hour |

### Real-time UX
- **Status change**: Card badge updates with green pulse (3s)
- **New content**: "📱 @beauty_girl đã đăng review!" toast + card moves to "Reviewed"
- **Overdue**: Card border turns orange when deadline passes

---

## 11. Mobile-specific UX

### Gestures & Haptics
| Gesture | Target | Haptic | Result |
|---|---|---|---|
| Pull down | Whole page | Light | Refresh all |
| Tap card | Sample card | Light | Expand inline details or push to detail |
| Tap influencer handle | "@beauty_girl" | Light | Open contact options (DM / SMS / Call) |
| Tap tracking number | Tracking code | Light | Open carrier tracking URL |
| Long press card | Sample card | Heavy | Context menu (Contact / Update / Cancel / Copy tracking) |

### Badge & Notifications
- Push notification: "📬 @beauty_girl đã nhận mẫu Serum HA"
- Overdue push: "⚠️ @skincare_vn chưa review mẫu (quá hạn 5 ngày)"
- Notification tap deep-links to sample list filtered by status

### Dark Mode
- Full dark mode support
- Status badges maintain same color semantics
- ROI positive = green, ROI negative = red, consistent across themes
- Card backgrounds use `surface-container` elevation

### Offline Behavior
- Last fetched sample list cached (up to 30 items)
- Summary stats cached
- Create/Update disabled offline — banner: "Cần kết nối mạng để tạo/cập nhật"
- Contact actions available offline (opens phone dialer/SMS)

---

## 12. Edge Cases

| Edge Case | Handling |
|---|---|
| Influencer doesn't have contact info | Show "📱 Không có thông tin liên hệ. [Thêm →]" |
| Product out of stock for sampling | Warning in create form: "⚠️ Sản phẩm hết hàng. Vẫn tạo yêu cầu?" |
| Tracking number invalid | "❌ Mã vận đơn không hợp lệ. Kiểm tra lại." |
| Influencer received but didn't review (> 30d) | Auto-mark as "Cancelled (timeout)" with reason |
| Same influencer, multiple samples | Show all — each as separate card |
| Content found via platform crawl (auto-detect) | Auto-update to "Reviewed" + link content + show "🤖 Auto-detected" badge |
| ROI calculation when no attributed orders | Show "ROI: Chưa có dữ liệu đơn hàng" |
| Carrier tracking API down | Show "📦 Không tra cứu được. [Thử lại sau]" |

---

## 13. Sample Pipeline Logic

### Status Flow
```
Requested → Shipped → Received → Reviewed
    │           │          │          └── (completed — ROI calculated)
    │           │          └── (overdue if deadline passed)
    │           └── (tracking via carrier API)
    └── Cancelled (at any stage)
```

### ROI Calculation
- **Cost**: `product.cost_price × quantity + shipping_cost`
- **Revenue driven**: `SUM(orders.total WHERE attribution_source = sample_id)`
- **ROI**: `(revenue_driven - total_cost) / total_cost × 100`
- **Attribution**: Content created from sample → UTM tracking → order attribution
- Source class: 🟢 Official (tracked link) / 🔵 Inferred (content match)

---

## 14. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `samples.list.viewed` | Page opens | `total_count`, `overdue_count`, `conversion_rate` |
| `samples.created` | New sample request | `product_id`, `influencer_id`, `platform`, `quantity` |
| `samples.status_updated` | Status change | `sample_id`, `old_status`, `new_status` |
| `samples.contact_tapped` | Contact influencer | `sample_id`, `method` ('dm'/'sms'/'call') |
| `samples.content_viewed` | View content from sample | `sample_id`, `content_count` |
| `samples.cancelled` | Cancel sample | `sample_id`, `reason`, `stage` |
| `samples.deadline_extended` | Extend deadline | `sample_id`, `old_deadline`, `new_deadline` |
| `samples.pull_refreshed` | Pull to refresh | — |

---

## 15. Performance Requirements

| Metric | Target |
|---|---|
| Open to interactive | < 800ms |
| Pull-to-refresh | < 1s |
| Card render (15 items) | 60fps scroll |
| Create sample form open | < 300ms |
| Push → deep link open | < 1s |
| Offline cache load | < 200ms |

---

## 16. Flutter Implementation Notes

### Widget Structure
- **Route**: `/commerce/samples` → `SampleTrackerPage`
- **State management**: Riverpod `sampleListProvider(status_filter)` + `sampleStatsProvider`
- **Pull-to-refresh**: `RefreshIndicator` widget
- **Infinite scroll**: `InfiniteListView` with cursor-based pagination
- **Bottom sheets**: `showModalBottomSheet` for create/update/filter
- **Push**: Firebase Cloud Messaging deep link handler for `sample_received` events
- **Deadline timer**: `Timer.periodic(1.hour)` for deadline countdown — `ValueNotifier`

### Data Fetching
```
onInit:
  Promise.all([
    sampleService.list(status: 'all', limit: 15),
    sampleService.getStats(),
  ])

onFilterChange(status):
  sampleService.list(status: status, limit: 15)

onPullRefresh:
  Promise.all([refetch list, refetch stats])

onCreate(product, influencer, platform, qty, deadline, note):
  sampleService.create({ product, influencer, platform, qty, deadline, note })
    .then(() → refetch list + stats)

onUpdateStatus(id, status, metadata):
  sampleService.updateStatus(id, { status, ...metadata })
    .then(() → refetch list + stats)
```

### Offline Storage
- **Hive box**: `sample_cache` — stores last 30 sample cards
- **TTL**: 15 minutes
- **Write-through**: On successful API fetch, update cache
- **Read-fallback**: On network error, load from cache (create/update disabled)

---

## 17. Navigation Map

```
Mobile Sample Tracker (/commerce/samples)
├── → /commerce/products/[id] (tap product name → Product Detail)
├── → /inbox/[thread_id] (tap influencer → Contact)
├── → /content/[id] (tap "View content" → Content Detail)
├── → Carrier tracking URL (tap tracking number → external browser)
├── ← /commerce (back via bottom nav or back button)
```

---

## 18. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached (chỉ xem)" | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được mẫu sản phẩm. [Thử lại]" | Retry |
| Create failed | API rejection | Toast: "Không tạo được yêu cầu. [Thử lại]" | Retry |
| Update status failed | API error | Toast: "Không cập nhật được. [Thử lại]" | Retry |
| Tracking API failed | Carrier API down | "📦 Không tra cứu được vận đơn" | Retry later |
| Influencer not found | Deleted contact | "Influencer đã bị xóa. [Cập nhật]" | Update sample |
| Product archived | Product no longer active | Note: "Sản phẩm đã lưu trữ" | Info only |

---

## 19. Accessibility

| Element | Requirement |
|---|---|
| Sample cards | `Semantics(label: "Mẫu Serum HA gửi beauty girl, đã giao, chi phí 329 ngàn, review trong 10 ngày")` |
| Status chips | `Semantics(selected:)` on active filter |
| ROI badge | `Semantics(label: "Lợi nhuận đầu tư cộng 165 phần trăm")` |
| Contact button | `Semantics(label: "Liên hệ beauty girl")` |
| Overdue banner | `Semantics(liveRegion: true)` for urgency |
| Interactive elements | Minimum 48×48dp tap targets |
| Status badges | Color not sole indicator — text/icon also present |

---

## 20. Localization Notes

- Primary language: Vietnamese
- Currency: "329,000đ" (dot separator, đ suffix)
- Compact amounts: "3.2M VND"
- Deadlines: "10 ngày còn lại" / "5 ngày quá hạn"
- Status: "Đã gửi", "Đã nhận", "Đã review", "Quá hạn", "Đã hủy"
- Time: Relative ("2 ngày trước", "3 giờ trước")
- ROI: "+165%" (positive = green text), "-20%" (negative = red text)
- Influencer handle: "@beauty_girl" (platform handle format)

---

## 21. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-sample-shipped` | Shipped status badge (🔵 blue) |
| `--color-sample-received` | Received status badge (🟡 amber) |
| `--color-sample-reviewed` | Reviewed status badge (🟢 green) |
| `--color-sample-overdue` | Overdue status badge (🟠 orange) |
| `--color-roi-positive` | Positive ROI text (green) |
| `--color-roi-negative` | Negative ROI text (red) |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Sample cards |

---

## 22. Related Screens

| Screen | Relationship |
|---|---|
| [W074] Web Sample Requests | Web equivalent (full pipeline with ROI dashboard) |
| [M028] Mobile Products | Product referenced in sample |
| [M026] Mobile Commerce Dashboard | Sample stats in quick nav |
| [W081] Profit Dashboard | Sample cost attribution |
| [S009] Trust Badge | Source class for attribution |

---

## 23. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite** from 155-line Tier C. Added: complete 23-section structure with Flutter widget tree, Riverpod state, 5-stage pipeline, ROI calculation, influencer contact workflow, create/update bottom sheets with validation, overdue alerting, 11 states, full RBAC matrix, real-time updates, gestures/haptics, offline caching with Hive, 8 analytics events, performance KPIs, navigation map, 7 error scenarios, semantic accessibility labels, screen-specific design tokens. Replaced ALL generic boilerplate. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

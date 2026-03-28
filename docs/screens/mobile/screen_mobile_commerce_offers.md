# Screen: Mobile — Commerce Offers

> **Screen ID**: M029
> **Module**: M14 — Monetization & Offers
> **Route**: `/commerce/offers` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 06 §7, A1 Schema (offers, coupons, coupon_usage, offer_products), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile offer management — monitor flash sales, bundle deals, and seasonal promotions. Focused on real-time monitoring with quick status toggle (pause/resume). Full offer creation and editing defers to web (W057/W058). Push notifications alert when offers are expiring or reaching usage limits.

### User Goals
- Monitor active offer status and performance on-the-go
- Quickly pause/resume offers during live events
- Check usage progress and revenue impact
- Respond to expiring-soon push alerts

### Business Goals
- Enable real-time offer management during live commerce
- Reduce missed-opportunity costs from unmonitored expiring offers

### When This Screen Is Used
- During promotions: Real-time monitoring of active offers
- Urgent: Pausing a misbehaving offer immediately
- Alert response: Checking offer after push notification

### Entry Points
- Commerce tab → "🏷 Ưu đãi"
- Push: "🏷 Flash sale kết thúc trong 2 giờ!"
- Push: "🏷 Offer Summer Sale đã dùng 90/100 lượt"
- Home (M001): Active offers widget

### Exit Points
- Tap offer → Offer Detail (read-only on mobile, "Edit on web")
- "+ Tạo offer" → simplified or redirect to web
- Back → Commerce hub

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- User has `offer:read` permission

### Postconditions
- Status changes (pause/resume) persisted immediately
- Push notification preferences updated

---

## 3. Screen Layout

### Mobile Layout (Flutter)
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Ưu đãi (13)                                   [+ Tạo offer]     │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ──────────────────────────────────────────────────┐  │
│ │ 🟢 Active: 3 · Revenue (30d): +2.8M VND · Avg CVR: 11.2%     │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│ Chips: [Tất cả] [🟢 Active (3)] [⏳ Scheduled (2)] [⏹ Ended (8)]  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Offer Card ────────────────────────────────────────────────────┐ │
│ │ 🏷 "Summer Sale"                              [🟢 Active]      │ │
│ │ Giảm 30% · 8 sản phẩm · Tất cả nền tảng                      │ │
│ │                                                                  │ │
│ │ ██████████████████████████░░░░░░░  45/100 (45%)               │ │
│ │                                                                  │ │
│ │ Revenue: +1.2M VND · Ends: 31/03 (Còn 2 ngày)                │ │
│ │                                                                  │ │
│ │ ┌─────────────────────────┐ ┌─────────────────────────┐        │ │
│ │ │   ⏸ Tạm dừng           │ │   📊 Chi tiết           │        │ │
│ │ └─────────────────────────┘ └─────────────────────────┘        │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Offer Card ────────────────────────────────────────────────────┐ │
│ │ 🏷 "Bundle 2+1"                               [⏳ Scheduled]   │ │
│ │ Mua 2 tặng 1 · 3 sản phẩm                                    │ │
│ │                                                                  │ │
│ │ Starts: 01/04 (Còn 3 ngày) · Auto-activate                    │ │
│ │                                                                  │ │
│ │ [📊 Chi tiết]                                                  │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Offer Card (ended) ───────────────────────────────────────────┐ │
│ │ 🏷 "Holiday Special"                          [⏹ Ended]       │ │
│ │ Giảm 20% · Used: 80/100 · Revenue: +3.5M                     │ │
│ │ [🔄 Nhân bản] [📊 Xem kết quả]                                │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Pull-to-refresh · Infinite scroll                                    │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠 Home] [💡 Ideas] [🎬 Studio] [💬 Inbox] [📊 Insights]        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
CommerceOffersScreen (ConsumerStatefulWidget)
├── AppBar
│   ├── BackButton
│   ├── Title ("Ưu đãi" + count)
│   └── CreateButton ("+ Tạo" → quick create or web redirect)
├── SummaryBar
│   ├── ActiveCount + indicator
│   ├── Revenue30d (VND compact)
│   └── AvgCVR (percentage)
├── StatusChipBar (horizontal scroll)
│   ├── FilterChip("Tất cả")
│   ├── FilterChip("🟢 Active" + count)
│   ├── FilterChip("⏳ Scheduled" + count)
│   └── FilterChip("⏹ Ended" + count)
├── OfferList (SliverList)
│   └── OfferCard[] (repeating)
│       ├── OfferHeader
│       │   ├── OfferIcon ("🏷")
│       │   ├── OfferName
│       │   └── StatusBadge
│       ├── DiscountDescription ("Giảm 30% · 8 sản phẩm")
│       ├── UsageProgress (active/ended only)
│       │   ├── LinearProgressBar (percentage-based, colored)
│       │   └── UsageText ("45/100 (45%)")
│       ├── MetricsRow
│       │   ├── Revenue ("+1.2M VND")
│       │   └── ExpiryCountdown ("Còn 2 ngày" or "Starts in 3d")
│       └── ActionRow (status-dependent)
│           ├── PauseButton ("⏸ Tạm dừng" — active only)
│           ├── ResumeButton ("▶ Tiếp tục" — paused only)
│           ├── DetailButton ("📊 Chi tiết")
│           ├── DuplicateButton ("🔄 Nhân bản" — ended only)
│           └── ResultsButton ("📊 Xem kết quả" — ended only)
├── EmptyState ("Chưa có offer. [Tạo trên web →]")
├── PullToRefresh
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Offer list | `offers` + stats | `OfferService/List(workspace_id, status)` | Cards | 5m, offline Hive |
| Summary | ClickHouse aggregation | Included in list header | Compact metrics | 5m |
| Usage progress | `COUNT(coupon_usage) / offers.usage_limit` | Aggregated | Progress bar + text | 5m |
| Revenue impact | `SUM(orders.total WHERE offer_id)` | Aggregated | VND compact | 5m |
| Countdown | `offers.ends_at - now()` | Computed client-side | "Còn 2 ngày" / "Còn 3 giờ" | — |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Pause offer | Tap "⏸ Tạm dừng" → confirm | `OfferService/Pause(id)` | `status = 'paused'` | Confirm dialog → badge → ⏸. Haptic + snackbar. | `offer:manage` |
| 2 | Resume offer | Tap "▶ Tiếp tục" | `OfferService/Resume(id)` | `status = 'active'` | Badge → 🟢. Haptic + snackbar. | `offer:manage` |
| 3 | View detail | Tap "📊 Chi tiết" or card | — | — | Navigate → Offer Detail (M029-detail) | `offer:read` |
| 4 | Duplicate | Tap "🔄 Nhân bản" | `OfferService/Duplicate(id)` | New draft | Snackbar "Đã nhân bản → Draft. [Chỉnh sửa trên web →]" | `offer:manage` |
| 5 | View results | Tap "📊 Xem kết quả" | — | — | Navigate → Offer Results (ended summary) | `offer:read` |
| 6 | Filter | Tap chip | Client-side filter | — | List filters with animation | `offer:read` |
| 7 | Refresh | Pull down | `OfferService/List()` | Cache invalidated | Updated list | `offer:read` |
| 8 | Create | Tap "+ Tạo" | — | — | Bottom sheet: "Tạo trên web" with QR/link, or simplified create | `offer:manage` |

---

## 7. Validation Rules

- Mobile offers screen is read-heavy; validation applies only to pause confirmation:
  - Pause confirm: "Tạm dừng offer? Khách hàng sẽ không thể sử dụng mã giảm giá."
  - Resume: No confirmation needed (safe action)

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial fetch | Summary shimmer + 3 card shimmers | Wait |
| LOADED | Data available | Summary bar + offer cards | Interact |
| EMPTY | No offers | "Chưa có offer. [Tạo trên web →]" | Navigate to web |
| EXPIRING_SOON | Offer ends < 24h | Orange countdown badge: "⏰ Kết thúc trong {time}" | Monitor or extend (web) |
| NEARLY_EXHAUSTED | Usage > 90% | Orange progress bar + "⚠️ Sắp hết lượt" | Increase limit (web) |
| PAUSING | Pause in progress | Button spinner | Wait |
| RESUMING | Resume in progress | Button spinner | Wait |
| OFFLINE | No network | Banner + cached list | Refresh when online |
| ERROR | API failed | Retry prompt | Retry |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View offers | ✅ | ✅ | ✅ | ✅ | ✅ (no revenue) | ❌ |
| Pause/resume | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Duplicate | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| View revenue | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Mobile Offers (/commerce/offers)
├── → /commerce/offers/[id]              (Detail view)
├── → web://offers/new                   (Create redirect)
├── ← /commerce                          (Back)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Offline | No network | Banner + Hive cached data | Pull-to-refresh |
| API error | 5xx | Snackbar with retry | Retry |
| Pause failed | Server error | Snackbar: "Không tạm dừng được. Thử lại." + revert | Retry |
| Offer expired mid-action | Offer ended while viewing | Snackbar: "Offer đã kết thúc" + card updates | — |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Offer cards | `Semantics(label: "Summer Sale, giảm 30 phần trăm, đang hoạt động, đã dùng 45 trên 100 lượt")` |
| Progress bar | `Semantics(label: "Lượt sử dụng: 45 trên 100, 45 phần trăm")` |
| Status badge | Text + color combination |
| Action buttons | 48×48dp minimum, descriptive labels |
| Countdown | `Semantics(liveRegion: true)` for time updates |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Mount | 0ms | AppBar + summary shimmer + card shimmers |
| Data | 200-500ms | Shimmer → cards stagger in |
| Pause/resume | 300-1000ms | Button spinner → status badge transition |
| Refresh | 500-1000ms | RefreshIndicator |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| First paint | < 800ms |
| Scroll | 60fps |
| Pause action | < 1s |
| Offline load | < 200ms |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Usage counts | Push notification → local refresh | On redemption batch |
| Offer status | Background sync | Every 5 minutes |
| Expiry alert | Push notification | At 24h, 2h, expired |

---

## 16. Localization Notes

- Vietnamese: "Ưu đãi", "Tạm dừng", "Tiếp tục"
- Discount: "Giảm 30%", "Giảm 50K", "Mua 2 tặng 1"
- Countdown: "Còn 2 ngày", "Còn 3 giờ", "Bắt đầu trong 3 ngày"
- Revenue: VND compact ("+1.2M VND")

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `offer.mobile.viewed` | Screen visible | `active_count`, `total_revenue` |
| `offer.mobile.paused` | Pause action | `offer_id`, `usage_at_pause` |
| `offer.mobile.resumed` | Resume action | `offer_id` |
| `offer.mobile.duplicated` | Duplicate | `offer_id` |
| `offer.mobile.detail_viewed` | Detail tap | `offer_id`, `status` |

---

## 18. Design Tokens Reference (Flutter)

| Token | Usage |
|---|---|
| `AppColors.surfaceElevated` | Offer cards |
| `AppColors.success` | 🟢 Active badge, healthy progress |
| `AppColors.warning` | ⏳ Scheduled, expiring soon, nearly exhausted |
| `AppColors.danger` | ⏹ Stop action |
| `AppColors.neutral` | ⏸ Paused badge |
| `AppTypography.headlineSmall` | Offer name |
| `AppDimens.cardRadius` | 12.dp |
| `AppDimens.progressHeight` | 8.dp |

---

## 19. Technical Implementation Notes

### Flutter Specifics
- **Widget**: `CommerceOffersScreen extends ConsumerStatefulWidget`
- **State**: Riverpod `offerListProvider` with status filter
- **Optimistic UI**: Pause/resume updates card immediately, reverts on error
- **Offline**: Offer list cached in Hive, synced on reconnect
- **Push handling**: Deep link from push notification applies filter

---

## 20. Related Screens & Revision History

### Related Screens
| Screen | Relationship |
|---|---|
| [W057] Web Offer List | Web equivalent (full management) |
| [W058] Web Offer Detail | Full create/edit on web |
| [M030] Mobile Coupons | Sibling — coupons linked to offers |

### Revision History
| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Full 20-point rewrite. Added: real APIs, Flutter widget tree, summary bar, usage progress, Quick pause/resume with optimistic UI, countdown badges, push notification deep links, 8 actions, 9 states, offline caching. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |

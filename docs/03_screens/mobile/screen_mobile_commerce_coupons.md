# Screen: Mobile — Commerce Coupons

> **Screen ID**: M030
> **Module**: M14 — Monetization & Offers
> **Route**: `/commerce/coupons` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 06 §7, A1 Schema (coupons, coupon_usage, offers), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile coupon management — view, create, copy, and share discount codes on the go. Optimized for quick coupon code distribution via native share sheet and clipboard, with at-a-glance usage stats and status filters. Complex coupon configuration defers to web (W068).

### User Goals
- Quickly copy coupon codes for distribution (chat, DM, livestream)
- Check coupon usage stats (how many used, remaining)
- Create simple coupons on mobile (code + discount + limit)
- Share coupons via native share sheet (WhatsApp, Zalo, TikTok DM)
- Stop/expire coupons immediately if needed

### Business Goals
- Enable real-time coupon distribution during live events
- Support mobile-first coupon management for creator sellers
- Track coupon effectiveness with usage metrics

### When This Screen Is Used
- During livestream: Quickly copy/share a coupon code in chat
- Daily: Check which coupons are running and usage progress
- Urgent: Stop a coupon that's being abused

### Entry Points
- Commerce tab → "🎟 Mã giảm giá"
- Push notification: "🎟 Coupon SUMMER30 đã dùng 90/100 lượt"
- Offers screen (M029): "Xem mã giảm giá" link

### Exit Points
- Tap coupon → Coupon Detail (read-only, "Edit on web" CTA)
- "+ Tạo coupon" → Quick create bottom sheet
- Share → native share sheet
- Back → Commerce hub

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- User has `coupon:read` permission

### Postconditions
- Coupon status changes persisted
- Share/copy actions logged for analytics
- Cache updated after creation or status change

---

## 3. Screen Layout

### Mobile Layout (Flutter)
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Mã giảm giá (10)                               [+ Tạo coupon]   │
├──────────────────────────────────────────────────────────────────────┤
│ Chips: [Tất cả (10)] [🟢 Active (4)] [⏹ Expired (6)]             │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Coupon Card ───────────────────────────────────────────────────┐ │
│ │ 🎟 SUMMER30                                    [🟢 Active]     │ │
│ │ Giảm 30% · Tối đa 100K · Tất cả sản phẩm                     │ │
│ │                                                                  │ │
│ │ ██████████████████████████████░░░░░░░░░  45/100 (45%)          │ │
│ │                                                                  │ │
│ │ Revenue impact: +1.2M VND · Expires: 31/03                    │ │
│ │                                                                  │ │
│ │ [📋 Copy] [📤 Share] [⏹ Stop]                                 │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Coupon Card ───────────────────────────────────────────────────┐ │
│ │ 🎟 NEWUSER10                                   [🟢 Active]     │ │
│ │ Giảm 10% · Đơn đầu tiên · Khách mới                           │ │
│ │                                                                  │ │
│ │ Đã dùng: 120 lượt (không giới hạn)                            │ │
│ │ Revenue impact: +850K VND                                      │ │
│ │                                                                  │ │
│ │ [📋 Copy] [📤 Share]                                           │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Coupon Card (expired) ─────────────────────────────────────────┐ │
│ │ 🎟 FLASH50     ⏹ Expired                                      │ │
│ │ Giảm 50K · Used: 100/100 · Revenue: +3.8M                     │ │
│ │ [🔄 Tạo lại]                                                   │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Pull-to-refresh                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠 Home] [💡 Ideas] [🎬 Studio] [💬 Inbox] [📊 Insights]        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
CommerceCouponsScreen (StatefulWidget)
├── AppBar
│   ├── BackButton
│   ├── Title ("Mã giảm giá" + count)
│   └── CreateButton ("+ Tạo coupon")
├── StatusChipBar (horizontal scroll)
│   ├── FilterChip("Tất cả", count: 10)
│   ├── FilterChip("🟢 Active", count: 4)
│   └── FilterChip("⏹ Expired", count: 6)
├── CouponList (Sliver-based)
│   └── CouponCard[] (repeating)
│       ├── CouponCode (large, monospace, bold: "SUMMER30")
│       ├── StatusBadge (🟢 Active / ⏹ Expired / ⏸ Paused)
│       ├── DiscountDescription ("Giảm 30% · Tối đa 100K · Tất cả sản phẩm")
│       ├── UsageProgress
│       │   ├── ProgressBar (linear, filled portion)
│       │   └── UsageText ("45/100 (45%)" or "120 lượt (không giới hạn)")
│       ├── RevenueImpact ("+1.2M VND")
│       ├── ExpiryDate ("Expires: 31/03" or "Vô thời hạn")
│       └── ActionRow
│           ├── CopyButton ("📋 Copy" — copies code to clipboard)
│           ├── ShareButton ("📤 Share" — native share sheet)
│           ├── StopButton ("⏹ Stop" — active only, with confirm)
│           └── RecreateButton ("🔄 Tạo lại" — expired only)
├── EmptyState
│   ├── Illustration
│   ├── Message ("Chưa có mã giảm giá. [+ Tạo coupon đầu tiên]")
│   └── CTAButton
├── QuickCreateBottomSheet (on "+ Tạo coupon")
│   ├── CouponCodeInput (auto-generate or custom)
│   ├── DiscountTypeSegment (% / VND)
│   ├── DiscountValueInput
│   ├── MaxDiscountInput (optional, for %)
│   ├── UsageLimitToggle + LimitInput
│   ├── ExpiryDatePicker
│   └── CreateButton
├── PullToRefresh
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Coupon list | `coupons` table | `CouponService/List(workspace_id, status)` | Cards with usage stats | 5m, offline Hive |
| Chip counts | `COUNT GROUP BY status` | Included in list | Integer badges | 5m |
| Coupon code | `coupons.code` | — | UPPERCASE, monospace, bold | — |
| Usage count | `COUNT(coupon_usage)` | Aggregated in list | "{used}/{limit}" or "{used} lượt" | 5m |
| Usage progress | `used / limit` | Computed | Linear progress bar | — |
| Revenue impact | `SUM(orders.total WHERE coupon_id)` | Aggregated in list | VND compact ("+1.2M VND") | 5m |
| Expiry date | `coupons.expires_at` | — | "dd/MM" or "Vô thời hạn" | — |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Copy code | Tap "📋 Copy" | — (clipboard) | — | Haptic + Snackbar "📋 Đã copy SUMMER30" | Any |
| 2 | Share code | Tap "📤 Share" | — (native share sheet) | — | Share sheet opens with formatted message | Any |
| 3 | Stop coupon | Tap "⏹ Stop" → confirm | `CouponService/Deactivate(id)` | `status = 'expired'` | Confirm dialog → card updates to expired. Haptic. | `coupon:manage` |
| 4 | Recreate coupon | Tap "🔄 Tạo lại" | `CouponService/Create(clone_data)` | New coupon (active) | Bottom sheet pre-filled → create → new card appears | `coupon:manage` |
| 5 | Quick create | Tap "+ Tạo coupon" | `CouponService/Create(data)` | New coupon | Bottom sheet → fill → create → card appears at top | `coupon:manage` |
| 6 | Filter by status | Tap chip | Client-side filter | — | List filters with animation | `coupon:read` |
| 7 | Pull-to-refresh | Pull down | `CouponService/List()` (fresh) | Cache invalidated | Updated list | `coupon:read` |
| 8 | View detail | Tap card body (not buttons) | — | — | Navigate → Coupon Detail (read-only) | `coupon:read` |

### Share Message Template
```
🎟 Mã giảm giá: SUMMER30
💰 Giảm 30% (tối đa 100K)
📅 Hết hạn: 31/03/2026
🛒 Áp dụng: creativanta.link/c/SUMMER30
```

---

## 7. Validation Rules

### Quick Create (Bottom Sheet)
| Field | Rule | Error |
|---|---|---|
| Coupon code | Required if custom, 4-20 chars, alphanumeric | "Mã 4-20 ký tự, chỉ chữ/số" |
| Discount type | Required: percentage or fixed | "Chọn loại giảm" |
| Discount value (%) | 1-99 | "Phần trăm 1-99%" |
| Discount value (VND) | ≥ 1,000 | "Tối thiểu 1,000đ" |
| Max discount | If %, optional, ≥ 10,000 | "Tối đa giảm ≥ 10,000đ" |
| Usage limit | Optional, if set: ≥ 1 | "Giới hạn ≥ 1" |
| Expiry date | Optional, if set: > now | "Ngày hết hạn phải trong tương lai" |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Fetching | Card shimmer placeholders | Wait |
| LOADED | Data available | Chip filters + coupon cards | Interact |
| EMPTY | No coupons | Illustration + "Chưa có mã giảm giá" | Create first |
| EMPTY_FILTER | No coupons for filter | "Không có mã {status}" | Change filter |
| NEARLY_EXHAUSTED | Usage > 90% of limit | Orange progress bar + "⚠️ Sắp hết lượt!" warning text | Increase limit (web) or create new |
| CREATING | Bottom sheet submission | Button spinner | Wait |
| STOPPING | Stop action in progress | Card dimming animation | Wait |
| REFRESHING | Pull-to-refresh | RefreshIndicator | Wait |
| OFFLINE | No network | Banner: "📡 Dữ liệu offline" + cached list | Refresh when online |
| ERROR | API failed | "Không tải được mã giảm giá. [Thử lại]" | Tap retry |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View coupons | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Copy code | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Share code | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Create coupon | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Stop coupon | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| View revenue impact | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Mobile Coupons (/commerce/coupons)
├── → /commerce/coupons/[id]           (Tap card → detail)
├── ← /commerce                         (Back)
├── → native share sheet                 (Share action)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner + cached list via Hive | Pull-to-refresh |
| API error | Server 5xx | Snackbar: "Không tải được. Thử lại." | Retry |
| Create failed (duplicate code) | Code already exists | Bottom sheet error: "Mã đã tồn tại" | Change code |
| Stop failed | Server error on deactivate | Snackbar: "Không dừng được mã. Thử lại." | Retry |
| Clipboard failed | Permission denied | Snackbar: "Không thể copy. Kiểm tra quyền." | Manual copy |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Coupon code | `Semantics(label: "Mã giảm giá: SUMMER30")`, large font for readability |
| Progress bar | `Semantics(label: "Đã dùng 45 trên 100 lượt, 45 phần trăm")` |
| Status badge | Not color-only — "Active" or "Expired" text |
| Copy button | `Semantics(label: "Copy mã SUMMER30")` |
| Share button | `Semantics(label: "Chia sẻ mã giảm giá SUMMER30")` |
| Tap targets | Minimum 48×48dp |
| Bottom sheet | `Semantics(label: "Tạo mã giảm giá mới")` |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + chip bar + 3 card shimmers |
| Coupon data | 200-400ms | Shimmer → cards with stagger |
| Bottom sheet open | 0ms | Sheet slides up with form |
| Create action | 500-1000ms | Button spinner → success toast |
| Pull-to-refresh | 500-1000ms | RefreshIndicator → updated |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| First paint | < 800ms |
| Card rendering | 60fps |
| Copy action | < 50ms (haptic feedback immediate) |
| Share sheet | < 200ms |
| Offline load | < 200ms (Hive) |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Usage counts | Background push | On redemption event (push → local update) |
| Coupon status | Background sync | Every 5 minutes |
| Near-exhaustion alert | Push notification | When usage > 90% |

---

## 16. Localization Notes

- Primary language: Vietnamese
- Coupon codes: Always UPPERCASE, monospace
- Discount: "Giảm 30%" (percentage), "Giảm 50K" (fixed)
- Revenue: VND compact ("+1.2M VND")
- Expiry: "Hết hạn: dd/MM" or "Vô thời hạn"
- Share message: Vietnamese formatted (see template in §6)

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `coupon.mobile.viewed` | Screen visible | `total_count`, `active_count` |
| `coupon.mobile.copied` | Copy code | `coupon_code`, `used_count` |
| `coupon.mobile.shared` | Share via sheet | `coupon_code`, `share_target` (if available) |
| `coupon.mobile.created` | Quick create | `code`, `discount_type`, `discount_value` |
| `coupon.mobile.stopped` | Stop coupon | `coupon_code`, `used_count_at_stop` |
| `coupon.mobile.recreated` | Recreate expired | `source_code`, `new_code` |

---

## 18. Design Tokens Reference (Flutter)

| Token | Usage |
|---|---|
| `AppColors.surfaceElevated` | Coupon cards |
| `AppColors.accent` | Create button |
| `AppColors.success` | 🟢 Active badge, healthy progress |
| `AppColors.warning` | 🟠 Nearly exhausted progress |
| `AppColors.danger` | ⏹ Stop button |
| `AppTypography.couponCode` | Code display (24sp, monospace, bold) |
| `AppTypography.bodySmall` | Usage text, revenue |
| `AppDimens.cardRadius` | 12.dp |
| `AppDimens.progressHeight` | 8.dp |

---

## 19. Technical Implementation Notes

### Flutter Specifics
- **Widget**: `CommerceCouponsScreen extends ConsumerStatefulWidget`
- **State**: Riverpod `couponListProvider`
- **Copy**: `Clipboard.setData(ClipboardData(text: code))` + `HapticFeedback.lightImpact()`
- **Share**: `Share.share(formattedMessage)` from `share_plus` package
- **Offline**: Coupon list cached in Hive box
- **Quick create**: Modal bottom sheet with form validation
- **Progress bar**: Custom `LinearProgressIndicator` with color based on percentage

---

## 20. Related Screens & Revision History

### Related Screens
| Screen | Relationship |
|---|---|
| [W068] Web Coupon Manager | Web equivalent (full management) |
| [M029] Mobile Offers | Sibling — offers can have coupons |
| [W058] Web Offer Detail | Coupons linked to offers |

### Revision History
| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Full 20-point rewrite. Added: real APIs (CouponService), Flutter widget tree, share message template, quick create bottom sheet, usage progress bar, 8 actions, 10 states, offline caching, haptic feedback, and comprehensive mobile accessibility. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |

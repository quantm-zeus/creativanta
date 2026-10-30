# Screen: Mobile — Commerce Affiliates

> **Screen ID**: M032
> **Module**: M16 — see canonical feature owner in screen_task_map.csv
> **Route**: `/commerce/affiliates` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 06 §8, A1 Schema (affiliate_links, affiliate_clicks, affiliate_conversions, affiliate_commissions), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile affiliate link manager — quick-access to copy/share affiliate links, monitor click/conversion stats, and track commission earnings. Optimized for content creators who need to grab affiliate links quickly before/during content creation (e.g., adding link to TikTok bio mid-livestream). Full link creation and configuration defers to web (W063).

### User Goals
- Quickly copy affiliate links for content creation (bio, description, pinned comment)
- Monitor which links are performing (clicks, conversions, commission)
- Share links via native share sheet (WhatsApp, Zalo, DM)
- Check commission earnings for the current period

### Business Goals
- Enable instant affiliate link access during content creation moments
- Maximize affiliate revenue through easy link distribution
- Track per-platform performance

### When This Screen Is Used
- Before content: Grabbing link to put in video description/bio
- During livestream: Quick link copy for chat
- Daily: Checking commission earnings
- Weekly: Reviewing top-performing links

### Entry Points
- Commerce tab → "🤝 Affiliates"
- Push: "💰 Bạn vừa kiếm 500K commission từ link Serum HA!"
- Content Studio: "📎 Gắn affiliate link" quick action

### Exit Points
- Tap link → Affiliate Detail (mobile read-only)
- "+ Tạo link" → redirect to web or simplified create
- Native share sheet
- Back → Commerce hub

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated, `affiliate:manage` permission

### Postconditions
- Copy/share actions logged for analytics
- Link access count tracked

---

## 3. Screen Layout

### Mobile Layout (Flutter)
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Affiliates (12)                                [+ Tạo link]      │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ──────────────────────────────────────────────────┐  │
│ │ 💰 Commission (30d): 8.2M VND · ↑+23%                        │  │
│ │ 👆 Clicks: 12K · Orders: 234 · CVR: 1.95%                    │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Chips: [Tất cả] [🎵 TikTok (5)] [🛍 Shopee (4)] [📸 Instagram (3)]│
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Affiliate Card ────────────────────────────────────────────────┐ │
│ │ 🤝 Serum HA Review                            [🟢 Active]      │ │
│ │ 🎵 TikTok Shop Affiliate                                       │ │
│ │                                                                  │ │
│ │ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐           │ │
│ │ │ Clicks   │ │ Orders   │ │ CVR      │ │ Comm.    │           │ │
│ │ │ 4.5K     │ │ 89       │ │ 1.98%    │ │ 3.2M     │           │ │
│ │ │ ↑+12%    │ │ ↑+8%     │ │ →        │ │ ↑+15%    │           │ │
│ │ └──────────┘ └──────────┘ └──────────┘ └──────────┘           │ │
│ │                                                                  │ │
│ │ creativanta.link/s/serum-ha                                     │ │
│ │ Last conv: 2 giờ trước · Rate: 4%                              │ │
│ │                                                                  │ │
│ │ ┌─────────────────────┐ ┌─────────────────────┐                │ │
│ │ │   📋 Copy link      │ │   📤 Share          │                │ │
│ │ └─────────────────────┘ └─────────────────────┘                │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Affiliate Card ────────────────────────────────────────────────┐ │
│ │ 🤝 Sunscreen SPF50                            [🟢 Active]      │ │
│ │ 🛍 Shopee Affiliate · CVR: 2.3%                               │ │
│ │ Clicks: 1.8K · Orders: 42 · Commission: 1.56M                │ │
│ │ creativanta.link/s/sunscreen                                   │ │
│ │ [📋 Copy] [📤 Share]                                          │ │
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
CommerceAffiliatesScreen (ConsumerStatefulWidget)
├── AppBar
│   ├── BackButton
│   ├── Title ("Affiliates" + count)
│   └── CreateButton ("+ Tạo link")
├── SummaryBar
│   ├── CommissionTotal ("💰 8.2M VND" + trend)
│   ├── ClicksTotal ("👆 12K")
│   ├── OrdersTotal ("234")
│   └── AvgCVR ("1.95%")
├── PlatformChipBar (horizontal scroll)
│   ├── FilterChip("Tất cả")
│   ├── FilterChip("🎵 TikTok" + count)
│   ├── FilterChip("🛍 Shopee" + count)
│   └── FilterChip("📸 Instagram" + count)
├── AffiliateLinkList (SliverList)
│   └── AffiliateCard[] (repeating)
│       ├── LinkHeader
│       │   ├── ProductName ("Serum HA Review")
│       │   ├── StatusBadge (🟢 Active / ⏸ Paused)
│       │   └── PlatformLabel ("🎵 TikTok Shop Affiliate")
│       ├── MetricCards (4 inline, compact)
│       │   ├── Clicks (count + trend)
│       │   ├── Orders (count + trend)
│       │   ├── CVR (percentage + trend)
│       │   └── Commission (VND compact + trend)
│       ├── LinkURL (monospace, truncated)
│       ├── DetailInfo ("Last conv: 2h ago · Rate: 4%")
│       └── ActionRow
│           ├── CopyButton ("📋 Copy link")
│           └── ShareButton ("📤 Share")
├── EmptyState
│   ├── Illustration
│   ├── Message ("Chưa có link affiliate. [Tạo trên web →]")
│   └── CTAButton
├── PullToRefresh
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Link list | `affiliate_links` + stats | `AffiliateService/List(workspace_id, platform, period)` | Cards | 5m, Hive |
| Summary | ClickHouse aggregation (30d) | Included in list header | Compact metrics | 5m |
| Platform counts | `COUNT GROUP BY platform` | Included in list | Chip badges | 5m |
| Clicks | `affiliate_clicks` COUNT | Aggregated | Compact ("4.5K") | 5m |
| Orders | `affiliate_conversions` COUNT | Aggregated | Integer | 5m |
| CVR | Conversions/Clicks × 100 | Computed | "1.98%" | — |
| Commission | `SUM(affiliate_commissions.amount)` | Aggregated | VND compact ("3.2M") | 5m |
| Link URL | `affiliate_links.short_url` | — | Monospace, truncated | — |
| Last conversion | `MAX(conversions.created_at)` | Included | Relative time | 5m |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Copy link | Tap "📋 Copy" | — (clipboard) | — | Haptic + Snackbar "📋 Đã copy link" | `affiliate:manage` |
| 2 | Share link | Tap "📤 Share" | — (native share) | — | Share sheet with link + product info | `affiliate:manage` |
| 3 | View detail | Tap card body | — | — | Navigate → Affiliate Detail (mobile) | `affiliate:manage` |
| 4 | Filter by platform | Tap chip | Client-side filter | — | List filters | `affiliate:manage` |
| 5 | Refresh | Pull down | Refetch | Cache invalidated | Updated | `affiliate:manage` |
| 6 | Create (redirect) | Tap "+ Tạo link" | — | — | Open web link or bottom sheet with instructions | `affiliate:manage` |

### Share Message Template
```
🤝 Affiliate Link
🛍 Serum HA — TikTok Shop
📎 creativanta.link/s/serum-ha
💰 Commission rate: 4%
```

---

## 7. Validation Rules

- No validation needed (read-only screen with copy/share actions)

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial | Summary shimmer + card shimmers | Wait |
| LOADED | Data available | Summary + cards | Browse, copy, share |
| EMPTY | No affiliate links | Illustration + "Tạo link trên web" | Web redirect |
| EMPTY_PLATFORM | No links for selected platform | "Không có link {platform}" | Change filter |
| HIGH_PERFORMER | CVR > 5% | 🔥 badge on card | Continue |
| NO_CONVERSIONS | Clicks > 100 but 0 conversions | "⚠️ Chưa có đơn" subtle | Review targeting |
| OFFLINE | No network | Banner + cached from Hive | Pull-to-refresh |
| ERROR | API failed | Retry | Retry |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View links | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| View commission | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Copy link | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Share link | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

### Visibility
- **Editor**: Sees links and metrics but commission column hidden. Copy/share available.
- **Contributor/Viewer**: No access. Tab hidden in Commerce section.

---

## 10. Navigation Map

```
Mobile Affiliates (/commerce/affiliates)
├── → /commerce/affiliates/[id]          (Detail)
├── → web://affiliate/new               (Create link on web)
├── → native share sheet                 (Share)
├── ← /commerce                          (Back)
```

---

## 11. Error Handling

| Error | UI | Recovery |
|---|---|---|
| Offline | Banner + Hive cached | Pull-to-refresh |
| API 5xx | Snackbar + retry | Retry |
| Clipboard failed | Snackbar: "Không copy được" | Manual copy |
| Commission sync delay | Info: "Dữ liệu commission có thể chậm" | Wait |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Cards | `Semantics(label: "Serum HA Review, TikTok Shop, 4,500 clicks, 89 orders, commission 3.2 triệu")` |
| Metrics | Not color-only — includes value + trend text |
| Copy button | `Semantics(label: "Copy link affiliate Serum HA")` |
| Share button | `Semantics(label: "Chia sẻ link affiliate")` |
| Tap targets | 48×48dp minimum |
| Platform chips | `Semantics(selected: true/false, label: "TikTok, 5 links")` |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Mount | 0ms | AppBar + summary shimmer + card shimmers |
| Data | 200-500ms | Shimmer → cards stagger in |
| Copy action | < 50ms | Haptic immediate |
| Share sheet | < 200ms | Native sheet opens |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| First paint | < 800ms |
| Scroll | 60fps |
| Copy | < 50ms |
| Offline load | < 200ms |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Click/conversion counts | Background sync | Every 5 minutes |
| Commission | Platform API sync | Every 6 hours |
| New conversion | Push notification | Real-time |

---

## 16. Localization Notes

- Vietnamese: "Affiliates", commission in VND compact
- Commission rate: "4%" 
- Link URLs: Always lowercase, monospace
- Relative time: "2 giờ trước"
- Platform names: Original (TikTok, Shopee, Instagram)

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `affiliate.mobile.viewed` | Screen visible | `link_count`, `total_commission` |
| `affiliate.mobile.copied` | Copy link | `link_id`, `platform` |
| `affiliate.mobile.shared` | Share link | `link_id`, `platform`, `share_target` |
| `affiliate.mobile.filtered` | Platform chip | `platform`, `count` |
| `affiliate.mobile.detail_viewed` | Card tap | `link_id` |

---

## 18. Design Tokens Reference (Flutter)

| Token | Usage |
|---|---|
| `AppColors.surfaceElevated` | Affiliate cards |
| `AppColors.accent` | Create button |
| `AppColors.success` | 🟢 Active badge, positive trends |
| `AppColors.fire` | 🔥 High performer badge |
| `AppColors.warning` | No conversions warning |
| `AppTypography.mono` | Link URLs |
| `AppTypography.metricLarge` | Commission value |
| `AppDimens.cardRadius` | 12.dp |
| `AppDimens.metricCardHeight` | 64.dp |

---

## 19. Technical Implementation Notes

### Flutter Specifics
- **Widget**: `CommerceAffiliatesScreen extends ConsumerStatefulWidget`
- **State**: Riverpod `affiliateLinkListProvider`
- **Copy**: `Clipboard.setData(ClipboardData(text: url))` + `HapticFeedback.lightImpact()`
- **Share**: `Share.share(formattedMessage)` from `share_plus` package
- **Offline**: Link list cached in Hive, metrics cached separately
- **Commission sync**: Background Workmanager task syncs platform commissions
- **Platform filter**: Client-side filter with URL-safe platform param

---

## 20. Related Screens & Revision History

### Related Screens
| Screen | Relationship |
|---|---|
| [W070] Web Affiliate Manager | Web equivalent (full management) |
| [M029] Mobile Offers | Offers can generate affiliate links |
| [W067] Web Offer Detail | Affiliate links linked to offers |
| [W088] Creator Pro | Affiliate as revenue stream |

### Revision History
| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Full 20-point rewrite. Added: real APIs (AffiliateService), Flutter widget tree, commission summary, platform filtering, share message template, 4 inline metric cards, 8 states, offline caching, push notification handling, and comprehensive mobile accessibility. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |

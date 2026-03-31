# Screen: Mobile — Studio Launcher

> **Screen ID**: M021
> **Module**: M07 — AI Video Studio
> **Route**: `/studio` (bottom tab: 🎬)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §4, Product Freeze §14-17, A1 Schema (studio_jobs, studio_assets, credit_ledger), B5 RBAC §2.7

---
## 1. Purpose & Context

Mobile Studio is the AI generation hub on mobile — a launcher interface for all production modes (video, image, voiceover, music, subtitle, thumbnail). Shows active job progress with real-time updates, a quick-access mode grid, recent creations gallery, and credit balance. Optimized for "create on the go" and "monitor long-running jobs" usage patterns.

### User Goals
- Quickly launch AI generation from their phone (image, video, voiceover)
- Monitor active jobs (progress bar, ETA, completion notification)
- Browse and manage recent AI-generated assets
- Check credit balance before starting a generation

### Business Goals
- Maximize AI feature adoption by making modes discoverable
- Drive mobile engagement through active job monitoring (sticky app usage)
- Reduce credit wastage through visible cost-per-mode pricing
- Enable mobile-first workflows (generate assets → quick publish)

### When This Screen Is Used
- Proactive: Creator wants to generate a specific asset type
- Monitoring: Checking on active job progress while doing other things
- Post-generation: Reviewing and using recent creations
- Browsing: Exploring what AI modes are available

### Entry Points
- Bottom nav: 🎬 Studio tab (primary access)
- Home Dashboard (M001): Quick Action "🎬 AI Studio"
- Home Dashboard (M001): Content Pipeline → "🎬 Producing" chip
- Script Editor (M006): "🎬 Generate assets" CTA
- Push notification: "🎬 Video generation complete! Tap to view"

### Exit Points
- Tap mode card → Mode-specific page (M022 AI Video, M023 AI Image, etc.)
- Tap active job → Job Detail/Preview
- Tap recent asset → Asset Preview (with share/use/delete options)
- "📤 Publish" on asset → Quick Publish (M006)
- "🛒 Buy credits" → Credit Purchase

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `studio:read` permission (Editor+ roles)
- Active workspace selected
- Credit balance fetched (may be 0 — still show modes but gate on launch)

### Postconditions
- Page view logged for engagement analytics
- Mode launch logged for AI usage analytics
- Job completion notification delivered via push if app is backgrounded

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ 🎬 AI Studio                                 🤖 Credits: 88/100    │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Active Jobs (conditional — only if jobs exist) ─────────────────┐│
│ │ 🟢 ACTIVE JOBS (2)                                                ││
│ │                                                                    ││
│ │ 🎬 "Skincare morning routine"                                     ││
│ │ Video · AI Video Pro · 78% ████████████░░░░ · ~2 phút              ││
│ │ [→ Xem chi tiết]                                                   ││
│ │                                                                    ││
│ │ 🖼 "Product banner Serum VitC"                                    ││
│ │ Image · AI Image · ✅ Xong! · Tap to view                        ││
│ │ [👁 Xem] [📤 Publish] [💾 Lưu]                                    ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Mode Grid (2-column, scrollable) ──────────────────────────────┐│
│ │ Tạo mới                                                           ││
│ │                                                                    ││
│ │ ┌──────────────────┐  ┌──────────────────┐                        ││
│ │ │ 🎬               │  │ 🖼               │                        ││
│ │ │ AI Video         │  │ AI Image         │                        ││
│ │ │ Pro quality      │  │ Multiple styles  │                        ││
│ │ │ 2-5 credits      │  │ 1 credit         │                        ││
│ │ │ ⭐ Popular       │  │                  │                        ││
│ │ └──────────────────┘  └──────────────────┘                        ││
│ │                                                                    ││
│ │ ┌──────────────────┐  ┌──────────────────┐                        ││
│ │ │ 🎙               │  │ 🎵               │                        ││
│ │ │ Voiceover        │  │ AI Music         │                        ││
│ │ │ 50+ voices       │  │ Background music │                        ││
│ │ │ 1 credit         │  │ 1 credit         │                        ││
│ │ └──────────────────┘  └──────────────────┘                        ││
│ │                                                                    ││
│ │ ┌──────────────────┐  ┌──────────────────┐                        ││
│ │ │ 💬               │  │ 🖼               │                        ││
│ │ │ Auto Subtitle    │  │ Thumbnail Gen    │                        ││
│ │ │ 10+ languages    │  │ Platform-fit     │                        ││
│ │ │ 1 credit         │  │ 1 credit         │                        ││
│ │ └──────────────────┘  └──────────────────┘                        ││
│ │                                                                    ││
│ │ ┌──────────────────┐  ┌──────────────────┐                        ││
│ │ │ ✂️               │  │ 🔄               │                        ││
│ │ │ Smart Crop       │  │ Repurpose        │                        ││
│ │ │ Multi-ratio      │  │ Format convert   │                        ││
│ │ │ Free             │  │ 1 credit         │                        ││
│ │ └──────────────────┘  └──────────────────┘                        ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Gần đây (Recent Creations) ────────────────────────────────────┐│
│ │ ← [🖼] [🎬] [🖼] [🎙] [🖼] [🎬] [🖼] → horizontal scroll    ││
│ │    2h   1d   1d   2d   3d   3d   4d                               ││
│ │                                                                    ││
│ │ [→ Xem tất cả (24 assets) →]                                      ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Usage Stats (collapsible) ─────────────────────────────────────┐│
│ │ Tháng này: 12 credits used · 24 assets created · 88 remaining    ││
│ │ [🛒 Mua thêm credits]                                            ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬•] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
MobileStudioLauncherPage
├── AppBar
│   ├── PageTitle ("🎬 AI Studio")
│   └── CreditsBadge ("🤖 88/100" — tappable → credit detail)
├── ScrollableContent (pull-to-refresh)
│   ├── ActiveJobsSection (conditional — only when jobs exist)
│   │   ├── SectionHeader ("🟢 Active Jobs" + count badge)
│   │   └── JobCard[] (vertical list, max 3 shown, "+2 more")
│   │       ├── JobIcon (type-specific: 🎬/🖼/🎙/🎵/💬/🖼)
│   │       ├── JobTitle
│   │       ├── JobType ("Video · AI Video Pro")
│   │       ├── ProgressBar (animated, percentage + ETA)
│   │       ├── StatusBadge
│   │       │   ├── QUEUED: "⏳ Đang chờ..."
│   │       │   ├── PROCESSING: "🔄 Đang xử lý (78%)"
│   │       │   ├── COMPLETED: "✅ Xong!"
│   │       │   └── FAILED: "❌ Lỗi — [Thử lại]"
│   │       └── ActionButtons (conditional per status)
│   │           ├── ViewButton ("→ Xem chi tiết", always)
│   │           ├── PreviewButton ("👁 Xem", completed only)
│   │           ├── PublishButton ("📤 Publish", completed only)
│   │           ├── SaveButton ("💾 Lưu", completed only)
│   │           └── RetryButton ("🔄 Thử lại", failed only)
│   ├── ModeGrid (2-column GridView)
│   │   ├── SectionHeader ("Tạo mới")
│   │   └── ModeCard[] (8 modes)
│   │       ├── ModeIcon (large, 48dp)
│   │       ├── ModeName
│   │       ├── ModeDescription (1 line — "Pro quality", "50+ voices")
│   │       ├── CreditCost ("2-5 credits" or "Free")
│   │       ├── PopularBadge (optional — "⭐ Popular")
│   │       ├── NewBadge (optional — "🆕 New")
│   │       └── LockedOverlay (if no credits or tier-gated)
│   ├── RecentSection
│   │   ├── SectionHeader ("Gần đây")
│   │   ├── HorizontalThumbnailScroll
│   │   │   └── RecentAssetThumb[] (tappable → asset preview)
│   │   │       ├── Thumbnail (square crop, 100dp)
│   │   │       ├── TypeIcon overlay (🎬/🖼/🎙)
│   │   │       └── TimeAgo ("2h", "1d")
│   │   └── ViewAllLink ("→ Xem tất cả (24 assets)")
│   └── UsageStatsSection (collapsible)
│       ├── MonthlyUsage ("12 credits used · 24 assets · 88 remaining")
│       └── BuyCreditsButton ("🛒 Mua thêm credits")
└── BottomNavBar
```

---
## 5. Displayed Data

| Element | Source | API | Display Format | Cache |
|---|---|---|---|---|
| Active jobs | `studio_jobs WHERE status IN ('queued','processing')` | `StudioService/GetActiveJobs()` | Job cards with progress | Real-time |
| Job progress | WebSocket per job | `ws://studio_jobs/{id}/progress` | Percentage + ETA | Real-time |
| Mode list | Static config (8 modes) + dynamic pricing | `StudioService/GetModes()` | 2-column grid | 1h |
| Credit cost per mode | `studio_modes.credit_cost` | Included in modes | "2-5 credits" | 1h |
| Credit balance | `credit_ledger.balance` | `CreditService/GetBalance()` | "88/100" | 2m |
| Recent assets | `studio_assets ORDER BY created_at DESC LIMIT 10` | `StudioService/GetRecentAssets(10)` | Thumbnail scroll | 5m |
| Asset count | `COUNT(studio_assets)` | Included in recent | "(24 assets)" | 5m |
| Monthly usage | `SUM(credit_transactions WHERE month=current)` | `CreditService/GetMonthlyUsage()` | "12 credits used" | 5m |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Launch mode | Tap mode card | Navigate | — | Push → mode-specific page (M022-M028) | `studio:use` |
| 2 | View job detail | Tap "→ Xem chi tiết" on active job | Navigate | — | Push → Job Detail page | `studio:read` |
| 3 | Preview completed | Tap "👁 Xem" on completed job | Navigate | — | Push → Asset Preview (fullscreen) | `studio:read` |
| 4 | Publish asset | Tap "📤 Publish" on completed | Navigate | — | Push → Quick Publish (M006) with asset pre-loaded | `publish:create` |
| 5 | Save to gallery | Tap "💾 Lưu" on completed | Action | Device gallery save | Haptic medium + toast "Đã lưu vào thư viện" | `studio:read` |
| 6 | Retry failed job | Tap "🔄 Thử lại" on failed | Action | `StudioService/Retry(job_id)` | Job re-queued. Card updates to QUEUED status. | `studio:use` |
| 7 | View recent asset | Tap thumbnail in recent | Navigate | — | Push → Asset Preview | `studio:read` |
| 8 | View all assets | Tap "→ Xem tất cả" | Navigate | — | Push → Asset Gallery (full list, filterable) | `studio:read` |
| 9 | Buy credits | Tap "🛒 Mua thêm" or credit badge | Navigate | — | Push → Credit Purchase page | `credits:top_up` |
| 10 | Pull refresh | Pull-down gesture | Refresh | Refetch all | All sections update. Haptic light. | `studio:read` |
| 11 | Cancel job | Long press active job → "Cancel" | Destructive | `StudioService/Cancel(job_id)` | Confirmation dialog → toast "Job đã hủy" | `studio:use` |

---
## 7. Validation Rules

### Mode Launch Gating
| Check | Rule | Error |
|---|---|---|
| Credit balance | Balance ≥ mode minimum cost | Bottom sheet: "Không đủ credits. Cần {cost} credits. [🛒 Mua thêm]" |
| Active job limit | Max 3 concurrent jobs | Toast: "Tối đa 3 jobs cùng lúc. Đợi job hiện tại hoàn thành." |
| Tier access | Mode available for user's plan | Locked overlay: "🔒 Cần Pro plan. [Nâng cấp]" |

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial page load | Mode grid skeleton + placeholder active jobs | Wait |
| LOADED_NO_JOBS | Data loaded, no active jobs | Mode grid + recent. Active jobs section hidden. | Normal interaction |
| LOADED_WITH_JOBS | Has active jobs | Active jobs at top + mode grid + recent | Monitor/interact |
| JOB_COMPLETED | A job just completed | Job card animates to ✅, confetti micro-animation | View/publish/save |
| JOB_FAILED | A job failed | Job card shows ❌ with error description + retry | Retry or remove |
| NO_CREDITS | Credit balance = 0 | All mode cards show locked overlay. Red credit badge. buy CTA prominent. | Buy credits |
| LOW_CREDITS | Balance < 10 | Yellow credit badge + "Sắp hết credits" banner above modes | Continue or buy |
| EMPTY_RECENT | No assets created yet | Recent section shows "Tạo asset đầu tiên! Chọn một mode ở trên." | Launch a mode |
| REFRESHING | Pull-to-refresh | Refresh indicator at top | Wait |
| ERROR | API failed | "Không tải được Studio. [Thử lại]" | Retry |
| OFFLINE | No network | Cached recent assets viewable. Mode launch disabled. Banner: "📡 Ngoại tuyến" | View cached |

---
## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View studio | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Launch mode | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View active jobs | ✅ | ✅ | ✅ | ✅ (own) | ❌ | ❌ | ❌ |
| View recent assets | ✅ | ✅ | ✅ | ✅ (own) | ❌ | ❌ | ❌ |
| Publish asset | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Buy credits | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Cancel job | ✅ | ✅ | ✅ | ✅ (own) | ❌ | ❌ | ❌ |

### Visibility Rules
- **Contributor/Viewer/External**: 🎬 Studio tab hidden from bottom nav. No access.
- **Editor**: Can launch modes and view own jobs/assets only.
- **Manager**: Can view all workspace jobs but not buy credits.

---
## 10. Mobile-specific UX

### Gestures & Haptics
| Gesture | Target | Haptic | Result |
|---|---|---|---|
| Tap mode card | ModeCard | Light | Navigate to mode page |
| Long press active job | JobCard | Heavy | Context menu: Cancel, Share, Delete |
| Pull down | Page | Light | Refresh all data |
| Horizontal scroll | Recent thumbnails | — | Browse recent assets |
| Tap + hold thumbnail | Recent asset | Light | Quick preview (peek) |

### Job Progress Animation
- Progress bar: smooth 60fps animation (interpolated between WebSocket updates)
- Percentage text: counter animation (12% → 78%)
- Completion: confetti burst (300ms) + haptic success + push notification if backgrounded

### Offline Behavior
- **Available offline**: Recent assets (thumbnails cached), usage stats (last known)
- **Unavailable offline**: Active job progress (WebSocket), mode launch, credit balance
- Mode cards show grey overlay: "📡 Cần kết nối mạng"

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| 0 credits | "Hết credits" banner. Mode cards show locked overlay. Buy CTA prominent at top. |
| 5+ active jobs (shouldn't happen) | Show first 3 + "Xem thêm ({count})" expandable |
| Job takes > 15 minutes | Show estimated wait: "⏳ Hàng chờ dài. Dự kiến: ~15 phút" |
| Job fails 3 times consecutively | Show "⚠️ Lỗi lặp lại. Thử với video ngắn hơn hoặc liên hệ hỗ trợ." + support CTA |
| All platforms disconnected | Mode grid still accessible (generate assets offline from platforms) |
| Free plan — some modes locked | Locked modes show "🔒 Pro" badge. Tap → upgrade bottom sheet. |
| Large recent gallery (100+ items) | Horizontal scroll shows first 10 + "→ Xem tất cả →" |
| Push notification tap (job complete) | Deep link to asset preview with "📤 Publish" button prominent |

---
## 12. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Job progress | WebSocket `ws://studio/jobs/{id}` | Real-time (every 2-5s) |
| Job completion | Push notification + WebSocket | Real-time |
| Credit balance | Polling | Every 2 minutes |
| Recent assets | On-demand (after job completion) | Event-driven |

---
## 13. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `studio.viewed` | Page load | `active_jobs`, `credit_balance`, `recent_count` |
| `studio.mode.launched` | Tap mode card | `mode` (video/image/voiceover/etc.), `credit_cost` |
| `studio.mode.blocked` | Mode launch blocked (no credits/tier) | `mode`, `block_reason` |
| `studio.job.viewed` | Tap active job detail | `job_id`, `status`, `progress` |
| `studio.job.retried` | Retry failed job | `job_id`, `retry_count` |
| `studio.job.cancelled` | Cancel active job | `job_id`, `progress_at_cancel` |
| `studio.asset.previewed` | Tap recent asset | `asset_id`, `type` |
| `studio.asset.published` | Publish from completed job | `asset_id`, `destination` |
| `studio.credits.buy_clicked` | Buy credits CTA | `current_balance`, `source` (banner/badge/locked_mode) |

---
## 14. Performance Requirements

| Metric | Target |
|---|---|
| Cold open to interactive | < 1.5s (mode grid visible) |
| Job progress render | < 100ms per update |
| Thumbnail scroll | 60fps |
| Pull-to-refresh | < 2s |
| Mode card tap → navigate | < 300ms |
| WebSocket reconnect | < 3s after disconnect |

---
## 15. Flutter Implementation Notes

### Widget Structure
- **Route**: `/studio` → `StudioLauncherPage extends ConsumerStatefulWidget`
- **State**: Riverpod `studioProvider` (jobs + modes + recent + credits)
- **Grid**: `GridView.count(crossAxisCount: 2)` with adaptive spacing
- **Job progress**: `AnimatedProgressBar` widget connected to WebSocket stream
- **Recent scroll**: `SizedBox(height: 120, child: ListView.builder(scrollDirection: Axis.horizontal))`
- **Pull-to-refresh**: `RefreshIndicator` with custom indicator

### Data Fetching
```
onInit:
  Promise.all([
    studioService.getActiveJobs(),    // active jobs
    studioService.getModes(),          // mode catalog (cached 1h)
    studioService.getRecentAssets(10), // last 10 assets
    creditService.getBalance(),        // current balance
  ])

// WebSocket per active job
for (job in activeJobs) {
  wsConnect('studio/jobs/${job.id}', onProgress: updateJobProgress)
}
```

### Notification Handling
```dart
// FCM handler for job completion
onMessage: (message) {
  if (message.data['type'] == 'studio_job_complete') {
    showLocalNotification('🎬 Video đã sẵn sàng!', body: message.data['title']);
    // Update job list
    ref.invalidate(studioProvider);
  }
}
```

---
## 16. Navigation Map

```
Mobile Studio (/studio)
├── → /studio/video (tap AI Video card → M022)
├── → /studio/image (tap AI Image card → M023)
├── → /studio/voiceover (tap Voiceover card → M024)
├── → /studio/music (tap AI Music card → M025)
├── → /studio/subtitle (tap Auto Subtitle card → M026)
├── → /studio/thumbnail (tap Thumbnail Gen card → M027)
├── → /studio/crop (tap Smart Crop card → M028)
├── → /studio/repurpose (tap Repurpose card → M029)
├── → /studio/jobs/{id} (tap active job → Job Detail)
├── → /studio/assets/{id} (tap recent asset → Asset Preview)
├── → /studio/assets (tap "Xem tất cả" → Asset Gallery)
├── → /publish/quick (tap "📤 Publish" on completed → M006)
├── → /settings/billing/credits (tap buy credits)
```

---
## 17. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + mode cards show grey overlay | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được Studio. [Thử lại]" | Retry button |
| Job launch failed | Insufficient credits or server error | Bottom sheet: "Không đủ credits. Cần {cost}. [🛒 Mua thêm]" | Buy credits or retry |
| WebSocket disconnect | Connection dropped | Job progress pauses + "🔄 Đang kết nối lại..." | Auto-reconnect with backoff |
| Job failed | AI processing error | Job card: "❌ Lỗi — [Thử lại]" with error description | Retry or contact support |
| Credit fetch failed | Balance API timeout | Show last known balance with "⚠️" indicator | Auto-retry |

---
## 18. Accessibility

| Element | Requirement |
|---|---|
| Mode cards | `Semantics(label: "AI Video, chất lượng Pro, 2 đến 5 credits, phổ biến")` |
| Job progress | `Semantics(liveRegion: true, label: "Job Skincare morning routine, 78 phần trăm, còn khoảng 2 phút")` |
| Credit badge | `Semantics(label: "88 trên 100 AI credits còn lại")` |
| Locked modes | `Semantics(label: "AI Video Pro, bị khoá, cần nâng cấp plan Pro")` |
| Recent thumbnails | `Semantics(label: "AI Image, tạo 2 giờ trước")` |
| Action buttons | Minimum 48×48dp tap targets, descriptive labels |
| Completion animation | `Semantics(announcement: "Job Video đã hoàn thành")` |

---
## 19. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + credit badge shimmer |
| Mode grid | 100-300ms | Grid skeleton → mode cards fade in |
| Active jobs | 200-500ms | Job card skeletons → progress fills |
| Recent assets | 300-600ms | Thumbnail placeholders → images load |
| WebSocket connect | 500-1000ms | Job progress starts updating |

---
## 20. Localization Notes

- Primary language: Vietnamese
- Credit display: "88/100" format
- Credit cost: "2-5 credits" or "Miễn phí"
- Job status: "Đang chờ", "Đang xử lý", "Xong!", "Lỗi"
- ETA: "~2 phút", "~15 phút"
- Mode descriptions: Vietnamese ("Chất lượng Pro", "50+ giọng nói")
- Relative time for recent: "2h", "1d", "3d"

---
## 21. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Credit badge, mode card CTA, popular badge |
| `--color-success` | Completed job (✅), progress bar fill |
| `--color-warning` | Low credit warning (🟡), queued status |
| `--color-danger` | Failed job (❌), no credits |
| `--color-surface-elevated` | Mode cards, job cards |
| `--color-surface-container` | Recent thumbnails background |
| `--font-metric` | Credit numbers, progress percentage |

---
## 22. Related Screens

| Screen | Relationship |
|---|---|
| [W024] Web Studio Launcher | Web equivalent (full mode catalog + job monitoring) |
| [M022-M029] Mobile Mode Pages | Mode-specific generation pages |
| [M006] Mobile Quick Publish | Publish generated assets |
| [M001] Mobile Home Dashboard | Links here via bottom nav + quick action |

---
## 23. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | **Structure fix**: Removed duplicate template sections (§6/§11/§12/§13/§16/§18). Added detailed Error Handling (6 scenarios), Accessibility with semantic labels, progressive Loading timeline, Localization with Vietnamese labels, expanded Design Tokens. Renumbered to 23-section structure. | System |
| 2026-03-28 | 2.0 | Full Tier A rewrite. Added active jobs with WebSocket, 8-mode grid, credit gating, 11 states, RBAC, mobile UX, Flutter implementation. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

# Screen Specs 05 — Publish & Packaging (M08)

> **Upstream**: Pack 01 §4, Product Freeze §18-19, A1 Schema (publish_jobs, publish_items, publish_logs, queue_items, packaging_checklists), B4 Connectors
> **Screens**: 6 web + 3 mobile screens
> **Screen Numbers**: §43-§48 (per screen_index.md canonical numbering)

---

## 43. Packaging QA

**Route**: `/packaging/[id]`
**Purpose**: Pre-publish quality assurance checklist. Verify content meets platform requirements before scheduling.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Publish   ✅ Kiểm tra chất lượng: "5 tips nấu ăn"            │
├──────────────────────────────────┬───────────────────────────────┤
│ Content Preview (60%)            │ QA Checklist (40%)             │
│                                  │                                │
│ ┌─ Video Player ─────────────┐  │ ┌─ Auto Checks ─────────────┐│
│ │ [▶ Video preview]           │  │ │ ✅ Resolution: 1080p       ││
│ │ Duration: 45s               │  │ │ ✅ Aspect: 9:16 (TikTok)  ││
│ │ Format: MP4, 28MB           │  │ │ ✅ Duration: <60s          ││
│ │ Resolution: 1080×1920       │  │ │ ⚠️ File size: 28MB (>25)  ││
│ └────────────────────────────┘  │ │ ✅ Audio: has audio         ││
│                                  │ │ ✅ Caption: has captions    ││
│ ┌─ Metadata ─────────────────┐  │ │ ✅ AI disclosure: included  ││
│ │ Title: [editable          ]│  │ └─────────────────────────────┘│
│ │ Caption: [editable        ]│  │                                │
│ │ Hashtags: [#cooking #tips ]│  │ ┌─ Manual Checks ────────────┐│
│ │ Thumbnail: [preview]       │  │ │ ☑ Nội dung không vi phạm   ││
│ │ First comment: [optional  ]│  │ │ ☑ Thông tin sản phẩm chính ││
│ │ Platforms:                  │  │ │    xác                     ││
│ │ [☑ TikTok] [☑ IG Reels]   │  │ │ ☑ CTA rõ ràng              ││
│ └────────────────────────────┘  │ │ ☐ Đã review với team       ││
│                                  │ └─────────────────────────────┘│
│ ┌─ Platform Warnings ────────┐  │                                │
│ │ ⚠️ TikTok: Caption >300    │  │ ┌─ Capability Check ────────┐│
│ │    chars (will trim)        │  │ │ TikTok: 🟢 Native publish ││
│ │ ✅ IG Reels: All OK         │  │ │ IG: 🟢 Native publish     ││
│ └────────────────────────────┘  │ │ YouTube: ⚫ Not connected  ││
│                                  │ └─────────────────────────────┘│
│                                  │                                │
│ [← Quay lại chỉnh sửa]         │ [📅 Lên lịch] [📤 Đăng ngay]  │
└──────────────────────────────────┴───────────────────────────────┘
```

### Components

#### 43.1 Auto QA Checks
- System-automated checks run on file upload
- Green ✅ = pass, Yellow ⚠️ = warning (can proceed), Red ❌ = blocking
- Red blocks the "Đăng ngay" button until resolved

#### 43.2 Manual QA Checklist
- User must check items before publishing (configurable per workspace)
- At minimum 1 manual check required
- All items must be checked before "Đăng ngay" enables

#### 43.3 Capability Check
- Real-time check: `ConnectorService/CheckCapabilities`
- Shows each target platform's publish capability
- If "Manual" → shows "📥 Export file + hướng dẫn đăng thủ công"
- If "Disconnected" → "[Kết nối ngay →]"

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Edit metadata | Inline field edit | — (save with publish) | Field updates |
| Schedule | "📅 Lên lịch" | — | → Schedule modal |
| Publish now | "📤 Đăng ngay" | `PublishService/Execute` | Queue status → Publishing |
| Export for manual | Platform = Manual → "📥 Export" | Download file | File downloads |
| Fix warning | Click warning | — | Scroll to relevant field |
| Back to edit | "← Quay lại" | — | → `/studio/[mode]/[id]` or editor |

### Schedule Modal
```
┌─ Modal: Lên lịch đăng ────────────────────────────────────────┐
│ Ngày: [27/03/2026 ▾]     Giờ: [19:00 ▾]                      │
│ Timezone: Asia/Ho_Chi_Minh                                     │
│                                                                │
│ 💡 AI suggest: 19:00-21:00 là giờ vàng cho TikTok Food        │
│                                                                │
│ Repeat: [☐ Không] [☐ Hàng ngày] [☐ Hàng tuần]                │
│                                                                │
│ Platforms: [☑ TikTok at 19:00] [☑ IG Reels at 19:30]          │
│ (stagger 30 min between platforms)                              │
│                                                                │
│ [Hủy]                                    [📅 Xác nhận lịch]    │
└────────────────────────────────────────────────────────────────┘
```

---

## 44. Publish Queue

**Route**: `/publish`
**Purpose**: All publish jobs — scheduled, in-progress, completed, failed. Primary execution dashboard.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📤 Đăng bài                              [+ Tạo bài mới]        │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [Lên lịch (5)] [Đang đăng (1)] [Đã đăng (24)] [Lỗi (2)] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ── Lên lịch ──                                                   │
│ ┌─ Publish Item ──────────────────────────────────────────────┐ │
│ │ [🎬 Thumb] "5 tips nấu ăn nhanh"                            │ │
│ │ 📅 Hôm nay 19:00 · TikTok + IG Reels · Caption ready       │ │
│ │ Capability: 🟢 All native                                   │ │
│ │ [👁 Preview] [✏️ Edit] [📤 Đăng ngay] [⏸ Tạm hoãn] [❌ Hủy]│ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Publish Item ──────────────────────────────────────────────┐ │
│ │ [🎬 Thumb] "Review serum mới"                               │ │
│ │ 📅 Ngày mai 10:00 · YouTube · Awaiting approval ⏳          │ │
│ │ [👁 Preview] [✏️ Edit] [❌ Hủy]                              │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ── Lỗi ──                                                        │
│ ┌─ Publish Item (Error) ──────────────────────────────────────┐ │
│ │ [🎬 Thumb] "Kem chống nắng review"                          │ │
│ │ ❌ TikTok: API timeout after 3 retries · 2h trước           │ │
│ │ IG Reels: ✅ Published successfully                          │ │
│ │ [🔄 Thử lại TikTok] [📥 Export file] [📊 Diagnostics]      │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Create new publish | "+ Tạo bài mới" | — | → Content picker → Packaging QA |
| Preview | "👁 Preview" | — | Modal: video player + metadata |
| Edit | "✏️ Edit" | — | → `/packaging/[id]` |
| Publish now | "📤 Đăng ngay" | `PublishService/Execute` | Status → Publishing → Published |
| Pause scheduled | "⏸ Tạm hoãn" | `PublishService/Pause` | Status → Paused |
| Cancel | "❌ Hủy" → confirm | `PublishService/Cancel` | Item removed from queue |
| Retry failed | "🔄 Thử lại" | `PublishService/Retry` | Re-enters queue |
| Export | "📥 Export" | Direct download | File + metadata exports |
| View diagnostics | "📊 Diagnostics" | — | → `/publish/[id]/diagnostics` |

---

## 45. Schedule Calendar

**Route**: `/publish/calendar`
**Purpose**: Visual calendar view of all scheduled and published content. Week/month view.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📅 Lịch đăng bài          [← Tuần trước] Tuần 13 [Tuần sau →]  │
│                                [Tuần ▾] [Tháng ▾]               │
├──────────────────────────────────────────────────────────────────┤
│ Mon 24  │ Tue 25  │ Wed 26  │ Thu 27  │ Fri 28  │ Sat 29│Sun 30│
│         │         │         │         │         │        │      │
│         │ [10:00] │         │ [19:00] │ [14:00] │        │      │
│         │ 🎬 "Rev │         │ 🎬 "5   │ 🎬 "Kem │        │      │
│         │ iew ser"│         │ tips"   │ chống"  │        │      │
│         │ YT ✅   │         │ TT+IG   │ TT ❌   │        │      │
│         │         │         │ ⏰ Sched│ → Retry │        │      │
│         │         │         │         │         │        │      │
│         │         │ [+]     │ [+]     │ [+]     │ [+]    │ [+]  │
└──────────────────────────────────────────────────────────────────┘
```

### Behavior
- Click empty slot "+" → Create new publish item for that date/time
- Click existing item → Preview modal with quick actions
- Drag item → Reschedule (update date/time)
- Color-coded: 🟢 published, 🟡 scheduled, 🔴 failed, ⚪ draft
- Hover item → tooltip: title, platforms, status
- Platform icons on each item

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Create on date | Click "+" | — | → New publish flow with pre-set date |
| Reschedule | Drag item | `PublishService/Update(scheduled_at)` | Item moves |
| View detail | Click item | — | Preview modal |
| Switch view | Week/Month toggle | — (client) | Layout changes |
| Navigate weeks | Arrow buttons | — (client) | Week changes |

---

## 46. Publish Item Detail

**Route**: `/publish/[id]`
**Purpose**: Full detail of a single publish item — content, metadata, per-platform status, logs.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Publish   "5 tips nấu ăn nhanh"           [Status ▾] [⋮]     │
├──────────────────────────────────┬───────────────────────────────┤
│ Main (65%)                       │ Right Panel (35%)              │
│                                  │                                │
│ ┌─ Content Preview ──────────┐  │ ┌─ Per-Platform Status ──────┐│
│ │ [Video Player]              │  │ │ 🎵 TikTok  │ ✅ Published  ││
│ │ Duration: 45s · 1080p       │  │ │ Posted: 19:05 · Views: 2.3K││
│ └────────────────────────────┘  │ │ [→ View on TikTok]         ││
│                                  │ │─────────────────────────────││
│ ┌─ Metadata ─────────────────┐  │ │ 📸 IG Reels │ ✅ Published  ││
│ │ Caption: "5 tips nấu ăn..." │  │ │ Posted: 19:35 · Reach: 890 ││
│ │ Hashtags: #cooking #tips    │  │ │ [→ View on Instagram]      ││
│ │ Thumbnail: [preview]        │  │ │─────────────────────────────││
│ │ First comment: "Link sp..." │  │ │ ▶ YouTube  │ ⏰ Queued     ││
│ │ From script: [→ #23]        │  │ │ Scheduled: Tomorrow 10:00  ││
│ │ From idea: [→ #12]          │  │ └─────────────────────────────┘│
│ └────────────────────────────┘  │                                │
│                                  │ ┌─ Performance ─────────────┐ │
│ ┌─ Publish Logs ─────────────┐  │ │ 📊 Total views: 3,190      │ │
│ │ 19:00 Queued for publish    │  │ │ ❤ Likes: 234               │ │
│ │ 19:05 TikTok: Published ✅  │  │ │ 💬 Comments: 18            │ │
│ │ 19:35 IG Reels: Published ✅│  │ │ 🔄 Shares: 12              │ │
│ │ 19:36 First comment posted  │  │ │ Engagement: 8.3%           │ │
│ │ 20:00 Capability snapshot ✅│  │ │ [📊 Full analytics →]      │ │
│ └────────────────────────────┘  │ └─────────────────────────────┘│
│                                  │                                │
│                                  │ ┌─ Related ─────────────────┐ │
│                                  │ │ 📝 Script: "5 tips..."     │ │
│                                  │ │ 💡 Idea: "Review cooking"  │ │
│                                  │ │ 🔥 Trend: "AI cooking"     │ │
│                                  │ └─────────────────────────────┘│
└──────────────────────────────────┴───────────────────────────────┘
```

---

## 47. Publish Diagnostics

**Route**: `/publish/[id]/diagnostics`
**Purpose**: Deep technical diagnostics for a publish item — API logs, capability state, error traces.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Publish Item   🔧 Diagnostics                                 │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Capability Snapshot at Publish Time ───────────────────────┐ │
│ │ TikTok: 🟢 Native · Token valid · Rate: 145/600 used      │ │
│ │ IG:     🟢 Native · Token valid · Rate: 89/200 used       │ │
│ │ YouTube:⚫ Not connected at publish time                    │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ API Call Log ──────────────────────────────────────────────┐ │
│ │ 19:05:234 POST /v1/tiktok/publish → 200 OK (1.2s)         │ │
│ │ 19:05:235 Response: {video_id: "abc123", status: "ok"}     │ │
│ │ 19:35:001 POST /v1/instagram/publish → 200 OK (2.1s)      │ │
│ │ ...                                                         │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Error Details (if failed) ─────────────────────────────────┐ │
│ │ Error: TikTokAPIError · Code: RATE_LIMIT_EXCEEDED           │ │
│ │ Retries: 3/3 exhausted · Last retry: 19:15:000              │ │
│ │ Recommendation: Wait 10 min then retry                      │ │
│ │ [🔄 Retry now] [📋 Copy error]                              │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 48. Channel Posts

**Route**: `/publish/posts`
**Purpose**: View all published content across all platforms with performance metrics.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📊 Bài đã đăng            [Platform ▾] [Period: 30d ▾]          │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Post Row ──────────────────────────────────────────────────┐ │
│ │ [🎬 Thumb] "5 tips nấu ăn"   🎵 TikTok · 27/3 19:05       │ │
│ │ 👁 24.3K views · ❤ 1.2K · 💬 89 · 🔄 45 · Eng: 8.2%       │ │
│ │ [📊 Analytics] [💬 Comments] [🔄 Create derivative]        │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Post Row ──────────────────────────────────────────────────┐ │
│ │ [🎬 Thumb] "5 tips nấu ăn"   📸 IG Reels · 27/3 19:35     │ │
│ │ 👁 3.2K reach · ❤ 234 · 💬 18 · Eng: 5.1%                  │ │
│ │ [📊 Analytics] [💬 Comments] [🔄 Create derivative]        │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ [Tải thêm ↓]                                                    │
└──────────────────────────────────────────────────────────────────┘
```

---

## Mobile Screens

### M6. Mobile Quick Publish Status

**Route**: `/publish` (mobile, tab view)
**Purpose**: View this week's scheduled content with swipe-to-action.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ 📤 Publish                                   [+ Đăng mới]       │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ This week: 8 scheduled · 3 published · 1 failed                  │
│                                                                  │
│ ── Hôm nay ──                                                    │
│ ┌─ Publish Item ─────────────────────────────────────────────┐  │
│ │ [🖼] "5 tips skincare mùa hè"   [TikTok] [🟢 18:00]      │  │
│ │ Video · 60s · Auto-publish                                 │  │
│ │ ← Swipe R: [🚀 Đăng ngay] · Swipe L: [🗑 Hủy]           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Publish Item ─────────────────────────────────────────────┐  │
│ │ [🖼] "Serum review"             [YouTube] [🟡 20:00]       │  │
│ │ Video · 5:30 · Needs caption review                        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Ngày mai ──                                                   │
│ ┌─ Publish Item ─────────────────────────────────────────────┐  │
│ │ [🖼] "Product haul tháng 3"     [IG] [🔵 10:00]           │  │
│ │ Reel · 30s · Scheduled OK                                  │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh                                                  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M6 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Publish now | Swipe right | `PublishService/PublishNow` | Published immediately |
| Cancel | Swipe left → confirm | `PublishService/Cancel` | Item cancelled |
| View detail | Tap item | — | → Bottom sheet with full details + edit |
| Create | "+ Đăng mới" | — | → Publish creation flow |
| Pull-to-refresh | Pull down | `PublishService/List` | Queue refreshed |

---

### M24. Mobile Publish Queue

**Route**: `/publish/queue` (mobile)
**Purpose**: Full publish queue with status filtering and batch actions.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Hàng đợi Publish                          [🔍] [Batch ⋮]     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Tabs: [⏳ Scheduled (5)] [🔄 Publishing (1)] [✅ Done (12)] [🔴 Failed (1)]│
│                                                                  │
│ ┌─ Queue Item ───────────────────────────────────────────────┐  │
│ │ [🖼 thumb] "5 tips skincare mùa hè"                        │  │
│ │ [TikTok 🔵] [Instagram 🟣]                                │  │
│ │ ⏳ Scheduled 18:00, 27/3 · Auto-publish                    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Queue Item ───────────────────────────────────────────────┐  │
│ │ [🖼 thumb] "Serum retinol review"                          │  │
│ │ [YouTube 🔴]                                                │  │
│ │ ⏳ Scheduled 20:00, 27/3 · Caption needs review             │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Detail Bottom Sheet (on tap) ──                               │
│ ┌────────────────────────────────────────────────────────────┐  │
│ │ "5 tips skincare mùa hè"                                   │  │
│ │ Status: Scheduled · Platform: TikTok + IG                  │  │
│ │ Time: 18:00, 27/3/2026                                     │  │
│ │ Caption: "POV: Da bạn sau..."                               │  │
│ │ [✏️ Edit] [🚀 Publish now] [🕐 Reschedule] [🗑 Cancel]    │  │
│ └────────────────────────────────────────────────────────────┘  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M24 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View detail | Tap item | — | Bottom sheet with full details |
| Edit | "Edit" in sheet | — | → Content editor |
| Publish now | "Publish now" | `PublishService/PublishNow` | Published |
| Reschedule | "Reschedule" | — | Date/time picker bottom sheet |
| Cancel | "Cancel" → confirm | `PublishService/Cancel` | Item cancelled |
| Filter | Tap tab | — | List filtered by status |

---

### M25. Mobile Publish Calendar

**Route**: `/publish/calendar` (mobile)
**Purpose**: Day-by-day view of scheduled content with quick creation.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Calendar                    [📅 Tháng 3, 2026] [List/Cal ▾]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ── Upcoming (today → 3 days) ──                                  │
│ ┌─ Day: Thứ 5, 27/3 ────────────────────────────── [+] ─────┐  │
│ │ 🟢 18:00 · "5 tips skincare"     · TikTok · Auto          │  │
│ │ 🟡 20:00 · "Serum review"        · YouTube · Draft         │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Day: Thứ 6, 28/3 ────────────────────────────── [+] ─────┐  │
│ │ 🟢 10:00 · "Product haul"         · Instagram · Ready      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Day: Thứ 7, 29/3 ────────────────────────────── [+] ─────┐  │
│ │ (trống — tap [+] để thêm)                                  │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── More days... ──                                               │
│ ┌─ Day: Chủ nhật, 30/3 ─────────────────────────── [+] ─────┐  │
│ │ 🟢 15:00 · "Weekly recap"         · TikTok · Ready         │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh · Infinite scroll                                │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M25 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View item | Tap item | — | → Bottom sheet with publish details |
| Add new | "+" on day | — | → Publish creation with pre-set date |
| Navigate month | Tap month header | — | Month picker |
| Toggle view | List/Cal toggle | — | Switch grid/list view |


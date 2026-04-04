# Screen: Mobile — Publish Queue

> **Screen ID**: M024
> **Module**: M11 — Publish Hub
> **Route**: `/publish` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §4, Product Freeze §10-12, A1 Schema (scheduled_posts, content_items, connected_accounts), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile publish queue — the chronological view of scheduled, published, and draft posts. Enables creators to monitor upcoming content, execute "publish now" for urgent posts, identify incomplete drafts requiring action, and manage their content pipeline from mobile. Designed for the "check what's coming up" and "quick approve before going live" patterns.

### User Goals
- See all upcoming scheduled posts in chronological order
- Quickly publish content if timing is right
- Identify and fix incomplete drafts (missing captions, media, etc.)
- Monitor publishing status and failures in real-time

### Business Goals
- Ensure 95%+ schedule adherence (reduce missed posts)
- Enable mobile approval workflows for manager/admin review
- Drive consistent publishing cadence
- Reduce incomplete draft abandonment

### When This Screen Is Used
- **Morning review**: Check today's scheduled content before starting day
- **Before publish**: Final review 30-60 minutes before scheduled time
- **Post-publish check**: Verify published content went live correctly
- **Push notification**: "📤 Bài đăng sắp đăng trong 1 giờ" → review queue
- **After content creation**: Verify new content is properly scheduled

### Entry Points
- Bottom nav → Content tab → "📤 Queue" segment
- Calendar (M045): "Xem hàng chờ" action
- Push notification: "📤 Bài đăng "{title}" sắp đăng trong 1 giờ" → deep link
- Home Dashboard (M001): Content Pipeline → "📤 Scheduled" chip
- Quick Publish (M006): After scheduling → "Xem queue"

### Exit Points
- Tap post → Content Detail / Editor
- "📤 Publish now" → Immediate publish → status updates
- Calendar button → Calendar view
- Tap incomplete draft → Editor with specific field highlighted

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `publish:read` permission
- At least one content item in scheduled/published/draft state
- Connected accounts have valid tokens for scheduled publishing

### Postconditions
- Published posts → status updated to "published" in `content_items`
- Rescheduled posts → `scheduled_posts.scheduled_at` updated
- Deleted scheduled posts → soft-deleted, removed from queue
- Analytics events dispatched for all user actions

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Publish Queue                               [📅 Calendar] [⋮]    │
├──────────────────────────────────────────────────────────────────────┤
│ Tabs: [📋 Queued (5)] [📤 Published (12)] [📝 Drafts (3)]          │
│                                                                      │
│ ── Today ─────────────────────────────────────────────────────────── │
│ ┌─ Post Card ──────────────────────────────────────────────────────┐│
│ │ [📸 Thumb] "5 tips nấu ăn"                     🎵 TikTok        ││
│ │ 📅 19:00 · In 4 hours · [🟢 Ready]                               ││
│ │ ✅ Video ✅ Caption ✅ Hashtags ✅ Cover                          ││
│ │ [📤 Publish now] [✏ Edit] [📅 Reschedule] [⋮]                    ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Post Card ──────────────────────────────────────────────────────┐│
│ │ [📸 Thumb] "Serum review tháng 3"              📸 Instagram      ││
│ │ 📅 Tomorrow 12:00 · [🟡 Draft — missing caption]                 ││
│ │ ✅ Image ⚠️ Caption ✅ Hashtags ❌ Location                      ││
│ │ [✏ Complete draft] [📅 Reschedule]                                ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ── Tomorrow ──────────────────────────────────────────────────────── │
│ ┌─ Post Card ──────────────────────────────────────────────────────┐│
│ │ [📸 Thumb] "Haul tháng 3"                      📺 YouTube        ││
│ │ 📅 10:00 · [🔴 Missing video file]                                ││
│ │ ❌ Video ✅ Title ⚠️ Description ✅ Tags                          ││
│ │ [📎 Upload video] [✏ Edit] [⋮]                                    ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ── Next Week ─────────────────────────────────────────────────────── │
│ ┌─ Post Card ──────────────────────────────────────────────────────┐│
│ │ [📸 Thumb] "Skincare Q&A"                      🎵 TikTok         ││
│ │ 📅 Mon 01/04 19:00 · [🟢 Ready]                                  ││
│ │ [📤 Publish now] [✏ Edit] [📅 Reschedule]                        ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ Pull-to-refresh                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
PublishQueuePage
├── AppBar
│   ├── BackButton
│   ├── Title ("Publish Queue")
│   ├── CalendarButton ("📅" → Calendar M045)
│   └── MoreMenu ("⋮" → Bulk actions, Settings)
├── TabBar (3 tabs)
│   ├── QueuedTab ("📋 Queued" + count badge)
│   ├── PublishedTab ("📤 Published" + count)
│   └── DraftsTab ("📝 Drafts" + count)
├── TabBarView
│   └── PostList (per tab, pull-to-refresh, grouped by day)
│       ├── DaySectionHeader (date label + post count)
│       └── PostCard[] (swipeable)
│           ├── Thumbnail (left, 80×80dp, with platform icon overlay)
│           ├── PostInfo
│           │   ├── Title (truncated to 2 lines)
│           │   ├── PlatformBadge (🎵/📸/📺 + name)
│           │   ├── ScheduleTime ("📅 19:00 · In 4 hours")
│           │   └── StatusBadge
│           │       ├── READY: "🟢 Ready"
│           │       ├── DRAFT: "🟡 Draft — {missing_field}"
│           │       ├── INCOMPLETE: "🔴 Missing {asset}"
│           │       ├── PUBLISHING: "⏳ Đang đăng..."
│           │       ├── PUBLISHED: "✅ Đã đăng"
│           │       └── FAILED: "❌ Lỗi — [Thử lại]"
│           ├── CompletenessChecklist (✅/⚠️/❌ per required field)
│           └── ActionButtons (conditional per status)
│               ├── PublishNowButton (Ready only)
│               ├── EditButton (always)
│               ├── RescheduleButton (Queued/Draft)
│               ├── UploadButton (Missing media)
│               ├── CompleteDraftButton (Draft)
│               ├── RetryButton (Failed)
│               └── MoreMenu (Delete, Duplicate, Move to draft)
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Queued posts | `scheduled_posts WHERE status='queued' ORDER BY scheduled_at ASC` | `PublishService/ListQueue(tab, cursor)` | Post cards grouped by day | 5m TTL |
| Published posts | `content_items WHERE status='published' ORDER BY published_at DESC` | `PublishService/ListPublished(cursor)` | Post cards grouped by day | 5m TTL |
| Drafts | `content_items WHERE status='draft' ORDER BY updated_at DESC` | `PublishService/ListDrafts(cursor)` | Post cards | 10m TTL |
| Tab counts | Aggregation queries | Included in list responses | Badge numbers | 2m TTL |
| Post thumbnail | `content_items.thumbnail_url` | CDN | 80×80dp square crop | Until invalidated |
| Schedule time | `scheduled_posts.scheduled_at` | Included in post | "19:00 · In 4 hours" (relative) | — |
| Completeness | Per-post validation | Client-side check | ✅/⚠️/❌ per field | — |
| Platform token status | `connected_accounts.token_status` | `AccountService/GetStatus` | 🟢/🔴 in status badge | 5m |

---

## 6. Actions Table

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Publish now | "📤 Publish now" button | Primary CTA | `PublishService/PublishNow(post_id)` | Confirmation dialog → spinner → "✅ Đã đăng!" toast. Card moves to Published tab. | `publish:create` |
| 2 | Edit post | "✏ Edit" button | Navigate | — | Push → Content Editor with post loaded | `publish:schedule` |
| 3 | Reschedule | "📅 Reschedule" button | Picker | `PublishService/Reschedule(post_id, new_time)` | Date/time picker → card updates position in queue | `publish:schedule` |
| 4 | Upload missing media | "📎 Upload video" | Action | Upload flow → `ContentService/AttachMedia(post_id, file)` | File picker → upload progress → status changes to Ready | `publish:schedule` |
| 5 | Complete draft | "✏ Complete draft" | Navigate | — | Push → Editor with missing field highlighted | `publish:schedule` |
| 6 | Retry failed publish | "Thử lại" on failed | Action | `PublishService/Retry(post_id)` | Spinner → success or show error detail | `publish:create` |
| 7 | Delete scheduled | ⋮ → "Xóa" | Destructive | `PublishService/Delete(post_id)` | Confirmation "Xóa bài này?" → card removed with animation | `publish:cancel` |
| 8 | Duplicate post | ⋮ → "Nhân bản" | Action | `PublishService/Duplicate(post_id)` | New draft created → toast "Đã nhân bản" | `publish:create` |
| 9 | Switch tab | Tap tab | Filter | `PublishService/List{tab}(cursor)` | List updates to show selected tab content | `publish:read` |
| 10 | Pull refresh | Pull-down | Refresh | Refetch current tab | Data refreshes. Haptic light. | `publish:read` |
| 11 | Open calendar | Tap "📅" | Navigate | — | Push → Calendar view (M045) | `publish:read` |
| 12 | Swipe delete | Swipe left (queued tab) | Destructive | Confirmation → `PublishService/Delete(post_id)` | Haptic medium → confirmation → card removed | `publish:cancel` |

---

## 7. Validation Rules

### Publish Readiness
| Check | Rule | Error |
|---|---|---|
| Required media | Platform-specific media present | "❌ Thiếu {media_type}" (🔴 status) |
| Caption/title | Not empty, within platform char limit | "⚠️ Caption — thiếu hoặc quá dài" |
| Platform token | Connected account token is valid | "🔴 {Platform} ngắt kết nối. [Kết nối lại]" |
| Schedule time | Must be in the future (for queued) | "📅 Thời gian đã qua. [Đăng ngay] hoặc [Đổi lịch]" |
| Aspect ratio | Matches platform requirements | "⚠️ Tỷ lệ video không đúng cho {platform}" |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial tab load | Card shimmer (3 skeleton cards) | Wait |
| LOADED | Posts available | Day-grouped post cards with actions | Normal interaction |
| EMPTY_QUEUED | No queued posts | "📋 Chưa có bài lên lịch. [📅 Lên lịch bài đăng đầu tiên →]" | Create content |
| EMPTY_PUBLISHED | No published posts | "📤 Chưa có bài đã đăng." | Queue content |
| EMPTY_DRAFTS | No drafts | "📝 Không có bản nháp nào." | Create content |
| HAS_INCOMPLETE | Posts with missing fields | Red badge on Queued tab + incomplete posts highlighted with orange border | Fix incomplete posts |
| PUBLISHING | "Publish now" in progress | Spinner on publish button. Card greyed out. | Wait |
| PUBLISH_FAILED | Platform API rejected | Card shows "❌ Lỗi: {reason}. [Thử lại]" | Retry or edit |
| RESCHEDULING | Reschedule picker open | Date/time bottom sheet | Select new time |
| REFRESHING | Pull-to-refresh | Refresh indicator | Wait |
| OFFLINE | No network | Banner: "📡 Ngoại tuyến — lịch đăng có thể chưa cập nhật" + cached queue | Read cached |
| ERROR | API failed | "Không tải được hàng chờ. [Thử lại]" | Retry |

---

## 9. Permissions & Role-based Behavior

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View queue | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ❌ | ❌ |
| Publish now | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Edit post | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ❌ | ❌ |
| Reschedule | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Delete scheduled | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Retry failed | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Editor**: "📤 Publish now" button hidden. Can edit and reschedule but not trigger publish.
- **Contributor**: Only sees own posts. Other users' posts hidden.
- **Viewer/External**: No access to publish queue.

---

## 10. Mobile-specific UX

### Gestures & Haptics
| Gesture | Target | Haptic | Result |
|---|---|---|---|
| Tap post card | PostCard | Light | Push → Content Editor |
| Swipe left | PostCard (Queued tab) | Medium | Delete action reveal |
| Pull down | Page | Light | Refresh current tab |
| Long press post | PostCard | Heavy | Context menu (Edit, Reschedule, Delete, Duplicate) |
| Tap publish now | PublishNow button | Success vibration | Publish confirmation |

### Push Notification Integration
- **1 hour before scheduled**: "📤 Bài "{title}" sắp đăng lúc 19:00 [Xem]"
- **Publish failed**: "❌ Không đăng được "{title}" trên TikTok. [Thử lại]"
- **Published successfully**: "✅ "{title}" đã đăng! [Xem analytics]"
- Tap notification → deep link to post card in queue

### Offline Behavior
- **Cached**: Queued and published post lists (last known state)
- **Not available**: Publish actions, reschedule, upload
- Banner: "📡 Ngoại tuyến — lịch đăng có thể chưa cập nhật"

---

## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| Scheduled time has passed | Card highlighted orange. Status: "⏰ Quá giờ — [📤 Đăng ngay] hoặc [📅 Đổi lịch]" |
| Platform token expired before publish | Red dot on platform badge. "🔴 {Platform} ngắt kết nối. Đăng không thể thực hiện. [Kết nối lại →]" |
| 50+ queued posts | Virtual scroll. Day headers sticky. Performance target: 60fps. |
| Multi-platform post (same content, 3 platforms) | Show as 1 card with 3 platform badges. Each can fail independently — show per-platform status. |
| Post deleted on platform after publish | Status shows "⚠️ Đã bị xóa trên nền tảng" |
| Concurrent edit (2 users editing same post) | Optimistic lock. If conflict: "⚠️ Bài đã được cập nhật. [Tải lại]" |

---

## 12. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| Queue list | SSE `/events/publish` | Real-time (new scheduleds, status changes) |
| Publish status | SSE | Real-time (publishing → published/failed) |
| Platform token status | Polling | Every 5 minutes |

### Real-time UX
- **New scheduled post**: Card slides in at correct position. Tab badge increments.
- **Publish success**: Card animates to Published tab with ✅ transition.
- **Publish failed**: Card shows red flash animation + ❌ badge.

---

## 13. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `publish.queue.viewed` | Page load | `tab`, `queued_count`, `incomplete_count`, `source` |
| `publish.queue.publish_now` | Publish now tapped | `post_id`, `platform`, `time_before_scheduled` |
| `publish.queue.rescheduled` | Post rescheduled | `post_id`, `old_time`, `new_time` |
| `publish.queue.deleted` | Post deleted | `post_id`, `post_status` |
| `publish.queue.draft_completed` | Draft completed | `post_id`, `missing_fields_fixed` |
| `publish.queue.retry` | Failed publish retried | `post_id`, `original_error` |
| `publish.queue.tab_switched` | Tab changed | `from_tab`, `to_tab` |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Screen render | <1.5s |
| Publish now → confirmation | <3s |
| Tab switch | <500ms |
| Scroll performance | 60fps (virtual scroll for 50+ items) |
| Pull-to-refresh | <2s |

---

## 15. Flutter Implementation Notes

### Widget Structure
- **Route**: `/publish` → `PublishQueuePage extends ConsumerStatefulWidget`
- **State**: Riverpod `publishQueueProvider(tab)` per tab
- **Tabs**: `TabBar` + `TabBarView` with lazy loading per tab
- **Post list**: `ListView.builder` with `Dismissible` for swipe-to-delete
- **Day headers**: `StickyHeader` package for sticky date sections
- **Pull-to-refresh**: `RefreshIndicator` per `TabBarView` child

### Data Fetching
```
onInit:
  // Load current tab (default: Queued)
  publishService.listQueue('queued', cursor: null)
  
onTabSwitch(tab):
  if (!tabLoaded[tab]) {
    publishService.listQueue(tab, cursor: null)
    tabLoaded[tab] = true
  }
  
onPublishNow(postId):
  confirm('Đăng bài ngay?')
  → publishService.publishNow(postId)
  → move card to Published tab with animation
```

---

## 16. Navigation Map

```
Publish Queue (/publish)
├── → /publish/edit/[post_id] (tap post → Content Editor)
├── → /calendar (tap 📅 → Calendar M045)
├── → /content/new (via "Lên lịch bài đăng đầu tiên" empty state)
├── → /analytics/content/[id] (via "Xem analytics" push notification)
├── → /settings/platforms (via "Kết nối lại" token error)
└── ← Back (via back button or bottom nav)
```

---

## 17. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + show cached queue | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được hàng chờ. [Thử lại]" | Retry button |
| Publish failed | Platform API rejected | Card: "❌ Lỗi: {error}. [Thử lại]" + expand error detail | Retry or edit |
| Token expired | Platform OAuth invalid | Card: "🔴 {Platform} ngắt. [Kết nối lại →]" | Re-auth flow |
| Schedule conflict | Same time as another post | Warning: "⚠️ Đã có bài đăng lúc {time}. Vẫn đăng?" | Confirm or reschedule |
| Media upload failed | File too large or network | Toast: "Upload thất bại. [Thử lại]" + file preserved | Retry upload |

---

## 18. Accessibility

| Element | Requirement |
|---|---|
| Post cards | `Semantics(label: "5 tips nấu ăn, TikTok, 19 giờ hôm nay, trạng thái sẵn sàng")` |
| Status badges | Color not sole indicator — text labels required (🟢 Ready, 🔴 Missing) |
| Completeness checklist | `Semantics(label: "Video sẵn sàng, Caption sẵn sàng, Hashtag sẵn sàng")` |
| Tab badge | `Semantics(label: "Hàng chờ, 5 bài")` |
| Publish now button | `Semantics(button: true, label: "Đăng bài 5 tips nấu ăn ngay bây giờ")`, min 48×48dp |
| Day section headers | `Semantics(header: true, label: "Hôm nay, 2 bài đăng")` |
| Swipe actions | Also available via long-press context menu |

---

## 19. Localization Notes

- Primary language: Vietnamese
- Schedule time: "19:00" (24h format)
- Relative time: "Trong 4 giờ", "Ngày mai", "Thứ 2 01/04"
- Status labels: "Sẵn sàng", "Bản nháp", "Đã đăng", "Lỗi"
- Tab labels: "Hàng chờ", "Đã đăng", "Bản nháp"
- Day headers: "Hôm nay", "Ngày mai", "Tuần tới", then DD/MM/YYYY
- Confirmation: "Bạn có muốn đăng bài ngay?"

---

## 20. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Publish now CTA, active tab indicator |
| `--color-success` | Ready status (🟢), published status (✅) |
| `--color-warning` | Draft status (🟡), incomplete fields (⚠️), overdue (⏰) |
| `--color-danger` | Missing media (🔴), failed publish (❌), delete action |
| `--color-surface-elevated` | Post cards |
| `--color-text-primary` | Post titles |
| `--color-text-secondary` | Schedule time, relative time, platform labels |

---

## 21. Related Screens

| Screen | Relationship |
|---|---|
| [W053] Web Publish Queue | Web equivalent (full table + bulk actions + drag-to-reorder) |
| [M025] Mobile Calendar | Calendar view of schedule |
| [M023] Mobile Quick Publish | Quick publish flow |
| [M001] Mobile Home Dashboard | Pipeline → Scheduled count |

---

## 22. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 2.0 | **Full Tier A rewrite** from 242-line Tier C. Added complete 22-section structure: expanded wireframe with completeness checklist, full component hierarchy with status badges, specific data binding (not template), 12 user actions with real API calls, publish readiness validation, 12 states, full RBAC matrix, mobile UX with gestures/push notifications/offline, 6 edge cases, real-time SSE, 7 tracking events, performance targets, Flutter implementation, navigation map, error handling (6 scenarios), accessibility with semantic labels, localization, design tokens. Replaced ALL template placeholders. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

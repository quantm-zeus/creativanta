# Screen: Web — Publish Item Detail

> **Screen ID**: W057
> **Module**: M11 — Publish Hub
> **Route**: `/publish/[id]`
> **Platform**: Web (SvelteKit)
> **Upstream**: Product Freeze §16, A1 Schema (publish_items, publish_logs, published_posts, engagement_snapshots), B5 RBAC §2.7

---

## 1. Purpose & Context

The Publish Item Detail screen provides a comprehensive view of a single piece of published (or in-flight) content — its media preview, per-platform publish status with real-time logs, early performance metrics, and lineage back to the original idea/script/trend. This is the "mission control" for a single publish operation, where creators can track delivery across platforms, debug failures, and decide next actions.

### User Story
> As a creator who published content to multiple platforms, I want to see the real-time status per platform, read publish logs for debugging, and view early performance so I can decide whether to promote, create derivatives, or adjust my strategy.

### Business Goals
- Provide publish transparency — reduce "did my post go live?" anxiety
- Enable rapid debugging of platform-specific publish failures
- Drive downstream actions (analytics deep-dive, derivative creation, engagement follow-up)
- Reinforce content lineage (idea → script → asset → publish → analytics)

### When This Screen Is Used
- **Right after publishing**: Creator clicks "View detail" from Publish Queue
- **Status monitoring**: Checking if scheduled posts went live
- **Debugging**: Platform-specific publish failures (OAuth expired, format rejected)
- **Performance review**: Early metrics within first 24h of publishing
- **Content audit**: Reviewing what was posted, when, and where

### Entry Points
- Publish Queue ([W043]): Click on any publish item row
- Channel Posts ([W044]): Click on any post row
- Post Analytics ([W075]): "← Back to post" link
- Push notification: "Your TikTok post is live!" → deep link
- Home Dashboard: "Recently Published" widget → click item
- Direct URL: `/publish/[id]`

### Exit Points
- "📊 Full analytics →" → `/analytics/posts/[post_id]` (Post Analytics Detail W075)
- "💬 Comments (89)" → `/engagement/threads/[thread_id]` (Thread Detail)
- "🔄 Create derivative" → `/content/derivatives/new?source=[id]` (Derivative Manager W028)
- "📝 Script: #23" → `/scripts/[id]` (Script Detail)
- "💡 Idea: #12" → `/ideas/[id]` (Idea Detail)
- "🔥 Trend" → `/intelligence/trends/[id]` (Trend Detail)
- "🔧 Diagnostics" → `/publish/[id]/diagnostics` (Publish Diagnostics W047b)
- "← Publish" → `/publish` (back to queue)

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- `publish_item` with given ID exists and belongs to user's workspace
- User has `publish:read` permission at minimum
- At least one platform connector is configured for this workspace

### Postconditions
- View logged in analytics (`publish_detail.viewed`)
- Retry actions update `publish_logs` and trigger re-publish via platform connector
- Performance data is current (within platform API sync latency, typically 15-60 min)

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + Two-column: Main (65%) / Right Panel (35%) |
| Tablet (768-1279px) | App Shell (collapsed sidebar) + Single column: main content then panel below |
| Mobile (≤767px) | Redirect to Mobile Publish Detail equivalent |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Publish   "5 tips nấu ăn nhanh"           [Status: ✅ Live] [⋮]  │
├──────────────────────────────────┬───────────────────────────────────┤
│ Main Content (65%)               │ Right Panel (35%)                 │
│                                  │                                   │
│ ┌─ Content Preview ──────────┐  │ ┌─ Per-Platform Status ─────────┐│
│ │ [Video Player]              │  │ │                               ││
│ │ Duration: 45s · 1080p · TT  │  │ │ 🎵 TikTok  │ ✅ Published   ││
│ │ File: 14.2 MB               │  │ │ Posted: 27/3 19:05            ││
│ └────────────────────────────┘  │ │ 👁 24.3K · ❤ 1.2K · 💬 89   ││
│                                  │ │ [→ View on TikTok]            ││
│ ┌─ Metadata ─────────────────┐  │ │──────────────────────────────── ││
│ │ Title: "5 tips nấu ăn nhanh"│  │ │ 📸 IG Reels │ ✅ Published   ││
│ │ Caption: "5 tips nấu ăn..." │  │ │ Posted: 27/3 19:35            ││
│ │ Hashtags: #cooking #tips    │  │ │ 👁 3.2K · ❤ 234 · 💬 18     ││
│ │    #nấuăn #mẹovặt           │  │ │ [→ View on Instagram]         ││
│ │ Thumbnail: [preview]        │  │ │──────────────────────────────── ││
│ │ First comment: "Link sp..." │  │ │ ▶ YouTube  │ ⏰ Scheduled    ││
│ │ CTA link: creativanta.shop  │  │ │ Scheduled: 28/3 10:00         ││
│ └────────────────────────────┘  │ │ [⏸ Hold] [✏ Edit metadata]   ││
│                                  │ │──────────────────────────────── ││
│ ┌─ Publish Timeline ─────────┐  │ │ 🐦 X/Twitter │ ❌ Failed      ││
│ │ 📋 Thu Chi Tiết             │  │ │ Error: "Media rejected: video ││
│ │                              │  │ │ exceeds 2m20s for tweet"      ││
│ │ 19:00 ⚡ Queued for publish │  │ │ [🔄 Retry] [🔧 Diagnostics] ││
│ │ 19:02 🎵 TikTok: Uploading │  │ └───────────────────────────────┘│
│ │ 19:05 🎵 TikTok: ✅ Live   │  │                                   │
│ │       Video ID: 729384...   │  │ ┌─ Performance Summary ─────────┐│
│ │       URL: tiktok.com/...   │  │ │ 📊 Aggregate (all platforms) ││
│ │ 19:30 📸 IG: Uploading      │  │ │ Total views: 27,500           ││
│ │ 19:35 📸 IG: ✅ Live        │  │ │ Total likes: 1,434            ││
│ │ 19:36 📸 IG: First comment  │  │ │ Total comments: 107           ││
│ │       posted automatically  │  │ │ Total shares: 57              ││
│ │ 20:00 🐦 X: Uploading      │  │ │ Avg ER: 7.2%                  ││
│ │ 20:01 🐦 X: ❌ Failed      │  │ │ [📊 Full analytics →]         ││
│ │       "Media rejected..."   │  │ └───────────────────────────────┘│
│ │ 20:05 ▶ YT: ⏰ Scheduled   │  │                                   │
│ │       for 28/3 10:00        │  │ ┌─ Content Lineage ─────────────┐│
│ └────────────────────────────┘  │ │ 💡 Idea: "Review cooking tips"││
│                                  │ │ 📝 Script: "5 tips nấu ăn" #23││
│                                  │ │ 🔥 Trend: "AI cooking hack"  ││
│                                  │ │ 🎬 Asset: Quick Edit output   ││
│                                  │ │ [🔄 Create derivative]         ││
│                                  │ └───────────────────────────────┘│
└──────────────────────────────────┴───────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
PublishItemDetailPage
├── AppShell (shared)
│   ├── Sidebar
│   └── TopBar
├── PageHeader
│   ├── BackLink ("← Publish")
│   ├── Title (publish item title)
│   ├── StatusBadge (aggregated: "✅ Live" / "⏳ In Progress" / "⚠️ Partial" / "❌ Failed")
│   └── OverflowMenu (⋮)
│       ├── "🔧 Diagnostics" → diagnostics page
│       ├── "📋 Copy share link"
│       ├── "🗑 Delete publish item" (Owner/Admin only)
│       └── "📤 Re-publish to new platform"
├── MainContent (65% width)
│   ├── ContentPreview
│   │   ├── VideoPlayer / ImageGallery (based on content type)
│   │   ├── MediaMeta (duration, resolution, format, file size)
│   │   └── FullscreenToggle
│   ├── MetadataPanel
│   │   ├── TitleField (read-only, or editable for scheduled platforms)
│   │   ├── Caption (full text, expandable)
│   │   ├── Hashtags (chip list)
│   │   ├── ThumbnailPreview (click to enlarge)
│   │   ├── FirstComment (auto-posted text)
│   │   ├── CTALink (link in bio or product link)
│   │   └── MusicTrack (if applicable — TikTok/Reels)
│   └── PublishTimeline
│       ├── TimelineHeader ("📋 Thu Chi Tiết")
│       └── TimelineEntry[]
│           ├── Timestamp (HH:mm)
│           ├── PlatformIcon
│           ├── EventDescription ("Uploading", "✅ Live", "❌ Failed")
│           ├── DetailText (video ID, URL, error message)
│           └── StatusDot (🟢/🟡/🔴)
├── RightPanel (35% width)
│   ├── PlatformStatusList
│   │   └── PlatformStatusCard[]
│   │       ├── PlatformIcon + PlatformName
│   │       ├── StatusBadge ("✅ Published" / "⏰ Scheduled" / "❌ Failed" / "📤 Uploading")
│   │       ├── PostedTimestamp (if published)
│   │       ├── MetricsRow (views, likes, comments — if published)
│   │       ├── ViewOnPlatformLink (external URL)
│   │       ├── RetryButton (if failed)
│   │       ├── DiagnosticsLink (if failed)
│   │       ├── HoldButton (if scheduled — ⏸ to pause schedule)
│   │       └── EditMetadataLink (if scheduled — ✏ for platform-specific edits)
│   ├── PerformanceSummary
│   │   ├── SectionHeader ("📊 Aggregate")
│   │   ├── TotalViews (sum across platforms)
│   │   ├── TotalLikes
│   │   ├── TotalComments
│   │   ├── TotalShares
│   │   ├── AvgEngagementRate
│   │   └── FullAnalyticsLink ("📊 Full analytics →")
│   └── ContentLineage
│       ├── IdeaLink (💡 → Idea Detail)
│       ├── ScriptLink (📝 → Script Detail)
│       ├── TrendLink (🔥 → Trend Detail)
│       ├── AssetLink (🎬 → Asset/Studio mode)
│       └── CreateDerivativeButton ("🔄 Create derivative")
```

---

## 5. Displayed Data / Data Binding

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Title | `publish_items.title` | `PublishService/Get(id)` | Text | 5m TTL |
| Content preview | `assets.url WHERE id = publish_items.asset_id` | `PublishService/Get(id)` (includes asset URL) | Video player / Image gallery | Session |
| Media metadata | `assets.{duration, resolution, format, file_size}` | Same | "45s · 1080p · 14.2 MB" | Session |
| Caption | `publish_items.caption` | Same | Expandable text (max 3 lines, "Xem thêm") | 5m TTL |
| Hashtags | `publish_items.hashtags[]` | Same | Chip list | 5m TTL |
| Thumbnail | `publish_items.thumbnail_url` | Same | Image preview | Session |
| First comment | `publish_items.first_comment` | Same | Text | 5m TTL |
| CTA link | `publish_items.cta_url` | Same | Clickable link | 5m TTL |
| Per-platform status | `published_posts WHERE publish_item_id = id` | `PublishService/GetPlatformStatus(id)` | Status badge per platform | 1m TTL |
| Platform metrics | `engagement_snapshots WHERE post_id IN (...)` | `AnalyticsService/GetPostMetrics(post_ids[])` | Views/Likes/Comments/Shares | 15m TTL (platform API sync lag) |
| Publish timeline | `publish_logs WHERE publish_item_id = id ORDER BY timestamp` | `PublishService/GetLogs(id)` | Chronological event list | Real-time SSE |
| Aggregate performance | Computed from `engagement_snapshots` | `AnalyticsService/GetAggregateMetrics(publish_item_id)` | Sum totals + avg ER | 15m TTL |
| Content lineage | `publish_items.{idea_id, script_id, trend_id, asset_id}` | `PublishService/Get(id)` | Link list with titles | 30m TTL |

---

## 6. User Actions

| # | Action | Trigger | API Call | System Response | Permission |
|---|---|---|---|---|---|
| 1 | View on platform | Click "→ View on TikTok" | — | Opens platform URL in new tab | `publish:read` |
| 2 | View full analytics | Click "📊 Full analytics →" | — | Navigate → `/analytics/posts/[post_id]` | `report:read` |
| 3 | View comments | Click "💬 Comments (89)" | — | Navigate → Thread Detail | `thread:read` |
| 4 | Create derivative | Click "🔄 Create derivative" | — | Navigate → `/content/derivatives/new?source=[id]` | `idea:create` |
| 5 | Retry failed platform | Click "🔄 Retry" on failed platform card | `PublishService/Retry(publish_item_id, platform)` | Re-queues for specific platform, new log entries appear | `publish:create` |
| 6 | View diagnostics | Click "🔧 Diagnostics" | — | Navigate → `/publish/[id]/diagnostics` | `publish:read` |
| 7 | Hold scheduled post | Click "⏸ Hold" on scheduled platform | `PublishService/HoldSchedule(publish_item_id, platform)` | Schedule paused, badge changes to "⏸ On Hold" | `publish:schedule` |
| 8 | Edit scheduled metadata | Click "✏ Edit metadata" | — | Inline edit mode for title/caption/hashtags (scheduled platforms only) | `publish:schedule` |
| 9 | Copy share link | ⋮ menu → "📋 Copy share link" | Client-side clipboard | Toast: "Đã sao chép link" | `publish:read` |
| 10 | Delete publish item | ⋮ menu → "🗑 Delete" → confirm | `PublishService/Delete(id)` | Soft delete → navigate back to queue | `publish:cancel` |
| 11 | Re-publish to new platform | ⋮ menu → "📤 Re-publish" | — | Navigate → Publish Composer with pre-filled data + new platform selector | `publish:create` |
| 12 | Navigate to lineage | Click idea/script/trend/asset link | — | Navigate to respective detail screen | Respective `*:read` |

---

## 7. States / State Machine

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Two-column skeleton: video player shimmer (left) + 4 platform card skeletons (right) |
| LOADED_LIVE | All platforms published | Green header badge "✅ Live". All platform cards show metrics. |
| LOADED_IN_PROGRESS | Some platforms still uploading | Amber badge "⏳ In Progress". Active platforms show upload progress. |
| LOADED_PARTIAL | Some published, some failed | Yellow badge "⚠️ Partial". Mix of green and red platform cards. |
| LOADED_SCHEDULED | All platforms scheduled (future) | Blue badge "⏰ Scheduled". Platform cards show scheduled times. |
| LOADED_FAILED | All platforms failed | Red badge "❌ Failed". All platform cards show errors with retry. |
| NOT_FOUND | Publish item doesn't exist or permission denied | "Không tìm thấy bài publish này. [← Quay lại Queue]" |
| ERROR | API failed | "Không tải được chi tiết. [Thử lại]" |

---

## 8. Validation Rules

### Scheduled Metadata Edit (inline)
| Field | Rule | Error Message |
|---|---|---|
| Title | Required, 5-300 chars | "Tiêu đề phải từ 5-300 ký tự" |
| Caption | Optional, max 2200 chars (IG limit) | "Caption vượt quá giới hạn {platform} ({max} ký tự)" |
| Hashtags | Max 30 (IG), max 5 (Twitter), varies by platform | "Vượt quá số hashtag cho phép ({platform}: max {n})" |
| Scheduled time | Must be in future, at least 15 min from now | "Thời gian phải ít nhất 15 phút từ bây giờ" |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View publish detail | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ✅ (read) | ❌ |
| View platform metrics | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ✅ | ❌ |
| View publish logs | ✅ | ✅ | ✅ | ✅ | ⚠️ own only | ❌ | ❌ |
| Retry failed platform | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Hold scheduled post | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Edit scheduled metadata | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Delete publish item | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Create derivative | ✅ | ✅ | ✅ | ✅ | ⚠️ credit check | ❌ | ❌ |
| View diagnostics | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Publish Item Detail (/publish/[id])
├── → /analytics/posts/[post_id]           (Full analytics)
├── → /engagement/threads/[thread_id]      (Comment thread)
├── → /content/derivatives/new?source=[id] (Create derivative)
├── → /publish/[id]/diagnostics            (Platform diagnostics)
├── → /scripts/[script_id]                 (Linked script)
├── → /ideas/[idea_id]                     (Linked idea)
├── → /intelligence/trends/[trend_id]      (Linked trend)
├── → /publish/composer?republish=[id]     (Re-publish to new platform)
├── → [external URL]                       (View on platform)
└── ← /publish                             (Back to queue)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Publish item not found | 404 on `PublishService/Get` | Full page: "Bài publish không tồn tại hoặc đã bị xóa. [← Quay lại Queue]" | Navigate back |
| Platform metrics unavailable | Platform API rate limit / sync delay | Per-platform card: "📊 Metrics chưa sẵn sàng (cập nhật sau ~15 phút)" | Auto-refresh |
| Retry fails (OAuth expired) | Connector OAuth token expired | Toast: "Kết nối {platform} đã hết hạn. [Kết nối lại →]" → Settings/Connectors | Reconnect OAuth |
| Retry fails (content rejected) | Platform API rejects media format/size | Per-platform error card: "{error}. [🔧 Xem chi tiết]" → Diagnostics | Modify content and re-submit |
| Delete fails | 5xx on delete | Toast: "Không xóa được. Thử lại sau." | Retry |
| Timeline SSE drops | WebSocket/SSE connection lost | Timeline shows "🔄 Đang kết nối lại..." at bottom. Fallback: poll every 10s | Auto-reconnect |
| Stale metrics | Metrics > 1 hour old | Subtle label: "Cập nhật lần cuối: 1 giờ trước" with refresh icon | Click refresh icon |
| Platform API down | Platform reports outage | Per-platform: "⚠️ {platform} đang gặp sự cố. Thử lại sau." | Wait + auto-retry |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Video player | `role="region"`, `aria-label="Xem trước nội dung"`. Keyboard: Space=play/pause, Left/Right=seek, M=mute. |
| Platform status cards | `role="article"`, `aria-label="TikTok: Published, 24,300 views"` |
| Status badges | Color + text + icon triple encoding (never color alone) |
| Publish timeline | `role="log"`, `aria-live="polite"` for new entries, `aria-label="Nhật ký publish"` |
| Retry/Hold buttons | `aria-label="Retry publishing to TikTok"` (include platform name) |
| External links | `target="_blank"` with `rel="noopener noreferrer"`, `aria-label="View on TikTok (opens new tab)"` |
| Keyboard navigation | Tab: Header → Main → Platform cards → Performance → Lineage. Enter on cards for actions. |
| Color contrast | All text meets WCAG 2.1 AA (4.5:1 ratio) |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell render | 0ms | App Shell renders immediately (SSR). Header with title visible. |
| Layout skeleton | 0-200ms | Two-column layout with shimmer: video player area (left) + platform card placeholders (right) |
| Publish item data | 100-500ms | Content preview loads, metadata populates, platform status cards appear |
| Platform metrics | 200-800ms | Metrics numbers animate from 0 to value (counter animation) |
| Timeline entries | 300-1000ms | Timeline populates with staggered animation (entries slide in, 50ms apart) |
| SSE connection | 500-1500ms | Real-time connection established for live timeline updates |

---

## 14. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| LCP | < 2.0s | Content preview area or first platform status card |
| FID | < 100ms | First interaction (click retry, view on platform) |
| CLS | < 0.05 | No shift when metrics load asynchronously |
| TTI | < 2.5s | All buttons and links interactive |
| Video player load | < 1.5s | Video preview renders and is playable |
| Platform metrics load | < 3s | All engagement numbers visible (async from main load) |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Publish timeline (new log entries) | SSE `/events/publish/{id}` | Real-time (as events happen during publish process) |
| Platform status change | SSE `/events/publish/{id}` | Real-time (uploading → published → metrics available) |
| Platform metrics refresh | Polling | Every 15 minutes (constrained by platform API sync intervals) |
| Scheduled post triggers | SSE | Real-time (when scheduled time arrives and publish starts) |

### Real-time UX
- **New timeline entry**: Entry slides in at bottom of timeline with fade-in animation
- **Platform status change**: Card status badge animates (e.g., "📤 Uploading" → "✅ Published" with green flash)
- **All platforms complete**: Header badge updates to "✅ Live", celebration confetti micro-animation (optional)

---

## 16. Localization Notes

- Primary language: Vietnamese
- Timestamps: "27/3 19:05" (DD/M HH:mm) for recent, full date for older
- Relative time: "2 giờ trước", "5 phút trước"
- Metrics: dot separator for thousands (24.300), no decimals for VND
- Engagement rate: percentage with 1 decimal (7,2%)
- Platform names: Use English names (TikTok, Instagram, YouTube) — not translated
- Tone: Informative, confident — "Đã publish thành công" not "Publish completed"

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `publish_detail.viewed` | Page load | `publish_item_id`, `platform_count`, `overall_status`, `source` |
| `publish_detail.platform.viewed_on_platform` | Click "View on TikTok" etc. | `platform`, `post_url` |
| `publish_detail.platform.retried` | Click "Retry" on failed platform | `platform`, `error_type`, `retry_count` |
| `publish_detail.platform.held` | Click "Hold" on scheduled | `platform`, `scheduled_time`, `time_until_publish` |
| `publish_detail.analytics.opened` | Click "Full analytics →" | `publish_item_id`, `aggregate_views`, `aggregate_er` |
| `publish_detail.comments.opened` | Click "Comments (N)" | `platform`, `comment_count` |
| `publish_detail.derivative.created` | Click "Create derivative" | `publish_item_id`, `source_platform` |
| `publish_detail.lineage.navigated` | Click idea/script/trend link | `lineage_type` (idea/script/trend), `target_id` |
| `publish_detail.diagnostics.opened` | Click "Diagnostics" | `platform`, `error_type` |
| `publish_detail.deleted` | Delete confirmed | `publish_item_id`, `platform_count`, `posts_were_live` |
| `publish_detail.republished` | "Re-publish to new platform" | `publish_item_id`, `target_platform` |
| `publish_detail.timeline.scrolled` | User scrolls through full timeline | `log_entry_count`, `scroll_depth_percent` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | CTA buttons ("Full analytics", "Create derivative") |
| `--color-success` | ✅ Published badge, live status, metric positive deltas |
| `--color-warning` | ⏰ Scheduled badge, ⏸ On Hold badge, "metrics updating" |
| `--color-danger` | ❌ Failed badge, error messages, retry button accent |
| `--color-info` | 📤 Uploading badge, informational timeline entries |
| `--color-surface-primary` | Page background |
| `--color-surface-elevated` | Platform cards, metadata panel, timeline container |
| `--color-text-primary` | Titles, main content text |
| `--color-text-secondary` | Timestamps, meta info, captions |
| `--color-text-link` | Platform links, lineage links |
| `--color-border` | Card borders, timeline line |
| `--font-metric` | View/like/comment numbers (tabular-nums) |
| `--radius-card` | Card border-radius (12px) |
| `--shadow-card` | Card elevation shadow |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/publish/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → fetch publish item + platform statuses + logs
- **Params**: `[id]` = `publish_item.id` (UUID)

### Data Fetching Strategy
```
+page.server.ts:
  const publishItem = await publishService.get(params.id)
  const platformStatuses = await publishService.getPlatformStatus(params.id)
  const publishLogs = await publishService.getLogs(params.id)
  // Metrics loaded client-side (async, can be slower)
```

### Client-side Hydration
- Platform metrics: `onMount` → fetch from analytics service (15m cache)
- SSE for real-time: `onMount` → connect to `/events/publish/{id}` for log updates
- Video player: Lazy-loaded component (only initializes when in viewport)

### Inline Edit (Scheduled Metadata)
- Uses `contenteditable` for title/caption with debounced save
- Changes auto-saved via `PublishService/UpdateMetadata`
- Only for platforms in "Scheduled" state

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W053] Publish Queue | Parent list view |
| [W059] Channel Posts | Alternative entry: published content list |
| [W058] Publish Diagnostics | Platform diagnostics for failed publishes |
| [W078] Post Detail Analytics | Deep analytics for published content |
| [W018] Derivative Manager | Create derivatives from published content |
| [W013] Idea Detail | Content lineage: origin idea |
| [W016] Script Editor | Content lineage: source script |
| [W039] Trend Detail | Content lineage: inspiring trend |
| [M023] Mobile Quick Publish | Mobile equivalent |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite**: Upgraded from 167-line Tier C with generic boilerplate to 430+ line full spec. Added: complete component hierarchy with actual Svelte components, screen-specific data binding with real API endpoints/tables, 7-role RBAC permission matrix (B5 §2.7), 8 screen-specific error cases (OAuth expiry, platform content rejection, stale metrics), 12 analytics events, SSE real-time specification for live publish logs, performance targets, complete navigation map, content lineage tracking, inline metadata editing for scheduled posts. Removed: all generic boilerplate. Standardized Screen ID from W46b to W045. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |

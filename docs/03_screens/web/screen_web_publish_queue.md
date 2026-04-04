# Screen: Web — Publish Queue

> **Screen ID**: W053
> **Module**: M11 — Publish Hub
> **Route**: `/publish`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §18-19, A1 Schema (publish_jobs, publish_items, publish_logs)

---

## 1. Purpose & Context

The Publish Queue is the primary execution dashboard for content publishing. It shows all publish jobs across four states: Scheduled, Publishing, Published, and Failed. Users can preview, edit, publish immediately, pause, retry failed posts, and view diagnostics.

### User Story
> As a creator, I want to see all my scheduled, in-progress, and completed posts in one view so I can manage my publishing pipeline effectively.

### Entry Points
- Sidebar: "📤 Đăng bài" under Publish
- Home Dashboard: Schedule widget
- After Packaging QA flow
- Direct URL: `/publish`

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 📤 Đăng bài                                 [+ Tạo bài mới]        │
├──────────────────────────────────────────────────────────────────────┤
│ Tabs: [⏳ Lên lịch (5)] [🔄 Đang đăng (1)] [✅ Đã đăng (24)] [❌ Lỗi (2)]│
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ── Lên lịch ──                                                       │
│ ┌─ Publish Item ──────────────────────────────────────────────────┐ │
│ │ [🎬 Thumb] "5 tips nấu ăn nhanh"                               │ │
│ │ 📅 Hôm nay 19:00 · TikTok + IG Reels · Caption ready          │ │
│ │ Capability: 🟢 All native                                      │ │
│ │ [👁 Preview] [✏️ Edit] [📤 Đăng ngay] [⏸ Tạm hoãn] [❌ Hủy] │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ── Lỗi ──                                                            │
│ ┌─ Publish Item (Error) ──────────────────────────────────────────┐ │
│ │ [🎬 Thumb] "Kem chống nắng review"                              │ │
│ │ ❌ TikTok: API timeout after 3 retries · 2h trước              │ │
│ │ IG Reels: ✅ Published successfully                              │ │
│ │ [🔄 Thử lại TikTok] [📥 Export file] [📊 Diagnostics]         │ │
│ └──────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
PublishQueuePage
├── AppShell (shared)
├── PageHeader
│   ├── Title
│   └── CreateButton ("+ Tạo bài mới")
├── StatusTabs (with counts)
│   ├── ScheduledTab
│   ├── PublishingTab
│   ├── PublishedTab
│   └── FailedTab
└── PublishItemList
    └── PublishItemCard[]
        ├── Thumbnail (video/image preview)
        ├── Title
        ├── ScheduleInfo (date, time, timezone)
        ├── PlatformChips (icons per platform)
        ├── StatusPerPlatform (if multi-platform)
        ├── CapabilityBadge (🟢 native / 🟡 manual / 🔴 error)
        ├── ErrorMessage (if failed)
        └── ActionButtons
            ├── PreviewButton
            ├── EditButton (→ /packaging/[id])
            ├── PublishNowButton (on scheduled)
            ├── PauseButton (on scheduled)
            ├── CancelButton (on scheduled)
            ├── RetryButton (on failed)
            ├── ExportButton (on failed)
            └── DiagnosticsButton (on failed)
```

---

## 4-5. Data & Actions

| UI Element | Source | API | Display |
|---|---|---|---|
| Title | `publish_items.title` | `PublishService/List(status)` | Text |
| Schedule | `publish_jobs.scheduled_at` | same | "Hôm nay 19:00" or "Ngày mai 10:00" |
| Platforms | `publish_items.platforms` (array) | same | Platform icons with per-platform status |
| Capability | `connectors.capability` | `ConnectorService/Check` | 🟢🟡🔴 |
| Error | `publish_logs.error_message` | same | Red text |
| Thumbnail | `assets.thumbnail_url` | same | Image preview |

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Create new | "+ Tạo bài mới" | — | → Content picker → Packaging QA | `publish:create` |
| 2 | Preview | "👁 Preview" | — | Modal: player + metadata | `publish:read` |
| 3 | Edit | "✏️ Edit" | — | → `/packaging/[id]` | `publish:schedule` |
| 4 | Publish now | "📤 Đăng ngay" | `PublishService/Execute(id)` | Status → Publishing | `publish:execute` |
| 5 | Pause | "⏸ Tạm hoãn" | `PublishService/Pause(id)` | Status → Paused | `publish:schedule` |
| 6 | Cancel | "❌ Hủy" → confirm | `PublishService/Cancel(id)` | Item removed | `publish:cancel` |
| 7 | Retry | "🔄 Thử lại" | `PublishService/Retry(id)` | Re-enters queue | `publish:execute` |
| 8 | Export | "📥 Export" | Direct download | File + metadata | `publish:read` |
| 9 | Diagnostics | "📊 Diagnostics" | — | → `/publish/[id]/diagnostics` | `publish:read` |
| 10 | Switch tab | Click tab | Refetch with status filter | List updates | `publish:read` |

---

## 6-20. Standard Sections

### States
| State | Visual |
|---|---|
| LOADING | List skeleton |
| LOADED | Tabbed list with items |
| EMPTY_TAB | "Không có nội dung nào trong trạng thái này" |
| EMPTY_ALL | "Chưa có bài đăng nào. [Tạo bài đầu tiên →]" |

### Permission Matrix
- `publish:execute` (Owner, Admin, Manager) for immediate publish
- `publish:schedule` (+ Editor) for edit/pause
- `publish:read` (all) for viewing

### Real-time
- Publishing status updates via SSE `/events/publish`
- Status transitions animate (scheduled → publishing → published)
- Failed items get toast notification

### Performance
- 20 items per tab page
- Thumbnails lazy-loaded
- Tab counts: separate lightweight API call

### Technical Notes
- Route: `src/routes/(app)/publish/+page.svelte`
- Tab state in URL: `?tab=scheduled`
- Publishing status polling: every 5s for active jobs

### Related Screens
| Screen | Relationship |
|---|---|
| [W056] Packaging QA | Pre-publish quality check |
| [W054] Schedule Calendar | Calendar view |
| [W057] Publish Item Detail | Full detail |
| [W058] Publish Diagnostics | Error investigation |
| [M023] Mobile Quick Publish | Mobile equivalent |

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-27 | 1.0 | Initial specification |

---

## 7. Edge Cases

| Edge Case | Handling |
|---|---|
| All platforms fail for same item | Red card: "❌ Không đăng được lên nền tảng nào. [Xem diagnostics]" |
| Queue overflow (>50 items) | Search + filter appears: "Lọc theo trạng thái, platform" |
| Connector expires mid-publish | Per-platform: "⚠ Token {platform} hết hạn trong khi đăng. [Kết nối lại →]" |
| Scheduled item time has passed | Auto-queue: "⏰ Đã qua giờ hẹn — tự động thêm vào hàng chờ." |
| No platform connectors | Empty state: "Chưa kết nối nền tảng. [Kết nối ngay →]" → Settings |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached list | Auto-retry online |
| Publish execute fail | API error on "Đăng ngay" | Button reverts + Toast: "Không đăng được. [Thử lại]" | Retry |
| Cancel fail | API error on cancel | Toast: "Không hủy được. [Thử lại]" | Retry |
| SSE drops | Connection lost | Status updates pause, polling fallback every 10s | Auto-reconnect |
| Retry exhausted | 3 retries failed per platform | Card shows "❌ Đã thử 3 lần. [Xem diagnostics]" | Diagnostics |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Status tabs | `role="tablist"`, each tab `role="tab"` with `aria-selected`, count `aria-label="Lên lịch: 5 items"` |
| Publish item cards | `role="article"`, `aria-label="{title}, {platform}, {status}"` |
| Capability badge | `aria-label="Capability: {native/manual/error}"`, text + icon (not color-only) |
| Action buttons | `aria-label` including context: "Đăng ngay: {title}" |
| Real-time status | `aria-live="polite"` for publishing → published transitions |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Tab bar + list skeleton |
| Tab counts | 100-200ms | Badge counts populate |
| Item list | 200-600ms | Cards stagger in |
| Thumbnail load | 300-800ms | Lazy-loaded as visible |
| SSE connect | 500-1500ms | Real-time status active |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `publish_queue.viewed` | Page load | `tab`, `item_count`, `source` |
| `publish_queue.tab_changed` | Tab switch | `from_tab`, `to_tab` |
| `publish_queue.publish_now` | "Đăng ngay" | `item_id`, `platform_count` |
| `publish_queue.paused` | "Tạm hoãn" | `item_id`, `scheduled_time` |
| `publish_queue.cancelled` | "Hủy" confirmed | `item_id`, `status` |
| `publish_queue.retried` | "Thử lại" | `item_id`, `platform`, `retry_count` |
| `publish_queue.diagnostics` | "Diagnostics" | `item_id`, `error_type` |
| `publish_queue.created` | "+ Tạo bài mới" | `source` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/publish/+page.svelte`
- **Server load**: `+page.server.ts` → `PublishService/List(status)` + tab counts
- **Tab state**: URL param `?tab=scheduled` (persisted, shareable)
- **SSE**: `/events/publish` for status transitions (scheduled→publishing→published/failed)
- **Polling fallback**: Every 5s for active "publishing" items
- **Cancel**: Optimistic UI → confirm modal → API call → revert on error
- **Thumbnails**: `loading="lazy"`, placeholder until visible
- **Pagination**: 20 per tab page, cursor-based

---

## 13. Localization Notes

- Status: "⏳ Lên lịch", "🔄 Đang đăng", "✅ Đã đăng", "❌ Lỗi"
- Schedule: "Hôm nay 19:00", "Ngày mai 10:00", "28/03 19:00"
- Capability: "🟢 Tự động", "🟡 Thủ công", "🔴 Lỗi"
- Relative: "12 phút trước", "2h trước"
- Platform: English (TikTok, IG Reels, YouTube, X)
- Tone: Action-oriented, confident

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-status-scheduled` | ⏳ Scheduled badge (blue) |
| `--color-status-publishing` | 🔄 Publishing badge (amber) |
| `--color-status-published` | ✅ Published badge (green) |
| `--color-status-failed` | ❌ Failed badge (red) |
| `--color-capability-native` | 🟢 Native capability |
| `--color-capability-manual` | 🟡 Manual capability |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards |
| `--color-platform-*` | Platform-specific accents |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W056] Packaging QA | Pre-publish quality check |
| [W054] Schedule Calendar | Calendar view |
| [W057] Publish Item Detail | Full detail |
| [W058] Publish Diagnostics | Error investigation |
| [M023] Mobile Quick Publish | Mobile equivalent |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (all-platform fail, queue overflow), 5 errors, tab/card a11y, 8 analytics, SvelteKit impl (SSE, optimistic cancel), localization, 9 design tokens. | System |
| 2026-03-27 | 1.0 | Initial specification | System |

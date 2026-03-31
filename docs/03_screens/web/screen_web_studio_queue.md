# Screen: Web — Generation Queue

> **Screen ID**: W030
> **Module**: M07 — AI Studio
> **Route**: `/studio/queue`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 04 §6, Product Freeze §15, A1 Schema (generation_jobs, assets, credit_ledger), B5 RBAC §2.4

---

## 1. Purpose & Context

The Generation Queue is the real-time monitoring hub for all AI generation jobs across every Studio mode. It shows active jobs with live progress, completed outputs ready for review, and failed jobs with retry options. This is the "task manager" of the AI Studio — creators return here to check progress, download results, or push completed assets directly into the publish pipeline.

### User Story
> As a creator with multiple AI video/audio/image jobs running, I want to monitor all generation progress in one place, download completed outputs, retry failures, and push finished assets to publish — without leaving the queue.

### Business Goals
- Reduce creator anxiety during long AI generations by providing real-time visibility
- Drive completed assets into the publish pipeline (Queue → Packaging QA → Publish)
- Enable self-service retry on failures to reduce support tickets
- Surface credit usage transparency per job

### When This Screen Is Used
- **During generation**: Creator submits a job in any Studio mode → redirected here to track
- **Periodic check**: Creator has multiple jobs running, returns to check status
- **Post-generation**: Review completed outputs, download or push to publish
- **Error recovery**: Check why a job failed, retry or view error details

### Entry Points
- Any Studio mode (Quick Edit, Clip Factory, Multi-Merge, AI Remix, etc.) after "🚀 Apply/Generate"
- Sidebar: "📋 Queue" (under AI Studio)
- Direct URL: `/studio/queue`
- Push notification: "Your video is ready!" → deep link to queue
- Home Dashboard: Pipeline widget → "🎬 Producing (2)" chip

### Exit Points
- "👁 Preview" → opens asset preview player (modal)
- "📤 Publish" → `/packaging/[asset_id]` (Packaging QA)
- "📥 Download" → direct file download
- "🔄 Redo" → respective Studio mode with same params
- Click Studio mode link → `/studio/[mode]`

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- User has `asset:read` permission minimum
- At least one generation job exists (or empty state shown)

### Postconditions
- Cancel/Retry actions persisted to `generation_jobs` table
- Credit refunds processed for cancelled jobs via `credit_ledger`
- Analytics events dispatched for all user interactions
- Desktop notifications triggered on job completion (if permission granted)

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell (sidebar 240px) + Main Content (single column, job card list) |
| Tablet (768-1279px) | App Shell (collapsed sidebar) + Main Content |
| Mobile (≤767px) | Redirect to M022 Mobile Generation Queue |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   📋 Generation Queue                    Credits: 320/1000│
├──────────────────────────────────────────────────────────────────────┤
│ Filter: [All modes ▾] [Status ▾]     Sort: [Newest first ▾] 🔍     │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Summary Bar ──────────────────────────────────────────────────┐  │
│ │ 🔄 Active: 3  ·  ✅ Completed: 12 today  ·  ❌ Failed: 1     │  │
│ │ Credits used today: 145  ·  Avg completion: 3m 22s             │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ── 🔄 Active (3) ──────────────────────────────────────────────────  │
│ ┌─ Job Card ──────────────────────────────────────────────────────┐ │
│ │ 🎬 Video Agent: "Serum review"           ████████░░ 75%        │ │
│ │ Stage: Generating visuals (Scene 4/5) · Est: ~1 min            │ │
│ │ Credits: 50 · Started: 5 min ago                                │ │
│ │ [⏸ Pause] [❌ Cancel]                                          │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Job Card ──────────────────────────────────────────────────────┐ │
│ │ 🎵 Sound Studio: "Background music"     ██████░░░░ 55%        │ │
│ │ Stage: Music generation · Est: ~2 min                           │ │
│ │ Credits: 8 · Started: 3 min ago                                 │ │
│ │ [⏸ Pause] [❌ Cancel]                                          │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Job Card ──────────────────────────────────────────────────────┐ │
│ │ ✂️ Quick Edit: "Tutorial P2"             ███░░░░░░░ 25%        │ │
│ │ Stage: Transcribing audio · Est: ~4 min                         │ │
│ │ Credits: 25 · Started: 1 min ago                                │ │
│ │ [⏸ Pause] [❌ Cancel]                                          │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ── ✅ Completed Today (12) ──────────────────────────────────────── │
│ ┌─ Job Card (completed) ──────────────────────────────────────────┐ │
│ │ ✂️ Quick Edit: "5 tips nấu ăn"          ✅ Complete             │ │
│ │ Credits: 25 · Duration: 3m 22s · 2h ago                        │ │
│ │ Output: 720p · 45s · 14.2MB                                     │ │
│ │ [👁 Preview] [📥 Download] [📤 Send to Publish] [🔄 Redo]     │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│ ... (more completed items, paginated)                                │
│                                                                      │
│ ── ❌ Failed (1) ──────────────────────────────────────────────────  │
│ ┌─ Job Card (failed) ────────────────────────────────────────────┐  │
│ │ 🔄 AI Remix: "Trend #456"              ❌ Failed               │  │
│ │ Error: "Reference video unavailable — source URL returned 404"  │  │
│ │ Credits: 15 → ✅ Refunded · 4h ago                              │  │
│ │ [🔄 Retry] [📋 Copy Error] [🗑 Remove]                         │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [📜 Xem lịch sử 7 ngày qua ↓]                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
GenerationQueuePage
├── AppShell (shared)
│   ├── Sidebar
│   └── TopBar (credits balance in header)
├── PageHeader
│   ├── BackLink ("← Studio")
│   ├── Title ("📋 Generation Queue")
│   └── CreditBalance (remaining/total)
├── FilterBar
│   ├── ModeFilter (All, Quick Edit, Clip Factory, Multi-Merge, AI Remix, Sound, Thumbnail, etc.)
│   ├── StatusFilter (All, Active, Completed, Failed)
│   ├── SortSelector (Newest first, Oldest first, Credits high→low)
│   └── SearchInput (search by job name)
├── SummaryBar
│   ├── ActiveCount (🔄 with count)
│   ├── CompletedCount (✅ with today count)
│   ├── FailedCount (❌ with count)
│   ├── CreditsUsedToday
│   └── AvgCompletionTime
├── ActiveSection
│   ├── SectionHeader ("🔄 Active" + count)
│   └── ActiveJobCard[] (sorted by start_time ASC)
│       ├── ModeIcon + ModeName
│       ├── JobTitle (from content title or auto-generated)
│       ├── ProgressBar (animated, % with live updates via SSE)
│       ├── StageLabel ("Generating visuals", "Transcribing", etc.)
│       ├── EstimatedTime ("~1 min remaining")
│       ├── CreditCost
│       ├── StartedAgo (relative time)
│       ├── PauseButton (⏸)
│       └── CancelButton (❌ → confirmation modal)
├── CompletedSection
│   ├── SectionHeader ("✅ Completed Today" + count)
│   └── CompletedJobCard[] (sorted by completed_at DESC)
│       ├── ModeIcon + ModeName
│       ├── JobTitle
│       ├── SuccessBadge (✅ Complete)
│       ├── CreditCost
│       ├── Duration ("3m 22s")
│       ├── CompletedAgo (relative time)
│       ├── OutputMeta (resolution, duration, file size)
│       ├── PreviewButton (👁 → opens modal player)
│       ├── DownloadButton (📥)
│       ├── PublishButton (📤 Send to Publish → navigate)
│       └── RedoButton (🔄 → reopens studio mode with same params)
├── FailedSection
│   ├── SectionHeader ("❌ Failed" + count)
│   └── FailedJobCard[] (sorted by failed_at DESC)
│       ├── ModeIcon + ModeName
│       ├── JobTitle
│       ├── FailBadge (❌ Failed)
│       ├── ErrorMessage (human-readable error)
│       ├── CreditRefundStatus ("✅ Refunded" or "⏳ Refunding")
│       ├── FailedAgo (relative time)
│       ├── RetryButton (🔄)
│       ├── CopyErrorButton (📋 → clipboard)
│       └── RemoveButton (🗑 → hides from list)
├── HistoryLink ("📜 Xem lịch sử 7 ngày qua")
└── PreviewModal (when 👁 Preview clicked)
    ├── VideoPlayer / AudioPlayer / ImageViewer (based on output type)
    ├── OutputMetadata (resolution, format, duration, file size)
    ├── DownloadButton
    └── CloseButton
```

---

## 5. Displayed Data / Data Binding

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Active job list | `generation_jobs WHERE status='processing'` | `QueueService/ListActive` | Job cards with live progress | Real-time SSE |
| Completed jobs | `generation_jobs WHERE status='completed' AND date=today` | `QueueService/ListCompleted(date)` | Completed cards with output links | 2m TTL |
| Failed jobs | `generation_jobs WHERE status='failed'` | `QueueService/ListFailed` | Error cards with retry | 2m TTL |
| Job progress % | SSE stream per job | SSE `/events/queue/{job_id}` | Animated progress bar | Real-time |
| Stage label | `generation_jobs.current_stage` | Via SSE | Text ("Generating visuals Scene 4/5") | Real-time |
| ETA | `generation_jobs.estimated_remaining_ms` | Via SSE | "~1 min" / "~30 giây" | Real-time |
| Credit cost | `generation_jobs.credit_cost` | `QueueService/List*` | Integer "50 credits" | Static per job |
| Credit refund status | `credit_ledger WHERE ref=job_id AND type='refund'` | `QueueService/ListFailed` | "✅ Refunded" / "⏳ Processing" | 30s TTL |
| Output metadata | `assets WHERE generation_job_id=job_id` | `QueueService/ListCompleted` | "720p · 45s · 14.2MB" | Static |
| Summary counts | Aggregated from above | `QueueService/GetSummary` | Integers | 30s TTL |
| Credits balance | `credit_ledger.balance` | `CreditService/GetBalance` | "320/1000" | Real-time SSE |

---

## 6. User Actions

| # | Action | Trigger | API Call | System Response | Permission |
|---|---|---|---|---|---|
| 1 | Pause active job | Click "⏸ Pause" | `QueueService/Pause(job_id)` | Job paused, progress bar stops, button changes to "▶ Resume" | `asset:generate` |
| 2 | Resume paused job | Click "▶ Resume" | `QueueService/Resume(job_id)` | Job resumes, progress continues | `asset:generate` |
| 3 | Cancel active job | Click "❌ Cancel" → confirm modal | `QueueService/Cancel(job_id)` | Job cancelled → credits refunded → card moves to Failed section | `asset:generate` |
| 4 | Preview completed output | Click "👁 Preview" | Client-side | Preview modal opens with video/audio/image player | `asset:read` |
| 5 | Download output | Click "📥 Download" | `AssetService/GetDownloadURL(asset_id)` | Browser download triggered (signed URL, 1h expiry) | `asset:read` |
| 6 | Send to publish | Click "📤 Send to Publish" | — | Navigate → `/packaging/[asset_id]` (Packaging QA) | `publish:create` |
| 7 | Redo job | Click "🔄 Redo" | — | Navigate → `/studio/[mode]?redo=job_id` (same params pre-filled) | `asset:generate` |
| 8 | Retry failed job | Click "🔄 Retry" → confirm | `QueueService/Retry(job_id)` | New job created with same params, card moves to Active | `asset:generate` |
| 9 | Copy error message | Click "📋 Copy Error" | Client-side clipboard | Toast: "Đã sao chép lỗi" | Any |
| 10 | Remove failed job | Click "🗑 Remove" → confirm | `QueueService/Hide(job_id)` | Card removed from view (soft-hide, still in DB) | `asset:generate` |
| 11 | Filter by mode | Change mode filter dropdown | Client-side + refetch | List filters to selected mode | `asset:read` |
| 12 | Filter by status | Change status filter | Client-side + refetch | List filters to selected status | `asset:read` |
| 13 | View history | Click "📜 Xem lịch sử 7 ngày qua" | `QueueService/ListHistory(days=7)` | Expand with older completed/failed jobs | `asset:read` |

---

## 7. States / State Machine

```
┌─────────────┐
│   LOADING   │ ← Initial page load
└──────┬──────┘
       │ API + SSE connected
       ▼
┌─────────────┐
│   LOADED    │ ← Normal state with active/completed/failed sections
└──────┬──────┘
       ├── Active section empty → show "Không có job đang chạy"
       ├── All sections empty → EMPTY state
       ├── API fails → ERROR state
       └── SSE disconnects → DEGRADED (polling fallback)

┌─────────────┐
│    EMPTY    │ ← No jobs at all: "Chưa có job nào. Bắt đầu tạo nội dung AI!"
│             │   [→ Mở AI Studio] [→ Xem lịch sử]
└─────────────┘

┌─────────────┐
│   DEGRADED  │ ← SSE disconnected, progress bars show "Đang kết nối lại..."
│             │   Polling every 5s as fallback
└─────────────┘

┌─────────────┐
│    ERROR    │ ← API failed completely: "Không tải được queue. [Thử lại]"
└─────────────┘
```

| State | Visual | User Action |
|---|---|---|
| LOADING | App Shell visible, 3 job card skeletons (shimmer) in Active section | Wait |
| LOADED | Full queue with sections. Active cards have animated progress bars. | Normal interactions |
| EMPTY | Illustration + "Chưa có job nào. Bắt đầu tạo nội dung AI!" + [Mở AI Studio] | Navigate to Studio |
| DEGRADED | Yellow banner: "🔄 Kết nối real-time bị gián đoạn. Tự động thử lại..." Progress bars show last-known %. | Auto-reconnect or manual refresh |
| ERROR | Full-page error: "Không tải được generation queue. [Thử lại]" | Retry |
| CANCELLING | Job card shows spinner overlay: "Đang hủy..." | Wait |
| RETRYING | New job card appears in Active with "🔄 Retrying..." label | Wait |

---

## 8. Validation Rules

N/A — This is a monitoring/action screen. No form inputs. Cancel and Retry actions require confirmation modals:
- **Cancel confirmation**: "Hủy job "{job_title}"? Credits đã dùng sẽ được hoàn lại." [Hủy job] [Quay lại]
- **Retry confirmation**: "Thử lại job "{job_title}"? Sẽ tốn {credit_cost} credits." [Thử lại] [Quay lại]

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View queue | ✅ | ✅ | ✅ | ✅ | ✅ (own jobs) | ✅ (read) | ❌ |
| Pause/Resume job | ✅ | ✅ | ✅ | ✅ | ⚠️ own only | ❌ | ❌ |
| Cancel job | ✅ | ✅ | ✅ | ✅ | ⚠️ own only | ❌ | ❌ |
| Preview output | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ✅ | ❌ |
| Download output | ✅ | ✅ | ✅ | ✅ | ⚠️ own only | ❌ | ❌ |
| Send to publish | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Retry failed job | ✅ | ✅ | ✅ | ✅ | ⚠️ own + credit check | ❌ | ❌ |
| Remove failed job | ✅ | ✅ | ✅ | ✅ | ⚠️ own only | ❌ | ❌ |
| View history | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ✅ | ❌ |

### Contributor Constraints
- Only sees own jobs (filtered by `created_by = user_id`)
- Retry requires sufficient credit balance (checked before confirmation)

---

## 10. Navigation Map

```
Generation Queue (/studio/queue)
├── → /studio                         (← Studio back link)
├── → /studio/quick-edit?redo={id}    (via Redo on Quick Edit job)
├── → /studio/clip-factory?redo={id}  (via Redo on Clip Factory job)
├── → /studio/remix?redo={id}         (via Redo on AI Remix job)
├── → /studio/[mode]?redo={id}        (via Redo on any mode)
├── → /packaging/[asset_id]           (via "📤 Send to Publish")
├── → Preview Modal                    (via "👁 Preview" — inline)
└── ← /studio/[mode]                  (entry from any studio mode)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network error (full) | No internet / server down | Full page: "Không tải được generation queue. [Thử lại]" | Retry button → reload |
| SSE connection lost | WebSocket/SSE drops | Yellow banner: "🔄 Đang kết nối lại..." + fallback polling every 5s | Auto-reconnect with exponential backoff (1s, 2s, 4s, max 30s) |
| Cancel fails | 5xx on cancel API | Toast: "Không hủy được. Thử lại sau." Job card keeps original state. | Manual retry |
| Retry fails (insufficient credits) | Credit check fails | Toast: "Không đủ credits ({needed} cần, {balance} còn). [Nạp thêm →]" | Navigate to credit purchase |
| Retry fails (server error) | 5xx on retry | Toast: "Không thể thử lại. [Thử lại sau]" | Wait + retry |
| Download URL expired | Signed URL 1h expiry | Toast: "Link đã hết hạn. [Tạo link mới]" | Refresh download URL |
| Job stuck (no progress > 10min) | SSE shows same % for > 10 minutes | Job card yellow border: "⚠️ Job có thể bị stuck. [Hủy và thử lại]" | Cancel + retry or contact support |
| Auth expired | 401 on any API | Redirect to `/auth/login` | Re-authenticate via Clerk |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Progress bar | `role="progressbar"`, `aria-valuenow`, `aria-valuemin="0"`, `aria-valuemax="100"`, `aria-label="Tiến trình: 75%"` |
| Job cards | `role="article"`, `aria-label="Job: Video Agent - Serum review, 75% hoàn thành"` |
| Status sections | `role="region"`, `aria-label="Jobs đang chạy: 3"` |
| Cancel/Retry buttons | Clear `aria-label` including job name: "Hủy job Serum review" |
| Real-time updates | `aria-live="polite"` on progress area, `aria-live="assertive"` on completion notification |
| Keyboard navigation | Tab: Summary → Active jobs → Completed → Failed. Space/Enter on buttons. |
| Color contrast | All text meets WCAG 2.1 AA (4.5:1). Status colors (🟢/🟡/🔴) always paired with text labels. |
| Reduced motion | `prefers-reduced-motion: reduce` → disable progress bar animation, use text "75%" instead |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell render | 0ms | App Shell renders immediately (SSR). Header with credits visible. |
| Skeleton phase | 0-300ms | 3 job card skeletons with shimmer. Summary bar shows "—" placeholders. |
| Active jobs load | 100-500ms | Active job cards appear with progress bars starting from last-known state |
| SSE connects | 200-800ms | Progress bars begin live updates. Green dot appears in header. |
| Completed/Failed | 300-800ms | Below-fold sections populate |
| Desktop notification permission | 1000ms (first visit) | Browser permission prompt: "Nhận thông báo khi job hoàn thành?" |

---

## 14. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| LCP | < 1.5s | First active job card or summary bar |
| FID | < 100ms | First click on any button |
| CLS | < 0.05 | No layout shift when jobs complete and move sections |
| TTI | < 2.0s | All buttons interactive |
| SSE latency | < 500ms | Progress updates from server to UI |
| Progress animation | 60fps | Smooth progress bar updates |
| Max concurrent SSE streams | 10 | One per active job |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Job progress % | SSE `/events/queue` | Real-time (every 2-5s per job, debounced) |
| Job stage change | SSE `/events/queue` | Real-time (on stage transition) |
| Job completion | SSE `/events/queue` | Real-time → triggers desktop notification + sound |
| Job failure | SSE `/events/queue` | Real-time → triggers error toast |
| Credit balance | SSE `/events/credits` | Real-time (updates header on deduction/refund) |
| New job from team member | SSE `/events/queue` | Real-time (if Manager+ sees team jobs) |

### Real-time UX
- **Progress update**: Bar smoothly animates to new % (CSS transition 500ms)
- **Job completes**: Card slides down to Completed section with green flash. Desktop notification: "✅ {job_title} hoàn thành!" Active count badge decrements.
- **Job fails**: Card slides to Failed section with red flash. Toast: "❌ {job_title} thất bại."
- **Desktop notification**: Only if user granted permission. Click → focuses browser tab + scrolls to completed job.

---

## 16. Localization Notes

- Primary language: Vietnamese
- Duration: "3 phút 22 giây" (long) / "3m 22s" (compact on cards)
- Relative time: "5 phút trước", "2 giờ trước"
- File size: "14,2 MB" (comma for decimals in Vietnamese)
- Credits: "50 credits" (no VND — credits are universal unit)
- ETA: "~1 phút", "~30 giây", "< 1 phút"
- Date: DD/MM/YYYY
- Numbers: dot separator for thousands (1.234)
- Tone: Technical but friendly — "Job hoàn thành" not "Generation complete"

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `queue.viewed` | Page load | `active_count`, `completed_today_count`, `failed_count` |
| `queue.job.paused` | Pause button clicked | `job_id`, `mode`, `progress_at_pause` |
| `queue.job.resumed` | Resume button clicked | `job_id`, `mode`, `paused_duration_ms` |
| `queue.job.cancelled` | Cancel confirmed | `job_id`, `mode`, `progress_at_cancel`, `credits_refunded` |
| `queue.job.previewed` | Preview button clicked | `job_id`, `mode`, `output_type` |
| `queue.job.downloaded` | Download button clicked | `job_id`, `mode`, `file_size_bytes` |
| `queue.job.sent_to_publish` | "Send to Publish" clicked | `job_id`, `mode`, `asset_id` |
| `queue.job.redo` | Redo button clicked | `job_id`, `mode`, `destination_mode` |
| `queue.job.retried` | Retry confirmed | `job_id`, `mode`, `credit_cost`, `retry_count` |
| `queue.job.removed` | Remove confirmed | `job_id`, `mode`, `error_type` |
| `queue.job.completed` | Job finishes (passive) | `job_id`, `mode`, `duration_ms`, `credit_cost` |
| `queue.filter.changed` | Filter/sort changed | `filter_mode`, `filter_status`, `sort_by` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | "Send to Publish" CTA, active progress bar fill |
| `--color-success` | ✅ Completed badge, refund status, completion flash |
| `--color-warning` | ⏳ Queued status, stuck job border, SSE reconnecting |
| `--color-danger` | ❌ Failed badge, cancel button, error messages |
| `--color-surface-primary` | Page background |
| `--color-surface-elevated` | Job cards, summary bar |
| `--color-text-primary` | Job titles, progress text |
| `--color-text-secondary` | Timestamps, credit costs, stage labels |
| `--color-progress-track` | Progress bar background (unfilled portion) |
| `--color-progress-fill` | Progress bar active fill (animated) |
| `--font-metric` | Credit numbers, progress %, duration (tabular-nums) |
| `--spacing-card` | Card inner padding (16px) |
| `--radius-card` | Card border-radius (12px) |
| `--shadow-card` | Card elevation shadow |
| `--shadow-card-active` | Elevated shadow on active job cards (higher prominence) |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/studio/queue/+page.svelte`
- **Server load**: `+page.server.ts` → fetch initial job lists (active, completed today, failed)
- **SSR**: Shell + summary bar SSR; job cards hydrated client-side
- **Store**: `queueStore` (writable) with sections: `{active: [], completed: [], failed: []}`

### Data Fetching Strategy
```
+page.server.ts:
  Promise.all([
    queueService.listActive(),
    queueService.listCompleted({ date: 'today' }),
    queueService.listFailed(),
    queueService.getSummary()
  ])
```

### SSE Setup
```
+page.svelte onMount:
  const sse = setupSSE('/events/queue', (event) => {
    switch(event.type) {
      case 'progress': updateJobProgress(event.job_id, event.percent, event.stage)
      case 'completed': moveJobToCompleted(event.job_id, event.asset)
      case 'failed': moveJobToFailed(event.job_id, event.error)
    }
  })

  // Desktop notification on completion
  if (Notification.permission === 'granted') {
    onJobComplete((job) => new Notification(`✅ ${job.title} hoàn thành!`))
  }
```

### Optimistic Updates
- Cancel: Immediately grey out job card → API call → on success move to Failed section → on failure revert
- Retry: Immediately add stub card to Active → API creates job → SSE provides real job data

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W021] AI Studio Launcher | Parent navigation |
| [W022] Quick Edit | Source of generation jobs |
| [W023] Clip Factory | Source of generation jobs |
| [W024] Product Showcase | Source of generation jobs |
| [W025] AI Remix | Source of generation jobs |
| [W026] Thumbnail Generator | Source of generation jobs |
| [W028] Sound Manager | Source of generation jobs |
| [W031] Full Video Agent | Source of generation jobs (highest credit cost) |
| [W056] Packaging QA | Downstream: "Send to Publish" |
| [M022] Mobile Generation Queue | Mobile equivalent |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite**: Upgraded from 190-line Tier C with generic boilerplate to 420+ line full spec. Added: complete component hierarchy with actual Svelte components, screen-specific data binding with real API endpoints, 7-role RBAC permission matrix (B5 §2.4), 8 screen-specific error cases (SSE drops, stuck jobs, credit insufficiency), 12 analytics events, SSE real-time specification, performance targets, complete navigation map, accessibility with progress bar ARIA. Removed: all generic boilerplate templates. Standardized Screen ID from W38 to W030. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |

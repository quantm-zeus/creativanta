# Screen: Web — AI Studio Launcher

> **Screen ID**: W24
> **Module**: M06 — AI Studio
> **Route**: `/studio`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §14-§17, A1 Schema (generation_jobs, assets)

---

## 1. Purpose & Context

The AI Studio Launcher is the gateway to all AI-powered content generation tools. It presents production modes as cards — each mode opens a specialized tool (Video, Image, Remix, Avatar, Voiceover, Music, Subtitle, Thumbnail, B-Roll, Text-to-Video, Image-to-Video). Also shows recent generations and active jobs.

### User Story
> As a creator, I want a centralized studio where I can access all AI generation tools and track my ongoing generations.

### Entry Points
- Sidebar: "🎬 AI Studio" under Content
- Bottom nav (mobile): 🎬 tab
- Quick Action from Home: "📝 Viết script" or direct
- Direct URL: `/studio`

### Exit Points
- Click mode card → respective studio page
- Click generation job → job detail

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🎬 AI Studio                [🔍 Search assets] [📜 History]         │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Active Jobs Banner ───────────────────────────────────────────┐  │
│ │ 🟡 2 jobs đang xử lý                                          │  │
│ │ 🎬 Video "Skincare tips" — 78% ████████░░ · ~2min remaining   │  │
│ │ 🖼 Image "Product shot" — 45% █████░░░░░ · ~5min remaining    │  │
│ │ [→ Xem tất cả jobs]                                            │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Production Modes (3-column grid) ─────────────────────────────┐  │
│ │                                                                  │  │
│ │ ┌─ Mode Card ──┐  ┌─ Mode Card ──┐  ┌─ Mode Card ──┐         │  │
│ │ │ 🎬           │  │ 🖼           │  │ 🔄           │         │  │
│ │ │ AI Video     │  │ AI Image     │  │ Video Remix  │         │  │
│ │ │ Tạo video từ │  │ Tạo hình ảnh │  │ Remix video  │         │  │
│ │ │ script/prompt│  │ cho content   │  │ có sẵn       │         │  │
│ │ │ [2 credits]  │  │ [1 credit]   │  │ [3 credits]  │         │  │
│ │ └──────────────┘  └──────────────┘  └──────────────┘         │  │
│ │                                                                  │  │
│ │ ┌─ Mode Card ──┐  ┌─ Mode Card ──┐  ┌─ Mode Card ──┐         │  │
│ │ │ 👤           │  │ 🎙           │  │ 🎵           │         │  │
│ │ │ AI Avatar    │  │ AI Voiceover │  │ AI Music     │         │  │
│ │ │ Tạo avatar   │  │ Giọng đọc AI │  │ Nhạc nền AI  │         │  │
│ │ │ [2 credits]  │  │ [1 credit]   │  │ [1 credit]   │         │  │
│ │ └──────────────┘  └──────────────┘  └──────────────┘         │  │
│ │                                                                  │  │
│ │ ┌─ Mode Card ──┐  ┌─ Mode Card ──┐  ┌─ Mode Card ──┐         │  │
│ │ │ 💬           │  │ 🖼           │  │ 🎞           │         │  │
│ │ │ AI Subtitle  │  │ AI Thumbnail │  │ AI B-Roll    │         │  │
│ │ │ Phụ đề tự    │  │ Thumbnail    │  │ B-Roll tự    │         │  │
│ │ │ động         │  │ thu hút      │  │ động         │         │  │
│ │ │ [1 credit]   │  │ [1 credit]   │  │ [2 credits]  │         │  │
│ │ └──────────────┘  └──────────────┘  └──────────────┘         │  │
│ │                                                                  │  │
│ │ ┌─ Mode Card ──┐  ┌─ Mode Card ──┐  ┌─ Mode Card ──┐         │  │
│ │ │ 📝→🎬       │  │ 🖼→🎬       │  │ 📦           │         │  │
│ │ │ Text→Video   │  │ Image→Video  │  │ Batch Gen    │         │  │
│ │ │ Từ text sang │  │ Từ ảnh sang  │  │ Tạo hàng     │         │  │
│ │ │ video        │  │ video        │  │ loạt         │         │  │
│ │ │ [3 credits]  │  │ [2 credits]  │  │ [varies]     │         │  │
│ │ └──────────────┘  └──────────────┘  └──────────────┘         │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Recent Generations ───────────────────────────────────────────┐  │
│ │ ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐             │  │
│ │ │[🖼  ]│  │[🎬  ]│  │[🖼  ]│  │[🎙  ]│  │[🖼  ]│             │  │
│ │ │thumb │  │thumb │  │thumb │  │wave  │  │thumb │             │  │
│ │ │2h ago│  │1d ago│  │1d ago│  │2d ago│  │3d ago│             │  │
│ │ └──────┘  └──────┘  └──────┘  └──────┘  └──────┘             │  │
│ │ [→ Xem tất cả →]                                               │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ AI Credits: 12/100 remaining · [→ Nạp thêm]                         │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
AIStudioLauncherPage
├── AppShell (shared)
├── PageHeader
│   ├── Title
│   ├── SearchButton
│   └── HistoryLink
├── ActiveJobsBanner (conditional)
│   └── JobProgressItem[]
│       ├── JobTypeIcon
│       ├── JobTitle
│       ├── ProgressBar + Percentage
│       ├── TimeRemaining
│       └── ViewAllLink
├── ProductionModeGrid (3-column)
│   └── ModeCard[] (12 cards)
│       ├── ModeIcon (large emoji/icon)
│       ├── ModeName
│       ├── ModeDescription (1-line)
│       ├── CreditCost
│       └── ClickArea (full card)
├── RecentGenerationsSection
│   ├── SectionHeader
│   ├── ThumbnailScroller (horizontal)
│   │   └── GenerationThumb[]
│   │       ├── Thumbnail/Preview
│   │       ├── TypeIcon
│   │       └── TimeAgo
│   └── ViewAllLink
└── CreditFooter
    ├── CreditBalance
    └── TopUpLink
```

---

## 4-5. Data & Actions

| UI Element | Source | API |
|---|---|---|
| Active jobs | `generation_jobs WHERE status=processing` | `GenerationService/ListActive` |
| Recent generations | `assets ORDER BY created_at DESC LIMIT 10` | `AssetService/ListRecent(10)` |
| Credit balance | `credit_transactions` | `CreditService/GetBalance` |
| Mode cards | Static config | Client-side |

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Open mode | Click mode card | — | Navigate → `/studio/[mode]` | `asset:generate` |
| 2 | View job | Click active job | — | → `/studio/history/[job_id]` | `asset:read` |
| 3 | View recent | Click thumbnail | — | → Asset detail or preview modal | `asset:read` |
| 4 | View history | "📜 History" | — | → `/studio/history` | `asset:read` |
| 5 | Top up | "Nạp thêm" | — | → `/settings/billing/credits` | `credits:top_up` |
| 6 | Search assets | "🔍 Search" | — | → `/assets?source=studio` | `asset:read` |

---

## 6-20. Standard Sections

### States
| State | Visual |
|---|---|
| LOADING | Mode card skeletons + banner skeleton |
| LOADED | Full launcher with mode cards |
| NO_ACTIVE_JOBS | Banner hidden |
| INSUFFICIENT_CREDITS | Mode cards show "Hết credit" overlay, top-up CTA prominent |

### Permission Matrix
- All roles with `asset:generate` can access modes
- Credit check happens at mode entry, not launcher
- Viewer role: can browse but not generate

### Performance
- Static page (mode cards are client-side config)
- Active jobs: polled every 10s
- Recent generations: 5m cache

### Technical Notes
- Route: `src/routes/(app)/studio/+page.svelte`
- Mode config: constant array with icon, name, description, route, credit_cost
- Active jobs: polling with `setInterval` or SSE

### Related Screens
| Screen | Relationship |
|---|---|
| [W25-W38] Individual AI modes | Children |
| [W39] Generation History | History view |
| [M21] Mobile Studio Launcher | Mobile equivalent |

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-27 | 1.0 | Initial specification |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + mode cards still visible | Retry online |
| Jobs poll fail | SSE/polling error | Active jobs banner: "⚠️ Không cập nhật được" | Auto-retry 10s |
| Credit fetch fail | API error | Footer: "Credits: --" | Retry |
| Recent load fail | API error | Section hidden gracefully | N/A |
| Job cancelled | Background cancel | Toast: "{job_name} đã bị hủy" | N/A |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Mode cards grid | `role="list"`, each card `role="listitem"` with `aria-label="{mode}: {description}, {credits} credits"` |
| Active jobs | `role="status"`, `aria-live="polite"`, progress with `aria-valuenow` |
| Credit footer | `role="status"`, `aria-label="{n} AI credits remaining"` |
| Recent thumbnails | `role="list"`, each with `aria-label="{type}, created {time_ago}"` |
| Search button | `aria-label="Search generated assets"` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Mode card grid (static, instant) |
| Active jobs | 200-500ms | Banner populates |
| Recent generations | 300-600ms | Thumbnail scroller loads |
| Credit balance | 100-300ms | Footer updates |
| Job progress | Real-time | Polls every 10s or SSE |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `studio.launcher_viewed` | Page load | `credit_balance`, `active_jobs` |
| `studio.mode_clicked` | Click mode card | `mode`, `credit_cost` |
| `studio.job_viewed` | Click active job | `job_id`, `status` |
| `studio.recent_clicked` | Click recent thumbnail | `asset_id`, `type` |
| `studio.history_opened` | "📜 History" | — |
| `studio.topup_clicked` | "Nạp thêm" | `current_balance` |
| `studio.search_opened` | "🔍 Search" | — |
| `studio.insufficient_credits` | Mode click with 0 credits | `mode`, `required` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/studio/+page.svelte`
- **Mode cards**: Static client-side config array — no API call
- **Active jobs**: SSE from `GenerationService/StreamActiveJobs` or polling every 10s
- **Recent**: `AssetService/ListRecent(10)` with 5m cache
- **Credits**: `CreditService/GetBalance` — refreshes on page focus
- **Insufficient credits**: Overlay on card with "Hết credit" + link to top-up

---

## 12. Localization Notes

- Title: "AI Studio"
- Cards: Vietnamese descriptions (e.g., "Tạo video từ script/prompt")
- Jobs: "đang xử lý", "~{n} phút còn lại"
- Credits: "{n} credits còn lại · [→ Nạp thêm]"
- Tone: Creative, inviting

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Mode card hover, top-up CTA |
| `--color-job-processing` | 🟡 Active job progress bar |
| `--color-credit-low` | Credit balance <10 warning |
| `--color-surface-elevated` | Mode cards |
| `--color-ai` | AI Studio branding |
| `--radius-card` | Mode card corners |
| `--font-metric` | Credit count (tabular-nums) |
| `--color-border` | Card borders |

---

## 14. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (jobs poll, credits), grid/job a11y, 8 analytics, SvelteKit impl (SSE jobs, credits), localization, 8 design tokens. | System |
| 2026-03-27 | 1.0 | Initial specification | System |

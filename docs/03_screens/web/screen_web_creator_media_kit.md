# Screen: Web — Media Kit Editor

> **Screen ID**: W089
> **Module**: S16 — Creator Pro Tools
> **Route**: `/creator-pro/media-kit`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 05, A1 Schema (creator_profiles, media_kits, portfolio_items), B5 RBAC §2.7

---

## 1. Purpose & Context

Build and share a professional media kit — auto-synced statistics from connected platforms, audience demographics, curated portfolio, customizable rate card, and shareable public link with PDF download.

### User Goals
- Build a professional media kit for brand pitches
- Auto-sync stats (no manual updating)
- Curate best content in drag-sortable portfolio
- Share via link, email, or PDF to potential sponsors

### Entry Points
- Sidebar: Creator Pro → "📋 Media Kit"
- Creator Pro Dashboard (W088): "📋 Media Kit" button

### Exit Points
- "👁 Preview" → live preview at `creativanta.vn/k/{handle}`
- "📤 Share" → copy link / email
- "📥 Download PDF" → client-side PDF generation

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Creator Pro   📋 Media Kit Editor      [👁 Preview] [📤 Share]  │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Profile Header ─────────────────────────────────────────────┐    │
│ │ [📷 Upload photo] [Edit name: Quân Nguyễn]                   │    │
│ │ Tagline: [Content creator chuyên ẩm thực & lifestyle]        │    │
│ │ Based in: [Hồ Chí Minh, Việt Nam]                             │    │
│ │ Categories: [🏷 Cooking] [🏷 Lifestyle] [+ Add]              │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Statistics (auto-synced) ───────────────────────────────────┐    │
│ │ Platform      │ Followers │ Engagement │ Reach/mo │ Updated  │    │
│ │ 🎵 TikTok    │ 50,000    │ 6.2%       │ 1.2M     │ 1h ago  │    │
│ │ 📸 Instagram │ 25,000    │ 4.1%       │ 450K     │ 2h ago  │    │
│ │ ▶️ YouTube   │ 12,000    │ 5.8%       │ 280K     │ 6h ago  │    │
│ │                                                                │    │
│ │ Totals: 87K followers · 5.4% avg engagement · 1.9M reach/mo │    │
│ │ [🔄 Refresh stats] · Next auto-sync: 1h                      │    │
│ │                                                                │    │
│ │ Toggle visibility: [☑ TikTok] [☑ Instagram] [☐ YouTube]     │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Audience Demographics ──────────────────────────────────────┐    │
│ │ Age: 18-24 (45%) · 25-34 (32%) · 35+ (23%)                   │    │
│ │ Gender: Female 62% · Male 35% · Other 3%                      │    │
│ │ Top cities: HCMC (30%) · Hà Nội (22%) · Đà Nẵng (10%)       │    │
│ │ [Bar charts — auto-generated from platform data]              │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Best Content (drag-sort portfolio) ─────────────────────────┐    │
│ │ [🎬 Thumb1] 24K views · [🎬 Thumb2] 18K · [🎬 Thumb3] 15K  │    │
│ │ [📸 Thumb4] 12K · [📸 Thumb5] 10K                           │    │
│ │ ← drag to reorder →                                           │    │
│ │ [+ Add content from library]                                   │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Rate Card ──────────────────────────────────────────────────┐    │
│ │ Deliverable           │ Price       │ Visible │               │    │
│ │ TikTok video (60s)    │ 2,000,000đ  │ [☑]    │ [✏]           │    │
│ │ Instagram Reel        │ 1,500,000đ  │ [☑]    │ [✏]           │    │
│ │ YouTube integration   │ 5,000,000đ  │ [☑]    │ [✏]           │    │
│ │ Story mentions (3×)   │ 500,000đ    │ [☐]    │ [✏]           │    │
│ │ [+ Add pricing item]                                          │    │
│ │ Note: Prices shown are starting rates. Custom packages        │    │
│ │ available upon request.                                        │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Share & Export ─────────────────────────────────────────────┐    │
│ │ Public link: https://creativanta.vn/k/nguyenquan              │    │
│ │ [📋 Copy link] [📧 Email to brand] [📥 Download PDF]        │    │
│ │ Privacy: [● Public] [○ Link-only] [○ Password-protected]    │    │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Section skeletons |
| LOADED | Data ready | Editable media kit |
| EMPTY_KIT | No content yet | "Bắt đầu tạo Media Kit. Thêm portfolio và rate card." |
| SYNCING | Refreshing stats | Spin icon on stats section |
| SAVING | Auto-save | "Saving..." indicator |
| GENERATING_PDF | PDF export | "📥 Đang tạo PDF..." spinner |
| ERROR | API failed | Error with retry |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached kit data | Retry online |
| Stats sync fail | Platform API error | Section: "⚠️ {platform} sync failed. [🔄 Thử lại]" + stale data shown | Retry |
| PDF generation fail | Client-side error | Toast: "Không tạo được PDF. [Thử lại]" | Retry |
| Photo upload fail | File >5MB or wrong format | Inline: "Ảnh phải nhỏ hơn 5MB (JPG, PNG)" | Re-upload |
| Auto-save fail | API error | "Saving..." turns red: "Lưu thất bại. [Thử lại]" | Retry |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Statistics table | `role="table"`, `aria-label="Platform statistics"` |
| Platform visibility toggles | `role="switch"`, `aria-label="Show {platform} in media kit"` |
| Portfolio grid | `role="list"`, drag items `aria-roledescription="sortable"` |
| Rate card table | `role="table"`, editable cells with `aria-label="Price for {deliverable}"` |
| Privacy radio | `role="radiogroup"`, `aria-label="Media kit visibility"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Section skeletons |
| Profile | 100-300ms | Profile header populates |
| Stats sync | 500-2000ms | Platform rows populate with latest data |
| Demographics | 500-1000ms | Charts render |
| Portfolio | 300-600ms | Thumbnails lazy-load |
| Rate card | 200-400ms | Table populates |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `media_kit.viewed` | Page load | `platforms_connected`, `portfolio_count` |
| `media_kit.profile_updated` | Profile field edited | `field` (name/tagline/photo/categories) |
| `media_kit.stats_refreshed` | "🔄 Refresh stats" | `platforms_refreshed` |
| `media_kit.portfolio_reordered` | Drag-sort completed | `item_id`, `old_pos`, `new_pos` |
| `media_kit.rate_card_updated` | Rate price changed | `deliverable`, `old_price`, `new_price` |
| `media_kit.shared` | "📤 Share" clicked | `method` (copy/email) |
| `media_kit.pdf_downloaded` | "📥 Download PDF" | `page_count` |
| `media_kit.privacy_changed` | Privacy radio changed | `new_privacy` (public/link/password) |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/creator-pro/media-kit/+page.svelte`
- **Server load**: `+page.server.ts` → `MediaKitService/GetKit(user_id)` + `CreatorProfileService/GetStats(platforms)`
- **Auto-sync**: Background cron syncs platform stats every 6h; manual refresh triggers immediate sync via `PlatformService/SyncStats(platform_id)`
- **Demographics**: Aggregated from platform APIs, cached 24h
- **Portfolio**: Drag-sort via `@dnd-kit/sortable`, items from Asset Library
- **Rate card**: Inline editable table → auto-save on blur
- **PDF**: Client-side `html2pdf.js` or server-side Puppeteer rendering
- **Share**: `navigator.share()` + copy link + email compose
- **Public page**: SSR at `creativanta.vn/k/{handle}` → reads `media_kits` table

---

## 13. Localization Notes

- Stats: "Người theo dõi", "Tương tác", "Tiếp cận/tháng"
- Demographics: "Độ tuổi", "Giới tính", "Thành phố"
- Rate card: "Loại nội dung", "Giá khởi điểm", "Hiển thị"
- Privacy: "Công khai", "Chỉ qua link", "Có mật khẩu"
- Tone: Professional, brand-pitch-ready

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Share CTA, edit CTAs |
| `--color-success` | Stats sync success |
| `--color-warning` | Stale stats (>24h) |
| `--color-platform-tiktok` | TikTok row accent |
| `--color-platform-instagram` | Instagram row accent |
| `--color-platform-youtube` | YouTube row accent |
| `--color-surface-elevated` | Section cards |
| `--font-metric` | Stats numbers (tabular-nums) |
| `--color-text-secondary` | Timestamps, hints |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W088] Creator Pro Dashboard | Parent |
| [W093] Rate Card Builder | Detailed rate card |
| [W095] Brand Deal Manager | Deal pipeline |
| [M048] Mobile Media Kit Preview | Mobile preview |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (sync fail, PDF gen), section/drag a11y, 8 analytics, SvelteKit impl (auto-sync, PDF gen), localization, 9 design tokens (platform-specific). | System |
| 2026-03-28 | 1.0 | Initial specification | System |

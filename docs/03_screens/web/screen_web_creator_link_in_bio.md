# Screen: Web — Link-in-Bio Builder

> **Screen ID**: W092
> **Module**: S16 — Creator Pro Tools
> **Route**: `/creator-pro/link-in-bio`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 05, A1 Schema (link_in_bio_pages, link_in_bio_links)

---

## 1. Purpose & Context

Build a personal landing page at `creativanta.link/{username}` with drag-reorder links, theme selection, analytics, and optional custom domain.

---

## 2-5. Layout & Actions

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Creator Pro   🔗 Link-in-Bio          [👁 Preview] [📤 Share]    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Live Preview (40%) ─────┐  ┌─ Editor (60%) ──────────────────┐  │
│ │ [Phone frame mockup]      │  │ ┌─ Profile ──────────────────┐  │  │
│ │ ┌──────────────────┐      │  │ │ Avatar: [📎] Name: [....]  │  │  │
│ │ │ [Avatar]         │      │  │ │ Bio: [Content creator...]   │  │  │
│ │ │ Nguyễn Quân      │      │  │ └────────────────────────────┘  │  │
│ │ │ Creator ẩm thực  │      │  │ ┌─ Links (drag to reorder) ─┐  │  │
│ │ │                  │      │  │ │ ☰ 🎬 YouTube channel      │  │  │
│ │ │ [🎬 YouTube]     │      │  │ │   URL: [youtube.com/...]   │  │  │
│ │ │ [🛍 TikTok Shop] │      │  │ │   [🟢 On] Clicks: 342     │  │  │
│ │ │ [📸 Instagram]   │      │  │ │ ☰ 🛍 TikTok Shop          │  │  │
│ │ └──────────────────┘      │  │ │ [+ Thêm link mới]         │  │  │
│ │ Real-time updates         │  │ └────────────────────────────┘  │  │
│ └────────────────────────────┘  │ ┌─ Theme ──────────────────┐  │  │
│                                  │ │ [Minimal][Bold][Gradient]│  │  │
│                                  │ │ Colors: [██ Primary]     │  │  │
│                                  │ └────────────────────────────┘  │  │
│                                  └──────────────────────────────┘  │
│ ┌─ Analytics (bottom) ──────────────────────────────────────────┐  │
│ │ Views: 1,234 (7d) · Clicks: 342 · CTR: 27.7%                 │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ [Lưu] [📤 Copy link]                                               │
└──────────────────────────────────────────────────────────────────────┘
```

### Link Types
| Type | Icon | Behavior |
|---|---|---|
| URL | 🔗 | External link |
| Product | 🛍 | Product page with price |
| Video | 🎬 | Embedded preview |
| Social | 📱 | Platform icon |
| Download | 📥 | Direct download |
| Email | 📧 | Opens mailto: |

| # | Action | Trigger | API | Result |
|---|---|---|---|---|
| 1 | Add link | "+ Thêm" | — | New row |
| 2 | Reorder | Drag ☰ | `LinkInBioService/Reorder` | Links reorder |
| 3 | Toggle | ON/OFF | `LinkInBioService/ToggleLink` | Link hidden/shown |
| 4 | Theme | Click theme | `LinkInBioService/UpdateTheme` | Preview updates |
| 5 | Save | "Lưu" | `LinkInBioService/Save` | Saved |

### Technical Notes
- Route: `src/routes/(app)/creator-pro/link-in-bio/+page.svelte`
- Free: max 3 links, Pro: unlimited
- Preview: real-time iframe of published page

### Related Screens: [W104] Dashboard, [M49] Mobile Link-in-Bio

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached page data | Retry online |
| Save fail | API error on save | Toast: "Không lưu được. [Thử lại]" + unsaved indicator | Retry |
| Theme render fail | CSS/iframe error | Fallback: default theme applied | Reset theme |
| Link URL invalid | Non-URL input | Inline: "URL không hợp lệ" | Fix input |
| Copy link fail | Clipboard API blocked | Toast: "Không copy được. Hãy copy thủ công." | Manual copy |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Link list | `role="list"`, `aria-label="Bio links"`, items `role="listitem"` |
| Drag handles | `aria-roledescription="sortable"`, `aria-label="Drag to reorder {link}"` |
| Link toggle | `role="switch"`, `aria-checked`, `aria-label="{link}: {on/off}"` |
| Theme selector | `role="radiogroup"`, `aria-label="Theme"`, each theme `role="radio"` |
| Live preview | `aria-label="Live preview of your link-in-bio page"`, `role="region"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Split-pane skeleton |
| Page data | 200-400ms | Profile + links populate |
| Preview iframe | 500-1000ms | Preview renders |
| Theme switch | 200-400ms | Preview refreshes with new theme |
| Analytics | 300-600ms | Stats populate below |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `link_in_bio.viewed` | Page load | `link_count`, `theme`, `total_clicks` |
| `link_in_bio.link_added` | "+ Thêm link mới" | `link_type`, `position` |
| `link_in_bio.link_reordered` | Drag completed | `link_id`, `old_pos`, `new_pos` |
| `link_in_bio.link_toggled` | ON/OFF toggle | `link_id`, `visible` |
| `link_in_bio.theme_changed` | Theme selected | `old_theme`, `new_theme` |
| `link_in_bio.saved` | "Lưu" | `link_count`, `theme` |
| `link_in_bio.link_copied` | "📤 Copy link" | — |
| `link_in_bio.previewed` | "👁 Preview" | — |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/creator-pro/link-in-bio/+page.svelte`
- **Server load**: `+page.server.ts` → `LinkInBioService/GetPage(user_id)` + `LinkInBioService/GetAnalytics`
- **Drag-drop**: `@dnd-kit/sortable` or Svelte DnD Action for link reordering
- **Preview**: Iframe pointed at `creativanta.link/{username}?preview=true`, refreshes on edit
- **Auto-save**: Debounced 2s after last edit → `LinkInBioService/Save(page_data)`
- **Theme**: CSS variables injected into preview iframe via postMessage
- **Free tier**: Max 3 links → upsell CTA for more
- **Analytics**: Link click tracking via redirect endpoint with UTM params

---

## 13. Localization Notes

- Profile: "Tên hiển thị", "Tiểu sử"
- Links: "+ Thêm link mới", "Kéo để sắp xếp"
- Themes: "Tối giản", "Nổi bật", "Gradient"
- Analytics: "Lượt xem", "Clicks", "CTR"
- Tone: Creative, personal

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Save CTA, primary link buttons |
| `--color-success` | Link active toggle |
| `--color-text-secondary` | Analytics numbers, hints |
| `--color-surface-elevated` | Editor panels |
| `--color-border` | Link item borders |
| `--color-preview-bg` | Preview background |
| `--font-metric` | Analytics numbers (tabular-nums) |
| `--radius-card` | Link item corners |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W088] Creator Pro Dashboard | Parent |
| [M047] Mobile Link-in-Bio | Mobile equivalent |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (save fail, theme render), drag/preview a11y, 8 analytics, SvelteKit impl (drag-drop, iframe preview), localization, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

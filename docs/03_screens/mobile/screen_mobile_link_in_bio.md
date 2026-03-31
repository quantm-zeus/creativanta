# Screen: Mobile — Link-in-Bio

> **Screen ID**: M052
> **Module**: M14 — Link-in-Bio
> **Route**: `/link-in-bio` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (link_pages, link_items), B5 RBAC §2.7

---

## 1. Purpose & Context
Mobile link-in-bio editor — manage links, reorder, toggle visibility. Preview live page and share link.
### Entry Points - Sidebar: "🔗 Link-in-Bio"
### Exit Points - "👁 Preview" → in-app browser preview

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Link-in-Bio                           [👁 Preview] [📤 Share]   │
├──────────────────────────────────────────────────────────────────────┤
│ URL: creativanta.link/nguyenquan [📋 Copy]                         │
│ Theme: [Minimal Dark ▾]                                              │
│                                                                      │
│ ┌─ Link List (drag to reorder) ────────────────────────────────┐   │
│ │ ⠿ 🛍 "Shop Skincare"                        [🟢 Visible]    │   │
│ │   → creativanta.link/shop/summer · Clicks: 234               │   │
│ │ ⠿ 🎵 "TikTok"                                [🟢 Visible]   │   │
│ │   → tiktok.com/@creativanta · Clicks: 567                    │   │
│ │ ⠿ 📸 "Instagram"                              [⬜ Hidden]   │   │
│ │   → instagram.com/creativanta · Clicks: 0                    │   │
│ │ ⠿ 📧 "Email"                                  [🟢 Visible]  │   │
│ │ [+ Thêm link]                                                 │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Analytics Mini ──────────────────────────────────────────────┐   │
│ │ Total clicks today: 45 · This week: 312 · CTR: 8.2%         │   │
│ └────────────────────────────────────────────────────────────────┘   │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```
## 7. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer |
| LOADED | Links ready | Drag-reorder list |
| EMPTY | No links | "Thêm link đầu tiên! [+ Thêm]" |
| SAVING | Auto-save on drag | "Saving..." |
| ERROR | API failed | Error with retry |

---

## 2. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Related screens updated via state management
- Analytics events dispatched

---

## 4. Component Hierarchy
```
LinkinBioScreen
├── AppBar
│   ├── BackButton
│   └── Title + ActionButtons
├── ContentArea (scrollable, pull-to-refresh)
│   ├── SummarySection
│   ├── PrimaryContent
│   │   └── [Items per wireframe]
│   └── SecondaryContent
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Primary data | Backend table | `Service/Get` | Formatted display | 15m TTL |
| List items | Backend query | `Service/List(page)` | Card/row list | Based on criticality |
| Summary stats | Aggregation | `Service/GetStats` | Count/percentage | 5m TTL |
| User-facing text | i18n keys | — | Vietnamese | Static |


---
## 19. Related Screens
| Screen | Relationship |
|---|---|
| [W070] Web Link-in-Bio | Web equivalent |
---
## Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được dữ liệu. [Thử lại]" | Retry |
| Not found | 404 | "Không tìm thấy" → navigate back | Back |
| Permission denied | 403 | "Không có quyền truy cập" | Contact admin |

---
## Accessibility

| Element | Requirement |
|---|---|
| Interactive elements | Minimum 48×48dp tap targets |
| Icons with meaning | `Semantics(label:)` descriptive text |
| Status indicators | Color not sole indicator; text/icon also present |
| Dynamic content | `Semantics(liveRegion: true)` for updates |
| Contrast | 4.5:1 minimum ratio |

---
## Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + shimmer placeholders |
| Primary data | 200-500ms | Content populates progressively |
| User action | <1s | Inline spinner → result feedback |

---
## Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "1.200.000đ")
- Date: DD/MM/YYYY
- Numbers: dot separator (1.234)
- Relative time: "2 giờ trước", "1 ngày trước"
- Tone: Friendly, action-oriented

---
## Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Primary actions, CTAs |
| `--color-success` | Positive states, confirmations |
| `--color-warning` | Warning indicators |
| `--color-danger` | Error states, destructive actions |
| `--color-surface-elevated` | Cards, elevated surfaces |

---
## Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | Patch | Removed duplicate template sections. Replaced with screen-specific Error Handling, Accessibility, Loading, Localization, Design Tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

# Screen: Mobile — Media Kit

> **Screen ID**: M051
> **Module**: S16 — Creator Pro Tools
> **Route**: `/creator-pro/media-kit` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (media_kits), B5 RBAC §2.7

---

## 1. Purpose & Context
Mobile media kit viewer — preview and share your media kit. Editing is limited; full editing on web.
### Entry Points - Creator Pro → "📋 Media Kit"
### Exit Points - "📤 Share" → native share / "✏ Edit on web" → web link

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Media Kit                               [📤 Share] [✏ Edit web] │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Profile ─────────────────────────────────────────────────────┐   │
│ │ [Photo] Quân Nguyễn                                           │   │
│ │ "Content creator chuyên ẩm thực & lifestyle"                 │   │
│ │ HCM · [Cooking] [Lifestyle]                                   │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Stats ───────────────────────────────────────────────────────┐   │
│ │ 87K total followers · 5.4% avg ER · 1.9M reach/mo           │   │
│ │ 🎵 TikTok 50K · 📸 IG 25K · ▶ YT 12K                      │   │
│ │ Last sync: 1h ago [🔄 Refresh]                                │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Best Content ────────────────────────────────────────────────┐   │
│ │ [🎬 24K] [🎬 18K] [🎬 15K] [📸 12K]                        │   │
│ │ Scroll horizontally →                                          │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Rate Card ──────────────────────────────────────────────────┐   │
│ │ TikTok video: from 2,000,000đ                                │   │
│ │ IG Reel: from 1,500,000đ                                     │   │
│ │ YouTube: from 5,000,000đ                                      │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Share ───────────────────────────────────────────────────────┐   │
│ │ Link: creativanta.vn/k/nguyenquan                             │   │
│ │ [📋 Copy] [📧 Email] [📥 PDF]                                │   │
│ └────────────────────────────────────────────────────────────────┘   │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```
## 7. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer |
| LOADED | Kit ready | Full preview |
| EMPTY | No kit created | "Tạo Media Kit trên web để bắt đầu." |
| SYNCING | Refreshing stats | Spin on stats |
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
MediaKitScreen
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
| [W089] Web Media Kit | Web equivalent (full editor) |
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

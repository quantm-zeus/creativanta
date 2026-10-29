# Screen: Mobile — Script List

> **Screen ID**: M010
> **Module**: M05 — Content Pipeline
> **Route**: `/scripts` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (scripts), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile script browser — list AI-generated and manually created scripts with status (draft/approved/used), quick preview, and filter by platform/status.

### Entry Points
- Content tab → "📝 Scripts"
- AI Studio: "📝 View scripts"
- Push: "📝 3 scripts waiting for review"

### Exit Points
- Tap script → Script Editor (M014)
- "+ Tạo" → new script

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Scripts                                 [🔍] [Filter ▾] [+ Tạo] │
├──────────────────────────────────────────────────────────────────────┤
│ Chips: [All (24)] [📝 Draft (5)] [✅ Approved (12)] [🎬 Used (7)] │
│                                                                      │
│ ┌─ Script Card ─────────────────────────────────────────────────┐   │
│ │ 📝 "5 tips nấu ăn healthy"               [🟢 Approved]      │   │
│ │ Platform: 🎵 TikTok · Duration: 60s · Created: 2d ago       │   │
│ │ Source: 🤖 AI generated · Idea: #23                           │   │
│ │ Preview: "Mở đầu: Chào mọi người! Hôm nay mình..."         │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Script Card ─────────────────────────────────────────────────┐   │
│ │ 📝 "Skincare routine am"                  [📝 Draft]         │   │
│ │ Platform: 📸 IG · Duration: 30s · ⏳ Needs review             │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ Pull-to-refresh · Infinite scroll                                    │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Card shimmer |
| LOADED | Scripts listed | Chip filters + cards |
| EMPTY | No scripts | "Chưa có script nào. [🤖 Tạo bằng AI] or [✏ Viết thủ công]" |
| NEEDS_REVIEW | Drafts awaiting approval | Badge: "5 scripts cần duyệt" |
| ERROR | API failed | Error with retry |

---
## 4. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Related screens updated via state management
- Analytics events dispatched

---

## 5. Component Hierarchy
```
ScriptListScreen
├── AppBar
│   ├── BackButton
│   └── Title + ActionButtons
├── ContentArea (scrollable, pull-to-refresh)
│   ├── SummarySection
│   ├── PrimaryContent
│   │   └── Screen-specific regions defined by the ASCII wireframe and interaction states
│   └── SecondaryContent
└── BottomNavBar (shared)
```

---

## 6. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Primary data | Parent screen state or canonical contract object(s) | Resolve via owning feature doc + API/schema contracts | Exact DTO fields from canonical contracts | Per endpoint policy |
| List items | Parent screen list/query contract(s) | Resolve via API endpoint map before implementation | Card or row layout per wireframe | Per endpoint policy |
| Summary stats | Parent screen aggregates/projections | Resolve via feature rules + API contracts | Count / KPI / chip formatting per screen | Short-lived cache only if contract allows |
| User-facing text | i18n keys | — | Vietnamese | Static |


---
## 7. Related Screens

| Screen | Relationship |
|---|---|
| [W015] Web Script List | Web equivalent |
| [M011] Script Editor | Editor |
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

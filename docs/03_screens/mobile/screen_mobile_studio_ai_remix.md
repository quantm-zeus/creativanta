# Screen: Mobile — AI Remix

> **Screen ID**: M016
> **Module**: M07 — AI Studio
> **Route**: `/studio/remix` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 04, A1 Schema (assets)

---

## 1. Purpose & Context

Mobile AI Remix with 3-phase wizard. Swipe between phases. Phase 1: paste URL or upload reference. Phase 2: Creative DNA accordion sections with keep/modify toggles. Phase 3: preview + export.

---

## 2. Layout Structure

### Phase 1: Input
```
┌─ Status Bar ──────────────────────────────────────────────────────┐
│ ← AI Remix                              [Credits: ~35] [⋮]      │
├──────────────────────────────────────────────────────────────────────┤
│ [● Phase 1] ── [○ Phase 2] ── [○ Phase 3]                        │
│                                                                      │
│ ┌─ Reference ────────────────────────────────────────────────────┐ │
│ │ [📋 Paste URL or 📹 Upload reference video]                    │ │
│ │ [Preview thumbnail]                                             │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Your Assets ──────────────────────────────────────────────────┐ │
│ │ [📹 Upload footage] or [📁 From library]                       │ │
│ │ [Asset1 ×] [Asset2 ×] [+ Add]                                 │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Adaptation: [Strict copy ──●── Creative freedom]                     │
│ [→ Analyze — 5 credits]                                              │
```

### Phase 2: DNA Report (accordions)
```
│ [● Phase 1] ── [● Phase 2] ── [○ Phase 3]                        │
│ ┌─ Pacing ─────────────── [▾] ───────────┐                        │
│ │ Fast cuts (2.1s avg) · [Keep ●] [Mod ○]│                        │
│ └──────────────────────────────────────────┘                       │
│ ┌─ Visual Style ──────── [▾] ───────────┐                         │
│ │ Warm colors · Zoom cuts · [Keep ●]     │                         │
│ └──────────────────────────────────────────┘                       │
│ ┌─ Audio ─────────────── [▾] ───────────┐                         │
│ │ Trending beat · Overlay narration       │                         │
│ └──────────────────────────────────────────┘                       │
│ [→ Generate Remix — 30 credits]                                     │
```

---

## 3-5. Component & Actions

| # | Action | Gesture | Credits | Result |
|---|---|---|---|---|
| 1 | Paste URL | Paste | 0 | Reference loaded |
| 2 | Analyze | Bottom button | 5 cr | Phase 2 accordion |
| 3 | Toggle DNA | Keep/Modify radio | 0 | Customize remix |
| 4 | Generate | Bottom button | 30 cr | → Queue |

### Flutter Implementation
- Phase navigation: `PageView` with swipe
- Accordion: `ExpansionTile`
- Slider: `Slider` widget for adaptation level

### Related Screens: [W28] Web AI Remix, [M21] Studio Launcher

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

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
AIRemixScreen
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

## 5. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Primary data | Parent screen state or canonical contract object(s) | Resolve via owning feature doc + API/schema contracts | Exact DTO fields from canonical contracts | Per endpoint policy |
| List items | Parent screen list/query contract(s) | Resolve via API endpoint map before implementation | Card or row layout per wireframe | Per endpoint policy |
| Summary stats | Parent screen aggregates/projections | Resolve via feature rules + API contracts | Count / KPI / chip formatting per screen | Short-lived cache only if contract allows |
| User-facing text | i18n keys | — | Vietnamese | Static |

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

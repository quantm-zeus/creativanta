# Screen: Mobile — Workspace Switch

> **Screen ID**: M004
> **Module**: M01 — Home (Global)
> **Route**: Modal overlay
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §4

---

## 1. Purpose & Context

Mobile workspace switcher — bottom sheet displaying all workspaces with quick switch capability. Shows workspace avatar, name, plan, and unread notification count per workspace.

### User Story
> As a creator managing multiple brands, I want to quickly switch between workspaces on my phone.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌──────────────────────────────────────────────────────────────────────┐
│ ... current page dimmed ...                                          │
│                                                                      │
│ ┌─ Bottom Sheet ─────────────────────────────────────────────────┐  │
│ │ Chọn workspace                                         [✕]    │  │
│ │                                                                  │  │
│ │ ┌─ Active ────────────────────────────────────────────────────┐│  │
│ │ │ [🟢 Avatar] Creativanta HQ · Pro Plan · ✅ Active          ││  │
│ │ └────────────────────────────────────────────────────────────┘│  │
│ │                                                                  │  │
│ │ ┌─ Other ─────────────────────────────────────────────────────┐│  │
│ │ │ [Avatar] SkinCare Brand · Free Plan · 🔴 3 unread          ││  │
│ │ └────────────────────────────────────────────────────────────┘│  │
│ │ ┌─ Other ─────────────────────────────────────────────────────┐│  │
│ │ │ [Avatar] Food Channel · Starter Plan                       ││  │
│ │ └────────────────────────────────────────────────────────────┘│  │
│ │                                                                  │  │
│ │ [+ Tạo workspace mới]                                          │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
WorkspaceSwitchSheet
├── SheetHeader ("Chọn workspace" + CloseButton)
├── WorkspaceList
│   └── WorkspaceRow[]
│       ├── Avatar
│       ├── WorkspaceName
│       ├── PlanBadge
│       ├── ActiveBadge (if current)
│       └── UnreadBadge (if not current and has unread)
└── CreateWorkspaceButton
```

---

## 4-5. Data & Actions

| # | Action | Trigger | API | Result |
|---|---|---|---|---|
| 1 | Switch | Tap workspace row | `WorkspaceService/Switch(id)` | App reloads with new context |
| 2 | Create | "+" button | — | Push → workspace creation flow |
| 3 | Close | "✕" or swipe down | — | Sheet closes |

---

## 6-20. Standard Sections

### Mobile UX
- Bottom sheet with drag handle
- Haptic: medium on switch
- Active workspace: green indicator dot
- Switch: shows loading overlay while context reloads

### Flutter Implementation
- Widget: `showModalBottomSheet` with `WorkspaceSwitchSheet`
- Triggered by: long-press avatar in bottom nav or AppBar menu
- Data: Riverpod `workspaceListProvider`

### Related Screens
| Screen | Relationship |
|---|---|
| [W002] Web Workspace Selector | Web equivalent |
| [M001] Mobile Home | Returns to home after switch |

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

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

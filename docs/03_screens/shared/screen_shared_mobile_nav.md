> **Screen ID**: S003

# Shared Component: Mobile Bottom Nav & App Bar

> **Component ID**: S02
> **Type**: Shared Layout Component
> **Platform**: Mobile (Flutter)
> **Used By**: All authenticated mobile screens

---

## 1. Purpose

The Mobile Bottom Navigation and App Bar are the persistent navigation elements for the Flutter mobile app. 5-tab bottom bar provides primary navigation, while the App Bar provides contextual actions and back navigation.

---

## 2. Bottom Nav Bar

### Layout
```
┌──────────────────────────────────────────────────────────────────────┐
│ [🏠 Home] [💡 Ideas] [🎬 Studio] [💬 Inbox•23] [📊 Analytics]     │
└──────────────────────────────────────────────────────────────────────┘
```

### Tabs
| Tab | Icon | Label | Route | Badge |
|---|---|---|---|---|
| Home | 🏠 | Trang chủ | `/` | None |
| Ideas | 💡 | Ý tưởng | `/ideas` | New AI ideas count |
| Studio | 🎬 | Studio | `/studio` | Active jobs count |
| Inbox | 💬 | Inbox | `/inbox` | Unread messages |
| Analytics | 📊 | Analytics | `/analytics` | None |

### Behavior
- Active tab: filled icon + label + color accent
- Inactive: outlined icon + dimmed
- Badge: red circle with number (max "99+")
- Long press: haptic + tooltip with full label
- Hides on scroll down, reveals on scroll up
- System badge: inbox unread count on app icon

---

## 3. App Bar Variants

### Root Level (on tab roots)
```
┌──────────────────────────────────────────────────────────────────────┐
│ [🏢 WS Avatar] Title                            [🔔•] [👤/⋮]    │
└──────────────────────────────────────────────────────────────────────┘
```

### Detail Level (pushed pages)
```
┌──────────────────────────────────────────────────────────────────────┐
│ [← Back] Title                                   [Action] [⋮]      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
MobileShell
├── AppBar
│   ├── LeadingWidget (avatar on root / back on detail)
│   ├── TitleWidget
│   └── ActionButtons (notification, menu, contextual)
├── Body (page content)
└── BottomNavBar
    └── NavTab[] (5 tabs)
        ├── Icon (outlined/filled)
        ├── Label
        └── BadgeWidget (optional)
```

---

## 5. Flutter Implementation
- BottomNav: `BottomNavigationBar` with `BottomNavigationBarType.fixed`
- Badge: `Badge` widget wrapping icon
- Shell routing: `GoRouter` with `ShellRoute` for persistent nav
- Active state: `GoRouter.of(context).location` matching
- Hide on scroll: `ScrollController` listener

---

## 6. Accessibility
- Each tab: `Semantics(label: 'tab_name')` 
- Badge: `Semantics(label: '23 unread messages')`
- Haptic: `HapticFeedback.lightImpact()` on tab switch

---

## 7. Navigation Patterns
- Tab switch: no animation (instant)
- Within tab: push navigation with slide transition
- Back: pop to tab root then switch tabs
- Deep link: activate correct tab + push to target

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 8. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Analytics events dispatched

---

## 9. Data Binding & Display Format
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

# Screen: Mobile — Notification List

> **Screen ID**: M002
> **Module**: M01 — Home (Global)
> **Route**: `/notifications` (mobile app)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §4, A1 Schema (notifications)

---

## 1. Purpose & Context

Mobile notification list — full-screen view of all notifications grouped by recency. Tappable for navigation to source entity. Mark-all-read and per-item swipe-to-dismiss.

### User Story
> As a creator, I want to see all my notifications on mobile and tap to jump to the relevant screen.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← 🔔 Thông báo (8 chưa đọc)           [✅ Đánh dấu tất cả]      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ── Hôm nay ──                                                        │
│ ┌─ Notification ──────────────────────────────────────────────────┐ │
│ │ 🔵 🤖 AI scored your idea "5 tips..." ⭐ 88                   │ │
│ │ 2 phút trước                                                    │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│ ┌─ Notification ──────────────────────────────────────────────────┐ │
│ │ 🔵 💬 Nguyễn Văn A commented on "Skincare tips"               │ │
│ │ 15 phút trước                                                   │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ── Hôm qua ──                                                        │
│ ┌─ Notification (read) ──────────────────────────────────────────┐  │
│ │ ⚪ 📦 Order #TK-1234 delivered                                  │  │
│ │ 1 ngày trước                                                     │  │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ... scroll for more ...                                              │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
MobileNotificationListPage
├── AppBar (← back, Title + UnreadBadge, MarkAllReadButton)
├── NotificationList (grouped by date, pull-to-refresh)
│   └── DateGroup[]
│       ├── DateHeader
│       └── NotificationRow[] (swipeable: dismiss)
│           ├── UnreadDot
│           ├── TypeIcon (🤖📬📦💬🔥📊)
│           ├── NotificationText
│           └── RelativeTime
```

---

## 4-5. Data & Actions

| # | Action | Trigger | API | Result |
|---|---|---|---|---|
| 1 | Open source | Tap notification | `NotificationService/MarkRead` + navigate | Push to entity screen |
| 2 | Mark all read | "✅ Đánh dấu tất cả" | `NotificationService/MarkAllRead` | All dots clear |
| 3 | Dismiss | Swipe left | `NotificationService/Delete(id)` | Row removed |
| 4 | Pull refresh | Pull gesture | Refetch | List updates |

---

## 6-20. Standard Sections

### Flutter Implementation
- Widget: `NotificationListPage extends ConsumerWidget`
- State: Riverpod `notificationListProvider`
- Push notifications: `firebase_messaging` → in-app + list
- Swipe: `Dismissible` with red "Xóa" background

### Related Screens
| Screen | Relationship |
|---|---|
| [W003] Web Notification Center | Web equivalent |
| All screens | Notifications link to source entities |

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

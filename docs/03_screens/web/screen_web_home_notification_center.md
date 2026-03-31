# Screen: Web — Notification Center

> **Screen ID**: W03
> **Module**: M01 — Home & Decision
> **Route**: `/notifications` (also: bell dropdown in topbar)
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §8, A1 Schema (notifications, notification_preferences)

---

## 1. Purpose & Context

The Notification Center aggregates all system notifications — from new orders, publishing events, AI results, team mentions, and platform alerts. It has two modes: a **dropdown** (bell icon in topbar) for quick glance, and a **full page** for browsing history.

### User Story
> As a creator, I want to see all important events in one place and quickly act on them without navigating away from my current task.

### Entry Points
- TopBar: 🔔 Bell icon (dropdown mode)
- TopBar: "Xem tất cả" from dropdown → full page
- Direct URL: `/notifications`

### Exit Points
- Click notification → respective page (order, publish item, inbox thread, etc.)
- Dismiss → notification marked read

---

## 2. Layout Structure

### Dropdown Mode (from bell icon)
```
┌─ Notification Dropdown (400px wide) ────────────────────────────────┐
│ 🔔 Thông báo (23 chưa đọc)                    [Đánh dấu tất cả ✓]│
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ── Hôm nay ──                                                        │
│ ┌─ 🔵 📦 3 đơn hàng mới từ TikTok Shop           · 15 phút trước  │
│ │   Serum ×2, Sunscreen ×1 — Tổng: 847,000đ        [Xem đơn →]    │
│ └────────────────────────────────────────────────────────────────────│
│ ┌─ 🔵 🎬 Video "5 tips" đã publish thành công     · 30 phút trước  │
│ │   TikTok ✅ · Instagram ✅                        [Xem stats →]   │
│ └────────────────────────────────────────────────────────────────────│
│ ┌─ ⚪ 🤖 AI đã tạo xong 3 ý tưởng mới            · 1 giờ trước   │
│ │   Score: 85, 72, 68                                [Xem →]        │
│ └────────────────────────────────────────────────────────────────────│
│ ┌─ ⚪ 💬 Nguyễn A đã comment trên video            · 2 giờ trước   │
│ │   "Sản phẩm mua ở đâu?"                           [Trả lời →]    │
│ └────────────────────────────────────────────────────────────────────│
│                                                                      │
│ [Xem tất cả thông báo →]                                            │
└──────────────────────────────────────────────────────────────────────┘
```

### Full Page Mode
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🔔 Thông báo                [Đánh dấu tất cả ✓] [⚙ Cài đặt]      │
├──────────────────────────────────────────────────────────────────────┤
│ Filter: [Tất cả] [📦 Đơn hàng] [📤 Publish] [🤖 AI] [💬 Inbox]   │
│         [⚠️ Hệ thống] [👥 Team]                                     │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ── Hôm nay ──                                                        │
│ ┌─ Notification Row (full list, grouped by date) ─────────────────┐ │
│ │ 🔵 📦 3 đơn hàng mới từ TikTok Shop           · 15 phút trước  │ │
│ │    Serum ×2, Sunscreen ×1 — Tổng: 847,000đ      [Xem đơn →]    │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│ ... more notifications ...                                           │
│                                                                      │
│ ── Hôm qua ──                                                        │
│ ... older notifications ...                                          │
│                                                                      │
│ [Tải thêm ↓]                                                        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
NotificationCenter
├── NotificationDropdown (topbar mode)
│   ├── DropdownHeader
│   │   ├── Title + unread count
│   │   └── MarkAllReadButton
│   ├── NotificationList (max 10 items)
│   │   └── NotificationItem[]
│   │       ├── UnreadDot (🔵/⚪)
│   │       ├── CategoryIcon
│   │       ├── Title
│   │       ├── Body (truncated)
│   │       ├── Timestamp (relative)
│   │       └── ActionLink
│   └── ViewAllLink
└── NotificationPage (full page mode)
    ├── PageHeader
    │   ├── Title + MarkAllRead
    │   └── SettingsLink
    ├── FilterChips
    └── GroupedNotificationList
        └── DateGroup[]
            ├── DateLabel
            └── NotificationItem[] (same as dropdown)
```

---

## 4. Data Binding & Display Format

| UI Element | Data Source | API | Display Format |
|---|---|---|---|
| Notification title | `notifications.title` | `NotificationService/List` | Bold text |
| Body | `notifications.body` | same | Text, truncated 80 chars in dropdown |
| Category | `notifications.category` | same | Icon: 📦/📤/🤖/💬/⚠️/👥 |
| Time | `notifications.created_at` | same | Relative time |
| Unread | `notifications.read_at IS NULL` | same | 🔵 dot |
| Action URL | `notifications.action_url` | same | CTA link |
| Unread badge count | `COUNT(unread)` | `NotificationService/GetUnreadCount` | Number on bell icon |

---

## 5. Actions Table

| # | Action | Trigger | API | UI Result | Permission |
|---|---|---|---|---|---|
| 1 | Mark as read | Click notification | `NotificationService/MarkRead(id)` | 🔵→⚪, badge count -1 | Any role |
| 2 | Mark all read | "Đánh dấu tất cả ✓" | `NotificationService/MarkAllRead` | All dots → ⚪, badge → 0 | Any role |
| 3 | Navigate to source | Click action link | — | Navigate to respective page | Depends on target |
| 4 | Filter | Click filter chip | Refetch with category filter | List updates | Any role |
| 5 | Load more | Scroll bottom | `NotificationService/List(cursor)` | More items append | Any role |
| 6 | Open settings | "⚙ Cài đặt" | — | → `/settings/notifications` | Any role |

---

## 6. State Machine

| State | Visual |
|---|---|
| LOADING | Skeleton list items |
| LOADED | Full notification list with date groups |
| EMPTY | "Không có thông báo nào 🎉" |
| EMPTY_FILTERED | "Không có thông báo cho bộ lọc này" |
| ERROR | "Không tải được thông báo. [Thử lại]" |

---

## 7-8. Validation & Permission

- No form inputs (read-only display)
- All authenticated users can view their own notifications
- Notifications are workspace-scoped

---

## 9. Navigation Map

```
Notification Center (/notifications)
├── → /orders                    (via order notification)
├── → /publish/[id]              (via publish notification)
├── → /ideas                     (via AI idea notification)
├── → /inbox/[threadId]           (via inbox notification)
├── → /settings/connectors       (via platform alert)
├── → /settings/notifications    (via settings link)
```

---

## 10. Error Handling

| Error | Response | Recovery |
|---|---|---|
| Load fail | Dropdown shows "Lỗi" | Retry on next open |
| Mark read fail | Toast "Không đánh dấu được" | Auto-retry |

---

## 11-20. Standard Sections

### Real-time Updates
- New notifications arrive via SSE `/events/notifications`
- Badge count updates in real-time
- New notification slides in at top with subtle animation

### Accessibility
- `role="listbox"` on notification list
- `aria-label` on each notification item
- Keyboard: Arrow keys to navigate, Enter to open

### Performance
- Dropdown: max 10 items, lazy-load more on full page
- No heavy assets

### Technical Notes
- Dropdown: Svelte component in `AppShell/TopBar/NotificationBell.svelte`
- Full page: `src/routes/(app)/notifications/+page.svelte`
- SSE integration in layout-level `+layout.svelte`

### Related Screens
| Screen | Relationship |
|---|---|
| [W01] Home Dashboard | Contains bell icon trigger |
| [W81] Notification Settings | Configure preferences |
| [M02] Mobile Notifications | Mobile equivalent |

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-27 | 1.0 | Initial specification |

---

## 2. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Analytics events dispatched

---

## 9. Permission Matrix
| Action | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Create/Edit | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Delete | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

---

## 13. Loading Behavior
| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | Shell + shimmer skeleton |
| Data fetch | 200-500ms | Content populates progressively |
| User action | <1s | Inline spinner → result feedback |

---

## 16. Localization Notes
- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator)
- Date: DD/MM/YYYY
- Numbers: dot separator (1.234)
- Tone: Friendly, action-oriented

---

## 17. Analytics / Tracking Events
| Event | Trigger | Properties |
|---|---|---|
| `notification_center.viewed` | Screen load | `source` |
| `notification_center.action` | Primary user action | `action_type`, relevant IDs |
| `notification_center.error` | Error occurred | `error_type`, `error_code` |

---

## 18. Design Tokens Reference
| Token | Usage |
|---|---|
| `--color-accent` | Primary actions, CTAs |
| `--color-success` | Positive states |
| `--color-warning` | Warning indicators |
| `--color-danger` | Error states, destructive |
| `--color-surface-elevated` | Cards, elevated surfaces |

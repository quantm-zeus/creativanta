> **Screen ID**: S001

# Shared Component: App Shell

> **Component ID**: S01
> **Type**: Shared Layout Component
> **Platform**: Web (SvelteKit)
> **Used By**: All authenticated web screens

---

## 1. Purpose

The App Shell is the persistent layout wrapper for all authenticated pages. It includes the sidebar navigation, top bar, breadcrumbs, and content area. Responsive: shifts to mobile layout at smaller breakpoints.

---

## 2. Layout Structure

### Desktop (≥1280px)
```
┌─ TopBar (h: 56px) ──────────────────────────────────────────────────┐
│ [≡ Toggle] 🏢 Creativanta HQ  [🔍 Cmd+K] [🤖] [🔔•3] [👤 Quân ▾]│
├─ Sidebar (w: 260px) ────────────┬─ Content Area ────────────────────┤
│ 🏠 Dashboard                    │                                    │
│                                  │ ┌─ Breadcrumbs ─────────────────┐│
│ 📊 Intelligence                 │ │ Home › Intelligence › Trends   ││
│ ├── 🔥 Xu hướng                 │ └──────────────────────────────┘│
│ ├── 💎 Cơ hội                   │                                  │
│ ├── 🏆 Đối thủ                  │ {Page Content}                   │
│ └── 📊 Benchmark                │                                  │
│                                  │                                  │
│ ✏️ Nội dung                      │                                  │
│ ├── 💡 Ý tưởng                  │                                  │
│ ├── 📝 Script                   │                                  │
│ └── 🎬 AI Studio                │                                  │
│                                  │                                  │
│ 📤 Xuất bản                      │                                  │
│ ├── 📤 Đăng bài                 │                                  │
│ └── 📅 Lịch                      │                                  │
│                                  │                                  │
│ 💬 Tương tác                     │                                  │
│ ├── 💬 Inbox  •23               │                                  │
│ └── 👤 Liên hệ                  │                                  │
│                                  │                                  │
│ 🛍 Kinh doanh                    │                                  │
│ ├── 🛍 Sản phẩm                 │                                  │
│ ├── 📦 Đơn hàng                 │                                  │
│ ├── 🏷 Khuyến mãi               │                                  │
│ └── 🤝 Affiliate                │                                  │
│                                  │                                  │
│ 💰 Tài chính                     │                                  │
│                                  │                                  │
│ 📊 Analytics                     │                                  │
│                                  │                                  │
│ ⚙️ Cài đặt                       │                                  │
│                                  │                                  │
│ ┌─ Sidebar Footer ──────────┐  │                                    │
│ │ Plan: Pro · 12/100 credits│  │                                    │
│ │ [🤖 Copilot] [❓ Help]    │  │                                    │
│ └────────────────────────────┘  │                                    │
└──────────────────────────────────┴───────────────────────────────────┘
```

### Tablet (768-1279px): Sidebar collapses to icon-only (60px)
### Mobile (<768px): Sidebar hidden, hamburger menu → overlay

---

## 3. Component Hierarchy

```
AppShell
├── TopBar
│   ├── SidebarToggle (hamburger/collapse)
│   ├── WorkspaceName (click → workspace selector)
│   ├── SearchButton (Cmd+K)
│   ├── CopilotButton
│   ├── NotificationBell (with badge)
│   └── UserMenu (avatar + dropdown)
│       ├── ProfileLink
│       ├── SettingsLink
│       ├── WorkspaceSwitchLink
│       ├── ThemeToggle (light/dark)
│       └── LogoutButton
├── Sidebar
│   ├── NavGroup[] (Intelligence, Content, Publish, Engagement, Commerce, Finance, Analytics)
│   │   ├── GroupTitle (collapsible)
│   │   └── NavItem[]
│   │       ├── Icon
│   │       ├── Label
│   │       ├── Badge (optional, e.g., inbox unread)
│   │       └── ActiveIndicator
│   └── SidebarFooter
│       ├── PlanInfo
│       ├── CreditCounter
│       └── HelpButton
├── Breadcrumbs
└── ContentSlot (page content goes here)
```

---

## 4. Responsive Behavior

| Breakpoint | Sidebar | TopBar | Content |
|---|---|---|---|
| ≥1440px | 260px, fully expanded | Full | Remaining width |
| 1280-1439px | 260px, collapsible | Full | Remaining width |
| 768-1279px | 60px, icon-only | Compact | Remaining width |
| <768px | Hidden, overlay on toggle | Mobile | Full width |

---

## 5. States

| State | Visual |
|---|---|
| SIDEBAR_EXPANDED | Full sidebar with labels |
| SIDEBAR_COLLAPSED | Icon-only sidebar (60px) |
| SIDEBAR_HIDDEN | Mobile overlay mode |
| COPILOT_OPEN | Right panel opens, content shrinks |

---

## 6. Accessibility
- Sidebar: `nav` element with `aria-label="Main navigation"`
- Active item: `aria-current="page"`
- Skip to content: hidden link at top
- Keyboard: ↑↓ navigate items, Enter to select

---

## 7. Technical Notes
- Component: `src/lib/components/AppShell/AppShell.svelte`
- Layout: `src/routes/(app)/+layout.svelte`
- Sidebar state: Svelte store, persisted in localStorage
- Active detection: `$page.route.id` matching
- Badge sync: SSE `/events/badges` for inbox count

---

## 8. Permission-Based Nav

Items hidden based on RBAC:
- Finance: hidden unless `profit:read`
- AI Studio: hidden unless `asset:generate`
- Commerce: hidden unless `product:read`
- Settings: hidden unless `workspace:billing:read`

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

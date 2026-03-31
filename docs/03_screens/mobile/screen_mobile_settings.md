# Screen: Mobile — Settings

> **Screen ID**: M40
> **Module**: M19 — Settings (Mobile)
> **Route**: `/settings` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: Product Freeze §27

---

## 1. Purpose & Context

Mobile settings hub — grouped list of all account and workspace settings. Includes profile, notifications, connected platforms, brand, team, billing, and app preferences.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ Status Bar ──────────────────────────────────────────────────────┐
│ ← ⚙️ Cài đặt                                                     │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Profile ──────────────────────────────────────────────────────┐ │
│ │ [😊 Avatar]  Quân Nguyễn · quanm@gmail.com                    │ │
│ │ [✏ Chỉnh sửa hồ sơ →]                                         │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ── Workspace ──                                                      │
│ [🔗 Kết nối nền tảng →]                                            │
│ [🎨 Thương hiệu & Voice →]                                        │
│ [👥 Đội ngũ & Phân quyền →]                                       │
│ [💳 Thanh toán & Gói →]                                            │
│                                                                      │
│ ── Thông báo ──                                                      │
│ [🔔 Push notifications   ▾ ON]                                      │
│ [📧 Email notifications  ▾ ON]                                      │
│ [🔕 Quiet hours: 22:00 - 07:00 →]                                  │
│                                                                      │
│ ── Ứng dụng ──                                                       │
│ [🌙 Dark mode   ▾ Auto]                                             │
│ [🌐 Ngôn ngữ   ▾ Tiếng Việt]                                       │
│ [📱 Chất lượng video   ▾ Tự động]                                   │
│ [💾 Cache: 234 MB   [Xóa cache]]                                   │
│                                                                      │
│ ── Tài khoản ──                                                      │
│ [🔑 Đổi mật khẩu →]                                                │
│ [🗑 Xóa tài khoản →]                                                │
│ [🚪 Đăng xuất]                                                       │
│                                                                      │
│ Version: 1.0.0 (build 42)                                            │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                         │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3-5. Component & Actions

```
MobileSettingsPage
├── ProfileSection (avatar, name, email, edit link)
├── WorkspaceGroup
│   ├── ConnectorsLink → Push to connector settings
│   ├── BrandLink → Push to brand settings
│   ├── TeamLink → Push to team management
│   └── BillingLink → Push to billing
├── NotificationGroup
│   ├── PushToggle
│   ├── EmailToggle
│   └── QuietHoursLink
├── AppGroup
│   ├── DarkModeSelector (Light/Dark/Auto)
│   ├── LanguageSelector
│   ├── VideoQualitySelector
│   └── CacheClearButton
├── AccountGroup
│   ├── ChangePasswordLink
│   ├── DeleteAccountLink (danger zone)
│   └── LogoutButton
└── VersionInfo
```

| # | Action | Trigger | Result |
|---|---|---|---|
| 1 | Edit profile | Tap profile section | Push → Profile editor |
| 2 | Toggle push | Switch | `SettingsService/Update(push_enabled)` |
| 3 | Clear cache | "Xóa cache" | Cache cleared, size resets |
| 4 | Logout | "🚪 Đăng xuất" → confirm | → Login screen |
| 5 | Delete account | "🗑 Xóa" → multi-step confirm | Account deletion flow |

### Flutter Implementation
- Widget: `SettingsPage extends ConsumerWidget`
- Sections: `ListView` with `ListTile` items
- Toggles: `Switch` widget
- Dark mode: `ThemeMode` provider

### Related Screens: [W08] Web Settings Hub

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
SettingsScreen
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

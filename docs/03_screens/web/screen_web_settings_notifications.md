# Screen: Web — Settings: Notifications

> **Screen ID**: W126
> **Module**: M26 — Settings
> **Route**: `/settings/notifications`
> **Platform**: Web (SvelteKit)
> **Upstream**: PRD §27 Settings, A1 Schema (notification_preferences, notification_channels), B5 RBAC §2.9

---

## 1. Purpose & Context

Notification preferences — granular control over push, email, and in-app notifications per event type. Includes quiet hours, email digest frequency, and team mention controls.

### User Goals
- Control which events trigger notifications and on which channels
- Set quiet hours to avoid non-urgent alerts at night
- Configure email digest vs real-time delivery
- Silence low-priority notifications without losing important ones

### Business Goals
- Reduce notification fatigue (improves retention)
- Ensure critical alerts (orders, errors, security) always reach users
- Support team collaboration through mention notifications

### Entry Points
- Sidebar: Settings → "🔔 Thông báo"
- Notification bell → "⚙️ Settings"

### Exit Points
- Self-contained settings page

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Settings   🔔 Cài đặt thông báo                                  │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Notification Channels ──────────────────────────────────────┐    │
│ │ Event Type           │ 📱 Push │ 📧 Email │ 🔔 In-App │     │    │
│ │ ─────────────────────┼─────────┼──────────┼───────────│      │    │
│ │ — Commerce —                                                  │    │
│ │ 📦 New order         │ [🟢]    │ [🟢]     │ [🟢]      │     │    │
│ │ 📦 Order cancelled   │ [🟢]    │ [🟢]     │ [🟢]      │     │    │
│ │ 💰 Settlement received│ [🔴]   │ [🟢]     │ [🟢]      │     │    │
│ │                                                                │    │
│ │ — Content & Publish —                                          │    │
│ │ 💬 Comment reply     │ [🟢]    │ [🔴]     │ [🟢]      │     │    │
│ │ 📤 Publish success   │ [🟢]    │ [🔴]     │ [🟢]      │     │    │
│ │ 📤 Publish failed    │ [🟢]    │ [🟢]     │ [🟢]      │     │    │
│ │                                                                │    │
│ │ — AI & Automation —                                            │    │
│ │ 🤖 AI generation done│ [🟢]    │ [🔴]     │ [🟢]      │     │    │
│ │ ⚡ Workflow error     │ [🟢]    │ [🟢]     │ [🟢]      │     │    │
│ │ ✅ Approval needed   │ [🟢]    │ [🟢]     │ [🟢]      │     │    │
│ │                                                                │    │
│ │ — Creator Pro —                                                │    │
│ │ 📩 Brand inquiry     │ [🟢]    │ [🟢]     │ [🟢]      │     │    │
│ │ 🤝 Deal update       │ [🟢]    │ [🟢]     │ [🟢]      │     │    │
│ │                                                                │    │
│ │ — System —                                                     │    │
│ │ 🪙 Credit low        │ [🔴]    │ [🟢]     │ [🟢]      │     │    │
│ │ 🔐 Security alert     │ [🟢]    │ [🟢]     │ [🟢]  🔒  │    │    │
│ │ 📊 Weekly report     │ [🔴]    │ [🟢]     │ [🔴]      │     │    │
│ │ 👥 Team mention      │ [🟢]    │ [🟢]     │ [🟢]      │     │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Quiet Hours ────────────────────────────────────────────────┐    │
│ │ Enable: [🟢 ON]                                               │    │
│ │ From: [22:00] To: [07:00]                                     │    │
│ │ Timezone: Asia/Ho_Chi_Minh (from workspace settings)          │    │
│ │ Exception: [☑ Urgent alerts always notify]                    │    │
│ │ Urgent = Security alerts, order fraud, publish failure        │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Email Digest ───────────────────────────────────────────────┐    │
│ │ Frequency: [○ Real-time] [● Daily digest 9AM] [○ Weekly Mon]  │   │
│ │ Preview: "Gộp email thành 1 email tóm tắt/ngày thay vì gửi  │   │
│ │ từng email riêng. Không áp dụng cho urgent."                  │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Team Notifications ─────────────────────────────────────────┐    │
│ │ Mentions: [🟢 ON] — Notify when @mentioned in comments       │    │
│ │ Task assignments: [🟢 ON] — Notify when assigned a task       │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [💾 Lưu thay đổi]   [🔄 Reset to defaults]                        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
NotificationSettingsPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Settings")
│   └── PageTitle ("🔔 Cài đặt thông báo")
├── NotificationChannelsTable
│   ├── CategoryGroup[] (Commerce, Content, AI, Creator, System)
│   │   └── EventRow[]
│   │       ├── EventIcon + EventName
│   │       ├── PushToggle
│   │       ├── EmailToggle
│   │       ├── InAppToggle
│   │       └── LockIcon (if mandatory — 🔐 Security always enabled)
├── QuietHoursSection
│   ├── EnableToggle
│   ├── FromTime + ToTime
│   ├── TimezoneLabel (from workspace settings)
│   ├── UrgentExceptionToggle
│   └── UrgentDefinition (info text)
├── EmailDigestSection
│   └── FrequencyRadioGroup (Real-time, Daily, Weekly)
├── TeamNotificationsSection
│   ├── MentionsToggle
│   └── TaskAssignmentsToggle
├── ActionBar
│   ├── SaveButton
│   └── ResetDefaultsButton
```

---

## 5. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Toggle notification | Click toggle | Auto-save | Preference stored | Any |
| 2 | Set quiet hours | Configure times | Auto-save | Quiet hours active | Any |
| 3 | Change email digest | Select frequency | Auto-save | Delivery method updated | Any |
| 4 | Reset to defaults | "🔄 Reset" → confirm | `NotificationService/ResetPreferences` | All toggles reset | Any |
| 5 | Save | "💾 Lưu" | `NotificationService/SavePreferences` | Confirmation toast | Any |

---

## 6. Mandatory Notifications (Cannot Disable)

| Event | Reason | Channels |
|---|---|---|
| 🔐 Security alert | Account safety | All (Push + Email + In-App) |
| 🔴 Account suspension | Legal/compliance | Email + In-App |
| 💳 Payment failure | Billing continuity | Email + In-App |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching preferences | Toggle grid skeleton |
| LOADED | Preferences loaded | Interactive toggle table |
| SAVING | Auto-saving or manual save | Brief spinner |
| SAVED | Just saved | Toast: "✅ Thông báo đã cập nhật" |
| ERROR | Save failed | Error with retry |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached preferences | Retry online |
| Toggle auto-save fail | API error on toggle change | Toggle reverts + toast: "Không lưu được. [Thử lại]" | Retry |
| Quiet hours conflict | From > To (cross-midnight) | Info: "Áp dụng qua nửa đêm (22:00 → 07:00+1)" | Auto-handle |
| Save fail | API error on manual save | Toast: "Không lưu được. [Thử lại]" | Retry |
| Push not supported | Browser doesn't support push | Push column disabled: "Push không khả dụng trên trình duyệt này" | N/A |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Toggle table | `role="table"`, `aria-label="Notification preferences by channel"` |
| Category rows | `role="rowgroup"`, `aria-label="{category}"` |
| Toggle buttons | `role="switch"`, `aria-checked`, `aria-label="{event}: {channel} notifications {on/off}"` |
| Locked toggles | `aria-disabled="true"`, `aria-label="Security alerts: always enabled"` |
| Quiet hours | Time inputs with `aria-label="Quiet hours from"` / `"to"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Toggle grid skeleton |
| Preferences | 200-400ms | Toggles populate with current state |
| Quiet hours | 200-400ms | Time inputs + toggle populate |
| Digest config | 200-400ms | Radio group populates |
| Toggle save | <200ms | Brief inline spinner |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `notification_settings.viewed` | Page load | `enabled_count`, `disabled_count` |
| `notification_settings.toggled` | Toggle change | `event_type`, `channel`, `new_value` |
| `notification_settings.quiet_hours_changed` | Quiet hours updated | `enabled`, `from`, `to` |
| `notification_settings.digest_changed` | Digest frequency changed | `old_frequency`, `new_frequency` |
| `notification_settings.mentions_toggled` | Mentions toggle | `new_value` |
| `notification_settings.tasks_toggled` | Task assignments toggle | `new_value` |
| `notification_settings.reset_defaults` | "🔄 Reset" | — |
| `notification_settings.saved` | "💾 Lưu" | `changes_count` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/settings/notifications/+page.svelte`
- **Server load**: `+page.server.ts` → `NotificationService/GetPreferences(user_id)` + `NotificationService/GetQuietHours`
- **Toggle**: Individual `fetch()` per toggle change (auto-save) → optimistic UI with revert on error
- **Quiet hours**: `NotificationService/UpdateQuietHours(from, to, timezone, urgentException)` → server validates cross-midnight
- **Digest**: `NotificationService/UpdateDigestFrequency(frequency)` → affects email batching job
- **Mandatory**: Server enforces mandatory events; client shows 🔒 + `disabled` attribute
- **Save**: Explicit "💾 Lưu" flushes any pending unsaved changes
- **Reset**: Confirm → `NotificationService/ResetPreferences(user_id)` → all toggles revert to defaults

---

## 13. Localization Notes

- Categories: "Thương mại", "Nội dung & Xuất bản", "AI & Tự động", "Creator Pro", "Hệ thống"
- Events: Vietnamese ("Đơn hàng mới", "Bình luận mới", "Xuất bản thành công")
- Channels: "📱 Push", "📧 Email", "🔔 Trong app"
- Quiet hours: "Giờ yên tĩnh", "Ngoại trừ: thông báo khẩn luôn gửi"
- Digest: "Gửi ngay", "Gộp hàng ngày 9h sáng", "Gộp hàng tuần (Thứ 2)"
- Tone: Personal, control-focused

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-toggle-on` | 🟢 Toggle enabled |
| `--color-toggle-off` | 🔴 Toggle disabled |
| `--color-toggle-locked` | 🔒 Mandatory toggle (grey, non-interactive) |
| `--color-surface-elevated` | Section cards |
| `--color-accent` | Save CTA |
| `--color-text-secondary` | Help text, category headers |
| `--color-border` | Category separators |
| `--color-quiet-hours` | Quiet hours indicator |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W120] Workspace Settings | Timezone for quiet hours |
| [M043] Mobile Notifications | Mobile equivalent |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (auto-save fail, quiet hours), toggle table a11y, 8 analytics, SvelteKit impl (auto-save, quiet hours), localization, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

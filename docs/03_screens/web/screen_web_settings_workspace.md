# Screen: Web — Settings: Workspace

> **Screen ID**: W114
> **Module**: M23 — Settings
> **Route**: `/settings/workspace`
> **Platform**: Web (SvelteKit)
> **Upstream**: PRD §34, A1 Schema (workspaces, connected_accounts), B5 RBAC §2.9

---

## 1. Purpose & Context

Workspace general settings — name, logo, timezone, language, default currency, and connected platforms overview. Foundation configuration for the entire workspace that affects all modules and users.

### User Goals
- Update workspace identity (name, logo, branding)
- Set correct timezone for analytics and scheduling
- Configure default language and currency
- Overview of connected platforms
- Delete workspace if no longer needed

### Business Goals
- Ensure correct timezone for publish scheduling and analytics
- Default currency for consistent financial display
- Brand identity for customer-facing elements (invoices, media kit)

### Entry Points
- Sidebar: Settings → "🏢 Workspace"
- Onboarding: step 1 "Set up your workspace"

### Exit Points
- "+ Kết nối nền tảng" → Connected Accounts (W117)
- "🗑 Xóa workspace" → deletion flow (destructive, requires confirmation)

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `workspace:settings:manage` permission (Owner, Admin)
- Workspace exists and is active

### Postconditions
- Name/logo changes reflected across all UI immediately
- Timezone change affects all scheduled publishes and analytics periods
- Currency change affects all financial displays (existing data unchanged)

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Settings   🏢 Workspace                                           │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ General ─────────────────────────────────────────────────────┐   │
│ │ Workspace name: [Creativanta Studio                   ]       │   │
│ │ URL slug: creativanta-studio (read-only)                      │   │
│ │ Logo: [Upload ▾] Preview: [🖼 64×64]                         │   │
│ │ Description: [Multi-line textarea — about your workspace]     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Regional ────────────────────────────────────────────────────┐   │
│ │ Timezone: [Asia/Ho_Chi_Minh (UTC+7) ▾]                       │   │
│ │ ⚠️ Thay đổi timezone sẽ ảnh hưởng lịch publish.              │   │
│ │ Default language: [Tiếng Việt ▾]                               │   │
│ │ Default currency: [VND ▾]                                      │   │
│ │ Date format: [DD/MM/YYYY ▾]                                    │   │
│ │ Week starts on: [Monday ▾]                                     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Connected Platforms (quick overview) ────────────────────────┐   │
│ │ 🎵 TikTok · @quancreator · [🟢 Connected]                   │   │
│ │ 📸 Instagram · @quanm · [🟢 Connected]                       │   │
│ │ ▶️ YouTube · Quân Channel · [🟢 Connected]                   │   │
│ │ 🛍 TikTok Shop · [🟢 Connected]                              │   │
│ │ [→ Quản lý kết nối chi tiết]                                  │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Danger Zone ─────────────────────────────────────────────────┐   │
│ │ ⚠️ Vùng nguy hiểm                                             │   │
│ │ [🔄 Reset workspace data] — Xóa toàn bộ dữ liệu, giữ cài đặt│  │
│ │ [🗑 Xóa workspace] — Xóa vĩnh viễn, không thể khôi phục     │   │
│ │ Requires: type workspace name + password confirmation          │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [💾 Lưu thay đổi]                                                   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
WorkspaceSettingsPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Settings")
│   └── PageTitle ("🏢 Workspace")
├── GeneralSection
│   ├── NameInput (required)
│   ├── URLSlug (read-only, auto-generated)
│   ├── LogoUpload (64×64, max 2MB, PNG/JPG/SVG)
│   ├── LogoPreview
│   └── DescriptionTextarea (optional, max 500 chars)
├── RegionalSection
│   ├── TimezoneSelector (with warning on change)
│   ├── LanguageSelector
│   ├── CurrencySelector
│   ├── DateFormatSelector
│   └── WeekStartSelector
├── ConnectedPlatformsOverview
│   ├── PlatformRow[] (icon, name, handle, status)
│   └── ManageConnectionsLink (→ W117)
├── DangerZone
│   ├── ResetDataButton (→ confirmation modal)
│   └── DeleteWorkspaceButton (→ type-to-confirm + password)
└── SaveButton
```

---

## 5. Validation Rules

| Field | Rule | Error |
|---|---|---|
| Workspace name | Required, 2-100 chars | "Tên workspace phải từ 2-100 ký tự" |
| Logo | Max 2MB, PNG/JPG/SVG only | "File quá lớn (max 2MB)" or "Định dạng không hỗ trợ" |
| Description | Optional, max 500 chars | "Mô tả tối đa 500 ký tự" |
| Delete confirm | Must type exact workspace name | "Tên không khớp — vui lòng nhập chính xác" |
| Delete confirm | Must enter current password | "Mật khẩu không đúng" |

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Form skeleton |
| LOADED | Ready to edit | Editable form with current values |
| SAVING | Save in progress | Save button spinner |
| SAVED | Just saved | Toast: "✅ Workspace đã cập nhật" |
| DELETE_CONFIRMING | Delete dialog open | Modal with type-to-confirm + password |
| ERROR | Save failed | Error with retry |

---

## 7. Permissions

| Feature | Owner | Admin | Manager+ |
|---|---|---|---|
| View settings | ✅ | ✅ | ❌ |
| Edit general | ✅ | ✅ | ❌ |
| Change timezone/currency | ✅ | ✅ | ❌ |
| Reset data | ✅ | ❌ | ❌ |
| Delete workspace | ✅ | ❌ | ❌ |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached form data | Retry online |
| Logo upload fail | File too large / bad format | Inline: "File quá lớn (max 2MB)" or "Định dạng không hỗ trợ (PNG/JPG/SVG)" | Re-select |
| Save fail | API error | Toast: "Không lưu được. [Thử lại]" | Retry |
| Timezone propagation | Timezone change affects scheduled items | Warning modal: "⚠️ Thay đổi timezone sẽ ảnh hưởng {n} bài đã lên lịch. Tiếp tục?" | Confirm/Cancel |
| Delete workspace fail | server error / password mismatch | "Mật khẩu không đúng" or "Không xóa được. [Thử lại]" | Re-enter password |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Form sections | `role="group"`, each with `aria-labelledby="section-title-id"` |
| Input fields | `<label>` linked via `for`, error messages via `aria-describedby` |
| Logo upload | `aria-label="Upload workspace logo"`, drag area `role="button"` |
| Danger zone | `role="region"`, `aria-label="Danger zone — destructive actions"` |
| Platform overview | `role="list"`, each platform `role="listitem"` with `aria-label="{name}: {status}"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Form skeleton with section outlines |
| Workspace data | 200-400ms | Fields populate with current values |
| Logo load | 300-600ms | Logo preview appears |
| Connectors overview | 400-800ms | Platform badges appear |
| Save | 500-2000ms | Button spinner → toast |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `settings_workspace.viewed` | Page load | `source` |
| `settings_workspace.name_changed` | Save with new name | `old_name`, `new_name` |
| `settings_workspace.logo_changed` | Logo uploaded | `file_type`, `file_size` |
| `settings_workspace.timezone_changed` | Timezone updated | `old_tz`, `new_tz`, `scheduled_items_affected` |
| `settings_workspace.currency_changed` | Currency updated | `old_currency`, `new_currency` |
| `settings_workspace.language_changed` | Language updated | `old_lang`, `new_lang` |
| `settings_workspace.reset_initiated` | "Reset workspace data" confirmed | `data_size` |
| `settings_workspace.delete_initiated` | "Xóa workspace" confirmed | `member_count`, `content_count` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/settings/workspace/+page.svelte`
- **Server load**: `+page.server.ts` → `WorkspaceService/Get(id)` + `ConnectorService/ListConnected(workspace_id)`
- **Form**: Standard `<form>` with `copilot:use_creative` for progressive enhancement
- **Logo upload**: `FormData` with `fetch()` → `WorkspaceService/UploadLogo(file)` → returns CDN URL
- **Timezone selector**: Searchable dropdown with `Intl.supportedValuesOf('timeZone')` grouped by region
- **Validation**: Client-side + server-side (revalidate on submit)
- **Delete flow**: Server action → requires password re-entry → `WorkspaceService/Delete(id, password)` → redirect to `/`
- **Save**: Single "Lưu thay đổi" button (not auto-save, due to timezone impact)

---

## 13. Localization Notes

- Labels: "Tên workspace", "Mô tả", "Múi giờ", "Ngôn ngữ mặc định", "Tiền tệ"
- Buttons: "💾 Lưu thay đổi", "🗑 Xóa workspace", "🔄 Reset dữ liệu"
- Warnings: Vietnamese (destructive actions use formal tone)
- Timezone: Display as "Asia/Ho_Chi_Minh (UTC+7)"
- Tone: Neutral, administrative

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Save button, CTA |
| `--color-danger` | Danger zone border, delete button |
| `--color-warning` | Timezone change warning |
| `--color-success` | "✅ Workspace đã cập nhật" toast |
| `--color-surface-elevated` | Form section cards |
| `--color-border` | Section separators |
| `--color-text-primary` | Labels, values |
| `--color-text-secondary` | Help text, slug |
| `--color-surface-danger` | Danger zone background (red 5% opacity) |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W117] Connected Accounts | Platform connection management |
| [W115] Member Management | Team management |
| [W119] Billing & Plans | Plan and payment |
| [W122] Notification Preferences | Notification preferences |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (timezone propagation, logo fail), form/danger a11y, 8 analytics, SvelteKit impl (form enhance, delete flow), localization, 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

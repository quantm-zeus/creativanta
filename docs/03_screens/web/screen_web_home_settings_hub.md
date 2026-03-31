# Screen: Web — Settings Page

> **Screen ID**: W08
> **Module**: M01 — Home & Decision / M23 Settings
> **Route**: `/settings`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §31

---

## 1. Purpose & Context

Settings hub — the navigation page for all workspace and account configuration. Shows a sidebar with settings categories and a main content area for the selected category.

### User Story
> As a creator, I want to configure my workspace settings, manage my team, and customize my experience.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ⚙️ Cài đặt                                                         │
├─ Settings Nav (250px) ──────────┬─ Settings Content ─────────────────┤
│                                  │                                    │
│ 🏢 Workspace                    │ ── General ──                     │
│ ├── ⚙️ General                  │ ┌─ Workspace Info ──────────────┐│
│ ├── 👥 Team                     │ │ Name: [Creativanta HQ      ]  ││
│ ├── 🔐 Roles & Permissions     │ │ Industry: [Beauty ▾]          ││
│ ├── 🔗 Connectors              │ │ Timezone: [GMT+7 ▾]           ││
│ └── 🎨 Brand Kit               │ │ Language: [Tiếng Việt ▾]      ││
│                                  │ │ Logo: [📸 Upload]             ││
│ 👤 Account                      │ │ [💾 Lưu]                      ││
│ ├── 📋 Profile                  │ └──────────────────────────────┘│
│ ├── 🔒 Security                 │                                  │
│ ├── 🔔 Notifications           │ ┌─ Operator Mode ──────────────┐│
│ └── 🌐 Language                 │ │ [✅ Creator] [✅ Seller]      ││
│                                  │ │ [☐ Brand]                    ││
│ 💰 Billing                      │ └──────────────────────────────┘│
│ ├── 📊 Plan & Usage            │                                  │
│ ├── 💳 Payment Method           │ ┌─ Danger Zone ────────────────┐│
│ ├── 📜 Invoices                 │ │ [🗑 Xóa workspace]            ││
│ └── 🎟 AI Credits               │ │ [📤 Export data]              ││
│                                  │ └──────────────────────────────┘│
│ 🤖 AI & Automation              │                                  │
│ ├── 🗣 Brand Voice              │                                    │
│ ├── 📝 Auto-rules               │                                    │
│ └── 🔧 API Keys                 │                                    │
│                                  │                                    │
│ 📊 Data                         │                                    │
│ ├── 📥 Import                   │                                    │
│ └── 📤 Export                    │                                    │
└──────────────────────────────────┴───────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
SettingsPage
├── AppShell (shared)
├── SettingsLayout
│   ├── SettingsSidebar (250px)
│   │   └── SettingsNavGroup[]
│   │       ├── GroupTitle (Workspace / Account / Billing / AI / Data)
│   │       └── NavItem[] (icon + label, active state)
│   └── SettingsContent (remaining width)
│       ├── GeneralSettings (default)
│       ├── TeamSettings
│       ├── RolesSettings
│       ├── ConnectorSettings [W92]
│       ├── BrandKitSettings
│       ├── ProfileSettings
│       ├── SecuritySettings
│       ├── NotificationSettings
│       ├── PlanSettings
│       ├── PaymentSettings
│       ├── InvoiceSettings
│       ├── CreditSettings
│       ├── BrandVoiceSettings
│       ├── AutoRulesSettings
│       ├── APIKeySettings
│       ├── ImportSettings
│       └── ExportSettings
```

---

## 4-5. Data & Actions

General Settings is the default view. Each sub-section has its own data and actions documented in respective screen files (W89-W100).

| # | Action | Trigger | Result | Permission |
|---|---|---|---|---|
| 1 | Navigate to section | Click sidebar item | Content area updates | `settings:read` |
| 2 | Save settings | "💾 Lưu" on any section | Update API call | `settings:update` |
| 3 | Delete workspace | "🗑 Xóa workspace" → multi-step confirm | Workspace deleted | `settings:danger` |

---

## 6-20. Standard Sections

### States
| State | Visual |
|---|---|
| LOADING | Form skeletons in content area |
| LOADED | Active section form |
| SAVING | Save button loading |
| SAVED | Toast "Đã lưu ✅" |

### Permission Matrix
| Section | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| General | ✅ | ✅ | ✅ (read) | ❌ | ❌ | ❌ |
| Team | ✅ | ✅ | ✅ (read) | ❌ | ❌ | ❌ |
| Billing | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| My Profile | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Danger Zone | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

### Technical Notes
- Route: `src/routes/(app)/settings/+layout.svelte` (shared layout)
- Sub-pages: `src/routes/(app)/settings/[section]/+page.svelte`
- Active nav: determined by `$page.route`

### Related Screens
| Screen | Relationship |
|---|---|
| [W89-W100] Individual settings pages | Children |
| [M07-M10] Mobile settings | Mobile equivalents |

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached settings | Retry online |
| Save fail | API error on save | Toast: "Không lưu được. [Thử lại]" | Retry (form preserved) |
| Delete fail | Workspace delete error | Alert: "Không xóa được workspace." | Contact support |
| Permission denied | Unauthorized section | Section disabled with lock icon + tooltip | Contact admin |
| Export fail | Data export error | Toast: "Không xuất được dữ liệu. [Thử lại]" | Retry |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Settings sidebar | `role="navigation"`, `aria-label="Settings navigation"` |
| Nav items | `role="link"`, active state with `aria-current="page"` |
| Form fields | All with `aria-label`, validation errors with `aria-describedby` |
| Danger zone | `role="region"`, `aria-label="Danger zone — irreversible actions"` |
| Save button | `aria-label="Save {section} settings"` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Sidebar + form skeleton |
| Section load | 200-400ms | Form fields populate |
| Save | 500-1000ms | Button loading → "Đã lưu ✅" toast |
| Section switch | 100-300ms | Content area updates |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `settings.viewed` | Page load | `section` |
| `settings.section_changed` | Sidebar nav click | `from_section`, `to_section` |
| `settings.saved` | "💾 Lưu" | `section`, `changed_fields` |
| `settings.mode_changed` | Operator mode toggled | `modes` |
| `settings.export_started` | "📤 Export data" | `format` |
| `settings.delete_initiated` | "🗑 Xóa workspace" | `step` (confirm1/confirm2) |
| `settings.team_member_invited` | Team invite sent | `role` |
| `settings.connector_connected` | Platform connected | `platform` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/settings/+layout.svelte` (shared sidebar layout)
- **Sub-pages**: `src/routes/(app)/settings/[section]/+page.svelte`
- **Active nav**: Determined by `$page.route.id` matching sidebar items
- **Save**: Per-section `WorkspaceService/Update{Section}(data)` — form state tracked for unsaved changes warning
- **Danger zone**: Multi-step confirmation: type workspace name → 30s cooldown → final confirm
- **Permissions**: Server-side layout load checks `RBAC/CheckPermission(section)` — unauthorized sections hidden

---

## 12. Localization Notes

- Groups: "Workspace", "Tài khoản", "Thanh toán", "AI & Tự động", "Dữ liệu"
- Actions: "Lưu", "Xóa workspace", "Xuất dữ liệu"
- Danger: "Hành động không thể hoàn tác. Gõ tên workspace để xác nhận."
- Tone: Neutral, configuration-focused

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Save CTA, active nav |
| `--color-danger` | Danger zone, delete button |
| `--color-success` | Saved confirmation |
| `--color-nav-active` | Active sidebar item |
| `--color-surface-elevated` | Form sections |
| `--color-border` | Section dividers |
| `--radius-card` | Form cards |

---

## 14. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (save, delete), sidebar/form a11y, 8 analytics, SvelteKit impl (layout, danger zone, permissions), localization, 7 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

# Screen: Web — Connected Account Detail

> **Screen ID**: W118
> **Module**: M26 — Settings (Connections)
> **Route**: `/settings/connections/[id]`
> **Platform**: Web (SvelteKit)
> **Upstream**: PRD §M22, A1 Schema (connected_accounts, sync_logs, oauth_tokens), B5 RBAC §2.9

---

## 1. Purpose & Context

Deep settings for a connected platform account — sync frequency per data type, data retention policies, OAuth token management, capability status, and sync history with error logs.

### User Goals
- Configure sync frequency per data type (posts, orders, analytics)
- Monitor token health and expiration
- View sync history with success/failure details
- Control data retention after disconnect

### Entry Points
- Connectors list (W117): click on a connected account
- Diagnostics (W128): "Configure" on issue

### Exit Points
- "← Connections" → Connectors list
- "🔌 Disconnect" → confirmation → back to list

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Connections   🎵 TikTok @creativanta_studio               [⋮]   │
├──────────────────────────────────────────────────────────────────────┤
│ Tabs: [⚙ Sync Settings] [📊 Capabilities] [🔑 Token] [📋 History]│
│                                                                      │
│ ── ⚙ Sync Settings Tab ──                                          │
│ ┌─ Sync Frequency ─────────────────────────────────────────────┐    │
│ │ Data Type    │ Frequency                    │ Last Sync       │    │
│ │ Posts        │ [● 15min] [○ 30min] [○ 1h]  │ 5 min ago ✅   │    │
│ │ Comments     │ [● 15min] [○ 30min] [○ 1h]  │ 12 min ago ✅  │    │
│ │ Orders       │ [● 5min] [○ 15min] [○ 30min]│ 2 min ago ✅   │    │
│ │ Analytics    │ [○ 1h] [● 6h] [○ Daily]     │ 3h ago ✅      │    │
│ │ Shop products│ [○ 1h] [● 6h] [○ Daily]     │ 1h ago ✅      │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Data Retention ─────────────────────────────────────────────┐    │
│ │ Keep synced data: [● 90 days] [○ 180 days] [○ Forever]      │    │
│ │ On disconnect: [☑ Delete all synced data from Creativanta]   │    │
│ │ ⚠️ Data xóa là vĩnh viễn, không thể khôi phục.              │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── 🔑 Token Tab ──                                                   │
│ ┌─ OAuth Token Status ─────────────────────────────────────────┐    │
│ │ Status: 🟢 Valid · Issued: 15/1/2026 · Expires: 25/6/2026   │    │
│ │ Remaining: 89 days [██████████████████████░░░] 74%            │    │
│ │ Scopes: [✅ read] [✅ write] [✅ analytics] [✅ commerce]    │    │
│ │ [🔄 Re-authorize (renew token)] [🔌 Disconnect]              │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── 📋 History Tab ──                                                 │
│ ┌─ Recent Syncs ───────────────────────────────────────────────┐    │
│ │ 28/3 12:05 │ Posts    │ ✅ 3 new, 0 updated │ 0.8s          │    │
│ │ 28/3 12:00 │ Orders  │ ✅ 1 new order      │ 0.3s           │    │
│ │ 28/3 11:45 │ Comments│ ✅ 12 new           │ 1.2s           │    │
│ │ 28/3 06:00 │ Analytics│ ✅ Daily update     │ 3.5s           │    │
│ │ 27/3 18:00 │ Orders  │ ❌ API timeout      │ 30s            │    │
│ │            │          │ Auto-retry: ✅ success (18:01)       │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [💾 Lưu cài đặt]                                                    │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Tab skeletons |
| LOADED | Data received | Editable settings tabs |
| TOKEN_EXPIRING | Token expires < 30 days | Orange: "⚠️ Token hết hạn trong {days} ngày. [🔄 Gia hạn]" |
| TOKEN_EXPIRED | Token invalid | Red: "🔴 Token đã hết hạn. [🔄 Re-authorize]" |
| SYNC_FAILING | Last 3+ syncs failed | Red: "🔴 Sync liên tục lỗi. Kiểm tra token hoặc API status." |
| DISCONNECTING | Disconnect in progress | Confirmation modal → removal |
| ERROR | API failed | Error with retry |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached detail | Retry online |
| Sync settings save fail | API error | Toast: "Không lưu cài đặt sync. [Thử lại]" | Retry |
| Re-authorize popup blocked | Browser blocks OAuth popup | Toast: "Popup bị chặn. Cho phép popup → thử lại" | Allow popup |
| Disconnect fail | API error during disconnect | Toast: "Không ngắt được kết nối. [Thử lại]" | Retry |
| Sync history load fail | Paginated history timeout | "Không tải được lịch sử. [Thử lại]" | Retry |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Tab navigation | `role="tablist"`, each tab `role="tab"` with `aria-selected` |
| Sync frequency table | `role="table"`, `aria-label="Sync frequency settings"` |
| Token progress bar | `role="progressbar"`, `aria-valuenow`, `aria-label="Token expires in 89 days (74%)"` |
| Scope badges | `aria-label="{scope}: granted"` |
| Sync history log | `role="log"`, entries with `aria-label="{time}: {type} → {result}"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Tab bar + skeleton |
| Sync settings | 200-400ms | Frequency rows populate |
| Token status | 200-500ms | Token bar + scopes appear |
| Sync history | 300-700ms | History rows stagger |
| Active tab content | <200ms | Tab swap (no reload) |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `connector_detail.viewed` | Page load | `platform`, `tab`, `token_days_remaining` |
| `connector_detail.sync_frequency_changed` | Frequency radio changed | `data_type`, `old_freq`, `new_freq` |
| `connector_detail.retention_changed` | Retention radio changed | `old_retention`, `new_retention` |
| `connector_detail.reauthorize` | "🔄 Re-authorize" | `platform`, `token_age_days` |
| `connector_detail.disconnect_started` | "🔌 Disconnect" | `platform`, `data_retained` |
| `connector_detail.disconnect_confirmed` | Confirmation accepted | `platform`, `delete_data` |
| `connector_detail.history_viewed` | Switch to History tab | `platform`, `recent_failure_count` |
| `connector_detail.settings_saved` | "💾 Lưu cài đặt" | `platform`, `changes_count` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/settings/connections/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → `ConnectorService/Get(id)` + `SyncService/GetHistory(id, page)` + `TokenService/GetStatus(id)`
- **Tabs**: URL hash `#sync`, `#capabilities`, `#token`, `#history` (no reload)
- **Sync frequency**: `ConnectorService/UpdateSyncConfig(id, config)` → affects background job scheduler
- **Re-authorize**: OAuth popup flow (same as W117)
- **Disconnect**: Confirm modal with "delete data" checkbox → `ConnectorService/Disconnect(id, { deleteData })` → redirect to W117
- **Sync history**: Cursor-paginated, 20 per page, with auto-retry entries nested
- **Data retention**: `ConnectorService/UpdateRetentionPolicy(id, days)`

---

## 13. Localization Notes

- Tabs: "⚙ Đồng bộ", "📊 Khả năng", "🔑 Token", "📋 Lịch sử"
- Frequency: "15 phút", "30 phút", "1 giờ", "6 giờ", "Hàng ngày"
- Retention: "90 ngày", "180 ngày", "Mãi mãi"
- Token: "Còn 89 ngày", "Hết hạn: 25/6/2026"
- Scopes: English (`read`, `write`, `analytics`, `commerce`)
- Tone: Technical, configuration-focused

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-token-valid` | 🟢 Token valid (green) |
| `--color-token-expiring` | 🟡 Token expiring <30d (amber) |
| `--color-token-expired` | 🔴 Token expired (red) |
| `--color-sync-success` | ✅ Sync success (green) |
| `--color-sync-fail` | ❌ Sync failure (red) |
| `--color-surface-elevated` | Tab content, cards |
| `--color-accent` | Save CTA |
| `--color-danger` | Disconnect button, data deletion |
| `--color-border` | Table rows, separators |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W117] Connectors | Parent: platform list |
| [W119] Diagnostics Center | System health |
| [W058] Publish Diagnostics | Publish error logs |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (sync save, popup blocked), tab/table a11y, 8 analytics, SvelteKit impl (tabs, OAuth, retention), localization, 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

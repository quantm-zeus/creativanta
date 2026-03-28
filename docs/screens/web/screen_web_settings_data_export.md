# Screen: Web — Data Export & Account Deletion

> **Screen ID**: W-SET-16
> **Module**: M23 — Settings / Legal Compliance
> **Route**: `/settings/data`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 07 §Legal/Compliance, GDPR/PDPA requirements, A1 Schema (users, workspaces), B5 RBAC

---

## 1. Purpose & Context

GDPR/PDPA compliant screen for users to request data export (right to portability) and account/workspace deletion (right to erasure). This is a legal launch requirement.

### User Story
> As a user, I want to export all my data or delete my account/workspace so I can exercise my data rights.

### Business Goal
- Legal compliance (GDPR, PDPA Vietnam)
- User trust and transparency
- Minimize support overhead for data requests

### When to Use
- User wants to export their data
- User wants to delete their account or workspace
- User exercising PDPA/GDPR rights

### Entry Points
- Settings → "🔒 Quyền riêng tư & Dữ liệu"
- Account menu → "Quyền riêng tư"
- Support ticket → "Data Request" → deep link

### Exit Points
- Export generated → download link
- Deletion confirmed → logout → farewell screen
- Cancel → back to Settings

---

## 2. Preconditions / Postconditions

### Preconditions
- User is authenticated
- User is Owner of workspace (for workspace deletion)
- No active subscriptions blocking deletion (grace period rules)

### Postconditions
- **Export**: Async job created, download link emailed within 48h
- **Workspace Deletion**: 30-day grace period initiated, data marked for deletion
- **Account Deletion**: All workspaces transferred or deleted, account purged after 30 days
- Audit events logged for all operations

---

## 3. Layout Structure

### ASCII Wireframe
```
┌─ Settings Shell ─────────────────────────────────────────────────────┐
│ ← Cài đặt / 🔒 Quyền riêng tư & Dữ liệu                          │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ┌─ Data Export ───────────────────────────────────────────────────┐  │
│ │ 📥 Xuất dữ liệu của bạn                                       │  │
│ │                                                                 │  │
│ │ Tải về toàn bộ dữ liệu cá nhân và workspace. File được gửi   │  │
│ │ qua email trong vòng 48 giờ.                                   │  │
│ │                                                                 │  │
│ │ Bao gồm: Hồ sơ cá nhân · Nội dung · Đơn hàng · Tài chính ·  │  │
│ │ Tin nhắn · Cài đặt · Lịch sử hoạt động                        │  │
│ │                                                                 │  │
│ │ Format: [JSON ▾] [CSV ▾]                                       │  │
│ │                                                                 │  │
│ │ [📥 Yêu cầu xuất dữ liệu]                                    │  │
│ │                                                                 │  │
│ │ 📋 Lịch sử yêu cầu:                                           │  │
│ │ · 15/03/2026 — Hoàn tất — [📥 Tải về] (hết hạn 22/03)       │  │
│ │ · 01/02/2026 — Hết hạn tải                                    │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Consent Management ───────────────────────────────────────────┐  │
│ │ 🍪 Quản lý đồng ý                                              │  │
│ │                                                                 │  │
│ │ Cookies phân tích        [🟢 Đã đồng ý] [Rút lại]             │  │
│ │ AI data usage            [🔴 Chưa đồng ý] [Đồng ý]            │  │
│ │ Marketing emails          [🟢 Đã đồng ý] [Rút lại]             │  │
│ │ Personalization          [🟢 Đã đồng ý] [Rút lại]             │  │
│ │                                                                 │  │
│ │ Last updated: 15/03/2026 14:30                                 │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Danger Zone ──────────────────────────────────────────────────┐  │
│ │ ⚠️ Vùng nguy hiểm                                              │  │
│ │                                                                 │  │
│ │ 🗑 Xóa workspace "{workspace_name}"                            │  │
│ │ Toàn bộ dữ liệu workspace sẽ bị xóa sau 30 ngày.             │  │
│ │ Bạn sẽ không thể khôi phục.                                   │  │
│ │ [🗑 Xóa workspace]                                             │  │
│ │                                                                 │  │
│ │ 🗑 Xóa tài khoản hoàn toàn                                    │  │
│ │ Tất cả workspace, dữ liệu, nội dung sẽ bị xóa vĩnh viễn.   │  │
│ │ [🗑 Xóa tài khoản]                                            │  │
│ └─────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
DataPrivacyPage
├── AppShell (shared)
├── PageHeader
│   ├── Breadcrumb (Cài đặt / Quyền riêng tư)
│   └── Title
├── DataExportSection
│   ├── SectionHeader ("📥 Xuất dữ liệu")
│   ├── Description
│   ├── DataScopeList (what's included)
│   ├── FormatSelector (JSON / CSV)
│   ├── RequestExportButton
│   └── ExportHistoryList
│       └── ExportHistoryRow[]
│           ├── RequestDate
│           ├── StatusBadge (Processing / Ready / Expired)
│           ├── DownloadLink (if ready)
│           └── ExpiryNote
├── ConsentManagementSection
│   ├── SectionHeader ("🍪 Quản lý đồng ý")
│   └── ConsentRow[]
│       ├── ConsentLabel
│       ├── ConsentDescription
│       ├── StatusBadge (🟢/🔴)
│       └── ToggleButton (Grant / Revoke)
├── DangerZoneSection
│   ├── SectionHeader ("⚠️ Vùng nguy hiểm")
│   ├── WorkspaceDeletionCard
│   │   ├── WorkspaceName
│   │   ├── WarningText
│   │   └── DeleteWorkspaceButton (destructive)
│   └── AccountDeletionCard
│       ├── WarningText
│       └── DeleteAccountButton (destructive)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | Display Format | Cache |
|---|---|---|---|
| Export history | `data_export_requests` | Date + status + download link | No cache |
| Consent status | `user_consents` | Toggle buttons with green/red status | No cache |
| Workspace name | `workspaces.display_name` | String | Session |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Request data export | Click "Yêu cầu xuất dữ liệu" | `DataService/RequestExport(format)` | Creates export job | Toast "Yêu cầu đã tiếp nhận. Email sẽ được gửi trong 48h." | Owner/Admin |
| 2 | Download export | Click "📥 Tải về" | `DataService/GetExportUrl(id)` | — | Browser download starts | Owner/Admin |
| 3 | Grant consent | Click "Đồng ý" on consent row | `ConsentService/Grant(type)` | `consents.granted_at = now` | Toggle → 🟢 + Toast | Any authenticated |
| 4 | Revoke consent | Click "Rút lại" on consent row | `ConsentService/Revoke(type)` | `consents.revoked_at = now` | Toggle → 🔴 + Toast | Any authenticated |
| 5 | Delete workspace | Click "🗑 Xóa workspace" | — | — | Open WorkspaceDeletionModal | Owner only |
| 6 | Confirm workspace deletion | Type workspace name + click confirm | `WorkspaceService/InitiateDeletion` | `workspace.status = pending_deletion` | Redirect to workspace selector | Owner only |
| 7 | Delete account | Click "🗑 Xóa tài khoản" | — | — | Open AccountDeletionModal | Owner (all workspaces) |
| 8 | Confirm account deletion | Type "XÓA TÀI KHOẢN" + click confirm | `UserService/InitiateAccountDeletion` | `user.status = pending_deletion` | Logout + farewell page | Self only |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial page load | Shimmer sections |
| LOADED | All data available | Full page with sections |
| EXPORT_PROCESSING | Export job in progress | Spinner + "Đang xử lý..." in export row |
| EXPORT_READY | Export file available | Download link visible + expiry date |
| DELETION_PENDING | Workspace marked for deletion | Orange banner: "Workspace sẽ bị xóa ngày {date}. [Hủy xóa]" |
| DELETION_CONFIRMED | 30-day countdown started | Cannot undo after 7 days |
| ERROR | API failure | Toast with retry |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Workspace deletion confirmation | Must type exact workspace name | "Vui lòng nhập đúng tên workspace" |
| Account deletion confirmation | Must type "XÓA TÀI KHOẢN" exactly | "Vui lòng nhập đúng cụm từ xác nhận" |
| Export request | Max 1 pending request at a time | "Bạn đã có yêu cầu đang xử lý. Vui lòng đợi hoàn tất." |
| Consent changes | — | No validation needed |

### Business Validation
- Cannot delete workspace with active subscription (must cancel first)
- Cannot delete account if any workspace has no other Owner
- Export files expire after 7 days

---

## 9. Permission Matrix

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View page | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Request export | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Manage consents | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Delete workspace | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Delete account | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Data Privacy (/settings/data)
├── → Download export file (browser download)
├── → WorkspaceDeletionModal → Workspace Selector
├── → AccountDeletionModal → Farewell Page → Login
└── ← /settings (breadcrumb back)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Export job failed | Processing error | Email notification + retry option in history | "Thử lại" button |
| Deletion blocked | Active subscription | Modal: "Vui lòng hủy gói đăng ký trước. [Đi tới Billing →]" | Navigate to billing |
| Consent update failed | API error | Toast: "Không thể cập nhật. Thử lại." | Retry button |
| Rate limited | Too many requests | Toast: "Vui lòng thử lại sau" | Wait |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Destructive buttons | `aria-label` with full context, red styling NOT sole indicator |
| Confirmation dialogs | Focus trapped in modal, Escape to cancel |
| Consent toggles | Accessible toggle pattern with `aria-checked` |
| Export status | `aria-live="polite"` for status updates |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Page load | <500ms | SSR content, export history fetched client-side |
| Export request | 1-3s | Button spinner → success toast |
| Deletion confirmation | 2-5s | Modal spinner → redirect |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| LCP | <1.5s |
| CLS | 0 |
| Bundle | <20KB page-specific |

---

## 15. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| Export status | Polling | 30s (while processing) |
| Deletion countdown | Client timer | 1s (countdown display) |

---

## 16. Localization Notes

- "XÓA TÀI KHOẢN" confirmation text must be locale-specific
- Date format: DD/MM/YYYY (Vietnamese)
- Tone: Serious, clear, no ambiguity for destructive actions

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `privacy.viewed` | Page load | — |
| `privacy.export_requested` | Request export | `format` |
| `privacy.consent_changed` | Grant/revoke consent | `consent_type`, `action` |
| `privacy.deletion_initiated` | Confirm deletion | `type` (workspace/account) |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-danger` | Destructive buttons, danger zone border |
| `--color-warning` | Pending deletion banner |
| `--color-success` | Active consent status |
| `--color-border-danger` | Danger zone section border |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W119] Billing | Must cancel subscription before deletion |
| [W114] Workspace Settings | Parent settings group |
| [W010] Login | After account deletion → redirected here |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 1.0 | Initial specification — fills GDPR/PDPA compliance gap | System |

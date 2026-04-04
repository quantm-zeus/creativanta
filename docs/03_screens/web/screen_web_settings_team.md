# Screen: Web — Settings: Team & Roles

> **Screen ID**: W116
> **Module**: M23 — Settings
> **Route**: `/settings/team`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, impl_b5_rbac_permission_matrix, A1 Schema (workspace_members, roles)

---

## 1. Purpose & Context

Manage team members within a workspace: invite, assign roles, set permissions, and remove access. Supports Owner, Admin, Manager, Editor, Viewer, and custom roles.

### User Story
> As a workspace owner, I want to manage my team members and control what they can access.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Settings   👥 Đội ngũ & Phân quyền                               │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Invite ───────────────────────────────────────────────────────┐  │
│ │ [📧 Email: user@example.com        ] Role: [Editor ▾] [Mời]  │  │
│ │ Invite link: [creativanta.com/invite/abc123   📋 Copy]        │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Members (5) ──────────────────────────────────────────────────┐  │
│ │ [👤] Quân Nguyễn    quanm@gmail.com    [👑 Owner]             │  │
│ │ [👤] Lan Trần        lan@gmail.com      [🛡 Admin ▾] [✕ Remove]│  │
│ │ [👤] Minh Lê         minh@gmail.com     [📝 Editor ▾] [✕]     │  │
│ │ [👤] Thu Phạm        thu@gmail.com      [👁 Viewer ▾] [✕]     │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Pending Invitations (2) ──────────────────────────────────────┐  │
│ │ new@gmail.com — Editor — Sent 2h ago    [🔄 Resend] [✕ Cancel]│  │
│ │ test@company.com — Admin — Sent 1d ago  [🔄 Resend] [✕ Cancel]│  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Roles & Permissions ──────────────────────────────────────────┐  │
│ │ [📋 Xem bảng phân quyền chi tiết →]                          │  │
│ │ [+ Tạo role tùy chỉnh]                                        │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3-5. Component & Actions

```
TeamSettingsPage
├── AppShell
├── PageHeader
├── InviteSection (email input, role selector, invite button, share link)
├── MembersList
│   └── MemberRow[] (avatar, name, email, role dropdown, remove)
├── PendingInvitationsList
│   └── InviteRow[] (email, role, sent time, resend/cancel)
└── RolesSection (link to permissions matrix, custom role creation)
```

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Invite | "Mời" button | `WorkspaceService/InviteMember(email, role)` | Invitation sent | `workspace:members:invite` |
| 2 | Change role | Role dropdown | `WorkspaceService/UpdateMemberRole` | Role updated | `workspace:roles:assign` |
| 3 | Remove | "✕ Remove" → confirm | `WorkspaceService/RemoveMember` | Member removed | `workspace:members:remove` |
| 4 | Resend invite | "🔄 Resend" | `WorkspaceService/ResendInvite` | Email resent | `workspace:members:invite` |
| 5 | Cancel invite | "✕ Cancel" | `WorkspaceService/CancelInvite` | Invite cancelled | `workspace:members:invite` |

### Role Hierarchy
| Role | Capabilities |
|---|---|
| 👑 Owner | Full access, billing, team, delete workspace |
| 🛡 Admin | All except billing and ownership transfer |
| 📋 Manager | Create/edit content, view analytics, manage contacts |
| 📝 Editor | Create/edit own content only |
| 👁 Viewer | Read-only access |

### Technical Notes
- Route: `src/routes/(app)/settings/team/+page.svelte`
- Invite: magic link + email notification

### Related Screens: [W08] Settings Hub, [A03] Admin User Management

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| Custom role name conflicts with canonical | "Tên role này đã tồn tại. Chọn tên khác." |
| Last Admin changed to Editor | Warning: "Workspace sẽ chỉ còn Owner quản lý. Tiếp tục?" |
| Invite same email twice | "Email này đã được mời. [🔄 Gửi lại lời mời cũ]" |
| Role change during active session | Target session refreshes permissions on next API call |
| Permission matrix too large | Collapsible groups by module, not all-at-once |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached team data | Retry online |
| Invite fail | SMTP error | Toast: "Không gửi được. [Thử lại]" | Retry |
| Role update fail | API error | Toast: "Không cập nhật được vai trò. [Thử lại]" | Retry |
| Custom role save fail | Conflict or API error | Inline error on form | Fix and retry |
| Permission matrix load fail | Large payload timeout | "Không tải được bảng phân quyền. [Thử lại]" | Retry |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Member list | `role="list"`, each row `aria-label="{name}, role: {role}"` |
| Role dropdown | `aria-label="Select role for {name}"`, descriptions per option |
| Invite form | Input + label linked, `aria-required`, `aria-describedby` for help text |
| Permission matrix table | `role="table"`, `aria-label="Permissions by role"`, row/column headers |
| Remove confirm | `role="alertdialog"`, destructive action aria warning |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Member row skeletons |
| Member list | 200-500ms | Rows stagger in |
| Pending invites | 300-600ms | Invite rows appear |
| Invite link | 100-300ms | Share link populates |
| Permission matrix | 500-1000ms | Table rows fill progressively |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `settings_team.viewed` | Page load | `member_count`, `pending_count`, `source` |
| `settings_team.invite_sent` | "Mời" | `email_domain`, `role` |
| `settings_team.invite_link_copied` | "📋 Copy" share link | — |
| `settings_team.role_changed` | Role dropdown confirmed | `member_id`, `old_role`, `new_role` |
| `settings_team.member_removed` | "✕ Remove" confirmed | `member_id`, `role` |
| `settings_team.invite_resent` | "🔄 Resend" | `invite_id` |
| `settings_team.invite_cancelled` | "✕ Cancel" confirmed | `invite_id` |
| `settings_team.permissions_viewed` | "📋 Xem bảng phân quyền" | — |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/settings/team/+page.svelte`
- **Server load**: `+page.server.ts` → `WorkspaceService/ListMembers` + `WorkspaceService/ListInvites`
- **Invite**: Form action `?/invite` → `WorkspaceService/InviteMember(email, role)` → magic link email
- **Share link**: `WorkspaceService/GetInviteLink(workspace_id)` → signed URL, rotatable
- **Role change**: Form action `?/changeRole` → RBAC enforcement server-side
- **Permission matrix**: Lazy-loaded drawer → `RBACService/GetPermissionMatrix` → cached 1h
- **Custom roles**: `RBACService/CreateCustomRole(name, permissions[])` → inherits from base role
- **Remove**: Confirm → `WorkspaceService/RemoveMember` → invalidate active sessions

---

## 12. Localization Notes

- Roles: Same as W121 — Vietnamese names with icons
- Actions: "Mời", "Gửi lại", "Hủy lời mời", "Xóa thành viên"
- Sections: "Đội ngũ & Phân quyền", "Lời mời đang chờ", "Bảng phân quyền"
- Share: "Liên kết mời — ai có link đều có thể tham gia"
- Tone: Administrative, clear

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-role-owner` | 👑 Owner badge (gold) |
| `--color-role-admin` | 🛡 Admin badge (blue) |
| `--color-role-editor` | 📝 Editor badge (green) |
| `--color-role-viewer` | 👁 Viewer badge (neutral) |
| `--color-accent` | Invite CTA |
| `--color-danger` | Remove button |
| `--color-surface-elevated` | Member cards, invite rows |
| `--color-text-secondary` | Invite timestamps, help text |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W007] Settings Hub | Parent navigation |
| [W115] Member Management | Detailed member management |
| [A003] Admin User Detail | Platform-level user admin |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (custom role conflict, last Admin), 5 errors, list/modal a11y, 8 analytics, SvelteKit impl (RBAC, magic link), localization, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

# Screen: Web — Settings: Workspace Members

> **Screen ID**: W115
> **Module**: M23 — Workspace Administration
> **Route**: `/settings/workspace/members`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 10, PRD §34 Workspace, A1 Schema (workspace_members, workspace_invites), B5 RBAC §2 (7 canonical roles)

---
## 1. Purpose & Context

Manage workspace members — invite by email, assign canonical roles (Owner, Admin, Manager, Editor, Contributor, Viewer, External), transfer ownership, remove members, and track pending invitations. Roles follow the B5 §2 canonical 7-role workspace RBAC model.

### User Goals
- Invite team members with appropriate roles
- Change roles as team members' responsibilities evolve
- Remove members who leave the team
- Track pending invitations and resend if needed

### Business Goals
- Enforce RBAC for data security and access control
- Enable team scaling with clear permission boundaries
- Track seat usage against subscription limits

### Entry Points
- Sidebar: Settings → "👥 Thành viên"
- Onboarding: step 3 "Invite your team"
- Workspace Settings (W120): "Members" section link

### Exit Points
- No external navigation (self-contained management screen)

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `workspace:settings:manage` permission (Owner, Admin)
- Workspace exists and is active

### Postconditions
- Invited members receive email with workspace invite link
- Role changes take effect immediately on all screens
- Removed members lose access immediately and active sessions are invalidated

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ⚙️ Settings > 👥 Thành viên workspace              [+ Mời mới]    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Seat Status ─────────────────────────────────────────────────┐   │
│ │ 👥 3/5 seats used · Plan: Pro (5 seats max)                   │   │
│ │ [████████░░░░░] · [📈 Nâng cấp để thêm seats]                │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── Active Members ──────────────────────────────────────────────      │
│ ┌─ Member Row ──────────────────────────────────────────────────┐   │
│ │ 👤 Nguyễn Quân · quanng@email.com                             │   │
│ │ Role: 👑 Owner · Active now                                    │   │
│ │ Joined: 15/01/2026 · Last active: just now                     │   │
│ │ [You — cannot modify own role]                                 │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Member Row ──────────────────────────────────────────────────┐   │
│ │ 👤 Trần Minh · minh@email.com                                 │   │
│ │ Role: [Editor ▾] · Active 2h ago                               │   │
│ │ Joined: 20/02/2026 · Content created: 45 items                 │   │
│ │ [✏ Change role ▾] [🗑 Xóa thành viên]                        │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Member Row ──────────────────────────────────────────────────┐   │
│ │ 👤 Lê Hoa · hoa@email.com                                     │   │
│ │ Role: [Viewer ▾] · Last active: 3 days ago                     │   │
│ │ ⚠️ Inactive > 3 days                                          │   │
│ │ [✏ Change role ▾] [🗑 Xóa]                                   │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── Pending Invitations ──────────────────────────────────────────     │
│ ┌─ Invite Row ──────────────────────────────────────────────────┐   │
│ │ 📧 linh@email.com · Role: Editor · Sent: 1 ngày trước        │   │
│ │ Status: ⏳ Chưa chấp nhận                                     │   │
│ │ [🔄 Gửi lại] [❌ Hủy lời mời]                                │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Role Reference (collapsible) ────────────────────────────────┐   │
│ │ 👑 Owner: Full access + billing + ownership transfer          │   │
│ │ 🔑 Admin: Full access (no billing/ownership)                  │   │
│ │ 📋 Manager: Read + write + manage team, no settings           │   │
│ │ ✏️ Editor: Read + create + edit content and products          │   │
│ │ 📎 Contributor: Read + create (limited edit)                   │   │
│ │ 👁 Viewer: Read-only access                                    │   │
│ │ 🔗 External: Limited access to assigned tasks only             │   │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
WorkspaceMembersPage
├── AppShell (shared)
├── PageHeader
│   ├── BreadcrumbNav ("⚙️ Settings > 👥 Thành viên")
│   └── InviteButton ("+ Mời mới", primary CTA)
├── SeatStatusBar
│   ├── UsedSeats / MaxSeats
│   ├── PlanName
│   ├── ProgressBar
│   └── UpgradeLink (if seats limited)
├── ActiveMembersSection
│   └── MemberRow[]
│       ├── Avatar
│       ├── DisplayName
│       ├── Email
│       ├── RoleBadge (with icon)
│       ├── ActivityStatus (active now / Xh ago / Xd ago)
│       ├── JoinDate
│       ├── ContributionSummary (content created, etc.)
│       ├── InactiveWarning (if > 3 days inactive)
│       └── ActionBar (conditional — not for own row)
│           ├── RoleDropdown (7 canonical roles)
│           └── RemoveButton
├── PendingInvitationsSection
│   └── InviteRow[]
│       ├── Email
│       ├── AssignedRole
│       ├── SentDate (relative)
│       ├── Status (pending / expired)
│       └── ActionBar
│           ├── ResendButton
│           └── CancelButton
├── RoleReferencePanel (collapsible)
│   └── RoleDescription[] (7 roles with icons and brief descriptions)
└── InviteModal
    ├── EmailInput (required, valid email format)
    ├── RoleSelector (dropdown with descriptions)
    ├── PersonalMessage (optional)
    └── SendInviteButton
```

---
## 5. Displayed Data

| Field | Source | Format |
|---|---|---|
| Name | `workspace_members.user.display_name` | Text |
| Email | `workspace_members.user.email` | Email |
| Role | `workspace_members.role` | Badge with icon |
| Activity | `workspace_members.last_active_at` | Relative time |
| Join date | `workspace_members.created_at` | "dd/MM/YYYY" |
| Content count | Aggregated from content tables | "45 items" |
| Seats | `workspace.member_count` / `plan.max_seats` | "3/5" |
| Invite status | `workspace_invites.status` | "pending" / "expired" |

---
## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Invite member | "+ Mời mới" → modal | `WorkspaceService/InviteMember(email, role)` | Email sent, pending invite appears, toast "Đã gửi lời mời đến {email}" | Owner, Admin |
| 2 | Change role | Role dropdown → select | `WorkspaceService/UpdateMemberRole(member_id, new_role)` | Confirmation: "Thay đổi vai trò của {name} thành {role}?" → instant update | Owner, Admin |
| 3 | Remove member | "🗑 Xóa" → confirm | `WorkspaceService/RemoveMember(member_id)` | Confirmation (S007): "Xóa {name} khỏi workspace? Họ sẽ mất tất cả quyền truy cập ngay lập tức." → removed | Owner, Admin |
| 4 | Resend invite | "🔄 Gửi lại" | `WorkspaceService/ResendInvite(invite_id)` | Email resent, timestamp updated | Owner, Admin |
| 5 | Cancel invite | "❌ Hủy" → confirm | `WorkspaceService/CancelInvite(invite_id)` | Invite deleted | Owner, Admin |
| 6 | Transfer ownership | ⋮ → "Transfer ownership" → confirm + password | `WorkspaceService/TransferOwnership(new_owner_id)` | 2FA verification required → ownership transferred | Owner only |

---
## 7. Validation Rules

| Field | Rule | Error |
|---|---|---|
| Email (invite) | Required, valid format, not already member | "Email không hợp lệ" / "Email đã là thành viên" |
| Role (invite) | Required, one of 7 canonical roles | — |
| Role (change) | Cannot change own role | "Không thể thay đổi vai trò của chính bạn" |
| Remove | Cannot remove self | "Không thể xóa chính bạn khỏi workspace" |
| Remove | Cannot remove Owner (must transfer first) | "Chuyển quyền sở hữu trước khi xóa" |
| Seats | Cannot invite if seats full | "Đã hết chỗ ({used}/{max}). Nâng cấp để thêm thành viên." |
| Ownership transfer | Requires password + 2FA | "Xác minh danh tính để chuyển quyền sở hữu" |

---
## 8. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Member row skeletons |
| LOADED | Data received | Member list with seat bar |
| EMPTY | Only owner, no other members | "Workspace hiện chỉ có bạn. Mời thành viên để cộng tác! [+ Mời thành viên]" |
| SEATS_FULL | Used seats = max seats | Invite button disabled, "Đã hết chỗ. [📈 Nâng cấp]" |
| INVITE_EXPIRED | Pending invite > 7 days | "⏰ Lời mời đã hết hạn. [🔄 Gửi lại]" |
| ERROR | API failed | Error with retry |

---
## 9. Permissions

Only Owner and Admin can manage members:

| Feature | Owner | Admin | Manager | Editor+ |
|---|---|---|---|---|
| View member list | ✅ | ✅ | ✅ (limited) | ❌ |
| Invite members | ✅ | ✅ | ❌ | ❌ |
| Change roles | ✅ | ✅ (cannot change Owner) | ❌ | ❌ |
| Remove members | ✅ | ✅ (cannot remove Owner) | ❌ | ❌ |
| Transfer ownership | ✅ | ❌ | ❌ | ❌ |

**Manager**: Can see member names and roles (for context) but cannot manage. Button section hidden.

---
## 10. Canonical 7-Role Reference (B5 §2)

| Role | Icon | Core Permissions | Revenue Access |
|---|---|---|---|
| Owner | 👑 | All + Billing + Ownership | Full |
| Admin | 🔑 | All except billing/ownership | Full |
| Manager | 📋 | CRUD + Team mgmt (no settings) | Revenue only |
| Editor | ✏️ | CRUD content + products | No |
| Contributor | 📎 | Create content (limited edit) | No |
| Viewer | 👁 | Read-only | No |
| External | 🔗 | Assigned tasks only | No |

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| Invite email already has Creativanta account | Invite links directly to workspace join |
| Invite email has no account | Invite email includes registration link → auto-join workspace |
| Last Admin removal | Warning: "Đây là Admin duy nhất. Workspace sẽ chỉ có Owner quản lý." |
| Owner goes inactive > 30 days | System sends notification to Owner → if 90 days, prompt Admin for ownership transfer request |
| Email domain restriction | If workspace has domain restriction, validate email domain on invite |

---
---

## 12. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached member list | Retry online |
| Invite email fail | SMTP error | Toast: "Không gửi được lời mời. [Thử lại]" | Retry (invite still created) |
| Role change conflict | Concurrent role change | Toast: "Vai trò đã được cập nhật bởi người khác. Tải lại?" | Reload |
| Remove self attempt | User tries to remove own account | Inline: "Không thể xóa chính bạn khỏi workspace" | N/A |
| Seats full on invite | Invite > max seats | Modal: "Đã hết chỗ ({used}/{max}). [📈 Nâng cấp]" | Upgrade plan |

---

## 13. Accessibility

| Element | Requirement |
|---|---|
| Seat progress bar | `role="progressbar"`, `aria-valuenow`, `aria-valuemax`, `aria-label="3 of 5 seats used"` |
| Member list | `role="list"`, each row `role="listitem"` with `aria-label="{name}, {role}"` |
| Role dropdown | `aria-label="Change role for {name}"`, options with role descriptions |
| Invite modal | `role="dialog"`, `aria-labelledby`, focus trap, Escape to close |
| Remove confirm | `role="alertdialog"`, `aria-describedby` with warning text |

---

## 14. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Seat bar + member row skeletons |
| Seat count | 100-200ms | Progress bar animates |
| Active members | 200-500ms | Member rows stagger in |
| Pending invites | 300-600ms | Invite rows appear |
| Activity status | 400-800ms | "Active now" / "2h ago" labels populate |

---

## 15. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `settings_members.viewed` | Page load | `member_count`, `seat_usage_pct`, `pending_count` |
| `settings_members.invite_sent` | Invite submitted | `email_domain`, `role`, `seats_remaining` |
| `settings_members.invite_resent` | "🔄 Gửi lại" | `invite_id`, `days_since_original` |
| `settings_members.invite_cancelled` | "❌ Hủy" confirmed | `invite_id`, `role` |
| `settings_members.role_changed` | Role dropdown change confirmed | `member_id`, `old_role`, `new_role` |
| `settings_members.member_removed` | "🗑 Xóa" confirmed | `member_id`, `role`, `content_count` |
| `settings_members.ownership_transferred` | Ownership transfer completed | `old_owner`, `new_owner` |
| `settings_members.upgrade_clicked` | "📈 Nâng cấp" from seat bar | `current_seats`, `plan` |

---

## 16. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/settings/workspace/members/+page.svelte`
- **Server load**: `+page.server.ts` → `WorkspaceService/ListMembers(workspace_id)` + `WorkspaceService/ListInvites`
- **Invite**: Form action `?/invite` → `WorkspaceService/InviteMember(email, role)` → sends email via queue
- **Role change**: Form action `?/changeRole` → `WorkspaceService/UpdateMemberRole(member_id, role)` → instant effect
- **Remove**: Confirm modal → Form action `?/remove` → `WorkspaceService/RemoveMember(member_id)` → invalidate sessions
- **Seat validation**: Server-side check before invite (client shows seat bar, server enforces)
- **Ownership transfer**: Requires password + 2FA → `WorkspaceService/TransferOwnership(new_owner_id)`
- **Magic link**: Invite email contains signed URL `/invite/[token]` → auto-join on accept

---

## 17. Localization Notes

- Roles: Vietnamese ("👑 Chủ sở hữu", "🔑 Quản trị viên", "📋 Quản lý", "✏️ Biên tập viên", "📎 Cộng tác viên", "👁 Người xem", "🔗 Bên ngoài")
- Status: "Hoạt động ngay", "Hoạt động 2h trước", "⚠️ Không hoạt động > 3 ngày"
- Seats: "3/5 chỗ đã sử dụng"
- Invite: "📧 Lời mời đang chờ", "⏰ Lời mời đã hết hạn"
- Tone: Administrative, respectful

---

## 18. Design Tokens

| Token | Usage |
|---|---|
| `--color-role-owner` | 👑 Owner badge (gold) |
| `--color-role-admin` | 🔑 Admin badge (blue) |
| `--color-role-manager` | 📋 Manager badge (teal) |
| `--color-role-editor` | ✏️ Editor badge (green) |
| `--color-role-viewer` | 👁 Viewer badge (neutral) |
| `--color-accent` | Invite CTA |
| `--color-danger` | Remove member button |
| `--color-warning` | Inactive warning, seats full |
| `--color-surface-elevated` | Member cards |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W114] Workspace Settings | Parent settings page |
| [W119] Billing & Plans | Seat limits from plan |
| [W122] Notification Preferences | Per-member notification preferences |
| [A002] Admin User List | Platform-level user management |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (invite fail, role conflict), member/modal a11y, 8 analytics, SvelteKit impl (form actions, seat validation), localization, 9 design tokens (role-specific colors). | System |
| 2026-03-28 | 1.0 | Initial specification | System |

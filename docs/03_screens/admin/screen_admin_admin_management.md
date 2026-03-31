# Screen: Admin — Admin Team Management

> **Screen ID**: A032
> **Module**: Admin — Internal Administration
> **Route**: `/admin/team`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: S26 §2, B5 RBAC §3

---

## 1. Purpose & Context

Admin Team Management is the interface for creating, modifying, and revoking internal admin accounts. This is a **Super Admin exclusive** screen — the only place where internal admin users and their roles can be managed. The internal admin system is completely isolated from workspace RBAC.

### User Goals
- Create new internal admin accounts
- Assign/change roles for existing admins
- View admin activity history
- Deactivate admin accounts
- Manage emergency access credentials

### Business Goals
- Enforce Principle of Least Privilege for internal team
- Maintain complete audit trail of admin access
- Enable rapid onboarding/offboarding of internal staff

### Entry Points
- Admin Navigation: "👥 Admin Management" (only visible to Super Admin)
- Only accessible with Super Admin role

### Exit Points
- Click admin → activity log for that admin
- Click edit → edit modal

---

## 2. Preconditions / Postconditions

### Preconditions
- **Super Admin role ONLY** — all other roles receive 403 (page not even visible in nav)
- Admin authenticated via VPN + MFA

### Postconditions
- All admin CRUD actions logged in `admin_audit_log` (immutable, 7-year retention)
- Role changes take effect immediately (existing sessions updated)
- Email notification sent to affected admin on role change or deactivation

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🏢 Creativanta Admin  [Admin Management]  [Super Admin] 👤 admin@  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ 🔒 This screen is Super Admin exclusive.                             │
│                                                                      │
│ ┌─ Admin Team ─────────────────────────────────────────────────┐    │
│ │ [🔍 Search...] [Role ▾] [Status ▾]     [+ Add Admin]         │    │
│ │ ┌──────────────────────────────────────────────────────────┐  │    │
│ │ │ 👤 admin1@creativanta.vn                                  │  │    │
│ │ │ Role: Super Admin | Status: 🟢 Active | Last: 2h ago     │  │    │
│ │ │ MFA: ✅ | Sessions: 1 | Login devices: 2                  │  │    │
│ │ │ [View Activity] [Edit Role] [Deactivate]                   │  │    │
│ │ │──────────────────────────────────────────────────────────│  │    │
│ │ │ 👤 ops1@creativanta.vn                                    │  │    │
│ │ │ Role: Operations Admin | Status: 🟢 Active | Last: 1d ago│  │    │
│ │ │ MFA: ✅ | Sessions: 0 | Login devices: 1                  │  │    │
│ │ │ [View Activity] [Edit Role] [Deactivate]                   │  │    │
│ │ │──────────────────────────────────────────────────────────│  │    │
│ │ │ 👤 finance1@creativanta.vn                                │  │    │
│ │ │ Role: Finance Admin | Status: 🟢 Active | Last: 3d ago   │  │    │
│ │ │ MFA: ✅ | Sessions: 0 | Login devices: 1                  │  │    │
│ │ │ [View Activity] [Edit Role] [Deactivate]                   │  │    │
│ │ │──────────────────────────────────────────────────────────│  │    │
│ │ │ 👤 content1@creativanta.vn                                │  │    │
│ │ │ Role: Content Admin | Status: 🔴 Deactivated              │  │    │
│ │ │ Deactivated: 2026-03-15 | Reason: Left company            │  │    │
│ │ │ [View Activity] [Reactivate]                               │  │    │
│ │ └──────────────────────────────────────────────────────────┘  │    │
│ │ Total: 8 admins (6 active, 2 deactivated)                     │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Role Distribution ──────────────┐ ┌─ Security Overview ────────┐ │
│ │ Super Admin: 2 (max 3)           │ │ MFA enabled: 8/8 (100%)    │ │
│ │ Operations Admin: 1              │ │ Password rotation due: 1    │ │
│ │ Finance Admin: 1                 │ │ Inactive > 7d: 2 accounts  │ │
│ │ Content Admin: 1                 │ │ Concurrent sessions now: 3  │ │
│ │ Support Admin: 1                 │ │ Last security audit: 5d ago │ │
│ │ Tech Admin: 1                    │ │ Recovery key holders: 2     │ │
│ │ Analyst: 1                       │ │                              │ │
│ │ Auditor: 0                       │ │                              │ │
│ └──────────────────────────────────┘ └──────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
AdminManagementPage
├── AdminShell (shared)
├── SuperAdminExclusiveBanner
├── AdminList
│   ├── FilterBar (search, role filter, status filter)
│   ├── AddAdminButton → CreateAdminModal
│   └── AdminRow[]
│       ├── Avatar + Email
│       ├── RoleBadge
│       ├── StatusIndicator (🟢 Active / 🔴 Deactivated)
│       ├── LastActiveTimestamp
│       ├── SecurityInfo (MFA status, active sessions, devices)
│       └── ActionButtons (View Activity, Edit Role, Deactivate/Reactivate)
├── StatsGrid (2 columns)
│   ├── RoleDistributionCard
│   │   └── RoleCount[] (per role with max capacity for Super Admin)
│   └── SecurityOverviewCard
│       ├── MFAStatus
│       ├── PasswordRotationDue
│       ├── InactiveAccounts
│       ├── ConcurrentSessions
│       └── RecoveryKeyHolders
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Admin list | `internal_admins` | `AdminManagementService/ListAdmins(filters)` | Sorted by role level then name | No cache |
| Role distribution | Aggregated from admin list | Computed client-side | Count per role | Same |
| Security overview | `admin_sessions`, `admin_mfa_status` | `AdminManagementService/GetSecurityOverview` | Status indicators | 5m TTL |
| Activity log | `admin_audit_log WHERE actor_admin_id = [id]` | `AdminManagementService/GetAdminActivity(adminId)` | Timeline | 2m TTL |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Create admin | Click "+ Add Admin" | `AdminManagementService/CreateAdmin(data)` | New admin created | Modal: email + role + temp password → toast "Admin created" + email sent | Super Admin |
| 2 | Edit role | Click "Edit Role" | `AdminManagementService/UpdateRole(adminId, role)` | Role updated | Dropdown → confirmation + reason → toast "Role updated" | Super Admin |
| 3 | Deactivate | Click "Deactivate" | `AdminManagementService/Deactivate(adminId, reason)` | Admin deactivated, sessions killed | Confirmation + reason required → toast "Admin deactivated" | Super Admin |
| 4 | Reactivate | Click "Reactivate" | `AdminManagementService/Reactivate(adminId)` | Admin reactivated | Confirmation → toast "Admin reactivated" | Super Admin |
| 5 | View activity | Click "View Activity" | `AdminManagementService/GetAdminActivity(adminId)` | — | Expand inline activity timeline | Super Admin |
| 6 | Force logout | Click "Kill Sessions" | `AdminManagementService/KillSessions(adminId)` | All sessions terminated | Confirmation → toast "Sessions terminated" | Super Admin |
| 7 | Reset MFA | Click "Reset MFA" | `AdminManagementService/ResetMFA(adminId)` | MFA token cleared, re-enrollment required | Confirmation → toast "MFA reset" | Super Admin |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Skeleton |
| LOADED | Data ready | Full admin list + stats |
| ERROR | API failure | Error with retry |

---

## 8. Permission Matrix

| Feature | Super Admin | All Other Roles |
|---|---|---|
| View admin list | ✅ | ❌ (page hidden + 403) |
| Create admin | ✅ | ❌ |
| Edit role | ✅ | ❌ |
| Deactivate/reactivate | ✅ | ❌ |
| View activity | ✅ | ❌ |
| Force logout | ✅ | ❌ |
| Reset MFA | ✅ | ❌ |

---

## 9. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Admin email | Must be @creativanta.vn or approved domain | "Admin email must be from approved domain" |
| Role selection | Must be one of 8 canonical roles | "Invalid role" |
| Super Admin count | Max 3 Super Admins allowed | "Maximum Super Admin limit reached" |
| Deactivation reason | Required, min 10 chars | "Please provide a detailed reason" |

---

## 10. Navigation Map

```
Admin Management (/admin/team)
├── → /admin/audit?actor=[adminId]     (Admin's full audit trail)
└── ← /admin                           (Dashboard)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Permission denied | Non-Super Admin access | 403 page, nav item hidden | N/A |
| Max limit reached | Creating 4th Super Admin | Toast "Max 3 Super Admins" | Choose different role |
| Email conflict | Admin email already exists | "Email already registered" | Use different email |
| Self-deactivation | Super Admin trying to deactivate self | "Cannot deactivate your own account" | N/A |

---

## 12. Related Screens

| Screen | Relationship |
|---|---|
| [A001] Admin Dashboard | Parent |
| [A010] Audit Log | Admin activity audit |

---

## 13. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 1.0 | Initial specification — aligned to S26 §2 internal admin RBAC | System |

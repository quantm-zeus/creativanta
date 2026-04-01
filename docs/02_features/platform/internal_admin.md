---
layer: features
module: S26
status: READY
created: 2026-04-01
canonical: true
upstream: PRD v3.1 §26
---

# S26 — Internal Admin Panel

> **Upstream**: PRD §26, Design Pack 11 (Admin)
> **DB tables**: `internal_admins`, `admin_sessions`, `moderation_cases`, `fraud_cases`, `support_tickets`, `incidents`, `system_announcements` (12 tables)
> **Screens**: 32 admin screens

---

## 1. Purpose

Internal Admin Panel provides the operations team with tools to manage users, workspaces, content moderation, fraud detection, billing, system health, and compliance — all through a separate admin-only interface.

### Scope

**Covers**: User/workspace management, content moderation queue, fraud detection, incident management, billing administration, system configuration, compliance (GDPR/data deletion), internal audit logs.

**Does NOT cover (Non-goals for this module)**:
- User-facing settings or preferences (owned by M23 Reporting/Admin/Billing)
- Platform analytics dashboards for creators (owned by analytics screens)
- AI model training or prompt management (owned by AI provider infrastructure)
- Customer-facing support chat widget (external tool, e.g., Intercom)

### Actors

| Actor | Role | Primary Actions |
|---|---|---|
| SuperAdmin | SuperAdmin | Full system access, impersonation, admin role management |
| ContentMod | ContentMod | Review reports, moderate content, issue warnings/bans |
| FinanceAdmin | FinanceAdmin | Manage billing, refunds, credit adjustments |
| SystemOps | SystemOps | Incident management, system config, monitoring |
| ComplianceOfficer | ComplianceOff | Data deletion requests, consent management |
| SupportAgent | SupportAgent | User lookup, ticket management, account assistance |

## 2. Business Rules

| Rule | Description |
|------|-------------|
| RULE-S26-001 | Admin panel is VPN-restricted + MFA-required, separate from user-facing app |
| RULE-S26-002 | 8 admin roles: SuperAdmin, UserAdmin, ContentMod, CommerceAdmin, FinanceAdmin, SystemOps, ComplianceOff, SupportAgent |
| RULE-S26-003 | All admin actions logged to `internal_audit_logs` with old/new values |
| RULE-S26-004 | Impersonation requires SuperAdmin + justification, auto-expires in 30 minutes |
| RULE-S26-005 | User suspension requires reason, triggers notification, 24h appeal window |
| RULE-S26-006 | Content moderation SLA: 4h for CRITICAL, 24h for HIGH, 72h for MEDIUM |
| RULE-S26-007 | Fraud cases auto-escalate after 48h if unresolved |
| RULE-S26-008 | Incident management follows severity: SEV1 (all-hands), SEV2 (on-call), SEV3 (next business day) |

## 3. Key Flows

### 3.1 User Management
1. Admin searches users by email/name/ID
2. Views user profile, activity, credit balance, workspaces
3. Actions: suspend, unsuspend, reset password, force logout, adjust credits, override plan
4. All actions require confirmation and are audit-logged

### 3.2 Content Moderation
1. Reports queue (auto-flagged + user-reported)
2. Moderator reviews content + evidence
3. Actions: approve, warn user, remove content, suspend user, ban user
4. Appeals tracked as separate workflow

### 3.3 Fraud Detection
1. Auto-flagged transactions appear in fraud queue
2. Analyst reviews signals (device intel, pattern analysis)
3. Actions: dismiss, freeze account, escalate, block payment method
4. Impact assessment calculated (total exposure)

### 3.4 Incident Management
1. System alert or manual creation
2. Incident tracked with timeline, affected services, assignees
3. Resolution → post-mortem with contributing factors + action items
4. All post-mortems published internally

## 4. State Machine — Moderation Case

| From | To | Trigger | Condition |
|------|----|---------|-----------|
| — | open | Report received | Auto-flag or user report |
| open | reviewing | Moderator claims | — |
| reviewing | resolved_approve | Content approved | No violation |
| reviewing | resolved_remove | Content removed | Violation confirmed |
| reviewing | escalated | Moderator escalates | Need higher authority |
| escalated | resolved_approve | Senior approves | — |
| escalated | resolved_ban | User banned | Severe violation |
| resolved_* | appealed | User appeals | Within 7 days |

## 5. State Machine — Incident

| From | To | Trigger | Condition |
|------|----|---------|-----------|
| — | detected | Alert or manual | — |
| detected | investigating | Team assigned | — |
| investigating | mitigated | Workaround applied | — |
| mitigated | resolved | Root cause fixed | — |
| resolved | post_mortem | Post-mortem created | Required for SEV1/SEV2 |

## 5.1 Edge Cases

### EC-S26-001: Impersonation during active user session
- Condition: Admin impersonates a user who is currently active in the app
- Expected behavior: User's session is NOT disrupted. Admin sees a read-only mirror. If admin takes a write action, user sees a notification: "An admin performed an action on your account." All admin actions marked with `performed_by_admin = true`.

### EC-S26-002: Moderator reviews own content
- Condition: A ContentMod's own published content is user-reported
- Expected behavior: System auto-assigns to a DIFFERENT moderator. If no other moderator available, escalate to SuperAdmin. Prevents self-review conflict of interest.

### EC-S26-003: Cascading suspension across workspaces
- Condition: User is member of 5 workspaces when suspended
- Expected behavior: User suspended from ALL workspaces simultaneously. Other workspace owners notified: "[User] has been suspended by platform admin." User's content remains visible but edit-locked.

## 6. API Surface

> See `04_contracts/api_endpoint_map.md` §6 (Admin S26) + §34 Extended — 18+ services, 200+ RPCs

| Service | Key RPCs |
|---------|----------|
| `AdminService` | GetDashboard, GetUser, SuspendUser, Impersonate, OverridePlan |
| `AdminAbuseService` | ListReports, ActionReport, BanUser, SuspendUser |
| `AdminFraudService` | ListCases, GetSignals, CreateCase, ExportReport |
| `AdminIncidentService` | Create, List, Resolve, CreatePostMortem |
| `AdminManagementService` | ListAdmins, CreateAdmin, UpdateRole, ResetMFA |
| `AdminComplianceService` | ListRequests, GetUserConsents, ApproveDeletion |
| `AdminRevenueService` | GetSummary, ListTransactions, RetryPayment |
| `AdminConfigService` | GetPricing, UpdateTier, UpdateRateLimit |

## 7. Acceptance Criteria

```gherkin
Feature: User Suspension
  Scenario: Admin suspends a user
    Given a user with active account
    When UserAdmin suspends with reason "TOS violation"
    Then user status changes to suspended
    And notification sent to user email
    And action logged to internal_audit_logs
    And 24h appeal window starts

Feature: Impersonation
  Scenario: SuperAdmin impersonates user
    Given a SuperAdmin with MFA verified
    When impersonation started with justification "Support ticket #1234"
    Then admin sees user's view
    And session auto-expires in 30 minutes
    And all pages viewed + actions taken are logged
```

## 8. Cross-references

- **DB**: `04_contracts/database_schema.md` §17 Internal Admin
- **API**: `04_contracts/api_endpoint_map.md` §6 + §34
- **RBAC**: `04_contracts/rbac_permission_matrix.md` (8 admin roles)
- **Security**: `06_quality_ops/security_threat_model.md` (insider threat model)
- **Screens**: `03_screens/admin/screen_admin_*.md` (32 files)

---
layer: features
module: M23
canonical: true
domain: platform
status: DRAFT
last_updated: 2026-03-30
---

# Feature: Reporting, Admin & Billing (M23)

## Purpose

Creativanta requires two distinct admin surfaces: (A) the **in-app workspace admin** for creators/sellers to manage their own workspace settings, billing, diagnostics, and connectors, and (B) the **internal admin site** for the Creativanta operations team to manage the platform itself — user management, fraud detection, content moderation, incident response, and system health. These surfaces MUST be architecturally separate with zero overlap in authentication, RBAC, and access patterns.

M23 exists as a **dual-surface admin module** — defining both the workspace-scoped self-service admin (Part A) and the platform-scoped internal operations admin (Part B), plus the customer support integration that bridges both surfaces.

---

# PART A — In-App Workspace Admin (creativanta.app)

## Purpose (Part A)

Self-service workspace administration for creators and sellers: manage connected accounts, billing, team members, workspace settings, diagnostics, and support access — all within the main application.

## Scope (Part A)

### Covers
- Workspace settings: name, branding, operator mode selection, language/timezone
- Team management: invite members, assign workspace roles (Owner → External), remove members
- Connected accounts: connect/disconnect platforms, OAuth status, health display
- Billing & subscription: plan selection, payment method, invoice history, credit balance, usage dashboard
- Diagnostics console: view system diagnostics for workspace issues (publish failures, sync errors)
- API key management: generate/revoke API keys (Starter+ tier), webhook configuration
- Data export: GDPR-compliant data export request
- Support access: help center, AI chatbot, bug report, ticket history

### Actors (Part A)

| Actor | Role | Primary Actions |
|---|---|---|
| Workspace Owner | Owner | Full admin: billing, team, settings, data export, account deletion |
| Admin | Admin | Team management, connector management, settings |
| Manager | Manager+ | View diagnostics, manage some settings |
| Contributor | Contributor+ | View own permissions, access support |

## Business Rules (Part A)

1. **RULE-M23-A01**: Billing management is Owner-only. Only workspace Owner can: change plan, update payment method, cancel subscription, request data deletion. Admin role can view billing but not modify (PRD §22, RBAC matrix §5).
2. **RULE-M23-A02**: Team actions follow RBAC hierarchy — users can only manage members at or below their level. Owner manages all; Admin manages Manager and below; Manager manages Contributor and below (RBAC matrix §1).
3. **RULE-M23-A03**: Connected account management: connect requires Editor+ (OAuth dance + capability check). Disconnect requires Admin+ (destructive — breaks dependent workflows). Force-reconnect available when token expires (connector_specs §connection).
4. **RULE-M23-A04**: Workspace diagnostics show user-facing error summaries for recent issues (publish failures, sync errors, AI generation failures). Each diagnostic links to the affected object and provides recommended actions — NOT raw error logs (Pack 03 §8).
5. **RULE-M23-A05**: Credit balance and usage dashboard shows: current balance, usage this period, usage by feature category (AI text, AI video, AI image, AI analysis), burn rate, estimated depletion date. Top-up CTA visible when balance < 20% of monthly allocation (PRD §21, Pack 08).

## Main Flow (Part A)

1. **Workspace settings**: Owner/Admin configures workspace
   - Name, branding assets, operator mode, timezone
   - Settings apply workspace-wide
2. **Team management**: Admin invites/manages members
   - Invite by email → invite acceptance flow → member joins with assigned role
   - Role change: Admin+ can promote/demote within their scope
   - Remove member: Admin+ (confirmation required)
3. **Billing management**: Owner manages subscription
   - View current plan, upcoming renewal, payment method
   - Upgrade/downgrade: immediate (upgrade) or at-period-end (downgrade)
   - Add-ons: purchase additional credits, extra storage, additional connected accounts
   - Invoice download: PDF per billing period
4. **Connected accounts**: Editor+ manages platform connections
   - Connect: OAuth flow → capability check → M22 registers connector
   - Health monitoring: view real-time health from M22
   - Reconnect: if token expired → re-authorize flow
   - Disconnect: Admin+ with confirmation ("This will disable [X] workflows")
5. **Diagnostics review**: Manager+ reviews workspace health
   - Recent issues list with severity, affected feature, resolution status
   - Each diagnostic: user-facing summary + recommended action CTA
6. **Support access**: all roles access support
   - Help center search, AI chatbot, bug report form
   - Ticket history: view submitted tickets with status

## State Machine (Part A)

### Workspace Subscription

| From | To | Trigger | Condition |
|---|---|---|---|
| — | trial | Workspace created | Free trial period (14 days) |
| trial | active | User subscribes | Payment confirmed |
| trial | free | Trial expires without subscription | Downgrade to free tier |
| active | active | Plan change | Upgrade/downgrade at period boundary |
| active | grace_period | Payment fails | Dunning flow active (30 days) |
| grace_period | active | Payment succeeds | Card updated or retry succeeds |
| grace_period | free | 30 days expired | Auto-downgrade, data archived |
| active | cancelled | Owner cancels | Access until period end |
| cancelled | free | Period ends | Downgrade to free tier |

---

# PART B — Internal Admin Site (admin.creativanta.app, S26)

## Purpose (Part B)

**Completely separate application** for Creativanta's internal operations team. Not accessible from public internet. Different authentication system. Different RBAC hierarchy. Manages the platform, not a workspace.

> **Full specification**: [S26 — Internal Admin & Operations Site](../creativanta_supplementary_s26_internal_admin_operations_v_3_1.md)

## Architecture (Part B)

| Aspect | Main App | Admin Site |
|---|---|---|
| URL | creativanta.app | admin.creativanta.app |
| Access | Public internet | VPN / Cloudflare Zero-Trust only |
| Auth | Clerk (email/social) | Separate auth, MFA mandatory (TOTP) |
| RBAC | 7 workspace roles | 8 internal roles (§2.1 below) |
| Database | Shared PostgreSQL + RLS | Same DB, admin-scoped views/policies |
| Deployment | Public CDN | Private Docker container, not indexed |
| Session | Standard web session | 30-min timeout, max 1 concurrent |

## Internal Roles (Part B)

8 internal roles, completely separate from workspace roles:

| Role | Level | Scope |
|---|---|---|
| **Super Admin** | L0 | Global — max 2-3 people (Founder/CTO) |
| **Operations Admin** | L1 | User/workspace management, support |
| **Finance Admin** | L1 | Revenue, billing, refunds, payouts |
| **Content Admin** | L1 | Moderation, DMCA, AUP enforcement |
| **Support Admin** | L1 | Ticket management, impersonation (view-only) |
| **Technical Admin** | L1 | System health, feature flags, incidents, deployments |
| **Analyst** | L2 | Read-only dashboard access, reports |
| **Auditor** | L2 | Audit logs, compliance reports, security events |

See: [S26 §2.3](../creativanta_supplementary_s26_internal_admin_operations_v_3_1.md) for full permission matrix.

## Admin Consoles (Part B)

### User & Workspace Management
- User explorer: search, filter, view profile, quick actions (S26 §4)
- Workspace explorer: health scores, subscription status, usage metrics (S26 §5)
- Churn risk detection: scoring algorithm, auto-outreach triggers (S26 §5.3)
- Impersonation: view-as-user (Support Admin+), write-as-user (Super Admin only + OTP per session) (S26 §4.3)

### Billing & Revenue Console
- Revenue dashboard: MRR/ARR, expansion/contraction, churn waterfall (S26 §6.1)
- Payment management: retry, refund, credit adjustment, void (S26 §6.2)
- Dunning management: staged dunning flow D0–D30 with admin intervention points (S26 §6.3)
- AI cost control: per-workspace cost tracking, margin analysis, provider routing override (S26 §6.4)

### Content Moderation Console
- Moderation queue: AI-flagged + user-reported + system-scanned content (S26 §7.1)
- AUP enforcement: 3-strike matrix per violation type (S26 §7.3)
- DMCA processing: takedown within 48h, counter-notice window 14 days (S26 §7 + S22 §S22.4)

### Fraud & Abuse Detection
- Fraud dashboard: trial abuse, multi-account, chargeback, credit gaming, referral abuse (S26 §14.1)
- Device & identity intelligence: fingerprinting, IP analysis, behavioral biometrics (S26 §14.2)
- Fraud case lifecycle: detected → investigating → confirmed/false_positive → resolved (S26 §14.3)

### Job Queue & Background Task Monitor
- Queue dashboard: per-queue depth, processing rate, oldest job age (S26 §15.1)
- Dead-letter queue management: view, retry single/batch, purge with reason (S26 §15.2)
- Workflow/saga state inspector: active runs, stuck detection, force-complete/cancel (S26 §15.4)

### Incident Management
- Incident lifecycle: Detected → Acknowledged → Investigating → Identified → Monitoring → Resolved → Post-mortem (S26 §18.2)
- Status page management: per-service status, public updates, maintenance windows (S26 §18.3)
- Post-mortem required within 48h for Sev1–Sev2 incidents (S26 §18.4)

### System Health & Infrastructure
- System health dashboard: 10 panels covering web/API/DB/cache/queue/AI/storage/CDN/connectors (S26 §9.1)
- Feature flag management: toggle, target (tier/workspace/user), rollout %, dependencies (S26 §9.2)
- Deployment & release management: canary status, rollback button, version history (S26 §9.3)

### Audit & Compliance
- Audit log explorer: immutable, append-only, 7-year retention (S26 §12.1)
- GDPR compliance tools: data subject requests, deletion workflow, consent dashboard (S26 §12.2)
- Security events: brute force, data exfiltration, privilege escalation detection (S26 §12.3)

## Business Rules (Part B)

1. **RULE-M23-B01 (CRITICAL)**: **Admin MUST NOT break canonical truth.** Any admin override (reconciliation, publish state, workflow force-cancel, billing adjustment) MUST include: actor, reason, affected objects, old/new state, timestamp, audit reference. The override object links to the canonical object it modified — the original truth is preserved alongside the override (Pack 06 §10, S26 §1.2).
2. **RULE-M23-B02**: Admin actions are **not operational shortcuts**. Override is an exceptional path, not a default workflow. Patterns to detect: if a specific override is used >10 times daily, trigger review — the system likely needs a proper feature, not repeated admin intervention (Pack 06 §10.3).
3. **RULE-M23-B03**: Impersonation protocol: view-only (Support Admin+) limited to 30 min, write-capable (Super Admin only + OTP per session). Impersonation NEVER touches billing/payment scope. All page views and clicks during impersonation logged. User is NOT notified but audit trail is complete (S26 §4.3).
4. **RULE-M23-B04**: Zero-trust security: VPN + IP whitelist + MFA (TOTP, no SMS) + 30-min session timeout + max 1 concurrent session + 16-char password with 90-day rotation + login anomaly detection (S26 §2.4).

---

# Customer Support Operations

## Purpose (Support Ops)

Customer support bridges both surfaces: users interact through the main app (Part A), while support agents manage tickets through the internal admin site (Part B). The support system uses AI-first triage and tiered SLA per plan.

> **Full legal context**: [01_business/legal_compliance.md#customer-support](../01_business/legal_compliance.md)

## Support Ticket Lifecycle

| From | To | Trigger | Condition |
|---|---|---|---|
| — | open | User submits ticket / AI escalates | Auto-capture data + user description |
| open | in_progress | Support agent claims ticket | Agent assigned (auto or manual) |
| in_progress | awaiting_response | Agent replies, needs user input | Waiting for user |
| awaiting_response | in_progress | User responds | Agent picks up again |
| awaiting_response | auto_closed | No response 7 days | System auto-closes |
| in_progress | resolved | Agent resolves issue | Resolution documented |
| resolved | closed | User confirms or 48h timeout | CSAT survey triggered |
| any | escalated | SLA breach or manual escalation | Escalated to L2/L3/L4 (escalation matrix below) |

## SLA Per Plan

| Metric | Free | Starter | Pro | Business | Enterprise |
|---|---|---|---|---|---|
| First response | 48h | 24h | 8h | 2h | 1h |
| Resolution target | 5 days | 3 days | 1 day | 8h | 4h |
| Channels | Email | Email + chat | +priority chat | +phone | +dedicated TAM |

## Escalation Matrix

| Level | Handler | Trigger | Response |
|---|---|---|---|
| L0 | AI Chatbot | All initial queries | Instant |
| L1 | Support agent | AI escalation / user request | Per SLA tier |
| L2 | Senior specialist | L1 cannot resolve / technical | 2× SLA |
| L3 | Engineering team | Bug confirmed / data issue | 24h max |
| L4 | Management | SLA breach / security / legal | 1h max |

## Support Agent Capabilities (Admin Site)

Support Admins in the internal admin site can:
- View full ticket queue sorted by priority × SLA remaining time
- View user profile with context: plan, workspace, connected accounts, recent errors
- Impersonate user (view-only) for debugging
- Check diagnostics records for user's workspace
- Link ticket to known bug / feature request
- Escalate to engineering with diagnostic bundle auto-attached
- View CSAT trends and resolution metrics (S26 §8.3)

## AI Chatbot (First-Line)

- RAG-based: answers from verified knowledge base only
- Escalation triggers: confidence <70%, billing/payment issue, data loss/security, user requests human, 3+ failed attempts
- Cost: included in subscription (0 AI credits)
- Language: Vietnamese primary, English secondary, auto-detect

---

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../04_contracts/database_schema.md) | §14 (workspace settings, team members, billing), §12 (diagnostics_records) |
| API | [04_contracts/api_endpoint_map.md](../04_contracts/api_endpoint_map.md) | §2.8 (Admin/Billing — ~15 RPCs), §6 (Internal Admin — 28 RPCs) |
| Admin Internal | [04_contracts/api_endpoint_map.md](../04_contracts/api_endpoint_map.md) | §6 (AdminAuthService, UserMgmtService, ModerationService, FraudService, SupportAdminService, IncidentService, SystemConfigService, FeeScheduleService) |
| Events | [04_contracts/domain_event_catalog.md](../04_contracts/domain_event_catalog.md) | §14 (admin.override_applied, audit.event_captured, diagnostics.opened, diagnostics.resolved) |
| RBAC — workspace | [04_contracts/rbac_permission_matrix.md](../04_contracts/rbac_permission_matrix.md) | §5 (workspace admin roles: Owner, Admin, Manager) |
| RBAC — internal | [S26 §2.3](../creativanta_supplementary_s26_internal_admin_operations_v_3_1.md) | Internal admin permission matrix |
| S26 | [S26 — Internal Admin](../creativanta_supplementary_s26_internal_admin_operations_v_3_1.md) | Full internal admin site spec |
| S19 | [S19 — Customer Support](../creativanta_supplementary_s19_customer_support_v_3_1.md) | Support channels, SLA, AI chatbot, escalation |
| S24 | [S24 — Public API](../creativanta_supplementary_s24_public_api_v_3_1.md) | API key management, webhook monitoring |
| Pack 06 | [Pack 06 — Admin Override](../creativanta_detail_design_pack_06_commerce_finance_proof_reporting_admin_contract_v_3_1.md) | §10 (Override Contract), §8 (Reporting) |
| Pack 08 | Pricing & Credits | Used by billing/credit management |

## Related Screens

| Platform | Screen | Surface | Notes |
|---|---|---|---|
| Web | Workspace settings | Part A | Name, branding, mode, timezone |
| Web | Team management | Part A | Invite, role management, member list |
| Web | Billing dashboard | Part A | Plan, payment, invoices, credits |
| Web | Connected accounts | Part A | Platform connections, health badges |
| Web | Diagnostics console | Part A | User-facing error summaries, CTAs |
| Web | Admin command center | Part B (S26) | Live metrics, alert center, widget grid |
| Web | User/workspace explorer | Part B (S26) | Search, profiles, churn risk |
| Web | Revenue dashboard | Part B (S26) | MRR, ARR, dunning, AI cost |
| Web | Moderation queue | Part B (S26) | Flagged content, AUP cases |
| Web | Support ticket queue | Part B (S26) | SLA tracking, impersonation, diagnostics |
| Web | System health | Part B (S26) | Infra panels, feature flags, incidents |
| Web | Fraud dashboard | Part B (S26) | Fraud cases, device intelligence |
| Web | Audit log explorer | Part B (S26) | Immutable logs, GDPR tools |
| Mobile | Quick settings | Part A | Basic workspace management |
| Mobile | Billing check | Part A | Plan/credit balance at a glance |

## Acceptance Criteria

1. **Given** an admin performs a reconciliation override in the internal admin site, **when** the override is applied, **then** the override record MUST contain: actor, reason, affected objects, old/new state, timestamp, audit reference — the original canonical truth MUST be preserved alongside the override, NOT replaced.

2. **Given** a support ticket breaches its SLA response time, **when** the SLA timer expires, **then** the ticket MUST auto-escalate to the next level in the escalation matrix — the SLA breach MUST be visible in the support dashboard with red highlight.

3. **Given** a support admin impersonates a user, **when** the impersonation session starts, **then** a 30-minute timer MUST begin, the session MUST be view-only (no mutations), and every page view during impersonation MUST be logged in the audit trail.

4. **Given** an admin override is used >10 times per day for the same type, **when** the threshold is reached, **then** the system MUST trigger a review notification to Super Admin: "Override [type] used frequently — consider implementing as a proper feature."

5. **Given** a workspace on the Pro plan submits a support ticket, **when** the ticket is routed, **then** first response SLA MUST be 8 hours, the user MUST have access to priority chat, and the ticket MUST show the correct SLA countdown in both user-facing (Part A) and admin-facing (Part B) interfaces.

## Open Questions / Blockers

- [NONE] — Admin endpoints defined in API map §6 (28 RPCs). Workspace admin in §2.8 (~15 RPCs).

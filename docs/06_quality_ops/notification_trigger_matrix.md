---
layer: quality_ops
canonical: true
created: 2026-04-01
---

# Notification Event→Trigger Matrix

> **Purpose**: Maps domain events (from `04_contracts/domain_event_catalog.md`) to notification templates (from `notification_templates.md`).  
> **Resolves**: Review §9 finding "No trigger matrix"

> [!IMPORTANT]
> **Canonical event namespace**: `domain_event_catalog.md` (dot.notation `domain.entity.action`).  
> The "Trigger Event" column below uses notification-friendly names. The "Canonical Event" column maps each to its exact canonical counterpart from the event catalog. When building notification consumers, **subscribe to the Canonical Event name**.

## Event→Notification Mapping

| Trigger Event (this doc) | Canonical Event (`domain_event_catalog.md`) | Template | Channel | Priority | Recipient |
|---|---|---|---|---|---|
| `identity.user.created` | `user.registered` | `welcome` | Email | NORMAL | New user |
| `identity.workspace_member.invited` | `workspace.member_invited` | `workspace_invite` | Email | HIGH | Invitee |
| `identity.auth.suspicious_login` | `auth.suspicious_login` | `security_alert` | Email + Push | HIGH | User |
| `content.script.submitted` | `script.submitted_for_approval` | `script_approval_request` | Email + Push | HIGH | Approver(s) |
| `content.script.approved` | `script.approved` | `script_approved` | Email + Push | NORMAL | Author |
| `publish.item.succeeded` | `publish.succeeded` | `publish_succeeded` | Email + Push | NORMAL | Author |
| `publish.item.failed` | `publish.failed` | `publish_failed` | Email + Push | HIGH | Author |
| `system.brief.generated` | `morning_brief.generated` | `morning_brief` | Email + Push | NORMAL | Workspace owner |
| `billing.credit.low` | `credits.low_warning` | `credit_low` | Email + Push | HIGH | Workspace owner |
| `billing.credit.exhausted` | `credits.exhausted` | `credit_exhausted` | Email + Push | HIGH | Workspace owner |
| `billing.payment.failed` | `subscription.payment_failed` | `payment_failed` | Email | HIGH | Billing contact |
| `billing.payment.succeeded` | `subscription.renewed` | `payment_succeeded` | Email | NORMAL | Billing contact |
| `engagement.thread.priority_changed` | `thread.priority_changed` | `thread_urgent` | Push + In-App | HIGH | Assignee |
| `content.approval.pending` | `script.submitted_for_approval` | `approval_pending` | Push + In-App | HIGH | Approver(s) |
| `finance.profit.anomaly_detected` | `profit.anomaly_detected` | `profit_anomaly` | Push + In-App | HIGH | Workspace owner |
| `gamification.achievement.unlocked` | `achievement.unlocked` | `achievement_unlocked` | Push + In-App | LOW | User |
| `engagement.sla.breached` | `support.sla_breached` | `sla_breach` | Push + In-App | HIGH | Assignee + Manager |
| `automation.workflow.approval_required` | `workflow_run.approval_required` | `workflow_approval` | Push + In-App | HIGH | Approver(s) |
| `commerce.brand_deal.deadline_approaching` | `brand_deal.deadline_approaching` | `brand_deal_deadline` | Email + Push | HIGH | Deal owner |
| `commerce.brand_deal.status_changed` | `brand_deal.status_changed` | `brand_deal_status` | Push + In-App | NORMAL | Deal owner |
| `content.media_kit.generated` | `media_kit.generated` | `media_kit_ready` | In-App | LOW | Creator |
| `content.rate_card.suggestion_ready` | `rate_card.ai_suggested` | `rate_card_suggested` | In-App | LOW | Creator |
| `admin.moderation.content_flagged` | `moderation.case_created` | `admin_moderation_alert` | Email | HIGH | Content Admin |
| `admin.fraud.case_detected` | `fraud.case_detected` | `admin_fraud_alert` | Email | HIGH | Content Admin |
| `admin.user.suspended` | `admin.user_suspended` | `admin_user_suspension` | Email | HIGH | Suspended user |
| `admin.impersonation.started` | `admin.impersonation_started` | `admin_impersonation_notify` | Email | NORMAL | Target user |
| `admin.incident.detected` | `incident.detected` | `admin_incident_alert` | Email | HIGH | Tech Admin |
| `admin.support.sla_breached` | `support.sla_breached` | `admin_sla_breach` | Email | HIGH | Support Admin |
| `identity.user.account_frozen` | `user.account_frozen` | `account_frozen` | Email | HIGH | User |
| `identity.workspace.frozen` | `workspace.frozen` | `workspace_freeze` | Email + Push | HIGH | All members |
| `system.export.completed` | `export.completed` | `export_ready` | Email + In-App | NORMAL | Requester |
| `commerce.referral.qualified` | `referral.qualified` | `referral_reward` | Push + In-App | LOW | Referrer |
| `billing.subscription.renewal_approaching` | `subscription.renewal_approaching` | `subscription_renewal` | Email | NORMAL | Billing contact |
| `billing.payment.retry_scheduled` | `subscription.payment_failed` | `dunning_attempt` | Email | HIGH | Billing contact |
| `system.report.weekly_generated` | `report.weekly_generated` | `weekly_report` | Email | NORMAL | Workspace owner |

> [!NOTE]
> All notification triggers are now mapped to canonical events in `domain_event_catalog.md`. When building notification consumers, **subscribe to the Canonical Event name** (second column).
>
> **Fully resolved (2026-04-04)**: All canonical event names in this matrix now exist verbatim in `domain_event_catalog.md`. The following events were added to the catalog: `user.registered`, `workspace.member_invited`, `auth.suspicious_login`, `thread.priority_changed`, `idea.scored`.

## Events Without Notifications (Intentional)

> These events are consumed by other systems (analytics, workflows, audit) but do NOT trigger user-facing notifications.

| Event Pattern | Canonical Event | Consumer | Reason |
|---|---|---|---|
| `content.idea.scored` | `idea.scored` | Idea board UI (real-time) | UI refresh, not notification |
| `intelligence.signal.detected` | `trend.signal_detected` | Trend radar (batch) | Aggregated in morning brief |
| `commerce.order.*` | `order.imported` / `order.state_changed` (M13) | Order management UI | In-UI real-time updates |
| `production.generation.*` | `asset.generation_started` / `asset.generation_completed` (M07) | Generation job UI (SSE) | Real-time progress bar |
| `*.*.created` (most entities) | Various | Analytics (PostHog) | Too noisy for notifications |
| `*.*.updated` (most entities) | Various | Audit log, search index | Internal only |

## Notification Volume Controls

| Trigger | De-duplicate Window | Batch Window | Max/Day/User |
|---|---|---|---|
| Thread urgent | 5 min | — | 50 |
| Approval pending | 5 min | — | 20 |
| Achievement unlock | — | 15 min | 10 |
| Morning brief | — | — | 1 |
| Credit alerts | 1 hour | — | 3 |
| Admin alerts | — | — | unlimited |

## Cross-references

- **Event catalog**: `04_contracts/domain_event_catalog.md`
- **Notification templates**: `06_quality_ops/notification_templates.md`
- **Queue**: `05_system/queue_retry_design.md` (notification queue)
- **RBAC**: `04_contracts/rbac_permission_matrix.md` (notification preferences per role)

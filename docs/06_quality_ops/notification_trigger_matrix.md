---
layer: quality_ops
canonical: true
created: 2026-04-01
---

# Notification Event→Trigger Matrix

> **Purpose**: Maps domain events (from `04_contracts/domain_event_catalog.md`) to notification templates (from `notification_templates.md`).  
> **Resolves**: Review §9 finding "No trigger matrix"

## Event→Notification Mapping

| Domain Event | Notification Template | Channel | Priority | Recipient |
|---|---|---|---|---|
| `identity.user.created` | `welcome` | Email | NORMAL | New user |
| `identity.workspace_member.invited` | `workspace_invite` | Email | HIGH | Invitee |
| `identity.auth.suspicious_login` | `security_alert` | Email + Push | HIGH | User |
| `content.script.submitted` | `script_approval_request` | Email + Push | HIGH | Approver(s) |
| `content.script.approved` | `script_approved` | Email + Push | NORMAL | Author |
| `publish.item.succeeded` | `publish_succeeded` | Email + Push | NORMAL | Author |
| `publish.item.failed` | `publish_failed` | Email + Push | HIGH | Author |
| `system.brief.generated` | `morning_brief` | Email + Push | NORMAL | Workspace owner |
| `billing.credit.low` | `credit_low` | Email + Push | HIGH | Workspace owner |
| `billing.credit.exhausted` | `credit_exhausted` | Email + Push | HIGH | Workspace owner |
| `billing.payment.failed` | `payment_failed` | Email | HIGH | Billing contact |
| `billing.payment.succeeded` | `payment_succeeded` | Email | NORMAL | Billing contact |
| `engagement.thread.priority_changed` (→urgent) | `thread_urgent` | Push + In-App | HIGH | Assignee |
| `content.approval.pending` | `approval_pending` | Push + In-App | HIGH | Approver(s) |
| `finance.profit.anomaly_detected` | `profit_anomaly` | Push + In-App | HIGH | Workspace owner |
| `gamification.achievement.unlocked` | `achievement_unlocked` | Push + In-App | LOW | User |
| `engagement.sla.breached` | `sla_breach` | Push + In-App | HIGH | Assignee + Manager |
| `automation.workflow.approval_required` | `workflow_approval` | Push + In-App | HIGH | Approver(s) |
| `commerce.brand_deal.deadline_approaching` | `brand_deal_deadline` | Email + Push | HIGH | Deal owner |
| `commerce.brand_deal.status_changed` | `brand_deal_status` | Push + In-App | NORMAL | Deal owner |
| `content.media_kit.generated` | `media_kit_ready` | In-App | LOW | Creator |
| `content.rate_card.suggestion_ready` | `rate_card_suggested` | In-App | LOW | Creator |
| `admin.moderation.content_flagged` | `admin_moderation_alert` | Email | HIGH | Content Admin |
| `admin.fraud.case_detected` | `admin_fraud_alert` | Email | HIGH | Ops Admin |
| `admin.user.suspended` | `admin_user_suspension` | Email | HIGH | Suspended user |
| `admin.impersonation.started` | `admin_impersonation_notify` | Email | NORMAL | Target user |
| `admin.incident.detected` | `admin_incident_alert` | Email | HIGH | Tech Admin |
| `admin.support.sla_breached` | `admin_sla_breach` | Email | HIGH | Ops Admin |
| `identity.user.account_frozen` | `account_frozen` | Email | HIGH | User |
| `identity.workspace.frozen` | `workspace_freeze` | Email + Push | HIGH | All members |
| `system.export.completed` | `export_ready` | Email + In-App | NORMAL | Requester |
| `commerce.referral.qualified` | `referral_reward` | Push + In-App | LOW | Referrer |
| `billing.subscription.renewal_approaching` | `subscription_renewal` | Email | NORMAL | Billing contact |
| `billing.payment.retry_scheduled` | `dunning_attempt` | Email | HIGH | Billing contact |
| `system.report.weekly_generated` | `weekly_report` | Email | NORMAL | Workspace owner |

## Events Without Notifications (Intentional)

> These events are consumed by other systems (analytics, workflows, audit) but do NOT trigger user-facing notifications.

| Event Pattern | Consumer | Reason |
|---|---|---|
| `*.*.created` (most entities) | Analytics (PostHog) | Too noisy for notifications |
| `*.*.updated` (most entities) | Audit log, search index | Internal only |
| `content.idea.scored` | Idea board UI (real-time) | UI refresh, not notification |
| `intelligence.signal.detected` | Trend radar (batch) | Aggregated in morning brief |
| `commerce.order.*` | Order management UI | In-UI real-time updates |
| `production.generation.*` | Generation job UI (SSE) | Real-time progress bar |

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

---
layer: contracts
canonical: true
source_file: domain_event_catalog.md  # was impl_a4_domain_event_catalog.md (legacy name)
last_verified: 2026-03-30
known_issues:
  - EVT-H-001
resolved_issues:
  - EVT-M-001  # connector.degraded + connector.recovered added §15D (2026-04-02)
do_not_edit_without: Đọc 00_index/OPEN_BLOCKERS.md trước khi sửa
---

## Quick Navigation

| Section | Events |
|---|---|
| §1 Event Envelope | DomainEvent struct, EventMetadata struct |
| §2 Identity & Workspace | workspace.created, account.connected, account.sync_completed, etc. |
| §3 Intelligence (M02-M04) | trend.signal_detected, trend.created, opportunity.created, etc. |
| §4 Creation (M05-M06) | idea.created, script.approved, script.ready_for_production, etc. |
| §5 AI Production (M07-M08) | asset.generation_started/completed/failed, continuity.violation_detected, etc. |
| §6 Publish (M10-M11) | publish.queued/scheduled/succeeded/failed, channel_post.synced, etc. |
| §7 Engagement (M12) | thread.created/assigned/resolved, message.received, sponsor_inquiry.detected, etc. |
| §8 Commerce (M13-M16) | product.created, order.imported, offer.activated, campaign.started, conversion.attributed, etc. |
| §9 Live Commerce (M17) | live.session_started/ended, live.highlight_marked, live.offer_pinned |
| §10 Finance & Proof (M19) | settlement.imported/reconciled, profit.anomaly_detected, proof_bundle.assembled, etc. |
| §11 Workflow & Agent (M20-M21) | workflow_run.started/completed/failed, agent_run.started, recipe.installed, etc. |
| §12 System & Admin (M22-M23) | capability.state_changed, credits.deducted/exhausted, subscription.changed, etc. |
| §13-14 Morning Brief & Gamification | morning_brief.generated, achievement.unlocked, xp.earned, level.up |
| §15 Creator Pro (S16) | link_in_bio.page_created, media_kit.generated, brand_deal.status_changed, etc. |
| §15B Extended Production | production.video_edit_job.*, production.remix.*, production.clip_factory.*, etc. (~35 events) |
| §15C-D Gamification & Health | gamification.challenge.*, connector.health_score.*, connector.degraded, connector.recovered, affiliate.link_health.* |
| §16-18 Admin, Support, Operational | admin.user_suspended, moderation.case_created, file.uploaded, consent.granted, etc. |
| §19 Commerce Life-Cycle | refund.*, return.*, chargeback.*, coupon.*, membership.*, commission.*, etc. |
| §20 Event Transport | Tokio mpsc, Redis Streams, PostgreSQL outbox |
| §21 Webhook-Eligible Events | 13 events eligible for S24 Public API webhooks |

# A4 — Domain Event Catalog

> **Upstream**: Pack 03 (Event/Workflow), Product Freeze v3.1
> **Pattern**: `{domain}.{entity}.{action}` — past tense, immutable facts

> **Implementation Rule (Audit v6 — L8)**: All event names in Rust code MUST use the `domain.entity.action` dot-notation (e.g., `content.script.approved`). Pack 03 documentation may reference CamelCase names (e.g., `ScriptApproved`) — these are the same events using documentation-style naming. The Rust `event_type: String` field uses dot-notation exclusively.

---

## 1. Event Envelope

```rust
struct DomainEvent {
    event_id: Uuid,
    event_type: String,        // e.g., "content.script.approved"
    aggregate_type: String,    // e.g., "script"
    aggregate_id: Uuid,
    workspace_id: Uuid,
    actor_id: Option<Uuid>,    // user or system
    actor_type: String,        // user, system, workflow, agent
    payload: serde_json::Value,
    metadata: EventMetadata,
    occurred_at: DateTime<Utc>,
    version: u32,
}

struct EventMetadata {
    correlation_id: Uuid,
    causation_id: Option<Uuid>,
    trace_id: Option<String>,
    operator_mode: Option<String>,
}
```

---

## 2. Identity & Workspace Events

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `workspace.created` | M23 | All | `{workspace_id, owner_id, tier}` |
| `workspace.tier_changed` | M23 | Billing, Limits | `{old_tier, new_tier}` |
| `workspace.suspended` | M23 | All | `{reason}` |
| `workspace.frozen` | M23 | All, Notification | `{workspace_id, frozen_by, reason}` |
| `workspace.member_invited` | M23 | Notification, Audit | `{workspace_id, invitee_email, invited_by, role}` |
| `user.registered` | Identity/Auth | Onboarding, Notification, Analytics | `{user_id, email, registration_method}` |
| `user.account_frozen` | Identity | Notification | `{user_id, reason, frozen_at}` |
| `auth.suspicious_login` | Auth/Security | Notification, Security | `{user_id, ip_address, device_fingerprint, risk_score, location}` |
| `account.connected` | M22 | M11, M12, M02 | `{provider, account_id, scopes}` |
| `account.disconnected` | M22 | M11, M12 | `{provider, account_id, reason}` |
| `account.token_expired` | M22 | Diagnostics | `{provider, account_id}` |
| `account.sync_completed` | M22 | M12, M13 | `{provider, records_synced}` |
| `account.sync_failed` | M22 | Diagnostics | `{provider, error}` |

## 3. Intelligence Events (M02-M04)

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `trend.signal_detected` | M02 | M02 | `{signal_id, type, source}` |
| `trend.created` | M02 | M01, M04, M05 | `{trend_id, title, strength}` |
| `trend.spike_detected` | M02 | M01, Notification | `{trend_id, metric, value}` |
| `trend.expired` | M02 | M01 | `{trend_id}` |
| `opportunity.created` | M04 | M01 | `{opportunity_id, type, priority}` |
| `opportunity.converted` | M04 | M05/M06 | `{opportunity_id, to_type, to_id}` |
| `opportunity.state_changed` | M04 | M01 | `{opportunity_id, from, to}` |

## 4. Creation Events (M05-M06)

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `idea.created` | M05 | M01 | `{idea_id, source_type}` |
| `idea.scored` | M05 | Idea Board UI (real-time) | `{idea_id, score, scoring_criteria, scored_by}` |
| `idea.converted` | M05 | M06 | `{idea_id, to_type, to_id}` |
| `script.created` | M06 | M01 | `{script_id}` |
| `script.submitted_for_approval` | M06 | Notification, M20 | `{script_id, approver_id}` |
| `script.approved` | M06 | M07, M10, Notification | `{script_id, approved_by}` |
| `script.rejected` | M06 | Notification | `{script_id, reason}` |
| `script.ready_for_production` | M06 | M07 | `{script_id, asset_brief_id}` |

## 5. AI Production Events (M07, M08)

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `asset.generation_started` | M07 | M01, Credits | `{asset_id, job_id, provider, est_credits}` |
| `asset.generation_completed` | M07 | M09, M10, Notification | `{asset_id, job_id, duration, credits_used}` |
| `asset.generation_failed` | M07 | Diagnostics, Notification | `{asset_id, job_id, error, provider}` |
| `asset.approved` | M07 | M10, M11 | `{asset_id, approved_by}` |
| `asset.promoted_canonical` | M07 | M08 | `{asset_id, continuity_event}` |
| `continuity.violation_detected` | M08 | Notification | `{asset_id, pack_id, type, severity}` |
| `continuity.pack_updated` | M08 | M07 | `{pack_id, version}` |
| `character.created` | M08 | M07 | `{character_id, type}` |
| `clip.extracted` | M07 | M09 | `{asset_id, parent_id, clip_index}` |
| `remix.completed` | M07 | M09, M10 | `{asset_id, source_ref}` |

## 6. Publish Events (M10, M11)

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `publish.packaging_scored` | M10 | M01 | `{publish_item_id, score, blockers}` |
| `publish.compliance_scanned` | M10 | M11, Notification | `{publish_item_id, result}` |
| `publish.queued` | M11 | M01 | `{publish_item_id, platform}` |
| `publish.scheduled` | M11 | M01, Notification | `{publish_item_id, schedule_at}` |
| `publish.executing` | M11 | M01 | `{publish_item_id, job_id}` |
| `publish.succeeded` | M11 | M01, M12, M19, Notification | `{publish_item_id, external_id, url}` |
| `publish.failed` | M11 | Diagnostics, Notification | `{publish_item_id, error, fallback}` |
| `publish.requires_manual_fallback` | M11 | Notification | `{publish_item_id, reason}` |
| `channel_post.synced` | M11 | M12, M19 | `{post_id, engagement_snapshot}` |

## 7. Engagement Events (M12)

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `thread.created` | M12 | M01, Notification | `{thread_id, type, intent, priority}` |
| `thread.intent_classified` | M12 | M20 | `{thread_id, intent, confidence}` |
| `thread.assigned` | M12 | Notification | `{thread_id, assigned_to}` |
| `thread.priority_changed` | M12 | Notification, M20 | `{thread_id, old_priority, new_priority, changed_by}` |
| `thread.resolved` | M12 | M01 | `{thread_id}` |
| `thread.sla_approaching` | M12 | Notification | `{thread_id, sla_due_at}` |
| `thread.sla_breached` | M12 | M01, Notification | `{thread_id}` |
| `message.received` | M12 | M12 (intent), M20 | `{message_id, thread_id, direction}` |
| `sponsor_inquiry.detected` | M12 | M01, Notification | `{thread_id, entity_id}` |
| `follow_up_task.created` | M12 | Notification | `{task_id, assigned_to, due_at}` |

## 8. Commerce Events (M13-M16)

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `product.created` | M13 | M14, M15 | `{product_id, type}` |
| `product.catalog_status_changed` | M13 | M14, M15, M16 | `{product_id, from, to}` |
| `order.imported` | M13 | M19 | `{order_id, platform, amount}` |
| `order.state_changed` | M13 | M19, M01 | `{order_id, from, to}` |
| `order.refund_initiated` | M13 | M19 | `{order_id, refund_amount}` |
| `offer.activated` | M14 | M01, M11, M15 | `{offer_id, type}` |
| `offer.expired` | M14 | M01, Notification | `{offer_id}` |
| `campaign.started` | M14 | M01, M16, M17, M18 | `{campaign_id}` |
| `campaign.completed` | M14 | M19, Notification | `{campaign_id}` |
| `affiliate_link.created` | M16 | M14 | `{link_id, product_id}` |
| `affiliate_link.health_degraded` | M16 | Diagnostics | `{link_id, status}` |
| `conversion.attributed` | M16 | M19 | `{order_id, link_id, commission}` |
| `affiliate.commission.earned` | M16 | M19, Notification | `{commission_id, affiliate_link_id, order_id, amount, currency}` |
| `affiliate.commission.confirmed` | M16 | M19, Notification | `{commission_id, amount, hold_period_days}` |
| `affiliate.commission.clawed_back` | M16 | M19, Notification | `{commission_id, clawback_reason, refund_amount}` |
| `affiliate.commission.paid_out` | M16 | M19 | `{commission_id, payout_id, amount}` |

## 9. Live Commerce Events (M17)

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `live.session_started` | M17 | M01, M12 | `{session_id, platform}` |
| `live.session_ended` | M17 | M19, M20, Notification | `{session_id, summary}` |
| `live.highlight_marked` | M17 | M09 | `{session_id, timestamp, type}` |
| `live.offer_pinned` | M17 | M14 | `{session_id, offer_id}` |
| `live.cue_triggered` | M17 | — | `{session_id, cue_id}` |

## 10. Finance & Proof Events (M19)

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `settlement.imported` | M19 | M23 | `{settlement_id, amount}` |
| `settlement.reconciled` | M19 | M01 | `{settlement_id, match_count}` |
| `cost.recorded` | M19 | Profit calc | `{cost_item_id, type, amount}` |
| `profit.snapshot_updated` | M19 | M01 | `{scope_type, scope_id, net_profit}` |
| `profit.anomaly_detected` | M19 | M01, Notification, M20 | `{scope, anomaly_type, severity}` |
| `evidence.submitted` | M19 | — | `{evidence_id, type}` |
| `proof_bundle.assembled` | M19 | M01, Notification | `{bundle_id, claim_scope}` |
| `reconciliation.conflict_detected` | M19 | Notification | `{record_id, type}` |

## 11. Workflow & Agent Events (M20, M21)

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `workflow.created` | M20 | Audit | `{workflow_id, version}` |
| `workflow.activated` | M20 | M23 | `{workflow_id}` |
| `workflow.paused` | M20 | M23, Audit | `{workflow_id, reason}` |
| `workflow.archived` | M20 | Audit | `{workflow_id}` |
| `workflow_run.started` | M20 | M01, Audit | `{run_id, workflow_id, trigger}` |
| `workflow_run.completed` | M20 | M01, Audit | `{run_id, status, side_effects}` |
| `workflow_run.partially_completed` | M20 | M01, Audit, Notification | `{run_id, unresolved_actions[]}` |
| `workflow_run.failed` | M20 | Diagnostics, Notification | `{run_id, error}` |
| `workflow_run.cancelled` | M20 | Audit | `{run_id, cancelled_by}` |
| `workflow_run.manual_intervention_required` | M20 | Notification, Audit | `{run_id, current_node, reason}` |
| `workflow_run.approval_required` | M20 | Notification | `{run_id, action, approver}` |
| `agent_run.started` | M21 | Audit | `{run_id, current_state, plan_summary}` |
| `agent_run.approval_required` | M21 | Notification | `{run_id, risk_actions[], approver_ids[]}` |
| `agent_run.waiting_context` | M21 | Notification | `{run_id, requested_context_type, prompt}` |
| `agent_run.completed` | M21 | Audit | `{run_id, side_effects}` |
| `agent_run.partially_completed` | M21 | Audit, Notification | `{run_id, unresolved_actions[]}` |
| `agent_run.failed` | M21 | Diagnostics, Notification | `{run_id, error}` |
| `agent_run.handed_off` | M21 | Notification | `{run_id, handoff_to}` |
| `agent_run.cancelled` | M21 | Audit | `{run_id, cancelled_by}` |
| `recipe.installed` | M21 | M20 | `{recipe_id, workflow_id}` |

## 12. System & Admin Events (M22, M23)

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `capability.state_changed` | M22 | M11, M01, Diagnostics | `{platform, action, from, to}` |
| `policy.note_created` | M22 | M11 | `{policy_note_id, scope}` |
| `credits.deducted` | M23 | M01 | `{workspace_id, amount, balance}` |
| `credits.low_warning` | M23 | Notification | `{workspace_id, remaining}` |
| `credits.exhausted` | M23 | All AI | `{workspace_id}` |
| `subscription.payment_failed` | M23 | Dunning | `{workspace_id, attempt}` |
| `subscription.changed` | M23 | Limits | `{workspace_id, from_tier, to_tier}` |
| `diagnostics.record_created` | M23 | M01, Notification | `{diagnostics_id, severity}` |
| `diagnostics.opened` | M23 | Audit, Analytics | `{workspace_id, actor_user_id, surface}` |
| `diagnostics.resolved` | M23 | M01, Notification, Audit | `{diagnostics_id, resolved_by, resolution_type}` |
| `referral.qualified` | M23 | Credits, Notification | `{referrer_id, referee_id}` |

## 13. Morning Brief Event (§35)

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `morning_brief.generated` | Cron/M01 | Push, Email | `{workspace_id, brief_id, sections}` |
| `morning_brief.delivered` | Push/Email | Analytics | `{workspace_id, channel, delivered_at}` |
| `report.weekly_generated` | Cron/M01 | Email | `{workspace_id, report_id, week_number, sections}` |

## 14. Gamification Events (§37.3)

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `achievement.unlocked` | Achievement | Notification, Credits | `{workspace_id, achievement_code, credits}` |
| `xp.earned` | Achievement | Progress | `{workspace_id, xp_amount, source}` |
| `level.up` | Achievement | Notification | `{workspace_id, new_level}` |
| `streak.broken` | Achievement | Notification | `{workspace_id, streak_days}` |

## 15. Creator Pro Tools Events (S16)

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `link_in_bio.page_created` | S16 | Analytics | `{page_id, slug}` |
| `link_in_bio.link_clicked` | S16 | Analytics | `{page_id, link_id, referrer}` |
| `link_in_bio.link_flagged` | S16 | Moderation | `{link_id, reason}` |
| `media_kit.generated` | S16 | Credits | `{media_kit_id, credits_used}` |
| `rate_card.ai_suggested` | S16 | Credits | `{rate_card_id, credits_used}` |
| `brand_deal.status_changed` | S16 | M19, Notification | `{deal_id, from, to, value}` |
| `brand_deal.deadline_approaching` | S16 | Notification | `{deal_id, deadline, days_remaining}` |

## 16. Internal Admin Events (S26) [GLOBAL]

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `admin.user_suspended` | S26 | User, Email | `{user_id, reason, duration}` |
| `admin.user_unsuspended` | S26 | User, Email | `{user_id}` |
| `admin.credits_adjusted` | S26 | Credits, Audit | `{workspace_id, amount, reason, admin_id}` |
| `admin.plan_overridden` | S26 | Billing | `{workspace_id, from_tier, to_tier, reason}` |
| `admin.refund_issued` | S26 | Billing, Audit | `{workspace_id, amount, reason}` |
| `admin.override_applied` | S26 | Audit, Billing, Finance, Workflow | `{override_id, domain, object_ref, old_state, new_state, admin_id, reason}` |
| `admin.impersonation_started` | S26 | Audit, Security | `{admin_id, target_user_id, mode}` |
| `admin.impersonation_ended` | S26 | Audit | `{session_id, duration_seconds}` |
| `moderation.case_created` | S26 | Content Admin | `{case_id, type, severity, object_ref}` |
| `moderation.case_resolved` | S26 | Audit | `{case_id, action, resolution}` |
| `fraud.case_detected` | S26 | Content Admin | `{case_id, type, severity, implicated_users}` |
| `fraud.case_confirmed` | S26 | Finance Admin | `{case_id, financial_impact}` |
| `feature_flag.toggled` | S26 | All services | `{flag_name, enabled, rollout_pct, toggled_by}` |
| `system.announcement_published` | S26 | All users | `{announcement_id, type, target_scope}` |
| `system.maintenance_mode_changed` | S26 | All services | `{enabled, reason}` |
| `incident.detected` | S26 | Tech Admin | `{incident_id, severity, affected_services}` |
| `incident.resolved` | S26 | Tech Admin | `{incident_id, resolution, duration}` |
| `system.alert_triggered` | S26 | Admin Dashboard | `{alert_id, type, severity, value}` |

## 17. Support Events (S19)

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `support.ticket_created` | S19 | Support Admin | `{ticket_id, user_id, category, priority}` |
| `support.ticket_assigned` | S19 | Support Admin | `{ticket_id, admin_id}` |
| `support.ticket_escalated` | S19 | Operations Admin | `{ticket_id, reason}` |
| `support.ticket_resolved` | S19 | User, Analytics | `{ticket_id, resolution_time_mins}` |
| `support.sla_breached` | S19 | Support Admin, Alert | `{ticket_id, sla_type}` |

## 18. Operational Events

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `audit.event_captured` | Platform | Audit, Forensics | `{audit_event_id, actor_id, action, object_ref, source_ip}` |
| `file.uploaded` | System | Virus Scanner | `{upload_id, purpose, size_bytes, mime_type}` |
| `file.virus_detected` | Scanner | Security Alert | `{upload_id, threat_name}` |
| `export.completed` | System | Notification | `{export_id, type, file_url}` |
| `api_key.created` | S24 | Audit | `{api_key_id, workspace_id, scopes}` |
| `api_key.suspended` | S24/Admin | Audit, Notification | `{api_key_id, reason}` |
| `consent.granted` | System | Compliance | `{user_id, consent_type, version}` |
| `consent.revoked` | System | Compliance | `{user_id, consent_type}` |
| `referral.rewarded` | M23 | Credits | `{referrer_id, referee_id, credits}` |
| `referral.fraud_detected` | Fraud | Finance Admin | `{referral_id, reason}` |

## 19. Commerce Life-Cycle Events (Round 2 Additions)

| Event Type | Emitter | Key Consumers | Payload |
|---|---|---|---|
| `refund.requested` | M13 | M19, Notification | `{refund_id, order_id, amount}` |
| `refund.approved` | M13 | M19 | `{refund_id, approved_by}` |
| `refund.completed` | M13 | M19, Notification | `{refund_id, settlement_id}` |
| `return.requested` | M13 | M19, Notification | `{return_id, order_id, items}` |
| `return.received` | M13 | M19 | `{return_id}` |
| `chargeback.opened` | M19 | Alert, M13 | `{chargeback_id, order_id, amount}` |
| `chargeback.evidence_submitted` | M19 | Audit | `{chargeback_id}` |
| `chargeback.resolved` | M19 | M13, Notification | `{chargeback_id, outcome}` |
| `coupon.activated` | M14 | M15 | `{coupon_id, code}` |
| `coupon.used` | M14 | M19 | `{coupon_id, order_id}` |
| `coupon.expired` | M14 | Notification | `{coupon_id}` |
| `membership.subscribed` | M15 | M19, Notification | `{plan_id, entity_id}` |
| `membership.cancelled` | M15 | M19, Notification | `{plan_id, entity_id, reason}` |
| `subscription.trial_ending` | M23 | Notification | `{workspace_id, trial_ends_at}` |
| `subscription.renewed` | M23 | Billing | `{subscription_id}` |
| `subscription.cancelled` | M23 | All | `{subscription_id, reason}` |
| `commission.calculated` | M16 | M19 | `{commission_id, amount}` |
| `commission.paid` | M16 | M19, Notification | `{commission_id, payout_ref}` |
| `store.page_published` | M15 | Analytics | `{store_page_id, slug}` |
| `live_segment.created` | M17 | M19 | `{segment_id, session_id, type}` |
| `sample_request.created` | M18 | M20, Notification | `{request_id, campaign_id, product_id, creator_entity_id}` |
| `sample_request.approved` | M18 | M20, Notification | `{request_id, approved_by}` |
| `sample_request.declined` | M18 | Notification | `{request_id, reason}` |
| `creator_assignment.created` | M18 | M20, Notification | `{assignment_id, campaign_id, creator_entity_id}` |
| `sample.shipped` | M18 | Notification | `{shipment_id, request_id, tracking}` |
| `sample.delivered` | M18 | Notification | `{shipment_id}` |
| `copilot.session_started` | §34 | Usage tracking | `{session_id, mode}` |
| `copilot.session_ended` | §34 | Credits | `{session_id, credits_used}` |

## 15B. Extended Production Events (Audit v5 — H1: Pack 03 §3.1B-C)

> **Ref**: Pack 03 §3.1B-C, Pack 04 §9.6-9.16, Pack 02 §3.4.
> **Naming reconciliation**: Pack 03 uses CamelCase display names (e.g., `VideoEditJobCreated`). Implementation MUST use the canonical `{domain}.{entity}.{action}` pattern below.

| Event | Owner | Consumer | Payload Key Fields |
|---|---|---|---|
| `production.video_edit_job.created` | M07 | Queue, Credits | `{job_id, mode, workspace_id, estimated_credits}` |
| `production.video_edit_job.started` | M07 | UI, Credits | `{job_id, mode}` |
| `production.video_edit_job.completed` | M07 | UI, Credits, Profit OS | `{job_id, mode, credits_used, output_asset_ids}` |
| `production.video_edit_job.failed` | M07 | UI, Credits (refund), Diagnostics | `{job_id, mode, error_code, error_message}` |
| `production.quick_edit.applied` | M07 | UI | `{job_id, edits_applied[], asset_id}` |
| `production.clip_factory.analyzed` | M07 | UI | `{collection_id, total_clips, source_asset_id}` |
| `production.clip_factory.clips_proposed` | M07 | UI | `{collection_id, clip_data[]}` |
| `production.virality_score.calculated` | M07 | UI, Analytics | `{asset_id, score, breakdown}` |
| `production.multi_merge.assembled` | M07 | UI | `{job_id, output_asset_id, source_count}` |
| `production.remix.analysis_started` | M07 | UI | `{blueprint_id, reference_asset_id}` |
| `production.remix.creative_dna_extracted` | M07 | UI | `{blueprint_id, creative_dna}` |
| `production.remix.generation_completed` | M07 | UI, Credits | `{blueprint_id, output_asset_id, originality_score}` |
| `production.remix.originality_checked` | M07 | UI, Compliance | `{blueprint_id, score, passed}` |
| `production.product_showcase.created` | M07 | Queue | `{showcase_job_id, product_id, style}` |
| `production.product_showcase.completed` | M07 | UI, Credits | `{showcase_job_id, output_asset_id, credits_used}` |
| `production.product_showcase.batch_queued` | M07 | Queue | `{batch_id, product_ids[], style}` |
| `production.image_to_video.generated` | M07 | UI, Credits | `{job_id, output_asset_id}` |
| `production.thumbnail.generated` | M07 | UI | `{job_id, output_urls[]}` |
| `production.thumbnail.ab_test_started` | M07/M10 | Analytics | `{experiment_id, variant_count}` |
| `production.link_to_video.scraped` | M07 | UI | `{ltv_job_id, scraped_data}` |
| `production.link_to_video.generated` | M07 | UI, Credits | `{ltv_job_id, output_asset_id, credits_used}` |
| `production.translation.started` | M07 | Queue | `{translation_job_id, source_asset_id, target_languages[]}` |
| `production.translation.language_completed` | M07 | UI | `{translation_job_id, language, output_asset_id}` |
| `production.translation.completed` | M07 | UI, Credits | `{translation_job_id, total_credits_used}` |
| `production.sound_studio.track_generated` | M07 | UI, Credits | `{job_id, track_type, duration_s}` |
| `production.style_pack.extracted` | M08 | UI | `{style_pack_id, source_asset_id}` |
| `production.style_pack.applied` | M08 | UI | `{style_pack_id, target_job_id}` |
| `production.video_agent.pipeline_started` | M07 | UI, Queue | `{job_id, pipeline_steps[]}` |
| `production.video_agent.pipeline_completed` | M07 | UI, Credits | `{job_id, output_asset_ids[], total_credits}` |
| `production.performance_report.generated` | M07 | UI | `{report_id, period, workspace_id}` |
| `production.ab_test.started` | M10 | Analytics | `{experiment_id, source_asset_id, variant_count}` |
| `production.ab_test.winner_determined` | M10 | UI, Analytics | `{experiment_id, winner_asset_id}` |
| `production.repurpose.started` | M09 | Queue | `{repurpose_job_id, source_asset_id, pipeline_config}` |
| `production.repurpose.completed` | M09 | UI, Credits | `{repurpose_job_id, output_asset_ids[]}` |

## 15C. Gamification Challenge Events (Audit v5 — H1)

| Event | Owner | Consumer | Payload Key Fields |
|---|---|---|---|
| `gamification.challenge.started` | Growth | UI | `{challenge_id, start_date, end_date}` |
| `gamification.challenge.progress_updated` | Growth | UI | `{progress_id, challenge_id, current_value, target_value}` |
| `gamification.challenge.completed` | Growth | UI, Credits | `{progress_id, challenge_id, reward_credits}` |
| `gamification.voice_clone.created` | M08 | UI | `{voice_clone_id, character_id, status}` |
| `gamification.voice_clone.ready` | M08 | UI | `{voice_clone_id, character_id}` |

## 15D. Platform Health Events (Audit v5 — H1)

| Event | Owner | Consumer | Payload Key Fields |
|---|---|---|---|
| `connector.health_score.captured` | M22 | UI, Admin | `{score_id, platform, overall_score, degraded_features[]}` |
| `connector.degraded` | M22 | M11, M01, Notification, Diagnostics | `{platform, degraded_features[], overall_score, reason, detected_at}` |
| `connector.recovered` | M22 | M11, M01, Notification | `{platform, recovered_features[], overall_score, downtime_minutes, recovered_at}` |
| `affiliate.link_health.checked` | M16 | UI, Notification | `{health_id, link_status, estimated_revenue_impact}` |
| `affiliate.link_health.broken` | M16 | Notification (Critical) | `{health_id, affiliate_link_id, suggested_action}` |

---

## 16. Notification-Required Events

> Events required by `notification_trigger_matrix.md` that were not previously catalogued. Added 2026-04-06.

### 16.1 Identity & Admin

| Event | Owner | Consumer | Payload Key Fields |
|---|---|---|---|
| `user.created` | Auth | M01, Notification, Analytics | `{user_id, email, signup_method, created_at}` |
| `user.suspended` | Admin | Notification, Auth | `{user_id, reason, suspended_by, suspended_at}` |
| `moderation.content_flagged` | Admin/AI | Notification, Admin | `{content_id, content_type, flag_reason, confidence}` |

### 16.2 Billing & Subscription

| Event | Owner | Consumer | Payload Key Fields |
|---|---|---|---|
| `payment.failed` | Billing | Notification, Admin | `{workspace_id, amount, currency, failure_reason, retry_count}` |
| `payment.succeeded` | Billing | Notification | `{workspace_id, amount, currency, invoice_id}` |
| `payment.retry_scheduled` | Billing | Notification | `{workspace_id, retry_at, retry_count}` |
| `credit.exhausted` | Billing | Notification, M01 | `{workspace_id, tier, last_operation}` |
| `credit.low` | Billing | Notification | `{workspace_id, remaining_credits, threshold_pct}` |
| `subscription.renewal_approaching` | Billing | Notification | `{workspace_id, tier, renewal_date, days_until}` |

### 16.3 Content & Production

| Event | Owner | Consumer | Payload Key Fields |
|---|---|---|---|
| `approval.pending` | M10 | Notification, M11 | `{item_id, item_type, submitted_by, approver_ids[]}` |
| `rate_card.suggestion_ready` | S16 | Notification | `{workspace_id, suggestion_id, suggested_rate}` |

### 16.4 Engagement & Automation

| Event | Owner | Consumer | Payload Key Fields |
|---|---|---|---|
| `sla.breached` | M12 | Notification, Admin | `{thread_id, sla_type, breach_minutes, priority}` |
| `workflow_run.approval_required` | M20 | Notification | `{run_id, workflow_id, step_name, approver_ids[]}` |

### 16.5 Publish

| Event | Owner | Consumer | Payload Key Fields |
|---|---|---|---|
| `publish_item.failed` | M11 | Notification, M01 | `{publish_item_id, platform, error_category, error_message}` |
| `publish_item.succeeded` | M11 | Notification, M01, Analytics | `{publish_item_id, platform, external_url, published_at}` |

### 16.6 Intelligence

| Event | Owner | Consumer | Payload Key Fields |
|---|---|---|---|
| `signal.detected` | M02 | Notification, M04 | `{signal_id, signal_type, platform, confidence, trend_id}` |

---

## 20. Event Transport

| Channel | Tech | Use |
|---|---|---|
| **In-process** | Tokio mpsc channels | Same-service domain events |
| **Cross-service** | Redis Streams (Dragonfly) | Real-time event distribution |
| **Durable** | PostgreSQL + outbox pattern | Critical business events |
**Total: ~250 event types** covering all 23 modules + S16/S19/S26 + commerce lifecycles + operational events + M18 seeding lifecycle + extended production (M07 Pack 04 §9.6-9.16) + gamification challenges + platform health (connector.degraded/recovered) + identity freeze events + billing/payment events + notification-required events (§16) + affiliate commission events (§8).

---

## 21. Webhook-Eligible Events (S24 Public API)

> **Ref**: S24 (Public API). Events tagged below are available for external webhook delivery to third-party consumers via the Public API.

### 21.1 Webhook Event Selection Criteria
- Event must represent a **completed business action** (not intermediate states)
- Event must **not** leak internal implementation details (e.g., provider route, internal actor IDs)
- Event payload must be **workspace-scoped** (no cross-tenant data)
- Events are delivered via HTTP POST with HMAC-SHA256 signature verification

### 21.2 Webhook-Eligible Events

| Event Type | Webhook Name | Payload (external) |
|---|---|---|
| `publish.succeeded` | `content.published` | `{publish_item_id, platform, external_url, published_at}` |
| `publish.failed` | `content.publish_failed` | `{publish_item_id, platform, error_category}` |
| `order.imported` | `order.created` | `{order_id, platform, total_amount, currency}` |
| `order.state_changed` | `order.updated` | `{order_id, status, updated_at}` |
| `refund.completed` | `refund.completed` | `{refund_id, order_id, amount, currency}` |
| `thread.created` | `engagement.thread_created` | `{thread_id, type, intent, platform}` |
| `asset.generation_completed` | `asset.ready` | `{asset_id, type, duration_secs}` |
| `workflow_run.completed` | `workflow.completed` | `{run_id, workflow_id, status}` |
| `subscription.changed` | `billing.plan_changed` | `{workspace_id, from_tier, to_tier}` |
| `credits.exhausted` | `billing.credits_exhausted` | `{workspace_id}` |
| `brand_deal.status_changed` | `brand_deal.updated` | `{deal_id, status, value}` |
| `live.session_ended` | `live.ended` | `{session_id, duration_mins, summary}` |
| `achievement.unlocked` | `gamification.achievement` | `{workspace_id, achievement_code}` |

### 21.3 Webhook Configuration
- Workspace Settings → API → Webhooks
- Per-workspace, per-event-type subscription
- Retry policy: 3 retries with exponential backoff (1s, 10s, 60s)
- Failed delivery after 3 retries → logged, user notified, webhook suspended after 100 consecutive failures
- Webhook secret rotation: available via Settings

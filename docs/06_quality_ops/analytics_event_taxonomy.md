---
layer: quality_ops
canonical: true
source_file: impl_d3_analytics_event_taxonomy.md
last_verified: 2026-04-09
---

# D3 — Analytics Event Taxonomy (PostHog)

> **Upstream**: Pack 01, Tech Stack ADR v3
> Coverage note: this is the canonical minimum analytics taxonomy for the full active corpus. Screen-level analytics sections may define more detailed events, but they MUST roll up to the event families and KPI intent declared here.

---

## 1. Event Naming: two forms

Creativanta uses two analytics-event naming forms depending on scope:

| Form | Shape | Used for | Example |
|---|---|---|---|
| **Module family** (rollup) | `{object}_{action}` snake_case, past tense | The minimum event families in §3 that each module MUST emit. These are the PostHog-catalog events surfaced in funnels and KPI dashboards. | `script_created`, `affiliate_link_created`, `publish_executed` |
| **Screen drill-down** | `{domain}.{resource}.{action}` dot-notation | Fine-grained UX telemetry emitted from specific screens — clicks, tab switches, filter changes. Each drill-down event MUST roll up to a module family above. | `affiliate.link.created`, `admin.abuse.actioned`, `affiliate.mobile.viewed` |

**Rollup rule**: every dot-notation screen event MUST be attributable to one of the module families in §3. Adding a drill-down event that has no rollup family means the owning module is not analytics-ready (per Governance Rule §5.5).

**Do not mix forms for the same concept**: if a rollup family exists (e.g., `affiliate_link_created`), the drill-down event for the "create link" action MUST share the same verb (e.g., `affiliate.link.created`) — not diverge to `affiliate.link.new` or `affiliate.link.added`.


## 1.1 Required Common Properties

All product analytics events SHOULD include these properties when applicable:

| Property | Meaning |
|---|---|
| `workspace_id` | Canonical workspace scope |
| `surface` | `web`, `mobile`, `admin`, `shared` |
| `module` | Owning module (`M01`, `M14`, `S26`, etc.) |
| `operator_mode` | Active operator mode from business docs |
| `plan_tier` | Current subscription tier |
| `actor_role` | Workspace role or internal admin role |
| `result` | `success`, `error`, `blocked`, `empty` |
| `source_class` | When the action touches proof/finance data |
| `confidence` | `high`, `medium`, `low` where applicable |
| `latency_ms` | Client-observed or server round-trip duration |

## 2. Core Events

### Navigation & Engagement
| Event | Properties |
|---|---|
| `page_viewed` | `page_name, route, module, operator_mode, duration_ms` |
| `feature_used` | `feature_name, module, action_type` |
| `search_executed` | `query, results_count, module` |
| `copilot_queried` | `mode, query_length, credits_used, response_time_ms` |
| `notification_clicked` | `notification_type, deep_link` |
| `onboarding_step_completed` | `step_number, step_name` |
| `onboarding_completed` | `total_time_seconds` |

### Content Creation
| Event | Properties |
|---|---|
| `idea_created` | `source_type, ai_generated` |
| `script_created` | `format_type, from_idea` |
| `script_approved` | `time_to_approve_hours` |
| `asset_generated` | `provider, type, credits_used, duration_s` |
| `asset_generation_failed` | `provider, error_type` |
| `asset_approved` | `time_to_approve_hours` |

### Publishing
| Event | Properties |
|---|---|
| `publish_scheduled` | `platform, schedule_hours_ahead` |
| `publish_executed` | `platform, mode, result` |
| `publish_failed` | `platform, error_type, fallback_used` |

### Commerce
| Event | Properties |
|---|---|
| `order_imported` | `platform, amount, currency` |
| `offer_activated` | `offer_type, has_product` |
| `affiliate_link_created` | `platform, product_id` |

### Finance
| Event | Properties |
|---|---|
| `profit_dashboard_viewed` | `scope_type, period` |
| `reconciliation_performed` | `match_count, conflict_count` |

### Workflow
| Event | Properties |
|---|---|
| `workflow_created` | `type, node_count` |
| `workflow_run_completed` | `workflow_id, status, duration_s` |
| `recipe_installed` | `recipe_id, source` |

---

## 3. Minimum Module Coverage Matrix

Each active module/spec below defines the minimum analytics events that MUST exist before the implementation is considered instrumentation-complete.

| Module | Required Event Families | KPI / Outcome Intent |
|---|---|---|
| `auth` | `login_completed`, `workspace_invitation_accepted`, `onboarding_completed` | Activation, invite conversion |
| `M01` | `home_dashboard_viewed`, `brief_card_opened`, `suggested_action_completed` | Daily engagement, brief usefulness |
| `M02` | `trend_radar_viewed`, `trend_saved`, `watchlist_created` | Trend discovery retention |
| `M03` | `competitor_added`, `competitor_benchmark_viewed`, `competitor_alert_created` | Competitive research adoption |
| `M04` | `opportunity_scored`, `opportunity_promoted`, `opportunity_converted` | Signal-to-action conversion |
| `M05` | `idea_created`, `idea_promoted`, `idea_converted` | Idea throughput and conversion |
| `M06` | `script_created`, `script_submitted`, `script_approved` | Script approval velocity |
| `M07` | `asset_generated`, `generation_retry_requested`, `generation_failed` | AI generation success and cost efficiency |
| `M08` | `continuity_pack_created`, `continuity_pack_activated`, `continuity_drift_detected` | Continuity adoption and drift containment |
| `M09` | `derivative_created`, `derivative_published`, `derivative_performance_viewed` | Asset reuse yield |
| `M10` | `packaging_check_started`, `packaging_issue_detected`, `packaging_override_submitted` | Publish-readiness and compliance quality |
| `M11` | `publish_scheduled`, `publish_executed`, `publish_failed` | Publish success rate |
| `M12` | `thread_opened`, `reply_sent`, `thread_sla_breached` | Response throughput and SLA control |
| `M13` | `product_created`, `product_synced`, `inventory_alert_opened` | Catalog health and sync quality |
| `M14` | `offer_created`, `coupon_created`, `campaign_launched` | Monetization setup velocity |
| `M15` | `store_page_published`, `membership_plan_activated`, `subscription_started` | Direct-store conversion |
| `M16` | `affiliate_link_created`, `affiliate_conversion_imported`, `affiliate_payout_viewed` | Attribution and affiliate yield |
| `M17` | `live_session_created`, `live_session_started`, `live_offer_pinned` | Live commerce adoption |
| `M18` | `sample_request_created`, `sample_shipped`, `sample_outcome_logged` | Seeding throughput and outcome coverage |
| `M19` | `profit_dashboard_viewed`, `reconciliation_performed`, `proof_bundle_assembled` | Financial trust and reconciliation completion |
| `M20` | `workflow_created`, `workflow_activated`, `workflow_run_completed` | Automation adoption and reliability |
| `M21` | `recipe_viewed`, `recipe_installed`, `agent_run_started` | Template adoption and agent usage |
| `M22` | `capability_matrix_viewed`, `capability_alert_reviewed`, `connector_gap_opened` | Capability awareness and remediation |
| `M23` | `billing_plan_viewed`, `invoice_downloaded`, `credit_pack_purchased` | Billing conversion and self-service administration |
| `copilot` | `copilot_queried`, `copilot_action_applied`, `copilot_feedback_submitted` | Assistant usefulness |
| `referral` | `referral_link_shared`, `referral_signup_attributed`, `referral_reward_claimed` | Referral funnel yield |
| `gamification` | `achievement_unlocked`, `challenge_joined`, `streak_extended` | Retention loops |
| `help` | `help_article_viewed`, `support_ticket_created`, `status_page_viewed` | Support deflection and issue transparency |
| `S16` | `media_kit_published`, `brand_deal_created`, `revenue_tracker_viewed` | Creator Pro adoption |
| `S24` | `api_key_created`, `api_key_rotated`, `webhook_replayed` | Developer platform adoption and reliability |
| `S26` | `admin_dashboard_viewed`, `admin_impersonation_started`, `moderation_action_taken` | Internal ops throughput and risk oversight |

## 4. Key Funnels
1. **Content Loop**: idea_created → script_created → script_approved → asset_generated → publish_executed
2. **Onboarding**: onboarding_step_1 → step_2 → ... → onboarding_completed
3. **Commerce**: offer_activated → affiliate_link_created → order_imported
4. **Support Resolution**: help_article_viewed → support_ticket_created → thread_resolved
5. **Finance Trust**: profit_dashboard_viewed → reconciliation_performed → proof_bundle_assembled

---

## 5. Governance Rules

1. Screen-specific analytics events MAY be more granular, but they MUST preserve the module event families above.
2. Error variants SHOULD use the same base event with `result = 'error'` unless a dedicated failure event is explicitly listed above.
3. Admin analytics events MUST include `admin_role` and `target_scope_type` when a user, workspace, or policy object is affected.
4. Finance/proof analytics events MUST include `source_class` and `confidence` whenever money or proof objects are displayed or mutated.
5. If a module has no explicit event family row here, it is not analytics-ready.

## 6. Feature Flags (PostHog)
| Flag | Purpose |
|---|---|
| `ai_remix_studio` | Gradual rollout of Remix feature |
| `new_profit_dashboard` | A/B test new dashboard design |
| `copilot_v2` | Test new copilot model |
| `gamification` | Enable achievement system |

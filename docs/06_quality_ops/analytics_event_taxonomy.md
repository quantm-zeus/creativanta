---
layer: quality_ops
canonical: true
source_file: impl_d3_analytics_event_taxonomy.md
last_verified: 2026-04-09
last_updated: 2026-10-30
---

# D3 — Analytics Event Taxonomy (PostHog)

> **Upstream**: Pack 01, Tech Stack ADR v4
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

## 6. Product validation measurements

These are analytical definitions, not new domain events. Use existing canonical object identities and approved analytics families; product analytics never authorizes financial writes. Exclude demo/test/internal accounts and deduplicate by workspace/object/operation identity. Show sample size, observation window and missingness in every cohort report.

| Measure | Definition / source | Limitation |
|---|---|---|
| First value | Time from workspace creation to first authorized imported/connected financial snapshot viewed with source/gap disclosure; use onboarding and profit_dashboard_viewed | Demo views excluded; first value does not imply all five onboarding steps or verified profit |
| Weekly proofed operating loops | Distinct linked content/publish objects with an attributed completed order, versioned cost/profit projection and inspectable evidence reviewed in that week; count each publish object once | Imported/manual proof remains labeled; reported attribution is not causal uplift; unresolved gaps exclude it from the proof-complete subset |
| Weekly operator retention | Activated eligible workspaces performing at least one real domain action or evidence review in week N divided by the same activation cohort eligible for week N | Login/page view alone does not count; show cohort size and censored workspaces |
| Repair burden | Median operator time and unresolved required-component count per imported batch/report | Missing time tracking remains unknown, never zero |
| Usable production yield | Accepted usable outputs / terminal generation attempts, by mode/provider and quote version | Show cancellations and unresolved outcomes separately; exclude previews from final-output yield |
| Cost per accepted output | Actual provider/render/storage/egress cost allocated to a cohort, including failed paid attempts, divided by accepted outputs | Decimal money from server ledger/metering; zero accepted outputs → undefined, not zero cost |
| Net unit economics | Net recognized subscription/top-up revenue minus provider, compute, storage/egress, payment/refund and attributed support cost for a billing cohort | Show allocation method and unknown costs; request quote margin alone is insufficient |

Source_class and confidence use the full canonical schema enum, including medium_high and low_medium. Do not collapse bands before aggregation. Suggested pilot targets and decision ownership live in the business strategy document; they are not measured achievements or release SLAs.

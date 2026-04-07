---
layer: quality_ops
canonical: true
source_file: impl_d3_analytics_event_taxonomy.md
last_verified: 2026-03-30
---

# D3 — Analytics Event Taxonomy (PostHog)

> **Upstream**: Pack 01, Tech Stack ADR v3
> Coverage note: this is the seed taxonomy, not full module coverage. Additional canonical events still need to be added for many modules before production analytics is implementation-complete.

---

## 1. Event Naming: `{object}_{action}` (snake_case, past tense)

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

## 3. Key Funnels
1. **Content Loop**: idea_created → script_created → script_approved → asset_generated → publish_executed
2. **Onboarding**: onboarding_step_1 → step_2 → ... → onboarding_completed
3. **Commerce**: offer_activated → affiliate_link_created → order_imported

---

## 4. Feature Flags (PostHog)
| Flag | Purpose |
|---|---|
| `ai_remix_studio` | Gradual rollout of Remix feature |
| `new_profit_dashboard` | A/B test new dashboard design |
| `copilot_v2` | Test new copilot model |
| `gamification` | Enable achievement system |

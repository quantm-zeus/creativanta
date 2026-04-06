---
layer: screens
canonical: true
last_updated: 2026-04-06
---

> ## AI Reading Rule
>
> Không đọc screen docs trước khi đọc feature doc tương ứng.
> Screen docs là UI detail — supporting evidence, không phải source of truth.
>
> Thứ tự đúng:
> 1. docs/02_features/<domain>/<feature>.md — business logic + AC
> 2. docs/04_contracts/ — field names, event names, permissions
> 3. docs/03_screens/SCREEN_IMPLEMENTATION_PROTOCOL.md — alias + placeholder resolution rules
> 4. docs/03_screens/<platform>/<screen>.md — UI layout + states
>
> Nếu screen doc và feature doc mâu thuẫn — feature doc wins.

# Creativanta — Screen Inventory (Canonical)

> **Total**: 243 screen files (133 Web + 61 Mobile + 37 Admin + 12 Shared)
> **Note**: Counts verified against filesystem 2026-04-06
> **Updated**: 2026-04-06 (v8 — Admin coverage completed + screen implementation protocol added)
> **Status**: Inventory verified. Admin coverage complete. Legacy screen aliases are governed by `SCREEN_IMPLEMENTATION_PROTOCOL.md`.
> **Migrated from**: `docs/screens/SCREEN_INDEX.md` (base) + `docs/screen_index.md` (supplementary)

---

## Web Screens (133 files)

### M01 — Home & Navigation
| ID | File | Screen |
|---|---|---|
| W001 | `screen_web_home_dashboard.md` | Dashboard |
| W002 | `screen_web_home_workspace_selector.md` | Workspace Selector |
| W003 | `screen_web_home_notification_center.md` | Notification Center |
| W004 | `screen_web_home_global_search.md` | Global Search |
| W005 | `screen_web_home_quick_actions.md` | Quick Actions (⌘K) |
| W006 | `screen_web_home_onboarding.md` | Onboarding Wizard |
| W007 | `screen_web_home_settings_hub.md` | Settings Hub |
| W008 | `screen_web_home_copilot_dialog.md` | Copilot Dialog |
| W009 | `screen_web_home_morning_brief.md` | Morning Brief |

### Auth
| ID | File | Screen |
|---|---|---|
| W010 | `screen_web_auth_login.md` | Login |
| W011 | `screen_web_auth_register.md` | Register |
| W012a | `screen_web_auth_forgot_password.md` | Forgot Password |

### M05-M06 — Content Pipeline
| ID | File | Screen |
|---|---|---|
| W012 | `screen_web_content_idea_board.md` | Idea Board |
| W013 | `screen_web_content_idea_detail.md` | Idea Detail |
| W014 | `screen_web_content_idea_generator.md` | AI Idea Generator |
| W015 | `screen_web_content_script_list.md` | Script List |
| W016 | `screen_web_content_script_editor.md` | Script Editor |
| W017 | `screen_web_content_script_review.md` | Script Review |
| W018 | `screen_web_content_derivatives.md` | Derivative Manager (M09) |
| W019 | `screen_web_content_continuity.md` | Content Continuity (M08) |
| W020 | `screen_web_content_asset_brief.md` | Asset Brief |

### M07 — AI Studio
| ID | File | Screen |
|---|---|---|
| W021 | `screen_web_studio_launcher.md` | Studio Launcher |
| W022 | `screen_web_studio_quick_edit.md` | Quick Edit |
| W023 | `screen_web_studio_clip_factory.md` | Clip Factory |
| W024 | `screen_web_studio_product_showcase.md` | Product Showcase |
| W025 | `screen_web_studio_ai_remix.md` | AI Remix |
| W026 | `screen_web_studio_thumbnail.md` | Thumbnail Generator |
| W027 | `screen_web_studio_ab_testing.md` | A/B Testing |
| W028 | `screen_web_studio_sound.md` | Sound Manager |
| W029 | `screen_web_studio_asset_library.md` | Asset Library |
| W030 | `screen_web_studio_queue.md` | Studio Queue |
| W031 | `screen_web_studio_video_agent.md` | Full Video Agent |
| W032 | `screen_web_studio_style_learning.md` | Style Learning |
| W033 | `screen_web_studio_translation.md` | Translation |
| W034 | `screen_web_studio_multi_merge.md` | Multi-Merge |
| W035 | `screen_web_studio_image_to_video.md` | Image to Video |
| W036 | `screen_web_studio_link_to_video.md` | Link to Video |
| W037 | `screen_web_studio_character.md` | Character Builder & Library (M08) |

### M02-M04 — Intelligence
| ID | File | Screen |
|---|---|---|
| W038 | `screen_web_intelligence_trend_radar.md` | Trend Radar |
| W039 | `screen_web_intelligence_trend_detail.md` | Trend Detail |
| W040 | `screen_web_intelligence_competitor_registry.md` | Competitor Registry |
| W041 | `screen_web_intelligence_benchmark.md` | Benchmark |
| W042 | `screen_web_intelligence_watchlist.md` | Watchlist |
| W043 | `screen_web_intelligence_opportunity_board.md` | Opportunity Board |
| W044 | `screen_web_intelligence_opportunity_detail.md` | Opportunity Detail |
| W045 | `screen_web_intelligence_opportunity_convert.md` | Opportunity Convert |

### M12 — Engagement
| ID | File | Screen |
|---|---|---|
| W046 | `screen_web_engagement_unified_inbox.md` | Unified Inbox |
| W047 | `screen_web_engagement_thread_detail.md` | Thread Detail |
| W048 | `screen_web_engagement_contact_list.md` | Contact List |
| W049 | `screen_web_engagement_contact_detail.md` | Contact Detail |
| W050 | `screen_web_engagement_bulk_triage.md` | Bulk Triage |
| W051 | `screen_web_engagement_followup_tasks.md` | Follow-up Tasks |

### M10-M11 — Publish
| ID | File | Screen |
|---|---|---|
| W052 | `screen_web_publish_composer.md` | Publish Composer |
| W053 | `screen_web_publish_queue.md` | Publish Queue |
| W054 | `screen_web_publish_calendar.md` | Publish Calendar |
| W055 | `screen_web_publish_calendar_full.md` | Calendar Full View |
| W056 | `screen_web_publish_packaging_qa.md` | Packaging QA |
| W057 | `screen_web_publish_item_detail.md` | Publish Item Detail |
| W058 | `screen_web_publish_diagnostics.md` | Publish Diagnostics |
| W059 | `screen_web_publish_channel_posts.md` | Channel Posts |

### M13-M16 — Commerce
| ID | File | Screen |
|---|---|---|
| W060 | `screen_web_commerce_product_list.md` | Product List |
| W061 | `screen_web_commerce_product_detail.md` | Product Detail |
| W062 | `screen_web_commerce_order_list.md` | Order List |
| W063 | `screen_web_commerce_order_detail.md` | Order Detail |
| W064 | `screen_web_commerce_campaign_list.md` | Campaign List |
| W065 | `screen_web_commerce_campaign_detail.md` | Campaign Detail |
| W066 | `screen_web_commerce_offer_list.md` | Offer List |
| W067 | `screen_web_commerce_offer_detail.md` | Offer Detail |
| W068 | `screen_web_commerce_coupon.md` | Coupon Manager |
| W069 | `screen_web_commerce_affiliate.md` | Affiliate Overview |
| W070 | `screen_web_commerce_affiliate_manager.md` | Affiliate Manager |
| W071 | `screen_web_commerce_membership.md` | Membership Plans |
| W072 | `screen_web_commerce_store_pages.md` | Store Pages & Editor |
| W073 | `screen_web_commerce_refunds.md` | Refund Management |
| W074 | `screen_web_commerce_samples.md` | Sample Requests |
| W075a | `screen_web_commerce_inventory.md` | Inventory Management |

### M14 — Monetization OS
| ID | File | Screen |
|---|---|---|
| W075b | `screen_web_monetization_os.md` | Monetization OS Dashboard (M14) |

### Analytics
| ID | File | Screen |
|---|---|---|
| W075 | `screen_web_analytics_overview.md` | Analytics Overview |
| W076 | `screen_web_analytics_detail.md` | Analytics Detail |
| W077 | `screen_web_analytics_performance.md` | Performance Metrics |
| W078 | `screen_web_analytics_post_detail.md` | Post Detail Analytics |
| W079 | `screen_web_analytics_gamification.md` | Gamification |

### M19 — Finance
| ID | File | Screen |
|---|---|---|
| W080 | `screen_web_finance_dashboard.md` | Finance Dashboard |
| W081 | `screen_web_finance_profit_dashboard.md` | Profit Dashboard |
| W082 | `screen_web_finance_revenue.md` | Revenue Detail |
| W083 | `screen_web_finance_costs.md` | Cost Detail |
| W084 | `screen_web_finance_reconciliation.md` | Reconciliation Center |
| W085 | `screen_web_finance_proof.md` | Proof Browser |
| W086 | `screen_web_finance_settlements.md` | Settlement Tracker |
| W087 | `screen_web_finance_reports.md` | Financial Reports |

### S16 — Creator Pro
| ID | File | Screen |
|---|---|---|
| W088 | `screen_web_creator_pro_dashboard.md` | Creator Pro Dashboard |
| W089 | `screen_web_creator_media_kit.md` | Media Kit Editor |
| W090 | `screen_web_creator_inquiries.md` | Sponsor Inquiries |
| W091 | `screen_web_creator_partnerships.md` | Partnership Manager |
| W092 | `screen_web_creator_link_in_bio.md` | Link-in-Bio Builder |
| W093 | `screen_web_creator_rate_card.md` | Rate Card Builder |
| W094 | `screen_web_creator_revenue.md` | Revenue Per Content |
| W095 | `screen_web_creator_brand_deals.md` | Brand Deal Manager |
| W096 | `screen_web_creator_tax_export.md` | Tax Report Export |

### S19 — Support
| ID | File | Screen |
|---|---|---|
| W097 | `screen_web_support_center.md` | Support Center |
| W098 | `screen_web_support_article.md` | Help Article Viewer |
| W099 | `screen_web_support_ticket_create.md` | Support Ticket Create |

### M20-M21 — Workflow
| ID | File | Screen |
|---|---|---|
| W100 | `screen_web_workflow_list.md` | Workflow List |
| W101 | `screen_web_workflow_builder.md` | Workflow Builder |
| W102 | `screen_web_workflow_runs.md` | Run History |
| W103 | `screen_web_workflow_recipes.md` | Recipe Templates |
| W104 | `screen_web_workflow_approvals.md` | Approval Queue |
| W105 | `screen_web_workflow_tasks.md` | Task Queue |
| W106 | `screen_web_workflow_agents.md` | AI Agent Runs |

### M17 — Live Commerce
| ID | File | Screen |
|---|---|---|
| W107 | `screen_web_live_planner.md` | Live Session Planner |
| W108 | `screen_web_live_setup.md` | Live Session Setup |
| W109 | `screen_web_live_war_room.md` | Live War Room |
| W110 | `screen_web_live_summary.md` | Post-Live Summary |

### M18 — Seeding
| ID | File | Screen |
|---|---|---|
| W111 | `screen_web_seeding_requests.md` | Sample Request Manager |
| W112 | `screen_web_seeding_assignments.md` | Creator Assignment |
| W113 | `screen_web_seeding_campaigns.md` | Seeding Campaigns |

### M23 — Settings
| ID | File | Screen |
|---|---|---|
| W114 | `screen_web_settings_workspace.md` | Workspace Settings |
| W115 | `screen_web_settings_members.md` | Member Management |
| W116 | `screen_web_settings_team.md` | Team Settings |
| W117 | `screen_web_settings_connectors.md` | Platform Connectors |
| W118 | `screen_web_settings_brand.md` | Brand Kit |
| W119 | `screen_web_settings_billing.md` | Billing & Plans |
| W120 | `screen_web_settings_credits.md` | AI Credits |
| W121 | `screen_web_settings_credit_usage.md` | Credit Usage Detail |
| W122 | `screen_web_settings_notifications.md` | Notification Preferences |
| W123 | `screen_web_settings_ai.md` | AI Preferences |
| W124 | `screen_web_settings_api_keys.md` | API Keys |
| W125 | `screen_web_settings_diagnostics.md` | Diagnostics Center |
| W126 | `screen_web_settings_referral.md` | Referral Program |
| W127 | `screen_web_settings_connector_detail.md` | Connected Account Detail |
| W128 | `screen_web_settings_credit_purchase.md` | Credit Purchase |
| W129 | `screen_web_settings_data_export.md` | Data Export (GDPR/PDPA) |
| W130 | `screen_web_capability_matrix.md` | Capability Matrix (M22) |

---

## Mobile Screens (61 files)

### M01 — Home
| ID | File | Screen |
|---|---|---|
| M001 | `screen_mobile_home_dashboard.md` | Dashboard |
| M002 | `screen_mobile_home_notification_list.md` | Notification List |
| M003 | `screen_mobile_morning_brief.md` | Morning Brief |
| M004 | `screen_mobile_home_workspace_switch.md` | Workspace Switch |
| M005 | `screen_mobile_search.md` | Universal Search |
| M006 | `screen_mobile_quick_capture.md` | Quick Capture (Camera) |
| M007 | `screen_mobile_onboarding.md` | Onboarding |

### M05-M06 — Content
| ID | File | Screen |
|---|---|---|
| M008 | `screen_mobile_content_idea_board.md` | Idea Board |
| M009 | `screen_mobile_idea_detail.md` | Idea Detail |
| M010 | `screen_mobile_script_list.md` | Script List |
| M011 | `screen_mobile_script_editor.md` | Script Editor |

### M07 — AI Studio
| ID | File | Screen |
|---|---|---|
| M013 | `screen_mobile_studio_launcher.md` | Studio Launcher |
| M014 | `screen_mobile_studio_quick_edit.md` | Quick Edit |
| M015 | `screen_mobile_studio_clip_factory.md` | Clip Factory |
| M016 | `screen_mobile_studio_ai_remix.md` | AI Remix |

### M02-M04 — Intelligence
| ID | File | Screen |
|---|---|---|
| M017 | `screen_mobile_intelligence_trend_list.md` | Trend List |
| M018 | `screen_mobile_competitors.md` | Competitors |

### M12 — Engagement
| ID | File | Screen |
|---|---|---|
| M019 | `screen_mobile_engagement_inbox.md` | Inbox |
| M020 | `screen_mobile_thread_detail.md` | Thread Detail |
| M021 | `screen_mobile_contacts.md` | Contact List |
| M022 | `screen_mobile_contact_detail.md` | Contact Detail |

### M10-M11 — Publish
| ID | File | Screen |
|---|---|---|
| M023 | `screen_mobile_publish_quick.md` | Quick Publish |
| M024 | `screen_mobile_publish_queue.md` | Publish Queue |
| M025 | `screen_mobile_calendar.md` | Calendar |

### M13-M16 — Commerce
| ID | File | Screen |
|---|---|---|
| M026 | `screen_mobile_commerce_dashboard.md` | Commerce Dashboard |
| M027 | `screen_mobile_commerce_orders.md` | Orders |
| M028 | `screen_mobile_commerce_products.md` | Products |
| M029 | `screen_mobile_commerce_offers.md` | Offers |
| M030 | `screen_mobile_commerce_refunds.md` | Refunds |
| M031 | `screen_mobile_commerce_campaigns.md` | Campaigns |
| M032 | `screen_mobile_commerce_affiliates.md` | Affiliates |
| M033 | `screen_mobile_commerce_coupons.md` | Coupons |
| M034 | `screen_mobile_commerce_samples.md` | Samples |

### Analytics
| ID | File | Screen |
|---|---|---|
| M035 | `screen_mobile_analytics.md` | Analytics |
| M036 | `screen_mobile_analytics_overview.md` | Analytics Overview |
| M037 | `screen_mobile_post_analytics.md` | Post Analytics |
| M038 | `screen_mobile_gamification.md` | Gamification |
| M039 | `screen_mobile_performance_coach.md` | Performance Coach |

### M19 — Finance
| ID | File | Screen |
|---|---|---|
| M040 | `screen_mobile_finance.md` | Finance Overview |
| M041 | `screen_mobile_finance_summary.md` | Finance Summary |
| M042 | `screen_mobile_revenue.md` | Revenue Detail |
| M043 | `screen_mobile_cost_entry.md` | Cost Entry |
| M044 | `screen_mobile_reconciliation.md` | Reconciliation |

### S16 — Creator Pro
| ID | File | Screen |
|---|---|---|
| M045 | `screen_mobile_creator_pro.md` | Creator Pro |
| M046 | `screen_mobile_brand_deals.md` | Brand Deals |
| M047 | `screen_mobile_link_in_bio.md` | Link-in-Bio |
| M048 | `screen_mobile_media_kit.md` | Media Kit Preview |

### S19 — Support
| ID | File | Screen |
|---|---|---|
| M049 | `screen_mobile_support.md` | Support |

### M20-M21 — Workflow
| ID | File | Screen |
|---|---|---|
| M050 | `screen_mobile_workflow_monitor.md` | Workflow Monitor |
| M051 | `screen_mobile_approval_queue.md` | Approval Queue |
| M052 | `screen_mobile_task_queue.md` | Task Queue |
| M053 | `screen_mobile_agent_runs.md` | Agent Runs |
| M054 | `screen_mobile_recipes.md` | Recipe Library |

### M17 — Live Commerce
| ID | File | Screen |
|---|---|---|
| M055 | `screen_mobile_live_war_room.md` | Live War Room |

### M18 — Seeding
| ID | File | Screen |
|---|---|---|
| M056 | `screen_mobile_seeding.md` | Seeding |

### M23 — Settings
| ID | File | Screen |
|---|---|---|
| M057 | `screen_mobile_settings.md` | Settings |
| M058 | `screen_mobile_connections.md` | Connections |
| M059 | `screen_mobile_diagnostics.md` | Diagnostics |
| M060 | `screen_mobile_copilot.md` | Copilot Chat |
| M061 | `screen_mobile_billing.md` | Billing & Subscription |
| M062 | `screen_mobile_referral.md` | Referral Program |

---

## Admin Screens (32 files)

### Core
| ID | File | Screen |
|---|---|---|
| A001 | `screen_admin_dashboard.md` | Admin Dashboard |
| A002 | `screen_admin_user_list.md` | User List |
| A003 | `screen_admin_user_detail.md` | User Detail |
| A004 | `screen_admin_workspace_list.md` | Workspace List |
| A005 | `screen_admin_workspace_detail.md` | Workspace Detail |

### Platform Ops
| ID | File | Screen |
|---|---|---|
| A006 | `screen_admin_system_health.md` | System Health |
| A007 | `screen_admin_platform_monitor.md` | Platform Monitor |
| A008 | `screen_admin_job_monitor.md` | Job Monitor |
| A009 | `screen_admin_feature_flags.md` | Feature Flags |
| A010 | `screen_admin_audit_log.md` | Audit Log |

### AI & Content
| ID | File | Screen |
|---|---|---|
| A011 | `screen_admin_ai_ops.md` | AI Operations |
| A012 | `screen_admin_ai_providers.md` | AI Providers |
| A013 | `screen_admin_ai_config.md` | AI Config |
| A014 | `screen_admin_ai_credits.md` | AI Credits |
| A015 | `screen_admin_moderation.md` | Content Moderation |
| A016 | `screen_admin_moderation_rules.md` | Moderation Rules |
| A017 | `screen_admin_abuse_reports.md` | Abuse Reports |

### Commerce & Finance
| ID | File | Screen |
|---|---|---|
| A018 | `screen_admin_commerce_overview.md` | Commerce Overview |
| A019 | `screen_admin_commerce_disputes.md` | Disputes |
| A020 | `screen_admin_commerce_fees.md` | Fee Management |
| A021 | `screen_admin_subscriptions.md` | Subscriptions |
| A022 | `screen_admin_revenue.md` | Revenue Dashboard |

### Analytics & Support
| ID | File | Screen |
|---|---|---|
| A023 | `screen_admin_analytics_usage.md` | Usage Analytics |
| A024 | `screen_admin_analytics_business.md` | Business Analytics |
| A025 | `screen_admin_analytics_errors.md` | Error Analytics |
| A026 | `screen_admin_support_queue.md` | Support Queue |
| A027 | `screen_admin_notifications.md` | Notification Broadcast |

### Security, Compliance & Operations (NEW)
| ID | File | Screen |
|---|---|---|
| A028 | `screen_admin_fraud_dashboard.md` | Fraud Dashboard (S26 §14) |
| A029 | `screen_admin_gdpr_tools.md` | GDPR & Compliance Tools (S26 §12) |
| A030 | `screen_admin_system_config.md` | System Configuration (S26 §11) |
| A031 | `screen_admin_incident_manager.md` | Incident Manager (S26 §9) |
| A032 | `screen_admin_admin_management.md` | Admin Team Management (S26 §2) |
| A033 | `screen_admin_connector_debug.md` | Connector Debug |
| A034 | `screen_admin_knowledge_base_editor.md` | Knowledge Base Editor |
| A035 | `screen_admin_email_campaign_manager.md` | Email Campaign Manager |
| A036 | `screen_admin_dlq_inspector.md` | DLQ Inspector |
| A037 | `screen_admin_subscription_override.md` | Subscription Override |

---

## Shared Components (12 files)

| ID | File | Component |
|---|---|---|
| S001 | `screen_shared_app_shell.md` | App Shell |
| S002 | `screen_shared_navigation.md` | Navigation (Web + Admin Sidebar) |
| S003 | `screen_shared_mobile_nav.md` | Mobile Navigation |
| S004 | `screen_shared_loading_states.md` | Loading States |
| S005 | `screen_shared_empty_states.md` | Empty States |
| S006 | `screen_shared_error_states.md` | Error States |
| S007 | `screen_shared_confirmations.md` | Confirmation Dialogs |
| S008 | `screen_shared_command_palette.md` | Command Palette (⌘K) |
| S009 | `screen_shared_trust_badge.md` | Trust Badge Component |
| S010 | `screen_shared_glossary.md` | Glossary & Tooltips |
| S011 | `screen_shared_upsell_banner.md` | Upsell Banner |
| S012 | `screen_shared_onboarding_tooltip.md` | Onboarding Tooltip Sequence |

---

## Coverage Summary

| Platform | Count | Status |
|---|---|---|
| Web | 133 | ✅ Complete (includes `screen_web_monetization_os.md` added 2026-04-02) |
| Mobile | 61 | ✅ Complete (M012 ID intentionally skipped — no gap) |
| Admin | 37 | ✅ Complete |
| Shared | 12 | ✅ Complete |
| **TOTAL** | **243** | **Coverage complete; see protocol for legacy shorthand resolution rules** |

---

## Module Coverage Matrix

| Module | Web | Mobile | Admin | Notes |
|---|---|---|---|---|
| M01 Home | 9 | 7 | 1 | Dashboard + Nav + Onboarding + Morning Brief |
| Auth | 2 | — | — | Web-only; mobile uses platform biometric + first-use login |
| M05-M06 Content | 9 | 5 | — | Full pipeline (Ideas → Scripts → Asset Brief) |
| M07 AI Studio | 17 | 4 | 4 | 12 modes + Character Builder (M08) |
| M02-M04 Intelligence | 8 | 2 | — | Trends, competitors, opportunities |
| M12 Engagement | 6 | 4 | — | Inbox, contacts, follow-ups |
| M10-M11 Publish | 8 | 3 | — | Composer, queue, calendar |
| M13-M16 Commerce | 15 | 9 | 3 | Products, orders, membership, refunds, samples |
| Analytics | 5 | 5 | 3 | Overview, detail, gamification, coach |
| M19 Finance | 8 | 5 | 2 | Profit, reconciliation, reports |
| M22 Capability | **1** | — | — | **NEW: Capability Matrix** |
| S16 Creator Pro | 9 | 4 | — | Media kit, deals, tax |
| S19 Support | 3 | 1 | 1 | Help center + tickets |
| M20-M21 Workflow | 7 | 5 | — | Builder, recipes, agents |
| M17 Live | 4 | 1 | — | Planner, war room, summary |
| M18 Seeding | 3 | 1 | — | Requests, assignments, campaigns |
| M23 Settings | 15 | 6 | — | Full config, connectors, credits |
| Platform Ops | — | — | 10 | System health, jobs, flags, connector debug, DLQ, campaigns |
| Content Mod | — | — | 3 | Moderation + abuse |
| Security/Compliance | — | — | **4** | **NEW: Fraud, GDPR, Incidents, Admin Mgmt** |
| System Config | — | — | **1** | **NEW: System Configuration** |
| Shared | — | — | — | 12 cross-platform components |

---

## Cross-Screen Navigation Map

> **Merged from**: `docs/screen_index.md` — route-level navigation flows not present in base SCREEN_INDEX.

### Primary Flows

```
Home → Trend Radar → Trend Detail → Convert to Idea → Idea Detail → Convert to Script → Script Editor → Asset Brief → AI Studio → Generation Queue → Packaging QA → Publish Queue → Channel Posts → Analytics
```

```
Inbox (Comment) → Thread Detail → Create Follow-up → Task Queue
                → Contact Detail → Order History
                → Reply (AI-assisted) → Resolve
```

```
Products → Offer Create → Campaign Create → Publish with offer link → Track in Campaign Dashboard → Profit Dashboard
```

```
AI Studio Home → Quick Edit / Clip Factory / Multi-Merge / AI Remix / Sound Studio / Video Agent → Generation Queue → Packaging QA → Publish
```

```
Creator Pro → Media Kit → Share with brand → Brand Deal → Deliverables → Revenue Per Content → Tax Export
```

### Global Access (from any screen)
- `⌘K` → Command Palette / Search
- `🤖` Copilot → Floating Assistant
- `🔔` → Notification Center
- Bottom nav (mobile) → Home, Ideas, Studio, Inbox, More
- Glossary → Any underlined term → tooltip definition

---

## Quality Audit Notes

> [!IMPORTANT]
> **Files are categorized by quality tier.** Tier A = full spec (15+ sections). Tier B = adequate (8+ sections). Tier C = sparse (<8 sections, needs upgrade).
> Legacy Tier C shorthand is no longer a blocking implementation risk because contract/schema derivation is governed by `SCREEN_IMPLEMENTATION_PROTOCOL.md`. Do not implement placeholder table/RPC names literally.

### Known Issues (tracked)
1. ~~`screen_mobile_idea_board.md` duplicate~~ — **RESOLVED** (deleted 2026-03-28)
2. Trust Badge source classes need alignment with PRD canonical taxonomy
3. ~~Admin dashboard RBAC~~ — **RESOLVED** (aligned to S26 8-role spec)
4. ~~9 admin screens from root `screen_index.md` not yet created~~ — **RESOLVED** (standalone screens A033-A037 created on 2026-04-06)
5. **Screen ID Policy (DEC-008 + 2026-04-04 clarification)**:
   - IDs follow the `{Platform}{Number}` pattern: `W###` (Web), `M###` (Mobile), `A###` (Admin), `S###` (Shared).
   - **Letter suffixes** (e.g., `W012a`, `W075a`, `W075b`) are allowed for screens inserted between existing numbered IDs to avoid cascading renumbering. These are intentional insertion IDs, not errors.
   - Mixed legacy formats (W-AUTH-02 etc.) are accepted per DEC-008 for existing docs. New screens should use `{Platform}{Number}` or `{Platform}{Number}{letter}`.
   - Cross-reference should use **path + title + module**, not ID format alone.
   - **Metadata formats**: Two styles exist: (a) inline blockquote (`> **Screen ID**: W001`) used by most screens, and (b) YAML frontmatter (`screen_id: W075b`) used by `screen_web_monetization_os.md`. Both are valid.
6. Tier upgrades continue, but implementation must follow `SCREEN_IMPLEMENTATION_PROTOCOL.md` rather than relying on legacy aliases in older files
7. ~~Module attribution: `screen_mobile_content_idea_board.md` incorrectly references M04~~ — **RESOLVED** (verified 2026-04-03: file correctly references M05 — Idea Engine per BUILD_INDEX)
8. ~~Admin Dashboard duplicate sections~~ — **RESOLVED** (template placeholders removed, proper section numbering applied)
9. **NEW**: Web Capability Matrix (M22) screen created — `screen_web_capability_matrix.md`
10. **NEW**: 4 critical admin screens created (Fraud, GDPR, System Config, Incidents, Admin Management)

---

## Merge Notes

> **Merge history** (2026-03-31, for archival reference only — current authoritative count is in the header above):
> - **Base**: `docs/screens/SCREEN_INDEX.md` (v6, 233 file-level entries at that time)
> - **Supplementary**: `docs/screen_index.md` (235 route-level entries from spec files)
>
> **Content merged from supplementary**:
> - Cross-Screen Navigation Map (§ Primary Flows + Global Access)
> - Route information (available in supplementary but not base)
>
> **Historical count note**: Base counted 233 files; supplementary counted 235 routes — due to different deduplication approaches. Current authoritative count is in the header (243 as of 2026-04-06).
>
> **No conflicts detected** — content was complementary, not contradictory.

# Creativanta — Detail Design Packs Index v3.1

Tài liệu này là **master index** cho bộ **Detail Design Packs** đi tiếp từ:
- PRD Master v3.1 (Revised, Freeze-Ready)
- Product Freeze / Build Contract v3.1

## 1. Mục tiêu

Bộ pack này chuyển hệ thống từ mức **build contract** sang mức **implementation-ready design**.

Mỗi pack phải:
- giữ nguyên canonical naming, scope và taxonomy đã freeze
- không tự đổi nghĩa object, state, source class, capability state, proof model
- đủ chi tiết để FE, BE, AI, Data, QA và DevOps có thể bắt đầu tách việc

## 2. Bộ pack

### Pack 01 — FE UX / Screen Contract
Phạm vi:
- navigation
- screen map
- object pages
- dashboard/action surfaces
- empty/partial/broken/repair states
- mobile execution rules
- component behavior contracts
- persona-based onboarding flows (6 operator modes)
- animation & interaction design contract
- error UX & copy/tone contract
- search & command hub UX
- notification center UX
- responsive breakpoints & accessibility (WCAG 2.1 AA)

### Pack 02 — Backend Domain / Canonical Schema Contract
Phạm vi:
- canonical entities (including new objects from Pack 07/08/PRD §33-§37)
- aggregates
- relationship rules
- field groups
- write ownership
- projection strategy
- persistence boundaries
- validation and invariant rules
- multi-tenant / workspace isolation & security (OWASP-aligned)
- authentication & identity contract
- API response & error contract
- commerce edge cases (overselling, chargeback, refund fraud, tax)
- data import / migration strategy
- Profit OS context (Profit Calculation, Fee Schedule, COGS, Content Attribution)
- Copilot context (Session, Action Log)
- Achievement context (Definition, User Record, Challenge)
- Platform Health context (Score, Check Log)
- Content Repurpose context (Job, Output)

### Pack 03 — Event Backbone / Workflow / Agent Runtime Contract
Phạm vi:
- domain events
- integration events
- workflow runtime
- recipe installation/execution
- agent planning/execution
- approvals
- retries, dead-letter, audit trail
- real-time communication contract (WebSocket / SSE / polling)
- transactional email / SMS / messaging contract
- product analytics & event tracking contract
- A/B testing & feature flag management

### Pack 04 — AI / Media / Continuity / Asset Production Contract
Phạm vi:
- **multi-provider media stack** (ADR-010): Veo 3.1, Kling 3.0, Runway Gen-4, Flux 2, GPT Image, ElevenLabs, SyncLabs, Kolors (Virtual Try-On), SAM2, rembg, Stable Audio/MusicGen
- **video production pipeline** — Smart Pipeline Router (4 strategies: Native Audio, Audio-First, Post-Prod Lip-Sync, Simple Voice-Over)
- **post-production mix contract** (rust-ffmpeg: audio ducking, normalize, subtitles, aspect ratio)
- **lip-sync contract** (SyncLabs primary, Wav2Lip fallback)
- **4 core production modes** (ADR-011):
  - **Quick Edit** (1→1): text-based editing, animated captions, active speaker detection, beat-sync, AI B-roll gen, Smart Hook Library, copyright-safe audio
  - **Clip Factory** (1→N): scene detection, highlight extraction, Virality Score (0-100 using Trend Engine M02/M03 data), batch export
  - **Multi-Merge** (N→1): multi-source assembly, AI transitions, voice-over with Character Pack, background music
  - **AI Remix Studio** (ref→new): 8-layer Creative DNA analysis → script rewrite → visual gen → polish. Legal safeguards: originality check, no footage reuse, abuse detection
- **11 extended production features** (§9.6-9.16):
  - **AI Product Showcase Studio** (§9.6): photos → product video (8 styles: 360° Spin, Tabletop Demo, Flip & Reveal, Virtual Try-On, Lifestyle, Unboxing, Before/After, Review Style + batch mode)
  - **Image-to-Video Converter** (§9.7): ảnh tĩnh → video động (6 motion styles)
  - **AI Thumbnail Studio** (§9.8): generate + A/B test + brand consistency
  - **Link-to-Video Generator** (§9.9): product URL → video ad (Shopee/Lazada/TikTok Shop/Amazon, 5 script templates)
  - **AI Translation Studio** (§9.10): video → N languages (voice clone + lip-sync)
  - **AI Sound Studio** (§9.11): AI music gen + beat-drop sync + speech-to-song + SFX
  - **AI Style Learning** (§9.12): extract editing style → Style Pack → Continuity OS
  - **AI Video Agent** (§9.13): 1-click full pipeline — prompt → video ready
  - **AI Performance Coach** (§9.14): post-publish analysis + weekly coaching
  - **Video A/B Testing** (§9.15): N variations → auto-winner
  - **Creator Gamification** (§9.16): Level, XP, streaks, quests, achievements
- **video analysis stack**: Google Video Intelligence, Whisper ASR, ACRCloud, Librosa, mediapipe
- provider orchestration
- generation jobs
- lineage
- continuity packs
- approved references
- QA and drift rules
- **Character Builder** (3 types: digital twin, AI generated, stock avatar)
- **character ↔ continuity integration** (auto-create Character Pack)
- **character selection UX** (default character, video generation picker)
- **voice clone** integration (ElevenLabs)
- **Digital Twin consent flow** (EU AI Act compliant)

### Pack 05 — Connector / Capability / Publish / Inbox Contract
Phạm vi:
- connector lifecycle
- capability registry
- publish execution
- publish log truth
- diagnostics hierarchy
- inbox ingestion
- moderation and fallback paths

### Pack 06 — Commerce / Finance / Proof / Reporting / Admin Contract
Phạm vi:
- product, offer, order, settlement
- cost and profit truth
- reconciliation
- evidence and proof bundles
- reporting layer
- billing/metering
- admin overrides

### Pack 07 — Legal / Compliance / Consent Contract
Phạm vi:
- Terms of Service, Privacy Policy, Cookie Policy, AUP
- Consent management (cookie, ToS, AI data usage)
- Third-party platform liability protection
- AI content liability shield
- Content ownership & AI IP contract
- EU AI Act compliance detail (Art.50 labeling, risk classification, C2PA)
- Platform policy compliance engine (pre-publish scan, policy monitoring)
- DMCA / copyright compliance
- Data portability & account lifecycle (export, deletion, transfer)
- Accessibility compliance (WCAG 2.1 AA)
- Online dispute resolution (ODR)
- Regulatory compliance (PDPA, GDPR, EU AI Act, EU Accessibility Act, DSA)
- SLA và dispute resolution
- Audit trail cho legal compliance

### Pack 08 — Pricing / AI Credit / Referral / Growth Engine Contract
Phạm vi:
- Subscription tiers và feature gating
- AI credit system và budget control
- **AI video editing — 4 core production modes + 11 extended features** (Quick Edit, Clip Factory, Multi-Merge, AI Remix Studio + Product Showcase, Image-to-Video, Thumbnail, Link-to-Video, Translation, Sound Studio, Style Learning, Video Agent, Performance Coach, A/B Testing, Gamification)
- **Credit tables per mode** (Quick Edit: 3-30, Clip Factory: 60-120 typical, Multi-Merge: 15-35, AI Remix: 30-55)
- **Tier limits per mode** (Free/Starter/Pro/Business caps + upload size + duration limits)
- Affiliate link health monitoring
- Referral program và viral loop
- Growth engine và promotional credits
- RBAC / permission contract
- Billing và subscription management
- Dunning, failed payment recovery, grace period
- Subscription lifecycle state machine
- OAuth token security contract
- Disaster recovery & backup (RPO/RTO, failover, backup strategy)
- Achievement & gamification engine (objects, rules, credit integration)
- Copilot credit integration (query limits, action costs per tier)

### Pack 09 — Tech Stack ADR (Architecture Decision Record v3)
Phạm vi:
- Full tech stack selection & rationale (SvelteKit 2 + Svelte 5 + Flutter 3.41 + Rust Axum + PostgreSQL + gRPC)
- Layer-by-layer architecture (12 layers: Web, Mobile, Backend, Protocol, Data, Workflow, AI/Media, Payments, Auth/Security, Observability, Testing, Communications)
- User-facing Workflow Studio (M20/M21) powered by Activepieces (MIT License)
- 14 Architecture Decision Records (ADR-001 to ADR-014, including SvelteKit migration, Revideo, Apache ECharts)
- AI Adapter Pattern: multi-provider LLM routing (Gemini default + GPT + Claude + Qwen + DeepSeek + Mistral)
- Polyglot monorepo structure (TypeScript + Dart + Rust)
- gRPC + Protobuf communication protocol
- Performance benchmarks & cost estimates
- Complete PRD ↔ Tech mapping (all 23 modules + 9 strategic features + 15 cross-cutting)
- File: `creativanta_tech_stack_adr_v3.md`

### Pack 10 — Supplementary Spec S16: Creator Pro Tools & Monetization
Phạm vi:
- Link-in-Bio builder (schema, UX, tier gating)
- Media Kit auto-generator (AI-powered, real-time metrics)
- Rate Card builder (AI pricing suggestions)
- Revenue per Content tracker + RPM tracking
- Brand Deal management (simplified pipeline)
- Tax report export
- File: `creativanta_supplementary_s16_creator_pro_tools_v_3_1.md`

### Pack 11 — Supplementary Spec S19: Customer Support & Help
Phạm vi:
- Support channels (6 channels) + SLA per plan
- Help Center architecture
- AI Chatbot (first-line, RAG-based)
- In-app bug report (auto-capture)
- Escalation matrix (L0-L4)
- Changelog, in-app announcements, beta program
- Public status page + incident communication
- File: `creativanta_supplementary_s19_customer_support_v_3_1.md`

### Pack 12 — Supplementary Spec S24: Public API & Integrations
Phạm vi:
- Public REST API v1 (13 endpoints)
- Authentication (API key + OAuth 2.0)
- Rate limiting per plan
- Webhooks (13 event types, HMAC-SHA256)
- Developer portal (v1 doc, P2 interactive)
- Zapier/Make integration (P2)
- Native integrations (Google Analytics, Calendar, Sheets)
- File: `creativanta_supplementary_s24_public_api_v_3_1.md`

## 3. Canonical Rules áp dụng cho toàn bộ pack

1. Có đúng 23 modules M01–M23.
2. Có đúng 6 operator modes, gồm cả Brand Collaboration Mode.
3. Source class canonical chỉ gồm: Official / Imported / Inferred / Estimated / Unreconciled.
4. Capability states canonical: Native / Read-only / Manual / Degraded / Unsupported.
5. Publish truth = Publish Item + Publish Log.
6. Thread bắt buộc có owner / intent / status / next action.
7. Script bắt buộc nối Idea + Asset Brief + Publish Targets.
8. Mobile là execution surface thật.
9. Beginner UX là requirement, không phải nice-to-have.
10. Workflow/agent không được tạo shadow truth ngoài canonical graph.
11. Reporting không được thay source-of-truth owners.
12. Legal/compliance/consent là launch requirement.
13. AI credit budget control là launch requirement.
14. Platform policy compliance engine là launch requirement.
15. Authentication & identity là launch requirement (JWT, OAuth, MFA).
16. Data portability & account deletion là launch requirement (GDPR).
17. WCAG 2.1 AA accessibility là launch requirement.
18. Subscription tiers (Free/Starter/Pro/Business/Enterprise) là canonical, không được tự đổi.
19. RBAC roles (Owner/Admin/Manager/Editor/Contributor/Viewer/External) là canonical.
20. Content IP: user-created = user-owned; AI-generated = user beneficial ownership.
21. Community/forum/social features: explicitly out of v1 scope (M15 covers membership, NOT community platform).
22. Tipping/donation: explicitly out of v1 scope.
23. Profit OS là launch requirement — user phải thấy net profit, không chỉ GMV.
24. Copilot là launch requirement — non-tech users phải có natural language interface.
25. Content Repurpose pipeline là launch requirement — 1 video → multi-format output.
26. Achievement system rewards credited as "promotional" type — không được tạo credit type mới.
27. Customer support & help center là launch requirement.
28. Creator pro tools (link-in-bio, media kit, revenue tracking) là launch requirement cho Creator mode.
29. Public API documentation là launch requirement (developer docs).
30. Character Builder là launch requirement cho AI Studio — user phải tạo được nhân vật và chọn nhân vật khi tạo video AI.

## 4. Full Document Reference Table

| # | File | Content | Pack |
|---|---|---|---|
| 1 | `creativanta_prd_v_3_1_revised_part_1.md` | PRD Part 1: Product Definition, Vision, Goals, Target Users, Modules M01-M13 | Core |
| 2 | `creativanta_prd_v_3_1_revised_part_2.md` | PRD Part 2: Modules M14-M23, Strategic Features §33-38, Cross-cutting §29-32 | Core |
| 3 | `creativanta_v_3_1_product_freeze_build_contract_part_1.md` | Product Freeze Part 1: Domain objects, state machines, capability matrix | Core |
| 4 | `creativanta_v_3_1_product_freeze_build_contract_part_2.md` | Product Freeze Part 2: Commerce/Finance objects, trust model, deployment | Core |
| 5 | `creativanta_detail_design_index_v_3_1.md` | This file — index + canonical rules + cross-reference table | Index |
| 6 | `creativanta_detail_design_pack_01_fe_ux_screen_contract_v_3_1.md` | Pack 01: FE/UX + S01/S04/S05/S08/S09/S17 supplementary | Pack 01 |
| 7 | `creativanta_detail_design_pack_02_backend_domain_schema_contract_v_3_1.md` | Pack 02: Backend/Schema + S07/S20 supplementary | Pack 02 |
| 8 | `creativanta_detail_design_pack_03_event_workflow_agent_runtime_contract_v_3_1.md` | Pack 03: Event/Workflow/Agent + S03 supplementary | Pack 03 |
| 9 | `creativanta_detail_design_pack_04_ai_media_continuity_contract_v_3_1.md` | Pack 04: AI/Media/Continuity + S13 supplementary | Pack 04 |
| 10 | `creativanta_detail_design_pack_05_connector_capability_publish_inbox_contract_v_3_1.md` | Pack 05: Connector/Publish/Inbox + S14 supplementary | Pack 05 |
| 11 | `creativanta_detail_design_pack_06_commerce_finance_proof_reporting_admin_contract_v_3_1.md` | Pack 06: Commerce/Finance/Proof + S22/S25 supplementary | Pack 06 |
| 12 | `creativanta_legal_compliance_consent_contract_v_3_1.md` | Pack 07: Legal, compliance, consent, data portability, accessibility | Pack 07 |
| 13 | `creativanta_pricing_credits_growth_contract_v_3_1.md` | Pack 08: Pricing, credits, referral, dunning, DR, link health | Pack 08 |
| 14 | `creativanta_tech_stack_adr_v3.md` | Pack 09: Tech Stack ADR v3 (Performance-First Edition), Architecture, AI adapter, Activepieces | Pack 09 |
| 15 | `creativanta_supplementary_s16_creator_pro_tools_v_3_1.md` | Pack 10: Creator Pro Tools (link-in-bio, media kit, rate card, RPM) | Pack 10 |
| 16 | `creativanta_supplementary_s19_customer_support_v_3_1.md` | Pack 11: Customer Support (channels, SLA, chatbot, status page) | Pack 11 |
| 17 | `creativanta_supplementary_s24_public_api_v_3_1.md` | Pack 12: Public API (REST, webhooks, rate limits, integrations) | Pack 12 |
| 18 | `creativanta_supplementary_s26_internal_admin_operations_v_3_1.md` | Pack 13: Internal Admin & Operations Site (Super Admin, RBAC, billing, moderation, system health) | Pack 13 |

### Supplementary Sections Embedded In Packs

| Spec | Location | Content |
|---|---|---|
| S01 Onboarding | Pack 01 §S01 | 7-step wizard, guided checklist per mode, resume |
| S03 Notifications | Pack 03 §S03 | Mode-aware priority matrix, DND, copy standards |
| S04 Error Messages | Pack 01 §S04 | WHAT/WHY/NEXT formula, domain templates, tone rules |
| S05 Smart Defaults | Pack 01 §S05 | Home cards per mode, KPIs per mode, regional defaults |
| S07 RBAC | Pack 02 §S07 | 7 roles, full permission matrix, agency workflows |
| S08 Glossary | Pack 01 §S08 | 26 terms across trust, product, commerce domains |
| S09 Templates | Pack 01 §S09 | 5 template categories, pre-installed per mode |
| S13 AI Media | Pack 04 §S13 | Audio processing, trending templates, stock, auto-tag |
| S14 Content Safety | Pack 05 §S14 | Shadowban score, pre-publish scan, post-publish monitoring |
| S17 Content Intel | Pack 01 §S17 | Calendar, best time, hashtag, A/B test, predictor |
| S20 Security | Pack 02 §S20 | Account freeze, cert roadmap, pen test, AI governance |
| S22 Marketplace | Pack 06 §S22 | Recipe marketplace governance, revenue share, DMCA |
| S25 Enterprise | Pack 06 §S25 | White-label, SLOs, canary deploy, cost tracking |
| S26 Internal Admin | Standalone S26 | Internal Admin Site, Super Admin RBAC, user/workspace management, billing console, AI cost tracking, moderation, support management, system health, audit/compliance, **fraud detection, job queue monitor, webhook console, API key management, incident management** |

## 4. Cách dùng bộ pack

- PRD trả lời: xây cái gì và vì sao.
- Product Freeze trả lời: nghĩa sản phẩm chính thức là gì.
- Detail Design Packs trả lời: build chính xác như thế nào.

## 5. Implementation derivatives tạo ra trực tiếp từ bộ pack này

Các artifact dưới đây là **implementation derivatives** được tách ra ngay từ cùng full-scope build stream này. Chúng **không** được diễn giải thành phase sau, bản tạm hay cắt bớt tính năng:

1. API / BFF contracts
2. DB / storage schema
3. sequence diagrams
4. queue/retry/dead-letter design
5. connector specs
6. screen-by-screen component specs
7. QA acceptance packs
8. implementation work breakdown

## 6. Handoff Rule

Nếu một team muốn thay đổi behavior của object, state, score, proof, capability hoặc cross-module contract, thay đổi đó phải quay lên Product Freeze. Không được tự sửa trong detail design pack.


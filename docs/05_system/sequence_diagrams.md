---
layer: system
canonical: true
source_file: impl_b2_sequence_diagrams.md
last_verified: 2026-03-30
purpose: Mermaid sequence diagrams for all critical cross-service flows (13 scenarios)
---

## Diagrams Index

| # | Scenario | Services |
|---|---|---|
| 1 | User Registration & Workspace Setup | Auth, Workspace, Email |
| 2 | Platform Connector OAuth | Connector, Platform API, Webhook |
| 3 | AI Asset Generation (standard) | Asset, AI Gate, Provider, Credits |
| 4 | AI Asset Generation (failover) | Asset, Circuit Breaker, Provider A→B |
| 5 | Publish to Platform | Publish, Capability Check, Platform API |
| 6 | Order Ingestion | Webhook, Order, Inventory, Notification |
| 7 | Live Commerce Session | Live, Cue, Comment, Offer Pin |
| 8 | Reconciliation Flow | Settlement, Reconciliation, Proof Bundle |
| 9 | Workflow Trigger & Execute | Event, Workflow Engine, Action, Audit |
| 10 | Credit Reservation & Deduction | Credits, Generation Job, Provider |
| 11 | Remix Pipeline | Remix, ASR, LLM, Video Gen, Originality |
| 12 | Link-to-Video | LTV Service, Scraper, Product Data, Video |
| 13 | Asset Repurpose (1→50) | Repurpose, Clip Factory, Queue, Batch |

# B2 — Sequence Diagrams (Critical Flows)

> **Upstream**: PRD v3.1, Product Freeze, All Detail Design Packs
> **Format**: Mermaid sequence diagrams for top 15 critical flows

---

## 1. Trend → Idea → Script → Publish (Core Loop)

```mermaid
sequenceDiagram
    participant Crawler as M02 Crawler
    participant TrendSvc as M02 Trend Service
    participant OppSvc as M04 Opportunity
    participant IdeaSvc as M05 Idea Engine
    participant ScriptSvc as M06 Script Lab
    participant AISvc as M07 AI Studio
    participant PkgSvc as M10 Packaging QA
    participant PubSvc as M11 Publish Hub
    participant User

    Crawler->>TrendSvc: signal_detected(signal)
    TrendSvc->>TrendSvc: normalize + cluster
    TrendSvc-->>OppSvc: trend.created event
    OppSvc->>OppSvc: score impact/effort
    OppSvc-->>User: opportunity card on M01
    User->>OppSvc: convert_to_idea()
    OppSvc->>IdeaSvc: create_idea(refs)
    IdeaSvc->>IdeaSvc: AI suggest hooks/angles
    IdeaSvc-->>User: idea_candidates
    User->>IdeaSvc: select_idea()
    IdeaSvc->>ScriptSvc: create_script(idea_ref)
    User->>ScriptSvc: edit + submit_for_approval
    ScriptSvc-->>User: approval notification
    User->>ScriptSvc: approve()
    ScriptSvc->>AISvc: generate_asset(brief)
    AISvc->>AISvc: select_provider + pipeline
    AISvc-->>User: asset ready for review
    User->>AISvc: approve_asset()
    AISvc->>PkgSvc: score_packaging(item)
    PkgSvc->>PkgSvc: compliance_scan
    PkgSvc-->>PubSvc: packaging_scored
    PubSvc->>PubSvc: queue + schedule
    PubSvc->>PubSvc: execute publish
    PubSvc-->>User: publish.succeeded
```

---

## 2. AI Video Generation Pipeline

```mermaid
sequenceDiagram
    participant User
    participant API as Rust API
    participant Router as Pipeline Router
    participant Provider as AI Provider
    participant TTS as ElevenLabs
    participant LipSync as SyncLabs
    participant FFmpeg as rust-ffmpeg
    participant Storage as R2 Storage
    participant Credits as Credit System

    User->>API: generate_video(brief, character, voice)
    Note over API,Credits: Phase 1 — Reserve (Escrow per §9/§11)
    API->>Credits: reserve(workspace_id, estimated_cost, initial_lease=30min)
    Credits-->>API: reservation_id
    API->>Router: select_pipeline(context)
    
    alt Native Audio (90% cases)
        Router->>Provider: generate(prompt, audio=native)
        Provider-->>Router: video_with_audio
    else Audio-First (Digital Twin)
        Router->>TTS: synthesize(script, cloned_voice)
        TTS-->>Router: audio_buffer
        Router->>Provider: generate(prompt, audio_ref)
        Provider-->>Router: video
        Router->>FFmpeg: merge(video, audio, music, sfx)
    else Post-Production Lip-Sync
        par Generate Video + Audio
            Router->>Provider: generate(prompt, no_audio)
            Router->>TTS: synthesize(script)
        end
        Provider-->>Router: video
        TTS-->>Router: audio
        Router->>LipSync: sync(video, audio)
        LipSync-->>Router: synced_video
        Router->>FFmpeg: final_mix(synced, music, subtitles)
    end
    
    FFmpeg-->>Router: final_output
    Router->>Storage: upload(output)
    Storage-->>Router: file_url
    Note over Router,Credits: Phase 2 — Commit (settle actual cost)
    Router->>Credits: commit(reservation_id, actual_cost)
    Credits-->>Router: committed(new_balance)
    Router-->>API: generation_completed
    API-->>User: asset_ready(url)
```

---

## 3. Publish Flow (with Capability Check)

```mermaid
sequenceDiagram
    participant User
    participant M10 as Packaging QA
    participant M22 as Capability Matrix
    participant M11 as Publish Hub
    participant Platform as Platform API
    participant M19 as Proof Layer

    User->>M10: submit_for_publish(item)
    M10->>M10: run compliance_scan
    M10->>M22: check_capability(platform, action)
    M22-->>M10: capability_state
    
    alt capability = Native
        M10-->>M11: ready_to_execute
        M11->>M11: create publish_job
        M11->>Platform: upload_content(payload)
        Platform-->>M11: external_post_id
        M11->>M11: create publish_log(success)
        M11-->>M19: evidence_submitted
        M11-->>User: published ✅
    else capability = Degraded
        M10-->>User: warning(degraded_reason)
        User->>M11: proceed_anyway
        M11->>Platform: attempt_publish
        Note over M11: May partially succeed
    else capability = Manual
        M10-->>User: manual_fallback_required
        M11->>M11: generate export_package
        M11-->>User: download_package + instructions
        User->>M11: confirm_manual_publish(proof)
        M11->>M19: evidence_submitted(imported_proof)
    else capability = Unsupported
        M10-->>User: blocked(unsupported_reason)
    end
```

---

## 4. Order Import & Profit Calculation

```mermaid
sequenceDiagram
    participant Platform as Platform API
    participant Sync as Sync Worker
    participant M13 as Product Hub
    participant M19 as Profit Layer
    participant CH as ClickHouse
    participant User

    Sync->>Platform: get_orders(since)
    Platform-->>Sync: order_batch[]
    Sync->>M13: import_orders(batch)
    M13->>M13: dedupe + create/update orders
    M13-->>M19: order.imported events
    
    Sync->>Platform: get_settlements(period)
    Platform-->>Sync: settlement_batch[]
    Sync->>M19: import_settlements(batch)
    M19->>M19: match orders ↔ settlements
    M19->>M19: calculate fees, deductions
    M19->>M19: build profit_snapshot
    
    Note over M19: Net Profit = Revenue - Platform Fees<br/>- Shipping - Commissions<br/>- Refunds - COGS - Ads - AI Costs
    
    M19->>CH: insert profit_daily(snapshot)
    M19-->>User: profit.snapshot_updated
    
    alt Anomaly Detected
        M19->>M19: detect_anomaly(margin_drop)
        M19-->>User: profit.anomaly_detected
    end
```

---

## 5. Thread → Commerce Conversion

```mermaid
sequenceDiagram
    participant Platform as Platform (Comment/DM)
    participant M12 as Inbox
    participant AI as Intent Classifier
    participant User
    participant M14 as Monetization
    participant M16 as Affiliate

    Platform-->>M12: new_message webhook
    M12->>M12: create/update thread
    M12->>AI: classify_intent(message)
    AI-->>M12: intent=purchase, confidence=high
    M12->>M12: update thread.intent
    M12-->>User: thread card with intent badge
    
    User->>M12: open thread
    M12->>M12: suggest_reply(template)
    M12->>M14: get_relevant_offers(product_context)
    M14-->>M12: offer_suggestions[]
    M12->>M16: generate_affiliate_link(offer)
    M16-->>M12: tracked_url
    M12-->>User: suggested_reply_with_link
    
    User->>M12: send_reply(with_link)
    M12->>Platform: post_reply
    M12->>M12: update thread.next_action = follow_up
    M12->>M12: create follow_up_task(3_days)
```

---

## 6. Workflow Execution (Activepieces)

```mermaid
sequenceDiagram
    participant Event as Domain Event
    participant M20 as Workflow Engine
    participant AP as Activepieces
    participant ApprovalQ as Approval Queue
    participant User
    participant Action as Domain Action

    Event-->>M20: trigger_event
    M20->>M20: match_workflows(event)
    M20->>M20: check_tier_limits(workspace)
    M20->>AP: trigger_flow(flow_id, input)
    AP->>AP: execute node 1 (condition)
    AP->>AP: execute node 2 (transform)
    AP->>AP: execute node 3 (approval gate)
    AP-->>M20: approval_required
    M20->>ApprovalQ: create_approval_request
    M20-->>User: push notification
    User->>M20: approve()
    M20->>AP: resume_flow(run_id)
    AP->>Action: execute_action(payload)
    Action-->>AP: action_result
    AP-->>M20: flow_completed(side_effects)
    M20->>M20: create audit_event
    M20->>M20: create workflow_run record
```

---

## 7. Authentication Flow (Clerk + Rust)

```mermaid
sequenceDiagram
    participant User
    participant Web as SvelteKit
    participant Clerk as Clerk
    participant API as Rust API
    participant DB as PostgreSQL

    User->>Web: login
    Web->>Clerk: authenticate
    Clerk-->>Web: session + JWT
    Web->>API: request + JWT (ConnectRPC)
    API->>API: Tower middleware: validate JWT
    API->>API: extract workspace_id + role
    API->>DB: SET LOCAL app.current_tenant_id
    API->>API: check_permission(role, action)
    API->>DB: execute query (RLS enforced)
    DB-->>API: results (tenant-scoped)
    API-->>Web: response (Protobuf)
    Web-->>User: render
```

---

## 8. Morning Brief Generation (§35)

```mermaid
sequenceDiagram
    participant Cron as Cron Scheduler
    participant Brief as Brief Generator
    participant M01 as Home Service
    participant M19 as Profit
    participant M12 as Inbox
    participant M02 as Trends
    participant AI as Gemini Flash
    participant Push as FCM/Email

    Cron->>Brief: trigger (6:30 AM per timezone)
    Brief->>M19: get_yesterday_profit(workspace)
    Brief->>M12: get_urgent_threads(workspace)
    Brief->>M02: get_new_trends(workspace)
    Brief->>M01: get_top_actions(workspace)
    Brief->>AI: generate_brief_summary(data)
    AI-->>Brief: personalized_summary
    Brief->>Brief: compose sections
    Brief->>Push: send_push(workspace_users)
    Brief->>Push: send_email(if_enabled)
    Brief-->>M01: morning_brief.generated
```

---

## 9. AI Credit Check and Execution

All AI flows use the durable state machine in [Credit accounting](../04_contracts/credit_accounting_contract.md). §11 shows the transaction boundaries; cache is a projection and never authorizes spend. Plan/role/object gates run before quote/hold.

---

## 10. AI Remix Pipeline (3-Phase — Audit v5 M5)

> **Ref**: Pack 04 §9.5, AI Remix Studio contract

```mermaid
sequenceDiagram
    participant User
    participant API as Rust API
    participant Credits as Credit System
    participant Remix as Remix Engine
    participant AI as Gemini AI
    participant Storage as R2 Storage
    participant Compliance as Originality Checker

    Note over User,Compliance: Phase 1 — Analysis (1 credit)
    User->>API: analyze_reference(video_url)
    API->>Credits: reserve(1 credit)
    Credits-->>API: reservation_id
    API->>Remix: extract_creative_dna(video)
    Remix->>AI: analyze(scenes, hooks, pacing, structure)
    AI-->>Remix: creative_dna_json
    Remix->>Remix: create remix_blueprint
    Remix-->>User: blueprint + Creative DNA card

    Note over User,Compliance: Phase 2 — Generation (5-15 credits)
    User->>API: generate_remix(blueprint_id, fidelity, character)
    API->>Credits: reserve(estimated_cost)
    Credits-->>API: reservation_id
    API->>Remix: build_remix_script(blueprint, fidelity_level)
    Remix->>AI: generate_script(creative_dna, user_character)
    AI-->>Remix: remix_script
    Remix->>AI: generate_video(remix_script, character, voice)
    AI-->>Remix: video_output

    Note over User,Compliance: Phase 3 — Originality Check
    Remix->>Compliance: check_originality(reference, output)
    Compliance->>Compliance: script_similarity_check (<30%)
    Compliance->>Compliance: visual_similarity_check
    Compliance->>Compliance: audio_similarity_check (expect 0%)

    alt Originality Passed (score > 70%)
        Compliance-->>Remix: passed(score=85)
        Remix->>Storage: upload(output)
        Remix->>Credits: commit(actual_cost)
        Remix-->>User: remix_ready(asset_id, originality_score)
    else Originality Failed (score < 70%)
        Compliance-->>Remix: failed(score=45, details)
        Remix->>Credits: release_reservation
        Remix-->>User: remix_blocked(reason, suggestions)
    end
```

---

## 11. Durable Credit Reservation

```mermaid
sequenceDiagram
    participant User
    participant API
    participant DB as PostgreSQL
    participant Worker
    participant Provider
    User->>API: Confirm quote_id + confirmed_credits + idempotency_key
    API->>DB: BEGIN; lock workspace; validate quote; allocate lots
    API->>DB: INSERT reservation held + allocations + outbox; COMMIT
    API-->>User: Reservation/job identity
    Worker->>DB: Claim event; held to in_flight; persist external_effect
    Worker->>Provider: Submit with stable provider operation identity
    alt Usable output
        Provider-->>Worker: Result + measured units
        Worker->>DB: BEGIN; lock; conditional commit; append debit; release remainder; inbox + outbox; COMMIT
    else Definite failure or cancellation
        Worker->>DB: Conditional release exactly once; audit + outbox
    else Unknown result or worker restart
        Worker->>DB: Mark reconciling; retain hold; probe/status recovery
    end
    Note over DB: Sweeper expires only unsubmitted held reservations after 30 minutes
    Note over DB: Late callbacks and duplicate events cannot debit a terminal reservation
```

The complete transitions, source-lot expiry, five-reservation cap and restart fixtures are owned by [Credit accounting](../04_contracts/credit_accounting_contract.md).

---

## 12. Link-to-Video Pipeline (Audit v5 M5)

> **Ref**: Pack 04 §9.9 — Scrape product URL → Generate sales script → Create video

```mermaid
sequenceDiagram
    participant User
    participant API as Rust API
    participant Scraper as Product Scraper
    participant AI as Gemini AI
    participant VideoGen as Video Generator
    participant Credits as Credit System
    participant Storage as R2 Storage

    User->>API: create_link_to_video(url, template, character)
    API->>API: detect_platform(url)
    API->>Credits: reserve(estimated_credits)

    Note over API,Scraper: Phase 1 — Scrape
    API->>Scraper: scrape_product(url, platform)
    Scraper->>Scraper: extract(name, price, images, description, reviews)

    alt Scrape Success
        Scraper-->>API: scraped_data
    else Scrape Failed (anti-bot, 404)
        Scraper-->>API: scrape_failed
        API->>Credits: release_reservation
        API-->>User: scrape_error(manual_input_option)
        User->>API: submit_manual_data(name, price, images)
    end

    Note over API,AI: Phase 2 — Script Generation
    API->>AI: generate_script(scraped_data, template_style)
    Note right of AI: template: problem_solution,<br/>listicle, testimonial,<br/>flash_sale, comparison
    AI-->>API: sales_script
    API-->>User: preview_script(editable)
    User->>API: approve_script(optional_edits)

    Note over API,Storage: Phase 3 — Video Generation
    API->>VideoGen: generate(script, character, voice, images)
    VideoGen->>VideoGen: compose scenes with product images
    VideoGen->>Storage: upload(video)
    Storage-->>VideoGen: video_url
    VideoGen-->>API: generation_completed
    API->>Credits: commit(actual_cost)
    API-->>User: video_ready(asset_id, preview_url)
```

---

## 13. Content Repurpose Pipeline (1 → 50+) (Audit v5 M5)

> **Ref**: PRD §36, Pack 04 §9.13 — One video generates 50+ content pieces across formats.

```mermaid
sequenceDiagram
    participant User
    participant API as Rust API
    participant Repurpose as Repurpose Engine
    participant AI as Gemini AI
    participant ClipEngine as Clip Factory
    participant Credits as Credit System
    participant Storage as R2 Storage

    User->>API: create_repurpose_job(asset_id, pipeline_config)
    API->>Credits: reserve(estimated_credits)
    API->>Repurpose: start_pipeline(asset, config)

    par Auto-Clips (3-5 clips)
        Repurpose->>ClipEngine: analyze_and_clip(video)
        ClipEngine-->>Repurpose: clip_collection[]
    and Text Posts (5-10 posts)
        Repurpose->>AI: extract_quotes_and_insights(transcript)
        AI-->>Repurpose: text_posts[]
    and Thumbnails (3-5 variants)
        Repurpose->>AI: generate_thumbnails(key_frames)
        AI-->>Repurpose: thumbnail_urls[]
    and Carousel (1-2 sets)
        Repurpose->>AI: create_carousel(key_points, images)
        AI-->>Repurpose: carousel_slides[]
    and Blog Post (1)
        Repurpose->>AI: transcript_to_blog(transcript, seo_keywords)
        AI-->>Repurpose: blog_html
    and Audio Podcast (1)
        Repurpose->>AI: extract_audio(video)
        AI-->>Repurpose: audio_url
    and Captions/Subtitles (SRT)
        Repurpose->>AI: generate_captions(video)
        AI-->>Repurpose: srt_file
    end

    Repurpose->>Storage: upload_all(outputs[])
    Repurpose->>Credits: commit(actual_credits)

    alt Auto-Schedule Enabled
        Repurpose->>Repurpose: create_publish_items(draft, schedule)
        Repurpose-->>User: repurpose_complete(50+ items, schedule_preview)
    else Manual Review
        Repurpose-->>User: repurpose_complete(50+ items, all_drafts)
    end

    Note over User: All outputs are DRAFTS<br/>User MUST approve before publish
```

---

These 13 diagrams cover all critical and extended flows. The complete set provides implementation-ready sequence guidance for core system operations, AI production pipelines, commerce lifecycle, and credit management.


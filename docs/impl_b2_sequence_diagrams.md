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
    API->>Credits: check_balance(estimated_cost)
    Credits-->>API: balance_ok
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
    Router->>Credits: deduct(actual_cost)
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

## 9. AI Credit Check & Deduction

```mermaid
sequenceDiagram
    participant User
    participant API as Service
    participant Credits as Credit System
    participant Cache as Dragonfly
    participant DB as PostgreSQL

    User->>API: request_ai_action(type)
    API->>Credits: estimate_cost(action_type)
    Credits->>Cache: get credits:balance:{workspace}
    
    alt Balance Sufficient
        Credits-->>API: approved(estimated_cost)
        API->>API: execute AI action
        API->>Credits: deduct(actual_cost)
        Credits->>DB: INSERT ai_credit_transaction
        Credits->>Cache: SET credits:balance (new_balance)
        Credits-->>API: deducted
    else Balance Low (Pro/Business)
        Credits-->>API: soft_warning(remaining)
        API->>API: proceed with warning
    else Balance Exhausted (Free/Starter)
        Credits-->>API: hard_block
        API-->>User: credits_exhausted error
    end
```

These 9 diagrams cover the most critical flows. Additional flows (Live Commerce, Seeding Pipeline, Referral, Dunning, Content Repurpose) follow similar patterns documented in the upstream packs.

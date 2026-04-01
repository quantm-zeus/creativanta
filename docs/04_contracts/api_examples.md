---
layer: contracts
canonical: true
companion_to: api_endpoint_map.md
purpose: JSON request/response examples for key RPCs (API-M-002 resolution)
last_updated: 2026-04-02
---

# API JSON Request/Response Examples (Appendix to api_endpoint_map.md)

> **Purpose**: Concrete JSON payloads for key RPCs, derived from `database_schema.md` field names. All field names match DB columns exactly (snake_case). Timestamps use ISO 8601. UUIDs use v7. Money fields use string representation of NUMERIC(18,6).

---

## A.1 Identity — AuthService/Login

```json
// Request
{
  "provider": "clerk",
  "token": "eyJhbG...",
  "device_info": {
    "platform": "web",
    "user_agent": "Mozilla/5.0..."
  }
}

// Response (200 OK)
{
  "access_token": "eyJhbG...",
  "refresh_token": "dGhpcyBpcyBhIHJlZnJlc2g...",
  "expires_in": 3600,
  "user": {
    "id": "019086a1-7c3e-7000-8000-000000000001",
    "email": "creator@example.com",
    "display_name": "Nguyễn Văn A",
    "avatar_url": "https://cdn.creativanta.com/avatars/019086a1.webp",
    "default_workspace_id": "019086a1-7c3e-7000-8000-000000000010"
  }
}
```

## A.2 Intelligence — TrendService/ListTrends

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "filters": {
    "platforms": ["tiktok", "youtube"],
    "min_strength": 0.6,
    "category": "beauty"
  },
  "pagination": { "page_size": 20, "page_token": "" }
}

// Response (200 OK)
{
  "trends": [
    {
      "id": "019086a2-1234-7000-8000-000000000001",
      "title": "Glass Skin Tutorial 2026",
      "strength_score": 0.87,
      "velocity": "rising",
      "platforms": ["tiktok", "youtube"],
      "category": "beauty",
      "signal_count": 342,
      "first_detected_at": "2026-03-28T10:00:00Z",
      "expires_at": "2026-04-10T10:00:00Z"
    }
  ],
  "next_page_token": "eyJwYWdl...",
  "total_count": 47
}
```

## A.3 Content — ScriptService/Create

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "title": "Product Review: Serum ABC",
  "content_type": "short_video",
  "body": "Hook: Bạn có biết serum này đang viral trên TikTok?\n\nScene 1: ...",
  "source_idea_id": "019086a2-5678-7000-8000-000000000001",
  "target_platforms": ["tiktok", "youtube_shorts"],
  "tags": ["beauty", "skincare", "review"]
}

// Response (201 Created)
{
  "id": "019086a3-abcd-7000-8000-000000000001",
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "title": "Product Review: Serum ABC",
  "lifecycle_state": "draft",
  "approval_state": "not_submitted",
  "version": 1,
  "word_count": 245,
  "created_at": "2026-04-02T15:30:00Z",
  "created_by": "019086a1-7c3e-7000-8000-000000000001"
}
```

## A.4 Production — GenerationService/StartGeneration

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "mode": "ai_video_generation",
  "config": {
    "script_id": "019086a3-abcd-7000-8000-000000000001",
    "character_id": "019086a4-1111-7000-8000-000000000001",
    "style": "cinematic",
    "duration_target_s": 45,
    "resolution": "1080p",
    "aspect_ratio": "9:16",
    "provider_preference": "veo_quality"
  }
}

// Response (202 Accepted)
{
  "job_id": "019086a5-aaaa-7000-8000-000000000001",
  "status": "queued",
  "estimated_credits": 35,
  "reserved_credits": 35,
  "estimated_duration_s": 180,
  "position_in_queue": 3,
  "sse_url": "/api/v1/generations/019086a5-aaaa/stream"
}
```

## A.5 Production — GenerationService/GetStatus (SSE stream)

```json
// SSE Event: progress
{
  "job_id": "019086a5-aaaa-7000-8000-000000000001",
  "status": "processing",
  "current_stage": "generating_visuals",
  "stage_progress": 0.65,
  "stage_label": "Generating visuals Scene 4/5",
  "estimated_remaining_ms": 45000,
  "credits_used_so_far": 22
}

// SSE Event: completed
{
  "job_id": "019086a5-aaaa-7000-8000-000000000001",
  "status": "completed",
  "asset_id": "019086a6-bbbb-7000-8000-000000000001",
  "credits_used": 32,
  "credits_refunded": 3,
  "duration_ms": 142500,
  "output": {
    "url": "https://cdn.creativanta.com/assets/019086a6-bbbb.mp4",
    "duration_s": 44,
    "resolution": "1080x1920",
    "file_size_bytes": 14200000
  }
}
```

## A.6 Publish — PublishService/Schedule

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "publish_item_id": "019086a7-cccc-7000-8000-000000000001",
  "platforms": [
    {
      "platform": "tiktok",
      "account_id": "019086a8-1111-7000-8000-000000000001",
      "caption": "Serum viral trên TikTok! 🔥 #skincare #beauty",
      "scheduled_at": "2026-04-03T10:00:00+07:00",
      "hashtags": ["skincare", "beauty", "review"],
      "music_id": null
    },
    {
      "platform": "youtube_shorts",
      "account_id": "019086a8-2222-7000-8000-000000000001",
      "caption": "Product Review: Serum ABC",
      "scheduled_at": "2026-04-03T11:00:00+07:00"
    }
  ]
}

// Response (200 OK)
{
  "publish_jobs": [
    {
      "id": "019086a9-dddd-7000-8000-000000000001",
      "platform": "tiktok",
      "lifecycle_state": "scheduled",
      "scheduled_at": "2026-04-03T10:00:00+07:00",
      "approval_required": false
    },
    {
      "id": "019086a9-dddd-7000-8000-000000000002",
      "platform": "youtube_shorts",
      "lifecycle_state": "scheduled",
      "scheduled_at": "2026-04-03T11:00:00+07:00",
      "approval_required": false
    }
  ]
}
```

## A.7 Engagement — ThreadService/Reply

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "thread_id": "019086b0-eeee-7000-8000-000000000001",
  "message": {
    "body": "Cảm ơn bạn! Mình sẽ review thêm variant này nhé 💕",
    "use_ai_suggestion": false
  }
}

// Response (200 OK)
{
  "message_id": "019086b1-ffff-7000-8000-000000000001",
  "thread_id": "019086b0-eeee-7000-8000-000000000001",
  "direction": "outbound",
  "status": "sent",
  "platform_message_id": "tiktok_msg_abc123",
  "sent_at": "2026-04-02T15:45:00Z"
}
```

## A.8 Commerce — ProductService/Create

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "title": "Serum ABC - Whitening Edition",
  "product_type": "physical",
  "description": "Serum dưỡng trắng da chính hãng",
  "price": "350000.000000",
  "currency": "VND",
  "sku": "SERUM-ABC-WE-001",
  "source_platform": "shopee",
  "external_id": "shopee_12345678",
  "category_ids": ["skincare", "serum"],
  "images": ["https://cdn.creativanta.com/products/serum-abc-1.webp"]
}

// Response (201 Created)
{
  "id": "019086c0-1111-7000-8000-000000000001",
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "title": "Serum ABC - Whitening Edition",
  "catalog_status": "active",
  "price": "350000.000000",
  "currency": "VND",
  "sku": "SERUM-ABC-WE-001",
  "created_at": "2026-04-02T15:50:00Z"
}
```

## A.9 Commerce — OrderService/Import

```json
// Request (batch import from platform sync)
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "source_platform": "shopee",
  "orders": [
    {
      "external_order_id": "SHP240402001",
      "buyer_name": "Trần Thị B",
      "items": [
        { "product_external_id": "shopee_12345678", "quantity": 2, "unit_price": "350000.000000" }
      ],
      "total_amount": "700000.000000",
      "shipping_fee": "30000.000000",
      "platform_fee": "28000.000000",
      "currency": "VND",
      "ordered_at": "2026-04-02T14:00:00+07:00",
      "status": "confirmed"
    }
  ]
}

// Response (200 OK)
{
  "imported": 1,
  "skipped": 0,
  "errors": [],
  "orders": [
    {
      "id": "019086c1-2222-7000-8000-000000000001",
      "external_order_id": "SHP240402001",
      "status": "confirmed",
      "net_amount": "642000.000000"
    }
  ]
}
```

## A.10 Commerce — OfferService/Activate

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "offer_id": "019086c2-3333-7000-8000-000000000001"
}

// Response (200 OK)
{
  "id": "019086c2-3333-7000-8000-000000000001",
  "lifecycle_state": "active",
  "activated_at": "2026-04-02T16:00:00Z",
  "activated_by": "019086a1-7c3e-7000-8000-000000000001",
  "expires_at": "2026-04-16T16:00:00Z"
}
```

## A.11 Commerce — CouponService/ValidateCoupon

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "code": "SPRING2026",
  "order_context": {
    "product_ids": ["019086c0-1111-7000-8000-000000000001"],
    "subtotal": "700000.000000",
    "currency": "VND"
  }
}

// Response (200 OK)
{
  "valid": true,
  "coupon_id": "019086c3-4444-7000-8000-000000000001",
  "discount_type": "percentage",
  "discount_value": "10.000000",
  "max_discount_amount": "100000.000000",
  "calculated_discount": "70000.000000",
  "stackable": false,
  "expires_at": "2026-04-30T23:59:59Z",
  "remaining_uses": 47
}
```

## A.12 Finance — ProfitService/GetSnapshot

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "scope_type": "workspace",
  "scope_id": "019086a1-7c3e-7000-8000-000000000010",
  "period": { "start": "2026-03-01", "end": "2026-03-31" }
}

// Response (200 OK)
{
  "snapshot_id": "019086d0-5555-7000-8000-000000000001",
  "scope_type": "workspace",
  "period": { "start": "2026-03-01", "end": "2026-03-31" },
  "revenue": {
    "total": "15750000.000000",
    "by_source": {
      "shopee": "8500000.000000",
      "tiktok_shop": "5200000.000000",
      "creator_store": "2050000.000000"
    }
  },
  "costs": {
    "total": "4230000.000000",
    "platform_fees": "1575000.000000",
    "shipping": "890000.000000",
    "ai_credits": "165000.000000",
    "cogs": "1600000.000000"
  },
  "net_profit": "11520000.000000",
  "currency": "VND",
  "source_class": "reconciled",
  "computed_at": "2026-04-02T16:00:00Z",
  "unreconciled_count": 3
}
```

## A.13 Finance — ReconciliationService/Reconcile

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "record_id": "019086d1-6666-7000-8000-000000000001",
  "action": "match",
  "matched_settlement_id": "019086d2-7777-7000-8000-000000000001",
  "note": "Matched via platform settlement report"
}

// Response (200 OK)
{
  "id": "019086d1-6666-7000-8000-000000000001",
  "reconciliation_state": "reconciled",
  "matched_amount": "350000.000000",
  "variance": "0.000000",
  "reconciled_at": "2026-04-02T16:05:00Z",
  "reconciled_by": "019086a1-7c3e-7000-8000-000000000001"
}
```

## A.14 Workflow — WorkflowService/Create

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "name": "Auto-reply to sponsor inquiries",
  "description": "Detect sponsor intent → draft reply → send for approval",
  "trigger": {
    "type": "event",
    "event_type": "sponsor_inquiry.detected",
    "conditions": [{ "field": "entity_id", "op": "exists" }]
  },
  "nodes": [
    { "id": "n1", "type": "action", "action": "ai_draft_reply", "config": { "template": "sponsor_reply_v2" } },
    { "id": "n2", "type": "approval", "approver_role": "manager", "timeout_hours": 24 },
    { "id": "n3", "type": "action", "action": "send_reply", "config": {} }
  ],
  "edges": [
    { "from": "trigger", "to": "n1" },
    { "from": "n1", "to": "n2" },
    { "from": "n2", "to": "n3", "condition": "approved" }
  ]
}

// Response (201 Created)
{
  "id": "019086e0-8888-7000-8000-000000000001",
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "name": "Auto-reply to sponsor inquiries",
  "status": "draft",
  "node_count": 3,
  "version": 1,
  "created_at": "2026-04-02T16:10:00Z"
}
```

## A.15 Workflow — WorkflowService/Run

```json
// Request (manual trigger)
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "workflow_id": "019086e0-8888-7000-8000-000000000001",
  "trigger_context": {
    "event_type": "sponsor_inquiry.detected",
    "payload": { "thread_id": "019086b0-eeee-7000-8000-000000000001", "entity_id": "brand_xyz" }
  }
}

// Response (202 Accepted)
{
  "run_id": "019086e1-9999-7000-8000-000000000001",
  "workflow_id": "019086e0-8888-7000-8000-000000000001",
  "status": "started",
  "current_node": "n1",
  "started_at": "2026-04-02T16:15:00Z",
  "sse_url": "/api/v1/workflow-runs/019086e1-9999/stream"
}
```

## A.16 LiveCommerce — LiveCommerceService/CreateSession

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "title": "Flash Sale Friday - Skincare Sets",
  "platform": "tiktok_live",
  "account_id": "019086a8-1111-7000-8000-000000000001",
  "scheduled_start": "2026-04-04T19:00:00+07:00",
  "estimated_duration_min": 90,
  "product_ids": ["019086c0-1111-7000-8000-000000000001"],
  "run_of_show": [
    { "time_offset_min": 0, "cue": "Opening + welcome" },
    { "time_offset_min": 10, "cue": "Product demo: Serum ABC" },
    { "time_offset_min": 30, "cue": "Flash deal announcement" }
  ]
}

// Response (201 Created)
{
  "id": "019086f0-aaaa-7000-8000-000000000001",
  "status": "scheduled",
  "title": "Flash Sale Friday - Skincare Sets",
  "scheduled_start": "2026-04-04T19:00:00+07:00",
  "stream_key": "rtmp://live.tiktok.com/stream/abc123",
  "created_at": "2026-04-02T16:20:00Z"
}
```

## A.17 Seeding — SeedingService/CreateSample

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "campaign_id": "019086f1-bbbb-7000-8000-000000000001",
  "product_id": "019086c0-1111-7000-8000-000000000001",
  "creator_entity_id": "019086f2-cccc-7000-8000-000000000001",
  "quantity": 2,
  "shipping_address": {
    "name": "Lê Thị C",
    "address_line_1": "123 Nguyễn Huệ",
    "city": "Hồ Chí Minh",
    "postal_code": "700000",
    "country": "VN",
    "phone": "+84901234567"
  },
  "content_requirements": "1 unboxing video + 1 review within 14 days",
  "deadline": "2026-04-20"
}

// Response (201 Created)
{
  "id": "019086f3-dddd-7000-8000-000000000001",
  "status": "pending_approval",
  "campaign_id": "019086f1-bbbb-7000-8000-000000000001",
  "product_title": "Serum ABC - Whitening Edition",
  "creator_name": "Lê Thị C",
  "created_at": "2026-04-02T16:25:00Z"
}
```

## A.18 Credits — CreditService/GetBalance

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010"
}

// Response (200 OK)
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "balance": {
    "available": 1456,
    "reserved": 35,
    "total_allocated": 2000,
    "used_this_period": 544,
    "rollover_from_last": 0,
    "purchased_remaining": 200
  },
  "tier": "pro",
  "reset_date": "2026-04-15T00:00:00Z",
  "low_warning_threshold": 200,
  "is_low": false
}
```

## A.19 Admin — AdminBillingService/GetWorkspaceOverview

```json
// Request (admin-only, VPN-required)
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010"
}

// Response (200 OK)
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "owner_email": "creator@example.com",
  "tier": "pro",
  "subscription_status": "active",
  "mrr": "299000.000000",
  "currency": "VND",
  "member_count": 3,
  "connected_accounts": 8,
  "storage_used_bytes": 5368709120,
  "ai_credits_used_this_month": 1245,
  "ai_credits_allocated": 2000,
  "last_payment_at": "2026-03-15T10:00:00Z",
  "next_billing_at": "2026-04-15T10:00:00Z",
  "dunning_state": null,
  "created_at": "2025-11-01T08:00:00Z"
}
```

## A.20 Capability — CapabilityService/GetMatrix

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010"
}

// Response (200 OK)
{
  "platforms": [
    {
      "platform": "tiktok",
      "account_id": "019086a8-1111-7000-8000-000000000001",
      "health_score": 92,
      "status": "healthy",
      "capabilities": {
        "publish": { "state": "available", "rate_limit_remaining": 45, "rate_limit_reset_at": "2026-04-02T17:00:00Z" },
        "analytics": { "state": "available" },
        "comments": { "state": "available" },
        "live": { "state": "available" },
        "shop": { "state": "degraded", "reason": "API rate limit approaching", "degraded_since": "2026-04-02T15:00:00Z" }
      },
      "token_expires_at": "2026-04-15T10:00:00Z"
    },
    {
      "platform": "youtube",
      "account_id": "019086a8-2222-7000-8000-000000000001",
      "health_score": 100,
      "status": "healthy",
      "capabilities": {
        "publish": { "state": "available" },
        "analytics": { "state": "available" },
        "comments": { "state": "available" }
      },
      "token_expires_at": "2026-05-01T10:00:00Z"
    }
  ]
}
```

## A.21 Referral — ReferralService/GetDashboard

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010"
}

// Response (200 OK)
{
  "referral_code": "CREATOR-NGUYEN-2026",
  "referral_url": "https://creativanta.com/ref/CREATOR-NGUYEN-2026",
  "stats": {
    "total_referrals": 12,
    "qualified_referrals": 8,
    "pending_referrals": 4,
    "total_credits_earned": 800,
    "remaining_slots_this_year": 42
  },
  "recent_referrals": [
    {
      "referee_display_name": "Phạm D",
      "status": "qualified",
      "credits_earned": 100,
      "qualified_at": "2026-03-28T12:00:00Z"
    }
  ]
}
```

## A.22 VoiceClone — VoiceCloneService/Create

```json
// Request
{
  "workspace_id": "019086a1-7c3e-7000-8000-000000000010",
  "character_id": "019086a4-1111-7000-8000-000000000001",
  "name": "Voice - Nguyễn Văn A",
  "sample_audio_urls": [
    "https://cdn.creativanta.com/voice-samples/sample1.wav",
    "https://cdn.creativanta.com/voice-samples/sample2.wav"
  ],
  "consent_confirmed": true,
  "language": "vi"
}

// Response (202 Accepted)
{
  "voice_clone_id": "01908700-1111-7000-8000-000000000001",
  "status": "processing",
  "estimated_duration_s": 300,
  "credits_reserved": 15,
  "consent_status": "granted"
}
```

## A.23 Error Response (Standard)

```json
// Error Response (400 Bad Request)
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Coupon code has expired",
    "details": [
      { "field": "code", "reason": "expired", "value": "SPRING2025" }
    ],
    "request_id": "req_019086ff-0000-7000-8000-000000000001",
    "trace_id": "trace_abc123"
  }
}

// Error Response (403 Forbidden — Tier Gate)
{
  "error": {
    "code": "TIER_GATE_BLOCKED",
    "message": "Voice clone requires Pro tier or above",
    "details": [
      { "required_tier": "pro", "current_tier": "starter", "feature": "voice_clone" }
    ],
    "upgrade_url": "/settings/billing?upgrade=pro",
    "request_id": "req_019086ff-1111-7000-8000-000000000001"
  }
}

// Error Response (429 Rate Limited)
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "AI generation rate limit exceeded (10/hour)",
    "details": [
      { "limit": 10, "window": "1h", "reset_at": "2026-04-02T17:00:00Z" }
    ],
    "retry_after_seconds": 1800,
    "request_id": "req_019086ff-2222-7000-8000-000000000001"
  }
}
```

## A.24 Pagination Convention

```json
// Standard paginated list request
{
  "workspace_id": "...",
  "pagination": {
    "page_size": 25,
    "page_token": "",
    "sort_by": "created_at",
    "sort_order": "desc"
  },
  "filters": {}
}

// Standard paginated list response envelope
{
  "items": [],
  "pagination": {
    "next_page_token": "eyJjcmVhdGVkX2F0IjoiMjAyNi0wNC0wMiJ9",
    "prev_page_token": "",
    "total_count": 142,
    "has_more": true
  }
}
```

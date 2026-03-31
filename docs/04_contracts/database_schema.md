---
layer: contracts
canonical: true
source_file: impl_a1_database_schema.md
last_verified: 2026-03-30
known_issues:
  - DB-C-001
  - DB-C-002
  - DB-H-001
  - DB-H-003
do_not_edit_without: Đọc 00_index/OPEN_BLOCKERS.md trước khi sửa
---

## Quick Navigation

| Section | Tables |
|---|---|
| §1 Multi-Tenant Strategy | RLS policy template |
| §2 Naming Conventions | Naming rules |
| §3 Shared Types (ENUMs) | source_class, confidence_band, verification_status, capability_state, reconciliation_state, operator_mode |
| §4 Identity & Workspace | workspaces, users, workspace_members, brand_profiles, connected_accounts, regions, currencies |
| §5 Intelligence (M02-M04) | signals, trends, trend_signals, opportunities, opportunity_sources, competitor_entities, benchmark_snapshots, watchlists |
| §6 Creation (M05-M06) | ideas, idea_sources, hooks, scripts, asset_briefs, scenes, shot_lists |
| §7 AI Production (M07-M09) | characters, continuity_packs, assets, generation_jobs, continuity_violations |
| §8 Publish (M10-M11) | publish_items, publish_jobs, publish_logs |
| §9 Engagement (M12) | entities, threads, messages, follow_up_tasks |
| §10 Commerce (M13-M16) | products, offers, skus, orders, order_items, campaigns, affiliate_links, coupons, store_pages, membership_plans |
| §11 Finance & Proof (M19) | profit_snapshots, settlements, cost_items, reconciliation_records, evidence_items, proof_bundles |
| §12 Workflow & Operations (M17-M21) | live_sessions, cue_cards, sample_requests, sample_shipments, workflows, workflow_runs, agent_runs, recipes |
| §13 Billing, Admin, Diagnostics (M23) | credit_transactions, subscription_events, notification_records, feature_flags, audit_events, diagnostics_records |
| §14 Gamification (§37.3) | achievements, achievement_progress, streaks, challenges, challenge_progress |
| §15 TimescaleDB Hypertables | content_metrics, engagement_metrics, commerce_metrics |
| §16 Creator Pro Tools (S16) | link_in_bio_pages, link_in_bio_items, media_kits, rate_cards, brand_deals |
| §17 Internal Admin (S26) | internal_admins, admin_sessions, moderation_cases, fraud_cases, support_tickets, incidents, system_announcements |
| §18 Operational Tables | file_uploads, api_keys, consent_records, referrals, export_jobs |
| §19 Missing Canonical Objects | video_edit_jobs, remix_blueprints, clip_collections, product_showcases, link_to_video_jobs, translation_jobs, style_packs, ab_test_experiments, repurpose_jobs |
| §20 Indexes Strategy | Index naming and strategy |
| §21 Platform Fee Schedules | fee_schedules |
| §22 Extended Production Tables | Detailed production tables |
| §23-25 Tier C & JSONB | Deferred objects and JSONB shape references |

# A1 — Database Schema Design (PostgreSQL 17 + TimescaleDB + pgvector)

> **Upstream**: PRD v3.1, Product Freeze v3.1, Pack 02 (Backend Schema)
> **Tech**: PostgreSQL 17, SeaORM 2.0, RLS multi-tenant, pgvector, TimescaleDB

---

## 1. Multi-Tenant Strategy

```sql
-- Every tenant-scoped table includes workspace_id with RLS
ALTER TABLE <table> ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON <table>
  USING (workspace_id = current_setting('app.current_tenant_id')::uuid);
```

All tables below include `workspace_id UUID NOT NULL` unless marked `[GLOBAL]`.

---

## 2. Naming Conventions

| Convention | Example |
|---|---|
| Tables | `snake_case`, plural | `signals`, `publish_items` |
| PKs | `<entity>_id UUID DEFAULT gen_random_uuid()` |
| FKs | `<referenced_entity>_id` |
| Timestamps | `created_at`, `updated_at`, `deleted_at` (soft delete) |
| Enums | PostgreSQL ENUM types, snake_case values |
| Indexes | `idx_<table>_<columns>` |

---

## 3. Shared Types (ENUMs)

```sql
CREATE TYPE source_class AS ENUM ('official','imported','inferred','estimated','unreconciled');
CREATE TYPE confidence_band AS ENUM ('high','medium_high','medium','low_medium','low');
CREATE TYPE verification_status AS ENUM ('verified','re_verify','pending');
CREATE TYPE capability_state AS ENUM ('native','read_only','manual','degraded','unsupported');
CREATE TYPE reconciliation_state AS ENUM (
  'fully_reconciled','partially_reconciled','awaiting_evidence',
  'imported_only','inferred_pending_confirmation','conflict_detected','manually_overridden'
);
CREATE TYPE operator_mode AS ENUM (
  'creator','seller','affiliate_operator','live_operator','agency_mcn','brand_collaboration'
);
```

---

## 4. Context: Identity & Workspace

### 4.1 workspaces
```sql
CREATE TABLE workspaces (
  workspace_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_type VARCHAR(50) NOT NULL DEFAULT 'standard',
  display_name VARCHAR(255) NOT NULL,
  slug VARCHAR(100) UNIQUE NOT NULL,
  default_operator_mode operator_mode NOT NULL DEFAULT 'creator',
  primary_region_id UUID REFERENCES regions(region_id),
  primary_currency_id UUID REFERENCES currencies(currency_id),
  status VARCHAR(20) NOT NULL DEFAULT 'active', -- active, suspended, deleted
  subscription_tier VARCHAR(20) NOT NULL DEFAULT 'free', -- free, starter, pro, business, enterprise
  ai_credits_remaining INTEGER NOT NULL DEFAULT 50,
  ai_credits_monthly_limit INTEGER NOT NULL DEFAULT 50,
  billing_cycle_start DATE,
  owner_user_id UUID NOT NULL,
  settings JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);
CREATE INDEX idx_workspaces_owner ON workspaces(owner_user_id);
CREATE INDEX idx_workspaces_slug ON workspaces(slug);
```

### 4.2 users [GLOBAL]
```sql
CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  clerk_id VARCHAR(255) UNIQUE NOT NULL,
  email VARCHAR(255) NOT NULL,
  display_name VARCHAR(255),
  avatar_url TEXT,
  locale VARCHAR(10) DEFAULT 'vi-VN',
  timezone VARCHAR(50) DEFAULT 'Asia/Ho_Chi_Minh',
  status VARCHAR(20) NOT NULL DEFAULT 'active',
  last_login_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE UNIQUE INDEX idx_users_clerk ON users(clerk_id);
CREATE INDEX idx_users_email ON users(email);
```

### 4.3 workspace_members
```sql
CREATE TABLE workspace_members (
  workspace_member_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  user_id UUID NOT NULL REFERENCES users(user_id),
  role VARCHAR(30) NOT NULL DEFAULT 'viewer', -- owner, admin, manager, editor, contributor, viewer, external
  status VARCHAR(20) NOT NULL DEFAULT 'active',
  invited_by UUID REFERENCES users(user_id),
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, user_id)
);
CREATE INDEX idx_wm_workspace ON workspace_members(workspace_id);
CREATE INDEX idx_wm_user ON workspace_members(user_id);
```

### 4.4 brand_profiles
```sql
CREATE TABLE brand_profiles (
  brand_profile_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  brand_name VARCHAR(255) NOT NULL,
  logo_url TEXT,
  brand_colors JSONB DEFAULT '[]', -- [{hex, name}]
  brand_fonts JSONB DEFAULT '[]',
  tone_description TEXT,
  industry VARCHAR(100),
  target_audience TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 4.5 connected_accounts
```sql
CREATE TABLE connected_accounts (
  connected_account_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  provider VARCHAR(50) NOT NULL, -- tiktok, shopee, lazada, youtube, instagram, facebook
  account_handle VARCHAR(255),
  external_account_id VARCHAR(255),
  granted_scopes JSONB DEFAULT '[]',
  access_token_encrypted BYTEA, -- AES-256-GCM encrypted
  refresh_token_encrypted BYTEA,
  token_expires_at TIMESTAMPTZ,
  connection_status VARCHAR(20) NOT NULL DEFAULT 'connected', -- connected, expired, revoked, error
  last_successful_sync_at TIMESTAMPTZ,
  last_failed_sync_at TIMESTAMPTZ,
  last_error_message TEXT,
  capability_summary JSONB DEFAULT '{}',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ca_workspace ON connected_accounts(workspace_id);
CREATE INDEX idx_ca_provider ON connected_accounts(provider);
CREATE UNIQUE INDEX idx_ca_workspace_provider_ext ON connected_accounts(workspace_id, provider, external_account_id);
```

### 4.6 regions & currencies [GLOBAL]
```sql
CREATE TABLE regions (
  region_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(10) UNIQUE NOT NULL, -- VN, TH, ID, PH
  name VARCHAR(100) NOT NULL,
  default_currency_code VARCHAR(5) NOT NULL,
  date_format VARCHAR(20) DEFAULT 'DD/MM/YYYY',
  number_format JSONB DEFAULT '{"decimal":".","thousands":","}'
);

CREATE TABLE currencies (
  currency_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(5) UNIQUE NOT NULL, -- VND, USD, THB
  symbol VARCHAR(10) NOT NULL,
  decimal_places SMALLINT NOT NULL DEFAULT 2,
  display_format VARCHAR(50) -- e.g., "#.###đ" for VND
);
```

---

## 5. Context: Intelligence (M02, M03, M04)

### 5.1 signals
```sql
CREATE TABLE signals (
  signal_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  signal_type VARCHAR(50) NOT NULL, -- keyword_spike, content_trend, product_trend, competitor_move
  source_system VARCHAR(50) NOT NULL, -- tiktok, shopee, google_trends, manual
  source_provider VARCHAR(100),
  collected_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  normalized_summary TEXT NOT NULL,
  raw_payload JSONB,
  freshness_hours INTEGER,
  confidence confidence_band,
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'detected', -- detected, processed, merged, expired, discarded
  related_trend_ids UUID[] DEFAULT '{}',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_signals_workspace ON signals(workspace_id);
CREATE INDEX idx_signals_type ON signals(signal_type);
CREATE INDEX idx_signals_state ON signals(lifecycle_state);
CREATE INDEX idx_signals_collected ON signals(collected_at DESC);
```

### 5.2 trends
```sql
CREATE TABLE trends (
  trend_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  title VARCHAR(500) NOT NULL,
  summary TEXT,
  why_now TEXT,
  relevance_description TEXT,
  source_class source_class NOT NULL DEFAULT 'inferred',
  confidence confidence_band NOT NULL DEFAULT 'medium',
  strength_score REAL, -- 0-100
  freshness_score REAL,
  saturation_score REAL,
  velocity_score REAL,
  freshness_at TIMESTAMPTZ,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_trends_workspace ON trends(workspace_id);
CREATE INDEX idx_trends_strength ON trends(strength_score DESC);
-- pgvector for semantic search
ALTER TABLE trends ADD COLUMN embedding vector(768);
CREATE INDEX idx_trends_embedding ON trends USING ivfflat (embedding vector_cosine_ops);
```

### 5.3 trend_signals (junction)
```sql
CREATE TABLE trend_signals (
  trend_id UUID NOT NULL REFERENCES trends(trend_id),
  signal_id UUID NOT NULL REFERENCES signals(signal_id),
  PRIMARY KEY (trend_id, signal_id)
);
```

### 5.4 opportunities
```sql
CREATE TABLE opportunities (
  opportunity_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  opportunity_type VARCHAR(50) NOT NULL, -- content, product, affiliate, live, campaign
  title VARCHAR(500) NOT NULL,
  summary TEXT,
  why_it_matters TEXT,
  expected_impact JSONB, -- {score, description, revenue_estimate}
  expected_effort JSONB, -- {score, description, time_estimate}
  priority_state VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft,open,prioritized,assigned,in_progress,converted,parked,closed_won,closed_lost
  priority_reason TEXT,
  suggested_next_step TEXT,
  owner_user_id UUID REFERENCES users(user_id),
  confidence confidence_band DEFAULT 'medium',
  converted_to_type VARCHAR(50), -- idea, script, campaign, live_plan
  converted_to_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_opp_workspace ON opportunities(workspace_id);
CREATE INDEX idx_opp_state ON opportunities(priority_state);
CREATE INDEX idx_opp_owner ON opportunities(owner_user_id);
```

### 5.5 opportunity_sources (polymorphic junction)
```sql
CREATE TABLE opportunity_sources (
  opportunity_id UUID NOT NULL REFERENCES opportunities(opportunity_id),
  source_type VARCHAR(50) NOT NULL, -- trend, signal, competitor, product_opportunity
  source_id UUID NOT NULL,
  PRIMARY KEY (opportunity_id, source_type, source_id)
);
```

### 5.6 competitor_entities
```sql
CREATE TABLE competitor_entities (
  competitor_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  name VARCHAR(255) NOT NULL,
  platform VARCHAR(50),
  external_handle VARCHAR(255),
  category VARCHAR(100),
  notes TEXT,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 5.7 benchmark_snapshots
```sql
CREATE TABLE benchmark_snapshots (
  snapshot_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  competitor_id UUID REFERENCES competitor_entities(competitor_id),
  snapshot_type VARCHAR(50) NOT NULL,
  data_period_start DATE,
  data_period_end DATE,
  metrics JSONB NOT NULL, -- flexible metric storage
  source_class source_class NOT NULL DEFAULT 'inferred',
  confidence confidence_band DEFAULT 'medium',
  captured_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 5.8 watchlists
```sql
CREATE TABLE watchlists (
  watchlist_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50) NOT NULL, -- trend, competitor, keyword, product
  criteria JSONB NOT NULL, -- filter/match criteria
  alert_enabled BOOLEAN DEFAULT true,
  alert_threshold JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

---

## 6. Context: Creation (M05, M06)

### 6.1 ideas
```sql
CREATE TABLE ideas (
  idea_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  title VARCHAR(500) NOT NULL,
  description TEXT,
  audience_intent TEXT,
  creator_intent TEXT,
  suggested_format VARCHAR(50),
  suggested_direction TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft,candidate,selected,converted,archived
  idea_score REAL,
  converted_to_type VARCHAR(50), -- script, campaign
  converted_to_id UUID,
  created_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ideas_workspace ON ideas(workspace_id);
CREATE INDEX idx_ideas_status ON ideas(status);
ALTER TABLE ideas ADD COLUMN embedding vector(768);
```

### 6.2 idea_sources (polymorphic)
```sql
CREATE TABLE idea_sources (
  idea_id UUID NOT NULL REFERENCES ideas(idea_id),
  source_type VARCHAR(50) NOT NULL,
  source_id UUID NOT NULL,
  PRIMARY KEY (idea_id, source_type, source_id)
);
```

### 6.3 hooks
```sql
CREATE TABLE hooks (
  hook_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  idea_id UUID REFERENCES ideas(idea_id),
  hook_text TEXT NOT NULL,
  hook_type VARCHAR(50), -- question, shock, story, pov, listicle, contrast
  effectiveness_score REAL,
  usage_count INTEGER DEFAULT 0,
  source VARCHAR(50) DEFAULT 'manual', -- manual, ai_generated, library
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 6.4 scripts
```sql
CREATE TABLE scripts (
  script_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  idea_id UUID REFERENCES ideas(idea_id),
  title VARCHAR(500) NOT NULL,
  format_type VARCHAR(50), -- short_form, long_form, live, review, tutorial
  body JSONB NOT NULL, -- structured: [{scene_id, content, notes, duration_target}]
  cta_blocks JSONB DEFAULT '[]',
  disclosure_blocks JSONB DEFAULT '[]',
  duration_target_seconds INTEGER,
  lifecycle_state VARCHAR(30) NOT NULL DEFAULT 'draft', -- draft,in_review,approved,revision_required,ready_for_production,archived
  approval_state VARCHAR(20) NOT NULL DEFAULT 'not_submitted', -- not_submitted,pending_approval,approved,rejected
  publish_target_profiles JSONB DEFAULT '[]', -- [{platform, format, account_id}]
  continuity_refs JSONB DEFAULT '[]',
  offer_product_hooks JSONB DEFAULT '[]',
  created_by UUID REFERENCES users(user_id),
  approved_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_scripts_workspace ON scripts(workspace_id);
CREATE INDEX idx_scripts_lifecycle ON scripts(lifecycle_state);
CREATE INDEX idx_scripts_approval ON scripts(approval_state);
```

### 6.5 asset_briefs
```sql
CREATE TABLE asset_briefs (
  asset_brief_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  script_id UUID NOT NULL REFERENCES scripts(script_id),
  output_type VARCHAR(50) NOT NULL, -- video, image, audio, mixed
  target_format VARCHAR(50), -- 9:16, 16:9, 1:1
  target_duration_seconds INTEGER,
  target_platforms JSONB DEFAULT '[]',
  continuity_requirements JSONB DEFAULT '{}',
  brand_voice_requirements JSONB DEFAULT '{}',
  production_instructions TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, ready, locked, superseded
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 6.6 scenes & shot_lists
```sql
CREATE TABLE scenes (
  scene_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  script_id UUID NOT NULL REFERENCES scripts(script_id),
  workspace_id UUID NOT NULL,
  scene_index SMALLINT NOT NULL,
  description TEXT,
  duration_seconds INTEGER,
  visual_notes TEXT,
  audio_notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE shot_lists (
  shot_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  scene_id UUID NOT NULL REFERENCES scenes(scene_id),
  workspace_id UUID NOT NULL,
  shot_index SMALLINT NOT NULL,
  shot_type VARCHAR(50),
  description TEXT,
  duration_seconds INTEGER,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

---

## 7. Context: AI Production & Continuity (M07, M08, M09)

### 7.1 characters
```sql
CREATE TABLE characters (
  character_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  name VARCHAR(255) NOT NULL,
  character_type VARCHAR(20) NOT NULL, -- digital_twin, ai_generated, stock
  description TEXT,
  reference_images JSONB DEFAULT '[]', -- [{url, type}]
  voice_settings JSONB DEFAULT '{}',
  visual_settings JSONB DEFAULT '{}',
  consent_verified BOOLEAN DEFAULT false,
  consent_record_id UUID,
  is_default BOOLEAN DEFAULT false,
  status VARCHAR(20) NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_characters_workspace ON characters(workspace_id);
```

### 7.2 character_packs / brand_packs / voice_packs
```sql
CREATE TABLE continuity_packs (
  pack_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  pack_type VARCHAR(20) NOT NULL, -- character, brand, voice, style, lookbook, scene_memory (see §24 for Tier C storage)
  name VARCHAR(255) NOT NULL,
  character_id UUID REFERENCES characters(character_id),
  approved_references JSONB DEFAULT '[]',
  rules_summary TEXT,
  allowed_use_scope JSONB DEFAULT '{}',
  version INTEGER NOT NULL DEFAULT 1,
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, active, deprecated, retired
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_cp_workspace ON continuity_packs(workspace_id);
CREATE INDEX idx_cp_type ON continuity_packs(pack_type);
```

### 7.3 assets
```sql
CREATE TABLE assets (
  asset_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  asset_type VARCHAR(30) NOT NULL, -- video, image, audio, thumbnail, subtitle
  title VARCHAR(500),
  script_id UUID REFERENCES scripts(script_id),
  asset_brief_id UUID REFERENCES asset_briefs(asset_brief_id),
  source_generation_mode VARCHAR(30), -- ai_generated, user_uploaded, imported, derived
  source_provider VARCHAR(50), -- veo, kling, runway, flux, elevenlabs, manual
  source_model VARCHAR(100),
  file_url TEXT,
  file_size_bytes BIGINT,
  duration_seconds REAL,
  resolution VARCHAR(20),
  aspect_ratio VARCHAR(10),
  mime_type VARCHAR(100),
  generation_state VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued,generating,generated,failed,cancelled
  quality_state VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft,review_required,approved,rejected,promoted_canonical
  lineage_refs JSONB DEFAULT '[]', -- [{type, id, prompt}]
  continuity_pack_ids UUID[] DEFAULT '{}',
  generation_cost_credits REAL,
  generation_cost_usd REAL,
  generation_prompt TEXT,
  generation_params JSONB DEFAULT '{}',
  error_message TEXT,
  parent_asset_id UUID REFERENCES assets(asset_id), -- for derivatives
  derivative_type VARCHAR(30), -- clip, variant, remix, repurpose, thumbnail
  metadata JSONB DEFAULT '{}',
  created_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_assets_workspace ON assets(workspace_id);
CREATE INDEX idx_assets_type ON assets(asset_type);
CREATE INDEX idx_assets_gen_state ON assets(generation_state);
CREATE INDEX idx_assets_quality ON assets(quality_state);
CREATE INDEX idx_assets_parent ON assets(parent_asset_id);
CREATE INDEX idx_assets_script ON assets(script_id);
```

### 7.4 generation_jobs
```sql
CREATE TABLE generation_jobs (
  job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  asset_id UUID REFERENCES assets(asset_id),
  job_type VARCHAR(50) NOT NULL, -- video_gen, image_gen, tts, lip_sync, remix, clip_factory, quick_edit, multi_merge, product_showcase, img_to_video, link_to_video, translation, thumbnail, sound_studio, style_extraction, video_agent, performance_analysis, ab_variant
  provider VARCHAR(50) NOT NULL,
  model VARCHAR(100),
  pipeline_strategy VARCHAR(30), -- native_audio, audio_first, post_prod_lip_sync, simple_voice_over
  input_params JSONB NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued,processing,completed,failed,cancelled
  progress_pct SMALLINT DEFAULT 0,
  current_step VARCHAR(100),
  estimated_credits REAL,
  actual_credits REAL,
  actual_cost_usd REAL,
  provider_job_id VARCHAR(255),
  result_url TEXT,
  result_metadata JSONB,
  error_code VARCHAR(50),
  error_message TEXT,
  retry_count SMALLINT DEFAULT 0,
  max_retries SMALLINT DEFAULT 3,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_gj_workspace ON generation_jobs(workspace_id);
CREATE INDEX idx_gj_status ON generation_jobs(status);
CREATE INDEX idx_gj_asset ON generation_jobs(asset_id);
```

> **State Sync Rule (Audit v4 — M1)**: `generation_jobs.status` tracks **per-attempt** execution state. `assets.generation_state` tracks the **aggregate-level** final result. When `generation_jobs.status` changes, `assets.generation_state` MUST be updated atomically to reflect the latest job outcome. The two fields are NOT independent — `assets.generation_state` is derived from the most recent `generation_jobs.status`.

### 7.5 continuity_violations
```sql
CREATE TABLE continuity_violations (
  violation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  asset_id UUID NOT NULL REFERENCES assets(asset_id),
  pack_id UUID REFERENCES continuity_packs(pack_id),
  violation_type VARCHAR(50) NOT NULL, -- visual_drift, voice_drift, brand_drift, style_drift
  severity VARCHAR(20) NOT NULL, -- low, medium, high, critical
  description TEXT,
  drift_score REAL,
  resolved BOOLEAN DEFAULT false,
  resolved_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

---

## 8. Context: Publish & Distribution (M10, M11)

### 8.1 publish_items
```sql
CREATE TABLE publish_items (
  publish_item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  asset_id UUID REFERENCES assets(asset_id),
  target_platform VARCHAR(50) NOT NULL,
  target_account_id UUID REFERENCES connected_accounts(connected_account_id),
  target_format VARCHAR(20),
  publish_mode VARCHAR(20) NOT NULL DEFAULT 'direct', -- direct, draft, export, manual
  title TEXT,
  description TEXT,
  hashtags JSONB DEFAULT '[]',
  schedule_at TIMESTAMPTZ,
  capability_snapshot_id UUID,
  lifecycle_state VARCHAR(30) NOT NULL DEFAULT 'draft', -- draft,queued,scheduled,ready_to_execute,executing,published,partially_published,failed,cancelled,requires_manual_fallback
  diagnostics_state VARCHAR(20) DEFAULT 'healthy', -- healthy,warning,degraded,blocked
  linked_offer_ids UUID[] DEFAULT '{}',
  linked_campaign_ids UUID[] DEFAULT '{}',
  packaging_score REAL,
  compliance_scan_result VARCHAR(20), -- pass,pass_with_warnings,review_required,blocked
  compliance_details JSONB,
  metadata JSONB DEFAULT '{}',
  created_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_pi_workspace ON publish_items(workspace_id);
CREATE INDEX idx_pi_state ON publish_items(lifecycle_state);
CREATE INDEX idx_pi_schedule ON publish_items(schedule_at);
CREATE INDEX idx_pi_platform ON publish_items(target_platform);
```

### 8.2 publish_jobs
```sql
CREATE TABLE publish_jobs (
  publish_job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  publish_item_id UUID NOT NULL REFERENCES publish_items(publish_item_id),
  dispatch_strategy VARCHAR(30),
  lifecycle_state VARCHAR(30) NOT NULL DEFAULT 'created', -- created,queued,dispatched,executing,partially_succeeded,succeeded,failed,cancelled,requires_manual_fallback
  attempt_count SMALLINT DEFAULT 0,
  max_attempts SMALLINT DEFAULT 3,
  current_worker_id VARCHAR(100),
  last_execution_summary JSONB,
  approval_request_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_pj_item ON publish_jobs(publish_item_id);
CREATE INDEX idx_pj_state ON publish_jobs(lifecycle_state);
```

### 8.3 publish_logs (immutable)
```sql
CREATE TABLE publish_logs (
  publish_log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  publish_job_id UUID NOT NULL REFERENCES publish_jobs(publish_job_id),
  publish_item_id UUID NOT NULL REFERENCES publish_items(publish_item_id),
  attempted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  failed_at TIMESTAMPTZ,
  actor_user_id UUID,
  acting_mode operator_mode,
  execution_path VARCHAR(50), -- native_api, manual_upload, export_package
  capability_snapshot_id UUID,
  result_status VARCHAR(30) NOT NULL, -- success, partial_success, failed, timeout
  external_post_id VARCHAR(255),
  external_post_url TEXT,
  diagnostics_ref UUID,
  evidence_ref UUID,
  error_code VARCHAR(50),
  error_message TEXT,
  metadata JSONB DEFAULT '{}'
);
CREATE INDEX idx_pl_item ON publish_logs(publish_item_id);
CREATE INDEX idx_pl_time ON publish_logs(attempted_at DESC);
```

---

## 9. Context: Engagement (M12)

### 9.1 entities (persons/contacts)
```sql
CREATE TABLE entities (
  entity_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  entity_type VARCHAR(30) NOT NULL, -- person, brand, bot, unknown
  display_name VARCHAR(255),
  platform_handles JSONB DEFAULT '[]', -- [{platform, handle, external_id}]
  relationship_state VARCHAR(30), -- lead, customer, creator, partner, sponsor
  tags JSONB DEFAULT '[]',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_entities_workspace ON entities(workspace_id);
```

### 9.2 threads
```sql
CREATE TABLE threads (
  thread_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  thread_type VARCHAR(30) NOT NULL, -- comment, dm, inquiry, sponsor_inquiry, sample_request, support
  entity_id UUID REFERENCES entities(entity_id),
  source_platform VARCHAR(50),
  source_post_id VARCHAR(255),
  owner_user_id UUID REFERENCES users(user_id),
  intent VARCHAR(50), -- purchase, complaint, question, praise, spam, collaboration, sample_request
  priority VARCHAR(10) NOT NULL DEFAULT 'normal', -- urgent,high,normal,low
  status VARCHAR(30) NOT NULL DEFAULT 'new', -- new,triaged,active,waiting_on_user,waiting_on_team,converted_to_task,resolved,archived
  next_action TEXT,
  sla_due_at TIMESTAMPTZ,
  related_object_refs JSONB DEFAULT '[]', -- [{type, id}]
  last_activity_at TIMESTAMPTZ DEFAULT NOW(),
  message_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_threads_workspace ON threads(workspace_id);
CREATE INDEX idx_threads_status ON threads(status);
CREATE INDEX idx_threads_priority ON threads(priority);
CREATE INDEX idx_threads_owner ON threads(owner_user_id);
CREATE INDEX idx_threads_sla ON threads(sla_due_at);
```

### 9.3 messages
```sql
CREATE TABLE messages (
  message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  thread_id UUID NOT NULL REFERENCES threads(thread_id),
  subtype VARCHAR(20) NOT NULL, -- comment, dm, inquiry, reply, system
  source_platform VARCHAR(50),
  body TEXT,
  author_direction VARCHAR(10) NOT NULL, -- inbound, outbound, system
  author_entity_id UUID REFERENCES entities(entity_id),
  author_user_id UUID REFERENCES users(user_id),
  moderation_state VARCHAR(20) DEFAULT 'visible', -- visible, hidden, flagged, deleted
  intent_overlay VARCHAR(50),
  attachments JSONB DEFAULT '[]',
  external_message_id VARCHAR(255),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_messages_thread ON messages(thread_id);
CREATE INDEX idx_messages_created ON messages(created_at);
```

### 9.4 follow_up_tasks
```sql
CREATE TABLE follow_up_tasks (
  task_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  source_thread_id UUID REFERENCES threads(thread_id),
  source_object_type VARCHAR(50),
  source_object_id UUID,
  assigned_user_id UUID REFERENCES users(user_id),
  task_type VARCHAR(50) NOT NULL,
  title VARCHAR(500) NOT NULL,
  description TEXT,
  due_at TIMESTAMPTZ,
  status VARCHAR(20) NOT NULL DEFAULT 'open', -- open,in_progress,blocked,completed,cancelled
  outcome_summary TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ft_workspace ON follow_up_tasks(workspace_id);
CREATE INDEX idx_ft_assigned ON follow_up_tasks(assigned_user_id);
CREATE INDEX idx_ft_status ON follow_up_tasks(status);
```

---

## 10. Context: Commerce (M13, M14, M15, M16)

### 10.1 products
```sql
CREATE TABLE products (
  product_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  product_type VARCHAR(30) NOT NULL, -- physical, digital, service, membership, bundle
  title VARCHAR(500) NOT NULL,
  description TEXT,
  category VARCHAR(100),
  base_price DECIMAL(15,2),
  currency VARCHAR(5) DEFAULT 'VND',
  cogs DECIMAL(15,2), -- cost of goods sold
  catalog_status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, active, archived, discontinued
  inventory_enabled BOOLEAN DEFAULT false,
  external_refs JSONB DEFAULT '[]', -- [{platform, external_id, url}]
  images JSONB DEFAULT '[]',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_products_workspace ON products(workspace_id);
CREATE INDEX idx_products_status ON products(catalog_status);
```

### 10.2 offers
```sql
CREATE TABLE offers (
  offer_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  offer_type VARCHAR(30) NOT NULL, -- product_offer, digital_offer, membership_offer, bundle_offer, affiliate_offer, sponsor_offer
  product_id UUID REFERENCES products(product_id),
  product_less_declaration VARCHAR(50), -- if no product: digital, community, service
  title VARCHAR(500) NOT NULL,
  pricing_value DECIMAL(15,2),
  pricing_currency VARCHAR(5) DEFAULT 'VND',
  pricing_logic JSONB DEFAULT '{}',
  cta_text VARCHAR(100),
  cta_url TEXT,
  channel_availability JSONB DEFAULT '[]', -- [{platform, enabled}]
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft,review_required,active,paused,expired,retired
  campaign_ids UUID[] DEFAULT '{}',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_offers_workspace ON offers(workspace_id);
CREATE INDEX idx_offers_state ON offers(lifecycle_state);
CREATE INDEX idx_offers_product ON offers(product_id);
```

### 10.3 orders
```sql
CREATE TABLE orders (
  order_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  source_class source_class NOT NULL DEFAULT 'imported',
  source_platform VARCHAR(50),
  external_order_id VARCHAR(255),
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'created', -- created,confirmed,fulfilled,completed,refunded,partially_refunded,returned,cancelled
  amount DECIMAL(15,2) NOT NULL,
  currency VARCHAR(5) NOT NULL DEFAULT 'VND',
  product_id UUID REFERENCES products(product_id),
  offer_id UUID REFERENCES offers(offer_id),
  campaign_id UUID,
  post_id UUID, -- publish_item_id
  live_session_id UUID,
  customer_entity_id UUID REFERENCES entities(entity_id),
  items JSONB DEFAULT '[]', -- [{sku, qty, price}] — see §25.1 OrderItem
  fee_breakdown JSONB DEFAULT '{}', -- per-order fee decomposition — see §25.1 FeeBreakdown
  shipping_address JSONB,
  reconciliation_state reconciliation_state DEFAULT 'awaiting_evidence',
  evidence_refs JSONB DEFAULT '[]',
  metadata JSONB DEFAULT '{}',
  ordered_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_orders_workspace ON orders(workspace_id);
CREATE INDEX idx_orders_state ON orders(lifecycle_state);
CREATE INDEX idx_orders_platform ON orders(source_platform);
CREATE INDEX idx_orders_ordered ON orders(ordered_at DESC);
```

> **Audit v6 — M1 Fix**: `fee_breakdown JSONB` added to store per-order fee decomposition (platform fees, payment processing, shipping, tax, commissions, promo). This is the primary source for per-order profit calculation in M19. Shipping costs per order are extracted from `fee_breakdown.shipping_fee` and aggregated into `cost_items` for period-level tracking.

> **Sponsor Inquiry Mapping (Audit v6 — L6)**: Sponsor Inquiry objects (M12/S16) are stored as `threads` with `thread_type = 'sponsor_inquiry'` and `intent = 'collaboration'`. No separate table is needed.

### 10.4 affiliate_links
```sql
CREATE TABLE affiliate_links (
  affiliate_link_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  product_id UUID REFERENCES products(product_id),
  offer_id UUID REFERENCES offers(offer_id),
  campaign_id UUID,
  platform VARCHAR(50) NOT NULL,
  original_url TEXT NOT NULL,
  tracked_url TEXT NOT NULL,
  short_code VARCHAR(50),
  commission_rate DECIMAL(5,2),
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'active', -- draft,active,paused,revoked,expired
  last_health_check_at TIMESTAMPTZ,
  health_status VARCHAR(20) DEFAULT 'healthy', -- healthy, broken, expired, product_unavailable
  click_count INTEGER DEFAULT 0,
  conversion_count INTEGER DEFAULT 0,
  revenue_attributed DECIMAL(15,2) DEFAULT 0,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_al_workspace ON affiliate_links(workspace_id);
CREATE INDEX idx_al_state ON affiliate_links(lifecycle_state);
```

### 10.5 campaigns
```sql
CREATE TABLE campaigns (
  campaign_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  campaign_type VARCHAR(30) NOT NULL, -- content, affiliate, seeding, live, brand_collab
  title VARCHAR(500) NOT NULL,
  objective TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'planned', -- planned,ready,live,paused,completed,cancelled
  start_date DATE,
  end_date DATE,
  budget DECIMAL(15,2),
  budget_currency VARCHAR(5) DEFAULT 'VND',
  related_product_ids UUID[] DEFAULT '{}',
  related_offer_ids UUID[] DEFAULT '{}',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

---

## 11. Context: Finance & Proof (M19)

### 11.1 settlements
```sql
CREATE TABLE settlements (
  settlement_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  source_class source_class NOT NULL DEFAULT 'imported',
  source_platform VARCHAR(50),
  external_settlement_id VARCHAR(255),
  gross_amount DECIMAL(15,2) NOT NULL,
  net_amount DECIMAL(15,2) NOT NULL,
  fees JSONB DEFAULT '{}', -- {platform_fee, transaction_fee, service_fee}
  deductions JSONB DEFAULT '{}',
  currency VARCHAR(5) NOT NULL DEFAULT 'VND',
  settlement_state VARCHAR(20) NOT NULL DEFAULT 'imported', -- imported,pending_reconciliation,reconciled,partially_reconciled,disputed
  related_order_ids UUID[] DEFAULT '{}',
  effective_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 11.2 cost_items
```sql
CREATE TABLE cost_items (
  cost_item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  cost_type VARCHAR(50) NOT NULL, -- platform_fee, shipping, ads_spend, ai_credits, commission, service_tool, cogs, other
  amount DECIMAL(15,2) NOT NULL,
  currency VARCHAR(5) NOT NULL DEFAULT 'VND',
  related_scope_type VARCHAR(50), -- workspace, product, campaign, order, asset
  related_scope_id UUID,
  source_class source_class NOT NULL DEFAULT 'estimated',
  evidence_id UUID,
  confidence_reason TEXT,
  cost_state VARCHAR(20) NOT NULL DEFAULT 'recorded', -- recorded,pending_evidence,reconciled,estimated,superseded
  effective_date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ci_workspace ON cost_items(workspace_id);
CREATE INDEX idx_ci_type ON cost_items(cost_type);
CREATE INDEX idx_ci_date ON cost_items(effective_date);
```

### 11.3 profit_snapshots (materialized/cached)
```sql
CREATE TABLE profit_snapshots (
  snapshot_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  scope_type VARCHAR(30) NOT NULL, -- workspace, product, platform, campaign, content, period
  scope_id UUID,
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  gross_revenue DECIMAL(15,2) DEFAULT 0,
  platform_fees DECIMAL(15,2) DEFAULT 0,
  shipping_costs DECIMAL(15,2) DEFAULT 0,
  affiliate_commissions DECIMAL(15,2) DEFAULT 0,
  refund_deductions DECIMAL(15,2) DEFAULT 0,
  cogs DECIMAL(15,2) DEFAULT 0,
  ads_spend DECIMAL(15,2) DEFAULT 0,
  ai_credit_costs DECIMAL(15,2) DEFAULT 0,
  other_costs DECIMAL(15,2) DEFAULT 0,
  net_profit DECIMAL(15,2) DEFAULT 0,
  margin_pct DECIMAL(5,2),
  source_class_mix JSONB DEFAULT '{}',
  confidence confidence_band DEFAULT 'medium',
  freshness_at TIMESTAMPTZ DEFAULT NOW(),
  currency VARCHAR(5) NOT NULL DEFAULT 'VND',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ps_workspace ON profit_snapshots(workspace_id);
CREATE INDEX idx_ps_scope ON profit_snapshots(scope_type, scope_id);
CREATE INDEX idx_ps_period ON profit_snapshots(period_start, period_end);
```

### 11.4 evidence_objects
```sql
CREATE TABLE evidence_objects (
  evidence_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  evidence_type VARCHAR(50) NOT NULL, -- screenshot, api_response, receipt, report, platform_data
  source_provenance VARCHAR(100),
  content_hash VARCHAR(128), -- SHA-512 immutable hash
  file_url TEXT,
  payload JSONB,
  collected_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  verification_status verification_status NOT NULL DEFAULT 'pending',
  related_object_refs JSONB DEFAULT '[]', -- [{type, id}]
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 11.5 proof_bundles
```sql
CREATE TABLE proof_bundles (
  proof_bundle_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  claim_scope VARCHAR(100) NOT NULL,
  claim_summary TEXT NOT NULL,
  supporting_evidence_ids UUID[] NOT NULL DEFAULT '{}',
  source_class_context JSONB DEFAULT '{}',
  confidence confidence_band DEFAULT 'medium',
  coverage_summary TEXT,
  unresolved_gaps TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

---

## 12. Context: Workflow & Operations (M17, M18, M20, M21)

### 12.1 live_sessions
```sql
CREATE TABLE live_sessions (
  session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  title VARCHAR(500) NOT NULL,
  platform VARCHAR(50),
  connected_account_id UUID REFERENCES connected_accounts(connected_account_id),
  status VARCHAR(20) NOT NULL DEFAULT 'planned', -- planned,ready,live,paused,ended,post_live_processing,closed
  planned_start_at TIMESTAMPTZ,
  actual_start_at TIMESTAMPTZ,
  actual_end_at TIMESTAMPTZ,
  run_of_show JSONB DEFAULT '[]', -- see §25.2 RunOfShowItem
  metrics_snapshot JSONB, -- post-live performance metrics — see §25.2 LiveMetricsSnapshot
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 12.2 workflows
```sql
CREATE TABLE workflows (
  workflow_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  title VARCHAR(500) NOT NULL,
  workflow_type VARCHAR(30) NOT NULL DEFAULT 'custom', -- custom, recipe_installed, agent
  trigger_config JSONB NOT NULL, -- see §25.4 TriggerConfig
  action_chain JSONB NOT NULL, -- Activepieces flow definition
  approval_requirements JSONB DEFAULT '[]',
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, active, paused, archived
  version INTEGER NOT NULL DEFAULT 1,
  activepieces_flow_id VARCHAR(255),
  tier_limit_check BOOLEAN DEFAULT true,
  run_count INTEGER DEFAULT 0,
  created_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 12.3 workflow_runs
```sql
CREATE TABLE workflow_runs (
  run_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  workflow_id UUID NOT NULL REFERENCES workflows(workflow_id),
  trigger_event JSONB NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'queued', -- queued,running,waiting_approval,waiting_external_condition,succeeded,partially_succeeded,failed,cancelled,requires_manual_intervention
  current_node VARCHAR(100),
  result_summary JSONB,
  execution_log JSONB DEFAULT '[]', -- per-node execution trace — see §25.4 ExecutionLogEntry
  affected_object_refs JSONB DEFAULT '[]',
  side_effects_summary JSONB DEFAULT '[]',
  activepieces_run_id VARCHAR(255),
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_wr_workflow ON workflow_runs(workflow_id);
CREATE INDEX idx_wr_status ON workflow_runs(status);
```

### 12.4 agent_runs (Audit v4 — H1: Freeze §16.3 + §28.2)
```sql
CREATE TABLE agent_runs (
  agent_run_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  recipe_id UUID REFERENCES recipe_templates(recipe_id),
  workflow_id UUID REFERENCES workflows(workflow_id),
  plan_summary TEXT NOT NULL,
  execution_scope JSONB DEFAULT '{}', -- {scope_type, scope_refs[]}
  approval_state VARCHAR(20) DEFAULT 'not_required', -- not_required, awaiting_approval, approved, rejected
  current_state VARCHAR(30) NOT NULL DEFAULT 'planning', -- planning,awaiting_approval,executing,waiting_context,completed,partially_completed,failed,handed_off,cancelled
  side_effects_summary JSONB DEFAULT '[]',
  handoff_target_user_id UUID REFERENCES users(user_id),
  handoff_context TEXT,
  diagnostics_ref UUID,
  audit_ref UUID,
  context_refs JSONB DEFAULT '[]', -- [{type, id}]
  credits_used INTEGER DEFAULT 0,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ar_workspace ON agent_runs(workspace_id);
CREATE INDEX idx_ar_state ON agent_runs(current_state);
CREATE INDEX idx_ar_recipe ON agent_runs(recipe_id);
```

> **State Machine Ref**: Freeze Part 2, §28.2 — `planning → awaiting_approval → executing → waiting_context → completed/partially_completed/failed/handed_off/cancelled`. `handed_off` requires `handoff_target_user_id` to be set. `partially_completed` requires `side_effects_summary` to list unresolved actions.

---

## 13. Context: Billing, Admin, Diagnostics (M23)

### 13.1 billing_events
```sql
CREATE TABLE billing_events (
  billing_event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  event_type VARCHAR(50) NOT NULL, -- subscription_created, payment_succeeded, payment_failed, credits_deducted, credits_added, refund
  stripe_event_id VARCHAR(255),
  amount DECIMAL(15,2),
  currency VARCHAR(5),
  subscription_tier VARCHAR(20),
  credits_change INTEGER,
  description TEXT,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_be_workspace ON billing_events(workspace_id);
CREATE INDEX idx_be_created ON billing_events(created_at DESC);
```

### 13.2 ai_credit_transactions
```sql
CREATE TABLE ai_credit_transactions (
  transaction_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  transaction_type VARCHAR(30) NOT NULL, -- deduction, monthly_allocation, top_up, promotional, achievement_reward, referral_bonus
  credits INTEGER NOT NULL, -- positive = add, negative = deduct
  balance_after INTEGER NOT NULL,
  operation_type VARCHAR(50), -- text_gen, image_gen, video_gen, analysis, agent_exec
  generation_job_id UUID,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_act_workspace ON ai_credit_transactions(workspace_id);
CREATE INDEX idx_act_created ON ai_credit_transactions(created_at DESC);
```

### 13.3 audit_events (immutable log)
```sql
CREATE TABLE audit_events (
  audit_event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID,
  actor_user_id UUID,
  actor_type VARCHAR(20) NOT NULL DEFAULT 'user', -- user, system, workflow, agent, admin
  action VARCHAR(100) NOT NULL,
  resource_type VARCHAR(50) NOT NULL,
  resource_id UUID,
  changes JSONB, -- {field: {old, new}}
  reason TEXT,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ae_workspace ON audit_events(workspace_id);
CREATE INDEX idx_ae_resource ON audit_events(resource_type, resource_id);
CREATE INDEX idx_ae_created ON audit_events(created_at DESC);
-- Partition by month for performance
-- CREATE TABLE audit_events_2026_03 PARTITION OF audit_events FOR VALUES FROM ('2026-03-01') TO ('2026-04-01');
```

### 13.4 diagnostics_records
```sql
CREATE TABLE diagnostics_records (
  diagnostics_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID,
  scope_type VARCHAR(50) NOT NULL,
  scope_id UUID,
  error_type VARCHAR(100) NOT NULL,
  severity VARCHAR(20) NOT NULL, -- info, warning, error, critical
  user_facing_explanation TEXT NOT NULL,
  operator_explanation TEXT,
  likely_causes JSONB DEFAULT '[]',
  suggested_actions JSONB DEFAULT '[]',
  repair_path TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'open', -- open, acknowledged, resolving, resolved, closed
  detected_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resolved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_dr_workspace ON diagnostics_records(workspace_id);
CREATE INDEX idx_dr_severity ON diagnostics_records(severity);
CREATE INDEX idx_dr_status ON diagnostics_records(status);
```

### 13.5 notifications
```sql
CREATE TABLE notifications (
  notification_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  user_id UUID NOT NULL REFERENCES users(user_id),
  priority VARCHAR(10) NOT NULL DEFAULT 'normal', -- urgent, high, normal, low
  channel VARCHAR(20) NOT NULL DEFAULT 'in_app', -- in_app, push, email
  title VARCHAR(255) NOT NULL,
  body TEXT,
  deep_link TEXT,
  action_buttons JSONB DEFAULT '[]',
  grouped_key VARCHAR(100), -- for notification grouping
  read_at TIMESTAMPTZ,
  dismissed_at TIMESTAMPTZ,
  delivered_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_notif_user ON notifications(user_id, read_at);
CREATE INDEX idx_notif_created ON notifications(created_at DESC);
```

---

## 14. Context: Gamification & Achievement (§37.3)

### 14.1 creator_progress
```sql
CREATE TABLE creator_progress (
  progress_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL UNIQUE,
  level SMALLINT NOT NULL DEFAULT 1,
  xp INTEGER NOT NULL DEFAULT 0,
  xp_to_next_level INTEGER NOT NULL DEFAULT 100,
  streak_days INTEGER NOT NULL DEFAULT 0,
  streak_last_activity_date DATE,
  creator_score REAL DEFAULT 0,
  total_achievements INTEGER DEFAULT 0,
  season_id VARCHAR(50),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 14.2 achievements
```sql
CREATE TABLE achievement_definitions (
  achievement_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(100) UNIQUE NOT NULL, -- debut_creator, rising_star, etc.
  title VARCHAR(255) NOT NULL,
  description TEXT,
  trigger_condition JSONB NOT NULL,
  reward_credits INTEGER NOT NULL DEFAULT 0,
  badge_image_url TEXT,
  category VARCHAR(50), -- milestone, streak, content, commerce
  sort_order SMALLINT DEFAULT 0,
  active BOOLEAN DEFAULT true
);

CREATE TABLE achievement_records (
  record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  achievement_id UUID NOT NULL REFERENCES achievement_definitions(achievement_id),
  earned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  credits_awarded INTEGER NOT NULL DEFAULT 0,
  UNIQUE(workspace_id, achievement_id)
);
```

---

## 15. TimescaleDB Hypertables (Time-Series)

```sql
-- Platform health metrics
CREATE TABLE platform_health_metrics (
  time TIMESTAMPTZ NOT NULL,
  workspace_id UUID NOT NULL,
  platform VARCHAR(50) NOT NULL,
  metric_name VARCHAR(100) NOT NULL,
  metric_value REAL NOT NULL,
  metadata JSONB DEFAULT '{}'
);
SELECT create_hypertable('platform_health_metrics', 'time');

-- API call logs (for cost tracking)
CREATE TABLE api_call_logs (
  time TIMESTAMPTZ NOT NULL,
  workspace_id UUID NOT NULL,
  provider VARCHAR(50) NOT NULL,
  model VARCHAR(100),
  operation VARCHAR(50) NOT NULL,
  input_tokens INTEGER,
  output_tokens INTEGER,
  cost_usd DECIMAL(10,6),
  latency_ms INTEGER,
  status VARCHAR(20) NOT NULL
);
SELECT create_hypertable('api_call_logs', 'time');
```

---

## 16. Context: Creator Pro Tools (S16)

### 16.1 link_in_bio_pages
```sql
CREATE TABLE link_in_bio_pages (
  page_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  slug VARCHAR(100) UNIQUE NOT NULL,
  title VARCHAR(255),
  bio VARCHAR(300),
  avatar_url TEXT,
  theme VARCHAR(20) NOT NULL DEFAULT 'minimal', -- minimal, bold, gradient, dark, custom
  custom_css JSONB,
  custom_domain VARCHAR(255),
  custom_domain_verified BOOLEAN DEFAULT false,
  analytics_enabled BOOLEAN DEFAULT true,
  total_views INTEGER DEFAULT 0,
  status VARCHAR(20) NOT NULL DEFAULT 'active', -- active, suspended, archived
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE UNIQUE INDEX idx_lib_slug ON link_in_bio_pages(slug);
CREATE INDEX idx_lib_workspace ON link_in_bio_pages(workspace_id);
```

### 16.2 link_items
```sql
CREATE TABLE link_items (
  link_item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  page_id UUID NOT NULL REFERENCES link_in_bio_pages(page_id),
  workspace_id UUID NOT NULL,
  link_type VARCHAR(20) NOT NULL, -- url, product, video, social, download, email
  label VARCHAR(255) NOT NULL,
  url TEXT NOT NULL,
  icon VARCHAR(50),
  thumbnail_url TEXT,
  position SMALLINT NOT NULL DEFAULT 0,
  clicks INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_li_page ON link_items(page_id);
```

### 16.3 media_kits
```sql
CREATE TABLE media_kits (
  media_kit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  template VARCHAR(50) NOT NULL DEFAULT 'professional',
  sections JSONB NOT NULL DEFAULT '[]', -- [{type, title, content, position}]
  brand_profile_id UUID REFERENCES brand_profiles(brand_profile_id),
  share_url TEXT,
  last_generated_at TIMESTAMPTZ,
  generation_credits_used REAL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 16.4 rate_cards & rate_card_items
```sql
CREATE TABLE rate_cards (
  rate_card_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  currency VARCHAR(5) NOT NULL DEFAULT 'VND',
  custom_note TEXT,
  ai_suggested_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE rate_card_items (
  item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  rate_card_id UUID NOT NULL REFERENCES rate_cards(rate_card_id),
  service_type VARCHAR(50) NOT NULL,
  price_min DECIMAL(15,2),
  price_max DECIMAL(15,2),
  ai_suggested_price DECIMAL(15,2),
  description TEXT,
  delivery_time VARCHAR(50),
  position SMALLINT DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 16.5 brand_deals
```sql
CREATE TABLE brand_deals (
  deal_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  brand_name VARCHAR(255) NOT NULL,
  contact_email VARCHAR(255),
  deal_type VARCHAR(30) NOT NULL, -- sponsored_post, product_review, ambassador, affiliate, custom
  value DECIMAL(15,2),
  currency VARCHAR(5) DEFAULT 'VND',
  status VARCHAR(20) NOT NULL DEFAULT 'negotiating', -- negotiating,agreed,in_progress,delivered,paid,completed,cancelled
  deadline DATE,
  deliverables TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_bd_workspace ON brand_deals(workspace_id);
CREATE INDEX idx_bd_status ON brand_deals(status);
```

---

## 17. Context: Internal Admin & Operations (S26) [GLOBAL]

### 17.1 internal_admins [GLOBAL]
```sql
CREATE TABLE internal_admins (
  admin_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  display_name VARCHAR(255) NOT NULL,
  password_hash TEXT NOT NULL, -- Argon2id
  role VARCHAR(30) NOT NULL, -- super_admin, ops_admin, finance_admin, content_admin, support_admin, tech_admin, analyst, auditor
  status VARCHAR(20) NOT NULL DEFAULT 'active', -- active, suspended, revoked
  mfa_secret_encrypted BYTEA, -- TOTP secret, AES-encrypted
  mfa_enabled BOOLEAN NOT NULL DEFAULT false,
  last_login_at TIMESTAMPTZ,
  last_login_ip INET,
  password_changed_at TIMESTAMPTZ DEFAULT NOW(),
  failed_login_count SMALLINT DEFAULT 0,
  max_concurrent_sessions SMALLINT DEFAULT 1,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 17.2 internal_audit_logs [GLOBAL] (immutable)
```sql
CREATE TABLE internal_audit_logs (
  log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_admin_id UUID NOT NULL REFERENCES internal_admins(admin_id),
  actor_role VARCHAR(30) NOT NULL,
  action VARCHAR(100) NOT NULL, -- e.g., user.suspend, billing.refund, config.update
  target_type VARCHAR(50) NOT NULL,
  target_id VARCHAR(255),
  old_value JSONB,
  new_value JSONB,
  reason TEXT, -- required for write actions
  ip_address INET,
  user_agent TEXT,
  session_type VARCHAR(20) NOT NULL DEFAULT 'normal', -- normal, impersonation
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ial_admin ON internal_audit_logs(actor_admin_id);
CREATE INDEX idx_ial_action ON internal_audit_logs(action);
CREATE INDEX idx_ial_target ON internal_audit_logs(target_type, target_id);
CREATE INDEX idx_ial_created ON internal_audit_logs(created_at DESC);
```

### 17.3 impersonation_sessions [GLOBAL]
```sql
CREATE TABLE impersonation_sessions (
  session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id UUID NOT NULL REFERENCES internal_admins(admin_id),
  target_user_id UUID NOT NULL REFERENCES users(user_id),
  target_workspace_id UUID REFERENCES workspaces(workspace_id),
  mode VARCHAR(20) NOT NULL DEFAULT 'read_only', -- read_only, read_write (Super Admin + OTP)
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at TIMESTAMPTZ NOT NULL, -- max 30 min
  ended_at TIMESTAMPTZ,
  pages_viewed JSONB DEFAULT '[]',
  actions_taken JSONB DEFAULT '[]',
  otp_verified BOOLEAN DEFAULT false
);
CREATE INDEX idx_imp_admin ON impersonation_sessions(admin_id);
CREATE INDEX idx_imp_active ON impersonation_sessions(expires_at) WHERE ended_at IS NULL;
```

### 17.4 moderation_cases [GLOBAL]
```sql
CREATE TABLE moderation_cases (
  case_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  case_type VARCHAR(30) NOT NULL, -- content_report, aup_violation, dmca, spam, abuse, fraud
  severity VARCHAR(20) NOT NULL, -- low, medium, high, critical
  status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, in_review, action_taken, dismissed, escalated
  reported_object_type VARCHAR(50) NOT NULL,
  reported_object_id UUID NOT NULL,
  workspace_id UUID REFERENCES workspaces(workspace_id),
  reported_by VARCHAR(20) NOT NULL, -- ai_auto, user_report, admin_manual, system_scan
  reporter_entity_id UUID,
  assigned_to UUID REFERENCES internal_admins(admin_id),
  evidence JSONB DEFAULT '{}',
  resolution TEXT,
  resolution_action VARCHAR(30), -- no_action, warning_sent, content_removed, account_suspended, account_banned
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resolved_at TIMESTAMPTZ
);
CREATE INDEX idx_mc_status ON moderation_cases(status);
CREATE INDEX idx_mc_severity ON moderation_cases(severity);
CREATE INDEX idx_mc_workspace ON moderation_cases(workspace_id);
```

### 17.5 fraud_cases [GLOBAL]
```sql
CREATE TABLE fraud_cases (
  fraud_case_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  fraud_type VARCHAR(30) NOT NULL, -- trial_abuse, multi_account, chargeback, credit_gaming, referral_abuse, scraping, marketplace_fraud
  severity VARCHAR(20) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'detected', -- detected, investigating, confirmed, false_positive, resolved
  implicated_user_ids UUID[] DEFAULT '{}',
  implicated_workspace_ids UUID[] DEFAULT '{}',
  evidence JSONB DEFAULT '{}',
  financial_impact DECIMAL(15,2),
  assigned_to UUID REFERENCES internal_admins(admin_id),
  resolution TEXT,
  resolution_action VARCHAR(30), -- no_action, warning, credit_revoked, account_suspended, account_banned, legal_referral
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resolved_at TIMESTAMPTZ
);
CREATE INDEX idx_fc_status ON fraud_cases(status);
```

### 17.6 feature_flags [GLOBAL]
```sql
CREATE TABLE feature_flags (
  flag_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  enabled BOOLEAN NOT NULL DEFAULT false,
  rollout_percentage SMALLINT DEFAULT 0, -- 0-100
  target_scope VARCHAR(20) DEFAULT 'global', -- global, tier, workspace, user
  target_ids JSONB DEFAULT '[]', -- specific workspace/user IDs or tier names
  dependencies JSONB DEFAULT '[]', -- other flag names this depends on
  is_kill_switch BOOLEAN DEFAULT false,
  created_by UUID REFERENCES internal_admins(admin_id),
  toggled_by UUID REFERENCES internal_admins(admin_id),
  toggled_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE UNIQUE INDEX idx_ff_name ON feature_flags(name);
```

### 17.7 system_announcements [GLOBAL]
```sql
CREATE TABLE system_announcements (
  announcement_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  announcement_type VARCHAR(20) NOT NULL DEFAULT 'info', -- info, warning, success, critical
  target_scope VARCHAR(20) NOT NULL DEFAULT 'all', -- all, tier, mode, workspace
  target_filter JSONB DEFAULT '{}',
  display_mode VARCHAR(20) NOT NULL DEFAULT 'banner', -- banner, modal, notification
  dismissable BOOLEAN DEFAULT true,
  scheduled_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  is_active BOOLEAN DEFAULT true,
  created_by UUID REFERENCES internal_admins(admin_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 17.8 support_tickets
```sql
CREATE TABLE support_tickets (
  ticket_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID REFERENCES workspaces(workspace_id),
  user_id UUID NOT NULL REFERENCES users(user_id),
  ticket_number VARCHAR(20) UNIQUE NOT NULL, -- TK-0001
  subject VARCHAR(500) NOT NULL,
  priority VARCHAR(10) NOT NULL DEFAULT 'normal', -- urgent, high, normal, low
  status VARCHAR(20) NOT NULL DEFAULT 'open', -- open, in_progress, waiting_user, waiting_admin, escalated, resolved, closed
  category VARCHAR(50), -- billing, technical, account, content, feature_request
  assigned_admin_id UUID REFERENCES internal_admins(admin_id),
  sla_response_due_at TIMESTAMPTZ,
  sla_resolution_due_at TIMESTAMPTZ,
  first_responded_at TIMESTAMPTZ,
  resolved_at TIMESTAMPTZ,
  csat_score SMALLINT, -- 1-5
  auto_captured_context JSONB DEFAULT '{}', -- browser, OS, route, last errors
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_st_status ON support_tickets(status);
CREATE INDEX idx_st_assigned ON support_tickets(assigned_admin_id);
CREATE INDEX idx_st_user ON support_tickets(user_id);
CREATE INDEX idx_st_sla ON support_tickets(sla_response_due_at);
```

### 17.9 support_ticket_messages
```sql
CREATE TABLE support_ticket_messages (
  message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_id UUID NOT NULL REFERENCES support_tickets(ticket_id),
  author_type VARCHAR(20) NOT NULL, -- user, admin, ai_bot, system
  author_id UUID, -- user_id or admin_id
  body TEXT NOT NULL,
  attachments JSONB DEFAULT '[]',
  is_internal_note BOOLEAN DEFAULT false, -- only visible to admins
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_stm_ticket ON support_ticket_messages(ticket_id);
```

### 17.10 incidents & post_mortems [GLOBAL]
```sql
CREATE TABLE incidents (
  incident_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(500) NOT NULL,
  severity VARCHAR(20) NOT NULL, -- P0_critical, P1_high, P2_medium, P3_low
  status VARCHAR(20) NOT NULL DEFAULT 'detected', -- detected, investigating, mitigated, resolved, post_mortem
  affected_services JSONB DEFAULT '[]',
  affected_user_count INTEGER DEFAULT 0,
  timeline JSONB DEFAULT '[]', -- [{timestamp, action, actor}]
  root_cause TEXT,
  resolution TEXT,
  lead_admin_id UUID REFERENCES internal_admins(admin_id),
  detected_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  mitigated_at TIMESTAMPTZ,
  resolved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE post_mortems (
  post_mortem_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  incident_id UUID NOT NULL REFERENCES incidents(incident_id),
  summary TEXT NOT NULL,
  root_cause_analysis TEXT NOT NULL,
  contributing_factors JSONB DEFAULT '[]',
  action_items JSONB DEFAULT '[]', -- [{action, owner, due_date, status}]
  lessons_learned TEXT,
  authored_by UUID REFERENCES internal_admins(admin_id),
  published BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 17.11 system_alerts [GLOBAL]
```sql
CREATE TABLE system_alerts (
  alert_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  alert_type VARCHAR(50) NOT NULL, -- revenue_anomaly, churn_spike, ai_cost_overrun, system_health, security_event
  severity VARCHAR(20) NOT NULL, -- info, warning, critical
  title VARCHAR(255) NOT NULL,
  description TEXT,
  trigger_condition JSONB NOT NULL,
  current_value JSONB,
  threshold_value JSONB,
  status VARCHAR(20) NOT NULL DEFAULT 'active', -- active, acknowledged, resolved, dismissed
  acknowledged_by UUID REFERENCES internal_admins(admin_id),
  acknowledged_at TIMESTAMPTZ,
  resolved_at TIMESTAMPTZ,
  auto_action_taken TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_sa_status ON system_alerts(status);
CREATE INDEX idx_sa_severity ON system_alerts(severity);
```

---

## 18. Context: Operational Tables

### 18.1 approval_requests
```sql
CREATE TABLE approval_requests (
  request_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  request_type VARCHAR(50) NOT NULL, -- script_approval, publish_approval, workflow_approval, asset_approval
  object_type VARCHAR(50) NOT NULL,
  object_id UUID NOT NULL,
  requested_by UUID NOT NULL REFERENCES users(user_id),
  approved_by UUID REFERENCES users(user_id),
  status VARCHAR(20) NOT NULL DEFAULT 'not_required', -- not_required, pending_approval, approved, rejected, expired, cancelled
  reason TEXT,
  rejection_reason TEXT,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ar_workspace ON approval_requests(workspace_id);
CREATE INDEX idx_ar_status ON approval_requests(status);
CREATE INDEX idx_ar_object ON approval_requests(object_type, object_id);
```

### 18.2 capability_snapshots
```sql
CREATE TABLE capability_snapshots (
  snapshot_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  platform VARCHAR(50) NOT NULL,
  capabilities JSONB NOT NULL, -- {action: capability_state}
  api_version VARCHAR(20),
  captured_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  valid_until TIMESTAMPTZ,
  notes TEXT
);
CREATE INDEX idx_cs_workspace ON capability_snapshots(workspace_id, platform);
```

### 18.2B policy_notes (Audit v4 — H2: Freeze §16.8, M22 write owner)
```sql
CREATE TABLE policy_notes (
  policy_note_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID,
  platform VARCHAR(50),
  action_scope VARCHAR(100) NOT NULL, -- e.g., 'publish.tiktok.schedule', 'commerce.shopee.auto_reply'
  note_type VARCHAR(30) NOT NULL, -- limitation, deprecation, policy_change, best_practice, warning
  summary TEXT NOT NULL,
  detail TEXT,
  effective_from DATE,
  effective_until DATE, -- NULL = ongoing
  source_url TEXT, -- platform documentation link
  severity VARCHAR(20) NOT NULL DEFAULT 'info', -- info, warning, critical
  related_capability_state capability_state, -- if this note explains a capability state
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_pn_platform ON policy_notes(platform);
CREATE INDEX idx_pn_scope ON policy_notes(action_scope);
CREATE INDEX idx_pn_workspace ON policy_notes(workspace_id);
```

### 18.2C fallback_paths (Audit v4 — H2: Freeze §16.8, M22 write owner)
```sql
CREATE TABLE fallback_paths (
  fallback_path_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID,
  platform VARCHAR(50),
  action_scope VARCHAR(100) NOT NULL, -- same scope taxonomy as policy_notes
  capability_state capability_state NOT NULL, -- which degraded/unsupported state triggers this fallback
  fallback_type VARCHAR(30) NOT NULL, -- manual_alternative, export_package, degraded_mode, workaround, contact_support
  instructions TEXT NOT NULL, -- user-facing step-by-step
  operator_instructions TEXT, -- operator-level detail
  estimated_effort VARCHAR(50), -- e.g., '2 min', '5 min', 'requires admin'
  related_policy_note_id UUID REFERENCES policy_notes(policy_note_id),
  active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_fp_platform ON fallback_paths(platform);
CREATE INDEX idx_fp_scope ON fallback_paths(action_scope);
CREATE INDEX idx_fp_capability ON fallback_paths(capability_state);
```

> **Ref**: Freeze §16.8 — Policy Note and Fallback Path are Trust/Policy Support Records with M22 as primary write owner. Every `Degraded` or `Unsupported` capability state SHOULD have at least one associated `fallback_path`. Policy notes explain *why*, fallback paths explain *what to do*.

### 18.3 consent_records
```sql
CREATE TABLE consent_records (
  consent_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(user_id),
  workspace_id UUID,
  consent_type VARCHAR(50) NOT NULL, -- tos, privacy, marketing, analytics, ai_processing, voice_clone, digital_twin
  version VARCHAR(20) NOT NULL,
  granted BOOLEAN NOT NULL,
  granted_at TIMESTAMPTZ,
  revoked_at TIMESTAMPTZ,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_cr_user ON consent_records(user_id);
CREATE INDEX idx_cr_type ON consent_records(consent_type);
```

### 18.4 api_keys
```sql
CREATE TABLE api_keys (
  api_key_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  key_prefix VARCHAR(10) NOT NULL, -- first 10 chars visible
  key_hash VARCHAR(128) NOT NULL, -- SHA-256 of full key
  name VARCHAR(255) NOT NULL,
  scopes JSONB DEFAULT '[]', -- e.g., ["products:read", "orders:read"]
  status VARCHAR(20) NOT NULL DEFAULT 'active', -- active, suspended, revoked, expired
  last_used_at TIMESTAMPTZ,
  request_count BIGINT DEFAULT 0,
  rate_limit_override INTEGER, -- null = use default
  expires_at TIMESTAMPTZ,
  created_by UUID NOT NULL REFERENCES users(user_id),
  suspended_reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ak_workspace ON api_keys(workspace_id);
CREATE INDEX idx_ak_hash ON api_keys(key_hash);
```

### 18.5 tags (generic polymorphic tagging)
```sql
CREATE TABLE tags (
  tag_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  name VARCHAR(100) NOT NULL,
  color VARCHAR(7), -- hex color
  UNIQUE(workspace_id, name)
);

CREATE TABLE taggables (
  tag_id UUID NOT NULL REFERENCES tags(tag_id),
  taggable_type VARCHAR(50) NOT NULL,
  taggable_id UUID NOT NULL,
  PRIMARY KEY (tag_id, taggable_type, taggable_id)
);
CREATE INDEX idx_taggables_target ON taggables(taggable_type, taggable_id);
```

### 18.6 referral_records
```sql
CREATE TABLE referral_records (
  referral_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  referrer_user_id UUID NOT NULL REFERENCES users(user_id),
  referee_user_id UUID NOT NULL REFERENCES users(user_id),
  referral_code VARCHAR(20) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, qualified, rewarded, revoked
  referee_qualified_at TIMESTAMPTZ,
  referrer_credits_awarded INTEGER DEFAULT 0,
  referee_credits_awarded INTEGER DEFAULT 0,
  fraud_check_passed BOOLEAN,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_rr_referrer ON referral_records(referrer_user_id);
CREATE UNIQUE INDEX idx_rr_referee ON referral_records(referee_user_id);
```

### 18.7 file_uploads
```sql
CREATE TABLE file_uploads (
  upload_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  uploader_user_id UUID NOT NULL REFERENCES users(user_id),
  file_name VARCHAR(500) NOT NULL,
  file_size_bytes BIGINT NOT NULL,
  mime_type VARCHAR(100) NOT NULL,
  storage_key TEXT NOT NULL, -- R2 key
  storage_url TEXT NOT NULL,
  checksum_sha256 VARCHAR(64),
  upload_purpose VARCHAR(50), -- asset, avatar, brand_logo, evidence, import, attachment
  virus_scan_status VARCHAR(20) DEFAULT 'pending', -- pending, clean, infected, error
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_fu_workspace ON file_uploads(workspace_id);
```

### 18.8 export_jobs
```sql
CREATE TABLE export_jobs (
  export_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  user_id UUID NOT NULL REFERENCES users(user_id),
  export_type VARCHAR(50) NOT NULL, -- data_export, tax_report, gdpr_export, analytics_export, media_export
  format VARCHAR(20) NOT NULL DEFAULT 'csv', -- csv, xlsx, pdf, json, zip
  filters JSONB DEFAULT '{}',
  status VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued, processing, completed, failed
  progress_pct SMALLINT DEFAULT 0,
  file_url TEXT,
  file_size_bytes BIGINT,
  expires_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  error_message TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ej_workspace ON export_jobs(workspace_id);
CREATE INDEX idx_ej_status ON export_jobs(status);
```

### 18.9 user_preferences
```sql
CREATE TABLE user_preferences (
  preference_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(user_id),
  workspace_id UUID REFERENCES workspaces(workspace_id),
  notification_email BOOLEAN DEFAULT true,
  notification_push BOOLEAN DEFAULT true,
  notification_in_app BOOLEAN DEFAULT true,
  quiet_hours_start TIME, -- e.g., 22:00
  quiet_hours_end TIME, -- e.g., 07:00
  morning_brief_enabled BOOLEAN DEFAULT true,
  morning_brief_channel VARCHAR(20) DEFAULT 'push', -- push, email, both
  theme VARCHAR(10) DEFAULT 'system', -- light, dark, system
  sidebar_collapsed BOOLEAN DEFAULT false,
  default_view_mode VARCHAR(20) DEFAULT 'grid', -- grid, list, kanban
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, workspace_id)
);
```

### 18.10 scheduled_job_configs [GLOBAL]
```sql
CREATE TABLE scheduled_job_configs (
  job_config_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_name VARCHAR(100) UNIQUE NOT NULL,
  cron_expression VARCHAR(100) NOT NULL,
  description TEXT,
  enabled BOOLEAN DEFAULT true,
  last_run_at TIMESTAMPTZ,
  last_run_status VARCHAR(20), -- success, failed, skipped
  last_run_duration_ms INTEGER,
  next_run_at TIMESTAMPTZ,
  alert_on_failure BOOLEAN DEFAULT true,
  max_duration_seconds INTEGER DEFAULT 300,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

---

## 19. Context: Missing Canonical Objects (Pack 02 §3.3-3.4 Audit)

### 19.1 subscriptions
```sql
CREATE TABLE subscriptions (
  subscription_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  stripe_subscription_id VARCHAR(255),
  plan_tier VARCHAR(20) NOT NULL, -- free, starter, pro, business, enterprise
  status VARCHAR(20) NOT NULL DEFAULT 'active', -- active, trialing, past_due, cancelled, paused
  billing_interval VARCHAR(10) NOT NULL DEFAULT 'monthly', -- monthly, yearly
  current_period_start DATE,
  current_period_end DATE,
  trial_ends_at TIMESTAMPTZ,
  cancelled_at TIMESTAMPTZ,
  cancel_reason TEXT,
  payment_method_last4 VARCHAR(4),
  payment_method_brand VARCHAR(20),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_sub_workspace ON subscriptions(workspace_id);
CREATE INDEX idx_sub_status ON subscriptions(status);
```

### 19.2 coupons
```sql
CREATE TABLE coupons (
  coupon_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  code VARCHAR(50) NOT NULL,
  coupon_type VARCHAR(20) NOT NULL, -- percentage, fixed_amount, free_shipping
  discount_value DECIMAL(15,2) NOT NULL,
  min_order_amount DECIMAL(15,2),
  max_uses INTEGER,
  current_uses INTEGER DEFAULT 0,
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, active, paused, expired, retired, revoked (Note: 'revoked' is a downstream extension of Freeze §26.3 for fraud/policy enforcement cases)
  related_offer_ids UUID[] DEFAULT '{}',
  related_campaign_ids UUID[] DEFAULT '{}',
  valid_from TIMESTAMPTZ,
  valid_until TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, code)
);
```

### 19.3 store_pages
```sql
CREATE TABLE store_pages (
  store_page_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(100) NOT NULL,
  description TEXT,
  layout JSONB DEFAULT '{}', -- {sections, hero, featured_products}
  theme_overrides JSONB DEFAULT '{}',
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, published, hidden, retired
  custom_domain VARCHAR(255),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, slug)
);
```

### 19.4 membership_plans
```sql
CREATE TABLE membership_plans (
  plan_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(15,2) NOT NULL,
  currency VARCHAR(5) DEFAULT 'VND',
  billing_interval VARCHAR(10) NOT NULL DEFAULT 'monthly',
  benefits JSONB DEFAULT '[]', -- [{type, description}]
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, active, hidden, paused, retired
  subscriber_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 19.5 refunds
```sql
CREATE TABLE refunds (
  refund_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  order_id UUID NOT NULL REFERENCES orders(order_id),
  refund_type VARCHAR(20) NOT NULL, -- full, partial, credit
  amount DECIMAL(15,2) NOT NULL,
  currency VARCHAR(5) NOT NULL DEFAULT 'VND',
  reason TEXT NOT NULL,
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'requested', -- requested, approved, rejected, processing, completed, failed, cancelled (aligned to Freeze §27.2)
  source_class source_class NOT NULL DEFAULT 'imported',
  source_platform VARCHAR(50),
  external_refund_id VARCHAR(255),
  settlement_id UUID REFERENCES settlements(settlement_id),
  evidence_refs JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_refunds_order ON refunds(order_id);
```

### 19.6 returns
```sql
CREATE TABLE returns (
  return_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  order_id UUID NOT NULL REFERENCES orders(order_id),
  refund_id UUID REFERENCES refunds(refund_id),
  return_type VARCHAR(20) NOT NULL, -- full, partial
  items JSONB DEFAULT '[]', -- [{sku, quantity, reason}]
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'initiated', -- initiated, approved, shipped_back, received, inspected, closed, rejected
  tracking_number VARCHAR(100),
  evidence_photo_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_returns_order ON returns(order_id);
```

### 19.7 bundles & bundle_items
```sql
CREATE TABLE bundles (
  bundle_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  title VARCHAR(255) NOT NULL,
  offer_id UUID REFERENCES offers(offer_id),
  bundle_price DECIMAL(15,2),
  discount_pct DECIMAL(5,2),
  status VARCHAR(20) NOT NULL DEFAULT 'draft',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE bundle_items (
  bundle_id UUID NOT NULL REFERENCES bundles(bundle_id),
  product_id UUID NOT NULL REFERENCES products(product_id),
  quantity INTEGER NOT NULL DEFAULT 1,
  PRIMARY KEY (bundle_id, product_id)
);
```

### 19.8 price_rules
```sql
CREATE TABLE price_rules (
  price_rule_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  rule_type VARCHAR(30) NOT NULL, -- volume_discount, tiered, time_limited, customer_segment
  conditions JSONB NOT NULL, -- {min_qty, date_range, segment}
  adjustment_type VARCHAR(20) NOT NULL, -- percentage, fixed
  adjustment_value DECIMAL(15,2) NOT NULL,
  related_product_ids UUID[] DEFAULT '{}',
  priority SMALLINT DEFAULT 0,
  status VARCHAR(20) NOT NULL DEFAULT 'active',
  valid_from TIMESTAMPTZ,
  valid_until TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 19.9 live_segments
```sql
CREATE TABLE live_segments (
  segment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES live_sessions(session_id),
  workspace_id UUID NOT NULL,
  segment_type VARCHAR(30) NOT NULL, -- product_demo, qa, giveaway, flash_sale, intro, outro
  start_offset_seconds INTEGER NOT NULL,
  end_offset_seconds INTEGER,
  title VARCHAR(255),
  pinned_offer_id UUID REFERENCES offers(offer_id),
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ls_session ON live_segments(session_id);
```

### 19.9B cue_cards (M17 — Tier B)
```sql
CREATE TABLE cue_cards (
  cue_card_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES live_sessions(session_id),
  workspace_id UUID NOT NULL,
  segment_id UUID REFERENCES live_segments(segment_id),
  cue_type VARCHAR(30) NOT NULL, -- product_highlight, talking_point, price_drop, giveaway, qa_prompt, cta, transition
  title VARCHAR(255) NOT NULL,
  body TEXT,
  pinned_product_id UUID REFERENCES products(product_id),
  pinned_offer_id UUID REFERENCES offers(offer_id),
  display_order SMALLINT NOT NULL DEFAULT 0,
  triggered_at TIMESTAMPTZ, -- when the cue was actually shown/used
  status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, active, used, skipped
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_cc_session ON cue_cards(session_id);
CREATE INDEX idx_cc_segment ON cue_cards(segment_id);
```

### 19.9C highlights (M17 — Tier B)
```sql
CREATE TABLE highlights (
  highlight_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES live_sessions(session_id),
  workspace_id UUID NOT NULL,
  title VARCHAR(255),
  start_offset_seconds INTEGER NOT NULL,
  end_offset_seconds INTEGER NOT NULL,
  highlight_type VARCHAR(30) NOT NULL, -- viral_moment, product_demo, best_sale, audience_peak, key_announcement
  auto_detected BOOLEAN DEFAULT false, -- true = AI-detected, false = manual mark
  asset_id UUID REFERENCES assets(asset_id), -- linked extracted clip
  engagement_score REAL, -- 0-100 composite
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_hl_session ON highlights(session_id);
```

### 19.9D channel_posts (M11 — Tier B, Freeze §13.10)
```sql
CREATE TABLE channel_posts (
  channel_post_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  publish_item_id UUID REFERENCES publish_items(publish_item_id),
  connected_account_id UUID REFERENCES connected_accounts(connected_account_id),
  external_post_id VARCHAR(255),
  external_permalink TEXT,
  post_status VARCHAR(30), -- active, deleted, hidden, flagged
  engagement_summary JSONB DEFAULT '{}', -- {views, likes, comments, shares, saves}
  imported_at TIMESTAMPTZ,
  synced_at TIMESTAMPTZ,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_cp_workspace ON channel_posts(workspace_id);
CREATE INDEX idx_cp_publish ON channel_posts(publish_item_id);
CREATE UNIQUE INDEX idx_cp_external ON channel_posts(connected_account_id, external_post_id);
```

### 19.9E reconciliation_records (M19 — Tier B, Freeze §27.6)
```sql
CREATE TABLE reconciliation_records (
  record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  scope_type VARCHAR(50) NOT NULL, -- order_batch, settlement_batch, affiliate_period, campaign
  scope_description TEXT,
  related_order_ids UUID[] DEFAULT '{}',
  related_settlement_ids UUID[] DEFAULT '{}',
  status VARCHAR(30) NOT NULL DEFAULT 'open', -- open, awaiting_evidence, matching, partially_reconciled, fully_reconciled, conflict_detected, manually_overridden, closed
  mismatches JSONB DEFAULT '[]', -- [{field, expected, actual, severity}]
  override_reason TEXT,
  override_by UUID REFERENCES users(user_id),
  override_at TIMESTAMPTZ,
  audit_event_id UUID,
  period_start DATE,
  period_end DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_rr_workspace ON reconciliation_records(workspace_id);
CREATE INDEX idx_rr_status ON reconciliation_records(status);
```

### 19.9F skus (M13 — Tier C, Freeze §15.2)
```sql
CREATE TABLE skus (
  sku_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  product_id UUID NOT NULL REFERENCES products(product_id),
  sku_code VARCHAR(100) NOT NULL,
  variant_attributes JSONB DEFAULT '{}', -- {color: "Red", size: "M"}
  barcode VARCHAR(50),
  price_override DECIMAL(15,2), -- NULL = use product base_price
  cogs_override DECIMAL(15,2), -- NULL = use product cogs
  weight_grams INTEGER,
  inventory_enabled BOOLEAN DEFAULT true,
  stock_quantity INTEGER NOT NULL DEFAULT 0,
  low_stock_threshold INTEGER DEFAULT 10,
  status VARCHAR(20) NOT NULL DEFAULT 'active', -- active, archived, discontinued
  external_refs JSONB DEFAULT '[]', -- [{platform, external_sku_id}]
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, sku_code)
);
CREATE INDEX idx_skus_product ON skus(product_id);
CREATE INDEX idx_skus_workspace ON skus(workspace_id);
```

### 19.9G inventory_locations (M13 — Tier C, Freeze §15.2)
```sql
CREATE TABLE inventory_locations (
  location_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  name VARCHAR(255) NOT NULL,
  location_type VARCHAR(30) NOT NULL, -- warehouse, store, supplier, in_transit
  address JSONB DEFAULT '{}',
  is_default BOOLEAN DEFAULT false,
  status VARCHAR(20) NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 19.9H stock_movements (M13 — Tier C, Freeze §15.2)
```sql
CREATE TABLE stock_movements (
  movement_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  sku_id UUID NOT NULL REFERENCES skus(sku_id),
  location_id UUID REFERENCES inventory_locations(location_id),
  movement_type VARCHAR(30) NOT NULL, -- purchase, sale, return, adjustment, transfer, damage, platform_sync
  quantity INTEGER NOT NULL, -- positive = in, negative = out
  reference_type VARCHAR(50), -- order, return, manual, platform_import
  reference_id UUID,
  source_class source_class NOT NULL DEFAULT 'imported',
  notes TEXT,
  moved_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_sm_sku ON stock_movements(sku_id);
CREATE INDEX idx_sm_moved ON stock_movements(moved_at DESC);
```

### 19.10 sample_requests & sample_shipments (M18)
```sql
CREATE TABLE sample_requests (
  request_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  campaign_id UUID REFERENCES campaigns(campaign_id),
  product_id UUID REFERENCES products(product_id),
  creator_entity_id UUID REFERENCES entities(entity_id),
  status VARCHAR(20) NOT NULL DEFAULT 'requested', -- requested, approved, declined, fulfilled, cancelled
  quantity INTEGER NOT NULL DEFAULT 1,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE sample_shipments (
  shipment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id UUID NOT NULL REFERENCES sample_requests(request_id),
  workspace_id UUID NOT NULL,
  tracking_number VARCHAR(100),
  carrier VARCHAR(50),
  shipped_at TIMESTAMPTZ,
  delivered_at TIMESTAMPTZ,
  status VARCHAR(20) NOT NULL DEFAULT 'preparing', -- preparing, shipped, delivered, lost, returned, closed
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 19.11 recipe_templates
```sql
CREATE TABLE recipe_templates (
  recipe_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(500) NOT NULL,
  description TEXT,
  category VARCHAR(50),
  author_workspace_id UUID, -- nullable for system recipes
  activepieces_template_id VARCHAR(255),
  parameters JSONB DEFAULT '[]', -- [{name, type, default, required}]
  required_capabilities JSONB DEFAULT '[]',
  install_count INTEGER DEFAULT 0,
  rating_avg REAL DEFAULT 0,
  review_count INTEGER DEFAULT 0,
  price DECIMAL(10,2) DEFAULT 0, -- 0 = free
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, review_required, published, deprecated, retired
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 19.12 copilot_sessions
```sql
CREATE TABLE copilot_sessions (
  session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  user_id UUID NOT NULL REFERENCES users(user_id),
  mode VARCHAR(20) NOT NULL, -- creative, analytics, action, video_production, help
  context_scope VARCHAR(50),
  messages JSONB DEFAULT '[]', -- [{role, content, timestamp}]
  total_credits_used INTEGER DEFAULT 0,
  ended_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_cs_workspace ON copilot_sessions(workspace_id);
CREATE INDEX idx_cs_user ON copilot_sessions(user_id);
```

### 19.13 commissions
```sql
CREATE TABLE commissions (
  commission_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  affiliate_link_id UUID REFERENCES affiliate_links(affiliate_link_id),
  order_id UUID REFERENCES orders(order_id),
  amount DECIMAL(15,2) NOT NULL,
  currency VARCHAR(5) DEFAULT 'VND',
  commission_rate DECIMAL(5,2),
  status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, confirmed, paid, cancelled
  payout_ref VARCHAR(255),
  calculated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_comm_workspace ON commissions(workspace_id);
```

### 19.14 chargebacks
```sql
CREATE TABLE chargebacks (
  chargeback_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  order_id UUID NOT NULL REFERENCES orders(order_id),
  external_chargeback_id VARCHAR(255),
  amount DECIMAL(15,2) NOT NULL,
  currency VARCHAR(5) DEFAULT 'VND',
  reason VARCHAR(100),
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'opened', -- opened, evidence_submitted, won, lost
  evidence_submitted_at TIMESTAMPTZ,
  resolved_at TIMESTAMPTZ,
  financial_impact_recorded BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_cb_order ON chargebacks(order_id);
```

### 19.15 content_attribution_records (Profit OS)
```sql
CREATE TABLE content_attribution_records (
  attribution_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  publish_item_id UUID REFERENCES publish_items(publish_item_id),
  order_id UUID REFERENCES orders(order_id),
  attribution_type VARCHAR(30) NOT NULL, -- direct_click, utm_match, affiliate, organic
  revenue_attributed DECIMAL(15,2),
  source_class source_class DEFAULT 'inferred',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_car_publish ON content_attribution_records(publish_item_id);
CREATE INDEX idx_car_workspace ON content_attribution_records(workspace_id);
```

---

## 20. Indexes Strategy Summary

| Pattern | Type | Tables |
|---|---|---|
| `workspace_id` | B-tree (every table) | ALL tenant tables |
| `status/state` | B-tree | Most tables |
| `created_at DESC` | B-tree | High-read tables |
| `embedding` | IVFFlat (pgvector) | trends, ideas |
| `external_id` | Unique | connected_accounts, orders |
| Full-text | GIN (tsvector) | products, scripts, ideas (via Meilisearch primary) |

Total tables: **~116 domain tables** + 2 hypertables + ~12 junction/utility tables = **~130 total table definitions** covering ALL canonical objects from Pack 02 §3.1-3.5 + S16 + S19 + S26 + operational + Profit OS + Live Commerce (cue_cards, highlights) + channel_posts + reconciliation + inventory (skus, locations, movements) + Agent Runs (M21) + Policy Notes + Fallback Paths (M22).

---

## 21. Platform Fee Schedules (Profit OS — PRD §33.5)

```sql
CREATE TABLE platform_fee_schedules (
  fee_schedule_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  platform VARCHAR(50) NOT NULL, -- shopee, lazada, tiktok_shop, amazon, shopify
  region VARCHAR(50) NOT NULL DEFAULT 'VN', -- VN, TH, ID, SG, PH, MY, US, etc.
  category VARCHAR(100), -- NULL = platform-wide default
  fee_type VARCHAR(50) NOT NULL, -- commission, transaction, payment_processing, shipping_subsidy, service
  fee_pct DECIMAL(5,4), -- e.g., 0.0500 = 5%
  fee_fixed DECIMAL(10,2), -- fixed fee amount (nullable)
  fee_currency VARCHAR(5) DEFAULT 'VND',
  effective_from DATE NOT NULL,
  effective_until DATE, -- NULL = current
  source_url TEXT, -- link to platform's official fee page
  last_verified_at TIMESTAMPTZ, -- when we last confirmed this fee is still accurate
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_pfs_platform ON platform_fee_schedules(platform, region);
CREATE INDEX idx_pfs_effective ON platform_fee_schedules(effective_from, effective_until);
```

> **Seeding strategy**: Initial fee data seeded from official platform documentation. Auto-verified via scheduled crawl every 7 days. `last_verified_at` goes stale → alert to admin dashboard. User profit calculations reference the most recent `effective_from ≤ NOW()` row per platform/region/category.

---

## 22. Extended Production & Domain Object Tables (Audit v5 — C1: Pack 02 §3.4)

> **Ref**: Pack 02 §3.4 domain objects, Pack 04 §9.6-9.16, PRD §37.3.
> These tables back the extended production features and gamification challenges that were defined in design contracts but had no schema coverage. All tables include `workspace_id UUID NOT NULL` with RLS.

### 22.1 video_edit_jobs (M07 — Production Modes)
```sql
CREATE TABLE video_edit_jobs (
  job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  mode VARCHAR(30) NOT NULL, -- quick_edit, clip_factory, multi_merge, remix, product_showcase, image_to_video, link_to_video, translation, video_agent
  source_asset_ids UUID[] DEFAULT '{}', -- input assets
  output_asset_ids UUID[] DEFAULT '{}', -- produced assets
  generation_job_id UUID REFERENCES generation_jobs(job_id), -- linked AI generation job
  character_id UUID REFERENCES characters(character_id),
  brand_pack_id UUID REFERENCES continuity_packs(pack_id),
  status VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued, processing, completed, partially_completed, failed, cancelled
  input_params JSONB NOT NULL DEFAULT '{}', -- mode-specific parameters
  output_metadata JSONB DEFAULT '{}', -- mode-specific outputs
  credits_estimated REAL,
  credits_used REAL,
  actual_cost_usd REAL,
  error_message TEXT,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_vej_workspace ON video_edit_jobs(workspace_id);
CREATE INDEX idx_vej_mode ON video_edit_jobs(mode);
CREATE INDEX idx_vej_status ON video_edit_jobs(status);
```

### 22.2 remix_blueprints (M07 — AI Remix Studio, Pack 04 §9.5)
```sql
CREATE TABLE remix_blueprints (
  blueprint_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  reference_asset_id UUID NOT NULL REFERENCES assets(asset_id), -- source video analyzed
  output_asset_id UUID REFERENCES assets(asset_id), -- generated remix
  video_edit_job_id UUID REFERENCES video_edit_jobs(job_id),
  creative_dna JSONB NOT NULL DEFAULT '{}', -- {scene_count, hook_type, content_structure, pacing_profile, visual_style, audio_profile, transition_map}
  remix_script TEXT, -- generated remix script
  fidelity_level VARCHAR(20) NOT NULL DEFAULT 'adapt', -- match_1to1, adapt, loose
  originality_score REAL, -- 0-100, must be > 70 (< 30% similarity)
  status VARCHAR(20) NOT NULL DEFAULT 'analyzing', -- analyzing, analyzed, generating, generated, failed
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_rb_workspace ON remix_blueprints(workspace_id);
CREATE INDEX idx_rb_ref ON remix_blueprints(reference_asset_id);
```

### 22.3 clip_collections (M07 — Clip Factory, Pack 04 §9.3)
```sql
CREATE TABLE clip_collections (
  collection_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  source_asset_id UUID NOT NULL REFERENCES assets(asset_id),
  video_edit_job_id UUID REFERENCES video_edit_jobs(job_id),
  total_clips INTEGER NOT NULL DEFAULT 0,
  clip_data JSONB NOT NULL DEFAULT '[]', -- [{clip_index, start_s, end_s, title, virality_score, selected}]
  status VARCHAR(20) NOT NULL DEFAULT 'analyzing', -- analyzing, proposed, processing, completed, failed
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_cc_workspace ON clip_collections(workspace_id);
CREATE INDEX idx_cc_source ON clip_collections(source_asset_id);
```

### 22.4 product_showcase_jobs (M07 — Pack 04 §9.6)
```sql
CREATE TABLE product_showcase_jobs (
  showcase_job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  video_edit_job_id UUID REFERENCES video_edit_jobs(job_id),
  product_id UUID REFERENCES products(product_id),
  style VARCHAR(30) NOT NULL, -- spin_360, tabletop, flip_reveal, virtual_tryon, lifestyle, unboxing, before_after, review_style
  customization JSONB DEFAULT '{}', -- {background, duration, music, voice, text, cta, aspect_ratio, pacing, color_grade}
  batch_id UUID, -- for batch processing
  output_asset_id UUID REFERENCES assets(asset_id),
  character_id UUID REFERENCES characters(character_id), -- for review_style
  status VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued, processing, completed, failed
  credits_used REAL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_psj_workspace ON product_showcase_jobs(workspace_id);
CREATE INDEX idx_psj_product ON product_showcase_jobs(product_id);
CREATE INDEX idx_psj_batch ON product_showcase_jobs(batch_id);
```

### 22.5 link_to_video_jobs (M07 — Pack 04 §9.9)
```sql
CREATE TABLE link_to_video_jobs (
  ltv_job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  video_edit_job_id UUID REFERENCES video_edit_jobs(job_id),
  source_url TEXT NOT NULL,
  platform_detected VARCHAR(30), -- shopee, lazada, tiktok_shop, amazon, shopify, generic
  scraped_data JSONB DEFAULT '{}', -- {name, price, images[], description, reviews[]}
  script_template VARCHAR(30) NOT NULL DEFAULT 'problem_solution', -- problem_solution, listicle, testimonial, flash_sale, comparison
  generated_script TEXT,
  output_asset_id UUID REFERENCES assets(asset_id),
  character_id UUID REFERENCES characters(character_id),
  status VARCHAR(20) NOT NULL DEFAULT 'scraping', -- scraping, scripting, generating, completed, failed
  credits_used REAL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ltv_workspace ON link_to_video_jobs(workspace_id);
```

### 22.6 translation_jobs (M07 — Pack 04 §9.10)
```sql
CREATE TABLE translation_jobs (
  translation_job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  video_edit_job_id UUID REFERENCES video_edit_jobs(job_id),
  source_asset_id UUID NOT NULL REFERENCES assets(asset_id),
  target_languages VARCHAR(10)[] NOT NULL, -- e.g., {'en', 'th', 'id', 'ja'}
  lip_sync_enabled BOOLEAN DEFAULT true,
  per_language_status JSONB DEFAULT '{}', -- {en: 'completed', th: 'processing', ...}
  output_asset_ids JSONB DEFAULT '{}', -- {en: asset_id, th: asset_id, ...}
  total_credits_used REAL DEFAULT 0,
  status VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued, processing, partially_completed, completed, failed
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_tj_workspace ON translation_jobs(workspace_id);
CREATE INDEX idx_tj_source ON translation_jobs(source_asset_id);
```

### 22.7 style_packs (M08 — Pack 04 §9.12)
```sql
CREATE TABLE style_packs (
  style_pack_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  name VARCHAR(255) NOT NULL,
  source_asset_id UUID NOT NULL REFERENCES assets(asset_id), -- video analyzed
  extracted_style JSONB NOT NULL DEFAULT '{}', -- {caption, color_grade, transitions, pacing, text_overlay, audio_mix}
  is_active BOOLEAN DEFAULT true,
  continuity_pack_id UUID REFERENCES continuity_packs(pack_id), -- linked Continuity OS pack
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_sp_workspace ON style_packs(workspace_id);
```

> **Note**: Style Packs are distinct from `continuity_packs` — they capture a learned editing style (output of Style Learning), not brand/character identity. A Style Pack MAY create a corresponding `continuity_packs` entry (type='style') for use in production pipelines.

### 22.8 performance_reports (M07 — Pack 04 §9.14)
```sql
CREATE TABLE performance_reports (
  report_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  period VARCHAR(10) NOT NULL, -- daily, weekly, monthly
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  publish_items_analyzed UUID[] DEFAULT '{}',
  metrics JSONB NOT NULL DEFAULT '{}', -- {views, engagement, best_content, worst_content, growth}
  suggestions JSONB DEFAULT '[]', -- [{type, title, description, priority}]
  generated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_pr_workspace ON performance_reports(workspace_id);
CREATE INDEX idx_pr_period ON performance_reports(period_start, period_end);
```

> **Credit cost**: 0 credits (included in plan, uses existing analytics data). Per Pack 04 §9.14 and Pack 08 §3.2.

### 22.9 ab_test_experiments (M07/M10 — Pack 04 §9.15)
```sql
CREATE TABLE ab_test_experiments (
  experiment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  source_asset_id UUID NOT NULL REFERENCES assets(asset_id),
  variants JSONB NOT NULL DEFAULT '[]', -- [{variant_type, asset_id, publish_item_id, variant_label}]
  metrics_snapshot JSONB DEFAULT '{}', -- per-variant metrics
  winner_asset_id UUID REFERENCES assets(asset_id),
  status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, running, completed, cancelled
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  auto_winner_criteria JSONB DEFAULT '{}', -- {metric, threshold, min_duration_hours}
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_abt_workspace ON ab_test_experiments(workspace_id);
CREATE INDEX idx_abt_status ON ab_test_experiments(status);
```

> **Experiment Object Mapping (Audit v6 — L4)**: This `ab_test_experiments` table serves as the canonical storage for BOTH:
> 1. **Packaging QA Experiments** (Freeze §13.4, M10 write owner) — comparing titles, thumbnails, hooks across publish items.
> 2. **Video A/B Testing** (Pack 04 §9.15, M07/M10) — testing video variations for performance.
>
> Use the `variants[].variant_type` field to distinguish experiment scope. Content-level experiments use `variant_type = 'thumbnail' | 'title' | 'hook'`; full video tests use `variant_type = 'full_video'`.

### 22.10 challenge_definitions (Gamification — PRD §37.3)
```sql
CREATE TABLE challenge_definitions (
  challenge_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  challenge_type VARCHAR(30) NOT NULL, -- publish_count, revenue_target, engagement_target, streak, custom
  target_value INTEGER NOT NULL,
  reward_credits INTEGER NOT NULL DEFAULT 0,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  is_active BOOLEAN DEFAULT true,
  sort_order SMALLINT DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 22.11 challenge_progress (Gamification — PRD §37.3)
```sql
CREATE TABLE challenge_progress (
  progress_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  challenge_id UUID NOT NULL REFERENCES challenge_definitions(challenge_id),
  current_value INTEGER NOT NULL DEFAULT 0,
  target_value INTEGER NOT NULL,
  completed BOOLEAN DEFAULT false,
  completed_at TIMESTAMPTZ,
  reward_credited BOOLEAN DEFAULT false,
  reward_transaction_id UUID, -- → ai_credit_transactions
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, challenge_id)
);
CREATE INDEX idx_chp_workspace ON challenge_progress(workspace_id);
```

> **Rules (Freeze §46A.8)**: Maximum 3 active challenges per week. Weekly challenges rotate Monday 00:00 UTC+7. Duplicate completion → no double credit (enforced by UNIQUE constraint + `reward_credited` flag).

### 22.12 voice_clone_records (M08 — Pack 04 §12B)
```sql
CREATE TABLE voice_clone_records (
  voice_clone_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  character_id UUID NOT NULL REFERENCES characters(character_id),
  provider VARCHAR(50) NOT NULL DEFAULT 'elevenlabs', -- elevenlabs, future providers
  provider_voice_id VARCHAR(255), -- external voice ID from provider
  voice_name VARCHAR(255),
  sample_audio_urls JSONB DEFAULT '[]', -- uploaded audio samples
  clone_status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, processing, ready, failed
  consent_record_id UUID REFERENCES consent_records(consent_id),
  quality_score REAL, -- provider quality assessment
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_vcr_character ON voice_clone_records(character_id);
CREATE INDEX idx_vcr_workspace ON voice_clone_records(workspace_id);
```

### 22.13 repurpose_jobs (M09 — PRD §36)
```sql
CREATE TABLE repurpose_jobs (
  repurpose_job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  source_asset_id UUID NOT NULL REFERENCES assets(asset_id),
  pipeline_config JSONB NOT NULL DEFAULT '{}', -- {auto_clips, text_posts, thumbnails, carousel, blog, audio, captions, auto_schedule}
  output_asset_ids UUID[] DEFAULT '{}',
  status VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued, processing, completed, partially_completed, failed
  credits_used REAL DEFAULT 0,
  created_by UUID REFERENCES users(user_id),
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_rj_workspace ON repurpose_jobs(workspace_id);
CREATE INDEX idx_rj_source ON repurpose_jobs(source_asset_id);
```

> **Rule (Freeze §46A.8)**: All repurpose outputs = drafts. User MUST approve before publish. Max video length per tier: Free 5min, Starter 30min, Pro 60min, Business 120min.

### 22.14 link_health_records (Pack 08 §5 — Affiliate Link Health)
```sql
CREATE TABLE link_health_records (
  health_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  affiliate_link_id UUID NOT NULL REFERENCES affiliate_links(affiliate_link_id),
  http_status INTEGER,
  product_status VARCHAR(30), -- available, out_of_stock, discontinued, price_changed, unknown
  commission_status VARCHAR(30), -- active, changed, suspended, unknown
  link_status VARCHAR(20) NOT NULL DEFAULT 'healthy', -- healthy, warning, broken, expired
  expiry_date TIMESTAMPTZ,
  suggested_action TEXT,
  checked_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  alert_sent BOOLEAN DEFAULT false,
  estimated_revenue_impact DECIMAL(15,2), -- daily revenue at risk
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_lhr_link ON link_health_records(affiliate_link_id);
CREATE INDEX idx_lhr_status ON link_health_records(link_status);
CREATE INDEX idx_lhr_checked ON link_health_records(checked_at DESC);
```

### 22.15 platform_health_scores (M22 — Connector Health)
```sql
CREATE TABLE platform_health_scores (
  score_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  platform VARCHAR(50) NOT NULL,
  connected_account_id UUID REFERENCES connected_accounts(connected_account_id),
  overall_score REAL NOT NULL, -- 0-100
  api_response_time_ms INTEGER,
  error_rate_pct REAL,
  capability_coverage_pct REAL,
  last_successful_sync TIMESTAMPTZ,
  degraded_features JSONB DEFAULT '[]',
  score_explanation TEXT,
  captured_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_phs_workspace ON platform_health_scores(workspace_id, platform);
CREATE INDEX idx_phs_captured ON platform_health_scores(captured_at DESC);
```

Updated total: **~116 tables** covering ALL canonical objects from Pack 02 §3.1-3.5 + §3.4 extended domains + S16 + S19 + S26 + operational + Profit OS + Live Commerce + Agent Runs + Policy/Fallback + Extended Production + Gamification Challenges + Voice Clones + Repurpose Jobs + Platform Health.

---

## 23. Tier C Deferred Object Notes (Audit v5 — M1)

> **Ref**: Pack 02 §3.3. The following Tier C objects from the "Canonical Supporting Entities" list are intentionally NOT stored as standalone PostgreSQL tables. Their data is either embedded in parent aggregates, tracked in specialized stores, or deferred.

| Tier C Object | Storage Strategy | Rationale |
|---|---|---|
| **Click Event** | `api_call_logs` / ClickHouse time-series | High-volume clickstream data is time-series; not relational |
| **Lead** | `entities` table (relationship_state='lead') | Leads are entities with a specific relationship state |
| **Conversion Event** | `content_attribution_records` (§19.15) | Content→revenue attribution already tracked |
| **Creator Payout** | `commissions` table (status='paid') + `settlements` | Payout is a settlement-linked commission state |
| **Affiliate Statement** | Reconciliation Records + Evidence Objects | Statements are imported evidence for reconciliation |
| **Invoice** | `billing_events` + Stripe Invoice API | Invoices are Stripe-managed; billing events track internally |
| **Margin Snapshot** | `profit_snapshots` table | Margin is a computed field within profit snapshots |
| **Experiment** | `ab_test_experiments` table (§22.9) | Now covered as standalone table |

> **Rule**: All deferred objects maintain traceability through their parent aggregate refs. No deferred object is "lost" — it maps to an existing canonical structure.

---

## 24. Tier C Object JSONB Storage Notes

> **Ref**: Freeze §10.3-10.4 — Tier C objects may be stored as JSONB within parent Tier A/B aggregates or as standalone tables, per engineering discretion.

| Tier C Object | Storage Location | Format |
|---|---|---|
| **Decision Card** | `opportunities.expected_impact` + `expected_effort` | JSONB: `{score, description, revenue_estimate}` / `{score, description, time_estimate}` |
| **Expected Impact Model** | `opportunities.expected_impact` | Same JSONB field as Decision Card |
| **Expected Effort Model** | `opportunities.expected_effort` | Same JSONB field as Decision Card |
| **Decision Outcome** | `opportunities.converted_to_type` + `converted_to_id` | VARCHAR + UUID ref |
| **Lookbook** | `continuity_packs` table (type = 'lookbook') | Uses existing `continuity_packs` table with `pack_type = 'lookbook'`, references stored as `JSONB` in `settings` column |
| **Scene Memory** | `continuity_packs` table (type = 'scene_memory') | Same pattern as Lookbook |
| **Prompt Lineage Record** | `asset_generation_jobs.prompt_package` | JSONB within generation job record |
| **Continuity Rule** | `continuity_packs.settings` → `rules[]` | JSONB array within pack settings |
| **Continuity Violation** | Standalone table `continuity_violations` (§7.5) | Dedicated table with violation_type, severity, drift_score, asset/pack refs |

> **Rule**: All Tier C objects stored as JSONB still maintain traceability via parent aggregate IDs. No Tier C object exists outside the canonical graph.

---

## 25. JSONB Shape Reference (Audit v5 — L2)

> **Purpose**: Documents the expected shape of all major JSONB columns across the schema. Implementers MUST use these structures when reading/writing JSONB data. Types shown in TypeScript notation for clarity.

### 25.1 Commerce JSONB Shapes

#### `orders.items`
```typescript
interface OrderItem {
  sku: string;
  product_id?: string;      // UUID ref if matched
  name: string;
  quantity: number;
  unit_price: number;        // in order currency
  discount: number;          // applied discount
  total: number;             // unit_price * quantity - discount
  variation?: string;        // e.g., "Red, XL"
  platform_item_id?: string; // external platform ref
}
// Column type: OrderItem[]
```

#### `orders.fee_breakdown`
```typescript
interface FeeBreakdown {
  platform_fee: number;
  payment_processing_fee: number;
  shipping_fee: number;
  tax: number;
  commission: number;
  promo_discount: number;
  other_fees: { name: string; amount: number }[];
  total_fees: number;
  currency: string;
}
```

### 25.2 Live Commerce JSONB Shapes

#### `live_sessions.run_of_show`
```typescript
interface RunOfShowItem {
  time_offset_min: number;   // minutes from session start
  type: 'product_pin' | 'poll' | 'giveaway' | 'cta' | 'break' | 'talking_point';
  title: string;
  product_id?: string;       // for product_pin
  notes?: string;
  duration_min?: number;
  executed: boolean;
  executed_at?: string;      // ISO timestamp
}
// Column type: RunOfShowItem[]
```

#### `live_sessions.metrics_snapshot`
```typescript
interface LiveMetricsSnapshot {
  peak_viewers: number;
  avg_viewers: number;
  total_viewers: number;
  total_comments: number;
  total_likes: number;
  total_shares: number;
  products_shown: number;
  orders_during_live: number;
  revenue_during_live: number;
  engagement_rate: number;
}
```

### 25.3 AI Production JSONB Shapes

#### `generation_jobs.input_params`
```typescript
interface GenerationInputParams {
  prompt: string;
  negative_prompt?: string;
  character_id?: string;
  voice_id?: string;
  style_preset?: string;
  aspect_ratio: '9:16' | '16:9' | '1:1' | '4:5';
  duration_seconds?: number;
  continuity_pack_id?: string;
  reference_asset_ids?: string[];
  music_config?: { genre: string; mood: string; volume: number };
  subtitle_config?: { enabled: boolean; style: string; language: string };
}
```

#### `generation_jobs.result_metadata`
```typescript
interface GenerationResultMetadata {
  width: number;
  height: number;
  duration_seconds: number;
  file_size_bytes: number;
  format: string;              // e.g., "mp4"
  codec: string;               // e.g., "h264"
  fps: number;
  audio_tracks: number;
  thumbnail_url?: string;
  provider_metadata?: Record<string, unknown>;
}
```

#### `remix_blueprints.creative_dna`
```typescript
interface CreativeDNA {
  scene_count: number;
  hook_type: string;           // e.g., "question", "shock", "story"
  content_structure: string;   // e.g., "hook-problem-solution-cta"
  pacing_profile: { avg_scene_duration_s: number; tempo: 'slow' | 'medium' | 'fast' };
  visual_style: { color_mood: string; transition_types: string[]; text_overlay_style: string };
  audio_profile: { music_genre: string; voice_pace: string; sfx_density: string };
  transition_map: { from_scene: number; to_scene: number; type: string }[];
}
```

#### `clip_collections.clip_data`
```typescript
interface ClipData {
  clip_index: number;
  start_s: number;
  end_s: number;
  title: string;
  virality_score: number;      // 0-100
  selected: boolean;
  highlights: string[];        // key moments
}
// Column type: ClipData[]
```

#### `product_showcase_jobs.customization`
```typescript
interface ShowcaseCustomization {
  background: string;          // color hex or preset name
  duration: number;            // seconds
  music: string;               // track id or 'none'
  voice: string;               // character voice id or 'none'
  text: { headline: string; subtitle?: string; cta: string };
  aspect_ratio: '9:16' | '16:9' | '1:1';
  pacing: 'slow' | 'medium' | 'fast';
  color_grade: string;         // preset name or custom
}
```

### 25.4 Workflow JSONB Shapes

#### `workflows.trigger_config`
```typescript
interface TriggerConfig {
  type: 'event' | 'schedule' | 'manual' | 'webhook';
  event_type?: string;         // for event triggers
  cron_expression?: string;    // for schedule triggers
  webhook_path?: string;       // for webhook triggers
  filters?: { field: string; operator: string; value: unknown }[];
}
```

#### `workflow_runs.execution_log`
```typescript
interface ExecutionLogEntry {
  node_id: string;
  node_type: string;
  started_at: string;
  completed_at: string;
  status: 'success' | 'failed' | 'skipped';
  input: Record<string, unknown>;
  output: Record<string, unknown>;
  error?: { code: string; message: string };
  duration_ms: number;
}
// Column type: ExecutionLogEntry[]
```

### 25.5 Gamification & Growth JSONB Shapes

#### `ab_test_experiments.variants`
```typescript
interface ABVariant {
  variant_type: 'thumbnail' | 'title' | 'hook' | 'full_video';
  asset_id: string;
  publish_item_id?: string;
  variant_label: string;       // e.g., "A", "B", "Control"
}
// Column type: ABVariant[]
```

#### `ab_test_experiments.auto_winner_criteria`
```typescript
interface AutoWinnerCriteria {
  metric: 'views' | 'engagement_rate' | 'click_through' | 'watch_time';
  threshold: number;           // e.g., 1.5 = 50% better than other
  min_duration_hours: number;  // minimum test duration before auto-declare
  min_impressions: number;     // minimum data before declaring
}
```

> **Implementation note**: All JSONB columns should be validated against these shapes at the application layer (Rust `serde` deserialize with `#[serde(deny_unknown_fields)]`). Database CHECK constraints are NOT used for JSONB validation — this is enforced at the API boundary.


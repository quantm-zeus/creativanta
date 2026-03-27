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
  pack_type VARCHAR(20) NOT NULL, -- character, brand, voice, style
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
  job_type VARCHAR(50) NOT NULL, -- video_gen, image_gen, tts, lip_sync, remix, clip_factory, quick_edit, multi_merge, product_showcase, img_to_video, link_to_video, translation, thumbnail
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
  items JSONB DEFAULT '[]', -- [{sku, qty, price}]
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
  run_of_show JSONB DEFAULT '[]',
  summary JSONB,
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
  trigger_definition JSONB NOT NULL,
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
  status VARCHAR(30) NOT NULL DEFAULT 'queued', -- queued,running,waiting_approval,waiting_external,succeeded,partially_succeeded,failed,cancelled,requires_manual_intervention
  current_node VARCHAR(100),
  result_summary JSONB,
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
  status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, approved, rejected, expired, cancelled
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
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, active, paused, expired, revoked
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
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, published, archived
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
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, active, archived
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
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'requested', -- requested, approved, processing, completed, rejected
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
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'requested', -- requested, approved, shipped, received, completed, rejected
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

### 19.10 sample_requests & sample_shipments (M18)
```sql
CREATE TABLE sample_requests (
  request_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL,
  campaign_id UUID REFERENCES campaigns(campaign_id),
  product_id UUID REFERENCES products(product_id),
  creator_entity_id UUID REFERENCES entities(entity_id),
  status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, approved, rejected, shipped, received, reviewed
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
  status VARCHAR(20) NOT NULL DEFAULT 'preparing', -- preparing, shipped, in_transit, delivered, returned
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
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, published, suspended, archived
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
  mode VARCHAR(20) NOT NULL, -- creative, analytics, action, help
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

Total tables: **~88 tables** covering ALL canonical objects from Pack 02 §3.1-3.5 + S16 + S19 + S26 + operational.

---
layer: contracts
canonical: true
source_file: impl_a1_database_schema.md
last_verified: 2026-10-29
resolved_issues:
  - DB-C-001  # RLS FORCE added to 106 tables (2026-04-02)
  - DB-C-002  # RLS ENABLE added to 106 tables (2026-04-02)
  - DB-H-001  # REAL→NUMERIC(18,6) for all financial fields (previous session)
  - DB-H-003  # deleted_at added to 51 entity tables (2026-04-02)
  - DB-H-004  # 23 CHECK constraints added for lifecycle fields (2026-04-02)
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
| §10 Commerce (M13-M16) | products, product_skus, offers, orders, campaigns, affiliate_links, affiliate_commissions; extended store/coupon tables in §19 |
| §11 Finance & Proof (M19) | profit_snapshots, settlements, cost_items, reconciliation_records, evidence_objects, proof_bundles |
| §12 Workflow & Operations (M17-M21) | live_sessions, cue_cards, sample_requests, sample_shipments, workflows, workflow_runs, agent_runs, recipes |
| §13 Billing, Admin, Diagnostics (M23) | ai_credit_transactions, subscription_events, notifications, feature_flags, audit_events, diagnostics_records |
| §14 Gamification (§37.3) | creator_progress, achievement_definitions, achievement_records, challenge_definitions (§22.10), challenge_progress (§22.11) |
| §15 TimescaleDB Hypertables | platform_health_metrics, api_call_logs |
| §16 Creator Pro Tools (S16) | link_in_bio_pages, link_in_bio_items, media_kits, rate_cards, brand_deals |
| §17 Internal Admin (S26) | internal_admins, admin_sessions, moderation_cases, fraud_cases, support_tickets, kb_categories, kb_articles, article_ratings, incidents, system_announcements |
| §18 Operational Tables | background_jobs, job_schedules, job_metrics, dead_letter_queue, event_outbox, file_uploads, api_keys, broadcasts, notification_events, consent_records, referral_records, export_jobs |
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
-- Every tenant-scoped table MUST include BOTH statements:
ALTER TABLE <table> ENABLE ROW LEVEL SECURITY;
ALTER TABLE <table> FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON <table>
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

> **⚠️ RLS ENFORCEMENT & BOOTSTRAP RULE**:
> 1. Every `CREATE TABLE` block for a tenant-scoped table (any table with `workspace_id`) MUST be followed by `ALTER TABLE <t> ENABLE ROW LEVEL SECURITY;` + `ALTER TABLE <t> FORCE ROW LEVEL SECURITY;`. Without `FORCE`, a non-superuser table owner bypasses RLS silently. See OPEN_BLOCKERS.md DB-C-001 / DB-C-002.
> 2. Always pass `missing_ok = true` wrapped in `NULLIF(..., '')::uuid` (`NULLIF(current_setting('app.current_tenant_id', true), '')::uuid`). Calling 1-argument `current_setting('app.current_tenant_id')` throws `ERROR: unrecognized configuration parameter` in PostgreSQL 17 whenever a transaction runs before `SET LOCAL app.current_tenant_id` is set.
> 3. **Bootstrap exception (`workspaces` and `workspace_members`)**: During login, session validation, workspace discovery, and initial workspace creation, `app.current_tenant_id` is not yet selected. Middleware sets `SET LOCAL app.current_user_id = '<user_uuid>'`, and the `tenant_isolation` policies on `workspaces` (`owner_user_id`) and `workspace_members` (`user_id`) allow authenticated user-scoped discovery/bootstrap alongside `app.current_tenant_id`.
> 4. **Role separation**: Database migrations and `seed_data.sql` execute under the migration/owner superuser role (`creativanta`), whereas the Rust API runtime connects as `app_user` (`NOBYPASSRLS`) to guarantee RLS enforcement on every application query.

All tables below include `workspace_id UUID NOT NULL` unless marked `[GLOBAL]`.

---

## 2. Naming Conventions

| Convention | Example |
|---|---|
| Tables | `snake_case`, plural | `signals`, `publish_items` |
| PKs | `<entity>_id UUID DEFAULT gen_random_uuid()` |
| UUID policy | External/application-generated IDs MUST use UUID v7. `gen_random_uuid()` remains the DB fallback for seeds, backfills, and internal records when the application does not pre-supply the ID. |
| FKs | `<referenced_entity>_id` |
| Timestamps | `created_at`, `updated_at`, `deleted_at` (soft delete) |
| Enums | PostgreSQL ENUM types, snake_case values |
| Indexes | `idx_<table>_<columns>` |
| Money/Credits | `NUMERIC(18,6)` — NEVER use REAL or FLOAT for financial amounts, credit balances, costs, or commissions. See DB-H-001. |
| Scores (0-100) | `REAL` acceptable for non-financial scores (relevance, quality, drift). Always comment `-- 0-100 non-financial score`. |

---

## 3. Shared Types (ENUMs)

```sql
CREATE TYPE source_class AS ENUM ('official','imported','inferred','estimated','unreconciled');
CREATE TYPE confidence_band AS ENUM ('high','medium_high','medium','low_medium','low');
CREATE TYPE verification_status AS ENUM ('verified','re_verify','pending','failed');
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

### 4.0 regions & currencies [GLOBAL]
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

### 4.1 workspaces
```sql
CREATE TABLE workspaces (
  workspace_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_type VARCHAR(50) NOT NULL DEFAULT 'standard',
  clerk_organization_id VARCHAR(255) UNIQUE,
  display_name VARCHAR(255) NOT NULL,
  slug VARCHAR(100) UNIQUE NOT NULL,
  referral_code VARCHAR(20) UNIQUE, -- one server-generated referral code per workspace
  default_operator_mode operator_mode NOT NULL DEFAULT 'creator',
  primary_region_id UUID REFERENCES regions(region_id),
  primary_currency_id UUID REFERENCES currencies(currency_id),
  status VARCHAR(20) NOT NULL DEFAULT 'active',
  subscription_tier VARCHAR(20) NOT NULL DEFAULT 'free', -- free, starter, pro, business, enterprise
  ai_credits_remaining NUMERIC(18,6) NOT NULL DEFAULT 50, -- total unspent credits, including held credits
  ai_credits_reserved NUMERIC(18,6) NOT NULL DEFAULT 0, -- available = remaining - reserved
  ai_credits_monthly_limit NUMERIC(18,6) NOT NULL DEFAULT 50,
  billing_cycle_start DATE,
  CHECK (ai_credits_remaining >= 0 AND ai_credits_reserved >= 0 AND ai_credits_reserved <= ai_credits_remaining),
  owner_user_id UUID NOT NULL,
  settings JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);
CREATE INDEX idx_workspaces_owner ON workspaces(owner_user_id);
CREATE INDEX idx_workspaces_slug ON workspaces(slug);
ALTER TABLE workspaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE workspaces FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON workspaces
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
    OR owner_user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid
  );
ALTER TABLE workspaces ADD CONSTRAINT chk_workspaces_status
  CHECK (status IN ('active', 'suspended', 'deleted'));
ALTER TABLE workspaces ADD CONSTRAINT chk_workspaces_tier
  CHECK (subscription_tier IN ('free', 'starter', 'pro', 'business', 'enterprise'));
```

### 4.2 users [GLOBAL]
```sql
CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  clerk_id VARCHAR(255) UNIQUE NOT NULL,
  source_updated_at TIMESTAMPTZ,
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
  clerk_membership_id VARCHAR(255) UNIQUE,
  source_updated_at TIMESTAMPTZ,
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
ALTER TABLE workspace_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE workspace_members FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON workspace_members
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
    OR user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid
  );
```

### 4.3B user-scoped workspace discovery
```sql
CREATE POLICY workspace_discovery ON workspaces FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM workspace_members wm
    WHERE wm.workspace_id = workspaces.workspace_id
      AND wm.user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid
      AND wm.status = 'active'
  ));
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE users FORCE ROW LEVEL SECURITY;
CREATE POLICY user_self ON users
  USING (user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid);
```
Workspace creation and first Owner membership insert occur in one transaction with authenticated user scope and the new tenant context. Existing member discovery is SELECT-only and does not authorize writes. Each API request revalidates active membership and its current role before setting tenant context.

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
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
ALTER TABLE brand_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE brand_profiles FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON brand_profiles
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_ca_workspace ON connected_accounts(workspace_id);
CREATE INDEX idx_ca_provider ON connected_accounts(provider);
CREATE UNIQUE INDEX idx_ca_workspace_provider_ext ON connected_accounts(workspace_id, provider, external_account_id);
ALTER TABLE connected_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE connected_accounts FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON connected_accounts
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 4.6 regions & currencies [GLOBAL]
> Moved to `§4.0` above `workspaces` so top-to-bottom DDL execution satisfies `workspaces.primary_region_id` and `workspaces.primary_currency_id` foreign keys without forward references.

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
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_signals_workspace ON signals(workspace_id);
CREATE INDEX idx_signals_type ON signals(signal_type);
CREATE INDEX idx_signals_state ON signals(lifecycle_state);
CREATE INDEX idx_signals_collected ON signals(collected_at DESC);
ALTER TABLE signals ENABLE ROW LEVEL SECURITY;
ALTER TABLE signals FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON signals
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE signals ADD CONSTRAINT chk_signals_lifecycle_state
  CHECK (lifecycle_state IN ('detected', 'processed', 'merged', 'expired', 'discarded'));
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
  strength_score REAL, -- 0-100 non-financial score
  freshness_score REAL, -- 0-100 non-financial score
  saturation_score REAL, -- 0-100 non-financial score
  velocity_score REAL, -- 0-100 non-financial score
  freshness_at TIMESTAMPTZ,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_trends_workspace ON trends(workspace_id);
CREATE INDEX idx_trends_strength ON trends(strength_score DESC);
-- pgvector for semantic search
ALTER TABLE trends ADD COLUMN embedding vector(768);
CREATE INDEX idx_trends_embedding ON trends USING ivfflat (embedding vector_cosine_ops);
ALTER TABLE trends ENABLE ROW LEVEL SECURITY;
ALTER TABLE trends FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON trends
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 5.3 trend_signals (junction)
> **RLS**: Direct tenant policy and same-workspace parent constraints apply; querying through JOIN is not a security boundary.
```sql
CREATE TABLE trend_signals (
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  trend_id UUID NOT NULL REFERENCES trends(trend_id),
  signal_id UUID NOT NULL REFERENCES signals(signal_id),
  PRIMARY KEY (trend_id, signal_id)
);
ALTER TABLE trend_signals ENABLE ROW LEVEL SECURITY;
ALTER TABLE trend_signals FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON trend_signals
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_opp_workspace ON opportunities(workspace_id);
CREATE INDEX idx_opp_state ON opportunities(priority_state);
CREATE INDEX idx_opp_owner ON opportunities(owner_user_id);
ALTER TABLE opportunities ENABLE ROW LEVEL SECURITY;
ALTER TABLE opportunities FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON opportunities
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE opportunities ADD CONSTRAINT chk_opportunities_priority_state
  CHECK (priority_state IN ('draft', 'open', 'prioritized', 'assigned', 'in_progress', 'converted', 'parked', 'closed_won', 'closed_lost'));
```

### 5.5 opportunity_sources (polymorphic junction)
> **RLS**: Direct tenant policy and same-workspace parent constraints apply; querying through JOIN is not a security boundary.
```sql
CREATE TABLE opportunity_sources (
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  opportunity_id UUID NOT NULL REFERENCES opportunities(opportunity_id),
  source_type VARCHAR(50) NOT NULL, -- trend, signal, competitor, product_opportunity
  source_id UUID NOT NULL,
  PRIMARY KEY (opportunity_id, source_type, source_id)
);
ALTER TABLE opportunity_sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE opportunity_sources FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON opportunity_sources
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
ALTER TABLE competitor_entities ENABLE ROW LEVEL SECURITY;
ALTER TABLE competitor_entities FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON competitor_entities
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
ALTER TABLE benchmark_snapshots ENABLE ROW LEVEL SECURITY;
ALTER TABLE benchmark_snapshots FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON benchmark_snapshots
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
ALTER TABLE watchlists ENABLE ROW LEVEL SECURITY;
ALTER TABLE watchlists FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON watchlists
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  idea_score REAL, -- 0-100 non-financial score
  converted_to_type VARCHAR(50), -- script, campaign
  converted_to_id UUID,
  created_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_ideas_workspace ON ideas(workspace_id);
CREATE INDEX idx_ideas_status ON ideas(status);
ALTER TABLE ideas ADD COLUMN embedding vector(768);
ALTER TABLE ideas ENABLE ROW LEVEL SECURITY;
ALTER TABLE ideas FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON ideas
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 6.2 idea_sources (polymorphic)
> **RLS**: Direct tenant policy and same-workspace parent constraints apply; querying through JOIN is not a security boundary.
```sql
CREATE TABLE idea_sources (
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  idea_id UUID NOT NULL REFERENCES ideas(idea_id),
  source_type VARCHAR(50) NOT NULL,
  source_id UUID NOT NULL,
  PRIMARY KEY (idea_id, source_type, source_id)
);
ALTER TABLE idea_sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE idea_sources FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON idea_sources
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 6.3 hooks
```sql
CREATE TABLE hooks (
  hook_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  idea_id UUID REFERENCES ideas(idea_id),
  hook_text TEXT NOT NULL,
  hook_type VARCHAR(50), -- question, shock, story, pov, listicle, contrast
  effectiveness_score REAL, -- 0-100 non-financial score
  usage_count INTEGER DEFAULT 0,
  source VARCHAR(50) DEFAULT 'manual', -- manual, ai_generated, library
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
ALTER TABLE hooks ENABLE ROW LEVEL SECURITY;
ALTER TABLE hooks FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON hooks
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_scripts_workspace ON scripts(workspace_id);
CREATE INDEX idx_scripts_lifecycle ON scripts(lifecycle_state);
CREATE INDEX idx_scripts_approval ON scripts(approval_state);
ALTER TABLE scripts ENABLE ROW LEVEL SECURITY;
ALTER TABLE scripts FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON scripts
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE scripts ADD CONSTRAINT chk_scripts_lifecycle_state
  CHECK (lifecycle_state IN ('draft', 'in_review', 'approved', 'revision_required', 'ready_for_production', 'archived'));
ALTER TABLE scripts ADD CONSTRAINT chk_scripts_approval_state
  CHECK (approval_state IN ('not_submitted', 'pending_approval', 'approved', 'rejected'));
```

### 6.5 asset_briefs
```sql
CREATE TABLE asset_briefs (
  asset_brief_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  script_id UUID NOT NULL REFERENCES scripts(script_id),
  output_type VARCHAR(50) NOT NULL, -- video, image, audio, mixed
  target_format VARCHAR(50), -- 9:16, 16:9, 1:1
  target_duration_seconds INTEGER, -- planned whole seconds; actual duration in assets uses NUMERIC(12,2)
  target_platforms JSONB DEFAULT '[]',
  continuity_requirements JSONB DEFAULT '{}',
  brand_voice_requirements JSONB DEFAULT '{}',
  production_instructions TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, ready, locked, superseded
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
ALTER TABLE asset_briefs ENABLE ROW LEVEL SECURITY;
ALTER TABLE asset_briefs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON asset_briefs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 6.6 scenes & shot_lists
```sql
CREATE TABLE scenes (
  scene_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  script_id UUID NOT NULL REFERENCES scripts(script_id),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  scene_index SMALLINT NOT NULL,
  description TEXT,
  duration_seconds INTEGER, -- planned whole seconds; actual duration in assets uses NUMERIC(12,2)
  visual_notes TEXT,
  audio_notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE scenes ENABLE ROW LEVEL SECURITY;
ALTER TABLE scenes FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON scenes
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE shot_lists (
  shot_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  scene_id UUID NOT NULL REFERENCES scenes(scene_id),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  shot_index SMALLINT NOT NULL,
  shot_type VARCHAR(50),
  description TEXT,
  duration_seconds INTEGER, -- planned whole seconds; actual duration in assets uses NUMERIC(12,2)
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
ALTER TABLE shot_lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE shot_lists FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON shot_lists
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  status VARCHAR(20) NOT NULL DEFAULT 'creating' CHECK (status IN ('creating','ready','failed','archived')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_characters_workspace ON characters(workspace_id);
ALTER TABLE characters ENABLE ROW LEVEL SECURITY;
ALTER TABLE characters FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON characters
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  settings JSONB NOT NULL DEFAULT '{}', -- typed pack rules/lookbook/scene memory, §25.7
  allowed_use_scope JSONB DEFAULT '{}',
  version INTEGER NOT NULL DEFAULT 1,
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, active, deprecated, retired
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_cp_workspace ON continuity_packs(workspace_id);
CREATE INDEX idx_cp_type ON continuity_packs(pack_type);
ALTER TABLE continuity_packs ENABLE ROW LEVEL SECURITY;
ALTER TABLE continuity_packs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON continuity_packs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  duration_seconds NUMERIC(12,2), -- duration, not financial but needs precision for video timecodes
  resolution VARCHAR(20),
  aspect_ratio VARCHAR(10),
  mime_type VARCHAR(100),
  generation_state VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued,generating,generated,failed,cancelled
  quality_state VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft,review_required,approved,rejected,promoted_canonical
  lineage_refs JSONB DEFAULT '[]', -- [{type, id, prompt}]
  continuity_pack_ids UUID[] DEFAULT '{}',
  generation_cost_credits NUMERIC(18,6), -- DB-H-001: financial precision
  generation_cost_usd NUMERIC(18,6), -- DB-H-001: financial precision
  generation_prompt TEXT,
  generation_params JSONB DEFAULT '{}',
  error_message TEXT,
  parent_asset_id UUID REFERENCES assets(asset_id), -- for derivatives
  derivative_type VARCHAR(30), -- clip, variant, remix, repurpose, thumbnail
  metadata JSONB DEFAULT '{}',
  created_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_assets_workspace ON assets(workspace_id);
CREATE INDEX idx_assets_type ON assets(asset_type);
CREATE INDEX idx_assets_gen_state ON assets(generation_state);
CREATE INDEX idx_assets_quality ON assets(quality_state);
CREATE INDEX idx_assets_parent ON assets(parent_asset_id);
CREATE INDEX idx_assets_script ON assets(script_id);
ALTER TABLE assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE assets FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON assets
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE assets ADD CONSTRAINT chk_assets_generation_state
  CHECK (generation_state IN ('queued', 'generating', 'generated', 'failed', 'cancelled'));
ALTER TABLE assets ADD CONSTRAINT chk_assets_quality_state
  CHECK (quality_state IN ('draft', 'review_required', 'approved', 'rejected', 'promoted_canonical'));
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
  prompt_package JSONB NOT NULL DEFAULT '{}', -- versioned prompt/continuity lineage, §25.7
  status VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued,processing,completed,failed,cancelled
  progress_pct SMALLINT DEFAULT 0,
  current_step VARCHAR(100),
  estimated_credits NUMERIC(18,6), -- DB-H-001: financial precision
  actual_credits NUMERIC(18,6), -- DB-H-001: financial precision
  actual_cost_usd NUMERIC(18,6), -- DB-H-001: financial precision
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
ALTER TABLE generation_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE generation_jobs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON generation_jobs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE generation_jobs ADD CONSTRAINT chk_generation_jobs_status
  CHECK (status IN ('queued', 'processing', 'completed', 'failed', 'cancelled'));
```

> **State Sync Rule (Audit v4 — M1)**: `generation_jobs.status` tracks **per-attempt** execution state. `assets.generation_state` tracks the **aggregate-level** final result. When `generation_jobs.status` changes, `assets.generation_state` MUST be updated atomically to reflect the latest job outcome. The two fields are NOT independent — `assets.generation_state` is derived from the most recent `generation_jobs.status`.

### 7.5 continuity_violations
```sql
CREATE TABLE continuity_violations (
  violation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  asset_id UUID NOT NULL REFERENCES assets(asset_id),
  pack_id UUID REFERENCES continuity_packs(pack_id),
  violation_type VARCHAR(50) NOT NULL, -- visual_drift, voice_drift, brand_drift, style_drift
  severity VARCHAR(20) NOT NULL, -- low, medium, high, critical
  description TEXT,
  drift_score REAL, -- 0-100 non-financial score
  resolved BOOLEAN DEFAULT false,
  resolved_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
ALTER TABLE continuity_violations ENABLE ROW LEVEL SECURITY;
ALTER TABLE continuity_violations FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON continuity_violations
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  packaging_score REAL, -- 0-100 non-financial score
  compliance_scan_result VARCHAR(20), -- pass,pass_with_warnings,review_required,blocked
  compliance_details JSONB,
  metadata JSONB DEFAULT '{}',
  created_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_pi_workspace ON publish_items(workspace_id);
CREATE INDEX idx_pi_state ON publish_items(lifecycle_state);
CREATE INDEX idx_pi_schedule ON publish_items(schedule_at);
CREATE INDEX idx_pi_platform ON publish_items(target_platform);
ALTER TABLE publish_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE publish_items FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON publish_items
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE publish_items ADD CONSTRAINT chk_publish_items_lifecycle_state
  CHECK (lifecycle_state IN ('draft', 'queued', 'scheduled', 'ready_to_execute', 'executing', 'published', 'partially_published', 'failed', 'cancelled', 'requires_manual_fallback'));
```

### 8.2 publish_jobs
```sql
CREATE TABLE publish_jobs (
  publish_job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  publish_item_id UUID NOT NULL REFERENCES publish_items(publish_item_id),
  dispatch_strategy VARCHAR(30),
  lifecycle_state VARCHAR(30) NOT NULL DEFAULT 'created', -- created,queued,dispatched,executing,partially_succeeded,succeeded,failed,cancelled,requires_manual_fallback
  attempt_count INTEGER DEFAULT 0, -- standardized INTEGER across all retry tables
  max_attempts INTEGER DEFAULT 3,
  current_worker_id VARCHAR(100),
  last_execution_summary JSONB,
  approval_request_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_pj_item ON publish_jobs(publish_item_id);
CREATE INDEX idx_pj_state ON publish_jobs(lifecycle_state);
ALTER TABLE publish_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE publish_jobs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON publish_jobs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE publish_jobs ADD CONSTRAINT chk_publish_jobs_lifecycle_state
  CHECK (lifecycle_state IN ('created', 'queued', 'dispatched', 'executing', 'partially_succeeded', 'succeeded', 'failed', 'cancelled', 'requires_manual_fallback'));
```

### 8.3 publish_logs (immutable)
```sql
CREATE TABLE publish_logs (
  publish_log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
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
ALTER TABLE publish_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE publish_logs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON publish_logs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_entities_workspace ON entities(workspace_id);
ALTER TABLE entities ENABLE ROW LEVEL SECURITY;
ALTER TABLE entities FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON entities
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  intent VARCHAR(50), -- purchase_interest, question, support_issue, objection, sponsor_interest, sample_request, moderation_risk, unknown
  priority VARCHAR(10) NOT NULL DEFAULT 'normal', -- urgent,high,normal,low
  status VARCHAR(30) NOT NULL DEFAULT 'new', -- new,triaged,active,waiting_on_user,waiting_on_team,snoozed,stale,converted_to_task,resolved,archived
  next_action TEXT,
  sla_due_at TIMESTAMPTZ,
  related_object_refs JSONB DEFAULT '[]', -- [{type, id}]
  last_activity_at TIMESTAMPTZ DEFAULT NOW(),
  message_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_threads_workspace ON threads(workspace_id);
CREATE INDEX idx_threads_status ON threads(status);
CREATE INDEX idx_threads_priority ON threads(priority);
CREATE INDEX idx_threads_owner ON threads(owner_user_id);
CREATE INDEX idx_threads_sla ON threads(sla_due_at);
ALTER TABLE threads ENABLE ROW LEVEL SECURITY;
ALTER TABLE threads FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON threads
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE threads ADD CONSTRAINT chk_threads_status
  CHECK (status IN ('new', 'triaged', 'active', 'waiting_on_user', 'waiting_on_team', 'snoozed', 'stale', 'converted_to_task', 'resolved', 'archived'));
```

### 9.3 messages
```sql
CREATE TABLE messages (
  message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
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
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON messages
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 9.4 follow_up_tasks
```sql
CREATE TABLE follow_up_tasks (
  task_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
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
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_ft_workspace ON follow_up_tasks(workspace_id);
CREATE INDEX idx_ft_assigned ON follow_up_tasks(assigned_user_id);
CREATE INDEX idx_ft_status ON follow_up_tasks(status);
ALTER TABLE follow_up_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE follow_up_tasks FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON follow_up_tasks
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  base_price NUMERIC(18,6),
  currency VARCHAR(5) DEFAULT 'VND',
  cogs NUMERIC(18,6), -- cost of goods sold
  catalog_status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, active, archived, discontinued
  inventory_enabled BOOLEAN DEFAULT false,
  external_refs JSONB DEFAULT '[]', -- [{platform, external_id, url}]
  images JSONB DEFAULT '[]',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_products_workspace ON products(workspace_id);
CREATE INDEX idx_products_status ON products(catalog_status);
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE products FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON products
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 10.1B product_skus (Audit v6 — schema gap)
```sql
CREATE TABLE product_skus (
  sku_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  product_id UUID NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
  sku_code VARCHAR(100) NOT NULL,
  variant_attributes JSONB NOT NULL DEFAULT '{}', -- {"size": "M", "color": "red"}
  price_override NUMERIC(18,6), -- NULL = use product.base_price
  cogs_override NUMERIC(18,6), -- NULL = use product.cogs
  currency VARCHAR(5) DEFAULT 'VND',
  stock_quantity INTEGER DEFAULT 0,
  stock_reserved INTEGER DEFAULT 0,
  low_stock_threshold INTEGER DEFAULT 5,
  barcode VARCHAR(100),
  weight_grams INTEGER,
  is_active BOOLEAN DEFAULT true,
  external_refs JSONB DEFAULT '[]', -- [{platform, external_sku_id}]
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);
CREATE UNIQUE INDEX idx_product_skus_code ON product_skus(workspace_id, product_id, sku_code);
CREATE INDEX idx_product_skus_product ON product_skus(product_id);
ALTER TABLE product_skus ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_skus FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON product_skus
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  pricing_value NUMERIC(18,6),
  pricing_currency VARCHAR(5) DEFAULT 'VND',
  pricing_logic JSONB DEFAULT '{}',
  cta_text VARCHAR(100),
  cta_url TEXT,
  channel_availability JSONB DEFAULT '[]', -- [{platform, enabled}]
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft,review_required,active,paused,expired,retired
  campaign_ids UUID[] DEFAULT '{}',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_offers_workspace ON offers(workspace_id);
CREATE INDEX idx_offers_state ON offers(lifecycle_state);
CREATE INDEX idx_offers_product ON offers(product_id);
ALTER TABLE offers ENABLE ROW LEVEL SECURITY;
ALTER TABLE offers FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON offers
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE offers ADD CONSTRAINT chk_offers_lifecycle_state
  CHECK (lifecycle_state IN ('draft', 'review_required', 'active', 'paused', 'expired', 'retired'));
```

### 10.3 orders
```sql
CREATE TABLE orders (
  order_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  source_class source_class NOT NULL DEFAULT 'imported',
  source_platform VARCHAR(50),
  external_order_id VARCHAR(255),
  connected_account_id UUID REFERENCES connected_accounts(connected_account_id),
  tax_amount NUMERIC(18,6) NOT NULL DEFAULT 0,
  tax_jurisdiction VARCHAR(10),
  tax_note VARCHAR(100),
  exchange_rate_snapshot JSONB NOT NULL DEFAULT '{}', -- exact shape in §25.1
  recognized_at TIMESTAMPTZ, -- revenue recognition, not import time
  source_updated_at TIMESTAMPTZ,
  import_fingerprint VARCHAR(128),
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'created', -- created,confirmed,fulfilled,completed,refunded,partially_refunded,returned,cancelled
  amount NUMERIC(18,6) NOT NULL,
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
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_orders_workspace ON orders(workspace_id);
CREATE INDEX idx_orders_state ON orders(lifecycle_state);
CREATE INDEX idx_orders_platform ON orders(source_platform);
CREATE UNIQUE INDEX idx_orders_external_identity ON orders(workspace_id, connected_account_id, source_platform, external_order_id)
  WHERE external_order_id IS NOT NULL AND connected_account_id IS NOT NULL;
CREATE UNIQUE INDEX idx_orders_import_fingerprint ON orders(workspace_id, import_fingerprint)
  WHERE import_fingerprint IS NOT NULL;
CREATE INDEX idx_orders_ordered ON orders(ordered_at DESC);
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON orders
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE orders ADD CONSTRAINT chk_orders_lifecycle_state
  CHECK (lifecycle_state IN ('created', 'confirmed', 'fulfilled', 'completed', 'refunded', 'partially_refunded', 'returned', 'cancelled'));
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
  commission_rate NUMERIC(5,2),
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'active', -- draft,active,paused,revoked,expired
  last_health_check_at TIMESTAMPTZ,
  health_status VARCHAR(20) DEFAULT 'healthy', -- healthy, broken, expired, product_unavailable
  click_count INTEGER DEFAULT 0,
  conversion_count INTEGER DEFAULT 0,
  revenue_attributed NUMERIC(18,6) DEFAULT 0,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_al_workspace ON affiliate_links(workspace_id);
CREATE INDEX idx_al_state ON affiliate_links(lifecycle_state);
ALTER TABLE affiliate_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliate_links FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON affiliate_links
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 10.4B affiliate_commissions
```sql
CREATE TABLE affiliate_commissions (
  commission_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  affiliate_link_id UUID NOT NULL REFERENCES affiliate_links(affiliate_link_id),
  order_id UUID NOT NULL REFERENCES orders(order_id),
  commission_amount NUMERIC(18,6) NOT NULL,
  currency VARCHAR(5) NOT NULL DEFAULT 'VND',
  status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, confirmed, clawed_back, paid_out
  hold_until TIMESTAMPTZ NOT NULL, -- 15 days after order delivery (per BIZ-012)
  clawback_reason VARCHAR(50), -- refund, partial_refund, fraud
  clawback_amount NUMERIC(18,6),
  payout_id UUID, -- references payout batch when paid
  confirmed_at TIMESTAMPTZ,
  clawed_back_at TIMESTAMPTZ,
  paid_out_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_acom_workspace ON affiliate_commissions(workspace_id);
CREATE INDEX idx_acom_link ON affiliate_commissions(affiliate_link_id);
CREATE INDEX idx_acom_status ON affiliate_commissions(status);
CREATE INDEX idx_acom_hold ON affiliate_commissions(hold_until) WHERE status = 'pending';
ALTER TABLE affiliate_commissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliate_commissions FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON affiliate_commissions
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  budget NUMERIC(18,6),
  budget_currency VARCHAR(5) DEFAULT 'VND',
  related_product_ids UUID[] DEFAULT '{}',
  related_offer_ids UUID[] DEFAULT '{}',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
ALTER TABLE campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE campaigns FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON campaigns
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE campaigns ADD CONSTRAINT chk_campaigns_status
  CHECK (status IN ('planned', 'ready', 'live', 'paused', 'completed', 'cancelled'));
```

---

## 11. Context: Finance & Proof (M19)

### 11.1 settlements
```sql
CREATE TABLE settlements (
  settlement_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  source_class source_class NOT NULL DEFAULT 'imported',
  source_platform VARCHAR(50),
  external_settlement_id VARCHAR(255),
  connected_account_id UUID REFERENCES connected_accounts(connected_account_id),
  exchange_rate_snapshot JSONB NOT NULL DEFAULT '{}',
  import_fingerprint VARCHAR(128),
  gross_amount NUMERIC(18,6) NOT NULL,
  net_amount NUMERIC(18,6) NOT NULL,
  fees JSONB DEFAULT '{}', -- {platform_fee, transaction_fee, service_fee}
  deductions JSONB DEFAULT '{}',
  currency VARCHAR(5) NOT NULL DEFAULT 'VND',
  settlement_state VARCHAR(30) NOT NULL DEFAULT 'imported', -- ingestion lifecycle only: imported, normalized, ready_for_matching, archived
  reconciliation_state reconciliation_state NOT NULL DEFAULT 'imported_only', -- canonical financial truth state
  related_order_ids UUID[] DEFAULT '{}',
  effective_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE UNIQUE INDEX idx_settlement_external ON settlements(workspace_id, connected_account_id, external_settlement_id)
  WHERE external_settlement_id IS NOT NULL AND connected_account_id IS NOT NULL;
CREATE UNIQUE INDEX idx_settlement_import ON settlements(workspace_id, import_fingerprint)
  WHERE import_fingerprint IS NOT NULL;
ALTER TABLE settlements ENABLE ROW LEVEL SECURITY;
ALTER TABLE settlements FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON settlements
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE settlements ADD CONSTRAINT chk_settlements_state
  CHECK (settlement_state IN ('imported', 'normalized', 'ready_for_matching', 'archived'));
```

### 11.2 cost_items
```sql
CREATE TABLE cost_items (
  cost_item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  cost_type VARCHAR(50) NOT NULL, -- platform_fee, shipping, ads_spend, ai_credits, commission, service_tool, cogs, seeding, other
  amount NUMERIC(18,6) NOT NULL,
  currency VARCHAR(5) NOT NULL DEFAULT 'VND',
  description TEXT,
  related_scope_type VARCHAR(50), -- workspace, product, campaign, order, asset
  related_scope_id UUID,
  source_class source_class NOT NULL DEFAULT 'estimated',
  evidence_id UUID,
  confidence_reason TEXT,
  cost_state VARCHAR(20) NOT NULL DEFAULT 'recorded', -- recorded,pending_evidence,reconciled,estimated,superseded
  effective_date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_ci_workspace ON cost_items(workspace_id);
CREATE INDEX idx_ci_type ON cost_items(cost_type);
CREATE INDEX idx_ci_date ON cost_items(effective_date);
ALTER TABLE cost_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE cost_items FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON cost_items
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 11.3 profit_snapshots (materialized/cached)
```sql
CREATE TABLE profit_snapshots (
  snapshot_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  scope_type VARCHAR(30) NOT NULL, -- workspace, product, platform, campaign, content, period
  scope_id UUID,
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  gross_revenue NUMERIC(18,6) DEFAULT 0,
  platform_fees NUMERIC(18,6) DEFAULT 0,
  shipping_costs NUMERIC(18,6) DEFAULT 0,
  affiliate_commissions NUMERIC(18,6) DEFAULT 0,
  refund_deductions NUMERIC(18,6) DEFAULT 0,
  cogs NUMERIC(18,6) DEFAULT 0,
  ads_spend NUMERIC(18,6) DEFAULT 0,
  ai_credit_costs NUMERIC(18,6) DEFAULT 0,
  seeding_costs NUMERIC(18,6) DEFAULT 0,
  other_costs NUMERIC(18,6) DEFAULT 0,
  net_profit NUMERIC(18,6) DEFAULT 0,
  margin_pct NUMERIC(5,2),
  source_class_mix JSONB DEFAULT '{}',
  confidence confidence_band DEFAULT 'medium',
  freshness_at TIMESTAMPTZ DEFAULT NOW(),
  currency VARCHAR(5) NOT NULL DEFAULT 'VND',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ps_workspace ON profit_snapshots(workspace_id);
CREATE INDEX idx_ps_scope ON profit_snapshots(scope_type, scope_id);
CREATE INDEX idx_ps_period ON profit_snapshots(period_start, period_end);
ALTER TABLE profit_snapshots ENABLE ROW LEVEL SECURITY;
ALTER TABLE profit_snapshots FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON profit_snapshots
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 11.4 evidence_objects
```sql
CREATE TABLE evidence_objects (
  evidence_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  evidence_type VARCHAR(50) NOT NULL, -- screenshot, api_response, receipt, report, platform_data
  source_provenance VARCHAR(100),
  content_hash VARCHAR(128) NOT NULL, -- SHA-512 immutable content; verification metadata may change
  file_url TEXT,
  payload JSONB,
  collected_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  verification_status verification_status NOT NULL DEFAULT 'pending',
  related_object_refs JSONB DEFAULT '[]', -- [{type, id}]
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
ALTER TABLE evidence_objects ENABLE ROW LEVEL SECURITY;
ALTER TABLE evidence_objects FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON evidence_objects
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 11.5 proof_bundles
```sql
CREATE TABLE proof_bundles (
  proof_bundle_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  claim_scope VARCHAR(100) NOT NULL,
  claim_summary TEXT NOT NULL,
  supporting_evidence_ids UUID[] NOT NULL DEFAULT '{}',
  source_class_context JSONB DEFAULT '{}',
  confidence confidence_band DEFAULT 'medium',
  coverage_summary TEXT,
  unresolved_gaps TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
ALTER TABLE proof_bundles ENABLE ROW LEVEL SECURITY;
ALTER TABLE proof_bundles FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON proof_bundles
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

---

## 12. Context: Workflow & Operations (M17, M18, M20, M21)

### 12.1 live_sessions
```sql
CREATE TABLE live_sessions (
  session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
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
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
ALTER TABLE live_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE live_sessions FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON live_sessions
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE live_sessions ADD CONSTRAINT chk_live_sessions_status
  CHECK (status IN ('planned', 'ready', 'live', 'paused', 'ended', 'post_live_processing', 'closed'));
```

### 12.2 workflows
```sql
CREATE TABLE workflows (
  workflow_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  title VARCHAR(500) NOT NULL,
  workflow_type VARCHAR(30) NOT NULL DEFAULT 'custom', -- custom, recipe_installed, agent
  trigger_config JSONB NOT NULL, -- see §25.4 TriggerConfig
  action_chain JSONB NOT NULL, -- canonical WorkflowGraph (§25.7), adapter-independent
  approval_requirements JSONB DEFAULT '[]',
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, active, paused, error, archived
  version INTEGER NOT NULL DEFAULT 1,
  activepieces_flow_id VARCHAR(255),
  tier_limit_check BOOLEAN DEFAULT true,
  run_count INTEGER DEFAULT 0,
  created_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
ALTER TABLE workflows ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflows FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON workflows
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE workflows ADD CONSTRAINT chk_workflows_status
  CHECK (status IN ('draft', 'active', 'paused', 'error', 'archived'));
```

### 12.3 workflow_runs
```sql
CREATE TABLE workflow_runs (
  run_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
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
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_wr_workflow ON workflow_runs(workflow_id);
CREATE INDEX idx_wr_status ON workflow_runs(status);
ALTER TABLE workflow_runs ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflow_runs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON workflow_runs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE workflow_runs ADD CONSTRAINT chk_workflow_runs_status
  CHECK (status IN ('queued', 'running', 'waiting_approval', 'waiting_external_condition', 'succeeded', 'partially_succeeded', 'failed', 'cancelled', 'requires_manual_intervention'));
```

### 12.3B recipe_templates
```sql
CREATE TABLE recipe_templates (
  recipe_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(500) NOT NULL,
  description TEXT,
  category VARCHAR(50),
  workspace_id UUID REFERENCES workspaces(workspace_id), -- nullable for system recipes
  author_workspace_id UUID, -- original author; workspace_id used for RLS
  activepieces_template_id VARCHAR(255),
  parameters JSONB DEFAULT '[]', -- [{name, type, default, required}]
  required_capabilities JSONB DEFAULT '[]',
  install_count INTEGER DEFAULT 0,
  rating_avg REAL DEFAULT 0, -- 0-5 non-financial rating
  review_count INTEGER DEFAULT 0,
  price NUMERIC(18,6) DEFAULT 0, -- 0 = free
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, review_required, published, deprecated, retired
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
ALTER TABLE recipe_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipe_templates FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON recipe_templates
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
CREATE POLICY system_recipe_read ON recipe_templates FOR SELECT
  USING (workspace_id IS NULL AND status = 'published');
```

### 12.4 agent_runs (Audit v4 — H1: Freeze §16.3 + §28.2)
```sql
CREATE TABLE agent_runs (
  agent_run_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
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
  credits_used NUMERIC(18,6) DEFAULT 0, -- DB-H-001: credit amount (not counter)
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_ar_workspace ON agent_runs(workspace_id);
CREATE INDEX idx_ar_state ON agent_runs(current_state);
CREATE INDEX idx_ar_recipe ON agent_runs(recipe_id);
ALTER TABLE agent_runs ENABLE ROW LEVEL SECURITY;
ALTER TABLE agent_runs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON agent_runs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE agent_runs ADD CONSTRAINT chk_agent_runs_current_state
  CHECK (current_state IN ('planning', 'awaiting_approval', 'executing', 'waiting_context', 'completed', 'partially_completed', 'failed', 'handed_off', 'cancelled'));
```

> **State Machine Ref**: Freeze Part 2, §28.2 — `planning → awaiting_approval → executing → waiting_context → completed/partially_completed/failed/handed_off/cancelled`. `handed_off` requires `handoff_target_user_id` to be set. `partially_completed` requires `side_effects_summary` to list unresolved actions.

### 12.3A workflow_run_steps
```sql
CREATE TABLE workflow_run_steps (
  step_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  run_id UUID NOT NULL REFERENCES workflow_runs(run_id),
  node_id VARCHAR(100) NOT NULL,
  node_type VARCHAR(30) NOT NULL, -- trigger, condition, transform, action, approval, wait, fallback, diagnostics, handoff, terminal
  step_order SMALLINT NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'queued', -- queued, running, waiting_approval, waiting_external_condition, succeeded, skipped, failed, cancelled
  input_snapshot JSONB DEFAULT '{}',
  output_snapshot JSONB DEFAULT '{}',
  diagnostics_ref UUID,
  side_effect_refs JSONB DEFAULT '[]',
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_wrs_run ON workflow_run_steps(run_id);
CREATE INDEX idx_wrs_workspace ON workflow_run_steps(workspace_id);
CREATE INDEX idx_wrs_status ON workflow_run_steps(status);
ALTER TABLE workflow_run_steps ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflow_run_steps FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON workflow_run_steps
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE workflow_run_steps ADD CONSTRAINT chk_workflow_run_steps_status
  CHECK (status IN ('queued', 'running', 'waiting_approval', 'waiting_external_condition', 'succeeded', 'skipped', 'failed', 'cancelled'));
```

### 12.4A agent_run_steps
```sql
CREATE TABLE agent_run_steps (
  agent_step_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  agent_run_id UUID NOT NULL REFERENCES agent_runs(agent_run_id),
  step_order SMALLINT NOT NULL,
  phase VARCHAR(30) NOT NULL, -- planning, awaiting_approval, executing, waiting_context, completed
  title VARCHAR(255) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'planning', -- planning, awaiting_approval, executing, waiting_context, completed, failed, skipped, cancelled
  expected_outcome TEXT,
  observed_outcome TEXT,
  input_context JSONB DEFAULT '{}',
  output_context JSONB DEFAULT '{}',
  diagnostics_ref UUID,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_ars_run ON agent_run_steps(agent_run_id);
CREATE INDEX idx_ars_workspace ON agent_run_steps(workspace_id);
CREATE INDEX idx_ars_status ON agent_run_steps(status);
ALTER TABLE agent_run_steps ENABLE ROW LEVEL SECURITY;
ALTER TABLE agent_run_steps FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON agent_run_steps
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE agent_run_steps ADD CONSTRAINT chk_agent_run_steps_status
  CHECK (status IN ('planning', 'awaiting_approval', 'executing', 'waiting_context', 'completed', 'failed', 'skipped', 'cancelled'));
```

### 12.4B agent_outputs
```sql
CREATE TABLE agent_outputs (
  output_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  agent_run_id UUID NOT NULL REFERENCES agent_runs(agent_run_id),
  output_type VARCHAR(50) NOT NULL, -- text, asset, dataset, workflow_patch, recommendation, report
  title VARCHAR(255) NOT NULL,
  summary TEXT,
  object_refs JSONB DEFAULT '[]', -- [{type, id}]
  downloadable_refs JSONB DEFAULT '[]', -- [{label, url}]
  preview_payload JSONB DEFAULT '{}',
  approval_state VARCHAR(20) NOT NULL DEFAULT 'not_required', -- not_required, pending_approval, approved, rejected
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_ao_run ON agent_outputs(agent_run_id);
CREATE INDEX idx_ao_workspace ON agent_outputs(workspace_id);
ALTER TABLE agent_outputs ENABLE ROW LEVEL SECURITY;
ALTER TABLE agent_outputs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON agent_outputs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE agent_outputs ADD CONSTRAINT chk_agent_outputs_approval_state
  CHECK (approval_state IN ('not_required', 'pending_approval', 'approved', 'rejected'));
```

---

## 13. Context: Billing, Admin, Diagnostics (M23)

### 13.1 billing_events
```sql
CREATE TABLE billing_events (
  billing_event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  event_type VARCHAR(50) NOT NULL, -- subscription_created, payment_succeeded, payment_failed, credits_deducted, credits_added, refund
  stripe_event_id VARCHAR(255),
  amount NUMERIC(18,6),
  currency VARCHAR(5),
  subscription_tier VARCHAR(20),
  credits_change NUMERIC(18,6), -- DB-H-001: credit transaction amount
  description TEXT,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_be_workspace ON billing_events(workspace_id);
CREATE INDEX idx_be_created ON billing_events(created_at DESC);
ALTER TABLE billing_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE billing_events FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON billing_events
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 13.2 ai_credit_transactions
```sql
CREATE TABLE ai_credit_transactions (
  transaction_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  transaction_type VARCHAR(40) NOT NULL, -- deduction, monthly_allocation, top_up, promotional, achievement_reward, referral_bonus, overage_charge, refund_system_failure, refund_no_output, refund_partial_output, refund_quality_dispute
  credits NUMERIC(18,6) NOT NULL, -- DB-H-001: positive = add, negative = deduct
  balance_after NUMERIC(18,6) NOT NULL, -- DB-H-001: running balance after transaction
  operation_type VARCHAR(50), -- text_gen, image_gen, video_gen, analysis, agent_exec
  generation_job_id UUID,
  estimated_cost NUMERIC(18,6), -- DB-H-001: estimated credits at reservation time (per BIZ-001)
  actual_cost NUMERIC(18,6), -- final customer credits, never above confirmed quote
  reservation_id UUID, -- same-workspace FK installed after reservation tables in §26
  lot_id UUID, -- same-workspace FK installed after lot tables in §26
  idempotency_key VARCHAR(255),
  reference_transaction_id UUID REFERENCES ai_credit_transactions(transaction_id),
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_act_workspace ON ai_credit_transactions(workspace_id);
CREATE INDEX idx_act_created ON ai_credit_transactions(created_at DESC);
CREATE UNIQUE INDEX idx_act_idempotency ON ai_credit_transactions(workspace_id, idempotency_key)
  WHERE idempotency_key IS NOT NULL;
ALTER TABLE ai_credit_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_credit_transactions FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON ai_credit_transactions
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
ALTER TABLE audit_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_events FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON audit_events
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
ALTER TABLE diagnostics_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE diagnostics_records FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON diagnostics_records
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 13.5 notifications
```sql
CREATE TABLE notifications (
  notification_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
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
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON notifications
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

---

## 14. Context: Gamification & Achievement (§37.3)

### 14.1 creator_progress
```sql
CREATE TABLE creator_progress (
  progress_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  user_id UUID NOT NULL REFERENCES users(user_id),
  level SMALLINT NOT NULL DEFAULT 1,
  xp INTEGER NOT NULL DEFAULT 0,
  xp_to_next_level INTEGER NOT NULL DEFAULT 100,
  streak_days INTEGER NOT NULL DEFAULT 0,
  streak_last_activity_date DATE,
  creator_score REAL DEFAULT 0, -- 0-100 non-financial score
  total_achievements INTEGER DEFAULT 0,
  season_id VARCHAR(50),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, user_id)
);
ALTER TABLE creator_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE creator_progress FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON creator_progress
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 14.2 achievements
```sql
CREATE TABLE achievement_definitions (
  achievement_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(100) UNIQUE NOT NULL, -- debut_creator, rising_star, etc.
  title VARCHAR(255) NOT NULL,
  description TEXT,
  trigger_condition JSONB NOT NULL,
  reward_credits INTEGER NOT NULL DEFAULT 0, -- whole credit units (counter, not transaction amount); DB-H-001 NUMERIC applies to credit *amounts* in ai_credit_transactions
  badge_image_url TEXT,
  category VARCHAR(50), -- milestone, streak, content, commerce
  sort_order SMALLINT DEFAULT 0,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


CREATE TABLE achievement_records (
  record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  user_id UUID NOT NULL REFERENCES users(user_id),
  achievement_id UUID NOT NULL REFERENCES achievement_definitions(achievement_id),
  earned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  credits_awarded NUMERIC(18,6) NOT NULL DEFAULT 0, -- DB-H-001: credit amount awarded
  UNIQUE(workspace_id, user_id, achievement_id)
);
ALTER TABLE achievement_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE achievement_records FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON achievement_records
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

> **Note**: Additional Gamification tables are defined in **§22.10 `challenge_definitions`** and **§22.11 `challenge_progress`** (Extended Production section). These tables complete the Gamification schema:
> - `challenge_definitions` — Quest/challenge configs with reward_type, xp_reward, criteria JSONB
> - `challenge_progress` — Per-workspace challenge tracking with progress_value and completion
>
> Total Gamification schema: **5 tables** (creator_progress, achievement_definitions, achievement_records, challenge_definitions, challenge_progress)

---

## 15. TimescaleDB Hypertables (Time-Series)

```sql
-- Platform health metrics
CREATE TABLE platform_health_metrics (
  time TIMESTAMPTZ NOT NULL,
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  platform VARCHAR(50) NOT NULL,
  metric_name VARCHAR(100) NOT NULL,
  metric_value REAL NOT NULL, -- non-financial health metric
  metadata JSONB DEFAULT '{}'
);
ALTER TABLE platform_health_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE platform_health_metrics FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON platform_health_metrics
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
SELECT create_hypertable('platform_health_metrics', 'time');

-- API call logs (for cost tracking)
CREATE TABLE api_call_logs (
  time TIMESTAMPTZ NOT NULL,
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  provider VARCHAR(50) NOT NULL,
  model VARCHAR(100),
  operation VARCHAR(50) NOT NULL,
  input_tokens INTEGER,
  output_tokens INTEGER,
  cost_usd NUMERIC(18,6),
  latency_ms INTEGER,
  status VARCHAR(20) NOT NULL
);
ALTER TABLE api_call_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_call_logs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON api_call_logs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE UNIQUE INDEX idx_lib_slug ON link_in_bio_pages(slug);
CREATE INDEX idx_lib_workspace ON link_in_bio_pages(workspace_id);
ALTER TABLE link_in_bio_pages ENABLE ROW LEVEL SECURITY;
ALTER TABLE link_in_bio_pages FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON link_in_bio_pages
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 16.2 link_items
```sql
CREATE TABLE link_items (
  link_item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  page_id UUID NOT NULL REFERENCES link_in_bio_pages(page_id),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
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
ALTER TABLE link_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE link_items FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON link_items
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  generation_credits_used NUMERIC(18,6) DEFAULT 0, -- DB-H-001: financial precision
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
ALTER TABLE media_kits ENABLE ROW LEVEL SECURITY;
ALTER TABLE media_kits FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON media_kits
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);

ALTER TABLE rate_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE rate_cards FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON rate_cards
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE rate_card_items (
  item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id), -- Audit v8: added for RLS (contains pricing data)
  rate_card_id UUID NOT NULL REFERENCES rate_cards(rate_card_id),
  service_type VARCHAR(50) NOT NULL,
  price_min NUMERIC(18,6),
  price_max NUMERIC(18,6),
  ai_suggested_price NUMERIC(18,6),
  description TEXT,
  delivery_time VARCHAR(50),
  position SMALLINT DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
ALTER TABLE rate_card_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE rate_card_items FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON rate_card_items
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 16.5 brand_deals
```sql
CREATE TABLE brand_deals (
  deal_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  brand_name VARCHAR(255) NOT NULL,
  contact_email VARCHAR(255),
  deal_type VARCHAR(30) NOT NULL, -- sponsored_post, product_review, ambassador, affiliate, custom
  value NUMERIC(18,6),
  currency VARCHAR(5) DEFAULT 'VND',
  status VARCHAR(20) NOT NULL DEFAULT 'negotiating', -- negotiating,agreed,in_progress,delivered,paid,completed,cancelled
  deadline DATE,
  deliverables TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_bd_workspace ON brand_deals(workspace_id);
CREATE INDEX idx_bd_status ON brand_deals(status);
ALTER TABLE brand_deals ENABLE ROW LEVEL SECURITY;
ALTER TABLE brand_deals FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON brand_deals
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  appeal_status VARCHAR(20) NOT NULL DEFAULT 'none' CHECK (appeal_status IN ('none','pending','reviewing','upheld','overturned')),
  resolution TEXT,
  resolution_action VARCHAR(30), -- no_action, warning_sent, content_removed, account_suspended, account_banned
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resolved_at TIMESTAMPTZ
);
ALTER TABLE moderation_cases ENABLE ROW LEVEL SECURITY;
ALTER TABLE moderation_cases FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON moderation_cases
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  financial_impact NUMERIC(18,6),
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
ALTER TABLE support_tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE support_tickets FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON support_tickets
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 17.9 support_ticket_messages
```sql
CREATE TABLE support_ticket_messages (
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_id UUID NOT NULL REFERENCES support_tickets(ticket_id),
  author_type VARCHAR(20) NOT NULL, -- user, admin, ai_bot, system
  author_id UUID, -- user_id or admin_id
  body TEXT NOT NULL,
  attachments JSONB DEFAULT '[]',
  is_internal_note BOOLEAN DEFAULT false, -- only visible to admins
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
ALTER TABLE support_ticket_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE support_ticket_messages FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON support_ticket_messages
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
    AND (NOT is_internal_note OR current_user = 'admin_user'))
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
    AND (NOT is_internal_note OR current_user = 'admin_user'));
CREATE INDEX idx_stm_ticket ON support_ticket_messages(ticket_id);
```

### 17.9A kb_categories [GLOBAL]
```sql
CREATE TABLE kb_categories (
  category_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug VARCHAR(100) UNIQUE NOT NULL,
  display_name VARCHAR(255) NOT NULL,
  description TEXT,
  icon_key VARCHAR(50),
  sort_order INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_by UUID REFERENCES internal_admins(admin_id),
  updated_by UUID REFERENCES internal_admins(admin_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_kbc_active ON kb_categories(is_active, sort_order);
```

### 17.9B kb_articles [GLOBAL]
```sql
CREATE TABLE kb_articles (
  article_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id UUID REFERENCES kb_categories(category_id),
  slug VARCHAR(160) UNIQUE NOT NULL,
  locale VARCHAR(10) NOT NULL DEFAULT 'vi-VN',
  title VARCHAR(255) NOT NULL,
  summary TEXT,
  body_markdown TEXT NOT NULL,
  search_document TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, review, published, archived
  article_type VARCHAR(30) NOT NULL DEFAULT 'how_to', -- getting_started, how_to, faq, troubleshooting, api_reference, changelog
  target_modules JSONB NOT NULL DEFAULT '[]', -- ["M07","M23"]
  target_operator_modes JSONB NOT NULL DEFAULT '[]',
  target_tiers JSONB NOT NULL DEFAULT '[]',
  tags JSONB NOT NULL DEFAULT '[]',
  related_article_ids JSONB NOT NULL DEFAULT '[]',
  estimated_read_minutes SMALLINT,
  helpful_votes INTEGER NOT NULL DEFAULT 0,
  unhelpful_votes INTEGER NOT NULL DEFAULT 0,
  view_count INTEGER NOT NULL DEFAULT 0,
  last_reviewed_at TIMESTAMPTZ,
  published_at TIMESTAMPTZ,
  archived_at TIMESTAMPTZ,
  created_by UUID REFERENCES internal_admins(admin_id),
  updated_by UUID REFERENCES internal_admins(admin_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_kba_category ON kb_articles(category_id, status);
CREATE INDEX idx_kba_slug_locale ON kb_articles(slug, locale);
CREATE INDEX idx_kba_review ON kb_articles(last_reviewed_at);
ALTER TABLE kb_articles ADD CONSTRAINT chk_kb_articles_status
  CHECK (status IN ('draft', 'review', 'published', 'archived'));
ALTER TABLE kb_articles ADD CONSTRAINT chk_kb_articles_type
  CHECK (article_type IN ('getting_started', 'how_to', 'faq', 'troubleshooting', 'api_reference', 'changelog'));
```

### 17.9C kb_article_versions [GLOBAL]
```sql
CREATE TABLE kb_article_versions (
  article_version_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  article_id UUID NOT NULL REFERENCES kb_articles(article_id),
  version_number INTEGER NOT NULL,
  title VARCHAR(255) NOT NULL,
  summary TEXT,
  body_markdown TEXT NOT NULL,
  change_note TEXT,
  edited_by UUID REFERENCES internal_admins(admin_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(article_id, version_number)
);
CREATE INDEX idx_kbav_article ON kb_article_versions(article_id, version_number DESC);
```

### 17.9D article_ratings [GLOBAL]
```sql
CREATE TABLE article_ratings (
  rating_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  article_id UUID NOT NULL REFERENCES kb_articles(article_id),
  user_id UUID NOT NULL REFERENCES users(user_id),
  helpful BOOLEAN NOT NULL,
  feedback_text TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(article_id, user_id)
);
CREATE INDEX idx_ar_article ON article_ratings(article_id, created_at DESC);
CREATE INDEX idx_ar_helpful ON article_ratings(article_id, helpful);
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

### 17.12 admin_sessions [GLOBAL] (Audit v6 — schema gap)
```sql
CREATE TABLE admin_sessions (
  session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id UUID NOT NULL REFERENCES internal_admins(admin_id),
  ip_address INET NOT NULL,
  user_agent TEXT,
  vpn_verified BOOLEAN NOT NULL DEFAULT false,
  mfa_verified BOOLEAN NOT NULL DEFAULT false,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_activity_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expired_at TIMESTAMPTZ,
  revoked_at TIMESTAMPTZ,
  revoked_reason VARCHAR(200),
  session_token_hash VARCHAR(128) NOT NULL
);
CREATE INDEX idx_admin_sessions_admin ON admin_sessions(admin_id);
CREATE INDEX idx_admin_sessions_active ON admin_sessions(expired_at) WHERE expired_at IS NULL;
```

---

## 18. Context: Operational Tables

### 18.1 approval_requests
```sql
CREATE TABLE approval_requests (
  request_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
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
CREATE INDEX idx_approval_requests_workspace ON approval_requests(workspace_id);
CREATE INDEX idx_ar_status ON approval_requests(status);
CREATE INDEX idx_ar_object ON approval_requests(object_type, object_id);
ALTER TABLE approval_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE approval_requests FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON approval_requests
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 18.2 capability_snapshots
```sql
CREATE TABLE capability_snapshots (
  snapshot_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  platform VARCHAR(50) NOT NULL,
  capabilities JSONB NOT NULL, -- {action: capability_state}
  api_version VARCHAR(20),
  captured_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  valid_until TIMESTAMPTZ,
  notes TEXT
);
CREATE INDEX idx_cs_workspace ON capability_snapshots(workspace_id, platform);
ALTER TABLE capability_snapshots ENABLE ROW LEVEL SECURITY;
ALTER TABLE capability_snapshots FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON capability_snapshots
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
ALTER TABLE policy_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE policy_notes FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON policy_notes
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
ALTER TABLE fallback_paths ENABLE ROW LEVEL SECURITY;
ALTER TABLE fallback_paths FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON fallback_paths
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
ALTER TABLE consent_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE consent_records FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON consent_records
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active','rotating','suspended','revoked','expired')),
  logical_key_id UUID REFERENCES api_keys(api_key_id),
  replaced_by_key_id UUID REFERENCES api_keys(api_key_id),
  rotation_grace_ends_at TIMESTAMPTZ,
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
ALTER TABLE api_keys ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_keys FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON api_keys
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 18.4A api_usage_daily
```sql
CREATE TABLE api_usage_daily (
  usage_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  api_key_id UUID NOT NULL REFERENCES api_keys(api_key_id),
  usage_date DATE NOT NULL,
  read_requests INTEGER NOT NULL DEFAULT 0,
  write_requests INTEGER NOT NULL DEFAULT 0,
  error_4xx_count INTEGER NOT NULL DEFAULT 0,
  error_5xx_count INTEGER NOT NULL DEFAULT 0,
  outbound_webhook_deliveries INTEGER NOT NULL DEFAULT 0,
  billable_ai_credits NUMERIC(18,6) NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(api_key_id, usage_date)
);
CREATE INDEX idx_aud_workspace ON api_usage_daily(workspace_id);
CREATE INDEX idx_aud_key_date ON api_usage_daily(api_key_id, usage_date DESC);
ALTER TABLE api_usage_daily ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_usage_daily FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON api_usage_daily
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 18.4B api_webhook_subscriptions
```sql
CREATE TABLE api_webhook_subscriptions (
  webhook_subscription_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  api_key_id UUID REFERENCES api_keys(api_key_id),
  target_url TEXT NOT NULL,
  event_types JSONB NOT NULL DEFAULT '[]',
  signing_secret_hash VARCHAR(128) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'active', -- active, suspended, revoked
  consecutive_failure_count INTEGER NOT NULL DEFAULT 0,
  last_delivery_at TIMESTAMPTZ,
  last_error TEXT,
  created_by UUID NOT NULL REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_aws_workspace ON api_webhook_subscriptions(workspace_id);
CREATE INDEX idx_aws_status ON api_webhook_subscriptions(status);
ALTER TABLE api_webhook_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_webhook_subscriptions FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON api_webhook_subscriptions
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE api_webhook_subscriptions ADD CONSTRAINT chk_api_webhook_subscriptions_status
  CHECK (status IN ('active', 'suspended', 'revoked'));
```

### 18.4C webhook_events
```sql
CREATE TABLE webhook_events (
  webhook_event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  provider VARCHAR(50) NOT NULL, -- stripe, tiktok, shopee, lazada, youtube, instagram, facebook, public_api
  direction VARCHAR(20) NOT NULL, -- inbound, outbound
  external_event_id VARCHAR(255),
  idempotency_key VARCHAR(255) NOT NULL,
  webhook_subscription_id UUID REFERENCES api_webhook_subscriptions(webhook_subscription_id),
  payload JSONB NOT NULL,
  processing_status VARCHAR(30) NOT NULL DEFAULT 'received', -- received, acknowledged, processed, failed, dead_lettered
  retry_count INTEGER NOT NULL DEFAULT 0,
  last_error TEXT,
  received_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  processed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE UNIQUE INDEX idx_we_idempotency ON webhook_events(provider, idempotency_key);
CREATE INDEX idx_we_workspace ON webhook_events(workspace_id);
CREATE INDEX idx_we_status ON webhook_events(processing_status);
ALTER TABLE webhook_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE webhook_events FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON webhook_events
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE webhook_events ADD CONSTRAINT chk_webhook_events_direction
  CHECK (direction IN ('inbound', 'outbound'));
ALTER TABLE webhook_events ADD CONSTRAINT chk_webhook_events_processing_status
  CHECK (processing_status IN ('received', 'acknowledged', 'processed', 'failed', 'dead_lettered'));
```

### 18.4D background_jobs [GLOBAL]
```sql
CREATE TABLE background_jobs (
  job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID REFERENCES workspaces(workspace_id),
  queue_name VARCHAR(100) NOT NULL,
  job_type VARCHAR(100) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'queued', -- queued, running, paused, succeeded, failed, cancelled, dead_lettered
  priority VARCHAR(10) NOT NULL DEFAULT 'normal', -- urgent, high, normal, low
  progress_percentage REAL NOT NULL DEFAULT 0, -- 0-100 non-financial progress
  step_name VARCHAR(255),
  provider VARCHAR(50),
  payload JSONB NOT NULL DEFAULT '{}',
  result_summary JSONB NOT NULL DEFAULT '{}',
  error_class VARCHAR(50),
  error_message TEXT,
  attempt_count INTEGER NOT NULL DEFAULT 0,
  max_attempts INTEGER NOT NULL DEFAULT 3,
  requested_by UUID,
  scheduled_at TIMESTAMPTZ,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  last_heartbeat_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_bgj_queue_status ON background_jobs(queue_name, status, created_at DESC);
CREATE INDEX idx_bgj_workspace ON background_jobs(workspace_id, created_at DESC);
ALTER TABLE background_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE background_jobs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON background_jobs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
-- Note: system-level jobs (workspace_id IS NULL) require service role access
ALTER TABLE background_jobs ADD CONSTRAINT chk_background_jobs_status
  CHECK (status IN ('queued', 'running', 'paused', 'succeeded', 'failed', 'cancelled', 'dead_lettered'));
ALTER TABLE background_jobs ADD CONSTRAINT chk_background_jobs_priority
  CHECK (priority IN ('urgent', 'high', 'normal', 'low'));
```

### 18.4E job_schedules [GLOBAL]
```sql
CREATE TABLE job_schedules (
  job_schedule_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  queue_name VARCHAR(100) NOT NULL,
  job_type VARCHAR(100) NOT NULL,
  cron_expression VARCHAR(120) NOT NULL,
  timezone VARCHAR(60) NOT NULL DEFAULT 'Asia/Ho_Chi_Minh',
  payload_template JSONB NOT NULL DEFAULT '{}',
  is_active BOOLEAN NOT NULL DEFAULT true,
  last_run_at TIMESTAMPTZ,
  next_run_at TIMESTAMPTZ,
  created_by UUID REFERENCES internal_admins(admin_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_js_active_next ON job_schedules(is_active, next_run_at);
```

### 18.4F job_metrics [GLOBAL]
```sql
CREATE TABLE job_metrics (
  metric_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  queue_name VARCHAR(100) NOT NULL,
  bucket_start TIMESTAMPTZ NOT NULL,
  running_count INTEGER NOT NULL DEFAULT 0,
  queued_count INTEGER NOT NULL DEFAULT 0,
  failed_count INTEGER NOT NULL DEFAULT 0,
  dead_letter_count INTEGER NOT NULL DEFAULT 0,
  avg_processing_ms INTEGER,
  p95_processing_ms INTEGER,
  queue_lag_ms INTEGER,
  active_workers INTEGER,
  memory_pct REAL, -- 0-100 non-financial usage
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(queue_name, bucket_start)
);
CREATE INDEX idx_jm_queue_bucket ON job_metrics(queue_name, bucket_start DESC);
```

### 18.4G dead_letter_queue [GLOBAL]
```sql
CREATE TABLE dead_letter_queue (
  dlq_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  queue_name VARCHAR(100) NOT NULL,
  original_message_id VARCHAR(255) NOT NULL,
  payload JSONB NOT NULL,
  error_class VARCHAR(50) NOT NULL,
  error_message TEXT,
  last_error_at TIMESTAMPTZ NOT NULL,
  attempt_count INTEGER NOT NULL,
  retry_history JSONB DEFAULT '[]',
  workspace_id UUID REFERENCES workspaces(workspace_id),
  status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, retrying, resolved, discarded
  resolved_at TIMESTAMPTZ,
  resolved_by UUID REFERENCES internal_admins(admin_id),
  resolution_notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_dlq_queue ON dead_letter_queue(queue_name, status);
CREATE INDEX idx_dlq_workspace ON dead_letter_queue(workspace_id);
ALTER TABLE dead_letter_queue ADD CONSTRAINT chk_dead_letter_queue_status
  CHECK (status IN ('pending', 'retrying', 'resolved', 'discarded'));
ALTER TABLE dead_letter_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE dead_letter_queue FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON dead_letter_queue
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
-- Note: system-level DLQ items (workspace_id IS NULL) require service role access
```

### 18.4H event_outbox [GLOBAL]
```sql
CREATE TABLE event_outbox (
  outbox_id BIGSERIAL PRIMARY KEY,
  event_id UUID NOT NULL UNIQUE, -- stable DomainEvent.event_id across delivery retries
  event_type VARCHAR(200) NOT NULL,
  target_stream VARCHAR(100) NOT NULL, -- canonical queue name from queue_retry_design.md §2 (e.g., publish_jobs, generation_jobs)
  aggregate_type VARCHAR(100) NOT NULL,
  aggregate_id UUID NOT NULL,
  workspace_id UUID REFERENCES workspaces(workspace_id),
  payload JSONB NOT NULL,
  metadata JSONB DEFAULT '{}',
  published BOOLEAN NOT NULL DEFAULT false,
  published_at TIMESTAMPTZ,
  lease_owner VARCHAR(100),
  lease_until TIMESTAMPTZ,
  attempt_count INTEGER NOT NULL DEFAULT 0,
  next_attempt_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_outbox_unpublished ON event_outbox(published, created_at)
  WHERE published = false;
ALTER TABLE event_outbox ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_outbox FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON event_outbox
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
-- Note: outbox poller runs as service role (bypasses RLS) per ADR-011 exception
```

### 18.4I broadcasts [GLOBAL]
```sql
CREATE TABLE broadcasts (
  broadcast_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  broadcast_type VARCHAR(30) NOT NULL DEFAULT 'announcement', -- announcement, maintenance, feature, security
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, scheduled, sending, sent, cancelled, failed
  title VARCHAR(255) NOT NULL,
  body_markdown TEXT NOT NULL,
  channels JSONB NOT NULL DEFAULT '[]', -- ["in_app","email","push"]
  audience_filter JSONB NOT NULL DEFAULT '{}',
  cta_label VARCHAR(120),
  cta_url TEXT,
  timezone VARCHAR(60) NOT NULL DEFAULT 'Asia/Ho_Chi_Minh',
  scheduled_at TIMESTAMPTZ,
  sent_at TIMESTAMPTZ,
  total_targets INTEGER NOT NULL DEFAULT 0,
  delivered_count INTEGER NOT NULL DEFAULT 0,
  read_count INTEGER NOT NULL DEFAULT 0,
  click_count INTEGER NOT NULL DEFAULT 0,
  created_by UUID REFERENCES internal_admins(admin_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_brd_status_schedule ON broadcasts(status, scheduled_at);
ALTER TABLE broadcasts ADD CONSTRAINT chk_broadcasts_type
  CHECK (broadcast_type IN ('announcement', 'maintenance', 'feature', 'security'));
ALTER TABLE broadcasts ADD CONSTRAINT chk_broadcasts_status
  CHECK (status IN ('draft', 'scheduled', 'sending', 'sent', 'cancelled', 'failed'));
```

### 18.4J broadcast_targets [GLOBAL]
```sql
CREATE TABLE broadcast_targets (
  broadcast_target_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  broadcast_id UUID NOT NULL REFERENCES broadcasts(broadcast_id),
  user_id UUID REFERENCES users(user_id),
  workspace_id UUID REFERENCES workspaces(workspace_id),
  delivery_channels JSONB NOT NULL DEFAULT '[]',
  delivery_status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, queued, delivered, failed, read, clicked
  last_delivery_at TIMESTAMPTZ,
  last_error TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
ALTER TABLE broadcast_targets ENABLE ROW LEVEL SECURITY;
ALTER TABLE broadcast_targets FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON broadcast_targets
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
CREATE INDEX idx_brt_broadcast_status ON broadcast_targets(broadcast_id, delivery_status);
ALTER TABLE broadcast_targets ADD CONSTRAINT chk_broadcast_targets_status
  CHECK (delivery_status IN ('pending', 'queued', 'delivered', 'failed', 'read', 'clicked'));
```

### 18.4K notification_events [GLOBAL]
```sql
CREATE TABLE notification_events (
  notification_event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  broadcast_id UUID REFERENCES broadcasts(broadcast_id),
  notification_id UUID REFERENCES notifications(notification_id),
  workspace_id UUID REFERENCES workspaces(workspace_id),
  user_id UUID REFERENCES users(user_id),
  channel VARCHAR(20) NOT NULL, -- in_app, email, push, sms
  event_type VARCHAR(20) NOT NULL, -- queued, sent, delivered, opened, clicked, failed
  metadata JSONB NOT NULL DEFAULT '{}',
  event_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ne_broadcast ON notification_events(broadcast_id, event_type, event_at DESC);
CREATE INDEX idx_ne_user ON notification_events(user_id, event_at DESC);
ALTER TABLE notification_events ADD CONSTRAINT chk_notification_events_channel
  CHECK (channel IN ('in_app', 'email', 'push', 'sms'));
ALTER TABLE notification_events ADD CONSTRAINT chk_notification_events_type
  CHECK (event_type IN ('queued', 'sent', 'delivered', 'opened', 'clicked', 'failed'));
ALTER TABLE notification_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_events FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON notification_events
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
-- Note: system-level events (workspace_id IS NULL) and broadcast delivery tracking require service role access
```

### 18.5 tags (generic polymorphic tagging)
```sql
CREATE TABLE tags (
  tag_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  name VARCHAR(100) NOT NULL,
  color VARCHAR(7), -- hex color
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, name)
);

ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON tags
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- Tag associations are directly tenant-scoped; see §26 for parent guards.
CREATE TABLE taggables (
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  tag_id UUID NOT NULL REFERENCES tags(tag_id),
  taggable_type VARCHAR(50) NOT NULL,
  taggable_id UUID NOT NULL,
  PRIMARY KEY (tag_id, taggable_type, taggable_id)
);
ALTER TABLE taggables ENABLE ROW LEVEL SECURITY;
ALTER TABLE taggables FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON taggables
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
CREATE INDEX idx_taggables_target ON taggables(taggable_type, taggable_id);
```

### 18.6 referral_records
```sql
CREATE TABLE referral_records (
  referral_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id), -- referring workspace
  referee_workspace_id UUID REFERENCES workspaces(workspace_id),
  referrer_user_id UUID NOT NULL REFERENCES users(user_id),
  referee_user_id UUID NOT NULL REFERENCES users(user_id),
  referral_code VARCHAR(20) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','qualified','rewarded','revoked','expired','fraud_flagged','forfeited')),
  referee_qualified_at TIMESTAMPTZ,
  referrer_credits_awarded NUMERIC(18,6) DEFAULT 0, -- DB-H-001: credit amount
  referee_credits_awarded NUMERIC(18,6) DEFAULT 0, -- DB-H-001: credit amount
  fraud_check_passed BOOLEAN,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_rr_referrer ON referral_records(referrer_user_id);
CREATE UNIQUE INDEX idx_rr_referee ON referral_records(referee_user_id);
ALTER TABLE referral_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE referral_records FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON referral_records
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
GRANT SELECT ON referral_records TO app_user;
GRANT SELECT, INSERT, UPDATE ON referral_records TO admin_user;
CREATE POLICY admin_referral_access ON referral_records TO admin_user USING (true);
```

### 18.7 file_uploads
```sql
CREATE TABLE file_uploads (
  upload_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
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
ALTER TABLE file_uploads ENABLE ROW LEVEL SECURITY;
ALTER TABLE file_uploads FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON file_uploads
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 18.8 export_jobs
```sql
CREATE TABLE export_jobs (
  export_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
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
ALTER TABLE export_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE export_jobs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON export_jobs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_preferences FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON user_preferences
  USING (user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid
    AND (workspace_id IS NULL OR workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid));
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
  current_period_start TIMESTAMPTZ,
  current_period_end TIMESTAMPTZ,
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
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON subscriptions
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 19.1B invoices (Audit v6 — schema gap)
```sql
CREATE TABLE invoices (
  invoice_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  subscription_id UUID REFERENCES subscriptions(subscription_id),
  stripe_invoice_id VARCHAR(255),
  invoice_number VARCHAR(50) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, open, paid, void, uncollectible
  amount_due NUMERIC(18,6) NOT NULL,
  amount_paid NUMERIC(18,6) NOT NULL DEFAULT 0,
  currency VARCHAR(5) DEFAULT 'VND',
  billing_period_start DATE,
  billing_period_end DATE,
  line_items JSONB NOT NULL DEFAULT '[]', -- [{description, quantity, unit_price, total}]
  payment_method_id UUID,
  paid_at TIMESTAMPTZ,
  due_date DATE,
  hosted_invoice_url TEXT, -- Stripe-hosted invoice page
  pdf_url TEXT,
  dunning_attempt INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_inv_workspace ON invoices(workspace_id);
CREATE INDEX idx_inv_status ON invoices(status);
CREATE INDEX idx_inv_period ON invoices(billing_period_start, billing_period_end);
ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoices FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON invoices
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE invoices ADD CONSTRAINT chk_invoices_status
  CHECK (status IN ('draft', 'open', 'paid', 'void', 'uncollectible'));
```

### 19.1C payment_methods (Audit v6 — schema gap)
```sql
CREATE TABLE payment_methods (
  payment_method_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  stripe_payment_method_id VARCHAR(255),
  method_type VARCHAR(20) NOT NULL, -- card, bank_transfer, momo, zalopay, vnpay, paypal
  brand VARCHAR(20), -- visa, mastercard, jcb, etc.
  last4 VARCHAR(4),
  exp_month SMALLINT,
  exp_year SMALLINT,
  is_default BOOLEAN DEFAULT false,
  billing_name VARCHAR(255),
  billing_email VARCHAR(255),
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);
CREATE INDEX idx_pm_workspace ON payment_methods(workspace_id);
ALTER TABLE payment_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_methods FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON payment_methods
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 19.2 coupons
```sql
CREATE TABLE coupons (
  coupon_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  code VARCHAR(50) NOT NULL,
  coupon_type VARCHAR(20) NOT NULL, -- percentage, fixed_amount, free_shipping
  discount_value NUMERIC(18,6) NOT NULL,
  min_order_amount NUMERIC(18,6),
  max_uses INTEGER,
  current_uses INTEGER DEFAULT 0,
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, active, paused, expired, retired, revoked (Note: 'revoked' is a downstream extension of Freeze §26.3 for fraud/policy enforcement cases)
  related_offer_ids UUID[] DEFAULT '{}',
  related_campaign_ids UUID[] DEFAULT '{}',
  valid_from TIMESTAMPTZ,
  valid_until TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, code),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE coupons FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON coupons
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE coupons ADD CONSTRAINT chk_coupons_lifecycle_state
  CHECK (lifecycle_state IN ('draft', 'active', 'paused', 'expired', 'retired', 'revoked'));
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
  UNIQUE(workspace_id, slug),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
ALTER TABLE store_pages ENABLE ROW LEVEL SECURITY;
ALTER TABLE store_pages FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON store_pages
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 19.4 membership_plans
```sql
CREATE TABLE membership_plans (
  plan_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  price NUMERIC(18,6) NOT NULL,
  currency VARCHAR(5) DEFAULT 'VND',
  billing_interval VARCHAR(10) NOT NULL DEFAULT 'monthly',
  benefits JSONB DEFAULT '[]', -- [{type, description}]
  entitlement_config JSONB NOT NULL DEFAULT '{}', -- creator-store content/feature/support entitlements, not SaaS workspace privileges
  status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, active, hidden, paused, retired
  subscriber_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
ALTER TABLE membership_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE membership_plans FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON membership_plans
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 19.4B membership_subscriptions
```sql
CREATE TABLE membership_subscriptions (
  membership_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  plan_id UUID NOT NULL REFERENCES membership_plans(plan_id),
  customer_entity_id UUID NOT NULL REFERENCES entities(entity_id),
  status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active','cancelled','expired')),
  provider_subscription_id VARCHAR(255),
  current_period_start TIMESTAMPTZ NOT NULL,
  current_period_end TIMESTAMPTZ NOT NULL,
  entitlement_snapshot JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, provider_subscription_id)
);
ALTER TABLE membership_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE membership_subscriptions FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON membership_subscriptions
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
GRANT SELECT, INSERT, UPDATE ON membership_subscriptions TO app_user;
```

Member access requires verified customer identity mapped to customer_entity_id and current paid period/entitlement_snapshot; a creator workspace member role alone is not a buyer membership. Provider events are idempotent. Cancel keeps access to current_period_end; payment failure expires access after the specified dunning period.


### 19.5 refunds
```sql
CREATE TABLE refunds (
  refund_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  order_id UUID NOT NULL REFERENCES orders(order_id),
  refund_type VARCHAR(20) NOT NULL, -- full, partial, credit
  amount NUMERIC(18,6) NOT NULL,
  currency VARCHAR(5) NOT NULL DEFAULT 'VND',
  reason TEXT NOT NULL,
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'requested', -- requested, approved, rejected, processing, completed, failed, cancelled (aligned to Freeze §27.2)
  source_class source_class NOT NULL DEFAULT 'imported',
  source_platform VARCHAR(50),
  external_refund_id VARCHAR(255),
  settlement_id UUID REFERENCES settlements(settlement_id),
  evidence_refs JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_refunds_order ON refunds(order_id);
ALTER TABLE refunds ENABLE ROW LEVEL SECURITY;
ALTER TABLE refunds FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON refunds
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE refunds ADD CONSTRAINT chk_refunds_lifecycle_state
  CHECK (lifecycle_state IN ('requested', 'approved', 'rejected', 'processing', 'completed', 'failed', 'cancelled'));
```

### 19.6 returns
```sql
CREATE TABLE returns (
  return_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  order_id UUID NOT NULL REFERENCES orders(order_id),
  refund_id UUID REFERENCES refunds(refund_id),
  return_type VARCHAR(20) NOT NULL, -- full, partial
  items JSONB DEFAULT '[]', -- [{sku, quantity, reason}]
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'initiated', -- initiated, approved, shipped_back, received, inspected, closed, rejected
  tracking_number VARCHAR(100),
  evidence_photo_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_returns_order ON returns(order_id);
ALTER TABLE returns ENABLE ROW LEVEL SECURITY;
ALTER TABLE returns FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON returns
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE returns ADD CONSTRAINT chk_returns_lifecycle_state
  CHECK (lifecycle_state IN ('initiated', 'approved', 'shipped_back', 'received', 'inspected', 'closed', 'rejected'));
```

### 19.7 bundles & bundle_items
```sql
CREATE TABLE bundles (
  bundle_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  title VARCHAR(255) NOT NULL,
  offer_id UUID REFERENCES offers(offer_id),
  bundle_price NUMERIC(18,6),
  discount_pct NUMERIC(5,2),
  status VARCHAR(20) NOT NULL DEFAULT 'draft',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);

ALTER TABLE bundles ENABLE ROW LEVEL SECURITY;
ALTER TABLE bundles FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON bundles
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE bundle_items (
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  bundle_id UUID NOT NULL REFERENCES bundles(bundle_id),
  product_id UUID NOT NULL REFERENCES products(product_id),
  quantity INTEGER NOT NULL DEFAULT 1,
  PRIMARY KEY (bundle_id, product_id)
);
ALTER TABLE bundle_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE bundle_items FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON bundle_items
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 19.8 price_rules
```sql
CREATE TABLE price_rules (
  price_rule_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  rule_type VARCHAR(30) NOT NULL, -- volume_discount, tiered, time_limited, customer_segment
  conditions JSONB NOT NULL, -- {min_qty, date_range, segment}
  adjustment_type VARCHAR(20) NOT NULL, -- percentage, fixed
  adjustment_value NUMERIC(18,6) NOT NULL,
  related_product_ids UUID[] DEFAULT '{}',
  priority SMALLINT DEFAULT 0,
  status VARCHAR(20) NOT NULL DEFAULT 'active',
  valid_from TIMESTAMPTZ,
  valid_until TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
ALTER TABLE price_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE price_rules FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON price_rules
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 19.9 live_segments
```sql
CREATE TABLE live_segments (
  segment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES live_sessions(session_id),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  segment_type VARCHAR(30) NOT NULL, -- product_demo, qa, giveaway, flash_sale, intro, outro
  start_offset_seconds INTEGER NOT NULL,
  end_offset_seconds INTEGER,
  title VARCHAR(255),
  pinned_offer_id UUID REFERENCES offers(offer_id),
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ls_session ON live_segments(session_id);
ALTER TABLE live_segments ENABLE ROW LEVEL SECURITY;
ALTER TABLE live_segments FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON live_segments
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 19.9B cue_cards (M17 — Tier B)
```sql
CREATE TABLE cue_cards (
  cue_card_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES live_sessions(session_id),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  segment_id UUID REFERENCES live_segments(segment_id),
  cue_type VARCHAR(30) NOT NULL, -- product_highlight, talking_point, price_drop, giveaway, qa_prompt, cta, transition
  title VARCHAR(255) NOT NULL,
  body TEXT,
  pinned_product_id UUID REFERENCES products(product_id),
  pinned_offer_id UUID REFERENCES offers(offer_id),
  display_order SMALLINT NOT NULL DEFAULT 0,
  triggered_at TIMESTAMPTZ, -- when the cue was actually shown/used
  status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, active, used, skipped
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_cc_session ON cue_cards(session_id);
CREATE INDEX idx_cc_segment ON cue_cards(segment_id);
ALTER TABLE cue_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE cue_cards FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON cue_cards
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 19.9C highlights (M17 — Tier B)
```sql
CREATE TABLE highlights (
  highlight_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES live_sessions(session_id),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  title VARCHAR(255),
  start_offset_seconds INTEGER NOT NULL,
  end_offset_seconds INTEGER NOT NULL,
  highlight_type VARCHAR(30) NOT NULL, -- viral_moment, product_demo, best_sale, audience_peak, key_announcement
  auto_detected BOOLEAN DEFAULT false, -- true = AI-detected, false = manual mark
  asset_id UUID REFERENCES assets(asset_id), -- linked extracted clip
  engagement_score REAL, -- 0-100 non-financial composite score
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_hl_session ON highlights(session_id);
ALTER TABLE highlights ENABLE ROW LEVEL SECURITY;
ALTER TABLE highlights FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON highlights
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 19.9D channel_posts (M11 — Tier B, Freeze §13.10)
```sql
CREATE TABLE channel_posts (
  channel_post_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
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
CREATE INDEX idx_channel_posts_workspace ON channel_posts(workspace_id);
CREATE INDEX idx_cp_publish ON channel_posts(publish_item_id);
CREATE UNIQUE INDEX idx_cp_external ON channel_posts(connected_account_id, external_post_id);
ALTER TABLE channel_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE channel_posts FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON channel_posts
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 19.9E reconciliation_records (M19 — Tier B, Freeze §27.6)
```sql
CREATE TABLE reconciliation_records (
  record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  scope_type VARCHAR(50) NOT NULL, -- order_batch, settlement_batch, affiliate_period, campaign
  scope_description TEXT,
  related_order_ids UUID[] DEFAULT '{}',
  related_settlement_ids UUID[] DEFAULT '{}',
  reconciliation_state reconciliation_state NOT NULL DEFAULT 'awaiting_evidence',
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
CREATE INDEX idx_rr_state ON reconciliation_records(reconciliation_state);
ALTER TABLE reconciliation_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE reconciliation_records FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON reconciliation_records
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 19.9F skus (M13 — Tier C, Freeze §15.2) — ⚠️ DEPRECATED: use `product_skus` (§10.1B)
> Historical alias only: use `product_skus`; no separate `skus` table is created.


### 19.9G inventory_locations (M13 — Tier C, Freeze §15.2)
```sql
CREATE TABLE inventory_locations (
  location_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  name VARCHAR(255) NOT NULL,
  location_type VARCHAR(30) NOT NULL, -- warehouse, store, supplier, in_transit
  address JSONB DEFAULT '{}',
  is_default BOOLEAN DEFAULT false,
  status VARCHAR(20) NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
ALTER TABLE inventory_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_locations FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON inventory_locations
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 19.9H stock_movements (M13 — Tier C, Freeze §15.2)
```sql
CREATE TABLE stock_movements (
  movement_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  sku_id UUID NOT NULL REFERENCES product_skus(sku_id), -- Audit v8: was skus(sku_id), skus is DEPRECATED per §19.9F
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
ALTER TABLE stock_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_movements FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON stock_movements
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 19.10 sample_requests & sample_shipments (M18)
```sql
CREATE TABLE sample_requests (
  request_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  campaign_id UUID REFERENCES campaigns(campaign_id),
  product_id UUID REFERENCES products(product_id),
  creator_entity_id UUID REFERENCES entities(entity_id),
  status VARCHAR(20) NOT NULL DEFAULT 'requested', -- requested, approved, declined, fulfilled, cancelled
  quantity INTEGER NOT NULL DEFAULT 1,
  outcome_status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (outcome_status IN ('pending','logged')),
  outcome JSONB NOT NULL DEFAULT '{}', -- content refs, attributable amounts/currency and source class
  follow_up_status VARCHAR(20) NOT NULL DEFAULT 'pending_followup' CHECK (follow_up_status IN ('pending_followup','contacted','responded','no_response')),
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);

ALTER TABLE sample_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE sample_requests FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON sample_requests
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE sample_requests ADD CONSTRAINT chk_sample_requests_status
  CHECK (status IN ('requested', 'approved', 'declined', 'fulfilled', 'cancelled'));

CREATE TABLE sample_shipments (
  shipment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id UUID NOT NULL REFERENCES sample_requests(request_id),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  tracking_number VARCHAR(100),
  carrier VARCHAR(50),
  shipped_at TIMESTAMPTZ,
  delivered_at TIMESTAMPTZ,
  status VARCHAR(20) NOT NULL DEFAULT 'preparing', -- preparing, shipped, delivered, lost, returned, closed
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
ALTER TABLE sample_shipments ENABLE ROW LEVEL SECURITY;
ALTER TABLE sample_shipments FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON sample_shipments
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE sample_shipments ADD CONSTRAINT chk_sample_shipments_status
  CHECK (status IN ('preparing', 'shipped', 'delivered', 'lost', 'returned', 'closed'));
```

### 19.11 recipe_templates
> Moved to `§12.3B` above `agent_runs` so top-to-bottom DDL execution satisfies `agent_runs.recipe_id REFERENCES recipe_templates(recipe_id)` without forward references.

### 19.12 copilot_sessions
```sql
CREATE TABLE copilot_sessions (
  session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  user_id UUID NOT NULL REFERENCES users(user_id),
  mode VARCHAR(20) NOT NULL, -- creative, analytics, action, video_production, help
  context_scope VARCHAR(50),
  messages JSONB DEFAULT '[]', -- [{role, content, timestamp}]
  total_credits_used NUMERIC(18,6) DEFAULT 0, -- DB-H-001: credit amount (not counter)
  ended_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_copilot_sessions_workspace ON copilot_sessions(workspace_id);
CREATE INDEX idx_cs_user ON copilot_sessions(user_id);
ALTER TABLE copilot_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE copilot_sessions FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON copilot_sessions
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 19.13 commissions — ⚠️ DEPRECATED: use `affiliate_commissions` (§10.4B)
> Historical alias only: use `affiliate_commissions`; no separate `commissions` table is created.


### 19.14 chargebacks
```sql
CREATE TABLE chargebacks (
  chargeback_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  order_id UUID NOT NULL REFERENCES orders(order_id),
  external_chargeback_id VARCHAR(255),
  amount NUMERIC(18,6) NOT NULL,
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
ALTER TABLE chargebacks ENABLE ROW LEVEL SECURITY;
ALTER TABLE chargebacks FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON chargebacks
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 19.15 content_attribution_records (Profit OS)
```sql
CREATE TABLE content_attribution_records (
  attribution_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  publish_item_id UUID REFERENCES publish_items(publish_item_id),
  order_id UUID REFERENCES orders(order_id),
  attribution_type VARCHAR(30) NOT NULL, -- direct_click, utm_match, affiliate, organic
  revenue_attributed NUMERIC(18,6),
  source_class source_class DEFAULT 'inferred',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_car_publish ON content_attribution_records(publish_item_id);
CREATE INDEX idx_car_workspace ON content_attribution_records(workspace_id);
ALTER TABLE content_attribution_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_attribution_records FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON content_attribution_records
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  fee_pct NUMERIC(5,4), -- e.g., 0.0500 = 5%
  fee_fixed NUMERIC(18,6), -- fixed fee amount (nullable)
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
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  mode VARCHAR(30) NOT NULL, -- quick_edit, clip_factory, multi_merge, remix, product_showcase, image_to_video, link_to_video, translation, video_agent
  source_asset_ids UUID[] DEFAULT '{}', -- input assets
  output_asset_ids UUID[] DEFAULT '{}', -- produced assets
  generation_job_id UUID REFERENCES generation_jobs(job_id), -- linked AI generation job
  character_id UUID REFERENCES characters(character_id),
  brand_pack_id UUID REFERENCES continuity_packs(pack_id),
  status VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued, processing, completed, partially_completed, failed, cancelled
  input_params JSONB NOT NULL DEFAULT '{}', -- mode-specific parameters
  output_metadata JSONB DEFAULT '{}', -- mode-specific outputs
  credits_estimated NUMERIC(18,6), -- DB-H-001: financial precision
  credits_used NUMERIC(18,6), -- DB-H-001: financial precision
  actual_cost_usd NUMERIC(18,6), -- DB-H-001: financial precision
  error_message TEXT,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_vej_workspace ON video_edit_jobs(workspace_id);
CREATE INDEX idx_vej_mode ON video_edit_jobs(mode);
CREATE INDEX idx_vej_status ON video_edit_jobs(status);
ALTER TABLE video_edit_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE video_edit_jobs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON video_edit_jobs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
ALTER TABLE video_edit_jobs ADD CONSTRAINT chk_video_edit_jobs_status
  CHECK (status IN ('queued', 'processing', 'completed', 'partially_completed', 'failed', 'cancelled'));
```

### 22.2 remix_blueprints (M07 — AI Remix Studio, Pack 04 §9.5)
```sql
CREATE TABLE remix_blueprints (
  blueprint_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  reference_asset_id UUID NOT NULL REFERENCES assets(asset_id), -- source video analyzed
  output_asset_id UUID REFERENCES assets(asset_id), -- generated remix
  video_edit_job_id UUID REFERENCES video_edit_jobs(job_id),
  creative_dna JSONB NOT NULL DEFAULT '{}', -- {scene_count, hook_type, content_structure, pacing_profile, visual_style, audio_profile, transition_map}
  remix_script TEXT, -- generated remix script
  fidelity_level VARCHAR(20) NOT NULL DEFAULT 'adapt', -- match_1to1, adapt, loose
  originality_score REAL, -- 0-100 non-financial score, must be > 70 (< 30% similarity)
  status VARCHAR(20) NOT NULL DEFAULT 'analyzing', -- analyzing, analyzed, generating, generated, failed
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_rb_workspace ON remix_blueprints(workspace_id);
CREATE INDEX idx_rb_ref ON remix_blueprints(reference_asset_id);
ALTER TABLE remix_blueprints ENABLE ROW LEVEL SECURITY;
ALTER TABLE remix_blueprints FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON remix_blueprints
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 22.3 clip_collections (M07 — Clip Factory, Pack 04 §9.3)
```sql
CREATE TABLE clip_collections (
  collection_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  source_asset_id UUID NOT NULL REFERENCES assets(asset_id),
  video_edit_job_id UUID REFERENCES video_edit_jobs(job_id),
  total_clips INTEGER NOT NULL DEFAULT 0,
  clip_data JSONB NOT NULL DEFAULT '[]', -- [{clip_index, start_s, end_s, title, virality_score, selected}]
  status VARCHAR(20) NOT NULL DEFAULT 'analyzing', -- analyzing, proposed, processing, completed, failed
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_cc_workspace ON clip_collections(workspace_id);
CREATE INDEX idx_cc_source ON clip_collections(source_asset_id);
ALTER TABLE clip_collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE clip_collections FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON clip_collections
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 22.4 product_showcase_jobs (M07 — Pack 04 §9.6)
```sql
CREATE TABLE product_showcase_jobs (
  showcase_job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  video_edit_job_id UUID REFERENCES video_edit_jobs(job_id),
  product_id UUID REFERENCES products(product_id),
  style VARCHAR(30) NOT NULL, -- spin_360, tabletop, flip_reveal, virtual_tryon, lifestyle, unboxing, before_after, review_style
  customization JSONB DEFAULT '{}', -- {background, duration, music, voice, text, cta, aspect_ratio, pacing, color_grade}
  batch_id UUID, -- for batch processing
  output_asset_id UUID REFERENCES assets(asset_id),
  character_id UUID REFERENCES characters(character_id), -- for review_style
  status VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued, processing, completed, failed
  credits_used NUMERIC(18,6), -- DB-H-001: financial precision
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_psj_workspace ON product_showcase_jobs(workspace_id);
CREATE INDEX idx_psj_product ON product_showcase_jobs(product_id);
CREATE INDEX idx_psj_batch ON product_showcase_jobs(batch_id);
ALTER TABLE product_showcase_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_showcase_jobs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON product_showcase_jobs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 22.5 link_to_video_jobs (M07 — Pack 04 §9.9)
```sql
CREATE TABLE link_to_video_jobs (
  ltv_job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  video_edit_job_id UUID REFERENCES video_edit_jobs(job_id),
  source_url TEXT NOT NULL,
  platform_detected VARCHAR(30), -- shopee, lazada, tiktok_shop, amazon, shopify, generic
  scraped_data JSONB DEFAULT '{}', -- {name, price, images[], description, reviews[]}
  script_template VARCHAR(30) NOT NULL DEFAULT 'problem_solution', -- problem_solution, listicle, testimonial, flash_sale, comparison
  generated_script TEXT,
  output_asset_id UUID REFERENCES assets(asset_id),
  character_id UUID REFERENCES characters(character_id),
  status VARCHAR(20) NOT NULL DEFAULT 'scraping', -- scraping, scripting, generating, completed, failed
  credits_used NUMERIC(18,6), -- DB-H-001: financial precision
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_ltv_workspace ON link_to_video_jobs(workspace_id);
ALTER TABLE link_to_video_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE link_to_video_jobs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON link_to_video_jobs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 22.6 translation_jobs (M07 — Pack 04 §9.10)
```sql
CREATE TABLE translation_jobs (
  translation_job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  video_edit_job_id UUID REFERENCES video_edit_jobs(job_id),
  source_asset_id UUID NOT NULL REFERENCES assets(asset_id),
  target_languages VARCHAR(10)[] NOT NULL, -- e.g., {'en', 'th', 'id', 'ja'}
  lip_sync_enabled BOOLEAN DEFAULT true,
  per_language_status JSONB DEFAULT '{}', -- {en: 'completed', th: 'processing', ...}
  output_asset_ids JSONB DEFAULT '{}', -- {en: asset_id, th: asset_id, ...}
  total_credits_used NUMERIC(18,6) DEFAULT 0, -- DB-H-001: financial precision
  status VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued, processing, partially_completed, completed, failed
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_tj_workspace ON translation_jobs(workspace_id);
CREATE INDEX idx_tj_source ON translation_jobs(source_asset_id);
ALTER TABLE translation_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE translation_jobs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON translation_jobs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 22.7 style_packs (M08 — Pack 04 §9.12)
```sql
CREATE TABLE style_packs (
  style_pack_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  name VARCHAR(255) NOT NULL,
  source_asset_id UUID NOT NULL REFERENCES assets(asset_id), -- video analyzed
  extracted_style JSONB NOT NULL DEFAULT '{}', -- {caption, color_grade, transitions, pacing, text_overlay, audio_mix}
  is_active BOOLEAN DEFAULT true,
  continuity_pack_id UUID REFERENCES continuity_packs(pack_id), -- linked Continuity OS pack
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_sp_workspace ON style_packs(workspace_id);
ALTER TABLE style_packs ENABLE ROW LEVEL SECURITY;
ALTER TABLE style_packs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON style_packs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

> **Note**: Style Packs are distinct from `continuity_packs` — they capture a learned editing style (output of Style Learning), not brand/character identity. A Style Pack MAY create a corresponding `continuity_packs` entry (type='style') for use in production pipelines.

### 22.8 performance_reports (M07 — Pack 04 §9.14)
```sql
CREATE TABLE performance_reports (
  report_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
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
ALTER TABLE performance_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE performance_reports FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON performance_reports
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

> **Credit cost**: 0 credits (included in plan, uses existing analytics data). Per Pack 04 §9.14 and Pack 08 §3.2.

### 22.9 ab_test_experiments (M07/M10 — Pack 04 §9.15)
```sql
CREATE TABLE ab_test_experiments (
  experiment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  source_asset_id UUID NOT NULL REFERENCES assets(asset_id),
  variants JSONB NOT NULL DEFAULT '[]', -- [{variant_type, asset_id, publish_item_id, variant_label}]
  metrics_snapshot JSONB DEFAULT '{}', -- per-variant metrics
  winner_asset_id UUID REFERENCES assets(asset_id),
  status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, running, completed, cancelled
  result_status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (result_status IN ('pending','conclusive','inconclusive','scaled')),
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  auto_winner_criteria JSONB DEFAULT '{}', -- {metric, threshold, min_duration_hours}
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_abt_workspace ON ab_test_experiments(workspace_id);
CREATE INDEX idx_abt_status ON ab_test_experiments(status);
ALTER TABLE ab_test_experiments ENABLE ROW LEVEL SECURITY;
ALTER TABLE ab_test_experiments FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON ab_test_experiments
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
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
  reward_credits INTEGER NOT NULL DEFAULT 0, -- whole credit units (counter); DB-H-001 NUMERIC applies to credit *amounts*
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','enrolling','active','completed','rewarded','cancelled')),
  is_active BOOLEAN DEFAULT false, -- projection of status, never independent authority
  sort_order SMALLINT DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 22.11 challenge_progress (Gamification — PRD §37.3)
```sql
CREATE TABLE challenge_progress (
  progress_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  user_id UUID NOT NULL REFERENCES users(user_id),
  challenge_id UUID NOT NULL REFERENCES challenge_definitions(challenge_id),
  current_value INTEGER NOT NULL DEFAULT 0,
  target_value INTEGER NOT NULL,
  completed BOOLEAN DEFAULT false,
  completed_at TIMESTAMPTZ,
  reward_credited BOOLEAN DEFAULT false,
  reward_transaction_id UUID, -- → ai_credit_transactions
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, user_id, challenge_id)
);
CREATE INDEX idx_chp_workspace ON challenge_progress(workspace_id);
ALTER TABLE challenge_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenge_progress FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON challenge_progress
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

> **Rules (Freeze §46A.8)**: Maximum 3 active challenges per week. Weekly challenges rotate Monday 00:00 UTC+7. Duplicate completion → no double credit (enforced by UNIQUE constraint + `reward_credited` flag).

### 22.12 voice_clone_records (M08 — Pack 04 §12B)
```sql
CREATE TABLE voice_clone_records (
  voice_clone_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  character_id UUID NOT NULL REFERENCES characters(character_id),
  provider VARCHAR(50) NOT NULL DEFAULT 'elevenlabs', -- elevenlabs, future providers
  provider_voice_id VARCHAR(255), -- external voice ID from provider
  voice_name VARCHAR(255),
  sample_audio_urls JSONB DEFAULT '[]', -- uploaded audio samples
  clone_status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, processing, ready, failed
  consent_record_id UUID REFERENCES consent_records(consent_id),
  quality_score REAL, -- 0-100 non-financial provider quality assessment
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_vcr_character ON voice_clone_records(character_id);
CREATE INDEX idx_vcr_workspace ON voice_clone_records(workspace_id);
ALTER TABLE voice_clone_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE voice_clone_records FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON voice_clone_records
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 22.13 repurpose_jobs (M09 — PRD §36)
```sql
CREATE TABLE repurpose_jobs (
  repurpose_job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  source_asset_id UUID NOT NULL REFERENCES assets(asset_id),
  pipeline_config JSONB NOT NULL DEFAULT '{}', -- {auto_clips, text_posts, thumbnails, carousel, blog, audio, captions, auto_schedule}
  output_asset_ids UUID[] DEFAULT '{}',
  status VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued, processing, completed, partially_completed, failed
  credits_used NUMERIC(18,6) DEFAULT 0, -- DB-H-001: financial precision
  created_by UUID REFERENCES users(user_id),
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ -- soft delete (DB-H-003)
);
CREATE INDEX idx_rj_workspace ON repurpose_jobs(workspace_id);
CREATE INDEX idx_rj_source ON repurpose_jobs(source_asset_id);
ALTER TABLE repurpose_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE repurpose_jobs FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON repurpose_jobs
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

> **Rule (Freeze §46A.8)**: All repurpose outputs = drafts. User MUST approve before publish. Max video length per tier: Free 5min, Starter 30min, Pro 60min, Business 120min.

### 22.14 link_health_records (Pack 08 §5 — Affiliate Link Health)
```sql
CREATE TABLE link_health_records (
  health_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  affiliate_link_id UUID NOT NULL REFERENCES affiliate_links(affiliate_link_id),
  http_status INTEGER,
  product_status VARCHAR(30), -- available, out_of_stock, discontinued, price_changed, unknown
  commission_status VARCHAR(30), -- active, changed, suspended, unknown
  link_status VARCHAR(20) NOT NULL DEFAULT 'healthy', -- healthy, warning, broken, expired
  expiry_date TIMESTAMPTZ,
  suggested_action TEXT,
  checked_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  alert_sent BOOLEAN DEFAULT false,
  estimated_revenue_impact NUMERIC(18,6), -- daily revenue at risk
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_lhr_link ON link_health_records(affiliate_link_id);
CREATE INDEX idx_lhr_status ON link_health_records(link_status);
CREATE INDEX idx_lhr_checked ON link_health_records(checked_at DESC);
ALTER TABLE link_health_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE link_health_records FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON link_health_records
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 22.15 platform_health_scores (M22 — Connector Health)
```sql
CREATE TABLE platform_health_scores (
  score_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  platform VARCHAR(50) NOT NULL,
  connected_account_id UUID REFERENCES connected_accounts(connected_account_id),
  overall_score REAL NOT NULL, -- 0-100 non-financial health score
  api_response_time_ms INTEGER,
  error_rate_pct REAL, -- 0-100 non-financial percentage
  capability_coverage_pct REAL, -- 0-100 non-financial percentage
  last_successful_sync TIMESTAMPTZ,
  degraded_features JSONB DEFAULT '[]',
  score_explanation TEXT,
  captured_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_phs_workspace ON platform_health_scores(workspace_id, platform);
CREATE INDEX idx_phs_captured ON platform_health_scores(captured_at DESC);
ALTER TABLE platform_health_scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE platform_health_scores FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON platform_health_scores
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 22.14 home_dashboard_config (M22 — Audit v6)
```sql
CREATE TABLE home_dashboard_config (
  config_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL UNIQUE REFERENCES workspaces(workspace_id),
  operator_mode VARCHAR(30) NOT NULL DEFAULT 'creator', -- creator, seller, affiliate_operator, live_operator, agency_mcn, brand_collaboration
  card_order_override JSONB, -- NULL = use default per mode. [{card_family, position, hidden}]
  snoozed_cards JSONB DEFAULT '[]', -- [{card_id, snoozed_until}]
  dismissed_cards UUID[] DEFAULT '{}', -- permanently dismissed card IDs
  morning_brief_enabled BOOLEAN DEFAULT true,
  morning_brief_channels JSONB DEFAULT '["push", "email"]', -- ["push", "email", "in_app"]
  morning_brief_time TIME DEFAULT '07:00', -- local time
  onboarding_completed BOOLEAN DEFAULT false,
  onboarding_progress JSONB DEFAULT '{"step": 0, "completed_steps": []}',
  beginner_tips_dismissed BOOLEAN DEFAULT false,
  last_home_visit_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
ALTER TABLE home_dashboard_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE home_dashboard_config FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON home_dashboard_config
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 22.15 monetization_offer_views (M14 — Audit v6)
```sql
CREATE TABLE monetization_offer_views (
  view_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  offer_id UUID NOT NULL REFERENCES offers(offer_id),
  channel VARCHAR(30) NOT NULL, -- link_in_bio, social_post, email, direct, qr_code
  viewer_ip_hash VARCHAR(64), -- SHA-256 hash for dedup, no PII stored
  referrer_url TEXT,
  converted BOOLEAN DEFAULT false,
  conversion_order_id UUID,
  viewed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_mov_offer ON monetization_offer_views(offer_id, viewed_at DESC);
CREATE INDEX idx_mov_workspace ON monetization_offer_views(workspace_id, viewed_at DESC);
ALTER TABLE monetization_offer_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE monetization_offer_views FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON monetization_offer_views
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

Table and policy totals are computed by `python3 tooling/check_docs.py`; counts do not establish semantic or runtime readiness.

---

## 23. Tier C Deferred Object Notes (Audit v5 — M1)

> **Ref**: Pack 02 §3.3. The following Tier C objects from the "Canonical Supporting Entities" list are intentionally NOT stored as standalone PostgreSQL tables. Their data is either embedded in parent aggregates, tracked in specialized stores, or deferred.

| Tier C Object | Storage Strategy | Rationale |
|---|---|---|
| **Click Event** | `api_call_logs` / ClickHouse time-series | High-volume clickstream data is time-series; not relational |
| **Lead** | `entities` table (relationship_state='lead') | Leads are entities with a specific relationship state |
| **Conversion Event** | `content_attribution_records` (§19.15) | Content→revenue attribution already tracked |
| **Creator Payout** | `affiliate_commissions` + `settlements` | Payout is a settlement-linked commission state |
| **Affiliate Statement** | Reconciliation Records + Evidence Objects | Statements are imported evidence for reconciliation |
| **Invoice** | `invoices` + payment-provider reference | Canonical invoice rows retain provider references |
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
| **Prompt Lineage Record** | `generation_jobs.prompt_package` | JSONB within generation job record |
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
  unit_price: string;        // in order currency
  discount: string;          // applied discount
  total: string;             // unit_price * quantity - discount
  unit_cogs: string;         // immutable transaction-time COGS; never recalculate from current catalog
  cogs_source_class: 'official' | 'imported' | 'estimated' | 'inferred' | 'unreconciled';
  variation?: string;        // e.g., "Red, XL"
  platform_item_id?: string; // external platform ref
}
// Column type: OrderItem[]
```

#### `orders.fee_breakdown`
```typescript
interface FeeBreakdown {
  platform_fee: string;
  payment_processing_fee: string;
  shipping_fee: string;
  tax: string;
  commission: string;
  promo_discount: string;
  other_fees: { name: string; amount: string }[];
  total_fees: string;
  currency: string;
}
```

#### `orders.exchange_rate_snapshot` / `settlements.exchange_rate_snapshot`
```typescript
interface ExchangeRateSnapshot {
  base_currency: string;     // workspace base, ISO 4217
  quote_currency: string;    // transaction currency
  rate_to_base: string;      // base units per 1 transaction unit, positive decimal
  provider: string;          // authorized feed or explicit manual input
  captured_at: string;       // RFC3339 UTC
  effective_at: string;
  source_class: 'official' | 'imported' | 'estimated';
}
```
Same-currency rate is exactly "1". Missing FX or COGS is a visible gap and cannot become verified zero. Historical recognition and rounding rules: [Financial computation contract](financial_computation_contract.md).

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


### 25.6 Connector access verification JSONB

`connected_accounts.metadata.access_verifications` and the matching capability projection use:
```typescript
interface ActionAccessVerification {
  action: string; // action from connector_specs.md registry, not arbitrary code
  api_product: string;
  api_version: string;
  endpoint: string;
  method: 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE';
  required_scopes: string[];
  granted_scopes: string[];
  app_approval_status: 'unverified' | 'test_only' | 'approved' | 'rejected';
  account_eligible: boolean;
  markets: string[];
  documentation_url: string;
  evidence_ref: string;
  checked_at: string;
  valid_until: string;
  probe_status: 'not_run' | 'passed' | 'failed';
  restrictions: string[];
}
```

### 25.7 Prompt, pack and workflow graph JSONB shapes

```typescript
interface PromptPackage {
  script_id?: string;
  continuity_pack_versions: {pack_id: string; version: number}[];
  user_prompt: string;
  system_prompt_version: string;
  provider_params: Record<string, string | number | boolean>;
  source_refs: {type: string; id: string}[];
}
interface ContinuitySettings {
  rules: {key: string; value: string; severity: 'warning' | 'block'}[];
  lookbook?: {asset_ids: string[]; notes: string};
  scene_memory?: {scene_refs: string[]; summary: string};
}
interface WorkflowGraph {
  schema_version: 1;
  nodes: {node_id: string; node_type: 'trigger' | 'condition' | 'transform' | 'action' | 'approval' | 'wait' | 'fallback' | 'diagnostics' | 'handoff' | 'terminal'; config: Record<string, unknown>}[];
  edges: {from_node_id: string; to_node_id: string; branch?: 'success' | 'failure' | 'true' | 'false'}[];
}
```

Graph config is a **discriminated typed object per node type**, validated before save/activation: trigger uses TriggerConfig; condition uses allowlisted field/operator/value; transform uses declarative field mappings (no arbitrary eval); action names an inventory RPC and its typed validated input; approval names permitted approver IDs and expiry; wait sets UTC resume time/condition; fallback names a fallback node; diagnostics defines severity/message; handoff names permitted target user; terminal names outcome. No node may store credentials or a raw DB query. Action input must conform to that RPC's compiled contract. Record<string,unknown> above denotes the union representation, not acceptance of unvalidated keys. Cycles are rejected; repeat work uses bounded schedules/cascade rules.

## 26. Execution integrity additions (2026-10-29)

The following are canonical persistence contracts, introduced with their owning P0/P1 slices. Credit transitions are owned by [Credit accounting](credit_accounting_contract.md); monetary recognition by [Financial computation](financial_computation_contract.md); async behavior by [Queue design](../05_system/queue_retry_design.md). These records implement the same canonical graph, not separate shadow business objects.

### 26.1 ai_provider_rates [GLOBAL]
```sql
CREATE TABLE ai_provider_rates (
  rate_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  provider VARCHAR(100) NOT NULL,
  model_id VARCHAR(200) NOT NULL,
  version VARCHAR(100) NOT NULL,
  currency VARCHAR(5) NOT NULL DEFAULT 'USD',
  unit_rates JSONB NOT NULL, -- named decimal rates, units and resolution/audio conditions
  source_url TEXT NOT NULL,
  verified_at TIMESTAMPTZ NOT NULL,
  valid_until TIMESTAMPTZ NOT NULL,
  enabled BOOLEAN NOT NULL DEFAULT false,
  UNIQUE(provider, model_id, version)
);
```

### 26.2 ai_credit_quotes
```sql
CREATE TABLE ai_credit_quotes (
  quote_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  request_hash VARCHAR(128) NOT NULL,
  operation_type VARCHAR(100) NOT NULL,
  rate_version VARCHAR(100) NOT NULL,
  provider_plan JSONB NOT NULL, -- bounded attempts, units and costs; no credentials
  cost_ceiling_usd NUMERIC(18,6) NOT NULL CHECK (cost_ceiling_usd >= 0),
  usd_per_credit_floor NUMERIC(18,6) NOT NULL CHECK (usd_per_credit_floor > 0),
  gross_margin_floor NUMERIC(5,4) NOT NULL CHECK (gross_margin_floor >= 0 AND gross_margin_floor < 1),
  quoted_credits NUMERIC(18,6) NOT NULL CHECK (quoted_credits >= 0),
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
ALTER TABLE ai_credit_quotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_credit_quotes FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON ai_credit_quotes
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 26.3 ai_credit_lots
```sql
CREATE TABLE ai_credit_lots (
  lot_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  source_type VARCHAR(30) NOT NULL CHECK (source_type IN ('subscription','purchased','promotional','overage')),
  granted_credits NUMERIC(18,6) NOT NULL CHECK (granted_credits >= 0),
  remaining_credits NUMERIC(18,6) NOT NULL CHECK (remaining_credits >= 0),
  reserved_credits NUMERIC(18,6) NOT NULL DEFAULT 0,
  expires_at TIMESTAMPTZ,
  external_grant_key VARCHAR(255) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK (reserved_credits >= 0 AND reserved_credits <= remaining_credits AND remaining_credits <= granted_credits),
  CHECK (source_type <> 'purchased' OR expires_at IS NULL),
  CHECK (source_type <> 'subscription' OR expires_at IS NOT NULL),
  UNIQUE(workspace_id, external_grant_key)
);
ALTER TABLE ai_credit_lots ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_credit_lots FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON ai_credit_lots
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 26.4 ai_credit_reservations
```sql
CREATE TABLE ai_credit_reservations (
  reservation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  quote_id UUID NOT NULL REFERENCES ai_credit_quotes(quote_id),
  idempotency_key VARCHAR(255) NOT NULL,
  request_hash VARCHAR(128) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'held' CHECK (status IN ('held','in_flight','reconciling','committed','released','expired')),
  reserved_credits NUMERIC(18,6) NOT NULL CHECK (reserved_credits >= 0),
  actual_credits NUMERIC(18,6),
  expires_at TIMESTAMPTZ NOT NULL,
  last_heartbeat_at TIMESTAMPTZ,
  provider_request_id VARCHAR(255),
  terminal_reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK (actual_credits IS NULL OR (actual_credits >= 0 AND actual_credits <= reserved_credits)),
  UNIQUE(workspace_id, idempotency_key)
);
ALTER TABLE ai_credit_reservations ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_credit_reservations FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON ai_credit_reservations
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 26.5 ai_credit_reservation_allocations
```sql
CREATE TABLE ai_credit_reservation_allocations (
  allocation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  reservation_id UUID NOT NULL REFERENCES ai_credit_reservations(reservation_id),
  lot_id UUID NOT NULL REFERENCES ai_credit_lots(lot_id),
  credits NUMERIC(18,6) NOT NULL CHECK (credits > 0),
  UNIQUE(reservation_id, lot_id)
);
ALTER TABLE ai_credit_reservation_allocations ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_credit_reservation_allocations FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON ai_credit_reservation_allocations
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 26.6 consumer_inbox
```sql
CREATE TABLE consumer_inbox (
  inbox_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  consumer_name VARCHAR(100) NOT NULL,
  event_id UUID NOT NULL,
  processed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, consumer_name, event_id)
);
ALTER TABLE consumer_inbox ENABLE ROW LEVEL SECURITY;
ALTER TABLE consumer_inbox FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON consumer_inbox
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 26.7 api_idempotency_records
```sql
CREATE TABLE api_idempotency_records (
  record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  actor_id UUID NOT NULL,
  rpc VARCHAR(255) NOT NULL,
  idempotency_key VARCHAR(255) NOT NULL,
  request_hash VARCHAR(128) NOT NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('processing','completed','failed')),
  response_payload JSONB,
  response_code INTEGER,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, actor_id, rpc, idempotency_key)
);
ALTER TABLE api_idempotency_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_idempotency_records FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON api_idempotency_records
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 26.8 external_effects
```sql
CREATE TABLE external_effects (
  effect_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  operation_key VARCHAR(255) NOT NULL,
  provider VARCHAR(100) NOT NULL,
  connected_account_id UUID REFERENCES connected_accounts(connected_account_id),
  aggregate_type VARCHAR(100) NOT NULL,
  aggregate_id UUID NOT NULL,
  provider_request_id VARCHAR(255),
  status VARCHAR(20) NOT NULL CHECK (status IN ('prepared','submitted','succeeded','failed','unknown','cancelled')),
  result_payload JSONB,
  last_checked_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, operation_key)
);
ALTER TABLE external_effects ENABLE ROW LEVEL SECURITY;
ALTER TABLE external_effects FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON external_effects
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 26.9 settlement_lines
```sql
CREATE TABLE settlement_lines (
  line_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  settlement_id UUID NOT NULL REFERENCES settlements(settlement_id),
  external_line_id VARCHAR(255) NOT NULL,
  external_order_id VARCHAR(255),
  order_id UUID REFERENCES orders(order_id),
  gross_amount NUMERIC(18,6) NOT NULL,
  fee_amount NUMERIC(18,6) NOT NULL DEFAULT 0,
  refund_amount NUMERIC(18,6) NOT NULL DEFAULT 0,
  net_amount NUMERIC(18,6) NOT NULL,
  matched_amount NUMERIC(18,6) NOT NULL DEFAULT 0,
  currency VARCHAR(5) NOT NULL,
  reconciliation_state reconciliation_state NOT NULL DEFAULT 'imported_only',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, settlement_id, external_line_id)
);
ALTER TABLE settlement_lines ENABLE ROW LEVEL SECURITY;
ALTER TABLE settlement_lines FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON settlement_lines
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 26.10 financial_postings
```sql
CREATE TABLE financial_postings (
  posting_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  origin_type VARCHAR(100) NOT NULL,
  origin_id UUID NOT NULL,
  origin_version VARCHAR(100) NOT NULL,
  component VARCHAR(50) NOT NULL CHECK (component IN ('revenue','platform_fee','shipping','cogs','ai_credits','commission','ads_spend','seeding','refund','other')),
  amount NUMERIC(18,6) NOT NULL, -- signed base-currency effect: revenue positive, costs negative
  currency VARCHAR(5) NOT NULL,
  source_class source_class NOT NULL,
  confidence confidence_band NOT NULL,
  exchange_rate_snapshot JSONB NOT NULL,
  reversal_of UUID REFERENCES financial_postings(posting_id),
  effective_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, origin_type, origin_id, origin_version, component)
);
ALTER TABLE financial_postings ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_postings FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON financial_postings
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
```

### 26.11 Same-tenant referential integrity

UUID-only foreign keys do not establish tenant equality. Install the following constraints after their tables in each slice migration. Polymorphic/JSONB/UUID-array references require an allowlisted type lookup and same-workspace check inside the command transaction; unknown types and foreign IDs return NOT_FOUND. Do not trust a client-supplied workspace ID. Global references are permitted only for explicitly global objects.

```sql
ALTER TABLE ai_credit_transactions ADD CONSTRAINT fk_act_reservation FOREIGN KEY (reservation_id) REFERENCES ai_credit_reservations(reservation_id);
ALTER TABLE ai_credit_transactions ADD CONSTRAINT fk_act_lot FOREIGN KEY (lot_id) REFERENCES ai_credit_lots(lot_id);
ALTER TABLE affiliate_links ADD CONSTRAINT uq_affiliate_links_tenant_pk UNIQUE (workspace_id, affiliate_link_id);
ALTER TABLE agent_runs ADD CONSTRAINT uq_agent_runs_tenant_pk UNIQUE (workspace_id, agent_run_id);
ALTER TABLE ai_credit_lots ADD CONSTRAINT uq_ai_credit_lots_tenant_pk UNIQUE (workspace_id, lot_id);
ALTER TABLE ai_credit_quotes ADD CONSTRAINT uq_ai_credit_quotes_tenant_pk UNIQUE (workspace_id, quote_id);
ALTER TABLE ai_credit_reservations ADD CONSTRAINT uq_ai_credit_reservations_tenant_pk UNIQUE (workspace_id, reservation_id);
ALTER TABLE ai_credit_transactions ADD CONSTRAINT uq_ai_credit_transactions_tenant_pk UNIQUE (workspace_id, transaction_id);
ALTER TABLE api_keys ADD CONSTRAINT uq_api_keys_tenant_pk UNIQUE (workspace_id, api_key_id);
ALTER TABLE api_webhook_subscriptions ADD CONSTRAINT uq_api_webhook_subscriptions_tenant_pk UNIQUE (workspace_id, webhook_subscription_id);
ALTER TABLE asset_briefs ADD CONSTRAINT uq_asset_briefs_tenant_pk UNIQUE (workspace_id, asset_brief_id);
ALTER TABLE assets ADD CONSTRAINT uq_assets_tenant_pk UNIQUE (workspace_id, asset_id);
ALTER TABLE brand_profiles ADD CONSTRAINT uq_brand_profiles_tenant_pk UNIQUE (workspace_id, brand_profile_id);
ALTER TABLE bundles ADD CONSTRAINT uq_bundles_tenant_pk UNIQUE (workspace_id, bundle_id);
ALTER TABLE campaigns ADD CONSTRAINT uq_campaigns_tenant_pk UNIQUE (workspace_id, campaign_id);
ALTER TABLE characters ADD CONSTRAINT uq_characters_tenant_pk UNIQUE (workspace_id, character_id);
ALTER TABLE competitor_entities ADD CONSTRAINT uq_competitor_entities_tenant_pk UNIQUE (workspace_id, competitor_id);
ALTER TABLE connected_accounts ADD CONSTRAINT uq_connected_accounts_tenant_pk UNIQUE (workspace_id, connected_account_id);
ALTER TABLE consent_records ADD CONSTRAINT uq_consent_records_tenant_pk UNIQUE (workspace_id, consent_id);
ALTER TABLE continuity_packs ADD CONSTRAINT uq_continuity_packs_tenant_pk UNIQUE (workspace_id, pack_id);
ALTER TABLE entities ADD CONSTRAINT uq_entities_tenant_pk UNIQUE (workspace_id, entity_id);
ALTER TABLE financial_postings ADD CONSTRAINT uq_financial_postings_tenant_pk UNIQUE (workspace_id, posting_id);
ALTER TABLE generation_jobs ADD CONSTRAINT uq_generation_jobs_tenant_pk UNIQUE (workspace_id, job_id);
ALTER TABLE ideas ADD CONSTRAINT uq_ideas_tenant_pk UNIQUE (workspace_id, idea_id);
ALTER TABLE inventory_locations ADD CONSTRAINT uq_inventory_locations_tenant_pk UNIQUE (workspace_id, location_id);
ALTER TABLE link_in_bio_pages ADD CONSTRAINT uq_link_in_bio_pages_tenant_pk UNIQUE (workspace_id, page_id);
ALTER TABLE live_segments ADD CONSTRAINT uq_live_segments_tenant_pk UNIQUE (workspace_id, segment_id);
ALTER TABLE live_sessions ADD CONSTRAINT uq_live_sessions_tenant_pk UNIQUE (workspace_id, session_id);
ALTER TABLE membership_plans ADD CONSTRAINT uq_membership_plans_tenant_pk UNIQUE (workspace_id, plan_id);
ALTER TABLE notifications ADD CONSTRAINT uq_notifications_tenant_pk UNIQUE (workspace_id, notification_id);
ALTER TABLE offers ADD CONSTRAINT uq_offers_tenant_pk UNIQUE (workspace_id, offer_id);
ALTER TABLE opportunities ADD CONSTRAINT uq_opportunities_tenant_pk UNIQUE (workspace_id, opportunity_id);
ALTER TABLE orders ADD CONSTRAINT uq_orders_tenant_pk UNIQUE (workspace_id, order_id);
ALTER TABLE policy_notes ADD CONSTRAINT uq_policy_notes_tenant_pk UNIQUE (workspace_id, policy_note_id);
ALTER TABLE product_skus ADD CONSTRAINT uq_product_skus_tenant_pk UNIQUE (workspace_id, sku_id);
ALTER TABLE products ADD CONSTRAINT uq_products_tenant_pk UNIQUE (workspace_id, product_id);
ALTER TABLE publish_items ADD CONSTRAINT uq_publish_items_tenant_pk UNIQUE (workspace_id, publish_item_id);
ALTER TABLE publish_jobs ADD CONSTRAINT uq_publish_jobs_tenant_pk UNIQUE (workspace_id, publish_job_id);
ALTER TABLE rate_cards ADD CONSTRAINT uq_rate_cards_tenant_pk UNIQUE (workspace_id, rate_card_id);
ALTER TABLE recipe_templates ADD CONSTRAINT uq_recipe_templates_tenant_pk UNIQUE (workspace_id, recipe_id);
ALTER TABLE refunds ADD CONSTRAINT uq_refunds_tenant_pk UNIQUE (workspace_id, refund_id);
ALTER TABLE sample_requests ADD CONSTRAINT uq_sample_requests_tenant_pk UNIQUE (workspace_id, request_id);
ALTER TABLE scenes ADD CONSTRAINT uq_scenes_tenant_pk UNIQUE (workspace_id, scene_id);
ALTER TABLE scripts ADD CONSTRAINT uq_scripts_tenant_pk UNIQUE (workspace_id, script_id);
ALTER TABLE settlements ADD CONSTRAINT uq_settlements_tenant_pk UNIQUE (workspace_id, settlement_id);
ALTER TABLE signals ADD CONSTRAINT uq_signals_tenant_pk UNIQUE (workspace_id, signal_id);
ALTER TABLE subscriptions ADD CONSTRAINT uq_subscriptions_tenant_pk UNIQUE (workspace_id, subscription_id);
ALTER TABLE support_tickets ADD CONSTRAINT uq_support_tickets_tenant_pk UNIQUE (workspace_id, ticket_id);
ALTER TABLE tags ADD CONSTRAINT uq_tags_tenant_pk UNIQUE (workspace_id, tag_id);
ALTER TABLE threads ADD CONSTRAINT uq_threads_tenant_pk UNIQUE (workspace_id, thread_id);
ALTER TABLE trends ADD CONSTRAINT uq_trends_tenant_pk UNIQUE (workspace_id, trend_id);
ALTER TABLE video_edit_jobs ADD CONSTRAINT uq_video_edit_jobs_tenant_pk UNIQUE (workspace_id, job_id);
ALTER TABLE workflow_runs ADD CONSTRAINT uq_workflow_runs_tenant_pk UNIQUE (workspace_id, run_id);
ALTER TABLE workflows ADD CONSTRAINT uq_workflows_tenant_pk UNIQUE (workspace_id, workflow_id);
ALTER TABLE trend_signals ADD CONSTRAINT fk_trend_signals_trend_id_tenant FOREIGN KEY (workspace_id, trend_id) REFERENCES trends(workspace_id, trend_id);
ALTER TABLE trend_signals ADD CONSTRAINT fk_trend_signals_signal_id_tenant FOREIGN KEY (workspace_id, signal_id) REFERENCES signals(workspace_id, signal_id);
ALTER TABLE opportunity_sources ADD CONSTRAINT fk_opportunity_sources_opportunity_id_tenant FOREIGN KEY (workspace_id, opportunity_id) REFERENCES opportunities(workspace_id, opportunity_id);
ALTER TABLE benchmark_snapshots ADD CONSTRAINT fk_benchmark_snapshots_competitor_id_tenant FOREIGN KEY (workspace_id, competitor_id) REFERENCES competitor_entities(workspace_id, competitor_id);
ALTER TABLE idea_sources ADD CONSTRAINT fk_idea_sources_idea_id_tenant FOREIGN KEY (workspace_id, idea_id) REFERENCES ideas(workspace_id, idea_id);
ALTER TABLE hooks ADD CONSTRAINT fk_hooks_idea_id_tenant FOREIGN KEY (workspace_id, idea_id) REFERENCES ideas(workspace_id, idea_id);
ALTER TABLE scripts ADD CONSTRAINT fk_scripts_idea_id_tenant FOREIGN KEY (workspace_id, idea_id) REFERENCES ideas(workspace_id, idea_id);
ALTER TABLE asset_briefs ADD CONSTRAINT fk_asset_briefs_script_id_tenant FOREIGN KEY (workspace_id, script_id) REFERENCES scripts(workspace_id, script_id);
ALTER TABLE scenes ADD CONSTRAINT fk_scenes_script_id_tenant FOREIGN KEY (workspace_id, script_id) REFERENCES scripts(workspace_id, script_id);
ALTER TABLE shot_lists ADD CONSTRAINT fk_shot_lists_scene_id_tenant FOREIGN KEY (workspace_id, scene_id) REFERENCES scenes(workspace_id, scene_id);
ALTER TABLE continuity_packs ADD CONSTRAINT fk_continuity_packs_character_id_tenant FOREIGN KEY (workspace_id, character_id) REFERENCES characters(workspace_id, character_id);
ALTER TABLE assets ADD CONSTRAINT fk_assets_script_id_tenant FOREIGN KEY (workspace_id, script_id) REFERENCES scripts(workspace_id, script_id);
ALTER TABLE assets ADD CONSTRAINT fk_assets_asset_brief_id_tenant FOREIGN KEY (workspace_id, asset_brief_id) REFERENCES asset_briefs(workspace_id, asset_brief_id);
ALTER TABLE assets ADD CONSTRAINT fk_assets_parent_asset_id_tenant FOREIGN KEY (workspace_id, parent_asset_id) REFERENCES assets(workspace_id, asset_id);
ALTER TABLE generation_jobs ADD CONSTRAINT fk_generation_jobs_asset_id_tenant FOREIGN KEY (workspace_id, asset_id) REFERENCES assets(workspace_id, asset_id);
ALTER TABLE continuity_violations ADD CONSTRAINT fk_continuity_violations_asset_id_tenant FOREIGN KEY (workspace_id, asset_id) REFERENCES assets(workspace_id, asset_id);
ALTER TABLE continuity_violations ADD CONSTRAINT fk_continuity_violations_pack_id_tenant FOREIGN KEY (workspace_id, pack_id) REFERENCES continuity_packs(workspace_id, pack_id);
ALTER TABLE publish_items ADD CONSTRAINT fk_publish_items_asset_id_tenant FOREIGN KEY (workspace_id, asset_id) REFERENCES assets(workspace_id, asset_id);
ALTER TABLE publish_items ADD CONSTRAINT fk_publish_items_target_account_id_tenant FOREIGN KEY (workspace_id, target_account_id) REFERENCES connected_accounts(workspace_id, connected_account_id);
ALTER TABLE publish_jobs ADD CONSTRAINT fk_publish_jobs_publish_item_id_tenant FOREIGN KEY (workspace_id, publish_item_id) REFERENCES publish_items(workspace_id, publish_item_id);
ALTER TABLE publish_logs ADD CONSTRAINT fk_publish_logs_publish_job_id_tenant FOREIGN KEY (workspace_id, publish_job_id) REFERENCES publish_jobs(workspace_id, publish_job_id);
ALTER TABLE publish_logs ADD CONSTRAINT fk_publish_logs_publish_item_id_tenant FOREIGN KEY (workspace_id, publish_item_id) REFERENCES publish_items(workspace_id, publish_item_id);
ALTER TABLE threads ADD CONSTRAINT fk_threads_entity_id_tenant FOREIGN KEY (workspace_id, entity_id) REFERENCES entities(workspace_id, entity_id);
ALTER TABLE messages ADD CONSTRAINT fk_messages_thread_id_tenant FOREIGN KEY (workspace_id, thread_id) REFERENCES threads(workspace_id, thread_id);
ALTER TABLE messages ADD CONSTRAINT fk_messages_author_entity_id_tenant FOREIGN KEY (workspace_id, author_entity_id) REFERENCES entities(workspace_id, entity_id);
ALTER TABLE follow_up_tasks ADD CONSTRAINT fk_follow_up_tasks_source_thread_id_tenant FOREIGN KEY (workspace_id, source_thread_id) REFERENCES threads(workspace_id, thread_id);
ALTER TABLE product_skus ADD CONSTRAINT fk_product_skus_product_id_tenant FOREIGN KEY (workspace_id, product_id) REFERENCES products(workspace_id, product_id);
ALTER TABLE offers ADD CONSTRAINT fk_offers_product_id_tenant FOREIGN KEY (workspace_id, product_id) REFERENCES products(workspace_id, product_id);
ALTER TABLE orders ADD CONSTRAINT fk_orders_connected_account_id_tenant FOREIGN KEY (workspace_id, connected_account_id) REFERENCES connected_accounts(workspace_id, connected_account_id);
ALTER TABLE orders ADD CONSTRAINT fk_orders_product_id_tenant FOREIGN KEY (workspace_id, product_id) REFERENCES products(workspace_id, product_id);
ALTER TABLE orders ADD CONSTRAINT fk_orders_offer_id_tenant FOREIGN KEY (workspace_id, offer_id) REFERENCES offers(workspace_id, offer_id);
ALTER TABLE orders ADD CONSTRAINT fk_orders_customer_entity_id_tenant FOREIGN KEY (workspace_id, customer_entity_id) REFERENCES entities(workspace_id, entity_id);
ALTER TABLE affiliate_links ADD CONSTRAINT fk_affiliate_links_product_id_tenant FOREIGN KEY (workspace_id, product_id) REFERENCES products(workspace_id, product_id);
ALTER TABLE affiliate_links ADD CONSTRAINT fk_affiliate_links_offer_id_tenant FOREIGN KEY (workspace_id, offer_id) REFERENCES offers(workspace_id, offer_id);
ALTER TABLE affiliate_commissions ADD CONSTRAINT fk_affiliate_commissions_affiliate_link_id_tenant FOREIGN KEY (workspace_id, affiliate_link_id) REFERENCES affiliate_links(workspace_id, affiliate_link_id);
ALTER TABLE affiliate_commissions ADD CONSTRAINT fk_affiliate_commissions_order_id_tenant FOREIGN KEY (workspace_id, order_id) REFERENCES orders(workspace_id, order_id);
ALTER TABLE settlements ADD CONSTRAINT fk_settlements_connected_account_id_tenant FOREIGN KEY (workspace_id, connected_account_id) REFERENCES connected_accounts(workspace_id, connected_account_id);
ALTER TABLE live_sessions ADD CONSTRAINT fk_live_sessions_connected_account_id_tenant FOREIGN KEY (workspace_id, connected_account_id) REFERENCES connected_accounts(workspace_id, connected_account_id);
ALTER TABLE workflow_runs ADD CONSTRAINT fk_workflow_runs_workflow_id_tenant FOREIGN KEY (workspace_id, workflow_id) REFERENCES workflows(workspace_id, workflow_id);
ALTER TABLE agent_runs ADD CONSTRAINT fk_agent_runs_recipe_id_tenant FOREIGN KEY (workspace_id, recipe_id) REFERENCES recipe_templates(workspace_id, recipe_id);
ALTER TABLE agent_runs ADD CONSTRAINT fk_agent_runs_workflow_id_tenant FOREIGN KEY (workspace_id, workflow_id) REFERENCES workflows(workspace_id, workflow_id);
ALTER TABLE workflow_run_steps ADD CONSTRAINT fk_workflow_run_steps_run_id_tenant FOREIGN KEY (workspace_id, run_id) REFERENCES workflow_runs(workspace_id, run_id);
ALTER TABLE agent_run_steps ADD CONSTRAINT fk_agent_run_steps_agent_run_id_tenant FOREIGN KEY (workspace_id, agent_run_id) REFERENCES agent_runs(workspace_id, agent_run_id);
ALTER TABLE agent_outputs ADD CONSTRAINT fk_agent_outputs_agent_run_id_tenant FOREIGN KEY (workspace_id, agent_run_id) REFERENCES agent_runs(workspace_id, agent_run_id);
ALTER TABLE ai_credit_transactions ADD CONSTRAINT fk_ai_credit_transactions_reference_transaction_id_tenant FOREIGN KEY (workspace_id, reference_transaction_id) REFERENCES ai_credit_transactions(workspace_id, transaction_id);
ALTER TABLE link_items ADD CONSTRAINT fk_link_items_page_id_tenant FOREIGN KEY (workspace_id, page_id) REFERENCES link_in_bio_pages(workspace_id, page_id);
ALTER TABLE media_kits ADD CONSTRAINT fk_media_kits_brand_profile_id_tenant FOREIGN KEY (workspace_id, brand_profile_id) REFERENCES brand_profiles(workspace_id, brand_profile_id);
ALTER TABLE rate_card_items ADD CONSTRAINT fk_rate_card_items_rate_card_id_tenant FOREIGN KEY (workspace_id, rate_card_id) REFERENCES rate_cards(workspace_id, rate_card_id);
ALTER TABLE support_ticket_messages ADD CONSTRAINT fk_support_ticket_messages_ticket_id_tenant FOREIGN KEY (workspace_id, ticket_id) REFERENCES support_tickets(workspace_id, ticket_id);
ALTER TABLE fallback_paths ADD CONSTRAINT fk_fallback_paths_related_policy_note_id_tenant FOREIGN KEY (workspace_id, related_policy_note_id) REFERENCES policy_notes(workspace_id, policy_note_id);
ALTER TABLE api_keys ADD CONSTRAINT fk_api_keys_logical_key_id_tenant FOREIGN KEY (workspace_id, logical_key_id) REFERENCES api_keys(workspace_id, api_key_id);
ALTER TABLE api_keys ADD CONSTRAINT fk_api_keys_replaced_by_key_id_tenant FOREIGN KEY (workspace_id, replaced_by_key_id) REFERENCES api_keys(workspace_id, api_key_id);
ALTER TABLE api_usage_daily ADD CONSTRAINT fk_api_usage_daily_api_key_id_tenant FOREIGN KEY (workspace_id, api_key_id) REFERENCES api_keys(workspace_id, api_key_id);
ALTER TABLE api_webhook_subscriptions ADD CONSTRAINT fk_api_webhook_subscriptions_api_key_id_tenant FOREIGN KEY (workspace_id, api_key_id) REFERENCES api_keys(workspace_id, api_key_id);
ALTER TABLE webhook_events ADD CONSTRAINT fk_webhook_events_webhook_subscription_id_tenant FOREIGN KEY (workspace_id, webhook_subscription_id) REFERENCES api_webhook_subscriptions(workspace_id, webhook_subscription_id);
ALTER TABLE notification_events ADD CONSTRAINT fk_notification_events_notification_id_tenant FOREIGN KEY (workspace_id, notification_id) REFERENCES notifications(workspace_id, notification_id);
ALTER TABLE taggables ADD CONSTRAINT fk_taggables_tag_id_tenant FOREIGN KEY (workspace_id, tag_id) REFERENCES tags(workspace_id, tag_id);
ALTER TABLE invoices ADD CONSTRAINT fk_invoices_subscription_id_tenant FOREIGN KEY (workspace_id, subscription_id) REFERENCES subscriptions(workspace_id, subscription_id);
ALTER TABLE membership_subscriptions ADD CONSTRAINT fk_membership_subscriptions_plan_id_tenant FOREIGN KEY (workspace_id, plan_id) REFERENCES membership_plans(workspace_id, plan_id);
ALTER TABLE membership_subscriptions ADD CONSTRAINT fk_membership_subscriptions_customer_entity_id_tenant FOREIGN KEY (workspace_id, customer_entity_id) REFERENCES entities(workspace_id, entity_id);
ALTER TABLE refunds ADD CONSTRAINT fk_refunds_order_id_tenant FOREIGN KEY (workspace_id, order_id) REFERENCES orders(workspace_id, order_id);
ALTER TABLE refunds ADD CONSTRAINT fk_refunds_settlement_id_tenant FOREIGN KEY (workspace_id, settlement_id) REFERENCES settlements(workspace_id, settlement_id);
ALTER TABLE returns ADD CONSTRAINT fk_returns_order_id_tenant FOREIGN KEY (workspace_id, order_id) REFERENCES orders(workspace_id, order_id);
ALTER TABLE returns ADD CONSTRAINT fk_returns_refund_id_tenant FOREIGN KEY (workspace_id, refund_id) REFERENCES refunds(workspace_id, refund_id);
ALTER TABLE bundles ADD CONSTRAINT fk_bundles_offer_id_tenant FOREIGN KEY (workspace_id, offer_id) REFERENCES offers(workspace_id, offer_id);
ALTER TABLE bundle_items ADD CONSTRAINT fk_bundle_items_bundle_id_tenant FOREIGN KEY (workspace_id, bundle_id) REFERENCES bundles(workspace_id, bundle_id);
ALTER TABLE bundle_items ADD CONSTRAINT fk_bundle_items_product_id_tenant FOREIGN KEY (workspace_id, product_id) REFERENCES products(workspace_id, product_id);
ALTER TABLE live_segments ADD CONSTRAINT fk_live_segments_session_id_tenant FOREIGN KEY (workspace_id, session_id) REFERENCES live_sessions(workspace_id, session_id);
ALTER TABLE live_segments ADD CONSTRAINT fk_live_segments_pinned_offer_id_tenant FOREIGN KEY (workspace_id, pinned_offer_id) REFERENCES offers(workspace_id, offer_id);
ALTER TABLE cue_cards ADD CONSTRAINT fk_cue_cards_session_id_tenant FOREIGN KEY (workspace_id, session_id) REFERENCES live_sessions(workspace_id, session_id);
ALTER TABLE cue_cards ADD CONSTRAINT fk_cue_cards_segment_id_tenant FOREIGN KEY (workspace_id, segment_id) REFERENCES live_segments(workspace_id, segment_id);
ALTER TABLE cue_cards ADD CONSTRAINT fk_cue_cards_pinned_product_id_tenant FOREIGN KEY (workspace_id, pinned_product_id) REFERENCES products(workspace_id, product_id);
ALTER TABLE cue_cards ADD CONSTRAINT fk_cue_cards_pinned_offer_id_tenant FOREIGN KEY (workspace_id, pinned_offer_id) REFERENCES offers(workspace_id, offer_id);
ALTER TABLE highlights ADD CONSTRAINT fk_highlights_session_id_tenant FOREIGN KEY (workspace_id, session_id) REFERENCES live_sessions(workspace_id, session_id);
ALTER TABLE highlights ADD CONSTRAINT fk_highlights_asset_id_tenant FOREIGN KEY (workspace_id, asset_id) REFERENCES assets(workspace_id, asset_id);
ALTER TABLE channel_posts ADD CONSTRAINT fk_channel_posts_publish_item_id_tenant FOREIGN KEY (workspace_id, publish_item_id) REFERENCES publish_items(workspace_id, publish_item_id);
ALTER TABLE channel_posts ADD CONSTRAINT fk_channel_posts_connected_account_id_tenant FOREIGN KEY (workspace_id, connected_account_id) REFERENCES connected_accounts(workspace_id, connected_account_id);
ALTER TABLE stock_movements ADD CONSTRAINT fk_stock_movements_sku_id_tenant FOREIGN KEY (workspace_id, sku_id) REFERENCES product_skus(workspace_id, sku_id);
ALTER TABLE stock_movements ADD CONSTRAINT fk_stock_movements_location_id_tenant FOREIGN KEY (workspace_id, location_id) REFERENCES inventory_locations(workspace_id, location_id);
ALTER TABLE sample_requests ADD CONSTRAINT fk_sample_requests_campaign_id_tenant FOREIGN KEY (workspace_id, campaign_id) REFERENCES campaigns(workspace_id, campaign_id);
ALTER TABLE sample_requests ADD CONSTRAINT fk_sample_requests_product_id_tenant FOREIGN KEY (workspace_id, product_id) REFERENCES products(workspace_id, product_id);
ALTER TABLE sample_requests ADD CONSTRAINT fk_sample_requests_creator_entity_id_tenant FOREIGN KEY (workspace_id, creator_entity_id) REFERENCES entities(workspace_id, entity_id);
ALTER TABLE sample_shipments ADD CONSTRAINT fk_sample_shipments_request_id_tenant FOREIGN KEY (workspace_id, request_id) REFERENCES sample_requests(workspace_id, request_id);
ALTER TABLE chargebacks ADD CONSTRAINT fk_chargebacks_order_id_tenant FOREIGN KEY (workspace_id, order_id) REFERENCES orders(workspace_id, order_id);
ALTER TABLE content_attribution_records ADD CONSTRAINT fk_content_attribution_records_publish_item_id_tenant FOREIGN KEY (workspace_id, publish_item_id) REFERENCES publish_items(workspace_id, publish_item_id);
ALTER TABLE content_attribution_records ADD CONSTRAINT fk_content_attribution_records_order_id_tenant FOREIGN KEY (workspace_id, order_id) REFERENCES orders(workspace_id, order_id);
ALTER TABLE video_edit_jobs ADD CONSTRAINT fk_video_edit_jobs_generation_job_id_tenant FOREIGN KEY (workspace_id, generation_job_id) REFERENCES generation_jobs(workspace_id, job_id);
ALTER TABLE video_edit_jobs ADD CONSTRAINT fk_video_edit_jobs_character_id_tenant FOREIGN KEY (workspace_id, character_id) REFERENCES characters(workspace_id, character_id);
ALTER TABLE video_edit_jobs ADD CONSTRAINT fk_video_edit_jobs_brand_pack_id_tenant FOREIGN KEY (workspace_id, brand_pack_id) REFERENCES continuity_packs(workspace_id, pack_id);
ALTER TABLE remix_blueprints ADD CONSTRAINT fk_remix_blueprints_reference_asset_id_tenant FOREIGN KEY (workspace_id, reference_asset_id) REFERENCES assets(workspace_id, asset_id);
ALTER TABLE remix_blueprints ADD CONSTRAINT fk_remix_blueprints_output_asset_id_tenant FOREIGN KEY (workspace_id, output_asset_id) REFERENCES assets(workspace_id, asset_id);
ALTER TABLE remix_blueprints ADD CONSTRAINT fk_remix_blueprints_video_edit_job_id_tenant FOREIGN KEY (workspace_id, video_edit_job_id) REFERENCES video_edit_jobs(workspace_id, job_id);
ALTER TABLE clip_collections ADD CONSTRAINT fk_clip_collections_source_asset_id_tenant FOREIGN KEY (workspace_id, source_asset_id) REFERENCES assets(workspace_id, asset_id);
ALTER TABLE clip_collections ADD CONSTRAINT fk_clip_collections_video_edit_job_id_tenant FOREIGN KEY (workspace_id, video_edit_job_id) REFERENCES video_edit_jobs(workspace_id, job_id);
ALTER TABLE product_showcase_jobs ADD CONSTRAINT fk_product_showcase_jobs_video_edit_job_id_tenant FOREIGN KEY (workspace_id, video_edit_job_id) REFERENCES video_edit_jobs(workspace_id, job_id);
ALTER TABLE product_showcase_jobs ADD CONSTRAINT fk_product_showcase_jobs_product_id_tenant FOREIGN KEY (workspace_id, product_id) REFERENCES products(workspace_id, product_id);
ALTER TABLE product_showcase_jobs ADD CONSTRAINT fk_product_showcase_jobs_output_asset_id_tenant FOREIGN KEY (workspace_id, output_asset_id) REFERENCES assets(workspace_id, asset_id);
ALTER TABLE product_showcase_jobs ADD CONSTRAINT fk_product_showcase_jobs_character_id_tenant FOREIGN KEY (workspace_id, character_id) REFERENCES characters(workspace_id, character_id);
ALTER TABLE link_to_video_jobs ADD CONSTRAINT fk_link_to_video_jobs_video_edit_job_id_tenant FOREIGN KEY (workspace_id, video_edit_job_id) REFERENCES video_edit_jobs(workspace_id, job_id);
ALTER TABLE link_to_video_jobs ADD CONSTRAINT fk_link_to_video_jobs_output_asset_id_tenant FOREIGN KEY (workspace_id, output_asset_id) REFERENCES assets(workspace_id, asset_id);
ALTER TABLE link_to_video_jobs ADD CONSTRAINT fk_link_to_video_jobs_character_id_tenant FOREIGN KEY (workspace_id, character_id) REFERENCES characters(workspace_id, character_id);
ALTER TABLE translation_jobs ADD CONSTRAINT fk_translation_jobs_video_edit_job_id_tenant FOREIGN KEY (workspace_id, video_edit_job_id) REFERENCES video_edit_jobs(workspace_id, job_id);
ALTER TABLE translation_jobs ADD CONSTRAINT fk_translation_jobs_source_asset_id_tenant FOREIGN KEY (workspace_id, source_asset_id) REFERENCES assets(workspace_id, asset_id);
ALTER TABLE style_packs ADD CONSTRAINT fk_style_packs_source_asset_id_tenant FOREIGN KEY (workspace_id, source_asset_id) REFERENCES assets(workspace_id, asset_id);
ALTER TABLE style_packs ADD CONSTRAINT fk_style_packs_continuity_pack_id_tenant FOREIGN KEY (workspace_id, continuity_pack_id) REFERENCES continuity_packs(workspace_id, pack_id);
ALTER TABLE ab_test_experiments ADD CONSTRAINT fk_ab_test_experiments_source_asset_id_tenant FOREIGN KEY (workspace_id, source_asset_id) REFERENCES assets(workspace_id, asset_id);
ALTER TABLE ab_test_experiments ADD CONSTRAINT fk_ab_test_experiments_winner_asset_id_tenant FOREIGN KEY (workspace_id, winner_asset_id) REFERENCES assets(workspace_id, asset_id);
ALTER TABLE voice_clone_records ADD CONSTRAINT fk_voice_clone_records_character_id_tenant FOREIGN KEY (workspace_id, character_id) REFERENCES characters(workspace_id, character_id);
ALTER TABLE voice_clone_records ADD CONSTRAINT fk_voice_clone_records_consent_record_id_tenant FOREIGN KEY (workspace_id, consent_record_id) REFERENCES consent_records(workspace_id, consent_id);
ALTER TABLE repurpose_jobs ADD CONSTRAINT fk_repurpose_jobs_source_asset_id_tenant FOREIGN KEY (workspace_id, source_asset_id) REFERENCES assets(workspace_id, asset_id);
ALTER TABLE link_health_records ADD CONSTRAINT fk_link_health_records_affiliate_link_id_tenant FOREIGN KEY (workspace_id, affiliate_link_id) REFERENCES affiliate_links(workspace_id, affiliate_link_id);
ALTER TABLE platform_health_scores ADD CONSTRAINT fk_platform_health_scores_connected_account_id_tenant FOREIGN KEY (workspace_id, connected_account_id) REFERENCES connected_accounts(workspace_id, connected_account_id);
ALTER TABLE monetization_offer_views ADD CONSTRAINT fk_monetization_offer_views_offer_id_tenant FOREIGN KEY (workspace_id, offer_id) REFERENCES offers(workspace_id, offer_id);
ALTER TABLE ai_credit_reservations ADD CONSTRAINT fk_ai_credit_reservations_quote_id_tenant FOREIGN KEY (workspace_id, quote_id) REFERENCES ai_credit_quotes(workspace_id, quote_id);
ALTER TABLE ai_credit_reservation_allocations ADD CONSTRAINT fk_ai_credit_reservation_allocations_reservation_id_tenant FOREIGN KEY (workspace_id, reservation_id) REFERENCES ai_credit_reservations(workspace_id, reservation_id);
ALTER TABLE ai_credit_reservation_allocations ADD CONSTRAINT fk_ai_credit_reservation_allocations_lot_id_tenant FOREIGN KEY (workspace_id, lot_id) REFERENCES ai_credit_lots(workspace_id, lot_id);
ALTER TABLE external_effects ADD CONSTRAINT fk_external_effects_connected_account_id_tenant FOREIGN KEY (workspace_id, connected_account_id) REFERENCES connected_accounts(workspace_id, connected_account_id);
ALTER TABLE settlement_lines ADD CONSTRAINT fk_settlement_lines_settlement_id_tenant FOREIGN KEY (workspace_id, settlement_id) REFERENCES settlements(workspace_id, settlement_id);
ALTER TABLE settlement_lines ADD CONSTRAINT fk_settlement_lines_order_id_tenant FOREIGN KEY (workspace_id, order_id) REFERENCES orders(workspace_id, order_id);
ALTER TABLE financial_postings ADD CONSTRAINT fk_financial_postings_reversal_of_tenant FOREIGN KEY (workspace_id, reversal_of) REFERENCES financial_postings(workspace_id, posting_id);
ALTER TABLE ai_credit_transactions ADD CONSTRAINT fk_act_reservation_tenant FOREIGN KEY (workspace_id, reservation_id) REFERENCES ai_credit_reservations(workspace_id, reservation_id);
ALTER TABLE ai_credit_transactions ADD CONSTRAINT fk_act_lot_tenant FOREIGN KEY (workspace_id, lot_id) REFERENCES ai_credit_lots(workspace_id, lot_id);
```


### 26.12 Runtime role grants and immutability

Bootstrap creates `app_user` and `admin_user` as NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS. `outbox_poller` is a dedicated BYPASSRLS role with access only to outbox routing records; domain workers use app_user and set validated tenant context per message. Never give the API migration credentials, TRUNCATE, DDL ownership, or internal-admin table privileges.

The migration role owns tables. Remove blanket default grants. After each migration, grant only installed tables from the allowlist below (absent future-phase tables are not errors in a slice migration). No runtime role receives `GRANT ALL`.

```sql
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO app_user, admin_user, outbox_poller;
GRANT SELECT, INSERT, UPDATE, DELETE ON workspaces TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON users TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON workspace_members TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON brand_profiles TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON connected_accounts TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON signals TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON trends TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON trend_signals TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON opportunities TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON opportunity_sources TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON competitor_entities TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON benchmark_snapshots TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON watchlists TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ideas TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON idea_sources TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON hooks TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON scripts TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON asset_briefs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON scenes TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON shot_lists TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON characters TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON continuity_packs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON assets TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON generation_jobs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON continuity_violations TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON publish_items TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON publish_jobs TO app_user;
GRANT SELECT, INSERT ON publish_logs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON entities TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON threads TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON messages TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON follow_up_tasks TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON products TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON product_skus TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON offers TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON orders TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON affiliate_links TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON affiliate_commissions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON campaigns TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON settlements TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON cost_items TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON profit_snapshots TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON evidence_objects TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON proof_bundles TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON live_sessions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON workflows TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON workflow_runs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON recipe_templates TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON agent_runs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON workflow_run_steps TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON agent_run_steps TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON agent_outputs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON billing_events TO app_user;
GRANT SELECT, INSERT ON ai_credit_transactions TO app_user;
GRANT SELECT, INSERT ON audit_events TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON notifications TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON creator_progress TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON achievement_records TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON api_call_logs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON link_in_bio_pages TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON link_items TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON media_kits TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON rate_cards TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON rate_card_items TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON brand_deals TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON support_tickets TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON support_ticket_messages TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON approval_requests TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON capability_snapshots TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON policy_notes TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON fallback_paths TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON consent_records TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON api_keys TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON api_usage_daily TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON api_webhook_subscriptions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON webhook_events TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON tags TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON taggables TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON file_uploads TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON export_jobs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON user_preferences TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON subscriptions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON invoices TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON payment_methods TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON coupons TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON store_pages TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON membership_plans TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON refunds TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON returns TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON bundles TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON bundle_items TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON price_rules TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON live_segments TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON cue_cards TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON highlights TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON channel_posts TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON reconciliation_records TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON inventory_locations TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON stock_movements TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON sample_requests TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON sample_shipments TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON copilot_sessions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON chargebacks TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON content_attribution_records TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON video_edit_jobs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON remix_blueprints TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON clip_collections TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON product_showcase_jobs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON link_to_video_jobs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON translation_jobs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON style_packs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON performance_reports TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ab_test_experiments TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON challenge_progress TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON voice_clone_records TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON repurpose_jobs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON link_health_records TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON platform_health_scores TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON home_dashboard_config TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON monetization_offer_views TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ai_credit_quotes TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ai_credit_lots TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ai_credit_reservations TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ai_credit_reservation_allocations TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON consumer_inbox TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON api_idempotency_records TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON external_effects TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON settlement_lines TO app_user;
GRANT SELECT, INSERT ON financial_postings TO app_user;
GRANT SELECT ON regions TO app_user;
GRANT SELECT ON currencies TO app_user;
GRANT SELECT ON achievement_definitions TO app_user;
GRANT SELECT ON challenge_definitions TO app_user;
GRANT SELECT ON ai_provider_rates TO app_user;
GRANT INSERT ON event_outbox TO app_user;
GRANT SELECT, UPDATE ON event_outbox TO outbox_poller;
GRANT USAGE, SELECT ON SEQUENCE event_outbox_outbox_id_seq TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON admin_sessions TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON background_jobs TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON broadcast_targets TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON broadcasts TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON dead_letter_queue TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON diagnostics_records TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON event_outbox TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON feature_flags TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON fraud_cases TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON impersonation_sessions TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON incidents TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON internal_admins TO admin_user;
GRANT SELECT, INSERT ON internal_audit_logs TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON job_metrics TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON job_schedules TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON kb_article_versions TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON moderation_cases TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON notification_events TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON platform_fee_schedules TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON platform_health_metrics TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON post_mortems TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON scheduled_job_configs TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON system_alerts TO admin_user;
GRANT SELECT, INSERT, UPDATE ON users TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON support_tickets, support_ticket_messages TO admin_user;
CREATE POLICY admin_user_directory ON users TO admin_user USING (true);
CREATE POLICY admin_ticket_access ON support_tickets TO admin_user USING (true);
CREATE POLICY admin_ticket_messages ON support_ticket_messages TO admin_user USING (true);
```

Admin access to ordinary tenant objects uses an explicitly validated target workspace and operation-scoped service permission through the domain command layer; admin identity alone does not inherit `app_user` or bypass RLS. Global KB/public projections are read through narrowly granted functions/views that filter publication and visibility; their definitions and allowed columns must ship with the owning slice. Secrets, drafts, internal notes and user-directory rows are never broadly granted to app_user.

Evidence content (`content_hash`, `file_url`, `payload`, provenance) and postings are append-only. Verification metadata may change with an audit event. A migration installs a BEFORE UPDATE/DELETE guard for evidence content and revokes UPDATE/DELETE for the append-only tables above. Legally required erasure is a separately authorized maintenance operation with deletion evidence, not an ordinary API mutation. Direct tenant fixture tests must verify these grants and guards; do not certify immutability from prose alone.

### 26.13 Profile visibility, system templates and immutable evidence guards

```sql
CREATE POLICY member_profile_read ON users FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM workspace_members wm
    WHERE wm.user_id = users.user_id
      AND wm.workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
      AND wm.status = 'active'
  ));
CREATE FUNCTION protect_evidence_content() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    RAISE EXCEPTION 'evidence content is immutable';
  END IF;
  IF (NEW.evidence_id, NEW.workspace_id, NEW.evidence_type, NEW.source_provenance,
      NEW.content_hash, NEW.file_url, NEW.payload, NEW.collected_at, NEW.related_object_refs, NEW.created_at)
      IS DISTINCT FROM
     (OLD.evidence_id, OLD.workspace_id, OLD.evidence_type, OLD.source_provenance,
      OLD.content_hash, OLD.file_url, OLD.payload, OLD.collected_at, OLD.related_object_refs, OLD.created_at)
     OR NEW.deleted_at IS DISTINCT FROM OLD.deleted_at THEN
    RAISE EXCEPTION 'evidence content is immutable';
  END IF;
  RETURN NEW;
END
$$;
CREATE TRIGGER evidence_content_immutable BEFORE UPDATE OR DELETE ON evidence_objects
  FOR EACH ROW EXECUTE FUNCTION protect_evidence_content();
```

Template install clones a published system template into a tenant-owned canonical recipe before agent/run references are created. This permits public template discovery without allowing a tenant to mutate global recipes or attach a foreign tenant's recipe. Profile reads expose only the authorized response projection; user preferences remain user-scoped even inside a shared workspace.

Privileged cross-workspace operations are restricted to the admin service and explicitly granted operational tables:
```sql
CREATE POLICY admin_ops_scope ON moderation_cases TO admin_user USING (true);
CREATE POLICY admin_ops_scope ON broadcast_targets TO admin_user USING (true);
CREATE POLICY admin_ops_scope ON notification_events TO admin_user USING (true);
CREATE POLICY admin_ops_scope ON background_jobs TO admin_user USING (true);
CREATE POLICY admin_ops_scope ON dead_letter_queue TO admin_user USING (true);
CREATE POLICY admin_ops_scope ON event_outbox TO admin_user USING (true);
CREATE POLICY admin_ops_scope ON diagnostics_records TO admin_user USING (true);
CREATE POLICY admin_ops_scope ON platform_health_metrics TO admin_user USING (true);
```

### 26.14 Owner identity integrity

```sql
ALTER TABLE workspaces ADD CONSTRAINT fk_workspaces_owner FOREIGN KEY (owner_user_id) REFERENCES users(user_id);
CREATE UNIQUE INDEX idx_one_active_workspace_owner ON workspace_members(workspace_id)
  WHERE role = 'owner' AND status = 'active';
```

Owner transfer updates memberships and workspaces.owner_user_id in one transaction. A command cannot commit with no active owner or a mismatched owner row; the service invariant and adversarial transfer tests enforce existence, while the partial unique index forbids two active owners.

-- +goose Up
-- P0-04: Canonical Tenant Schema, Roles/Grants, Direct RLS, Composite Same-Tenant FKs,
-- Owner Identity Integrity, Immutable Evidence Trigger, and Private Projection Boundaries.
-- Canonical contract: docs/04_contracts/database_schema.md (§1, §3–§6, §8, §10, §11, §13, §16–§19, §26, §27.2)

-- +goose StatementBegin
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_user') THEN
    CREATE ROLE app_user NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS;
  ELSE
    ALTER ROLE app_user NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'admin_user') THEN
    CREATE ROLE admin_user NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS;
  ELSE
    ALTER ROLE admin_user NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'outbox_poller') THEN
    CREATE ROLE outbox_poller NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT BYPASSRLS;
  ELSE
    ALTER ROLE outbox_poller NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT BYPASSRLS;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'directory_reader') THEN
    CREATE ROLE directory_reader NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS;
  ELSE
    ALTER ROLE directory_reader NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS;
  END IF;
END
$$;
-- +goose StatementEnd

-- 3. Core Enums
-- +goose StatementBegin
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'source_class') THEN
    CREATE TYPE source_class AS ENUM (
      'official',
      'imported',
      'inferred',
      'estimated',
      'unreconciled'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'confidence_band') THEN
    CREATE TYPE confidence_band AS ENUM (
      'high',
      'medium_high',
      'medium',
      'low_medium',
      'low'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'operator_mode') THEN
    CREATE TYPE operator_mode AS ENUM (
      'creator',
      'seller',
      'affiliate_operator',
      'live_operator',
      'agency_mcn',
      'brand_collaboration'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'reconciliation_state') THEN
    CREATE TYPE reconciliation_state AS ENUM (
      'imported_only',
      'estimated',
      'awaiting_evidence',
      'partially_matched',
      'reconciled',
      'disputed',
      'adjusted',
      'closed'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'verification_status') THEN
    CREATE TYPE verification_status AS ENUM (
      'pending',
      'verified',
      'disputed',
      'superseded'
    );
  END IF;
END
$$;
-- +goose StatementEnd

-- 4.0 regions & currencies [GLOBAL]
CREATE TABLE IF NOT EXISTS regions (
  region_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(10) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  default_currency_code VARCHAR(5) NOT NULL,
  date_format VARCHAR(20) DEFAULT 'DD/MM/YYYY',
  number_format JSONB DEFAULT '{"decimal":".","thousands":","}'
);

CREATE TABLE IF NOT EXISTS currencies (
  currency_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(5) UNIQUE NOT NULL,
  symbol VARCHAR(10) NOT NULL,
  decimal_places SMALLINT NOT NULL DEFAULT 2,
  display_format VARCHAR(50)
);

-- 4.1 workspaces & users & workspace_members
CREATE TABLE IF NOT EXISTS workspaces (
  workspace_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_type VARCHAR(50) NOT NULL DEFAULT 'standard',
  clerk_organization_id VARCHAR(255) UNIQUE,
  external_org_id VARCHAR(255) UNIQUE,
  source_updated_at TIMESTAMPTZ,
  name VARCHAR(255) NOT NULL DEFAULT '',
  display_name VARCHAR(255) NOT NULL DEFAULT '',
  slug VARCHAR(100) UNIQUE NOT NULL,
  referral_code VARCHAR(20) UNIQUE,
  owner_user_id UUID NOT NULL,
  primary_region_id UUID REFERENCES regions(region_id),
  primary_currency_id UUID REFERENCES currencies(currency_id),
  subscription_tier VARCHAR(20) NOT NULL DEFAULT 'free'
    CHECK (subscription_tier IN ('free','starter','pro','business','enterprise')),
  default_mode operator_mode NOT NULL DEFAULT 'creator',
  default_operator_mode operator_mode NOT NULL DEFAULT 'creator',
  enabled_modes operator_mode[] NOT NULL DEFAULT '{creator}',
  ai_credits_remaining NUMERIC(18,6) NOT NULL DEFAULT 30,
  ai_credits_reserved NUMERIC(18,6) NOT NULL DEFAULT 0,
  ai_credits_monthly_limit NUMERIC(18,6) NOT NULL DEFAULT 30,
  billing_cycle_start DATE,
  CHECK (ai_credits_remaining >= 0 AND ai_credits_reserved >= 0 AND ai_credits_reserved <= ai_credits_remaining),
  storage_used_bytes BIGINT NOT NULL DEFAULT 0,
  storage_limit_bytes BIGINT NOT NULL DEFAULT 1073741824,
  settings JSONB NOT NULL DEFAULT '{}',
  locale VARCHAR(10) NOT NULL DEFAULT 'vi-VN',
  timezone VARCHAR(50) NOT NULL DEFAULT 'Asia/Ho_Chi_Minh',
  status VARCHAR(20) NOT NULL DEFAULT 'active'
    CHECK (status IN ('active','suspended','cancelled','deleted')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  clerk_id VARCHAR(255) UNIQUE,
  external_auth_id VARCHAR(255) UNIQUE,
  source_updated_at TIMESTAMPTZ,
  email VARCHAR(255) UNIQUE NOT NULL,
  display_name VARCHAR(255) NOT NULL DEFAULT '',
  avatar_url TEXT,
  locale VARCHAR(10) NOT NULL DEFAULT 'vi-VN',
  timezone VARCHAR(50) NOT NULL DEFAULT 'Asia/Ho_Chi_Minh',
  notification_prefs JSONB NOT NULL DEFAULT '{}',
  onboarding_completed BOOLEAN NOT NULL DEFAULT false,
  onboarding_step SMALLINT NOT NULL DEFAULT 0,
  status VARCHAR(20) NOT NULL DEFAULT 'active'
    CHECK (status IN ('active','suspended','banned','deleted')),
  last_login_at TIMESTAMPTZ,
  last_active_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- §26.14 Owner identity integrity: workspaces.owner_user_id -> users.user_id
ALTER TABLE workspaces
  ADD CONSTRAINT fk_workspaces_owner FOREIGN KEY (owner_user_id) REFERENCES users(user_id);

CREATE TABLE IF NOT EXISTS workspace_members (
  member_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_member_id UUID NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  clerk_membership_id VARCHAR(255) UNIQUE,
  external_membership_id VARCHAR(255) UNIQUE,
  source_updated_at TIMESTAMPTZ,
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  user_id UUID NOT NULL REFERENCES users(user_id),
  role VARCHAR(30) NOT NULL DEFAULT 'viewer'
    CHECK (role IN ('owner','admin','manager','editor','contributor','viewer','external','client_reviewer')),
  status VARCHAR(20) NOT NULL DEFAULT 'active'
    CHECK (status IN ('invited','active','suspended','revoked','removed')),
  invited_by UUID REFERENCES users(user_id),
  invited_at TIMESTAMPTZ,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_wm_workspace ON workspace_members(workspace_id);
CREATE INDEX IF NOT EXISTS idx_wm_user ON workspace_members(user_id);

-- §26.14 Partial unique index enforcing at most one active Owner per workspace
CREATE UNIQUE INDEX IF NOT EXISTS idx_one_active_workspace_owner
  ON workspace_members(workspace_id)
  WHERE role = 'owner' AND status = 'active';

-- §4.1 RLS on workspaces & workspace_members
ALTER TABLE workspaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE workspaces FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON workspaces
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
    OR owner_user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
    OR owner_user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid);

CREATE POLICY workspace_discovery ON workspaces FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM workspace_members wm
    WHERE wm.workspace_id = workspaces.workspace_id
      AND wm.user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid
      AND wm.status = 'active'
  ));

ALTER TABLE workspace_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE workspace_members FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON workspace_members
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
    OR user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
    OR user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid);

-- §4.1 RLS on users
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE users FORCE ROW LEVEL SECURITY;
CREATE POLICY user_self ON users
  USING (user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid)
  WITH CHECK (user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid);

CREATE POLICY member_profile_read ON users FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM workspace_members wm
    WHERE wm.user_id = users.user_id
      AND wm.workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
      AND wm.status = 'active'
  ));

CREATE POLICY admin_user_directory ON users TO admin_user
  USING (true);

-- §4.2 brand_profiles
CREATE TABLE IF NOT EXISTS brand_profiles (
  brand_profile_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  name VARCHAR(255) NOT NULL,
  tone_of_voice TEXT,
  visual_style JSONB DEFAULT '{}',
  forbidden_words TEXT[],
  cta_templates JSONB DEFAULT '[]',
  bio_templates JSONB DEFAULT '[]',
  is_default BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  CONSTRAINT uq_brand_profiles_tenant_pk UNIQUE (workspace_id, brand_profile_id)
);
CREATE INDEX IF NOT EXISTS idx_bp_workspace ON brand_profiles(workspace_id);
ALTER TABLE brand_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE brand_profiles FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON brand_profiles
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- §4.3 connected_accounts (contains encrypted token secrets that must never be serialized)
CREATE TABLE IF NOT EXISTS connected_accounts (
  connected_account_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  platform VARCHAR(50) NOT NULL,
  account_type VARCHAR(50) NOT NULL,
  external_account_id VARCHAR(255) NOT NULL,
  display_name VARCHAR(255),
  avatar_url TEXT,
  access_token_encrypted BYTEA,
  refresh_token_encrypted BYTEA,
  token_expires_at TIMESTAMPTZ,
  granted_scopes TEXT[],
  connection_state VARCHAR(30) NOT NULL DEFAULT 'connected'
    CHECK (connection_state IN ('connected','degraded','expired','reauth_required','revoked','unavailable')),
  last_synced_at TIMESTAMPTZ,
  last_health_check_at TIMESTAMPTZ,
  health_details JSONB DEFAULT '{}',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  UNIQUE(workspace_id, platform, external_account_id),
  CONSTRAINT uq_connected_accounts_tenant_pk UNIQUE (workspace_id, connected_account_id)
);
CREATE INDEX IF NOT EXISTS idx_ca_workspace ON connected_accounts(workspace_id);
CREATE INDEX IF NOT EXISTS idx_ca_platform ON connected_accounts(platform);
CREATE INDEX IF NOT EXISTS idx_ca_state ON connected_accounts(connection_state);
ALTER TABLE connected_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE connected_accounts FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON connected_accounts
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- §18.9 user_preferences
CREATE TABLE IF NOT EXISTS user_preferences (
  preference_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pref_id UUID NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  user_id UUID NOT NULL REFERENCES users(user_id),
  workspace_id UUID REFERENCES workspaces(workspace_id),
  category VARCHAR(30) DEFAULT 'display'
    CHECK (category IN ('ai','notification','display','editor','privacy')),
  preferences JSONB NOT NULL DEFAULT '{}',
  notification_email BOOLEAN DEFAULT true,
  notification_push BOOLEAN DEFAULT true,
  notification_in_app BOOLEAN DEFAULT true,
  quiet_hours_start TIME,
  quiet_hours_end TIME,
  morning_brief_enabled BOOLEAN DEFAULT true,
  morning_brief_channel VARCHAR(20) DEFAULT 'push',
  onboarding_completed BOOLEAN NOT NULL DEFAULT false,
  onboarding_progress JSONB NOT NULL DEFAULT '{"completed_steps": []}',
  theme VARCHAR(10) DEFAULT 'system',
  sidebar_collapsed BOOLEAN DEFAULT false,
  default_view_mode VARCHAR(20) DEFAULT 'grid',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, workspace_id),
  UNIQUE(user_id, workspace_id, category)
);
CREATE INDEX IF NOT EXISTS idx_up_user ON user_preferences(user_id);
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_preferences FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON user_preferences
  USING (user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid
    AND (workspace_id IS NULL OR workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid))
  WITH CHECK (user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid
    AND (workspace_id IS NULL OR workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid));

-- §5.1–§5.5 Intelligence tables & direct-junction tables (signals, trends, trend_signals, opportunities, opportunity_sources, competitor_entities)
CREATE TABLE IF NOT EXISTS signals (
  signal_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  source_platform VARCHAR(50) NOT NULL,
  source_class source_class NOT NULL DEFAULT 'imported',
  signal_type VARCHAR(50) NOT NULL,
  raw_payload JSONB NOT NULL,
  extracted_text TEXT,
  external_url TEXT,
  metrics_snapshot JSONB DEFAULT '{}',
  confidence confidence_band NOT NULL DEFAULT 'medium',
  freshness_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_signals_tenant_pk UNIQUE (workspace_id, signal_id)
);
CREATE INDEX IF NOT EXISTS idx_signals_workspace_time ON signals(workspace_id, created_at DESC);
ALTER TABLE signals ENABLE ROW LEVEL SECURITY;
ALTER TABLE signals FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON signals
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS trends (
  trend_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  title VARCHAR(500) NOT NULL,
  summary TEXT,
  category VARCHAR(100),
  platforms VARCHAR(50)[] NOT NULL DEFAULT '{}',
  velocity_score REAL DEFAULT 0,
  relevance_score REAL DEFAULT 0,
  commercial_potential_score REAL DEFAULT 0,
  saturation_level VARCHAR(20) DEFAULT 'low',
  recommended_window_hours INTEGER,
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'emerging'
    CHECK (lifecycle_state IN ('emerging','rising','peaking','declining','expired','archived')),
  signal_count INTEGER NOT NULL DEFAULT 1,
  confidence confidence_band NOT NULL DEFAULT 'medium',
  source_classes source_class[] NOT NULL DEFAULT '{inferred}',
  first_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  CONSTRAINT uq_trends_tenant_pk UNIQUE (workspace_id, trend_id)
);
CREATE INDEX IF NOT EXISTS idx_trends_workspace_state ON trends(workspace_id, lifecycle_state);
ALTER TABLE trends ENABLE ROW LEVEL SECURITY;
ALTER TABLE trends FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON trends
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- §5.2 trend_signals (direct junction table with direct RLS + composite tenant FKs)
CREATE TABLE IF NOT EXISTS trend_signals (
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  trend_id UUID NOT NULL REFERENCES trends(trend_id) ON DELETE CASCADE,
  signal_id UUID NOT NULL REFERENCES signals(signal_id) ON DELETE CASCADE,
  PRIMARY KEY (trend_id, signal_id),
  CONSTRAINT fk_trend_signals_trend_id_tenant
    FOREIGN KEY (workspace_id, trend_id) REFERENCES trends(workspace_id, trend_id) ON DELETE CASCADE,
  CONSTRAINT fk_trend_signals_signal_id_tenant
    FOREIGN KEY (workspace_id, signal_id) REFERENCES signals(workspace_id, signal_id) ON DELETE CASCADE
);
ALTER TABLE trend_signals ENABLE ROW LEVEL SECURITY;
ALTER TABLE trend_signals FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON trend_signals
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS opportunities (
  opportunity_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  title VARCHAR(500) NOT NULL,
  hypothesis TEXT NOT NULL,
  opportunity_type VARCHAR(50) NOT NULL,
  overall_score REAL NOT NULL DEFAULT 0,
  score_breakdown JSONB NOT NULL DEFAULT '{}',
  confidence confidence_band NOT NULL DEFAULT 'medium',
  source_classes source_class[] NOT NULL DEFAULT '{inferred}',
  recommended_actions JSONB NOT NULL DEFAULT '[]',
  status VARCHAR(20) NOT NULL DEFAULT 'new'
    CHECK (status IN ('new','saved','acted','converted','dismissed','expired')),
  converted_to_type VARCHAR(50),
  converted_to_id UUID,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  CONSTRAINT uq_opportunities_tenant_pk UNIQUE (workspace_id, opportunity_id)
);
CREATE INDEX IF NOT EXISTS idx_opp_workspace_status ON opportunities(workspace_id, status);
ALTER TABLE opportunities ENABLE ROW LEVEL SECURITY;
ALTER TABLE opportunities FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON opportunities
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- §5.4 opportunity_sources (direct junction table with direct RLS + composite tenant FK)
CREATE TABLE IF NOT EXISTS opportunity_sources (
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  opportunity_id UUID NOT NULL REFERENCES opportunities(opportunity_id) ON DELETE CASCADE,
  source_type VARCHAR(50) NOT NULL,
  source_id UUID NOT NULL,
  PRIMARY KEY (opportunity_id, source_type, source_id),
  CONSTRAINT fk_opportunity_sources_opportunity_id_tenant
    FOREIGN KEY (workspace_id, opportunity_id) REFERENCES opportunities(workspace_id, opportunity_id) ON DELETE CASCADE
);
ALTER TABLE opportunity_sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE opportunity_sources FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON opportunity_sources
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- §5.5 competitor_entities (includes private notes field)
CREATE TABLE IF NOT EXISTS competitor_entities (
  competitor_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  name VARCHAR(255) NOT NULL,
  entity_type VARCHAR(50) NOT NULL,
  platform_handles JSONB NOT NULL DEFAULT '[]',
  category VARCHAR(100),
  watchlist_group VARCHAR(100),
  notes TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  CONSTRAINT uq_competitor_entities_tenant_pk UNIQUE (workspace_id, competitor_id)
);
CREATE INDEX IF NOT EXISTS idx_comp_workspace ON competitor_entities(workspace_id);
ALTER TABLE competitor_entities ENABLE ROW LEVEL SECURITY;
ALTER TABLE competitor_entities FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON competitor_entities
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- §6.1 & §6.2 ideas & idea_sources (direct junction table)
CREATE TABLE IF NOT EXISTS ideas (
  idea_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  title VARCHAR(500) NOT NULL,
  angle TEXT,
  hook_suggestion TEXT,
  target_persona VARCHAR(255),
  recommended_formats VARCHAR(50)[] DEFAULT '{}',
  recommended_platforms VARCHAR(50)[] DEFAULT '{}',
  score REAL DEFAULT 0,
  score_breakdown JSONB DEFAULT '{}',
  commercial_link_ids UUID[] DEFAULT '{}',
  status VARCHAR(30) NOT NULL DEFAULT 'captured'
    CHECK (status IN ('captured','scored','shortlisted','scheduled','in_script','converted','rejected','archived')),
  rejection_reason VARCHAR(255),
  converted_to_type VARCHAR(50),
  converted_to_id UUID,
  created_by UUID REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  CONSTRAINT uq_ideas_tenant_pk UNIQUE (workspace_id, idea_id)
);
CREATE INDEX IF NOT EXISTS idx_ideas_workspace ON ideas(workspace_id);
CREATE INDEX IF NOT EXISTS idx_ideas_status ON ideas(status);
ALTER TABLE ideas ENABLE ROW LEVEL SECURITY;
ALTER TABLE ideas FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON ideas
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS idea_sources (
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  idea_id UUID NOT NULL REFERENCES ideas(idea_id),
  source_type VARCHAR(50) NOT NULL,
  source_id UUID NOT NULL,
  PRIMARY KEY (idea_id, source_type, source_id),
  CONSTRAINT fk_idea_sources_idea_id_tenant
    FOREIGN KEY (workspace_id, idea_id) REFERENCES ideas(workspace_id, idea_id)
);
ALTER TABLE idea_sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE idea_sources FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON idea_sources
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- §9.1 & §9.2 entities & threads
CREATE TABLE IF NOT EXISTS entities (
  entity_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  entity_type VARCHAR(30) NOT NULL,
  display_name VARCHAR(255),
  platform_handles JSONB DEFAULT '[]',
  relationship_state VARCHAR(30),
  tags JSONB DEFAULT '[]',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  CONSTRAINT uq_entities_tenant_pk UNIQUE (workspace_id, entity_id)
);
CREATE INDEX IF NOT EXISTS idx_entities_workspace ON entities(workspace_id);
ALTER TABLE entities ENABLE ROW LEVEL SECURITY;
ALTER TABLE entities FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON entities
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS threads (
  thread_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  thread_type VARCHAR(30) NOT NULL,
  entity_id UUID REFERENCES entities(entity_id),
  source_platform VARCHAR(50),
  source_post_id VARCHAR(255),
  owner_user_id UUID REFERENCES users(user_id),
  intent VARCHAR(50),
  priority VARCHAR(10) NOT NULL DEFAULT 'normal',
  status VARCHAR(30) NOT NULL DEFAULT 'new'
    CHECK (status IN ('new','triaged','active','waiting_on_user','waiting_on_team','snoozed','stale','converted_to_task','resolved','archived')),
  next_action TEXT,
  sla_due_at TIMESTAMPTZ,
  related_object_refs JSONB DEFAULT '[]',
  last_activity_at TIMESTAMPTZ DEFAULT NOW(),
  message_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  CONSTRAINT uq_threads_tenant_pk UNIQUE (workspace_id, thread_id),
  CONSTRAINT fk_threads_entity_id_tenant
    FOREIGN KEY (workspace_id, entity_id) REFERENCES entities(workspace_id, entity_id)
);
CREATE INDEX IF NOT EXISTS idx_threads_workspace ON threads(workspace_id);
ALTER TABLE threads ENABLE ROW LEVEL SECURITY;
ALTER TABLE threads FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON threads
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- §10.1–§10.2 & §19.7 products, product_skus, offers, bundles, bundle_items (direct junction table)
CREATE TABLE IF NOT EXISTS products (
  product_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  product_type VARCHAR(30) NOT NULL,
  title VARCHAR(500) NOT NULL,
  description TEXT,
  category VARCHAR(100),
  base_price NUMERIC(18,6),
  currency VARCHAR(5) DEFAULT 'VND',
  cogs NUMERIC(18,6),
  catalog_status VARCHAR(20) NOT NULL DEFAULT 'draft',
  inventory_enabled BOOLEAN DEFAULT false,
  external_refs JSONB DEFAULT '[]',
  images JSONB DEFAULT '[]',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  CONSTRAINT uq_products_tenant_pk UNIQUE (workspace_id, product_id)
);
CREATE INDEX IF NOT EXISTS idx_products_workspace ON products(workspace_id);
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE products FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON products
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS product_skus (
  sku_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  product_id UUID NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
  sku_code VARCHAR(100) NOT NULL,
  variant_attributes JSONB NOT NULL DEFAULT '{}',
  price_override NUMERIC(18,6),
  cogs_override NUMERIC(18,6),
  currency VARCHAR(5) DEFAULT 'VND',
  stock_quantity INTEGER DEFAULT 0,
  stock_reserved INTEGER DEFAULT 0,
  low_stock_threshold INTEGER DEFAULT 5,
  barcode VARCHAR(100),
  weight_grams INTEGER,
  is_active BOOLEAN DEFAULT true,
  external_refs JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  CONSTRAINT uq_product_skus_tenant_pk UNIQUE (workspace_id, sku_id),
  CONSTRAINT fk_product_skus_product_id_tenant
    FOREIGN KEY (workspace_id, product_id) REFERENCES products(workspace_id, product_id) ON DELETE CASCADE
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_product_skus_code ON product_skus(workspace_id, product_id, sku_code);
ALTER TABLE product_skus ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_skus FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON product_skus
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS offers (
  offer_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  offer_type VARCHAR(30) NOT NULL,
  product_id UUID REFERENCES products(product_id),
  product_less_declaration VARCHAR(50),
  title VARCHAR(500) NOT NULL,
  pricing_value NUMERIC(18,6),
  pricing_currency VARCHAR(5) DEFAULT 'VND',
  pricing_logic JSONB DEFAULT '{}',
  cta_text VARCHAR(100),
  cta_url TEXT,
  channel_availability JSONB DEFAULT '[]',
  lifecycle_state VARCHAR(20) NOT NULL DEFAULT 'draft'
    CHECK (lifecycle_state IN ('draft','review_required','active','paused','expired','retired')),
  campaign_ids UUID[] DEFAULT '{}',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  CONSTRAINT uq_offers_tenant_pk UNIQUE (workspace_id, offer_id),
  CONSTRAINT fk_offers_product_id_tenant
    FOREIGN KEY (workspace_id, product_id) REFERENCES products(workspace_id, product_id)
);
CREATE INDEX IF NOT EXISTS idx_offers_workspace ON offers(workspace_id);
ALTER TABLE offers ENABLE ROW LEVEL SECURITY;
ALTER TABLE offers FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON offers
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS bundles (
  bundle_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  title VARCHAR(255) NOT NULL,
  offer_id UUID REFERENCES offers(offer_id),
  bundle_price NUMERIC(18,6),
  discount_pct NUMERIC(5,2),
  status VARCHAR(20) NOT NULL DEFAULT 'draft',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  CONSTRAINT uq_bundles_tenant_pk UNIQUE (workspace_id, bundle_id),
  CONSTRAINT fk_bundles_offer_id_tenant
    FOREIGN KEY (workspace_id, offer_id) REFERENCES offers(workspace_id, offer_id)
);
ALTER TABLE bundles ENABLE ROW LEVEL SECURITY;
ALTER TABLE bundles FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON bundles
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS bundle_items (
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  bundle_id UUID NOT NULL REFERENCES bundles(bundle_id),
  product_id UUID NOT NULL REFERENCES products(product_id),
  quantity INTEGER NOT NULL DEFAULT 1,
  PRIMARY KEY (bundle_id, product_id),
  CONSTRAINT fk_bundle_items_bundle_id_tenant
    FOREIGN KEY (workspace_id, bundle_id) REFERENCES bundles(workspace_id, bundle_id),
  CONSTRAINT fk_bundle_items_product_id_tenant
    FOREIGN KEY (workspace_id, product_id) REFERENCES products(workspace_id, product_id)
);
ALTER TABLE bundle_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE bundle_items FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON bundle_items
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- §11.4 & §26.13 evidence_objects + immutability trigger protect_evidence_content()
CREATE TABLE IF NOT EXISTS evidence_objects (
  evidence_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  evidence_type VARCHAR(50) NOT NULL,
  source_provenance VARCHAR(100),
  content_hash VARCHAR(128) NOT NULL,
  file_url TEXT,
  payload JSONB,
  collected_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  verification_status verification_status NOT NULL DEFAULT 'pending',
  related_object_refs JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);
ALTER TABLE evidence_objects ENABLE ROW LEVEL SECURITY;
ALTER TABLE evidence_objects FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON evidence_objects
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION protect_evidence_content() RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    RAISE EXCEPTION 'evidence_objects cannot be hard-deleted';
  END IF;
  IF NEW.workspace_id IS DISTINCT FROM OLD.workspace_id
     OR NEW.evidence_type IS DISTINCT FROM OLD.evidence_type
     OR NEW.source_provenance IS DISTINCT FROM OLD.source_provenance
     OR NEW.content_hash IS DISTINCT FROM OLD.content_hash
     OR NEW.file_url IS DISTINCT FROM OLD.file_url
     OR NEW.payload IS DISTINCT FROM OLD.payload
     OR NEW.collected_at IS DISTINCT FROM OLD.collected_at
     OR NEW.created_at IS DISTINCT FROM OLD.created_at THEN
    RAISE EXCEPTION 'evidence content is immutable; create a superseding evidence object';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- +goose StatementEnd

DROP TRIGGER IF EXISTS trg_protect_evidence_content ON evidence_objects;
CREATE TRIGGER trg_protect_evidence_content
  BEFORE UPDATE OR DELETE ON evidence_objects
  FOR EACH ROW EXECUTE FUNCTION protect_evidence_content();

-- §13.1–§13.3 billing_events, ai_credit_transactions, audit_events
CREATE TABLE IF NOT EXISTS billing_events (
  billing_event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  event_type VARCHAR(50) NOT NULL,
  stripe_event_id VARCHAR(255),
  amount NUMERIC(18,6),
  currency VARCHAR(5),
  subscription_tier VARCHAR(20),
  credits_change NUMERIC(18,6),
  description TEXT,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_be_workspace ON billing_events(workspace_id);
ALTER TABLE billing_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE billing_events FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON billing_events
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS ai_credit_transactions (
  transaction_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  transaction_type VARCHAR(40) NOT NULL,
  credits NUMERIC(18,6) NOT NULL,
  balance_after NUMERIC(18,6) NOT NULL,
  operation_type VARCHAR(50),
  generation_job_id UUID,
  estimated_cost NUMERIC(18,6),
  actual_cost NUMERIC(18,6),
  reservation_id UUID,
  lot_id UUID,
  idempotency_key VARCHAR(255),
  reference_transaction_id UUID REFERENCES ai_credit_transactions(transaction_id),
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_ai_credit_transactions_tenant_pk UNIQUE (workspace_id, transaction_id),
  CONSTRAINT fk_ai_credit_transactions_reference_transaction_id_tenant
    FOREIGN KEY (workspace_id, reference_transaction_id) REFERENCES ai_credit_transactions(workspace_id, transaction_id)
);
CREATE INDEX IF NOT EXISTS idx_act_workspace ON ai_credit_transactions(workspace_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_act_idempotency ON ai_credit_transactions(workspace_id, idempotency_key)
  WHERE idempotency_key IS NOT NULL;
ALTER TABLE ai_credit_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_credit_transactions FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON ai_credit_transactions
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS audit_events (
  audit_event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID,
  actor_user_id UUID,
  actor_type VARCHAR(20) NOT NULL DEFAULT 'user',
  action VARCHAR(100) NOT NULL,
  resource_type VARCHAR(50) NOT NULL,
  resource_id UUID,
  changes JSONB,
  reason TEXT,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_ae_workspace ON audit_events(workspace_id);
CREATE INDEX IF NOT EXISTS idx_ae_resource ON audit_events(resource_type, resource_id);
CREATE INDEX IF NOT EXISTS idx_ae_created ON audit_events(created_at DESC);
ALTER TABLE audit_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_events FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON audit_events
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- §16.3 & §27.2 media_kits (tenant_isolation TO app_user + public_directory_read TO directory_reader)
CREATE TABLE IF NOT EXISTS media_kits (
  media_kit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  template VARCHAR(50) NOT NULL DEFAULT 'professional',
  sections JSONB NOT NULL DEFAULT '[]',
  brand_profile_id UUID REFERENCES brand_profiles(brand_profile_id),
  share_url TEXT,
  directory_opt_in BOOLEAN NOT NULL DEFAULT false,
  directory_status VARCHAR(20) NOT NULL DEFAULT 'hidden'
    CHECK (directory_status IN ('hidden','pending_review','published')),
  directory_profile JSONB NOT NULL DEFAULT '{}',
  directory_consented_at TIMESTAMPTZ,
  last_generated_at TIMESTAMPTZ,
  generation_credits_used NUMERIC(18,6) DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  CONSTRAINT fk_media_kits_brand_profile_id_tenant
    FOREIGN KEY (workspace_id, brand_profile_id) REFERENCES brand_profiles(workspace_id, brand_profile_id)
);
ALTER TABLE media_kits ENABLE ROW LEVEL SECURITY;
ALTER TABLE media_kits FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON media_kits TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
CREATE POLICY public_directory_read ON media_kits FOR SELECT TO directory_reader
  USING (directory_opt_in AND directory_status = 'published' AND deleted_at IS NULL);

-- §16.5 brand_deals (contains private notes)
CREATE TABLE IF NOT EXISTS brand_deals (
  deal_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  brand_name VARCHAR(255) NOT NULL,
  contact_email VARCHAR(255),
  deal_type VARCHAR(30) NOT NULL,
  value NUMERIC(18,6),
  currency VARCHAR(5) DEFAULT 'VND',
  status VARCHAR(20) NOT NULL DEFAULT 'negotiating',
  deadline DATE,
  deliverables TEXT,
  contract_evidence_ids UUID[] NOT NULL DEFAULT '{}',
  inquiry_thread_id UUID REFERENCES threads(thread_id),
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  CONSTRAINT fk_brand_deals_inquiry_thread_id_tenant
    FOREIGN KEY (workspace_id, inquiry_thread_id) REFERENCES threads(workspace_id, thread_id)
);
CREATE INDEX IF NOT EXISTS idx_bd_workspace ON brand_deals(workspace_id);
ALTER TABLE brand_deals ENABLE ROW LEVEL SECURITY;
ALTER TABLE brand_deals FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON brand_deals
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- §17.1–§17.3 & §17.10 internal_admins, admin_sessions, internal_audit_logs, impersonation_sessions [GLOBAL]
CREATE TABLE IF NOT EXISTS internal_admins (
  admin_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  display_name VARCHAR(255) NOT NULL,
  password_hash TEXT NOT NULL,
  role VARCHAR(30) NOT NULL
    CHECK (role IN ('super_admin','ops_admin','finance_admin','content_admin','support_admin','tech_admin','analyst','auditor')),
  status VARCHAR(20) NOT NULL DEFAULT 'active'
    CHECK (status IN ('active','suspended','revoked')),
  mfa_secret_encrypted BYTEA,
  mfa_enabled BOOLEAN NOT NULL DEFAULT false,
  last_login_at TIMESTAMPTZ,
  last_login_ip INET,
  password_changed_at TIMESTAMPTZ DEFAULT NOW(),
  failed_login_count SMALLINT DEFAULT 0,
  max_concurrent_sessions SMALLINT DEFAULT 1,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS admin_sessions (
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
CREATE INDEX IF NOT EXISTS idx_admin_sessions_admin ON admin_sessions(admin_id);

CREATE TABLE IF NOT EXISTS internal_audit_logs (
  log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_admin_id UUID NOT NULL REFERENCES internal_admins(admin_id),
  actor_role VARCHAR(30) NOT NULL,
  action VARCHAR(100) NOT NULL,
  target_type VARCHAR(50) NOT NULL,
  target_id VARCHAR(255),
  old_value JSONB,
  new_value JSONB,
  reason TEXT,
  ip_address INET,
  user_agent TEXT,
  session_type VARCHAR(20) NOT NULL DEFAULT 'normal',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_ial_admin ON internal_audit_logs(actor_admin_id);
CREATE INDEX IF NOT EXISTS idx_ial_created ON internal_audit_logs(created_at DESC);

CREATE TABLE IF NOT EXISTS impersonation_sessions (
  session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id UUID NOT NULL REFERENCES internal_admins(admin_id),
  target_user_id UUID NOT NULL REFERENCES users(user_id),
  target_workspace_id UUID REFERENCES workspaces(workspace_id),
  mode VARCHAR(20) NOT NULL DEFAULT 'read_only'
    CHECK (mode IN ('read_only')),
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at TIMESTAMPTZ NOT NULL,
  ended_at TIMESTAMPTZ,
  pages_viewed JSONB DEFAULT '[]',
  actions_taken JSONB DEFAULT '[]',
  otp_verified BOOLEAN DEFAULT false
);

-- §17.8 & §17.9 support_tickets & support_ticket_messages (internal notes hidden from app_user via RLS)
CREATE TABLE IF NOT EXISTS support_tickets (
  ticket_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID REFERENCES workspaces(workspace_id),
  user_id UUID NOT NULL REFERENCES users(user_id),
  ticket_number VARCHAR(20) UNIQUE NOT NULL,
  subject VARCHAR(500) NOT NULL,
  priority VARCHAR(10) NOT NULL DEFAULT 'normal',
  status VARCHAR(20) NOT NULL DEFAULT 'open',
  category VARCHAR(50),
  assigned_admin_id UUID REFERENCES internal_admins(admin_id),
  sla_response_due_at TIMESTAMPTZ,
  sla_resolution_due_at TIMESTAMPTZ,
  first_responded_at TIMESTAMPTZ,
  resolved_at TIMESTAMPTZ,
  csat_score SMALLINT,
  auto_captured_context JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_support_tickets_tenant_pk UNIQUE (workspace_id, ticket_id)
);
CREATE INDEX IF NOT EXISTS idx_st_user ON support_tickets(user_id);
ALTER TABLE support_tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE support_tickets FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON support_tickets
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);
CREATE POLICY admin_ticket_access ON support_tickets FOR ALL TO admin_user
  USING (true)
  WITH CHECK (true);

CREATE TABLE IF NOT EXISTS support_ticket_messages (
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_id UUID NOT NULL REFERENCES support_tickets(ticket_id),
  author_type VARCHAR(20) NOT NULL,
  author_id UUID,
  body TEXT NOT NULL,
  attachments JSONB DEFAULT '[]',
  is_internal_note BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT fk_support_ticket_messages_ticket_id_tenant
    FOREIGN KEY (workspace_id, ticket_id) REFERENCES support_tickets(workspace_id, ticket_id)
);
CREATE INDEX IF NOT EXISTS idx_stm_ticket ON support_ticket_messages(ticket_id);
ALTER TABLE support_ticket_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE support_ticket_messages FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON support_ticket_messages
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
    AND (NOT is_internal_note OR current_user = 'admin_user'))
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
    AND (NOT is_internal_note OR current_user = 'admin_user'));
CREATE POLICY admin_ticket_messages ON support_ticket_messages FOR ALL TO admin_user
  USING (true)
  WITH CHECK (true);

-- §18.2–§18.5 api_keys, api_webhook_subscriptions, webhook_events, event_outbox, tags, taggables
CREATE TABLE IF NOT EXISTS api_keys (
  api_key_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  key_prefix VARCHAR(10) NOT NULL,
  key_hash VARCHAR(128) NOT NULL,
  name VARCHAR(255) NOT NULL,
  scopes JSONB DEFAULT '[]',
  status VARCHAR(20) NOT NULL DEFAULT 'active'
    CHECK (status IN ('active','rotating','suspended','revoked','expired')),
  logical_key_id UUID REFERENCES api_keys(api_key_id),
  replaced_by_key_id UUID REFERENCES api_keys(api_key_id),
  rotation_grace_ends_at TIMESTAMPTZ,
  last_used_at TIMESTAMPTZ,
  request_count BIGINT DEFAULT 0,
  rate_limit_override INTEGER,
  expires_at TIMESTAMPTZ,
  created_by UUID NOT NULL REFERENCES users(user_id),
  suspended_reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_api_keys_tenant_pk UNIQUE (workspace_id, api_key_id),
  CONSTRAINT fk_api_keys_logical_key_id_tenant
    FOREIGN KEY (workspace_id, logical_key_id) REFERENCES api_keys(workspace_id, api_key_id),
  CONSTRAINT fk_api_keys_replaced_by_key_id_tenant
    FOREIGN KEY (workspace_id, replaced_by_key_id) REFERENCES api_keys(workspace_id, api_key_id)
);
CREATE INDEX IF NOT EXISTS idx_ak_workspace ON api_keys(workspace_id);
CREATE INDEX IF NOT EXISTS idx_ak_hash ON api_keys(key_hash);
ALTER TABLE api_keys ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_keys FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON api_keys
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS api_webhook_subscriptions (
  webhook_subscription_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  api_key_id UUID REFERENCES api_keys(api_key_id),
  target_url TEXT NOT NULL,
  event_types JSONB NOT NULL DEFAULT '[]',
  signing_secret_hash VARCHAR(128) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'active'
    CHECK (status IN ('active','suspended','revoked')),
  consecutive_failure_count INTEGER NOT NULL DEFAULT 0,
  last_delivery_at TIMESTAMPTZ,
  last_error TEXT,
  created_by UUID NOT NULL REFERENCES users(user_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  CONSTRAINT uq_api_webhook_subscriptions_tenant_pk UNIQUE (workspace_id, webhook_subscription_id),
  CONSTRAINT fk_api_webhook_subscriptions_api_key_id_tenant
    FOREIGN KEY (workspace_id, api_key_id) REFERENCES api_keys(workspace_id, api_key_id)
);
CREATE INDEX IF NOT EXISTS idx_aws_workspace ON api_webhook_subscriptions(workspace_id);
ALTER TABLE api_webhook_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_webhook_subscriptions FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON api_webhook_subscriptions
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS webhook_events (
  webhook_event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  provider VARCHAR(50) NOT NULL,
  direction VARCHAR(20) NOT NULL
    CHECK (direction IN ('inbound','outbound')),
  external_event_id VARCHAR(255),
  idempotency_key VARCHAR(255) NOT NULL,
  webhook_subscription_id UUID REFERENCES api_webhook_subscriptions(webhook_subscription_id),
  payload JSONB NOT NULL,
  processing_status VARCHAR(30) NOT NULL DEFAULT 'received'
    CHECK (processing_status IN ('received','acknowledged','processed','failed','dead_lettered')),
  retry_count INTEGER NOT NULL DEFAULT 0,
  last_error TEXT,
  received_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  processed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (provider, idempotency_key),
  CONSTRAINT fk_webhook_events_webhook_subscription_id_tenant
    FOREIGN KEY (workspace_id, webhook_subscription_id) REFERENCES api_webhook_subscriptions(workspace_id, webhook_subscription_id)
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_we_idempotency ON webhook_events(workspace_id, provider, direction, idempotency_key);
ALTER TABLE webhook_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE webhook_events FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON webhook_events
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS event_outbox (
  outbox_id BIGSERIAL PRIMARY KEY,
  event_id UUID NOT NULL UNIQUE,
  event_type VARCHAR(200) NOT NULL,
  target_stream VARCHAR(100) NOT NULL,
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
CREATE INDEX IF NOT EXISTS idx_outbox_unpublished ON event_outbox(published, created_at)
  WHERE published = false;
ALTER TABLE event_outbox ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_outbox FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON event_outbox
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS tags (
  tag_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  name VARCHAR(100) NOT NULL,
  color VARCHAR(7),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, name),
  CONSTRAINT uq_tags_tenant_pk UNIQUE (workspace_id, tag_id)
);
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON tags
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- §18.5 taggables (direct junction table with direct RLS + composite tenant FK)
CREATE TABLE IF NOT EXISTS taggables (
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  tag_id UUID NOT NULL REFERENCES tags(tag_id),
  taggable_type VARCHAR(50) NOT NULL,
  taggable_id UUID NOT NULL,
  PRIMARY KEY (tag_id, taggable_type, taggable_id),
  CONSTRAINT fk_taggables_tag_id_tenant
    FOREIGN KEY (workspace_id, tag_id) REFERENCES tags(workspace_id, tag_id)
);
CREATE INDEX IF NOT EXISTS idx_taggables_target ON taggables(taggable_type, taggable_id);
ALTER TABLE taggables ENABLE ROW LEVEL SECURITY;
ALTER TABLE taggables FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON taggables
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- §19.1 subscriptions & §26.7 api_idempotency_records & §26.10 financial_postings
CREATE TABLE IF NOT EXISTS subscriptions (
  subscription_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  stripe_subscription_id VARCHAR(255),
  plan_tier VARCHAR(20) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'active',
  billing_interval VARCHAR(10) NOT NULL DEFAULT 'monthly',
  current_period_start TIMESTAMPTZ,
  current_period_end TIMESTAMPTZ,
  trial_ends_at TIMESTAMPTZ,
  cancelled_at TIMESTAMPTZ,
  cancel_reason TEXT,
  payment_method_last4 VARCHAR(4),
  payment_method_brand VARCHAR(20),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_subscriptions_tenant_pk UNIQUE (workspace_id, subscription_id)
);
CREATE INDEX IF NOT EXISTS idx_sub_workspace ON subscriptions(workspace_id);
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON subscriptions
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS api_idempotency_records (
  record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  actor_id UUID,
  actor_user_id UUID,
  rpc VARCHAR(255),
  rpc_name VARCHAR(255),
  idempotency_key VARCHAR(255) NOT NULL,
  request_hash VARCHAR(128) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'completed'
    CHECK (status IN ('processing','completed','failed')),
  response_payload JSONB,
  response_body JSONB,
  response_code INTEGER,
  expires_at TIMESTAMPTZ NOT NULL DEFAULT (NOW() + INTERVAL '24 hours'),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, actor_id, rpc, idempotency_key),
  UNIQUE(workspace_id, actor_user_id, idempotency_key)
);
ALTER TABLE api_idempotency_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_idempotency_records FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON api_idempotency_records
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

CREATE TABLE IF NOT EXISTS financial_postings (
  posting_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
  origin_type VARCHAR(100) NOT NULL,
  origin_id UUID NOT NULL,
  origin_version VARCHAR(100) NOT NULL,
  component VARCHAR(50) NOT NULL
    CHECK (component IN ('revenue','platform_fee','shipping','cogs','ai_credits','commission','ads_spend','seeding','refund','other')),
  amount NUMERIC(18,6) NOT NULL,
  currency VARCHAR(5) NOT NULL,
  source_class source_class NOT NULL,
  confidence confidence_band NOT NULL,
  exchange_rate_snapshot JSONB NOT NULL,
  reversal_of UUID REFERENCES financial_postings(posting_id),
  effective_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(workspace_id, origin_type, origin_id, origin_version, component),
  CONSTRAINT uq_financial_postings_tenant_pk UNIQUE (workspace_id, posting_id),
  CONSTRAINT fk_financial_postings_reversal_of_tenant
    FOREIGN KEY (workspace_id, reversal_of) REFERENCES financial_postings(workspace_id, posting_id)
);
ALTER TABLE financial_postings ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_postings FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON financial_postings
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

-- §26.12 & §27.2 Schema & Table Grants (No GRANT ALL; narrow per-role privileges)
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO app_user, admin_user, outbox_poller, directory_reader;

-- Revoke default public privileges on all installed tables
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;

-- app_user grants (never receives TRUNCATE, DDL, or internal_admin privileges)
GRANT SELECT ON regions TO app_user;
GRANT SELECT ON currencies TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON workspaces TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON users TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON workspace_members TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON brand_profiles TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON connected_accounts TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON user_preferences TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON signals TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON trends TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON trend_signals TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON opportunities TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON opportunity_sources TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON competitor_entities TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ideas TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON idea_sources TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON entities TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON threads TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON products TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON product_skus TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON offers TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON bundles TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON bundle_items TO app_user;
GRANT SELECT, INSERT, UPDATE ON evidence_objects TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON billing_events TO app_user;
GRANT SELECT, INSERT ON ai_credit_transactions TO app_user;
GRANT SELECT, INSERT ON audit_events TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON media_kits TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON brand_deals TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON support_tickets TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON support_ticket_messages TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON api_keys TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON api_webhook_subscriptions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON webhook_events TO app_user;
GRANT INSERT ON event_outbox TO app_user;
GRANT USAGE, SELECT ON SEQUENCE event_outbox_outbox_id_seq TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON tags TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON taggables TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON subscriptions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON api_idempotency_records TO app_user;
GRANT SELECT, INSERT ON financial_postings TO app_user;

-- admin_user grants
GRANT SELECT, INSERT, UPDATE, DELETE ON regions TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON currencies TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON internal_admins TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON admin_sessions TO admin_user;
GRANT SELECT, INSERT ON internal_audit_logs TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON impersonation_sessions TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON workspaces TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON users TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON workspace_members TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON support_tickets TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON support_ticket_messages TO admin_user;
GRANT SELECT, INSERT, UPDATE ON evidence_objects TO admin_user;
GRANT SELECT, INSERT ON audit_events TO admin_user;
GRANT SELECT, INSERT ON ai_credit_transactions TO admin_user;
GRANT SELECT, INSERT ON financial_postings TO admin_user;
GRANT INSERT ON event_outbox TO admin_user;
GRANT USAGE, SELECT ON SEQUENCE event_outbox_outbox_id_seq TO admin_user;

-- outbox_poller grants (dedicated BYPASSRLS role for event_outbox only)
GRANT SELECT, UPDATE ON event_outbox TO outbox_poller;
GRANT USAGE, SELECT ON SEQUENCE event_outbox_outbox_id_seq TO outbox_poller;

-- directory_reader grants (§27.2 column-level SELECT only on media_kits)
GRANT SELECT (media_kit_id, directory_profile) ON media_kits TO directory_reader;

-- +goose Down
DROP TRIGGER IF EXISTS trg_protect_evidence_content ON evidence_objects;
DROP FUNCTION IF EXISTS protect_evidence_content();
DROP TABLE IF EXISTS financial_postings CASCADE;
DROP TABLE IF EXISTS api_idempotency_records CASCADE;
DROP TABLE IF EXISTS subscriptions CASCADE;
DROP TABLE IF EXISTS taggables CASCADE;
DROP TABLE IF EXISTS tags CASCADE;
DROP TABLE IF EXISTS event_outbox CASCADE;
DROP TABLE IF EXISTS webhook_events CASCADE;
DROP TABLE IF EXISTS api_webhook_subscriptions CASCADE;
DROP TABLE IF EXISTS api_keys CASCADE;
DROP TABLE IF EXISTS support_ticket_messages CASCADE;
DROP TABLE IF EXISTS support_tickets CASCADE;
DROP TABLE IF EXISTS impersonation_sessions CASCADE;
DROP TABLE IF EXISTS internal_audit_logs CASCADE;
DROP TABLE IF EXISTS admin_sessions CASCADE;
DROP TABLE IF EXISTS internal_admins CASCADE;
DROP TABLE IF EXISTS brand_deals CASCADE;
DROP TABLE IF EXISTS media_kits CASCADE;
DROP TABLE IF EXISTS audit_events CASCADE;
DROP TABLE IF EXISTS ai_credit_transactions CASCADE;
DROP TABLE IF EXISTS billing_events CASCADE;
DROP TABLE IF EXISTS evidence_objects CASCADE;
DROP TABLE IF EXISTS bundle_items CASCADE;
DROP TABLE IF EXISTS bundles CASCADE;
DROP TABLE IF EXISTS offers CASCADE;
DROP TABLE IF EXISTS product_skus CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS threads CASCADE;
DROP TABLE IF EXISTS entities CASCADE;
DROP TABLE IF EXISTS idea_sources CASCADE;
DROP TABLE IF EXISTS ideas CASCADE;
DROP TABLE IF EXISTS competitor_entities CASCADE;
DROP TABLE IF EXISTS opportunity_sources CASCADE;
DROP TABLE IF EXISTS opportunities CASCADE;
DROP TABLE IF EXISTS trend_signals CASCADE;
DROP TABLE IF EXISTS trends CASCADE;
DROP TABLE IF EXISTS signals CASCADE;
DROP TABLE IF EXISTS user_preferences CASCADE;
DROP TABLE IF EXISTS connected_accounts CASCADE;
DROP TABLE IF EXISTS brand_profiles CASCADE;
DROP TABLE IF EXISTS workspace_members CASCADE;
DROP TABLE IF EXISTS workspaces CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS regions CASCADE;
DROP TABLE IF EXISTS currencies CASCADE;
DROP TYPE IF EXISTS verification_status;
DROP TYPE IF EXISTS reconciliation_state;
DROP TYPE IF EXISTS operator_mode;
DROP TYPE IF EXISTS confidence_band;
DROP TYPE IF EXISTS source_class;

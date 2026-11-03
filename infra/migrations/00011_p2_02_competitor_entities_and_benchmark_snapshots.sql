-- ============================================================================
-- Creativanta P2-02 Migration: Competitor Intelligence & Benchmark Snapshots
-- Canonical Source: docs/04_contracts/database_schema.md (§5.6, §5.7, §26.11, §26.12, §27.3)
--                   docs/02_features/intelligence/competitor_intelligence.md (RULE-M03-001–006, EC-M03-001–004)
--                   docs/04_contracts/domain_event_catalog.md (§3)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Extend Competitor Entities with Tracking, Relevance & Profile Columns (§5.6, §27.3)
-- ----------------------------------------------------------------------------
ALTER TABLE competitor_entities ADD COLUMN IF NOT EXISTS platform VARCHAR(50);
ALTER TABLE competitor_entities ADD COLUMN IF NOT EXISTS external_handle VARCHAR(255);
ALTER TABLE competitor_entities ADD COLUMN IF NOT EXISTS relevance_score REAL DEFAULT 0;
ALTER TABLE competitor_entities ADD COLUMN IF NOT EXISTS relevance_reason TEXT;
ALTER TABLE competitor_entities ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb;
ALTER TABLE competitor_entities ADD COLUMN IF NOT EXISTS followers_count BIGINT DEFAULT 0;
ALTER TABLE competitor_entities ADD COLUMN IF NOT EXISTS video_count_30d INTEGER DEFAULT 0;
ALTER TABLE competitor_entities ADD COLUMN IF NOT EXISTS avg_views BIGINT DEFAULT 0;
ALTER TABLE competitor_entities ADD COLUMN IF NOT EXISTS growth_rate_30d REAL DEFAULT 0;
ALTER TABLE competitor_entities ADD COLUMN IF NOT EXISTS avg_engagement_rate REAL DEFAULT 0;
ALTER TABLE competitor_entities ADD COLUMN IF NOT EXISTS posting_frequency_per_day REAL DEFAULT 0;
ALTER TABLE competitor_entities ADD COLUMN IF NOT EXISTS last_post_at TIMESTAMPTZ;

CREATE INDEX IF NOT EXISTS idx_comp_lookup ON competitor_entities(workspace_id, platform, external_handle);

-- ----------------------------------------------------------------------------
-- 2. Benchmark Snapshots Table (§5.7)
--    Enforces captured_at, data_period_start/end, flexible JSONB metrics,
--    source_class (RULE-M03-001: inferred default), and confidence band.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS benchmark_snapshots (
  snapshot_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  competitor_id           UUID REFERENCES competitor_entities(competitor_id) ON DELETE CASCADE,
  snapshot_type           VARCHAR(50) NOT NULL DEFAULT 'benchmark',
  data_period_start       DATE,
  data_period_end         DATE,
  metrics                 JSONB NOT NULL DEFAULT '{}'::jsonb,
  source_class            source_class NOT NULL DEFAULT 'inferred',
  confidence              confidence_band NOT NULL DEFAULT 'medium',
  captured_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_benchmark_snapshots_tenant_pk UNIQUE (workspace_id, snapshot_id),
  CONSTRAINT fk_benchmark_snapshots_competitor_id_tenant FOREIGN KEY (workspace_id, competitor_id)
    REFERENCES competitor_entities(workspace_id, competitor_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_bs_workspace_competitor ON benchmark_snapshots(workspace_id, competitor_id);
CREATE INDEX IF NOT EXISTS idx_bs_captured_at ON benchmark_snapshots(workspace_id, captured_at);

ALTER TABLE benchmark_snapshots ENABLE ROW LEVEL SECURITY;
ALTER TABLE benchmark_snapshots FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON benchmark_snapshots;
CREATE POLICY tenant_isolation ON benchmark_snapshots
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON benchmark_snapshots;
CREATE POLICY admin_ops_scope ON benchmark_snapshots
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. Narrow Role Grants (§26.12 — NEVER GRANT ALL)
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON benchmark_snapshots TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON benchmark_snapshots TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON benchmark_snapshots FROM app_user, admin_user;
DROP POLICY IF EXISTS admin_ops_scope ON benchmark_snapshots;
DROP POLICY IF EXISTS tenant_isolation ON benchmark_snapshots;
DROP TABLE IF EXISTS benchmark_snapshots CASCADE;
DROP INDEX IF EXISTS idx_comp_lookup;
ALTER TABLE competitor_entities DROP COLUMN IF EXISTS last_post_at;
ALTER TABLE competitor_entities DROP COLUMN IF EXISTS posting_frequency_per_day;
ALTER TABLE competitor_entities DROP COLUMN IF EXISTS avg_engagement_rate;
ALTER TABLE competitor_entities DROP COLUMN IF EXISTS growth_rate_30d;
ALTER TABLE competitor_entities DROP COLUMN IF EXISTS avg_views;
ALTER TABLE competitor_entities DROP COLUMN IF EXISTS video_count_30d;
ALTER TABLE competitor_entities DROP COLUMN IF EXISTS followers_count;
ALTER TABLE competitor_entities DROP COLUMN IF EXISTS metadata;
ALTER TABLE competitor_entities DROP COLUMN IF EXISTS relevance_reason;
ALTER TABLE competitor_entities DROP COLUMN IF EXISTS relevance_score;
ALTER TABLE competitor_entities DROP COLUMN IF EXISTS external_handle;
ALTER TABLE competitor_entities DROP COLUMN IF EXISTS platform;

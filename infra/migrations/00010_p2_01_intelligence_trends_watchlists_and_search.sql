-- ============================================================================
-- Creativanta P2-01 Migration: Intelligence Trends Scoring, Watchlists & Search
-- Canonical Source: docs/04_contracts/database_schema.md (§5.1, §5.2, §5.3, §5.8, §26.11, §26.12)
--                   docs/02_features/intelligence/trend_radar.md (RULE-M02-001–006, EC-M02-001–004)
--                   docs/04_contracts/domain_event_catalog.md (§3)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Trends Multi-Dimensional Scoring & Lineage Columns (§5.2, RULE-M02-002)
--    Enforces velocity_score, freshness_score, saturation_score and composite
--    strength_score (0-100) with freshness timestamp and vector embedding.
-- ----------------------------------------------------------------------------
ALTER TABLE trends ADD COLUMN IF NOT EXISTS strength_score REAL DEFAULT 0;
ALTER TABLE trends ADD COLUMN IF NOT EXISTS freshness_score REAL DEFAULT 0;
ALTER TABLE trends ADD COLUMN IF NOT EXISTS saturation_score REAL DEFAULT 0;
ALTER TABLE trends ADD COLUMN IF NOT EXISTS freshness_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE trends ADD COLUMN IF NOT EXISTS why_now TEXT;
ALTER TABLE trends ADD COLUMN IF NOT EXISTS relevance_description TEXT;
ALTER TABLE trends ADD COLUMN IF NOT EXISTS embedding_vector FLOAT8[] DEFAULT '{}';

-- ----------------------------------------------------------------------------
-- 2. Watchlists Table (§5.8)
--    Enables creator/operator watchlist tracking with alert thresholds.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS watchlists (
  watchlist_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  name                    VARCHAR(255) NOT NULL,
  type                    VARCHAR(50) NOT NULL DEFAULT 'trend'
                          CHECK (type IN ('trend', 'competitor', 'keyword', 'product')),
  criteria                JSONB NOT NULL DEFAULT '{}'::jsonb,
  alert_enabled           BOOLEAN DEFAULT true,
  alert_threshold         JSONB DEFAULT '{"velocity_score": 80, "spike_percentage": 50}'::jsonb,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_watchlists_tenant_pk UNIQUE (workspace_id, watchlist_id)
);

CREATE INDEX IF NOT EXISTS idx_watchlists_workspace ON watchlists(workspace_id);

ALTER TABLE watchlists ENABLE ROW LEVEL SECURITY;
ALTER TABLE watchlists FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON watchlists;
CREATE POLICY tenant_isolation ON watchlists
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON watchlists;
CREATE POLICY admin_ops_scope ON watchlists
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. Watchlist Alert Logs Table (Acceptance Target 2 & EC-M02-004)
--    Provides durable fingerprint deduplication and cooldown window tracking
--    to prevent notification storms.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS watchlist_alert_logs (
  alert_log_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  watchlist_id            UUID NOT NULL REFERENCES watchlists(watchlist_id) ON DELETE CASCADE,
  trend_id                UUID REFERENCES trends(trend_id) ON DELETE CASCADE,
  alert_fingerprint       VARCHAR(255) NOT NULL,
  metrics_snapshot        JSONB NOT NULL DEFAULT '{}'::jsonb,
  delivered_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  cooldown_until          TIMESTAMPTZ NOT NULL,
  CONSTRAINT uq_watchlist_alert_dedup UNIQUE (workspace_id, alert_fingerprint),
  CONSTRAINT uq_watchlist_alert_logs_tenant_pk UNIQUE (workspace_id, alert_log_id)
);

CREATE INDEX IF NOT EXISTS idx_wal_workspace ON watchlist_alert_logs(workspace_id);
CREATE INDEX IF NOT EXISTS idx_wal_cooldown ON watchlist_alert_logs(workspace_id, cooldown_until);

ALTER TABLE watchlist_alert_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE watchlist_alert_logs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON watchlist_alert_logs;
CREATE POLICY tenant_isolation ON watchlist_alert_logs
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON watchlist_alert_logs;
CREATE POLICY admin_ops_scope ON watchlist_alert_logs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 4. Narrow Role Grants (§26.12 — NEVER GRANT ALL)
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON watchlists TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON watchlists TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON watchlist_alert_logs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON watchlist_alert_logs TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON watchlists FROM app_user, admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON watchlist_alert_logs FROM app_user, admin_user;
DROP POLICY IF EXISTS admin_ops_scope ON watchlist_alert_logs;
DROP POLICY IF EXISTS tenant_isolation ON watchlist_alert_logs;
DROP TABLE IF EXISTS watchlist_alert_logs CASCADE;
DROP POLICY IF EXISTS admin_ops_scope ON watchlists;
DROP POLICY IF EXISTS tenant_isolation ON watchlists;
DROP TABLE IF EXISTS watchlists CASCADE;
ALTER TABLE trends DROP COLUMN IF EXISTS embedding_vector;
ALTER TABLE trends DROP COLUMN IF EXISTS relevance_description;
ALTER TABLE trends DROP COLUMN IF EXISTS why_now;
ALTER TABLE trends DROP COLUMN IF EXISTS freshness_at;
ALTER TABLE trends DROP COLUMN IF EXISTS saturation_score;
ALTER TABLE trends DROP COLUMN IF EXISTS freshness_score;
ALTER TABLE trends DROP COLUMN IF EXISTS strength_score;

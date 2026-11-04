-- ============================================================================
-- Creativanta P8-07 Migration: Competitor Monitoring, Brand Deal Kanban & Creator Directory
-- Canonical Sources: docs/04_contracts/database_schema.md (§5.6, §5.7, §16.1–§16.5, §27.2, §27.3)
--                    docs/02_features/intelligence/competitor_intelligence.md (Monitoring expansion)
--                    docs/02_features/commerce/creator_pro_tools.md (§12 Retained expansion)
--                    docs/04_contracts/domain_event_catalog.md (§3, §15)
--                    docs/04_contracts/rbac_permission_matrix.md
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Competitor Monitoring Alerts Table (§27.3)
--    Enforces continuous alert history, threshold evaluation, and deduplication
--    across identical snapshot replays.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS competitor_monitoring_alerts (
  alert_id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id                UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  competitor_id               UUID NOT NULL,
  snapshot_id                 UUID,
  metric                      VARCHAR(50) NOT NULL, -- engagement_rate, post_frequency, observed_price
  metric_value                NUMERIC(18,6),
  threshold                   NUMERIC(18,6) NOT NULL,
  direction                   VARCHAR(20) NOT NULL, -- above, below
  source_status               VARCHAR(30) NOT NULL DEFAULT 'active'
    CHECK (source_status IN ('active', 'paused', 'import_required')),
  alert_latch                 BOOLEAN NOT NULL DEFAULT true,
  recovery_latched_at         TIMESTAMPTZ,
  triggered_at                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  metadata                    JSONB DEFAULT '{}'::jsonb,
  CONSTRAINT uq_cma_tenant_pk UNIQUE (workspace_id, alert_id),
  CONSTRAINT fk_cma_competitor_id_tenant FOREIGN KEY (workspace_id, competitor_id)
    REFERENCES competitor_entities(workspace_id, competitor_id) ON DELETE CASCADE,
  CONSTRAINT fk_cma_snapshot_id_tenant FOREIGN KEY (workspace_id, snapshot_id)
    REFERENCES benchmark_snapshots(workspace_id, snapshot_id) ON DELETE SET NULL,
  CONSTRAINT uq_cma_snapshot_metric_dedup UNIQUE (workspace_id, competitor_id, snapshot_id, metric)
);

CREATE INDEX IF NOT EXISTS idx_cma_workspace_comp ON competitor_monitoring_alerts(workspace_id, competitor_id);
CREATE INDEX IF NOT EXISTS idx_cma_triggered_at ON competitor_monitoring_alerts(triggered_at DESC);

ALTER TABLE competitor_monitoring_alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE competitor_monitoring_alerts FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON competitor_monitoring_alerts;
CREATE POLICY tenant_isolation ON competitor_monitoring_alerts
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON competitor_monitoring_alerts;
CREATE POLICY admin_ops_scope ON competitor_monitoring_alerts
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 2. Brand Deals Kanban & Concurrency Extensions (§12, §16.5)
-- ----------------------------------------------------------------------------
ALTER TABLE brand_deals
  ADD COLUMN IF NOT EXISTS kanban_order INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS version INTEGER NOT NULL DEFAULT 1;

CREATE INDEX IF NOT EXISTS idx_bd_kanban_view ON brand_deals(workspace_id, status, kanban_order);

-- ----------------------------------------------------------------------------
-- 3. Media Kits Published Directory Partial Index (§27.2)
-- ----------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_media_kits_directory_published
  ON media_kits(directory_status, directory_opt_in)
  WHERE directory_opt_in = true AND directory_status = 'published' AND deleted_at IS NULL;

-- ----------------------------------------------------------------------------
-- 4. Table Role Grants (Narrow per-role grants; NEVER GRANT ALL)
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON competitor_monitoring_alerts TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON competitor_monitoring_alerts TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON competitor_monitoring_alerts FROM app_user, admin_user;
DROP POLICY IF EXISTS admin_ops_scope ON competitor_monitoring_alerts;
DROP POLICY IF EXISTS tenant_isolation ON competitor_monitoring_alerts;
DROP TABLE IF EXISTS competitor_monitoring_alerts CASCADE;
DROP INDEX IF EXISTS idx_media_kits_directory_published;
DROP INDEX IF EXISTS idx_bd_kanban_view;
ALTER TABLE brand_deals DROP COLUMN IF EXISTS version;
ALTER TABLE brand_deals DROP COLUMN IF EXISTS kanban_order;

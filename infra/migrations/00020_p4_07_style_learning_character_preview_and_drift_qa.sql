-- ============================================================================
-- Creativanta P4-07 Migration: Style Learning, Character Preview & Drift QA
-- Canonical Sources: docs/04_contracts/database_schema.md (§7.3, §7.5, §22.7)
--                    docs/02_features/production/ai_video_studio.md (EF-07, EF-07A)
--                    docs/02_features/content/continuity_os.md (RULE-M08-001–005, AC 1, 4, 5)
--                    docs/04_contracts/domain_event_catalog.md (§5, §15)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.4)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. style_packs Table (database_schema.md §22.7)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS style_packs (
  style_pack_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id       UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  name               VARCHAR(255) NOT NULL,
  source_asset_id    UUID NOT NULL REFERENCES assets(asset_id) ON DELETE RESTRICT,
  extracted_style    JSONB NOT NULL DEFAULT '{}',
  is_active          BOOLEAN DEFAULT true,
  continuity_pack_id UUID REFERENCES continuity_packs(pack_id) ON DELETE SET NULL,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at         TIMESTAMPTZ,
  CONSTRAINT uq_style_packs_tenant_pk UNIQUE (workspace_id, style_pack_id),
  CONSTRAINT fk_style_packs_source_asset_id_tenant
    FOREIGN KEY (workspace_id, source_asset_id) REFERENCES assets(workspace_id, asset_id) ON DELETE RESTRICT,
  CONSTRAINT fk_style_packs_continuity_pack_id_tenant
    FOREIGN KEY (workspace_id, continuity_pack_id) REFERENCES continuity_packs(workspace_id, pack_id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_style_packs_workspace ON style_packs(workspace_id);
CREATE INDEX IF NOT EXISTS idx_style_packs_source ON style_packs(source_asset_id);
CREATE INDEX IF NOT EXISTS idx_style_packs_continuity_pack ON style_packs(continuity_pack_id);

ALTER TABLE style_packs ENABLE ROW LEVEL SECURITY;
ALTER TABLE style_packs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON style_packs;
CREATE POLICY tenant_isolation ON style_packs
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON style_packs;
CREATE POLICY admin_ops_scope ON style_packs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON style_packs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON style_packs TO admin_user;

-- ----------------------------------------------------------------------------
-- 2. Drift Columns on assets Table (database_schema.md §7.3 & RULE-M08-005)
-- ----------------------------------------------------------------------------
ALTER TABLE assets ADD COLUMN IF NOT EXISTS drift_score REAL;
ALTER TABLE assets ADD COLUMN IF NOT EXISTS drift_severity VARCHAR(20) DEFAULT 'none';
ALTER TABLE assets ADD COLUMN IF NOT EXISTS drift_details JSONB DEFAULT '{}';

ALTER TABLE assets DROP CONSTRAINT IF EXISTS chk_assets_drift_severity;
ALTER TABLE assets ADD CONSTRAINT chk_assets_drift_severity
  CHECK (drift_severity IN ('none', 'low_drift', 'moderate_drift', 'high_drift'));

CREATE INDEX IF NOT EXISTS idx_assets_drift_severity ON assets(workspace_id, drift_severity);

-- ----------------------------------------------------------------------------
-- 3. Override Fields on continuity_violations Table (database_schema.md §7.5)
-- ----------------------------------------------------------------------------
ALTER TABLE continuity_violations ADD COLUMN IF NOT EXISTS override_reason TEXT;
ALTER TABLE continuity_violations ADD COLUMN IF NOT EXISTS resolved_at TIMESTAMPTZ;

-- +goose Down
ALTER TABLE continuity_violations DROP COLUMN IF EXISTS resolved_at;
ALTER TABLE continuity_violations DROP COLUMN IF EXISTS override_reason;

DROP INDEX IF EXISTS idx_assets_drift_severity;
ALTER TABLE assets DROP CONSTRAINT IF EXISTS chk_assets_drift_severity;
ALTER TABLE assets DROP COLUMN IF EXISTS drift_details;
ALTER TABLE assets DROP COLUMN IF EXISTS drift_severity;
ALTER TABLE assets DROP COLUMN IF EXISTS drift_score;

ALTER TABLE style_packs DROP CONSTRAINT IF EXISTS fk_style_packs_continuity_pack_id_tenant;
ALTER TABLE style_packs DROP CONSTRAINT IF EXISTS fk_style_packs_source_asset_id_tenant;
REVOKE SELECT, INSERT, UPDATE, DELETE ON style_packs FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON style_packs FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON style_packs;
DROP POLICY IF EXISTS tenant_isolation ON style_packs;
DROP TABLE IF EXISTS style_packs CASCADE;

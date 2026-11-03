-- ============================================================================
-- Creativanta P4-04 Migration: Remix Blueprints & Multi-Merge Pipeline
-- Canonical Sources: docs/04_contracts/database_schema.md (§22.2, §32, §34)
--                    docs/02_features/production/ai_video_studio.md (Mode 3, Mode 4, RULE-M07-003, RULE-M07-008, EC-M07-M01, EC-M07-R01)
--                    docs/04_contracts/domain_event_catalog.md (§15B)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.4)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. remix_blueprints Table (§22.2)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS remix_blueprints (
  blueprint_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  reference_asset_id     UUID NOT NULL REFERENCES assets(asset_id),
  output_asset_id        UUID REFERENCES assets(asset_id),
  video_edit_job_id      UUID REFERENCES video_edit_jobs(job_id),
  creative_dna           JSONB NOT NULL DEFAULT '{}',
  remix_script           TEXT,
  fidelity_level         VARCHAR(20) NOT NULL DEFAULT 'adapt',
  originality_score      REAL, -- 0-100 non-financial score, must be > 70 (< 30% similarity)
  similarity_percentage  REAL, -- 0-100 script similarity vs reference original (< 30%)
  status                 VARCHAR(20) NOT NULL DEFAULT 'analyzing',
  rejection_reason       TEXT,
  error_message          TEXT,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at             TIMESTAMPTZ, -- soft delete (DB-H-003)
  CONSTRAINT uq_remix_blueprints_tenant_pk UNIQUE (workspace_id, blueprint_id),
  CONSTRAINT fk_remix_blueprints_reference_asset_id_tenant
    FOREIGN KEY (workspace_id, reference_asset_id) REFERENCES assets(workspace_id, asset_id),
  CONSTRAINT fk_remix_blueprints_output_asset_id_tenant
    FOREIGN KEY (workspace_id, output_asset_id) REFERENCES assets(workspace_id, asset_id),
  CONSTRAINT fk_remix_blueprints_video_edit_job_id_tenant
    FOREIGN KEY (workspace_id, video_edit_job_id) REFERENCES video_edit_jobs(workspace_id, job_id),
  CONSTRAINT chk_remix_blueprints_fidelity
    CHECK (fidelity_level IN ('match_1to1', 'adapt', 'loose')),
  CONSTRAINT chk_remix_blueprints_status
    CHECK (status IN ('analyzing', 'analyzed', 'generating', 'generated', 'failed', 'rejected'))
);

CREATE INDEX IF NOT EXISTS idx_rb_workspace ON remix_blueprints(workspace_id);
CREATE INDEX IF NOT EXISTS idx_rb_ref ON remix_blueprints(reference_asset_id);
CREATE INDEX IF NOT EXISTS idx_rb_output ON remix_blueprints(output_asset_id);
CREATE INDEX IF NOT EXISTS idx_rb_job ON remix_blueprints(video_edit_job_id);
CREATE INDEX IF NOT EXISTS idx_rb_status ON remix_blueprints(status);

ALTER TABLE remix_blueprints ENABLE ROW LEVEL SECURITY;
ALTER TABLE remix_blueprints FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON remix_blueprints;
CREATE POLICY tenant_isolation ON remix_blueprints
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON remix_blueprints;
CREATE POLICY admin_ops_scope ON remix_blueprints
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON remix_blueprints TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON remix_blueprints TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON remix_blueprints FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON remix_blueprints FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON remix_blueprints;
DROP POLICY IF EXISTS tenant_isolation ON remix_blueprints;
DROP TABLE IF EXISTS remix_blueprints CASCADE;

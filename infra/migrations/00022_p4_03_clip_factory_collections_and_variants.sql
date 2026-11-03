-- ============================================================================
-- Creativanta P4-03 Migration: Clip Factory Collections and Scored Clip Proposals
-- Canonical Sources: docs/02_features/production/ai_video_studio.md (§Mode 2: Clip Factory, EC-M07-C01, AC-3)
--                    docs/03_screens/web/screen_web_studio_clip_factory.md (W023)
--                    docs/03_screens/mobile/screen_mobile_studio_clip_factory.md (M015)
--                    docs/04_contracts/database_schema.md (§7.3, §22.1, §22.3)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. clip_collections Table (§22.3)
--    Stores AI-detected viral clips, timecodes, hook analyses, virality breakdowns,
--    and selection state for Mode 2 (1->N).
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS clip_collections (
  collection_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id             UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  source_asset_id          UUID NOT NULL,
  video_edit_job_id        UUID,
  total_clips              INTEGER NOT NULL DEFAULT 0,
  clip_data                JSONB NOT NULL DEFAULT '[]',
  status                   VARCHAR(20) NOT NULL DEFAULT 'analyzing',
  created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at               TIMESTAMPTZ,
  CONSTRAINT uq_clip_collections_tenant_pk UNIQUE (workspace_id, collection_id),
  CONSTRAINT fk_clip_collections_source_asset_id_tenant
    FOREIGN KEY (workspace_id, source_asset_id) REFERENCES assets(workspace_id, asset_id) ON DELETE CASCADE,
  CONSTRAINT fk_clip_collections_video_edit_job_id_tenant
    FOREIGN KEY (workspace_id, video_edit_job_id) REFERENCES video_edit_jobs(workspace_id, job_id) ON DELETE SET NULL,
  CONSTRAINT chk_clip_collections_status
    CHECK (status IN ('analyzing', 'proposed', 'processing', 'completed', 'failed'))
);

CREATE INDEX IF NOT EXISTS idx_cc_workspace ON clip_collections(workspace_id);
CREATE INDEX IF NOT EXISTS idx_cc_source ON clip_collections(source_asset_id);
CREATE INDEX IF NOT EXISTS idx_cc_status ON clip_collections(status);

ALTER TABLE clip_collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE clip_collections FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON clip_collections;
CREATE POLICY tenant_isolation ON clip_collections
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON clip_collections;
CREATE POLICY admin_ops_scope ON clip_collections
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON clip_collections TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON clip_collections TO admin_user;

-- +goose Down

REVOKE SELECT, INSERT, UPDATE, DELETE ON clip_collections FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON clip_collections FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON clip_collections;
DROP POLICY IF EXISTS tenant_isolation ON clip_collections;
DROP TABLE IF EXISTS clip_collections CASCADE;

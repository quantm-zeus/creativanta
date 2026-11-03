-- ============================================================================
-- Creativanta P4-06 Migration: Translation, Sound & Voice Clone (EF05–EF06, M07, M08)
-- Canonical Sources: docs/04_contracts/database_schema.md (§22.6, §22.12)
--                    docs/02_features/production/ai_video_studio.md (EF-05, EF-06)
--                    docs/02_features/content/continuity_os.md (RULE-M08-002, EC-M08-001)
--                    docs/04_contracts/domain_event_catalog.md (§5)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.4)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. voice_clone_records Table (§22.12)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS voice_clone_records (
  voice_clone_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id         UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  character_id         UUID NOT NULL,
  provider             VARCHAR(50) NOT NULL DEFAULT 'elevenlabs',
  provider_voice_id    VARCHAR(255),
  voice_name           VARCHAR(255),
  sample_audio_urls    JSONB DEFAULT '[]',
  clone_status         VARCHAR(20) NOT NULL DEFAULT 'pending',
  consent_record_id    UUID,
  quality_score        REAL,
  repair_applied       BOOLEAN DEFAULT false,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_voice_clone_records_tenant_pk UNIQUE (workspace_id, voice_clone_id),
  CONSTRAINT fk_voice_clone_records_character_id_tenant
    FOREIGN KEY (workspace_id, character_id) REFERENCES characters(workspace_id, character_id) ON DELETE CASCADE,
  CONSTRAINT fk_voice_clone_records_consent_record_id_tenant
    FOREIGN KEY (workspace_id, consent_record_id) REFERENCES consent_records(workspace_id, consent_id) ON DELETE SET NULL,
  CONSTRAINT chk_voice_clone_records_status
    CHECK (clone_status IN ('pending', 'processing', 'ready', 'failed', 'revoked'))
);

CREATE INDEX IF NOT EXISTS idx_vcr_workspace ON voice_clone_records(workspace_id);
CREATE INDEX IF NOT EXISTS idx_vcr_character ON voice_clone_records(workspace_id, character_id);
CREATE INDEX IF NOT EXISTS idx_vcr_status ON voice_clone_records(workspace_id, clone_status);

ALTER TABLE voice_clone_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE voice_clone_records FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON voice_clone_records;
CREATE POLICY tenant_isolation ON voice_clone_records
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON voice_clone_records;
CREATE POLICY admin_ops_scope ON voice_clone_records
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON voice_clone_records TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON voice_clone_records TO admin_user;

-- ----------------------------------------------------------------------------
-- 2. translation_jobs Table (§22.6)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS translation_jobs (
  translation_job_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id                 UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  video_edit_job_id            UUID,
  source_asset_id              UUID NOT NULL,
  target_languages             VARCHAR(10)[] NOT NULL,
  lip_sync_enabled             BOOLEAN DEFAULT true,
  cultural_adaptation_enabled  BOOLEAN DEFAULT false,
  translate_captions           BOOLEAN DEFAULT true,
  translate_overlays           BOOLEAN DEFAULT true,
  voice_option                 VARCHAR(30) DEFAULT 'ai_preset',
  voice_clone_id               UUID,
  per_language_status          JSONB DEFAULT '{}',
  output_asset_ids             JSONB DEFAULT '{}',
  total_credits_used           NUMERIC(18,6) DEFAULT 0,
  status                       VARCHAR(20) NOT NULL DEFAULT 'queued',
  quality_scores               JSONB DEFAULT '{}',
  repair_notes                 JSONB DEFAULT '{}',
  quote_id                     UUID,
  created_at                   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at                   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at                   TIMESTAMPTZ,
  CONSTRAINT uq_translation_jobs_tenant_pk UNIQUE (workspace_id, translation_job_id),
  CONSTRAINT fk_translation_jobs_source_asset_id_tenant
    FOREIGN KEY (workspace_id, source_asset_id) REFERENCES assets(workspace_id, asset_id),
  CONSTRAINT fk_translation_jobs_video_edit_job_id_tenant
    FOREIGN KEY (workspace_id, video_edit_job_id) REFERENCES video_edit_jobs(workspace_id, job_id),
  CONSTRAINT fk_translation_jobs_voice_clone_id_tenant
    FOREIGN KEY (workspace_id, voice_clone_id) REFERENCES voice_clone_records(workspace_id, voice_clone_id) ON DELETE SET NULL,
  CONSTRAINT chk_translation_jobs_status
    CHECK (status IN ('queued', 'processing', 'partially_completed', 'completed', 'failed', 'cancelled'))
);

CREATE INDEX IF NOT EXISTS idx_tj_workspace ON translation_jobs(workspace_id);
CREATE INDEX IF NOT EXISTS idx_tj_source ON translation_jobs(source_asset_id);
CREATE INDEX IF NOT EXISTS idx_tj_status ON translation_jobs(workspace_id, status);

ALTER TABLE translation_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE translation_jobs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON translation_jobs;
CREATE POLICY tenant_isolation ON translation_jobs
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON translation_jobs;
CREATE POLICY admin_ops_scope ON translation_jobs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON translation_jobs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON translation_jobs TO admin_user;

-- +goose Down
ALTER TABLE translation_jobs DROP CONSTRAINT IF EXISTS fk_translation_jobs_voice_clone_id_tenant;
REVOKE SELECT, INSERT, UPDATE, DELETE ON translation_jobs FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON translation_jobs FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON translation_jobs;
DROP POLICY IF EXISTS tenant_isolation ON translation_jobs;
DROP TABLE IF EXISTS translation_jobs CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON voice_clone_records FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON voice_clone_records FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON voice_clone_records;
DROP POLICY IF EXISTS tenant_isolation ON voice_clone_records;
DROP TABLE IF EXISTS voice_clone_records CASCADE;

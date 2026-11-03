-- ============================================================================
-- Creativanta P4-01 Migration: Production Jobs, Assets, Lineage, Uploads & Post-Production
-- Canonical Sources: docs/04_contracts/database_schema.md (§7.3, §7.4, §7.5, §18.7, §22.1)
--                    docs/02_features/production/ai_video_studio.md (RULE-M07-001–008, EC-M07-001–004)
--                    docs/04_contracts/domain_event_catalog.md (§5)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.4)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. assets Table (§7.3)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS assets (
  asset_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id             UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  asset_type               VARCHAR(30) NOT NULL, -- video, image, audio, thumbnail, subtitle
  title                    VARCHAR(500),
  script_id                UUID REFERENCES scripts(script_id),
  asset_brief_id           UUID REFERENCES asset_briefs(asset_brief_id),
  source_generation_mode   VARCHAR(30), -- ai_generated, user_uploaded, imported, derived
  source_provider          VARCHAR(50), -- veo, kling, runway, flux, elevenlabs, manual
  source_model             VARCHAR(100),
  file_url                 TEXT,
  file_size_bytes          BIGINT,
  duration_seconds         NUMERIC(12,2), -- duration, not financial but needs precision for video timecodes
  resolution               VARCHAR(20),
  aspect_ratio             VARCHAR(10),
  mime_type                VARCHAR(100),
  generation_state         VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued,generating,generated,failed,cancelled
  quality_state            VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft,review_required,approved,rejected,promoted_canonical
  lineage_refs             JSONB DEFAULT '[]', -- [{type, id, prompt, provider, model, cost_credits, cost_usd}]
  continuity_pack_ids      UUID[] DEFAULT '{}',
  generation_cost_credits  NUMERIC(18,6), -- DB-H-001: financial precision
  generation_cost_usd      NUMERIC(18,6), -- DB-H-001: financial precision
  generation_prompt        TEXT,
  generation_params        JSONB DEFAULT '{}',
  error_message            TEXT,
  parent_asset_id          UUID REFERENCES assets(asset_id),
  derivative_type          VARCHAR(30), -- clip, variant, remix, repurpose, thumbnail
  metadata                 JSONB DEFAULT '{}',
  created_by               UUID REFERENCES users(user_id),
  created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at               TIMESTAMPTZ, -- soft delete (DB-H-003)
  CONSTRAINT uq_assets_tenant_pk UNIQUE (workspace_id, asset_id),
  CONSTRAINT chk_assets_generation_state
    CHECK (generation_state IN ('queued', 'generating', 'generated', 'failed', 'cancelled')),
  CONSTRAINT chk_assets_quality_state
    CHECK (quality_state IN ('draft', 'review_required', 'approved', 'rejected', 'promoted_canonical')),
  CONSTRAINT fk_assets_script_id_tenant
    FOREIGN KEY (workspace_id, script_id) REFERENCES scripts(workspace_id, script_id),
  CONSTRAINT fk_assets_asset_brief_id_tenant
    FOREIGN KEY (workspace_id, asset_brief_id) REFERENCES asset_briefs(workspace_id, asset_brief_id),
  CONSTRAINT fk_assets_parent_asset_id_tenant
    FOREIGN KEY (workspace_id, parent_asset_id) REFERENCES assets(workspace_id, asset_id)
);

CREATE INDEX IF NOT EXISTS idx_assets_workspace ON assets(workspace_id);
CREATE INDEX IF NOT EXISTS idx_assets_type ON assets(asset_type);
CREATE INDEX IF NOT EXISTS idx_assets_gen_state ON assets(generation_state);
CREATE INDEX IF NOT EXISTS idx_assets_quality ON assets(quality_state);
CREATE INDEX IF NOT EXISTS idx_assets_parent ON assets(parent_asset_id);
CREATE INDEX IF NOT EXISTS idx_assets_script ON assets(script_id);

ALTER TABLE assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE assets FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON assets;
CREATE POLICY tenant_isolation ON assets
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON assets;
CREATE POLICY admin_ops_scope ON assets
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON assets TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON assets TO admin_user;

-- ----------------------------------------------------------------------------
-- 2. generation_jobs Table (§7.4)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS generation_jobs (
  job_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  asset_id               UUID REFERENCES assets(asset_id),
  job_type               VARCHAR(50) NOT NULL, -- video_gen, image_gen, tts, lip_sync, remix, clip_factory, quick_edit, multi_merge, etc.
  provider               VARCHAR(50) NOT NULL,
  model                  VARCHAR(100),
  pipeline_strategy      VARCHAR(30), -- native_audio, audio_first, post_prod_lip_sync, simple_voice_over
  input_params           JSONB NOT NULL DEFAULT '{}',
  prompt_package         JSONB NOT NULL DEFAULT '{}', -- versioned prompt/continuity lineage
  status                 VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued,processing,completed,failed,cancelled
  progress_pct           SMALLINT DEFAULT 0,
  current_step           VARCHAR(100),
  estimated_credits      NUMERIC(18,6), -- DB-H-001: financial precision
  actual_credits         NUMERIC(18,6), -- DB-H-001: financial precision
  actual_cost_usd        NUMERIC(18,6), -- DB-H-001: financial precision
  provider_job_id        VARCHAR(255),
  result_url             TEXT,
  result_metadata        JSONB DEFAULT '{}',
  error_code             VARCHAR(50),
  error_message          TEXT,
  retry_count            SMALLINT DEFAULT 0,
  max_retries            SMALLINT DEFAULT 3,
  started_at             TIMESTAMPTZ,
  completed_at           TIMESTAMPTZ,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_generation_jobs_tenant_pk UNIQUE (workspace_id, job_id),
  CONSTRAINT chk_generation_jobs_status
    CHECK (status IN ('queued', 'processing', 'completed', 'failed', 'cancelled')),
  CONSTRAINT fk_generation_jobs_asset_id_tenant
    FOREIGN KEY (workspace_id, asset_id) REFERENCES assets(workspace_id, asset_id)
);

CREATE INDEX IF NOT EXISTS idx_gj_workspace ON generation_jobs(workspace_id);
CREATE INDEX IF NOT EXISTS idx_gj_status ON generation_jobs(status);
CREATE INDEX IF NOT EXISTS idx_gj_asset ON generation_jobs(asset_id);

ALTER TABLE generation_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE generation_jobs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON generation_jobs;
CREATE POLICY tenant_isolation ON generation_jobs
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON generation_jobs;
CREATE POLICY admin_ops_scope ON generation_jobs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON generation_jobs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON generation_jobs TO admin_user;

-- ----------------------------------------------------------------------------
-- 3. continuity_violations Table (§7.5)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS continuity_violations (
  violation_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  asset_id               UUID NOT NULL REFERENCES assets(asset_id),
  pack_id                UUID REFERENCES continuity_packs(pack_id),
  violation_type         VARCHAR(50) NOT NULL, -- visual_drift, voice_drift, brand_drift, style_drift
  severity               VARCHAR(20) NOT NULL, -- low, medium, high, critical
  description            TEXT,
  drift_score            REAL, -- 0-100 non-financial score
  resolved               BOOLEAN DEFAULT false,
  resolved_by            UUID REFERENCES users(user_id),
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at             TIMESTAMPTZ, -- soft delete (DB-H-003)
  CONSTRAINT uq_continuity_violations_tenant_pk UNIQUE (workspace_id, violation_id),
  CONSTRAINT fk_continuity_violations_asset_id_tenant
    FOREIGN KEY (workspace_id, asset_id) REFERENCES assets(workspace_id, asset_id),
  CONSTRAINT fk_continuity_violations_pack_id_tenant
    FOREIGN KEY (workspace_id, pack_id) REFERENCES continuity_packs(workspace_id, pack_id)
);

CREATE INDEX IF NOT EXISTS idx_cv_workspace ON continuity_violations(workspace_id);
CREATE INDEX IF NOT EXISTS idx_cv_asset ON continuity_violations(asset_id);

ALTER TABLE continuity_violations ENABLE ROW LEVEL SECURITY;
ALTER TABLE continuity_violations FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON continuity_violations;
CREATE POLICY tenant_isolation ON continuity_violations
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON continuity_violations;
CREATE POLICY admin_ops_scope ON continuity_violations
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON continuity_violations TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON continuity_violations TO admin_user;

-- ----------------------------------------------------------------------------
-- 4. file_uploads Table (§18.7)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS file_uploads (
  upload_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  uploader_user_id       UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  file_name              VARCHAR(500) NOT NULL,
  file_size_bytes        BIGINT NOT NULL,
  mime_type              VARCHAR(100) NOT NULL,
  storage_key            TEXT NOT NULL, -- R2 key
  storage_url            TEXT NOT NULL,
  checksum_sha256        VARCHAR(64),
  upload_purpose         VARCHAR(50), -- asset, avatar, brand_logo, evidence, import, attachment
  virus_scan_status      VARCHAR(20) DEFAULT 'pending', -- pending, clean, infected, error
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_file_uploads_tenant_pk UNIQUE (workspace_id, upload_id),
  CONSTRAINT fk_file_uploads_user_tenant
    FOREIGN KEY (workspace_id, uploader_user_id) REFERENCES workspace_members(workspace_id, user_id) ON DELETE CASCADE,
  CONSTRAINT chk_file_uploads_virus_scan
    CHECK (virus_scan_status IN ('pending', 'clean', 'infected', 'error'))
);

CREATE INDEX IF NOT EXISTS idx_fu_workspace ON file_uploads(workspace_id);

ALTER TABLE file_uploads ENABLE ROW LEVEL SECURITY;
ALTER TABLE file_uploads FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON file_uploads;
CREATE POLICY tenant_isolation ON file_uploads
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON file_uploads;
CREATE POLICY admin_ops_scope ON file_uploads
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON file_uploads TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON file_uploads TO admin_user;

-- ----------------------------------------------------------------------------
-- 5. video_edit_jobs Table (§22.1)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS video_edit_jobs (
  job_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  mode                   VARCHAR(30) NOT NULL, -- quick_edit, clip_factory, multi_merge, remix, product_showcase, image_to_video, link_to_video, translation, video_agent
  source_asset_ids       UUID[] DEFAULT '{}', -- input assets
  output_asset_ids       UUID[] DEFAULT '{}', -- produced assets
  generation_job_id      UUID REFERENCES generation_jobs(job_id), -- linked AI generation job
  character_id           UUID REFERENCES characters(character_id),
  brand_pack_id          UUID REFERENCES continuity_packs(pack_id),
  status                 VARCHAR(20) NOT NULL DEFAULT 'queued', -- queued, processing, completed, partially_completed, failed, cancelled
  input_params           JSONB NOT NULL DEFAULT '{}', -- mode-specific parameters
  output_metadata        JSONB DEFAULT '{}', -- mode-specific outputs
  credits_estimated      NUMERIC(18,6), -- DB-H-001: financial precision
  credits_used           NUMERIC(18,6), -- DB-H-001: financial precision
  actual_cost_usd        NUMERIC(18,6), -- DB-H-001: financial precision
  error_message          TEXT,
  started_at             TIMESTAMPTZ,
  completed_at           TIMESTAMPTZ,
  created_by             UUID REFERENCES users(user_id),
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at             TIMESTAMPTZ, -- soft delete (DB-H-003)
  CONSTRAINT uq_video_edit_jobs_tenant_pk UNIQUE (workspace_id, job_id),
  CONSTRAINT fk_video_edit_jobs_generation_job_id_tenant
    FOREIGN KEY (workspace_id, generation_job_id) REFERENCES generation_jobs(workspace_id, job_id),
  CONSTRAINT fk_video_edit_jobs_character_id_tenant
    FOREIGN KEY (workspace_id, character_id) REFERENCES characters(workspace_id, character_id),
  CONSTRAINT fk_video_edit_jobs_brand_pack_id_tenant
    FOREIGN KEY (workspace_id, brand_pack_id) REFERENCES continuity_packs(workspace_id, pack_id),
  CONSTRAINT chk_video_edit_jobs_status
    CHECK (status IN ('queued', 'processing', 'completed', 'partially_completed', 'failed', 'cancelled'))
);

CREATE INDEX IF NOT EXISTS idx_vej_workspace ON video_edit_jobs(workspace_id);
CREATE INDEX IF NOT EXISTS idx_vej_mode ON video_edit_jobs(mode);
CREATE INDEX IF NOT EXISTS idx_vej_status ON video_edit_jobs(status);

ALTER TABLE video_edit_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE video_edit_jobs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON video_edit_jobs;
CREATE POLICY tenant_isolation ON video_edit_jobs
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON video_edit_jobs;
CREATE POLICY admin_ops_scope ON video_edit_jobs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON video_edit_jobs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON video_edit_jobs TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON video_edit_jobs FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON video_edit_jobs FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON video_edit_jobs;
DROP POLICY IF EXISTS tenant_isolation ON video_edit_jobs;
DROP TABLE IF EXISTS video_edit_jobs CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON file_uploads FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON file_uploads FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON file_uploads;
DROP POLICY IF EXISTS tenant_isolation ON file_uploads;
DROP TABLE IF EXISTS file_uploads CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON continuity_violations FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON continuity_violations FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON continuity_violations;
DROP POLICY IF EXISTS tenant_isolation ON continuity_violations;
DROP TABLE IF EXISTS continuity_violations CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON generation_jobs FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON generation_jobs FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON generation_jobs;
DROP POLICY IF EXISTS tenant_isolation ON generation_jobs;
DROP TABLE IF EXISTS generation_jobs CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON assets FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON assets FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON assets;
DROP POLICY IF EXISTS tenant_isolation ON assets;
DROP TABLE IF EXISTS assets CASCADE;

-- ============================================================================
-- Creativanta P3-02 Migration: Scripts, Approvals, Versions & Asset Briefs (M06)
-- Canonical Sources: docs/04_contracts/database_schema.md (§6.4, §6.5, §6.6, §18.1)
--                    docs/02_features/content/script_lab.md (RULE-M06-001–007, EC-M06-001–004)
--                    docs/04_contracts/domain_event_catalog.md (§4)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. scripts Table (§6.4)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS scripts (
  script_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  idea_id                 UUID,
  title                   VARCHAR(500) NOT NULL,
  format_type             VARCHAR(50) DEFAULT 'short_form',
  body                    JSONB NOT NULL DEFAULT '[]',
  cta_blocks              JSONB DEFAULT '[]',
  disclosure_blocks       JSONB DEFAULT '[]',
  duration_target_seconds INTEGER DEFAULT 60,
  lifecycle_state         VARCHAR(30) NOT NULL DEFAULT 'draft',
  approval_state          VARCHAR(20) NOT NULL DEFAULT 'not_submitted',
  publish_target_profiles JSONB DEFAULT '[]',
  continuity_refs         JSONB DEFAULT '[]',
  offer_product_hooks     JSONB DEFAULT '[]',
  rejection_reason        TEXT,
  version_index           INTEGER NOT NULL DEFAULT 1,
  created_by              UUID REFERENCES users(user_id),
  approved_by             UUID REFERENCES users(user_id),
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_scripts_tenant_pk UNIQUE (workspace_id, script_id),
  CONSTRAINT fk_scripts_idea_id_tenant
    FOREIGN KEY (workspace_id, idea_id) REFERENCES ideas(workspace_id, idea_id) ON DELETE SET NULL,
  CONSTRAINT chk_scripts_lifecycle_state
    CHECK (lifecycle_state IN ('draft', 'in_review', 'approved', 'revision_required', 'ready_for_production', 'archived')),
  CONSTRAINT chk_scripts_approval_state
    CHECK (approval_state IN ('not_submitted', 'pending_approval', 'approved', 'rejected'))
);

CREATE INDEX IF NOT EXISTS idx_scripts_workspace ON scripts(workspace_id);
CREATE INDEX IF NOT EXISTS idx_scripts_idea ON scripts(workspace_id, idea_id);
CREATE INDEX IF NOT EXISTS idx_scripts_lifecycle ON scripts(workspace_id, lifecycle_state);
CREATE INDEX IF NOT EXISTS idx_scripts_approval ON scripts(workspace_id, approval_state);

ALTER TABLE scripts ENABLE ROW LEVEL SECURITY;
ALTER TABLE scripts FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON scripts;
CREATE POLICY tenant_isolation ON scripts
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON scripts;
CREATE POLICY admin_ops_scope ON scripts
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON scripts TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON scripts TO admin_user;

-- ----------------------------------------------------------------------------
-- 2. asset_briefs Table (§6.5)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS asset_briefs (
  asset_brief_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id             UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  script_id                UUID NOT NULL,
  output_type              VARCHAR(50) NOT NULL DEFAULT 'video',
  target_format            VARCHAR(50) DEFAULT '9:16',
  target_duration_seconds  INTEGER DEFAULT 60,
  target_platforms         JSONB DEFAULT '[]',
  continuity_requirements  JSONB DEFAULT '{}',
  brand_voice_requirements JSONB DEFAULT '{}',
  production_instructions  TEXT,
  status                   VARCHAR(20) NOT NULL DEFAULT 'draft',
  created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at               TIMESTAMPTZ,
  CONSTRAINT uq_asset_briefs_tenant_pk UNIQUE (workspace_id, asset_brief_id),
  CONSTRAINT fk_asset_briefs_script_id_tenant
    FOREIGN KEY (workspace_id, script_id) REFERENCES scripts(workspace_id, script_id) ON DELETE CASCADE,
  CONSTRAINT chk_asset_briefs_status
    CHECK (status IN ('draft', 'ready', 'locked', 'superseded'))
);

CREATE INDEX IF NOT EXISTS idx_asset_briefs_workspace ON asset_briefs(workspace_id);
CREATE INDEX IF NOT EXISTS idx_asset_briefs_script ON asset_briefs(workspace_id, script_id);
CREATE INDEX IF NOT EXISTS idx_asset_briefs_status ON asset_briefs(workspace_id, status);

ALTER TABLE asset_briefs ENABLE ROW LEVEL SECURITY;
ALTER TABLE asset_briefs FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON asset_briefs;
CREATE POLICY tenant_isolation ON asset_briefs
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON asset_briefs;
CREATE POLICY admin_ops_scope ON asset_briefs
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON asset_briefs TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON asset_briefs TO admin_user;

-- ----------------------------------------------------------------------------
-- 3. scenes & shot_lists Tables (§6.6)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS scenes (
  scene_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  script_id        UUID NOT NULL,
  workspace_id     UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  scene_index      SMALLINT NOT NULL,
  description      TEXT,
  duration_seconds INTEGER DEFAULT 10,
  visual_notes     TEXT,
  audio_notes      TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_scenes_tenant_pk UNIQUE (workspace_id, scene_id),
  CONSTRAINT fk_scenes_script_id_tenant
    FOREIGN KEY (workspace_id, script_id) REFERENCES scripts(workspace_id, script_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_scenes_workspace_script ON scenes(workspace_id, script_id, scene_index);

ALTER TABLE scenes ENABLE ROW LEVEL SECURITY;
ALTER TABLE scenes FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON scenes;
CREATE POLICY tenant_isolation ON scenes
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON scenes;
CREATE POLICY admin_ops_scope ON scenes
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON scenes TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON scenes TO admin_user;

CREATE TABLE IF NOT EXISTS shot_lists (
  shot_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  scene_id         UUID NOT NULL,
  workspace_id     UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  shot_index       SMALLINT NOT NULL,
  shot_type        VARCHAR(50) DEFAULT 'close_up',
  description      TEXT,
  duration_seconds INTEGER DEFAULT 5,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_shot_lists_tenant_pk UNIQUE (workspace_id, shot_id),
  CONSTRAINT fk_shot_lists_scene_id_tenant
    FOREIGN KEY (workspace_id, scene_id) REFERENCES scenes(workspace_id, scene_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_shot_lists_workspace_scene ON shot_lists(workspace_id, scene_id, shot_index);

ALTER TABLE shot_lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE shot_lists FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON shot_lists;
CREATE POLICY tenant_isolation ON shot_lists
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON shot_lists;
CREATE POLICY admin_ops_scope ON shot_lists
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON shot_lists TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON shot_lists TO admin_user;

-- ----------------------------------------------------------------------------
-- 4. approval_requests Table (§18.1)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS approval_requests (
  request_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id     UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  request_type     VARCHAR(50) NOT NULL,
  object_type      VARCHAR(50) NOT NULL,
  object_id        UUID NOT NULL,
  requested_by     UUID NOT NULL REFERENCES users(user_id),
  approved_by      UUID REFERENCES users(user_id),
  status           VARCHAR(20) NOT NULL DEFAULT 'not_required',
  reason           TEXT,
  rejection_reason TEXT,
  expires_at       TIMESTAMPTZ,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_approval_requests_tenant_pk UNIQUE (workspace_id, request_id),
  CONSTRAINT chk_approval_requests_status
    CHECK (status IN ('not_required', 'pending_approval', 'approved', 'rejected', 'expired', 'cancelled'))
);

CREATE INDEX IF NOT EXISTS idx_approval_requests_workspace ON approval_requests(workspace_id);
CREATE INDEX IF NOT EXISTS idx_ar_status ON approval_requests(workspace_id, status);
CREATE INDEX IF NOT EXISTS idx_ar_object ON approval_requests(workspace_id, object_type, object_id);

ALTER TABLE approval_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE approval_requests FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON approval_requests;
CREATE POLICY tenant_isolation ON approval_requests
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON approval_requests;
CREATE POLICY admin_ops_scope ON approval_requests
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON approval_requests TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON approval_requests TO admin_user;

-- ----------------------------------------------------------------------------
-- 5. script_versions Table (Version diff and audit trail)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS script_versions (
  version_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  script_id               UUID NOT NULL,
  version_index           INTEGER NOT NULL,
  title                   VARCHAR(500) NOT NULL,
  body                    JSONB NOT NULL DEFAULT '[]',
  cta_blocks              JSONB DEFAULT '[]',
  disclosure_blocks       JSONB DEFAULT '[]',
  duration_target_seconds INTEGER DEFAULT 60,
  lifecycle_state         VARCHAR(30) NOT NULL,
  approval_state          VARCHAR(20) NOT NULL,
  snapshot_reason         VARCHAR(100) DEFAULT 'edit',
  created_by              UUID REFERENCES users(user_id),
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_script_versions_tenant_pk UNIQUE (workspace_id, version_id),
  CONSTRAINT fk_script_versions_script_id_tenant
    FOREIGN KEY (workspace_id, script_id) REFERENCES scripts(workspace_id, script_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_script_versions_script ON script_versions(workspace_id, script_id, version_index);

ALTER TABLE script_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE script_versions FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON script_versions;
CREATE POLICY tenant_isolation ON script_versions
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON script_versions;
CREATE POLICY admin_ops_scope ON script_versions
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON script_versions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON script_versions TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON script_versions FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON script_versions FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON script_versions;
DROP POLICY IF EXISTS tenant_isolation ON script_versions;
DROP TABLE IF EXISTS script_versions CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON approval_requests FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON approval_requests FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON approval_requests;
DROP POLICY IF EXISTS tenant_isolation ON approval_requests;
DROP TABLE IF EXISTS approval_requests CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON shot_lists FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON shot_lists FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON shot_lists;
DROP POLICY IF EXISTS tenant_isolation ON shot_lists;
DROP TABLE IF EXISTS shot_lists CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON scenes FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON scenes FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON scenes;
DROP POLICY IF EXISTS tenant_isolation ON scenes;
DROP TABLE IF EXISTS scenes CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON asset_briefs FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON asset_briefs FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON asset_briefs;
DROP POLICY IF EXISTS tenant_isolation ON asset_briefs;
DROP TABLE IF EXISTS asset_briefs CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON scripts FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON scripts FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON scripts;
DROP POLICY IF EXISTS tenant_isolation ON scripts;
DROP TABLE IF EXISTS scripts CASCADE;

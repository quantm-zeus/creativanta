-- ============================================================================
-- Creativanta P3-01 Migration: Ideas Engine, Hooks Bank & Deduplication (M05)
-- Canonical Source: docs/04_contracts/database_schema.md (§6.1, §6.2, §6.3)
--                   docs/02_features/content/idea_engine.md (RULE-M05-001–006, EC-M05-001–004)
--                   docs/04_contracts/domain_event_catalog.md (§4)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Extend ideas table with embedding vector & provenance metadata (§6.1)
-- ----------------------------------------------------------------------------
ALTER TABLE ideas ADD COLUMN IF NOT EXISTS embedding_vector FLOAT8[] DEFAULT '{}';
ALTER TABLE ideas ADD COLUMN IF NOT EXISTS source_class VARCHAR(20) DEFAULT 'inferred';
ALTER TABLE ideas ADD COLUMN IF NOT EXISTS confidence_band VARCHAR(20) DEFAULT 'medium';

-- Ensure index on workspace and status for efficient retrieval
CREATE INDEX IF NOT EXISTS idx_ideas_workspace_status ON ideas(workspace_id, status);

-- ----------------------------------------------------------------------------
-- 2. Hooks Table (§6.3)
--    Enables structured hook bank storage, categorizing hooks (question, shock,
--    story, pov, listicle, contrast) with source attribution and effectiveness.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS hooks (
  hook_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id        UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  idea_id             UUID,
  hook_text           TEXT NOT NULL,
  hook_type           VARCHAR(50) DEFAULT 'question'
                      CHECK (hook_type IN ('question', 'shock', 'story', 'pov', 'listicle', 'contrast')),
  effectiveness_score REAL DEFAULT 0,
  usage_count         INTEGER DEFAULT 0,
  source              VARCHAR(50) DEFAULT 'manual'
                      CHECK (source IN ('manual', 'ai_generated', 'library')),
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at          TIMESTAMPTZ,
  CONSTRAINT uq_hooks_tenant_pk UNIQUE (workspace_id, hook_id),
  CONSTRAINT fk_hooks_idea_id_tenant
    FOREIGN KEY (workspace_id, idea_id) REFERENCES ideas(workspace_id, idea_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_hooks_workspace ON hooks(workspace_id);
CREATE INDEX IF NOT EXISTS idx_hooks_idea ON hooks(workspace_id, idea_id);
CREATE INDEX IF NOT EXISTS idx_hooks_type ON hooks(workspace_id, hook_type);

-- ----------------------------------------------------------------------------
-- 3. Direct RLS Policies (§1, §6.3)
-- ----------------------------------------------------------------------------
ALTER TABLE hooks ENABLE ROW LEVEL SECURITY;
ALTER TABLE hooks FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON hooks;
CREATE POLICY tenant_isolation ON hooks
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON hooks;
CREATE POLICY admin_ops_scope ON hooks
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 4. Narrow Role Grants (§26.12 — NEVER GRANT ALL)
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON hooks TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON hooks TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON hooks FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON hooks FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON hooks;
DROP POLICY IF EXISTS tenant_isolation ON hooks;
DROP TABLE IF EXISTS hooks CASCADE;
DROP INDEX IF EXISTS idx_ideas_workspace_status;
ALTER TABLE ideas DROP COLUMN IF EXISTS confidence_band;
ALTER TABLE ideas DROP COLUMN IF EXISTS source_class;
ALTER TABLE ideas DROP COLUMN IF EXISTS embedding_vector;

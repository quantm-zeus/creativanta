-- ============================================================================
-- Creativanta P3-04 Migration: Copilot Sessions & Operations Assistance (copilot)
-- Canonical Sources: docs/04_contracts/database_schema.md (§19.12)
--                    docs/02_features/platform/copilot.md (RULE-COP-001–008, EC-COP-001–003)
--                    docs/04_contracts/domain_event_catalog.md (§15)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.15)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. copilot_sessions Table (§19.12)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS copilot_sessions (
  session_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id       UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  user_id            UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  mode               VARCHAR(20) NOT NULL, -- creative, analytics, action, video_production, help
  context_scope      VARCHAR(50),
  messages           JSONB DEFAULT '[]', -- [{role, content, timestamp, actions}]
  total_credits_used NUMERIC(18,6) NOT NULL DEFAULT 0, -- DB-H-001: credit amount (not counter)
  ended_at           TIMESTAMPTZ,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_copilot_sessions_tenant_pk UNIQUE (workspace_id, session_id),
  CONSTRAINT fk_copilot_sessions_member_tenant
    FOREIGN KEY (workspace_id, user_id) REFERENCES workspace_members(workspace_id, user_id) ON DELETE CASCADE,
  CONSTRAINT chk_copilot_sessions_mode
    CHECK (mode IN ('creative', 'analytics', 'action', 'video_production', 'help')),
  CONSTRAINT chk_copilot_sessions_credits
    CHECK (total_credits_used >= 0)
);

CREATE INDEX IF NOT EXISTS idx_copilot_sessions_workspace ON copilot_sessions(workspace_id);
CREATE INDEX IF NOT EXISTS idx_cs_user ON copilot_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_copilot_sessions_workspace_user ON copilot_sessions(workspace_id, user_id);
CREATE INDEX IF NOT EXISTS idx_copilot_sessions_history ON copilot_sessions(workspace_id, user_id, created_at DESC);

ALTER TABLE copilot_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE copilot_sessions FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON copilot_sessions;
CREATE POLICY tenant_isolation ON copilot_sessions
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON copilot_sessions;
CREATE POLICY admin_ops_scope ON copilot_sessions
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON copilot_sessions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON copilot_sessions TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON copilot_sessions FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON copilot_sessions FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON copilot_sessions;
DROP POLICY IF EXISTS tenant_isolation ON copilot_sessions;
DROP TABLE IF EXISTS copilot_sessions CASCADE;

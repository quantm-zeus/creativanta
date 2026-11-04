-- ============================================================================
-- Creativanta P5-02 Migration: Engagement Messages, Follow-up Tasks & Protection
-- Canonical Sources: docs/04_contracts/database_schema.md (§9.2, §9.3, §9.4)
--                    docs/02_features/engagement/unified_inbox.md (RULE-M12-001..008)
--                    docs/04_contracts/domain_event_catalog.md (§7, §16.4)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.6)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. messages Table (§9.3)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS messages (
  message_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id        UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  thread_id           UUID NOT NULL,
  subtype             VARCHAR(20) NOT NULL, -- comment, dm, inquiry, reply, system
  source_platform     VARCHAR(50),
  body                TEXT,
  author_direction    VARCHAR(10) NOT NULL, -- inbound, outbound, system
  author_entity_id    UUID REFERENCES entities(entity_id),
  author_user_id      UUID REFERENCES users(user_id),
  moderation_state    VARCHAR(20) DEFAULT 'visible', -- visible, hidden, flagged, deleted
  intent_overlay      VARCHAR(50),
  attachments         JSONB DEFAULT '[]'::jsonb,
  external_message_id VARCHAR(255),
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_messages_tenant_pk UNIQUE (workspace_id, message_id),
  CONSTRAINT fk_messages_thread_tenant
    FOREIGN KEY (workspace_id, thread_id) REFERENCES threads(workspace_id, thread_id) ON DELETE CASCADE,
  CONSTRAINT chk_messages_direction
    CHECK (author_direction IN ('inbound', 'outbound', 'system')),
  CONSTRAINT chk_messages_subtype
    CHECK (subtype IN ('comment', 'dm', 'inquiry', 'reply', 'system'))
);

CREATE INDEX IF NOT EXISTS idx_messages_workspace ON messages(workspace_id);
CREATE INDEX IF NOT EXISTS idx_messages_thread ON messages(workspace_id, thread_id);
CREATE INDEX IF NOT EXISTS idx_messages_created ON messages(workspace_id, created_at);

ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON messages;
CREATE POLICY tenant_isolation ON messages
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON messages;
CREATE POLICY admin_ops_scope ON messages
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 2. follow_up_tasks Table (§9.4)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS follow_up_tasks (
  task_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id        UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  source_thread_id    UUID,
  source_object_type  VARCHAR(50),
  source_object_id    UUID,
  assigned_user_id    UUID REFERENCES users(user_id),
  task_type           VARCHAR(50) NOT NULL,
  title               VARCHAR(500) NOT NULL,
  description         TEXT,
  due_at              TIMESTAMPTZ,
  status              VARCHAR(20) NOT NULL DEFAULT 'open', -- open, in_progress, blocked, completed, cancelled
  outcome_summary     TEXT,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at          TIMESTAMPTZ, -- soft delete (DB-H-003)
  CONSTRAINT uq_follow_up_tasks_tenant_pk UNIQUE (workspace_id, task_id),
  CONSTRAINT fk_follow_up_tasks_thread_tenant
    FOREIGN KEY (workspace_id, source_thread_id) REFERENCES threads(workspace_id, thread_id) ON DELETE SET NULL,
  CONSTRAINT chk_follow_up_tasks_status
    CHECK (status IN ('open', 'in_progress', 'blocked', 'completed', 'cancelled'))
);

CREATE INDEX IF NOT EXISTS idx_ft_workspace ON follow_up_tasks(workspace_id);
CREATE INDEX IF NOT EXISTS idx_ft_assigned ON follow_up_tasks(workspace_id, assigned_user_id);
CREATE INDEX IF NOT EXISTS idx_ft_status ON follow_up_tasks(workspace_id, status);
CREATE INDEX IF NOT EXISTS idx_ft_thread ON follow_up_tasks(workspace_id, source_thread_id);

ALTER TABLE follow_up_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE follow_up_tasks FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON follow_up_tasks;
CREATE POLICY tenant_isolation ON follow_up_tasks
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON follow_up_tasks;
CREATE POLICY admin_ops_scope ON follow_up_tasks
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. engagement_throttles Table (Viral surge & ingestion protection - RULE-M12-007)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS engagement_throttles (
  throttle_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id          UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  current_rate_per_min  INTEGER NOT NULL DEFAULT 0,
  throttle_mode         VARCHAR(30) NOT NULL DEFAULT 'normal', -- normal, throttled, circuit_breaker
  unprocessed_raw_count INTEGER NOT NULL DEFAULT 0,
  last_surge_at         TIMESTAMPTZ,
  last_evaluated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_engagement_throttles_tenant_pk UNIQUE (workspace_id, throttle_id),
  CONSTRAINT uq_engagement_throttles_workspace UNIQUE (workspace_id),
  CONSTRAINT chk_engagement_throttle_mode
    CHECK (throttle_mode IN ('normal', 'throttled', 'circuit_breaker'))
);

CREATE INDEX IF NOT EXISTS idx_et_workspace ON engagement_throttles(workspace_id);

ALTER TABLE engagement_throttles ENABLE ROW LEVEL SECURITY;
ALTER TABLE engagement_throttles FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON engagement_throttles;
CREATE POLICY tenant_isolation ON engagement_throttles
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON engagement_throttles;
CREATE POLICY admin_ops_scope ON engagement_throttles
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 4. threads Table Enhancements (Messaging window, bot-loop, ghost & revoked account)
-- ----------------------------------------------------------------------------
ALTER TABLE threads
  ADD COLUMN IF NOT EXISTS messaging_window_expires_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS auto_reply_paused BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS auto_reply_consecutive_count INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS auto_reply_hour_count INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS last_auto_reply_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS auto_reply_permanently_disabled BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS is_ghost BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS ghost_status VARCHAR(50) NOT NULL DEFAULT 'none',
  ADD COLUMN IF NOT EXISTS throttle_state VARCHAR(30) NOT NULL DEFAULT 'normal',
  ADD COLUMN IF NOT EXISTS connected_account_id UUID REFERENCES connected_accounts(connected_account_id),
  ADD COLUMN IF NOT EXISTS account_revoked BOOLEAN NOT NULL DEFAULT false;

CREATE INDEX IF NOT EXISTS idx_threads_msg_window ON threads(workspace_id, messaging_window_expires_at);
CREATE INDEX IF NOT EXISTS idx_threads_conn_account ON threads(workspace_id, connected_account_id);

-- ----------------------------------------------------------------------------
-- 5. Role Grants
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON messages TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON messages TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON follow_up_tasks TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON follow_up_tasks TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON engagement_throttles TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON engagement_throttles TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON engagement_throttles FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON engagement_throttles FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON engagement_throttles;
DROP POLICY IF EXISTS tenant_isolation ON engagement_throttles;
DROP TABLE IF EXISTS engagement_throttles CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON follow_up_tasks FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON follow_up_tasks FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON follow_up_tasks;
DROP POLICY IF EXISTS tenant_isolation ON follow_up_tasks;
DROP TABLE IF EXISTS follow_up_tasks CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON messages FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON messages FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON messages;
DROP POLICY IF EXISTS tenant_isolation ON messages;
DROP TABLE IF EXISTS messages CASCADE;

DROP INDEX IF EXISTS idx_threads_conn_account;
DROP INDEX IF EXISTS idx_threads_msg_window;

ALTER TABLE threads
  DROP COLUMN IF EXISTS account_revoked,
  DROP COLUMN IF EXISTS connected_account_id,
  DROP COLUMN IF EXISTS throttle_state,
  DROP COLUMN IF EXISTS ghost_status,
  DROP COLUMN IF EXISTS is_ghost,
  DROP COLUMN IF EXISTS auto_reply_permanently_disabled,
  DROP COLUMN IF EXISTS last_auto_reply_at,
  DROP COLUMN IF EXISTS auto_reply_hour_count,
  DROP COLUMN IF EXISTS auto_reply_consecutive_count,
  DROP COLUMN IF EXISTS auto_reply_paused,
  DROP COLUMN IF EXISTS messaging_window_expires_at;

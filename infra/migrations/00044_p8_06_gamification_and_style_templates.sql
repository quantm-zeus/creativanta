-- ============================================================================
-- Creativanta P8-06 Migration: Gamification, Streaks, Quests & Style-Template Sharing
-- Canonical Sources: docs/04_contracts/database_schema.md (§14.1, §14.2, §22.10, §22.11, §27.4, §12.3B)
--                    docs/02_features/platform/gamification.md (RULE-GAM-001..008)
--                    docs/02_features/production/ai_video_studio.md (EF-07A, EF-11)
--                    docs/02_features/automation/recipe_agent_center.md (Style template extension)
--                    docs/04_contracts/domain_event_catalog.md (§14, §15C)
--                    docs/04_contracts/rbac_permission_matrix.md
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Creator Progress Extensions (EF-11, EC-GAM-001)
-- ----------------------------------------------------------------------------
ALTER TABLE creator_progress
  ADD COLUMN IF NOT EXISTS streak_grace_until TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS last_activity_at TIMESTAMPTZ;

CREATE INDEX IF NOT EXISTS idx_cp_xp_level ON creator_progress(xp DESC, level DESC);
CREATE INDEX IF NOT EXISTS idx_cp_user_score ON creator_progress(user_id, creator_score DESC);

-- ----------------------------------------------------------------------------
-- 2. Recipe Installations Extensions for Style Templates (EF-07A, §27.4)
-- ----------------------------------------------------------------------------
ALTER TABLE recipe_installations
  ADD COLUMN IF NOT EXISTS continuity_pack_id UUID REFERENCES continuity_packs(pack_id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS style_pack_id UUID REFERENCES style_packs(style_pack_id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS template_kind VARCHAR(30) DEFAULT 'workflow',
  ADD COLUMN IF NOT EXISTS immutable_install_audit JSONB DEFAULT '{}';

CREATE INDEX IF NOT EXISTS idx_ri_continuity_pack ON recipe_installations(continuity_pack_id);
CREATE INDEX IF NOT EXISTS idx_ri_style_pack ON recipe_installations(style_pack_id);

-- ----------------------------------------------------------------------------
-- 3. Gamification Reward Events Table (Acceptance Target 2: Reward Event Replay Once)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS gamification_reward_events (
  event_id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id                UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  user_id                     UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  event_key                   VARCHAR(255) NOT NULL, -- "achievement:<code_or_id>", "streak:<days>", "challenge:<id>"
  event_type                  VARCHAR(100) NOT NULL,
  credits_awarded             NUMERIC(18,6) NOT NULL DEFAULT 0,
  xp_awarded                  INTEGER NOT NULL DEFAULT 0,
  idempotency_key             VARCHAR(255) NOT NULL,
  status                      VARCHAR(30) NOT NULL DEFAULT 'awarded'
    CHECK (status IN ('awarded', 'skipped', 'reversed')),
  processed_at                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  metadata                    JSONB DEFAULT '{}',
  CONSTRAINT uq_gamification_reward_event UNIQUE (workspace_id, user_id, event_key)
);

CREATE INDEX IF NOT EXISTS idx_gre_workspace_user ON gamification_reward_events(workspace_id, user_id);
CREATE INDEX IF NOT EXISTS idx_gre_idempotency ON gamification_reward_events(idempotency_key);
CREATE INDEX IF NOT EXISTS idx_gre_processed_at ON gamification_reward_events(processed_at DESC);

ALTER TABLE gamification_reward_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE gamification_reward_events FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON gamification_reward_events;
CREATE POLICY tenant_isolation ON gamification_reward_events
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON gamification_reward_events;
CREATE POLICY admin_ops_scope ON gamification_reward_events
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON gamification_reward_events TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON gamification_reward_events TO admin_user;

-- ----------------------------------------------------------------------------
-- 4. Indexes for Challenge Definitions and Progress (§22.10, §22.11)
-- ----------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_cd_dates ON challenge_definitions(start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_chp_challenge ON challenge_progress(challenge_id);
CREATE INDEX IF NOT EXISTS idx_chp_completion ON challenge_progress(completed, reward_credited);

-- +goose Down
DROP INDEX IF EXISTS idx_chp_completion;
DROP INDEX IF EXISTS idx_chp_challenge;
DROP INDEX IF EXISTS idx_cd_dates;

REVOKE SELECT, INSERT, UPDATE, DELETE ON gamification_reward_events FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON gamification_reward_events FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON gamification_reward_events;
DROP POLICY IF EXISTS tenant_isolation ON gamification_reward_events;
DROP TABLE IF EXISTS gamification_reward_events CASCADE;

DROP INDEX IF EXISTS idx_ri_style_pack;
DROP INDEX IF EXISTS idx_ri_continuity_pack;
ALTER TABLE recipe_installations
  DROP COLUMN IF EXISTS immutable_install_audit,
  DROP COLUMN IF EXISTS template_kind,
  DROP COLUMN IF EXISTS style_pack_id,
  DROP COLUMN IF EXISTS continuity_pack_id;

DROP INDEX IF EXISTS idx_cp_user_score;
DROP INDEX IF EXISTS idx_cp_xp_level;
ALTER TABLE creator_progress
  DROP COLUMN IF EXISTS last_activity_at,
  DROP COLUMN IF EXISTS streak_grace_until;

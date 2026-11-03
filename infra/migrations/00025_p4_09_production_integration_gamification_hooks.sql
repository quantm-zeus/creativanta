-- ============================================================================
-- Creativanta P4-09 Migration: Production Integration Acceptance & Gamification Hooks
-- Canonical Sources: docs/04_contracts/database_schema.md (§14.1, §14.2, §22.10, §22.11)
--                    docs/02_features/platform/gamification.md (RULE-GAM-001..008)
--                    docs/04_contracts/domain_event_catalog.md (§13, §14, §15)
--                    docs/04_contracts/rbac_permission_matrix.md
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. creator_progress Table (§14.1)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS creator_progress (
  progress_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id                UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  user_id                     UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  level                       SMALLINT NOT NULL DEFAULT 1,
  xp                          INTEGER NOT NULL DEFAULT 0,
  xp_to_next_level            INTEGER NOT NULL DEFAULT 100,
  streak_days                 INTEGER NOT NULL DEFAULT 0,
  streak_last_activity_date   DATE,
  creator_score               REAL DEFAULT 0,
  total_achievements          INTEGER DEFAULT 0,
  season_id                   VARCHAR(50),
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_creator_progress_tenant_user UNIQUE (workspace_id, user_id),
  CONSTRAINT chk_creator_progress_level CHECK (level >= 1),
  CONSTRAINT chk_creator_progress_xp CHECK (xp >= 0),
  CONSTRAINT chk_creator_progress_streak CHECK (streak_days >= 0)
);

CREATE INDEX IF NOT EXISTS idx_cp_workspace_user ON creator_progress(workspace_id, user_id);
CREATE INDEX IF NOT EXISTS idx_cp_streak ON creator_progress(streak_days DESC);

ALTER TABLE creator_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE creator_progress FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON creator_progress;
CREATE POLICY tenant_isolation ON creator_progress
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON creator_progress;
CREATE POLICY admin_ops_scope ON creator_progress
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 2. achievement_definitions Table (§14.2)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS achievement_definitions (
  achievement_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code                        VARCHAR(100) UNIQUE NOT NULL,
  title                       VARCHAR(255) NOT NULL,
  description                 TEXT,
  trigger_condition           JSONB NOT NULL DEFAULT '{}',
  reward_credits              INTEGER NOT NULL DEFAULT 0,
  badge_image_url             TEXT,
  category                    VARCHAR(50) DEFAULT 'milestone',
  sort_order                  SMALLINT DEFAULT 0,
  active                      BOOLEAN DEFAULT true,
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ad_code ON achievement_definitions(code);
CREATE INDEX IF NOT EXISTS idx_ad_category ON achievement_definitions(category);

-- Global catalog definitions accessible to app_user and admin_user

-- ----------------------------------------------------------------------------
-- 3. achievement_records Table (§14.2)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS achievement_records (
  record_id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id                UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  user_id                     UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  achievement_id              UUID NOT NULL REFERENCES achievement_definitions(achievement_id) ON DELETE CASCADE,
  earned_at                   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  credits_awarded             NUMERIC(18,6) NOT NULL DEFAULT 0,
  CONSTRAINT uq_achievement_records_tenant_user_ach UNIQUE (workspace_id, user_id, achievement_id)
);

CREATE INDEX IF NOT EXISTS idx_ar_workspace_user ON achievement_records(workspace_id, user_id);
CREATE INDEX IF NOT EXISTS idx_ar_achievement ON achievement_records(achievement_id);

ALTER TABLE achievement_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE achievement_records FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON achievement_records;
CREATE POLICY tenant_isolation ON achievement_records
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON achievement_records;
CREATE POLICY admin_ops_scope ON achievement_records
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 4. challenge_definitions Table (§22.10)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS challenge_definitions (
  challenge_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title                       VARCHAR(255) NOT NULL,
  description                 TEXT,
  challenge_type              VARCHAR(30) NOT NULL,
  target_value                INTEGER NOT NULL,
  reward_credits              INTEGER NOT NULL DEFAULT 0,
  start_date                  DATE NOT NULL,
  end_date                    DATE NOT NULL,
  status                      VARCHAR(20) NOT NULL DEFAULT 'draft'
    CHECK (status IN ('draft', 'enrolling', 'active', 'completed', 'rewarded', 'cancelled')),
  is_active                   BOOLEAN DEFAULT false,
  sort_order                  SMALLINT DEFAULT 0,
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_cd_status ON challenge_definitions(status);

-- ----------------------------------------------------------------------------
-- 5. challenge_progress Table (§22.11)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS challenge_progress (
  progress_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id                UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  user_id                     UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  challenge_id                UUID NOT NULL REFERENCES challenge_definitions(challenge_id) ON DELETE CASCADE,
  current_value               INTEGER NOT NULL DEFAULT 0,
  target_value                INTEGER NOT NULL,
  completed                   BOOLEAN DEFAULT false,
  completed_at                TIMESTAMPTZ,
  reward_credited             BOOLEAN DEFAULT false,
  reward_transaction_id       UUID,
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_challenge_progress_tenant_user_ch UNIQUE (workspace_id, user_id, challenge_id),
  CONSTRAINT fk_challenge_progress_reward_transaction_id_tenant
    FOREIGN KEY (workspace_id, reward_transaction_id)
    REFERENCES ai_credit_transactions(workspace_id, transaction_id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_chp_workspace ON challenge_progress(workspace_id);
CREATE INDEX IF NOT EXISTS idx_chp_user ON challenge_progress(user_id);

ALTER TABLE challenge_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenge_progress FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON challenge_progress;
CREATE POLICY tenant_isolation ON challenge_progress
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON challenge_progress;
CREATE POLICY admin_ops_scope ON challenge_progress
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 6. Initial Seed Achievement Definitions (§14.2)
-- ----------------------------------------------------------------------------
INSERT INTO achievement_definitions (code, title, description, trigger_condition, reward_credits, category, sort_order)
VALUES
  ('first_video_generated', 'Khởi Đầu Sáng Tạo', 'Tạo video AI đầu tiên thành công trong hệ thống', '{"event": "asset.generation_completed", "count": 1}'::jsonb, 10, 'milestone', 1),
  ('remix_pioneer', 'Bậc Thầy Chuyển Thể', 'Tạo video AI Remix đạt kiểm tra tính nguyên bản <30%', '{"event": "production.remix.generation_completed", "count": 1}'::jsonb, 15, 'content', 2),
  ('clip_master', 'Chuyên Gia Viral Clips', 'Trích xuất và đề xuất clips thành công từ Clip Factory', '{"event": "clip.extracted", "count": 1}'::jsonb, 15, 'content', 3),
  ('streak_7_day', 'Sáng Tạo Kiên Trì', 'Duy trì chuỗi hoạt động 7 ngày liên tiếp', '{"streak_days": 7}'::jsonb, 50, 'streak', 4),
  ('first_video_published', 'Bước Ra Thế Giới', 'Xuất bản video đầu tiên lên mạng xã hội', '{"event": "publish.completed", "count": 1}'::jsonb, 10, 'milestone', 5)
ON CONFLICT (code) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 7. Role Grants
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON creator_progress TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON creator_progress TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON achievement_definitions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON achievement_definitions TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON achievement_records TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON achievement_records TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON challenge_definitions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON challenge_definitions TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON challenge_progress TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON challenge_progress TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON challenge_progress FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON challenge_progress FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON challenge_progress;
DROP POLICY IF EXISTS tenant_isolation ON challenge_progress;
DROP TABLE IF EXISTS challenge_progress CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON challenge_definitions FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON challenge_definitions FROM app_user;
DROP TABLE IF EXISTS challenge_definitions CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON achievement_records FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON achievement_records FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON achievement_records;
DROP POLICY IF EXISTS tenant_isolation ON achievement_records;
DROP TABLE IF EXISTS achievement_records CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON achievement_definitions FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON achievement_definitions FROM app_user;
DROP TABLE IF EXISTS achievement_definitions CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON creator_progress FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON creator_progress FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON creator_progress;
DROP POLICY IF EXISTS tenant_isolation ON creator_progress;
DROP TABLE IF EXISTS creator_progress CASCADE;

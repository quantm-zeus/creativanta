-- ============================================================================
-- Creativanta P8-04 Migration: Help Center, Beta Program, Status Page & Support SLAs
-- Canonical Sources:
--   - docs/04_contracts/database_schema.md (§17.7 system_announcements, §17.8 support_tickets, §17.9 support_ticket_messages, §17.9A–§17.9D, §17.10 incidents)
--   - docs/02_features/platform/help_center.md (help)
--   - docs/01_business/legal_compliance.md (§7 Customer Support Operations & SLAs)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Beta Program Enrollments (§4.1 Participation Rules, Beta Grant Once)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS beta_enrollments (
  workspace_id           UUID PRIMARY KEY REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  user_id                UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  tier                   VARCHAR(20) NOT NULL,
  status                 VARCHAR(20) NOT NULL DEFAULT 'active'
                           CHECK (status IN ('active', 'opted_out')),
  bonus_credits_granted  BOOLEAN NOT NULL DEFAULT true,
  bonus_credits_amount   INTEGER NOT NULL DEFAULT 50,
  enrolled_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  opted_out_at           TIMESTAMPTZ,
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE beta_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE beta_enrollments FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON beta_enrollments;
CREATE POLICY tenant_isolation ON beta_enrollments
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON beta_enrollments;
CREATE POLICY admin_ops_scope ON beta_enrollments
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 2. Beta Feature Feedback & Bug Capture (§4.3 Feedback Collection)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS beta_feedbacks (
  feedback_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  user_id                UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  feature_key            VARCHAR(100) NOT NULL,
  rating                 SMALLINT NOT NULL CHECK (rating >= 1 AND rating <= 5),
  feedback_text          TEXT,
  is_bug_report          BOOLEAN NOT NULL DEFAULT false,
  client_context         JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_beta_feedbacks_tenant_pk UNIQUE (workspace_id, feedback_id)
);

CREATE INDEX IF NOT EXISTS idx_beta_feedbacks_feature ON beta_feedbacks(feature_key, rating);

ALTER TABLE beta_feedbacks ENABLE ROW LEVEL SECURITY;
ALTER TABLE beta_feedbacks FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON beta_feedbacks;
CREATE POLICY tenant_isolation ON beta_feedbacks
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON beta_feedbacks;
CREATE POLICY admin_ops_scope ON beta_feedbacks
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. Public Status Page Subscribers [GLOBAL] (§5.4 Subscription Privacy)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS status_subscribers (
  subscriber_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email                  VARCHAR(255),
  webhook_url            TEXT,
  channel                VARCHAR(20) NOT NULL CHECK (channel IN ('email', 'webhook', 'rss')),
  status                 VARCHAR(20) NOT NULL DEFAULT 'active'
                           CHECK (status IN ('active', 'unsubscribed', 'pending_verification')),
  privacy_token_hash     VARCHAR(128) NOT NULL,
  component_filter       JSONB NOT NULL DEFAULT '[]'::jsonb,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  unsubscribed_at        TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_status_sub_token ON status_subscribers(privacy_token_hash);
CREATE INDEX IF NOT EXISTS idx_status_sub_active ON status_subscribers(status, channel);

-- ----------------------------------------------------------------------------
-- 4. In-App Announcement Session & User Dismissals (§3.2 Dismissal System)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS announcement_dismissals (
  dismissal_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  user_id                UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  announcement_id        UUID NOT NULL REFERENCES system_announcements(announcement_id) ON DELETE CASCADE,
  dismissed_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_announcement_dismissal_tenant_pk UNIQUE (workspace_id, dismissal_id),
  CONSTRAINT uq_announcement_user_dismissal UNIQUE (workspace_id, user_id, announcement_id)
);

CREATE INDEX IF NOT EXISTS idx_ann_dismiss_user ON announcement_dismissals(user_id, announcement_id);

ALTER TABLE announcement_dismissals ENABLE ROW LEVEL SECURITY;
ALTER TABLE announcement_dismissals FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON announcement_dismissals;
CREATE POLICY tenant_isolation ON announcement_dismissals
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON announcement_dismissals;
CREATE POLICY admin_ops_scope ON announcement_dismissals
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 5. Enhanced KB Article Review Tracking (§2.4 Stale Review & Quality Queue)
-- ----------------------------------------------------------------------------
ALTER TABLE kb_articles
  ADD COLUMN IF NOT EXISTS last_reviewed_by UUID REFERENCES internal_admins(admin_id),
  ADD COLUMN IF NOT EXISTS review_notes TEXT;

-- ----------------------------------------------------------------------------
-- 6. Role grants and permissions (§26.12)
-- ----------------------------------------------------------------------------
REVOKE ALL ON
  beta_enrollments,
  beta_feedbacks,
  status_subscribers,
  announcement_dismissals
FROM PUBLIC;

GRANT SELECT, INSERT, UPDATE, DELETE ON
  beta_enrollments,
  beta_feedbacks,
  announcement_dismissals
TO app_user;

GRANT SELECT, INSERT, UPDATE ON
  status_subscribers
TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON
  beta_enrollments,
  beta_feedbacks,
  status_subscribers,
  announcement_dismissals
TO admin_user;

-- +goose Down
REVOKE ALL PRIVILEGES ON
  beta_enrollments,
  beta_feedbacks,
  status_subscribers,
  announcement_dismissals
FROM app_user, admin_user;

DROP TABLE IF EXISTS announcement_dismissals;
DROP TABLE IF EXISTS status_subscribers;
DROP TABLE IF EXISTS beta_feedbacks;
DROP TABLE IF EXISTS beta_enrollments;

ALTER TABLE kb_articles
  DROP COLUMN IF EXISTS review_notes,
  DROP COLUMN IF EXISTS last_reviewed_by;

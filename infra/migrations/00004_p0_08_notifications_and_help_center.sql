-- +goose Up
-- =============================================================================
-- P0-08: Shells, notifications và help entry
-- Canonical sources:
--   - docs/04_contracts/database_schema.md (§13.5, §17.8, §17.9, §17.9A–§17.9D, §26.11–§26.13)
--   - docs/02_features/platform/home_decision_engine.md (M01)
--   - docs/02_features/platform/help_center.md (help)
--   - docs/02_features/platform/reporting_admin_billing.md (M23)
-- =============================================================================

-- 1. Scoped notifications (§13.5)
CREATE TABLE IF NOT EXISTS notifications (
  notification_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id        UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  user_id             UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  priority            VARCHAR(10) NOT NULL DEFAULT 'normal', -- urgent, high, normal, low
  channel             VARCHAR(20) NOT NULL DEFAULT 'in_app', -- in_app, push, email
  title               VARCHAR(255) NOT NULL,
  body                TEXT,
  deep_link           TEXT,
  action_buttons      JSONB NOT NULL DEFAULT '[]'::jsonb,
  grouped_key         VARCHAR(100),
  read_at             TIMESTAMPTZ,
  dismissed_at        TIMESTAMPTZ,
  delivered_at        TIMESTAMPTZ,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_notif_user ON notifications(user_id, read_at);
CREATE INDEX IF NOT EXISTS idx_notif_created ON notifications(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notif_workspace_user ON notifications(workspace_id, user_id, read_at);

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON notifications;
CREATE POLICY tenant_isolation ON notifications
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON notifications;
CREATE POLICY admin_ops_scope ON notifications
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- 2. Knowledge Base Categories [GLOBAL] (§17.9A)
CREATE TABLE IF NOT EXISTS kb_categories (
  category_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug                VARCHAR(100) UNIQUE NOT NULL,
  display_name        VARCHAR(255) NOT NULL,
  description         TEXT,
  icon_key            VARCHAR(50),
  sort_order          INTEGER NOT NULL DEFAULT 0,
  is_active           BOOLEAN NOT NULL DEFAULT true,
  created_by          UUID REFERENCES internal_admins(admin_id),
  updated_by          UUID REFERENCES internal_admins(admin_id),
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_kbc_active ON kb_categories(is_active, sort_order);

-- 3. Knowledge Base Articles [GLOBAL] (§17.9B)
CREATE TABLE IF NOT EXISTS kb_articles (
  article_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id            UUID REFERENCES kb_categories(category_id) ON DELETE SET NULL,
  slug                   VARCHAR(160) UNIQUE NOT NULL,
  locale                 VARCHAR(10) NOT NULL DEFAULT 'vi-VN',
  title                  VARCHAR(255) NOT NULL,
  summary                TEXT,
  body_markdown          TEXT NOT NULL,
  search_document        TEXT,
  status                 VARCHAR(20) NOT NULL DEFAULT 'draft',
  article_type           VARCHAR(30) NOT NULL DEFAULT 'how_to',
  target_modules         JSONB NOT NULL DEFAULT '[]'::jsonb,
  target_operator_modes  JSONB NOT NULL DEFAULT '[]'::jsonb,
  target_tiers           JSONB NOT NULL DEFAULT '[]'::jsonb,
  tags                   JSONB NOT NULL DEFAULT '[]'::jsonb,
  related_article_ids    JSONB NOT NULL DEFAULT '[]'::jsonb,
  estimated_read_minutes SMALLINT,
  helpful_votes          INTEGER NOT NULL DEFAULT 0,
  unhelpful_votes        INTEGER NOT NULL DEFAULT 0,
  view_count             INTEGER NOT NULL DEFAULT 0,
  last_reviewed_at       TIMESTAMPTZ,
  published_at           TIMESTAMPTZ,
  archived_at            TIMESTAMPTZ,
  created_by             UUID REFERENCES internal_admins(admin_id),
  updated_by             UUID REFERENCES internal_admins(admin_id),
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT chk_kb_articles_status CHECK (status IN ('draft', 'review', 'published', 'archived')),
  CONSTRAINT chk_kb_articles_type CHECK (article_type IN ('getting_started', 'how_to', 'faq', 'troubleshooting', 'api_reference', 'changelog'))
);

CREATE INDEX IF NOT EXISTS idx_kba_category ON kb_articles(category_id, status);
CREATE INDEX IF NOT EXISTS idx_kba_slug_locale ON kb_articles(slug, locale);
CREATE INDEX IF NOT EXISTS idx_kba_review ON kb_articles(last_reviewed_at);

-- 4. Knowledge Base Article Versions [GLOBAL] (§17.9C)
CREATE TABLE IF NOT EXISTS kb_article_versions (
  article_version_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  article_id          UUID NOT NULL REFERENCES kb_articles(article_id) ON DELETE CASCADE,
  version_number      INTEGER NOT NULL,
  title               VARCHAR(255) NOT NULL,
  summary             TEXT,
  body_markdown       TEXT NOT NULL,
  change_note         TEXT,
  edited_by           UUID REFERENCES internal_admins(admin_id),
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(article_id, version_number)
);

CREATE INDEX IF NOT EXISTS idx_kbav_article ON kb_article_versions(article_id, version_number DESC);

-- 5. Article Ratings & Feedback [GLOBAL] (§17.9D)
CREATE TABLE IF NOT EXISTS article_ratings (
  rating_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  article_id          UUID NOT NULL REFERENCES kb_articles(article_id) ON DELETE CASCADE,
  user_id             UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  helpful             BOOLEAN NOT NULL,
  feedback_text       TEXT,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(article_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_ar_article ON article_ratings(article_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_ar_helpful ON article_ratings(article_id, helpful);

-- 6. Table-level role grants per §26.12
GRANT SELECT, INSERT, UPDATE, DELETE ON
  notifications
TO app_user;

GRANT SELECT ON
  kb_categories,
  kb_articles,
  kb_article_versions
TO app_user;

GRANT SELECT, INSERT, UPDATE ON
  article_ratings
TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON
  notifications,
  kb_categories,
  kb_articles,
  kb_article_versions,
  article_ratings
TO admin_user;

-- +goose Down
REVOKE ALL PRIVILEGES ON
  notifications,
  kb_categories,
  kb_articles,
  kb_article_versions,
  article_ratings
FROM app_user, admin_user;

DROP TABLE IF EXISTS article_ratings;
DROP TABLE IF EXISTS kb_article_versions;
DROP TABLE IF EXISTS kb_articles;
DROP TABLE IF EXISTS kb_categories;
DROP TABLE IF EXISTS notifications;

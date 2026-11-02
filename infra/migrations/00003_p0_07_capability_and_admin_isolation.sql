-- +goose Up
-- =============================================================================
-- P0-07: Capability & Connector Verification Registry + Internal Admin Isolation
-- Canonical sources:
--   - docs/04_contracts/database_schema.md (§3, §4.5, §17.4–§17.11, §18.2, §22.15, §25.6, §26.11–§26.13)
--   - docs/02_features/platform/capability_matrix.md (M22)
--   - docs/02_features/platform/internal_admin.md (S26)
--   - docs/06_quality_ops/moderation_rules_engine.md
-- =============================================================================

-- 1. Canonical capability_state enum (§3)
-- +goose StatementBegin
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'capability_state') THEN
    CREATE TYPE capability_state AS ENUM (
      'native',
      'read_only',
      'manual',
      'degraded',
      'unsupported'
    );
  END IF;
END
$$;
-- +goose StatementEnd

-- Ensure connected_accounts includes capability_summary (§4.5)
ALTER TABLE connected_accounts
  ADD COLUMN IF NOT EXISTS capability_summary JSONB NOT NULL DEFAULT '{}'::jsonb;

-- 2. Capability Snapshots (§18.2)
CREATE TABLE IF NOT EXISTS capability_snapshots (
  snapshot_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id          UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  platform              VARCHAR(30) NOT NULL,
  capability_key        VARCHAR(100) NOT NULL,
  state                 capability_state NOT NULL,
  reason                TEXT,
  fallback_type         VARCHAR(50),
  fallback_instructions TEXT,
  policy_note           TEXT,
  checked_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  valid_until           TIMESTAMPTZ,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_cs_workspace
  ON capability_snapshots(workspace_id, platform, capability_key);

ALTER TABLE capability_snapshots ENABLE ROW LEVEL SECURITY;
ALTER TABLE capability_snapshots FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON capability_snapshots;
CREATE POLICY tenant_isolation ON capability_snapshots
  FOR ALL
  TO app_user
  USING (workspace_id = COALESCE(NULLIF(current_setting('app.current_tenant_id', true), ''), NULLIF(current_setting('app.current_workspace_id', true), ''))::uuid)
  WITH CHECK (workspace_id = COALESCE(NULLIF(current_setting('app.current_tenant_id', true), ''), NULLIF(current_setting('app.current_workspace_id', true), ''))::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON capability_snapshots;
CREATE POLICY admin_ops_scope ON capability_snapshots
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- 3. Policy Notes (§18.2B & §26.11)
CREATE TABLE IF NOT EXISTS policy_notes (
  policy_note_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id   UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  platform       VARCHAR(30) NOT NULL,
  capability_key VARCHAR(100) NOT NULL,
  summary        TEXT NOT NULL,
  detail         TEXT,
  source_url     TEXT,
  effective_date DATE,
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_policy_notes_tenant_pk UNIQUE (workspace_id, policy_note_id)
);

CREATE INDEX IF NOT EXISTS idx_pn_workspace
  ON policy_notes(workspace_id, platform, capability_key);

ALTER TABLE policy_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE policy_notes FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON policy_notes;
CREATE POLICY tenant_isolation ON policy_notes
  FOR ALL
  TO app_user
  USING (workspace_id = COALESCE(NULLIF(current_setting('app.current_tenant_id', true), ''), NULLIF(current_setting('app.current_workspace_id', true), ''))::uuid)
  WITH CHECK (workspace_id = COALESCE(NULLIF(current_setting('app.current_tenant_id', true), ''), NULLIF(current_setting('app.current_workspace_id', true), ''))::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON policy_notes;
CREATE POLICY admin_ops_scope ON policy_notes
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- 4. Fallback Paths (§18.2C & §26.11)
CREATE TABLE IF NOT EXISTS fallback_paths (
  fallback_path_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  platform               VARCHAR(30) NOT NULL,
  capability_key         VARCHAR(100) NOT NULL,
  fallback_type          VARCHAR(50) NOT NULL
                           CHECK (fallback_type IN ('manual_upload','csv_import','webhook_workaround','browser_assist','unsupported')),
  instructions           TEXT NOT NULL,
  estimated_effort       VARCHAR(30),
  related_policy_note_id UUID REFERENCES policy_notes(policy_note_id) ON DELETE SET NULL,
  is_active              BOOLEAN DEFAULT true,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT fk_fallback_paths_related_policy_note_id_tenant
    FOREIGN KEY (workspace_id, related_policy_note_id)
    REFERENCES policy_notes(workspace_id, policy_note_id)
);

CREATE INDEX IF NOT EXISTS idx_fp_workspace
  ON fallback_paths(workspace_id, platform, capability_key);

ALTER TABLE fallback_paths ENABLE ROW LEVEL SECURITY;
ALTER TABLE fallback_paths FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON fallback_paths;
CREATE POLICY tenant_isolation ON fallback_paths
  FOR ALL
  TO app_user
  USING (workspace_id = COALESCE(NULLIF(current_setting('app.current_tenant_id', true), ''), NULLIF(current_setting('app.current_workspace_id', true), ''))::uuid)
  WITH CHECK (workspace_id = COALESCE(NULLIF(current_setting('app.current_tenant_id', true), ''), NULLIF(current_setting('app.current_workspace_id', true), ''))::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON fallback_paths;
CREATE POLICY admin_ops_scope ON fallback_paths
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- 5. Platform Health Scores (§22.15 & §26.11)
CREATE TABLE IF NOT EXISTS platform_health_scores (
  health_score_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id         UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  connected_account_id UUID NOT NULL REFERENCES connected_accounts(connected_account_id) ON DELETE CASCADE,
  platform             VARCHAR(30) NOT NULL,
  overall_score        INT NOT NULL CHECK (overall_score >= 0 AND overall_score <= 100),
  dimensions           JSONB NOT NULL DEFAULT '{}'::jsonb,
  risk_flags           JSONB DEFAULT '[]'::jsonb,
  recommendations      JSONB DEFAULT '[]'::jsonb,
  snapshot_date        DATE NOT NULL,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT fk_platform_health_scores_connected_account_id_tenant
    FOREIGN KEY (workspace_id, connected_account_id)
    REFERENCES connected_accounts(workspace_id, connected_account_id)
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_phs_account_date
  ON platform_health_scores(connected_account_id, snapshot_date);
CREATE INDEX IF NOT EXISTS idx_phs_workspace
  ON platform_health_scores(workspace_id, snapshot_date DESC);

ALTER TABLE platform_health_scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE platform_health_scores FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON platform_health_scores;
CREATE POLICY tenant_isolation ON platform_health_scores
  FOR ALL
  TO app_user
  USING (workspace_id = COALESCE(NULLIF(current_setting('app.current_tenant_id', true), ''), NULLIF(current_setting('app.current_workspace_id', true), ''))::uuid)
  WITH CHECK (workspace_id = COALESCE(NULLIF(current_setting('app.current_tenant_id', true), ''), NULLIF(current_setting('app.current_workspace_id', true), ''))::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON platform_health_scores;
CREATE POLICY admin_ops_scope ON platform_health_scores
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- 6. Moderation Cases (§17.4 & §26.13)
CREATE TABLE IF NOT EXISTS moderation_cases (
  case_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id      UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  content_type      VARCHAR(50) NOT NULL
                      CHECK (content_type IN ('asset','publish_item','script','comment','profile','link_in_bio','media_kit')),
  content_id        UUID NOT NULL,
  flag_reason       VARCHAR(50) NOT NULL
                      CHECK (flag_reason IN ('nsfw','hate_speech','spam','copyright','trademark','violence','self_harm','misinformation','policy_violation','user_report')),
  flag_source       VARCHAR(30) NOT NULL DEFAULT 'auto_scan'
                      CHECK (flag_source IN ('auto_scan','user_report','platform_reject','admin_manual')),
  confidence_score  NUMERIC(5,4),
  details           JSONB DEFAULT '{}'::jsonb,
  status            VARCHAR(20) NOT NULL DEFAULT 'pending'
                      CHECK (status IN ('pending','approved','rejected','warned','suspended','escalated')),
  assigned_admin_id UUID REFERENCES internal_admins(admin_id),
  decision_reason   TEXT,
  sla_deadline      TIMESTAMPTZ NOT NULL,
  decided_at        TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_mc_status_sla
  ON moderation_cases(status, sla_deadline)
  WHERE status = 'pending';
CREATE INDEX IF NOT EXISTS idx_mc_workspace
  ON moderation_cases(workspace_id, created_at DESC);

ALTER TABLE moderation_cases ENABLE ROW LEVEL SECURITY;
ALTER TABLE moderation_cases FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON moderation_cases;
CREATE POLICY tenant_isolation ON moderation_cases
  FOR SELECT
  TO app_user
  USING (workspace_id = COALESCE(NULLIF(current_setting('app.current_tenant_id', true), ''), NULLIF(current_setting('app.current_workspace_id', true), ''))::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON moderation_cases;
CREATE POLICY admin_ops_scope ON moderation_cases
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- 7. Fraud Cases (§17.5 [GLOBAL])
CREATE TABLE IF NOT EXISTS fraud_cases (
  fraud_case_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id      UUID REFERENCES workspaces(workspace_id),
  user_id           UUID REFERENCES users(user_id),
  signal_type       VARCHAR(50) NOT NULL
                      CHECK (signal_type IN ('credit_velocity_spike','referral_self_ring','payment_chargeback','fake_order_pattern','bot_registration','api_abuse','multi_account_free_abuse','ip_fingerprint_match')),
  risk_score        INT NOT NULL CHECK (risk_score >= 0 AND risk_score <= 100),
  evidence          JSONB NOT NULL DEFAULT '{}'::jsonb,
  status            VARCHAR(20) NOT NULL DEFAULT 'open'
                      CHECK (status IN ('open','investigating','confirmed_fraud','false_positive','resolved')),
  action_taken      VARCHAR(50)
                      CHECK (action_taken IN ('none','warned','credits_frozen','account_suspended','account_banned','clawback_issued')),
  assigned_admin_id UUID REFERENCES internal_admins(admin_id),
  resolution_notes  TEXT,
  detected_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resolved_at       TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fc_status_risk
  ON fraud_cases(status, risk_score DESC)
  WHERE status IN ('open','investigating');
CREATE INDEX IF NOT EXISTS idx_fc_workspace
  ON fraud_cases(workspace_id)
  WHERE workspace_id IS NOT NULL;

-- 8. Feature Flags & Kill Switches (§17.6 [GLOBAL])
CREATE TABLE IF NOT EXISTS feature_flags (
  flag_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  flag_key              VARCHAR(100) NOT NULL UNIQUE,
  name                  VARCHAR(200) NOT NULL,
  description           TEXT,
  status                VARCHAR(20) NOT NULL DEFAULT 'disabled'
                          CHECK (status IN ('disabled','percentage','plan_gated','workspace_allowlist','enabled')),
  percentage            INT DEFAULT 0 CHECK (percentage >= 0 AND percentage <= 100),
  allowed_plans         VARCHAR(20)[] DEFAULT '{}',
  allowed_workspace_ids UUID[] DEFAULT '{}',
  is_kill_switch        BOOLEAN DEFAULT false,
  updated_by            UUID REFERENCES internal_admins(admin_id),
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_ff_key
  ON feature_flags(flag_key);

-- 9. System Announcements (§17.7 [GLOBAL])
CREATE TABLE IF NOT EXISTS system_announcements (
  announcement_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title             VARCHAR(300) NOT NULL,
  body              TEXT NOT NULL,
  announcement_type VARCHAR(30) NOT NULL
                      CHECK (announcement_type IN ('info','warning','maintenance','feature','urgent')),
  target_plans      VARCHAR(20)[] DEFAULT '{}',
  target_locales    VARCHAR(10)[] DEFAULT '{}',
  display_location  VARCHAR(30) NOT NULL DEFAULT 'banner'
                      CHECK (display_location IN ('banner','modal','toast','notification_center')),
  starts_at         TIMESTAMPTZ NOT NULL,
  ends_at           TIMESTAMPTZ,
  is_dismissible    BOOLEAN DEFAULT true,
  created_by        UUID NOT NULL REFERENCES internal_admins(admin_id),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sa_active
  ON system_announcements(starts_at, ends_at);

-- 10. Incidents, Post-Mortems & System Alerts (§17.10 & §17.11 [GLOBAL])
CREATE TABLE IF NOT EXISTS incidents (
  incident_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title              VARCHAR(300) NOT NULL,
  severity           VARCHAR(10) NOT NULL CHECK (severity IN ('sev1','sev2','sev3','sev4')),
  status             VARCHAR(20) NOT NULL DEFAULT 'investigating'
                       CHECK (status IN ('investigating','identified','monitoring','resolved')),
  affected_services  VARCHAR(100)[] NOT NULL,
  impact_summary     TEXT,
  commander_admin_id UUID REFERENCES internal_admins(admin_id),
  timeline           JSONB DEFAULT '[]'::jsonb,
  started_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  identified_at      TIMESTAMPTZ,
  resolved_at        TIMESTAMPTZ,
  duration_minutes   INT,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_inc_status
  ON incidents(status, severity)
  WHERE status != 'resolved';

CREATE TABLE IF NOT EXISTS post_mortems (
  postmortem_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  incident_id               UUID NOT NULL UNIQUE REFERENCES incidents(incident_id) ON DELETE CASCADE,
  root_cause                TEXT NOT NULL,
  impact_description        TEXT NOT NULL,
  affected_workspaces_count INT DEFAULT 0,
  timeline_summary          TEXT NOT NULL,
  what_went_well            TEXT,
  what_went_wrong           TEXT,
  action_items              JSONB NOT NULL DEFAULT '[]'::jsonb,
  status                    VARCHAR(20) NOT NULL DEFAULT 'draft'
                              CHECK (status IN ('draft','in_review','published')),
  author_admin_id           UUID NOT NULL REFERENCES internal_admins(admin_id),
  published_at              TIMESTAMPTZ,
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS system_alerts (
  alert_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  alert_name          VARCHAR(200) NOT NULL,
  severity            VARCHAR(10) NOT NULL CHECK (severity IN ('critical','warning','info')),
  source_service      VARCHAR(100) NOT NULL,
  metric_name         VARCHAR(100),
  metric_value        NUMERIC(18,6),
  threshold_value     NUMERIC(18,6),
  message             TEXT NOT NULL,
  status              VARCHAR(20) NOT NULL DEFAULT 'firing'
                        CHECK (status IN ('firing','acknowledged','resolved','silenced')),
  acknowledged_by     UUID REFERENCES internal_admins(admin_id),
  related_incident_id UUID REFERENCES incidents(incident_id),
  fired_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  acknowledged_at     TIMESTAMPTZ,
  resolved_at         TIMESTAMPTZ,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_salert_firing
  ON system_alerts(status, severity, fired_at DESC)
  WHERE status = 'firing';

-- 11. Narrow Role Grants (§26.12)
REVOKE ALL ON
  capability_snapshots,
  policy_notes,
  fallback_paths,
  platform_health_scores,
  moderation_cases,
  fraud_cases,
  feature_flags,
  system_announcements,
  incidents,
  post_mortems,
  system_alerts
FROM PUBLIC;

-- app_user: tenant-scoped capability & health tables + read-only on moderation_cases, feature_flags, system_announcements
GRANT SELECT, INSERT, UPDATE, DELETE ON
  capability_snapshots,
  policy_notes,
  fallback_paths,
  platform_health_scores
TO app_user;

GRANT SELECT ON
  moderation_cases,
  feature_flags,
  system_announcements
TO app_user;

-- admin_user: internal admin operations on S26 & M22 tables
GRANT SELECT, INSERT, UPDATE, DELETE ON
  capability_snapshots,
  policy_notes,
  fallback_paths,
  platform_health_scores,
  moderation_cases,
  fraud_cases,
  feature_flags,
  system_announcements,
  incidents,
  post_mortems,
  system_alerts
TO admin_user;

-- +goose Down
REVOKE ALL PRIVILEGES ON
  capability_snapshots,
  policy_notes,
  fallback_paths,
  platform_health_scores,
  moderation_cases,
  fraud_cases,
  feature_flags,
  system_announcements,
  incidents,
  post_mortems,
  system_alerts
FROM app_user, admin_user;

DROP TABLE IF EXISTS system_alerts;
DROP TABLE IF EXISTS post_mortems;
DROP TABLE IF EXISTS incidents;
DROP TABLE IF EXISTS system_announcements;
DROP TABLE IF EXISTS feature_flags;
DROP TABLE IF EXISTS fraud_cases;
DROP TABLE IF EXISTS moderation_cases;
DROP TABLE IF EXISTS platform_health_scores;
DROP TABLE IF EXISTS fallback_paths;
DROP TABLE IF EXISTS policy_notes;
DROP TABLE IF EXISTS capability_snapshots;
ALTER TABLE connected_accounts DROP COLUMN IF EXISTS capability_summary;
DROP TYPE IF EXISTS capability_state;

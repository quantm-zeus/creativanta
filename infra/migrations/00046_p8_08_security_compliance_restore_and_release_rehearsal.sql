-- ============================================================================
-- Creativanta P8-08 Migration: Security, Privacy Compliance, Restore & Release Rehearsal
-- Canonical Sources: docs/04_contracts/database_schema.md (§15, §17, §26.1, §26.12–§26.14)
--                    docs/02_features/platform/reporting_admin_billing.md (M23, EC-M23-003..005)
--                    docs/02_features/platform/internal_admin.md (S26, AdminComplianceService)
--                    docs/01_business/legal_compliance.md (§4 GDPR/PDPA, §8 Launch Checklist)
--                    docs/06_quality_ops/security_threat_model.md (§1B, §2, §3)
--                    docs/06_quality_ops/runbook.md (§4, §7, §10 Backup & Restore)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Data Subject Requests Table (GDPR Art. 15-21 / Vietnam PDPA Decree 13/2023)
--    Tenant-scoped DSR lifecycle with mandatory OAuth token redaction flag.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS data_subject_requests (
  request_id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id                UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  user_id                     UUID NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
  user_email                  VARCHAR(255) NOT NULL,
  request_type                VARCHAR(30) NOT NULL
    CHECK (request_type IN ('access', 'deletion', 'portability', 'rectification', 'objection')),
  status                      VARCHAR(30) NOT NULL DEFAULT 'received'
    CHECK (status IN ('received', 'identity_verification', 'processing', 'completed', 'rejected')),
  regulation                  VARCHAR(20) NOT NULL DEFAULT 'PDPA_VN'
    CHECK (regulation IN ('GDPR', 'PDPA_VN', 'CCPA')),
  description                 TEXT,
  sla_deadline                TIMESTAMPTZ NOT NULL,
  oauth_tokens_redacted       BOOLEAN NOT NULL DEFAULT true
    CHECK (oauth_tokens_redacted = true),
  export_file_url             TEXT,
  export_file_expires_at      TIMESTAMPTZ,
  rejection_reason            TEXT,
  legal_basis_for_rejection   TEXT,
  processed_by_admin_id       UUID REFERENCES internal_admins(admin_id) ON DELETE SET NULL,
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at                TIMESTAMPTZ,
  CONSTRAINT uq_dsr_tenant_pk UNIQUE (workspace_id, request_id)
);

CREATE INDEX IF NOT EXISTS idx_dsr_workspace_status ON data_subject_requests(workspace_id, status);
CREATE INDEX IF NOT EXISTS idx_dsr_sla_deadline ON data_subject_requests(sla_deadline ASC);

ALTER TABLE data_subject_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE data_subject_requests FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON data_subject_requests;
CREATE POLICY tenant_isolation ON data_subject_requests
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON data_subject_requests;
CREATE POLICY admin_ops_scope ON data_subject_requests
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 2. Breach Notifications Table (GDPR Art. 33 / PDPA 72-Hour Countdown)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS breach_notifications (
  breach_id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title                       VARCHAR(255) NOT NULL,
  description                 TEXT NOT NULL,
  severity                    VARCHAR(20) NOT NULL
    CHECK (severity IN ('critical', 'high', 'medium', 'low')),
  status                      VARCHAR(30) NOT NULL DEFAULT 'detected'
    CHECK (status IN ('detected', 'investigating', 'authority_notified', 'users_notified', 'resolved')),
  detected_at                 TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  notification_deadline       TIMESTAMPTZ NOT NULL,
  authority_notified_at       TIMESTAMPTZ,
  users_notified_at           TIMESTAMPTZ,
  affected_user_count         INTEGER NOT NULL DEFAULT 0 CHECK (affected_user_count >= 0),
  data_categories             TEXT[] NOT NULL DEFAULT '{}',
  remediation_steps           TEXT,
  created_by_admin_id         UUID REFERENCES internal_admins(admin_id) ON DELETE SET NULL,
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_breach_notifications_status ON breach_notifications(status, notification_deadline ASC);

-- ----------------------------------------------------------------------------
-- 3. Data Processing Activities Table (GDPR Article 30 ROPA Log)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS data_processing_activities (
  activity_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  activity_name               VARCHAR(200) NOT NULL,
  purpose                     TEXT NOT NULL,
  legal_basis                 VARCHAR(60) NOT NULL,
  data_categories             TEXT[] NOT NULL DEFAULT '{}',
  data_subjects               TEXT[] NOT NULL DEFAULT '{}',
  recipients                  TEXT[] NOT NULL DEFAULT '{}',
  third_country_transfers     TEXT,
  retention_period            VARCHAR(120) NOT NULL,
  security_measures           TEXT NOT NULL,
  sub_processor_name          VARCHAR(160),
  sub_processor_location      VARCHAR(120),
  dpa_signed                  BOOLEAN NOT NULL DEFAULT false,
  last_reviewed_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ----------------------------------------------------------------------------
-- 4. Backup, Restore & Release Smoke Rehearsals Table (runbook.md §4, §7, §10)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS backup_restore_rehearsals (
  rehearsal_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  environment                 VARCHAR(30) NOT NULL DEFAULT 'rehearsal'
    CHECK (environment IN ('local', 'rehearsal', 'staging', 'production')),
  backup_artifact_uri         TEXT NOT NULL,
  backup_sha256               VARCHAR(64) NOT NULL,
  restored_sha256             VARCHAR(64) NOT NULL,
  checksum_verified           BOOLEAN NOT NULL DEFAULT false,
  rpo_seconds                 INTEGER NOT NULL DEFAULT 0 CHECK (rpo_seconds >= 0),
  rto_seconds                 INTEGER NOT NULL DEFAULT 0 CHECK (rto_seconds >= 0),
  smoke_passed                BOOLEAN NOT NULL DEFAULT false,
  smoke_failure_code          VARCHAR(80),
  rollback_triggered          BOOLEAN NOT NULL DEFAULT false,
  previous_slot_digest        VARCHAR(128) NOT NULL,
  candidate_slot_digest       VARCHAR(128) NOT NULL,
  active_slot_after_rehearsal VARCHAR(20) NOT NULL DEFAULT 'blue'
    CHECK (active_slot_after_rehearsal IN ('blue', 'green')),
  rehearsal_report            JSONB NOT NULL DEFAULT '{}'::jsonb,
  executed_by_admin_id        UUID REFERENCES internal_admins(admin_id) ON DELETE SET NULL,
  executed_at                 TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_backup_restore_rehearsals_executed_at
  ON backup_restore_rehearsals(executed_at DESC);

-- ----------------------------------------------------------------------------
-- 5. Internal Audit Logs Sequence Integrity Extensions (EC-M23-005)
-- ----------------------------------------------------------------------------
ALTER TABLE internal_audit_logs
  ADD COLUMN IF NOT EXISTS sequence_number BIGINT,
  ADD COLUMN IF NOT EXISTS entry_hash VARCHAR(64);

CREATE UNIQUE INDEX IF NOT EXISTS idx_internal_audit_logs_sequence_number
  ON internal_audit_logs(sequence_number)
  WHERE sequence_number IS NOT NULL;

-- ----------------------------------------------------------------------------
-- 6. Table Role Grants (Narrow per-role grants; NEVER GRANT ALL)
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON data_subject_requests TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON data_subject_requests TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON breach_notifications TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON data_processing_activities TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON backup_restore_rehearsals TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON backup_restore_rehearsals FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON data_processing_activities FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON breach_notifications FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON data_subject_requests FROM app_user, admin_user;
DROP INDEX IF EXISTS idx_internal_audit_logs_sequence_number;
ALTER TABLE internal_audit_logs DROP COLUMN IF EXISTS entry_hash;
ALTER TABLE internal_audit_logs DROP COLUMN IF EXISTS sequence_number;
DROP INDEX IF EXISTS idx_backup_restore_rehearsals_executed_at;
DROP TABLE IF EXISTS backup_restore_rehearsals CASCADE;
DROP TABLE IF EXISTS data_processing_activities CASCADE;
DROP INDEX IF EXISTS idx_breach_notifications_status;
DROP TABLE IF EXISTS breach_notifications CASCADE;
DROP POLICY IF EXISTS admin_ops_scope ON data_subject_requests;
DROP POLICY IF EXISTS tenant_isolation ON data_subject_requests;
DROP INDEX IF EXISTS idx_dsr_sla_deadline;
DROP INDEX IF EXISTS idx_dsr_workspace_status;
DROP TABLE IF EXISTS data_subject_requests CASCADE;

-- +goose Up
-- ============================================================================
-- Migration: 00042_p8_05_referral_commissions_and_anti_fraud.sql
-- Domain: Platform / Growth / Referral (M23 / Referral)
-- Upstream: docs/02_features/platform/referral_growth.md
-- Contracts: docs/04_contracts/database_schema.md (§18.6, §13.2)
-- Invariants: NUMERIC(18,6) for credits, RLS FORCE, tenant isolation, no GRANT ALL.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. referral_records Enhancements (Anti-Fraud, Payment Status, Reversals)
-- ----------------------------------------------------------------------------
ALTER TABLE referral_records DROP CONSTRAINT IF EXISTS referral_records_status_check;
ALTER TABLE referral_records ADD CONSTRAINT referral_records_status_check
  CHECK (status IN ('pending', 'qualified', 'rewarded', 'revoked', 'expired', 'fraud_flagged', 'forfeited'));

ALTER TABLE referral_records ADD COLUMN IF NOT EXISTS fraud_check_passed BOOLEAN DEFAULT NULL;
ALTER TABLE referral_records ADD COLUMN IF NOT EXISTS fraud_reason TEXT;
ALTER TABLE referral_records ADD COLUMN IF NOT EXISTS fraud_signals JSONB DEFAULT '{}'::jsonb;
ALTER TABLE referral_records ADD COLUMN IF NOT EXISTS payment_status VARCHAR(50) DEFAULT 'unpaid';
ALTER TABLE referral_records ADD COLUMN IF NOT EXISTS plan_tier VARCHAR(20) DEFAULT 'free';
ALTER TABLE referral_records ADD COLUMN IF NOT EXISTS recurring_commission_rate NUMERIC(18,6) NOT NULL DEFAULT 0;
ALTER TABLE referral_records ADD COLUMN IF NOT EXISTS recurring_commission_earned NUMERIC(18,6) NOT NULL DEFAULT 0;
ALTER TABLE referral_records ADD COLUMN IF NOT EXISTS reversal_transaction_id UUID;
ALTER TABLE referral_records ADD COLUMN IF NOT EXISTS reversed_at TIMESTAMPTZ;
ALTER TABLE referral_records ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

CREATE INDEX IF NOT EXISTS idx_rr_status_payment
  ON referral_records(workspace_id, status, payment_status);

CREATE INDEX IF NOT EXISTS idx_rr_fraud
  ON referral_records(status) WHERE status = 'fraud_flagged';

-- ----------------------------------------------------------------------------
-- 2. referral_events (Funnel Clicks, Signups, Reminders Tracking)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS referral_events (
  event_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id    UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  referral_code   VARCHAR(20) NOT NULL,
  event_type      VARCHAR(50) NOT NULL, -- click, signup, trigger_shown, trigger_accepted, reminder_sent
  ip_hash         VARCHAR(64),
  user_agent_hash VARCHAR(64),
  metadata        JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_referral_events_tenant_pk UNIQUE (workspace_id, event_id)
);

CREATE INDEX IF NOT EXISTS idx_re_workspace_code
  ON referral_events(workspace_id, referral_code, event_type);

ALTER TABLE referral_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE referral_events FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON referral_events;
CREATE POLICY tenant_isolation ON referral_events
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON referral_events;
CREATE POLICY admin_ops_scope ON referral_events
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. promotional_campaigns & promotional_redemptions (PromotionalService)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS promotional_campaigns (
  campaign_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code                 VARCHAR(50) UNIQUE NOT NULL,
  title                VARCHAR(255) NOT NULL,
  description          TEXT,
  credit_bonus         NUMERIC(18,6) NOT NULL DEFAULT 0,
  max_redemptions      INT NOT NULL DEFAULT 1000,
  current_redemptions  INT NOT NULL DEFAULT 0,
  tier_eligibility     VARCHAR(50)[] DEFAULT ARRAY['free', 'starter', 'pro', 'business'],
  expires_at           TIMESTAMPTZ,
  is_active            BOOLEAN NOT NULL DEFAULT true,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pc_code ON promotional_campaigns(code);

CREATE TABLE IF NOT EXISTS promotional_redemptions (
  redemption_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id    UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  user_id         UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  campaign_id     UUID NOT NULL REFERENCES promotional_campaigns(campaign_id) ON DELETE CASCADE,
  credits_awarded NUMERIC(18,6) NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_promotional_redemptions_tenant_pk UNIQUE (workspace_id, redemption_id),
  CONSTRAINT uq_workspace_campaign_once UNIQUE (workspace_id, campaign_id)
);

CREATE INDEX IF NOT EXISTS idx_pr_workspace_campaign
  ON promotional_redemptions(workspace_id, campaign_id);

ALTER TABLE promotional_redemptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE promotional_redemptions FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON promotional_redemptions;
CREATE POLICY tenant_isolation ON promotional_redemptions
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON promotional_redemptions;
CREATE POLICY admin_ops_scope ON promotional_redemptions
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 4. growth_prompts (In-Product Growth Triggers)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS growth_prompts (
  prompt_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id   UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  user_id        UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  trigger_point  VARCHAR(50) NOT NULL, -- first_publish, first_profit_proof, followers_1000, team_invite, recipe_submit, feature_upvote
  status         VARCHAR(20) NOT NULL DEFAULT 'active'
                 CHECK (status IN ('active', 'completed', 'dismissed')),
  credits_reward NUMERIC(18,6) NOT NULL DEFAULT 0,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at   TIMESTAMPTZ,
  CONSTRAINT uq_growth_prompts_tenant_pk UNIQUE (workspace_id, prompt_id)
);

CREATE INDEX IF NOT EXISTS idx_gp_workspace_user
  ON growth_prompts(workspace_id, user_id, status);

ALTER TABLE growth_prompts ENABLE ROW LEVEL SECURITY;
ALTER TABLE growth_prompts FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON growth_prompts;
CREATE POLICY tenant_isolation ON growth_prompts
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON growth_prompts;
CREATE POLICY admin_ops_scope ON growth_prompts
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 5. Narrow Role Grants (NEVER GRANT ALL)
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON referral_events TO app_user, admin_user;
GRANT SELECT ON promotional_campaigns TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON promotional_campaigns TO admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON promotional_redemptions TO app_user, admin_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON growth_prompts TO app_user, admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON growth_prompts FROM app_user, admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON promotional_redemptions FROM app_user, admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON promotional_campaigns FROM admin_user;
REVOKE SELECT ON promotional_campaigns FROM app_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON referral_events FROM app_user, admin_user;

DROP TABLE IF EXISTS growth_prompts CASCADE;
DROP TABLE IF EXISTS promotional_redemptions CASCADE;
DROP TABLE IF EXISTS promotional_campaigns CASCADE;
DROP TABLE IF EXISTS referral_events CASCADE;

ALTER TABLE referral_records DROP COLUMN IF EXISTS updated_at;
ALTER TABLE referral_records DROP COLUMN IF EXISTS reversed_at;
ALTER TABLE referral_records DROP COLUMN IF EXISTS reversal_transaction_id;
ALTER TABLE referral_records DROP COLUMN IF EXISTS recurring_commission_earned;
ALTER TABLE referral_records DROP COLUMN IF EXISTS recurring_commission_rate;
ALTER TABLE referral_records DROP COLUMN IF EXISTS plan_tier;
ALTER TABLE referral_records DROP COLUMN IF EXISTS payment_status;
ALTER TABLE referral_records DROP COLUMN IF EXISTS fraud_signals;
ALTER TABLE referral_records DROP COLUMN IF EXISTS fraud_reason;
ALTER TABLE referral_records DROP COLUMN IF EXISTS fraud_check_passed;

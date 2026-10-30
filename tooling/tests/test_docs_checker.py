"""Regression checks for defects that would make AI implementation unsafe."""
import csv
import importlib.util
import json
import shutil
import sys
import tempfile
import unittest
from pathlib import Path

sys.dont_write_bytecode = True
SOURCE = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('check_docs', SOURCE/'tooling/check_docs.py')
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)

class DocsGuardTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.scratch = tempfile.TemporaryDirectory(prefix='creativanta-docs-regression-')
        cls.root = Path(cls.scratch.name)
        shutil.copytree(SOURCE/'docs',cls.root/'docs')
        shutil.copytree(SOURCE/'tooling',cls.root/'tooling',ignore=shutil.ignore_patterns('__pycache__'))

    @classmethod
    def tearDownClass(cls):
        cls.scratch.cleanup()

    def mutation_fails(self, filename, old, new, expected):
        p=self.root/'docs'/filename
        original=p.read_text()
        self.assertIn(old,original)
        try:
            p.write_text(original.replace(old,new,1))
            errors,_=checker.audit(self.root)
            self.assertTrue(any(expected in e for e in errors),errors)
        finally:
            p.write_text(original)

    def test_baseline_passes(self):
        errors,counts=checker.audit(self.root)
        self.assertEqual(errors,[])
        self.assertEqual(counts['modules'],31)

    def test_superuser_dsn_rejected(self):
        self.mutation_fails('06_quality_ops/docker_dev_environment.md','DATABASE_URL=postgresql://app_user:','DATABASE_URL=postgresql://creativanta:','sample')

    def test_missing_junction_rls_rejected(self):
        self.mutation_fails('04_contracts/database_schema.md','ALTER TABLE trend_signals FORCE ROW LEVEL SECURITY;','-- removed junction FORCE policy','trend_signals: missing FORCE')

    def test_cross_tenant_fk_gap_rejected(self):
        self.mutation_fails('04_contracts/database_schema.md','FOREIGN KEY (workspace_id, trend_id) REFERENCES trends(workspace_id, trend_id)','FOREIGN KEY (trend_id) REFERENCES trends(trend_id)','same-tenant FK')

    def test_missing_fx_snapshot_rejected(self):
        self.mutation_fails('04_contracts/database_schema.md','  exchange_rate_snapshot JSONB NOT NULL DEFAULT','  obsolete_fx JSONB NOT NULL DEFAULT','orders: missing exchange_rate_snapshot')

    def test_unknown_rpc_permission_rejected(self):
        self.mutation_fails('04_contracts/rpc_permission_bindings.csv','publish:execute','publish:invented','unknown permission')

    def test_sensitive_permission_downgrade_rejected(self):
        self.mutation_fails('04_contracts/rpc_permission_bindings.csv','PublishService/Execute,publish:execute','PublishService/Execute,publish:read','sensitive permission drift')

    def test_removed_module_rejected(self):
        self.mutation_fails('00_index/IMPLEMENTATION_ORDER.md','| M18 | P6 | P6 |','| REMOVED | P6 | P6 |','preserve all 31')

    def test_old_credit_ttl_rejected(self):
        self.mutation_fails('01_business/pricing_and_credits.md','### 2.3 Credit Reservation','### 2.3 Credit Reservation\nReservation TTL: 15 phút','conflicting credit TTL')

    def test_duplicate_index_rejected(self):
        self.mutation_fails('04_contracts/database_schema.md','CREATE INDEX idx_channel_posts_workspace','CREATE INDEX idx_cp_workspace','duplicate index')

    def test_missing_stock_identity_rejected(self):
        self.mutation_fails('04_contracts/database_schema.md','CREATE UNIQUE INDEX idx_sm_identity','CREATE INDEX idx_sm_identity','unique economic identity')

    def test_mutable_stock_ledger_rejected(self):
        self.mutation_fails('04_contracts/database_schema.md','GRANT SELECT, INSERT ON stock_movements TO app_user','GRANT SELECT, INSERT, UPDATE, DELETE ON stock_movements TO app_user','immutability')

    def test_public_directory_wide_grant_rejected(self):
        self.mutation_fails('04_contracts/database_schema.md','GRANT SELECT (media_kit_id, directory_profile) ON media_kits TO directory_reader','GRANT SELECT ON media_kits TO directory_reader','column-scoped grants')

    def test_public_directory_tenant_policy_bypass_rejected(self):
        self.mutation_fails('04_contracts/database_schema.md','CREATE POLICY tenant_isolation ON media_kits TO app_user','CREATE POLICY tenant_isolation ON media_kits','permissive tenant policy')

    def test_onboarding_workspace_permission_rejected(self):
        self.mutation_fails('04_contracts/rpc_permission_bindings.csv','WorkspaceService/CompleteOnboarding,user:self','WorkspaceService/CompleteOnboarding,workspace:settings:manage','onboarding permission drift')

    def test_noncanonical_capability_rejected(self):
        self.mutation_fails('02_features/platform/capability_matrix.md',"M22 MUST return `'manual'`", "M22 MUST return `'unknown'` status",'non-schema unknown')

    def test_phishing_override_rejected(self):
        self.mutation_fails('02_features/commerce/creator_pro_tools.md','creator can remove it or request security review of a false positive','creator removes or overrides (with AUP acknowledgment)','phishing override')

    def test_feature_changes_invalidate_coverage(self):
        self.mutation_fails('02_features/content/idea_engine.md','### A4: Quick Capture from Mobile','### A4: Removed Mobile Flow','stale or missing requirement_task_map')

    def test_task_cycle_rejected(self):
        path=self.root/'docs/00_index/agent_task_catalog.json';original=path.read_text()
        try:
            value=json.loads(original)
            value['tasks'][0]['depends_on']=['P0-09']
            path.write_text(json.dumps(value))
            errors,_=checker.audit(self.root)
            self.assertTrue(any('dependency cycle' in e for e in errors),errors)
        finally:path.write_text(original)

    def test_premature_module_completion_rejected(self):
        self.mutation_fails('00_index/agent_task_catalog.json','"completion_task": "P8-06"','"completion_task": "P4-09"','completion phase mismatch')

    def test_rust_ci_command_after_go_migration_rejected(self):
        self.mutation_fails('06_quality_ops/ci_cd_pipeline.md','go test -race -count=1 ./...','cargo test --workspace','legacy Rust runtime instruction')

    def test_missing_go_handler_generator_rejected(self):
        self.mutation_fails('04_contracts/protobuf_contracts.md','local: protoc-gen-connect-go','local: obsolete-handler-generator','Go transport generator missing')

    def test_go_float_provider_cost_rejected(self):
        self.mutation_fails('05_system/ai_provider_guide.md','CostUSD decimal.Decimal','CostUSD float64','exact decimal arithmetic')

if __name__=='__main__':unittest.main()

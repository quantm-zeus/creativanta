"""Regression checks for defects that would make AI implementation unsafe."""
import csv
import importlib.util
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
        (cls.root/'tooling').mkdir()
        shutil.copy(SOURCE/'tooling/check_docs.py',cls.root/'tooling/check_docs.py')

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

if __name__=='__main__':unittest.main()

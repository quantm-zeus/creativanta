import json
from pathlib import Path
import tempfile
import unittest
from supervisor import eval_checks, deps_ready, retry_seconds, json_result, safe_id, Harness

class HarnessPureTests(unittest.TestCase):
    def test_checks_fail_closed_on_missing_or_pending(self):
        self.assertEqual(eval_checks([]), "pending")
        self.assertEqual(eval_checks([{"name":"CI Gate: All Verification Passed",
                                      "status":"IN_PROGRESS","conclusion":None}]),"pending")
        self.assertEqual(eval_checks([{"name":"Other", "status":"COMPLETED",
                                      "conclusion":"SUCCESS"}]),"pending")
    def test_required_gate_success(self):
        self.assertEqual(eval_checks([{"name":"CI Gate: All Verification Passed",
                                      "status":"COMPLETED","conclusion":"SUCCESS"}]),"success")
    def test_failure_dominates_success(self):
        self.assertEqual(eval_checks([
            {"name":"CI Gate: All Verification Passed","status":"COMPLETED","conclusion":"SUCCESS"},
            {"name":"Backend", "status":"COMPLETED","conclusion":"FAILURE"}]), "failure")
    def test_dependencies(self):
        self.assertTrue(deps_ready(["P0-01", "P0-02"],
                        {"P0-01":"INTEGRATED", "P0-02":"INTEGRATED"}))
        self.assertFalse(deps_ready(["P0-03"], {"P0-03":"CI_PENDING"}))
    def test_retry_is_bounded(self):
        self.assertEqual(retry_seconds(1),15)
        self.assertGreater(retry_seconds(3),retry_seconds(2))
        self.assertLessEqual(retry_seconds(100),1800)
    def test_reject_invalid_ids(self):
        with self.assertRaises(ValueError):
            safe_id("P0-03; rm")
    def test_report_validation(self):
        with tempfile.TemporaryDirectory() as t:
            p=Path(t)/"result.json"
            self.assertIsNone(json_result(p))
            p.write_text(json.dumps({"status":"implemented_local","checks":[]}))
            self.assertEqual(json_result(p)["status"],"implemented_local")
            p.write_text(json.dumps({"status":"ACCEPTED","checks":["fake"]}))
            self.assertIsNone(json_result(p))

class HarnessLifecycleTests(unittest.TestCase):
    def _fixture(self, base):
        root=Path(base)
        repo=root/"repo"
        docs=repo/"docs"/"00_index"
        docs.mkdir(parents=True)
        cases=[
            {"id":"P0-01","title":"boot","depends_on":[]},
            {"id":"P0-02","title":"wire","depends_on":["P0-01"]},
            {"id":"P0-03","title":"auth","depends_on":["P0-02"]},
            {"id":"P0-04","title":"tenant","depends_on":["P0-03"]}
        ]
        (docs/"agent_task_catalog.json").write_text(json.dumps({"tasks":cases}))
        cfg=root/"config.json"
        cfg.write_text(json.dumps({
            "repository":str(repo), "worktrees":str(root/"worktrees"),
            "state_dir":str(root/"data"), "max_concurrent":2,
            "max_runs_per_24h":10, "max_iterations_per_task":4
        }))
        return cfg

    def test_next_dependency_starts_on_next_tick_without_chat(self):
        with tempfile.TemporaryDirectory() as directory:
            harness=Harness(self._fixture(directory))
            called=[]
            def fake_launch(task_id):
                called.append(task_id)
                harness.update(task_id, status="INTEGRATED")
            harness.launch=fake_launch
            harness.dispatch()
            self.assertEqual(called,["P0-03"])
            harness.dispatch()
            self.assertEqual(called,["P0-03","P0-04"])
            harness.db.close()
            harness.lockfile.close()

    def test_restart_recovers_interrupted_agent(self):
        with tempfile.TemporaryDirectory() as directory:
            cfg=self._fixture(directory)
            first=Harness(cfg)
            first.update("P0-03",status="RUNNING",attempts=1)
            first.db.close()
            first.lockfile.close()
            second=Harness(cfg)
            state=second.rows()["P0-03"]
            self.assertEqual(state["status"],"RETRY")
            self.assertIn("restarted",state["error"])
            second.db.close()
            second.lockfile.close()

if __name__ == "__main__":
    unittest.main()

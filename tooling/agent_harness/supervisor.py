#!/usr/bin/env python3
"""Creativanta AGY adapter: a deliberately small, durable Symphony-style scheduler.

Uses the canonical 60-task DAG, isolated Git worktrees, persisted SQLite state,
bounded AGY sessions, real GitHub CI, and staging-only automatic integration.
This is an AGY-native adapter inspired by the public Symphony spec, NOT the
official Symphony Elixir reference implementation. Never merges into main.
"""
import argparse
import fcntl
import json
import logging
import os
from pathlib import Path
import re
import signal
import sqlite3
import subprocess
import sys
import time

LOG = logging.getLogger("creativanta.harness")
REPO_FULL = "quantm-zeus/creativanta"
ALLOWED_RESULT = {"implemented_local", "partial", "blocked"}
DONE = "INTEGRATED"
PENDING = "PENDING"
BASELINE = {"P0-01", "P0-02"}
COMPLETED_CHECK = "CI Gate: All Verification Passed"

def safe_id(value):
    if not re.fullmatch(r"P[0-8]-[0-9]{2}", value):
        raise ValueError("unsafe task identifier")
    return value

def retry_seconds(attempt):
    return min(1800, 15 * (2 ** min(max(attempt - 1, 0), 7)))

def deps_ready(deps, statuses):
    return all(statuses.get(dep) == DONE for dep in deps)

def eval_checks(checks):
    """Return pending/failure/success; no CI entries never count as success."""
    if not checks:
        return "pending"
    gate = False
    for check in checks:
        status = str(check.get("status") or "").upper()
        verdict = str(check.get("conclusion") or "").upper()
        if status != "COMPLETED":
            return "pending"
        if verdict in {"FAILURE", "TIMED_OUT", "CANCELLED", "ACTION_REQUIRED", "STARTUP_FAILURE"}:
            return "failure"
        if verdict not in {"SUCCESS", "NEUTRAL", "SKIPPED"}:
            return "pending"
        if check.get("name") == COMPLETED_CHECK and verdict == "SUCCESS":
            gate = True
    return "success" if gate else "pending"

def command(args, cwd=None, timeout=60, check=True, env=None):
    result = subprocess.run(args, cwd=str(cwd) if cwd else None,
                            text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                            timeout=timeout, env=env)
    if check and result.returncode:
        raise RuntimeError(f"{args[0]} failed ({result.returncode}): {result.stderr[-700:]}")
    return result.stdout.strip()

def json_result(path):
    try:
        data = json.loads(Path(path).read_text())
        if data.get("status") not in ALLOWED_RESULT:
            return None
        if not isinstance(data.get("checks"), list):
            return None
        return data
    except (OSError, ValueError, TypeError):
        return None

class Harness:
    def __init__(self, config_file):
        self.config_path = Path(config_file)
        self.cfg = json.loads(self.config_path.read_text())
        self.repo = Path(self.cfg["repository"])
        self.worktrees = Path(self.cfg["worktrees"])
        self.state = Path(self.cfg["state_dir"])
        self.state.mkdir(parents=True, exist_ok=True)
        self.worktrees.mkdir(parents=True, exist_ok=True)
        (self.state / "logs").mkdir(exist_ok=True)
        (self.state / "results").mkdir(exist_ok=True)
        self.lockfile = (self.state / "supervisor.lock").open("a+")
        fcntl.flock(self.lockfile, fcntl.LOCK_EX | fcntl.LOCK_NB)
        self.db = sqlite3.connect(self.state / "state.sqlite3", timeout=30)
        self.db.row_factory = sqlite3.Row
        self.db.execute("PRAGMA journal_mode=WAL")
        self.db.execute("""CREATE TABLE IF NOT EXISTS tasks (
            id TEXT PRIMARY KEY, title TEXT NOT NULL, deps TEXT NOT NULL,
            status TEXT NOT NULL, branch TEXT, workspace TEXT, base_sha TEXT,
            attempts INTEGER NOT NULL DEFAULT 0, ready_at INTEGER NOT NULL DEFAULT 0,
            started INTEGER NOT NULL DEFAULT 0, updated INTEGER NOT NULL DEFAULT 0,
            sha TEXT, pr TEXT, error TEXT NOT NULL DEFAULT '',
            output TEXT NOT NULL DEFAULT '' )""")
        self.db.execute("""CREATE TABLE IF NOT EXISTS events (
            ts INTEGER NOT NULL, task_id TEXT NOT NULL, action TEXT NOT NULL,
            detail TEXT NOT NULL DEFAULT '' )""")
        self.db.commit()
        self.active = {}
        self.stop = False
        self.tasks = {}
        self.bootstrap_catalog()
        self.recover_stale_runs()

    def log_event(self, task, action, detail=""):
        self.db.execute("INSERT INTO events VALUES (?,?,?,?)",
                        (int(time.time()), task, action, str(detail)[:400]))
        self.db.commit()
        LOG.info("%s %s %s", task, action, str(detail)[:180])

    def update(self, task, **values):
        values["updated"] = int(time.time())
        sql = ", ".join(f"{k}=?" for k in values)
        self.db.execute(f"UPDATE tasks SET {sql} WHERE id=?",
                        tuple(values.values()) + (task,))
        self.db.commit()

    def rows(self):
        return {r["id"]: dict(r) for r in self.db.execute("SELECT * FROM tasks")}

    def bootstrap_catalog(self):
        data = json.loads((self.repo / "docs/00_index/agent_task_catalog.json").read_text())
        for task in data["tasks"]:
            identifier = safe_id(task["id"])
            self.tasks[identifier] = task
            state = DONE if identifier in BASELINE else PENDING
            self.db.execute(
                "INSERT OR IGNORE INTO tasks(id,title,deps,status,updated) VALUES (?,?,?,?,?)",
                (identifier, task["title"], json.dumps(task["depends_on"]), state, int(time.time())))
        self.db.commit()

    def recover_stale_runs(self):
        for row in self.db.execute("SELECT id FROM tasks WHERE status='RUNNING'").fetchall():
            self.update(row["id"], status="RETRY", ready_at=int(time.time())+30,
                        error="supervisor/container restarted during AGY run")
            self.log_event(row["id"], "RECOVERED", "workspace/commits preserved")

    def initialize_staging(self):
        staging = self.cfg["staging_branch"]
        if staging != "staging":
            raise RuntimeError("safety: only nonproduction staging is permitted")
        command(["git", "fetch", "-q", "origin", "main"], self.repo, timeout=60)
        result = command(["git", "ls-remote", "--heads", "origin", "staging"], self.repo)
        if not result:
            command(["git", "push", "origin", "origin/main:refs/heads/staging"],
                    self.repo, timeout=90)
            self.log_event("SYSTEM", "STAGING_CREATED", "from main, no production deployment")

    def prepare_worktree(self, task_id):
        row = self.rows()[task_id]
        if row["workspace"] and Path(row["workspace"]).exists():
            return Path(row["workspace"])
        branch = f"feat/auto-{task_id.lower()}"
        dest = self.worktrees / task_id.lower()
        if dest.exists() and not (dest / ".git").exists():
            raise RuntimeError(f"workspace exists without git: {dest}")
        if task_id == "P0-03":
            source = "origin/feat/p0-03-identity-foundation"
            command(["git", "fetch", "-q", "origin",
                     "feat/p0-03-identity-foundation"], self.repo)
        else:
            source = "origin/staging"
            command(["git", "fetch", "-q", "origin", "staging"], self.repo)
        base_sha = command(["git", "rev-parse", source], self.repo)
        if not dest.exists():
            existing_branch = command(["git", "branch", "--list", branch], self.repo)
            if existing_branch:
                command(["git", "worktree", "add", str(dest), branch], self.repo)
            else:
                command(["git", "worktree", "add", "-b", branch, str(dest), source],
                        self.repo, timeout=90)
        self.update(task_id, workspace=str(dest), branch=branch, base_sha=base_sha)
        return dest

    def make_prompt(self, task_id):
        task = self.tasks[task_id]
        row = self.rows()[task_id]
        refs = "\n".join(" - " + p for p in task.get("reading_refs", []))
        outcomes = "\n".join(" - " + a for a in task.get("acceptance", []))
        result_path = self.state / "results" / (task_id + ".json")
        previous = ("Previous attempt feedback:\n" + row["error"] + "\n"
                    if row["error"] else "")
        special = ""
        if task_id == "P0-03":
            special = """
INTEGRATION STARTING POINT:
This task starts on origin/feat/p0-03-identity-foundation at 03e423a.
Four validated sibling branches have independently committed scoped code:
 feat/p0-03-provider-sync   commit 0e3debb
 feat/p0-03-web-auth        commit 02433a3
 feat/p0-03-mobile-auth     commit 3c2e955
 feat/p0-03-invitations    commit d9e1670
First fetch each branch from origin, inspect their evidence/checks, cherry-pick the
four commits into THIS dedicated worktree and resolve code/lockfile conflicts.
Then finish the P0-03 integration seams safely, exercise real local Postgres
where test credentials exist, run actual Go/web/Flutter/document checks.
Clerk provider credentials and P0-04 RLS remain external gates; never claim
end-to-end identity is complete or enable untested production routes.
"""
        return f"""You are the authorized AGY coding worker for Creativanta task {task_id}.
Your dedicated worktree is {row['workspace']}.
You have no authorization to edit ANY OTHER repository or worktree.
MISSION: {task['title']}
PHASE: {task['phase']}
DELIVERABLE: {task['deliverable']}
ACCEPTANCE TARGETS:
{outcomes}
READ THESE FEATURE REFS (after mandatory root docs):
{refs}
{special}
MANDATORY OPERATING RULES:
1. Read AGENTS.md and the FOUR mandatory canonical docs first, as ordered there.
2. Follow docs/00_index/AGENT_BUILD_BACKLOG.md and BUILD_EXECUTION_CONTRACT.md.
3. Preserve every feature, screen, six modes, design/v5, permission/RLS/money rules.
4. No demos posing as live data. No mock pretending to be Clerk or production provider.
5. Do not disable security, CI, auth, RBAC, idempotency or error gates.
6. You may use the command, write_file, edit_file tools in this WORKTREE only.
7. Implement a real meaningful vertical slice. Include failure, cancellation, denial
   and replay fixtures as appropriate, with tests and truthful evidence.
8. Update the phase implementation manifest and evidence; distinguish LOCAL_IMPLEMENTED
   from full ACCEPTED and record external dependencies honestly.
9. Run gofmt/Go tests/race, Svelte check/test/build, Flutter analyze/test, proto
   and docs checks that apply to YOUR changed files. Use local tools where available.
10. Do NOT alter docs/09_archive, delete existing scope, deploy, edit VPS services,
    touch crypto projects, merge into main, or modify GitHub Actions secrets.
11. Commit meaningful changes on your branch with descriptive commit, git push
    origin HEAD:{row['branch']} only after local tests pass. Never push staging/main.
12. Only when implemented and locally tested: write VALID JSON to {result_path}
    with keys: status (implemented_local|partial|blocked), checks (array of
    actual commands/results), external_gates (array), remaining_scope (array),
    notes (string). This report is not a certificate; GitHub CI independently gates.
13. If incomplete but progress exists, commit it, accurately state status=partial.
    The supervisor will reopen this task. If genuinely blocked, state=blocked
    with honest reason; don't fabricate secrets or approvals.
14. Do not close PRs or pretend CI GREEN based on locally mocked output.
{previous}
Begin by evaluating Git history/status, then implement. Continue work without
asking the user to reopen ChatGPT. Your completed changes will be reviewed by
CI and integrated into staging only, never deployed automatically.
"""

    def launch(self, task_id):
        row = self.rows()[task_id]
        workspace = self.prepare_worktree(task_id)
        prompt = self.make_prompt(task_id)
        model = self.cfg["models"]["complex"] if (
            task_id in {"P0-03", "P0-04", "P0-05", "P0-06", "P0-07"} or
            any(x in self.tasks[task_id]["title"].lower()
                for x in ["billing", "credit", "tenant", "security", "migration", "payment"])
        ) else self.cfg["models"]["regular"]
        result_path = self.state / "results" / (task_id + ".json")
        if result_path.exists():
            result_path.unlink()  # must be freshly verified on every attempt
        log = self.state / "logs" / f"{task_id}-attempt-{row['attempts']+1}.log"
        permissions = {"permissions": {"allow": [
            "command(*)", "write_file(*)", "edit_file(*)", "apply_patch(*)",
            "create_directory(*)"]}}
        args = ["agy", "--model", model, "--settings", json.dumps(permissions),
                "--print-timeout", "0s", "-p", prompt]
        f = log.open("w")
        try:
            proc = subprocess.Popen(args, cwd=str(workspace), stdout=f,
                                    stderr=subprocess.STDOUT, start_new_session=True)
        finally:
            f.close()
        self.active[task_id] = (proc, int(time.time()), log)
        self.update(task_id, status="RUNNING", attempts=row["attempts"]+1,
                    started=int(time.time()), output=str(log))
        self.log_event(task_id, "STARTED", f"pid={proc.pid} model={model}")

    def mark_retry(self, task_id, message):
        row = self.rows()[task_id]
        if row["attempts"] >= self.cfg["max_iterations_per_task"]:
            self.update(task_id, status="BLOCKED", error=message)
            self.log_event(task_id, "BLOCKED", message)
        else:
            due = int(time.time()) + retry_seconds(row["attempts"])
            self.update(task_id, status="RETRY", ready_at=due, error=message)
            self.log_event(task_id, "RETRY_QUEUED", message)

    def finish_worker(self, task_id, proc, log):
        try:
            output = log.read_text(errors="replace")[-18000:]
        except OSError:
            output = ""
        if proc.returncode:
            self.mark_retry(task_id, f"AGY exit={proc.returncode}; log={log}")
            return
        if "auto-denied" in output or 'tool required the "write_file" permission' in output:
            self.mark_retry(task_id, "AGY denied a required tool permission")
            return
        row = self.rows()[task_id]
        workspace = Path(row["workspace"])
        sha = command(["git", "rev-parse", "HEAD"], workspace)
        ahead = int(command(["git", "rev-list", "--count",
                             f"{row['base_sha']}..HEAD"], workspace))
        dirty = command(["git", "status", "--porcelain"], workspace)
        report = json_result(self.state / "results" / (task_id + ".json"))
        if ahead == 0 or dirty:
            self.mark_retry(task_id, f"no committed code (ahead={ahead}), dirty={bool(dirty)}")
            return
        if not report:
            self.mark_retry(task_id, "missing/invalid fresh agent evidence JSON")
            return
        if report["status"] == "blocked":
            self.update(task_id, status="BLOCKED", sha=sha,
                        error=str(report.get("notes", "external blocker"))[:350])
            self.log_event(task_id, "BLOCKED", report.get("notes", "external gate"))
            return
        if report["status"] != "implemented_local" or not report["checks"]:
            self.mark_retry(task_id, "partial scope or missing actual test commands")
            return
        if command(["git", "diff", "--check", row["base_sha"], "HEAD"],
                   workspace, check=False):
            self.mark_retry(task_id, "git diff --check reported violations")
            return
        try:
            command(["git", "push", "origin", f"HEAD:refs/heads/{row['branch']}"],
                    workspace, timeout=120)
            pr = self.ensure_pr(task_id, row["branch"])
        except Exception as ex:
            self.mark_retry(task_id, f"push/PR failure: {ex}")
            return
        self.update(task_id, status="CI_PENDING", pr=str(pr), sha=sha,
                    ready_at=int(time.time())+15, error="")
        self.log_event(task_id, "PR_OPENED", pr)

    def ensure_pr(self, task_id, branch):
        existing = command(["gh", "pr", "list", "-R", REPO_FULL, "--head", branch,
                            "--state", "open", "--json", "number"], self.repo)
        records = json.loads(existing)
        if records:
            return records[0]["number"]
        title = f"{task_id}: {self.tasks[task_id]['title']}"
        body = (f"AGY autonomous task {task_id}. Candidate code for STAGING only.\n\n"
                "Passing GitHub CI is required before integration. External Clerk,"
                " RLS, billing, legal and release gates remain independently active."
                "\nNever interpret this PR as production approval.")
        command(["gh", "pr", "create", "-R", REPO_FULL, "--base", "staging",
                 "--head", branch, "--title", title[:240], "--body", body],
                self.repo, timeout=90)
        found = command(["gh", "pr", "list", "-R", REPO_FULL, "--head", branch,
                         "--state", "open", "--json", "number"], self.repo)
        records = json.loads(found)
        if not records:
            raise RuntimeError("PR created but not found")
        return records[0]["number"]

    def evaluate_ci(self, task_id):
        row = self.rows()[task_id]
        if row["ready_at"] > time.time():
            return
        try:
            raw = command(["gh", "pr", "view", row["pr"], "-R", REPO_FULL, "--json",
                           "baseRefName,state,isDraft,mergeable,statusCheckRollup"], self.repo,
                          timeout=45)
            info = json.loads(raw)
        except Exception as ex:
            self.update(task_id, ready_at=int(time.time())+90,
                        error=f"GitHub temporarily unavailable: {str(ex)[:180]}")
            return
        if info.get("baseRefName") != "staging":
            self.update(task_id, status="BLOCKED", error="SAFETY: unexpected PR base")
            return
        if info.get("state") == "MERGED":
            self.update(task_id, status=DONE, error="")
            self.log_event(task_id, DONE, f"PR #{row['pr']}")
            return
        if info.get("state") != "OPEN" or info.get("isDraft"):
            self.update(task_id, status="BLOCKED", error="PR not open/reviewable")
            return
        verdict = eval_checks(info.get("statusCheckRollup") or [])
        if verdict == "failure":
            self.mark_retry(task_id, f"GitHub CI failed for PR #{row['pr']}. Inspect gh pr checks.")
            return
        if verdict != "success" or info.get("mergeable") == "UNKNOWN":
            self.update(task_id, ready_at=int(time.time())+45)
            return
        if info.get("mergeable") != "MERGEABLE":
            self.mark_retry(task_id, f"PR conflict: mergeable={info.get('mergeable')}")
            return
        try:
            # Strict invariant: NO automatic merging to main, release or production.
            command(["gh", "pr", "merge", row["pr"], "-R", REPO_FULL, "--merge"],
                    self.repo, timeout=120)
            self.update(task_id, status=DONE, ready_at=0, error="")
            self.log_event(task_id, DONE, f"CI GREEN + merged to staging; PR #{row['pr']}")
        except Exception as ex:
            self.update(task_id, ready_at=int(time.time())+120,
                        error=f"staging merge waiting: {str(ex)[:180]}")

    def active_status(self):
        now = int(time.time())
        for task_id, (proc, started, log) in list(self.active.items()):
            code = proc.poll()
            if code is None and now-started > self.cfg["max_agent_minutes"]*60:
                os.killpg(proc.pid, signal.SIGTERM)
                try:
                    proc.wait(timeout=8)
                except subprocess.TimeoutExpired:
                    os.killpg(proc.pid, signal.SIGKILL)
                    proc.wait(timeout=8)
                code = proc.returncode
            if code is None:
                continue
            self.active.pop(task_id)
            self.finish_worker(task_id, proc, log)

    def dispatch(self):
        now = int(time.time())
        if self.cfg.get("paused", False):
            return
        launched_today = self.db.execute(
            "SELECT COUNT(*) FROM events WHERE action='STARTED' AND ts>?",
            (now-86400,)).fetchone()[0]
        slots = max(0, self.cfg["max_concurrent"] - len(self.active))
        quotas = max(0, self.cfg["max_runs_per_24h"] - launched_today)
        if not slots or not quotas:
            return
        statuses = {k: row["status"] for k, row in self.rows().items()}
        for task in self.tasks.values():
            if not slots or not quotas:
                return
            row = self.rows()[task["id"]]
            if row["status"] not in {PENDING, "RETRY"} or row["ready_at"] > now:
                continue
            if not deps_ready(task.get("depends_on", []), statuses):
                continue
            try:
                self.launch(task["id"])
            except Exception as ex:
                self.mark_retry(task["id"], f"launch failed: {ex}")
            slots -= 1
            quotas -= 1

    def write_snapshot(self):
        rows = self.rows()
        statuses = {k: v["status"] for k, v in rows.items()}
        snap = {
            "time_utc": int(time.time()),
            "pid": os.getpid(),
            "running": sorted(self.active),
            "counts": {s: list(statuses.values()).count(s) for s in set(statuses.values())},
            "tasks": [
                {"id": k, "status": r["status"], "attempts": r["attempts"],
                 "sha": r["sha"], "pr": r["pr"], "error": r["error"][:250],
                 "dependencies": json.loads(r["deps"])}
                for k, r in rows.items()
            ],
        }
        path = self.state / "status.json"
        tmp = path.with_suffix(".tmp")
        tmp.write_text(json.dumps(snap, ensure_ascii=False, indent=2) + "\n")
        tmp.replace(path)

    def tick(self):
        self.cfg = json.loads(self.config_path.read_text())
        self.active_status()
        for row in self.rows().values():
            if row["status"] == "CI_PENDING":
                self.evaluate_ci(row["id"])
        self.dispatch()
        self.write_snapshot()

    def run(self, once=False):
        self.initialize_staging()
        def stop(*_):
            self.stop = True
        signal.signal(signal.SIGTERM, stop)
        signal.signal(signal.SIGINT, stop)
        LOG.info("started poll=%ss concurrency=%s staging-only",
                 self.cfg["interval_seconds"], self.cfg["max_concurrent"])
        while not self.stop:
            try:
                self.tick()
            except Exception:
                LOG.exception("tick failed; will retry (process remains healthy)")
            if once:
                return
            time.sleep(max(5, int(self.cfg["interval_seconds"])))
        for task_id, (proc, _, _) in self.active.items():
            if proc.poll() is None:
                os.killpg(proc.pid, signal.SIGTERM)
                self.log_event(task_id, "PAUSED", "supervisor stopping; will recover")
        self.write_snapshot()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=("run", "once", "status"))
    parser.add_argument("--config", default="/opt/harness/config.json")
    args = parser.parse_args()
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
    if args.action == "status":
        cfg = json.loads(Path(args.config).read_text())
        snap = Path(cfg["state_dir"]) / "status.json"
        if not snap.exists():
            print("NOT_STARTED")
            return 2
        data = json.loads(snap.read_text())
        print(json.dumps({"time_utc":data["time_utc"],"running":data["running"],
                          "counts":data["counts"]}, indent=2))
        for t in data["tasks"]:
            if t["status"] not in {"PENDING", "INTEGRATED"}:
                print(t["id"], t["status"], "attempts="+str(t["attempts"]),
                      "PR="+str(t["pr"]), t["error"][:100])
        return 0
    harness = Harness(args.config)
    harness.run(once=args.action == "once")
    return 0

if __name__ == "__main__":
    sys.exit(main())

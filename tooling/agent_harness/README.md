# Creativanta Autonomous Agent Harness

This is an **AGY-native implementation of Symphony-style orchestration**, not the
official OpenAI Symphony Elixir runtime. It reads the canonical 60-task backlog
from `docs/00_index/agent_task_catalog.json`, uses short-lived AGY sessions
with a durable supervisor, and provides independent CI-gated staging integration.

## Why this exists

The old `run-agent.sh` starts one AGY session and exits. There is no owner to
start the next task, retry transient issues, validate GitHub CI, or restart an
agent after machine reboot. ChatGPT interaction was inadvertently acting as
the missing scheduler.

This service makes **task state**, not conversations, the unit of work.

## Install

The deployed source is located on the evergreen VPS at
`~/.local/share/creativanta-harness/`. This repository folder is its versioned
copy. On the VPS, run from the deployed source directory:

```sh
python3 -m unittest discover -s tests -v
docker compose build
docker compose up -d
docker compose exec -T scheduler python3 /opt/harness/supervisor.py status
docker compose logs -f --tail 30 scheduler
```

The container has `restart: unless-stopped`, which survives daemon/server
reboots. The state is stored on the host in `data/state.sqlite3`, with
`data/status.json` for quick inspection, agent logs, and result evidence.

The deployment uses a **separate Creativanta Git clone** and AGY worktrees,
not the developer's main checkout. Keep the Docker mounts restricted to the
Creativanta clone, local development toolchain and dedicated AGY/GitHub auth.

## Task lifecycle

1. Load canonical task DAG; P0-01/P0-02 are already merged in main.
2. Dispatch only tasks whose direct dependencies have **passed CI and merged
   to development staging** (this is *code integration*, not business acceptance).
3. Prepare unique Git worktree based on staging (P0-03 uses its prior feature
   branch as a starting point), generate a source-linked prompt.
4. Run an AGY CLI agent with bounded lifetime, model-specific routing and
   audited tooling permissions inside an unprivileged container.
5. Reject exit-code-only success: require a Git commit, clean worktree, no
   permission-denied output, fresh structured local evidence, and diff checks.
6. Push task branch, create PR **targeting staging only**.
7. Require the real GitHub Actions CI Gate success and absence of failed checks.
   Only then auto-merge this PR into staging and unlock dependent work.
8. Retry failures with bounded exponential backoff; persist exhausted/blocked
   tasks and continue unrelated ready work. A restart recovers unfinished tasks.
9. Preserve P0-P8 requirement inventory, remaining external gates and history.

There is **no automatic merge to main, production deployment or provider
approval**. Staging integration is never reported as ACCEPTED or LAUNCH_APPROVED.
P0-03, for example, still requires live Clerk and P0-04 RLS evidence.

## Operations

```sh
# Process + backed-up state:
docker inspect -f '{{.HostConfig.RestartPolicy.Name}} {{.State.Status}}' creativanta-agy-supervisor
docker compose exec -T scheduler python3 /opt/harness/supervisor.py status
docker compose logs --tail 100 --no-color scheduler

# Pause new dispatch (running agents finish their current turn):
# Set `paused: true` in config.json, then wait one scheduler poll.
# Set `paused: false` to resume.
docker compose restart scheduler
```

Config keys: `max_concurrent` (default 2), `max_runs_per_24h` (0 = disabled),
`max_agent_minutes` (45), `max_iterations_per_task` (6), `paused` and
model routing. Changes are reread at every poll. SQLite, GitHub and worktree
state are source-of-truth; the dashboard is an observation, not authority.

The local `max_runs_per_24h` counter is NOT an AGY provider quota. Setting
it to `0` or `null` disables Creativanta's artificial daily launch cap. Keep
`max_concurrent`, agent timeouts, bounded retries, dependencies, CI and staging
gates enforced. The supervisor reports actual active subprocess PIDs, elapsed
runtime, log activity and launch history separately in `data/status.json`.
A live process proves only that AGY started; code commits and CI are stronger
proof of useful completion.

If `git diff --check` rejects *only* whitespace in machine-generated
`build/phase-P*/p*-*/evidence/*.log` files, the harness makes a traceable
whitespace-only commit and reruns the original strict Git check. Source code,
schema, test fixtures and security checks are never automatically bypassed.
Provider-side API quotas and billing limits are not controlled here.

### Limitations

- This is a **project-specific subset** of the Symphony public spec. It does
  not implement Codex App Server protocol, tracker-specific issue tools, or the
  official Symphony Elixir daemon. The runner uses the available AGY CLI.
- The state file must remain on a persistent disk, and backups should include
  `state.sqlite3`. Network/GitHub/CI outages can block progression temporarily.
- A project without configured provider credentials can still implement safe
  local boundaries, but final live E2E/security/launch gates cannot be faked.
- The scheduler never treats CI green as proof of entire P0/P8 acceptance.
- Auto-merge is **staging only**; review main-branch release changes separately.

Architectural references:
- https://github.com/openai/symphony/blob/main/SPEC.md
- https://github.com/gastownhall/gastown/blob/main/docs/agent-provider-integration.md
- https://github.com/Intelligent-Internet/zenith

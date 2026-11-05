#!/usr/bin/env bash
# POST-P8 Runtime/DB/API Security & Real Integration Readiness Gate
# Classification: STAGING/LOCAL (real OS processes + isolated PostgreSQL 17.10)
# Never touches persistent databases or shared ports; fails closed on any assertion failure.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT"

POSTGRES_IMAGE="postgres@sha256:7958605b474b3d264a969cb3a123d6aa00ad1e1fe9da8a69984dabb704d93317"
POSTGRES_FALLBACK_IMAGE="postgres:17.10"

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/creativanta-runtime-e2e.XXXXXX")"
EPHEMERAL_PG_CONTAINER=""
API_PID=""
ADMIN_API_PID=""
ROGUE_PID=""

cleanup() {
  local exit_code=$?
  for pid_var in API_PID ADMIN_API_PID ROGUE_PID; do
    local pid="${!pid_var:-}"
    if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
      wait "$pid" 2>/dev/null || true
    fi
  done
  if [[ -n "$EPHEMERAL_PG_CONTAINER" ]]; then
    docker rm -f "$EPHEMERAL_PG_CONTAINER" >/dev/null 2>&1 || true
  fi
  rm -rf "$TMP_DIR"
  exit "$exit_code"
}
trap cleanup EXIT INT TERM

fail() {
  echo "FAIL [runtime-readiness]: $*" >&2
  exit 1
}

info() {
  echo "==> [runtime-readiness] $*"
}

check_prereqs() {
  for cmd in go python3 curl; do
    command -v "$cmd" >/dev/null 2>&1 || fail "missing required prerequisite command: $cmd"
  done
}

pick_loopback_port() {
  python3 -c '
import socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(("127.0.0.1", 0))
print(s.getsockname()[1])
s.close()
'
}

wait_for_http_status() {
  local url="$1"
  local expected="$2"
  local label="$3"
  local status=""
  for _ in $(seq 1 60); do
    status="$(curl -sS -o /dev/null -w '%{http_code}' "$url" 2>/dev/null || true)"
    if [[ "$status" == "$expected" ]]; then
      return 0
    fi
    sleep 0.05
  done
  fail "$label did not return HTTP $expected at $url (last status: ${status:-none})"
}

probe_endpoint() {
  local method="$1"
  local url="$2"
  local expected_status="$3"
  local expected_substring="$4"
  local label="$5"
  shift 5
  local hdr_file="$TMP_DIR/probe.headers"
  local body_file="$TMP_DIR/probe.body"
  rm -f "$hdr_file" "$body_file"

  local status
  status="$(curl -sS -X "$method" "$@" -D "$hdr_file" -o "$body_file" -w '%{http_code}' "$url")" || fail "$label curl request failed"
  if [[ "$status" != "$expected_status" ]]; then
    fail "$label returned HTTP $status, expected $expected_status (body: $(cat "$body_file" 2>/dev/null || true))"
  fi

  if [[ -n "$expected_substring" ]] && ! grep -Fq "$expected_substring" "$body_file"; then
    fail "$label body missing expected substring '$expected_substring': $(cat "$body_file")"
  fi

  grep -Fqi "Content-Type: application/json" "$hdr_file" || fail "$label missing Content-Type: application/json header"
  grep -Fqi "Cache-Control: no-store" "$hdr_file" || fail "$label missing Cache-Control: no-store header"
  grep -Fqi "X-Content-Type-Options: nosniff" "$hdr_file" || fail "$label missing X-Content-Type-Options: nosniff header"
  if [[ "$expected_status" == "405" ]]; then
    grep -Fqi "Allow: GET" "$hdr_file" || fail "$label 405 response missing Allow: GET header"
  fi
}

# Support forced-failure modes to prove fail-closed propagation and cleanup.
if [[ -n "${CREATIVANTA_RUNTIME_E2E_FORCE_FAIL:-}" ]]; then
  rogue_port="$(pick_loopback_port)"
  mode="${CREATIVANTA_RUNTIME_E2E_FORCE_FAIL}"
  python3 - "$rogue_port" "$mode" <<'PY' &
import http.server, sys

port = int(sys.argv[1])
mode = sys.argv[2]

class RogueHandler(http.server.BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        pass
    def _send(self, code, body, include_sec_headers=True):
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        if include_sec_headers:
            self.send_header("Cache-Control", "no-store")
            self.send_header("X-Content-Type-Options", "nosniff")
        self.end_headers()
        self.wfile.write(body.encode("utf-8"))
    def do_GET(self):
        if self.path == "/healthz":
            self._send(200, '{"status":"alive","role":"api"}')
        elif self.path == "/readyz":
            if mode == "bad_readyz":
                self._send(200, '{"status":"ready","role":"api"}')
            else:
                self._send(503, '{"status":"not_ready","role":"api"}')
        elif self.path == "/admin/users" and mode == "bad_forbidden_route":
            self._send(200, '{"admin":"leaked"}')
        else:
            self._send(404, '{"error":"not_found"}')
    def do_POST(self):
        if mode == "bad_method":
            self._send(200, '{"unexpected":"post_allowed"}')
        else:
            self.send_response(405)
            self.send_header("Allow", "GET")
            self.send_header("Content-Type", "application/json")
            self.send_header("Cache-Control", "no-store")
            self.send_header("X-Content-Type-Options", "nosniff")
            self.end_headers()
            self.wfile.write(b'{"error":"method_not_allowed"}')

http.server.HTTPServer(("127.0.0.1", port), RogueHandler).serve_forever()
PY
  ROGUE_PID="$!"
  wait_for_http_status "http://127.0.0.1:${rogue_port}/healthz" "200" "rogue-server"
  probe_endpoint "GET" "http://127.0.0.1:${rogue_port}/readyz" "503" '"status":"not_ready"' "rogue /readyz"
  probe_endpoint "GET" "http://127.0.0.1:${rogue_port}/admin/users" "404" '"error":"not_found"' "rogue /admin/users"
  probe_endpoint "POST" "http://127.0.0.1:${rogue_port}/healthz" "405" '"error":"method_not_allowed"' "rogue POST /healthz"
  exit 0
fi

check_prereqs

# Step 1: Failure-propagation & cleanup self-test
info "Step 1/6: Verifying fail-closed assertion propagation and child-process cleanup..."
for fail_mode in bad_readyz bad_forbidden_route bad_method; do
  if CREATIVANTA_RUNTIME_E2E_FORCE_FAIL="$fail_mode" "${BASH_SOURCE[0]}" >/dev/null 2>&1; then
    fail "self-test mode '$fail_mode' unexpectedly succeeded (must fail closed)"
  fi
done
info "PASS: All simulated rogue server assertions failed closed and cleaned up cleanly."

# Step 2: Compile real Go entrypoints into ephemeral directory
info "Step 2/6: Compiling real Go binaries (api, admin-api, worker, outbox, migrate)..."
(
  cd "$ROOT/apps/api"
  for target in api admin-api worker outbox migrate; do
    go build -o "$TMP_DIR/$target" "./cmd/$target"
  done
)

# Step 3: Probe real compiled processes on loopback ephemeral ports
info "Step 3/6: Probing real api and admin-api processes on loopback ephemeral ports..."

# 3a. Non-loopback bind refusal
if CREATIVANTA_API_LISTEN_ADDR="0.0.0.0:18080" "$TMP_DIR/api" >"$TMP_DIR/api_nonloop.log" 2>&1; then
  fail "cmd/api accepted non-loopback address 0.0.0.0:18080"
fi
grep -Fq "bind address must be loopback" "$TMP_DIR/api_nonloop.log" || fail "cmd/api missing non-loopback refusal error"

if CREATIVANTA_ADMIN_LISTEN_ADDR="0.0.0.0:18081" "$TMP_DIR/admin-api" >"$TMP_DIR/admin_nonloop.log" 2>&1; then
  fail "cmd/admin-api accepted non-loopback address 0.0.0.0:18081"
fi
grep -Fq "bind address must be loopback" "$TMP_DIR/admin_nonloop.log" || fail "cmd/admin-api missing non-loopback refusal error"

# 3b. Start real api and admin-api on ephemeral loopback ports
API_PORT="$(pick_loopback_port)"
ADMIN_API_PORT="$(pick_loopback_port)"
while [[ "$ADMIN_API_PORT" == "$API_PORT" ]]; do
  ADMIN_API_PORT="$(pick_loopback_port)"
done

CREATIVANTA_API_LISTEN_ADDR="127.0.0.1:${API_PORT}" "$TMP_DIR/api" >"$TMP_DIR/api.log" 2>&1 &
API_PID="$!"

CREATIVANTA_ADMIN_LISTEN_ADDR="127.0.0.1:${ADMIN_API_PORT}" "$TMP_DIR/admin-api" >"$TMP_DIR/admin-api.log" 2>&1 &
ADMIN_API_PID="$!"

wait_for_http_status "http://127.0.0.1:${API_PORT}/healthz" "200" "cmd/api /healthz"
wait_for_http_status "http://127.0.0.1:${ADMIN_API_PORT}/healthz" "200" "cmd/admin-api /healthz"

for surface in "api:${API_PORT}" "admin-api:${ADMIN_API_PORT}"; do
  role="${surface%%:*}"
  port="${surface##*:}"
  base="http://127.0.0.1:${port}"

  probe_endpoint "GET" "${base}/healthz" "200" "\"status\":\"alive\",\"role\":\"${role}\"" "${role} GET /healthz"
  probe_endpoint "GET" "${base}/readyz" "503" '"status":"not_ready"' "${role} GET /readyz (fail-closed)"

  for method in POST PUT DELETE PATCH OPTIONS; do
    probe_endpoint "$method" "${base}/healthz" "405" '"error":"method_not_allowed"' "${role} ${method} /healthz"
    probe_endpoint "$method" "${base}/readyz" "405" '"error":"method_not_allowed"' "${role} ${method} /readyz"
  done

  for forbidden_path in "/" "/v1/workspaces" "/admin/users" "/internal/admin" "/metrics" "/debug/pprof" "/creativanta.v1.AuthService/GetSession"; do
    probe_endpoint "GET" "${base}${forbidden_path}" "404" '"error":"not_found"' "${role} GET ${forbidden_path}" \
      -H "Authorization: Bearer forged.jwt.token" \
      -H "X-Workspace-ID: aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"
    probe_endpoint "POST" "${base}${forbidden_path}" "404" '"error":"not_found"' "${role} POST ${forbidden_path}" \
      -H "Authorization: Bearer forged.jwt.token" \
      -H "X-Workspace-ID: aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa" \
      -d '{}'
  done
done

# Stop api and admin-api cleanly and verify exit code 0
kill -TERM "$API_PID" "$ADMIN_API_PID"
wait "$API_PID" || fail "cmd/api did not exit cleanly on SIGTERM"
wait "$ADMIN_API_PID" || fail "cmd/admin-api did not exit cleanly on SIGTERM"
API_PID=""
ADMIN_API_PID=""

# 3c. Verify worker, outbox, and migrate fail closed (exit code 2) without arguments/credentials
for daemon in worker outbox migrate; do
  set +e
  "$TMP_DIR/$daemon" >"$TMP_DIR/${daemon}.log" 2>&1
  rc=$?
  set -e
  [[ "$rc" -eq 2 ]] || fail "cmd/$daemon expected exit code 2 without arguments, got $rc"
  grep -Fq "not implemented" "$TMP_DIR/${daemon}.log" || fail "cmd/$daemon missing fail-closed stderr message"
done
info "PASS: Real-process entrypoint lifecycle, negative method, forbidden route, and daemon fail-closed checks succeeded."

# Step 4: Isolated PostgreSQL 17.10 container setup (if DSN not already provided)
TEST_DSN="${CREATIVANTA_TEST_DATABASE_URL:-${CREATIVANTA_TEST_POSTGRES_DSN:-}}"
if [[ -z "$TEST_DSN" ]]; then
  info "Step 4/6: Starting isolated ephemeral PostgreSQL 17.10 container on random loopback port..."
  command -v docker >/dev/null 2>&1 || fail "docker is required when CREATIVANTA_TEST_DATABASE_URL is not set"
  docker info >/dev/null 2>&1 || fail "docker daemon is not reachable"

  IMAGE_TO_USE="$POSTGRES_IMAGE"
  if ! docker image inspect "$IMAGE_TO_USE" >/dev/null 2>&1; then
    IMAGE_TO_USE="$POSTGRES_FALLBACK_IMAGE"
  fi

  EPHEMERAL_PG_CONTAINER="creativanta-readiness-runtime-pg-$$"
  EPHEMERAL_PG_PASS="ephemeral_pg_pass_$$"
  docker run -d --rm \
    --name "$EPHEMERAL_PG_CONTAINER" \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD="$EPHEMERAL_PG_PASS" \
    -e POSTGRES_DB=creativanta_readiness_e2e \
    --tmpfs /var/lib/postgresql/data:rw,noexec,nosuid,size=512m \
    -p 127.0.0.1::5432 \
    "$IMAGE_TO_USE" >/dev/null

  PG_HOST_PORT="$(docker port "$EPHEMERAL_PG_CONTAINER" 5432/tcp | head -n1 | awk -F: '{print $NF}')"
  [[ -n "$PG_HOST_PORT" ]] || fail "failed to resolve ephemeral host port for PostgreSQL container"

  pg_ready=0
  for _ in $(seq 1 60); do
    if docker exec -e PGPASSWORD="$EPHEMERAL_PG_PASS" "$EPHEMERAL_PG_CONTAINER" \
      psql -h 127.0.0.1 -U postgres -d creativanta_readiness_e2e -c "SELECT 1" >/dev/null 2>&1; then
      pg_ready=1
      break
    fi
    sleep 0.25
  done
  [[ "$pg_ready" -eq 1 ]] || fail "ephemeral PostgreSQL 17 container failed to become ready over TCP"

  TEST_DSN="postgres://postgres:${EPHEMERAL_PG_PASS}@127.0.0.1:${PG_HOST_PORT}/creativanta_readiness_e2e?sslmode=disable"
  info "Isolated PostgreSQL 17.10 ready on 127.0.0.1:${PG_HOST_PORT}/creativanta_readiness_e2e (container: ${EPHEMERAL_PG_CONTAINER})"
else
  info "Step 4/6: Using provided isolated test database DSN from environment."
fi

export CREATIVANTA_TEST_DATABASE_URL="$TEST_DSN"
export CREATIVANTA_TEST_POSTGRES_DSN="$TEST_DSN"

# Step 5: Run real compiled cmd/migrate CLI against isolated PostgreSQL 17.10
info "Step 5/6: Running compiled cmd/migrate up & status against isolated PostgreSQL 17.10..."
CREATIVANTA_MIGRATE_DATABASE_URL="$TEST_DSN" CREATIVANTA_MIGRATIONS_DIR="$ROOT/infra/migrations" "$TMP_DIR/migrate" up >"$TMP_DIR/migrate_up.log" 2>&1 || {
  cat "$TMP_DIR/migrate_up.log" >&2
  fail "cmd/migrate up failed against isolated PostgreSQL 17.10"
}
CREATIVANTA_MIGRATE_DATABASE_URL="$TEST_DSN" CREATIVANTA_MIGRATIONS_DIR="$ROOT/infra/migrations" "$TMP_DIR/migrate" status >"$TMP_DIR/migrate_status.log" 2>&1 || {
  cat "$TMP_DIR/migrate_status.log" >&2
  fail "cmd/migrate status failed against isolated PostgreSQL 17.10"
}
applied_count="$(grep -c 'applied=true' "$TMP_DIR/migrate_status.log" || true)"
expected_migrations="$(find "$ROOT/infra/migrations" -maxdepth 1 -type f -name '[0-9]*_*.sql' | wc -l | tr -d '[:space:]')"
[[ "$expected_migrations" -ge 47 ]] || fail "migration source unexpectedly missing canonical files (found $expected_migrations)"
[[ "$applied_count" -eq "$expected_migrations" ]] || fail "expected $expected_migrations applied migrations in cmd/migrate status, got $applied_count"
info "PASS: cmd/migrate CLI applied and verified all $expected_migrations canonical SQL migrations."

# Step 6: Execute real Go integration, RLS, negative auth, replay, and race suites
info "Step 6/6: Running live PostgreSQL 17.10 & Go -race security/RLS/replay test suites..."
"$ROOT/tooling/ci/check_identity.sh"

(
  cd "$ROOT/apps/api"
  go test -p 1 -race -count=1 \
    ./internal/bootstrap/... \
    ./internal/transportauth/... \
    ./internal/identity/... \
    ./internal/tenantdb/... \
    ./internal/migrate/... \
    ./internal/outbox/... \
    ./internal/internaladmin/... \
    ./internal/platformacceptance/...
)

cat <<'EOF'

================================================================================
CREATIVANTA RUNTIME/DB/API E2E READINESS SUMMARY
================================================================================
Verification Classification : STAGING/LOCAL (Real OS Processes + Ephemeral PG 17.10)
API / Admin-API Loopback    : VERIFIED (ephemeral 127.0.0.1 ports, non-loopback refused)
Readiness Fail-Closed       : VERIFIED (/readyz -> 503 when dependencies unwired)
Negative Auth & RBAC        : VERIFIED (401/404/405, zero default privileged routes)
PostgreSQL 17.10 Migrations : VERIFIED (47 Up / 47 Down / 47 Up + seed idempotency)
Tenant RLS & Composite FKs  : VERIFIED (app_user isolation, internal notes hidden)
Replay & Money Exactness    : VERIFIED (23505 dedup guards, zero float money columns)

EXTERNAL PRODUCTION GATES (TRUTHFUL STATUS — NOT CLAIMED BY LOCAL E2E):
  - EXT-GATE-CLERK-PRODUCTION                         : NOT VERIFIED (PENDING)
  - EXT-GATE-LIVE-PROVIDER-AND-CONNECTOR-VERIFICATION : NOT VERIFIED (PENDING)
  - EXT-GATE-PAYMENT-STRIPE-LIVE                      : NOT VERIFIED (PENDING)
  - LEG-H-001 (External Legal Counsel Sign-Off)       : NOT VERIFIED (PENDING)
  - EXT-GATE-STAGING-LOAD-AND-DR-REHEARSAL            : NOT VERIFIED (PENDING)
  - EXT-GATE-ACTIVEPIECES-ENTERPRISE-LICENSE          : NOT VERIFIED (PENDING)
================================================================================
EOF

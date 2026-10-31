#!/usr/bin/env bash
# Prove that errors propagate and an incorrectly ready server cannot pass smoke.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"

set +e
(set -eo pipefail; false | cat) >/dev/null 2>&1
pipeline_rc=$?
python3 -c 'assert False, "intentional negative test"' >/dev/null 2>&1
assertion_rc=$?
set -e
if [[ "$pipeline_rc" == 0 || "$assertion_rc" == 0 ]]; then
  echo 'FAIL: CI swallowed intentional negative test' >&2
  exit 1
fi

for path in "$HERE"/*.sh; do
  if [[ "$path" == "$HERE/self_test_failure.sh" ]]; then continue; fi
  if grep -n -E '(\|\|[[:space:]]*true|\|\|[[:space:]]*exit[[:space:]]+0)' "$path"; then
    echo "FAIL: forbidden success masking in $path" >&2
    exit 1
  fi
done

BAD_PORT="${MOCK_BAD_PORT:-18091}"
LOG="$(mktemp)"
python3 -u - "$BAD_PORT" <<'PY' &
import http.server,sys
class Broken(http.server.BaseHTTPRequestHandler):
    def log_message(self,*a):pass
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type','application/json')
        self.end_headers()
        if self.path=='/healthz':
            self.wfile.write(b'{"status":"alive","role":"api"}')
        else:
            self.wfile.write(b'{"status":"ready"}')
http.server.ThreadingHTTPServer(('127.0.0.1',int(sys.argv[1])),Broken).serve_forever()
PY
BAD_PID=$!
cleanup() {
  set +e
  kill "$BAD_PID" >/dev/null 2>&1
  wait "$BAD_PID" >/dev/null 2>&1
  rm -f "$LOG"
}
trap cleanup EXIT
for _ in $(seq 1 30); do
  if curl -sS --max-time 1 "http://127.0.0.1:$BAD_PORT/healthz" >/dev/null 2>&1; then break; fi
  sleep 0.1
done
set +e
SPAWN_SERVER=0 API_URL="http://127.0.0.1:$BAD_PORT" bash "$HERE/smoke_test.sh" >"$LOG" 2>&1
bad_smoke_rc=$?
set -e
if [[ "$bad_smoke_rc" == 0 ]]; then
  echo 'FAIL: smoke accepted premature readyz=200' >&2
  exit 1
fi
if ! grep -q 'FAIL /readyz' "$LOG"; then
  echo 'FAIL: smoke failed for wrong reason, not readyz' >&2
  cat "$LOG" >&2
  exit 1
fi
echo 'NEGATIVE_TESTS_PASS: pipeline, assertion, anti-mask, bad readiness correctly fail'

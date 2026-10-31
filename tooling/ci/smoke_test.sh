#!/usr/bin/env bash
# P0-01 REAL server smoke: never substitute a mock API for runtime evidence.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PORT="${API_PORT:-18089}"
BASE="${API_URL:-http://127.0.0.1:${PORT}}"
DIR="$(mktemp -d)"
PID=""
cleanup() {
  if [[ -n "$PID" ]]; then
    set +e
    kill "$PID" >/dev/null 2>&1
    wait "$PID" >/dev/null 2>&1
    set -e
  fi
  rm -rf "$DIR"
}
trap cleanup EXIT

if [[ "${SPAWN_SERVER:-1}" == "1" ]]; then
  test -f "$ROOT/apps/api/go.mod"
  (
    cd "$ROOT/apps/api"
    GOTOOLCHAIN=local go build -o "$DIR/creativanta-api" ./cmd/api
  )
  CREATIVANTA_API_LISTEN_ADDR="127.0.0.1:${PORT}" "$DIR/creativanta-api" &
  PID="$!"
  found=0
  for _ in $(seq 1 80); do
    if ! kill -0 "$PID" 2>/dev/null; then
      echo "FAIL: API terminated during startup" >&2
      exit 1
    fi
    if curl -sS --max-time 1 -o /dev/null "$BASE/healthz" 2>/dev/null; then
      found=1
      break
    fi
    sleep 0.2
  done
  test "$found" = 1
fi

HEALTH_CODE="$(curl -sS --max-time 4 -o "$DIR/health.json" -w '%{http_code}' "$BASE/healthz")"
if [[ "$HEALTH_CODE" != '200' ]]; then echo "FAIL /healthz status: $HEALTH_CODE" >&2; exit 1; fi
python3 - "$DIR/health.json" <<'PY'
import json,sys
r=json.load(open(sys.argv[1]))
assert r.get('status')=='alive',r
assert r.get('role')=='api',r
PY

READY_CODE="$(curl -sS --max-time 4 -o "$DIR/ready.json" -w '%{http_code}' "$BASE/readyz")"
if [[ "$READY_CODE" != '503' ]]; then
  echo "FAIL /readyz must be 503 before real dependencies, got $READY_CODE" >&2
  exit 1
fi
python3 - "$DIR/ready.json" <<'PY'
import json,sys
r=json.load(open(sys.argv[1]))
assert r.get('status')=='not_ready',r
PY

POST_CODE="$(curl -sS --max-time 4 -o /dev/null -w '%{http_code}' -X POST "$BASE/healthz")"
[[ "$POST_CODE" == 405 ]] || { echo 'FAIL /healthz POST was not rejected' >&2; exit 1; }
echo "REAL_SMOKE_PASS: /healthz 200, /readyz 503, forbidden method 405"

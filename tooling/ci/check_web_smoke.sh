#!/usr/bin/env bash
# Exercise actual compiled SvelteKit Web and Admin runtime, not mocked HTML.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP="$(mktemp -d)"
PID=""
cleanup() {
  if [[ -n "$PID" ]]; then
    set +e
    kill "$PID" >/dev/null 2>&1
    wait "$PID" >/dev/null 2>&1
    set -e
  fi
  rm -rf "$TMP"
}
trap cleanup EXIT
for surface in web admin; do
  test -f "$ROOT/apps/$surface/build/index.js" || { echo "FAIL missing $surface SSR build" >&2; exit 1; }
  if [[ "$surface" == web ]]; then
    port="${CV_WEB_SMOKE_PORT:-18440}"
    routes=(/ /kham-pha /sang-tao /xuat-ban /kinh-doanh /intelligence/competitors /intelligence/benchmarks)
    marker='Creativanta'
  else
    port="${CV_ADMIN_SMOKE_PORT:-18441}"
    routes=(/)
    marker='Chưa cấp quyền truy cập'
  fi
  base="http://127.0.0.1:$port"
  (cd "$ROOT/apps/$surface" && HOST=127.0.0.1 PORT="$port" node build/index.js) > "$TMP/$surface.log" 2>&1 &
  PID="$!"
  ready=0
  for _ in $(seq 1 70); do
    if ! kill -0 "$PID" 2>/dev/null;then cat "$TMP/$surface.log" >&2;exit 1;fi
    if curl --fail -sS --max-time 1 "$base/" -o "$TMP/first.html" 2>/dev/null;then ready=1;break;fi
    sleep 0.1
  done
  test "$ready" = 1 || { echo "FAIL $surface SSR start" >&2;cat "$TMP/$surface.log" >&2;exit 1; }
  for route in "${routes[@]}";do
    code="$(curl -sS --max-time 4 -o "$TMP/page.html" -w '%{http_code}' "$base$route")"
    [[ "$code" == 200 ]] || { echo "FAIL $surface $route HTTP $code" >&2;exit 1; }
    grep -iq '<h1' "$TMP/page.html" || { echo "FAIL $surface $route no heading" >&2;exit 1; }
    echo "OK $surface $route 200"
  done
  if [[ "$surface" == admin ]]; then
    grep -q "$marker" "$TMP/page.html" || { echo 'FAIL admin restricted shell not rendered' >&2;exit 1; }
  fi
  code="$(curl -sS --max-time 4 -o /dev/null -w '%{http_code}' "$base/route-that-must-not-exist")"
  [[ "$code" == 404 ]] || { echo "FAIL $surface unknown route must be 404, got $code" >&2;exit 1; }
  kill "$PID"
  set +e
  wait "$PID" >/dev/null 2>&1
  set -e
  PID=""
done
echo 'WEB_ADMIN_REAL_SSR_SMOKE_PASS'

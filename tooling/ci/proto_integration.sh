#!/usr/bin/env bash
# Prove a real TS Connect and a real Dart gRPC client reach the SAME Go h2c handler.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

for tool in go pnpm dart python3 curl;do command -v "$tool" >/dev/null || { echo "FATAL missing $tool" >&2; exit 1; };done
test -f apps/api/cmd/transport-fixture-test/main.go
test -f packages/shared-types/test/transport.test.ts
test -f apps/mobile/tool/transport_smoke.dart
TMP="$(mktemp -d)"
PID=""
cleanup(){
 status=$?
 trap - EXIT
 if [[ -n "$PID" ]];then
  kill "$PID" >/dev/null 2>&1 || :
  wait "$PID" >/dev/null 2>&1 || :
 fi
 if [[ "$status" -ne 0 && -f "$TMP/server.log" ]];then
  echo 'GO_SERVER_LOG_ON_FAILURE' >&2
  tail -n 65 "$TMP/server.log" >&2
 fi
 rm -rf "$TMP"
 exit "$status"
}
trap cleanup EXIT

echo 'BUILD_REAL_GO_TRANSPORT_FIXTURE'
(cd apps/api && GOTOOLCHAIN=local go build -o "$TMP/fixture-server" ./cmd/transport-fixture-test)
test -x "$TMP/fixture-server"
PORT="$(python3 - <<'PY'
import socket
with socket.socket() as s:
 s.bind(('127.0.0.1',0))
 print(s.getsockname()[1])
PY
)"
export CV_FIXTURE_URL="http://127.0.0.1:$PORT"
CV_FIXTURE_LISTEN_ADDR="127.0.0.1:$PORT" "$TMP/fixture-server" > "$TMP/server.log" 2>&1 &
PID=$!
ready=0
for i in $(seq 1 80);do
 if ! kill -0 "$PID" 2>/dev/null;then
  echo 'FATAL: fixture server exited early' >&2;exit 1
 fi
 if code="$(curl --max-time 1 -sS -o /dev/null -w '%{http_code}' "$CV_FIXTURE_URL/" 2>/dev/null)";then
  if [[ "$code" == '404' ]];then ready=1;break;fi
 fi
 sleep 0.1
done
test "$ready" = 1 || { echo 'FATAL: fixture did not become ready' >&2;exit 1; }
echo 'GO_H2C_TEST_ONLY_SERVER_STARTED'
echo 'RUN_TYPESCRIPT_CONNECT_REAL_CLIENT'
pnpm --dir packages/shared-types test:transport
kill -0 "$PID"
echo 'RUN_DART_GRPC_HTTP2_REAL_CLIENT'
(cd apps/mobile && CV_FIXTURE_URL="$CV_FIXTURE_URL" dart run tool/transport_smoke.dart) > "$TMP/dart.log" 2>&1 || { cat "$TMP/dart.log" >&2;exit 1; }
cat "$TMP/dart.log"
grep -Fxq 'DART_GRPC_REAL_TRANSPORT_PASS' "$TMP/dart.log" || { echo 'FATAL: Dart did not verify its RPC responses' >&2;exit 1; }
kill -0 "$PID"
echo 'GO_TS_DART_SAME_HANDLER_INTEGRATION_PASS'

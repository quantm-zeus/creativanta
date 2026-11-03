#!/usr/bin/env bash
# ==============================================================================
# Creativanta CI/CD - Go Backend Quality Gate
# Canonical Source: docs/06_quality_ops/ci_cd_pipeline.md (Lint & Unit stages)
# ADR-015: Single Go module at apps/api, net/http, ConnectRPC, pgx/v5, sqlc.
# Pinned Toolchain: Go 1.27.3
# Zero Greenwashing: Missing apps/api, unformatted code, vet errors, race
# detector violations or test failures IMMEDIATELY terminate with exit code 1.
# ==============================================================================
set -euo pipefail

if [ -z "${GOTMPDIR:-}" ] && [ -d "$HOME/tmp" ]; then
  export GOTMPDIR="$HOME/tmp"
fi
if [ -z "${TMPDIR:-}" ] && [ -d "$HOME/tmp" ]; then
  export TMPDIR="$HOME/tmp"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

if [ -z "${GOTMPDIR:-}" ] && [ -d "$HOME/tmp" ]; then
  export GOTMPDIR="$HOME/tmp"
fi
if [ -z "${TMPDIR:-}" ] && [ -d "$HOME/tmp" ]; then
  export TMPDIR="$HOME/tmp"
fi
if [ -d "$HOME/go/bin" ] && [[ ":$PATH:" != *":$HOME/go/bin:"* ]]; then
  export PATH="$HOME/go/bin:$PATH"
fi

cd "${REPO_ROOT}"

echo "=== Go Backend Quality Gate ==="

# 1. Zero Greenwashing: Artifact Existence Check
if [ ! -d "apps/api" ]; then
    echo "FATAL: 'apps/api' directory does not exist! Required application artifacts are missing." >&2
    exit 1
fi

if [ ! -f "apps/api/go.mod" ]; then
    echo "FATAL: 'apps/api/go.mod' not found! Go module must be initialized." >&2
    exit 1
fi

# 2. Toolchain check
if ! command -v go >/dev/null 2>&1; then
    echo "FATAL: 'go' binary not found in PATH." >&2
    exit 1
fi

GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
echo "Detected Go version: $GO_VERSION"
if [[ "${STRICT_TOOLCHAIN:-1}" == "1" && "$GO_VERSION" != "1.27.3"* ]]; then
    echo "FATAL: Pinned Go version violation. Required: 1.27.3, Got: $GO_VERSION" >&2
    exit 1
fi

cd apps/api

# 3. Format check (test -z "$(gofmt -l .)")
echo "Checking Go formatting (gofmt)..."
UNFORMATTED=$(gofmt -l .)
if [ -n "$UNFORMATTED" ]; then
    echo "FATAL: The following Go files are not formatted properly:" >&2
    echo "$UNFORMATTED" >&2
    echo "Run 'gofmt -w .' to resolve." >&2
    exit 1
fi
echo "gofmt check passed."

# 4. Dependency Verification
echo "Verifying Go module dependencies (go mod verify)..."
go mod verify

# 5. Static Analysis (go vet)
echo "Running Go static analysis (go vet ./...)..."
go vet ./...
echo "go vet check passed."

# 6. Vulnerability check (govulncheck if installed)
if ! command -v govulncheck >/dev/null 2>&1; then
    echo "FATAL: govulncheck missing; install pinned v1.9.0 before Go verification" >&2
    exit 1
fi
echo "Running pinned govulncheck ./..."
govulncheck ./...

# 7. Unit and Race Detection Tests
echo "Running unit tests with thread race detector (go test -race -count=1 ./...)..."
go test -race -v -count=1 ./...

echo "Verifying unimplemented worker/outbox/migrate fail-closed..."
bash "${SCRIPT_DIR}/check_entrypoints.sh"

echo "=== Go Backend Quality Gate: ALL CHECKS PASSED ==="

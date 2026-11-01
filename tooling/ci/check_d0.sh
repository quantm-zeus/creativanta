#!/usr/bin/env bash
# ==============================================================================
# Creativanta CI/CD - D0 Documentation Invariant Gate
# Canonical Source: docs/00_index/BUILD_EXECUTION_CONTRACT.md Gate D0
# Pass condition: Zero static contract/link/coverage violations.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

cd "${REPO_ROOT}"

echo "=== Running D0 Documentation Invariants Check ==="

if ! command -v python3 >/dev/null 2>&1; then
    echo "FATAL: python3 not found. Required for D0 gate." >&2
    exit 1
fi

# Run canonical check_docs.py
# Check if pglast is installed for full SQL grammar validation
SQL_FLAG=""
if python3 -c "import pglast" >/dev/null 2>&1; then
    echo "pglast detected: enabling PostgreSQL grammar audit (--sql)."
    SQL_FLAG="--sql"
else
    echo "pglast not installed in current environment; running core static contract checks."
fi

echo "Executing: python3 tooling/check_docs.py ${SQL_FLAG}"
python3 tooling/check_docs.py ${SQL_FLAG}

echo "=== D0 Documentation Invariant Gate: PASS ==="

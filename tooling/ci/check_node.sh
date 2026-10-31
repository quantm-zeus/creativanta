#!/usr/bin/env bash
# ==============================================================================
# Creativanta CI/CD - Web and Admin Frontend Quality Gate
# Canonical Source: docs/06_quality_ops/ci_cd_pipeline.md
# Pinned Toolchain: Node 24, pnpm 10.34.9
# Targets: apps/web, apps/admin
# Zero Greenwashing: Missing web/admin directories, missing lockfile,
# build errors, type errors, or test failures fail immediately.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

cd "${REPO_ROOT}"

echo "=== Web & Admin Frontend Quality Gate ==="

# 1. Zero Greenwashing: Workspace and Artifact Existence
for TARGET in apps/web apps/admin; do
    if [ ! -d "$TARGET" ]; then
        echo "FATAL: '$TARGET' directory does not exist! Required application artifacts are missing." >&2
        exit 1
    fi
    if [ ! -f "$TARGET/package.json" ]; then
        echo "FATAL: '$TARGET/package.json' not found! Workspace configuration missing." >&2
        exit 1
    fi
done

if [ ! -f "pnpm-lock.yaml" ]; then
    echo "FATAL: 'pnpm-lock.yaml' not found at repository root. Frozen lockfile is required." >&2
    exit 1
fi

# 2. Toolchain check
if ! command -v node >/dev/null 2>&1; then
    echo "FATAL: 'node' binary not found in PATH." >&2
    exit 1
fi

if ! command -v pnpm >/dev/null 2>&1; then
    echo "FATAL: 'pnpm' binary not found in PATH." >&2
    exit 1
fi

NODE_VER=$(node -v | sed 's/v//')
PNPM_VER=$(pnpm -v)
echo "Detected Node: $NODE_VER, pnpm: $PNPM_VER"

if [[ "${STRICT_TOOLCHAIN:-1}" == "1" ]]; then
    if [[ "$NODE_VER" != "24."* ]]; then
        echo "FATAL: Node version violation. Required major: 24, Got: $NODE_VER" >&2
        exit 1
    fi
    if [[ "$PNPM_VER" != "10.34.9" ]]; then
        echo "FATAL: pnpm version violation. Required: 10.34.9, Got: $PNPM_VER" >&2
        exit 1
    fi
fi

# 3. Frozen Lockfile Installation
echo "Installing dependencies with frozen lockfile..."
pnpm install --frozen-lockfile

# 4. Web Workspace: Check, Build, Test
echo "--- Testing apps/web ---"
if grep -q '"check"' apps/web/package.json; then
    echo "Running pnpm --dir apps/web check..."
    pnpm --dir apps/web check
fi

if grep -q '"lint"' apps/web/package.json; then
    echo "Running pnpm --dir apps/web lint..."
    pnpm --dir apps/web lint
fi

echo "Running pnpm --dir apps/web build..."
pnpm --dir apps/web build

echo "Running pnpm --dir apps/web test..."
pnpm --dir apps/web test

# 5. Admin Workspace: Check, Build, Test
echo "--- Testing apps/admin ---"
if grep -q '"check"' apps/admin/package.json; then
    echo "Running pnpm --dir apps/admin check..."
    pnpm --dir apps/admin check
fi

if grep -q '"lint"' apps/admin/package.json; then
    echo "Running pnpm --dir apps/admin lint..."
    pnpm --dir apps/admin lint
fi

echo "Running pnpm --dir apps/admin build..."
pnpm --dir apps/admin build

echo "Running pnpm --dir apps/admin test..."
pnpm --dir apps/admin test

echo "=== Web & Admin Frontend Quality Gate: ALL CHECKS PASSED ==="

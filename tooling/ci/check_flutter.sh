#!/usr/bin/env bash
# ==============================================================================
# Creativanta CI/CD - Flutter Mobile Quality Gate
# Canonical Source: docs/06_quality_ops/ci_cd_pipeline.md
# Pinned Toolchain: Flutter 3.47.9
# Target: apps/mobile
# Zero Greenwashing: Missing apps/mobile or pubspec.yaml, linter errors,
# or unit test failures IMMEDIATELY terminate with exit code 1.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

cd "${REPO_ROOT}"

echo "=== Flutter Mobile Quality Gate ==="

# 1. Zero Greenwashing: Artifact Existence Check
if [ ! -d "apps/mobile" ]; then
    echo "FATAL: 'apps/mobile' directory does not exist! Required mobile application artifacts are missing." >&2
    exit 1
fi

if [ ! -f "apps/mobile/pubspec.yaml" ]; then
    echo "FATAL: 'apps/mobile/pubspec.yaml' not found! Flutter project must be initialized." >&2
    exit 1
fi

# 2. Toolchain check
if ! command -v flutter >/dev/null 2>&1; then
    echo "FATAL: 'flutter' binary not found in PATH." >&2
    exit 1
fi

FLUTTER_VER=$(flutter --version | head -n 1 | awk '{print $2}')
echo "Detected Flutter version: $FLUTTER_VER"

if [[ "${STRICT_TOOLCHAIN:-1}" == "1" && "$FLUTTER_VER" != "3.47.9"* ]]; then
    echo "FATAL: Flutter version violation. Required: 3.47.9, Got: $FLUTTER_VER" >&2
    exit 1
fi

cd apps/mobile

# 3. Dependencies
echo "Fetching Flutter dependencies (flutter pub get)..."
flutter pub get

# 4. Static Analysis (flutter analyze)
echo "Running Flutter analysis (flutter analyze --fatal-infos --fatal-warnings)..."
flutter analyze --fatal-infos --fatal-warnings
echo "flutter analyze passed."

# 5. Unit Tests
echo "Running Flutter unit tests (flutter test)..."
flutter test

echo "=== Flutter Mobile Quality Gate: ALL CHECKS PASSED ==="

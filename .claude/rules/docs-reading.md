---
description: Docs reading order and navigation rules for Creativanta project
---
# Docs Reading Rules

## Reading order by task type

New feature implementation:
1. docs/00_index/BUILD_INDEX.md (find module + dependencies)
2. docs/02_features/<domain>/<feature>.md (behavior + AC)
3. docs/04_contracts/ (schema + API + events)
4. docs/06_quality_ops/security_threat_model.md (security constraints)

Bug investigation:
1. docs/00_index/OPEN_BLOCKERS.md (known issues first)
2. docs/02_features/<domain>/<feature>.md (expected behavior)
3. docs/04_contracts/database_schema.md (data model)
4. docs/05_system/sequence_diagrams.md (flow)

Screen implementation:
1. docs/02_features/<domain>/<feature>.md FIRST
2. docs/04_contracts/ (exact field names)
3. docs/03_screens/<platform>/<screen>.md LAST

## What NOT to do
- Do not open 03_screens/ files before reading 02_features/ equivalent
- Do not guess field names — always check 04_contracts/database_schema.md
- Do not treat 90_archive/ as active documentation

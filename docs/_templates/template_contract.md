---
template_for: 04_contracts/*.md
version: 1.0
---

# Contract: [Tên]

---
layer: contracts
canonical: true
source_file: [original impl_*/]
last_verified: YYYY-MM-DD
known_issues:
  - [ID from OPEN_BLOCKERS.md or "none"]
do_not_edit_without: Đọc OPEN_BLOCKERS.md trước
---

## Quick Navigation
| Section | Content |
|---|---|
| #section-1 | [description] |

## Overview
[2-3 câu: file này chứa gì, ai cần đọc nó]

## Invariants
> Rules bất biến — vi phạm là bug, không phải feature request.
1. **INV-001**: [rule]

## [Main Content Section]
[Field tables:
| Field | Type | Constraints | Description |
|---|---|---|---|
]

## Enum Values
### [enum_name]
| Value | Description | Valid transitions |
|---|---|---|

## Error Conditions
| Code | Condition | Expected behavior |
|---|---|---|

## Known Issues
- [BLOCKER-ID]: [description]

## Version Notes
[Thay đổi quan trọng]

---
Common mistakes:
1. Sửa contract mà không update OPEN_BLOCKERS.md
2. Không ghi enum values — AI sẽ tự bịa
3. Không ghi Error Conditions — inconsistent error handling

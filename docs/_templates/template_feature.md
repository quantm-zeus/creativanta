---
template_for: 02_features/**/*.md
version: 1.0
usage: cp _templates/template_feature.md 02_features/<domain>/<feature>.md
---

# Feature: [Tên đầy đủ] (M0X)

---
layer: features
module: M0X
canonical: true
domain: [platform|intelligence|content|production|publish|engagement|commerce|finance|automation]
status: DRAFT
last_updated: YYYY-MM-DD
---

## Purpose
[Tại sao feature tồn tại. User problem cụ thể. KHÔNG viết chung chung.]
[Ví dụ tốt: "M07 giải quyết pain point creator phải dùng 3-4 tool khác nhau để tạo 1 video."]

## Scope

### Covers
- [bullet list cụ thể]

### Does NOT cover (Non-goals for this module only)
- [bullet cụ thể — KHÔNG dùng global non-goals từ PRD §6]
- [Ví dụ tốt: "Không build bulk DM blast" thay vì "Không build social network"]

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| [user segment from 01_business/user_segments_and_modes.md] | [role] | [3-5 actions] |

## Business Rules

> INVARIANTS — bắt buộc implement đúng. Rút từ PRD §23.X AC. Viết dạng imperative.

1. **RULE-M0X-001**: [Statement. Ví dụ: "Mọi offer PHẢI map về product hoặc khai báo rõ là product-less"]
2. **RULE-M0X-002**: ...

## Main Flow

> Happy path. Reference API — không copy API spec vào đây.

1. [Step: User action] — calls `ServiceName/RpcName`
   see 04_contracts/api_endpoint_map.md#section
2. [Step: System response] — emits event `domain.entity.action`
   see 04_contracts/domain_event_catalog.md#section

## Alternate Flows

### [Tên — ví dụ: "Platform returns 429"]
- Trigger: [khi nào]
- Steps: [1-3 steps]
- Result: [outcome]
- Reference: 05_system/queue_retry_design.md#section (nếu liên quan đến retry)

## Edge Cases

> Tối thiểu 3. Phải handle tường minh — implementation team KHÔNG được tự đoán.

### EC-M0X-001: [Tên — ví dụ: "Provider timeout during generation"]
- Condition: [khi nào xảy ra]
- Expected behavior: [cụ thể phải làm gì]
- Reference: [link nếu cần]

### EC-M0X-002: ...
- Condition: [khi nào xảy ra]
- Expected behavior: [cụ thể phải làm gì]
- Reference: [link nếu cần]

### EC-M0X-003: ...
- Condition: [khi nào xảy ra]
- Expected behavior: [cụ thể phải làm gì]
- Reference: [link nếu cần]

## State Machine

> Chỉ điền nếu object trong PRD §24 list. Xóa section này nếu không applicable.

**Object**: [tên]
**DB enum**: `table.column` — see 04_contracts/database_schema.md#section

| From State | To State | Trigger | Condition |
|---|---|---|---|
| DRAFT | SUBMITTED | User clicks Submit | Must have ≥1 scene |
| SUBMITTED | APPROVED | Manager approves | — |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables: [names] | 04_contracts/database_schema.md | #section |
| API endpoints | 04_contracts/api_endpoint_map.md | #section |
| Domain events | 04_contracts/domain_event_catalog.md | #section |
| RBAC permissions | 04_contracts/rbac_permission_matrix.md | #section |

## Related Screens

| Platform | Screen File | Notes |
|---|---|---|
| Web | 03_screens/web/[screen].md | [1 dòng] |
| Mobile | 03_screens/mobile/[screen].md | [1 dòng] |

## Acceptance Criteria

> Tối thiểu 3. Given/When/Then format. Convert từ PRD §23.X AC bullets.

### AC-M0X-001: [Tên test]

    Given [precondition cụ thể]
    When [action cụ thể]
    Then [result có thể verify]
    And [assertion bổ sung]

### AC-M0X-002: [Tên test]

    Given [precondition cụ thể]
    When [action cụ thể]
    Then [result có thể verify]
    And [assertion bổ sung]

### AC-M0X-003: [Tên test]

    Given [precondition cụ thể]
    When [action cụ thể]
    Then [result có thể verify]
    And [assertion bổ sung]

## Open Questions / Blockers

> Reference 00_index/OPEN_BLOCKERS.md IDs. Ghi [NONE] nếu không có.

- [ ] [BLOCKER-ID]: [mô tả tại sao block]
- [ ] [NEEDS INPUT]: [câu hỏi chưa có câu trả lời]

---
Common mistakes:
1. Copy PRD business rules mà không rewrite thành imperative statement
2. Để trống edge cases — phải có ≥3 dù khó nghĩ
3. Copy API spec vào Main Flow — chỉ reference, không copy
4. Viết AC dạng "System should X" — phải Given/When/Then
5. Không update _STATUS.md sau khi tạo file
6. Viết non-goals chung chung như PRD §6 — phải module-specific

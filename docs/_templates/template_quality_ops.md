---
template_for: 06_quality_ops/*.md
version: 1.0
---

# Quality/Ops: [Tên]

---
layer: quality_ops
canonical: true
source_file: [original]
last_verified: YYYY-MM-DD
---

## Purpose
[1-2 câu: document này dùng để làm gì, ai dùng nó]

## Test Cases

### TC-001: [Tên]

    Given [precondition]
    When [action]
    Then [expected result]

## Benchmarks / SLA
| Metric | Target | Measurement |
|---|---|---|

## Security Constraints
[Constraints phải satisfied — không optional]

## Migration Steps
1. [Step] — Rollback: [how to undo]

## Rollback Plan
[Khi nào cần, steps to rollback]

## Monitoring Checklist
- [ ] [metric] đang được track
- [ ] Alert đã set

---
Common mistakes:
1. Test cases không có Given/When/Then
2. Không có Rollback Plan
3. Benchmark targets không có measurement method

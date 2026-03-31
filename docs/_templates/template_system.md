---
template_for: 05_system/*.md
version: 1.0
---

# System: [Tên Component]

---
layer: system
canonical: true
source_file: [original]
last_verified: YYYY-MM-DD
purpose: [1 câu]
---

## Overview
[ASCII diagram hoặc text flow tổng quát]

## Flow Steps
1. [Step name]
   - Actor: [service]
   - Action: [what happens]
   - Output: [what's produced]
   - Side effects: [DB writes, events emitted]

## Failure Modes
| Failure | Detection | Recovery |
|---|---|---|
| [provider timeout] | [circuit breaker] | [retry → fallback] |

## Retry / Idempotency Rules
[Max attempts, backoff, idempotency key]

## Service Dependencies
| Dependency | Type | Failure impact |
|---|---|---|

## Monitoring Points
- Metric: [name] | Alert: [threshold] | Dashboard: [link]

---
Common mistakes:
1. Không document failure modes
2. Không ghi idempotency rules
3. Diagram quá abstract — phải có service names
4. Không ghi monitoring points

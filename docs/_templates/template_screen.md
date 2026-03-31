---
template_for: 03_screens/**/*.md
version: 1.0
scoring: 7 criteria
usage: cp _templates/template_screen.md 03_screens/<platform>/<screen>.md
---

# Screen: [Platform] — [Tên màn hình]

---
layer: screens
platform: [web|mobile|admin|shared]
screen_id: [W01|M01|A01|S01]
module: M0X
canonical: true
score: 0/7
last_updated: YYYY-MM-DD
---

> Feature doc: 02_features/[domain]/[feature].md
> Route: /path/to/screen

---

## 1. Purpose & User Goal [Tiêu chí 1]

[Trả lời: Tại sao màn hình này tồn tại? User đến đây để làm gì?]
[Tốt: "User mở màn hình này để bulk confirm orders trong <2 phút"]
[Tệ: "Manage products"]

### User Story
> As a [user segment], I want to [action] so that [outcome].

### Entry Points
- [Vào từ đâu]

### Exit Points
- [Đi đến đâu]

---

## 2. Data Contract [Tiêu chí 2]

| UI Element | API Call | Key Fields | Cache TTL |
|---|---|---|---|
| [component] | ServiceName/RpcName | [field1, field2] | [30s] |

---

## 3. Actions Table [Tiêu chí 3]

| # | Action | Trigger | API Call | Result | Permission |
|---|---|---|---|---|---|
| 1 | [action] | [click] | Service/Rpc | [UI change + navigate] | [permission:key] |

---

## 4. Loading State [Tiêu chí 4]

### Initial Load

    ┌─ Skeleton ──────────────────────┐
    │ ░░░░░░░░░░ (header placeholder) │
    │ ████ ░░░░░░░░░░░░░░             │
    │ ████ ░░░░░░░░░░░░░░             │
    └─────────────────────────────────┘

### Partial Load
[Behavior khi một số widgets đã load, một số chưa]

---

## 5. Empty & Error States [Tiêu chí 5]

### Empty State: [Tên scenario]
- Condition: [khi nào]
- Message: "[exact text]"
- CTA: [button text → action]

### Error State: [Tên — ví dụ: Network timeout]
- Condition: [khi nào]
- Message: "[exact text]"
- CTA: [Retry / Refresh]

### Error State: [Tên — ví dụ: Insufficient permissions]
- Condition: [which roles see this]
- Message: "[exact text]"
- CTA: [...]

---

## 6. Navigation Map [Tiêu chí 6]

### Comes from
| Source screen/route | Trigger |
|---|---|
| [screen] | [action that leads here] |

### Goes to
| Destination | Trigger |
|---|---|
| [screen/route] | [action] |

### Deep link
/path?param=value — behavior: [...]

---

## 7. Stitch Design Prompt [Tiêu chí 7]

**Layout type**: [Full page | Modal | Drawer | Split view]
**Navigation**: [Sidebar + top bar | Bottom tab | Stack]
**Primary action**: [CTA position and visual weight]
**Content density**: [Dense table | Card grid | Single focus]
**Key components**: [shadcn-svelte / Flutter components]
**Visual feel**: [Professional | Data-heavy | Minimal]
**Color emphasis**: [Brand primary | Warning red | Neutral]
**Mobile adaptations**: [...]

---
Common mistakes:
1. Actions table thiếu Permission column
2. Loading State chỉ ghi "show spinner" — phải có skeleton ASCII
3. Empty State không có CTA
4. Navigation Map thiếu "comes from"
5. Stitch Prompt quá vague: "clean modern design" không đủ

# Screen: Web — Script Approval Review

> **Screen ID**: W22
> **Module**: M04 — Content Creation (Scripts)
> **Route**: `/scripts/[id]/review`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §13, A1 Schema (scripts, script_reviews, review_comments)

---

## 1. Purpose & Context

Script review mode — read-only script view with inline commenting, approval/rejection workflow, and change request tracking. Reviewers can add feedback per section and make a final decision.

### User Story
> As a manager reviewing team scripts, I want to read the full script, add inline feedback, and approve or request changes.

### Entry Points
- Script List: "✅ Approve" button on in-review scripts
- Script Editor: when status = in_review and user is reviewer
- Notification: "Script submitted for review"
- Direct URL: `/scripts/[id]/review`

### Exit Points
- Approve → script stays, status changes, navigate → `/scripts`
- Reject → script status → draft, notification to author, → `/scripts`
- "← Script" → back to script list

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Script   📋 Review: "5 tips nấu ăn"     [🟡 Under Review]       │
├──────────────────────────────────┬───────────────────────────────────┤
│ Script Content (65%, read-only)  │ Review Panel (35%)                │
│                                  │                                    │
│ ┌─ Script Metadata ──────────┐  │ ┌─ Review Summary ──────────────┐│
│ │ Author: Quân · Submitted 1d│  │ │ Reviewer: Admin               ││
│ │ Platform: 🎵 TikTok        │  │ │ Comments: 3                   ││
│ │ Words: 134 · Est: 52s      │  │ │ Status: Pending decision      ││
│ └────────────────────────────┘  │ └──────────────────────────────┘│
│                                  │                                    │
│ ┌─ Section: HOOK ──────────┐   │ ┌─ Comments ────────────────────┐│
│ │ "Bạn có đang mắc 5 sai   │   │ │ 🟡 Section: Hook             ││
│ │  lầm skincare mỗi sáng   │   │ │ Admin: "Hook hơi dài, nên   ││
│ │  không?"                   │   │ │  rút gọn 1-2 từ"            ││
│ │ 🟡 1 comment on this      │   │ │ [Reply]                      ││
│ │ 📝 [+ Add comment]         │   │ │                               ││
│ └────────────────────────────┘  │ │ 🟢 Section: Body             ││
│                                  │ │ Admin: "Content tốt, đầy đủ"││
│ ┌─ Section: BODY ──────────┐   │ │                               ││
│ │ "Tip 1: Không rửa mặt    │   │ │ 🔴 Section: CTA              ││
│ │  bằng nước nóng..."       │   │ │ Admin: "CTA cần mạnh hơn.   ││
│ │ 🟢 1 comment (positive)   │   │ │  Thêm urgency."             ││
│ │ 📝 [+ Add comment]         │   │ └──────────────────────────────┘│
│ └────────────────────────────┘  │                                  │
│                                  │ ┌─ AI Quality Check ───────────┐│
│ ┌─ Section: CTA ───────────┐   │ │ Grammar: 🟢 OK               ││
│ │ "Follow để xem thêm tips" │   │ │ Brand voice: 🟢 Match        ││
│ │ 🔴 1 comment (needs fix)  │   │ │ Length: 🟡 Hơi dài          ││
│ │ 📝 [+ Add comment]         │   │ │ Hook quality: 🟢 Strong     ││
│ └────────────────────────────┘  │ │ CTA clarity: 🟡 Can improve ││
│                                  │ └──────────────────────────────┘│
│                                  │                                  │
│ ┌─ Decision Bar ─────────────┐  │ ┌─ Decision ───────────────────┐│
│ │ [✅ Approve] [🔄 Yêu cầu  │  │ │ Overall note:                ││
│ │  chỉnh sửa] [❌ Reject]   │  │ │ [Script gần ok, chỉ cần    ]││
│ └────────────────────────────┘  │ │ [fix CTA                    ]││
│                                  │ └──────────────────────────────┘│
└──────────────────────────────────┴───────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
ScriptReviewPage
├── AppShell (shared)
├── PageHeader
│   ├── BackButton
│   ├── Title ("📋 Review: [script title]")
│   └── StatusBadge
├── SplitView
│   ├── ScriptContentPanel (65%, read-only)
│   │   ├── MetadataSection (author, date, platform, word count)
│   │   └── SectionList (read-only)
│   │       └── ReviewableSection[]
│   │           ├── SectionHeader + TimeRange
│   │           ├── ContentText (read-only)
│   │           ├── CommentIndicator (🟢/🟡/🔴 + count)
│   │           └── AddCommentButton
│   └── ReviewPanel (35%)
│       ├── ReviewSummary (reviewer, comment count, status)
│       ├── CommentList (grouped by section)
│       │   └── SectionComments[]
│       │       ├── SectionLabel + SeverityBadge
│       │       ├── CommentText
│       │       └── ReplyButton
│       ├── AIQualityCheckCard
│       │   └── CheckItem[] (grammar, brand voice, length, hook, CTA)
│       └── DecisionSection
│           ├── OverallNoteTextarea
│           └── DecisionButtons
│               ├── ApproveButton
│               ├── RequestChangesButton
│               └── RejectButton
```

---

## 4-5. Data & Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Add comment | "+ Add comment" on section | `ReviewService/AddComment(section_id, text, severity)` | Comment appears in panel | `script:approve` |
| 2 | Reply to comment | "Reply" on comment | `ReviewService/ReplyComment(comment_id, text)` | Reply added | `script:approve` or author |
| 3 | Approve | "✅ Approve" | `ScriptService/Approve(id, overall_note)` | Status → Approved, notification to author | `script:approve` |
| 4 | Request changes | "🔄 Yêu cầu chỉnh sửa" | `ScriptService/RequestChanges(id, note)` | Status → Draft, notification with comments | `script:approve` |
| 5 | Reject | "❌ Reject" → reason | `ScriptService/Reject(id, reason)` | Status → Rejected | `script:approve` |

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Split-view skeletons |
| LOADED | Review data received | Read-only script + comment panel |
| SUBMITTING | Decision button pressed | Button spinner + disabled |
| APPROVED | Decision = approve | Green banner: "✅ Đã duyệt" + read-only |
| CHANGES_REQUESTED | Decision = changes | Amber banner: "🔄 Đã yêu cầu chỉnh sửa" |
| REJECTED | Decision = reject | Red banner: "❌ Đã từ chối: {reason}" |
| ALREADY_DECIDED | Another reviewer decided | Toast: "Script đã được xử lý bởi {user}" + refresh |

---

## 7. Permission Matrix

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View review | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Add comments | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Reply to comments | ✅ | ✅ | ✅ | Author only | ❌ | ❌ |
| Approve/Reject | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

- **Self-review guard**: Author cannot approve their own script (button hidden)
- **Author view**: Author can read comments but not make decisions

---

## 8. Edge Cases

| Edge Case | Handling |
|---|---|
| Reviewer is also the author | Decision buttons hidden; can only read and reply |
| Script modified during review | Banner: "Script đã thay đổi kể từ khi gửi review. [Xem diff]" |
| Concurrent reviewers | First decision wins; second receives ALREADY_DECIDED state |
| Empty sections | Show "(Section trống)" with comment still available |
| Very long script (20+ sections) | Sections collapsed, expand on click |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — chế độ chỉ đọc" | Reconnect |
| API error (5xx) | Server failure | Error banner: "Không tải được review. [Thử lại]" | Retry |
| Decision conflict | Already decided | Toast: "Script đã được xử lý bởi {user}" | Auto-refresh |
| Comment failed | Save error | Inline: "Không gửi được. [Thử lại]" | Retry |
| Script not found | Deleted | Error page: "Script không tồn tại" | Navigate back |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| Script sections | `role="article"`, `aria-label="Section {name}, {n} comments"` |
| Comment indicators | Color + icon (🟢/🟡/🔴) + text count |
| Review panel | `role="complementary"`, `aria-label="Review panel"` |
| Decision buttons | `aria-label="Duyệt script '{title}'"` etc. |
| Comment thread | `role="list"`, `role="listitem"` per comment |
| AI quality checks | `aria-label="Kiểm tra {check}: {result}"` |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Split-view skeleton |
| Script content | 200-400ms | Script sections populate (left panel) |
| Comments | 300-500ms | Comment indicators + panel populate |
| AI quality check | 400-600ms | Check results animate in |
| Activity log | 500ms | Activity items slide in |

---

## 12. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (script content visible) |
| TTI | < 2.0s |
| Comment add | < 500ms |
| Decision response | < 1s |
| AI check render | < 300ms |

---

## 13. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `review.viewed` | Page load | `script_id`, `comment_count`, `reviewer` |
| `review.comment_added` | Add comment | `script_id`, `section_id`, `severity` |
| `review.comment_replied` | Reply | `script_id`, `comment_id` |
| `review.approved` | Approve | `script_id`, `time_in_review`, `comment_count` |
| `review.changes_requested` | Request changes | `script_id`, `comment_count` |
| `review.rejected` | Reject | `script_id`, `reason_length` |
| `review.ai_check_viewed` | AI quality card seen | `script_id`, `checks_summary` |

---

## 14. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/scripts/[id]/review/+page.svelte`
- **Server load**: `+page.server.ts` → fetch script + review data + AI checks
- **SSR**: Server renders script content; comments load client-side
- **Comments**: Linked to `section_id` for inline positioning
- **AI quality check**: Pre-computed on submission, stored in `script_reviews.ai_checks`
- **Real-time**: SSE for concurrent reviewer detection

---

## 15. Localization Notes

- Comment severity: "🟢 Tốt", "🟡 Góp ý", "🔴 Cần sửa"
- Decision: "Duyệt", "Yêu cầu chỉnh sửa", "Từ chối"
- Status: "Đang chờ quyết định"
- AI checks: "Ngữ pháp", "Đúng tone thương hiệu", "Độ dài", "Chất lượng hook", "CTA"
- Relative time: "Gửi 1 ngày trước"

---

## 16. Design Tokens

| Token | Usage |
|---|---|
| `--color-comment-positive` | 🟢 Positive comments |
| `--color-comment-suggestion` | 🟡 Suggestions |
| `--color-comment-fix` | 🔴 Needs fix |
| `--color-success` | Approve button |
| `--color-warning` | Request changes button |
| `--color-danger` | Reject button |
| `--color-surface-elevated` | Comment panel, AI check card |
| `--color-split-divider` | Panel separator line |

---

## 17. Related Screens

| Screen | Relationship |
|---|---|
| [W021] Script Editor | Source script |
| [W020] Script List | Parent list |
| [M019] Mobile Script List | Mobile equivalent (no split view) |
| [S007] Confirmations | Reject confirmation |

---

## 18. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A rewrite**: Expanded §6-20. Added 7 states (concurrent review), RBAC (self-review guard), 5 edge cases, 5 error scenarios, accessibility for split-view, 5-stage loading, 5 perf KPIs, 7 analytics, SvelteKit impl, review-specific localization, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

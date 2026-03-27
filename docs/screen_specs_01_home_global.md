# Screen Specs 01 — Home & Global Screens

> **Upstream**: Pack 01 §5/§9/§9A-9E, Product Freeze §35-37, A1 Schema, A3 API, A5 Design Tokens
> **Screens**: 8 web + 3 mobile priority screens

---

## 1. Home Dashboard

**Route**: `/`
**Purpose**: Daily decision engine — hiển thị hành động ưu tiên, cảnh báo rủi ro, và trạng thái tổng quan workspace. KHÔNG phải dashboard chart-first; phải action-card-first.

### Layout
```
┌─ Topbar (56px) ──────────────────────────────────────────────────────┐
│ [≡ Toggle] Logo    [Workspace ▾]     [🔍 Cmd+K]  [🔔 3]  [👤 Avatar]│
├─ Sidebar (260px) ─┬─ Main Content (scroll) ──────────────────────────┤
│  (Navigation)     │                                                  │
│                   │  ┌─ Welcome Banner / Greeting ──────────────────┐│
│                   │  │ "Chào buổi sáng, Quân!" · ☀️ Thứ 5, 27/3   ││
│                   │  │ [📋 Xem Briefing hôm nay]                   ││
│                   │  └──────────────────────────────────────────────┘│
│                   │                                                  │
│                   │  ┌─ Quick Stats Bar (4 mini cards) ─────────────┐│
│                   │  │ 📈 Doanh thu  │ 💰 Lợi nhuận │ 📤 Đã đăng  ││
│                   │  │ 12.5M ▲18%   │ 3.2M ▲12%    │ 14 bài      ││
│                   │  │ {source badge}│ {confidence} │ {7 ngày}     ││
│                   │  │──────────────│──────────────│──────────────││
│                   │  │ 💬 Chưa đọc   │ ⏳ Chờ duyệt │ ⚠️ Cảnh báo ││
│                   │  │ 23 tin nhắn  │ 5 items      │ 2 issues     ││
│                   │  └──────────────────────────────────────────────┘│
│                   │                                                  │
│                   │  ┌─ Action Cards Grid (2 columns) ─────────────┐│
│                   │  │ [Card: Top Opportunities]                    ││
│                   │  │ [Card: Top Risks]                            ││
│                   │  │ [Card: Profitable Actions]                   ││
│                   │  │ [Card: Pending Approvals]                    ││
│                   │  │ [Card: Urgent Threads]                       ││
│                   │  │ [Card: System Health]                        ││
│                   │  └──────────────────────────────────────────────┘│
│                   │                                                  │
│                   │  ┌─ Setup Checklist (if incomplete) ────────────┐│
│                   │  │ ✅ Tạo workspace · ✅ Kết nối TikTok         ││
│                   │  │ ⬜ Tạo sản phẩm đầu tiên · ⬜ Đăng bài đầu  ││
│                   │  │ [Tiếp tục thiết lập →]                       ││
│                   │  └──────────────────────────────────────────────┘│
└───────────────────┴──────────────────────────────────────────────────┘
```

### Components Detail

#### 1.1 Welcome Banner
- **Data**: `user.display_name`, current date/time (locale-aware)
- **CTA Primary**: "Xem Briefing hôm nay" → navigates to `/brief`
- **Behavior**: Only shows if Morning Brief has new data today
- **Operator Mode Variation**:
  - Creator: "✨ 3 xu hướng mới cho niche của bạn"
  - Seller: "🛍️ 12 đơn mới từ đêm qua"
  - Live: "🔴 Phiên live hôm nay lúc 19:00"

#### 1.2 Quick Stats Bar
- **Data Source**: `ProfitService/GetSummary`, cache `profit:summary:{workspace_id}` (TTL 15m)
- **Fields**:
  | Stat | API | Format | Click → |
  |---|---|---|---|
  | Doanh thu | `profit_snapshots.gross_revenue` | `{amount}đ ▲{change}%` | `/profit/revenue` |
  | Lợi nhuận | `profit_snapshots.net_profit` | `{amount}đ ▲{change}%` | `/profit` |
  | Đã đăng | `publish_items count` (7 days) | `{count} bài` | `/publish/posts` |
  | Chưa đọc | `threads.unread_count` | `{count} tin nhắn` | `/inbox` |
  | Chờ duyệt | `approval_requests.pending_count` | `{count} items` | `/approvals` |
  | Cảnh báo | `diagnostics_records.open_count` | `{count} issues` | `/settings/diagnostics` |
- **Trust Display**: Each stat shows source_class badge (official/imported/estimated)
- **Confidence**: Color-coded border (green=high, amber=medium, red=low)

#### 1.3 Action Cards (6 Card Families)
Each card follows the canonical structure:

```
┌─ Card ────────────────────────────────────────┐
│ [Icon] Card Title                    [⋮ Menu] │
│ Subtitle / Why this matters                    │
│                                                │
│ ┌─ Item Row ─────────────────────────────────┐ │
│ │ [Avatar] Item Title    [State]  [→ Action] │ │
│ └────────────────────────────────────────────┘ │
│ ┌─ Item Row ─────────────────────────────────┐ │
│ │ [Avatar] Item Title    [State]  [→ Action] │ │
│ └────────────────────────────────────────────┘ │
│                                                │
│ [Xem tất cả (12) →]                           │
└────────────────────────────────────────────────┘
```

**Card A: Top Opportunities**
- Data: `OpportunityService/List` (status=actionable, limit=3, sort=score DESC)
- Items: Opportunity title + score badge + source
- CTA per item: "Chuyển thành ý tưởng" → `OpportunityService/Convert` → redirect `/ideas/[new_id]`
- Footer: "Xem tất cả ({count}) →" → `/opportunities`
- Mode priority: Creator=1st, Agency=1st

**Card B: Top Risks**
- Data: `diagnostics_records` (severity=warning|error, status=open, limit=3)
- Items: Risk title + severity badge + affected scope
- CTA per item: "Xem & sửa" → `/settings/diagnostics#[id]`
- Includes: Connector health warnings, SLA breaches, stale data alerts
- Mode priority: All modes show this 2nd

**Card C: Profitable Actions**
- Data: AI-generated suggestions from `CopilotService/Query` (mode=analytics, scope=home)
- Items: Suggestion text + expected impact + effort level
- CTA per item: varies (e.g., "Tạo offer →", "Publish video →")
- Mode priority: Seller=1st, Affiliate=2nd

**Card D: Pending Approvals**
- Data: `ApprovalService/List` (status=pending, limit=3)
- Items: Object title + type badge + requester avatar + waiting_since
- CTA per item: "Duyệt" → slide-out review panel (inline approve/reject)
- Footer: "Xem tất cả ({count}) →" → `/approvals`
- Inline actions: ✅ Approve, ❌ Reject (with reason modal), 👁️ Preview
- Mode priority: Agency/MCN=1st, Manager+=visible

**Card E: Urgent Threads**
- Data: `ThreadService/List` (priority=urgent|high, status!=resolved, limit=3)
- Items: Entity name + platform icon + last message preview + time ago
- CTA per item: "Trả lời" → `/inbox/[id]`
- Shows AI-suggested reply preview (first 50 chars)
- Mode priority: Creator=2nd, Seller=2nd

**Card F: System Health**
- Data: `ConnectorService/List` + `diagnostics_records`
- Items: Platform health row (icon + name + status indicator)
- States: 🟢 Healthy, 🟡 Degraded, 🔴 Error, ⚫ Disconnected
- CTA for degraded/error: "Sửa lỗi →" → Repair Wizard
- Mode priority: All modes show last

#### 1.4 Setup Checklist (Conditional)
- **Show condition**: New workspace OR onboarding incomplete
- **Data**: `workspaces.onboarding_state` JSONB
- **Steps** (varies by mode, see Pack 01 §9A):
  - Creator: 7 steps (connect → niche → idea → script → asset → publish → review)
  - Seller: 6 steps (connect → import → offer → content → order → profit)
- **Each step**: Checkbox + title + CTA if incomplete
- **Skip**: User can click "Bỏ qua" → mark skipped but show banner reminder
- **Dismiss**: After all complete → auto-hide with confetti animation 🎉

### Actions Table
| Action | UI Trigger | API Call | Response | Navigation |
|---|---|---|---|---|
| View Brief | Click banner CTA | — | — | → `/brief` |
| View stat detail | Click any stat card | — | — | → respective route |
| Convert opportunity | Click "Chuyển thành ý tưởng" | `OpportunityService/Convert` | Toast "Đã tạo ý tưởng" | → `/ideas/[new_id]` |
| Approve item | Click ✅ on approval card | `ApprovalService/Approve` | Toast "Đã duyệt" + card removed | Stay (card animates out) |
| Reply to thread | Click "Trả lời" | — | — | → `/inbox/[id]` |
| Repair connector | Click "Sửa lỗi" | — | — | → Repair Wizard modal |
| Continue setup | Click checklist CTA | — | — | → relevant setup step |
| Switch mode | Click mode selector | `WorkspaceService/Update` | Cards reorder | Stay (animated reorder) |
| Dismiss checklist | Click "Bỏ qua" | `UserService/UpdatePreferences` | Checklist fades | Stay |

### States
- **Loading**: Skeleton grid — 6 card skeletons (2x3 grid) + stats bar skeleton + banner skeleton
- **Empty (new user)**: No cards → Full-screen onboarding wizard overlay with mode selection
- **Error**: Banner "Không tải được dữ liệu. [Thử lại]" + cached data if available
- **Offline (mobile)**: Show cached data with "Đang offline" banner
- **Degraded**: Some cards show "Dữ liệu cũ" badge with last_synced time

### Operator Mode Card Order
| Mode | Card Order (left→right, top→bottom) |
|---|---|
| Creator | Opportunities → Risks → Urgent Threads → Approvals → Profitable Actions → Health |
| Seller | Profitable Actions → Risks → Urgent Threads → Opportunities → Approvals → Health |
| Affiliate | Profitable Actions → Opportunities → Risks → Urgent Threads → Approvals → Health |
| Live | Risks → Urgent Threads → Profitable Actions → Approvals → Opportunities → Health |
| Agency/MCN | Approvals → Risks → Opportunities → Urgent Threads → Profitable Actions → Health |
| Brand Collab | Approvals → Opportunities → Risks → Profitable Actions → Urgent Threads → Health |

### Responsive Behavior
- **Desktop (>1024px)**: 2-column card grid, sidebar expanded
- **Tablet (768-1024px)**: 2-column cards, sidebar collapsed (icons only)
- **Mobile (<768px)**: 1-column cards, sidebar hidden, bottom nav visible

---

## 2. Morning Brief

**Route**: `/daily-brief`
**Purpose**: AI-generated daily summary — highlights quan trọng, tóm tắt tài chính, suggested actions. Dạng newsletter format, dễ scan nhanh trong 2-3 phút.

### Layout
```
┌─ App Shell ────────────────────────────────────────────────────┐
│ ← Quay lại    ☀️ Briefing Thứ 5, 27/3/2026    [📧 Gửi email] │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  ┌─ Section: Tóm tắt ──────────────────────────────────────┐  │
│  │ "Hôm qua bạn có 12 đơn mới (+30%), 3 video đạt >10K    │  │
│  │  views. Lợi nhuận ước tính 2.1M VND."                   │  │
│  │  {confidence badge} {source badge}                       │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌─ Section: 💰 Tài chính ─────────────────────────────────┐  │
│  │ Doanh thu hôm qua: 5.2M VND (↑18%)                     │  │
│  │ Chi phí: 1.8M VND                                       │  │
│  │ Lợi nhuận ròng: 3.4M VND (margin 65%)                  │  │
│  │ ⚠️ 2 đơn hoàn tiền chờ xử lý                            │  │
│  │ [Xem chi tiết P&L →]                                     │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌─ Section: 🔥 Xu hướng nổi bật ──────────────────────────┐  │
│  │ 1. "AI cooking assistant" — TikTok +340% (7d)           │  │
│  │    [Tạo ý tưởng từ xu hướng này →]                      │  │
│  │ 2. "Minimalist skincare routine" — IG +180% (3d)        │  │
│  │    [Xem chi tiết →]                                     │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌─ Section: 📊 Nội dung hiệu quả nhất ────────────────────┐  │
│  │ ┌─────────┐ "5 tips nấu ăn nhanh"                       │  │
│  │ │Thumbnail│ 👁 24.3K views · ❤ 1.2K · 💬 89             │  │
│  │ │         │ ⭐ Engagement: 8.2% (trên trung bình)       │  │
│  │ └─────────┘ [📊 Xem analytics] [🔄 Tạo phiên bản mới]  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌─ Section: ✅ Hành động đề xuất ──────────────────────────┐  │
│  │ 1. 📝 Duyệt 3 script đang chờ                [Duyệt →] │  │
│  │ 2. 💬 Trả lời 5 thread khẩn cấp              [Inbox →]  │  │
│  │ 3. 📤 Đăng 2 bài đã lên lịch hôm nay    [Xem queue →]  │  │
│  │ 4. 🔗 2 affiliate link hết hạn tuần này   [Gia hạn →]   │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌─ Section: ⚠️ Cần chú ý ────────────────────────────────┐  │
│  │ • Shopee connector chậm (sync cách 2h) [Kiểm tra →]     │  │
│  │ • AI credits còn 120/500 (24%) [Nạp thêm →]             │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### Data Sources
| Section | API / Data | Cache |
|---|---|---|
| Summary | `CopilotService/Query(mode=analytics, scope=brief)` | Generated at 6:30 AM cron |
| Finance | `ProfitService/GetSummary(period=yesterday)` | `profit:summary:{wid}` |
| Trends | `TrendService/List(sort=growth, limit=3)` | `trend:hot:{wid}` |
| Top Content | `ClickHouse: content_performance (24h, sort=views)` | — |
| Actions | Aggregation: approvals + threads + publish queue | Multiple caches |
| Warnings | `diagnostics_records` + `ai_credit_transactions` | — |

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Send brief email | Click "Gửi email" | `NotificationService/SendBrief` | Toast "Đã gửi" |
| Create idea from trend | Click CTA | `IdeaService/Create(from_trend_id)` | → `/ideas/[id]` |
| View trend detail | Click "Xem chi tiết" | — | → `/trends/[id]` |
| Approve scripts | Click "Duyệt" | — | → `/scripts?filter=pending_approval` |
| Go to inbox | Click "Inbox" | — | → `/inbox?filter=urgent` |
| Top up credits | Click "Nạp thêm" | — | → `/settings/credits` |

### States
- **Loading**: Skeleton sections (summary shimmer, 3 card skeletons)
- **Empty**: First day → "Chưa có đủ dữ liệu. Briefing sẽ có từ ngày mai!"
- **Error**: Brief generation failed → "Không tạo được briefing. [Thử lại]"

### Mobile Adaptation
- Scrollable single column, sections as collapsible cards
- Swipe between sections horizontally (carousel)
- Push notification at 6:30 AM links to this screen

---

## 3. Onboarding Wizard

**Route**: `/onboarding`
**Purpose**: 5-7 step guided setup flow. Mode-aware — steps change based on operator mode selection. Target: time-to-first-value ≤ 15-25 minutes.

### Layout
```
┌─ Full Screen (no sidebar) ─────────────────────────────────────┐
│  [Logo]                              Step 2 of 7  [Bỏ qua ×]  │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│     ● ── ● ── ○ ── ○ ── ○ ── ○ ── ○                          │
│     1    2    3    4    5    6    7                              │
│                                                                │
│  ┌─ Step Content (centered, max 640px) ───────────────────┐    │
│  │                                                        │    │
│  │  🔗 Kết nối tài khoản mạng xã hội                     │    │
│  │                                                        │    │
│  │  Kết nối để Creativanta tự động đồng bộ                │    │
│  │  nội dung, bình luận và dữ liệu đơn hàng.             │    │
│  │                                                        │    │
│  │  ┌──────────────────────────────────────────┐          │    │
│  │  │ 🎵 TikTok           [✅ Đã kết nối]      │          │    │
│  │  │ 🛒 TikTok Shop      [Kết nối →]          │          │    │
│  │  │ 📸 Instagram         [Kết nối →]          │          │    │
│  │  │ ▶️ YouTube            [Kết nối →]          │          │    │
│  │  │ 🛍 Shopee            [Kết nối →]          │          │    │
│  │  │ 📘 Facebook          [Kết nối →]          │          │    │
│  │  │ 🛒 Lazada            [Kết nối →]          │          │    │
│  │  └──────────────────────────────────────────┘          │    │
│  │                                                        │    │
│  │  💡 Tip: Kết nối ít nhất 1 tài khoản để bắt đầu.     │    │
│  │  Bạn có thể thêm sau trong Cài đặt.                   │    │
│  │                                                        │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                │
│  [← Quay lại]                              [Tiếp tục →]       │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### Steps by Mode

**Creator Mode (7 steps)**:
| Step | Title | Component | Action |
|---|---|---|---|
| 1 | Chọn vai trò | ModeSelector (6 cards) | Select mode → persisted |
| 2 | Kết nối tài khoản | ConnectorList | OAuth → `ConnectorService/Connect` |
| 3 | Chọn lĩnh vực & audience | NicheSelector + AudienceInput | Save to workspace settings |
| 4 | Khám phá xu hướng | TrendPreview (3 trending items) | Save idea → `IdeaService/Create` |
| 5 | Tạo script đầu tiên | ScriptQuickCreate | AI generate → `ScriptService/Create` |
| 6 | Tạo hoặc upload asset | AssetUploader / AIGenerate | Upload or `AssetService/Generate` |
| 7 | Đăng hoặc export nội dung | PublishQuickAction | `PublishService/Execute` or export |

**Seller Mode (6 steps)**:
| Step | Title | Component | Action |
|---|---|---|---|
| 1 | Chọn vai trò | ModeSelector | Select mode |
| 2 | Kết nối e-commerce | ConnectorList (commerce focus) | OAuth |
| 3 | Import sản phẩm | ProductImporter / CSVUpload | `ProductService/Create` or CSV import |
| 4 | Tạo offer đầu tiên | OfferQuickCreate | `OfferService/Create` |
| 5 | Tạo nội dung cho offer | ContentQuickFlow (idea→script) | `ScriptService/Create` |
| 6 | Xem doanh thu & lợi nhuận | ProfitPreview | Navigate to `/profit` |

### Step Component Behavior
- **Progress bar**: Filled dots for completed, current = active, future = empty
- **Skip**: Each step can be skipped (except Step 1), skipped steps tracked
- **Back**: Click "← Quay lại" goes to previous step
- **Persistence**: Progress saved to `workspaces.onboarding_state` JSONB
- **Resume**: Returning user continues where they left off
- **Completion**: Last step → confetti 🎉 → redirect to Home with setup checklist hidden

### States
- **Loading**: Step content skeleton
- **OAuth in progress**: "Đang kết nối..." spinner + external OAuth popup
- **OAuth success**: ✅ checkmark animation + "Đã kết nối" badge
- **OAuth error**: "Kết nối thất bại. [Thử lại]" with error detail
- **All steps skipped**: Redirect to Home with full setup checklist visible

---

## 4. Setup Checklist

**Route**: `/setup`
**Purpose**: Persistent checklist showing remaining setup steps. Accessible from Home and Settings.

### Layout
```
┌─ App Shell ────────────────────────────────────────────────┐
│ ← Trang chủ    Thiết lập Workspace                         │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  Tiến trình: ████████░░░░ 5/8 hoàn thành (62%)            │
│                                                            │
│  ┌─ Step Card ─────────────────────────────────────────┐   │
│  │ ✅ 1. Tạo workspace                    Hoàn thành   │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─ Step Card ─────────────────────────────────────────┐   │
│  │ ✅ 2. Kết nối TikTok                   Hoàn thành   │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─ Step Card (active) ───────────────────────────────┐   │
│  │ ⬜ 3. Tạo sản phẩm đầu tiên                        │   │
│  │    Import từ TikTok Shop hoặc tạo thủ công          │   │
│  │    [Import từ TikTok Shop →] [Tạo thủ công →]       │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─ Step Card ─────────────────────────────────────────┐   │
│  │ ⬜ 4. Tạo offer đầu tiên                            │   │
│  │    Bước này mở khóa sau bước 3                       │   │
│  └─────────────────────────────────────────────────────┘   │
│  ... more steps ...                                        │
│                                                            │
│  [Bỏ qua tất cả bước còn lại]                             │
└────────────────────────────────────────────────────────────┘
```

### Data
- Source: `workspaces.onboarding_state` JSONB
- API: `WorkspaceService/Get` → extract onboarding_state
- Mutation: `WorkspaceService/Update(onboarding_state)`

### Behavior
- Steps with dependencies show "Bước này mở khóa sau bước {n}" if prerequisite incomplete
- Completed steps are collapsed, showing only title + ✅
- Current step is expanded with description + CTA buttons
- Click step CTA → navigates to relevant creation screen
- On returning with object created → auto-mark step complete + check animation

---

## 5. Notification Center

**Route**: `/notifications`
**Purpose**: Centralized notification list with filters. Web: dropdown panel from bell icon + full page. Mobile: dedicated tab.

### Layout (Full Page)
```
┌─ App Shell ────────────────────────────────────────────────┐
│ Thông báo                    [Đánh dấu đã đọc tất cả]     │
├────────────────────────────────────────────────────────────┤
│ Filters: [Tất cả ▾] [Phê duyệt ▾] [Cảnh báo ▾] [Thương mại ▾] │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  Hôm nay                                                   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 🔵 [Avatar] Script "5 tips nấu ăn" cần duyệt       │   │
│  │    Trung đã gửi · 2 giờ trước                       │   │
│  │    [Duyệt ngay →]                                   │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ ⚪ ✅ Đã đăng thành công lên TikTok                  │   │
│  │    "Cách chọn skincare phù hợp" · 5 giờ trước       │   │
│  │    [Xem bài đăng →]                                  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                            │
│  Hôm qua                                                   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ ⚪ ⚠️ Shopee connector bị gián đoạn                 │   │
│  │    Đồng bộ đơn hàng bị ảnh hưởng · 1 ngày trước    │   │
│  │    [Kiểm tra kết nối →]                              │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                            │
│  [Tải thêm ↓]                                              │
└────────────────────────────────────────────────────────────┘
```

### Data
- Source: `notifications` table
- API: `NotificationService/List(user_id, filters, cursor_pagination)`
- Cache: `thread:unread:{workspace_id}` for count badge
- Real-time: WebSocket push for new notifications

### Notification Item Structure
| Field | Source | Display |
|---|---|---|
| Icon | `notification.channel` + type | Type-specific icon with color |
| Title | `notification.title` | Bold text |
| Body | `notification.body` | Secondary text |
| Time | `notification.created_at` | Relative time ("2 giờ trước") |
| Read state | `notification.read_at` | 🔵 dot if unread |
| Deep link | `notification.deep_link` | Click → navigate |
| Action buttons | `notification.action_buttons` | CTA buttons |

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Mark read | Click notification | `PATCH notification.read_at` | Blue dot removed |
| Mark all read | Click "Đánh dấu đã đọc tất cả" | `PATCH notifications (bulk)` | All dots removed |
| Navigate | Click notification or CTA | — | → deep_link route |
| Filter | Select filter chip | Refetch with filter | List updates |
| Load more | Scroll to bottom / click | Next cursor page | Append items |
| Dismiss | Swipe left (mobile) | `PATCH notification.dismissed_at` | Item slides out |

### States
- **Loading**: 5 notification item skeletons
- **Empty**: "Không có thông báo nào 🎉 Mọi thứ ok!"
- **Error**: "Không tải được. [Thử lại]"

---

## 6. Global Search / Command Hub

**Route**: Overlay (Cmd+K / Ctrl+K)
**Purpose**: Universal search across all objects + quick actions + navigation shortcuts.

### Layout
```
┌─ Overlay (centered, 640px wide) ─────────────────────────────┐
│ 🔍 [Search everything...                              ] [×] │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│ Quick Actions                                                │
│ ┌────────────────────────────────────────────────────────┐   │
│ │ ⚡ Tạo ý tưởng mới          │ ⚡ Tạo script mới        │   │
│ │ ⚡ Tạo sản phẩm mới         │ ⚡ Đăng bài nhanh         │   │
│ └────────────────────────────────────────────────────────┘   │
│                                                              │
│ Recent                                                       │
│ 📝 Script: "5 tips nấu ăn nhanh"          2 giờ trước       │
│ 💬 Thread: Nguyễn Văn A · TikTok          5 giờ trước       │
│ 🛍️ Product: Serum Vitamin C               1 ngày trước       │
│                                                              │
│ ─── When typing: ─────────────────────────────────────────   │
│                                                              │
│ 📝 Scripts (3)                                               │
│   "5 tips nấu ăn nhanh"     [Draft]     [→ Mở]              │
│   "Review serum mới"        [Approved]  [→ Mở]              │
│   "Unboxing camera Sony"    [Draft]     [→ Mở]              │
│                                                              │
│ 🛍️ Products (2)                                              │
│   "Serum Vitamin C"         [Active]    [→ Mở]              │
│   "Kem chống nắng SPF50"   [Draft]     [→ Mở]              │
│                                                              │
│ ⚡ Actions                                                   │
│   "Tạo script mới"                      [Enter ↵]           │
│   "Đi tới cài đặt"                      [Enter ↵]           │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Data
- Search backend: Meilisearch (all indexes: scripts, products, ideas, trends, threads, entities, offers, orders, workflows)
- Quick actions: Hardcoded list filtered by RBAC permissions
- Recent: `localStorage` (last 10 opened objects)

### Behavior
- **Open**: `Cmd+K` (web) / search icon tap (mobile) / "?" key
- **Auto-focus**: Input focused immediately
- **As-you-type**: Debounce 150ms → Meilisearch multi-index search
- **Results**: Grouped by type, max 3 per type, "Xem thêm" expands
- **Navigation**: Arrow keys to select, Enter to open, Esc to close
- **Quick actions**: Keyboard shortcut hints shown (e.g., `Cmd+Shift+I` for new idea)
- **Performance**: Suggestion ≤ 200ms, full result ≤ 500ms

### Mobile Adaptation
- Full-screen overlay with large search input
- Recent searches section
- Voice search button (optional)
- Results in scrollable list with type section headers

---

## 7. User Settings

**Route**: `/settings/profile`
**Purpose**: Personal profile, preferences, locale, theme, security.

### Layout
```
┌─ App Shell ────────────────────────────────────────────────┐
│ Cài đặt > Hồ sơ cá nhân                                   │
├─ Settings Sidebar ─┬───────────────────────────────────────┤
│ 👤 Hồ sơ ← active │                                       │
│ 🔔 Thông báo       │  ┌─ Avatar Section ────────────────┐  │
│ 🌐 Ngôn ngữ        │  │ [Avatar] Nguyễn Quân           │  │
│ 🎨 Giao diện       │  │ [📷 Đổi ảnh]                   │  │
│ 🔒 Bảo mật         │  └────────────────────────────────┘  │
│                     │                                       │
│                     │  ┌─ Form ─────────────────────────┐  │
│                     │  │ Tên hiển thị: [Nguyễn Quân  ]  │  │
│                     │  │ Email: [quan@email.com      ]  │  │
│                     │  │ Timezone: [Asia/Ho_Chi_Minh ▾]  │  │
│                     │  │ Ngôn ngữ: [Tiếng Việt ▾]       │  │
│                     │  └────────────────────────────────┘  │
│                     │                                       │
│                     │  [Lưu thay đổi]                      │
└─────────────────────┴───────────────────────────────────────┘
```

### Settings Sub-pages
| Sub-page | Route | Key Fields |
|---|---|---|
| Profile | `/settings/profile` | Avatar, display_name, email, timezone, locale |
| Notifications | `/settings/notifications` | Per-channel toggles (email, push, in-app), per-type toggles, quiet hours |
| Language | `/settings/language` | UI language (vi/en), number format, date format, currency format |
| Appearance | `/settings/appearance` | Theme (light/dark/auto), sidebar density, font size |
| Security | `/settings/security` | Password change (→ Clerk), active sessions list, 2FA status |

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Update profile | Click "Lưu" | `UserService/UpdatePreferences` | Toast "Đã lưu" |
| Upload avatar | Click "Đổi ảnh" | Upload to R2 → update user | Avatar updates |
| Change theme | Toggle dark/light | `localStorage` + `UserService/UpdatePreferences` | Immediate theme switch |
| Toggle notification | Click toggle | `UserService/UpdatePreferences` | Saved to `notification_preferences` JSONB |

---

## 8. Workspace Settings

**Route**: `/settings/workspace`
**Purpose**: Team management, billing, subscription tier, danger zone. Owner/Admin only.

### Layout
```
┌─ App Shell ────────────────────────────────────────────────┐
│ Cài đặt > Workspace                                        │
├─ Settings Sidebar ─┬───────────────────────────────────────┤
│ 🏢 Tổng quan       │                                       │
│ 👥 Thành viên      │  ┌─ Workspace Info ────────────────┐  │
│ 💳 Thanh toán      │  │ Tên: [Creativanta Studio    ]   │  │
│ 🔗 Kết nối         │  │ Slug: creativanta-studio        │  │
│ ⚙️ Nâng cao        │  │ Mode: [Creator ▾]               │  │
│ ⚠️ Danger Zone     │  │ Gói: [Pro] · Hết hạn 15/04     │  │
│                     │  │ ID: ws_abc123...                │  │
│                     │  └────────────────────────────────┘  │
│                     │                                       │
│                     │  [Lưu thay đổi]                      │
└─────────────────────┴───────────────────────────────────────┘
```

### Sub-pages

**8a. Members (`/settings/workspace/members`)**
```
┌─────────────────────────────────────────────────────────────┐
│ Thành viên (5/10)               [+ Mời thành viên]          │
├─────────────────────────────────────────────────────────────┤
│ [Avatar] Nguyễn Quân      Owner     quan@email.com   [⋮]   │
│ [Avatar] Trần Minh        Admin     minh@email.com   [⋮]   │
│ [Avatar] Lê Hoa           Editor    hoa@email.com    [⋮]   │
│ [Avatar] Nguyễn Bình      Viewer    binh@email.com   [⋮]   │
│                                                              │
│ Pending Invitations:                                         │
│ [Avatar] an@email.com     Contributor  Sent 2d ago  [Hủy]  │
└─────────────────────────────────────────────────────────────┘
```

- **Invite**: Click "Mời" → Modal: email + role selector → `WorkspaceService/InviteMember`
- **Change role**: Click ⋮ → "Đổi vai trò" → Role dropdown → `WorkspaceService/UpdateRole`
- **Remove**: Click ⋮ → "Xóa" → Confirm modal → `WorkspaceService/RemoveMember`
- **RBAC**: Only Admin+ can invite. Only Owner can change Admin roles.

**8b. Danger Zone (`/settings/workspace/danger`)**
- **Transfer ownership**: Owner only, requires OTP
- **Freeze workspace**: Emergency action, requires Owner OTP
- **Delete workspace**: Owner only, requires type workspace name + OTP
- All destructive actions show red warning banner + confirmation modal

### Actions
| Action | Trigger | API | Permission | Result |
|---|---|---|---|---|
| Update workspace | Click "Lưu" | `WorkspaceService/Update` | Admin+ | Toast "Đã lưu" |
| Change mode | Select mode dropdown | `WorkspaceService/Update` | Admin+ | Home cards reorder |
| Invite member | Click "Mời" | `WorkspaceService/InviteMember` | Manager+ | Email sent + pending row |
| Change role | ⋮ → role select | `WorkspaceService/UpdateRole` | Admin+ | Role badge updates |
| Remove member | ⋮ → "Xóa" → confirm | `WorkspaceService/RemoveMember` | Admin+ | Row removed |
| Transfer ownership | Danger zone | `WorkspaceService/TransferOwnership` | Owner+OTP | Role swapped |
| Delete workspace | Danger zone | `WorkspaceService/Delete` | Owner+OTP | → `/` (new workspace) |

---

## Mobile Priority Screens (M1-M3)

> **Canonical specs**: See `screen_specs_13_mobile_shared.md` §M1-M3 for full layouts.
> Below are web-specific behavioral notes that supplement the mobile specs.

### M15. Mobile Home (extended notes)

> Full wireframe → see `screen_specs_13_mobile_shared.md` → **M1. Mobile Home / Today Feed**

**Behavioral Supplements (mobile-specific):**
- Quick stats bar uses horizontal scroll (swipe through KPI cards)
- Action cards are swipeable carousel (pull-to-refresh reloads all)
- Floating action button "+" opens quick create bottom sheet:
  - 💡 Ý tưởng mới → M17
  - 📝 Script mới → M20
  - 🎬 Tạo video → M21
  - 📤 Đăng bài → M6
- **More menu** (tab 5 📊): Analytics, Products, Settings, Creator Pro

### M16. Mobile Morning Brief

**Route**: `/briefing` (mobile, push notification entry)
**Purpose**: Daily morning briefing pushed at 6:30 AM with collapsible sections.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Morning Brief                    ☀️ Thứ 5, 27/3/2026          │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ "Chào buổi sáng, Quân! 🌅"                                      │
│                                                                  │
│ ┌─ Section: 📊 Performance (collapsible) ─── [▾] ────────────┐  │
│ │ Hôm qua: 12.4K reach · +45 followers · 890 likes          │  │
│ │ Top post: "Serum review" — 5.2K views                      │  │
│ │ [📊 Xem chi tiết →]                                        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Section: 💬 Inbox (collapsible) ─── [▾] ──────────────────┐  │
│ │ 23 tin nhắn chưa đọc · 3 purchase intents                 │  │
│ │ [💬 Mở Inbox →]                                            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Section: 🔥 Trends (collapsible) ─── [▾] ────────────────┐  │
│ │ 3 xu hướng mới phù hợp với niche của bạn                  │  │
│ │ 1. "Retinol alternatives" — Score: 92                       │  │
│ │ 2. "Glass skin routine" — Score: 87                         │  │
│ │ [🔍 Xem xu hướng →]                                        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Section: 📤 Lịch hôm nay (collapsible) ─── [▾] ──────────┐  │
│ │ 18:00 · "5 tips skincare" → TikTok                         │  │
│ │ 20:00 · "Serum review" → YouTube                            │  │
│ │ [📅 Xem lịch →]                                            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Section: 💰 Revenue (collapsible) ─── [▾] ────────────────┐  │
│ │ Hôm qua: 2.1M · MTD: 12.5M · ▲18% vs tháng trước        │  │
│ │ [💰 Xem tài chính →]                                       │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [📤 Share brief] → Zalo, WhatsApp, Messenger                    │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M16 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Expand/Collapse | Tap section header | — | Section toggles |
| Navigate to detail | Tap "→" link | — | → Relevant screen |
| Share brief | "Share brief" | — | Native share sheet |

#### M16 States
- **Loading**: Skeleton shimmer sections
- **Empty section**: "Không có dữ liệu mới" + muted text
- **Push notification**: Delivered at 6:30 AM (user-configurable in §99b)

### M3. Mobile Notifications

> Full wireframe → see `screen_specs_13_mobile_shared.md` → **M3. Mobile Notification Center**

**Cross-reference notes:**
- Accessible from bell icon 🔔 on all screens
- Badge count auto-updates via WebSocket
- Full spec with wireframe, action table, and states in specs_13

---

## Missing Screens (Gap Fixes)

### 9. Copilot Web (`/copilot`)

**Route**: `/copilot` (also accessible as side-panel overlay via hotkey `Ctrl+J`)
**Purpose**: AI-powered conversational assistant for the entire workspace — answers questions, generates content, provides data insights, and executes quick actions. Always available as a slide-in panel or dedicated page.

#### Layout (Dedicated Page)
```
┌─ App Shell ─────────────────────────────────────────────────────┐
│ 🤖 Copilot                               [Mode: General ▾] [⋮] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Conversation Area (scrollable) ───────────────────────────┐  │
│ │                                                              │  │
│ │ [🤖] "Chào Quân! Tôi có thể giúp gì hôm nay?"              │  │
│ │                                                              │  │
│ │ [👤] "Xu hướng skincare tuần này?"                           │  │
│ │                                                              │  │
│ │ [🤖] "Dựa trên Intelligence Hub, 3 xu hướng nổi bật:"       │  │
│ │      1. Retinol alternatives — ↑45% searches                │  │
│ │      2. Glass skin routine — ↑32% TikTok                    │  │
│ │      3. Peptide serums — ↑28% Shopee                        │  │
│ │      [📍 Sources: TikTok API, Google Trends, Shopee API]    │  │
│ │      [💡 Tạo ý tưởng từ xu hướng này →]                     │  │
│ │                                                              │  │
│ │ [👤] "Viết caption cho video review serum Vitamin C"         │  │
│ │                                                              │  │
│ │ [🤖] "Đây là 3 phiên bản caption:"                          │  │
│ │      Version A: "Serum thần thánh..." [📋 Copy] [✏️ Edit]  │  │
│ │      Version B: "POV: Da bạn sau..." [📋 Copy] [✏️ Edit]   │  │
│ │      Version C: "Review thật lòng..." [📋 Copy] [✏️ Edit]  │  │
│ │      [🔄 Regenerate] [⭐ Save to Ideas]                     │  │
│ │                                                              │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Quick Actions Row ─────────────────────────────────────────┐  │
│ │ [📊 Phân tích] [✍️ Viết] [💡 Ý tưởng] [📋 Tóm tắt] [🔍]  │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Input Area ────────────────────────────────────────────────┐  │
│ │ [📎] Hỏi bất cứ gì về workspace...  [🎤] [↵ Send]         │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ⚡ Credits: 45/200 today · [Upgrade for more →]                 │
└──────────────────────────────────────────────────────────────────┘
```

#### Copilot Modes
| Mode | Scope | Specialization |
|---|---|---|
| General | All workspace data | Conversation, Q&A, quick tasks |
| Writing | Content creation | Scripts, captions, descriptions |
| Analytics | Data analysis | Revenue, trends, performance |
| Strategy | Planning | Content calendar, campaign ideas |

#### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Send message | Enter or [Send] | `CopilotService/Chat` | AI response streamed |
| Quick action | Chip button | `CopilotService/QuickAction` | Context-aware prompt |
| Copy output | "Copy" | — | Clipboard + toast |
| Save to Ideas | "Save to Ideas" | `IdeaService/Create` | Idea created from response |
| Edit in Studio | "Edit" on generated content | — | → `/studio/text` prefilled |
| Attach file | 📎 | Upload → `CopilotService/Chat(with_context)` | File analyzed |
| Regenerate | "Regenerate" | `CopilotService/Regenerate` | New response |

#### States
- **Loading**: Typing indicator dots animation
- **Error**: "Không thể phản hồi, thử lại" with retry button
- **Rate limited**: "Bạn đã hết credit hôm nay" + upgrade CTA
- **Empty**: Suggested prompts grid (6 example questions)

---

### 10. Support Ticket Create (`/support/new`)

**Route**: `/support/new`
**Purpose**: User-facing form to submit a support ticket with category selection, description, and file attachments.

#### Layout
```
┌─ App Shell ─────────────────────────────────────────────────────┐
│ ← Hỗ trợ   📝 Tạo yêu cầu hỗ trợ                               │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ AI Self-Help (pre-form) ──────────────────────────────────┐  │
│ │ 🤖 "Mô tả vấn đề của bạn, tôi sẽ tìm bài hướng dẫn"      │  │
│ │ [Tìm kiếm bài hướng dẫn...]                                │  │
│ │                                                              │  │
│ │ Gợi ý: "Kết nối TikTok" · "Lỗi thanh toán" · "AI credit"  │  │
│ │ → Shows KB articles matching query before ticket form       │  │
│ │ [Không tìm được giải pháp? Tạo ticket →]                    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Ticket Form ──────────────────────────────────────────────┐  │
│ │ Category: [Connector ▾ | AI | Commerce | Billing | Other]   │  │
│ │ Priority: [🟡 Normal ▾ | Low | High | Urgent]               │  │
│ │ Subject: [Không thể kết nối TikTok Shop            ]        │  │
│ │ Description:                                                 │  │
│ │ ┌──────────────────────────────────────────────────────────┐ │  │
│ │ │ [Rich text editor with screenshot paste support]         │ │  │
│ │ │                                                           │ │  │
│ │ └──────────────────────────────────────────────────────────┘ │  │
│ │ Attachments: [📎 Drag & drop or click to upload] (max 5)    │  │
│ │ [screenshot.png ✕] [error_log.txt ✕]                        │  │
│ │                                                              │  │
│ │ Auto-detected context:                                       │  │
│ │ ☑ Include workspace config  ☑ Include browser info           │  │
│ │ ☑ Include recent error logs (last 24h)                       │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [Gửi yêu cầu hỗ trợ]                                            │
└──────────────────────────────────────────────────────────────────┘
```

#### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Search KB | Type in self-help | `KBService/Search` | Article suggestions |
| Submit ticket | "Gửi yêu cầu" | `SupportService/CreateTicket` | → `/support/[id]` confirmation |
| Upload file | Drag/click | `FileService/Upload` | File attached |
| Remove file | ✕ | — | File removed from form |

---

### 11. Asset Library (`/assets`)

**Route**: `/assets`
**Purpose**: Central media library for all workspace files — images, videos, audio, documents. Used across AI Studio, Publishing, and Commerce modules.

#### Layout
```
┌─ App Shell ─────────────────────────────────────────────────────┐
│ 📁 Thư viện tài nguyên                   [📤 Upload] [+ Folder]│
├──────────────────────────────────────────────────────────────────┤
│ Toolbar: [🔍 Search] [Type ▾] [Date ▾] [Size ▾] [Grid/List 🔲]│
│                                                                  │
│ ┌─ Folder Breadcrumb ────────────────────────────────────────┐  │
│ │ 📁 All Files > 📁 Products > 📁 Serum Campaign             │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Asset Grid (responsive: 4-6 columns) ─────────────────────┐  │
│ │ ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐             │  │
│ │ │📁 Prod │  │ 🖼️     │  │ 🎬     │  │ 🖼️     │             │  │
│ │ │ ucts   │  │ hero   │  │ review │  │ thumb  │             │  │
│ │ │ 24 items│  │ .jpg   │  │ .mp4   │  │ .png   │             │  │
│ │ │         │  │ 2.1 MB │  │ 45 MB  │  │ 450 KB │             │  │
│ │ └────────┘  └────────┘  └────────┘  └────────┘             │  │
│ │                                                              │  │
│ │ ┌────────┐  ┌────────┐  ┌────────┐                          │  │
│ │ │ 📄     │  │ 🎵     │  │ 🖼️     │                          │  │
│ │ │ brief  │  │ bgm    │  │ banner │                          │  │
│ │ │ .pdf   │  │ .mp3   │  │ .psd   │                          │  │
│ │ │ 1.8 MB │  │ 5.2 MB │  │ 12 MB  │                          │  │
│ │ └────────┘  └────────┘  └────────┘                          │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Storage: 2.1 GB / 50 GB used                                    │
└──────────────────────────────────────────────────────────────────┘
```

#### Detail Panel (Click Asset)
```
┌─ Asset Detail Drawer (right) ────────────────────────────────────┐
│ ✕                                                                │
│ [Preview: image/video/audio player]                              │
│                                                                  │
│ Filename: hero_serum.jpg                                         │
│ Size: 2.1 MB · Dimensions: 1920×1080 · Format: JPEG             │
│ Uploaded: 25/3/2026 · By: Quân                                   │
│                                                                  │
│ Used in:                                                         │
│ · Product "Serum Vitamin C" (cover image)                        │
│ · Post "Review serum" (scheduled 28/3)                           │
│                                                                  │
│ Tags: [serum] [product] [hero] [+ Add tag]                       │
│ Alt text: [Vitamin C serum bottle on marble background    ]      │
│                                                                  │
│ [📋 Copy URL] [📥 Download] [✏️ Edit in AI Studio]              │
│ [🗑 Delete]                                                      │
└──────────────────────────────────────────────────────────────────┘
```

#### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Upload | Drag or click "Upload" | `FileService/Upload` | File added to current folder |
| Create folder | "+ Folder" | `FileService/CreateFolder` | New folder created |
| Delete | Select → "Delete" | `FileService/Delete` | File removed (soft delete 30d) |
| Move | Drag to folder / ⋮ → Move | `FileService/Move` | File relocated |
| Bulk select | Click checkbox overlay | — | Toolbar: Move, Delete, Download |
| Copy URL | "Copy URL" | — | R2 public URL to clipboard |
| Edit in Studio | "Edit in AI Studio" | — | → `/studio/image?source=[id]` |
| Search | Type in search | `FileService/Search(Meilisearch)` | Instant results |

#### States
- **Loading**: Grid skeleton cards
- **Empty**: "Chưa có tài nguyên nào" + Upload CTA + drag zone
- **Quota near**: Yellow banner "Sắp hết dung lượng (45 GB / 50 GB)"
- **Upload progress**: Each file shows progress bar overlay

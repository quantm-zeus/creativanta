# Creativanta — Detail Design Pack 05 — Connector / Capability / Publish / Inbox Contract v3.1

## 0. Traceability Header

- **Upstream sections used**: Product Freeze sections 8–10, 13–14, 22, 24–25, 34–37, 39–46.
- **Canonical objects touched**: Connected Account, Connected Provider, Capability Snapshot, Publish Job, Queue Item, Approval Request, Publish Item, Publish Log, Channel Post, Thread, Sponsor Inquiry, Sample Request, Diagnostics Record.
- **State machines touched**: connected account/connector lifecycle, Publish Job, Queue Item, Approval Request, Publish Item, Thread, Sample Request.
- **Read / write ownership respected**: connector/runtime surfaces chỉ mutate qua publish/inbox/capability owners; logs và sync evidence append-only.
- **Acceptance scenarios inherited**: connect/reconnect, capability-visible publish, queue/approval inspection, inbox triage, sponsor/sample routing, repair wizard, degraded fallback.
- **See also**: S26 §16 (Webhook & Connector Health Console) — admin-side inbound webhook monitoring, platform health matrix, connector emergency isolation.

## 1. Mục tiêu

Pack này khóa các lớp dễ lệch nhất giữa UX và runtime:
- connector lifecycle
- capability registry
- publish execution
- publish logs
- inbox ingestion và thread model
- diagnostics, fallback, repair flows

## 2. Connector Contract

### 2.1 Connector Lifecycle
- not_connected
- connecting
- connected
- degraded
- disconnected
- reconnect_required
- revoked

### 2.2 Connected Account / Provider Metadata
- connected account id
- provider
- provider type
- workspace scope
- granted scopes
- external account ref/handle
- last successful sync
- last failure
- health status
- last capability snapshot ref

### 2.3 Rule
- connector lifecycle và capability lifecycle không được merge làm một
- workspace phải nhìn thấy connector state và repair path
- connected account là canonical object inspectable được, không chỉ là opaque integration config

## 3. Capability Registry Contract

### 3.1 Capability Dimensions
- publish capability
- moderation capability
- inbox reply capability
- order import capability
- payout/settlement import capability
- live support capability
- analytics import capability

### 3.2 States
- Native
- Read-only
- Manual
- Unsupported

### 3.3 Required Context
Capability snapshot phải gắn với:
- platform
- connector state
- action type
- timestamp
- policy note refs
- fallback path refs

## 4. Publish Contract

### 4.1 Publish Inputs
- publish item ref
- publish job ref
- asset ref
- target platform/account
- target format
- publish mode
- schedule if any
- capability snapshot ref

### 4.2 Publish Outputs
- publish state update
- publish log append
- channel post sync/import ref nếu có
- diagnostics if failure/degradation
- evidence/proof if success

### 4.3 Publish Mode Types
- native direct publish
- schedule via native support
- export/manual fallback
- draft save only

### 4.4 Publish Execution Objects
- Publish Job = execution-attempt group cho đúng một Publish Item
- Queue Item = inspectable queue/runtime record
- Approval Request = approval gate object khi action cần human approval
- Channel Post = synced/imported post object sau execution hoặc import path

### 4.5 Rule
- action phải show capability state trước khi execute
- export/manual fallback vẫn phải giữ publish intent trong graph
- publish queue, approval queue và repair flow phải đọc được cùng canonical objects mà runtime dùng

## 5. Publish Log Contract

### 5.1 Required Fields
- publish item ref
- action attempt time
- actor / acting mode
- execution path
- capability snapshot ref
- result state
- diagnostics ref if failed/degraded
- evidence ref or imported proof ref if success

### 5.2 Rule
Publish Log là immutable execution record. Mọi retry tạo log mới hoặc append run history, không overwrite history cũ.

### 5.3 Batch Publish Contract (Clip Factory / Multi-Merge / AI Remix)

> **Ref**: Pack 04 §9 (Video Production Modes), Pack 08 §4 (Credits)

Khi user export nhiều clips (Clip Factory) hoặc publish remix ra nhiều platforms:

| Aspect | Rule |
|---|---|
| **Job model** | Batch = N individual Publish Jobs (1 per clip × 1 per platform). Không phải 1 group job. |
| **Queue ordering** | Sequential dispatch: clip 1 → clip 2 → ... (tuân theo platform rate limits) |
| **Rate limiting** | TikTok: max 10 publish/hour. Reels: max 5/hour. YouTube: no batch limit. System auto-pace. |
| **Schedule spread** | User option: "Publish all now" hoặc "Spread over X hours" (recommended for algorithm) |
| **Partial failure** | Publish Job per clip có independent lifecycle. Clip 3 fails ≠ stop remaining clips. |
| **Progress UX** | Batch progress bar: "Publishing 5/10 clips..." + per-clip status indicator |
| **Credit tracking** | Credits charged per-publish (not per-batch). Failed publish = refund credits. |
| **Approval gate** | If workspace has approval flow: batch creates N Approval Requests (can bulk-approve). |
| **Clip Factory → M09 → M11 flow** | Clip Factory (M07) creates clips → M09 manages → user selects → M10 QA check → M11 Publish |

### 5.4 System-Level Publish Queue Fairness (Cross-Workspace Hotspot Prevention)

> **Context**: Khi hàng nghìn workspaces hẹn giờ publish cùng thời điểm (VD: 12:00:00, 20:00:00), platform API rate limits có thể reject hàng loạt jobs.

| Aspect | Rule |
|---|---|
| **Hotspot detection** | System monitor global publish queue. Khi > 100 jobs/phút cho cùng platform → activate jitter mode. |
| **Jitter queue** | Trong jitter mode, mỗi job được delay ngẫu nhiên ±30s quanh scheduled time (VD: 11:59:30 → 12:00:30). |
| **Priority ordering** | Paid tiers (Business > Pro > Starter) được ưu tiên dispatch trước Free tier trong jitter window. |
| **User transparency** | Nếu job bị jitter delay > 15s, show: "Đang tối ưu thời gian đăng để đạt hiệu quả tốt nhất." |
| **Platform-specific caps** | TikTok: max 50 concurrent publish calls/phút (system-wide). Reels: max 30. YouTube: max 100. |
| **Fairness guarantee** | Không workspace nào được chiếm > 20% system-wide publish slots trong 1 phút. |
| **Monitoring** | Alert ops khi global queue depth > 1.000 jobs pending cho 1 platform. |

## 6. Inbox Ingestion Contract

### 6.1 Ingested Message Types
- comment
- dm
- inquiry
- sponsor inquiry
- sample request

Sponsor inquiry và sample request được **ingested** như message subtypes vào inbox, nhưng khi được classify, chúng tạo ra canonical **Engagement Support Records** (Tier C trong Object Registry) linked to parent Thread. Thread giữ canonical relationship; Sponsor Inquiry / Sample Request objects giữ business-specific fields (sponsor profile, sample details, quantities, etc.). Đây không phải message-level objects mà là thread-linked business records.

### 6.2 Threading Rules
- messages phải được group vào canonical Thread
- Thread owner / intent / status / next action là mandatory
- thread activity timestamp phải cập nhật từ inbound/outbound messages

### 6.3 Intent Contract
Intent tối thiểu gồm:
- question
- purchase_interest
- support_issue
- objection
- sponsor_interest
- sample_request
- moderation_risk
- unknown

### 6.4 Sponsor / Sample Routing Rule
- sponsor inquiry và sample request phải giữ được canonical thread/entity relationship
- routing sang seeding/commercial owners không được làm mất inbox provenance

### 6.5 Inbox Ingestion Throttle (Viral Surge Protection)

> **Context**: Khi 1 video viral nhận 100.000+ comments/giờ, ingestion pipeline có thể quá tải DB và cháy AI credits nếu auto-analyze tất cả.

| Threshold | Action |
|---|---|
| **Thread < 100 messages/phút** | Normal mode: AI intent analysis real-time trên mỗi message. |
| **Thread 100-500 messages/phút** | Throttled mode: AI intent analysis chuyển sang batch processing mỗi 5 phút. UI badge: "⚡ Lượng tin nhắn cao — AI phân tích theo đợt." |
| **Thread > 500 messages/phút** | Circuit breaker mode: Tắt AI auto-analysis. Chỉ ingest raw messages. Alert user: "🔴 Lượng tin nhắn cực cao. AI tạm ngưng phân tích tự động. [Bật lại thủ công]." |
| **Workspace > 10.000 messages/giờ (tổng)** | Workspace-level throttle: batch processing cho toàn bộ threads. |

**Recovery rules:**
- Khi message rate giảm xuống < 100/phút trong 10 phút liên tục → tự động resume normal mode
- User có thể manually trigger batch analysis cho messages đã bị skip: "Phân tích [N] tin nhắn chưa xử lý" (tính AI credits)
- Messages ingested trong circuit breaker mode vẫn được lưu đầy đủ, chỉ skip AI processing
- Throttle events logged vào Diagnostics Record cho audit

## 7. Reply / Moderation Contract

### 7.1 Reply Paths
- native reply
- assisted reply copy
- manual fallback
- unsupported

### 7.2 Moderation Paths
- native moderation
- recommendation only
- unsupported

### 7.3 Rule
UI phải reflect đúng capability path, không giả vờ native nếu thực tế chỉ recommendation/manual.

### 7.4 Reply-As Identity Indicator (Multi-Account Confusion Prevention)

Khi workspace có nhiều Connected Accounts (VD: 5 Fanpages), Unified Inbox gom tất cả threads:

- Compose box **bắt buộc** hiển thị identity tag nổi bật: **color-coded badge + avatar + tên page/account** đang reply
- Identity tag format: `[🟢 Avatar] ĐANG TRẢ LỜI VỚI: Tên Page/Account`
- Khi user switch giữa threads từ accounts khác nhau, compose box **tự động cập nhật** identity tag
- Color-coding: mỗi Connected Account có 1 màu riêng biệt (auto-assigned, user có thể tùy chỉnh)
- **Không cho phép** reply mà không có identity tag visible (hard UX rule)
- Mobile: identity tag hiển thị dạng compact bar phía trên compose box

### 7.5 Ghost Message Handling (Platform-Side Deletion)

Khi user reply/react nhưng message gốc đã bị xóa trên platform:

| API Response | UX Behavior |
|---|---|
| **404 Not Found** (comment/message deleted) | Show: "Nội dung gốc đã bị người dùng xóa trên {platform}. Không thể trả lời." + disable compose box cho thread đó. |
| **403 Forbidden** (post restricted) | Show: "Bài viết đã bị hạn chế bởi {platform}. [Xem chi tiết]" + disable actions. |
| **410 Gone** (permanently removed) | Show: "Nội dung đã bị gỡ vĩnh viễn bởi {platform}." + archive thread. |
| **Timeout / 5xx** | Show: "Không thể kết nối {platform}. [Thử lại]" — KHÔNG disable compose (transient error). |

- Thread status tự động chuyển sang `stale` khi source message bị xóa
- Stale threads vẫn visible nhưng không cho phép reply
- Error messages tuân thủ formula "WHAT → WHY → NEXT" (PRD mandate)

### 7.6 Auto-Reply Loop Detection (Bot-to-Bot Circuit Breaker)

> **Context**: Khi AI auto-reply của Creativanta gặp auto-responder của platform khác hoặc chatbot bên thứ ba, có thể tạo vòng lặp reply vô hạn.

**Detection rules:**
- Nếu thread có **≥ 3 consecutive replies** hoàn toàn từ system (không có human input ở cả 2 phía): **tạm stop auto-reply** cho thread đó
- Nếu **≥ 5 auto-replies trong 5 phút** trên cùng thread: trigger circuit breaker ngay lập tức
- Pattern detection: nếu reply content lặp lại (similarity > 80% giữa 2 consecutive auto-replies): stop ngay + flag

**Actions khi trigger:**
- Stop auto-reply cho thread đó (không ảnh hưởng threads khác)
- Alert user: "🔄 Phát hiện vòng lặp phản hồi tự động trên thread [X]. AI đã tạm dừng. [Xem thread] [Bật lại]"
- Last auto-reply message có tag: `[Auto-reply paused — possible bot loop detected]`
- Log vào Diagnostics Record: loop detection event + thread ref + message count

**Resume rules:**
- User phải manually re-enable auto-reply cho thread bị dừng
- Sau khi re-enable, nếu loop detect lại → permanent disable cho thread + alert
- Max auto-reply depth per thread per hour: 10 (hard cap, không thể override)

## 8. Diagnostics & Repair Contract

### 8.1 Typical Failure Classes
- auth/scope failure
- connector revoked
- platform limitation
- transient publish failure
- unsupported action
- sync lag / stale data
- inbox ingestion mismatch

### 8.2 Repair Flow
Repair flow phải support:
- reconnect
- re-auth with scopes
- retry sync
- manual fallback
- verify recovered state

## 9. FE/UX Notes

### 9.1 Publish UX
- capability visible before action
- diagnostics visible after action
- retry/fallback CTA visible when needed
- publish status and log history inspectable

### 9.2 Inbox UX
- fast triage
- thread summary
- next action editing
- assignment
- reply / suggested action / related object links

## 10. Handoff

Detail design tiếp theo phải chốt:
- connector adapter interfaces
- sync schedules and webhooks/polling
- capability evaluation rules per action
- publish execution sequencing
- thread merge/split rules
- repair wizard logic per provider


## 11. Acceptance Scenario Inventory

Connector/capability/publish/inbox pack bắt buộc cover tối thiểu các scenario sau:
- connect, reconnect, revoke và degraded connector đều cập nhật đúng Connected Account + Capability Snapshot + Diagnostics surfaces
- publish path có thể inspect end-to-end qua Publish Job, Queue Item, Approval Request, Publish Item, Publish Log, Channel Post
- manual fallback/export vẫn giữ canonical publish intent, evidence path và retry/repair history
- inbox triage giữ thread owner/intent/status/next action khi route sang sponsor inquiry hoặc sample request flows
- diagnostics center và repair wizard luôn truy được về object/platform/account gây lỗi
- system-level publish jitter giãn cách hợp lý khi phát hiện hotspot (> 100 jobs/phút cùng platform)
- inbox ingestion throttle kích hoạt đúng theo threshold (100/500/10.000 messages) và tự recovery khi load giảm
- auto-reply loop detection dừng đúng thread bị loop, không ảnh hưởng threads khác
- ghost message (deleted on platform) hiển thị đúng error message + disable compose box
- reply-as identity tag luôn visible khi reply từ Unified Inbox, đúng account đang active

---

## S14. Content Safety & Post-Publish Monitoring (Supplementary)

> **Ref**: Legal §9 (Platform Policy), Pack 08 §5 (Affiliate Link Health)

### S14.1 Shadowban Risk Score

| Factor | Weight | Check Method |
|---|---|---|
| Banned hashtags used | 30% | Database of known shadowbanned hashtags per platform |
| Content flagged by moderation | 25% | OpenAI Moderation API + Gemini Safety pre-check |
| Engagement sudden drop | 20% | Analytics: compare last 7d vs previous 7d |
| Duplicate content | 15% | Content-hash comparison across recent publishes |
| Account warning from platform | 10% | Connected Account status API (when available) |

- **Score**: 0-100 (0 = safe, 100 = high risk)
- **Thresholds**: 0-30 = 🟢 Safe, 31-60 = 🟡 Warning, 61-100 = 🔴 High Risk
- **Behavior**: pre-publish check → warning if score > 30 → suggest fixes
- **AI credit cost**: 1 credit per full scan

### S14.2 Pre-Publish Content Scan (extends Legal §9)

| Check | Platform | Warning Message |
|---|---|---|
| Copyright music detected | TikTok, YouTube, Instagram | "Nhạc có thể vi phạm bản quyền. [Đổi nhạc] [Chấp nhận risk]" |
| Banned hashtag | All | "#xyz đã bị cấm trên {platform}. [Xóa] [Thay thế]" |
| Content too similar to recent | TikTok | "Nội dung tương tự post {date}. Có thể bị hạn chế reach." |
| Missing AI disclosure | YouTube, EU | "Nội dung AI-generated phải ghi nhãn theo EU AI Act" |
| Product claim without proof | TikTok Shop | "Claim hiệu quả sản phẩm cần có chứng cứ" |

### S14.3 Post-Publish Monitoring Dashboard

| Metric | Check Frequency | Alert Threshold |
|---|---|---|
| Engagement rate | Every 6h for 48h after publish | Drop > 50% vs average |
| View velocity | Every 2h for 24h | Unusually low velocity |
| Comment sentiment | Daily | > 30% negative sentiment |
| Content removal | Hourly for 72h | Platform removed content |
| Link click health | Every 12h | CTR drop > 40% |
| Platform warning | On webhook event | Any warning received |

### S14.4 Redirect Chain Analysis (Affiliate Links)

| Check | Detail |
|---|---|
| Redirect hops | Count hops (warn if > 3 — slower loading, potential block) |
| HTTPS enforcement | All redirects must use HTTPS |
| Geo-availability | Check if destination accessible from user's target regions |
| Product availability | Verify product still in stock at destination |
| Commission rate change | Alert if commission rate changed since link creation |
| Auto-replace suggestion | If link broken → suggest replacement product with similar commission |


# Creativanta — Detail Design Pack 01 — FE UX / Screen Contract v3.1

## 0. Traceability Header

- **Upstream sections used**: Product Freeze sections 7–10, 35–37, 39–46.
- **Canonical objects touched**: Workspace, Connected Account, Opportunity, Script, Asset, Publish Job, Publish Item, Thread, Offer, Order, Profit Snapshot, Proof Bundle, Workflow Run, Agent Run, Diagnostics Record cùng các supporting first-class objects hiển thị trên FE.
- **State machines touched**: Publish Job, Publish Item, Approval Request, Thread, Follow-up Task, Offer, Campaign, Coupon, Membership Plan, Order, Refund, Reconciliation Record, Live Session, Sample Request, Sample Shipment, Workflow Run, Agent Run.
- **Read / write ownership respected**: FE chỉ mutate canonical objects qua approved actions/commands; không tạo FE-only shadow truth.
- **Acceptance scenarios inherited**: beginner entry, mode-aware home, trust/proof visibility, degraded/repair flows, mobile execution, queue/approval handling, commerce/profit proofability.

## 1. Mục tiêu

Pack này khóa cách FE và UX triển khai giao diện để:
- không làm đứt One Graph
- không làm mất proof / confidence / capability visibility
- không làm sản phẩm khó dùng với user non-tech
- không biến mobile thành view-only

## 2. Surface Architecture

### 2.1 Surface Types
- Decision surfaces: Home, Daily Brief, alerts, anomalies
- Object workspaces: Trend, Opportunity, Script, Asset, Thread, Offer, Order, Proof Bundle
- Execution surfaces: Publish, Inbox triage, Live War Room, Workflow Run, Agent Run
- Trust surfaces: diagnostics, capability notes, proof drawer, reconciliation drawer
- Admin surfaces: reporting, metering, overrides, support console

### 2.2 Navigation Model
Primary navigation phải ưu tiên:
1. Home
2. Workflows / Tasks
3. Objects
4. Commerce / Profit
5. Diagnostics / Admin

Navigation không được bắt beginner học toàn bộ 23 module ngay từ đầu.

## 3. Layout System

### 3.1 Web Layout
- left navigation + contextual subnav
- top command/search bar là accelerator, không phải entry bắt buộc
- center = object/action canvas
- right drawer = trust/explanation/diagnostics/proof/details

### 3.2 Mobile Layout
- bottom nav theo loop/task
- floating quick actions cho publish/reply/approve/assign
- swipe actions cho triage/inbox/tasks
- bottom sheets cho explanation/proof/diagnostics

## 4. Screen Map

### 4.1 Global Screens
- Home / Daily Decision Engine
- Global Search / Command Hub
- Notifications / Alerts
- Task Queue
- Approval Queue
- Publish Queue / Publish Jobs
- Diagnostics Center
- Settings / Workspace Switcher
- Connected Accounts / Capability Center
- Commerce / Profit Hub
- Live / Seeding Console Entry

### 4.2 Object Detail Screens
Mọi object Tier A phải có detail page chuẩn gồm:
- summary header
- primary state
- key relations
- recommended next actions
- activity timeline
- trust panel
- diagnostics panel nếu có
- audit summary nếu object có business side effects

Áp dụng tối thiểu cho:
- Workspace
- Connected Account
- Trend
- Opportunity
- Idea
- Script
- Asset Brief
- Asset
- Publish Job
- Publish Item
- Person / Entity
- Thread
- Message / Comment / DM / Inquiry
- Product
- Offer
- Campaign
- Order
- Refund
- Settlement
- Cost Item
- Profit Snapshot
- Proof Bundle
- Workflow
- Workflow Run
- Agent Run
- Diagnostics Record
- Capability Snapshot

### 4.3 Operational Support Screens
Các supporting first-class objects sau cũng phải có ít nhất detail drawer hoặc full page chuẩn hóa, không được ẩn hoàn toàn trong modal kỹ thuật:
- Hook
- Angle
- Shot List
- Packaging Checklist
- Queue Item
- Approval Request
- Publish Log
- Channel Post
- Coupon
- Affiliate Link
- Membership Plan
- Store Page
- Reconciliation Record
- Live Session
- Sample Request
- Sample Shipment
- Recipe Template
- Evidence Object

### 4.4 AI Video Studio Screens (M07 — Production Modes + Extended Features)

> **Ref**: PRD M07, Pack 04 §9, ADR-011

#### 4.4.1 Mode Selector Hub
- Entry point: sidebar "AI Studio" → "Video Studio"
- Grid layout: 4 cards (Quick Edit, Clip Factory, Multi-Merge, AI Remix Studio)
- Mỗi card: icon, tên mode, mô tả 1 dòng, estimated credit range, tier badge (nếu locked)
- Locked modes (Clip Factory Free, Remix Free/Starter): hiển thị upsell badge + click → upgrade modal
- Recent projects section (last 5) dưới mode cards
- Gated modes hiển thị rõ "🔒 Nâng cấp để mở" (không ẩn hoàn toàn)

#### 4.4.2 Quick Edit Screen
```
┌─────────────────────────────────────────────────┐
│ Quick Edit                        [Credits: ~25]│
├───────────┬─────────────────────────────────────┤
│           │  [Video Player]                      │
│ Transcript│  AI-detected: filler, pauses,        │
│ Panel     │  dead segments highlighted           │
│           │                                      │
│ (edit     │  ──────────────────────────           │
│  text =   │  [Edit Plan]                          │
│  edit     │  ☑ Remove 5 filler words              │
│  video)   │  ☑ Auto-captions (bounce style)       │
│           │  ☑ Add hook (Question type)            │
│ [🗑 Delete]│  ☐ Beat-sync music                    │
│ [⟲ Undo]  │  ☐ Platform preset: TikTok            │
│           │                                      │
│           │  [Estimated Credits: 25] [▶ Apply]    │
└───────────┴─────────────────────────────────────┘
```
- Transcript panel: word-level timestamps, strikethrough = deleted, highlight = AI-suggested
- Edit plan: checklist of AI-suggested edits, user toggle on/off each
- Credit estimator updates in real-time khi user toggle options
- Preview: split before/after player
- Export: chọn platform → auto-adjust aspect ratio + pace

#### 4.4.3 Clip Factory Screen
```
┌─────────────────────────────────────────────────┐
│ Clip Factory                  [Source: 12:34]   │
├─────────────────────────────────────────────────┤
│ [Source video preview — scrub timeline]          │
├─────────────────────────────────────────────────┤
│ Detected Clips (8)         Sort: [Virality ▾]   │
│                                                  │
│ ┌───────────────────────────────────────────┐    │
│ │ Clip 1 — 0:45-1:12 (27s)        ⭐ 87/100│    │
│ │ [Thumbnail] Hook: Question | Pacing: Fast │    │
│ │ "Bạn có biết rằng 90%..."                 │    │
│ │ [☑ Select] [▶ Preview] [✏ Edit] [📊 Score]│    │
│ └───────────────────────────────────────────┘    │
│ ┌───────────────────────────────────────────┐    │
│ │ Clip 2 — 3:21-3:55 (34s)        ⭐ 72/100│    │
│ │ ...                                        │    │
│ └───────────────────────────────────────────┘    │
│                                                  │
│ [☑ Select All] [Batch: Add Captions] [Export 3]  │
└─────────────────────────────────────────────────┘
```
- Virality Score badge: color-coded (green ≥80, yellow 50-79, red <50)
- Score detail popover: 5 dimensions breakdown + explanation
- Sort: by virality, duration, chronological
- Batch actions: add captions, add music, apply style, export selected
- Export: multi-platform (TikTok + Reels + Shorts cùng lúc)

#### 4.4.4 Multi-Merge Screen
```
┌─────────────────────────────────────────────────┐
│ Multi-Merge                   [Media: 5/20 max] │
├─────────────────────────────────────────────────┤
│ [Drop media here ↓] hoặc [📎 Upload]            │
│                                                  │
│ Timeline:                                        │
│ ┌────┐ → ┌────┐ → ┌────┐ → ┌────┐ → ┌────┐    │
│ │ V1 │   │ I1 │   │ V2 │   │ I2 │   │ V3 │    │
│ │30s │   │ 3s │   │15s │   │ 3s │   │20s │    │
│ └────┘   └────┘   └────┘   └────┘   └────┘    │
│ [drag to reorder]                                │
│                                                  │
│ Duration target: [60s ▾]  Transitions: [Auto ▾]  │
│ Voice-over: [🎭 Character: Mila ▾] [🎤 Record]  │
│ Music: [🎵 Auto-select ▾] [📎 Upload]            │
│ Ratio: [9:16] [16:9] [1:1]                      │
│                                                  │
│ [▶ Preview] [Credits: ~20] [🚀 Create]           │
└─────────────────────────────────────────────────┘
```
- Drag-reorder media on timeline
- Duration slider: AI auto-adjust per-media timing
- Transition selector: per-transition or global auto
- Voice-over integrates with Character selector (from Character Pack)

#### 4.4.5 AI Remix Studio Screen
```
Phase 1 — Input:
┌─────────────────────────────────────────────────┐
│ 🔄 AI Remix Studio                               │
│                                                  │
│ [📎 Upload video] hoặc [🔗 Paste URL]            │
│ URL: [https://tiktok.com/...              ]      │
│                                                  │
│ Fidelity: ○ Match 1:1  ● Adapt  ○ Loose         │
│ Topic/niche: [________________________________]  │
│ Character: [🎭 Mila (default) ▾]                 │
│ Brand Pack: [My Brand ▾]                         │
│ Platforms: [☑ TikTok] [☑ Reels] [☐ YouTube]     │
│                                                  │
│ [🔍 Analyze — ~8 credits]                        │
└─────────────────────────────────────────────────┘

Phase 2 — Creative DNA Report:
┌─────────────────────────────────────────────────┐
│ Creative DNA Analysis                            │
│                                                  │
│ Duration: 28s | Scenes: 6 | Hook: Question       │
│                                                  │
│ 📊 Structure:                                    │
│ [Hook 3s][Problem 5s][Tip1 6s][Tip2 6s][CTA 5s] │
│                                                  │
│ 🎵 Audio: Pop, BPM 120, Voice 70% / Music 30%   │
│ 🎨 Visual: Bright, fast cuts, text overlays      │
│ 📈 Pacing: Fast → Medium → Fast                  │
│                                                  │
│ [✏ Edit blueprint] [🔄 Generate Remix — ~35 cr]  │
└─────────────────────────────────────────────────┘

Phase 3 — Polish:
┌─────────────────────────────────────────────────┐
│ [Original Video ▶]    │    [Remix Video ▶]       │
│                       │                          │
│  Side-by-side synced playback                    │
│                                                  │
│ ✅ Originality: 85% (safe)                       │
│ ⭐ Virality Score: 78/100                        │
│ ✅ Compliance: pass                              │
│                                                  │
│ Per-scene editor: [Scene 1 ▾] [✏ Script] [🎨]    │
│                                                  │
│ [🔄 Regenerate scene 2] [📤 Export] [📅 Schedule] │
└─────────────────────────────────────────────────┘
```

#### 4.4.6 Trend Engine → Remix Integration UX
- Trend Discovery (M02/M03): trending videos trong user's niche hiển thị "🔄 Remix this" button
- Click → auto-fill URL → navigate to AI Remix Studio Phase 1
- Button chỉ hiển thị cho tiers có access (Starter+)
- Locked tiers: "🔒 Upgrade to Remix" tooltip

#### 4.4.7 Mobile UX cho Production Modes

| Mode | Mobile Adaptation |
|---|---|
| **Mode Selector** | Bottom sheet grid, recent projects list |
| **Quick Edit** | Transcript list view (scrollable), edit plan as bottom sheet checkboxes |
| **Clip Factory** | Swipeable clip cards (like Tinder style), swipe right = select, left = skip |
| **Multi-Merge** | Horizontal scroll timeline, voice/music as bottom sheet pickers |
| **AI Remix** | Phase 1: form view. Phase 2: Creative DNA report as expandable sections. Phase 3: stacked (not side-by-side) video comparison |

#### 4.4.8 Component Requirements (Production Modes)
Các components mới cần cho video production:
- **TranscriptEditor**: word-level interactive transcript with playback sync
- **ViralityScoreBadge**: color-coded score (0-100) with detail popover
- **ClipReviewCard**: thumbnail + score + hook type + actions
- **TimelineEditor**: drag-reorder media blocks with transitions
- **CreativeDnaReport**: structured analysis visualization
- **SideBySidePlayer**: synced dual video player (web) / stacked (mobile)
- **CreditEstimator**: real-time cost calculation based on selected options
- **MediaDropZone**: multi-file upload with drag-drop
- **FidelitySelector**: radio group (Match 1:1 / Adapt / Loose)
- **PlatformExportSelector**: checkbox group with platform icons

**Extended Production Components** (§9.6-9.16):

- **ProductShowcaseStylePicker**: visual grid of 8 styles (360° Spin, Tabletop Demo, Flip & Reveal, Virtual Try-On, Lifestyle, Unboxing, Before/After, Review) — animated preview on hover
- **ProductPhotoUploader**: drag-drop + camera + auto background removal preview
- **ShowcaseCustomizer**: tabbed panel (Background | Duration | Music | Voice | Text | CTA | Aspect | Pacing | Color)
- **VirtualTryOnModelPicker**: model selection (AI generated / stock / Character) + body type + pose
- **BatchShowcaseManager**: grid of queued product videos, status per item, bulk export actions
- **ImageToVideoMotionPicker**: 6 motion style cards with animated preview
- **ThumbnailStudio**: generate panel + template browser + A/B variant viewer + platform preview
- **LinkToVideoInput**: URL paste field + auto-detected platform badge + crawled data preview
- **LinkVideoScriptPicker**: 5 script template cards (Problem-Solution / Listicle / Testimonial / Flash Sale / Comparison)
- **TranslationLanguagePicker**: language grid with flag icons, multi-select, lip-sync toggle
- **SoundStudioMixer**: waveform editor + AI music gen panel + SFX library + voice enhancement controls
- **StylePackViewer**: extracted style elements visualization + "Apply to next video" CTA
- **VideoAgentPromptInput**: single text input + suggestions + "Generate Video" primary CTA
- **PerformanceCoachWidget**: post-publish insight cards + weekly report card + improvement suggestions
- **GamificationDashboard**: Creator Level bar, streak counter (with flame icon), XP progress, achievement grid, quest list, leaderboard
- **StreakCounter**: persistent widget (home screen + sidebar) with flame animation
- **AchievementCard**: unlocked badge + title + shareable action
- **ABTestPanel**: variant comparison grid + live metrics + winner indicator

## 5. Home / Daily Brief UX Contract

Home phải có đúng 6 card families:
- Top Opportunities
- Top Risks
- Top Profitable Actions
- Pending Approvals
- Urgent Threads
- Connector / Capability / Diagnostics Issues

Mỗi card bắt buộc có:
- title rõ ràng bằng ngôn ngữ hành động
- why this matters
- primary CTA
- secondary CTA nếu cần
- owner / scope context
- confidence/trust badge khi áp dụng

Không dùng KPI cards trừu tượng làm hero section mặc định cho beginner.

Home phải reorder card priority theo operator mode đã freeze:
- Creator Mode: opportunities, scripts/assets waiting approval, publish queue, urgent threads
- Seller Mode: products/offers, publish-to-conversion links, order/refund anomalies, proof/profit cards
- Affiliate Operator Mode: affiliate links, coupons, campaign actions, conversion/profit evidence
- Live Operator Mode: live session readiness, cue/highlight actions, urgent commerce CTAs, moderation threads
- Agency / MCN Mode: approvals, assignments, diagnostics, workflow handoffs, reporting anomalies
- Brand Collaboration Mode: sponsor inquiries, deliverables, campaign proof, creator assignment and seeding actions

Home bắt buộc có first closed-loop onboarding cho beginner/non-tech theo đúng logic full product:
1. connect account hoặc chọn workspace mode
2. tạo/chọn product hoặc offer phù hợp
3. tạo idea → script → asset
4. tạo publish item/job hoặc manual fallback path
5. theo dõi thread/order/proof outcome

## 6. Object Page UX Contract

### 6.1 Header chuẩn
Header object phải gồm:
- object name/title
- state badges
- owner
- freshness / last updated
- source badge khi áp dụng
- quick actions

### 6.2 Tabs chuẩn
Mỗi object page chọn từ các tab sau:
- Overview
- Related Objects
- Activity / Timeline
- Proof / Evidence
- Diagnostics
- Audit

### 6.3 Cross-link Rules
Mọi object detail phải mở được tới object liên quan, không dùng deep nested modals cho flow quan trọng.

## 7. Trust UX Contract

### 7.1 Badges
User-facing badges canonical:
- Source: Official / Imported / Inferred / Estimated / Unreconciled
- Confidence: High / Medium-High / Medium / Low-Medium / Low
- Capability: Native / Read-only / Manual / Degraded / Unsupported
- Diagnostics: healthy / warning / degraded / blocked

### 7.2 Why Panels
Mọi score hoặc KPI quan trọng phải có drawer “Why this number” gồm:
- dựa trên dữ liệu nào
- còn thiếu gì
- caveat hiện tại
- nên làm gì tiếp

### 7.3 Proof Drawers
Mọi claim quan trọng phải mở được proof drawer gồm:
- claim summary
- evidence list
- proof bundle coverage
- unresolved gaps
- source mix

## 8. Empty / Partial / Broken / Repair UX

### 8.1 Empty State
Mọi empty state phải có:
- module/object dùng để làm gì
- bước đầu tiên
- CTA bắt đầu ngay
- recipe hoặc setup shortcut

### 8.2 Partial State
Khi thiếu data:
- chỉ rõ thiếu loại nào
- ảnh hưởng tới score / proof / capability là gì
- CTA repair / connect / add data

### 8.3 Broken State
Khi runtime hoặc connector lỗi:
- status banner rõ ràng
- explanation 1 câu dễ hiểu
- repair CTA
- diagnostics CTA
- fallback CTA nếu có

### 8.4 Repair Wizard
Repair wizard gồm 4 step:
1. Issue Summary
2. Why It Happened
3. Recommended Fix
4. Verify Repair

## 9. Beginner UX Contract

### 9.1 Entry Paths
Beginner phải bắt đầu được bằng 1 trong 4 đường:
- onboarding checklist
- Daily Brief
- guided recipes
- task inbox

### 9.2 Progressive Disclosure
- Beginner: 1 CTA chính / panel chính
- Intermediate: thêm related actions + explanation
- Advanced: thêm bulk actions / filters / advanced diagnostics

### 9.3 Forbidden UX Pattern
- không đẩy beginner vào blank dashboards nhiều chart
- không bắt user hiểu scores trước khi làm action
- không dùng technical wording làm label chính ở critical entry points

### 9.4 Beginner Safety Rails
- mọi publish/approval/refund/reconciliation action phải có explanation ngắn và undo/repair path khi khả thi
- các object support quan trọng như queue item, approval request, coupon, membership plan, sample request phải có label/action dễ hiểu cho non-tech
- user phải luôn nhìn thấy object đang bị block bởi capability, approval hay missing proof

## 9A. Persona-Based Onboarding Flows

### 9A.1 Onboarding Selection
Sau khi tạo workspace, user phải chọn operator mode. Mode này quyết định onboarding flow.

### 9A.2 Creator Mode Onboarding
1. Connect social account(s)
2. Chọn niche / audience
3. Explore trending topics → save first idea
4. Create first script from idea
5. Generate or upload first asset
6. Publish or export first content
7. Review first engagement / thread
**Time-to-first-value target**: ≤ 15 phút

### 9A.3 Seller Mode Onboarding
1. Connect commerce platform (Shopee, TikTok Shop, etc.)
2. Import products / create first product
3. Create first offer from product
4. Create content cho offer (idea → script → publish)
5. Review first order / revenue data
6. Inspect first profit snapshot
**Time-to-first-value target**: ≤ 20 phút

### 9A.4 Affiliate Operator Mode Onboarding
1. Connect affiliate platform account
2. Browse product opportunities
3. Generate / import affiliate links
4. Create content around product
5. Track first attributed conversion
**Time-to-first-value target**: ≤ 15 phút

### 9A.5 Live Operator Mode Onboarding
1. Connect live platform account
2. Plan first live session (products, cue cards)
3. Run practice live or review sample live data
4. Review post-live summary
**Time-to-first-value target**: ≤ 20 phút

### 9A.6 Agency / MCN Mode Onboarding
1. Create workspace, invite team members
2. Connect creator/client accounts
3. Review approval queue setup
4. Run first workflow / recipe
5. Review first cross-creator report
**Time-to-first-value target**: ≤ 25 phút

### 9A.7 Brand Collaboration Mode Onboarding
1. Set up brand profile
2. Create first campaign / sponsor brief
3. Assign creators
4. Track deliverables
5. Review first proof bundle
**Time-to-first-value target**: ≤ 20 phút

### 9A.8 Onboarding Resume & Skip
- Onboarding progress phải persisted
- User có thể skip steps (nhưng partial setup state phải hiện tại Home)
- User có thể re-enter onboarding bất cứ lúc nào từ Settings
- Completed steps có checkmark, pending steps có CTA rõ

### 9A.9 Contextual Help System
- Tooltips cho first-time interactions trên critical surfaces
- Coach marks sequence cho complex flows (workflow builder, live war room)
- "Learn more" links dẫn tới help center, không dẫn tới dead-end
- Contextual help phải mode-aware (hiện help liên quan tới operator mode hiện tại)

---

## 9B. Animation & Interaction Design Contract

### 9B.1 Animation Principles
- Animations phục vụ UX clarity, không phải decoration
- Mọi animation phải có `prefers-reduced-motion` override
- Performance budget: animation không được gây frame drop (maintain 60fps)
- Max animation duration: 300ms cho micro-interactions, 500ms cho page transitions

### 9B.2 Transition Library

| Transition Type | Duration | Easing | Use Case |
|---|---|---|---|
| Page navigation | 200–300ms | ease-out | Route changes |
| Drawer open/close | 250ms | ease-in-out | Right drawer, bottom sheet |
| Modal open | 200ms | ease-out | Dialogs, confirmations |
| Modal close | 150ms | ease-in | Dismiss |
| Card expand/collapse | 200ms | ease-in-out | Decision cards, detail sections |
| List item enter | 150ms | ease-out | Staggered: 50ms delay per item, max 5 |
| Toast / notification | 300ms enter, 200ms exit | ease-out / ease-in | Success, error, info |
| Tab switch | 150ms | ease-out | Content swap |
| Skeleton → content | 200ms | fade | Data loaded |
| Badge / counter update | 100ms | bounce | Count changes |

### 9B.3 Micro-Interactions

| Interaction | Feedback |
|---|---|
| Button click | Scale 0.97 → 1.0 (50ms) |
| Card hover (web) | Subtle shadow elevation |
| Swipe action reveal | Color-coded action strip slides in |
| Pull-to-refresh | Smooth elastic pull with icon rotation |
| Long press (mobile) | Scale pulse + haptic feedback |
| Drag-and-drop | Ghost element + drop zone highlight |
| Toggle switch | Smooth slide with color transition |
| Progress step complete | Checkmark entrance animation |

### 9B.4 Loading Animations
- Skeleton screens phải match actual layout structure
- Shimmer direction: left-to-right, consistent speed
- No spinners for page-level loading (use skeletons)
- Spinners only for inline actions (button loading, submit)
- AI generation progress: multi-step with named stages

### 9B.5 Mobile Haptic Feedback
- Light haptic: button taps, selection changes
- Medium haptic: successful action (publish, approve)
- Heavy haptic: error, warning alert
- Pattern haptic: live notification, urgent thread

### 9B.6 Responsive Breakpoints

| Breakpoint | Name | Target |
|---|---|---|
| ≤ 480px | mobile-small | Small phones |
| 481–768px | mobile-large | Large phones, small tablets |
| 769–1024px | tablet | Tablets, small laptops |
| 1025–1440px | desktop | Standard desktop |
| ≥ 1441px | desktop-wide | Wide monitors |

---

## 9C. Error UX & Copy/Tone Contract

### 9C.1 Error Message Principles
- **Plain language first**: không dùng error codes, HTTP status, hoặc technical jargon cho user-facing messages
- **Action-oriented**: mọi error message phải nói user làm gì tiếp
- **Blame-free**: không đổ lỗi cho user ("bạn đã nhập sai" → "thông tin chưa khớp, vui lòng kiểm tra lại")
- **Specific**: "Có lỗi xảy ra" là UNACCEPTABLE — phải nói rõ lỗi gì, ở đâu, làm gì

### 9C.2 Error Message Template

```
[Icon] [Tiêu đề ngắn — vấn đề là gì]
[Giải thích 1–2 câu — vì sao xảy ra]
[CTA chính — làm gì để fix]
[CTA phụ — xem chi tiết / liên hệ support] (optional)
```

### 9C.3 Error Categories & Tone

| Category | Tone | Example |
|---|---|---|
| Network / Connection | Calm, helpful | "Kết nối bị gián đoạn. Đang thử kết nối lại..." |
| Permission / Auth | Neutral, clear | "Bạn cần quyền truy cập để thực hiện. Liên hệ admin workspace." |
| Validation | Specific, guiding | "Tiêu đề offer cần ít nhất 5 ký tự." |
| Capability / Platform | Transparent | "TikTok chưa hỗ trợ đăng bài trực tiếp từ app. Bạn có thể xuất file và đăng thủ công." |
| Financial / Proof | Precise, cautious | "Doanh thu hiển thị chưa đầy đủ do chưa đồng bộ xong. Dữ liệu cuối cùng cập nhật lúc 14:30." |
| AI Generation | Patient, options | "Không tạo được video. Có thể do quá tải hệ thống. Thử lại hoặc chọn provider khác." |
| Workflow / Agent | Explanatory | "Workflow dừng ở bước 3 vì cần phê duyệt. Xem chi tiết và phê duyệt để tiếp tục." |

### 9C.4 Network Error Handling (Mobile)
- Offline: banner "Đang offline — hiển thị dữ liệu đã lưu"
- Slow connection: progressive loading, low-res images, deferred non-critical requests
- Reconnected: auto-sync + success notification "Đã kết nối lại, dữ liệu đã cập nhật"
- Failed request: inline retry CTA, không force-reload page

### 9C.5 Global Copy/Tone Guidelines
- **Voice**: Helpful expert — biết nhiều nhưng nói đơn giản
- **Tone**: Calm, confident, transparent
- **Length**: Labels ≤ 4 words, descriptions ≤ 2 sentences, tooltips ≤ 1 sentence
- **Terminology**: Dùng "doanh thu" thay "revenue" khi UI tiếng Việt, giữ English cho system/canonical terms
- **Numbers**: Luôn format theo locale, luôn có unit/context

---

## 9D. Search & Command Hub UX Contract

### 9D.1 Web Search UX
- Keyboard shortcut: `Cmd/Ctrl + K` mở Command Hub
- Auto-focus search input
- As-you-type suggestions: objects + actions + navigation targets
- Recent searches section
- Grouped results: by object type, limited 3 per group, expandable
- Empty search state: show quick actions + recent objects

### 9D.2 Mobile Search UX
- Search icon trên top bar, hoặc pull-down gesture
- Full-screen search overlay
- Recent searches + suggested searches
- Voice search button (optional, platform-dependent)
- Results grouped, scrollable

### 9D.3 Search Result Card
Mỗi search result phải có:
- Object type icon
- Object title/name
- Current state badge
- Owner (nếu applicable)
- Last updated time
- Quick action button (approve, open, reply)

---

## 9E. Notification Center UX Contract

### 9E.1 Web Notification Center
- Bell icon trên top bar với unread badge count
- Dropdown panel: grouped by time (today, yesterday, this week)
- Mark as read / mark all read
- Click notification → navigate to object
- Filter by type: approvals, alerts, commerce, diagnostics

### 9E.2 Mobile Notification Center
- Dedicated notifications tab hoặc pull-down
- Swipe to dismiss / mark read
- Long press for quick actions
- Grouped by type + time

### 9E.3 In-Context Alerts
- Sticky banner cho critical issues (connector broken, payment failed)
- Dismissable alerts cho warnings (stale data, approaching SLA)
- Toast notifications cho transient events (publish success, approval received)
- Toast auto-dismiss: 5s success, 8s warning, persistent cho errors

---

## 10. Mobile Execution Contract

### 10.1 Mandatory Mobile Actions
Mobile phải support:
- approve/reject scripts
- approve/reject assets
- quick publish / retry / fallback
- thread triage / reply / assign / next action
- live cue / highlight / urgent offer action
- anomaly inspect / assign follow-up
- workflow/agent approval and handoff

### 10.2 Mobile Interaction Rules
- swipe for quick triage
- bottom sheet for trust/proof/diagnostics
- large thumb targets
- max 2-step critical actions cho urgent flows

### 10.3 Mobile Navigation Architecture

#### 10.3.1 Bottom Tab Bar (5 tabs)

```
┌─────────────────────────────────────────────────┐
│  🏠 Home  │  📋 Tasks  │  ➕  │  💬 Inbox  │  👤 Me  │
└─────────────────────────────────────────────────┘
```

| Tab | Primary Screen | Key Sub-Screens |
|---|---|---|
| **🏠 Home** | Home / Morning Brief | Notifications, Search, Quick Actions |
| **📋 Tasks** | Task Queue + Approvals | Publish Queue, Workflow Runs, Follow-ups |
| **➕ (Create)** | Quick Create Modal | New Idea, New Script, AI Studio, Quick Publish, Start Live |
| **💬 Inbox** | Unified Thread List | Thread Detail, Reply, Assign, Triage |
| **👤 Me** | Profile / Settings | Workspace Switcher, Connected Accounts, Credits, Referral |

#### 10.3.2 Screen Hierarchy (per tab)

```
🏠 Home
├── Morning Brief (default)
├── Notifications Center
├── Global Search (full-screen overlay)
├── Diagnostics Overview
└── Object Detail → (any Tier A object page)

📋 Tasks
├── Task Queue (default)
├── Approval Queue
├── Publish Queue / Jobs
├── Workflow Run List
│   └── Workflow Run Detail
└── Follow-up Tasks

➕ Create (modal / bottom sheet)
├── New Idea → Idea Editor
├── New Script → Script Editor
├── AI Studio → Mode Selector
│   ├── Quick Edit
│   ├── Clip Factory
│   ├── Multi-Merge
│   ├── AI Remix Studio
│   └── Product Showcase (+ other extended modes)
├── Quick Publish
└── Start Live Session → Live War Room

💬 Inbox
├── Thread List (unified, filterable)
├── Thread Detail
│   ├── Reply composer
│   ├── Assign drawer
│   └── Related objects drawer
└── Sponsor Inquiry Detail

👤 Me
├── Profile / Account
├── Workspace Switcher
├── Connected Accounts
├── Credit Balance & Usage
├── Referral Center
├── Gamification (Level, Streak, Achievements)
├── Settings
│   ├── Notification Preferences
│   ├── Language
│   ├── Privacy & Consent
│   └── Data Export / Delete
└── Help / Support
```

#### 10.3.3 Navigation Rules
- Bottom tab bar: persistent across all screens (hidden during full-screen flows like AI generation, Live War Room)
- Back button: system back, not custom (platform-native behavior)
- Deep linking: all critical objects + notification targets must be deep-linkable
- Tab memory: switching tabs preserves scroll position and state
- Create button (center, elevated): always visible, opens action sheet / bottom sheet with context-aware options
- Swipe-to-go-back: enabled for all detail screens (iOS default, Android material edge gesture)
## 11. Component Contract

### 11.1 Canonical Components
- Decision Card
- Object Header
- Trust Badge Row
- Explanation Drawer
- Proof Drawer
- Diagnostics Drawer
- Timeline Panel
- Related Objects List
- Action Bar
- Empty State Block
- Broken State Banner
- Repair Wizard Stepper
- Search Result Card
- Notification Item
- Onboarding Stepper
- Skeleton Loader
- Toast Notification
- Connection Status Indicator

### 11.2 Component Reuse Rule
Các component trust/proof/diagnostics phải dùng thống nhất xuyên app, không custom mỗi module một kiểu.

## 12. FE State Handling Contract

FE phải tách các loại state sau:
- loading
- refreshing
- stale
- partial data
- degraded capability
- blocked
- empty
- broken
- repaired_pending_verification
- offline
- reconnecting
- slow_connection

Không được dùng chung một trạng thái "error" cho mọi case.

## 13. Accessibility & Responsiveness

- keyboard navigation cho web
- contrast ratio ≥ 4.5:1 cho text, ≥ 3:1 cho large text
- state không phụ thuộc màu sắc duy nhất (luôn kèm icon/text)
- screen reader labels cho actions chính
- mobile critical actions không nằm ở vị trí khó chạm
- focus indicators visible cho keyboard users
- skip navigation links
- ARIA labels cho custom components
- form fields phải có visible labels (không chỉ placeholder)
- error states phải có `aria-invalid` và `aria-describedby`

## 14. QA Notes cho FE

FE QA tối thiểu phải test:
- empty/partial/broken/repair states
- mobile urgent flows
- trust badge consistency
- proof drawer consistency
- navigation không tạo dead-end
- state refresh và stale indicator
- onboarding flow per operator mode (all 6 modes)
- animation performance (60fps check)
- search accuracy và response time
- notification delivery và deep linking
- offline → online transition
- responsive breakpoints (all 5)
- accessibility audit (keyboard, screen reader, contrast)

## 15. Handoff sang Screen Specs

Screen-by-screen specs tiếp theo phải bám theo pack này và tách thành:
- Home
- Object pages
- Publish
- Inbox
- Live
- Profit/Proof
- Workflow/Agent
- Diagnostics/Admin
- Search / Command Hub
- Notification Center
- Onboarding Flows (per mode)


## 16. Acceptance Scenario Inventory

FE/UX bắt buộc cover tối thiểu các scenario sau:
- beginner đi hết first closed-loop từ setup tới publish/proof cho mỗi operator mode (6 flows)
- chuyển operator mode làm đổi home priorities, quick actions và vocabulary mà không làm mất object graph
- publish queue / approval queue / diagnostics center mở được từ Home, object page và mobile quick actions
- object pages cho Publish Job, Approval Request, Refund, Reconciliation Record, Live Session, Sample Request có trust/proof/repair surfaces nhất quán
- degraded connector hoặc capability mismatch luôn có banner + explanation + repair CTA + fallback path
- mobile urgent flows không vượt quá 2 bước cho approve/reject, triage/reply, retry/fallback, live urgent actions
- proof drawer và why-panel hiển thị nhất quán trên commerce/profit/reporting surfaces
- search suggestion ≤ 200ms, full result ≤ 500ms cho cả web và mobile
- notification push delivery ≤ 5s, deep link mở đúng object
- offline → online transition giữ data integrity, sync thành công, hiển thị indicator
- animation không gây frame drop trên mid-range mobile devices
- onboarding resume sau app kill / browser close giữ đúng progress
- error messages luôn có action CTA, không bao giờ chỉ hiện "Có lỗi xảy ra"

---

## S01. Onboarding & First-Run Wizard (Supplementary)

> **Ref**: PRD §7 (Operator Modes), §29 (Beginner-Friendly), Legal §3 (Consent Gate)

### S01.1 Onboarding Flow Steps

```
 App Launch (first time)
     │
     ▼
 [1] Welcome Screen → brand intro + value proposition (5s max)
     │
     ▼
 [2] Legal Consent Gate → Privacy Policy + ToS checkbox (MANDATORY)
     │  ❌ Cannot proceed without consent
     ▼
 [3] Account Setup → name, avatar, timezone, language (VN/EN)
     │
     ▼
 [4] Operator Mode Selection → 6 modes with description + preview
     │  → "Bạn không chắc? Bắt đầu với Beginner mode"
     ▼
 [5] Platform Connection → connect ≥ 1 platform (TikTok/YouTube/Shopee/...)
     │  → Skip allowed, but encouraged (show benefits)
     ▼
 [6] First Goal Setup → AI asks "Bạn muốn đạt gì trong 30 ngày đầu?"
     │  → Pre-built goals per mode (e.g., "Publish 10 videos", "Earn 1M VND")
     ▼
 [7] Home → Guided checklist overlay (first 5 actions)
```

### S01.2 Guided Checklist (per mode)

| Mode | First 5 Actions |
|---|---|
| Creator | Connect platform → Create first content → Publish → Check analytics → Review profit |
| Seller | Connect shop → Import products → Create first offer → Publish → Check orders |
| Affiliate | Connect platform → Browse products → Create affiliate link → Share → Check clicks |
| Agency | Invite team → Add client workspace → Connect platforms → Assign task → Review report |
| Brand Collab | Set up brand profile → Create media kit → Set rate card → Browse deals → Apply |
| Beginner | Watch intro video → Connect 1 platform → Create first post → Publish → Celebrate 🎉 |

### S01.3 Progressive Disclosure
- Feature complexity revealed gradually as user completes checklist
- Advanced features hidden until prerequisites met
- "Pro tip" tooltips appear after 3rd successful action
- Checklist progress: saved per workspace, resumable after app kill

### S01.4 Resume Behavior
- Onboarding state persisted (localStorage + server sync)
- If app killed during step 4 → resume exactly at step 4
- Skip button available from step 5 onwards (not for legal/mode)

---

## S04. Error Message Guidelines (Supplementary)

> **Ref**: Pack 01 §12 (States), Pack 02 §16 (API Errors)

### S04.1 Error Copy Formula: WHAT → WHY → NEXT

Mọi error message phải có 3 phần:

| Part | Purpose | Example |
|---|---|---|
| **WHAT** | Mô tả ngắn gọn chuyện gì xảy ra | "Không thể publish video" |
| **WHY** | Giải thích nguyên nhân | "TikTok đang tạm thời từ chối upload do bảo trì hệ thống" |
| **NEXT** | CTA hành động | [Thử lại sau 15 phút] [Lên lịch publish sau] [Xem chi tiết] |

### S04.2 Domain-Specific Error Templates

| Domain | Error | WHAT | WHY | NEXT |
|---|---|---|---|---|
| Publish | Platform reject | "Video bị từ chối" | "{platform} phát hiện: {reason}" | [Sửa video] [Xem guidelines] |
| Commerce | Payment fail | "Thanh toán thất bại" | "Thẻ bị từ chối bởi ngân hàng" | [Thử thẻ khác] [Liên hệ ngân hàng] |
| AI | Generation fail | "AI không tạo được nội dung" | "Prompt quá dài / vi phạm policy" | [Sửa prompt] [Thử template] |
| Connector | Auth expired | "Kết nối {platform} hết hạn" | "Token hết hạn sau 90 ngày" | [Kết nối lại] |
| Upload | File too large | "File quá lớn" | "Giới hạn {limit}MB cho plan {tier}" | [Nén file] [Nâng cấp plan] |
| Search | No results | "Không tìm thấy kết quả" | "Thử từ khóa khác hoặc bỏ bớt filter" | [Xóa filter] [Tìm gợi ý] |

### S04.3 Tone Rules
- Không bao giờ đổ lỗi user: ❌ "Bạn đã nhập sai" → ✅ "Mật khẩu chưa đúng"
- Không dùng mã lỗi kỹ thuật trên UI: ❌ "Error 500" → ✅ giải thích bằng ngôn ngữ tự nhiên
- Luôn kết thúc bằng CTA
- Humor chỉ dùng cho lỗi nhẹ (empty state), không dùng cho lỗi liên quan tiền/data

---

## S05. Smart Defaults Per Operator Mode (Supplementary)

> **Ref**: PRD §7 (6 Operator Modes)

### S05.1 Home Cards Order Per Mode

| Card Position | Creator | Seller | Affiliate | Agency | Brand Collab | Beginner |
|---|---|---|---|---|---|---|
| **#1** | Morning Brief | Order Queue | Affiliate Dashboard | Team Overview | Deal Pipeline | Getting Started |
| **#2** | Content Calendar | Revenue Today | Top Products | Client Performance | Media Kit Status | Quick Actions |
| **#3** | Trending Now | Low Stock Alert | Link Health | Pending Approvals | Rate Card | Explore Features |
| **#4** | Publish Queue | Profit Summary | Commission History | Content Pipeline | Deliverables | Learning Hub |
| **#5** | Engagement Stats | Customer Messages | Trending Products | Revenue Report | Campaign Stats | My Progress |

### S05.2 Default KPIs Per Mode

| Mode | KPI 1 | KPI 2 | KPI 3 | KPI 4 |
|---|---|---|---|---|
| Creator | Total views (7d) | Engagement rate | Revenue | Content count |
| Seller | Orders today | Revenue today | Return rate | Average order value |
| Affiliate | Clicks today | Commission earned | Conversion rate | Active links |
| Agency | Active clients | Total revenue (all) | Pending tasks | SLA compliance |
| Brand Collab | Active deals | Earnings this month | Pending deliverables | Media kit views |
| Beginner | Checklist progress | Content published | First revenue | Platform health |

### S05.3 Regional Smart Defaults (Vietnam)

| Setting | Vietnam Default |
|---|---|
| Currency | VND |
| Timezone | Asia/Ho_Chi_Minh (UTC+7) |
| Language | Vietnamese |
| Date format | DD/MM/YYYY |
| Number format | 1.000.000 (dot thousands, comma decimal) |
| Payment | VNPay primary, Stripe secondary |
| Platforms | TikTok, Shopee, Lazada, YouTube |

---

## S08. In-App Glossary & Contextual Tooltips (Supplementary)

> **Ref**: PRD §29 (Beginner-Friendly)

### S08.1 Glossary Behavior
- Icon "?" bên cạnh mọi technical term lần đầu xuất hiện
- Hover (web) / tap (mobile) → tooltip với definition + example
- "Xem thêm" link → full glossary page
- Glossary searchable từ Command Hub: "glossary {term}"

### S08.2 Trust & Finance Terms

| Term | Definition (Vietnamese) | Context |
|---|---|---|
| Revenue | Tổng doanh thu trước chi phí | Profit OS |
| Net Profit | Lợi nhuận sau khi trừ mọi chi phí | Profit OS |
| Margin | Tỷ suất lợi nhuận (%) | Profit OS |
| RPM | Doanh thu trên mỗi 1.000 lượt xem | Analytics |
| Engagement Rate | Tỷ lệ tương tác (likes+comments+shares / views) | Analytics |
| Conversion Rate | Tỷ lệ chuyển đổi từ view → mua hàng | Commerce |
| Proof Bundle | Gói bằng chứng chứng minh kết quả thực tế | Trust |
| Health Score | Điểm sức khỏe kết nối platform (0-100) | Connector |
| Capability Gate | Giới hạn chức năng theo plan hoặc platform | Tier |
| Dunning | Quy trình thu hồi thanh toán thất bại | Billing |

### S08.3 Product Terms

| Term | Definition | Context |
|---|---|---|
| Workflow | Quy trình tự động hóa các bước lặp lại | Workflow Studio |
| Recipe | Workflow template có sẵn, cài 1-click | Recipe Marketplace |
| Copilot | Trợ lý AI hỗ trợ tạo nội dung và phân tích | AI |
| Operator Mode | Chế độ hiển thị tối ưu cho vai trò của bạn | Settings |
| Morning Brief | Bản tin sáng tổng hợp việc quan trọng | Home |
| Connected Account | Tài khoản platform đã liên kết | Connector |
| Repurpose | Biến 1 nội dung thành nhiều format/platform | Content |
| Smart Schedule | AI chọn thời điểm đăng tối ưu | Publish |

### S08.4 Commerce Terms

| Term | Definition | Context |
|---|---|---|
| Affiliate Link | Link giới thiệu sản phẩm, có hoa hồng | Affiliate |
| Commission | Hoa hồng nhận được khi có đơn hàng qua link | Affiliate |
| Offer | Sản phẩm/dịch vụ bạn bán cho khách hàng | Commerce |
| Seeding | Gửi sản phẩm miễn phí cho creator để review | Commerce |
| Live Commerce | Bán hàng trực tiếp qua livestream | Live |
| Pin Product | Ghim sản phẩm trên livestream | Live |

---

## S09. Quick Start Templates (Supplementary)

> **Ref**: PRD M21 (Recipe Marketplace)

### S09.1 Template Categories

| Category | Type | Examples |
|---|---|---|
| **Content Templates** | Script drafts | "Product review script", "Trending reaction", "Day-in-life vlog" |
| **Workflow Templates** | Automation recipes | "Auto-publish schedule", "Comment → DM auto-reply", "Trending alert" |
| **Calendar Templates** | Pre-filled schedules | "30-day content plan", "Product launch week", "Holiday campaign" |
| **Caption Templates** | Text templates | "Product caption (VN)", "Engagement caption", "Story question" |
| **Object Templates** | Pre-filled forms | "Product listing", "Affiliate campaign", "Brand deal tracker" |

### S09.2 Templates Per Mode

| Mode | Pre-installed Templates |
|---|---|
| Creator | 3 script templates + 2 workflow recipes + 1 calendar template |
| Seller | 2 product listing templates + 1 order workflow + 1 promotion calendar |
| Affiliate | 2 campaign templates + 1 link management workflow + caption templates |
| Agency | 1 client onboarding checklist + 1 reporting template + 1 approval workflow |
| Brand Collab | 1 media kit template + 1 deal tracking template + 1 deliverable checklist |
| Beginner | 1 "My First Post" template + 1 "Simple Publish" workflow |

### S09.3 Template Discovery
- Browse: Templates page (sidebar link)
- Search: Command Hub → "template {keyword}"
- Contextual: khi user tạo object mới → "Bắt đầu từ template?" suggestion
- AI suggest: Copilot gợi ý template phù hợp dựa trên mode + history

---

## S17. Content Intelligence & Calendar (Supplementary)

> **Ref**: PRD §37.2 (Smart Scheduling), M08 (Publish Queue)

### S17.1 Visual Content Calendar

| Feature | Spec |
|---|---|
| View modes | Day / Week / Month |
| Drag-drop | Reschedule by dragging content to new slot |
| Color coding | By platform (TikTok=cyan, YouTube=red, Shopee=orange) |
| Status indicators | Draft / Scheduled / Published / Failed |
| Multi-platform | Show all platforms merged or filtered |
| Empty slot suggestion | AI suggests content for empty slots |

### S17.2 Best Time to Post (AI)

| Factor | Data Source |
|---|---|
| Historical engagement | Connected platform analytics |
| Audience online time | Platform API (when available) |
| Content type | System classification |
| Platform algorithm | Learned patterns |
| Competitor analysis (P2) | Future feature |

- Output: heatmap 7x24 (day × hour) per platform
- Suggestion: top 3 recommended time slots per content
- Auto-schedule: "Publish at best time" toggle → AI picks optimal slot

### S17.3 Hashtag Intelligence

| Feature | Spec |
|---|---|
| Trending hashtags | Daily update per platform, per region |
| Related hashtags | AI suggests based on content topic |
| Performance data | Average views per hashtag (anonymized) |
| Banned/risky hashtags | Warn if hashtag is shadowban-risky |
| Custom saved sets | User saves frequently used hashtag groups |
| AI credit cost | 1 credit per analysis |

### S17.4 Content Performance Predictor (AI)

- Input: draft content (title, caption, thumbnail)
- Output: predicted engagement range (low/medium/high) with confidence %
- Basis: historical performance of similar content by same creator
- AI credit cost: 2 credits per prediction
- Tier: Pro+ only

### S17.5 Content A/B Testing

- Create 2 variants (different thumbnail, caption, or hashtags)
- Publish both simultaneously
- Auto-winner: after 24h, AI picks winner based on engagement
- Winner continues, loser can be manually kept or withdrawn
- Required: Pro+ plan

### S17.6 Content Gap Analysis (P2)

- AI analyzes published content history
- Identifies: topics not covered, formats not tried, platforms underutilized
- Suggests: "You haven't posted product reviews in 14 days — trending in your niche"
- Frequency: weekly automated report

### S17.7 Social Listening (P2 — Post-Launch)

> **Note**: Social listening is a P2 feature, documented here for architecture planning only.

| Feature | Scope |
|---|---|
| Mention monitoring | Track brand/username mentions across platforms |
| Sentiment analysis | Positive/negative/neutral classification |
| Trending alerts | Alert when topic in user's niche is trending |
| Reputation score | Composite score based on mentions + sentiment |

### S17.8 FE/UX Calendar Contract
- Calendar is accessible from sidebar: "Calendar" item
- Week view is default
- Mobile: simplified list view with day selector
- Pull-to-refresh on mobile
- Empty state: "Lịch trống — Thêm nội dung đầu tiên" + CTA

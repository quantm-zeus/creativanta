---
layer: index
canonical: true
last_updated: 2026-03-30
source: PRD Master v3.1 §23.1-§23.23
rule: Every AC below is a 1:1 conversion of a PRD §23 bullet. No invented ACs.
---

# Acceptance Tests — Given/When/Then

> Converted from PRD §23 Acceptance Criteria.
> Each AC has a unique ID and source citation.
> `[NEEDS INPUT]` marks bullets too vague for precise GWT.

---

## M01 — Home / Daily Decision Engine

### AC-M01-001: Action cards have primary CTA
Source: PRD §23.1 — "mỗi card có primary action rõ ràng"

    Given user đã login và workspace có ít nhất 1 connected account
    When user truy cập Home Dashboard (/)
    Then mỗi action card hiển thị đúng 1 primary CTA button
    And button CTA có label mô tả action cụ thể (không phải "OK" hay "Action")

### AC-M01-002: Cards link to real objects
Source: PRD §23.1 — "card map được về object thật"

    Given Home Dashboard hiển thị action cards
    When user click vào một card
    Then user được navigate đến detail page của object thật trong hệ thống
    And object đó tồn tại trong DB (không phải mock data hay dead link)

### AC-M01-003: Home reflects operator mode
Source: PRD §23.1 — "home phản ánh operator mode"

    Given user đã chọn operator mode (e.g., Creator Mode hoặc Seller Mode)
    When user truy cập Home Dashboard
    Then card priorities và layout thay đổi theo operator mode đang active
    And cards hiển thị phù hợp với context của mode (e.g., Seller Mode ưu tiên order anomalies, stock alerts)

### AC-M01-004: Home is not a dead dashboard
Source: PRD §23.1 — "home không được là dashboard chết chỉ để xem số"

    Given Home Dashboard đang hiển thị
    When user scan qua danh sách cards
    Then mỗi card đều có actionable next step (không chỉ hiển thị số liệu)
    And không có card nào chỉ show metric mà không có CTA hoặc drill-down path

---

## M02 — Trend Fusion Radar

### AC-M02-001: Trend save works
Source: PRD §23.2 — "trend save works"

    Given user đang xem một trend trên Trend Radar
    When user nhấn "Save" trên trend card
    Then trend được lưu vào workspace's saved trends list
    And user có thể truy cập lại trend đã save từ saved trends view

### AC-M02-002: Trend to opportunity conversion works
Source: PRD §23.2 — "trend → opportunity works"

    Given user đang xem một saved trend
    When user nhấn "Convert to Opportunity"
    Then một Opportunity object mới được tạo trong M04
    And Opportunity mới link về trend gốc (source ref populated)
    And user được navigate đến Opportunity detail page

### AC-M02-003: Confidence is visible
Source: PRD §23.2 — "confidence visible"

    Given Trend Radar hiển thị danh sách trends
    When user xem bất kỳ trend nào
    Then trend card hiển thị confidence band rõ ràng (High / Medium-High / Medium / Low-Medium / Low)
    And confidence band có visual indicator (color/icon) để phân biệt nhanh

### AC-M02-004: Watchlist alerts work
Source: PRD §23.2 — "watchlist alerts hoạt động"

    Given user đã tạo watchlist với keyword/topic conditions
    When một trend mới match watchlist conditions
    Then user nhận được alert notification (in-app và/hoặc push tùy settings)
    And alert chứa link đến trend detail để user review ngay

---

## M03 — Research & Competitor Intelligence

### AC-M03-001: Inferred insights labeled correctly
Source: PRD §23.3 — "inferred insights phải gắn nhãn inferred"

    Given system hiển thị competitive insights
    When insight được tạo từ inferred/aggregated data (không phải official API)
    Then insight card hiển thị badge "Inferred" rõ ràng
    And badge phân biệt được với Official data insights

### AC-M03-002: Insights have confidence and explanation
Source: PRD §23.3 — "insight phải có confidence/explanation"

    Given user xem một competitive insight
    When user click vào insight detail
    Then detail view hiển thị confidence band
    And có explanation section giải thích tại sao system đưa ra insight này
    And explanation có source references (data points sử dụng)

### AC-M03-003: Market intelligence separated from accounting truth
Source: PRD §23.3 — "không conflates market intelligence với accounting truth"

    Given user đang xem research/competitor data
    When data hiển thị revenue/pricing estimates
    Then estimates được label rõ là "Market Intelligence" hoặc "Estimated"
    And không có mixing với Official profit/revenue data từ M19 Operating Ledger

---

## M04 — Opportunity Board

### AC-M04-001: Opportunity maps to trend/signal source
Source: PRD §23.4 — "opportunity phải map về trend/signal source"

    Given user xem Opportunity detail page
    When opportunity có nguồn gốc từ trend hoặc signal
    Then detail page hiển thị linked source refs (trend/signal IDs)
    And user có thể click vào source ref để navigate đến trend/signal gốc

### AC-M04-002: Opportunity has owner and status
Source: PRD §23.4 — "opportunity phải có owner và status"

    Given một Opportunity tồn tại trong system
    When user xem Opportunity trên board hoặc detail view
    Then Opportunity hiển thị assigned owner (hoặc "Unassigned" nếu chưa có)
    And Opportunity hiển thị current status (e.g., new, evaluating, accepted, rejected, converted)

### AC-M04-003: Opportunity has priority reason or confidence context
Source: PRD §23.4 — "opportunity phải có priority reason hoặc confidence context"

    Given user xem ranked Opportunity list
    When user click vào priority/rank indicator
    Then system hiển thị reason tại sao opportunity được rank ở vị trí đó
    And/hoặc confidence context (impact estimation, effort estimation) được hiển thị

---

## M05 — Idea Engine

### AC-M05-001: Every idea links to source refs
Source: PRD §23.5 — "mỗi idea link được về source refs"

    Given user tạo hoặc xem một Idea
    When Idea được tạo từ trend, product, comment, hoặc opportunity
    Then Idea detail hiển thị source refs (linked object IDs)
    And user có thể navigate đến source object từ Idea detail

### AC-M05-002: Idea has clear state
Source: PRD §23.5 — "idea có state rõ ràng"

    Given một Idea tồn tại trong system
    When user xem Idea list hoặc detail
    Then Idea hiển thị current state rõ ràng (e.g., draft, evaluating, approved, converted, archived)
    And state transition history có thể truy cập được

### AC-M05-003: Idea flows forward to script or campaign
Source: PRD §23.5 — "idea có thể đi tiếp sang script hoặc campaign/live plan"

    Given user đang xem một Idea với status approved
    When user nhấn "Convert to Script" hoặc "Convert to Campaign"
    Then object mới (Script hoặc Campaign) được tạo với link về Idea gốc
    And user được navigate đến object mới để tiếp tục workflow

---

## M06 — Script Lab

### AC-M06-001: Every script has status
Source: PRD §23.6 — "mỗi script có status"

    Given một Script tồn tại trong Script Lab
    When user xem Script list hoặc detail
    Then Script hiển thị current lifecycle status (e.g., drafting, review, approved, production, archived)
    And status badge visible ở cả list view và detail view

### AC-M06-002: Script links to idea, asset brief, publish targets
Source: PRD §23.6 — "links tới idea, asset brief, publish targets hoặc publish target profile refs"

    Given user xem Script detail page
    When Script đã được tạo từ Idea và có associated Asset Brief
    Then detail page hiển thị linked Idea (clickable)
    And detail page hiển thị linked Asset Brief (clickable)
    And detail page hiển thị target publish platforms/profiles

### AC-M06-003: Approval state is clear
Source: PRD §23.6 — "approval state rõ ràng"

    Given một Script đang trong approval flow
    When user (reviewer hoặc creator) xem Script
    Then approval state hiển thị rõ: pending, approved, rejected, changes_requested
    And nếu rejected/changes_requested, reason/comments được hiển thị inline

---

## M07 — AI Video Studio

### AC-M07-001: Generation logs include required fields
Source: PRD §23.7 — "required logs gồm provider, model, cost, latency, status, diagnostics, lineage"

    Given một asset generation job đã chạy (thành công hoặc thất bại)
    When user hoặc system truy cập generation log
    Then log chứa: provider name, model ID, credit cost, latency (ms), status, diagnostics summary
    And log chứa lineage refs (prompt, script_ref, character_ref nếu có)

### AC-M07-002: Asset versions are traceable
Source: PRD §23.7 — "asset versions truy được nguồn gốc (provider + model + prompt)"

    Given một Asset có nhiều versions (regenerated/edited)
    When user xem Asset version history
    Then mỗi version hiển thị: provider, model, prompt used
    And user có thể so sánh 2 versions side-by-side

### AC-M07-003: Generation failure has explanation and auto-fallback
Source: PRD §23.7 — "generation failure có explanation usable + auto-fallback to secondary provider"

    Given primary provider (e.g., Veo 3.1) trả về error/timeout
    When system detect failure
    Then system tự động fallback sang secondary provider (e.g., Kling 3.0)
    And user nhận được notification với explanation: lý do fail, provider đã fallback
    And nếu tất cả providers fail, user nhận error message có diagnostics path

### AC-M07-004: Model selection with credit estimation
Source: PRD §23.7 — "user chọn được model cụ thể hoặc 'Tự động' → system hiện estimated credit cost"

    Given user bắt đầu generation flow trong AI Studio
    When user chọn model (Veo/Kling/Flux/Auto)
    Then UI hiển thị estimated credit cost cho generation job
    And nếu chọn "Tự động", system hiển thị estimated cost range (min-max)

### AC-M07-005: Lip-sync output matches audio
Source: PRD §23.7 — "lip-sync output khớp audio (QA drift check vs canonical character)"

    Given system gen video với lip-sync (SyncLabs/Wav2Lip)
    When lip-sync processing hoàn tất
    Then output video's lip movement khớp với audio track
    And system chạy drift check so sánh với canonical character visual
    And nếu drift detected, warning hiện cho user review

### AC-M07-006: Post-production mix meets spec
Source: PRD §23.7 — "post-production mix output normalize -14 LUFS, aspect ratio correct"

    Given video asset đi qua post-production pipeline (rust-ffmpeg)
    When mix processing hoàn tất
    Then audio output đạt -14 LUFS (±1 LUFS tolerance)
    And aspect ratio output match target platform spec (9:16, 16:9, 1:1)

### AC-M07-007: Clip Factory virality score uses Trend Engine data
Source: PRD §23.7 — "Clip Factory virality score phải sử dụng data từ Trend Engine (M02/M03), không chỉ pattern chung"

    Given Clip Factory cắt clips từ long-form video
    When system tính Virality Score (0-100) cho mỗi clip
    Then score calculation bao gồm trend relevance factor (10% weight) từ M02/M03
    And score breakdown hiển thị contribution từ Trend Engine data
    And không chỉ dựa trên generic pattern matching

### AC-M07-008: AI Remix passes originality check
Source: PRD §23.7 — "AI Remix output phải pass originality check (<30% script similarity vs reference)"

    Given user tạo Remix từ reference video
    When remix generation hoàn tất
    Then system chạy script similarity check vs reference transcript
    And nếu similarity ≥ 30%, remix bị block với warning "Too similar to reference"
    And user phải adjust trước khi export

### AC-M07-009: AI Remix does not use source footage
Source: PRD §23.7 — "AI Remix KHÔNG sử dụng bất kỳ footage/audio gốc nào — chỉ dùng analysis data"

    Given user tạo Remix từ reference video
    When remix pipeline chạy
    Then system KHÔNG copy/reuse bất kỳ frame, audio clip, hoặc footage nào từ reference
    And remix chỉ sử dụng analysis data (Creative DNA Blueprint) để generate video mới hoàn toàn

### AC-M07-010: Quick Edit text-based editing works real-time
Source: PRD §23.7 — "Quick Edit text-based editing phải sync transcript ↔ video timeline real-time"

    Given user mở video trong Quick Edit mode
    When user edit text trong transcript panel
    Then video timeline updates tương ứng trong real-time (≤ 2s delay)
    And cursor position trong transcript sync với playhead trên timeline

### AC-M07-011: Multi-Merge passes compliance scan
Source: PRD §23.7 — "Multi-Merge output phải pass compliance scan trước export"

    Given user đã merge nhiều video/ảnh thành 1 video
    When user nhấn "Export"
    Then system chạy compliance scan trước khi cho phép export
    And nếu compliance issues detected, user nhận warning list với suggested fixes
    And export bị block cho đến khi issues resolved hoặc user explicitly overrides

### AC-M07-012: Product Showcase quality
Source: PRD §23.7 — "Product Showcase: background removal clean, product recognizable, Virtual Try-On proportions natural"

    Given user tạo Product Showcase từ product photos
    When generation hoàn tất
    Then background removal clean (no product edge artifacts visible)
    And product recognizable trong video output (không bị distort/blur)
    And nếu Virtual Try-On mode: AI model proportions natural (clothing fits naturally)

### AC-M07-013: Link-to-Video data extraction
Source: PRD §23.7 — "Link-to-Video: product data extraction accurate (price, reviews), script relevant to product"

    Given user paste product URL (Shopee/Lazada/TikTok Shop/Amazon)
    When system crawl và extract product data
    Then extracted data chứa: product name, price, images, description (nếu available)
    And generated script content relevant to actual product (không hallucinate features)
    And price displayed in video matches source URL price

### AC-M07-014: Translation quality
Source: PRD §23.7 — "Translation: lip-sync quality check, cultural nuance in translation"

    Given user dịch video sang target language
    When translation pipeline hoàn tất (ASR → translate → voice clone → lip-sync)
    Then lip-sync quality pass (audio-visual alignment check)
    And translation output preserves cultural context (không literal translation gây confusion)

### AC-M07-015: Performance Coach uses real data
Source: PRD §23.7 — "Performance Coach: analysis based on REAL platform data, no hallucinated stats"

    Given user mở Performance Coach cho một published content
    When system generate analysis
    Then all metrics cited are from real platform API data (views, likes, comments, retention)
    And NO fabricated/estimated stats presented as facts
    And source class "Official" hoặc "Imported" badge visible on every metric

### AC-M07-016: Gamification XP is event-driven
Source: PRD §23.7 — "Gamification: XP calculation event-driven, streak tracking persist across sessions"

    Given user thực hiện action có XP reward (e.g., publish video, complete streak)
    When action event fires
    Then XP tính toán dựa trên event payload (không batch/cron-based)
    And streak counter persist across sessions (login lại vẫn giữ streak)
    And streak rewards apply correctly (7-day = +50 credits, 30-day = +200 credits)

### AC-M07-017: Cost estimation before generation
Source: PRD §23.7 — "cost estimation — hiển thị estimated credits trước generate"

    Given user configure generation job (model, duration, features)
    When user review job summary trước khi nhấn "Generate"
    Then UI hiển thị estimated credit cost dựa trên selected configuration
    And nếu user không đủ credits, warning hiển thị với upsell option

---

## M08 — Continuity OS

### AC-M08-001: Character creation via 4-step wizard
Source: PRD §23.8 — "user tạo được character qua 4-step wizard (type → profile → preview → save)"

    Given user navigates đến Character Builder trong Continuity OS
    When user bắt đầu tạo character mới
    Then wizard hiển thị 4 steps: Type Selection → Profile Setup → Preview → Save
    And user phải hoàn thành từng step tuần tự
    And saved character xuất hiện trong character library

### AC-M08-002: Character auto-creates canonical pack
Source: PRD §23.8 — "character tự động tạo Character Pack canonical (continuity integration)"

    Given user vừa save character mới qua wizard
    When character save thành công
    Then system tự động tạo Character Pack canonical linked to character
    And Character Pack chứa visual references, voice profile (nếu có), continuity rules
    And Pack xuất hiện trong Continuity OS pack library

### AC-M08-003: Character selection at script/generation step
Source: PRD §23.8 — "user chọn character tại bước script hoặc generation"

    Given user đang tạo script (M06) hoặc bắt đầu generation (M07)
    When user đến bước chọn character
    Then character picker hiển thị available characters từ workspace library
    And user có thể chọn character hoặc skip (use default)

### AC-M08-004: Default character auto-selected
Source: PRD §23.8 — "default character auto-selected khi mở video generation flow"

    Given user đã set default character trong Continuity OS settings
    When user mở video generation flow trong M07
    Then default character tự động pre-selected trong character picker
    And user vẫn có thể change sang character khác

### AC-M08-005: Digital twin consent verification
Source: PRD §23.8 — "digital twin phải pass consent verification trước khi sử dụng"

    Given user tạo character type "Digital Twin" (based on real person)
    When user attempt sử dụng digital twin trong generation
    Then system check consent verification status
    And nếu consent chưa verified, generation bị block với message yêu cầu verify consent
    And consent verification record lưu trong audit trail

### AC-M08-006: Output drift warning
Source: PRD §23.8 — "output drift phải được cảnh báo (so với canonical character visual/voice)"

    Given asset generation sử dụng character từ Character Pack
    When generation output ready cho review
    Then system chạy drift check so sánh output với canonical character references
    And nếu drift detected (visual hoặc voice mismatch), warning banner hiển thị
    And warning chứa specific drift details (e.g., "Face shape differs from canonical reference")

### AC-M08-007: Continuity history traversable
Source: PRD §23.8 — "continuity history truy được xuyên assets"

    Given user xem một Character Pack detail
    When user click "History" / "Usage" tab
    Then system hiển thị danh sách all assets đã sử dụng Character Pack này
    And mỗi entry link đến asset detail page
    And timeline view cho phép xem continuity evolution

### AC-M08-008: Character slots gated by tier
Source: PRD §23.8 — "character slots gating per tier (Free: 1, Starter: 2, Pro: 5, Business: 15)"

    Given user đang ở tier Free
    When user đã có 1 character và attempt tạo character mới
    Then system block creation với message "Character slot limit reached (1/1)"
    And inline upsell hiển thị: "Upgrade to Starter for 2 characters"
    And tier limits enforce: Free=1, Starter=2, Pro=5, Business=15

---

## M09 — Asset Derivative Manager / Repurpose Hub

### AC-M09-001: Derivative links to source asset
Source: PRD §23.9 — "mọi derivative phải link về source asset (lineage mandatory)"

    Given một derivative (clip/variant/remix) tồn tại trong system
    When user xem derivative detail
    Then detail hiển thị source asset ref (clickable link)
    And lineage chain traversable từ derivative → source asset → original script/idea

### AC-M09-002: Variant purpose and target channel clear
Source: PRD §23.9 — "variant purpose và target channel phải rõ"

    Given user xem variant trong derivative library
    When variant hiển thị
    Then variant có labeled purpose (e.g., "TikTok vertical cut", "YouTube shorts")
    And target channel/platform hiển thị rõ ràng

### AC-M09-003: Derivative flows to packaging and publish
Source: PRD §23.9 — "clip/derivative đi tiếp được sang M10 (packaging) / M11 (publish) liền mạch"

    Given user xem derivative trong library
    When user select derivative và nhấn "Send to Packaging" hoặc "Queue Publish"
    Then derivative được chuyển sang M10 Packaging QA hoặc M11 Publish Hub
    And no data re-entry required (metadata carries over)

### AC-M09-004: Performance attribution feeds back
Source: PRD §23.9 — "performance attribution: clip performance feed ngược về source asset analytics"

    Given một derivative đã published và has performance data
    When user xem source asset analytics
    Then analytics view hiển thị aggregated performance từ all derivatives
    And mỗi derivative's contribution visible trong breakdown

### AC-M09-005: Batch operations support 100+ items
Source: PRD §23.9 — "batch operations phải support ≥100 items cùng lúc"

    Given user xem derivative library với > 100 items
    When user select 100+ derivatives và apply batch action (tag/archive/queue publish)
    Then batch action completes successfully cho tất cả selected items
    And progress indicator hiển thị during batch execution
    And failure report cho any items that failed

---

## M10 — Packaging QA / Upload Copilot / Experiment Lab

### AC-M10-001: Every publish attempt has packaging QA
Source: PRD §23.10 — "mọi publish attempt có packaging QA panel"

    Given user bắt đầu publish flow cho một content item
    When publish wizard mở
    Then packaging QA panel hiển thị automatically với checklist: hook score, title, caption, CTA, disclosure
    And each checklist item shows pass/warning/fail status

### AC-M10-002: Readiness gaps have suggested fixes
Source: PRD §23.10 — "mọi error/readiness gap có suggested fix hoặc override"

    Given packaging QA panel hiển thị warnings hoặc errors
    When user click vào warning/error item
    Then system hiển thị suggested fix (e.g., "Add CTA in last 5 seconds", "Caption too long for TikTok")
    And user có option "Fix now" (apply suggestion) hoặc "Override" (skip with reason)

### AC-M10-003: Override requires reason for trust-critical checks
Source: PRD §23.10 — "override phải có reason nếu bypass trust-critical checks"

    Given packaging QA có trust-critical error (e.g., missing disclosure, copyright flag)
    When user nhấn "Override"
    Then system yêu cầu reason text input trước khi allow override
    And override event lưu vào audit trail với reason, user, timestamp

---

## M11 — Publish Hub

### AC-M11-001: Publish shows capability status per platform
Source: PRD §23.11 — "mỗi publish action hiển thị capability status theo platform"

    Given user chọn platforms để publish
    When publish configuration screen hiển thị
    Then mỗi platform hiển thị capability status (Native / Read-only / Manual / Degraded / Unsupported)
    And nếu capability < Native, explanation accessible via tooltip hoặc info icon

### AC-M11-002: Publish logs contain required evidence
Source: PRD §23.11 — "publish logs lưu capability snapshot, diagnostics, evidence link"

    Given một publish action đã hoàn tất (thành công hoặc thất bại)
    When user xem publish log entry
    Then log chứa: capability snapshot tại thời điểm publish, diagnostics summary, evidence link
    And log immutable (không thể edit sau khi tạo)

### AC-M11-003: Published state requires proof
Source: PRD §23.11 — "publish state không được đánh dấu published nếu thiếu publish log success hoặc imported proof tương đương"

    Given content item đang trong publish flow
    When publish job completes
    Then state chỉ chuyển sang "Published" nếu có publish log success HOẶC imported proof
    And nếu không có proof, state remains "Pending Verification" hoặc "Manual"
    And no silent state promotion without evidence

---

## M12 — Unified Inbox & Engagement Center

### AC-M12-001: Thread always has owner, intent, status, next action
Source: PRD §23.12 — "thread luôn có owner, intent, status, next action"

    Given một thread tồn tại trong Unified Inbox
    When user xem thread
    Then thread hiển thị: assigned owner (hoặc "Unassigned"), classified intent, current status, suggested next action
    And mỗi field có giá trị (không để trống) — nếu chưa classify, hiển thị "Pending Classification"

### AC-M12-002: Thread can generate content/commercial/CRM tasks
Source: PRD §23.12 — "thread có thể sinh content/commercial/CRM tasks"

    Given user đang xem một thread
    When user nhấn action menu trên thread
    Then options hiển thị: "Create Idea" (→ M05), "Create Offer" (→ M14), "Create Sample Request" (→ M18), "Create Follow-up Task"
    And khi chọn, object mới tạo với link ngược về thread gốc

### AC-M12-003: Thread opens related objects
Source: PRD §23.12 — "thread phải mở được related objects"

    Given thread có related objects (product, order, campaign, idea)
    When user xem thread detail
    Then related objects hiển thị dưới dạng linked cards/chips
    And user click vào related object → navigate đến object detail page

---

## M13 — Product Hub / Inventory / Order Truth

### AC-M13-001: Offer maps to product or product-less offer type
Source: PRD §23.13 — "mọi offer phải map tới product hoặc product-less digital offer rõ ràng"

    Given user tạo một Offer
    When Offer creation form hiển thị
    Then user phải chọn: linked Product HOẶC declare "Product-less Digital Offer" type
    And system không cho phép save Offer mà không có product mapping hoặc type declaration

### AC-M13-002: Every order has source class and lifecycle state
Source: PRD §23.13 — "mọi order phải có source class và lifecycle state"

    Given một Order tồn tại trong system (imported hoặc native)
    When user xem Order detail
    Then Order hiển thị source class (Official / Imported / Inferred)
    And Order hiển thị current lifecycle state (e.g., pending, confirmed, processing, shipped, delivered, cancelled)

### AC-M13-003: Inventory truth connected to stock movement
Source: PRD §23.13 — "inventory truth không được tách silo khỏi stock movement logic"

    Given user xem inventory levels cho một product
    When inventory view hiển thị
    Then current stock level derived từ stock movement ledger (không từ static field)
    And user có thể drill down vào stock movements (in/out/reserved) để verify tính đúng đắn

---

## M14 — Monetization OS

### AC-M14-001: Monetization objects map to operating ledger
Source: PRD §23.14 — "mọi monetization object phải map được về operating ledger scope khi có doanh thu/chi phí phát sinh"

    Given một monetization event phát sinh revenue hoặc cost (offer sold, coupon redeemed, affiliate commission)
    When event processed
    Then corresponding entry tạo hoặc link trong M19 Operating Ledger
    And monetization object detail hiển thị ledger ref khi revenue/cost exists

### AC-M14-002: Monetization surfaces connected to proof/profit
Source: PRD §23.14 — "monetization surfaces không được đứng riêng khỏi proof/profit system"

    Given user xem monetization dashboard (offers, campaigns, links)
    When monetization data hiển thị revenue/performance
    Then data có link/drill-down đến M19 Proof Center
    And revenue figures show source class và confidence badge

### AC-M14-003: Monetization experiment results link to proof
[NEEDS INPUT: PRD §23.14 chỉ có 2 AC bullets. Cần thêm AC cho monetization experiments — "monetization experiments kết quả phải link về proof layer" hoặc AC khác từ sản phẩm.]

---

## M15 — Creator Store / Offers / Membership

### AC-M15-001: Offer lifecycle is clear
Source: PRD §23.15 — "offer lifecycle rõ ràng"

    Given một Offer tồn tại trong Creator Store
    When user xem Offer
    Then Offer hiển thị current lifecycle state (draft, active, paused, expired, archived)
    And state transitions visible trong history/timeline

### AC-M15-002: Product-less offers declare type
Source: PRD §23.15 — "product-less offers phải khai báo rõ loại offer"

    Given user tạo Offer không link đến physical product
    When user chọn "Product-less Offer"
    Then system yêu cầu declare offer type (e.g., digital download, service, membership access, consultation)
    And offer type hiển thị rõ ràng trên storefront và admin views

### AC-M15-003: Store performance links to proof/profit
Source: PRD §23.15 — "store performance nối được về proof/profit layer"

    Given user xem Store performance dashboard
    When performance data hiển thị revenue metrics
    Then metrics có drill-down link đến M19 Proof Center
    And data có source class badge (Official / Imported / Estimated)

---

## M16 — In-Product Affiliate Network

### AC-M16-001: Attributed performance has source class and confidence
Source: PRD §23.16 — "attributed performance phải có source class và confidence"

    Given affiliate link performance data hiển thị
    When user xem attribution report
    Then mỗi attribution entry hiển thị source class (Official / Imported / Inferred)
    And confidence band visible cho inferred attributions

### AC-M16-002: Affiliate payouts connected to ledger
Source: PRD §23.16 — "affiliate payouts/commissions nối được về ledger"

    Given affiliate commission payment processed
    When user xem commission detail
    Then commission entry link đến M19 Operating Ledger cost entry
    And user có thể navigate từ commission → ledger → evidence

### AC-M16-003: Ambiguous attribution labeled correctly
Source: PRD §23.16 — "ambiguous attribution phải hiện là inferred hoặc unreconciled"

    Given attribution data cannot be definitively assigned (multi-touch, missing data)
    When attribution report hiển thị
    Then ambiguous entries labeled "Inferred" hoặc "Unreconciled"
    And không có ambiguous data hiển thị as "Official" or "Verified"

---

## M17 — Live Commerce War Room

### AC-M17-001: Live events leave usable timeline
Source: PRD §23.17 — "live events phải để lại timeline usable"

    Given một live session đã kết thúc
    When user mở post-live view
    Then timeline hiển thị chronological events (segments, highlights, offers pinned, comments surges)
    And timeline interactive (click event → view detail/replay)

### AC-M17-002: Highlights and cues link to live session
Source: PRD §23.17 — "highlight và cue phải link được về live session"

    Given highlights và cue cards tồn tại từ live session
    When user xem highlight hoặc cue card detail
    Then detail hiển thị link về parent live session
    And timestamp within session accessible

### AC-M17-003: Post-live proof/performance view accessible
Source: PRD §23.17 — "post-live proof/performance view mở được"

    Given live session đã kết thúc và performance data available
    When user navigate đến post-live summary
    Then performance view hiển thị: viewers count, engagement rate, revenue attributed, highlights count
    And data links đến M19 proof layer when revenue figures present

---

## M18 — Seeding / Sample CRM

### AC-M18-001: Sample request and shipment have lifecycle state
Source: PRD §23.18 — "sample request và shipment có lifecycle state rõ"

    Given một Sample Request hoặc Sample Shipment tồn tại
    When user xem detail
    Then lifecycle state hiển thị rõ (e.g., request: draft, approved, sent, received, follow_up; shipment: preparing, shipped, delivered, returned)
    And state transition history accessible

### AC-M18-002: Seeding outcomes link to campaign/performance
Source: PRD §23.18 — "seeding outcomes link được về campaign/performance khi có dữ liệu"

    Given seeding campaign has outcome data (creator published content, engagement generated)
    When user xem seeding campaign results
    Then outcomes link đến performance data (publish items, engagement metrics)
    And attribution visible khi data available

### AC-M18-003: Missing proof does not become definitive claim
Source: PRD §23.18 — "missing proof không được biến thành definitive outcome claim"

    Given seeding outcome chưa có verified proof (e.g., creator chưa publish)
    When outcome hiển thị
    Then status labeled "Awaiting Evidence" hoặc "Pending" — KHÔNG "Successful" hay "Completed"
    And no definitive claim made without evidence link

---

## M19 — Operating Ledger / Profit Graph / Proof Center

### AC-M19-001: Money cards have trust metadata
Source: PRD §23.19 — "money cards phải có source class, confidence, last refresh, drilldown"

    Given user xem profit/revenue card trên dashboard
    When card hiển thị
    Then card hiển thị: source class badge, confidence band, last refresh timestamp
    And card có drill-down action → opens evidence/proof detail

### AC-M19-002: Estimates not mixed with official truth
Source: PRD §23.19 — "estimate không được trộn vào Official truth mà không nhãn"

    Given dashboard hiển thị mix of official và estimated financial data
    When user scan financial data
    Then estimated values có distinct visual treatment (different color/badge/label "Estimated")
    And estimated data KHÔNG appear in same column/row as Official data without clear separation

### AC-M19-003: Unreconciled bucket visible
Source: PRD §23.19 — "unreconciled bucket riêng phải hiện rõ"

    Given financial data có unreconciled items (mismatched amounts, missing evidence)
    When user xem financial overview
    Then separate "Unreconciled" section/bucket hiển thị clearly
    And unreconciled items liệt kê với: amount, source, reason not reconciled
    And user có action path để reconcile (link evidence, manual override with reason)

---

## M20 — Workflow Studio

### AC-M20-001: Business-critical side effects have audit trail
Source: PRD §23.20 — "business-critical side effects có audit trail"

    Given workflow chạy action có business-critical side effect (e.g., publish, send email, modify order)
    When action executes
    Then audit event tạo với: action type, target object, timestamp, workflow_run_id, user context
    And audit trail queryable từ Workflow Run detail page

### AC-M20-002: Workflow failures have user-facing explanation
Source: PRD §23.20 — "workflow failures có user-facing explanation"

    Given workflow run gặp failure
    When user xem workflow run detail
    Then failure explanation hiển thị bằng ngôn ngữ user-facing (không raw error codes)
    And explanation bao gồm: what failed, why, suggested fix
    And technical details available via "Show details" expandable section

### AC-M20-003: Capability-aware execution is mandatory
Source: PRD §23.20 — "capability-aware execution bắt buộc"

    Given workflow chứa action yêu cầu specific platform capability (e.g., TikTok direct publish)
    When workflow run đến action step
    Then system check capability status trước khi execute
    And nếu capability = Degraded/Unsupported, action skips với explanation và triggers fallback path
    And workflow KHÔNG silently fail do missing capability

---

## M21 — Workflow Marketplace / Recipe Economy / Agent Center

### AC-M21-001: Installed recipe maps to canonical objects
Source: PRD §23.21 — "installed recipe phải map được về canonical workflow/agent objects"

    Given user install recipe từ marketplace
    When installation completes
    Then recipe creates canonical Workflow object trong workspace
    And Workflow object trackable trong M20 (runs, logs, diagnostics)
    And source recipe template ref preserved

### AC-M21-002: Recipe/agent does not break auditability
Source: PRD §23.21 — "recipe/agent không được phá auditability"

    Given recipe/agent đang chạy actions
    When actions execute
    Then mỗi action lưu audit event theo cùng standard với manual actions
    And agent-initiated actions tagged "agent" trong audit trail
    And no action bypasses audit logging

### AC-M21-003: Dependencies and required capabilities explained
Source: PRD §23.21 — "dependencies và required capabilities phải được giải thích rõ"

    Given user xem recipe detail trước khi install
    When recipe info page hiển thị
    Then required capabilities listed (e.g., "Requires TikTok Native Publish", "Requires Pro tier")
    And dependencies listed (e.g., "Requires M08 Continuity OS character", "Requires connected Shopee account")
    And missing dependencies highlighted với resolution guidance

---

## M22 — Capability Matrix & Policy Center

### AC-M22-001: Degraded/unsupported actions have explanation
Source: PRD §23.22 — "mọi degraded/unsupported action mở được explanation"

    Given platform action có capability = Degraded hoặc Unsupported
    When user attempt action hoặc encounter degraded feature
    Then explanation panel mở được (click info icon hoặc inline message)
    And explanation chứa: reason, platform constraint, suggested alternative

### AC-M22-002: Policy notes accessible from action context
Source: PRD §23.22 — "policy notes và fallback paths truy được từ action context"

    Given user đang thực hiện action liên quan đến platform policy
    When action context hiển thị
    Then relevant policy note accessible via inline link hoặc tooltip
    And fallback path hiển thị nếu primary action unavailable

### AC-M22-003: Capability state not hidden from user
Source: PRD §23.22 — "capability state không bị giấu khỏi user"

    Given connected account có capability limitations
    When user navigate đến any feature affected by capability
    Then capability state visible (Native / Read-only / Manual / Degraded / Unsupported)
    And state indicator shown consistently across all affected surfaces
    And system KHÔNG hide limitations to create false impression of full functionality

---

## M23 — Reporting / Admin / Billing / Diagnostics

### AC-M23-001: Admin/support does not break canonical truth
Source: PRD §23.23 — "admin/support không phá canonical truth"

    Given admin user perform override action (e.g., adjust billing, modify user data)
    When override executes
    Then canonical truth preserved (override recorded as overlay, original data retained)
    And override does NOT silently modify canonical object without trace

### AC-M23-002: Override tools require reason and audit trail
Source: PRD §23.23 — "override tools phải có reason và audit trail"

    Given admin uses override tool
    When admin submits override
    Then system requires reason text input (mandatory field)
    And audit event created: override type, target, old value, new value, reason, admin user, timestamp
    And audit trail queryable from admin console

### AC-M23-003: Diagnostics hierarchy usable for non-technical user
Source: PRD §23.23 — "diagnostics hierarchy usable cho non-technical user trước khi đến engineering logs"

    Given user encounters issue and opens diagnostics
    When diagnostics view loads
    Then first layer shows plain-language explanation (e.g., "Your TikTok connection stopped working 2 hours ago")
    And second layer shows operator-level details (e.g., "OAuth token expired, re-authorize needed")
    And third layer (expandable) shows engineering trace logs
    And user can resolve issue from first layer without needing to understand technical details

### AC-M23-004: Internal admin site fully separated
Source: PRD §23.23 — "internal admin site hoàn toàn tách biệt khỏi main app (separate auth, VPN access, internal RBAC)"

    Given internal admin (admin.creativanta.app) deployed
    When admin user accesses internal admin site
    Then auth system separate from main app (does NOT use main app's Clerk auth)
    And access requires VPN connection
    And RBAC uses internal role/permission system (separate from workspace RBAC)
    And no cross-authentication possible between main app and internal admin

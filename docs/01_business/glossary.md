---
layer: business
canonical: true
source: screen_shared_glossary.md, creativanta_prd_v_3_1_revised_part_1.md, creativanta_prd_v_3_1_revised_part_2.md
last_updated: 2026-04-11
---

# Glossary

> Bảng thuật ngữ canonical cho Creativanta. Entries sắp xếp theo alphabet.
> Canonical naming (M01–M23) per [product_overview.md](./product_overview.md).
> DB fields chỉ liệt kê canonical enum — chi tiết schema: `04_contracts/database_schema.md`

---

## Core System Terms

| Term | Module | Definition |
|---|---|---|
| **One Graph** | Cross-cutting | Nguyên tắc: mọi data quan trọng nằm trong cùng một graph thống nhất. Không data silo. |
| **Operator Mode** | Cross-cutting | Chế độ vận hành thay đổi UX emphasis (Creator, Seller, Affiliate, Live, Agency, Brand). 6 modes canonical. Mode KHÔNG cắt domain scope. DB: `workspaces.default_operator_mode` |
| **Source Class** | Cross-cutting | Phân loại nguồn gốc dữ liệu. Enum: `official` · `imported` · `inferred` · `estimated` · `unreconciled`. UI badge phải map về 5 lớp này. |
| **Confidence Band** | Cross-cutting | Mức độ tin cậy của insight/metric. Enum: `high` · `medium_high` · `medium` · `low_medium` · `low`. Phải giải thích lý do. |
| **Verification Status** | Cross-cutting | Trạng thái xác minh dữ liệu. Enum: `verified` · `re_verify` · `pending` · `failed` |
| **Capability State** | M22 | Trạng thái khả năng thực thi action trên platform. Enum: `native` · `read_only` · `manual` · `degraded` · `unsupported`. Phải luôn visible. |
| **Reconciliation State** | M19 | Trạng thái đối soát tài chính. Enum: `fully_reconciled` · `partially_reconciled` · `awaiting_evidence` · `imported_only` · `inferred_pending_confirmation` · `conflict_detected` · `manually_overridden` |
| **Workspace** | Cross-cutting | Đơn vị tổ chức cấp cao nhất — chứa mọi data, members, settings. Cross-workspace data isolation bắt buộc. |
| **Connected Account** | M22, M23 | Tài khoản platform bên thứ ba đã liên kết qua OAuth. Tokens encrypted at rest. |
| **Diagnostics Record** | M20, M22, M23 | Bản ghi chẩn đoán khi có lỗi/degradation. User-facing explanation trước technical detail. |
| **Audit Event** | M20, M21, M23 | Bản ghi bất biến (immutable) về mọi state change quan trọng. Phục vụ compliance, security. |
| **Metering Record** | M23 | Bản ghi đo lường usage (AI credits, API calls, storage). Input cho billing. |
| **Add-on Module** | M23 | Gói mở rộng mua ngoài subscription tier. VD: Commerce Intelligence, Continuity Pro. |

---

## Intelligence & Decision (M01–M04)

| Term | Module | Definition |
|---|---|---|
| **Daily Brief** | M01 | Bản tin vận hành đầu ngày — 3–7 cards quan trọng nhất. Selection: impact × urgency × effort × mode weight. |
| **Decision Card** | M01, M04 | Card hiển thị opportunity/risk cần quyết định. Mỗi card phải có 1 primary action rõ ràng. |
| **Alert** | M01, M02 | Thông báo tự động khi sự kiện quan trọng cần user action. Priority: Urgent → High → Normal → Low. |
| **Signal** | M02 | Tín hiệu thô từ thị trường (search spike, trending topic, price move). Raw input cho Trend. |
| **Trend** | M02 | Xu hướng đã normalize từ signals. Phải có velocity, freshness, saturation scoring, confidence. |
| **Watchlist** | M02, M03 | Danh sách theo dõi trends/competitors/products. Kích hoạt alerts khi có thay đổi. |
| **Benchmark Snapshot** | M03 | Ảnh chụp performance metrics tại thời điểm cụ thể. Inferred insights phải gắn nhãn. |
| **Product Opportunity** | M03, M04 | Cơ hội kinh doanh gắn với sản phẩm cụ thể, từ competitor intelligence hoặc trend analysis. |
| **Opportunity** | M04 | Cơ hội kinh doanh từ signal/trend/research. Bắt buộc: title, source refs, priority, owner, status, confidence. |
| **Expected Impact Model** | M04 | Mô hình ước tính tác động (revenue, growth, profit). Phải có confidence context. |
| **Expected Effort Model** | M04 | Mô hình ước tính công sức cần thiết. Dùng cùng Impact Model cho prioritization. |

---

## Content Creation (M05–M06)

| Term | Module | Definition |
|---|---|---|
| **Idea** | M05 | Ý tưởng content/commerce từ signal, trend, comment, hoặc product. Bắt buộc: source refs, hook/angle/audience/goal, state. |
| **Angle** | M05 | Góc tiếp cận content — cách frame thông điệp cho audience cụ thể. Một idea có thể có nhiều angles. |
| **Hook** | M05, M06 | Câu/hình mở đầu thu hút attention trong 3s đầu. Hook bank lưu mẫu proven effective. |
| **Objection Pattern** | M05 | Mẫu phản đối thường gặp từ audience, feed vào Idea Engine cho objection-led ideation. |
| **Script** | M06 | Kịch bản content có cấu trúc — hook, body, CTA, disclosure. Bắt buộc: idea link, format type, CTA blocks, status. |
| **Scene** | M06 | Phân cảnh trong script — đơn vị cấu thành shot list. |
| **Shot List** | M06 | Danh sách shot cần quay/generate. Link: Script → Scene decomposition. |
| **Asset Brief** | M06, M07 | Mô tả yêu cầu production cho asset. Link bắt buộc tới Script. Chứa continuity refs nếu có. |
| **CTA** | M06, M10 | Call to Action — lời kêu gọi hành động. Phải có trong script. Placement dựa trên retention curve. |

---

## AI Production & Continuity (M07–M09)

| Term | Module | Definition |
|---|---|---|
| **Asset** | M07, M08 | Sản phẩm media (video, image, audio). Bắt buộc: asset type, source provider, lineage refs, quality/approval status. |
| **Clip** | M07, M09 | Đoạn video ngắn cắt từ video dài hơn. Lineage link về source asset mandatory. |
| **Variant** | M07, M09 | Phiên bản khác của asset (format, CTA, platform khác). Phải rõ purpose và target channel. |
| **Virality Score** | M07 | Điểm dự đoán viral potential (0–100). Engagement (30%) + hook (25%) + pacing (20%) + audio (15%) + trend (10%). |
| **Style Pack** | M07, M08 | Bộ style editing (color grade, transition, caption style, pacing) từ AI analysis. Continuity OS component. |
| **Prompt Lineage Record** | M07, M08 | Lịch sử prompt dùng để generate AI content. Truy vết: human → AI → human review → output. |
| **Character** | M08 | Nhân vật AI (digital twin, AI generated, stock). Slots per tier: Free 1, Starter 2, Pro 5, Business 15. |
| **Character Pack** | M08 | Bộ tham chiếu hình ảnh + voice + personality cho continuity. Tự động tạo khi hoàn thành Character Builder. |
| **Brand Pack** | M08 | Bộ tài nguyên thương hiệu (fonts, colors, logo, tone, guidelines) cho AI production. Continuity OS component. |
| **Voice Pack** | M08 | Bộ tham chiếu giọng nói cho Character. Voice clone cần consent verification. Slots gating per tier. |
| **Lookbook** | M08 | Bộ visual references được approve cho Character/Brand. Dùng cho continuity QA. |
| **Scene Memory** | M08 | Bộ nhớ scene context cho AI continuity (bối cảnh, vị trí, ánh sáng). |
| **Continuity Rule** | M08 | Quy tắc đảm bảo AI output nhất quán xuyên assets. Violations tạo Continuity Violation record. |
| **Continuity Violation** | M08 | Bản ghi khi AI output drift khỏi canonical references. Phải cảnh báo user. |
| **A/B Test** | M10, M07 | Thí nghiệm so sánh hai version. Áp dụng cho content variants, thumbnails, hooks, CTAs. |
| **Experiment** | M10, M07 | Thí nghiệm A/B hoặc multivariate. Kết quả phải link về performance evidence. |
| **Packaging Checklist** | M10 | Danh sách kiểm tra trước publish — hook, title, CTA, disclosure, format. Mọi publish phải qua QA panel. |

---

## Publish & Distribution (M11)

| Term | Module | Definition |
|---|---|---|
| **Publish Item** | M11 | Đơn vị nội dung sẵn sàng publish. Bắt buộc: capability snapshot ref, publish mode, publish state. |
| **Publish Job** | M11 | Công việc publish đang chạy/hoàn thành. Bắt buộc có state machine. |
| **Publish Log** | M11 | Bản ghi kết quả publish. Bắt buộc: publish item ref, attempted_at, capability snapshot, result status. |
| **Queue Item** | M11 | Item đang chờ trong hàng đợi. Có priority, estimated processing time. |
| **Capability Snapshot** | M11, M22 | Bản ghi trạng thái capability của platform tại thời điểm execution. |
| **Approval Request** | M11, M20 | Yêu cầu phê duyệt (script, asset, publish, workflow). Approval boundaries phải rõ ràng. |

---

## Engagement & Inbox (M12)

| Term | Module | Definition |
|---|---|---|
| **Thread** | M12 | Chuỗi tương tác (comment, DM, inquiry) gom theo context. Bắt buộc: owner, intent, status, next action. State machine required. |
| **DM** | M12 | Direct Message — tin nhắn riêng từ platform. Thuộc Thread object family. |
| **Person / Entity** | M12 | Người/tổ chức tương tác với workspace qua inbox. Normalized identity across platforms. |
| **Intent** | M12 | Ý định của người gửi (buy, ask, complain, collaborate). AI classifies; link về Thread. |
| **Inquiry** | M12 | Tin nhắn hỏi thăm từ potential customer/partner. |
| **Sponsor Inquiry** | M12 | Tin nhắn từ brand/sponsor muốn hợp tác. Route vào Brand Collaboration Mode. |
| **Suggested Reply** | M12 | Gợi ý trả lời từ AI. User phải review trước gửi. |
| **Follow-up Task** | M12, M18 | Task tiếp theo sau engagement/interaction. Bắt buộc: owner, deadline, status. |

---

## Commerce & Monetization (M13–M18)

| Term | Module | Definition |
|---|---|---|
| **Product** | M13 | Sản phẩm commerce (physical, digital, service). Canonical entity — SKU, variants, inventory link. |
| **SKU** | M13 | Stock Keeping Unit — đơn vị quản lý tồn kho cho product variant. |
| **Order** | M13 | Đơn hàng từ customer. Bắt buộc: source class, lifecycle state, amount/currency. State machine required. |
| **Refund** | M13 | Hoàn tiền cho đơn hàng. State machine required. Impact tới profit phải tính. |
| **Stock Movement** | M13 | Bản ghi di chuyển tồn kho (nhập, xuất, điều chuyển, trả). Link về Inventory Location. |
| **Offer** | M14, M15 | Đề xuất thương mại (sản phẩm, deal, coupon, membership). Phải map về Product HOẶC khai báo product-less. |
| **Campaign** | M14, M16 | Kế hoạch marketing có mục tiêu, thời gian, budget. Phải nối về Order/Settlement/Cost/Profit (RULE-007). |
| **Lead** | M14 | Khách hàng tiềm năng từ engagement/content. Link về Thread, Content, Offer. |
| **Conversion Event** | M14 | Sự kiện chuyển đổi (click → purchase, view → lead). Link về source. |
| **Coupon** | M14, M15 | Mã giảm giá gắn với Offer/Product. Track usage, conversion attribution. |
| **Store Page** | M15 | Trang cửa hàng trưng bày offers/products. Performance nối về proof/profit layer. |
| **Bundle** | M15 | Gói nhiều sản phẩm/offers bán cùng nhau. Link về từng product thành phần. |
| **Membership Plan** | M15 | Gói thành viên có phí. Phải khai báo: product-backed hay product-less. |
| **Price Rule** | M15 | Quy tắc định giá (discount, tier pricing, regional pricing). |
| **Promotion Rule** | M15 | Quy tắc khuyến mãi tự động (buy X get Y, seasonal discount). |
| **Affiliate Link** | M16 | Link tracking gắn với creator/affiliate. Phải có source class và confidence khi report. |
| **Affiliate Statement** | M16 | Báo cáo hoa hồng affiliate. Phải reconcile với ledger — unreconciled phải hiện rõ. |
| **Click Event** | M16 | Sự kiện click trên affiliate link/CTA. Đếm cho attribution. |
| **Commission** | M16, M19 | Hoa hồng affiliate/creator từ giao dịch thành công. Link về Order + Campaign + Creator. |
| **Creator Assignment** | M16, M18 | Giao việc cho creator (seeding, campaign). Track status, outcome. |
| **Cue Card** | M17 | Card chỉ dẫn cho live session (talking points, offers, timing). Link về Live Session. |
| **Highlight** | M17 | Điểm nhấn trong live session (moment quan trọng). Link về Live Session + Live Segment. |
| **Live Session** | M17 | Phiên live commerce với timeline, cues, offers, engagement. State machine required. |
| **Live Segment** | M17 | Đoạn thời gian trong live session có mục đích cụ thể. |
| **Sample Request** | M18 | Yêu cầu gửi mẫu sản phẩm cho creator/KOL. State machine required. |
| **Sample Shipment** | M18 | Bản ghi gửi mẫu sản phẩm (tracking, status). State machine required. |

---

## Finance & Proof (M19)

| Term | Module | Definition |
|---|---|---|
| **Profit Snapshot** | M19 | Tổng hợp profit — gross, net, margin, by dimensions. Bắt buộc: source class, confidence, proof path. |
| **Margin Snapshot** | M19 | Ảnh chụp biên lợi nhuận. Compound metric: revenue − all cost layers. |
| **Evidence Object** | M19 | Bằng chứng hỗ trợ claim (screenshot, API data, receipt). Bắt buộc: evidence type, payload ref, source provenance, collected_at. |
| **Proof Bundle** | M19 | Gói bằng chứng tổng hợp. Bắt buộc: claim scope, supporting evidence refs[], coverage summary. |
| **Settlement** | M19 | Bản thanh toán từ platform/partner (gross/net, fees). Phải reconcile với orders. Source class mandatory. |
| **Reconciliation Record** | M19 | Bản ghi đối soát (revenue, payout, order, cost). State machine required. 7 states canonical. |
| **Cost Item** | M19 | Khoản chi phí (ads, AI, shipping, service). Bắt buộc: cost type, amount, currency, scope, source class. |
| **COGS** | M19 | Cost of Goods Sold — giá vốn hàng bán. User input 1 lần per product. |
| **Creator Payout** | M19 | Khoản thanh toán cho creator (commission, salary, bonus). Nối về ledger, reconciliation. |
| **Invoice** | M19 | Hóa đơn (sponsor deals, services). Link về Campaign, Creator Payout. |
| **ROAS** | M19, M23 | Return on Ad Spend — tỷ lệ lợi nhuận trên chi phí quảng cáo. |
| **RPM** | M19, M23 | Revenue Per Mille — doanh thu trên 1.000 views. Benchmark ngành: 30–80K VND. |
| **CPM** | M19, M23 | Cost Per Mille — chi phí cho mỗi 1.000 hiển thị quảng cáo. |
| **CTR** | M19, M23 | Click-Through Rate — tỷ lệ click trên số lượt hiển thị. Phải có source class. |
| **ARPU** | M19, M23 | Average Revenue Per User. KPI quan trọng cho subscription business. |

---

## Automation & Policy (M20–M22)

| Term | Module | Definition |
|---|---|---|
| **Workflow** | M20 | Quy trình tự động: triggers, conditions, actions, approvals. Capability-aware, auditable, fallback + retry. |
| **Workflow Run** | M20 | Một lần thực thi workflow. State machine, action logs, audit trail required. |
| **Trigger Event** | M20 | Sự kiện kích hoạt workflow tự động. Configurable per workflow. |
| **Action Log** | M20, M21 | Bản ghi chi tiết mọi hành động trong workflow/agent run. Bắt buộc cho auditability. |
| **Agent Run** | M21 | Một lần thực thi agentic (AI tự lập kế hoạch + multi-step). Audit trail, action logs, side-effect summary required. |
| **Recipe Template** | M21 | Workflow/process template có thể cài đặt và tái sử dụng. Map về canonical objects. |
| **Fallback Path** | M22 | Hướng dẫn thay thế khi action không thể thực hiện native. Hiện cho user khi degraded/unsupported. |
| **Policy Note** | M22 | Ghi chú chính sách platform ảnh hưởng đến action/capability. Truy cập được từ action context. |

---

## User Segments

| Term | Definition |
|---|---|
| **KOC / KOL** | Key Opinion Consumer / Key Opinion Leader — người có ảnh hưởng. User segment, không phải system entity riêng. |
| **Micro Creator** | Segment: <10K followers, beginner. Sử dụng Free/Starter tier. |
| **Mid-tier Creator** | Segment: 10K-100K followers, growing. Sử dụng Pro tier. |
| **Macro Creator** | Segment: 100K-1M followers, established. Sử dụng Pro/Business tier. |
| **Brand Account** | Segment: corporate/brand entity, uses workspace for affiliate management, seeding. Business/Enterprise tier. |
| **Agency** | Segment: manages multiple creators, multi-workspace setup. Enterprise tier. |
| **Affiliate-only** | Segment: creators focused solely on affiliate revenue. Starter+ tier. |
| **Cross-platform Creator** | Segment: active on 3+ platforms simultaneously. Pro+ tier recommended. |

---

## Gamification & Engagement

| Term | Module | Definition |
|---|---|---|
| **XP (Experience Points)** | Gamification | Điểm kinh nghiệm tích lũy từ hành động trên hệ thống. Dùng để mở khóa achievements, không đổi được credits. |
| **Streak** | Gamification | Chuỗi ngày liên tiếp user hoạt động trên hệ thống. Reset nếu miss 1 ngày. |
| **Achievement** | Gamification | Thành tựu mở khóa khi đạt milestone. Ví dụ: "First Video" (M07), "10-Day Streak", "First Sale" (M13). |
| **Challenge** | Gamification | Thử thách có thời hạn (daily/weekly/monthly). Hoàn thành nhận XP bonus. |
| **Creator Score** | Gamification | 0-100 composite score dựa trên: content quality, engagement, revenue, consistency. Non-financial REAL. |
| **Referral** | M23/Billing | Chương trình giới thiệu: referrer nhận credit bonus khi referee subscribe paid tier. Tier-based rewards. |
| **Referral Tier** | M23/Billing | Cấp độ referrer dựa trên số lượng successful referrals. Recalculated monthly. |

---

## Packaging & QA (M10)

| Term | Module | Definition |
|---|---|---|
| **Packaging Score** | M10 | 0-100 composite score đánh giá chất lượng packaging (thumbnail, caption, hook, tags, CTA). Non-financial REAL. |
| **Compliance Scan** | M10 | Tự động kiểm tra content vi phạm platform guidelines trước khi publish. Result: pass, pass_with_warnings, review_required, blocked. |
| **Proof Graph** | M19/System | Bộ liên kết chứng minh từ: trend signal → idea → script → content → publish → order → profit. Traceability chain. |
| **Operating Loop** | M01/System | Chu kỳ: Intelligence → Creation → Production → Publish → Engagement → Commerce → Finance → Repeat. Core business cycle. |
| **Full Product Scope, Delivered by Phase** | Business | Toàn bộ chức năng được giữ lại; giao dần theo phase và nghiệm thu đầy đủ ở P8. Xem product_overview.md và IMPLEMENTATION_ORDER.md. |

---

> **Tổng: 133 entries** | Glossary này sẽ được cập nhật khi downstream docs bổ sung thêm terms.

---
layer: index
canonical: false
last_updated: 2026-10-30
---

# Review sản phẩm, tài liệu và mức sẵn sàng build — 2026-10-30

## Chuyển backend sang Go — 2026-10-30

Theo yêu cầu chủ sản phẩm, API/admin API, worker và runtime workflow chuyển sang Go. [ADR-015](../05_system/tech_stack_adr.md#adr-015-product-owner-migration-to-go--2026-10-30) sở hữu lựa chọn và quy tắc triển khai. Đã đồng bộ codegen Go/TS/Dart, pgx/sqlc, Goose SQL migrations, decimal, queue/provider interfaces, FFmpeg workers, CI/dev và cấu hình agent. Không thay đổi phạm vi/chức năng hoặc dependency P0–P8; task/hash maps được sinh lại. Các con số hiệu năng Rust trước đây không phải benchmark và đã rút khỏi căn cứ sizing.

Kết quả kiểm tra riêng cho lần chuyển đổi nằm ở [Go migration evidence](../06_quality_ops/evidence/2026-10-30-go-migration/run_summary.json). Bằng chứng review trước đó giữ nguyên giá trị lịch sử; chưa có ứng dụng Go được compile hoặc chạy nghiệm thu trong lượt sửa docs này.

## 1. Kết luận

**Có thể bắt đầu build P0 theo từng task đã định nghĩa. Chưa có cơ sở gọi sản phẩm là đã triển khai, đã nghiệm thu hay sẵn sàng production.** Bộ docs sau review giữ đủ 31 feature/spec, sáu operator mode, các chức năng cũ và phần mở rộng được đề xuất/giữ lại; có backlog và kiểm tra để agent không âm thầm làm mất phạm vi.

Ý tưởng đáng kiểm chứng nhất là chuỗi nội dung → thương mại → chi phí/lợi nhuận có bằng chứng. Phạm vi rộng giúp tạo một hệ vận hành thống nhất, nhưng cũng là rủi ro lớn về thời gian, độ đúng của dữ liệu, chi phí AI, hỗ trợ khách hàng và quyền API. Ưu tiên chứng minh giá trị qua import-to-profit và các vòng vận hành thật, rồi mở rộng sản xuất/automation. [Chiến lược và kế hoạch kiểm chứng](../01_business/product_strategy_validation.md) có nhận định, nguồn đối chiếu và thí nghiệm cụ thể; đây chưa phải bằng chứng nhu cầu hoặc willingness-to-pay.

## 2. Phạm vi review và giới hạn bằng chứng

Đã đọc các tài liệu bắt buộc; đối chiếu scope/rules/AC của các feature với phase, contract và các luồng rủi ro cao. Checker kiểm tra toàn bộ liên kết Markdown active, inventory API/bindings, các bất biến schema và bản đồ source/task. Screen được kiểm kê đầy đủ, sửa owner sai và các surface liên quan; không coi kiểm kê là đã kiểm thử tương tác từng màn hình.

Baseline trước sửa: checker hiện có đã PASS dù vẫn có mâu thuẫn nghiệp vụ bên dưới. Điều này cho thấy lint không thay thế review. Review này bổ sung các kiểm tra hồi quy cụ thể, không tuyên bố đã chứng minh ngữ nghĩa mọi field của toàn bộ RPC inventory. Các message `.proto`, migration chạy được và kiểm thử UI/API/worker phải được tạo và chạy ở D1–D5 của từng slice.

Không chỉnh sửa `docs/09_archive/`. Không xóa feature hoặc mode để làm pass. Giữ các file cá nhân chưa được Git theo dõi có sẵn trước review.

## 3. Các vấn đề đã sửa

| Nhóm | Vấn đề trước review | Kết quả trong docs |
|---|---|---|
| Tồn kho — CRITICAL | M13 gọi `inventory_locations.current_stock`, `SUM(delta)` không tồn tại; giữ chỗ chưa có bản ghi bền vững | Hợp đồng inventory riêng, balance theo SKU/location, reservation, movement identity, baseline import, locking/expiry/replay và 10 fixtures |
| State/permission | Capability AC trả unknown/supported dù schema có năm giá trị khác; deal AC dùng tên cũ; partial refund coi là terminal; Copilot báo sai quyền xóa | Đồng bộ AC/rules/transition và binding; giữ nguyên chức năng |
| Safety và trust | Phishing có đường override bằng AUP; rights/disclosure block có thể bỏ qua; remix có hai ngưỡng | Cấm bypass hard blocks, giữ appeal/false-positive có evidence; thống nhất heuristic originality |
| AI/retry | Circuit breaker có thể gây retry khi outcome chưa rõ; lineage/credit dễ hiểu sai | Reconcile trước resubmit; quote/consent ceiling và provider lineage đúng từng attempt |
| Experiments | Feature/QA chọn winner tự động dù ít dữ liệu; hợp đồng API đã yêu cầu evidence | Inconclusive, denominator/freshness, observational label và recheck trước scale |
| Dependency | M02/M05/M07 và các expansion được hoàn tất trước chức năng chúng cần | Sửa completion phases, phân rã 60 task có DAG; delivery và acceptance tách rõ |
| Onboarding | Đòi connector/full loop trước khi có giá trị; hoàn tất cá nhân dùng quyền workspace-admin | Import-first và phased guidance; progress theo user/workspace; permission user:self |
| Import/ops | Dedup thiếu account scope, quota ví dụ bị hiểu là quyền thật, event không có trong catalog, DLQ cleanup xóa quá rộng, jitter âm | Dùng contract nguồn chuẩn, preview/commit/repair, không xóa unresolved effect, không publish sớm |
| Templates | Recipe chỉ có adapter template ID, thiếu body cho owned runtime | Portable versioned graph/style snapshot, clone vào tenant và install có quyền |
| Screen ownership | Nhiều header dùng module cũ cho inbox/affiliate/store/Creator Pro | Sửa 23 header ownership; map mọi screen tới feature/task, thêm hai screen cho directory/contracts |
| Bảo toàn phạm vi | Các mục deferred/future khó tìm owner và mốc hoàn tất | Competitor monitoring, CRM/templates/discovery và style sharing có task P8, contract và AC |

Chi tiết severity và runtime gates còn phải đạt nằm trong [Open Blockers](OPEN_BLOCKERS.md); registry nguồn chuẩn ở [Canonical Sources](CANONICAL_SOURCES.md).

## 4. Các cải thiện chức năng đã đưa vào phạm vi

- Nhận giá trị sớm qua dữ liệu được phép nhập/manual; đủ năm bước full loop vẫn được giữ.
- Hiển thị độ phủ bằng chứng và danh sách việc cần sửa để tin con số, với quyền truy cập đúng từng đối tượng.
- Xem trước đầu vào, chi phí trần và tùy chọn thử một đầu ra trước batch AI.
- Thí nghiệm có kết quả “chưa đủ bằng chứng”, không ép chọn winner hoặc hứa tăng doanh thu.
- Workflow xem trước hành động/quyền/budget; thay đổi phiên bản/target làm hết hiệu lực approval cũ.
- Hoàn thiện các mở rộng đã được nhắc trong docs: monitoring có nguồn được phép, style-template sharing, brand kanban, versioned contract evidence và creator directory có opt-in.

Behavior nằm ở feature owners; persisted fields ở schema; wire fields/commands ở API behavior; registry permission và task/screen đã được cập nhật. [Product Strategy](../01_business/product_strategy_validation.md#6-cải-thiện-được-đưa-vào-build) liên kết từng owner để tránh thêm một bản đặc tả trùng lặp.

## 5. Bộ bàn giao cho AI Agent

| Tài liệu | Công dụng |
|---|---|
| [Implementation Order](IMPLEMENTATION_ORDER.md) | Chín phase P0–P8 và thời điểm hoàn tất từng module |
| [Agent Build Backlog](AGENT_BUILD_BACKLOG.md) | Quy trình nhận task, tách slice, giữ scope và handoff |
| [60 task cards](AGENT_TASK_CARDS.md) | Đầu ra, dependency, reading path và acceptance của từng task |
| [Task catalog](agent_task_catalog.json) | Nguồn máy đọc được của task/DAG/owner |
| [Requirement map](requirement_task_map.csv) | 1.333 source units từ feature và AC gốc, có dòng/hash và task |
| [Screen map](screen_task_map.csv) | 245 screen, gồm 243 screen cũ và hai screen mới, có owner/task/hash |
| [Build Execution Contract](BUILD_EXECUTION_CONTRACT.md) | Packet, trạng thái SPECIFIED → CONTRACT_READY → IMPLEMENTED → ACCEPTED → LAUNCH_APPROVED |

Source units gồm cả phần ngữ cảnh/tham chiếu; con số 1.333 không có nghĩa có 1.333 test tự động hay 1.333 feature độc lập. Mỗi unit chứa nhiều hành vi phải được agent phân rã tiếp trong packet và nghiệm thu đủ. Map có hash để phát hiện drift, không thay cho đánh giá chất lượng.

Bắt đầu P0-01; dependency đã đủ bằng chứng mới nhận task tiếp. Phase là gate chất lượng, không phải cam kết số tuần. Không có app, provider approval hoặc codegen được dựng giả để đóng task trong lượt review tài liệu này.

## 6. Kiểm chứng và bằng chứng lưu lại

[Thư mục evidence](../06_quality_ops/evidence/2026-10-30-docs-review/run_summary.json) lưu command, exit code, timestamp, Git baseline và đường dẫn log. Các bước kiểm tra:

- `python3 tooling/build_plan.py`: DAG, source hash, đủ 31 owner, completion phase và generated task cards.
- `python3 tooling/check_docs.py --json`: liên kết, schema/RLS/FK được kiểm tra, permission bindings, phase, fixtures và regression guards.
- `python3 -m unittest discover -s tooling/tests -v`: 20 tests, gồm tái đưa lỗi quyền, RLS/FK, stock identity, public grants/policy bypass, capability, phishing, source drift và dependency cycle.
- `python tooling/check_docs.py --sql --json` với pglast 8.7: parse SQL contract và seed; không thực thi PostgreSQL.
- `git diff --check` và kiểm tra archive diff: whitespace sạch và không sửa archive.

Môi trường Python mặc định ban đầu thiếu pglast; đã cài đúng dependency đã pin trong virtualenv tạm để chạy bước SQL. Không coi việc thiếu thư viện ở lần thử đầu là một lần SQL pass.

## 7. Gate còn lại khi build/launch

Typed transport, migration/seed trên PostgreSQL thật, concurrency/replay, security, accessibility, load/restore/rollback và acceptance web/mobile chưa chạy vì repository vẫn đang ở giai đoạn đặc tả. Quyền API production, credential, model/rate/license, payment onboarding và legal sign-off cần bằng chứng bên ngoài. Demand, mức giá khách hàng chấp nhận và chi phí vận hành cũng cần thử nghiệm thật.

Các gate này có nơi sở hữu và task xử lý; chúng không được thay bằng nhãn “READY” trong docs. Kết luận của review là sẵn sàng bắt đầu thực thi có kiểm soát theo backlog, với đầy đủ phạm vi được theo dõi.

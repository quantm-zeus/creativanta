---
layer: index
canonical: false
last_updated: 2026-10-29
---

# Bản ghi hoàn thiện tài liệu — 2026-10-29

## Quyết định sản phẩm

Giữ toàn bộ chức năng: 23 module, auth, 7 mục feature/spec và 6 operator mode. Giao dần qua P0–P8; mọi chức năng phải có bằng chứng nghiệm thu ở phase hoàn thiện. Quyết định của chủ sản phẩm thay thế yêu cầu hoạt động đồng thời từ ngày đầu. [Implementation Order](IMPLEMENTATION_ORDER.md) là nguồn chuẩn về phạm vi từng phase; tài liệu này chỉ là bản ghi kiểm tra.

## Các nhóm đã sửa

- Tenant/security: tài khoản runtime tách migration/admin/outbox; grant hẹp; RLS trực tiếp trên bảng liên kết; FK cùng tenant; discovery workspace cho thành viên; dữ liệu cá nhân/internal note; guard evidence bất biến.
- Credit/pricing: báo giá theo chi phí provider, rate version, biên tối thiểu và trần đã xác nhận; lot theo nguồn; reservation lưu DB; xử lý replay/restart/late result; cache là projection.
- Finance: snapshot thuế/tỷ giá/giá vốn; thời điểm ghi nhận doanh thu; postings và reversal; không đếm hai lần settlement/fee/refund; đối soát từng phần và bộ F01–F09 có kết quả tính độc lập.
- API/auth/RBAC: cơ chế Clerk đúng vai trò; binding permission/hành vi cho mọi RPC; command input/validation/error/replay; typed contract gate trước endpoint/UI; billing Owner-only; sửa screen nhạy cảm.
- State/data model: đồng bộ seeding/brand deal/capability/subscription; membership subscriber/entitlement; tiến độ gamification theo người dùng; rotation identity; bỏ DDL skus/commissions đã bị thay thế; sửa index trùng tên.
- Provider/workflow: quyền thực tế theo app/account/action; fallback minh bạch; baseline canvas/runtime riêng; Activepieces embedding chỉ bật khi có license/edition được xác minh.
- Ops: outbox/inbox và external effects; không retry mù khi kết quả chưa rõ; pipeline fail-closed; smoke nghiệp vụ bắt buộc; staging/prod tách biệt; rollback tương thích schema.
- Handoff: source registry, feature status, phase matrix và quy tắc agent thống nhất; không dùng nhãn READY để suy ra code/test/launch đã đạt.

Chi tiết và nguồn chuẩn: [Canonical Sources](CANONICAL_SOURCES.md). Lịch sử/điều kiện bên ngoài: [Open Blockers](OPEN_BLOCKERS.md).

## Kiểm tra đã thực hiện

- `python3 tooling/check_docs.py`: kiểm tra liên kết nội bộ, phạm vi 31 mục, phase projection, binding đủ RPC, tên permission, một số bất biến schema/RLS/FK/credit/state và JSON fixtures.
- `python3 -m unittest discover -s tooling/tests -v`: 10 regression tests, gồm đưa lỗi credential/RLS/FK/FX/permission/phase/TTL/index trở lại và xác nhận checker bắt được.
- `python tooling/check_docs.py --sql` trong môi trường có pglast 8.7: parser PostgreSQL kiểm tra cú pháp các SQL block chuẩn và seed. Không thực thi DDL.
- `git diff --check`: kiểm tra lỗi whitespace/diff. Thư mục docs/09_archive không bị chỉnh sửa.

Số lượng bảng/RPC/docs được checker tính từ nội dung thực tế để tránh một bảng đếm tay trở thành nguồn sai lệch mới. Kết quả pass chỉ áp dụng cho các bất biến được kiểm tra, không chứng minh mọi thuật toán/screen đều hoàn hảo.

## Agent bắt đầu build

Bắt đầu P0 theo [Build Execution Contract](BUILD_EXECUTION_CONTRACT.md), tạo từng packet và typed contract, dựng migration/grants, chạy seed và integration test bằng PostgreSQL thật, rồi hoàn thiện một luồng xuyên UI/API/worker/DB. Không sinh toàn bộ inventory cùng lúc. P1 bắt đầu commerce/finance nền tảng để kiểm chứng con số trước khi mở rộng intelligence/production/publish/commerce/automation.

## Những gate chưa thể chứng minh bằng sửa docs

Repo vẫn là đặc tả; chưa có bằng chứng app build/codegen/runtime/load/restore của các phase. Quyền API production, credential, model/rate, Enterprise entitlement và legal sign-off phải có bằng chứng thật trước khi bật tuyến tương ứng hoặc launch. Những gate này có owner, thời điểm kiểm tra và đường phát triển/manual rõ ràng; không được giả lập thành đã được duyệt.

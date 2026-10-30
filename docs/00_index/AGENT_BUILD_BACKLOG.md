---
layer: index
canonical: true
last_updated: 2026-10-30
---

# Backlog để AI Agent build theo phase

## 1. Điểm bắt đầu và nguồn chuẩn

Bắt đầu **P0-01** trong [task cards](AGENT_TASK_CARDS.md#p0-01--bootstrap-repo-toolchain-và-ci). Có 60 task chia P0–P8, đều ở trạng thái SPECIFIED. Mỗi task có dependency, chức năng liên quan, tài liệu cần đọc, đầu ra, trường hợp nghiệm thu và đường dẫn packet triển khai. Không có task nào được đánh dấu đã code/test/launch.

[Implementation Order](IMPLEMENTATION_ORDER.md) sở hữu mốc bắt đầu/hoàn tất module. [agent_task_catalog.json](agent_task_catalog.json) sở hữu phân rã công việc. Task cards là bản đọc được sinh từ catalog, không phải một backlog độc lập. [Build Execution Contract](BUILD_EXECUTION_CONTRACT.md) sở hữu quy trình và các gate D0–D5.

## 2. Bảo toàn phạm vi

- [requirement_task_map.csv](requirement_task_map.csv) trỏ từng đơn vị đặc tả feature và AC gốc về source, heading, dòng, hash và task. Có đủ 31 feature/spec, cả quy tắc, luồng, edge case, scope và phần mở rộng. Nội dung nghiệp vụ không được sao chép sang CSV.
- `delivery_task` chỉ nơi triển khai đầu tiên. `acceptance_task` là task chốt toàn bộ module khi các phần phụ thuộc đã có; một phần dựng ở P2 có thể chỉ được nghiệm thu đầy đủ ở P4. Điều này tránh “xong sớm” giả tạo.
- [screen_task_map.csv](screen_task_map.csv) gắn mọi screen web/mobile/admin/shared với owner/task và hash. Cột declared_module giữ header lịch sử để thấy khác biệt; cột module là owner dùng cho backlog. Header cũ như “M13 Engagement” không chuyển quyền sở hữu inbox khỏi M12.
- Mỗi packet triển khai phải tách tiếp các dòng/action/AC bên trong source unit nếu chưa thể hoàn tất trong một lượt. `remaining_scope` chứa ID và task nhận phần còn lại, không được ghi “out of scope” để bỏ chức năng. Một unit có nhiều hành vi chỉ đạt khi tất cả hành vi của nó có bằng chứng.
- Registry là kiểm soát bao phủ tài liệu, không phải bằng chứng code thực hiện đúng. Task hoàn tất module kiểm tra lại toàn bộ AC và các task trước, kể cả nội dung cùng unit cần phase sau.
- Các cổng provider/license/legal không được đóng bằng nội dung giả. Manual/import phải có đường thật và proof thật; native route chưa được cấp quyền vẫn là gate chưa đạt.

## 3. Đầu vào và đầu ra cho một lượt agent

1. Chọn task chưa được nhận có dependency đã đủ bằng chứng. Đọc bốn tài liệu bắt buộc, task card, feature owner, contracts/runtime, rồi mới đọc screen trong map.
2. Tạo packet tại đường dẫn của task, ghi task_id, requirement_ids, screen_refs, source hashes và baseline commit. Liệt kê chính xác RPC, messages, permission/object/tier checks, events, migrations và fixtures của slice. Các RPC mở rộng giữ tên trong inventory; không tự tạo alias hoặc bảng mới.
3. Nếu task lớn, tách sub-slice `<task-id>-a`, `-b` trong packet với dependency và requirement IDs rõ ràng. Không cần sinh tất cả services/screens ngay đầu phase. Parent task chỉ được accepted khi mọi sub-slice đạt.
4. Đi từ contract/migration chạy được tới một luồng UI → API → service/worker → DB → UI. Xử lý happy/degraded/missing/broken/audit, replay/concurrency và permission denial ngay trong luồng đó.
5. Chạy kiểm tra trong task, checks của phase và checker docs nếu có sửa đặc tả. Ghi command thật, exit code, thời gian và đường dẫn artifact; không ghi “PASS” khi mới đọc tài liệu.
6. Handoff gồm những gì đã đạt, bằng chứng, scope còn lại với task nhận, gate bên ngoài và task kế tiếp đủ điều kiện. Cập nhật trạng thái thực thi trong packet; catalog kế hoạch vẫn SPECIFIED để không trộn kế hoạch với kết quả.

Paths mã nguồn theo ADR monorepo; tên file migration/proto/test cụ thể do packet xác định trước khi code. D1 vẫn yêu cầu compile transport và validation fixtures cho slice hiện tại. Bộ docs không giả vờ có sẵn 1.000+ compiled RPC.

## 4. Quy tắc nghiệm thu một phase

| Phase | Chốt task | Kết quả người dùng nhìn thấy |
|---|---|---|
| P0 | P0-09 | Đăng nhập/workspace an toàn; nền dữ liệu, credits, capability và shells có kiểm chứng |
| P1 | P1-05 | Nhập đơn/chi phí → xem lợi nhuận có nguồn và việc cần đối soát |
| P2 | P2-04 | Tín hiệu được phép → benchmark → cơ hội có lý do |
| P3 | P3-05 | Cơ hội → idea → script được duyệt → brief; mobile review |
| P4 | P4-09 | Sản xuất đủ bốn mode và EF01–07 → derivative → QA |
| P5 | P5-05 | Publish native/manual → inbox/metrics → coaching và experiment có giới hạn bằng chứng |
| P6 | P6-09 | Commerce/store/affiliate/live/seeding/Creator Pro và chuỗi tài chính hoàn chỉnh |
| P7 | P7-05 | Workflow/recipe/agent/Copilot actions và developer API có quyền/budget/audit |
| P8 | P8-09 | Tất cả module, sáu mode, surfaces và phần mở rộng được đối chiếu bằng bằng chứng |

Một phase có thể được kiểm chứng trong môi trường development bằng adapter nhưng chưa được launch. Báo cáo phải ghi rõ loại môi trường và gate còn thiếu. Không chuyển một phần từ P8 ra ngoài kế hoạch để làm cho checklist pass.

## 5. Cập nhật backlog an toàn

Chạy từ repository root:

```bash
python3 tooling/build_plan.py
python3 tooling/check_docs.py
python3 -m unittest discover -s tooling/tests -v
```

Sau khi sửa source đã được review, cập nhật catalog nếu cần và chạy `python3 tooling/build_plan.py --write`. Generator từ chối làm mất requirement ID; đổi heading/xóa section phải được đối chiếu, chuyển ID tường minh với decision note và giữ đầy đủ hành vi. Không sửa hash/CSV bằng tay để che lệch source. D0 kiểm tra source drift, vòng dependency, task thiếu source, owner/phase mismatch và trường hợp hồi quy quan trọng.

SQL grammar là kiểm tra bổ sung: cài đúng `tooling/requirements-docs.txt` trong virtualenv rồi chạy `python tooling/check_docs.py --sql`. PostgreSQL runtime, lock races, provider access và legal vẫn phải được kiểm chứng ở phase triển khai.

## 6. Prompt bàn giao gợi ý

> Thực hiện task P0-01 theo AGENTS.md và AGENT_BUILD_BACKLOG. Đọc đúng thứ tự, giữ đủ phạm vi. Tạo manifest/sub-slice với requirement IDs và source hashes trước khi code; không đánh dấu ACCEPTED nếu thiếu evidence. Khi có gate bên ngoài, hoàn tất phần độc lập và ghi owner/điều kiện còn thiếu. Kết thúc bằng kết quả kiểm tra thật, phần còn lại và task tiếp theo đủ dependency.

Thay P0-01 bằng mã task đang được chọn. Đây là hướng dẫn triển khai trong chat hiện tại, không tự tạo agent/chat khác hoặc tự cấp quyền production.

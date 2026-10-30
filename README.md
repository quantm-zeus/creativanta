# Creativanta

Creativanta giữ toàn bộ 23 module, auth và 7 mục feature/spec bổ sung; triển khai dần qua P0–P8. Quyết định phạm vi ngày 2026-10-29 thay thế yêu cầu mọi chức năng hoạt động đồng thời từ ngày đầu.

Bắt đầu theo thứ tự:

1. [AGENTS.md](AGENTS.md)
2. [Build Index](docs/00_index/BUILD_INDEX.md)
3. [Open Blockers](docs/00_index/OPEN_BLOCKERS.md)
4. [Canonical Sources](docs/00_index/CANONICAL_SOURCES.md)
5. [Build Execution Contract](docs/00_index/BUILD_EXECUTION_CONTRACT.md)
6. [Implementation Order](docs/00_index/IMPLEMENTATION_ORDER.md)

AI agent bắt đầu từ P0, hoàn thành từng vertical slice và ghi bằng chứng nghiệm thu. Không sinh toàn bộ hệ thống hoặc tự cắt chức năng để qua phase. Đọc feature trước screen; API command phải có typed contract và permission binding trước khi viết endpoint/UI.

Kiểm tra tài liệu:

```bash
python3 tooling/check_docs.py
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tooling/tests -v
```

Kiểm tra thêm cú pháp PostgreSQL và seed (cần dependency tùy chọn đã pin):

```bash
python3 -m venv /tmp/creativanta-docs-check
/tmp/creativanta-docs-check/bin/python -m pip install -r tooling/requirements-docs.txt
/tmp/creativanta-docs-check/bin/python tooling/check_docs.py --sql
```

Các lệnh trên kiểm tra bất biến tĩnh và hồi quy của checker. Chúng không chạy hệ thống, xác nhận quyền API/license, hay thay thế PostgreSQL integration test, codegen và release gate của từng phase. Repo hiện là bộ đặc tả và công cụ kiểm tra docs; trạng thái SPECIFIED chưa phải IMPLEMENTED/ACCEPTED/LAUNCH_APPROVED.

Xem [bản ghi hoàn thiện docs](docs/00_index/BUILD_READINESS.md) để biết thay đổi, kiểm tra đã thực hiện và các gate cần bằng chứng khi build.

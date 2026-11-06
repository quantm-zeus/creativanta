/**
 * Canonical Legal & Compliance Documents Registry (LEG-H-001 / legal_compliance.md §1–§2)
 * Maps each of the 6 canonical footer links in `CANONICAL_LEGAL_LINKS` to its
 * engineering-approved baseline policy document and launch-gate metadata.
 */

export type CanonicalLegalSlug =
  | 'terms'
  | 'privacy'
  | 'cookies'
  | 'aup'
  | 'dmca'
  | 'ai-disclaimer';

export interface LegalDocumentSection {
  heading: string;
  paragraphs: string[];
  bullets?: string[];
}

export interface LegalDocumentSpec {
  id: string;
  slug: CanonicalLegalSlug;
  href: string;
  titleVi: string;
  titleEn: string;
  version: string;
  effectiveDate: string;
  reviewStatus: 'engineering_approved_launch_gated';
  blockerRef: 'LEG-H-001';
  summary: string;
  sections: LegalDocumentSection[];
}

export const CANONICAL_LEGAL_DOCUMENTS: Record<CanonicalLegalSlug, LegalDocumentSpec> = {
  terms: {
    id: 'terms_of_service',
    slug: 'terms',
    href: '/legal/terms',
    titleVi: 'Điều khoản dịch vụ',
    titleEn: 'Terms of Service',
    version: '1.0-rc1',
    effectiveDate: '2026-11-01',
    reviewStatus: 'engineering_approved_launch_gated',
    blockerRef: 'LEG-H-001',
    summary:
      'Quy định về đăng ký tài khoản, quyền quản trị Workspace, gói thuê bao, quy tắc AI Credits và giới hạn trách nhiệm pháp lý khi sử dụng nền tảng Creativanta.',
    sections: [
      {
        heading: '1. Tài khoản, Tổ chức & Phân quyền Workspace',
        paragraphs: [
          'Mỗi tài khoản người dùng được xác thực qua nhà cung cấp định danh (Clerk) và liên kết với một hoặc nhiều Workspace độc lập.',
          'Chủ sở hữu (Owner) và Quản trị viên (Admin) của Workspace chịu trách nhiệm quản lý thành viên, phân quyền RBAC và bảo mật khóa API được cấp phát.'
        ]
      },
      {
        heading: '2. Thuê bao, Thanh toán & Quy tắc AI Credits (M23)',
        paragraphs: [
          'Các gói thuê bao được gia hạn tự động theo chu kỳ tháng hoặc năm trừ khi được hủy trước ngày gia hạn tiếp theo.',
          'AI Credits được quản lý theo từng lô (credit_lots) với thứ tự ưu tiên trừ từ lô sắp hết hạn trước (FIFO theo ngày hết hạn).'
        ],
        bullets: [
          'Credits chỉ bị khấu trừ khi tác vụ AI hoàn tất thành công hoặc được xác nhận từ nhà cung cấp.',
          'Khi tác vụ AI thất bại do lỗi hệ thống hoặc bị hủy hợp lệ trước khi kết xuất hoàn tất, số credits đã giữ chỗ sẽ được giải phóng về ví.',
          'Các gói Credits mua thêm (Top-up) có thời hạn sử dụng theo chính sách gói và không quy đổi ngược thành tiền mặt.'
        ]
      },
      {
        heading: '3. Quyền sở hữu trí tuệ & Dữ liệu khách hàng',
        paragraphs: [
          'Khách hàng giữ toàn bộ quyền sở hữu đối với tài nguyên gốc, kịch bản, danh mục sản phẩm và dữ liệu đơn hàng được tải lên hoặc đồng bộ vào Workspace.',
          'Creativanta chỉ xử lý dữ liệu của khách hàng nhằm mục đích cung cấp dịch vụ theo đúng phạm vi tenant cô lập (Row-Level Security).'
        ]
      }
    ]
  },
  privacy: {
    id: 'privacy_policy',
    slug: 'privacy',
    href: '/legal/privacy',
    titleVi: 'Chính sách bảo mật',
    titleEn: 'Privacy Policy',
    version: '1.0-rc1',
    effectiveDate: '2026-11-01',
    reviewStatus: 'engineering_approved_launch_gated',
    blockerRef: 'LEG-H-001',
    summary:
      'Cam kết bảo vệ dữ liệu cá nhân theo GDPR, CCPA và Nghị định 13/2023/NĐ-CP (PDPD Việt Nam), bao gồm quyền truy cập, trích xuất và xóa dữ liệu.',
    sections: [
      {
        heading: '1. Phạm vi dữ liệu thu thập & Mục đích xử lý',
        paragraphs: [
          'Creativanta thu thập thông tin định danh tài khoản (họ tên, email), siêu dữ liệu kết nối kênh (OAuth tokens được mã hóa AES-256-GCM) và nhật ký vận hành để phục vụ hoạt động thương mại đa kênh.'
        ],
        bullets: [
          'Không bán dữ liệu cá nhân hoặc dữ liệu doanh thu của khách hàng cho bên thứ ba.',
          'Không sử dụng dữ liệu riêng tư của Workspace để huấn luyện mô hình AI dùng chung nếu không có sự đồng ý rõ ràng (explicit opt-in).'
        ]
      },
      {
        heading: '2. Lưu trữ, Cô lập Đa thuê bao & Bảo mật',
        paragraphs: [
          'Mọi bảng dữ liệu nghiệp vụ đều áp dụng chính sách Row-Level Security (RLS) bắt buộc theo workspace_id.',
          'Thông tin nhạy cảm của khách hàng mua lẻ (PII đơn hàng) được tự động ẩn danh hóa sau thời hạn lưu trữ pháp lý.'
        ]
      },
      {
        heading: '3. Quyền của Chủ thể Dữ liệu (DSAR)',
        paragraphs: [
          'Người dùng có quyền yêu cầu trích xuất toàn bộ dữ liệu (Data Export) hoặc yêu cầu xóa tài khoản/dữ liệu cá nhân với thời gian ân hạn 30 ngày theo quy định tại docs/01_business/legal_compliance.md §3.'
        ]
      }
    ]
  },
  cookies: {
    id: 'cookie_policy',
    slug: 'cookies',
    href: '/legal/cookies',
    titleVi: 'Chính sách Cookie',
    titleEn: 'Cookie Policy',
    version: '1.0-rc1',
    effectiveDate: '2026-11-01',
    reviewStatus: 'engineering_approved_launch_gated',
    blockerRef: 'LEG-H-001',
    summary:
      'Giải thích cách Creativanta sử dụng cookie thiết yếu cho xác thực phiên, lưu trữ tùy chọn giao diện (6 chế độ vận hành) và kiểm soát cookie phân tích.',
    sections: [
      {
        heading: '1. Cookie thiết yếu (Strictly Necessary)',
        paragraphs: [
          'Được sử dụng để duy trì phiên đăng nhập an toàn (Clerk session JWT), bảo vệ chống giả mạo yêu cầu (CSRF) và ghi nhớ Workspace/Chế độ vận hành đang hoạt động.'
        ]
      },
      {
        heading: '2. Tùy chọn giao diện & Bộ nhớ cục bộ',
        paragraphs: [
          'Hệ thống lưu trữ khóa cấu hình không nhạy cảm trong trình duyệt (như creativanta_operator_mode và creativanta_active_workspace_id) để đồng bộ trải nghiệm giữa các tab.'
        ]
      },
      {
        heading: '3. Quản lý sự đồng ý (Consent Management)',
        paragraphs: [
          'Người dùng có thể thay đổi tùy chọn cookie phân tích bất kỳ lúc nào trong phần Cài đặt quyền riêng tư mà không ảnh hưởng đến các tính năng cốt lõi.'
        ]
      }
    ]
  },
  aup: {
    id: 'acceptable_use_policy',
    slug: 'aup',
    href: '/legal/aup',
    titleVi: 'Chính sách sử dụng hợp lệ (AUP)',
    titleEn: 'Acceptable Use Policy',
    version: '1.0-rc1',
    effectiveDate: '2026-11-01',
    reviewStatus: 'engineering_approved_launch_gated',
    blockerRef: 'LEG-H-001',
    summary:
      'Các quy tắc bắt buộc nhằm ngăn chặn nội dung giả mạo trái phép (deepfake không xin phép), gian lận thương mại, phát tán mã độc và lạm dụng hạn mức API.',
    sections: [
      {
        heading: '1. Nội dung AI & Hình ảnh Nhân vật bị cấm',
        paragraphs: [
          'Người dùng không được sử dụng AI Video Studio, AI Remix hoặc Character Continuity để tạo nội dung mạo danh cá nhân thực tế mà không có sự đồng ý hợp pháp bằng văn bản.'
        ],
        bullets: [
          'Cấm tạo nội dung vi phạm pháp luật, lừa đảo tài chính, hàng giả hoặc tuyên truyền sai sự thật về công dụng sản phẩm.',
          'Bắt buộc vượt qua kiểm tra độ nguyên bản (Originality Check < 30% tương đồng) khi sử dụng tính năng AI Remix.'
        ]
      },
      {
        heading: '2. Bảo vệ Hạ tầng, SSRF & Giới hạn Tốc độ (Rate Limits)',
        paragraphs: [
          'Nghiêm cấm mọi hành vi quét lỗ hổng, gửi yêu cầu giả mạo tới mạng nội bộ (SSRF), vượt rào kiểm tra quyền hạn RBAC hoặc chia sẻ khóa Public API trái phép.'
        ]
      }
    ]
  },
  dmca: {
    id: 'dmca_policy',
    slug: 'dmca',
    href: '/legal/dmca',
    titleVi: 'Bản quyền & DMCA',
    titleEn: 'DMCA & Copyright Policy',
    version: '1.0-rc1',
    effectiveDate: '2026-11-01',
    reviewStatus: 'engineering_approved_launch_gated',
    blockerRef: 'LEG-H-001',
    summary:
      'Quy trình tiếp nhận thông báo khiếu nại bản quyền (DMCA Takedown), cơ chế kiểm tra bản quyền âm thanh/hình ảnh trước khi xuất bản và thủ tục phản hồi.',
    sections: [
      {
        heading: '1. Kiểm soát Bản quyền Chủ động trong Sản xuất',
        paragraphs: [
          'Creativanta tích hợp bước kiểm tra bản quyền tự động (Copyright Check) và đánh giá độ nguyên bản trước khi cho phép xuất bản nội dung lên TikTok, YouTube, Instagram và Facebook.'
        ]
      },
      {
        heading: '2. Quy trình Gửi Thông báo Khiếu nại (Takedown Notice)',
        paragraphs: [
          'Chủ sở hữu bản quyền có thể gửi yêu cầu gỡ bỏ nội dung vi phạm kèm bằng chứng sở hữu hợp lệ tới bộ phận Pháp chế & Tuân thủ của Creativanta để được xử lý trong vòng 24–48 giờ làm việc.'
        ]
      },
      {
        heading: '3. Thông báo Phản hồi & Chính sách Vi phạm Nhiều lần',
        paragraphs: [
          'Chủ Workspace bị khiếu nại có quyền gửi thông báo phản hồi (Counter-Notice) kèm bằng chứng cấp phép. Các Workspace tái phạm nhiều lần sẽ bị tạm ngưng quyền xuất bản tự động.'
        ]
      }
    ]
  },
  'ai-disclaimer': {
    id: 'ai_content_disclaimer',
    slug: 'ai-disclaimer',
    href: '/legal/ai-disclaimer',
    titleVi: 'Tuyên bố miễn trừ AI',
    titleEn: 'AI Content Disclaimer',
    version: '1.0-rc1',
    effectiveDate: '2026-11-01',
    reviewStatus: 'engineering_approved_launch_gated',
    blockerRef: 'LEG-H-001',
    summary:
      'Quy định về tính minh bạch của nội dung do AI sinh ra (EU AI Act Art. 52), trách nhiệm kiểm duyệt của con người (Human-in-the-Loop) và giới hạn độ chính xác của dự báo.',
    sections: [
      {
        heading: '1. Gắn nhãn Minh bạch Nội dung AI (Provenance & Lineage)',
        paragraphs: [
          'Mọi tài sản truyền thông được tạo bởi AI Video Studio, Image-to-Video hoặc AI Voiceover đều lưu trữ hồ sơ nguồn gốc (Lineage Record) ghi nhận rõ nhà cung cấp mô hình, câu lệnh gốc và chi phí kết xuất.'
        ]
      },
      {
        heading: '2. Trách nhiệm Kiểm duyệt trước khi Xuất bản',
        paragraphs: [
          'Các gợi ý từ Morning Brief, điểm số Virality Score, dự báo CTR và nội dung sinh tự động chỉ mang tính chất hỗ trợ quyết định.',
          'Khách hàng chịu trách nhiệm kiểm duyệt cuối cùng về tính chính xác của thông tin sản phẩm, giá bán và nhãn công bố quảng cáo trên từng nền tảng mạng xã hội.'
        ]
      }
    ]
  }
};

export function getLegalDocumentBySlug(slug: string): LegalDocumentSpec | null {
  const normalized = (slug || '').trim().toLowerCase() as CanonicalLegalSlug;
  return CANONICAL_LEGAL_DOCUMENTS[normalized] ?? null;
}

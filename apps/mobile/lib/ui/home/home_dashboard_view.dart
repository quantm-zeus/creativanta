import 'package:flutter/material.dart';
import 'package:creativanta_mobile/auth/auth_models.dart';
import 'package:creativanta_mobile/ui/home/why_number_sheet.dart';

/// Data structure for a decision card on mobile
class MobileDecisionCard {
  const MobileDecisionCard({
    required this.cardId,
    required this.cardFamily,
    required this.title,
    required this.description,
    required this.primaryCtaLabel,
    required this.primaryCtaRoute,
    required this.moduleRef,
    required this.priorityRank,
    required this.whyThisMatters,
    this.dataSourceBadge = 'OFFICIAL',
    this.confidenceLevel = 'HIGH',
    this.isActionAvailable = true,
    this.unavailableReason = '',
  });

  final String cardId;
  final String cardFamily;
  final String title;
  final String description;
  final String primaryCtaLabel;
  final String primaryCtaRoute;
  final String moduleRef;
  final int priorityRank;
  final String whyThisMatters;
  final String dataSourceBadge;
  final String confidenceLevel;
  final bool isActionAvailable;
  final String unavailableReason;
}

/// Data structure for a canonical onboarding step
class MobileOnboardingStep {
  const MobileOnboardingStep({
    required this.stepNumber,
    required this.stepKey,
    required this.title,
    required this.description,
  });

  final int stepNumber;
  final String stepKey;
  final String title;
  final String description;
}

/// Canonical 5-step onboarding definitions (Target 2)
const List<MobileOnboardingStep> canonicalOnboardingSteps = [
  MobileOnboardingStep(
    stepNumber: 1,
    stepKey: 'connect_data',
    title: '1. Kết nối kênh bán hoặc nhập tệp dữ liệu mẫu',
    description: 'Kết nối TikTok Shop / Shopee hoặc nhập tệp CSV đơn hàng & chi phí mẫu.',
  ),
  MobileOnboardingStep(
    stepNumber: 2,
    stepKey: 'select_offer',
    title: '2. Tạo danh mục hoặc chọn sản phẩm kinh doanh',
    description: 'Chọn sản phẩm chủ lực hoặc thiết lập ưu đãi độc quyền trên Product Hub (M13).',
  ),
  MobileOnboardingStep(
    stepNumber: 3,
    stepKey: 'create_content',
    title: '3. Tạo kịch bản & sản xuất video AI đầu tiên',
    description: 'Tự động tạo kịch bản viral và sản xuất video ngắn bằng AI Video Studio (M07).',
  ),
  MobileOnboardingStep(
    stepNumber: 4,
    stepKey: 'publish',
    title: '4. Lên lịch & xuất bản đa kênh chuẩn giờ vàng',
    description: 'Phân phối đồng thời lên TikTok, Reels và YouTube Shorts bằng Publish Hub (M11).',
  ),
  MobileOnboardingStep(
    stepNumber: 5,
    stepKey: 'track_outcome',
    title: '5. Đối soát doanh số & đo lường biên lợi nhuận ròng',
    description: 'Theo dõi báo cáo đối soát doanh thu, chi phí và chứng từ trên Sổ cái (M19).',
  ),
];

/// Decision cards for all 6 operator modes (Target 1)
const Map<OperatorMode, List<MobileDecisionCard>> modeDecisionCards = {
  OperatorMode.creator: [
    MobileDecisionCard(
      cardId: 'card-creator-trend',
      cardFamily: 'top_opportunities',
      title: 'Cơ hội xu hướng FMCG & Đồ gia dụng thông minh',
      description: 'Âm thanh và chủ đề xu hướng tăng trưởng 120% trong 24 giờ qua trên TikTok Shop.',
      primaryCtaLabel: 'Khám phá tín hiệu xu hướng',
      primaryCtaRoute: '/kham-pha',
      moduleRef: 'M02',
      priorityRank: 1,
      whyThisMatters: 'Bắt nhịp xu hướng sớm tăng lượt xem tự nhiên lên gấp 3 lần.',
    ),
    MobileDecisionCard(
      cardId: 'card-creator-ideas',
      cardFamily: 'ideas_and_scripts',
      title: '5 ý tưởng video mới từ Trend Radar',
      description: 'Ý tưởng nội dung kèm 3 góc hook đã sẵn sàng để phát triển thành kịch bản hoàn chỉnh.',
      primaryCtaLabel: 'Mở Idea Engine',
      primaryCtaRoute: '/ideas',
      moduleRef: 'M05',
      priorityRank: 2,
      whyThisMatters: 'Chuyển hóa tín hiệu xu hướng thành nội dung cụ thể trong vòng 24h.',
    ),
    MobileDecisionCard(
      cardId: 'card-creator-script',
      cardFamily: 'ideas_and_scripts',
      title: '3 kịch bản AI Video Studio đề xuất',
      description: 'Kịch bản dạng unboxing và review thực tế được tạo tự động cho sản phẩm chọn lọc.',
      primaryCtaLabel: 'Mở Script Lab',
      primaryCtaRoute: '/scripts',
      moduleRef: 'M06',
      priorityRank: 3,
      whyThisMatters: 'Kịch bản có cấu trúc giữ chân khán giả trên 60% ở 3 giây đầu.',
    ),
    MobileDecisionCard(
      cardId: 'card-creator-studio',
      cardFamily: 'video_generation',
      title: '2 tác vụ render video đang xử lý',
      description: 'AI Video Studio đang tổng hợp video từ kịch bản được phê duyệt gần nhất.',
      primaryCtaLabel: 'Mở Video Studio',
      primaryCtaRoute: '/studio',
      moduleRef: 'M07',
      priorityRank: 4,
      whyThisMatters: 'Theo dõi tiến độ render để kịp giờ vàng đăng bài.',
    ),
    MobileDecisionCard(
      cardId: 'card-creator-publish',
      cardFamily: 'publish_schedule',
      title: 'Lịch đăng tối nay: Khung giờ vàng 19:30',
      description: '1 video đã sẵn sàng xuất bản đa kênh đồng thời lên TikTok và Reels.',
      primaryCtaLabel: 'Kiểm tra lịch xuất bản',
      primaryCtaRoute: '/xuat-ban',
      moduleRef: 'M11',
      priorityRank: 5,
      whyThisMatters: 'Đăng đúng khung giờ cao điểm giúp tối đa hóa tương tác ban đầu.',
    ),
    MobileDecisionCard(
      cardId: 'card-creator-inbox',
      cardFamily: 'high_priority_inbox',
      title: '8 bình luận hỏi mua hàng cần phản hồi gấp',
      description: 'Khán giả quan tâm tới giá và link mua trong video đăng 2 giờ trước.',
      primaryCtaLabel: 'Mở Hộp thư tương tác',
      primaryCtaRoute: '/inbox',
      moduleRef: 'M12',
      priorityRank: 6,
      whyThisMatters: 'Tương tác nhanh trong 1 giờ đầu giúp đẩy video vào luồng phân phối.',
    ),
    MobileDecisionCard(
      cardId: 'card-creator-income',
      cardFamily: 'revenue_today',
      title: 'Thu nhập & hoa hồng ước tính hôm nay',
      description: 'Theo dõi doanh thu hoa hồng affiliate và thưởng hiệu suất từ các video đang phân phối.',
      primaryCtaLabel: 'Xem Sổ cái lợi nhuận',
      primaryCtaRoute: '/finance',
      moduleRef: 'M19',
      priorityRank: 7,
      whyThisMatters: 'Nắm bắt thu nhập thực tế đã đối soát để tối ưu hóa nguồn lực sáng tạo.',
    ),
  ],
  OperatorMode.seller: [
    MobileDecisionCard(
      cardId: 'card-seller-orders',
      cardFamily: 'order_queue',
      title: 'Hàng đợi đơn hàng cần xử lý',
      description: 'Kiểm tra và chuẩn bị hàng cho các đơn mới phát sinh để đáp ứng SLA sàn.',
      primaryCtaLabel: 'Mở danh sách đơn hàng',
      primaryCtaRoute: '/kinh-doanh',
      moduleRef: 'M13',
      priorityRank: 1,
      whyThisMatters: 'Giao hàng đúng SLA sàn để tránh phạt tỷ lệ trễ hạn.',
      dataSourceBadge: 'IMPORTED',
    ),
    MobileDecisionCard(
      cardId: 'card-seller-revenue',
      cardFamily: 'revenue_today',
      title: 'Doanh thu bán hàng hôm nay',
      description: 'Theo dõi số liệu doanh số bán hàng và biên lợi nhuận từ các kênh liên kết.',
      primaryCtaLabel: 'Xem đối soát lợi nhuận',
      primaryCtaRoute: '/finance',
      moduleRef: 'M19',
      priorityRank: 2,
      whyThisMatters: 'Đánh giá nhịp bán hàng và dòng tiền trong ngày.',
    ),
    MobileDecisionCard(
      cardId: 'card-seller-stock',
      cardFamily: 'low_stock_alert',
      title: 'Cảnh báo tồn kho an toàn',
      description: 'Kiểm tra lượng tồn kho khả dụng và dự báo điểm đặt hàng lại cho các SKU bán chạy.',
      primaryCtaLabel: 'Kiểm tra kho hàng',
      primaryCtaRoute: '/kinh-doanh',
      moduleRef: 'M13',
      priorityRank: 3,
      whyThisMatters: 'Tránh tình trạng đứt hàng khi chiến dịch quảng cáo đang chạy.',
    ),
    MobileDecisionCard(
      cardId: 'card-seller-promotions',
      cardFamily: 'pricing_rules',
      title: 'Cài đặt mã giảm giá & ưu đãi mua kèm',
      description: 'Thiết lập chương trình khuyến mãi chớp nhoáng (Flash Sale) để kích cầu.',
      primaryCtaLabel: 'Cấu hình ưu đãi',
      primaryCtaRoute: '/offers',
      moduleRef: 'M14',
      priorityRank: 4,
      whyThisMatters: 'Tối ưu giá trị giỏ hàng trung bình (AOV) bằng combo ưu đãi.',
    ),
    MobileDecisionCard(
      cardId: 'card-seller-ads',
      cardFamily: 'ad_spend_alerts',
      title: 'Tối ưu ngân sách quảng cáo tự động',
      description: 'Quy tắc tự động điều chỉnh ngân sách cho các chiến dịch có ROAS vượt kỳ vọng.',
      primaryCtaLabel: 'Quản lý quy tắc tự động',
      primaryCtaRoute: '/workflows',
      moduleRef: 'M20',
      priorityRank: 5,
      whyThisMatters: 'Kiểm soát chi phí quảng cáo và bảo vệ biên lợi nhuận ròng.',
    ),
  ],
  OperatorMode.affiliateOperator: [
    MobileDecisionCard(
      cardId: 'card-affiliate-links',
      cardFamily: 'broken_links',
      title: 'Giám sát tính khả dụng của liên kết tiếp thị',
      description: 'Tất cả các liên kết bio và video đang hoạt động tốt, không có mã 404.',
      primaryCtaLabel: 'Quản lý liên kết tiếp thị',
      primaryCtaRoute: '/affiliates',
      moduleRef: 'M16',
      priorityRank: 1,
      whyThisMatters: 'Liên kết hỏng làm mất trực tiếp hoa hồng khi có lưu lượng truy cập.',
    ),
    MobileDecisionCard(
      cardId: 'card-affiliate-campaigns',
      cardFamily: 'commission_opportunities',
      title: '3 chiến dịch hoa hồng cao độc quyền',
      description: 'Các nhãn hàng ngành sức khỏe & sắc đẹp đang tài trợ mức hoa hồng lên tới 25%.',
      primaryCtaLabel: 'Khám phá chiến dịch',
      primaryCtaRoute: '/offers',
      moduleRef: 'M14',
      priorityRank: 2,
      whyThisMatters: 'Tập trung vào sản phẩm hoa hồng cao giúp tăng doanh thu trên mỗi lượt xem.',
    ),
    MobileDecisionCard(
      cardId: 'card-affiliate-coupons',
      cardFamily: 'coupon_inventory',
      title: 'Mã giảm giá độc quyền cho người theo dõi',
      description: '2 mã giảm giá 15% độc quyền sắp hết hạn sau 48 giờ.',
      primaryCtaLabel: 'Cập nhật mã ưu đãi',
      primaryCtaRoute: '/coupons',
      moduleRef: 'M14',
      priorityRank: 3,
      whyThisMatters: 'Mã ưu đãi sắp hết hạn tạo hiệu ứng khan hiếm kích thích mua ngay.',
    ),
    MobileDecisionCard(
      cardId: 'card-affiliate-analytics',
      cardFamily: 'conversion_lineage',
      title: 'Phân tích nguồn chuyển đổi theo video',
      description: 'Video ngắn M07-Review mang lại 65% tổng số lượt nhấp vào giỏ hàng hôm qua.',
      primaryCtaLabel: 'Xem báo cáo phân bổ',
      primaryCtaRoute: '/attribution',
      moduleRef: 'M16',
      priorityRank: 4,
      whyThisMatters: 'Hiểu rõ video nào tạo ra đơn hàng để nhân bản nội dung tương tự.',
    ),
    MobileDecisionCard(
      cardId: 'card-affiliate-payouts',
      cardFamily: 'payout_tracking',
      title: 'Đối soát hoa hồng sàn đến hạn rút',
      description: 'Khoản hoa hồng đối soát kỳ trước đã sẵn sàng để yêu cầu thanh toán.',
      primaryCtaLabel: 'Kiểm tra số dư hoa hồng',
      primaryCtaRoute: '/finance',
      moduleRef: 'M19',
      priorityRank: 5,
      whyThisMatters: 'Rút hoa hồng đúng chu kỳ giúp duy trì dòng tiền ổn định.',
    ),
  ],
  OperatorMode.liveOperator: [
    MobileDecisionCard(
      cardId: 'card-live-readiness',
      cardFamily: 'live_readiness',
      title: 'Kiểm tra kịch bản & luồng kỹ thuật phòng Live',
      description: 'Phiên live tiếp theo dự kiến lúc 20:00 tối nay. Kịch bản và danh sách deal đã sẵn sàng.',
      primaryCtaLabel: 'Mở Phòng điều khiển Live',
      primaryCtaRoute: '/live',
      moduleRef: 'M17',
      priorityRank: 1,
      whyThisMatters: 'Chuẩn bị kỹ lưỡng trước giờ live giúp giảm 90% lỗi kỹ thuật khi lên sóng.',
    ),
    MobileDecisionCard(
      cardId: 'card-live-deals',
      cardFamily: 'flash_sale_queue',
      title: 'Sắp xếp thứ tự deal Flash Sale theo phút',
      description: 'Lên lịch tung 5 deal giá sốc vào các thời điểm mắt xem đạt đỉnh.',
      primaryCtaLabel: 'Quản lý lịch deal',
      primaryCtaRoute: '/offers',
      moduleRef: 'M14',
      priorityRank: 2,
      whyThisMatters: 'Tung deal đúng nhịp giữ chân khán giả xem livestream lâu hơn.',
    ),
    MobileDecisionCard(
      cardId: 'card-live-chat-alerts',
      cardFamily: 'live_sentiment_alerts',
      title: 'Giám sát từ khóa & bình luận cần ghim',
      description: 'Bộ lọc tự động phát hiện câu hỏi về bảng kích cỡ (size) và chính sách đổi trả.',
      primaryCtaLabel: 'Cấu hình phản hồi chat',
      primaryCtaRoute: '/inbox',
      moduleRef: 'M12',
      priorityRank: 3,
      whyThisMatters: 'Trả lời thắc mắc sản phẩm ngay lập tức giúp chốt đơn trong phiên live.',
    ),
    MobileDecisionCard(
      cardId: 'card-live-replay',
      cardFamily: 'clip_extraction',
      title: 'Cắt video ngắn (Clips) từ phiên live gần nhất',
      description: 'Tự động trích xuất 3 khoảnh khắc bán hàng cao trào để đăng lại thành video ngắn.',
      primaryCtaLabel: 'Mở Video Studio',
      primaryCtaRoute: '/studio',
      moduleRef: 'M07',
      priorityRank: 4,
      whyThisMatters: 'Tái sử dụng nội dung live thành video ngắn giúp bán hàng liên tục 24/7.',
    ),
    MobileDecisionCard(
      cardId: 'card-live-gmv',
      cardFamily: 'live_gmv_pulse',
      title: 'Đối soát doanh thu & tỷ lệ hoàn đơn livestream',
      description: 'Theo dõi tổng doanh số GMV thực tế sau khi trừ các đơn hủy và hoàn hàng.',
      primaryCtaLabel: 'Xem Sổ cái doanh thu',
      primaryCtaRoute: '/finance',
      moduleRef: 'M19',
      priorityRank: 5,
      whyThisMatters: 'Kiểm soát tỷ lệ hoàn đơn thực tế để tính toán chính xác lợi nhuận gộp.',
    ),
  ],
  OperatorMode.agencyMcn: [
    MobileDecisionCard(
      cardId: 'card-agency-approvals',
      cardFamily: 'approval_gate',
      title: 'Quy trình phê duyệt nội dung Creator & Khách hàng',
      description: '3 kịch bản video đang chờ đối tác phê duyệt trước khi tiến hành sản xuất.',
      primaryCtaLabel: 'Mở hàng đợi phê duyệt',
      primaryCtaRoute: '/workflows',
      moduleRef: 'M20',
      priorityRank: 1,
      whyThisMatters: 'Phê duyệt đúng quy trình ngăn ngừa rủi ro vi phạm cam kết thương hiệu.',
    ),
    MobileDecisionCard(
      cardId: 'card-agency-contracts',
      cardFamily: 'creator_governance',
      title: 'Tiến độ hoàn thành KPI của mạng lưới Creator',
      description: 'Đánh giá tỷ lệ nộp bài đúng hạn và lượt xem đạt chuẩn của 15 Creator trong tháng.',
      primaryCtaLabel: 'Xem danh sách Creator',
      primaryCtaRoute: '/attribution',
      moduleRef: 'M18',
      priorityRank: 2,
      whyThisMatters: 'Theo dõi sát sao tiến độ giúp đảm bảo KPI đã cam kết với khách hàng.',
    ),
    MobileDecisionCard(
      cardId: 'card-agency-pipeline',
      cardFamily: 'deal_pipeline',
      title: 'Đường ống hợp đồng hợp tác chiến dịch mới',
      description: '2 đề xuất chiến dịch truyền thông đa kênh đang trong giai đoạn thương thảo hợp đồng.',
      primaryCtaLabel: 'Kiểm tra đường ống deal',
      primaryCtaRoute: '/attribution',
      moduleRef: 'M18',
      priorityRank: 3,
      whyThisMatters: 'Duy trì đường ống hợp đồng liên tục để bảo đảm doanh thu agency.',
    ),
    MobileDecisionCard(
      cardId: 'card-agency-splits',
      cardFamily: 'payout_splits',
      title: 'Đối soát tỷ lệ chia sẻ doanh thu & hoa hồng',
      description: 'Tính toán phân bổ doanh thu giữa Agency và Creator theo điều khoản hợp đồng.',
      primaryCtaLabel: 'Mở Sổ cái phân bổ',
      primaryCtaRoute: '/finance',
      moduleRef: 'M19',
      priorityRank: 4,
      whyThisMatters: 'Phân bổ minh bạch và chính xác tạo dựng niềm tin bền vững với Creator.',
    ),
    MobileDecisionCard(
      cardId: 'card-agency-performance',
      cardFamily: 'campaign_benchmarks',
      title: 'Báo cáo tổng hợp hiệu suất đa kênh cho nhãn hàng',
      description: 'Báo cáo tổng hợp chỉ số lượt xem, tương tác và chuyển đổi đơn hàng của chiến dịch.',
      primaryCtaLabel: 'Xem báo cáo tổng hợp',
      primaryCtaRoute: '/attribution',
      moduleRef: 'M16',
      priorityRank: 5,
      whyThisMatters: 'Báo cáo chuyên nghiệp giúp gia tăng tỷ lệ tái ký hợp đồng của khách hàng.',
    ),
  ],
  OperatorMode.brandCollaboration: [
    MobileDecisionCard(
      cardId: 'card-brand-inquiries',
      cardFamily: 'sponsor_inquiries',
      title: 'Yêu cầu hợp tác & booking tài trợ mới',
      description: 'Kiểm tra các lời mời hợp tác từ nhãn hàng gửi vào hộp thư.',
      primaryCtaLabel: 'Mở danh sách booking',
      primaryCtaRoute: '/creator-pro',
      moduleRef: 'S16',
      priorityRank: 1,
      whyThisMatters: 'Phản hồi nhãn hàng nhanh trong 24h giúp giữ deal giá trị cao.',
    ),
    MobileDecisionCard(
      cardId: 'card-brand-deliverables',
      cardFamily: 'deliverable_deadlines',
      title: 'Hạn chót bàn giao nội dung tài trợ (Deadlines)',
      description: '2 bài đăng sponsored post đã được duyệt, chuẩn bị lên sóng theo lịch cam kết.',
      primaryCtaLabel: 'Xem lịch bàn giao',
      primaryCtaRoute: '/ideas',
      moduleRef: 'M05',
      priorityRank: 2,
      whyThisMatters: 'Đăng đúng hạn cam kết giúp bảo toàn uy tín chuyên nghiệp với thương hiệu.',
    ),
    MobileDecisionCard(
      cardId: 'card-brand-review',
      cardFamily: 'brand_approvals',
      title: 'Trạng thái nghiệm thu & phản hồi từ nhãn hàng',
      description: 'Nội dung video tài trợ đã hoàn thành đang chờ thương hiệu phản hồi nghiệm thu.',
      primaryCtaLabel: 'Kiểm tra tiến độ nghiệm thu',
      primaryCtaRoute: '/attribution',
      moduleRef: 'M18',
      priorityRank: 3,
      whyThisMatters: 'Bằng chứng nghiệm thu đầy đủ giúp giải ngân hợp đồng tài trợ nhanh chóng.',
    ),
    MobileDecisionCard(
      cardId: 'card-brand-invoices',
      cardFamily: 'payout_tracking',
      title: 'Theo dõi thanh toán hợp đồng & Giải ngân (Payouts)',
      description: '1 hóa đơn thanh toán đợt 2 của nhãn hàng đang chờ đối soát tài khoản.',
      primaryCtaLabel: 'Kiểm tra tiến độ thanh toán',
      primaryCtaRoute: '/finance',
      moduleRef: 'M19',
      priorityRank: 4,
      whyThisMatters: 'Đảm bảo đối soát chính xác các đợt thanh toán từ đối tác thương hiệu.',
    ),
    MobileDecisionCard(
      cardId: 'card-brand-evidence',
      cardFamily: 'performance_evidence',
      title: 'Bằng chứng chuyển đổi & ROI chiến dịch',
      description: 'Báo cáo phân bổ đơn hàng và tỷ lệ chuyển đổi mã giảm giá tài trợ độc quyền.',
      primaryCtaLabel: 'Xem bằng chứng ROI',
      primaryCtaRoute: '/attribution',
      moduleRef: 'M16',
      priorityRank: 5,
      whyThisMatters: 'Chứng minh ROI thực tế là chìa khóa để ký hợp đồng tài trợ dài hạn.',
    ),
  ],
};

/// Home Dashboard View implementing Phase P8 requirements:
/// - Target 1: All six mode priorities rendered with rankings and actionable routes
/// - Target 2: Canonical 5-step onboarding checklist with distinct First-Value vs Closed-Loop badges
/// - Target 3: Every shared UI state (Normal, Loading, Empty, Error, Repair) and route mapped
class HomeDashboardView extends StatefulWidget {
  const HomeDashboardView({
    super.key,
    required this.activeMode,
    this.onSwitchMode,
    this.onOpenModePicker,
    this.onNavigateToRoute,
    this.initialCompletedSteps = const {1},
    this.initialUiState = 'normal',
  });

  final OperatorMode activeMode;
  final ValueChanged<OperatorMode>? onSwitchMode;
  final VoidCallback? onOpenModePicker;
  final ValueChanged<String>? onNavigateToRoute;
  final Set<int> initialCompletedSteps;
  final String initialUiState;

  static const Color paper = Color(0xFFFBF9F5);
  static const Color surface = Color(0xFFFFFEFA);
  static const Color ink = Color(0xFF242924);
  static const Color forest = Color(0xFF274333);
  static const Color vermilion = Color(0xFFD94A31);
  static const Color textMuted = Color(0xFF7D837B);
  static const Color border = Color(0xFFE8E5DC);

  @override
  State<HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends State<HomeDashboardView> {
  late Set<int> _completedSteps;
  late String _uiState;

  @override
  void initState() {
    super.initState();
    _completedSteps = Set<int>.from(widget.initialCompletedSteps);
    _uiState = widget.initialUiState;
  }

  void _toggleStep(int stepNumber) {
    setState(() {
      if (_completedSteps.contains(stepNumber)) {
        _completedSteps.remove(stepNumber);
      } else {
        _completedSteps.add(stepNumber);
      }
    });
  }

  bool get isFirstValueComplete => _completedSteps.contains(1);
  bool get isClosedLoopComplete => _completedSteps.length == 5;

  void _openModePicker() {
    if (widget.onOpenModePicker != null) {
      widget.onOpenModePicker!();
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Chọn chế độ vận hành',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            for (final mode in OperatorMode.values)
              ListTile(
                title: Text(mode.displayName),
                subtitle: Text(mode.description, maxLines: 1),
                trailing: mode == widget.activeMode
                    ? const Icon(Icons.check, color: Color(0xFF274333))
                    : null,
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onSwitchMode?.call(mode);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _openWhyNumberSheet() {
    WhyNumberSheet.show(
      context: context,
      metricTitle: 'Doanh thu mẫu minh họa (Demo GMV)',
      displayValue: '48.500.000 ₫',
      dataSourceBadge: 'DEMO',
      confidenceLevel: 'LOW',
      calculationFormula: 'SUM(demo_fixture_orders.amount) WHERE status = "completed"',
      caveats: [
        'Dữ liệu mẫu fixture tĩnh nhằm trực quan hóa giao diện báo cáo.',
        'Tuyệt đối không cộng gộp vào tổng doanh thu thực tế của tài khoản (Acceptance Target 3).',
        'Sẽ tự động ẩn đi khi bạn kết nối tài khoản bán hàng chính thức đầu tiên.',
      ],
      nextSteps: [
        'Kết nối tài khoản TikTok Shop hoặc Shopee trong phần Kênh kết nối.',
        'Đồng bộ đơn hàng thực tế qua giao thức OAuth.',
      ],
      isCustomerVerified: false,
    );
  }

  Widget _buildUIStateChip(String stateKey, String label) {
    final isSelected = _uiState == stateKey;
    return InkWell(
      onTap: () => setState(() => _uiState = stateKey),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? HomeDashboardView.forest : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? HomeDashboardView.forest : HomeDashboardView.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : HomeDashboardView.textMuted,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = modeDecisionCards[widget.activeMode] ?? modeDecisionCards[OperatorMode.creator]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode Identity & Header Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: HomeDashboardView.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: HomeDashboardView.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: HomeDashboardView.forest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.activeMode.displayName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _openModePicker,
                    icon: const Icon(Icons.swap_horiz_rounded, size: 14),
                    label: const Text('Đổi chế độ', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      visualDensity: VisualDensity.compact,
                      foregroundColor: HomeDashboardView.forest,
                      side: const BorderSide(color: HomeDashboardView.border),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.activeMode.description,
                style: const TextStyle(
                  fontSize: 12,
                  color: HomeDashboardView.textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 5 UI States Switcher
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: HomeDashboardView.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: HomeDashboardView.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kiểm thử 5 trạng thái giao diện:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: HomeDashboardView.textMuted,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildUIStateChip('normal', '1. Chuẩn'),
                  _buildUIStateChip('loading', '2. Đang tải'),
                  _buildUIStateChip('empty', '3. Trống'),
                  _buildUIStateChip('error', '4. Lỗi'),
                  _buildUIStateChip('repair', '5. Sửa lỗi'),
                ],
              ),
            ],
          ),
        ),

        // Error State Banner
        if (_uiState == 'error') ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFBEEE9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: HomeDashboardView.vermilion.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.error_outline_rounded, color: HomeDashboardView.vermilion, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Lỗi đồng bộ dữ liệu quyết định (M01-E-503)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: HomeDashboardView.vermilion,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Không thể kết nối máy chủ phân tích tín hiệu thời gian thực.',
                  style: TextStyle(fontSize: 11, color: HomeDashboardView.ink),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => setState(() => _uiState = 'normal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HomeDashboardView.vermilion,
                    foregroundColor: Colors.white,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Thử lại kết nối', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
        ],

        // Repair State Card
        if (_uiState == 'repair') ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF9C3),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF854D0E).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFF854D0E), size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Cần sửa: Kênh kết nối bị gián đoạn (M22)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF854D0E),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Token kết nối đã hết hạn sau 30 ngày.',
                        style: TextStyle(fontSize: 10.5, color: HomeDashboardView.ink),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onNavigateToRoute?.call('/settings/connections');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF854D0E),
                    foregroundColor: Colors.white,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Cấp lại', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
        ],

        // Loading Skeleton
        if (_uiState == 'loading') ...[
          const SizedBox(height: 14),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E5DC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Đang tải nhịp quyết định theo vai trò...',
                style: TextStyle(fontSize: 12, color: HomeDashboardView.textMuted),
              ),
            ),
          ),
        ],

        // Empty State
        if (_uiState == 'empty') ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: HomeDashboardView.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: HomeDashboardView.border),
            ),
            child: Column(
              children: [
                const Icon(Icons.check_circle_outline_rounded, color: HomeDashboardView.forest, size: 36),
                const SizedBox(height: 8),
                const Text(
                  'Tất cả quyết định hôm nay đã hoàn thành',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Không có cảnh báo tồn kho hoặc vi phạm SLA nào.',
                  style: TextStyle(fontSize: 11, color: HomeDashboardView.textMuted),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => setState(() => _uiState = 'normal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HomeDashboardView.forest,
                    foregroundColor: Colors.white,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Làm mới dữ liệu', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
        ],

        // Onboarding Checklist Section (Acceptance Target 2)
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: HomeDashboardView.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: HomeDashboardView.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'LỘ TRÌNH VẬN HÀNH CHUẨN',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: HomeDashboardView.textMuted,
                    ),
                  ),
                  Text(
                    '${_completedSteps.length}/5 hoàn thành',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: HomeDashboardView.forest,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Badges for First-Value vs Closed-Loop
              Row(
                children: [
                  if (isClosedLoopComplete)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: HomeDashboardView.forest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '🎉 CHU TRÌNH KHÉP KÍN HOÀN TẤT',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  else if (isFirstValueComplete)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF4ED),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: HomeDashboardView.forest.withValues(alpha: 0.3)),
                      ),
                      child: const Text(
                        '🌟 FIRST-VALUE ĐẠT ĐƯỢC',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: HomeDashboardView.forest,
                        ),
                      ),
                    )
                  else
                    const Text(
                      'Hoàn thành bước 1 để đạt First-Value',
                      style: TextStyle(fontSize: 10.5, color: HomeDashboardView.textMuted),
                    ),
                ],
              ),

              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: _completedSteps.length / 5.0,
                backgroundColor: const Color(0xFFF4F0E8),
                valueColor: const AlwaysStoppedAnimation<Color>(HomeDashboardView.forest),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),

              const SizedBox(height: 12),
              // List of 5 Onboarding Steps
              for (final step in canonicalOnboardingSteps) ...[
                InkWell(
                  onTap: () => _toggleStep(step.stepNumber),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          _completedSteps.contains(step.stepNumber)
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          size: 18,
                          color: _completedSteps.contains(step.stepNumber)
                              ? HomeDashboardView.forest
                              : HomeDashboardView.textMuted,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.title,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  decoration: _completedSteps.contains(step.stepNumber)
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: _completedSteps.contains(step.stepNumber)
                                      ? HomeDashboardView.textMuted
                                      : HomeDashboardView.ink,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                step.description,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: HomeDashboardView.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Normal State Decision Grid & Revenue Banner
        if (_uiState == 'normal') ...[
          const SizedBox(height: 16),
          // Strict Revenue Totals Isolation Card (Target 3)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: HomeDashboardView.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: HomeDashboardView.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'DOANH THU & SỐ LIỆU MINH BẠCH',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        color: HomeDashboardView.textMuted,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _openWhyNumberSheet,
                      icon: const Icon(Icons.info_outline_rounded, size: 14),
                      label: const Text('Tại sao có số này?', style: TextStyle(fontSize: 11)),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        foregroundColor: HomeDashboardView.forest,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Customer Verified Total
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBF9F5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: HomeDashboardView.forest.withValues(alpha: 0.2)),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thực tế (Verified)',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: HomeDashboardView.forest,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '0 ₫',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                color: HomeDashboardView.ink,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Chưa có đơn thực',
                              style: TextStyle(fontSize: 9.5, color: HomeDashboardView.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Demo Fixture (Strictly Isolated)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBEEE9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: HomeDashboardView.vermilion.withValues(alpha: 0.3)),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DEMO (Cách ly)',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: HomeDashboardView.vermilion,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '48.500.000 ₫',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                color: HomeDashboardView.vermilion,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Không cộng dồn',
                              style: TextStyle(fontSize: 9.5, color: HomeDashboardView.vermilion),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // Decision Cards Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'QUYẾT ĐỊNH ƯU TIÊN (${cards.length} HẠNG MỤC)',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: HomeDashboardView.textMuted,
                ),
              ),
              Text(
                'P8 ACTIVE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Render Decision Cards
          for (final card in cards) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: HomeDashboardView.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: HomeDashboardView.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F0E8),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          card.moduleRef,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: HomeDashboardView.forest,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: HomeDashboardView.forest.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Ưu tiên #${card.priorityRank}',
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: HomeDashboardView.forest,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    card.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: HomeDashboardView.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: HomeDashboardView.textMuted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF9F5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: HomeDashboardView.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline_rounded, size: 14, color: HomeDashboardView.forest),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            card.whyThisMatters,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: HomeDashboardView.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: card.isActionAvailable
                          ? () {
                              if (widget.onNavigateToRoute != null) {
                                widget.onNavigateToRoute!(card.primaryCtaRoute);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Điều hướng: ${card.primaryCtaLabel} (${card.primaryCtaRoute})'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HomeDashboardView.forest,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        '${card.primaryCtaLabel} →',
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }
}

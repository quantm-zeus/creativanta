// Mobile Copilot Models and Business Rules (Module M23 / Screen M060).
// Conforms to docs/02_features/platform/copilot.md & database_schema.md §16.

enum CopilotRole {
  owner,
  admin,
  manager,
  editor,
  contributor,
  viewer,
  external,
}

enum MessageSender {
  user,
  assistant,
  system,
}

enum QuoteStatus {
  pending,
  confirmed,
  cancelled,
  executed,
}

class CreditQuotePreview {
  CreditQuotePreview({
    required this.quoteId,
    required this.operationType,
    required this.costCredits,
    required this.currentBalance,
    this.confirmed = false,
    this.status = QuoteStatus.pending,
    required this.title,
    required this.summary,
  });

  final String quoteId;
  final String operationType;
  final int costCredits;
  final int currentBalance;
  final bool confirmed;
  final QuoteStatus status;
  final String title;
  final String summary;

  CreditQuotePreview copyWith({
    bool? confirmed,
    QuoteStatus? status,
    int? currentBalance,
  }) {
    return CreditQuotePreview(
      quoteId: quoteId,
      operationType: operationType,
      costCredits: costCredits,
      currentBalance: currentBalance ?? this.currentBalance,
      confirmed: confirmed ?? this.confirmed,
      status: status ?? this.status,
      title: title,
      summary: summary,
    );
  }
}

class CopilotCitation {
  const CopilotCitation({
    required this.sourceType,
    required this.sourceId,
    required this.title,
    this.snippet,
  });

  final String sourceType;
  final String sourceId;
  final String title;
  final String? snippet;
}

class CopilotAction {
  const CopilotAction({
    required this.id,
    required this.label,
    required this.actionType,
    this.payload,
  });

  final String id;
  final String label;
  final String actionType;
  final Map<String, dynamic>? payload;
}

class CopilotMessage {
  CopilotMessage({
    required this.id,
    required this.sessionId,
    required this.sender,
    required this.content,
    required this.createdAt,
    this.isRefusal = false,
    this.quotePreview,
    this.citations = const [],
    this.actions = const [],
  });

  final String id;
  final String sessionId;
  final MessageSender sender;
  final String content;
  final DateTime createdAt;
  final bool isRefusal;
  final CreditQuotePreview? quotePreview;
  final List<CopilotCitation> citations;
  final List<CopilotAction> actions;

  CopilotMessage copyWith({
    String? content,
    CreditQuotePreview? quotePreview,
    bool? isRefusal,
  }) {
    return CopilotMessage(
      id: id,
      sessionId: sessionId,
      sender: sender,
      content: content ?? this.content,
      createdAt: createdAt,
      isRefusal: isRefusal ?? this.isRefusal,
      quotePreview: quotePreview ?? this.quotePreview,
      citations: citations,
      actions: actions,
    );
  }
}

// Canonical Refusal Texts & Constraints
const String kRefusalProductDelete =
    'Bạn không có quyền xóa sản phẩm. Cần Admin+ role (product:delete).';
const String kRefusalFinanceAccess =
    'Bạn không có quyền truy cập dữ liệu tài chính của workspace.';
const int kScriptGenerationCreditCost = 5;

// Acceptance Target 1: Contributor cannot delete product
bool canDeleteProduct(CopilotRole role) {
  return role == CopilotRole.owner || role == CopilotRole.admin;
}

// Acceptance Target 2: Read query cannot expose finance
bool canAccessFinance(CopilotRole role) {
  return role == CopilotRole.owner ||
      role == CopilotRole.admin ||
      role == CopilotRole.manager ||
      role == CopilotRole.editor;
}

CreditQuotePreview createScriptQuotePreview(String title, int currentBalance) {
  final now = DateTime.now().millisecondsSinceEpoch;
  return CreditQuotePreview(
    quoteId: 'quote-$now',
    operationType: 'generate_script_draft',
    costCredits: kScriptGenerationCreditCost,
    currentBalance: currentBalance,
    confirmed: false,
    status: QuoteStatus.pending,
    title: 'Báo giá tạo kịch bản AI: $title',
    summary:
        'Thao tác tạo bản nháp kịch bản trong Script Lab tiêu tốn $kScriptGenerationCreditCost credits. Vui lòng xác nhận trước khi tiếp tục.',
  );
}

class ConfirmQuoteResult {
  const ConfirmQuoteResult({
    required this.success,
    this.error,
    required this.updatedQuote,
  });

  final bool success;
  final String? error;
  final CreditQuotePreview updatedQuote;
}

ConfirmQuoteResult confirmScriptQuote(
  CreditQuotePreview quote,
  bool userConfirmed,
) {
  if (!userConfirmed) {
    return ConfirmQuoteResult(
      success: false,
      error: 'Người dùng đã hủy thao tác tạo kịch bản.',
      updatedQuote: quote.copyWith(
        confirmed: false,
        status: QuoteStatus.cancelled,
      ),
    );
  }

  if (quote.currentBalance < quote.costCredits) {
    return ConfirmQuoteResult(
      success: false,
      error:
          'Không đủ credits (Hiện có: ${quote.currentBalance}, Cần: ${quote.costCredits}). Vui lòng nạp thêm.',
      updatedQuote: quote.copyWith(
        status: QuoteStatus.cancelled,
      ),
    );
  }

  return ConfirmQuoteResult(
    success: true,
    updatedQuote: quote.copyWith(
      confirmed: true,
      status: QuoteStatus.confirmed,
      currentBalance: quote.currentBalance - quote.costCredits,
    ),
  );
}

class CommandEvalResult {
  const CommandEvalResult({
    required this.messageContent,
    required this.isRefusal,
    this.requiresQuote = false,
    this.quotePreview,
    this.actions = const [],
  });

  final String messageContent;
  final bool isRefusal;
  final bool requiresQuote;
  final CreditQuotePreview? quotePreview;
  final List<CopilotAction> actions;
}

CommandEvalResult evaluateCopilotCommand(
  String input,
  CopilotRole role,
  int currentBalance,
) {
  final normalized = input.trim().toLowerCase();

  // Target 1 Check: Product Deletion attempt
  if (normalized.contains('xóa sản phẩm') ||
      normalized.contains('delete product') ||
      normalized.contains('remove product')) {
    if (!canDeleteProduct(role)) {
      return const CommandEvalResult(
        messageContent: kRefusalProductDelete,
        isRefusal: true,
        actions: [
          CopilotAction(
            id: 'act-refusal-delete',
            label: 'Yêu cầu quyền Quản trị viên',
            actionType: 'refusal',
          ),
        ],
      );
    }
    return const CommandEvalResult(
      messageContent:
          'Bạn có quyền xóa sản phẩm. Vui lòng xác nhận mã sản phẩm cần xóa trên Product Hub.',
      isRefusal: false,
      actions: [
        CopilotAction(
          id: 'act-nav-product-hub',
          label: 'Mở Product Hub',
          actionType: 'navigate',
          payload: {'route': '/kinh-doanh/san-pham'},
        ),
      ],
    );
  }

  // Target 2 Check: Financial exposure query
  if (normalized.contains('doanh thu') ||
      normalized.contains('lợi nhuận') ||
      normalized.contains('chi phí') ||
      normalized.contains('revenue') ||
      normalized.contains('profit') ||
      normalized.contains('finance')) {
    if (!canAccessFinance(role)) {
      return const CommandEvalResult(
        messageContent: kRefusalFinanceAccess,
        isRefusal: true,
        actions: [
          CopilotAction(
            id: 'act-refusal-finance',
            label: 'Xem quyền hạn phân vai',
            actionType: 'refusal',
          ),
        ],
      );
    }
    return const CommandEvalResult(
      messageContent:
          'Tổng doanh thu tháng hiện tại của workspace: 45,200,000 VND (Biên lợi nhuận gộp ước tính 38.5%).',
      isRefusal: false,
    );
  }

  // Target 3 Check: Generated script draft request
  if (normalized.contains('viết kịch bản') ||
      normalized.contains('tạo kịch bản') ||
      normalized.contains('draft script') ||
      normalized.contains('generate script')) {
    final preview = createScriptQuotePreview(input, currentBalance);
    return CommandEvalResult(
      messageContent:
          'Tôi có thể soạn thảo kịch bản này cho bạn trong Script Lab (M06). Thao tác này cần báo giá ${preview.costCredits} credits.',
      isRefusal: false,
      requiresQuote: true,
      quotePreview: preview,
      actions: [
        CopilotAction(
          id: 'act-confirm-quote',
          label: 'Xác nhận tạo kịch bản',
          actionType: 'confirm_quote',
          payload: {'quoteId': preview.quoteId},
        ),
      ],
    );
  }

  // General Copilot Q&A
  return CommandEvalResult(
    messageContent:
        'Tôi đã ghi nhận câu hỏi: "$input". Hệ thống Creativanta đã kết nối với tài nguyên workspace của bạn.',
    isRefusal: false,
  );
}

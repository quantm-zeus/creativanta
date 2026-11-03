// Mobile Copilot View (Screen M060 / Module M23).
// Conforms to docs/02_features/platform/copilot.md & database_schema.md §16.

import 'package:flutter/material.dart';
import '../../copilot/copilot_models.dart';

class CopilotView extends StatefulWidget {
  const CopilotView({
    super.key,
    required this.workspaceId,
    required this.userId,
    this.initialRole = CopilotRole.contributor,
    this.initialCredits = 100,
  });

  final String workspaceId;
  final String userId;
  final CopilotRole initialRole;
  final int initialCredits;

  static const Color paper = Color(0xFFFBF9F5);
  static const Color ink = Color(0xFF242924);
  static const Color forest = Color(0xFF274333);
  static const Color vermilion = Color(0xFFD94A31);

  @override
  State<CopilotView> createState() => _CopilotViewState();
}

class _CopilotViewState extends State<CopilotView> {
  late CopilotRole _currentRole;
  late int _creditBalance;
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<CopilotMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _currentRole = widget.initialRole;
    _creditBalance = widget.initialCredits;

    // Welcome message
    _messages.add(
      CopilotMessage(
        id: 'msg-welcome',
        sessionId: 'session-m060',
        sender: MessageSender.assistant,
        content:
            'Xin chào! Tôi là Creativanta Copilot, trợ lý sáng tạo & phân tích thông minh cho workspace của bạn.',
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final userMsg = CopilotMessage(
      id: 'msg-user-${DateTime.now().millisecondsSinceEpoch}',
      sessionId: 'session-m060',
      sender: MessageSender.user,
      content: trimmed,
      createdAt: DateTime.now(),
    );

    final evalResult = evaluateCopilotCommand(
      trimmed,
      _currentRole,
      _creditBalance,
    );

    final assistantMsg = CopilotMessage(
      id: 'msg-bot-${DateTime.now().millisecondsSinceEpoch}',
      sessionId: 'session-m060',
      sender: MessageSender.assistant,
      content: evalResult.messageContent,
      createdAt: DateTime.now(),
      isRefusal: evalResult.isRefusal,
      quotePreview: evalResult.quotePreview,
      actions: evalResult.actions,
    );

    setState(() {
      _messages.add(userMsg);
      _messages.add(assistantMsg);
    });

    _inputController.clear();
    _scrollToBottom();
  }

  void _handleQuoteAction(String messageId, bool confirm) {
    final idx = _messages.indexWhere((m) => m.id == messageId);
    if (idx == -1) return;

    final msg = _messages[idx];
    if (msg.quotePreview == null) return;

    final result = confirmScriptQuote(msg.quotePreview!, confirm);

    setState(() {
      if (result.success) {
        _creditBalance = result.updatedQuote.currentBalance;
        _messages[idx] = msg.copyWith(
          quotePreview: result.updatedQuote,
          content:
              '${msg.content}\n\n✅ Đã xác nhận báo giá! Bản nháp kịch bản đã được khởi tạo trong Script Lab.',
        );
      } else {
        _messages[idx] = msg.copyWith(
          quotePreview: result.updatedQuote,
          content: '${msg.content}\n\n❌ Đã hủy: ${result.error}',
        );
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CopilotView.paper,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Creativanta Copilot',
              style: TextStyle(
                color: CopilotView.ink,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Trợ lý không gian làm việc (M23)',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
            ),
          ],
        ),
        actions: [
          // Credit Balance Badge
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFA5D6A7)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🪙 ', style: TextStyle(fontSize: 12)),
                Text(
                  '$_creditBalance cr',
                  key: const Key('copilot-credit-badge'),
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Role Menu
          PopupMenuButton<CopilotRole>(
            initialValue: _currentRole,
            tooltip: 'Đổi vai trò phân quyền',
            onSelected: (role) {
              setState(() {
                _currentRole = role;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: CopilotRole.contributor,
                child: Text('Role: Contributor'),
              ),
              const PopupMenuItem(
                value: CopilotRole.admin,
                child: Text('Role: Admin'),
              ),
              const PopupMenuItem(
                value: CopilotRole.manager,
                child: Text('Role: Manager'),
              ),
              const PopupMenuItem(
                value: CopilotRole.viewer,
                child: Text('Role: Viewer'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Chip(
                label: Text(
                  _currentRole.name.toUpperCase(),
                  key: const Key('copilot-role-chip'),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.grey.shade200,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          // Quick Prompts Bar
          _buildQuickPrompts(),
          // Input Box
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(CopilotMessage msg) {
    final isUser = msg.sender == MessageSender.user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isUser ? 'Bạn' : 'Copilot Trợ Lý',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isUser
                  ? CopilotView.forest
                  : msg.isRefusal
                      ? const Color(0xFFFFF0F0)
                      : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 0),
                bottomRight: Radius.circular(isUser ? 0 : 16),
              ),
              border: Border.all(
                color: isUser
                    ? CopilotView.forest
                    : msg.isRefusal
                        ? const Color(0xFFFFCDD2)
                        : Colors.grey.shade300,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (msg.isRefusal) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.block, size: 14, color: CopilotView.vermilion),
                      SizedBox(width: 4),
                      Text(
                        'Từ chối quyền truy cập',
                        key: Key('refusal-badge'),
                        style: TextStyle(
                          color: CopilotView.vermilion,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  msg.content,
                  key: Key('message-content-${msg.id}'),
                  style: TextStyle(
                    color: isUser
                        ? Colors.white
                        : msg.isRefusal
                            ? const Color(0xFFB71C1C)
                            : CopilotView.ink,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                if (msg.quotePreview != null) ...[
                  const SizedBox(height: 10),
                  _buildQuoteCard(msg),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(CopilotMessage msg) {
    final quote = msg.quotePreview!;
    final isPending = quote.status == QuoteStatus.pending;
    final isConfirmed = quote.status == QuoteStatus.confirmed;

    return Container(
      key: Key('quote-card-${msg.id}'),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isPending
            ? const Color(0xFFFFFDE7)
            : isConfirmed
                ? const Color(0xFFE8F5E9)
                : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isPending
              ? const Color(0xFFFFF59D)
              : isConfirmed
                  ? const Color(0xFFA5D6A7)
                  : const Color(0xFFFFCDD2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  quote.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: CopilotView.ink,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isPending
                      ? const Color(0xFFFFF9C4)
                      : isConfirmed
                          ? const Color(0xFFC8E6C9)
                          : const Color(0xFFFFCDD2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isPending
                      ? 'Chờ xác nhận'
                      : isConfirmed
                          ? 'Đã xác nhận'
                          : 'Đã hủy',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isPending
                        ? const Color(0xFFF57F17)
                        : isConfirmed
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFC62828),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            quote.summary,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Chi phí: ',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              Text(
                '${quote.costCredits} credits',
                key: const Key('quote-cost-text'),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE65100),
                ),
              ),
            ],
          ),
          if (isPending) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  key: const Key('btn-quote-cancel'),
                  onPressed: () => _handleQuoteAction(msg.id, false),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: Colors.grey.shade700,
                  ),
                  child: const Text('Hủy bỏ', style: TextStyle(fontSize: 11)),
                ),
                const SizedBox(width: 6),
                ElevatedButton(
                  key: const Key('btn-quote-confirm'),
                  onPressed: () => _handleQuoteAction(msg.id, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CopilotView.forest,
                    foregroundColor: Colors.white,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                  child: Text(
                    'Xác nhận (${quote.costCredits} cr)',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickPrompts() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ActionChip(
              key: const Key('chip-delete-product'),
              label: const Text('🗑️ Xóa sản phẩm', style: TextStyle(fontSize: 11)),
              backgroundColor: const Color(0xFFFFEBEE),
              onPressed: () => _sendMessage('Xóa sản phẩm này'),
            ),
            const SizedBox(width: 6),
            ActionChip(
              key: const Key('chip-query-finance'),
              label: const Text('📊 Xem doanh thu', style: TextStyle(fontSize: 11)),
              backgroundColor: const Color(0xFFFFF8E1),
              onPressed: () => _sendMessage('Doanh thu tháng này thế nào?'),
            ),
            const SizedBox(width: 6),
            ActionChip(
              key: const Key('chip-generate-script'),
              label: const Text('🎬 Viết kịch bản AI', style: TextStyle(fontSize: 11)),
              backgroundColor: const Color(0xFFE8F5E9),
              onPressed: () => _sendMessage('Viết kịch bản video TikTok 30s'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('copilot-text-input'),
                controller: _inputController,
                decoration: InputDecoration(
                  hintText: 'Hỏi Copilot hoặc yêu cầu hỗ trợ...',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: CopilotView.paper,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: CopilotView.forest),
                  ),
                ),
                onSubmitted: _sendMessage,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              key: const Key('copilot-send-button'),
              icon: const Icon(Icons.send, color: CopilotView.forest),
              onPressed: () => _sendMessage(_inputController.text),
            ),
          ],
        ),
      ),
    );
  }
}

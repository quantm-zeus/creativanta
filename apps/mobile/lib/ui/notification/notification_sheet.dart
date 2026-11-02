import 'package:flutter/material.dart';

enum NotificationPriority { urgent, high, normal, low }

class MobileScopedNotification {
  final String id;
  final String title;
  final String body;
  final NotificationPriority priority;
  final String moduleRef;
  final DateTime createdAt;
  bool isRead;
  bool isDismissed;

  MobileScopedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.priority,
    required this.moduleRef,
    required this.createdAt,
    this.isRead = false,
    this.isDismissed = false,
  });
}

class NotificationSheet extends StatefulWidget {
  const NotificationSheet({super.key});

  static const Color paper = Color(0xFFFBF9F5);
  static const Color surface = Color(0xFFFFFEFA);
  static const Color ink = Color(0xFF242924);
  static const Color forest = Color(0xFF274333);
  static const Color vermilion = Color(0xFFD94A31);
  static const Color textMuted = Color(0xFF7D837B);
  static const Color border = Color(0xFFE8E5DC);

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const NotificationSheet(),
    );
  }

  @override
  State<NotificationSheet> createState() => _NotificationSheetState();
}

class _NotificationSheetState extends State<NotificationSheet> {
  final List<MobileScopedNotification> _notifications = [
    MobileScopedNotification(
      id: 'm-notif-001',
      title: 'Cảnh báo vi phạm SLA xử lý đơn hàng (M19)',
      body: 'Có 3 đơn hàng Shopee đã quá hạn xử lý 18 giờ. Cần xác nhận gửi hàng trước 16:00 hôm nay.',
      priority: NotificationPriority.urgent,
      moduleRef: 'M19',
      createdAt: DateTime.now().subtract(const Duration(minutes: 35)),
    ),
    MobileScopedNotification(
      id: 'm-notif-002',
      title: 'Cần cấp lại quyền tài khoản TikTok Shop (M11)',
      body: 'Token kết nối kênh TikTok Shop hết hạn sau 30 ngày. Vui lòng cấp lại quyền.',
      priority: NotificationPriority.high,
      moduleRef: 'M11',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    MobileScopedNotification(
      id: 'm-notif-003',
      title: 'Hướng dẫn mới: Tối ưu kịch bản AI Video Studio',
      body: 'Tài liệu hướng dẫn kỹ thuật viết prompt viral cho nhà sáng tạo.',
      priority: NotificationPriority.normal,
      moduleRef: 'M07',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    MobileScopedNotification(
      id: 'm-notif-004',
      title: 'Báo cáo nhịp vận hành tuần đã sẵn sàng (M01)',
      body: 'Tổng kết chỉ số tăng trưởng tuần qua đã được tổng hợp xong.',
      priority: NotificationPriority.low,
      moduleRef: 'M01',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  String _filter = 'all';

  List<MobileScopedNotification> get _activeNotifications =>
      _notifications.where((n) => !n.isDismissed).toList();

  List<MobileScopedNotification> get _filteredNotifications {
    final active = _activeNotifications;
    if (_filter == 'unread') return active.where((n) => !n.isRead).toList();
    if (_filter == 'urgent') return active.where((n) => n.priority == NotificationPriority.urgent).toList();
    return active;
  }

  int get _unreadCount => _activeNotifications.where((n) => !n.isRead).length;

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _markRead(String id) {
    setState(() {
      final notif = _notifications.firstWhere((n) => n.id == id);
      notif.isRead = true;
    });
  }

  void _dismiss(String id) {
    setState(() {
      final notif = _notifications.firstWhere((n) => n.id == id);
      notif.isDismissed = true;
    });
  }

  (String label, Color bg, Color text) _priorityMeta(NotificationPriority p) {
    switch (p) {
      case NotificationPriority.urgent:
        return ('Khẩn cấp', NotificationSheet.vermilion, Colors.white);
      case NotificationPriority.high:
        return ('Cao', const Color(0xFFFBEEE9), NotificationSheet.vermilion);
      case NotificationPriority.normal:
        return ('Bình thường', const Color(0xFFEFF5F0), NotificationSheet.forest);
      case NotificationPriority.low:
        return ('Tham khảo', const Color(0xFFF1EFEA), NotificationSheet.textMuted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: NotificationSheet.paper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Handle
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4D0C5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Thông báo vận hành',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: NotificationSheet.ink,
                        ),
                      ),
                      if (_unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: NotificationSheet.vermilion,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$_unreadCount mới',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (_unreadCount > 0)
                    TextButton(
                      onPressed: _markAllRead,
                      child: const Text(
                        'Đọc tất cả',
                        style: TextStyle(
                          color: NotificationSheet.forest,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  _buildFilterChip('all', 'Tất cả (${_activeNotifications.length})'),
                  const SizedBox(width: 8),
                  _buildFilterChip('unread', 'Chưa đọc ($_unreadCount)'),
                  const SizedBox(width: 8),
                  _buildFilterChip('urgent', 'Khẩn cấp'),
                ],
              ),
            ),
            const Divider(height: 1, color: NotificationSheet.border),

            // List
            Expanded(
              child: _filteredNotifications.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'Không có thông báo nào cần xử lý.',
                          style: TextStyle(
                            fontSize: 13,
                            color: NotificationSheet.textMuted,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredNotifications.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = _filteredNotifications[index];
                        final meta = _priorityMeta(item.priority);
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: NotificationSheet.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: item.isRead
                                  ? NotificationSheet.border
                                  : NotificationSheet.forest.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: meta.$2,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      meta.$1,
                                      style: TextStyle(
                                        color: meta.$3,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item.moduleRef,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 10,
                                      color: NotificationSheet.textMuted,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: NotificationSheet.ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.body,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  height: 1.4,
                                  color: NotificationSheet.textMuted,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (!item.isRead)
                                    TextButton(
                                      onPressed: () => _markRead(item.id),
                                      child: const Text('Đã đọc', style: TextStyle(fontSize: 11)),
                                    ),
                                  TextButton(
                                    onPressed: () => _dismiss(item.id),
                                    child: const Text(
                                      'Bỏ qua',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: NotificationSheet.vermilion,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _filter == key;
    return GestureDetector(
      onTap: () => setState(() => _filter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? NotificationSheet.forest : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : NotificationSheet.textMuted,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../referral/referral_models.dart';

/// Screen M062 — Mobile Referral Center
/// Upstream: docs/03_screens/mobile/screen_mobile_referral.md
/// Route: /m/settings/referral
class MobileReferralScreen extends StatefulWidget {
  final String initialReferralCode;
  final int initialQualifiedCount;
  final MobileReferralFunnel? initialFunnel;

  const MobileReferralScreen({
    super.key,
    this.initialReferralCode = 'QUANNG2026',
    this.initialQualifiedCount = 12,
    this.initialFunnel,
  });

  @override
  State<MobileReferralScreen> createState() => _MobileReferralScreenState();
}

class _MobileReferralScreenState extends State<MobileReferralScreen> {
  late String referralCode;
  late int qualifiedCount;
  late MobileReferralFunnel funnel;
  late MobileTierProgress tierProgress;
  String? toastMessage;

  @override
  void initState() {
    super.initState();
    referralCode = widget.initialReferralCode;
    qualifiedCount = widget.initialQualifiedCount;
    tierProgress = calculateMobileTier(qualifiedCount);
    funnel = widget.initialFunnel ??
        const MobileReferralFunnel(
          clicks: 45,
          signups: 12,
          paid: 3,
          creditsEarned: '150',
          creditsPending: '75',
        );
  }

  void _copyToClipboard(BuildContext context) {
    final link = 'https://creativanta.vn/r/$referralCode';
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép liên kết giới thiệu!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _sendReminder(BuildContext context, String friendName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã gửi lời nhắc tới $friendName!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shareLink = 'creativanta.vn/r/$referralCode';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Giới thiệu bạn bè', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Referral Link Card
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🔗 Liên kết giới thiệu của bạn', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.cyan.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              shareLink,
                              style: const TextStyle(fontFamily: 'monospace', color: Colors.cyanAccent, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          key: const Key('copy_button'),
                          onPressed: () => _copyToClipboard(context),
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('📋 Copy'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue[300],
                            side: BorderSide(color: Colors.blue.withValues(alpha: 0.5)),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          child: const Text('📱 Zalo'),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.indigo[300],
                            side: BorderSide(color: Colors.indigo.withValues(alpha: 0.5)),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          child: const Text('📘 Facebook'),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white70,
                            side: const BorderSide(color: Colors.white24),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          child: const Text('📤 Khác'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 2. Reward Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
              ),
              child: const Row(
                children: [
                  Text('🎁', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Mỗi bạn bè đăng ký + nâng cấp: BẠN nhận 75cr, HỌ nhận 50cr miễn phí!',
                      style: TextStyle(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Conversion Funnel Card
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📊 Phễu chuyển đổi tăng trưởng', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _metricBox('👆 Lượt Click', '${funnel.clicks}', '100%'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _metricBox('📝 Đăng ký', '${funnel.signups}', funnel.clickToSignupPercent),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _metricBox('💳 Trả phí', '${funnel.paid}', funnel.signupToPaidPercent),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 4. Credits Summary Card
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _creditRow('💰 Tổng kiếm được', '225 credits', Colors.cyanAccent),
                    const Divider(color: Colors.white12),
                    _creditRow('✅ Đã nhận vào ví', '${funnel.creditsEarned} credits', Colors.greenAccent),
                    const Divider(color: Colors.white12),
                    _creditRow('⏳ Chờ xử lý', '${funnel.creditsPending} credits (1 bạn chưa trả phí)', Colors.amberAccent),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 5. Tier Progress Card
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tierProgress.tierName, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        Text('${(tierProgress.progressPercent * 100).toInt()}% lên ${tierProgress.nextTierName}', style: const TextStyle(color: Colors.cyanAccent, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: tierProgress.progressPercent,
                        minHeight: 8,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('• Hiện tại: ${tierProgress.rewardMultiplier} credits mỗi lượt', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    const Text('• Gold (21 ref): 2.0x thưởng + 10% hoa hồng định kỳ 🎉', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const Text('• Platinum (51 ref): 2.5x thưởng + 15% hoa hồng trọn đời 🏆', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    if (tierProgress.referralsToNextTier > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        '🎯 Chỉ còn ${tierProgress.referralsToNextTier} bạn nữa để đạt ${tierProgress.nextTierName}!',
                        style: const TextStyle(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 6. Referral History
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('👥 Lịch sử giới thiệu', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _historyItem('Nguyễn A', 'Pro plan', '+75cr ✅', Colors.greenAccent, '5 ngày trước', null),
                    _historyItem('Lê C', 'Pro plan', '+75cr ✅', Colors.greenAccent, '15 ngày trước', null),
                    _historyItem('Trần B', 'Free plan', '⏳ Chờ nâng cấp', Colors.amberAccent, '12 ngày trước', () => _sendReminder(context, 'Trần B')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricBox(String title, String count, String rate) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white60, fontSize: 11)),
          const SizedBox(height: 4),
          Text(count, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(rate, style: const TextStyle(color: Colors.cyanAccent, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _creditRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text(value, style: TextStyle(color: valueColor, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _historyItem(String name, String plan, String status, Color statusColor, String timeAgo, VoidCallback? onRemind) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('👤 $name', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
              Text('$plan · $timeAgo', style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
          Row(
            children: [
              Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
              if (onRemind != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: onRemind,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Nhắc nhở', style: TextStyle(color: Colors.cyanAccent, fontSize: 11)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

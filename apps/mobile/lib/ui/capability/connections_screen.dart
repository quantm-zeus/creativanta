import 'package:flutter/material.dart';
import 'package:creativanta_mobile/capability/capability_models.dart';
import 'package:creativanta_mobile/generated/creativanta/admin/v1/capability.pb.dart';

/// M058 Mobile Connected Accounts & Capability Status Screen (P0-07 / M22).
class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({
    super.key,
    this.isImpersonationSession = false,
  });

  final bool isImpersonationSession;

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  bool _killSwitchActive = false;
  bool _verifiedPostProbe = false;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.utc(2026, 11, 2, 8, 0);
    final verification = _verifiedPostProbe
        ? MobileActionVerification(
            platform: 'tiktok',
            actionKey: 'publish_post',
            appApproved: true,
            grantedScopes: const <String>['video.publish', 'video.upload'],
            requiredScopes: const <String>['video.publish', 'video.upload'],
            accountEligible: true,
            supportedMarkets: const <String>['VN', 'SG'],
            probeMethod: 'POST',
            probePassed: true,
            checkedAt: now.subtract(const Duration(minutes: 2)),
            validUntil: now.add(const Duration(hours: 24)),
          )
        : null;

    final verdict = evaluateMobileActionCapability(
      platform: 'tiktok',
      actionKey: 'publish_post',
      requiresWrite: true,
      isUnsupportedByPlatform: false,
      targetMarket: 'VN',
      now: now,
      policyNoteVi:
          'TikTok Content Posting API yêu cầu App Audit được duyệt và quyền video.publish.',
      fallbackInstructionsVi:
          'Tải video xuống thiết bị và mở ứng dụng TikTok để đăng thủ công.',
      verification: verification,
      killSwitchActive: _killSwitchActive,
      killSwitchReasonVi:
          'Công tắc ngắt khẩn cấp (Kill Switch) đang bật cho TikTok.',
    );

    final healthScore = computeMobileCompositeHealthScore(
      availabilityScore: _killSwitchActive ? 40 : 96,
      errorRateScore: _killSwitchActive ? 50 : 92,
      latencyScore: 88,
      rateLimitScore: 90,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết nối & Năng lực Nền tảng (M058)'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          if (widget.isImpersonationSession)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Phiên Impersonation Chỉ đọc (read_only · 30m): Mọi thao tác kết nối hoặc ngắt kết nối đều bị khóa.',
                key: Key('impersonation-readonly-banner'),
              ),
            ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'TikTok Shop & Creator VN · Điểm sức khỏe: $healthScore/100',
                    key: const Key('health-score-headline'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    verdict.state == CapabilityState.CAPABILITY_STATE_NATIVE &&
                            verdict.executable
                        ? 'Trạng thái: Tự động (Native API) — Cho phép thực thi'
                        : 'Trạng thái: Chặn tự động thực thi (${verdict.state.name})',
                    key: const Key('capability-verdict-text'),
                  ),
                  const SizedBox(height: 6),
                  Text('Lý do: ${verdict.reasonVi}'),
                  const SizedBox(height: 6),
                  Text('Ghi chú chính sách: ${verdict.policyNoteVi}'),
                  const SizedBox(height: 6),
                  Text('Dự phòng: ${verdict.fallbackInstructionsVi}'),
                  const Divider(height: 24),
                  SwitchListTile(
                    key: const Key('toggle-post-probe-switch'),
                    title: const Text('Đã xác minh POST Probe (<10 phút)'),
                    value: _verifiedPostProbe,
                    onChanged: (bool value) {
                      setState(() {
                        _verifiedPostProbe = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    key: const Key('toggle-kill-switch'),
                    title: const Text('Kích hoạt Kill Switch khẩn cấp'),
                    value: _killSwitchActive,
                    onChanged: (bool value) {
                      setState(() {
                        _killSwitchActive = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    key: const Key('disconnect-account-button'),
                    onPressed: widget.isImpersonationSession ? null : () {},
                    child: const Text('Ngắt kết nối tài khoản'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

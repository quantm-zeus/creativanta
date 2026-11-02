import 'package:flutter/material.dart';
import 'package:creativanta_mobile/generated/creativanta/intelligence/v1/trend.pbenum.dart';
import 'package:creativanta_mobile/trend/trend_models.dart';

class TrendRadarView extends StatefulWidget {
  const TrendRadarView({
    super.key,
    required this.currentWorkspaceId,
    required this.currentUserId,
  });

  final String currentWorkspaceId;
  final String currentUserId;

  static const Color paper = Color(0xFFFBF9F5);
  static const Color ink = Color(0xFF242924);
  static const Color forest = Color(0xFF274333);
  static const Color vermilion = Color(0xFFD94A31);

  @override
  State<TrendRadarView> createState() => _TrendRadarViewState();
}

class _TrendRadarViewState extends State<TrendRadarView> {
  // Connector statuses
  bool _isTikTokConnected = true;
  final bool _isShopeeConnected = true;

  // Search & Filter state
  String _searchQuery = '';
  String _selectedPlatform = 'all';

  // Watchlist & alerts state
  final Set<String> _watchlistIds = {};
  final Map<String, DateTime> _fingerprints = {};
  List<WatchlistAlertModel> _alerts = [];
  int _suppressedCount = 0;
  String? _stormBanner;

  late List<TrendSummary> _baseTrends;

  @override
  void initState() {
    super.initState();
    _initTrends();
  }

  void _initTrends() {
    _baseTrends = [
      TrendSummary(
        id: 'm-tr-01',
        workspaceId: widget.currentWorkspaceId,
        title: 'Review nồi chiên không dầu hơi nước 15L',
        category: 'Home & Living',
        platform: 'TikTok',
        velocity: 94.0,
        freshnessScore: 92.0,
        saturationScore: 20.0,
        strengthScore: TrendSummary.calculateStrengthScore(94.0, 92.0, 20.0),
        confidence: ConfidenceBand.CONFIDENCE_BAND_HIGH,
        sourceClass: SourceClass.SOURCE_CLASS_OFFICIAL,
        isDegraded: false,
        sampleSize: 1420,
        whyNow: 'Mùa tiệc cuối năm kích cầu dòng nồi chiên hơi nước chống khô',
        relevanceDescription: 'Lượng tìm kiếm tăng vọt 340% trên TikTok Shop',
      ),
      TrendSummary(
        id: 'm-tr-02',
        workspaceId: widget.currentWorkspaceId,
        title: 'Serum phục hồi B5 + Rau má hữu cơ',
        category: 'Beauty',
        platform: 'Shopee',
        velocity: 86.0,
        freshnessScore: 88.0,
        saturationScore: 35.0,
        strengthScore: TrendSummary.calculateStrengthScore(86.0, 88.0, 35.0),
        confidence: ConfidenceBand.CONFIDENCE_BAND_HIGH,
        sourceClass: SourceClass.SOURCE_CLASS_OFFICIAL,
        isDegraded: false,
        sampleSize: 980,
        whyNow: 'Thời tiết giao mùa hanh khô, người dùng tìm kiếm sản phẩm dịu nhẹ',
        relevanceDescription: 'Tỷ lệ chốt đơn livestream tăng 180%',
      ),
      TrendSummary(
        id: 'm-tr-03',
        workspaceId: widget.currentWorkspaceId,
        title: 'Bàn phím cơ công thái học Alice layout',
        category: 'Tech & Gadgets',
        platform: 'YouTube',
        velocity: 80.0,
        freshnessScore: 85.0,
        saturationScore: 28.0,
        strengthScore: TrendSummary.calculateStrengthScore(80.0, 85.0, 28.0),
        confidence: ConfidenceBand.CONFIDENCE_BAND_MEDIUM_HIGH,
        sourceClass: SourceClass.SOURCE_CLASS_OFFICIAL,
        isDegraded: false,
        sampleSize: 540,
        whyNow: 'Dân văn phòng chú trọng bảo vệ cổ tay khi làm việc hybrid',
        relevanceDescription: 'CTR video unboxing đạt 8.4%',
      ),
    ];
  }

  void _toggleTikTokConnection() {
    setState(() {
      _isTikTokConnected = !_isTikTokConnected;
    });
  }

  void _toggleWatchlist(String trendId) {
    setState(() {
      if (_watchlistIds.contains(trendId)) {
        _watchlistIds.remove(trendId);
      } else {
        _watchlistIds.add(trendId);
      }
    });
  }

  void _runAlertEvaluation({bool simulateStorm = false}) {
    final breaches = <Map<String, dynamic>>[];
    final evaluated = _getProcessedTrends();

    for (final t in evaluated) {
      if (t.velocity >= 80.0) {
        breaches.add({
          'workspaceId': widget.currentWorkspaceId,
          'watchlistId': 'wl-mobile-01',
          'trendId': t.id,
          'title': t.title,
          'metric': 'velocity',
          'threshold': 80.0,
          'actual': t.velocity,
        });
      }
    }

    if (simulateStorm) {
      for (var i = 1; i <= 6; i++) {
        breaches.add({
          'workspaceId': widget.currentWorkspaceId,
          'watchlistId': 'wl-mobile-01',
          'trendId': 'storm-$i',
          'title': 'Bão xu hướng #$i',
          'metric': 'velocity',
          'threshold': 80.0,
          'actual': 85.0 + i,
        });
      }
    }

    final res = evaluateMobileAlerts(
      breaches: breaches,
      existingFingerprints: _fingerprints,
      cooldownMinutes: 60,
    );

    setState(() {
      _alerts = [...res.emittedAlerts, ..._alerts];
      _suppressedCount += res.suppressedCount;
      _fingerprints.addAll(res.updatedFingerprints);
      if (res.emittedAlerts.any((a) => a.isBatchedSummary)) {
        _stormBanner = 'Bão cảnh báo: >5 vi phạm cùng lúc đã được gộp thành 1 thông báo tổng hợp (EC-M02-004)';
      } else {
        _stormBanner = null;
      }
    });
  }

  List<TrendSummary> _getProcessedTrends() {
    // 1. Evaluate degradation (Target 1)
    final degraded = _baseTrends.map((t) {
      var item = t.copyWith(isSavedToWatchlist: _watchlistIds.contains(t.id));
      item = item.copyWithDegradation(_isTikTokConnected, 'TikTok');
      item = item.copyWithDegradation(_isShopeeConnected, 'Shopee');
      return item;
    }).toList();

    // 2. Tenant-scoped search & filter (Target 3)
    return searchAndFilterMobileTrends(
      trends: degraded,
      currentWorkspaceId: widget.currentWorkspaceId,
      query: _searchQuery,
      platform: _selectedPlatform,
    );
  }

  void _openWatchlistSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Watchlist & Cảnh báo bứt phá',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: TrendRadarView.ink,
                              ),
                            ),
                            Text(
                              'Khử trùng lặp qua Fingerprint & Cooldown 60p',
                              style: TextStyle(fontSize: 11, color: Color(0xFF7D837B)),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const Divider(),
                    if (_stormBanner != null) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBEEE9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: TrendRadarView.vermilion),
                        ),
                        child: Text(
                          _stormBanner!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: TrendRadarView.vermilion,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    // Action controls
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            key: const Key('mobile_run_alerts_btn'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TrendRadarView.forest,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              _runAlertEvaluation(simulateStorm: false);
                              setSheetState(() {});
                            },
                            child: const Text('Quét cảnh báo (Ngưỡng 80%)', style: TextStyle(fontSize: 11)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            key: const Key('mobile_simulate_storm_btn'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: TrendRadarView.vermilion,
                              side: const BorderSide(color: TrendRadarView.vermilion),
                            ),
                            onPressed: () {
                              _runAlertEvaluation(simulateStorm: true);
                              setSheetState(() {});
                            },
                            child: const Text('Giả lập bão (>5 vi phạm)', style: TextStyle(fontSize: 11)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Deduplication stats
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1EFEA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('Đã phát', style: TextStyle(fontSize: 11, color: Color(0xFF7D837B))),
                              Text('${_alerts.length}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('Đã khử trùng (Suppressed)', style: TextStyle(fontSize: 11, color: Color(0xFF7D837B))),
                              Text('$_suppressedCount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: TrendRadarView.vermilion)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Lịch sử cảnh báo',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (_alerts.isEmpty)
                      const Text(
                        'Chưa có cảnh báo nào được kích hoạt.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF7D837B)),
                      )
                    else
                      ..._alerts.map((a) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE8E5DC)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      a.trendTitle,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  ),
                                  if (a.isBatchedSummary)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFBEEE9),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'GỘP ${a.batchedAlertCount}',
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: TrendRadarView.vermilion,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Chỉ số: ${a.metricName} = ${a.actualValue}% (Ngưỡng: ${a.thresholdValue}%)',
                                style: const TextStyle(fontSize: 10, color: Color(0xFF7D837B)),
                              ),
                              Text(
                                'FP: ${a.fingerprint}',
                                style: const TextStyle(fontSize: 9, fontFamily: 'monospace', color: Color(0xFF7D837B)),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final processed = _getProcessedTrends();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top banner: Header & Watchlist trigger
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trend Fusion Radar (M02)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: TrendRadarView.ink,
                  ),
                ),
                Text(
                  'Tín hiệu xu hướng đa nền tảng & chấm điểm đa chiều',
                  style: TextStyle(fontSize: 11, color: Color(0xFF7D837B)),
                ),
              ],
            ),
            ElevatedButton.icon(
              key: const Key('mobile_open_wl_sheet'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TrendRadarView.forest,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
              onPressed: _openWatchlistSheet,
              icon: const Icon(Icons.bookmark_outline, size: 16),
              label: Text('Watchlist (${_watchlistIds.length})', style: const TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Acceptance Target 1: Degraded Source Alert Banner
        if (!_isTikTokConnected) ...[
          Container(
            key: const Key('mobile_degraded_banner'),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFBEEE9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TrendRadarView.vermilion.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: TrendRadarView.vermilion, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Nguồn TikTok bị gián đoạn (Token hết hạn)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: TrendRadarView.vermilion,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Hệ thống chuyển sang chế độ dữ liệu ước tính (ESTIMATED) với độ tin cậy thấp (CONFIDENCE_BAND_LOW).',
                  style: TextStyle(fontSize: 11, color: TrendRadarView.ink),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TrendRadarView.vermilion,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                      onPressed: _toggleTikTokConnection,
                      child: const Text('Kết nối lại nguồn', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Search & Connector toggle bar
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('mobile_trend_search_field'),
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm theo từ khóa, ngành hàng...',
                  hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF7D837B)),
                  prefixIcon: const Icon(Icons.search, size: 18),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE8E5DC)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Simulator toggle button for Target 1
            IconButton(
              key: const Key('mobile_toggle_degrade_btn'),
              tooltip: _isTikTokConnected ? 'Ngắt TikTok (Test degraded)' : 'Nối TikTok',
              onPressed: _toggleTikTokConnection,
              icon: Icon(
                _isTikTokConnected ? Icons.link : Icons.link_off,
                color: _isTikTokConnected ? TrendRadarView.forest : TrendRadarView.vermilion,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Platform filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('all', 'Tất cả'),
              const SizedBox(width: 6),
              _buildFilterChip('TikTok', 'TikTok'),
              const SizedBox(width: 6),
              _buildFilterChip('Shopee', 'Shopee'),
              const SizedBox(width: 6),
              _buildFilterChip('YouTube', 'YouTube'),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Trend items list
        if (processed.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            child: const Text(
              'Không tìm thấy xu hướng phù hợp trong workspace này.',
              style: TextStyle(fontSize: 12, color: Color(0xFF7D837B)),
            ),
          )
        else
          ...processed.map((t) => _buildTrendCard(t)),
      ],
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedPlatform == key;
    return GestureDetector(
      key: Key('mobile_filter_$key'),
      onTap: () => setState(() => _selectedPlatform = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? TrendRadarView.forest : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE8E5DC)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF7D837B),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendCard(TrendSummary trend) {
    final isSaved = _watchlistIds.contains(trend.id);
    return Container(
      key: Key('mobile_trend_card_${trend.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: trend.isDegraded ? TrendRadarView.vermilion.withValues(alpha: 0.4) : const Color(0xFFE8E5DC),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Degraded pill if degraded
          if (trend.isDegraded) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFBEEE9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning, size: 12, color: TrendRadarView.vermilion),
                  SizedBox(width: 4),
                  Text(
                    'DỮ LIỆU ƯỚC TÍNH (DEGRADED)',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: TrendRadarView.vermilion),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Platform & Category & Score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1EFEA),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      trend.platform,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: TrendRadarView.forest),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    trend.category,
                    style: const TextStyle(fontSize: 10, color: Color(0xFF7D837B)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF3F0),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: TrendRadarView.forest.withValues(alpha: 0.2)),
                ),
                child: Text(
                  '⭐ ${trend.strengthScore}đ',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: TrendRadarView.forest),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            trend.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TrendRadarView.ink),
          ),
          const SizedBox(height: 6),

          // Why Now box
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF9F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE8E5DC)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '💡 Tại sao ngay lúc này?',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: TrendRadarView.forest),
                ),
                const SizedBox(height: 2),
                Text(
                  trend.whyNow,
                  style: const TextStyle(fontSize: 11, color: TrendRadarView.ink),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 3 Dimension stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tốc độ: ${trend.velocity.toInt()}%', style: const TextStyle(fontSize: 10, color: Color(0xFF7D837B))),
              Text('Độ mới: ${trend.freshnessScore.toInt()}%', style: const TextStyle(fontSize: 10, color: Color(0xFF7D837B))),
              Text('Bão hòa: ${trend.saturationScore.toInt()}%', style: const TextStyle(fontSize: 10, color: Color(0xFF7D837B))),
            ],
          ),
          const SizedBox(height: 8),

          // Confidence & Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Độ tin cậy: ',
                    style: const TextStyle(fontSize: 10, color: Color(0xFF7D837B)),
                  ),
                  Text(
                    trend.confidence.name.replaceAll('CONFIDENCE_BAND_', ''),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: trend.confidence == ConfidenceBand.CONFIDENCE_BAND_LOW
                          ? TrendRadarView.vermilion
                          : TrendRadarView.forest,
                    ),
                  ),
                ],
              ),
              OutlinedButton.icon(
                key: Key('mobile_save_wl_${trend.id}'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  foregroundColor: isSaved ? Colors.white : TrendRadarView.forest,
                  backgroundColor: isSaved ? TrendRadarView.forest : Colors.white,
                  side: const BorderSide(color: TrendRadarView.forest),
                ),
                onPressed: () => _toggleWatchlist(trend.id),
                icon: Icon(isSaved ? Icons.check : Icons.bookmark_add_outlined, size: 14),
                label: Text(isSaved ? 'Đã lưu' : 'Lưu watchlist', style: const TextStyle(fontSize: 10)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

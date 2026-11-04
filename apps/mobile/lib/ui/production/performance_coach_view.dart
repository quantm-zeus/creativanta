import 'package:flutter/material.dart';
import '../../production/ab_test_coach_models.dart';

/// Screen M039: Mobile Performance Coach
/// Canonical Sources: docs/03_screens/mobile/screen_mobile_performance_coach.md
///                    docs/02_features/production/ai_video_studio.md §EF-10
///                    docs/04_contracts/api_behavior_contracts.md §7
class PerformanceCoachView extends StatefulWidget {
  final VideoScorecardModel? initialScorecard;
  final List<ImprovementPlanModel>? initialPlans;
  final IndustryComparisonModel? initialComparison;
  final bool isLoading;
  final bool hasInsufficientData;

  const PerformanceCoachView({
    super.key,
    this.initialScorecard,
    this.initialPlans,
    this.initialComparison,
    this.isLoading = false,
    this.hasInsufficientData = false,
  });

  @override
  State<PerformanceCoachView> createState() => _PerformanceCoachViewState();
}

class _PerformanceCoachViewState extends State<PerformanceCoachView> {
  late bool _isLoading;
  late bool _hasInsufficientData;
  late VideoScorecardModel _scorecard;
  late List<ImprovementPlanModel> _plans;
  late IndustryComparisonModel _comparison;
  String? _snackBarMessage;

  @override
  void initState() {
    super.initState();
    _isLoading = widget.isLoading;
    _hasInsufficientData = widget.hasInsufficientData;

    _scorecard = widget.initialScorecard ??
        const VideoScorecardModel(
          videoId: 'vid-recent-01',
          title: 'Top 5 Tips for Video Editing',
          overallScore: 82.0,
          letterGrade: 'A-',
          engagementRate: 8.2,
          retentionRate: 58.0,
          clickThroughRate: 6.4,
          isObservational: true,
          observationalNotice: kStandardObservationalNotice,
          keyObservations: [
            'Best post: "5 tips" (ER 8.2%)',
            'Worst post: "Review" (ER 2.1%)',
            'Streak: 3 weeks improving',
          ],
        );

    _plans = widget.initialPlans ??
        const [
          ImprovementPlanModel(
            id: 'plan-1',
            title: 'Post more "tips" content',
            description: '4 of your 5 top-performing posts are tips tutorials.',
            impact: 'High',
            effort: 'Low',
            suggestedAction: 'Create a tips video',
            category: 'topic',
            isObservational: true,
          ),
          ImprovementPlanModel(
            id: 'plan-2',
            title: 'Post at 19:00',
            description: 'Your audience is most active and comments peak between 19:00 and 21:00.',
            impact: 'Medium',
            effort: 'Low',
            suggestedAction: 'Schedule for 19:00',
            category: 'timing',
            isObservational: true,
          ),
          ImprovementPlanModel(
            id: 'plan-3',
            title: 'Add CTA overlay at 0:15',
            description: 'Videos with mid-roll engagement hooks see +50 followers per post.',
            impact: 'Medium',
            effort: 'Medium',
            suggestedAction: 'Add overlay CTA',
            category: 'cta',
            isObservational: true,
          ),
        ];

    _comparison = widget.initialComparison ??
        const IndustryComparisonModel(
          accountRate: 8.2,
          industryP50: 4.8,
          percentileRank: 84.0,
          deltaVsMedian: 3.4,
          isObservational: true,
          observationalNotice: kStandardObservationalNotice,
        );
  }

  Future<void> _refreshCoachData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _snackBarMessage = 'AI Coach recommendations refreshed';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_snackBarMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Performance Coach',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.blueAccent),
            tooltip: 'Refresh recommendations',
            onPressed: _refreshCoachData,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.blueAccent),
            SizedBox(height: 16),
            Text(
              '🤖 Analyzing your performance...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_hasInsufficientData) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bar_chart, size: 64, color: Colors.white38),
              const SizedBox(height: 16),
              const Text(
                'Cần ít nhất 3 bài đăng để AI Coach phân tích.',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Publish more content or import analytics to generate custom coaching feedback.',
                style: TextStyle(color: Colors.white60, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => _hasInsufficientData = false);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Check again'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshCoachData,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildObservationalBanner(),
          const SizedBox(height: 12),
          _buildScorecardCard(),
          const SizedBox(height: 16),
          _buildBenchmarkComparisonCard(),
          const SizedBox(height: 16),
          const Text(
            'Actionable Recommendations',
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._plans.map(_buildRecommendationCard),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildObservationalBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.amberAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _scorecard.observationalNotice,
              style: const TextStyle(color: Colors.amberAccent, fontSize: 12, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScorecardCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '📊 Weekly Quality Score',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '🔥 3 tuần liên tục cải thiện!',
                  style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: Center(
                  child: Text(
                    _scorecard.letterGrade,
                    style: const TextStyle(color: Colors.blueAccent, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_scorecard.overallScore.toStringAsFixed(0)}/100',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      '↑ 5 vs last week · Strong retention and pacing',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white12, height: 24),
          ..._scorecard.keyObservations.map(
            (obs) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 14, color: Colors.blueAccent),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      obs,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenchmarkComparisonCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🌐 Niche Benchmark Comparison',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                'Top ${(100 - _comparison.percentileRank).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.cyanAccent, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricColumn('Your ER', '${_comparison.accountRate}%', Colors.greenAccent),
              _buildMetricColumn('Industry P50', '${_comparison.industryP50}%', Colors.white60),
              _buildMetricColumn('Delta', '+${_comparison.deltaVsMedian}%', Colors.cyanAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildRecommendationCard(ImprovementPlanModel plan) {
    Color impactColor = Colors.greenAccent;
    if (plan.impact == 'Medium') impactColor = Colors.amberAccent;
    if (plan.impact == 'Low') impactColor = Colors.white60;

    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.white12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.amberAccent, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    plan.title,
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              plan.description,
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Impact: ',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                Text(
                  plan.impact,
                  style: TextStyle(color: impactColor, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Effort: ',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
                Text(
                  plan.effort,
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Triggered: ${plan.suggestedAction}')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    side: const BorderSide(color: Colors.blueAccent),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text('${plan.suggestedAction} →', style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

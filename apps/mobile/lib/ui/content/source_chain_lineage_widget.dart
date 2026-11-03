import 'package:flutter/material.dart';
import 'package:creativanta_mobile/content/content_handoff_models.dart';

/// Renders the end-to-end provenance and lineage chain:
/// Trend Radar -> Opportunity Board -> Idea Engine -> Script Lab -> Asset Brief.
class SourceChainLineageWidget extends StatelessWidget {
  const SourceChainLineageWidget({
    super.key,
    required this.lineage,
    this.onNodeTap,
  });

  final SourceChainLineage lineage;
  final ValueChanged<SourceChainNode>? onNodeTap;

  @override
  Widget build(BuildContext context) {
    final nodes = lineage.nodes;
    final readiness = lineage.evaluateProductionReadiness();

    return Card(
      key: const Key('source-chain-lineage-card'),
      elevation: 0,
      color: Colors.blueGrey[50]?.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blueGrey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_tree_outlined, size: 18, color: Colors.blueGrey),
                const SizedBox(width: 8),
                const Text(
                  'Chuỗi nguồn & Xuất xứ (Source Chain)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                const Spacer(),
                if (lineage.reachesApprovedBrief)
                  Container(
                    key: const Key('production-ready-badge'),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[600]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 12, color: Colors.green[800]),
                        const SizedBox(width: 4),
                        Text(
                          'Sẵn sàng sản xuất',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green[900]),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    key: const Key('in-progress-badge'),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber[600]!),
                    ),
                    child: Text(
                      'Đang xử lý',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber[900]),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Horizontal scrolling node pipeline
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < nodes.length; i++) ...[
                    _buildNodeChip(context, nodes[i]),
                    if (i < nodes.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(Icons.arrow_forward_ios, size: 12, color: Colors.blueGrey[300]),
                      ),
                  ],
                ],
              ),
            ),

            if (!readiness.isEligible && readiness.reasons.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                key: const Key('lineage-blockers-container'),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 14, color: Colors.orange[800]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Chặn sản xuất: ${readiness.reasons.first}',
                        style: TextStyle(fontSize: 11, color: Colors.orange[900]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNodeChip(BuildContext context, SourceChainNode node) {
    Color chipColor = Colors.blueGrey[100]!;
    Color textColor = Colors.blueGrey[900]!;
    IconData icon = Icons.circle_outlined;

    switch (node.stage) {
      case ContentPipelineStage.trend:
        chipColor = Colors.purple[50]!;
        textColor = Colors.purple[900]!;
        icon = Icons.trending_up;
        break;
      case ContentPipelineStage.opportunity:
        chipColor = Colors.teal[50]!;
        textColor = Colors.teal[900]!;
        icon = Icons.lightbulb_outline;
        break;
      case ContentPipelineStage.idea:
        chipColor = Colors.amber[50]!;
        textColor = Colors.amber[900]!;
        icon = Icons.auto_awesome;
        break;
      case ContentPipelineStage.script:
        chipColor = Colors.indigo[50]!;
        textColor = Colors.indigo[900]!;
        icon = Icons.description_outlined;
        break;
      case ContentPipelineStage.assetBrief:
        chipColor = Colors.green[50]!;
        textColor = Colors.green[900]!;
        icon = Icons.movie_creation_outlined;
        break;
      case ContentPipelineStage.production:
        chipColor = Colors.pink[50]!;
        textColor = Colors.pink[900]!;
        icon = Icons.video_camera_front_outlined;
        break;
    }

    return InkWell(
      onTap: () => onNodeTap?.call(node),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: textColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 12, color: textColor),
                const SizedBox(width: 4),
                Text(
                  node.stageName.split(' ').first,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 2),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120),
              child: Text(
                node.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ),
            if (node.id.isNotEmpty)
              Text(
                node.id,
                style: TextStyle(fontSize: 9, color: Colors.grey[600], fontFamily: 'monospace'),
              ),
          ],
        ),
      ),
    );
  }
}

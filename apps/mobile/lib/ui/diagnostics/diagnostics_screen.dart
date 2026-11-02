import 'package:flutter/material.dart';
import 'package:creativanta_mobile/diagnostics/diagnostics_models.dart';

/// M059: Mobile Diagnostics Screen (Outbox, Inbox & External Effects).
class MobileDiagnosticsScreen extends StatelessWidget {
  const MobileDiagnosticsScreen({
    super.key,
    this.effectStatus = MobileExternalEffectStatus.unknown,
  });

  final MobileExternalEffectStatus effectStatus;

  @override
  Widget build(BuildContext context) {
    final verdict = evaluateMobileExternalEffectGuard(effectStatus);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chẩn đoán Hệ thống (M059)'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'P0-05: Outbox, Inbox & Tác vụ Ngoài',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text('Trạng thái tác vụ ngoài: ${effectStatus.name}'),
                  const SizedBox(height: 4),
                  Text('Phán quyết: ${verdict.decisionKey}'),
                  const SizedBox(height: 4),
                  Text(verdict.explanation),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

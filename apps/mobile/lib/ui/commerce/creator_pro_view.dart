import 'package:flutter/material.dart';
import 'package:creativanta_mobile/commerce/creator_pro_models.dart';
import 'package:creativanta_mobile/generated/creativanta/commerce/v1/creator_pro.pb.dart';

class CreatorProDashboardView extends StatefulWidget {
  const CreatorProDashboardView({
    super.key,
    required this.workspaceId,
    required this.initialItems,
  });

  final String workspaceId;
  final List<LinkItem> initialItems;

  @override
  State<CreatorProDashboardView> createState() => _CreatorProDashboardViewState();
}

class _CreatorProDashboardViewState extends State<CreatorProDashboardView> {
  late List<LinkItem> _items;
  MobileBrandDealStatus _dealStatus = MobileBrandDealStatus.negotiating;
  MobileWorkspaceMode _selectedMode = MobileWorkspaceMode.creator;
  String? _statusMessage;
  String? _errorMessage;
  bool _aupAcknowledged = false;
  int _views = 0;
  final BigInt _revenueMicros = BigInt.from(500000000000); // 500,000 VND

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.initialItems);
  }

  void _transitionDeal(MobileBrandDealStatus next, {String? reason, bool reversal = false}) {
    final result = CanonicalDealLifecycle.validateTransition(
      _dealStatus,
      next,
      cancellationReason: reason,
      financialReversalConfirmed: reversal,
    );
    setState(() {
      if (result.isValid) {
        _dealStatus = next;
        _statusMessage = 'Deal status updated to ${_dealStatus.name}';
        _errorMessage = null;
      } else {
        _errorMessage = result.errorMessage;
      }
    });
  }

  void _publishBioPage() {
    final result = canPublishBioPage(
      items: _items,
      aupAcknowledged: _aupAcknowledged,
    );
    setState(() {
      if (result.allowed) {
        _statusMessage = 'Bio page published successfully!';
        _errorMessage = null;
      } else {
        _errorMessage = result.rejectionReason;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rpm = computeRPM(views: _views, revenueMicros: _revenueMicros);
    final entitledTools = modeEntitledTools[_selectedMode] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Creator Pro v1'),
        actions: [
          DropdownButton<MobileWorkspaceMode>(
            value: _selectedMode,
            dropdownColor: Colors.grey[900],
            style: const TextStyle(color: Colors.white),
            onChanged: (mode) {
              if (mode != null) {
                setState(() => _selectedMode = mode);
              }
            },
            items: MobileWorkspaceMode.values.map((m) {
              return DropdownMenuItem(
                value: m,
                child: Text(m.name.toUpperCase()),
              );
            }).toList(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_statusMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_statusMessage!, style: const TextStyle(color: Colors.greenAccent)),
              ),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)),
              ),

            // Mode Entitlements Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Active Mode: ${_selectedMode.name.toUpperCase()}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: MobileCreatorProTool.values.map((tool) {
                        final isEntitled = entitledTools.contains(tool);
                        return Chip(
                          label: Text(tool.name),
                          backgroundColor: isEntitled ? Colors.teal : Colors.grey[800],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Canonical Deal Lifecycle Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Deal Lifecycle: ${_dealStatus.name.toUpperCase()}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () => _transitionDeal(MobileBrandDealStatus.agreed),
                          child: const Text('Advance to Agreed'),
                        ),
                        ElevatedButton(
                          onPressed: () => _transitionDeal(
                            MobileBrandDealStatus.cancelled,
                            reason: 'Budget cancellation',
                            reversal: _dealStatus == MobileBrandDealStatus.paid,
                          ),
                          child: const Text('Cancel Deal'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Zero-view RPM Undefined Representation
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Content Revenue & RPM Tracker',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Views: $_views'),
                    Text('RPM: ${rpm.formatted}',
                        style: TextStyle(
                          color: rpm.rpmIsUndefined ? Colors.amber : Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () => setState(() => _views = 0),
                          child: const Text('Set 0 Views (Undefined)'),
                        ),
                        ElevatedButton(
                          onPressed: () => setState(() => _views = 25000),
                          child: const Text('Set 25k Views (Defined)'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Phishing & Bio Page Publisher
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Link-in-Bio Security & Publishing',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: _aupAcknowledged,
                          onChanged: (val) => setState(() => _aupAcknowledged = val ?? false),
                        ),
                        const Expanded(child: Text('Acknowledge Acceptable Use Policy (AUP)')),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _publishBioPage,
                      child: const Text('Publish Bio Page'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

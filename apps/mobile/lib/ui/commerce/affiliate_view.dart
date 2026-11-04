import 'package:flutter/material.dart';
import 'package:creativanta_mobile/commerce/affiliate_models.dart';
import 'package:creativanta_mobile/generated/creativanta/commerce/v1/affiliate.pb.dart';

class AffiliateDashboardView extends StatefulWidget {
  const AffiliateDashboardView({
    super.key,
    required this.workspaceId,
    required this.initialLinks,
  });

  final String workspaceId;
  final List<MobileAffiliateLink> initialLinks;

  @override
  State<AffiliateDashboardView> createState() => _AffiliateDashboardViewState();
}

class _AffiliateDashboardViewState extends State<AffiliateDashboardView> {
  late List<MobileAffiliateLink> _links;
  WorkspaceEconomicRole _selectedRole =
      WorkspaceEconomicRole.WORKSPACE_ECONOMIC_ROLE_CREATOR;
  MobileLedgerPostingEvaluation? _currentPosting;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _links = List.from(widget.initialLinks);
    _evaluateRole();
  }

  void _evaluateRole() {
    setState(() {
      _currentPosting = evaluateMobileLedgerImpact(
        workspaceId: widget.workspaceId,
        commissionAmount: '250000.000000',
        currency: 'VND',
        role: _selectedRole,
      );
    });
  }

  void _repairLink(MobileAffiliateLink link) {
    try {
      final repaired = repairMobileBrokenLink(
        link,
        'https://shopee.vn/products/replacement-item',
        replacementProductId: 'prod-repl-99',
      );
      setState(() {
        final index = _links.indexWhere(
            (l) => l.affiliateLinkId == link.affiliateLinkId);
        if (index != -1) {
          _links[index] = repaired;
        }
        _statusMessage = 'Link repaired successfully! Health status restored.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Repair blocked: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Affiliate & Ledger Proof'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Target 1: Economic Role Toggle & Ledger Verification
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Economic Role & Ledger Separation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Creator commission is pure income (ZERO COGS deduction). Seller commission is an expense deduction.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Creator (Income)'),
                        selected: _selectedRole ==
                            WorkspaceEconomicRole
                                .WORKSPACE_ECONOMIC_ROLE_CREATOR,
                        onSelected: (val) {
                          if (val) {
                            _selectedRole = WorkspaceEconomicRole
                                .WORKSPACE_ECONOMIC_ROLE_CREATOR;
                            _evaluateRole();
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Seller (Expense)'),
                        selected: _selectedRole ==
                            WorkspaceEconomicRole
                                .WORKSPACE_ECONOMIC_ROLE_SELLER,
                        onSelected: (val) {
                          if (val) {
                            _selectedRole = WorkspaceEconomicRole
                                .WORKSPACE_ECONOMIC_ROLE_SELLER;
                            _evaluateRole();
                          }
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  if (_currentPosting != null) ...[
                    Text(
                      'Posting Type: ${_currentPosting!.postingType}',
                      key: const Key('ledgerPostingType'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'COGS Deducted: ${_currentPosting!.cogsDeducted ? "YES" : "NO (Pure Creator Income)"}',
                      key: const Key('ledgerCogsDeducted'),
                      style: TextStyle(
                        color: _currentPosting!.cogsDeducted
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Net Profit Impact: ${_currentPosting!.netProfitImpact} ${_currentPosting!.currency}',
                      key: const Key('ledgerProfitImpact'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Target 2: Ambiguous Attribution Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Ambiguous Attribution Notice: Multi-touch conversions are labeled as [Inferred] and never presented as definitive truth.',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Status message if repair performed
          if (_statusMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                _statusMessage!,
                key: const Key('statusMessageText'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Target 3: Links and Repair List
          const Text(
            'Tracked Affiliate Links',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._links.map((link) {
            final isBroken = link.healthStatus ==
                LinkHealthStatus.LINK_HEALTH_STATUS_BROKEN;
            final isRevoked = link.lifecycleState ==
                AffiliateLinkLifecycleState
                    .AFFILIATE_LINK_LIFECYCLE_STATE_REVOKED;

            return Card(
              key: Key('linkCard_${link.affiliateLinkId}'),
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text('${link.platform.toUpperCase()} - ${link.shortCode}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(link.trackedUrl, style: const TextStyle(fontSize: 12)),
                    Row(
                      children: [
                        Text(
                          'Health: ${link.healthStatus.name.replaceAll('LINK_HEALTH_STATUS_', '')}',
                          key: Key('healthStatus_${link.affiliateLinkId}'),
                          style: TextStyle(
                            color: isBroken ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isRevoked) ...[
                          const SizedBox(width: 8),
                          const Text(
                            '(REVOKED)',
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                trailing: isBroken && !isRevoked
                    ? ElevatedButton(
                        key: Key('repairButton_${link.affiliateLinkId}'),
                        onPressed: () => _repairLink(link),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Repair'),
                      )
                    : isRevoked
                        ? const Text('Blocked', style: TextStyle(color: Colors.grey))
                        : const Icon(Icons.check_circle, color: Colors.green),
              ),
            );
          }),
        ],
      ),
    );
  }
}

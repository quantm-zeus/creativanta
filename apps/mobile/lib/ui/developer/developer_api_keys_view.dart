import 'package:flutter/material.dart';
import '../../developer/api_key_models.dart';

class DeveloperApiKeysView extends StatefulWidget {
  final DeveloperStateNotifier notifier;

  const DeveloperApiKeysView({
    super.key,
    required this.notifier,
  });

  @override
  State<DeveloperApiKeysView> createState() => _DeveloperApiKeysViewState();
}

class _DeveloperApiKeysViewState extends State<DeveloperApiKeysView> {
  String? _revealedSecret;
  String? _errorBanner;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.notifier,
      builder: (context, _) {
        final keys = widget.notifier.keys;
        final webhooks = widget.notifier.webhooks;
        final tier = widget.notifier.tier;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Developer API & Webhooks (S24)'),
            actions: [
              PopupMenuButton<String>(
                initialValue: tier,
                onSelected: (val) => widget.notifier.setTier(val),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'starter', child: Text('Starter (Read-Only)')),
                  PopupMenuItem(value: 'pro', child: Text('Pro (Read/Write)')),
                  PopupMenuItem(value: 'business', child: Text('Business (Full)')),
                ],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      tier.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_errorBanner != null) _buildErrorCard(_errorBanner!),
              if (_revealedSecret != null) _buildSecretCard(_revealedSecret!),
              _buildUsageCard(),
              const SizedBox(height: 16),
              _buildKeysSection(keys),
              const SizedBox(height: 16),
              _buildWebhooksSection(webhooks),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showCreateKeyDialog(context),
            icon: const Icon(Icons.key),
            label: const Text('New Key'),
          ),
        );
      },
    );
  }

  Widget _buildErrorCard(String errorMessage) {
    return Card(
      key: const Key('developer-error-banner'),
      color: Colors.red.shade50,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.red.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => setState(() => _errorBanner = null),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecretCard(String secret) {
    return Card(
      color: Colors.green.shade50,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.green.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text(
                  'DISPLAYED ONCE',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SelectableText(
              secret,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => _revealedSecret = null),
                child: const Text('Dismiss'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageCard() {
    final quota = widget.notifier.monthlyQuota;
    final used = widget.notifier.monthRequests;
    final cap = widget.notifier.keyCap;
    final activeCount = widget.notifier.activeKeyCount;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Quota & Limits',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: quota > 0 ? (used / quota).clamp(0.0, 1.0) : 0,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Requests: $used / $quota'),
                Text('Keys: $activeCount / $cap'),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Rate Limits: 100 RPM Read / 30 RPM Write (Sliding Window)',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeysSection(List<ApiKeyItem> keys) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'API Keys',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        if (keys.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('No API keys yet')),
          )
        else
          ...keys.map((key) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(key.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Prefix: ${key.keyPrefix}... | Status: ${key.status.name.toUpperCase()}'),
                      Wrap(
                        spacing: 4,
                        children: key.scopes
                            .map((s) => Chip(
                                  label: Text(s, style: const TextStyle(fontSize: 10)),
                                  padding: EdgeInsets.zero,
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (val) async {
                      if (val == 'rotate') {
                        final outcome = await widget.notifier.rotateKeyRemote(key.apiKeyId);
                        if (!mounted) return;
                        setState(() {
                          if (outcome.ok && outcome.data != null) {
                            _errorBanner = null;
                            _revealedSecret = outcome.data!.secretKey;
                          } else {
                            _revealedSecret = null;
                            _errorBanner =
                                '${outcome.errorCode ?? 'ERROR'}: ${outcome.message ?? 'Key rotation failed'}';
                          }
                        });
                      } else if (val == 'revoke') {
                        final outcome = await widget.notifier.revokeKeyRemote(key.apiKeyId);
                        if (!mounted) return;
                        setState(() {
                          if (outcome.ok) {
                            _errorBanner = null;
                          } else {
                            _errorBanner =
                                '${outcome.errorCode ?? 'ERROR'}: ${outcome.message ?? 'Key revocation failed'}';
                          }
                        });
                      }
                    },
                    itemBuilder: (context) => [
                      if (key.status == ApiKeyStatus.active)
                        const PopupMenuItem(value: 'rotate', child: Text('Rotate (24h Grace)')),
                      if (key.status != ApiKeyStatus.revoked)
                        const PopupMenuItem(value: 'revoke', child: Text('Revoke')),
                    ],
                  ),
                ),
              )),
      ],
    );
  }

  Widget _buildWebhooksSection(List<WebhookSubscriptionItem> webhooks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Outbound Webhooks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        if (webhooks.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('No webhook subscriptions')),
          )
        else
          ...webhooks.map((sub) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(sub.targetUrl),
                  subtitle: Text(
                    'Status: ${sub.status.name.toUpperCase()} | Failures: ${sub.consecutiveFailureCount}/100',
                    style: TextStyle(
                      color: sub.consecutiveFailureCount >= 100
                          ? Colors.red
                          : Colors.grey.shade700,
                    ),
                  ),
                  trailing: Text(sub.eventTypes.join(', '), style: const TextStyle(fontSize: 11)),
                ),
              )),
      ],
    );
  }

  void _showCreateKeyDialog(BuildContext context) {
    final nameCtrl = TextEditingController(text: 'Mobile Key');
    final selectedScopes = <String>['read:content'];

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final isStarter = widget.notifier.tier.toLowerCase() == 'starter';

          return AlertDialog(
            title: const Text('Create API Key'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Key Name'),
                ),
                const SizedBox(height: 12),
                if (isStarter)
                  const Text(
                    'Starter tier is restricted to read-only API access.',
                    style: TextStyle(color: Colors.orange, fontSize: 12),
                  ),
                CheckboxListTile(
                  title: const Text('read:content'),
                  value: selectedScopes.contains('read:content'),
                  onChanged: (val) {
                    setDialogState(() {
                      if (val == true) {
                        selectedScopes.add('read:content');
                      } else {
                        selectedScopes.remove('read:content');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('write:content'),
                  value: selectedScopes.contains('write:content'),
                  enabled: !isStarter,
                  onChanged: isStarter
                      ? null
                      : (val) {
                          setDialogState(() {
                            if (val == true) {
                              selectedScopes.add('write:content');
                            } else {
                              selectedScopes.remove('write:content');
                            }
                          });
                        },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final requestedName = nameCtrl.text;
                  final requestedScopes = List<String>.from(selectedScopes);
                  Navigator.pop(dialogCtx);
                  final outcome = await widget.notifier.createKeyRemote(
                    name: requestedName,
                    scopes: requestedScopes,
                  );
                  if (!mounted) return;
                  setState(() {
                    if (outcome.ok && outcome.data != null) {
                      _errorBanner = null;
                      _revealedSecret = outcome.data!.secretKey;
                    } else {
                      _revealedSecret = null;
                      _errorBanner =
                          '${outcome.errorCode ?? 'ERROR'}: ${outcome.message ?? 'Failed to create API key'}';
                    }
                  });
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      ),
    );
  }
}

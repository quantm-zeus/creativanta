import 'package:flutter/material.dart';
import 'package:creativanta_mobile/content/continuity_models.dart';
import 'package:creativanta_mobile/generated/creativanta/content/v1/continuity.pbenum.dart';

/// Mobile Character Library & Management View (W019 / W037).
class MobileCharacterLibraryView extends StatefulWidget {
  const MobileCharacterLibraryView({
    super.key,
    required this.workspaceId,
    required this.tier,
    this.initialCharacters = const [],
    this.onCharacterChanged,
  });

  final String workspaceId;
  final String tier;
  final List<CharacterItem> initialCharacters;
  final ValueChanged<List<CharacterItem>>? onCharacterChanged;

  @override
  State<MobileCharacterLibraryView> createState() =>
      _MobileCharacterLibraryViewState();
}

class _MobileCharacterLibraryViewState
    extends State<MobileCharacterLibraryView> {
  late List<CharacterItem> _characters;

  @override
  void initState() {
    super.initState();
    _characters = List.from(widget.initialCharacters);
  }

  int get _activeCount => _characters
      .where((c) => c.status != CharacterStatus.CHARACTER_STATUS_ARCHIVED)
      .length;

  bool get _isQuotaExceeded =>
      CharacterSlotQuota.isExceeded(_activeCount, widget.tier);

  /// Target 3: Exactly one default character invariance.
  void _setDefaultCharacter(String charId) {
    setState(() {
      _characters = _characters.map((c) {
        return c.copyWith(isDefault: c.characterId == charId);
      }).toList();
    });
    widget.onCharacterChanged?.call(_characters);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Đã cập nhật nhân vật mặc định của workspace!'),
        backgroundColor: Color(0xFF274333),
      ),
    );
  }

  /// Archive character to free up slot quota.
  void _archiveCharacter(String charId) {
    setState(() {
      _characters = _characters.map((c) {
        if (c.characterId == charId) {
          return c.copyWith(
            status: CharacterStatus.CHARACTER_STATUS_ARCHIVED,
            isDefault: false,
          );
        }
        return c;
      }).toList();
    });
    widget.onCharacterChanged?.call(_characters);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📦 Đã lưu trữ nhân vật thành công!'),
      ),
    );
  }

  /// Target 1: Revoked consent blocks generation.
  void _triggerGeneration(CharacterItem character) {
    if (!character.canGenerate) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.block, color: Colors.red),
              SizedBox(width: 8),
              Text('Tạo video bị chặn'),
            ],
          ),
          content: Text(
            character.characterType == CharacterType.CHARACTER_TYPE_DIGITAL_TWIN
                ? 'Nhân vật Digital Twin "${character.name}" đã bị thu hồi sự đồng ý (Consent Revoked). Không được phép tạo video khi chưa có chấp thuận chân dung hợp lệ.'
                : 'Nhân vật "${character.name}" chưa sẵn sàng để tạo video.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Đã hiểu'),
            ),
          ],
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎬 Đang khởi tạo video với nhân vật "${character.name}"...'),
        backgroundColor: const Color(0xFF274333),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCharacters = _characters
        .where((c) => c.status != CharacterStatus.CHARACTER_STATUS_ARCHIVED)
        .toList();
    final quota = CharacterSlotQuota.getQuota(widget.tier);
    final quotaText = quota == -1 ? 'Không giới hạn' : '$_activeCount / $quota';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhân vật & Continuity (M08)'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // Quota Card (RULE-M08-003)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _isQuotaExceeded
                  ? const Color(0xFFFEF2F2)
                  : const Color(0xFFF9FAFB),
              border: Border.all(
                color: _isQuotaExceeded
                    ? const Color(0xFFFCA5A5)
                    : const Color(0xFFE5E7EB),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  _isQuotaExceeded ? Icons.warning_amber : Icons.badge_outlined,
                  color: _isQuotaExceeded ? Colors.red : const Color(0xFF274333),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Số lượng nhân vật: $quotaText (Gói ${widget.tier.toUpperCase()})',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        _isQuotaExceeded
                            ? 'Đã đạt giới hạn slot nhân vật của gói hiện tại.'
                            : 'Mỗi nhân vật lưu giữ đặc điểm nhận diện nhất quán.',
                        style: TextStyle(
                          fontSize: 12,
                          color: _isQuotaExceeded ? Colors.red[700] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Character List
          Expanded(
            child: activeCharacters.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_outline, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        const Text(
                          'Chưa có nhân vật nào trong Workspace',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: activeCharacters.length,
                    itemBuilder: (context, index) {
                      final char = activeCharacters[index];
                      return _buildCharacterCard(char);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(CharacterItem char) {
    final isDigitalTwin =
        char.characterType == CharacterType.CHARACTER_TYPE_DIGITAL_TWIN;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: char.isDefault
              ? const Color(0xFF10B981)
              : const Color(0xFFE5E7EB),
          width: char.isDefault ? 1.5 : 1,
        ),
      ),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Avatar + Name + Default Badge
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFE0E7FF),
                  child: Text(
                    char.name.isNotEmpty ? char.name[0] : '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              char.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (char.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD1FAE5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'MẶC ĐỊNH',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF065F46),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isDigitalTwin
                            ? 'Bản sao kỹ thuật số (Digital Twin)'
                            : 'Nhân vật AI sáng tạo (AI Generated)',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (char.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                char.description,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],

            const SizedBox(height: 10),

            // Consent Status Badge
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: char.consentVerified
                        ? const Color(0xFFECFDF5)
                        : const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: char.consentVerified
                          ? const Color(0xFFA7F3D0)
                          : const Color(0xFFFECACA),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        char.consentVerified
                            ? Icons.verified_user_outlined
                            : Icons.gpp_bad_outlined,
                        size: 14,
                        color: char.consentVerified
                            ? const Color(0xFF047857)
                            : const Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        char.consentVerified
                            ? 'Consent: Đã xác thực'
                            : 'Consent: Bị từ chối / Chưa cấp',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: char.consentVerified
                              ? const Color(0xFF047857)
                              : const Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: 4,
                  children: [
                    if (!char.isDefault)
                      TextButton(
                        onPressed: () => _setDefaultCharacter(char.characterId),
                        child: const Text('Đặt mặc định',
                            style: TextStyle(fontSize: 12)),
                      ),
                    TextButton(
                      onPressed: () => _archiveCharacter(char.characterId),
                      child: const Text('Lưu trữ',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _triggerGeneration(char),
                  icon: const Icon(Icons.movie_creation_outlined, size: 14),
                  label: const Text('Tạo video', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: char.canGenerate
                        ? const Color(0xFF274333)
                        : Colors.grey[400],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

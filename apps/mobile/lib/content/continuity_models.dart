import 'package:creativanta_mobile/generated/creativanta/content/v1/continuity.pbenum.dart';

/// Tier character slot quotas per docs/02_features/content/continuity_os.md §4 (RULE-M08-003).
class CharacterSlotQuota {
  static const int free = 1;
  static const int starter = 2;
  static const int pro = 5;
  static const int business = 15;
  static const int enterprise = -1; // Unlimited

  static int getQuota(String tier) {
    switch (tier.toLowerCase()) {
      case 'enterprise':
        return enterprise;
      case 'business':
        return business;
      case 'pro':
        return pro;
      case 'starter':
        return starter;
      case 'free':
      default:
        return free;
    }
  }

  static bool isExceeded(int activeCount, String tier) {
    final quota = getQuota(tier);
    if (quota == -1) return false;
    return activeCount >= quota;
  }
}

/// Approved Reference Asset per continuity_os.md §5.
class ApprovedReferenceItem {
  const ApprovedReferenceItem({
    required this.referenceId,
    required this.name,
    required this.mediaUrl,
    required this.referenceType,
    required this.status,
  });

  final String referenceId;
  final String name;
  final String mediaUrl;
  final String referenceType;
  final String status;
}

/// Immutable Pack Version Snapshot per continuity_os.md §5 (Acceptance Target 2).
class PackVersionItem {
  const PackVersionItem({
    required this.versionId,
    required this.workspaceId,
    required this.packId,
    required this.versionIndex,
    required this.name,
    required this.packType,
    this.approvedReferences = const [],
    this.rulesSummary = '',
    required this.status,
    required this.snapshotReason,
    this.createdAt,
  });

  final String versionId;
  final String workspaceId;
  final String packId;
  final int versionIndex;
  final String name;
  final String packType;
  final List<ApprovedReferenceItem> approvedReferences;
  final String rulesSummary;
  final String status;
  final String snapshotReason;
  final DateTime? createdAt;
}

/// Continuity Pack Model per database_schema.md §7.2.
class ContinuityPackItem {
  const ContinuityPackItem({
    required this.packId,
    required this.workspaceId,
    required this.name,
    required this.packType,
    required this.version,
    this.rulesSummary = '',
    this.approvedReferences = const [],
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  final String packId;
  final String workspaceId;
  final String name;
  final String packType;
  final int version;
  final String rulesSummary;
  final List<ApprovedReferenceItem> approvedReferences;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

/// Consent Record per database_schema.md §18.3 & continuity_os.md §7.
class ConsentRecordItem {
  const ConsentRecordItem({
    required this.consentId,
    required this.userId,
    required this.workspaceId,
    required this.consentType,
    required this.version,
    required this.granted,
    required this.faceMatchVerified,
    this.revokedAt,
    this.revokedReason,
    this.createdAt,
  });

  final String consentId;
  final String userId;
  final String workspaceId;
  final String consentType;
  final String version;
  final bool granted;
  final bool faceMatchVerified;
  final DateTime? revokedAt;
  final String? revokedReason;
  final DateTime? createdAt;

  /// True if consent is actively granted, face match passed, and not revoked.
  bool get isValid => granted && faceMatchVerified && revokedAt == null;
}

/// Character Model per database_schema.md §7.1 & continuity_os.md §2-§4.
class CharacterItem {
  const CharacterItem({
    required this.characterId,
    required this.workspaceId,
    required this.name,
    required this.characterType,
    this.description = '',
    this.speakingTone = '',
    this.personalityTags = const [],
    this.avatarUrl = '',
    required this.isDefault,
    required this.consentVerified,
    required this.status,
    this.characterPackId,
    this.consentRecordId,
    this.createdAt,
    this.updatedAt,
  });

  final String characterId;
  final String workspaceId;
  final String name;
  final CharacterType characterType;
  final String description;
  final String speakingTone;
  final List<String> personalityTags;
  final String avatarUrl;
  final bool isDefault;
  final bool consentVerified;
  final CharacterStatus status;
  final String? characterPackId;
  final String? consentRecordId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Acceptance Target 1: Revoked consent blocks generation.
  /// Digital Twin strictly requires consentVerified == true.
  bool get canGenerate {
    if (status != CharacterStatus.CHARACTER_STATUS_READY) {
      return false;
    }
    if (characterType == CharacterType.CHARACTER_TYPE_DIGITAL_TWIN) {
      return consentVerified;
    }
    return true;
  }

  CharacterItem copyWith({
    String? name,
    String? description,
    String? speakingTone,
    List<String>? personalityTags,
    String? avatarUrl,
    bool? isDefault,
    bool? consentVerified,
    CharacterStatus? status,
    String? characterPackId,
    String? consentRecordId,
    DateTime? updatedAt,
  }) {
    return CharacterItem(
      characterId: characterId,
      workspaceId: workspaceId,
      name: name ?? this.name,
      characterType: characterType,
      description: description ?? this.description,
      speakingTone: speakingTone ?? this.speakingTone,
      personalityTags: personalityTags ?? this.personalityTags,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isDefault: isDefault ?? this.isDefault,
      consentVerified: consentVerified ?? this.consentVerified,
      status: status ?? this.status,
      characterPackId: characterPackId ?? this.characterPackId,
      consentRecordId: consentRecordId ?? this.consentRecordId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

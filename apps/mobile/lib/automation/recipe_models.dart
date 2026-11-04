/// Models and business logic for Recipe Marketplace & Governance (M21)
/// Canonical Sources: docs/02_features/automation/recipe_agent_center.md
///                    docs/04_contracts/database_schema.md §12.3B, §25.7, §27.4
///                    docs/03_screens/mobile/screen_mobile_recipes.md (M054)
library;

enum RecipeStatus {
  draft,
  reviewRequired,
  published,
  deprecated,
  retired,
  takenDown;

  static RecipeStatus fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'review_required':
        return RecipeStatus.reviewRequired;
      case 'published':
        return RecipeStatus.published;
      case 'deprecated':
        return RecipeStatus.deprecated;
      case 'retired':
        return RecipeStatus.retired;
      case 'taken_down':
        return RecipeStatus.takenDown;
      case 'draft':
      default:
        return RecipeStatus.draft;
    }
  }
}

enum RecipeInstallationStatus {
  installed,
  customized,
  updateAvailable,
  pinned,
  deprecated,
  workflowDeleted;

  static RecipeInstallationStatus fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'customized':
        return RecipeInstallationStatus.customized;
      case 'update_available':
        return RecipeInstallationStatus.updateAvailable;
      case 'pinned':
        return RecipeInstallationStatus.pinned;
      case 'deprecated':
        return RecipeInstallationStatus.deprecated;
      case 'workflow_deleted':
        return RecipeInstallationStatus.workflowDeleted;
      case 'installed':
      default:
        return RecipeInstallationStatus.installed;
    }
  }
}

class RecipeParameter {
  final String name;
  final String type;
  final String defaultValue;
  final bool required;
  final String description;

  const RecipeParameter({
    required this.name,
    required this.type,
    required this.defaultValue,
    required this.required,
    required this.description,
  });

  factory RecipeParameter.fromJson(Map<String, dynamic> json) {
    return RecipeParameter(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'string',
      defaultValue: json['default_value'] as String? ?? '',
      required: json['required'] as bool? ?? false,
      description: json['description'] as String? ?? '',
    );
  }
}

class MissingCapabilityExplanation {
  final String capabilityKey;
  final String platform;
  final String reason;
  final String resolutionGuidance;
  final String connectUrl;

  const MissingCapabilityExplanation({
    required this.capabilityKey,
    required this.platform,
    required this.reason,
    required this.resolutionGuidance,
    required this.connectUrl,
  });
}

class RecipeTemplate {
  final String recipeId;
  final String? workspaceId; // null for global system recipes
  final String? authorWorkspaceId;
  final String title;
  final String description;
  final String category;
  final String? activepiecesTemplateId;
  final String templateKind; // workflow, style_workflow
  final int templateVersion;
  final Map<String, dynamic> templatePayload;
  final List<RecipeParameter> parameters;
  final List<String> requiredCapabilities;
  final int installCount;
  final double ratingAvg; // 0-5 non-financial rating
  final int reviewCount;
  final String priceUSD; // exact decimal string per DB-H-001
  final RecipeStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RecipeTemplate({
    required this.recipeId,
    this.workspaceId,
    this.authorWorkspaceId,
    required this.title,
    required this.description,
    required this.category,
    this.activepiecesTemplateId,
    required this.templateKind,
    required this.templateVersion,
    required this.templatePayload,
    required this.parameters,
    required this.requiredCapabilities,
    required this.installCount,
    required this.ratingAvg,
    required this.reviewCount,
    required this.priceUSD,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isSystemRecipe => workspaceId == null;
  bool get isFree => priceUSD == '0' || priceUSD == '0.000000' || priceUSD.isEmpty;
}

class RecipeInstallation {
  final String installationId;
  final String workspaceId;
  final String recipeId;
  final String workflowId;
  final int installedVersion;
  final RecipeInstallationStatus status;
  final Map<String, dynamic> parameterValues;
  final String? installedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RecipeInstallation({
    required this.installationId,
    required this.workspaceId,
    required this.recipeId,
    required this.workflowId,
    required this.installedVersion,
    required this.status,
    required this.parameterValues,
    this.installedBy,
    required this.createdAt,
    required this.updatedAt,
  });
}

class RevenueShareSplit {
  final String grossUSD;
  final String creatorUSD; // 70%
  final String platformUSD; // 30%
  final int refundWindowDays;

  const RevenueShareSplit({
    required this.grossUSD,
    required this.creatorUSD,
    required this.platformUSD,
    required this.refundWindowDays,
  });
}

/// Evaluates if workspace capabilities satisfy recipe requirements (Target 2 / AC-M21-003).
List<MissingCapabilityExplanation> checkMissingCapabilities(
  RecipeTemplate recipe,
  Map<String, String> workspaceCapabilities,
) {
  final missing = <MissingCapabilityExplanation>[];

  for (final cap in recipe.requiredCapabilities) {
    final trimmed = cap.trim();
    if (trimmed.isEmpty) continue;

    final parts = trimmed.split('.');
    final platform = parts[0].toLowerCase();

    final directStatus = workspaceCapabilities[trimmed.toLowerCase()];
    final platformStatus = workspaceCapabilities[platform];
    final status = (directStatus ?? platformStatus ?? 'unsupported').toLowerCase();

    if (status == 'supported' || status == 'native' || status == 'active') {
      continue;
    }

    String reason = "Connector '$platform' capability is currently $status.";
    String guidance = "Connect your $platform account in Settings -> Integrations to enable this automation.";
    String connectUrl = "/settings/integrations/$platform";

    if (platform == 'shopee') {
      reason = 'This recipe requires an active Shopee connector with order sync capability.';
      guidance = 'Connect your Shopee seller store in Settings -> Integrations or browse alternatives.';
    } else if (platform == 'tiktok') {
      reason = 'This recipe requires TikTok Direct Publish or Video Sync capability.';
      guidance = 'Authorize your TikTok Creator account with publish permissions in Integrations.';
    }

    missing.add(MissingCapabilityExplanation(
      capabilityKey: cap,
      platform: platform,
      reason: reason,
      resolutionGuidance: guidance,
      connectUrl: connectUrl,
    ));
  }

  return missing;
}

/// Calculates 70/30 creator/platform revenue split without floats (RULE-M21-006, DB-H-001).
RevenueShareSplit calculateRevenueShare(String grossUSD) {
  final clean = grossUSD.trim().isEmpty ? '0.000000' : grossUSD.trim();
  final parts = clean.split('.');
  final whole = BigInt.tryParse(parts[0]) ?? BigInt.zero;
  final fracStr = (parts.length > 1 ? parts[1] : '').padRight(6, '0').substring(0, 6);
  final frac = BigInt.tryParse(fracStr) ?? BigInt.zero;

  final micros = whole * BigInt.from(1000000) + frac;
  final creatorMicros = (micros * BigInt.from(70)) ~/ BigInt.from(100);
  final platformMicros = micros - creatorMicros;

  String formatMicros(BigInt m) {
    final w = m ~/ BigInt.from(1000000);
    final f = (m % BigInt.from(1000000)).toString().padLeft(6, '0');
    return '$w.$f';
  }

  return RevenueShareSplit(
    grossUSD: formatMicros(micros),
    creatorUSD: formatMicros(creatorMicros),
    platformUSD: formatMicros(platformMicros),
    refundWindowDays: 7,
  );
}

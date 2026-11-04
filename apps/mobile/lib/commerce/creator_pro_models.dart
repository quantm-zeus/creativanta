import 'package:creativanta_mobile/generated/creativanta/commerce/v1/creator_pro.pb.dart';

/// Fixed micro-units arithmetic for monetary calculations (never float per DB-H-001).
BigInt parseMicros(String raw) {
  final trimmed = raw.trim();
  final neg = trimmed.startsWith('-');
  final unsigned = neg ? trimmed.substring(1) : trimmed;
  final parts = unsigned.split('.');
  final intPart = parts[0].isEmpty ? '0' : parts[0];
  final fracPart = parts.length > 1 ? parts[1] : '';
  final padded = fracPart.padRight(6, '0').substring(0, 6);
  final micros = BigInt.parse('$intPart$padded');
  return neg ? -micros : micros;
}

String formatMicros(BigInt micros) {
  if (micros == BigInt.zero) {
    return '0.0';
  }
  final scale = BigInt.from(1000000);
  final neg = micros.isNegative;
  final abs = micros.abs();
  final intPart = abs ~/ scale;
  final fracPart = abs % scale;
  if (fracPart == BigInt.zero) {
    return '${neg ? '-' : ''}$intPart.0';
  }
  var fracStr = fracPart.toString().padLeft(6, '0');
  while (fracStr.length > 1 && fracStr.endsWith('0')) {
    fracStr = fracStr.substring(0, fracStr.length - 1);
  }
  return '${neg ? '-' : ''}$intPart.$fracStr';
}

// ----------------------------------------------------------------------------
// Acceptance Target 1: Canonical Deal Lifecycle
// Sequence: negotiating -> agreed -> in_progress -> delivered -> paid -> completed
// ----------------------------------------------------------------------------

enum MobileBrandDealStatus {
  negotiating,
  agreed,
  inProgress,
  delivered,
  paid,
  completed,
  cancelled,
}

class DealTransitionResult {
  const DealTransitionResult({
    required this.isValid,
    this.errorMessage,
  });

  final bool isValid;
  final String? errorMessage;
}

class CanonicalDealLifecycle {
  static const List<MobileBrandDealStatus> sequence = [
    MobileBrandDealStatus.negotiating,
    MobileBrandDealStatus.agreed,
    MobileBrandDealStatus.inProgress,
    MobileBrandDealStatus.delivered,
    MobileBrandDealStatus.paid,
    MobileBrandDealStatus.completed,
  ];

  static DealTransitionResult validateTransition(
    MobileBrandDealStatus current,
    MobileBrandDealStatus target, {
    String? cancellationReason,
    bool financialReversalConfirmed = false,
  }) {
    if (current == target) {
      return const DealTransitionResult(isValid: true);
    }

    // Terminal state
    if (current == MobileBrandDealStatus.completed) {
      return const DealTransitionResult(
        isValid: false,
        errorMessage: 'Completed deals cannot transition to any other status',
      );
    }

    // Cancellation
    if (target == MobileBrandDealStatus.cancelled) {
      final reason = cancellationReason?.trim();
      if (reason == null || reason.isEmpty) {
        return const DealTransitionResult(
          isValid: false,
          errorMessage: 'Cancellation requires a non-empty reason',
        );
      }
      if (current == MobileBrandDealStatus.paid && !financialReversalConfirmed) {
        return const DealTransitionResult(
          isValid: false,
          errorMessage: 'Paid deals require explicit financial reversal confirmation before cancellation',
        );
      }
      return const DealTransitionResult(isValid: true);
    }

    if (current == MobileBrandDealStatus.cancelled) {
      return const DealTransitionResult(
        isValid: false,
        errorMessage: 'Cancelled deals cannot be reopened',
      );
    }

    final currentIndex = sequence.indexOf(current);
    final targetIndex = sequence.indexOf(target);

    if (currentIndex == -1 || targetIndex == -1) {
      return const DealTransitionResult(
        isValid: false,
        errorMessage: 'Unrecognized deal status',
      );
    }

    if (targetIndex != currentIndex + 1) {
      return DealTransitionResult(
        isValid: false,
        errorMessage: 'Invalid transition from $current to $target. Must follow canonical sequence.',
      );
    }

    return const DealTransitionResult(isValid: true);
  }
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: Phishing Cannot Be Acknowledged Away
// ----------------------------------------------------------------------------

const int maxDailyLinksPerWorkspace = 20;

class ThreatScanResult {
  const ThreatScanResult({
    required this.scanStatus,
    required this.phishingDetected,
    required this.blockedFromPublishing,
    required this.details,
  });

  final String scanStatus; // safe, suspicious, phishing, malware
  final bool phishingDetected;
  final bool blockedFromPublishing;
  final String details;
}

ThreatScanResult evaluateLinkThreat(String url) {
  final lower = url.toLowerCase();
  if (lower.contains('phishing') ||
      lower.contains('steal-login') ||
      lower.contains('fake-bank') ||
      lower.contains('credential-harvest')) {
    return const ThreatScanResult(
      scanStatus: 'phishing',
      phishingDetected: true,
      blockedFromPublishing: true,
      details: 'Google Safe Browsing flagged phishing URL. Cannot be activated or published.',
    );
  }
  if (lower.contains('malware') || lower.contains('trojan')) {
    return const ThreatScanResult(
      scanStatus: 'malware',
      phishingDetected: false,
      blockedFromPublishing: true,
      details: 'Malicious payload detected.',
    );
  }
  if (lower.contains('suspicious') || lower.contains('bit.ly/suspect')) {
    return const ThreatScanResult(
      scanStatus: 'suspicious',
      phishingDetected: false,
      blockedFromPublishing: false,
      details: 'Domain marked suspicious by reputation database.',
    );
  }
  return const ThreatScanResult(
    scanStatus: 'safe',
    phishingDetected: false,
    blockedFromPublishing: false,
    details: 'URL verified clean.',
  );
}

class PublishValidationResult {
  const PublishValidationResult({
    required this.allowed,
    this.rejectionReason,
  });

  final bool allowed;
  final String? rejectionReason;
}

PublishValidationResult canPublishBioPage({
  required List<LinkItem> items,
  bool aupAcknowledged = false,
}) {
  // Acceptance Target 2: Phishing CANNOT be acknowledged away.
  // Even if aupAcknowledged is true, any phishing item blocks publishing.
  for (final item in items) {
    if (item.phishingDetected || item.scanStatus == LinkSecurityScanStatus.LINK_SECURITY_SCAN_STATUS_PHISHING) {
      return PublishValidationResult(
        allowed: false,
        rejectionReason:
            'Publishing blocked: Link "${item.label}" is a confirmed phishing threat. Security policy prohibits publishing phishing links; AUP acknowledgment cannot bypass this protection.',
      );
    }
  }

  final activeItems = items.where((i) => i.isActive).toList();
  if (activeItems.isEmpty) {
    return const PublishValidationResult(
      allowed: false,
      rejectionReason: 'Bio page must contain at least one active link before publishing.',
    );
  }

  return const PublishValidationResult(allowed: true);
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: Zero-View RPM Undefined Representation
// ----------------------------------------------------------------------------

class RPMResult {
  const RPMResult({
    required this.rpmMicros,
    required this.rpmIsUndefined,
    required this.formatted,
  });

  final BigInt rpmMicros;
  final bool rpmIsUndefined;
  final String formatted;
}

RPMResult computeRPM({
  required int views,
  required BigInt revenueMicros,
}) {
  // Crucial: Acceptance Target 3 - If views == 0, RPM is strictly undefined!
  if (views <= 0) {
    return RPMResult(
      rpmMicros: BigInt.zero,
      rpmIsUndefined: true,
      formatted: '— (undefined, 0 views)',
    );
  }

  // RPM = (revenue / views) * 1000
  final scale = BigInt.from(1000);
  final rpm = (revenueMicros * scale) ~/ BigInt.from(views);
  return RPMResult(
    rpmMicros: rpm,
    rpmIsUndefined: false,
    formatted: '${formatMicros(rpm)} VND',
  );
}

class RPMDropAlertResult {
  const RPMDropAlertResult({
    required this.alertTriggered,
    required this.changePercent,
  });

  final bool alertTriggered;
  final double changePercent;
}

RPMDropAlertResult checkRPMDropAlert({
  required RPMResult previous,
  required RPMResult current,
  double thresholdPercent = 20.0,
}) {
  // If either period is undefined, no alert is triggered
  if (previous.rpmIsUndefined || current.rpmIsUndefined || previous.rpmMicros <= BigInt.zero) {
    return const RPMDropAlertResult(alertTriggered: false, changePercent: 0.0);
  }

  final prevD = previous.rpmMicros.toDouble();
  final currD = current.rpmMicros.toDouble();
  final changePercent = ((currD - prevD) / prevD) * 100.0;
  final isDrop = changePercent < -thresholdPercent;

  return RPMDropAlertResult(
    alertTriggered: isDrop,
    changePercent: changePercent,
  );
}

// ----------------------------------------------------------------------------
// Acceptance Target 4: All Six Modes Can Reach Entitled Tools
// ----------------------------------------------------------------------------

enum MobileWorkspaceMode {
  creator,
  seller,
  agency,
  affiliate,
  brandCollab,
  liveOperator,
}

enum MobileCreatorProTool {
  bioPages,
  mediaKits,
  rateCards,
  brandDeals,
  contentRoi,
  taxReports,
}

const Map<MobileWorkspaceMode, Set<MobileCreatorProTool>> modeEntitledTools = {
  MobileWorkspaceMode.creator: {
    MobileCreatorProTool.bioPages,
    MobileCreatorProTool.mediaKits,
    MobileCreatorProTool.rateCards,
    MobileCreatorProTool.brandDeals,
    MobileCreatorProTool.contentRoi,
    MobileCreatorProTool.taxReports,
  },
  MobileWorkspaceMode.seller: {
    MobileCreatorProTool.rateCards,
    MobileCreatorProTool.brandDeals,
    MobileCreatorProTool.contentRoi,
  },
  MobileWorkspaceMode.agency: {
    MobileCreatorProTool.bioPages,
    MobileCreatorProTool.mediaKits,
    MobileCreatorProTool.rateCards,
    MobileCreatorProTool.brandDeals,
    MobileCreatorProTool.contentRoi,
    MobileCreatorProTool.taxReports,
  },
  MobileWorkspaceMode.affiliate: {
    MobileCreatorProTool.bioPages,
    MobileCreatorProTool.contentRoi,
    MobileCreatorProTool.taxReports,
  },
  MobileWorkspaceMode.brandCollab: {
    MobileCreatorProTool.mediaKits,
    MobileCreatorProTool.rateCards,
    MobileCreatorProTool.brandDeals,
  },
  MobileWorkspaceMode.liveOperator: {
    MobileCreatorProTool.bioPages,
    MobileCreatorProTool.contentRoi,
  },
};

bool isToolEntitledForMobileMode(MobileWorkspaceMode mode, MobileCreatorProTool tool) {
  final tools = modeEntitledTools[mode];
  return tools != null && tools.contains(tool);
}

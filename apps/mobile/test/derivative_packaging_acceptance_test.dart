import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/production/derivative_packaging_models.dart';

void main() {
  group('P4-08 Mobile Derivative & Packaging QA Acceptance Tests', () {
    // ========================================================================
    // Acceptance Target 1: 150-item partial batch results
    // ========================================================================
    test('Acceptance Target 1: Batch operation on 150 items handles 147 successes and 3 failures gracefully', () {
      final existingItems = <String, DerivativeModel>{};
      final assetIds = <String>[];

      // Seed 147 valid derivative items
      for (int i = 1; i <= 147; i++) {
        final id = 'deriv-mob-${i.toString().padLeft(3, '0')}';
        assetIds.add(id);
        existingItems[id] = DerivativeModel(
          assetId: id,
          parentAssetId: 'master-source-001',
          title: 'Mobile Clip $i',
          derivativeType: 'clip',
          targetChannel: 'tiktok',
          tags: ['initial'],
        );
      }

      // Add 3 failing items
      assetIds.add('invalid-asset-991');
      assetIds.add('missing-asset-992');
      assetIds.add('err-asset-993');

      expect(assetIds.length, equals(150));

      final result = executeBatchTag(
        assetIds: assetIds,
        addTags: ['campaign-2026', 'mobile-approved'],
        removeTags: ['initial'],
        existingItems: existingItems,
      );

      expect(result.totalItems, equals(150));
      expect(result.succeededCount, equals(147));
      expect(result.failedCount, equals(3));
      expect(result.succeededAssetIds.length, equals(147));
      expect(result.failures.length, equals(3));
      expect(result.summary, equals('147/150 succeeded. 3 failed: [view details].'));

      // Check tag update on sample
      final sample = existingItems['deriv-mob-001']!;
      expect(sample.tags, contains('campaign-2026'));
      expect(sample.tags, contains('mobile-approved'));
      expect(sample.tags, isNot(contains('initial')));
    });

    // ========================================================================
    // Acceptance Target 2: No lineage -> routing denied
    // ========================================================================
    test('Acceptance Target 2: Orphan derivative with empty parentAssetId strictly denied routing', () {
      final orphan = DerivativeModel(
        assetId: 'orphan-mob-001',
        parentAssetId: '', // NO LINEAGE
        title: 'Unattributed Mobile Clip',
        derivativeType: 'clip',
        targetChannel: 'tiktok',
      );

      expect(
        () => validateLineageForPackaging(orphan),
        throwsA(isA<LineageException>().having(
          (e) => e.message,
          'message',
          contains('Missing source lineage'),
        )),
      );

      final valid = DerivativeModel(
        assetId: 'valid-mob-002',
        parentAssetId: 'master-src-001', // VALID LINEAGE
        title: 'Attributed Mobile Clip',
        derivativeType: 'clip',
        targetChannel: 'tiktok',
      );

      expect(validateLineageForPackaging(valid), isTrue);
    });

    // ========================================================================
    // Acceptance Target 3: Hard blocks cannot be workspace-overridden
    // ========================================================================
    test('Acceptance Target 3: Commercial content without disclosure creates hard block that cannot be overridden by anyone', () {
      final report = calculatePackagingScore(
        assetId: 'comm-mob-001',
        publishItemId: 'pub-mob-001',
        title: 'Khuyến mãi đặc biệt 50%',
        caption: 'Mua sắm ngay hôm nay tại cửa hàng online',
        hashtags: ['giamgia', 'sale'],
        cta: 'Mua ngay',
        disclosure: '', // MISSING DISCLOSURE
        isCommercial: true,
      );

      expect(report.hasHardBlocks, isTrue);
      expect(report.readyForPackaging, isFalse);
      expect(report.readyToPublish, isFalse);
      expect(report.scoreStatus, equals('critical'));

      final disclosureComp = report.components.firstWhere((c) => c.componentName == 'disclosure');
      expect(disclosureComp.isHardBlocked, isTrue);
      expect(disclosureComp.canOverride, isFalse);

      // Manager override attempt -> FAILS
      expect(
        () => applyWorkspaceOverride(
          report: report,
          componentName: 'disclosure',
          reason: 'Client requested no disclosure tag for branding',
          actorRole: 'Manager',
          userId: 'usr-mgr-01',
        ),
        throwsA(isA<OverridePolicyException>().having(
          (e) => e.message,
          'message',
          contains('cannot be workspace-overridden'),
        )),
      );

      // Owner override attempt -> STILL FAILS
      expect(
        () => applyWorkspaceOverride(
          report: report,
          componentName: 'disclosure',
          reason: 'Owner level authorization override',
          actorRole: 'Owner',
          userId: 'usr-owner-01',
        ),
        throwsA(isA<OverridePolicyException>().having(
          (e) => e.message,
          'message',
          contains('cannot be workspace-overridden'),
        )),
      );
    });

    test('Acceptance Target 3 (Cont): Reviewable warnings can be overridden by Manager with reason >= 10 chars', () {
      final report = calculatePackagingScore(
        assetId: 'reviewable-mob-001',
        publishItemId: 'pub-mob-002',
        title: 'Mẹo hay mỗi ngày',
        caption: 'Ngắn', // short caption -> warning
        hashtags: ['tips'],
        cta: 'Follow kênh',
        disclosure: '',
        isCommercial: false,
      );

      expect(report.hasHardBlocks, isFalse);
      final captionComp = report.components.firstWhere((c) => c.componentName == 'caption');
      expect(captionComp.status, equals('warning'));

      // Editor attempt -> fails
      expect(
        () => applyWorkspaceOverride(
          report: report,
          componentName: 'caption',
          reason: 'Aesthetic minimal caption requested',
          actorRole: 'Editor',
          userId: 'usr-ed-01',
        ),
        throwsA(isA<OverridePolicyException>().having(
          (e) => e.message,
          'message',
          contains('Permission denied'),
        )),
      );

      // Reason < 10 chars -> fails
      expect(
        () => applyWorkspaceOverride(
          report: report,
          componentName: 'caption',
          reason: 'too short',
          actorRole: 'Manager',
          userId: 'usr-mgr-01',
        ),
        throwsA(isA<OverridePolicyException>().having(
          (e) => e.message,
          'message',
          contains('at least 10 characters'),
        )),
      );

      // Valid Manager override -> SUCCEEDS
      final updated = applyWorkspaceOverride(
        report: report,
        componentName: 'caption',
        reason: 'Approved minimalist format by creative lead',
        actorRole: 'Manager',
        userId: 'usr-mgr-01',
      );

      expect(updated.appliedOverrides.length, equals(1));
      expect(updated.appliedOverrides.first.actorRole, equals('Manager'));
      expect(captionComp.status, equals('pass'));
    });

    // ========================================================================
    // A/B Experiment Evidence Threshold (RULE-M10-006)
    // ========================================================================
    test('A/B experiment is inconclusive under 1,000 impressions', () {
      final resLow = evaluateABExperiment(
        viewsA: 400,
        clicksA: 30,
        viewsB: 450,
        clicksB: 50,
      );

      expect(resLow['status'], equals('inconclusive'));
      expect(resLow['winner'], isNull);

      final resHigh = evaluateABExperiment(
        viewsA: 2000,
        clicksA: 100, // 5%
        viewsB: 2000,
        clicksB: 200, // 10% (100% lift)
      );

      expect(resHigh['status'], equals('completed'));
      expect(resHigh['resultStatus'], equals('conclusive'));
      expect(resHigh['winner'], equals('B'));
    });
  });
}

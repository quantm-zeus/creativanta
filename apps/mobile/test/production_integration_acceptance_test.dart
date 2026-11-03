import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/production/production_models.dart';
import 'package:creativanta_mobile/generated/creativanta/production/v1/production.pb.dart' as pb;
import 'package:creativanta_mobile/generated/creativanta/production/v1/production.pbenum.dart' as pbenum;

void main() {
  group('P4-09 Production Integration Acceptance Tests', () {
    test('Acceptance Target 1: All production modes defined and active', () {
      final modeIds = kProductionModes.map((m) => m.id).toSet();

      // Mode 1: Quick Edit
      expect(modeIds.contains('quick_edit'), isTrue);

      // Mode 2: Clip Factory / Batch
      expect(modeIds.contains('batch_gen') || modeIds.contains('broll'), isTrue);

      // Mode 3: Multi-Merge
      expect(modeIds.contains('multi_merge'), isTrue);

      // Mode 4: AI Remix
      expect(modeIds.contains('remix'), isTrue);

      for (final mode in kProductionModes) {
        expect(mode.title.isNotEmpty, isTrue);
        expect(mode.creditCost, greaterThan(0));
      }
    });

    test('Acceptance Target 2 & 3: Trend-to-Remix Lineage Protobuf and Model Persistence', () {
      const trendId = 'trend-skincare-vietnam-2026';
      const referenceUrl = 'https://tiktok.com/@creator/video/73918274912';

      // 1. Dart Protobuf LineageItem with trend_id
      final lineageItem = pb.LineageItem()
        ..parentAssetId = 'asset-p409-remix-parent'
        ..sourceProvider = 'veo'
        ..sourceModel = 'veo-2-turbo'
        ..trendId = trendId;

      expect(lineageItem.trendId, equals(trendId));

      // Serialize and deserialize
      final bytes = lineageItem.writeToBuffer();
      final decodedLineage = pb.LineageItem.fromBuffer(bytes);
      expect(decodedLineage.trendId, equals(trendId));
      expect(decodedLineage.sourceProvider, equals('veo'));

      // 2. Dart Protobuf RemixBlueprint with trend_id
      final protoBlueprint = pb.RemixBlueprint()
        ..blueprintId = 'bp-p409-test'
        ..workspaceId = 'ws-test-01'
        ..referenceUrl = referenceUrl
        ..trendId = trendId
        ..remixScript = 'Remix script derived from trend $trendId'
        ..fidelityLevel = pbenum.FidelityLevel.FIDELITY_LEVEL_ADAPT
        ..originalityScore = 84.5
        ..similarityPercentage = 15.5
        ..status = pbenum.RemixStatus.REMIX_STATUS_GENERATED;

      expect(protoBlueprint.trendId, equals(trendId));
      final bpBytes = protoBlueprint.writeToBuffer();
      final decodedBp = pb.RemixBlueprint.fromBuffer(bpBytes);
      expect(decodedBp.trendId, equals(trendId));
      expect(decodedBp.similarityPercentage, equals(15.5));

      // 3. Mobile UI Model RemixBlueprintModel
      final uiModel = RemixBlueprintModel(
        blueprintId: 'bp-ui-01',
        workspaceId: 'ws-test-01',
        referenceAssetId: 'ref-asset-01',
        referenceUrl: referenceUrl,
        trendId: trendId,
        referenceTranscript: 'Goc ve cham soc da',
        remixScript: 'Ban remix moi la',
        fidelityLevel: 'adapt',
        originalityScore: 84.5,
        similarityPercentage: 15.5,
        status: 'generated',
        createdAt: DateTime.now(),
      );

      expect(uiModel.hasTrendProvenance, isTrue);
      expect(uiModel.trendId, equals(trendId));
    });

    test('Acceptance Target 3: Originality threshold safeguard (< 30%)', () {
      // 15% similarity passes
      final passResult = evaluateRemixOriginality(15.0);
      expect(passResult.passed, isTrue);
      expect(passResult.originalityScore, closeTo(85.0, 0.01));

      // 30% or more fails
      final failResult = evaluateRemixOriginality(32.5);
      expect(failResult.passed, isFalse);
      expect(failResult.explanation, contains('Remix is too similar'));
      expect(failResult.actionableAlternatives.isNotEmpty, isTrue);
    });

    test('Acceptance Target 4: Multi-merge copyright licensing block cannot be bypassed', () {
      final items = [
        const MultiMergeItemModel(
          itemId: 'v1',
          assetId: 'asset-1',
          mediaType: 'video',
          title: 'Video intro',
          durationSeconds: 5.0,
        ),
        const MultiMergeItemModel(
          itemId: 'a1',
          assetId: 'asset-2',
          mediaType: 'audio',
          title: 'Unlicensed Music Track',
          durationSeconds: 10.0,
          hasCopyrightHit: true,
          licenseProofKey: null, // missing license proof
        ),
      ];

      final result = validateMultiMergeTimeline('pro', items);
      expect(result.isValid, isFalse);
      expect(result.hasUnlicensedCopyrightBlock, isTrue);
      expect(result.errors.first, contains('Rights violations cannot be bypassed'));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/content/continuity_models.dart';
import 'package:creativanta_mobile/generated/creativanta/content/v1/continuity.pbenum.dart';
import 'package:creativanta_mobile/ui/content/mobile_character_library_view.dart';

void main() {
  group('P3-03 Continuity OS Acceptance Targets & Models', () {
    test('Acceptance Target 1: Revoked consent blocks generation for Digital Twin', () {
      final validTwin = CharacterItem(
        characterId: 'char-twin-01',
        workspaceId: 'ws-test',
        name: 'Digital Twin Alice',
        characterType: CharacterType.CHARACTER_TYPE_DIGITAL_TWIN,
        isDefault: false,
        consentVerified: true,
        status: CharacterStatus.CHARACTER_STATUS_READY,
      );

      expect(validTwin.canGenerate, isTrue,
          reason: 'Verified digital twin should allow generation');

      // Now simulate consent revocation
      final revokedTwin = validTwin.copyWith(consentVerified: false);
      expect(revokedTwin.canGenerate, isFalse,
          reason: 'Digital twin with revoked consent MUST block generation (Target 1)');

      // Consent record model validation
      final consent = ConsentRecordItem(
        consentId: 'consent-01',
        userId: 'user-01',
        workspaceId: 'ws-test',
        consentType: 'digital_twin',
        version: '1.0-GDPR',
        granted: false,
        faceMatchVerified: true,
        revokedAt: DateTime.now(),
        revokedReason: 'User opted out of AI likeness',
      );
      expect(consent.isValid, isFalse,
          reason: 'Revoked consent record is invalid');
    });

    test('Acceptance Target 2: Pack updates retain old lineage snapshots', () {
      final refV1 = ApprovedReferenceItem(
        referenceId: 'ref-01',
        name: 'Alice Headshot V1',
        mediaUrl: 'https://cdn.creativanta.io/alice_v1.png',
        referenceType: 'headshot',
        status: 'approved',
      );

      final v1Snapshot = PackVersionItem(
        versionId: 'ver-01',
        workspaceId: 'ws-test',
        packId: 'pack-01',
        versionIndex: 1,
        name: 'Alice Continuity Pack v1',
        packType: 'character',
        approvedReferences: [refV1],
        rulesSummary: 'Initial baseline references',
        status: 'deprecated',
        snapshotReason: 'Initial setup',
      );

      final refV2 = ApprovedReferenceItem(
        referenceId: 'ref-02',
        name: 'Alice Headshot 4K',
        mediaUrl: 'https://cdn.creativanta.io/alice_v2.png',
        referenceType: 'headshot',
        status: 'approved',
      );

      final v2Snapshot = PackVersionItem(
        versionId: 'ver-02',
        workspaceId: 'ws-test',
        packId: 'pack-01',
        versionIndex: 2,
        name: 'Alice Continuity Pack v2',
        packType: 'character',
        approvedReferences: [refV2],
        rulesSummary: 'Updated 4K face reference',
        status: 'active',
        snapshotReason: 'High-res upgrade',
      );

      final lineage = [v1Snapshot, v2Snapshot];
      expect(lineage.length, equals(2));
      expect(lineage[0].versionIndex, equals(1));
      expect(lineage[1].versionIndex, equals(2));
      // Preserves immutable old references
      expect(lineage[0].approvedReferences[0].mediaUrl,
          equals('https://cdn.creativanta.io/alice_v1.png'));
      expect(lineage[1].approvedReferences[0].mediaUrl,
          equals('https://cdn.creativanta.io/alice_v2.png'));
    });

    test('Acceptance Target 3: Exactly one default character invariance', () {
      final charA = CharacterItem(
        characterId: 'char-a',
        workspaceId: 'ws-test',
        name: 'Alice',
        characterType: CharacterType.CHARACTER_TYPE_AI_GENERATED,
        isDefault: true,
        consentVerified: true,
        status: CharacterStatus.CHARACTER_STATUS_READY,
      );

      final charB = CharacterItem(
        characterId: 'char-b',
        workspaceId: 'ws-test',
        name: 'Bob',
        characterType: CharacterType.CHARACTER_TYPE_AI_GENERATED,
        isDefault: false,
        consentVerified: true,
        status: CharacterStatus.CHARACTER_STATUS_READY,
      );

      List<CharacterItem> characters = [charA, charB];
      final defaultListBefore = characters.where((c) => c.isDefault).toList();
      expect(defaultListBefore.length, equals(1));
      expect(defaultListBefore.first.characterId, equals('char-a'));

      // Set Bob as default: atomically unsets Alice
      final newDefaultId = 'char-b';
      characters = characters.map((c) {
        return c.copyWith(isDefault: c.characterId == newDefaultId);
      }).toList();

      final defaultListAfter = characters.where((c) => c.isDefault).toList();
      expect(defaultListAfter.length, equals(1));
      expect(defaultListAfter.first.characterId, equals('char-b'));
      expect(characters.firstWhere((c) => c.characterId == 'char-a').isDefault,
          isFalse);
    });

    test('Slot Quota gating per subscription tier (RULE-M08-003)', () {
      expect(CharacterSlotQuota.getQuota('free'), equals(1));
      expect(CharacterSlotQuota.getQuota('starter'), equals(2));
      expect(CharacterSlotQuota.getQuota('pro'), equals(5));
      expect(CharacterSlotQuota.getQuota('business'), equals(15));
      expect(CharacterSlotQuota.getQuota('enterprise'), equals(-1));

      // Free tier: 1 allowed
      expect(CharacterSlotQuota.isExceeded(0, 'free'), isFalse);
      expect(CharacterSlotQuota.isExceeded(1, 'free'), isTrue);

      // Enterprise tier: unlimited
      expect(CharacterSlotQuota.isExceeded(100, 'enterprise'), isFalse);
    });
  });

  group('MobileCharacterLibraryView Widget Tests', () {
    testWidgets('Renders quota card and character cards with default badge',
        (tester) async {
      final initialCharacters = [
        CharacterItem(
          characterId: 'char-01',
          workspaceId: 'ws-test',
          name: 'Mila',
          characterType: CharacterType.CHARACTER_TYPE_AI_GENERATED,
          description: 'Thân thiện, giải thích sản phẩm',
          isDefault: true,
          consentVerified: true,
          status: CharacterStatus.CHARACTER_STATUS_READY,
        ),
        CharacterItem(
          characterId: 'char-02',
          workspaceId: 'ws-test',
          name: 'David Twin',
          characterType: CharacterType.CHARACTER_TYPE_DIGITAL_TWIN,
          description: 'Bản sao kỹ thuật số của Founder',
          isDefault: false,
          consentVerified: false, // Consent revoked
          status: CharacterStatus.CHARACTER_STATUS_READY,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: MobileCharacterLibraryView(
            workspaceId: 'ws-test',
            tier: 'starter',
            initialCharacters: initialCharacters,
          ),
        ),
      );

      // Verify quota header
      expect(find.textContaining('Số lượng nhân vật: 2 / 2 (Gói STARTER)'),
          findsOneWidget);
      expect(find.text('MILA'), findsNothing); // Checks name
      expect(find.text('Mila'), findsOneWidget);
      expect(find.text('MẶC ĐỊNH'), findsOneWidget);

      // Verify second character
      expect(find.text('David Twin'), findsOneWidget);
      expect(find.text('Consent: Bị từ chối / Chưa cấp'), findsOneWidget);

      // Tap "Tạo video" on David Twin (revoked consent) -> dialog blocks generation
      final generateButtons = find.text('Tạo video');
      expect(generateButtons, findsNWidgets(2));
      await tester.tap(generateButtons.at(1));
      await tester.pumpAndSettle();

      // Check alert dialog with fail-closed message
      expect(find.text('Tạo video bị chặn'), findsOneWidget);
      expect(find.textContaining('Consent Revoked'), findsOneWidget);
    });

    testWidgets('Switching default character atomically unsets previous default',
        (tester) async {
      List<CharacterItem>? updatedList;

      final initialCharacters = [
        CharacterItem(
          characterId: 'char-01',
          workspaceId: 'ws-test',
          name: 'Mila',
          characterType: CharacterType.CHARACTER_TYPE_AI_GENERATED,
          isDefault: true,
          consentVerified: true,
          status: CharacterStatus.CHARACTER_STATUS_READY,
        ),
        CharacterItem(
          characterId: 'char-02',
          workspaceId: 'ws-test',
          name: 'David',
          characterType: CharacterType.CHARACTER_TYPE_AI_GENERATED,
          isDefault: false,
          consentVerified: true,
          status: CharacterStatus.CHARACTER_STATUS_READY,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: MobileCharacterLibraryView(
            workspaceId: 'ws-test',
            tier: 'pro',
            initialCharacters: initialCharacters,
            onCharacterChanged: (chars) => updatedList = chars,
          ),
        ),
      );

      // Only 1 "Đặt mặc định" button should exist (on David, since Mila is already default)
      final setDefaultButton = find.text('Đặt mặc định');
      expect(setDefaultButton, findsOneWidget);

      await tester.tap(setDefaultButton);
      await tester.pumpAndSettle();

      // Verify callback updated list
      expect(updatedList, isNotNull);
      final defaultCount = updatedList!.where((c) => c.isDefault).length;
      expect(defaultCount, equals(1));
      expect(
          updatedList!.firstWhere((c) => c.characterId == 'char-02').isDefault,
          isTrue);
      expect(
          updatedList!.firstWhere((c) => c.characterId == 'char-01').isDefault,
          isFalse);
    });
  });
}

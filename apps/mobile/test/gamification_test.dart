import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/generated/creativanta/common/v1/types.pb.dart' as common_pb;
import 'package:creativanta_mobile/generated/creativanta/platform/v1/gamification.pb.dart' as pb;
import 'package:creativanta_mobile/gamification/gamification_models.dart';
import 'package:creativanta_mobile/ui/gamification/gamification_screen.dart';

void main() {
  group('P8-06 Mobile Gamification & Style-Template Sharing (M038)', () {
    // ------------------------------------------------------------------------
    // Target 1: Per-user progress (Levels 1–50, XP thresholds, titles)
    // ------------------------------------------------------------------------
    test('Target 1: exact canonical milestone XP thresholds (EF-11)', () {
      expect(getMobileXPForLevel(1), equals(0));
      expect(getMobileXPForLevel(5), equals(100));
      expect(getMobileXPForLevel(10), equals(500));
      expect(getMobileXPForLevel(20), equals(2000));
      expect(getMobileXPForLevel(50), equals(25000));
    });

    test('Target 1: calculates correct level progression for Level 12 Content Pro', () {
      final progress = calculateMobileLevel(875);
      expect(progress.currentLevel, equals(12));
      expect(progress.title, equals('Content Pro'));
      expect(progress.currentLevelBaseXP, equals(800));
      expect(progress.nextLevelXP, equals(950));
      expect(progress.xpInCurrentLevel, equals(75));
      expect(progress.xpNeededForNextLevel, equals(150));
      expect(progress.progressPercent, equals(50.0));
      expect(progress.isMaxLevel, isFalse);
    });

    test('Target 1: handles Level 50 max level without overflow', () {
      final progress = calculateMobileLevel(26000);
      expect(progress.currentLevel, equals(50));
      expect(progress.progressPercent, equals(100.0));
      expect(progress.isMaxLevel, isTrue);
      expect(progress.title, contains('Huyền thoại sáng tạo'));
    });

    // ------------------------------------------------------------------------
    // Target 2: Reward event replay once (RULE-GAM-006)
    // ------------------------------------------------------------------------
    test('Target 2: reward event replay idempotency prevents duplicate rewards', () {
      final processedIds = <String>{};
      const event = MobileRewardEvent(
        eventId: 'evt-test-reward-101',
        workspaceId: 'ws-mobile',
        userId: 'usr-mobile',
        sourceType: 'streak_milestone_7',
        creditsEarned: 10,
        xpEarned: 100,
      );

      // First processing: awarded
      final firstResult = evaluateMobileRewardReplay(
        event: event,
        processedEventIds: processedIds,
      );
      expect(firstResult.isDuplicate, isFalse);
      expect(firstResult.creditsAwarded, equals(10));
      expect(firstResult.xpAwarded, equals(100));
      processedIds.add(event.eventId);

      // Duplicate replay: rejected with 0 award
      final replayResult = evaluateMobileRewardReplay(
        event: event,
        processedEventIds: processedIds,
      );
      expect(replayResult.isDuplicate, isTrue);
      expect(replayResult.creditsAwarded, equals(0));
      expect(replayResult.xpAwarded, equals(0));
      expect(replayResult.message, contains('Replay bị từ chối'));
    });

    // ------------------------------------------------------------------------
    // Target 3: Licensed template install clones tenant-owned pack
    // ------------------------------------------------------------------------
    test('Target 3: clones style template into tenant-owned pack without source-tenant IDs', () {
      const authorRecipeId = 'rec-cinematic-style-01';
      const templateVersion = 2;
      const sourceSettings = {
        'color_grade': 'teal_orange_film',
        'pacing': 'dynamic_cut_120bpm',
      };
      const buyerWorkspace = 'ws-buyer-mobile';

      final cloned = cloneMobileStyleTemplateToTenant(
        authorRecipeId: authorRecipeId,
        templateVersion: templateVersion,
        sourceSettings: sourceSettings,
        destinationWorkspaceId: buyerWorkspace,
        packName: 'My Imported Cinematic Style',
      );

      expect(cloned.destinationWorkspaceId, equals(buyerWorkspace));
      expect(cloned.clonedPackId, startsWith('sp-mobile-cloned-'));
      expect(cloned.clonedSettings['color_grade'], equals('teal_orange_film'));
      expect(cloned.immutableInstallAudit['recipe_id'], equals(authorRecipeId));
      expect(cloned.immutableInstallAudit['template_version'], equals(templateVersion));
      expect(cloned.immutableInstallAudit['destination_workspace_id'], equals(buyerWorkspace));
      expect(cloned.immutableInstallAudit.containsKey('author_workspace_id'), isFalse);
    });

    // ------------------------------------------------------------------------
    // Target 4: No private source media in shared style template
    // ------------------------------------------------------------------------
    test('Target 4: approves clean parametric style settings', () {
      final res = validateMobileStyleTemplate(
        schemaVersion: 1,
        licenseNotice: 'Creativanta Community License v1.0',
        styleSettings: {
          'color_grade': 'warm_vintage_film',
          'pacing': 'relaxed_cuts',
        },
      );
      expect(res.isValid, isTrue);
      expect(res.issues, isEmpty);
    });

    test('Target 4: rejects private media URLs and local file paths', () {
      final res = validateMobileStyleTemplate(
        schemaVersion: 1,
        licenseNotice: 'Community License',
        styleSettings: {
          'color_grade': 'vintage',
          'raw_media': 'file:///data/user/storage/clip01.mov',
        },
      );
      expect(res.isValid, isFalse);
      expect(res.issues.first, contains('Phát hiện nội dung bị cấm'));
    });

    test('Target 4: rejects voice clone biometric embeddings', () {
      final res = validateMobileStyleTemplate(
        schemaVersion: 1,
        licenseNotice: 'Community License',
        styleSettings: {
          'voice_clone_embedding': [0.12, 0.45, 0.78],
        },
      );
      expect(res.isValid, isFalse);
      expect(res.issues.first, contains('Phát hiện nội dung bị cấm'));
    });

    test('Target 4: rejects face mesh / facial feature vectors', () {
      final res = validateMobileStyleTemplate(
        schemaVersion: 1,
        licenseNotice: 'Community License',
        styleSettings: {
          'face_embedding': 'facial_mesh_data_xyz',
        },
      );
      expect(res.isValid, isFalse);
      expect(res.issues.first, contains('Phát hiện nội dung bị cấm'));
    });

    test('Target 4: rejects API bearer tokens and secrets', () {
      final res = validateMobileStyleTemplate(
        schemaVersion: 1,
        licenseNotice: 'Community License',
        styleSettings: {
          'auth_header': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
        },
      );
      expect(res.isValid, isFalse);
      expect(res.issues.first, contains('Phát hiện nội dung bị cấm'));
    });

    // ------------------------------------------------------------------------
    // Streaks & Downtime Grace Period (RULE-GAM-001..003, EC-GAM-001)
    // ------------------------------------------------------------------------
    test('Streak: protects streak with downtime grace period (EC-GAM-001)', () {
      final now = DateTime.utc(2026, 11, 4, 15, 0);
      final lastActivity = DateTime.utc(2026, 11, 1, 10, 0); // 3 days ago
      final graceUntil = DateTime.utc(2026, 11, 5, 0, 0); // Active grace period

      final status = evaluateMobileStreak(
        currentStreak: 14,
        bestStreak: 21,
        lastActivityAt: lastActivity,
        streakGraceUntil: graceUntil,
        now: now,
      );

      expect(status.isActive, isTrue);
      expect(status.isGraceActive, isTrue);
      expect(status.currentStreak, equals(14));
    });

    // ------------------------------------------------------------------------
    // Proto message compilation & roundtrip verification
    // ------------------------------------------------------------------------
    test('Proto: encodes and decodes CreatorProgress proto message cleanly', () {
      final progressProto = pb.CreatorProgress()
        ..progressId = 'prog-mobile-1'
        ..workspaceId = (common_pb.UUID()..value = 'ws-mobile')
        ..userId = 'usr-mobile'
        ..level = 12
        ..xp = 2840
        ..streakDays = 14
        ..totalAchievements = 2;

      expect(progressProto.level, equals(12));
      expect(progressProto.xp, equals(2840));

      final bytes = progressProto.writeToBuffer();
      final decoded = pb.CreatorProgress.fromBuffer(bytes);

      expect(decoded.workspaceId.value, equals('ws-mobile'));
      expect(decoded.streakDays, equals(14));
      expect(decoded.totalAchievements, equals(2));
    });

    // ------------------------------------------------------------------------
    // Widget Test: MobileGamificationScreen
    // ------------------------------------------------------------------------
    testWidgets('Widget: renders MobileGamificationScreen with Level, Streaks, and Quests', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MobileGamificationScreen(
            initialTotalXP: 875,
            initialCurrentStreak: 14,
            initialBestStreak: 21,
          ),
        ),
      );

      // Verify Level Card elements
      expect(find.textContaining('Level 12'), findsOneWidget);
      expect(find.textContaining('Content Pro'), findsOneWidget);
      expect(find.textContaining('14 ngày'), findsOneWidget);

      // Verify Quests Section
      expect(find.textContaining('Nhiệm Vụ Hoạt Động'), findsOneWidget);
      expect(find.textContaining('Xuất bản 3 video AI'), findsOneWidget);

      // Verify Achievements Section
      expect(find.textContaining('Huy Hiệu Thành Tích'), findsOneWidget);
      expect(find.textContaining('First Creation'), findsOneWidget);

      // Verify Target 2 Replay Tester
      expect(find.textContaining('Thử Nghiệm Replay Idempotency'), findsOneWidget);

      // Scroll to button and tap first time deposit
      await tester.ensureVisible(find.text('Nhận Thưởng (Lần 1)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nhận Thưởng (Lần 1)'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Nhận thành công'), findsOneWidget);

      // Tap replay button (same eventId) -> blocked duplicate!
      await tester.ensureVisible(find.text('Replay Lần 2 (Chặn)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Replay Lần 2 (Chặn)'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Replay bị từ chối'), findsOneWidget);
    });
  });
}

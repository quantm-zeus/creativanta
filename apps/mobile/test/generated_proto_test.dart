import 'package:flutter_test/flutter_test.dart';

import 'package:creativanta_mobile/generated/creativanta/admin/v1/capability.pb.dart';
import 'package:creativanta_mobile/generated/creativanta/admin/v1/internal_admin.pb.dart';
import 'package:creativanta_mobile/generated/creativanta/common/v1/types.pb.dart';

void main() {
  group('Generated Protobuf Tests', () {
    test('Money serialization and exact string deserialization', () {
      final original = Money(amount: '123.456789', currency: 'USD');

      expect(original.amount, '123.456789');
      expect(original.currency, 'USD');

      final bytes = original.writeToBuffer();
      expect(bytes, isNotEmpty);

      final deserialized = Money.fromBuffer(bytes);
      expect(deserialized.amount, '123.456789');
      expect(deserialized.currency, 'USD');
      expect(deserialized, equals(original));
    });

    test('CommandContext instantiation with UUID and field validation', () {
      const workspaceUuid = '00000000-0000-0000-0000-000000000001';
      final uuid = UUID(value: workspaceUuid);
      expect(uuid.value, workspaceUuid);

      final ctx = CommandContext(idempotencyKey: 'dart-01', workspaceId: uuid);

      expect(ctx.idempotencyKey, 'dart-01');
      expect(ctx.hasWorkspaceId(), isTrue);
      expect(ctx.workspaceId.value, workspaceUuid);

      final bytes = ctx.writeToBuffer();
      final deserialized = CommandContext.fromBuffer(bytes);

      expect(deserialized.idempotencyKey, 'dart-01');
      expect(deserialized.workspaceId.value, workspaceUuid);
      expect(deserialized, equals(ctx));
    });

    test('P0-07 CapabilityMatrixCell and ImpersonateResponse round-trip serialization', () {
      final cell = CapabilityMatrixCell(
        platform: 'tiktok',
        capabilityKey: 'publish_post',
        displayName: 'TikTok Video Publish',
        state: CapabilityState.CAPABILITY_STATE_MANUAL,
        verificationFresh: false,
        executable: false,
        reason: 'Unverified route cannot execute',
      );
      final cellDecoded = CapabilityMatrixCell.fromBuffer(cell.writeToBuffer());
      expect(cellDecoded.platform, 'tiktok');
      expect(cellDecoded.state, CapabilityState.CAPABILITY_STATE_MANUAL);
      expect(cellDecoded.executable, isFalse);

      final imp = ImpersonateResponse(
        impersonationId: UUID(value: '00000000-0000-4000-8000-000000000099'),
        mode: 'read_only',
      );
      final impDecoded = ImpersonateResponse.fromBuffer(imp.writeToBuffer());
      expect(impDecoded.mode, 'read_only');
      expect(impDecoded.impersonationId.value, '00000000-0000-4000-8000-000000000099');
    });
  });
}

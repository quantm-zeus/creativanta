import 'package:flutter_test/flutter_test.dart';

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
  });
}

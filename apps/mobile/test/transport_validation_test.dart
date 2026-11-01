import 'package:creativanta_mobile/core/transport_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isCanonicalUuid and validateCanonicalUuid', () {
    test('accepts valid lowercase canonical UUIDs', () {
      expect(isCanonicalUuid('123e4567-e89b-12d3-a456-426614174000'), isTrue);
      expect(isCanonicalUuid('00000000-0000-0000-0000-000000000000'), isTrue);
      expect(isCanonicalUuid('c001f00d-cafe-4000-8000-0123456789ab'), isTrue);
      expect(isCanonicalUuid('ffffffff-ffff-ffff-ffff-ffffffffffff'), isTrue);

      expect(
        () => validateCanonicalUuid('123e4567-e89b-12d3-a456-426614174000'),
        returnsNormally,
      );
    });

    test('rejects uppercase and mixed-case UUIDs', () {
      expect(isCanonicalUuid('123E4567-E89B-12D3-A456-426614174000'), isFalse);
      expect(isCanonicalUuid('123e4567-e89b-12D3-a456-426614174000'), isFalse);
      expect(isCanonicalUuid('C001F00D-CAFE-4000-8000-0123456789AB'), isFalse);

      expect(
        () => validateCanonicalUuid('123E4567-E89B-12D3-A456-426614174000'),
        throwsA(isA<FormatException>()),
      );
    });

    test('rejects malformed UUIDs, incorrect hyphens and lengths', () {
      expect(isCanonicalUuid(''), isFalse);
      expect(isCanonicalUuid('123e4567e89b12d3a456426614174000'), isFalse);
      expect(isCanonicalUuid('123e4567-e89b-12d3-a456-42661417400'), isFalse);
      expect(isCanonicalUuid('123e4567-e89b-12d3-a456-4266141740000'), isFalse);
      expect(isCanonicalUuid('123e4567--89b-12d3-a456-426614174000'), isFalse);
      expect(isCanonicalUuid('123e4567-e89b1-2d3-a456-426614174000'), isFalse);
      expect(isCanonicalUuid(' 123e4567-e89b-12d3-a456-426614174000'), isFalse);
      expect(isCanonicalUuid('123e4567-e89b-12d3-a456-426614174000 '), isFalse);
      expect(isCanonicalUuid('g23e4567-e89b-12d3-a456-426614174000'), isFalse);
      expect(isCanonicalUuid('z23e4567-e89b-12d3-a456-426614174000'), isFalse);
    });
  });

  group('validateMoney', () {
    test('accepts valid amounts and standard currencies', () {
      expect(() => validateMoney('0', 'USD'), returnsNormally);
      expect(() => validateMoney('0.0', 'EUR'), returnsNormally);
      expect(() => validateMoney('0.00', 'GBP'), returnsNormally);
      expect(() => validateMoney('10', 'JPY'), returnsNormally);
      expect(() => validateMoney('100.50', 'CAD'), returnsNormally);
      expect(() => validateMoney('999999999999999999', 'USD'), returnsNormally);
      expect(() => validateMoney('0.123456', 'EUR'), returnsNormally);
      expect(
        () => validateMoney('123456789012.123456', 'GBP'),
        returnsNormally,
      );
    });

    test('validates currency must be 3 uppercase ASCII letters', () {
      expect(
        () => validateMoney('10.00', 'usd'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => validateMoney('10.00', 'US'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => validateMoney('10.00', 'USDT'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => validateMoney('10.00', 'U1D'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => validateMoney('10.00', r'U$D'),
        throwsA(isA<FormatException>()),
      );
      expect(() => validateMoney('10.00', ''), throwsA(isA<FormatException>()));
    });

    test('rejects leading zeros on integers greater than zero', () {
      expect(() => validateMoney('00', 'USD'), throwsA(isA<FormatException>()));
      expect(() => validateMoney('01', 'USD'), throwsA(isA<FormatException>()));
      expect(
        () => validateMoney('007.50', 'USD'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => validateMoney('0123.45', 'USD'),
        throwsA(isA<FormatException>()),
      );
    });

    test('enforces decimal places limit up to 6', () {
      expect(() => validateMoney('10.123456', 'USD'), returnsNormally);
      expect(
        () => validateMoney('10.1234567', 'USD'),
        throwsA(isA<FormatException>()),
      );
    });

    test('enforces total digits limit up to 18', () {
      // 18 digits total
      expect(() => validateMoney('999999999999999999', 'USD'), returnsNormally);
      expect(
        () => validateMoney('123456789012.123456', 'USD'),
        returnsNormally,
      );

      // 19 digits total
      expect(
        () => validateMoney('1000000000000000000', 'USD'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => validateMoney('1234567890123.123456', 'USD'),
        throwsA(isA<FormatException>()),
      );
    });

    test(
      'rejects scientific notation, plus sign, spaces, and empty strings',
      () {
        expect(() => validateMoney('', 'USD'), throwsA(isA<FormatException>()));
        expect(
          () => validateMoney('1e5', 'USD'),
          throwsA(isA<FormatException>()),
        );
        expect(
          () => validateMoney('1.5E3', 'USD'),
          throwsA(isA<FormatException>()),
        );
        expect(
          () => validateMoney('+10.00', 'USD'),
          throwsA(isA<FormatException>()),
        );
        expect(
          () => validateMoney(' 10.00', 'USD'),
          throwsA(isA<FormatException>()),
        );
        expect(
          () => validateMoney('10.00 ', 'USD'),
          throwsA(isA<FormatException>()),
        );
        expect(
          () => validateMoney('.5', 'USD'),
          throwsA(isA<FormatException>()),
        );
        expect(
          () => validateMoney('5.', 'USD'),
          throwsA(isA<FormatException>()),
        );
        expect(
          () => validateMoney('10.0.0', 'USD'),
          throwsA(isA<FormatException>()),
        );
        expect(
          () => validateMoney('abc', 'USD'),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test('handles negative amounts according to allowNegative flag', () {
      // By default allowNegative is false
      expect(
        () => validateMoney('-10.00', 'USD'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => validateMoney('-10.00', 'USD', allowNegative: false),
        throwsA(isA<FormatException>()),
      );

      // When allowNegative is true
      expect(
        () => validateMoney('-10.00', 'USD', allowNegative: true),
        returnsNormally,
      );
      expect(
        () => validateMoney('-0.50', 'USD', allowNegative: true),
        returnsNormally,
      );
      expect(
        () => validateMoney('-123456789012.123456', 'USD', allowNegative: true),
        returnsNormally,
      );

      // Negative zero is strictly disallowed
      expect(
        () => validateMoney('-0', 'USD', allowNegative: true),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => validateMoney('-0.0', 'USD', allowNegative: true),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => validateMoney('-0.00', 'USD', allowNegative: true),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => validateMoney('-0.000000', 'USD', allowNegative: true),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('normalizePagination', () {
    test('normalizes pageSize 0 to 20', () {
      final res = normalizePagination(0, 'token_abc');
      expect(res.pageSize, 20);
      expect(res.pageToken, 'token_abc');
    });

    test('preserves valid pageSize between 1 and 100', () {
      expect(normalizePagination(1, 'tok').pageSize, 1);
      expect(normalizePagination(50, 'tok').pageSize, 50);
      expect(normalizePagination(100, 'tok').pageSize, 100);
    });

    test('rejects pageSize < 0 or > 100', () {
      expect(
        () => normalizePagination(-1, 'tok'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => normalizePagination(101, 'tok'),
        throwsA(isA<FormatException>()),
      );
    });

    test('accepts empty pageToken and valid token strings', () {
      final emptyRes = normalizePagination(20, '');
      expect(emptyRes.pageToken, '');

      final normalRes = normalizePagination(20, 'next-page_v1.key=123');
      expect(normalRes.pageToken, 'next-page_v1.key=123');
    });

    test('enforces pageToken length <= 512', () {
      final maxToken = 'a' * 512;
      expect(normalizePagination(20, maxToken).pageToken, maxToken);

      final tooLongToken = 'a' * 513;
      expect(
        () => normalizePagination(20, tooLongToken),
        throwsA(isA<FormatException>()),
      );
    });

    test('rejects pageToken with spaces or control characters', () {
      expect(
        () => normalizePagination(20, 'token with spaces'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => normalizePagination(20, 'token\twithTab'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => normalizePagination(20, 'token\nwithNewline'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => normalizePagination(20, 'token\rwithCR'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => normalizePagination(20, 'token\x00nullByte'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => normalizePagination(20, 'token\x7fdel'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('validateIdempotencyKey', () {
    test('accepts valid 1..255 printable ASCII keys', () {
      expect(() => validateIdempotencyKey('a'), returnsNormally);
      expect(
        () => validateIdempotencyKey('order-create-2026-11-01-uuid123'),
        returnsNormally,
      );
      expect(
        () => validateIdempotencyKey('key_with:special.chars!~'),
        returnsNormally,
      );
      expect(() => validateIdempotencyKey('x' * 255), returnsNormally);
    });

    test('rejects empty key or key > 255 chars', () {
      expect(() => validateIdempotencyKey(''), throwsA(isA<FormatException>()));
      expect(
        () => validateIdempotencyKey('x' * 256),
        throwsA(isA<FormatException>()),
      );
    });

    test('rejects non-printable or non-ASCII characters', () {
      expect(
        () => validateIdempotencyKey('key\nnewline'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => validateIdempotencyKey('key\ttab'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => validateIdempotencyKey('key\x00null'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => validateIdempotencyKey('key\x7fdel'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => validateIdempotencyKey('key_café'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => validateIdempotencyKey('key_🚀'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('validateReason', () {
    test('accepts null reason', () {
      expect(() => validateReason(null), returnsNormally);
    });

    test('accepts valid reason between 1 and 2000 characters', () {
      expect(() => validateReason('a'), returnsNormally);
      expect(
        () => validateReason('Customer requested cancellation.'),
        returnsNormally,
      );
      expect(() => validateReason('r' * 2000), returnsNormally);
    });

    test('rejects empty string reason', () {
      expect(() => validateReason(''), throwsA(isA<FormatException>()));
    });

    test('rejects reason exceeding 2000 characters', () {
      expect(() => validateReason('r' * 2001), throwsA(isA<FormatException>()));
    });
  });
}

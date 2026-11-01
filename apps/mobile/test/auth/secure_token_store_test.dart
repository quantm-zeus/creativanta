import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/auth/secure_token_store.dart';

void main() {
  group('EphemeralSecureTokenStore security contracts', () {
    late EphemeralSecureTokenStore store;

    setUp(() {
      store = EphemeralSecureTokenStore();
    });

    test('stores and retrieves token successfully', () async {
      const sampleJwt = 'header.payload.signature';
      await store.writeToken(key: 'clerk_session_jwt', token: sampleJwt);

      final retrieved = await store.readToken(key: 'clerk_session_jwt');
      expect(retrieved, equals(sampleJwt));
    });

    test('returns null for non-existent token key', () async {
      final retrieved = await store.readToken(key: 'non_existent_key');
      expect(retrieved, isNull);
    });

    test('rejects empty token values fail-closed', () async {
      expect(
        () => store.writeToken(key: 'empty_key', token: ''),
        throwsArgumentError,
      );
    });

    test('deletes individual token and zeroes memory', () async {
      const sampleToken = 'token_to_delete';
      await store.writeToken(key: 'delete_me', token: sampleToken);
      expect(await store.readToken(key: 'delete_me'), equals(sampleToken));

      await store.deleteToken(key: 'delete_me');
      expect(await store.readToken(key: 'delete_me'), isNull);
      expect(store.entryCount, equals(0));
    });

    test('clearAll removes and zeroes all tokens', () async {
      await store.writeToken(key: 'token_1', token: 'jwt_value_1');
      await store.writeToken(key: 'token_2', token: 'jwt_value_2');
      expect(store.entryCount, equals(2));

      await store.clearAll();
      expect(store.entryCount, equals(0));
      expect(await store.readToken(key: 'token_1'), isNull);
      expect(await store.readToken(key: 'token_2'), isNull);
    });

    test('toString() redacts and never discloses cleartext tokens or keys', () async {
      const secretJwt = 'sensitive_clerk_jwt_token_secret';
      await store.writeToken(key: 'secret_key', token: secretJwt);

      final stringRep = store.toString();
      expect(stringRep.contains(secretJwt), isFalse,
          reason: 'Token store toString must never disclose cleartext JWT');
      expect(stringRep.contains('[REDACTED]'), isTrue);
    });
  });
}

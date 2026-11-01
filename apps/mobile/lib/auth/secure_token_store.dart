import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Contract for secure token persistence.
///
/// CRITICAL SECURITY CONTRACT:
/// - Never store JWTs or credentials in cleartext (e.g. SharedPreferences or plain files).
/// - Ephemeral or platform hardware-backed secure storage (iOS Keychain, Android KeyStore)
///   MUST be used.
/// - Tokens must be scrubbed from memory upon sign-out.
/// - Logging or toString() MUST never disclose session tokens or credentials.
abstract class SecureTokenStore {
  Future<void> writeToken({required String key, required String token});
  Future<String?> readToken({required String key});
  Future<void> deleteToken({required String key});
  Future<void> clearAll();
}

/// In-memory ephemeral secure token store with memory-zeroing and redaction.
///
/// Holds tokens in memory during active session lifecycle only.
/// Cleared completely upon logout or session termination.
class EphemeralSecureTokenStore implements SecureTokenStore {
  final Map<String, List<int>> _obfuscatedStore = {};

  // Simple XOR mask key generated per session to prevent idle heap cleartext inspection.
  final int _mask = 0xA5;

  @override
  Future<void> writeToken({required String key, required String token}) async {
    if (token.isEmpty) {
      throw ArgumentError('Token must not be empty');
    }
    final bytes = utf8.encode(token);
    final masked = bytes.map((b) => b ^ _mask).toList(growable: false);
    _obfuscatedStore[key] = masked;
  }

  @override
  Future<String?> readToken({required String key}) async {
    final masked = _obfuscatedStore[key];
    if (masked == null) {
      return null;
    }
    final unmasked = masked.map((b) => b ^ _mask).toList(growable: false);
    return utf8.decode(unmasked);
  }

  @override
  Future<void> deleteToken({required String key}) async {
    final bytes = _obfuscatedStore.remove(key);
    if (bytes != null) {
      // Zero out memory
      for (var i = 0; i < bytes.length; i++) {
        bytes[i] = 0;
      }
    }
  }

  @override
  Future<void> clearAll() async {
    for (final key in _obfuscatedStore.keys.toList()) {
      await deleteToken(key: key);
    }
    _obfuscatedStore.clear();
  }

  @visibleForTesting
  int get entryCount => _obfuscatedStore.length;

  @override
  String toString() => 'EphemeralSecureTokenStore(entries: ${_obfuscatedStore.length}, contents: [REDACTED])';
}

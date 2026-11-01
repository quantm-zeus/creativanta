/// Pure transport validation rules mirroring TS/Go transport contracts.
///
/// Contains contract-level assertion and normalization helpers for:
/// - Canonical lower-case UUIDs
/// - Money decimal amounts and 3-letter currency codes
/// - Pagination normalization (pageSize and pageToken)
/// - Idempotency keys
/// - Reason strings
library;

final RegExp _uuidRegExp = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
);

final RegExp _currencyRegExp = RegExp(r'^[A-Z]{3}$');

final RegExp _digitsOnlyRegExp = RegExp(r'^[0-9]+$');

/// Returns true if [uuid] matches the canonical 36-character lower-case
/// hyphenated UUID format (8-4-4-4-12 hex digits, no uppercase).
bool isCanonicalUuid(String uuid) {
  return _uuidRegExp.hasMatch(uuid);
}

/// Validates that [uuid] is a canonical lower-case UUID, throwing [FormatException]
/// if it is invalid.
void validateCanonicalUuid(String uuid) {
  if (!isCanonicalUuid(uuid)) {
    throw FormatException(
      'Invalid canonical UUID "$uuid": must be 36 lowercase hexadecimal characters formatted as 8-4-4-4-12.',
    );
  }
}

/// Validates a financial [amount] and 3-letter [currency] code.
///
/// Rules:
/// - [currency]: Exactly 3 uppercase ASCII letters.
/// - [amount]: Plain decimal string with up to 18 total digits and up to 6
///   decimal places. No exponent notation (`e`/`E`), no `+` sign, no whitespace.
/// - Leading zeros are prohibited except for integer "0".
/// - Negative amounts are allowed only when [allowNegative] is true.
/// - Negative zero (e.g. "-0", "-0.00") is strictly prohibited even if
///   [allowNegative] is true.
///
/// Throws [FormatException] if validation fails.
void validateMoney(
  String amount,
  String currency, {
  bool allowNegative = false,
}) {
  if (!_currencyRegExp.hasMatch(currency)) {
    throw FormatException(
      'Invalid currency "$currency": must be exactly 3 uppercase ASCII letters.',
    );
  }

  if (amount.isEmpty) {
    throw const FormatException('Amount cannot be empty.');
  }

  var raw = amount;
  var isNegative = false;
  if (raw.startsWith('-')) {
    if (!allowNegative) {
      throw FormatException('Negative amounts are not allowed: "$amount".');
    }
    isNegative = true;
    raw = raw.substring(1);
    if (raw.isEmpty) {
      throw FormatException(
        'Invalid amount "$amount": missing numeric digits after negative sign.',
      );
    }
  }

  // Reject exponent notation, positive unary sign, or any whitespace.
  if (raw.startsWith('+') ||
      raw.contains('e') ||
      raw.contains('E') ||
      raw.contains(' ') ||
      raw.contains('\t') ||
      raw.contains('\n') ||
      raw.contains('\r')) {
    throw FormatException(
      'Invalid amount "$amount": plain decimal format required with no exponents or whitespace.',
    );
  }

  final parts = raw.split('.');
  if (parts.length > 2) {
    throw FormatException(
      'Invalid amount "$amount": multiple decimal points encountered.',
    );
  }

  final intPart = parts[0];
  final decPart = parts.length == 2 ? parts[1] : null;

  if (intPart.isEmpty) {
    throw FormatException(
      'Invalid amount "$amount": missing integer part before decimal point.',
    );
  }

  if (!_digitsOnlyRegExp.hasMatch(intPart)) {
    throw FormatException(
      'Invalid amount "$amount": integer part contains non-digit characters.',
    );
  }

  // Prohibit leading zero unless integer part is exactly "0".
  if (intPart.length > 1 && intPart.startsWith('0')) {
    throw FormatException(
      'Invalid amount "$amount": leading zeros are not allowed.',
    );
  }

  if (decPart != null) {
    if (decPart.isEmpty) {
      throw FormatException(
        'Invalid amount "$amount": trailing decimal point without fractional digits.',
      );
    }
    if (!_digitsOnlyRegExp.hasMatch(decPart)) {
      throw FormatException(
        'Invalid amount "$amount": fractional part contains non-digit characters.',
      );
    }
    if (decPart.length > 6) {
      throw FormatException(
        'Invalid amount "$amount": exceeds maximum of 6 decimal places (got ${decPart.length}).',
      );
    }
  }

  final totalDigits = intPart.length + (decPart?.length ?? 0);
  if (totalDigits > 18) {
    throw FormatException(
      'Invalid amount "$amount": exceeds maximum of 18 total digits (got $totalDigits).',
    );
  }

  if (isNegative) {
    final combined = intPart + (decPart ?? '');
    if (combined.replaceAll('0', '').isEmpty) {
      throw FormatException(
        'Invalid amount "$amount": negative zero is not allowed.',
      );
    }
  }
}

/// Normalizes pagination parameters [pageSize] and [pageToken].
///
/// Rules:
/// - If [pageSize] is 0, normalizes to 20.
/// - Otherwise [pageSize] must be in the range 1..100 inclusive.
/// - [pageToken] must have length <= 512 and must contain no spaces or control characters.
///
/// Returns a Dart 3 record `({int pageSize, String pageToken})`.
/// Throws [FormatException] if validation fails.
({int pageSize, String pageToken}) normalizePagination(
  int pageSize,
  String pageToken,
) {
  if (pageSize < 0 || pageSize > 100) {
    throw FormatException(
      'Invalid pageSize $pageSize: must be between 1 and 100 (or 0 for default 20).',
    );
  }

  final resolvedPageSize = pageSize == 0 ? 20 : pageSize;

  if (pageToken.length > 512) {
    throw FormatException(
      'Invalid pageToken: length exceeds maximum of 512 characters (got ${pageToken.length}).',
    );
  }

  for (var i = 0; i < pageToken.length; i++) {
    final code = pageToken.codeUnitAt(i);
    // ASCII control codes (0-31), space (32), DEL (127), and C1 control codes (128-159).
    if (code <= 32 || code == 127 || (code >= 128 && code <= 159)) {
      throw FormatException(
        'Invalid pageToken: contains space or control character (code $code at index $i).',
      );
    }
  }

  // Unicode whitespace check
  if (RegExp(r'\s').hasMatch(pageToken)) {
    throw const FormatException(
      'Invalid pageToken: contains whitespace character.',
    );
  }

  return (pageSize: resolvedPageSize, pageToken: pageToken);
}

/// Validates an [idempotencyKey].
///
/// Rules:
/// - Length must be between 1 and 255 characters inclusive.
/// - Must consist entirely of printable ASCII characters (code units 32 to 126 inclusive).
///
/// Throws [FormatException] if validation fails.
void validateIdempotencyKey(String idempotencyKey) {
  if (idempotencyKey.isEmpty || idempotencyKey.length > 255) {
    throw FormatException(
      'Invalid idempotencyKey: length must be between 1 and 255 characters (got ${idempotencyKey.length}).',
    );
  }

  for (var i = 0; i < idempotencyKey.length; i++) {
    final code = idempotencyKey.codeUnitAt(i);
    if (code < 32 || code > 126) {
      throw FormatException(
        'Invalid idempotencyKey: contains non-printable or non-ASCII character (code $code at index $i).',
      );
    }
  }
}

/// Validates an optional [reason] string.
///
/// Rules:
/// - If null, valid (no-op).
/// - If non-null, length must be between 1 and 2000 characters inclusive.
///
/// Throws [FormatException] if validation fails.
void validateReason(String? reason) {
  if (reason == null) {
    return;
  }
  if (reason.isEmpty || reason.length > 2000) {
    throw FormatException(
      'Invalid reason: when provided, length must be between 1 and 2000 characters (got ${reason.length}).',
    );
  }
}

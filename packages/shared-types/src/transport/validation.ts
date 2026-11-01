/**
 * Transport-level validation utilities for Creativanta wire payloads.
 * Pure functions enforcing canonical contracts with zero runtime dependencies.
 */

const CANONICAL_UUID_REGEX =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/;

const CURRENCY_REGEX = /^[A-Z]{3}$/;

const DECIMAL_AMOUNT_REGEX = /^(0|[1-9]\d*)(\.\d+)?$/;

const PRINTABLE_ASCII_REGEX = /^[\x20-\x7E]+$/;

// Reject C0 and C1 controls consistently with the Dart client.
const PAGE_TOKEN_FORBIDDEN_REGEX = /[\s\x00-\x1f\x7f\u0080-\u009f]/;

const LONE_SURROGATE_REGEX =
  /[\uD800-\uDBFF](?![\uDC00-\uDFFF])|(?<![\uD800-\uDBFF])[\uDC00-\uDFFF]/;

/**
 * Validates canonical RFC 9562 UUID:
 * Lowercase hexadecimal with 5 hyphen-separated groups (8-4-4-4-12), total length 36.
 */
export function isCanonicalUuid(value: string): boolean {
  if (typeof value !== 'string' || value.length !== 36) {
    return false;
  }
  return CANONICAL_UUID_REGEX.test(value);
}

/**
 * Validates monetary amount and currency wire fields:
 * - Currency: required uppercase ISO-like 3 letters (e.g. "USD").
 * - Amount: exact canonical decimal string, precision <= 18 total digits, scale <= 6,
 *   no exponent notation, no leading zeros, negative only if allowNegative is true,
 *   negative zero is always forbidden.
 * Throws RangeError for any contract violation.
 */
export function assertMoney(
  amount: string,
  currency: string,
  allowNegative?: boolean
): void {
  if (typeof currency !== 'string' || !CURRENCY_REGEX.test(currency)) {
    throw new RangeError(
      `Invalid currency code: "${currency}". Expected 3 uppercase ASCII letters.`
    );
  }

  if (typeof amount !== 'string') {
    throw new RangeError('Money amount must be a string');
  }

  if (amount.length === 0) {
    throw new RangeError('Money amount cannot be empty');
  }

  if (/[eE]/.test(amount)) {
    throw new RangeError(
      `Invalid money amount: "${amount}". Exponent notation is forbidden.`
    );
  }

  const isNegative = amount.startsWith('-');
  const numericPart = isNegative ? amount.slice(1) : amount;

  if (numericPart.length === 0) {
    throw new RangeError(`Invalid money amount: "${amount}". Missing digits.`);
  }

  if (isNegative) {
    if (!allowNegative) {
      throw new RangeError(
        `Negative money amount "${amount}" is not allowed.`
      );
    }
    if (/^0+(\.0+)?$/.test(numericPart)) {
      throw new RangeError(
        `Invalid money amount: "${amount}". Negative zero is forbidden in canonical representation.`
      );
    }
  }

  if (!DECIMAL_AMOUNT_REGEX.test(numericPart)) {
    throw new RangeError(
      `Invalid money amount format: "${amount}". Must be an exact canonical decimal string without leading zeros.`
    );
  }

  let scale = 0;
  let totalDigits = 0;

  if (numericPart.includes('.')) {
    const [intPart, fracPart] = numericPart.split('.');
    scale = fracPart.length;
    totalDigits = intPart.length + fracPart.length;
  } else {
    totalDigits = numericPart.length;
  }

  if (scale > 6) {
    throw new RangeError(
      `Money amount scale (${scale}) exceeds maximum allowed scale of 6 decimal places.`
    );
  }

  if (totalDigits > 18) {
    throw new RangeError(
      `Money amount precision (${totalDigits} digits) exceeds maximum allowed precision of 18 digits.`
    );
  }
}

/**
 * Normalizes and validates pagination wire fields:
 * - pageSize: 0 defaults to 20; otherwise must be an integer between 1 and 100.
 * - pageToken: must be <= 512 characters and contain no spaces or control characters.
 * Throws RangeError if invalid.
 */
export function normalizePagination(
  pageSize: number,
  pageToken: string
): { pageSize: number; pageToken: string } {
  if (typeof pageSize !== 'number' || !Number.isInteger(pageSize)) {
    throw new RangeError(
      `Invalid page_size: expected integer, received ${pageSize}`
    );
  }

  if (pageSize < 0 || pageSize > 100) {
    throw new RangeError(
      `Invalid page_size: ${pageSize}. Allowed values are 0 (defaults to 20) or 1..100.`
    );
  }

  if (typeof pageToken !== 'string') {
    throw new RangeError('Invalid page_token: expected string');
  }

  if (pageToken.length > 512) {
    throw new RangeError(
      `Invalid page_token: length (${pageToken.length}) exceeds maximum limit of 512 characters.`
    );
  }

  if (PAGE_TOKEN_FORBIDDEN_REGEX.test(pageToken)) {
    throw new RangeError(
      'Invalid page_token: must not contain spaces or control characters.'
    );
  }

  const normalizedPageSize = pageSize === 0 ? 20 : pageSize;

  return {
    pageSize: normalizedPageSize,
    pageToken,
  };
}

/**
 * Validates command idempotency key:
 * Required non-empty ASCII printable string between 1 and 255 characters (0x20 to 0x7E).
 * Throws RangeError if invalid.
 */
export function validateIdempotencyKey(value: string): void {
  if (typeof value !== 'string') {
    throw new RangeError('Idempotency key must be a string');
  }

  if (value.length < 1 || value.length > 255) {
    throw new RangeError(
      `Idempotency key length must be between 1 and 255 characters, received ${value.length}.`
    );
  }

  if (!PRINTABLE_ASCII_REGEX.test(value)) {
    throw new RangeError(
      'Idempotency key must contain only printable ASCII characters.'
    );
  }
}

/**
 * Validates optional audit reason:
 * When undefined, passes validation.
 * When supplied, must be non-empty string between 1 and 2000 characters without lone surrogates.
 * Throws RangeError if empty or invalid when supplied.
 */
export function validateReason(reason: string | undefined): void {
  if (reason === undefined) {
    return;
  }

  if (typeof reason !== 'string') {
    throw new RangeError('Audit reason must be a string when supplied');
  }

  if (reason.length === 0) {
    throw new RangeError('Audit reason cannot be empty when supplied');
  }

  if (reason.length > 2000) {
    throw new RangeError(
      `Audit reason length (${reason.length}) exceeds maximum allowed length of 2000 characters.`
    );
  }

  if (
    (typeof (reason as unknown as { isWellFormed?: () => boolean }).isWellFormed === 'function' &&
      !(reason as unknown as { isWellFormed: () => boolean }).isWellFormed()) ||
    LONE_SURROGATE_REGEX.test(reason)
  ) {
    throw new RangeError(
      'Audit reason contains malformed Unicode (lone surrogate code points).'
    );
  }
}

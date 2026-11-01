import { describe, it, expect } from 'vitest';
import {
  isCanonicalUuid,
  assertMoney,
  normalizePagination,
  validateIdempotencyKey,
  validateReason,
} from '../src/transport/validation.js';

describe('isCanonicalUuid', () => {
  it('accepts standard RFC 9562 lowercase UUIDs', () => {
    expect(isCanonicalUuid('f47ac10b-58cc-4372-a567-0e02b2c3d479')).toBe(true);
    expect(isCanonicalUuid('01890a5c-7b24-7000-8000-000000000000')).toBe(true);
    expect(isCanonicalUuid('00000000-0000-0000-0000-000000000000')).toBe(true);
    expect(isCanonicalUuid('ffffffff-ffff-ffff-ffff-ffffffffffff')).toBe(true);
  });

  it('rejects corrupt UUIDs with uppercase or mixed-case hex', () => {
    expect(isCanonicalUuid('F47AC10B-58CC-4372-A567-0E02B2C3D479')).toBe(false);
    expect(isCanonicalUuid('f47ac10b-58cc-4372-A567-0e02b2c3d479')).toBe(false);
    expect(isCanonicalUuid('01890A5C-7B24-7000-8000-000000000000')).toBe(false);
  });

  it('rejects corrupt UUIDs with missing, extra, or misplaced hyphens', () => {
    expect(isCanonicalUuid('f47ac10b58cc-4372-a567-0e02b2c3d479')).toBe(false);
    expect(isCanonicalUuid('f47ac10b-58cc4372-a567-0e02b2c3d479')).toBe(false);
    expect(isCanonicalUuid('f47ac10b-58cc-4372a567-0e02b2c3d479')).toBe(false);
    expect(isCanonicalUuid('f47ac10b-58cc-4372-a5670e02b2c3d479')).toBe(false);
    expect(isCanonicalUuid('f47ac10-b58cc-4372-a567-0e02b2c3d479')).toBe(false);
    expect(isCanonicalUuid('f47ac10b-58cc-4372-a567--0e02b2c3d479')).toBe(false);
  });

  it('rejects corrupt UUIDs with invalid characters or bad lengths', () => {
    expect(isCanonicalUuid('g47ac10b-58cc-4372-a567-0e02b2c3d479')).toBe(false);
    expect(isCanonicalUuid('f47ac10b-58cc-4372-a567-0e02b2c3d47z')).toBe(false);
    expect(isCanonicalUuid('f47ac10b-58cc-4372-a567-0e02b2c3d47')).toBe(false);
    expect(isCanonicalUuid('f47ac10b-58cc-4372-a567-0e02b2c3d4799')).toBe(false);
    expect(isCanonicalUuid('')).toBe(false);
    expect(isCanonicalUuid(' ')).toBe(false);
    expect(isCanonicalUuid(' f47ac10b-58cc-4372-a567-0e02b2c3d479')).toBe(false);
    expect(isCanonicalUuid('{f47ac10b-58cc-4372-a567-0e02b2c3d479}')).toBe(false);
    expect(isCanonicalUuid('urn:uuid:f47ac10b-58cc-4372-a567-0e02b2c3d479')).toBe(false);
  });

  it('handles non-string types safely without throwing', () => {
    expect(isCanonicalUuid(null as unknown as string)).toBe(false);
    expect(isCanonicalUuid(undefined as unknown as string)).toBe(false);
    expect(isCanonicalUuid(12345 as unknown as string)).toBe(false);
  });
});

describe('assertMoney', () => {
  describe('currency validation', () => {
    it('accepts valid 3-letter uppercase ISO currency codes', () => {
      expect(() => assertMoney('10.00', 'USD')).not.toThrow();
      expect(() => assertMoney('10.00', 'EUR')).not.toThrow();
      expect(() => assertMoney('10.00', 'GBP')).not.toThrow();
      expect(() => assertMoney('10.00', 'JPY')).not.toThrow();
    });

    it('rejects invalid currency codes with RangeError', () => {
      expect(() => assertMoney('10.00', 'usd')).toThrow(RangeError);
      expect(() => assertMoney('10.00', 'Usd')).toThrow(RangeError);
      expect(() => assertMoney('10.00', 'US')).toThrow(RangeError);
      expect(() => assertMoney('10.00', 'USDT')).toThrow(RangeError);
      expect(() => assertMoney('10.00', 'U$D')).toThrow(RangeError);
      expect(() => assertMoney('10.00', '')).toThrow(RangeError);
      expect(() => assertMoney('10.00', ' USD')).toThrow(RangeError);
      expect(() => assertMoney('10.00', null as unknown as string)).toThrow(RangeError);
    });
  });

  describe('amount canonical representation', () => {
    it('accepts canonical integer and decimal representations', () => {
      expect(() => assertMoney('0', 'USD')).not.toThrow();
      expect(() => assertMoney('1', 'USD')).not.toThrow();
      expect(() => assertMoney('100', 'USD')).not.toThrow();
      expect(() => assertMoney('0.0', 'USD')).not.toThrow();
      expect(() => assertMoney('0.50', 'USD')).not.toThrow();
      expect(() => assertMoney('123.456', 'USD')).not.toThrow();
    });

    it('accepts boundary scale of exactly 6 decimal places', () => {
      expect(() => assertMoney('0.123456', 'USD')).not.toThrow();
      expect(() => assertMoney('0.000001', 'USD')).not.toThrow();
      expect(() => assertMoney('0.000000', 'USD')).not.toThrow();
      expect(() => assertMoney('100.999999', 'USD')).not.toThrow();
    });

    it('rejects scale exceeding 6 decimal places with RangeError', () => {
      expect(() => assertMoney('0.1234567', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('1.0000001', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('10.0000000', 'USD')).toThrow(RangeError);
    });

    it('accepts boundary precision of exactly 18 total digits', () => {
      // 18 integer digits
      expect(() => assertMoney('999999999999999999', 'USD')).not.toThrow();
      // 12 integer digits + 6 scale digits = 18 digits
      expect(() => assertMoney('999999999999.123456', 'USD')).not.toThrow();
      // 16 integer digits + 2 scale digits = 18 digits
      expect(() => assertMoney('1234567890123456.78', 'USD')).not.toThrow();
      // 1 integer digit + 6 scale digits = 7 digits (<= 18)
      expect(() => assertMoney('0.123456', 'USD')).not.toThrow();
    });

    it('rejects precision exceeding 18 total digits with RangeError', () => {
      // 19 integer digits
      expect(() => assertMoney('1000000000000000000', 'USD')).toThrow(RangeError);
      // 13 integer digits + 6 scale digits = 19 digits
      expect(() => assertMoney('1234567890123.123456', 'USD')).toThrow(RangeError);
      // 18 integer digits + 1 scale digit = 19 digits
      expect(() => assertMoney('999999999999999999.9', 'USD')).toThrow(RangeError);
    });

    it('rejects scientific exponent notation with RangeError', () => {
      expect(() => assertMoney('1e5', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('1.5e3', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('1E6', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('2.0E-4', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('1e-6', 'USD')).toThrow(RangeError);
    });

    it('rejects leading zeros on integer amounts with RangeError', () => {
      expect(() => assertMoney('01', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('007', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('00', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('00.5', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('01.50', 'USD')).toThrow(RangeError);
    });

    it('rejects malformed numbers and non-canonical formats with RangeError', () => {
      expect(() => assertMoney('', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('.5', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('10.', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('+10.00', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('10,000.00', 'USD')).toThrow(RangeError);
      expect(() => assertMoney(' 10.00', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('10.00 ', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('abc', 'USD')).toThrow(RangeError);
      expect(() => assertMoney(null as unknown as string, 'USD')).toThrow(RangeError);
    });
  });

  describe('negative amount handling', () => {
    it('allows negative amounts only when allowNegative is true', () => {
      expect(() => assertMoney('-10.50', 'USD', true)).not.toThrow();
      expect(() => assertMoney('-999999999999.123456', 'USD', true)).not.toThrow();
      expect(() => assertMoney('-1', 'USD', true)).not.toThrow();
    });

    it('rejects negative amounts when allowNegative is false or omitted', () => {
      expect(() => assertMoney('-10.50', 'USD')).toThrow(RangeError);
      expect(() => assertMoney('-10.50', 'USD', false)).toThrow(RangeError);
      expect(() => assertMoney('-1', 'USD')).toThrow(RangeError);
    });

    it('rejects negative zero under all conditions', () => {
      expect(() => assertMoney('-0', 'USD', true)).toThrow(RangeError);
      expect(() => assertMoney('-0.0', 'USD', true)).toThrow(RangeError);
      expect(() => assertMoney('-0.000000', 'USD', true)).toThrow(RangeError);
      expect(() => assertMoney('-0', 'USD', false)).toThrow(RangeError);
    });

    it('rejects negative amounts with leading zeros even if allowNegative is true', () => {
      expect(() => assertMoney('-05.00', 'USD', true)).toThrow(RangeError);
      expect(() => assertMoney('-00.5', 'USD', true)).toThrow(RangeError);
    });
  });
});

describe('normalizePagination', () => {
  it('defaults pageSize 0 to 20', () => {
    expect(normalizePagination(0, '')).toEqual({ pageSize: 20, pageToken: '' });
    expect(normalizePagination(0, 'cursor_token')).toEqual({
      pageSize: 20,
      pageToken: 'cursor_token',
    });
  });

  it('accepts explicit pageSize within 1..100', () => {
    expect(normalizePagination(1, 'tok')).toEqual({ pageSize: 1, pageToken: 'tok' });
    expect(normalizePagination(50, 'tok')).toEqual({ pageSize: 50, pageToken: 'tok' });
    expect(normalizePagination(100, 'tok')).toEqual({ pageSize: 100, pageToken: 'tok' });
  });

  it('rejects pageSize out-of-bounds with RangeError', () => {
    expect(() => normalizePagination(-1, '')).toThrow(RangeError);
    expect(() => normalizePagination(-50, '')).toThrow(RangeError);
    expect(() => normalizePagination(101, '')).toThrow(RangeError);
    expect(() => normalizePagination(500, '')).toThrow(RangeError);
  });

  it('rejects non-integer and non-numeric pageSize with RangeError', () => {
    expect(() => normalizePagination(1.5, '')).toThrow(RangeError);
    expect(() => normalizePagination(20.9, '')).toThrow(RangeError);
    expect(() => normalizePagination(NaN, '')).toThrow(RangeError);
    expect(() => normalizePagination(Infinity, '')).toThrow(RangeError);
    expect(() => normalizePagination(-Infinity, '')).toThrow(RangeError);
  });

  it('accepts pageToken up to 512 characters', () => {
    const token512 = 'a'.repeat(512);
    expect(normalizePagination(20, token512)).toEqual({
      pageSize: 20,
      pageToken: token512,
    });
  });

  it('rejects pageToken exceeding 512 characters with RangeError', () => {
    const token513 = 'a'.repeat(513);
    expect(() => normalizePagination(20, token513)).toThrow(RangeError);
  });

  it('rejects pageToken containing spaces or control characters with RangeError', () => {
    expect(() => normalizePagination(20, 'token with space')).toThrow(RangeError);
    expect(() => normalizePagination(20, ' token')).toThrow(RangeError);
    expect(() => normalizePagination(20, 'token ')).toThrow(RangeError);
    expect(() => normalizePagination(20, 'token\t1')).toThrow(RangeError);
    expect(() => normalizePagination(20, 'token\n1')).toThrow(RangeError);
    expect(() => normalizePagination(20, 'token\r1')).toThrow(RangeError);
    expect(() => normalizePagination(20, 'token\x001')).toThrow(RangeError);
    expect(() => normalizePagination(20, 'token\x1f1')).toThrow(RangeError);
    expect(() => normalizePagination(20, 'token\x7f1')).toThrow(RangeError);
  });

  it('rejects non-string pageToken with RangeError', () => {
    expect(() => normalizePagination(20, null as unknown as string)).toThrow(RangeError);
    expect(() => normalizePagination(20, undefined as unknown as string)).toThrow(RangeError);
  });
});

describe('validateIdempotencyKey', () => {
  it('accepts valid ASCII printable idempotency keys', () => {
    expect(() => validateIdempotencyKey('order-create-2026-10-31')).not.toThrow();
    expect(() => validateIdempotencyKey('a')).not.toThrow();
    expect(() => validateIdempotencyKey('x'.repeat(255))).not.toThrow();
    expect(() => validateIdempotencyKey('req_123:ABC/def-456.xyz')).not.toThrow();
    expect(() => validateIdempotencyKey('printable symbols ~!@#$%^&*()_+-=[]{}|;:?')).not.toThrow();
  });

  it('rejects empty and out-of-bounds idempotency keys with RangeError', () => {
    expect(() => validateIdempotencyKey('')).toThrow(RangeError);
    expect(() => validateIdempotencyKey('x'.repeat(256))).toThrow(RangeError);
    expect(() => validateIdempotencyKey(null as unknown as string)).toThrow(RangeError);
  });

  it('rejects unprintable control characters with RangeError', () => {
    expect(() => validateIdempotencyKey('key\x00null')).toThrow(RangeError);
    expect(() => validateIdempotencyKey('key\ttab')).toThrow(RangeError);
    expect(() => validateIdempotencyKey('key\nnewline')).toThrow(RangeError);
    expect(() => validateIdempotencyKey('key\rcarriage')).toThrow(RangeError);
    expect(() => validateIdempotencyKey('key\x1bescape')).toThrow(RangeError);
    expect(() => validateIdempotencyKey('key\x1funitsep')).toThrow(RangeError);
    expect(() => validateIdempotencyKey('key\x7fdelete')).toThrow(RangeError);
  });

  it('rejects non-ASCII and Unicode characters with RangeError', () => {
    expect(() => validateIdempotencyKey('idemp-🚀')).toThrow(RangeError);
    expect(() => validateIdempotencyKey('clé-123')).toThrow(RangeError);
    expect(() => validateIdempotencyKey('schlüssel-ä')).toThrow(RangeError);
    expect(() => validateIdempotencyKey('注文キー-123')).toThrow(RangeError);
    expect(() => validateIdempotencyKey('ключ-123')).toThrow(RangeError);
    expect(() => validateIdempotencyKey('key\u200B123')).toThrow(RangeError); // zero-width space
  });
});

describe('validateReason', () => {
  it('passes when reason is undefined', () => {
    expect(() => validateReason(undefined)).not.toThrow();
  });

  it('accepts valid audit reasons between 1 and 2000 characters with full Unicode', () => {
    expect(() => validateReason('Supervisor manual override per policy §4.2')).not.toThrow();
    expect(() => validateReason('a')).not.toThrow();
    expect(() => validateReason('x'.repeat(2000))).not.toThrow();
    expect(() => validateReason('Refund approved for René 🚀 in Tokyo: 返金完了')).not.toThrow();
  });

  it('rejects empty string when reason is supplied with RangeError', () => {
    expect(() => validateReason('')).toThrow(RangeError);
  });

  it('rejects reason exceeding 2000 characters with RangeError', () => {
    expect(() => validateReason('x'.repeat(2001))).toThrow(RangeError);
  });

  it('rejects non-string input when supplied with RangeError', () => {
    expect(() => validateReason(12345 as unknown as string)).toThrow(RangeError);
    expect(() => validateReason(null as unknown as string)).toThrow(RangeError);
  });

  it('rejects malformed Unicode containing lone surrogates with RangeError', () => {
    expect(() => validateReason('bad high surrogate: \uD800')).toThrow(RangeError);
    expect(() => validateReason('bad low surrogate: \uDC00')).toThrow(RangeError);
    expect(() => validateReason('reversed surrogates: \uDC00\uD800')).toThrow(RangeError);
  });
});

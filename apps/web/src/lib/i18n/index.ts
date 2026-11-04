/**
 * P8-08 Internationalization (i18n) & Localization Engine (docs/06_quality_ops/i18n_guide.md).
 * Primary language: Vietnamese (`vi`, Launch Tier 1).
 * Secondary language: English (`en`, Launch Tier 1).
 * Enforces `{module}_{screen}_{element}_{variant}` key convention, 100% key parity,
 * parameter interpolation, and region-aware VND/USD/date/number formatting.
 */
import viMessages from '../../../messages/vi.json';
import enMessages from '../../../messages/en.json';

export type SupportedLocale = 'vi' | 'en';
export type TranslationKey = keyof typeof viMessages;

const CATALOGS: Record<SupportedLocale, Record<string, string>> = {
  vi: viMessages,
  en: enMessages
};

const KEY_CONVENTION_REGEX = /^[a-z0-9]+_[a-z0-9]+_[a-z0-9]+(?:_[a-z0-9]+)+$/;

/**
 * Translates a key for the given locale with optional `{param}` interpolation.
 * Falls back to Vietnamese (`vi`) primary catalog if a key is missing in secondary locale.
 */
export function t(
  key: TranslationKey | string,
  locale: SupportedLocale = 'vi',
  params?: Record<string, string | number>
): string {
  const catalog = CATALOGS[locale] ?? CATALOGS.vi;
  let template = catalog[key] ?? CATALOGS.vi[key] ?? key;
  if (params) {
    for (const [k, v] of Object.entries(params)) {
      template = template.replaceAll(`{${k}}`, String(v));
    }
  }
  return template;
}

/**
 * Verifies 100% translation key parity between `vi.json` and `en.json`
 * and checks that every key matches `{module}_{screen}_{element}_{variant}`.
 */
export function verifyTranslationCatalogParity(): {
  valid: boolean;
  viCount: number;
  enCount: number;
  missingInEn: string[];
  missingInVi: string[];
  invalidKeyNames: string[];
} {
  const viKeys = Object.keys(viMessages);
  const enKeys = Object.keys(enMessages);
  const viSet = new Set(viKeys);
  const enSet = new Set(enKeys);

  const missingInEn = viKeys.filter((k) => !enSet.has(k));
  const missingInVi = enKeys.filter((k) => !viSet.has(k));
  const invalidKeyNames = [...new Set([...viKeys, ...enKeys])].filter(
    (k) => !KEY_CONVENTION_REGEX.test(k) || !String(viMessages[k as TranslationKey] ?? '').trim() || !String(enMessages[k as TranslationKey] ?? '').trim()
  );

  return {
    valid: missingInEn.length === 0 && missingInVi.length === 0 && invalidKeyNames.length === 0,
    viCount: viKeys.length,
    enCount: enKeys.length,
    missingInEn,
    missingInVi,
    invalidKeyNames
  };
}

/**
 * Formats integer currency amounts according to `docs/06_quality_ops/i18n_guide.md` §4:
 * - VND: zero decimal places, dot thousands separator, suffix `đ` (`1.234.567đ`)
 * - USD: integer cents or whole dollars formatted with `$` prefix (`$1,234.56` or `$1,234,567`)
 */
export function formatLocalizedCurrency(
  amount: number,
  currency: 'VND' | 'USD',
  options?: { isCents?: boolean }
): string {
  if (currency === 'VND') {
    const rounded = Math.round(amount);
    const sign = rounded < 0 ? '-' : '';
    const absStr = Math.abs(rounded)
      .toString()
      .replace(/\B(?=(\d{3})+(?!\d))/g, '.');
    return `${sign}${absStr}đ`;
  }

  const value = options?.isCents ? amount / 100 : amount;
  const hasFraction = options?.isCents || !Number.isInteger(value);
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: hasFraction ? 2 : 0,
    maximumFractionDigits: hasFraction ? 2 : 0
  }).format(value);
}

/**
 * Formats a date in `DD/MM/YYYY` for `vi` and `MM/DD/YYYY` for `en` (UTC calendar fields).
 */
export function formatLocalizedDate(isoOrDate: string | Date, locale: SupportedLocale = 'vi'): string {
  const d = typeof isoOrDate === 'string' ? new Date(isoOrDate) : isoOrDate;
  const day = String(d.getUTCDate()).padStart(2, '0');
  const month = String(d.getUTCMonth() + 1).padStart(2, '0');
  const year = String(d.getUTCFullYear());
  return locale === 'vi' ? `${day}/${month}/${year}` : `${month}/${day}/${year}`;
}

/**
 * Formats compact numbers per `i18n_guide.md` §4.1 (`1,2 Tr` in Vietnamese vs `1.2M` in English).
 */
export function formatCompactNumber(value: number, locale: SupportedLocale = 'vi'): string {
  const abs = Math.abs(value);
  if (abs >= 1_000_000_000) {
    const scaled = (value / 1_000_000_000).toFixed(1).replace(/\.0$/, '');
    return locale === 'vi' ? `${scaled.replace('.', ',')} Tỷ` : `${scaled}B`;
  }
  if (abs >= 1_000_000) {
    const scaled = (value / 1_000_000).toFixed(1).replace(/\.0$/, '');
    return locale === 'vi' ? `${scaled.replace('.', ',')} Tr` : `${scaled}M`;
  }
  if (abs >= 1_000) {
    const scaled = (value / 1_000).toFixed(1).replace(/\.0$/, '');
    return locale === 'vi' ? `${scaled.replace('.', ',')} N` : `${scaled}K`;
  }
  return String(value);
}

/**
 * P8-08 Full-Surface Accessibility (WCAG 2.1 AA) & Legal/Security Verification Helpers
 * Canonical references:
 *   - docs/06_quality_ops/accessibility_spec.md
 *   - docs/01_business/legal_compliance.md
 *   - docs/06_quality_ops/security_threat_model.md
 */
import type { SupportedLocale } from '../i18n';

export interface ContrastResult {
  ratio: number;
  passesNormalTextAA: boolean; // >= 4.5:1
  passesLargeTextOrUIComponentAA: boolean; // >= 3.0:1
  passesAAA: boolean; // >= 7.0:1
}

function parseHexChannel(hex: string, start: number): number {
  const v = parseInt(hex.slice(start, start + 2), 16) / 255;
  return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4);
}

export function relativeLuminance(hexColor: string): number {
  const clean = hexColor.trim().replace(/^#/, '');
  const full =
    clean.length === 3
      ? clean
          .split('')
          .map((c) => c + c)
          .join('')
      : clean;
  if (full.length !== 6) {
    throw new Error(`Invalid hex color: ${hexColor}`);
  }
  const r = parseHexChannel(full, 0);
  const g = parseHexChannel(full, 2);
  const b = parseHexChannel(full, 4);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/**
 * Computes WCAG 2.1 contrast ratio between two hex colors (`#RRGGBB`).
 */
export function evaluateColorContrast(foregroundHex: string, backgroundHex: string): ContrastResult {
  const l1 = relativeLuminance(foregroundHex);
  const l2 = relativeLuminance(backgroundHex);
  const lighter = Math.max(l1, l2);
  const darker = Math.min(l1, l2);
  const ratio = Number(((lighter + 0.05) / (darker + 0.05)).toFixed(2));
  return {
    ratio,
    passesNormalTextAA: ratio >= 4.5,
    passesLargeTextOrUIComponentAA: ratio >= 3.0,
    passesAAA: ratio >= 7.0
  };
}

export type SemanticStatusKind = 'success' | 'warning' | 'error' | 'info' | 'locked';

export interface AccessibleStatusBadge {
  kind: SemanticStatusKind;
  iconSymbol: string;
  label: string;
  ariaLive: 'polite' | 'assertive';
  role: 'status' | 'alert';
  nonColorDifferentiated: true;
}

/**
 * Enforces `accessibility_spec.md` §1.2 ("Never Rely on Color Alone"):
 * Every status indicator combines color with a distinct icon symbol, visible text label,
 * and semantic ARIA role/live region.
 */
export function buildAccessibleStatusBadge(
  kind: SemanticStatusKind,
  locale: SupportedLocale = 'vi'
): AccessibleStatusBadge {
  const labels: Record<SemanticStatusKind, { vi: string; en: string; icon: string }> = {
    success: { vi: 'Thành công', en: 'Success', icon: '✓' },
    warning: { vi: 'Cảnh báo', en: 'Warning', icon: '⚠' },
    error: { vi: 'Lỗi cần xử lý', en: 'Action required error', icon: '✕' },
    info: { vi: 'Thông tin', en: 'Information', icon: 'ℹ' },
    locked: { vi: 'Đã khóa chỉ đọc', en: 'Read-only locked', icon: '🔒' }
  };
  const entry = labels[kind];
  const isUrgent = kind === 'error' || kind === 'locked';
  return {
    kind,
    iconSymbol: entry.icon,
    label: locale === 'vi' ? entry.vi : entry.en,
    ariaLive: isUrgent ? 'assertive' : 'polite',
    role: isUrgent ? 'alert' : 'status',
    nonColorDifferentiated: true
  };
}

export interface FocusTrapState {
  isOpen: boolean;
  focusableIds: string[];
  activeFocusId: string;
  returnFocusToId: string;
}

/**
 * Deterministic keyboard focus trap state machine for modal dialogs & drawers
 * (`accessibility_spec.md` §2.3: Tab cycles forward, Shift+Tab cycles backward,
 * Escape closes and restores focus to the trigger element).
 */
export function stepDialogFocusTrap(
  state: FocusTrapState,
  key: 'Tab' | 'Shift+Tab' | 'Escape'
): FocusTrapState {
  if (!state.isOpen || state.focusableIds.length === 0) {
    return state;
  }
  if (key === 'Escape') {
    return {
      ...state,
      isOpen: false,
      activeFocusId: state.returnFocusToId
    };
  }
  const currentIdx = Math.max(0, state.focusableIds.indexOf(state.activeFocusId));
  if (key === 'Tab') {
    const nextIdx = (currentIdx + 1) % state.focusableIds.length;
    return {
      ...state,
      activeFocusId: state.focusableIds[nextIdx]
    };
  }
  const prevIdx = (currentIdx - 1 + state.focusableIds.length) % state.focusableIds.length;
  return {
    ...state,
    activeFocusId: state.focusableIds[prevIdx]
  };
}

export interface LegalComplianceLink {
  id: string;
  href: string;
  labelVi: string;
  labelEn: string;
}

/**
 * Returns the 6 required legal compliance documents from `legal_compliance.md` §1 & §8.1.
 */
export const CANONICAL_LEGAL_LINKS: readonly LegalComplianceLink[] = [
  { id: 'tos', href: '/legal/terms', labelVi: 'Điều khoản dịch vụ', labelEn: 'Terms of Service' },
  {
    id: 'privacy',
    href: '/legal/privacy',
    labelVi: 'Chính sách bảo mật (NĐ 13/2023 & GDPR)',
    labelEn: 'Privacy Policy (VN PDPA & GDPR)'
  },
  { id: 'cookies', href: '/legal/cookies', labelVi: 'Chính sách Cookie', labelEn: 'Cookie Policy' },
  { id: 'aup', href: '/legal/aup', labelVi: 'Chính sách sử dụng hợp lệ', labelEn: 'Acceptable Use Policy' },
  { id: 'dmca', href: '/legal/dmca', labelVi: 'Bản quyền & DMCA', labelEn: 'Copyright & DMCA' },
  {
    id: 'ai-disclaimer',
    href: '/legal/ai-disclaimer',
    labelVi: 'Tuyên bố minh bạch AI',
    labelEn: 'AI Transparency Disclaimer'
  }
] as const;

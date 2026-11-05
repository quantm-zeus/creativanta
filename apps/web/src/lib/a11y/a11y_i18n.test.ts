import { describe, expect, it } from 'vitest';
import {
  formatCompactNumber,
  formatLocalizedCurrency,
  formatLocalizedDate,
  t,
  verifyTranslationCatalogParity
} from '../i18n';
import {
  activateModalFocusSession,
  buildAccessibleStatusBadge,
  CANONICAL_LEGAL_LINKS,
  evaluateColorContrast,
  getFocusableElements,
  handleModalKeydown,
  stepDialogFocusTrap
} from './index';

describe('P8-08 Web Full-Surface i18n, WCAG 2.1 AA Accessibility & Legal Compliance', () => {
  it('enforces 100% key parity between vi.json and en.json and {module}_{screen}_{element}_{variant} convention', () => {
    const parity = verifyTranslationCatalogParity();
    expect(parity.valid).toBe(true);
    expect(parity.missingInEn).toEqual([]);
    expect(parity.missingInVi).toEqual([]);
    expect(parity.invalidKeyNames).toEqual([]);
    expect(parity.viCount).toBeGreaterThanOrEqual(20);
  });

  it('interpolates parameters and formats Vietnamese & English currency, dates, and compact numbers accurately', () => {
    expect(
      t('production_studio_credits_insufficient', 'vi', { required: 150, available: 40 })
    ).toBe('Không đủ tín dụng AI (cần 150, còn 40)');
    expect(
      t('production_studio_credits_insufficient', 'en', { required: 150, available: 40 })
    ).toBe('Insufficient AI credits (requires 150, available 40)');

    // VND: zero decimals, dot separator, đ suffix
    expect(formatLocalizedCurrency(1234567, 'VND')).toBe('1.234.567đ');
    // USD: comma separator, $ prefix
    expect(formatLocalizedCurrency(1234567, 'USD')).toBe('$1,234,567');
    expect(formatLocalizedCurrency(123456, 'USD', { isCents: true })).toBe('$1,234.56');

    // Dates: DD/MM/YYYY for vi, MM/DD/YYYY for en
    expect(formatLocalizedDate('2026-03-26T00:00:00Z', 'vi')).toBe('26/03/2026');
    expect(formatLocalizedDate('2026-03-26T00:00:00Z', 'en')).toBe('03/26/2026');

    // Compact numbers
    expect(formatCompactNumber(1200000, 'vi')).toBe('1,2 Tr');
    expect(formatCompactNumber(1200000, 'en')).toBe('1.2M');
  });

  it('verifies WCAG 2.1 AA color contrast ratios for Creativanta Dark UI palette and rejects low-contrast pairs', () => {
    // Primary text #FAFAFA on #09090B (~19.3:1)
    const primary = evaluateColorContrast('#FAFAFA', '#09090B');
    expect(primary.passesNormalTextAA).toBe(true);
    expect(primary.passesAAA).toBe(true);
    expect(primary.ratio).toBeGreaterThan(18);

    // Secondary text #A1A1AA on #09090B (~7.4:1)
    const secondary = evaluateColorContrast('#A1A1AA', '#09090B');
    expect(secondary.passesNormalTextAA).toBe(true);
    expect(secondary.passesAAA).toBe(true);

    // Semantic Success #10B981 on #09090B (~8.1:1 AA & AAA)
    const successBadge = evaluateColorContrast('#10B981', '#09090B');
    expect(successBadge.passesNormalTextAA).toBe(true);
    expect(successBadge.passesAAA).toBe(true);

    // Muted UI component/large text #71717A on #09090B (>= 3.0:1 UI Component / Large Text AA)
    const muted = evaluateColorContrast('#71717A', '#09090B');
    expect(muted.passesLargeTextOrUIComponentAA).toBe(true);

    // Low contrast pair (#3F3F46 on #18181B) fails normal text AA
    const lowContrast = evaluateColorContrast('#3F3F46', '#18181B');
    expect(lowContrast.passesNormalTextAA).toBe(false);
  });

  it('enforces non-color status badges and modal keyboard focus trap with Escape focus restoration', () => {
    const errBadge = buildAccessibleStatusBadge('error', 'vi');
    expect(errBadge.nonColorDifferentiated).toBe(true);
    expect(errBadge.iconSymbol).toBe('✕');
    expect(errBadge.ariaLive).toBe('assertive');
    expect(errBadge.role).toBe('alert');

    let trap = {
      isOpen: true,
      focusableIds: ['dialog-close', 'dialog-input', 'dialog-confirm'],
      activeFocusId: 'dialog-close',
      returnFocusToId: 'open-modal-trigger'
    };
    trap = stepDialogFocusTrap(trap, 'Tab');
    expect(trap.activeFocusId).toBe('dialog-input');
    trap = stepDialogFocusTrap(trap, 'Tab');
    expect(trap.activeFocusId).toBe('dialog-confirm');
    // Wrap around from last to first
    trap = stepDialogFocusTrap(trap, 'Tab');
    expect(trap.activeFocusId).toBe('dialog-close');
    // Shift+Tab wraps backward from first to last
    trap = stepDialogFocusTrap(trap, 'Shift+Tab');
    expect(trap.activeFocusId).toBe('dialog-confirm');
    // Escape closes dialog and restores focus to trigger
    trap = stepDialogFocusTrap(trap, 'Escape');
    expect(trap.isOpen).toBe(false);
    expect(trap.activeFocusId).toBe('open-modal-trigger');
  });

  it('exposes all 6 canonical legal compliance links (ToS, Privacy/PDPA, Cookie, AUP, DMCA, AI Disclaimer)', () => {
    expect(CANONICAL_LEGAL_LINKS).toHaveLength(6);
    expect(CANONICAL_LEGAL_LINKS.map((l) => l.id)).toEqual([
      'tos',
      'privacy',
      'cookies',
      'aup',
      'dmca',
      'ai-disclaimer'
    ]);
  });

  it('UF-12 traps Tab/Shift+Tab inside modal container and restores focus on close', () => {
    const firstBtn = {
      focus: () => {
        activeEl = firstBtn;
      },
      hasAttribute: () => false,
      getAttribute: () => null
    } as unknown as HTMLElement;
    const lastBtn = {
      focus: () => {
        activeEl = lastBtn;
      },
      hasAttribute: () => false,
      getAttribute: () => null
    } as unknown as HTMLElement;
    const triggerBtn = {
      focus: () => {
        activeEl = triggerBtn;
      }
    } as unknown as HTMLElement;

    let activeEl: HTMLElement | null = triggerBtn;
    const container = {
      querySelectorAll: () => [firstBtn, lastBtn],
      contains: (node: Node | null) => node === (firstBtn as unknown as Node) || node === (lastBtn as unknown as Node),
      focus: () => {
        activeEl = container;
      }
    } as unknown as HTMLElement;

    const origDocument = globalThis.document;
    Object.defineProperty(globalThis, 'document', {
      configurable: true,
      value: {
        get activeElement() {
          return activeEl;
        },
        querySelectorAll: () => []
      }
    });

    try {
      expect(getFocusableElements(container)).toHaveLength(2);
      const cleanup = activateModalFocusSession(container, triggerBtn);
      expect(activeEl).toBe(firstBtn);

      // Tab on last element wraps to first element
      activeEl = lastBtn;
      let prevented = false;
      handleModalKeydown(
        {
          key: 'Tab',
          shiftKey: false,
          preventDefault: () => {
            prevented = true;
          }
        } as unknown as KeyboardEvent,
        container,
        () => {}
      );
      expect(prevented).toBe(true);
      expect(activeEl).toBe(firstBtn);

      // Shift+Tab on first element wraps to last element
      let shiftPrevented = false;
      handleModalKeydown(
        {
          key: 'Tab',
          shiftKey: true,
          preventDefault: () => {
            shiftPrevented = true;
          }
        } as unknown as KeyboardEvent,
        container,
        () => {}
      );
      expect(shiftPrevented).toBe(true);
      expect(activeEl).toBe(lastBtn);

      // Cleanup restores focus to triggerBtn
      cleanup();
      expect(activeEl).toBe(triggerBtn);
    } finally {
      Object.defineProperty(globalThis, 'document', {
        configurable: true,
        value: origDocument
      });
    }
  });
});

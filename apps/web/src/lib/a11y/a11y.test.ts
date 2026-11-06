import { describe, expect, it, vi } from 'vitest';
import {
  activateModalFocusSession,
  handleModalKeydown,
  CANONICAL_LEGAL_LINKS,
  getLegalDocumentBySlug
} from './index';
import { load as loadLegalPage } from '../../routes/legal/[slug]/+page';
import whyThisNumberModalSource from '../components/WhyThisNumberModal.svelte?raw';

class FakeHTMLElement {
  id: string;
  tagName: string;
  attributes = new Map<string, string>();
  children: FakeHTMLElement[] = [];
  onFocus?: (el: FakeHTMLElement) => void;

  constructor(tagName: string, id: string, onFocus?: (el: FakeHTMLElement) => void) {
    this.tagName = tagName.toUpperCase();
    this.id = id;
    this.onFocus = onFocus;
  }

  getAttribute(name: string): string | null {
    return this.attributes.has(name) ? (this.attributes.get(name) ?? null) : null;
  }

  setAttribute(name: string, value: string): void {
    this.attributes.set(name, value);
  }

  removeAttribute(name: string): void {
    this.attributes.delete(name);
  }

  hasAttribute(name: string): boolean {
    return this.attributes.has(name);
  }

  contains(other: FakeHTMLElement | null): boolean {
    if (!other) return false;
    if (other === this) return true;
    return this.children.some((c) => c.contains(other));
  }

  querySelectorAll(): FakeHTMLElement[] {
    return this.children;
  }

  focus(): void {
    this.onFocus?.(this);
  }
}

describe('R7 Accessibility & Legal Compliance (Findings 9 & 10)', () => {
  it('traps Tab and Shift+Tab inside modal dialog, marks background landmarks inert/aria-hidden, and restores focus on close', () => {
    const origDocument = (globalThis as any).document;
    const origHTMLElement = (globalThis as any).HTMLElement;

    let currentActive: FakeHTMLElement | null = null;
    const setActive = (el: FakeHTMLElement) => {
      currentActive = el;
    };

    const triggerBtn = new FakeHTMLElement('button', 'trigger-btn', setActive);
    const header = new FakeHTMLElement('header', 'app-header', setActive);
    header.children = [triggerBtn];
    const main = new FakeHTMLElement('main', 'app-main', setActive);
    const footer = new FakeHTMLElement('footer', 'app-footer', setActive);

    const firstBtn = new FakeHTMLElement('button', 'modal-close-top', setActive);
    const lastBtn = new FakeHTMLElement('button', 'modal-close-bottom', setActive);
    const dialog = new FakeHTMLElement('div', 'why-modal', setActive);
    dialog.children = [firstBtn, lastBtn];

    try {
      (globalThis as any).HTMLElement = FakeHTMLElement;
      (globalThis as any).document = {
        get activeElement() {
          return currentActive;
        },
        querySelectorAll: () => [header, main, footer]
      };

      triggerBtn.focus();
      expect(currentActive).toBe(triggerBtn);

      const cleanup = activateModalFocusSession(dialog as unknown as HTMLElement);

      // Focus moved to first focusable control inside dialog
      expect(currentActive).toBe(firstBtn);
      // Background landmarks are marked aria-hidden="true" and inert
      expect(header.getAttribute('aria-hidden')).toBe('true');
      expect(main.getAttribute('aria-hidden')).toBe('true');
      expect(footer.getAttribute('aria-hidden')).toBe('true');
      expect(header.hasAttribute('inert')).toBe(true);
      expect(main.hasAttribute('inert')).toBe(true);
      expect(footer.hasAttribute('inert')).toBe(true);

      // Shift+Tab from first button wraps to last button
      let shiftTabPrevented = false;
      const shiftTabEvent = {
        key: 'Tab',
        shiftKey: true,
        preventDefault: () => {
          shiftTabPrevented = true;
        }
      } as unknown as KeyboardEvent;
      const onClose = vi.fn();
      handleModalKeydown(shiftTabEvent, dialog as unknown as HTMLElement, onClose);
      expect(shiftTabPrevented).toBe(true);
      expect(currentActive).toBe(lastBtn);

      // Tab from last button wraps to first button
      let tabPrevented = false;
      const tabEvent = {
        key: 'Tab',
        shiftKey: false,
        preventDefault: () => {
          tabPrevented = true;
        }
      } as unknown as KeyboardEvent;
      handleModalKeydown(tabEvent, dialog as unknown as HTMLElement, onClose);
      expect(tabPrevented).toBe(true);
      expect(currentActive).toBe(firstBtn);

      // Escape invokes close callback and cleanup restores focus to trigger button
      let escPrevented = false;
      const escEvent = {
        key: 'Escape',
        shiftKey: false,
        preventDefault: () => {
          escPrevented = true;
        }
      } as unknown as KeyboardEvent;
      handleModalKeydown(escEvent, dialog as unknown as HTMLElement, () => {
        cleanup();
        onClose();
      });
      expect(escPrevented).toBe(true);
      expect(onClose).toHaveBeenCalledTimes(1);
      expect(currentActive).toBe(triggerBtn);
      expect(header.getAttribute('aria-hidden')).toBeNull();
      expect(main.getAttribute('aria-hidden')).toBeNull();
      expect(footer.getAttribute('aria-hidden')).toBeNull();
      expect(header.hasAttribute('inert')).toBe(false);
    } finally {
      (globalThis as any).document = origDocument;
      (globalThis as any).HTMLElement = origHTMLElement;
    }

    // Verify WhyThisNumberModal.svelte wires activateModalFocusSession & handleModalKeydown
    expect(whyThisNumberModalSource).toContain('activateModalFocusSession');
    expect(whyThisNumberModalSource).toContain('handleModalKeydown');
    expect(whyThisNumberModalSource).toContain('bind:this={dialogElement}');
  });

  it('loads all 6 canonical legal routes via +page.ts and throws 404 for unknown slugs', () => {
    for (const link of CANONICAL_LEGAL_LINKS) {
      const slug = link.href.replace('/legal/', '');
      const result = loadLegalPage({ params: { slug } } as any) as { document: any };
      expect(result.document).toBeDefined();
      expect(result.document.slug).toBe(slug);
      expect(result.document.href).toBe(link.href);
      expect(result.document.blockerRef).toBe('LEG-H-001');
      expect(getLegalDocumentBySlug(slug)?.id).toBe(result.document.id);
    }

    expect(() => loadLegalPage({ params: { slug: 'unknown-slug' } } as any)).toThrow();
  });
});

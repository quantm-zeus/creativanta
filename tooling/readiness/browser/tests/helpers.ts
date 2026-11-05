import { expect, type Page } from '@playwright/test';

export const WEB_PORT = process.env.BROWSER_QA_WEB_PORT || '41731';
export const ADMIN_PORT = process.env.BROWSER_QA_ADMIN_PORT || '41732';

export const WEB_BASE_URL = `http://127.0.0.1:${WEB_PORT}`;
export const ADMIN_BASE_URL = `http://127.0.0.1:${ADMIN_PORT}`;

/**
 * Checks that the page has zero horizontal overflow across responsive viewports.
 * Returns true if documentElement scrollWidth <= clientWidth + 1px tolerance.
 */
export async function assertNoHorizontalOverflow(page: Page, contextLabel: string = ''): Promise<void> {
  const result = await page.evaluate(() => {
    const doc = document.documentElement;
    const body = document.body;
    const scrollWidth = Math.max(doc.scrollWidth, body ? body.scrollWidth : 0);
    const clientWidth = Math.max(doc.clientWidth, body ? body.clientWidth : 0);
    const overflow = scrollWidth - clientWidth;
    return {
      scrollWidth,
      clientWidth,
      hasOverflow: overflow > 1,
      overflowAmount: Math.max(0, overflow)
    };
  });

  expect(
    result.hasOverflow,
    `Horizontal overflow detected on ${contextLabel} (${page.viewportSize()?.width}px): scrollWidth=${result.scrollWidth}, clientWidth=${result.clientWidth}, overflow=${result.overflowAmount}px`
  ).toBe(false);
}

/**
 * Verifies that a prominent semantic heading (h1 or primary header) is visible.
 */
export async function assertHeadingVisible(page: Page): Promise<void> {
  const heading = page.locator('h1').first();
  await expect(heading).toBeVisible();
}

import { test, expect } from '@playwright/test';
import { WEB_BASE_URL, ADMIN_BASE_URL } from './helpers';

test.describe('Accessibility & Keyboard Navigation Smoke (WCAG 2.1 AA)', () => {
  test('web app contains skip-to-content link, landmarks and aria live regions', async ({ page }) => {
    const pageErrors: string[] = [];
    page.on('pageerror', (err) => pageErrors.push(err.message));

    await page.goto(`${WEB_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    // Skip to content link
    const skipLink = page.locator('a[href="#main-content"]');
    await expect(skipLink).toHaveCount(1);
    await expect(skipLink).toHaveText(/Bỏ qua điều hướng|Skip to content/);

    // Landmarks: header, main, footer
    await expect(page.locator('header').first()).toBeVisible();
    await expect(page.locator('main#main-content')).toBeVisible();
    await expect(page.locator('footer').first()).toBeVisible();

    // ARIA live regions
    const politeLive = page.locator('div[role="status"][aria-live="polite"]');
    const assertiveLive = page.locator('div[role="alert"][aria-live="assertive"]');
    await expect(politeLive).toHaveCount(1);
    await expect(assertiveLive).toHaveCount(1);

    // Press Tab from initial page load to verify focus hits the skip link
    await page.keyboard.press('Tab');
    await expect(skipLink).toBeFocused();

    // Zero uncaught runtime errors
    expect(pageErrors, `Uncaught page errors: ${pageErrors.join('; ')}`).toEqual([]);
  });

  test('admin portal contains skip-to-content link and semantic landmarks', async ({ page }) => {
    const pageErrors: string[] = [];
    page.on('pageerror', (err) => pageErrors.push(err.message));

    await page.goto(`${ADMIN_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    // Skip to content link
    const skipLink = page.locator('a[href="#admin-main-content"]');
    await expect(skipLink).toHaveCount(1);

    // Landmarks: header, main
    await expect(page.locator('header').first()).toBeVisible();
    await expect(page.locator('main#admin-main-content')).toBeVisible();

    // Press Tab to verify focus on skip link
    await page.keyboard.press('Tab');
    await expect(skipLink).toBeFocused();

    // Zero uncaught runtime errors
    expect(pageErrors, `Uncaught page errors: ${pageErrors.join('; ')}`).toEqual([]);
  });

  test('interactive controls in header have accessible names', async ({ page }) => {
    await page.goto(`${WEB_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    // Notification bell has accessible label
    const bell = page.locator('header button[aria-label="Mở trung tâm thông báo"]');
    await expect(bell).toBeVisible();

    // Help button has accessible label
    const help = page.locator('header button[aria-label="Mở trung tâm trợ giúp"]');
    await expect(help).toBeVisible();

    // Desktop/Mobile mode selector has accessible label
    const width = page.viewportSize()?.width || 1440;
    if (width >= 640) {
      const modeSelect = page.locator('header select[aria-label="Chọn chế độ vận hành"]');
      await expect(modeSelect).toBeVisible();
    } else {
      const mobileModeSelect = page.locator('header select[aria-label="Chọn chế độ vận hành trên di động"]');
      await expect(mobileModeSelect).toBeVisible();
    }
  });
});

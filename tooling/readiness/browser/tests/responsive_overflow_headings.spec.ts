import { test, expect } from '@playwright/test';
import { WEB_BASE_URL, assertNoHorizontalOverflow } from './helpers';

const KEY_ROUTES = [
  { path: '/', name: 'Home' },
  { path: '/login', name: 'Login' },
  { path: '/workspaces', name: 'Workspaces' },
  { path: '/ideas', name: 'Idea Engine' },
  { path: '/scripts', name: 'Script Lab' },
  { path: '/studio', name: 'AI Video Studio' },
  { path: '/campaigns', name: 'Campaigns' },
  { path: '/store', name: 'Creator Store' },
  { path: '/workflows', name: 'Workflow Studio' },
  { path: '/status', name: 'Public Status' },
  { path: '/support', name: 'Help Center' }
];

test.describe('Responsive Layout, Overflow & Heading Smoke', () => {
  for (const route of KEY_ROUTES) {
    test(`route ${route.path} renders with zero horizontal overflow and visible headings`, async ({ page }) => {
      await page.goto(`${WEB_BASE_URL}${route.path}`);
      await page.waitForLoadState('networkidle');

      // Verify no horizontal overflow at this viewport
      await assertNoHorizontalOverflow(page, route.name);

      // Verify at least one heading is visible
      const heading = page.locator('h1, h2').first();
      await expect(heading).toBeVisible();
    });
  }

  test('navigation adapts responsively between desktop top nav and mobile bottom nav', async ({ page }) => {
    await page.goto(`${WEB_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    const width = page.viewportSize()?.width || 1440;
    const desktopNav = page.locator('nav[aria-label="Điều hướng chính theo công việc"]');
    const mobileNav = page.locator('nav[aria-label="Điều hướng di động"]');

    if (width >= 768) {
      await expect(desktopNav).toBeVisible();
      await expect(mobileNav).toBeHidden();
    } else {
      await expect(desktopNav).toBeHidden();
      await expect(mobileNav).toBeVisible();
    }
  });
});

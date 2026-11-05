import { test, expect } from '@playwright/test';
import { WEB_BASE_URL, assertNoHorizontalOverflow } from './helpers';

test.describe('Auth & Fail-Closed Security Smoke', () => {
  test('unconfigured Clerk IdP displays fail-closed indicator in header', async ({ page }) => {
    await page.goto(`${WEB_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    // Header should show unconfigured Clerk status badge
    const clerkBadge = page.locator('text=Clerk: Chưa cấu hình');
    await expect(clerkBadge).toBeVisible();

    await assertNoHorizontalOverflow(page, 'Home unauthenticated');
  });

  test('/login displays honest unavailable notice and disabled inputs when Clerk is unconfigured', async ({ page }) => {
    await page.goto(`${WEB_BASE_URL}/login`);
    await page.waitForLoadState('networkidle');

    // Brand panel heading is visible
    const brandPanelHeading = page.locator('h2:has-text("Creativanta")').first();
    await expect(brandPanelHeading).toBeVisible();

    // UnavailableNotice for Clerk unconfigured must be visible
    const notice = page.locator('text=Khóa định danh Clerk chưa cấu hình');
    await expect(notice).toBeVisible();

    const requiresBadge = page.locator('text=Yêu cầu: VITE_CLERK_PUBLISHABLE_KEY');
    await expect(requiresBadge).toBeVisible();

    // Form inputs and submit button must be disabled (fail-closed)
    const emailInput = page.locator('input#mock-email');
    await expect(emailInput).toBeDisabled();

    const submitBtn = page.locator('button:has-text("Đăng nhập (Đã vô hiệu hóa)")');
    await expect(submitBtn).toBeDisabled();

    await assertNoHorizontalOverflow(page, 'Login page');
  });

  test('/workspaces renders selection ribbon and keeps unmounted create button disabled', async ({ page }) => {
    await page.goto(`${WEB_BASE_URL}/workspaces`);
    await page.waitForLoadState('networkidle');

    // Title should be visible
    const title = page.locator('h1:has-text("Chọn Workspace")');
    await expect(title).toBeVisible();

    // "+ Tạo mới" button must be disabled with "(Unmounted)" indicator
    const createBtn = page.locator('button:has-text("+ Tạo mới")');
    await expect(createBtn).toBeDisabled();
    await expect(page.locator('text=(Unmounted)')).toBeVisible();

    // Verify 6 operator modes are presented in the ribbon
    await expect(page.locator('text=Chế độ vận hành hiện tại (6 Operator Modes)')).toBeVisible();

    await assertNoHorizontalOverflow(page, 'Workspaces page');
  });

  test('query param auth bypass attempts fail closed', async ({ page }) => {
    // Attempting artificial bypass via query params must not grant session
    await page.goto(`${WEB_BASE_URL}/?mock_admin=true&bypass_auth=1&role=super_admin`);
    await page.waitForLoadState('networkidle');

    // Must still show unconfigured Clerk badge
    await expect(page.locator('text=Clerk: Chưa cấu hình')).toBeVisible();
  });

  test('/login with external or protocol-relative redirectTo stays fail-closed on origin', async ({ page }) => {
    for (const candidate of ['https://evil.example/phish', '//evil.example/path', 'javascript:alert(1)']) {
      await page.goto(`${WEB_BASE_URL}/login?redirectTo=${encodeURIComponent(candidate)}`);
      await page.waitForLoadState('networkidle');

      expect(page.url().startsWith(`${WEB_BASE_URL}/login`)).toBe(true);
      await expect(page.locator('button:has-text("Đăng nhập (Đã vô hiệu hóa)")')).toBeDisabled();
    }
  });
});

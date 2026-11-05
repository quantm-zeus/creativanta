import { test, expect } from '@playwright/test';
import { WEB_BASE_URL, assertNoHorizontalOverflow } from './helpers';

test.describe('Key Screens & Interactive Affordances Smoke', () => {
  test('home onboarding checklist is interactive and updates progress', async ({ page }) => {
    await page.goto(`${WEB_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    // Onboarding progress indicator exists
    const progressIndicator = page.locator('text=bước hoàn tất');
    await expect(progressIndicator).toBeVisible();
    await expect(progressIndicator).toContainText('1/5 bước hoàn tất');

    // Find and click the second onboarding step button
    const stepButtons = page.locator('button:has-text("Bước 2")');
    if (await stepButtons.count() > 0) {
      await stepButtons.first().click();
      await expect(progressIndicator).toContainText('2/5 bước hoàn tất');
      // Toggle back
      await stepButtons.first().click();
      await expect(progressIndicator).toContainText('1/5 bước hoàn tất');
    }
  });

  test('home UI state switcher exercises Normal, Loading, Empty, Error and Repair states', async ({ page }) => {
    await page.goto(`${WEB_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    // State switcher buttons
    const normalBtn = page.locator('button:has-text("1. Chuẩn")');
    const loadingBtn = page.locator('button:has-text("2. Đang tải")');
    const emptyBtn = page.locator('button:has-text("3. Trống")');
    const errorBtn = page.locator('button:has-text("4. Lỗi")');
    const repairBtn = page.locator('button:has-text("5. Sửa lỗi")');

    await expect(normalBtn).toBeVisible();
    await expect(loadingBtn).toBeVisible();
    await expect(emptyBtn).toBeVisible();
    await expect(errorBtn).toBeVisible();
    await expect(repairBtn).toBeVisible();

    // Click Empty state
    await emptyBtn.click();
    await expect(page.locator('text=Tất cả quyết định hôm nay đã được xử lý xong')).toBeVisible();

    // Click Error state
    await errorBtn.click();
    await expect(page.locator('text=Lỗi đồng bộ dữ liệu quyết định')).toBeVisible();

    // Click Repair state
    await repairBtn.click();
    await expect(page.locator('text=Cần sửa chữa: Tài khoản TikTok Shop')).toBeVisible();

    // Return to Normal state
    await normalBtn.click();
    await expect(page.locator('text=Nhịp việc ưu tiên hôm nay')).toBeVisible();
  });

  test('notification drawer opens via header bell and dismisses via Escape key', async ({ page }) => {
    await page.goto(`${WEB_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    const bellBtn = page.locator('header button[aria-label="Mở trung tâm thông báo"]');
    await expect(bellBtn).toBeVisible();
    await bellBtn.click();

    // Drawer dialog opens
    const drawerDialog = page.locator('div[role="dialog"][aria-labelledby="notification-drawer-title"]');
    await expect(drawerDialog).toBeVisible();
    await expect(page.locator('#notification-drawer-title')).toContainText('Trung tâm thông báo');

    // Press Escape to dismiss
    await page.keyboard.press('Escape');
    await expect(drawerDialog).toBeHidden();
  });

  test('help drawer opens via help button and dismisses via Escape key', async ({ page }) => {
    await page.goto(`${WEB_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    const helpBtn = page.locator('header button[aria-label="Mở trung tâm trợ giúp"]');
    await expect(helpBtn).toBeVisible();
    await helpBtn.click();

    // Help drawer should be visible with its title
    const helpTitle = page.locator('#help-drawer-title');
    await expect(helpTitle).toBeVisible();
    await expect(helpTitle).toContainText('Trung tâm trợ giúp');

    // Press Escape to dismiss
    await page.keyboard.press('Escape');
    await expect(helpTitle).toBeHidden();
  });

  test('localization switcher updates canonical legal footer and announces to aria-live', async ({ page }) => {
    await page.goto(`${WEB_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    const politeLive = page.locator('div[aria-live="polite"]');

    // Switch to English
    const enBtn = page.locator('footer button:has-text("EN")');
    await expect(enBtn).toBeVisible();
    await enBtn.click();

    // Live region announces switch
    await expect(politeLive).toContainText('Display language switched to English');

    // English legal link visible
    await expect(page.locator('footer a:has-text("Terms of Service")')).toBeVisible();

    // Switch back to Vietnamese
    const viBtn = page.locator('footer button:has-text("VI")');
    await viBtn.click();

    await expect(politeLive).toContainText('Đã chuyển ngôn ngữ hiển thị sang Tiếng Việt');
    await expect(page.locator('footer a:has-text("Điều khoản dịch vụ")')).toBeVisible();
  });
});

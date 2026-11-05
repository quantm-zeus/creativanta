import { test, expect } from '@playwright/test';
import { WEB_BASE_URL, assertNoHorizontalOverflow } from './helpers';

const CANONICAL_MODES = [
  {
    id: 'creator',
    name: 'Solo Creator',
    tagline: 'Sáng tạo nội dung & thương hiệu cá nhân',
    primaryModule: 'M05-M10'
  },
  {
    id: 'seller',
    name: 'Seller / Nhà bán hàng',
    tagline: 'Vận hành shop đa sàn & tối ưu chuyển đổi',
    primaryModule: 'M13-M19'
  },
  {
    id: 'affiliate_operator',
    name: 'Affiliate Operator',
    tagline: 'Tiếp thị liên kết & tối ưu hoa hồng',
    primaryModule: 'M15-M18'
  },
  {
    id: 'live_operator',
    name: 'Live Operator',
    tagline: 'Vận hành phiên live & chốt đơn tức thì',
    primaryModule: 'M11-M14'
  },
  {
    id: 'agency_mcn',
    name: 'Agency / MCN',
    tagline: 'Quản trị mạng lưới đa creator & nhãn hàng',
    primaryModule: 'M20-M23'
  },
  {
    id: 'brand_collaboration',
    name: 'Brand Collaboration',
    tagline: 'Booking KOC & đo lường hiệu quả chiến dịch',
    primaryModule: 'M17-M22'
  }
];

test.describe('Operator Modes & Navigation Smoke', () => {
  test('header contains mode selector with all 6 canonical modes', async ({ page }) => {
    await page.goto(`${WEB_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    const isMobile = (page.viewportSize()?.width || 1440) < 640;
    const selector = isMobile
      ? page.locator('select[aria-label="Chọn chế độ vận hành trên di động"]')
      : page.locator('#operator-mode-select');

    await expect(selector).toBeVisible();

    // Verify all 6 mode options are present
    for (const mode of CANONICAL_MODES) {
      const option = selector.locator(`option[value="${mode.id}"]`);
      await expect(option).toHaveCount(1);
    }
  });

  test('switching between all 6 modes dynamically updates Home priorities, tagline and module badge', async ({ page }) => {
    await page.goto(`${WEB_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    const isMobile = (page.viewportSize()?.width || 1440) < 640;
    const selector = isMobile
      ? page.locator('select[aria-label="Chọn chế độ vận hành trên di động"]')
      : page.locator('#operator-mode-select');

    for (const mode of CANONICAL_MODES) {
      await selector.selectOption(mode.id);

      // Verify h1 updates to mode tagline
      const heading = page.locator('h1').first();
      await expect(heading).toContainText(mode.tagline);

      // Verify primary module badge updates
      const moduleBadge = page.locator(`text=Phân hệ: ${mode.primaryModule}`);
      await expect(moduleBadge).toBeVisible();

      // Ensure no horizontal overflow during or after mode transition
      await assertNoHorizontalOverflow(page, `Mode ${mode.id}`);
    }
  });

  test('mode persists across route navigation', async ({ page }) => {
    await page.goto(`${WEB_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    const isMobile = (page.viewportSize()?.width || 1440) < 640;
    const selector = isMobile
      ? page.locator('select[aria-label="Chọn chế độ vận hành trên di động"]')
      : page.locator('#operator-mode-select');

    // Switch to seller mode
    await selector.selectOption('seller');
    await expect(page.locator('h1').first()).toContainText('Vận hành shop đa sàn');

    // Navigate to /ideas
    await page.goto(`${WEB_BASE_URL}/ideas`);
    await page.waitForLoadState('networkidle');

    // Return to /
    await page.goto(`${WEB_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    // Verify mode is still seller
    await expect(page.locator('h1').first()).toContainText('Vận hành shop đa sàn');
  });
});

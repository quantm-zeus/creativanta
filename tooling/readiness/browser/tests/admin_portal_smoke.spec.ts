import { test, expect } from '@playwright/test';
import { ADMIN_BASE_URL, assertNoHorizontalOverflow } from './helpers';

test.describe('Restricted Admin Portal Smoke', () => {
  test('admin portal loads with restricted headers and zero horizontal overflow', async ({ page }) => {
    await page.goto(`${ADMIN_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    // Header badge
    const badge = page.locator('text=INTERNAL ADMIN · P0 / P8-08');
    await expect(badge).toBeVisible();

    // Title
    const title = page.locator('h1#restricted-title');
    await expect(title).toContainText('Khu vực vận hành nội bộ');

    // Skip to main content link exists
    const skipLink = page.locator('a[href="#admin-main-content"]');
    await expect(skipLink).toHaveCount(1);

    await assertNoHorizontalOverflow(page, 'Admin Portal');
  });

  test('admin listener access control fails closed for workspace roles and requires VPN+MFA for super_admin', async ({ page }) => {
    await page.goto(`${ADMIN_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    // Section 1: Cổng Cô lập Listener Admin
    const roleSelect = page.locator('label:has-text("Vai trò thử nghiệm gọi Admin Listener") select');
    await expect(roleSelect).toBeVisible();

    // Default role 'owner' should show denial
    await roleSelect.selectOption('owner');
    await expect(page.getByText('Vai trò Workspace (owner) tuyệt đối không được phép gọi cổng Admin nội bộ.')).toBeVisible();

    // Switch to 'super_admin'
    await roleSelect.selectOption('super_admin');
    await expect(page.getByText('Đã xác minh phiên Admin nội bộ (super_admin) qua VPN + TOTP MFA.')).toBeVisible();

    // Uncheck VPN checkbox to verify fail-closed behavior
    const vpnCheckbox = page.locator('label:has-text("VPN Mesh Verified") input[type="checkbox"]');
    await vpnCheckbox.uncheck();
    await expect(page.getByText('Từ chối truy cập: yêu cầu kết nối mạng riêng VPN')).toBeVisible();
  });

  test('impersonation actions enforce strictly read-only mode and block mutating commands', async ({ page }) => {
    await page.goto(`${ADMIN_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    // Section 2: Phiên Impersonation
    const actionSelect = page.locator('label:has-text("Loại thao tác trong phiên Impersonation") select');
    await expect(actionSelect).toBeVisible();

    // Mutating command should be blocked
    await actionSelect.selectOption('mutating_command');
    await expect(page.getByText('Chặn thao tác ghi: Phiên Impersonation chỉ cho phép chế độ Chỉ đọc')).toBeVisible();

    // Read query should be permitted
    await actionSelect.selectOption('read_query');
    await expect(page.getByText('Cho phép truy vấn Chỉ đọc (read_only) trong thời hạn 30 phút')).toBeVisible();
  });

  test('full scope release decision evaluator enforces external gates remain fail-closed', async ({ page }) => {
    await page.goto(`${ADMIN_BASE_URL}/`);
    await page.waitForLoadState('networkidle');

    // Section 9: Nghiệm thu toàn diện P8-09
    const releaseHeading = page.locator('#p809-acceptance-heading');
    await expect(releaseHeading).toBeVisible();

    // Verify default local state reflects external gates are pending
    await expect(page.getByText('CONDITIONAL_READY_LOCAL', { exact: true })).toBeVisible();
    await expect(page.getByText('3 cổng ngoại vi')).toBeVisible();

    // Find the toggle for asserting production launch
    const assertCheckbox = page.locator('label:has-text("Yêu cầu phát hành sản xuất") input[type="checkbox"]');
    await assertCheckbox.check();

    // Verdict must be RELEASE_BLOCKED with EXTERNAL_GATES_OPEN error (never fake-green)
    await expect(page.getByText('RELEASE_BLOCKED', { exact: true })).toBeVisible();
    await expect(page.getByText('Không thể tuyên bố phát hành sản xuất')).toBeVisible();
  });
});

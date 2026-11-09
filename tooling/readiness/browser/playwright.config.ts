import { defineConfig } from '@playwright/test';
import fs from 'node:fs';
import path from 'node:path';

// Ports for Web and Admin servers during local QA
const WEB_PORT = process.env.BROWSER_QA_WEB_PORT || '41731';
const ADMIN_PORT = process.env.BROWSER_QA_ADMIN_PORT || '41732';

export const WEB_BASE_URL = `http://127.0.0.1:${WEB_PORT}`;
export const ADMIN_BASE_URL = `http://127.0.0.1:${ADMIN_PORT}`;

// Unprivileged Headless Shell path on this host (fallback if not in PATH/standard)
const localHeadlessShell = '/home/whaleorcale/.cache/ms-playwright/chromium_headless_shell-1155/chrome-linux/headless_shell';
const unprivilegedLibs = '/home/whaleorcale/.local/lib/chromium-deps/usr/lib/x86_64-linux-gnu';

const chromiumExecutable = process.env.CHROMIUM_EXECUTABLE_PATH ||
  (fs.existsSync(localHeadlessShell) ? localHeadlessShell : undefined);

const ldLibPath = [
  fs.existsSync(unprivilegedLibs) ? unprivilegedLibs : '',
  process.env.LD_LIBRARY_PATH || ''
].filter(Boolean).join(':');

export default defineConfig({
  testDir: './tests',
  timeout: 30000,
  expect: {
    timeout: 5000,
  },
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: 0,
  workers: 1, // Single worker: deterministic, zero port thrashing, low memory
  reporter: [
    ['list'],
    ['json', { outputFile: path.resolve(__dirname, '../../../build/readiness/2026-11-05/browser_results.json') }]
  ],
  use: {
    baseURL: WEB_BASE_URL,
    trace: 'off',
    screenshot: 'only-on-failure',
    video: 'off',
    launchOptions: {
      executablePath: chromiumExecutable,
      args: [
        '--no-sandbox',
        '--disable-gpu',
        '--disable-dev-shm-usage',
        '--disable-software-rasterizer',
        '--disable-extensions'
      ],
      env: {
        ...process.env,
        ...(ldLibPath ? { LD_LIBRARY_PATH: ldLibPath } : {})
      }
    }
  },
  projects: [
    {
      name: 'desktop',
      use: {
        viewport: { width: 1440, height: 900 },
        userAgent: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36 CreativantaSmoke/1.0',
      },
    },
    {
      name: 'tablet',
      use: {
        viewport: { width: 768, height: 1024 },
        userAgent: 'Mozilla/5.0 (iPad; CPU OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1 CreativantaSmoke/1.0',
      },
    },
    {
      name: 'mobile',
      use: {
        viewport: { width: 390, height: 844 },
        isMobile: true,
        hasTouch: true,
        userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1 CreativantaSmoke/1.0',
      },
    },
  ],
  webServer: [
    {
      command: `PORT=${WEB_PORT} HOST=127.0.0.1 node apps/web/build/index.js`,
      cwd: path.resolve(__dirname, '../../..'),
      port: Number(WEB_PORT),
      reuseExistingServer: false,
      timeout: 15000,
    },
    {
      command: `PORT=${ADMIN_PORT} HOST=127.0.0.1 node apps/admin/build/index.js`,
      cwd: path.resolve(__dirname, '../../..'),
      port: Number(ADMIN_PORT),
      reuseExistingServer: false,
      timeout: 15000,
    }
  ],
});

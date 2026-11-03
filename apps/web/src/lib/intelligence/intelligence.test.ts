import { describe, it, expect } from 'vitest';
import {
  verifyLiveSourceAccess,
  getDownstreamGatePolicy,
  neutralizeSpreadsheetFormula,
  validateFinancialNonConflation,
  evaluateEmptyOrDegraded,
  type DownstreamTargetType
} from './access_proof';

describe('P2-04 Intelligence Acceptance and Access Proof (Web)', () => {
  describe('Acceptance Target 1: Every live source has access evidence', () => {
    it('fails closed when no access evidence is present', () => {
      const result = verifyLiveSourceAccess({
        platform: 'tiktok',
        actionKey: 'intelligence.trends.fetch_live',
        evidenceRef: '',
        grantedScopes: [],
        requiredScopes: ['video.list', 'trend.read']
      });

      expect(result.status).toBe('unsupported');
      expect(result.isVerified).toBe(false);
      expect(result.canFallbackToImport).toBe(true);
      expect(result.reconnectRequired).toBe(true);
      expect(result.degradedReason).toContain('Thiếu quyền OAuth');
    });

    it('flags degraded and requires reconnect when access token has expired', () => {
      const past = new Date(Date.now() - 3600 * 1000).toISOString();
      const result = verifyLiveSourceAccess({
        platform: 'shopee',
        actionKey: 'competitor.shop.inspect_live',
        evidenceRef: 'oauth-grant-shopee-vn-9921',
        grantedScopes: ['shop.read', 'product.read'],
        requiredScopes: ['shop.read'],
        validUntil: past
      });

      expect(result.status).toBe('degraded');
      expect(result.isVerified).toBe(true);
      expect(result.isDegraded).toBe(true);
      expect(result.confidenceBand).toBe('medium');
      expect(result.reconnectRequired).toBe(true);
      expect(result.fallbackNote).toContain('bộ nhớ đệm gần nhất');
    });

    it('marks verified when valid evidence and scopes are present', () => {
      const future = new Date(Date.now() + 86400 * 1000).toISOString();
      const result = verifyLiveSourceAccess({
        platform: 'meta',
        actionKey: 'intelligence.competitors.ads_library',
        evidenceRef: 'meta-system-token-valid-7711',
        grantedScopes: ['ads_read', 'pages_read_engagement'],
        requiredScopes: ['ads_read'],
        validUntil: future,
        sourceClass: 'official',
        confidenceBand: 'high'
      });

      expect(result.status).toBe('verified');
      expect(result.isVerified).toBe(true);
      expect(result.isDegraded).toBe(false);
      expect(result.confidenceBand).toBe('high');
      expect(result.reconnectRequired).toBe(false);
    });
  });

  describe('Acceptance Target 2: Future conversions remain assigned to later tasks', () => {
    const targets: Array<{ target: DownstreamTargetType; phase: 'P3' | 'P6'; module: string }> = [
      { target: 'idea', phase: 'P3', module: 'M05' },
      { target: 'script', phase: 'P3', module: 'M06' },
      { target: 'campaign', phase: 'P6', module: 'M14' },
      { target: 'live_plan', phase: 'P6', module: 'M17' },
    ];

    targets.forEach(({ target, phase, module }) => {
      it(`enforces downstream gating for ${target} -> Phase ${phase} (${module})`, () => {
        const policy = getDownstreamGatePolicy(target);
        expect(policy.phaseAssigned).toBe(phase);
        expect(policy.targetModule).toBe(module);
        expect(policy.isExecutableInP2).toBe(false);
        expect(policy.explanation).toBeDefined();
      });
    });

    it('throws on unsupported conversion target', () => {
      expect(() => getDownstreamGatePolicy('invalid_target' as any)).toThrow();
    });
  });

  describe('Acceptance Target 3: Empty, degraded, and audit paths', () => {
    it('accurately identifies empty state and generates helpful CTAs', () => {
      const summary = evaluateEmptyOrDegraded([
        { platform: 'tiktok', isConnected: false },
        { platform: 'shopee', isConnected: false },
        { platform: 'meta', isConnected: false }
      ]);

      expect(summary.hasEmptyState).toBe(true);
      expect(summary.connectedCount).toBe(0);
      expect(summary.degradedCount).toBe(0);
      expect(summary.emptyStateCtas.length).toBeGreaterThanOrEqual(3);
    });

    it('accurately counts degraded connections when tokens expire', () => {
      const summary = evaluateEmptyOrDegraded([
        { platform: 'tiktok', isConnected: true, tokenExpired: true },
        { platform: 'shopee', isConnected: true, tokenExpired: false },
        { platform: 'meta', isConnected: false }
      ]);

      expect(summary.hasEmptyState).toBe(false);
      expect(summary.connectedCount).toBe(1);
      expect(summary.degradedCount).toBe(1);
      expect(summary.degradedPlatforms).toContain('tiktok');
    });
  });

  describe('Spreadsheet formula injection neutralization', () => {
    it('neutralizes leading =, +, -, @, \\t, \\r characters', () => {
      expect(neutralizeSpreadsheetFormula('=SUM(A1:A10)')).toBe("'=SUM(A1:A10)");
      expect(neutralizeSpreadsheetFormula('+123456')).toBe("'+123456");
      expect(neutralizeSpreadsheetFormula('-CMD|test')).toBe("'-CMD|test");
      expect(neutralizeSpreadsheetFormula('@HYPERLINK("http://evil.com")')).toBe("'@HYPERLINK(\"http://evil.com\")");
      expect(neutralizeSpreadsheetFormula('Clean Trend Name')).toBe('Clean Trend Name');
      expect(neutralizeSpreadsheetFormula('')).toBe('');
    });
  });

  describe('Financial non-conflation guard', () => {
    it('prevents intelligence observational data from polluting financial ledger M19', () => {
      expect(validateFinancialNonConflation('M02', true).allowed).toBe(false);
      expect(validateFinancialNonConflation('M03', true).allowed).toBe(false);
      expect(validateFinancialNonConflation('M04', true).allowed).toBe(false);
      expect(validateFinancialNonConflation('M19', true).allowed).toBe(true);
      expect(validateFinancialNonConflation('M04', false).allowed).toBe(true);
    });
  });
});

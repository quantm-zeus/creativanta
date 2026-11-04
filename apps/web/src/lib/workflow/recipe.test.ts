import { describe, it, expect } from 'vitest';
import {
  checkRecipeCapabilities,
  calculateRevenueShare,
  instantiateRecipeWorkflow,
  type RecipeTemplate
} from './recipe';

describe('P7-03 Recipe Marketplace & Governance Web Utilities', () => {
  const mockRecipe: RecipeTemplate = {
    recipe_id: 'rec-test-01',
    title: 'TikTok Auto Publisher',
    description: 'Auto-publish approved videos to TikTok',
    category: 'content',
    template_kind: 'workflow',
    template_version: 1,
    template_payload: {
      schema_version: 1,
      license_notice: 'MIT',
      graph: {
        schema_version: 1,
        nodes: [
          { node_id: 'n1', node_type: 'trigger', title: 'Video Approved Trigger', config: { type: 'event', event_type: 'video.approved' } },
          { node_id: 'n2', node_type: 'action', title: 'Publish TikTok Action', config: { action: 'PublishTikTok', caption: '{{custom_caption}}' } },
          { node_id: 'n3', node_type: 'terminal', title: 'Finish Terminal', config: {} }
        ],
        edges: [
          { from_node_id: 'n1', to_node_id: 'n2' },
          { from_node_id: 'n2', to_node_id: 'n3' }
        ]
      }
    },
    parameters: [
      { name: 'custom_caption', type: 'string', default_value: 'Default caption', required: true, description: 'Caption' }
    ],
    required_capabilities: ['tiktok.publish', 'shopee.order.sync'],
    install_count: 50,
    rating_avg: 4.8,
    review_count: 12,
    price_usd: '50.000000',
    status: 'published',
    created_at: '2026-10-01T00:00:00Z',
    updated_at: '2026-10-02T00:00:00Z'
  };

  it('Target 2: checkRecipeCapabilities explains missing capabilities with guidance', () => {
    // TikTok supported, Shopee unsupported
    const caps = {
      'tiktok.publish': 'supported',
      'shopee.order.sync': 'unsupported'
    };

    const res = checkRecipeCapabilities(mockRecipe, caps);
    expect(res.eligible).toBe(false);
    expect(res.missing).toHaveLength(1);
    expect(res.missing[0].capability_key).toBe('shopee.order.sync');
    expect(res.missing[0].platform).toBe('shopee');
    expect(res.missing[0].resolution_guidance).toContain('Connect your Shopee seller store');
    expect(res.missing[0].connect_url).toBe('/settings/integrations/shopee');
  });

  it('Target 2: checkRecipeCapabilities passes when all capabilities are active', () => {
    const caps = {
      'tiktok.publish': 'supported',
      'shopee.order.sync': 'supported'
    };

    const res = checkRecipeCapabilities(mockRecipe, caps);
    expect(res.eligible).toBe(true);
    expect(res.missing).toHaveLength(0);
  });

  it('Target 1 & 3: instantiateRecipeWorkflow preserves canonical graph and substitutes parameters', () => {
    const wf = instantiateRecipeWorkflow(
      mockRecipe,
      'ws-target-123',
      { custom_caption: 'Awesome new video!' },
      'My Custom Pipeline'
    );

    expect(wf.workspace_id).toBe('ws-target-123');
    expect(wf.title).toBe('My Custom Pipeline');
    expect(wf.workflow_type).toBe('recipe_installed');
    expect(wf.status).toBe('draft');
    expect(wf.action_chain.nodes).toHaveLength(3);
    expect(wf.action_chain.edges).toHaveLength(2);

    // Verify parameter placeholder substituted
    const actionNode = wf.action_chain.nodes[1];
    expect(actionNode.config?.['caption']).toBe('Awesome new video!');
  });

  it('Revenue Share (RULE-M21-006): calculates exact 70/30 split with 7-day refund window', () => {
    const rev100 = calculateRevenueShare('100.000000');
    expect(rev100.grossUSD).toBe('100.000000');
    expect(rev100.creatorUSD).toBe('70.000000');
    expect(rev100.platformUSD).toBe('30.000000');
    expect(rev100.refundWindowDays).toBe(7);

    // Test with fractional amount: $29.50
    const rev2950 = calculateRevenueShare('29.500000');
    expect(rev2950.creatorUSD).toBe('20.650000');
    expect(rev2950.platformUSD).toBe('8.850000');
  });
});

import type { Workflow, WorkflowGraph, TriggerConfig } from './types';

export type RecipeStatus = 'draft' | 'review_required' | 'published' | 'deprecated' | 'retired' | 'taken_down';
export type TemplateKind = 'workflow' | 'style_workflow';
export type RecipeInstallationStatus = 'installed' | 'customized' | 'update_available' | 'pinned' | 'deprecated' | 'workflow_deleted';
export type SubmissionStatus = 'pending' | 'approved' | 'rejected' | 'changes_requested' | 'taken_down';

export interface RecipeParameter {
  name: string;
  type: string;
  default_value: string;
  required: boolean;
  description: string;
}

export interface MissingCapabilityExplanation {
  capability_key: string;
  platform: string;
  reason: string;
  resolution_guidance: string;
  connect_url: string;
}

export interface RecipeTemplate {
  recipe_id: string;
  workspace_id?: string;
  author_workspace_id?: string;
  title: string;
  description: string;
  category: string;
  activepieces_template_id?: string;
  template_kind: TemplateKind;
  template_version: number;
  template_payload: {
    schema_version: 1;
    graph: WorkflowGraph;
    license_notice: string;
    style_settings?: Record<string, unknown>;
  };
  parameters: RecipeParameter[];
  required_capabilities: string[];
  install_count: number;
  rating_avg: number;
  review_count: number;
  price_usd: string; // Exact decimal string per DB-H-001
  status: RecipeStatus;
  created_at: string;
  updated_at: string;
}

export interface RecipeInstallation {
  installation_id: string;
  workspace_id: string;
  recipe_id: string;
  workflow_id: string;
  installed_version: number;
  status: RecipeInstallationStatus;
  parameter_values: Record<string, unknown>;
  installed_by?: string;
  created_at: string;
  updated_at: string;
}

export interface RecipeReview {
  review_id: string;
  recipe_id: string;
  workspace_id: string;
  user_id: string;
  rating: number; // 1-5
  review_text: string;
  author_name: string;
  created_at: string;
}

export interface RecipeRevenueShare {
  revenue_share_id: string;
  recipe_id: string;
  author_workspace_id: string;
  purchaser_workspace_id: string;
  gross_amount: string;
  creator_amount: string; // 70%
  platform_amount: string; // 30%
  currency: string;
  status: 'settled' | 'refunded' | 'disputed';
  refund_eligible_until: string;
  created_at: string;
}

/**
 * Checks if workspace capabilities satisfy recipe requirements and explains missing capabilities (AC-M21-003).
 */
export function checkRecipeCapabilities(
  recipe: RecipeTemplate,
  workspaceCapabilities: Record<string, string>
): { eligible: boolean; missing: MissingCapabilityExplanation[] } {
  const missing: MissingCapabilityExplanation[] = [];

  for (const capKey of recipe.required_capabilities || []) {
    const trimmed = capKey.trim();
    if (!trimmed) continue;

    const parts = trimmed.split('.');
    const platform = parts[0].toLowerCase();
    const action = parts.slice(1).join('.');

    // Lookup capability status in workspace
    const directStatus = workspaceCapabilities[trimmed.toLowerCase()];
    const platformStatus = workspaceCapabilities[platform];
    const status = directStatus || platformStatus || 'unsupported';

    const s = status.toLowerCase();
    if (s === 'supported' || s === 'native' || s === 'active') {
      continue;
    }

    let reason = `Platform connector '${platform}' capability is currently ${s}.`;
    let guidance = `Connect your ${platform} account in Settings -> Integrations to enable this automation.`;
    const connect_url = `/settings/integrations/${platform}`;

    if (platform === 'shopee') {
      reason = 'This recipe requires an active Shopee connected account with order sync capability.';
      guidance = 'Connect your Shopee seller store in Settings -> Integrations or browse alternatives.';
    } else if (platform === 'tiktok') {
      reason = 'This recipe requires TikTok Direct Publish or Video Sync capability.';
      guidance = 'Authorize your TikTok Creator account with publish permissions in Integrations.';
    }

    missing.push({
      capability_key: capKey,
      platform,
      reason,
      resolution_guidance: guidance,
      connect_url
    });
  }

  return {
    eligible: missing.length === 0,
    missing
  };
}

/**
 * Calculates exact 70/30 revenue share for paid recipe templates without floating point errors (RULE-M21-006).
 */
export function calculateRevenueShare(grossUSD: string): {
  grossUSD: string;
  creatorUSD: string;
  platformUSD: string;
  refundWindowDays: number;
} {
  const clean = grossUSD.trim() || '0.000000';
  const parts = clean.split('.');
  const whole = BigInt(parts[0] || '0');
  const fractionStr = (parts[1] || '').padEnd(6, '0').slice(0, 6);
  const fraction = BigInt(fractionStr);

  const micros = whole * 1000000n + fraction;
  const creatorMicros = (micros * 70n) / 100n;
  const platformMicros = micros - creatorMicros;

  const fmt = (m: bigint): string => {
    const w = m / 1000000n;
    const f = (m % 1000000n).toString().padStart(6, '0');
    return `${w}.${f}`;
  };

  return {
    grossUSD: fmt(micros),
    creatorUSD: fmt(creatorMicros),
    platformUSD: fmt(platformMicros),
    refundWindowDays: 7
  };
}

/**
 * Clones recipe template into an editable canonical M20 workflow instance (Target 1 & 3).
 */
export function instantiateRecipeWorkflow(
  recipe: RecipeTemplate,
  workspaceId: string,
  paramValues: Record<string, unknown>,
  titleOverride?: string
): Workflow {
  const title = titleOverride?.trim() || recipe.title;
  const graph = recipe.template_payload?.graph || { schema_version: 1, nodes: [], edges: [] };

  // Clone nodes and substitute parameters
  const clonedNodes = graph.nodes.map((node) => {
    const cfg: Record<string, unknown> = { ...node.config };
    for (const [k, v] of Object.entries(cfg)) {
      if (typeof v === 'string' && v.startsWith('{{') && v.endsWith('}}')) {
        const paramName = v.slice(2, -2).trim();
        if (paramValues[paramName] !== undefined) {
          cfg[k] = paramValues[paramName];
        }
      }
    }
    return {
      ...node,
      node_id: node.node_id,
      node_type: node.node_type,
      title: node.title || node.node_id,
      config: cfg
    };
  });

  const clonedEdges = graph.edges.map((e) => ({ ...e }));

  const now = new Date().toISOString();
  return {
    workflow_id: `wf-${Date.now()}`,
    workspace_id: workspaceId,
    title,
    workflow_type: 'recipe_installed',
    status: 'draft',
    version: 1,
    trigger_config: { type: 'manual' },
    action_chain: {
      schema_version: 1,
      nodes: clonedNodes,
      edges: clonedEdges
    },
    approval_requirements: [],
    tier_limit_check: true,
    run_count: 0,
    created_at: now,
    updated_at: now
  };
}

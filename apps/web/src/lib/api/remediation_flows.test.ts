import { describe, expect, it, vi } from 'vitest';
import { get } from 'svelte/store';
import { callCanonicalRpc } from './client';
import { createIdeaRemote } from '../idea';
import {
  requestImageToVideoGenerationRemote,
  requestImageToVideoQuoteRemote,
  cancelStudioJobRemote,
  retryStudioJobRemote
} from '../production';
import {
  issueApiKeyRemote,
  rotateApiKeyRemote,
  revokeApiKeyRemote,
  registerWebhookRemote,
  developerStore
} from '../developer/public_api';
import {
  submitSupportTicketRemote,
  supportStore
} from '../help/store';
import {
  loadWorkflowRemote,
  saveWorkflowRemote,
  setWorkflowStatusRemote,
  createWorkflowEditorSession
} from '../workflow/runtime';
import {
  createScriptEditorSession,
  createScriptReviewSession,
  updateSceneInList,
  updateShotInList,
  approveScriptRemote,
  rejectScriptRemote
} from '../script';
import { CANONICAL_LEGAL_LINKS, getLegalDocumentBySlug } from '../a11y';
import { executeVideoAgentStepRemote, planVideoAgent } from '../automation/agent';
import {
  applyOperationalRepairRemote,
  getInitialUnreconciledOutcomes
} from '../commerce/commerce_acceptance';

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'content-type': 'application/json' }
  });
}

describe('Remediation Canonical RPC Flows (UF-04..UF-08, AI-02, R04)', () => {
  it('callCanonicalRpc fails closed when session token is missing', async () => {
    const fetchMock = vi.fn();
    const res = await callCanonicalRpc(
      'creativanta.content.v1.IdeaService/Create',
      { title: 'Test' },
      {
        token: null,
        fetchFn: fetchMock as unknown as typeof fetch
      }
    );

    expect(res.ok).toBe(false);
    if (!res.ok) {
      expect(res.error.code).toBe('AUTH_REQUIRED_001');
    }
    expect(fetchMock).not.toHaveBeenCalled();
  });

  it('UF-04 createIdeaRemote fails closed on 404/503 and succeeds only with persisted idea_id', async () => {
    const fetch404 = vi.fn().mockResolvedValue(jsonResponse({ message: 'Not Found' }, 404));
    const failRes = await createIdeaRemote(
      {
        workspaceId: 'ws-1',
        title: 'Ý tưởng kem chống nắng',
        hookText: '90% người dùng thoa sai cách'
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: fetch404 as unknown as typeof fetch
      }
    );
    expect(failRes.ok).toBe(false);
    expect(failRes.idea).toBeUndefined();

    const fetch200 = vi.fn().mockResolvedValue(
      jsonResponse({
        idea: {
          idea_id: 'idea-persisted-001',
          workspace_id: 'ws-1',
          title: 'Ý tưởng kem chống nắng',
          status: 'candidate'
        }
      })
    );
    const okRes = await createIdeaRemote(
      {
        workspaceId: 'ws-1',
        title: 'Ý tưởng kem chống nắng',
        hookText: '90% người dùng thoa sai cách'
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: fetch200 as unknown as typeof fetch
      }
    );
    expect(okRes.ok).toBe(true);
    expect(okRes.idea?.ideaId).toBe('idea-persisted-001');
  });

  it('UF-05 requestImageToVideoGenerationRemote never debits credits on failure and returns job_id on success', async () => {
    const fetch503 = vi.fn().mockResolvedValue(
      jsonResponse({ message: 'Provider queue unavailable' }, 503)
    );
    const failRes = await requestImageToVideoGenerationRemote(
      {
        workspaceId: 'ws-1',
        images: [
          {
            id: 'img-1',
            url: 'https://cdn.creativanta.vn/input.png',
            name: 'input.png',
            durationSeconds: 5
          }
        ],
        selectedMotionStyleId: 'zoom_in',
        motionIntensity: 60,
        aspectRatio: '9:16',
        selectedTransitionId: 'crossfade',
        quoteCredits: 25,
        availableBalance: 450
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: fetch503 as unknown as typeof fetch
      }
    );
    expect(failRes.ok).toBe(false);
    expect(failRes.jobId).toBeUndefined();

    const fetch200 = vi.fn().mockResolvedValue(
      jsonResponse({
        job: {
          job_id: 'job-real-001',
          reserved_credits: 25
        },
        remaining_balance: 425
      })
    );
    const okRes = await requestImageToVideoGenerationRemote(
      {
        workspaceId: 'ws-1',
        images: [
          {
            id: 'img-1',
            url: 'https://cdn.creativanta.vn/input.png',
            name: 'input.png',
            durationSeconds: 5
          }
        ],
        selectedMotionStyleId: 'zoom_in',
        motionIntensity: 60,
        aspectRatio: '9:16',
        selectedTransitionId: 'crossfade',
        quoteCredits: 25,
        availableBalance: 450
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: fetch200 as unknown as typeof fetch
      }
    );
    expect(okRes.ok).toBe(true);
    expect(okRes.jobId).toBe('job-real-001');
    expect(okRes.remainingBalance).toBe(425);
  });

  it('UF-06 issue/rotate/revoke API key and webhook registration fail closed without fake secrets', async () => {
    developerStore.reset();
    const fetch404 = vi.fn().mockResolvedValue(jsonResponse({ message: 'Not Found' }, 404));

    const issueFail = await issueApiKeyRemote(
      {
        workspaceId: 'ws-1',
        tier: 'pro',
        activeKeysCount: 0,
        name: 'CI Key',
        scopes: ['read:trends']
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: fetch404 as unknown as typeof fetch
      }
    );
    expect(issueFail.ok).toBe(false);
    expect(issueFail.key).toBeUndefined();

    const fetchIssue200 = vi.fn().mockResolvedValue(
      jsonResponse({
        api_key: {
          api_key_id: 'ak_server_01',
          workspace_id: 'ws-1',
          key_prefix: 'ca_live_99',
          name: 'CI Key',
          scopes: ['read:trends'],
          status: 'active',
          logical_key_id: 'ak_server_01'
        },
        raw_secret: 'ca_live_99_server_issued_secret'
      })
    );
    const issueOk = await issueApiKeyRemote(
      {
        workspaceId: 'ws-1',
        tier: 'pro',
        activeKeysCount: 0,
        name: 'CI Key',
        scopes: ['read:trends']
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: fetchIssue200 as unknown as typeof fetch
      }
    );
    expect(issueOk.ok).toBe(true);
    expect(issueOk.rawSecret).toBe('ca_live_99_server_issued_secret');
    developerStore.upsertRemoteKey(issueOk.key!);

    const rotateFail = await rotateApiKeyRemote(
      { workspaceId: 'ws-1', apiKeyId: 'ak_server_01' },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: fetch404 as unknown as typeof fetch
      }
    );
    expect(rotateFail.ok).toBe(false);

    const revokeFail = await revokeApiKeyRemote(
      { workspaceId: 'ws-1', apiKeyId: 'ak_server_01' },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: fetch404 as unknown as typeof fetch
      }
    );
    expect(revokeFail.ok).toBe(false);

    const webhookFail = await registerWebhookRemote(
      {
        workspaceId: 'ws-1',
        targetUrl: 'https://hooks.example.com/creativanta',
        eventTypes: ['order.created']
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: fetch404 as unknown as typeof fetch
      }
    );
    expect(webhookFail.ok).toBe(false);
  });

  it('UF-07 submitSupportTicketRemote fails closed on error and preserves caller input', async () => {
    const fetch503 = vi.fn().mockResolvedValue(
      jsonResponse({ message: 'Support service unavailable' }, 503)
    );
    const failRes = await submitSupportTicketRemote(
      {
        workspaceId: 'ws-1',
        subject: 'Không đồng bộ được TikTok Shop',
        priority: 'high',
        initialMessage: 'Chi tiết lỗi kết nối OAuth sau khi cấp quyền.',
        planTier: 'pro'
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: fetch503 as unknown as typeof fetch
      }
    );
    expect(failRes.ok).toBe(false);
    expect(failRes.ticket).toBeUndefined();

    const fetch200 = vi.fn().mockResolvedValue(
      jsonResponse({
        ticket: {
          ticket_id: 'tkt_server_101',
          ticket_number: 'TKT-2026-9001',
          subject: 'Không đồng bộ được TikTok Shop',
          priority: 'high',
          status: 'open'
        }
      })
    );
    const okRes = await submitSupportTicketRemote(
      {
        workspaceId: 'ws-1',
        subject: 'Không đồng bộ được TikTok Shop',
        priority: 'high',
        initialMessage: 'Chi tiết lỗi kết nối OAuth sau khi cấp quyền.',
        planTier: 'pro'
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: fetch200 as unknown as typeof fetch
      }
    );
    expect(okRes.ok).toBe(true);
    expect(okRes.ticket?.ticketNumber).toBe('TKT-2026-9001');
  });

  it('UF-08 saveWorkflowRemote & setWorkflowStatusRemote do not bump version or activate locally on failure', async () => {
    const wf = {
      workflowId: 'wf-1',
      workspaceId: 'ws-1',
      title: 'Test Workflow',
      description: 'Desc',
      expectedVersion: 2,
      graph: {
        schema_version: 1,
        nodes: [
          { node_id: 'n1', node_type: 'trigger' as const, title: 'Start', config: {} },
          { node_id: 'n2', node_type: 'terminal' as const, title: 'End', config: {} }
        ],
        edges: [{ from_node_id: 'n1', to_node_id: 'n2' }]
      }
    };

    const fetch503 = vi.fn().mockResolvedValue(
      jsonResponse({ message: 'Workflow engine offline' }, 503)
    );
    const saveFail = await saveWorkflowRemote(wf, {
      token: 'jwt_valid',
      workspaceId: 'ws-1',
      fetchFn: fetch503 as unknown as typeof fetch
    });
    expect(saveFail.ok).toBe(false);
    expect(wf.expectedVersion).toBe(2);

    expect(fetch503).toHaveBeenCalledTimes(1);
    const statusFail = await setWorkflowStatusRemote(
      { workspaceId: 'ws-1', workflowId: 'wf-1', targetStatus: 'active', expectedVersion: 2 },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: fetch503 as unknown as typeof fetch
      }
    );
    expect(statusFail.ok).toBe(false);
    expect(fetch503).toHaveBeenCalledTimes(2);
    expect(wf.expectedVersion).toBe(2);
  });

  it('AI-02 executeVideoAgentStepRemote fails closed without deducting credits when backend is unavailable', async () => {
    const run = planVideoAgent({
      workspaceId: 'ws-1',
      userId: 'usr-1',
      prompt: 'Video giới thiệu serum vitamin C'
    });
    const fetch404 = vi.fn().mockResolvedValue(jsonResponse({ message: 'Not Found' }, 404));

    const failRes = await executeVideoAgentStepRemote(run, 0, 'editor', 150, {
      token: 'jwt_valid',
      workspaceId: 'ws-1',
      fetchFn: fetch404 as unknown as typeof fetch
    });
    expect(failRes.success).toBe(false);
    expect(failRes.run.creditsUsed).toBe(0);
    expect(failRes.run.steps[0].status).toBe('planning');
  });

  it('R04 applyOperationalRepairRemote fails closed without fabricating official provenance or ledger posting ID', async () => {
    const outcomes = getInitialUnreconciledOutcomes('ws-1');
    const fetch503 = vi.fn().mockResolvedValue(
      jsonResponse({ message: 'Ledger service unavailable' }, 503)
    );

    const failRes = await applyOperationalRepairRemote(
      outcomes,
      {
        workspaceId: 'ws-1',
        unreconciledId: outcomes[2].id,
        repairType: 'reconcile_stock_adjustment',
        auditReason: 'Bổ sung chứng từ kiểm kê kho định kỳ',
        actorId: 'usr-owner-1',
        actorRole: 'owner'
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: fetch503 as unknown as typeof fetch
      }
    );

    expect(failRes.ok).toBe(false);
    expect(failRes.updatedOutcomes[2].resolved).toBe(false);
    expect(failRes.updatedOutcomes[2].sourceClass).toBe('unreconciled');
    expect(failRes.result).toBeUndefined();
  });

  it('R7-04 Developer Public API client uses canonical creativanta.platform.v1 services and proto field names', async () => {
    developerStore.reset();
    const calledUrls: string[] = [];

    const createFetch = vi.fn(async (url: string) => {
      calledUrls.push(String(url));
      return jsonResponse({
        api_key: {
          api_key_id: 'key_platform_01',
          workspace_id: 'ws-1',
          key_prefix: 'ca_live_ab',
          name: 'Platform Key',
          scopes: ['read:content', 'write:content'],
          status: 'API_KEY_STATUS_ACTIVE',
          logical_key_id: 'logical_01'
        },
        secret_key: 'ca_live_ab_real_secret_key_value'
      });
    });

    const createRes = await issueApiKeyRemote(
      {
        workspaceId: 'ws-1',
        tier: 'pro',
        activeKeysCount: 0,
        name: 'Platform Key',
        scopes: ['read:content', 'write:content']
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: createFetch as unknown as typeof fetch
      }
    );
    expect(createRes.ok).toBe(true);
    expect(createRes.rawSecret).toBe('ca_live_ab_real_secret_key_value');
    expect(createRes.key?.status).toBe('active');
    expect(calledUrls[0]).toContain('/creativanta.platform.v1.APIKeyService/Create');

    const rotateFetch = vi.fn(async (url: string) => {
      calledUrls.push(String(url));
      return jsonResponse({
        old_key: {
          api_key_id: 'key_platform_01',
          status: 'API_KEY_STATUS_ROTATING',
          grace_ends_at: '2026-11-07T21:00:00Z'
        },
        new_key: {
          api_key_id: 'key_platform_02',
          workspace_id: 'ws-1',
          key_prefix: 'ca_live_cd',
          name: 'Platform Key',
          scopes: ['read:content', 'write:content'],
          status: 'API_KEY_STATUS_ACTIVE',
          logical_key_id: 'logical_01'
        },
        new_secret_key: 'ca_live_cd_rotated_secret_key',
        grace_ends_at: '2026-11-07T21:00:00Z'
      });
    });

    const rotateRes = await rotateApiKeyRemote(
      { workspaceId: 'ws-1', apiKeyId: 'key_platform_01' },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: rotateFetch as unknown as typeof fetch
      }
    );
    expect(rotateRes.ok).toBe(true);
    expect(rotateRes.newSecret).toBe('ca_live_cd_rotated_secret_key');
    expect(rotateRes.graceEndsAt).toBe('2026-11-07T21:00:00Z');
    expect(calledUrls[1]).toContain('/creativanta.platform.v1.APIKeyService/Rotate');

    const stateAfterRotate = get(developerStore);
    expect(stateAfterRotate.keys.find((k) => k.apiKeyId === 'key_platform_01')?.status).toBe(
      'rotating'
    );
    expect(stateAfterRotate.keys.find((k) => k.apiKeyId === 'key_platform_02')?.status).toBe(
      'active'
    );

    const revokeFetch = vi.fn(async (url: string) => {
      calledUrls.push(String(url));
      return jsonResponse({
        api_key: {
          api_key_id: 'key_platform_02',
          status: 'API_KEY_STATUS_REVOKED'
        }
      });
    });

    const revokeRes = await revokeApiKeyRemote(
      { workspaceId: 'ws-1', apiKeyId: 'key_platform_02' },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: revokeFetch as unknown as typeof fetch
      }
    );
    expect(revokeRes.ok).toBe(true);
    expect(calledUrls[2]).toContain('/creativanta.platform.v1.APIKeyService/Revoke');

    const webhookFetch = vi.fn(async (url: string) => {
      calledUrls.push(String(url));
      return jsonResponse({
        subscription: {
          webhook_subscription_id: 'whsub_platform_01',
          workspace_id: 'ws-1',
          target_url: 'https://hooks.creativanta.vn/events',
          event_types: ['order.created', 'workflow.completed'],
          status: 'WEBHOOK_SUBSCRIPTION_STATUS_ACTIVE'
        },
        signing_secret: 'whsec_platform_signing_secret_01'
      });
    });

    const whRes = await registerWebhookRemote(
      {
        workspaceId: 'ws-1',
        targetUrl: 'https://hooks.creativanta.vn/events',
        eventTypes: ['order.created', 'workflow.completed']
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: webhookFetch as unknown as typeof fetch
      }
    );
    expect(whRes.ok).toBe(true);
    expect(whRes.subscription?.subscriptionId).toBe('whsub_platform_01');
    expect(whRes.subscription?.status).toBe('active');
    expect(whRes.secret).toBe('whsec_platform_signing_secret_01');
    expect(calledUrls[3]).toContain(
      '/creativanta.platform.v1.WebhookSubscriptionService/CreateWebhookSubscription'
    );
  });

  it('R7-05 Workflow editor round-trips action_chain & trigger_config and calls Deactivate on pause', async () => {
    const requests: Array<{ url: string; body: any }> = [];

    // 1. Load workflow from proto shape (action_chain + trigger_config + proto enums)
    const loadFetch = vi.fn(async (url: string, init?: RequestInit) => {
      requests.push({ url: String(url), body: init?.body ? JSON.parse(String(init.body)) : null });
      return jsonResponse({
        workflow: {
          workflow_id: 'wf-roundtrip-1',
          workspace_id: 'ws-1',
          title: 'VIP Order Flow',
          description: 'Proto-backed graph',
          status: 'WORKFLOW_STATUS_ACTIVE',
          version: 3,
          trigger_config: {
            type: 'TRIGGER_TYPE_EVENT',
            event_type: 'commerce.order.created'
          },
          action_chain: {
            schema_version: 1,
            nodes: [
              {
                node_id: 'n-trig',
                node_type: 'NODE_TYPE_TRIGGER',
                title: 'Order Trigger',
                trigger_config: {
                  config: {
                    type: 'TRIGGER_TYPE_EVENT',
                    event_type: 'commerce.order.created'
                  }
                }
              },
              {
                node_id: 'n-act',
                node_type: 'NODE_TYPE_ACTION',
                title: 'Notify Ops',
                action_config: {
                  rpc_name: 'creativanta.commerce.v1.OrderService/FulfillOrder',
                  input_json: '{"priority":"high"}',
                  timeout_seconds: 30
                }
              },
              {
                node_id: 'n-term',
                node_type: 'NODE_TYPE_TERMINAL',
                title: 'Done',
                terminal_config: {
                  outcome: 'succeeded'
                }
              }
            ],
            edges: [
              { from_node_id: 'n-trig', to_node_id: 'n-act', branch: 'EDGE_BRANCH_SUCCESS' },
              { from_node_id: 'n-act', to_node_id: 'n-term', branch: 'EDGE_BRANCH_SUCCESS' }
            ]
          }
        }
      });
    });

    const loaded = await loadWorkflowRemote(
      { workspaceId: 'ws-1', workflowId: 'wf-roundtrip-1' },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: loadFetch as unknown as typeof fetch
      }
    );
    expect(loaded.ok).toBe(true);
    expect(loaded.workflow?.status).toBe('active');
    expect(loaded.workflow?.version).toBe(3);
    expect(loaded.workflow?.graph?.nodes).toHaveLength(3);
    expect(loaded.workflow?.graph?.nodes[0].node_type).toBe('trigger');
    expect(loaded.workflow?.graph?.nodes[1].action_config?.rpc_name).toBe(
      'creativanta.commerce.v1.OrderService/FulfillOrder'
    );

    // 2. Edit node title & save via WorkflowService/Update -> verify action_chain and trigger_config are sent
    const editedGraph = structuredClone(loaded.workflow!.graph!);
    editedGraph.nodes[1].title = 'Notify VIP Ops Team';

    const saveFetch = vi.fn(async (url: string, init?: RequestInit) => {
      const parsedBody = init?.body ? JSON.parse(String(init.body)) : null;
      requests.push({ url: String(url), body: parsedBody });
      return jsonResponse({
        workflow: {
          workflow_id: 'wf-roundtrip-1',
          version: 4,
          status: 'WORKFLOW_STATUS_ACTIVE'
        }
      });
    });

    const saved = await saveWorkflowRemote(
      {
        workspaceId: 'ws-1',
        workflowId: 'wf-roundtrip-1',
        title: 'VIP Order Flow Updated',
        description: 'Proto-backed graph',
        expectedVersion: 3,
        graph: editedGraph
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: saveFetch as unknown as typeof fetch
      }
    );
    expect(saved.ok).toBe(true);
    expect(saved.version).toBe(4);
    expect(saved.status).toBe('active');
    const updateBody = requests[1].body;
    expect(updateBody.action_chain).toBeDefined();
    expect(updateBody.action_chain.nodes).toHaveLength(3);
    expect(updateBody.action_chain.nodes[1].title).toBe('Notify VIP Ops Team');
    expect(updateBody.action_chain.nodes[1].node_type).toBe('NODE_TYPE_ACTION');
    expect(updateBody.trigger_config.type).toBe('TRIGGER_TYPE_EVENT');

    // 3. Pause workflow -> must call WorkflowService/Deactivate and normalize WORKFLOW_STATUS_PAUSED -> 'paused'
    const pauseFetch = vi.fn(async (url: string, init?: RequestInit) => {
      requests.push({ url: String(url), body: init?.body ? JSON.parse(String(init.body)) : null });
      return jsonResponse({
        workflow: {
          workflow_id: 'wf-roundtrip-1',
          version: 5,
          status: 'WORKFLOW_STATUS_PAUSED'
        }
      });
    });

    const paused = await setWorkflowStatusRemote(
      {
        workspaceId: 'ws-1',
        workflowId: 'wf-roundtrip-1',
        targetStatus: 'paused',
        expectedVersion: 4
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: pauseFetch as unknown as typeof fetch
      }
    );
    expect(paused.ok).toBe(true);
    expect(paused.status).toBe('paused');
    expect(paused.version).toBe(5);
    expect(requests[2].url).toContain('/creativanta.automation.v1.WorkflowService/Deactivate');
  });

  it('R7-06 Image-to-Video acquires bounded quote (dry_run) and sends canonical GenerateRequest with image_to_video_config', async () => {
    const capturedCalls: Array<{ url: string; body: any }> = [];

    const twoStepFetch = vi.fn(async (url: string, init?: RequestInit) => {
      const body = init?.body ? JSON.parse(String(init.body)) : {};
      capturedCalls.push({ url: String(url), body });
      if (body.dry_run === true) {
        return jsonResponse({
          is_dry_run: true,
          budget_preview: {
            quote_id: 'quote_server_i2v_99',
            quote_expires_at: '2026-11-06T22:00:00Z',
            total_estimated_credits: '80',
            available_credits: '450',
            sufficient_credits: true
          }
        });
      }
      return jsonResponse({
        is_dry_run: false,
        job: {
          job_id: 'job_i2v_confirmed_01',
          estimated_credits: '80',
          quote_id: body.quote_id,
          status: 'processing'
        }
      });
    });

    const res = await requestImageToVideoGenerationRemote(
      {
        workspaceId: 'ws-1',
        title: 'Lookbook Thu Đông',
        images: [
          {
            id: 'img-a',
            url: 'https://cdn.creativanta.vn/look1.jpg',
            name: 'look1.jpg',
            durationSeconds: 4,
            customMotionStyle: 'parallax_3d'
          }
        ],
        selectedMotionStyleId: 'cinematic_pan',
        motionIntensity: 70,
        aspectRatio: '9:16',
        selectedTransitionId: 'morph',
        customPrompt: 'Chuyển động 3D mượt mà cho bộ sưu tập thu đông',
        quoteCredits: 80,
        availableBalance: 450,
        requirePreflightQuote: true
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: twoStepFetch as unknown as typeof fetch
      }
    );

    expect(res.ok).toBe(true);
    expect(res.jobId).toBe('job_i2v_confirmed_01');
    expect(res.quoteId).toBe('quote_server_i2v_99');
    expect(res.reservedCredits).toBe(80);
    expect(res.remainingBalance).toBe(370);
    expect(capturedCalls).toHaveLength(2);

    // Verify dry_run preflight request
    expect(capturedCalls[0].body.dry_run).toBe(true);
    expect(capturedCalls[0].body.mode).toBe('PRODUCTION_MODE_IMAGE_TO_VIDEO');
    expect(capturedCalls[0].body.context.workspace_id.value).toBe('ws-1');
    expect(capturedCalls[0].body.image_to_video_config.image_urls).toEqual([
      'https://cdn.creativanta.vn/look1.jpg'
    ]);
    expect(capturedCalls[0].body.image_to_video_config.per_image_settings[0].motion_style).toBe(
      'IMAGE_MOTION_STYLE_PARALLAX_3D'
    );

    // Verify live Generate request uses server-issued quote_id & confirmed_credits
    expect(capturedCalls[1].body.dry_run).toBe(false);
    expect(capturedCalls[1].body.quote_id).toBe('quote_server_i2v_99');
    expect(capturedCalls[1].body.confirmed_credits).toBe('80');
    expect(capturedCalls[1].body.post_production.aspect_ratio).toBe('9:16');

    // Negative: server reports insufficient_credits in dry_run -> fails closed without calling live Generate
    const insufficientFetch = vi.fn(async () =>
      jsonResponse({
        is_dry_run: true,
        budget_preview: {
          quote_id: 'quote_insufficient_01',
          total_estimated_credits: '80',
          available_credits: '10',
          sufficient_credits: false
        }
      })
    );
    const failQuote = await requestImageToVideoQuoteRemote(
      {
        workspaceId: 'ws-1',
        images: [
          {
            id: 'img-a',
            url: 'https://cdn.creativanta.vn/look1.jpg',
            name: 'look1.jpg',
            durationSeconds: 4
          }
        ],
        selectedMotionStyleId: 'cinematic_pan',
        motionIntensity: 70,
        aspectRatio: '9:16',
        selectedTransitionId: 'morph',
        quoteCredits: 80,
        availableBalance: 450
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: insufficientFetch as unknown as typeof fetch
      }
    );
    expect(failQuote.ok).toBe(false);
    expect(failQuote.sufficientCredits).toBe(false);
  });

  it('R7-07 StudioService/Cancel and StudioService/Retry fail closed on backend error and confirm refund only from server', async () => {
    const fetch503 = vi.fn().mockResolvedValue(
      jsonResponse({ message: 'Studio service unavailable' }, 503)
    );

    const cancelFail = await cancelStudioJobRemote(
      { workspaceId: 'ws-1', jobId: 'job-q-101' },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: fetch503 as unknown as typeof fetch
      }
    );
    expect(cancelFail.ok).toBe(false);
    expect(cancelFail.creditsRefunded).toBeUndefined();

    const cancelOkFetch = vi.fn(async (url: string, init?: RequestInit) => {
      const body = init?.body ? JSON.parse(String(init.body)) : {};
      expect(url).toContain('/creativanta.production.v1.StudioService/Cancel');
      expect(body.context.workspace_id.value).toBe('ws-1');
      expect(body.job_id).toBe('job-q-101');
      return jsonResponse({
        job: {
          job_id: 'job-q-101',
          status: 'cancelled'
        },
        credits_refunded: true,
        refunded_credits: '80'
      });
    });

    const cancelOk = await cancelStudioJobRemote(
      { workspaceId: 'ws-1', jobId: 'job-q-101' },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: cancelOkFetch as unknown as typeof fetch
      }
    );
    expect(cancelOk.ok).toBe(true);
    expect(cancelOk.creditsRefunded).toBe(true);
    expect(cancelOk.refundedCredits).toBe(80);

    const retryFail = await retryStudioJobRemote(
      { workspaceId: 'ws-1', jobId: 'job-q-103' },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: fetch503 as unknown as typeof fetch
      }
    );
    expect(retryFail.ok).toBe(false);

    const retryOkFetch = vi.fn(async (url: string, init?: RequestInit) => {
      const body = init?.body ? JSON.parse(String(init.body)) : {};
      expect(url).toContain('/creativanta.production.v1.StudioService/Retry');
      expect(body.use_fallback_provider).toBe(true);
      return jsonResponse({
        job: {
          job_id: 'job-q-103',
          status: 'processing',
          provider: 'kling',
          current_step: 'Retrying on Kling fallback',
          progress_pct: 15
        },
        message: 'Retrying job on Kling fallback provider'
      });
    });

    const retryOk = await retryStudioJobRemote(
      { workspaceId: 'ws-1', jobId: 'job-q-103', useFallbackProvider: true },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: retryOkFetch as unknown as typeof fetch
      }
    );
    expect(retryOk.ok).toBe(true);
    expect(retryOk.provider).toBe('kling');
    expect(retryOk.status).toBe('processing');
  });

  it('R7-10 All 6 canonical legal footer links resolve to engineering-approved legal documents with LEG-H-001 metadata', () => {
    expect(CANONICAL_LEGAL_LINKS).toHaveLength(6);
    for (const link of CANONICAL_LEGAL_LINKS) {
      expect(link.href.startsWith('/legal/')).toBe(true);
      const slug = link.href.replace('/legal/', '');
      const doc = getLegalDocumentBySlug(slug);
      expect(doc).not.toBeNull();
      expect(doc?.href).toBe(link.href);
      expect(doc?.blockerRef).toBe('LEG-H-001');
      expect(doc?.sections.length).toBeGreaterThanOrEqual(2);
    }
    expect(getLegalDocumentBySlug('non-existent-policy')).toBeNull();
  });

  it('S8-F1 Image-to-Video refuses to auto-approve a server credit quote higher than the user-consented quote', async () => {
    const capturedCalls: Array<{ url: string; body: any }> = [];

    const quoteHigherFetch = vi.fn(async (url: string, init?: RequestInit) => {
      const body = init?.body ? JSON.parse(String(init.body)) : {};
      capturedCalls.push({ url: String(url), body });
      if (body.dry_run === true) {
        return jsonResponse({
          is_dry_run: true,
          budget_preview: {
            quote_id: 'quote_server_expensive_80',
            quote_expires_at: '2026-11-07T22:00:00Z',
            total_estimated_credits: '80',
            current_available_credits: '320',
            sufficient_credits: true
          }
        });
      }
      return jsonResponse({
        is_dry_run: false,
        job: {
          job_id: 'job_i2v_after_consent_01',
          estimated_credits: '80',
          quote_id: body.quote_id,
          status: 'processing'
        }
      });
    });

    // User saw local estimate of 10 credits; server dry_run quote returns 80 credits.
    // Must stop after dry_run and require explicit confirmation without dispatching live Generate.
    const initialAttempt = await requestImageToVideoGenerationRemote(
      {
        workspaceId: 'ws-1',
        title: 'Standard 10cr Button Click',
        images: [
          {
            id: 'img-1',
            url: 'https://cdn.creativanta.vn/sneaker.jpg',
            name: 'sneaker.jpg',
            durationSeconds: 4,
            customMotionStyle: 'parallax_3d'
          }
        ],
        selectedMotionStyleId: 'parallax_3d',
        motionIntensity: 75,
        aspectRatio: '9:16',
        selectedTransitionId: 'crossfade',
        quoteCredits: 10,
        availableBalance: 320,
        requirePreflightQuote: true
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: quoteHigherFetch as unknown as typeof fetch
      }
    );

    expect(initialAttempt.ok).toBe(false);
    expect(initialAttempt.requiresConfirmation).toBe(true);
    expect(initialAttempt.quoteId).toBe('quote_server_expensive_80');
    expect(initialAttempt.quotedCredits).toBe('80');
    expect(initialAttempt.jobId).toBeUndefined();
    // Crucial: Only the dry_run request was sent; live Generate was NOT called!
    expect(capturedCalls).toHaveLength(1);
    expect(capturedCalls[0].body.dry_run).toBe(true);

    // Step 2: Only after user explicitly confirms 80 credits with the returned quoteId does live Generate execute
    const confirmedAttempt = await requestImageToVideoGenerationRemote(
      {
        workspaceId: 'ws-1',
        title: 'Standard 10cr Button Click',
        images: [
          {
            id: 'img-1',
            url: 'https://cdn.creativanta.vn/sneaker.jpg',
            name: 'sneaker.jpg',
            durationSeconds: 4,
            customMotionStyle: 'parallax_3d'
          }
        ],
        selectedMotionStyleId: 'parallax_3d',
        motionIntensity: 75,
        aspectRatio: '9:16',
        selectedTransitionId: 'crossfade',
        quoteCredits: 80,
        confirmedCredits: '80',
        quoteId: initialAttempt.quoteId,
        availableBalance: 320,
        requirePreflightQuote: false
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: quoteHigherFetch as unknown as typeof fetch
      }
    );

    expect(confirmedAttempt.ok).toBe(true);
    expect(confirmedAttempt.jobId).toBe('job_i2v_after_consent_01');
    expect(confirmedAttempt.reservedCredits).toBe(80);
    expect(capturedCalls).toHaveLength(2);
    expect(capturedCalls[1].body.dry_run).toBe(false);
    expect(capturedCalls[1].body.quote_id).toBe('quote_server_expensive_80');
    expect(capturedCalls[1].body.confirmed_credits).toBe('80');
  });

  it('S8-F2 Workflow editor session blocks Save/Activate before load or after load failure, reloads on delayed discovery, and discards stale tenant responses', async () => {
    const rpcCalls: Array<{ url: string; body: any; workspaceHeader?: string | null }> = [];
    const session = createWorkflowEditorSession('wf-prod-v3');

    // 1. Initial state before auth/discovery is ready: no default fixture graph or version 3 loaded, mutations blocked
    expect(session.getSnapshot().loadState).toBe('waiting_context');
    expect(session.getSnapshot().nodes).toHaveLength(0);
    expect(session.getSnapshot().version).toBeNull();

    const prematureSave = await session.save({
      token: 'jwt_valid',
      fetchFn: vi.fn() as unknown as typeof fetch
    });
    expect(prematureSave.ok).toBe(false);

    // 2. Load failure (e.g., 503 or 403): session enters error state, keeps nodes empty, and blocks Save/Activate
    const failFetch = vi.fn(async (url: string, init?: RequestInit) => {
      rpcCalls.push({ url: String(url), body: init?.body ? JSON.parse(String(init.body)) : null });
      return jsonResponse({ code: 'permission_denied', message: 'Forbidden' }, 403);
    });

    const loadFailRes = await session.syncContext(
      { userId: 'usr-1', workspaceId: 'ws-1', workflowId: 'wf-prod-v3' },
      { token: 'jwt_valid', workspaceId: 'ws-1', fetchFn: failFetch as unknown as typeof fetch }
    );
    expect(loadFailRes.ok).toBe(false);
    expect(session.getSnapshot().loadState).toBe('error');
    expect(session.getSnapshot().nodes).toHaveLength(0);

    const saveAfterErrorFetch = vi.fn();
    const saveAfterError = await session.save({
      token: 'jwt_valid',
      workspaceId: 'ws-1',
      fetchFn: saveAfterErrorFetch as unknown as typeof fetch
    });
    expect(saveAfterError.ok).toBe(false);
    expect(saveAfterErrorFetch).not.toHaveBeenCalled();

    const activateAfterError = await session.setStatus('active', {
      token: 'jwt_valid',
      workspaceId: 'ws-1',
      fetchFn: saveAfterErrorFetch as unknown as typeof fetch
    });
    expect(activateAfterError.ok).toBe(false);
    expect(saveAfterErrorFetch).not.toHaveBeenCalled();

    // 3. Stale response from tenant A is discarded if user switches to tenant B while load is in flight
    let resolveTenantA!: (value: Response) => void;
    const tenantAFetch = vi.fn(
      () =>
        new Promise<Response>((resolve) => {
          resolveTenantA = resolve;
        })
    );
    const tenantBFetch = vi.fn(async () =>
      jsonResponse({
        workflow: {
          workflow_id: 'wf-prod-v3',
          workspace_id: 'ws-tenant-B',
          title: 'Tenant B Authoritative Workflow',
          description: 'Loaded from Tenant B',
          status: 'WORKFLOW_STATUS_DRAFT',
          version: 7,
          trigger_config: { type: 'TRIGGER_TYPE_EVENT', event_type: 'order.created' },
          action_chain: {
            schema_version: 1,
            nodes: [
              {
                node_id: 'trig-b',
                node_type: 'NODE_TYPE_TRIGGER',
                title: 'Tenant B Trigger',
                trigger_config: { config: { type: 'TRIGGER_TYPE_EVENT', event_type: 'order.created' } }
              },
              {
                node_id: 'term-b',
                node_type: 'NODE_TYPE_TERMINAL',
                title: 'Tenant B End',
                terminal_config: { outcome: 'succeeded' }
              }
            ],
            edges: [{ from_node_id: 'trig-b', to_node_id: 'term-b' }]
          }
        }
      })
    );

    const pendingA = session.syncContext(
      { userId: 'usr-1', workspaceId: 'ws-tenant-A', workflowId: 'wf-prod-v3', force: true },
      { token: 'jwt_a', workspaceId: 'ws-tenant-A', fetchFn: tenantAFetch as unknown as typeof fetch }
    );

    const completedB = await session.syncContext(
      { userId: 'usr-1', workspaceId: 'ws-tenant-B', workflowId: 'wf-prod-v3' },
      { token: 'jwt_b', workspaceId: 'ws-tenant-B', fetchFn: tenantBFetch as unknown as typeof fetch }
    );
    expect(completedB.ok).toBe(true);
    expect(session.getSnapshot().loadState).toBe('loaded');
    expect(session.getSnapshot().title).toBe('Tenant B Authoritative Workflow');
    expect(session.getSnapshot().version).toBe(7);

    // Now resolve stale Tenant A response -> must NOT overwrite Tenant B state
    resolveTenantA(
      jsonResponse({
        workflow: {
          workflow_id: 'wf-prod-v3',
          workspace_id: 'ws-tenant-A',
          title: 'Stale Tenant A Workflow',
          status: 'WORKFLOW_STATUS_ACTIVE',
          version: 3,
          action_chain: {
            schema_version: 1,
            nodes: [
              { node_id: 'trig-a', node_type: 'NODE_TYPE_TRIGGER', title: 'A' },
              { node_id: 'term-a', node_type: 'NODE_TYPE_TERMINAL', title: 'A End' }
            ],
            edges: [{ from_node_id: 'trig-a', to_node_id: 'term-a' }]
          }
        }
      })
    );
    await pendingA;

    expect(session.getSnapshot().title).toBe('Tenant B Authoritative Workflow');
    expect(session.getSnapshot().version).toBe(7);
    expect(session.getSnapshot().nodes[0].node_id).toBe('trig-b');
  });

  it('S8-ResetGuard In-flight Developer and Support RPC responses do not upsert into stores after auth/workspace reset', async () => {
    developerStore.reset();
    supportStore.reset();

    let resolveKeyRpc!: (value: Response) => void;
    let resolveTicketRpc!: (value: Response) => void;

    const slowKeyFetch = vi.fn(
      () =>
        new Promise<Response>((resolve) => {
          resolveKeyRpc = resolve;
        })
    );
    const slowTicketFetch = vi.fn(
      () =>
        new Promise<Response>((resolve) => {
          resolveTicketRpc = resolve;
        })
    );

    const keyPromise = issueApiKeyRemote(
      {
        workspaceId: 'ws-old',
        tier: 'pro',
        activeKeysCount: 0,
        name: 'Pre-Logout Key',
        scopes: ['read:content']
      },
      {
        token: 'jwt_old',
        workspaceId: 'ws-old',
        fetchFn: slowKeyFetch as unknown as typeof fetch
      }
    );

    const ticketPromise = submitSupportTicketRemote(
      {
        workspaceId: 'ws-old',
        planTier: 'pro',
        subject: 'Pre-Logout Ticket',
        priority: 'high',
        initialMessage: 'Confidential workspace issue'
      },
      {
        token: 'jwt_old',
        workspaceId: 'ws-old',
        fetchFn: slowTicketFetch as unknown as typeof fetch
      }
    );

    // Simulate logout / workspace switch reset before responses arrive
    developerStore.reset();
    supportStore.reset();

    resolveKeyRpc(
      jsonResponse({
        apiKey: {
          apiKeyId: 'ak_stale_old_tenant',
          workspaceId: 'ws-old',
          keyPrefix: 'ca_live_ol',
          name: 'Pre-Logout Key',
          scopes: ['read:content'],
          status: 'API_KEY_STATUS_ACTIVE'
        },
        secretKey: 'ca_live_old_tenant_secret'
      })
    );
    resolveTicketRpc(
      jsonResponse({
        ticket: {
          ticket_id: 'tk_stale_old_tenant',
          ticket_number: '#TK-99999',
          subject: 'Pre-Logout Ticket',
          priority: 'high',
          status: 'open'
        }
      })
    );

    await Promise.all([keyPromise, ticketPromise]);

    expect(get(developerStore).keys).toHaveLength(0);
    expect(get(supportStore.tickets)).toHaveLength(0);
  });

  it('T8-F5 Workflow editor preserves unsaved draft during same-tenant re-discovery while locking save, and purges draft on tenant change or revocation', async () => {
    const session = createWorkflowEditorSession('wf-prod-v3');
    let loadCalls = 0;

    const loadFetch = vi.fn(async () => {
      loadCalls += 1;
      return jsonResponse({
        workflow: {
          workflow_id: 'wf-prod-v3',
          workspace_id: 'ws-1',
          title: 'Server Title v3',
          description: 'Server Description',
          status: 'WORKFLOW_STATUS_DRAFT',
          version: 3,
          trigger_config: { type: 'TRIGGER_TYPE_EVENT', event_type: 'order.created' },
          action_chain: {
            schema_version: 1,
            nodes: [
              {
                node_id: 'trig-1',
                node_type: 'NODE_TYPE_TRIGGER',
                title: 'Order Created',
                trigger_config: { config: { type: 'TRIGGER_TYPE_EVENT', event_type: 'order.created' } }
              },
              {
                node_id: 'term-1',
                node_type: 'NODE_TYPE_TERMINAL',
                title: 'Done',
                terminal_config: { outcome: 'succeeded' }
              }
            ],
            edges: [{ from_node_id: 'trig-1', to_node_id: 'term-1' }]
          }
        }
      });
    });

    // 1. Initial load succeeds
    const initialLoad = await session.syncContext(
      {
        userId: 'usr-1',
        workspaceId: 'ws-1',
        workflowId: 'wf-prod-v3',
        authState: 'authenticated',
        isDiscoveryLoading: false
      },
      { token: 'jwt_1', workspaceId: 'ws-1', fetchFn: loadFetch as unknown as typeof fetch }
    );
    expect(initialLoad.ok).toBe(true);
    expect(loadCalls).toBe(1);

    // 2. User edits title, description, and graph without saving yet
    session.setMeta({
      title: 'Unsaved Draft Title',
      description: 'Unsaved Draft Description'
    });
    const editedNodes = [
      ...session.getSnapshot().nodes,
      {
        node_id: 'act-unsaved-1',
        node_type: 'action' as const,
        title: 'Unsaved Action Node',
        action_config: {
          rpc_name: 'creativanta.commerce.v1.InventoryService/CheckStock',
          input_json: '{}'
        }
      }
    ];
    session.setGraph({
      nodes: editedNodes,
      edges: session.getSnapshot().edges
    });

    // 3. Same-session re-discovery starts (e.g. Clerk listener refreshes token & re-runs discovery)
    const reverifyStart = await session.syncContext(
      {
        userId: 'usr-1',
        workspaceId: 'ws-1',
        workflowId: 'wf-prod-v3',
        authState: 'authenticated',
        isDiscoveryLoading: true
      },
      { token: 'jwt_2', workspaceId: 'ws-1', fetchFn: loadFetch as unknown as typeof fetch }
    );
    expect(reverifyStart.ok).toBe(false);
    // Draft MUST still be preserved while re-verifying
    expect(session.getSnapshot().title).toBe('Unsaved Draft Title');
    expect(session.getSnapshot().description).toBe('Unsaved Draft Description');
    expect(session.getSnapshot().nodes).toHaveLength(3);
    expect((session.getSnapshot() as any).isReverifying).toBe(true);

    // Mutations must be temporarily locked during re-verification
    const blockedSaveFetch = vi.fn();
    const saveWhileReverifying = await session.save({
      token: 'jwt_2',
      workspaceId: 'ws-1',
      fetchFn: blockedSaveFetch as unknown as typeof fetch
    });
    expect(saveWhileReverifying.ok).toBe(false);
    expect(blockedSaveFetch).not.toHaveBeenCalled();

    // 4. Discovery finishes for the SAME (userId, workspaceId, workflowId) -> draft remains intact without re-fetching
    const reverifyDone = await session.syncContext(
      {
        userId: 'usr-1',
        workspaceId: 'ws-1',
        workflowId: 'wf-prod-v3',
        authState: 'authenticated',
        isDiscoveryLoading: false
      },
      { token: 'jwt_2', workspaceId: 'ws-1', fetchFn: loadFetch as unknown as typeof fetch }
    );
    expect(reverifyDone.ok).toBe(true);
    expect(loadCalls).toBe(1);
    expect((session.getSnapshot() as any).isReverifying).toBe(false);
    expect(session.getSnapshot().title).toBe('Unsaved Draft Title');
    expect(session.getSnapshot().description).toBe('Unsaved Draft Description');
    expect(session.getSnapshot().nodes).toHaveLength(3);

    // 5. Negative isolation: if discovery finishes with revoked membership (workspaceId: null, isDiscoveryLoading: false), draft is purged
    await session.syncContext({
      userId: 'usr-1',
      workspaceId: null,
      workflowId: 'wf-prod-v3',
      authState: 'authenticated',
      isDiscoveryLoading: false
    });
    expect(session.getSnapshot().loadState).toBe('waiting_context');
    expect(session.getSnapshot().title).toBe('');
    expect(session.getSnapshot().version).toBeNull();
    expect(session.getSnapshot().nodes).toHaveLength(0);
  });

  it('T8-F4 Revealed API and webhook secrets are bound to issuing user+workspace and wiped on logout, expiry, user switch, or workspace switch', async () => {
    developerStore.reset();
    const createFetch = vi.fn(async () =>
      jsonResponse({
        apiKey: {
          apiKeyId: 'ak_f4_01',
          workspaceId: 'ws-1',
          keyPrefix: 'ca_live_f4',
          name: 'F4 Secret Key',
          scopes: ['read:content'],
          status: 4, // API_KEY_STATUS_REVOKED in proto enum
          logicalKeyId: 'lk_f4_01'
        },
        secretKey: 'ca_live_f4_once_only_secret'
      })
    );

    const res = await issueApiKeyRemote(
      {
        userId: 'usr-1',
        workspaceId: 'ws-1',
        tier: 'pro',
        activeKeysCount: 0,
        name: 'F4 Secret Key',
        scopes: ['read:content']
      } as any,
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: createFetch as unknown as typeof fetch
      }
    );
    expect(res.ok).toBe(true);
    expect(res.key?.status).toBe('revoked');

    // Revealed secret is visible for the issuing (usr-1, ws-1) authenticated session
    expect(
      (developerStore as any).getVisibleKeySecret({
        state: 'authenticated',
        userId: 'usr-1',
        workspaceId: 'ws-1'
      })
    ).toBe('ca_live_f4_once_only_secret');

    // Different user or different workspace or unauthenticated cannot read the secret
    expect(
      (developerStore as any).getVisibleKeySecret({
        state: 'authenticated',
        userId: 'usr-2',
        workspaceId: 'ws-1'
      })
    ).toBe('');
    expect(
      (developerStore as any).getVisibleKeySecret({
        state: 'authenticated',
        userId: 'usr-1',
        workspaceId: 'ws-2'
      })
    ).toBe('');
    expect(
      (developerStore as any).getVisibleKeySecret({
        state: 'unauthenticated',
        userId: null,
        workspaceId: null
      })
    ).toBe('');

    // Syncing an unauthenticated/expired or different session wipes the stored revealed secret permanently
    (developerStore as any).syncSessionContext({
      state: 'unauthenticated',
      userId: null,
      workspaceId: null
    });
    expect(
      (developerStore as any).getVisibleKeySecret({
        state: 'authenticated',
        userId: 'usr-1',
        workspaceId: 'ws-1'
      })
    ).toBe('');
  });

  it('T8-F1 Image-to-Video rejects expired server quotes, rejects under-confirmed credits, and forwards qualityTier/loop/duration/bgm', async () => {
    const unexpectedLiveFetch = vi.fn();

    // 1. Expired quote is rejected before any live Generate RPC is sent
    const expiredAttempt = await requestImageToVideoGenerationRemote(
      {
        workspaceId: 'ws-1',
        images: [
          {
            id: 'img-1',
            url: 'https://cdn.creativanta.vn/sneaker.jpg',
            name: 'sneaker.jpg',
            durationSeconds: 4
          }
        ],
        selectedMotionStyleId: 'parallax_3d',
        motionIntensity: 75,
        aspectRatio: '9:16',
        selectedTransitionId: 'crossfade',
        qualityTier: 'premium',
        isLoop: true,
        durationSeconds: 15,
        attachBgm: false,
        quoteCredits: 30,
        confirmedCredits: '30',
        quoteId: 'quote_expired_01',
        quoteExpiresAt: '2020-01-01T00:00:00Z',
        availableBalance: 320,
        requirePreflightQuote: false
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: unexpectedLiveFetch as unknown as typeof fetch
      }
    );
    expect(expiredAttempt.ok).toBe(false);
    expect(expiredAttempt.error).toContain('hết hạn');
    expect(unexpectedLiveFetch).not.toHaveBeenCalled();

    // 2. Under-confirmed credits (< quoteCredits) are rejected before any live Generate RPC is sent
    const underConfirmedAttempt = await requestImageToVideoGenerationRemote(
      {
        workspaceId: 'ws-1',
        images: [
          {
            id: 'img-1',
            url: 'https://cdn.creativanta.vn/sneaker.jpg',
            name: 'sneaker.jpg',
            durationSeconds: 4
          }
        ],
        selectedMotionStyleId: 'parallax_3d',
        motionIntensity: 75,
        aspectRatio: '9:16',
        selectedTransitionId: 'crossfade',
        quoteCredits: 30,
        confirmedCredits: '10',
        quoteId: 'quote_valid_01',
        availableBalance: 320,
        requirePreflightQuote: false
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: unexpectedLiveFetch as unknown as typeof fetch
      }
    );
    expect(underConfirmedAttempt.ok).toBe(false);
    expect(underConfirmedAttempt.requiresConfirmation).toBe(true);
    expect(unexpectedLiveFetch).not.toHaveBeenCalled();

    // 3. Valid confirmation forwards quality_tier, loop_friendly, auto_music_sync, duration_seconds
    const capturedBodies: any[] = [];
    const liveOkFetch = vi.fn(async (_url: string, init?: RequestInit) => {
      const body = init?.body ? JSON.parse(String(init.body)) : {};
      capturedBodies.push(body);
      return jsonResponse({
        job: {
          job_id: 'job_i2v_f1_verified',
          estimated_credits: '30',
          quote_id: body.quote_id,
          status: 'processing'
        }
      });
    });

    const validAttempt = await requestImageToVideoGenerationRemote(
      {
        workspaceId: 'ws-1',
        images: [
          {
            id: 'img-1',
            url: 'https://cdn.creativanta.vn/sneaker.jpg',
            name: 'sneaker.jpg',
            durationSeconds: 4
          }
        ],
        selectedMotionStyleId: 'parallax_3d',
        motionIntensity: 75,
        aspectRatio: '9:16',
        selectedTransitionId: 'crossfade',
        qualityTier: 'premium',
        isLoop: true,
        durationSeconds: 15,
        attachBgm: false,
        quoteCredits: 30,
        confirmedCredits: '30',
        quoteId: 'quote_valid_01',
        quoteExpiresAt: '2099-01-01T00:00:00Z',
        availableBalance: 320,
        requirePreflightQuote: false
      },
      {
        token: 'jwt_valid',
        workspaceId: 'ws-1',
        fetchFn: liveOkFetch as unknown as typeof fetch
      }
    );
    expect(validAttempt.ok).toBe(true);
    expect(capturedBodies).toHaveLength(1);
    expect(capturedBodies[0].image_to_video_config.quality_tier).toBe('premium');
    expect(capturedBodies[0].image_to_video_config.loop_friendly).toBe(true);
    expect(capturedBodies[0].image_to_video_config.auto_music_sync).toBe(false);
    expect(capturedBodies[0].image_to_video_config.duration_seconds).toBe(15);
  });

  it('T8-N2 In-flight workflow Save and Activate started before same-tenant re-discovery preserve updated version (v3 -> v4) while still rejecting cross-tenant responses', async () => {
    const session = createWorkflowEditorSession('wf-prod-v3');
    const loadFetch = vi.fn(async () =>
      jsonResponse({
        workflow: {
          workflow_id: 'wf-prod-v3',
          workspace_id: 'ws-1',
          title: 'Workflow v3',
          description: 'Initial v3',
          status: 'WORKFLOW_STATUS_DRAFT',
          version: 3,
          trigger_config: { type: 'TRIGGER_TYPE_EVENT', event_type: 'order.created' },
          action_chain: {
            schema_version: 1,
            nodes: [
              {
                node_id: 'trig-1',
                node_type: 'NODE_TYPE_TRIGGER',
                title: 'Order Created',
                trigger_config: { config: { type: 'TRIGGER_TYPE_EVENT', event_type: 'order.created' } }
              },
              {
                node_id: 'term-1',
                node_type: 'NODE_TYPE_TERMINAL',
                title: 'Done',
                terminal_config: { outcome: 'succeeded' }
              }
            ],
            edges: [{ from_node_id: 'trig-1', to_node_id: 'term-1' }]
          }
        }
      })
    );

    // 1. Load workflow v3
    await session.syncContext(
      {
        userId: 'usr-1',
        workspaceId: 'ws-1',
        workflowId: 'wf-prod-v3',
        authState: 'authenticated',
        isDiscoveryLoading: false
      },
      { token: 'jwt_1', workspaceId: 'ws-1', fetchFn: loadFetch as unknown as typeof fetch }
    );
    expect(session.getSnapshot().version).toBe(3);

    // 2. Start Save (v3 -> v4), keep response pending
    const sentExpectedVersions: number[] = [];
    let resolveFirstSave!: (value: Response) => void;
    const firstSaveFetch = vi.fn((_url: string, init?: RequestInit) => {
      const parsed = init?.body ? JSON.parse(String(init.body)) : {};
      sentExpectedVersions.push(parsed.expected_version);
      return new Promise<Response>((resolve) => {
        resolveFirstSave = resolve;
      });
    });

    session.setMeta({ title: 'Workflow Edited for v4' });
    const pendingFirstSave = session.save({
      token: 'jwt_1',
      workspaceId: 'ws-1',
      fetchFn: firstSaveFetch as unknown as typeof fetch
    });
    expect(session.getSnapshot().isPersisting).toBe(true);

    // 3. Same-tenant discovery starts and then completes with same (usr-1, ws-1)
    await session.syncContext(
      {
        userId: 'usr-1',
        workspaceId: 'ws-1',
        workflowId: 'wf-prod-v3',
        authState: 'authenticated',
        isDiscoveryLoading: true
      },
      { token: 'jwt_2', workspaceId: 'ws-1', fetchFn: loadFetch as unknown as typeof fetch }
    );
    expect(session.getSnapshot().isReverifying).toBe(true);
    expect(session.getSnapshot().isPersisting).toBe(true);

    await session.syncContext(
      {
        userId: 'usr-1',
        workspaceId: 'ws-1',
        workflowId: 'wf-prod-v3',
        authState: 'authenticated',
        isDiscoveryLoading: false
      },
      { token: 'jwt_2', workspaceId: 'ws-1', fetchFn: loadFetch as unknown as typeof fetch }
    );
    expect(session.getSnapshot().isReverifying).toBe(false);
    expect(session.getSnapshot().isPersisting).toBe(true);

    // 4. Server completes first Save and returns v4
    resolveFirstSave(
      jsonResponse({
        workflow: {
          workflow_id: 'wf-prod-v3',
          status: 'WORKFLOW_STATUS_DRAFT',
          version: 4
        }
      })
    );
    const firstSaveRes = await pendingFirstSave;
    expect(firstSaveRes.ok).toBe(true);
    expect(firstSaveRes.version).toBe(4);
    expect(session.getSnapshot().version).toBe(4);
    expect(session.getSnapshot().isPersisting).toBe(false);

    // 5. Second Save uses expected_version = 4 (not stale 3!) and advances to v5
    const secondSaveFetch = vi.fn(async (_url: string, init?: RequestInit) => {
      const parsed = init?.body ? JSON.parse(String(init.body)) : {};
      sentExpectedVersions.push(parsed.expected_version);
      return jsonResponse({
        workflow: {
          workflow_id: 'wf-prod-v3',
          status: 'WORKFLOW_STATUS_DRAFT',
          version: 5
        }
      });
    });

    const secondSaveRes = await session.save({
      token: 'jwt_2',
      workspaceId: 'ws-1',
      fetchFn: secondSaveFetch as unknown as typeof fetch
    });
    expect(secondSaveRes.ok).toBe(true);
    expect(secondSaveRes.version).toBe(5);
    expect(sentExpectedVersions).toEqual([3, 4]);
    expect(session.getSnapshot().version).toBe(5);

    // 6. In-flight setStatus('active') started before same-tenant discovery also preserves v5 -> v6
    let resolveActivate!: (value: Response) => void;
    const activateFetch = vi.fn(() => {
      return new Promise<Response>((resolve) => {
        resolveActivate = resolve;
      });
    });

    const pendingActivate = session.setStatus('active', {
      token: 'jwt_2',
      workspaceId: 'ws-1',
      fetchFn: activateFetch as unknown as typeof fetch
    });
    expect(session.getSnapshot().isPersisting).toBe(true);

    await session.syncContext(
      {
        userId: 'usr-1',
        workspaceId: 'ws-1',
        workflowId: 'wf-prod-v3',
        authState: 'authenticated',
        isDiscoveryLoading: true
      },
      { token: 'jwt_3', workspaceId: 'ws-1', fetchFn: loadFetch as unknown as typeof fetch }
    );
    await session.syncContext(
      {
        userId: 'usr-1',
        workspaceId: 'ws-1',
        workflowId: 'wf-prod-v3',
        authState: 'authenticated',
        isDiscoveryLoading: false
      },
      { token: 'jwt_3', workspaceId: 'ws-1', fetchFn: loadFetch as unknown as typeof fetch }
    );

    resolveActivate(
      jsonResponse({
        workflow: {
          workflow_id: 'wf-prod-v3',
          status: 'WORKFLOW_STATUS_ACTIVE',
          version: 6
        }
      })
    );
    const activateRes = await pendingActivate;
    expect(activateRes.ok).toBe(true);
    expect(activateRes.status).toBe('active');
    expect(activateRes.version).toBe(6);
    expect(session.getSnapshot().status).toBe('active');
    expect(session.getSnapshot().version).toBe(6);
    expect(session.getSnapshot().isPersisting).toBe(false);

    // 7. Negative isolation: if discovery switches workspace to ws-2 while Save is in flight, stale ws-1 Save is rejected
    let resolveCrossTenantSave!: (value: Response) => void;
    const crossTenantSaveFetch = vi.fn(
      () =>
        new Promise<Response>((resolve) => {
          resolveCrossTenantSave = resolve;
        })
    );
    const pendingCrossTenantSave = session.save({
      token: 'jwt_3',
      workspaceId: 'ws-1',
      fetchFn: crossTenantSaveFetch as unknown as typeof fetch
    });

    const ws2LoadFetch = vi.fn(async () =>
      jsonResponse({
        workflow: {
          workflow_id: 'wf-prod-v3',
          workspace_id: 'ws-2',
          title: 'Workspace 2 Workflow',
          status: 'WORKFLOW_STATUS_DRAFT',
          version: 1,
          action_chain: {
            schema_version: 1,
            nodes: [
              { node_id: 'trig-ws2', node_type: 'NODE_TYPE_TRIGGER', title: 'WS2 Trigger' },
              { node_id: 'term-ws2', node_type: 'NODE_TYPE_TERMINAL', title: 'WS2 End' }
            ],
            edges: [{ from_node_id: 'trig-ws2', to_node_id: 'term-ws2' }]
          }
        }
      })
    );
    await session.syncContext(
      {
        userId: 'usr-1',
        workspaceId: 'ws-2',
        workflowId: 'wf-prod-v3',
        authState: 'authenticated',
        isDiscoveryLoading: false
      },
      { token: 'jwt_ws2', workspaceId: 'ws-2', fetchFn: ws2LoadFetch as unknown as typeof fetch }
    );

    resolveCrossTenantSave(
      jsonResponse({
        workflow: {
          workflow_id: 'wf-prod-v3',
          status: 'WORKFLOW_STATUS_ACTIVE',
          version: 99
        }
      })
    );
    const staleCrossRes = await pendingCrossTenantSave;
    expect(staleCrossRes.ok).toBe(false);
    expect(session.getSnapshot().workspaceId).toBe('ws-2');
    expect(session.getSnapshot().version).toBe(1);
    expect(session.getSnapshot().title).toBe('Workspace 2 Workflow');
  });

  it('T8-N3 Script Lab session fails closed on Save, SubmitApproval, Approve, and Reject without backend persistence, preserves conflict state on failure, and persists across reload on success', async () => {
    const scriptSession = createScriptEditorSession('scr-001');

    // 1. Before context load: Save and SubmitApproval fail closed without incrementing versionIndex or reporting success
    expect(scriptSession.getSnapshot().loadState).toBe('waiting_context');
    expect(scriptSession.getSnapshot().versionIndex).toBeNull();

    const saveBeforeLoad = await scriptSession.save({
      token: 'jwt_1',
      fetchFn: vi.fn() as unknown as typeof fetch
    });
    expect(saveBeforeLoad.ok).toBe(false);
    expect(scriptSession.getSnapshot().versionIndex).toBeNull();
    expect(scriptSession.getSnapshot().saveFeedback).toBe('');

    const submitBeforeLoad = await scriptSession.submitForReview({
      token: 'jwt_1',
      fetchFn: vi.fn() as unknown as typeof fetch
    });
    expect(submitBeforeLoad.ok).toBe(false);
    expect(scriptSession.getSnapshot().lifecycleState).toBe('draft');
    expect(scriptSession.getSnapshot().approvalState).toBe('not_submitted');
    expect(scriptSession.getSnapshot().saveFeedback).toBe('');

    // 2. Load script v2 from server (ScriptService/Get)
    let serverRecord = {
      script_id: 'scr-001',
      workspace_id: 'ws-1',
      title: 'Kịch bản Skincare Mùa Hè',
      format_type: '9:16 vertical short',
      duration_target_seconds: 60,
      version_index: 2,
      lifecycle_state: 'SCRIPT_LIFECYCLE_STATE_DRAFT',
      approval_state: 'SCRIPT_APPROVAL_STATE_NOT_SUBMITTED',
      scenes: [
        {
          scene_id: 'sc-1',
          script_id: 'scr-001',
          workspace_id: 'ws-1',
          scene_index: 0,
          description: 'Hook mở đầu',
          content: 'Nếu hè này da bạn đổ dầu, dừng ngay 2 bước này!',
          duration_seconds: 10,
          visual_notes: 'Cận mặt',
          audio_notes: 'Nhạc nhanh',
          shot_list: []
        }
      ]
    };

    const getScriptFetch = vi.fn(async (url: string) => {
      expect(url).toContain('/creativanta.content.v1.ScriptService/Get');
      return jsonResponse({ script: serverRecord });
    });

    const loadRes = await scriptSession.syncContext(
      {
        userId: 'usr-1',
        workspaceId: 'ws-1',
        scriptId: 'scr-001',
        authState: 'authenticated',
        isDiscoveryLoading: false
      },
      { token: 'jwt_1', workspaceId: 'ws-1', fetchFn: getScriptFetch as unknown as typeof fetch }
    );
    expect(loadRes.ok).toBe(true);
    expect(scriptSession.getSnapshot().loadState).toBe('loaded');
    expect(scriptSession.getSnapshot().versionIndex).toBe(2);
    expect(scriptSession.getSnapshot().title).toBe('Kịch bản Skincare Mùa Hè');

    // 3. Mark conflict and attempt Save while backend returns 503 -> must NOT increment versionIndex or clear isConflict!
    scriptSession.markConflict('Phiên bản máy chủ đã thay đổi (v3).');
    expect(scriptSession.getSnapshot().isConflict).toBe(true);

    const fail503Fetch = vi
      .fn()
      .mockResolvedValue(jsonResponse({ code: 'unavailable', message: 'Backend offline' }, 503));

    scriptSession.setTitle('Tiêu đề chỉnh sửa khi offline');
    const failedSave = await scriptSession.save({
      token: 'jwt_1',
      workspaceId: 'ws-1',
      fetchFn: fail503Fetch as unknown as typeof fetch
    });
    expect(failedSave.ok).toBe(false);
    expect(scriptSession.getSnapshot().versionIndex).toBe(2);
    expect(scriptSession.getSnapshot().isConflict).toBe(true);
    expect(scriptSession.getSnapshot().saveFeedback).toBe('');
    expect(scriptSession.getSnapshot().error).toBeTruthy();

    // 4. Attempt SubmitApproval while backend returns 503 -> must NOT transition to in_review or pending_approval
    const failedSubmit = await scriptSession.submitForReview({
      token: 'jwt_1',
      workspaceId: 'ws-1',
      fetchFn: fail503Fetch as unknown as typeof fetch
    });
    expect(failedSubmit.ok).toBe(false);
    expect(scriptSession.getSnapshot().lifecycleState).toBe('draft');
    expect(scriptSession.getSnapshot().approvalState).toBe('not_submitted');
    expect(scriptSession.getSnapshot().approvalRequestId).toBeNull();
    expect(scriptSession.getSnapshot().saveFeedback).toBe('');

    // 5. Save succeeds via ScriptService/Update -> advances to v3, clears conflict, and persists across reload (F5)
    const updateScriptFetch = vi.fn(async (url: string, init?: RequestInit) => {
      expect(url).toContain('/creativanta.content.v1.ScriptService/Update');
      const body = init?.body ? JSON.parse(String(init.body)) : {};
      expect(body.expected_version).toBe(2);
      expect(body.title).toBe('Tiêu đề chỉnh sửa khi offline');
      serverRecord = {
        ...serverRecord,
        title: body.title,
        version_index: 3
      };
      return jsonResponse({ script: serverRecord });
    });

    const okSave = await scriptSession.save({
      token: 'jwt_1',
      workspaceId: 'ws-1',
      fetchFn: updateScriptFetch as unknown as typeof fetch
    });
    expect(okSave.ok).toBe(true);
    expect(scriptSession.getSnapshot().versionIndex).toBe(3);
    expect(scriptSession.getSnapshot().isConflict).toBe(false);
    expect(scriptSession.getSnapshot().saveFeedback).toContain('v3');

    // Simulate page reload (force re-fetch from ScriptService/Get)
    const reloadRes = await scriptSession.syncContext(
      {
        userId: 'usr-1',
        workspaceId: 'ws-1',
        scriptId: 'scr-001',
        authState: 'authenticated',
        isDiscoveryLoading: false,
        force: true
      },
      { token: 'jwt_1', workspaceId: 'ws-1', fetchFn: getScriptFetch as unknown as typeof fetch }
    );
    expect(reloadRes.ok).toBe(true);
    expect(scriptSession.getSnapshot().versionIndex).toBe(3);
    expect(scriptSession.getSnapshot().title).toBe('Tiêu đề chỉnh sửa khi offline');

    // 6. SubmitApproval succeeds via ScriptService/SubmitApproval -> transitions to in_review + pending_approval with approval_request_id
    const submitOkFetch = vi.fn(async (url: string, init?: RequestInit) => {
      expect(url).toContain('/creativanta.content.v1.ScriptService/SubmitApproval');
      const body = init?.body ? JSON.parse(String(init.body)) : {};
      expect(body.expected_version).toBe(3);
      serverRecord = {
        ...serverRecord,
        version_index: 3,
        lifecycle_state: 'SCRIPT_LIFECYCLE_STATE_IN_REVIEW',
        approval_state: 'SCRIPT_APPROVAL_STATE_PENDING_APPROVAL'
      };
      return jsonResponse({
        script: serverRecord,
        approval_request_id: 'apr_req_901'
      });
    });

    const okSubmit = await scriptSession.submitForReview({
      token: 'jwt_1',
      workspaceId: 'ws-1',
      fetchFn: submitOkFetch as unknown as typeof fetch
    });
    expect(okSubmit.ok).toBe(true);
    expect(okSubmit.approvalRequestId).toBe('apr_req_901');
    expect(scriptSession.getSnapshot().lifecycleState).toBe('in_review');
    expect(scriptSession.getSnapshot().approvalState).toBe('pending_approval');
    expect(scriptSession.getSnapshot().approvalRequestId).toBe('apr_req_901');

    // 7. Reviewer Approve/Reject helpers also fail closed on 503/412
    const approveFail = await approveScriptRemote(
      { workspaceId: 'ws-1', scriptId: 'scr-001', expectedVersion: 3 },
      { token: 'jwt_1', workspaceId: 'ws-1', fetchFn: fail503Fetch as unknown as typeof fetch }
    );
    expect(approveFail.ok).toBe(false);

    const rejectShort = await rejectScriptRemote(
      { workspaceId: 'ws-1', scriptId: 'scr-001', rejectionReason: 'ngắn', expectedVersion: 3 },
      { token: 'jwt_1', workspaceId: 'ws-1', fetchFn: fail503Fetch as unknown as typeof fetch }
    );
    expect(rejectShort.ok).toBe(false);
  });

  it('T8-R1-R2-R3 Script Lab review screen loads real scenes before approval, scene field edits persist on Save, and dirty SubmitApproval saves or blocks before submitting', async () => {
    const scriptReviewPageSource = (await import('../../routes/scripts/[id]/review/+page.svelte?raw')).default;
    const scriptSceneEditorSource = (await import('../script/ScriptSceneEditor.svelte?raw')).default;

    // R1: Review page must not hardcode sample skincare scenes and must wire createScriptReviewSession + dynamic scene loop
    expect(scriptReviewPageSource).not.toContain('Nếu hè này da bạn đổ dầu như chảo mỡ');
    expect(scriptReviewPageSource).not.toContain('Số cảnh: <strong class="text-gray-800">3 cảnh</strong>');
    expect(scriptReviewPageSource).toContain('createScriptReviewSession');
    expect(scriptReviewPageSource).toContain('{#each scenes as scene, sceneIdx');

    // R2: ScriptSceneEditor must synchronize field edits (content, description, duration, visual/audio notes, shot fields) via onUpdateScenes
    expect(scriptSceneEditorSource).toContain('updateSceneField');
    expect(scriptSceneEditorSource).toContain('updateShotField');

    // R1 behavioral verification: createScriptReviewSession starts fail-closed with no sample scenes or version
    const reviewSession = createScriptReviewSession('scr-kb-01');
    expect(reviewSession.getSnapshot().loadState).toBe('waiting_context');
    expect(reviewSession.getSnapshot().versionIndex).toBeNull();
    expect(reviewSession.getSnapshot().scenes).toEqual([]);

    // Attempting Approve or Reject before Get succeeds is strictly denied
    const earlyApprove = await reviewSession.approve({
      token: 'jwt_mgr',
      fetchFn: vi.fn() as unknown as typeof fetch
    });
    expect(earlyApprove.ok).toBe(false);
    expect(reviewSession.getSnapshot().error).toBeTruthy();

    const earlyReject = await reviewSession.reject('Lý do từ chối hợp lệ trên 10 ký tự', {
      token: 'jwt_mgr',
      fetchFn: vi.fn() as unknown as typeof fetch
    });
    expect(earlyReject.ok).toBe(false);

    // Failed Get (503) keeps review session locked and scenes empty
    const failGetFetch = vi
      .fn()
      .mockResolvedValue(jsonResponse({ code: 'unavailable', message: 'Backend down' }, 503));
    const failedReviewLoad = await reviewSession.syncContext(
      {
        userId: 'mgr-1',
        workspaceId: 'ws-1',
        scriptId: 'scr-kb-01',
        authState: 'authenticated',
        isDiscoveryLoading: false
      },
      { token: 'jwt_mgr', workspaceId: 'ws-1', fetchFn: failGetFetch as unknown as typeof fetch }
    );
    expect(failedReviewLoad.ok).toBe(false);
    expect(reviewSession.getSnapshot().loadState).toBe('error');
    expect(reviewSession.getSnapshot().scenes).toEqual([]);
    expect(reviewSession.getSnapshot().versionIndex).toBeNull();

    // Valid Get returns distinct non-skincare scenes (v4)
    let reviewServerRecord = {
      script_id: 'scr-kb-01',
      workspace_id: 'ws-1',
      title: 'Đánh giá bàn phím cơ Custom Gasket Mount',
      format_type: '16:9 youtube review',
      duration_target_seconds: 90,
      version_index: 4,
      lifecycle_state: 'SCRIPT_LIFECYCLE_STATE_IN_REVIEW',
      approval_state: 'SCRIPT_APPROVAL_STATE_PENDING_APPROVAL',
      updated_at: '2026-10-30T10:00:00Z',
      scenes: [
        {
          scene_id: 'sc-kb-1',
          script_id: 'scr-kb-01',
          workspace_id: 'ws-1',
          scene_index: 0,
          description: 'Soundtest mở đầu',
          content: 'Nghe thử âm thanh gõ thocky của chiếc bàn phím nhôm CNC dưới 2 triệu này!',
          duration_seconds: 15,
          visual_notes: 'Macro keycap PBT và switch linear',
          audio_notes: 'Thu âm mic condenser không nén',
          shot_list: [
            {
              shot_id: 'sh-kb-1',
              scene_id: 'sc-kb-1',
              workspace_id: 'ws-1',
              shot_index: 0,
              shot_type: 'Product Macro',
              description: 'Gõ phím Spacebar',
              duration_seconds: 5
            }
          ]
        },
        {
          scene_id: 'sc-kb-2',
          script_id: 'scr-kb-01',
          workspace_id: 'ws-1',
          scene_index: 1,
          description: 'Phân tích cấu trúc Gasket',
          content: 'Mạch xuôi Hotswap 5 pin kèm foam poron 3 lớp giúp độ nhún cực kỳ êm.',
          duration_seconds: 75,
          visual_notes: 'Tháo case hiển thị lớp foam',
          audio_notes: 'Voiceover rõ ràng',
          shot_list: []
        }
      ]
    };

    const reviewFetch = vi.fn(async (url: string, init?: RequestInit) => {
      const body = init?.body ? JSON.parse(String(init.body)) : {};
      if (url.includes('ScriptService/Get')) {
        return jsonResponse({ script: reviewServerRecord });
      }
      if (url.includes('ScriptService/Approve')) {
        expect(body.script_id).toBe('scr-kb-01');
        expect(body.expected_version).toBe(4);
        expect(body.reviewer_snapshot_time).toBe('2026-10-30T10:00:00Z');
        reviewServerRecord = {
          ...reviewServerRecord,
          version_index: 5,
          lifecycle_state: 'SCRIPT_LIFECYCLE_STATE_APPROVED',
          approval_state: 'SCRIPT_APPROVAL_STATE_APPROVED'
        };
        return jsonResponse({ script: reviewServerRecord });
      }
      return jsonResponse({ message: 'Unexpected RPC' }, 404);
    });

    const okReviewLoad = await reviewSession.syncContext(
      {
        userId: 'mgr-1',
        workspaceId: 'ws-1',
        scriptId: 'scr-kb-01',
        authState: 'authenticated',
        isDiscoveryLoading: false,
        force: true
      },
      { token: 'jwt_mgr', workspaceId: 'ws-1', fetchFn: reviewFetch as unknown as typeof fetch }
    );
    expect(okReviewLoad.ok).toBe(true);
    expect(reviewSession.getSnapshot().loadState).toBe('loaded');
    expect(reviewSession.getSnapshot().versionIndex).toBe(4);
    expect(reviewSession.getSnapshot().scenes).toHaveLength(2);
    expect(reviewSession.getSnapshot().scenes[0].content).toContain('âm thanh gõ thocky');
    expect(reviewSession.getSnapshot().scenes[1].content).toContain('Mạch xuôi Hotswap 5 pin');

    // Approve sends expected_version=4 matching the displayed scenes
    const okReviewApprove = await reviewSession.approve({
      token: 'jwt_mgr',
      workspaceId: 'ws-1',
      fetchFn: reviewFetch as unknown as typeof fetch
    });
    expect(okReviewApprove.ok).toBe(true);
    expect(reviewSession.getSnapshot().approvalState).toBe('approved');
    expect(reviewSession.getSnapshot().versionIndex).toBe(5);

    // Tenant switch / logout immediately purges review scenes and locks mutations
    await reviewSession.syncContext({
      userId: null,
      workspaceId: null,
      scriptId: 'scr-kb-01',
      authState: 'unauthenticated',
      isDiscoveryLoading: false
    });
    expect(reviewSession.getSnapshot().loadState).toBe('waiting_context');
    expect(reviewSession.getSnapshot().versionIndex).toBeNull();
    expect(reviewSession.getSnapshot().scenes).toEqual([]);

    // R2 & R3 behavioral verification:
    // Editing existing scene fields via component helpers updates controller, sets isDirty=true,
    // persists updated fields on Save, and dirty SubmitApproval runs Update before SubmitApproval.
    const editorSession = createScriptEditorSession('scr-r2-r3');
    let editorServerRecord = {
      script_id: 'scr-r2-r3',
      workspace_id: 'ws-1',
      title: 'Persisted title',
      format_type: '9:16 vertical short',
      duration_target_seconds: 60,
      version_index: 2,
      lifecycle_state: 'SCRIPT_LIFECYCLE_STATE_DRAFT',
      approval_state: 'SCRIPT_APPROVAL_STATE_NOT_SUBMITTED',
      scenes: [
        {
          scene_id: 'sc-1',
          script_id: 'scr-r2-r3',
          workspace_id: 'ws-1',
          scene_index: 0,
          description: 'Hook',
          content: 'Original scene',
          duration_seconds: 10,
          visual_notes: 'Original visual',
          audio_notes: 'Original audio',
          shot_list: [
            {
              shot_id: 'sh-1',
              scene_id: 'sc-1',
              workspace_id: 'ws-1',
              shot_index: 0,
              shot_type: 'Medium Shot',
              description: 'Original shot',
              duration_seconds: 3
            }
          ]
        }
      ]
    };

    const calledRpcs: string[] = [];
    const editorFetch = vi.fn(async (url: string, init?: RequestInit) => {
      const body = init?.body ? JSON.parse(String(init.body)) : {};
      if (url.includes('ScriptService/Get')) {
        calledRpcs.push('Get');
        return jsonResponse({ script: editorServerRecord });
      }
      if (url.includes('ScriptService/Update')) {
        calledRpcs.push(`Update(v=${body.expected_version})`);
        editorServerRecord = {
          ...editorServerRecord,
          title: body.title,
          scenes: body.scenes,
          version_index: editorServerRecord.version_index + 1
        };
        return jsonResponse({ script: editorServerRecord });
      }
      if (url.includes('ScriptService/SubmitApproval')) {
        calledRpcs.push(`SubmitApproval(v=${body.expected_version})`);
        editorServerRecord = {
          ...editorServerRecord,
          lifecycle_state: 'SCRIPT_LIFECYCLE_STATE_IN_REVIEW',
          approval_state: 'SCRIPT_APPROVAL_STATE_PENDING_APPROVAL'
        };
        return jsonResponse({
          script: editorServerRecord,
          approval_request_id: 'apr-r3-1'
        });
      }
      return jsonResponse({ message: 'Unknown RPC' }, 404);
    });

    await editorSession.syncContext(
      {
        userId: 'usr-1',
        workspaceId: 'ws-1',
        scriptId: 'scr-r2-r3',
        authState: 'authenticated',
        isDiscoveryLoading: false
      },
      { token: 'jwt_1', workspaceId: 'ws-1', fetchFn: editorFetch as unknown as typeof fetch }
    );
    expect(editorSession.getSnapshot().isDirty).toBe(false);

    // R2: Simulate ScriptSceneEditor field edits on existing scene and shot without adding/removing scenes
    let boundScenes = editorSession.getSnapshot().scenes;
    const onUpdateScenes = (nextScenes: typeof boundScenes) => {
      boundScenes = nextScenes;
      editorSession.setScenes(nextScenes);
    };
    onUpdateScenes(
      updateSceneInList(boundScenes, 0, {
        content: 'NEW TEXT TYPED IN TEXTAREA',
        description: 'Updated Hook Title',
        durationSeconds: 14,
        visualNotes: 'Updated visual angle',
        audioNotes: 'Updated audio sfx'
      })
    );
    onUpdateScenes(
      updateShotInList(boundScenes, 0, 0, {
        shotType: 'Close Up',
        description: 'Updated close-up shot',
        durationSeconds: 5
      })
    );

    expect(editorSession.getSnapshot().isDirty).toBe(true);
    expect(editorSession.getSnapshot().scenes[0].content).toBe('NEW TEXT TYPED IN TEXTAREA');
    expect(editorSession.getSnapshot().scenes[0].shotList[0].description).toBe(
      'Updated close-up shot'
    );

    const r2SaveRes = await editorSession.save({
      token: 'jwt_1',
      workspaceId: 'ws-1',
      fetchFn: editorFetch as unknown as typeof fetch
    });
    expect(r2SaveRes.ok).toBe(true);
    expect(editorSession.getSnapshot().isDirty).toBe(false);
    expect(editorSession.getSnapshot().versionIndex).toBe(3);
    expect(editorSession.getSnapshot().scenes[0].content).toBe('NEW TEXT TYPED IN TEXTAREA');
    expect(editorServerRecord.scenes[0].content).toBe('NEW TEXT TYPED IN TEXTAREA');
    expect(editorServerRecord.scenes[0].description).toBe('Updated Hook Title');
    expect(editorServerRecord.scenes[0].duration_seconds).toBe(14);
    expect(editorServerRecord.scenes[0].visual_notes).toBe('Updated visual angle');
    expect(editorServerRecord.scenes[0].audio_notes).toBe('Updated audio sfx');
    expect(editorServerRecord.scenes[0].shot_list[0].shot_type).toBe('Close Up');
    expect(editorServerRecord.scenes[0].shot_list[0].description).toBe('Updated close-up shot');

    // R3: Edit title + add a second scene, then call submitForReview() WITHOUT calling save() first
    calledRpcs.length = 0;
    editorSession.setTitle('NEW TITLE NOT YET SAVED');
    onUpdateScenes([
      ...editorSession.getSnapshot().scenes,
      {
        sceneId: 'sc-2',
        scriptId: 'scr-r2-r3',
        workspaceId: 'ws-1',
        sceneIndex: 1,
        description: 'CTA Scene',
        content: 'Nhấn vào giỏ hàng để đặt mua ngay!',
        durationSeconds: 10,
        visualNotes: 'Chỉ tay xuống góc trái',
        audioNotes: 'Nhạc dồn dập',
        shotList: [],
        createdAt: '2026-10-30T10:05:00Z'
      }
    ]);
    expect(editorSession.getSnapshot().isDirty).toBe(true);

    // Negative check first: if Update fails with 409 conflict during submitForReview, SubmitApproval MUST NOT be called
    const conflictUpdateFetch = vi.fn(async (url: string) => {
      if (url.includes('ScriptService/Update')) {
        calledRpcs.push('UpdateConflict');
        return jsonResponse(
          { code: 'failed_precondition', message: 'expected_version conflict' },
          409
        );
      }
      if (url.includes('ScriptService/SubmitApproval')) {
        calledRpcs.push('SubmitApprovalShouldNotRun');
      }
      return jsonResponse({ message: 'Error' }, 500);
    });
    const failedDirtySubmit = await editorSession.submitForReview({
      token: 'jwt_1',
      workspaceId: 'ws-1',
      fetchFn: conflictUpdateFetch as unknown as typeof fetch
    });
    expect(failedDirtySubmit.ok).toBe(false);
    expect(failedDirtySubmit.conflict).toBe(true);
    expect(calledRpcs).toEqual(['UpdateConflict']);
    expect(editorSession.getSnapshot().approvalState).toBe('not_submitted');
    expect(editorSession.getSnapshot().isDirty).toBe(true);
    expect(editorSession.getSnapshot().isConflict).toBe(true);

    // Now submitForReview succeeds: runs Update(v=3) -> advances to v4 -> runs SubmitApproval(v=4)
    calledRpcs.length = 0;
    const submitRes = await editorSession.submitForReview({
      token: 'jwt_1',
      workspaceId: 'ws-1',
      fetchFn: editorFetch as unknown as typeof fetch
    });
    expect(submitRes.ok).toBe(true);
    expect(calledRpcs).toEqual(['Update(v=3)', 'SubmitApproval(v=4)']);
    expect(editorServerRecord.title).toBe('NEW TITLE NOT YET SAVED');
    expect(editorServerRecord.scenes).toHaveLength(2);
    expect(editorSession.getSnapshot().isDirty).toBe(false);
    expect(editorSession.getSnapshot().versionIndex).toBe(4);
    expect(editorSession.getSnapshot().approvalState).toBe('pending_approval');

    // Reloading editor and opening Reviewer screen both see the exact submitted v4 title & 2 scenes
    await editorSession.syncContext(
      {
        userId: 'usr-1',
        workspaceId: 'ws-1',
        scriptId: 'scr-r2-r3',
        authState: 'authenticated',
        isDiscoveryLoading: false,
        force: true
      },
      { token: 'jwt_1', workspaceId: 'ws-1', fetchFn: editorFetch as unknown as typeof fetch }
    );
    expect(editorSession.getSnapshot().title).toBe('NEW TITLE NOT YET SAVED');
    expect(editorSession.getSnapshot().scenes).toHaveLength(2);
    expect(editorSession.getSnapshot().scenes[1].content).toBe(
      'Nhấn vào giỏ hàng để đặt mua ngay!'
    );

    const reviewerCheck = createScriptReviewSession('scr-r2-r3');
    await reviewerCheck.syncContext(
      {
        userId: 'mgr-1',
        workspaceId: 'ws-1',
        scriptId: 'scr-r2-r3',
        authState: 'authenticated',
        isDiscoveryLoading: false
      },
      { token: 'jwt_mgr', workspaceId: 'ws-1', fetchFn: editorFetch as unknown as typeof fetch }
    );
    expect(reviewerCheck.getSnapshot().title).toBe('NEW TITLE NOT YET SAVED');
    expect(reviewerCheck.getSnapshot().versionIndex).toBe(4);
    expect(reviewerCheck.getSnapshot().scenes).toHaveLength(2);
    expect(reviewerCheck.getSnapshot().scenes[0].content).toBe('NEW TEXT TYPED IN TEXTAREA');
    expect(reviewerCheck.getSnapshot().scenes[1].content).toBe(
      'Nhấn vào giỏ hàng để đặt mua ngay!'
    );
  });
});

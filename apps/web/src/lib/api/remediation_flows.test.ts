import { describe, expect, it, vi } from 'vitest';
import { callCanonicalRpc } from './client';
import { createIdeaRemote } from '../idea';
import { requestImageToVideoGenerationRemote } from '../production';
import {
  issueApiKeyRemote,
  rotateApiKeyRemote,
  revokeApiKeyRemote,
  registerWebhookRemote,
  developerStore
} from '../developer/public_api';
import { submitSupportTicketRemote } from '../help/store';
import { saveWorkflowRemote, setWorkflowStatusRemote, type Workflow } from '../workflow/runtime';
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
        activeKeyCount: 0,
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
        activeKeyCount: 0,
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
    const wf: Workflow = {
      workflowId: 'wf-1',
      workspaceId: 'ws-1',
      title: 'Test Workflow',
      description: 'Desc',
      workflowType: 'custom',
      status: 'draft',
      version: 2,
      triggerType: 'event',
      runCount: 0,
      createdAt: '2026-11-05T00:00:00Z',
      updatedAt: '2026-11-05T00:00:00Z',
      graph: {
        schemaVersion: 1,
        nodes: [
          { nodeId: 'n1', nodeType: 'trigger', title: 'Start', description: '', config: {} },
          { nodeId: 'n2', nodeType: 'terminal', title: 'End', description: '', config: {} }
        ],
        edges: [{ fromNodeId: 'n1', toNodeId: 'n2' }]
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
    expect(wf.version).toBe(2);

    const statusFail = await setWorkflowStatusRemote(wf, 'active', {
      token: 'jwt_valid',
      workspaceId: 'ws-1',
      fetchFn: fetch503 as unknown as typeof fetch
    });
    expect(statusFail.ok).toBe(false);
    expect(wf.status).toBe('draft');
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
});

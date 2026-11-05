<script lang="ts">
  import { onMount } from 'svelte';
  import {
    developerStore,
    TIER_KEY_CAPS,
    TIER_MONTHLY_QUOTAS,
    ELIGIBLE_WEBHOOK_EVENTS,
    isReadOnlyScopes,
    canMutate,
    issueApiKeyRemote,
    rotateApiKeyRemote,
    revokeApiKeyRemote,
    registerWebhookRemote,
    type APIKey,
    type WebhookSubscription
  } from '$lib/developer/public_api';
  import { authStore } from '$lib/auth';

  let selectedTier = 'pro';
  let newKeyName = '';
  let selectedScopes: string[] = ['read:content', 'read:orders'];
  let newKeySecret = '';
  let showCreateKeyModal = false;
  let showCreateWebhookModal = false;

  let webhookUrl = '';
  let webhookEvents: string[] = ['workflow.completed', 'content.published'];
  let newWebhookSecret = '';

  let actionFeedback = '';
  let isProcessing = false;

  $: state = $developerStore;
  $: activeKeysCount = state.keys.filter(
    (k) => k.status === 'active' || k.status === 'rotating'
  ).length;
  $: keyCap = TIER_KEY_CAPS[state.tier] || 3;
  $: quotaUsedPercent = Math.min(
    100,
    Math.round((state.summary.monthRequests / state.summary.monthlyQuota) * 100)
  );

  onMount(() => {
    developerStore.setTier(selectedTier);
  });

  function handleTierChange(e: Event) {
    const target = e.target as HTMLSelectElement;
    selectedTier = target.value;
    developerStore.setTier(selectedTier);
  }

  async function handleCreateKey() {
    actionFeedback = '';
    isProcessing = true;
    try {
      const res = await issueApiKeyRemote({
        workspaceId: $authStore.activeWorkspace?.id,
        tier: state.tier,
        activeKeysCount,
        name: newKeyName || 'New API Key',
        scopes: selectedScopes
      });
      if (!res.ok || !res.rawSecret) {
        actionFeedback = res.error || 'Không thể cấp phát khóa API từ máy chủ (APIKeyService/Create).';
        return;
      }
      newKeySecret = res.rawSecret;
      newKeyName = '';
      showCreateKeyModal = false;
    } finally {
      isProcessing = false;
    }
  }

  async function handleRotate(keyId: string) {
    actionFeedback = '';
    isProcessing = true;
    try {
      const rot = await rotateApiKeyRemote({
        workspaceId: $authStore.activeWorkspace?.id,
        apiKeyId: keyId
      });
      if (!rot.ok || !rot.newSecret || !rot.graceEndsAt) {
        actionFeedback = rot.error || 'Không thể xoay vòng khóa API trên máy chủ (APIKeyService/Rotate).';
        return;
      }
      newKeySecret = rot.newSecret;
      actionFeedback = `Key rotated successfully! Both keys active during 24h grace window until ${new Date(
        rot.graceEndsAt
      ).toLocaleTimeString()}`;
    } finally {
      isProcessing = false;
    }
  }

  async function handleRevoke(keyId: string) {
    actionFeedback = '';
    isProcessing = true;
    try {
      const res = await revokeApiKeyRemote({
        workspaceId: $authStore.activeWorkspace?.id,
        apiKeyId: keyId
      });
      if (!res.ok) {
        actionFeedback = res.error || 'Không thể thu hồi khóa API trên máy chủ (APIKeyService/Revoke).';
        return;
      }
      actionFeedback = 'API key revoked immediately.';
    } finally {
      isProcessing = false;
    }
  }

  async function handleCreateWebhook() {
    actionFeedback = '';
    isProcessing = true;
    try {
      const res = await registerWebhookRemote({
        workspaceId: $authStore.activeWorkspace?.id,
        targetUrl: webhookUrl,
        eventTypes: webhookEvents
      });
      if (!res.ok || !res.secret) {
        actionFeedback = res.error || 'Không thể đăng ký Webhook trên máy chủ (WebhookService/Create).';
        return;
      }
      newWebhookSecret = res.secret;
      webhookUrl = '';
      showCreateWebhookModal = false;
    } finally {
      isProcessing = false;
    }
  }

  function toggleScope(scope: string) {
    if (selectedScopes.includes(scope)) {
      selectedScopes = selectedScopes.filter((s) => s !== scope);
    } else {
      selectedScopes = [...selectedScopes, scope];
    }
  }

  function toggleWebhookEvent(ev: string) {
    if (webhookEvents.includes(ev)) {
      webhookEvents = webhookEvents.filter((e) => e !== ev);
    } else {
      webhookEvents = [...webhookEvents, ev];
    }
  }
</script>

<div class="developer-settings-container">
  <header class="header">
    <div>
      <h1 class="title">Developer Platform & Public API (S24)</h1>
      <p class="subtitle">
        Manage workspace-scoped API keys, rate limits, rotation, and replay-safe outbound webhooks.
      </p>
    </div>

    <div class="tier-selector">
      <label for="tier-select">Workspace Tier:</label>
      <select id="tier-select" bind:value={selectedTier} on:change={handleTierChange}>
        <option value="starter">Starter (Read-Only Mode, 3 Keys, 10k Quota)</option>
        <option value="pro">Pro (Read/Write, 10 Keys, 100k Quota)</option>
        <option value="business">Business (Full Access, 25 Keys, 1M Quota)</option>
      </select>
    </div>
  </header>

  {#if actionFeedback}
    <div class="feedback-banner" role="alert">
      <span>{actionFeedback}</span>
      <button class="btn-close" on:click={() => (actionFeedback = '')}>✕</button>
    </div>
  {/if}

  {#if newKeySecret}
    <div class="secret-reveal-card" role="region" aria-label="Generated Secret Key">
      <div class="secret-header">
        <span class="badge-once">DISPLAYED ONCE</span>
        <strong>Make sure to copy your API secret key now. You won't be able to see it again!</strong>
      </div>
      <div class="secret-box">
        <code>{newKeySecret}</code>
        <button class="btn-copy" on:click={() => navigator.clipboard.writeText(newKeySecret)}>
          Copy
        </button>
      </div>
      <small>Stored in database as SHA-256 hash. Visible prefix: {newKeySecret.substring(0, 10)}</small>
    </div>
  {/if}

  {#if newWebhookSecret}
    <div class="secret-reveal-card webhook-secret" role="region" aria-label="Webhook Signing Secret">
      <div class="secret-header">
        <span class="badge-once">WEBHOOK SIGNING SECRET</span>
        <strong>Use this HMAC-SHA256 secret to verify the X-Creativanta-Signature header on incoming webhooks:</strong>
      </div>
      <div class="secret-box">
        <code>{newWebhookSecret}</code>
        <button class="btn-copy" on:click={() => navigator.clipboard.writeText(newWebhookSecret)}>
          Copy
        </button>
      </div>
    </div>
  {/if}

  <!-- USAGE & QUOTA SECTION -->
  <section class="card usage-card">
    <h2>API Usage & Quota Metering (RULE-S24-002 & RULE-S24-005)</h2>
    <div class="stats-grid">
      <div class="stat-item">
        <span class="stat-label">Monthly Requests</span>
        <span class="stat-value">{state.summary.monthRequests.toLocaleString()} / {state.summary.monthlyQuota.toLocaleString()}</span>
        <div class="progress-bar">
          <div class="progress-fill" style="width: {quotaUsedPercent}%"></div>
        </div>
      </div>
      <div class="stat-item">
        <span class="stat-label">Rate Limits</span>
        <span class="stat-value">{state.summary.readRateLimitRPM} RPM (Read) / {state.summary.writeRateLimitRPM} RPM (Write)</span>
        <small class="text-muted">Sliding window with 2x burst allowance</small>
      </div>
      <div class="stat-item">
        <span class="stat-label">Billable AI Credits</span>
        <span class="stat-value">{state.summary.billableAICreditsUsed.toFixed(2)} cr</span>
        <small class="text-muted">5xx errors do not deduct AI credits (EC-S24-003)</small>
      </div>
      <div class="stat-item">
        <span class="stat-label">Active Keys Capacity</span>
        <span class="stat-value">{activeKeysCount} / {keyCap} Keys</span>
        <small class="text-muted">{state.tier === 'starter' ? 'Read-only mode enforced' : 'Mutating operations permitted'}</small>
      </div>
    </div>
  </section>

  <!-- API KEYS SECTION -->
  <section class="card">
    <div class="section-header">
      <div>
        <h2>Developer API Keys</h2>
        <p class="section-desc">
          Keys inherit permissions within your tier envelope. Starter tier is strictly read-only.
        </p>
      </div>
      <button
        class="btn-primary"
        disabled={activeKeysCount >= keyCap}
        on:click={() => (showCreateKeyModal = true)}
      >
        + Create API Key
      </button>
    </div>

    {#if state.keys.length === 0}
      <div class="empty-state">No API keys created yet.</div>
    {:else}
      <table class="data-table">
        <thead>
          <tr>
            <th>Key Name & Prefix</th>
            <th>Scopes</th>
            <th>Status</th>
            <th>Requests</th>
            <th>Expires</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {#each state.keys as key}
            <tr>
              <td>
                <strong>{key.name}</strong>
                <div class="key-prefix"><code>{key.keyPrefix}...</code></div>
              </td>
              <td>
                <div class="scope-badges">
                  {#each key.scopes as scope}
                    <span class="badge {scope.startsWith('write:') ? 'badge-write' : 'badge-read'}">
                      {scope}
                    </span>
                  {/each}
                </div>
              </td>
              <td>
                <span class="status-pill status-{key.status}">{key.status.toUpperCase()}</span>
                {#if key.status === 'rotating' && key.rotationGraceEndsAt}
                  <div class="grace-label">Grace until {new Date(key.rotationGraceEndsAt).toLocaleTimeString()}</div>
                {/if}
              </td>
              <td>{key.requestCount.toLocaleString()}</td>
              <td>{new Date(key.expiresAt).toLocaleDateString()}</td>
              <td class="action-cell">
                {#if key.status === 'active'}
                  <button class="btn-action" on:click={() => handleRotate(key.apiKeyId)}>
                    Rotate (24h Grace)
                  </button>
                  <button class="btn-action btn-danger" on:click={() => handleRevoke(key.apiKeyId)}>
                    Revoke
                  </button>
                {:else if key.status === 'rotating'}
                  <span class="text-muted">Rotating</span>
                {:else}
                  <span class="text-muted">Inactive</span>
                {/if}
              </td>
            </tr>
          {/each}
        </tbody>
      </table>
    {/if}
  </section>

  <!-- OUTBOUND WEBHOOKS SECTION -->
  <section class="card">
    <div class="section-header">
      <div>
        <h2>Outbound Webhook Subscriptions (RULE-S24-006)</h2>
        <p class="section-desc">
          Automated HTTP POST delivery with HMAC-SHA256 signatures, exponential retries (1s/10s/60s), and auto-suspension after 100 consecutive failures.
        </p>
      </div>
      <button class="btn-primary" on:click={() => (showCreateWebhookModal = true)}>
        + Add Webhook Endpoint
      </button>
    </div>

    {#if state.webhooks.length === 0}
      <div class="empty-state">No webhook subscriptions configured.</div>
    {:else}
      <table class="data-table">
        <thead>
          <tr>
            <th>Endpoint URL</th>
            <th>Events</th>
            <th>Status</th>
            <th>Consecutive Failures</th>
            <th>Last Delivery</th>
          </tr>
        </thead>
        <tbody>
          {#each state.webhooks as sub}
            <tr>
              <td><code>{sub.targetUrl}</code></td>
              <td>
                <div class="scope-badges">
                  {#each sub.eventTypes as ev}
                    <span class="badge badge-read">{ev}</span>
                  {/each}
                </div>
              </td>
              <td>
                <span class="status-pill status-{sub.status}">{sub.status.toUpperCase()}</span>
              </td>
              <td>
                <span class={sub.consecutiveFailureCount > 0 ? 'text-danger' : 'text-muted'}>
                  {sub.consecutiveFailureCount} / 100
                </span>
                {#if sub.consecutiveFailureCount >= 100}
                  <small class="text-danger block">Auto-suspended</small>
                {/if}
              </td>
              <td>
                {sub.lastDeliveryAt ? new Date(sub.lastDeliveryAt).toLocaleTimeString() : 'Never'}
                {#if sub.lastError}
                  <div class="text-danger small">{sub.lastError}</div>
                {/if}
              </td>
            </tr>
          {/each}
        </tbody>
      </table>
    {/if}
  </section>
</div>

<!-- CREATE KEY MODAL -->
{#if showCreateKeyModal}
  <div class="modal-backdrop">
    <div class="modal-card">
      <h3>Create Developer API Key</h3>
      <div class="form-group">
        <label for="key-name">Key Name</label>
        <input id="key-name" type="text" placeholder="e.g. CI/CD Deploy Key" bind:value={newKeyName} />
      </div>

      <div class="form-group">
        <span class="label-heading">Scopes</span>
        {#if selectedTier === 'starter'}
          <p class="text-muted small">Starter tier is restricted to read-only scopes.</p>
        {/if}
        <div class="scopes-selection-grid">
          {#each ['read:content', 'write:content', 'read:orders', 'write:orders', 'read:analytics'] as sc}
            <label class="checkbox-label">
              <input
                type="checkbox"
                checked={selectedScopes.includes(sc)}
                disabled={selectedTier === 'starter' && sc.startsWith('write:')}
                on:change={() => toggleScope(sc)}
              />
              <span class="{sc.startsWith('write:') ? 'text-write' : ''}">{sc}</span>
            </label>
          {/each}
        </div>
      </div>

      <div class="modal-actions">
        <button class="btn-secondary" on:click={() => (showCreateKeyModal = false)}>Cancel</button>
        <button class="btn-primary" on:click={handleCreateKey}>Generate Key</button>
      </div>
    </div>
  </div>
{/if}

<!-- CREATE WEBHOOK MODAL -->
{#if showCreateWebhookModal}
  <div class="modal-backdrop">
    <div class="modal-card">
      <h3>Add Outbound Webhook Endpoint</h3>
      <div class="form-group">
        <label for="target-url">Target URL</label>
        <input
          id="target-url"
          type="url"
          placeholder="https://your-domain.com/api/webhooks"
          bind:value={webhookUrl}
        />
      </div>

      <div class="form-group">
        <span class="label-heading">Subscribed Events (13 Eligible Domain Events)</span>
        <div class="events-grid">
          {#each ELIGIBLE_WEBHOOK_EVENTS as ev}
            <label class="checkbox-label">
              <input
                type="checkbox"
                checked={webhookEvents.includes(ev)}
                on:change={() => toggleWebhookEvent(ev)}
              />
              <span>{ev}</span>
            </label>
          {/each}
        </div>
      </div>

      <div class="modal-actions">
        <button class="btn-secondary" on:click={() => (showCreateWebhookModal = false)}>Cancel</button>
        <button class="btn-primary" disabled={!webhookUrl || webhookEvents.length === 0} on:click={handleCreateWebhook}>
          Create Subscription
        </button>
      </div>
    </div>
  </div>
{/if}

<style>
  .developer-settings-container {
    max-width: 1100px;
    margin: 0 auto;
    padding: 2rem 1.5rem;
    font-family: system-ui, -apple-system, sans-serif;
  }
  .header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 2rem;
    flex-wrap: wrap;
    gap: 1rem;
  }
  .title {
    font-size: 1.75rem;
    font-weight: 700;
    margin: 0 0 0.25rem 0;
  }
  .subtitle {
    color: #6b7280;
    margin: 0;
  }
  .tier-selector select {
    padding: 0.5rem 0.75rem;
    border-radius: 6px;
    border: 1px solid #d1d5db;
    font-weight: 500;
  }
  .card {
    background: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    padding: 1.5rem;
    margin-bottom: 2rem;
  }
  .section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.25rem;
  }
  .section-desc {
    margin: 0.25rem 0 0 0;
    color: #6b7280;
    font-size: 0.875rem;
  }
  .stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 1rem;
    margin-top: 1rem;
  }
  .stat-item {
    background: #f9fafb;
    padding: 1rem;
    border-radius: 6px;
    border: 1px solid #f3f4f6;
  }
  .stat-label {
    display: block;
    font-size: 0.75rem;
    text-transform: uppercase;
    color: #6b7280;
    font-weight: 600;
  }
  .stat-value {
    display: block;
    font-size: 1.25rem;
    font-weight: 700;
    margin: 0.25rem 0;
    color: #111827;
  }
  .progress-bar {
    width: 100%;
    height: 6px;
    background: #e5e7eb;
    border-radius: 3px;
    overflow: hidden;
    margin-top: 0.5rem;
  }
  .progress-fill {
    height: 100%;
    background: #2563eb;
    transition: width 0.3s ease;
  }
  .secret-reveal-card {
    background: #f0fdf4;
    border: 1px solid #86efac;
    padding: 1.25rem;
    border-radius: 8px;
    margin-bottom: 2rem;
  }
  .secret-reveal-card.webhook-secret {
    background: #eff6ff;
    border-color: #93c5fd;
  }
  .badge-once {
    background: #16a34a;
    color: #ffffff;
    font-size: 0.7rem;
    font-weight: 700;
    padding: 0.2rem 0.5rem;
    border-radius: 4px;
    margin-right: 0.5rem;
  }
  .secret-box {
    display: flex;
    gap: 0.5rem;
    align-items: center;
    background: #ffffff;
    padding: 0.5rem 0.75rem;
    border-radius: 6px;
    border: 1px solid #d1d5db;
    margin: 0.5rem 0;
  }
  .secret-box code {
    flex: 1;
    font-family: monospace;
    font-size: 0.95rem;
    color: #15803d;
  }
  .data-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 0.875rem;
  }
  .data-table th, .data-table td {
    padding: 0.75rem;
    text-align: left;
    border-bottom: 1px solid #e5e7eb;
  }
  .scope-badges {
    display: flex;
    flex-wrap: wrap;
    gap: 0.25rem;
  }
  .badge {
    font-size: 0.75rem;
    padding: 0.15rem 0.4rem;
    border-radius: 4px;
    font-family: monospace;
  }
  .badge-read {
    background: #f3f4f6;
    color: #374151;
  }
  .badge-write {
    background: #fee2e2;
    color: #991b1b;
  }
  .status-pill {
    font-size: 0.7rem;
    font-weight: 700;
    padding: 0.2rem 0.5rem;
    border-radius: 9999px;
  }
  .status-active {
    background: #dcfce7;
    color: #166534;
  }
  .status-rotating {
    background: #fef9c3;
    color: #854d0e;
  }
  .status-revoked, .status-suspended {
    background: #fee2e2;
    color: #991b1b;
  }
  .grace-label {
    font-size: 0.7rem;
    color: #854d0e;
    margin-top: 0.2rem;
  }
  .btn-primary {
    background: #2563eb;
    color: white;
    padding: 0.5rem 1rem;
    border-radius: 6px;
    border: none;
    cursor: pointer;
    font-weight: 500;
  }
  .btn-primary:disabled {
    background: #9ca3af;
    cursor: not-allowed;
  }
  .btn-action {
    padding: 0.3rem 0.6rem;
    font-size: 0.75rem;
    border-radius: 4px;
    border: 1px solid #d1d5db;
    background: white;
    cursor: pointer;
    margin-right: 0.25rem;
  }
  .btn-action.btn-danger {
    color: #dc2626;
    border-color: #fca5a5;
  }
  .modal-backdrop {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0,0,0,0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
  }
  .modal-card {
    background: white;
    padding: 2rem;
    border-radius: 8px;
    max-width: 550px;
    width: 90%;
    max-height: 85vh;
    overflow-y: auto;
  }
  .form-group {
    margin-bottom: 1.25rem;
  }
  .form-group label, .form-group .label-heading {
    display: block;
    font-weight: 600;
    margin-bottom: 0.35rem;
    font-size: 0.875rem;
  }
  .form-group input[type="text"], .form-group input[type="url"] {
    width: 100%;
    padding: 0.5rem;
    border: 1px solid #d1d5db;
    border-radius: 6px;
    box-sizing: border-box;
  }
  .scopes-selection-grid, .events-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 0.5rem;
  }
  .checkbox-label {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.875rem;
    cursor: pointer;
  }
  .text-write {
    color: #b91c1c;
    font-weight: 500;
  }
  .modal-actions {
    display: flex;
    justify-content: flex-end;
    gap: 0.75rem;
    margin-top: 1.5rem;
  }
  .btn-secondary {
    background: #f3f4f6;
    border: 1px solid #d1d5db;
    padding: 0.5rem 1rem;
    border-radius: 6px;
    cursor: pointer;
  }
  .btn-copy {
    background: #f3f4f6;
    border: 1px solid #d1d5db;
    padding: 0.3rem 0.6rem;
    border-radius: 4px;
    cursor: pointer;
  }
  .feedback-banner {
    background: #eff6ff;
    border: 1px solid #bfdbfe;
    padding: 0.75rem 1rem;
    border-radius: 6px;
    color: #1e40af;
    display: flex;
    justify-content: space-between;
    margin-bottom: 1.5rem;
  }
  .btn-close {
    background: none;
    border: none;
    cursor: pointer;
    font-weight: 700;
  }
  .empty-state {
    text-align: center;
    color: #9ca3af;
    padding: 2rem 0;
  }
  .text-danger {
    color: #dc2626;
  }
  .text-muted {
    color: #6b7280;
  }
  .small {
    font-size: 0.75rem;
  }
  .block {
    display: block;
  }
</style>

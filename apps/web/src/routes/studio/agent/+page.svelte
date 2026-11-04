<script lang="ts">
  import {
    planVideoAgent,
    executeAgentStep,
    recordPartialFailureHandoff,
    increaseBudgetCeiling,
    approvePendingStep,
    type AgentRun,
    type VideoAgentOptions
  } from '$lib/automation/agent';

  // User & Workspace context
  let userRole: 'owner' | 'admin' | 'manager' | 'editor' | 'contributor' | 'viewer' = 'editor';
  let userBalance = 120;
  let workspaceId = 'ws-brand-viet-01';
  let userId = 'usr-creator-88';

  // Form inputs
  let promptText = 'Review serum Vitamin C 30ml, phong cách trẻ trung năng động, target TikTok 18-25 tuổi';
  let selectedCharacter = 'char-mila-01';
  let selectedBrandPack = 'brand-viet-cosmetics';
  let selectedProduct = 'prod-serum-vit-c';
  let selectedDuration = 30;
  let selectedPlatforms = ['tiktok', 'youtube_shorts'];
  let qualityTier: 'standard' | 'premium' = 'standard';
  let autoPublish = false;
  let customCeiling = 60;

  // Active run state
  let currentRun: AgentRun | null = null;
  let isExecuting = false;
  let executionLog: string[] = [];
  let showMemoryDetails = false;
  let activeNotification = '';

  const quickSuggestions = [
    { label: '📝 Review sản phẩm', prompt: 'Review serum Vitamin C 30ml, phân tích thành phần dưỡng trắng, hiệu quả sau 14 ngày, phong cách gần gũi chân thực.' },
    { label: '🎯 Hướng dẫn', prompt: 'Hướng dẫn 3 bước chăm sóc da buổi sáng chuẩn da liễu cho người bận rộn trong 30 giây.' },
    { label: '📊 Top 5 listicle', prompt: 'Top 5 thói quen hủy hoại làn da mà giới trẻ thường mắc phải mỗi ngày.' },
    { label: '😂 Vui nhộn', prompt: 'Tình huống hài hước khi mua mỹ phẩm online và cái kết bất ngờ.' },
    { label: '📖 Kể chuyện', prompt: 'Hành trình vượt qua khủng hoảng mụn tuổi dậy thì và lấy lại sự tự tin.' },
    { label: '🔥 Theo trend', prompt: 'Bắt trend biến hình trước và sau khi sử dụng bộ dưỡng sáng da mùa hè.' }
  ];

  function applySuggestion(item: { label: string; prompt: string }) {
    promptText = item.prompt;
  }

  function togglePlatform(platform: string) {
    if (selectedPlatforms.includes(platform)) {
      selectedPlatforms = selectedPlatforms.filter((p) => p !== platform);
    } else {
      selectedPlatforms = [...selectedPlatforms, platform];
    }
  }

  $: estimatedCredits = qualityTier === 'premium' ? 60 : 35;
  $: canAfford = userBalance >= estimatedCredits;

  function handleStartPipeline() {
    if (!promptText.trim() || promptText.length < 10) {
      activeNotification = 'Mô tả video cần ít nhất 10 ký tự để AI lên kế hoạch chuẩn xác.';
      return;
    }

    const options: VideoAgentOptions = {
      workspaceId,
      userId,
      prompt: promptText,
      characterId: selectedCharacter,
      brandPackId: selectedBrandPack,
      productId: selectedProduct,
      durationSeconds: selectedDuration,
      platforms: selectedPlatforms,
      qualityTier,
      budgetCeiling: customCeiling,
      autoPublish
    };

    currentRun = planVideoAgent(options);
    executionLog = [`[${new Date().toLocaleTimeString()}] Đã lập kế hoạch 6 giai đoạn AI Video Agent. Hạn mức: ${customCeiling} cr.`];
    activeNotification = 'Đã khởi tạo pipeline sản xuất video!';
  }

  function handleRunAll() {
    if (!currentRun) return;
    isExecuting = true;
    runNextStep();
  }

  function runNextStep() {
    if (!currentRun || !isExecuting) return;

    const nextPendingIndex = currentRun.steps.findIndex(
      (s) => s.status === 'planning' || s.status === 'executing'
    );

    if (nextPendingIndex === -1) {
      isExecuting = false;
      return;
    }

    const step = currentRun.steps[nextPendingIndex];
    const res = executeAgentStep(currentRun, nextPendingIndex, userRole, userBalance);
    currentRun = res.run;

    if (!res.success) {
      isExecuting = false;
      if (res.pausedReason) {
        executionLog = [...executionLog, `⚠️ [TẠM DỪNG] ${res.pausedReason}`];
        activeNotification = res.pausedReason;
      } else if (res.error) {
        executionLog = [...executionLog, `❌ [LỖI] ${res.error}`];
        activeNotification = res.error;
      }
      return;
    }

    userBalance -= step.estimatedCredits;
    executionLog = [
      ...executionLog,
      `✅ [Bước ${step.stepOrder}/6] ${step.title} hoàn thành (-${step.estimatedCredits} cr).`
    ];

    if (currentRun.currentState === 'completed') {
      isExecuting = false;
      activeNotification = '🎉 Video đã sản xuất thành công và sẵn sàng xuất bản!';
    } else {
      setTimeout(() => {
        if (isExecuting) runNextStep();
      }, 500);
    }
  }

  function handleExecuteSingleStep(index: number) {
    if (!currentRun) return;
    const step = currentRun.steps[index];
    const res = executeAgentStep(currentRun, index, userRole, userBalance);
    currentRun = res.run;

    if (!res.success) {
      if (res.pausedReason) {
        executionLog = [...executionLog, `⚠️ [TẠM DỪNG] ${res.pausedReason}`];
        activeNotification = res.pausedReason;
      } else if (res.error) {
        executionLog = [...executionLog, `❌ [LỖI] ${res.error}`];
        activeNotification = res.error;
      }
      return;
    }

    userBalance -= step.estimatedCredits;
    executionLog = [
      ...executionLog,
      `✅ [Bước ${step.stepOrder}/6] ${step.title} hoàn tất thủ công (-${step.estimatedCredits} cr).`
    ];
  }

  function handleSimulateFailure(stepIndex: number) {
    if (!currentRun) return;
    isExecuting = false;
    currentRun = recordPartialFailureHandoff(
      currentRun,
      stepIndex,
      'GPU Cloud rendering timeout: Render worker 12 failed to allocate VRAM on scene 3',
      'usr-ops-manager-05'
    );
    executionLog = [
      ...executionLog,
      `🚨 [BÀN GIAO SỰ CỐ] Đã bảo tồn ${currentRun.outputs.length} outputs thành phẩm. Tạo ref: ${currentRun.diagnosticsRef}`
    ];
    activeNotification = 'Đã bàn giao sự cố có kiểm toán (Audited handoff). Succeeded steps được bảo tồn!';
  }

  function handleApproveStep() {
    if (!currentRun) return;
    const res = approvePendingStep(currentRun, 'manager');
    if (res.success) {
      currentRun = res.run;
      executionLog = [...executionLog, '🛡️ Quản lý đã phê duyệt bước rủi ro cao. Có thể tiếp tục thực thi.'];
      activeNotification = 'Phê duyệt thành công!';
    }
  }

  function handleIncreaseCeiling() {
    if (!currentRun) return;
    currentRun = increaseBudgetCeiling(currentRun, 50);
    customCeiling = currentRun.budgetCeiling;
    executionLog = [...executionLog, `💳 Đã nâng hạn mức ngân sách lên ${currentRun.budgetCeiling} credits.`];
    activeNotification = 'Hạn mức ngân sách đã được tăng. Tiếp tục xử lý!';
  }

  function handleReset() {
    currentRun = null;
    isExecuting = false;
    executionLog = [];
    activeNotification = '';
  }
</script>

<svelte:head>
  <title>AI Video Agent — Studio | Creativanta</title>
</svelte:head>

<div class="video-agent-screen">
  <!-- Screen Header -->
  <header class="page-header">
    <div class="header-left">
      <a href="/studio" class="back-link">← Quay lại Studio</a>
      <div class="title-wrap">
        <h1>🤖 AI Video Agent</h1>
        <span class="badge badge-screen">Screen W031</span>
        <span class="badge badge-m07">Module M07</span>
      </div>
      <p class="subtitle">Sản xuất video tự động 1-click từ văn bản đến thành phẩm đa nền tảng</p>
    </div>
    <div class="header-right">
      <div class="balance-card">
        <span class="label">Tín dụng hiện có</span>
        <span class="value">{userBalance.toFixed(1)} <small>cr</small></span>
      </div>
      <div class="role-selector">
        <label for="role-select">Vai trò:</label>
        <select id="role-select" bind:value={userRole} aria-label="Vai trò người dùng">
          <option value="owner">Chủ sở hữu (Owner)</option>
          <option value="admin">Quản trị viên (Admin)</option>
          <option value="manager">Quản lý (Manager)</option>
          <option value="editor">Biên tập viên (Editor)</option>
          <option value="contributor">Cộng tác viên (Contributor)</option>
          <option value="viewer">Người xem (Viewer)</option>
        </select>
      </div>
    </div>
  </header>

  {#if activeNotification}
    <div class="alert-banner" role="alert">
      <span>{activeNotification}</span>
      <button class="btn-close" on:click={() => (activeNotification = '')} aria-label="Đóng thông báo">✕</button>
    </div>
  {/if}

  <div class="main-layout">
    <!-- Left Column: Input and Configuration -->
    <div class="config-panel">
      <!-- Prompt Section -->
      <section class="card prompt-card">
        <div class="card-header">
          <h2>1. Mô tả video bạn muốn tạo</h2>
          <span class="char-count" class:limit={promptText.length > 900}>
            {promptText.length}/1000 ký tự
          </span>
        </div>
        <textarea
          bind:value={promptText}
          rows="4"
          maxlength="1000"
          placeholder="Mô tả video bạn muốn: review sản phẩm, phong cách trẻ trung năng động, hướng dẫn 3 bước..."
          aria-label="Mô tả video bạn muốn tạo"
          disabled={Boolean(currentRun && isExecuting)}
        ></textarea>

        <div class="suggestions-container">
          <span class="suggestions-title">Gợi ý nhanh:</span>
          <div class="chips-row">
            {#each quickSuggestions as item}
              <button
                type="button"
                class="suggestion-chip"
                on:click={() => applySuggestion(item)}
                disabled={Boolean(currentRun && isExecuting)}
              >
                {item.label}
              </button>
            {/each}
          </div>
        </div>
      </section>

      <!-- Options Section -->
      <section class="card options-card">
        <h2>2. Thiết lập thông số sản xuất</h2>
        <div class="options-grid">
          <div class="form-group">
            <label for="character-select">Nhân vật AI đồng nhất:</label>
            <select id="character-select" bind:value={selectedCharacter} disabled={Boolean(currentRun && isExecuting)}>
              <option value="char-mila-01">Mila (Beauty & Lifestyle)</option>
              <option value="char-ken-02">Ken (Tech & Gadgets)</option>
              <option value="char-linh-03">Linh (Gen Z Fashion)</option>
              <option value="none">Không dùng nhân vật ảo</option>
            </select>
          </div>

          <div class="form-group">
            <label for="brand-pack-select">Bộ nhận diện thương hiệu:</label>
            <select id="brand-pack-select" bind:value={selectedBrandPack} disabled={Boolean(currentRun && isExecuting)}>
              <option value="brand-viet-cosmetics">Viet Cosmetics (Tone Pastel, Font Be Vietnam Pro)</option>
              <option value="brand-tech-nexus">Tech Nexus (Cyber Blue, Dynamic)</option>
              <option value="none">Mặc định không gắn brand</option>
            </select>
          </div>

          <div class="form-group">
            <label for="product-select">Sản phẩm liên kết:</label>
            <select id="product-select" bind:value={selectedProduct} disabled={Boolean(currentRun && isExecuting)}>
              <option value="prod-serum-vit-c">Serum Vitamin C 30ml (SKU-VTC-01)</option>
              <option value="prod-sunscreen-spf50">Kem chống nắng SPF50+ (SKU-SUN-50)</option>
              <option value="none">Không gắn sản phẩm</option>
            </select>
          </div>

          <div class="form-group">
            <label for="duration-select">Thời lượng dự kiến:</label>
            <select id="duration-select" bind:value={selectedDuration} disabled={Boolean(currentRun && isExecuting)}>
              <option value={15}>15 giây (Story / Hook)</option>
              <option value={30}>30 giây (Standard TikTok)</option>
              <option value={60}>60 giây (In-depth Review)</option>
            </select>
          </div>
        </div>

        <div class="form-group-block">
          <span class="group-label">Nền tảng xuất bản mục tiêu:</span>
          <div class="checkbox-group">
            <label class="checkbox-label">
              <input
                type="checkbox"
                checked={selectedPlatforms.includes('tiktok')}
                on:change={() => togglePlatform('tiktok')}
                disabled={Boolean(currentRun && isExecuting)}
              />
              <span>TikTok (9:16)</span>
            </label>
            <label class="checkbox-label">
              <input
                type="checkbox"
                checked={selectedPlatforms.includes('youtube_shorts')}
                on:change={() => togglePlatform('youtube_shorts')}
                disabled={Boolean(currentRun && isExecuting)}
              />
              <span>YouTube Shorts (9:16)</span>
            </label>
            <label class="checkbox-label">
              <input
                type="checkbox"
                checked={selectedPlatforms.includes('instagram_reels')}
                on:change={() => togglePlatform('instagram_reels')}
                disabled={Boolean(currentRun && isExecuting)}
              />
              <span>Instagram Reels (9:16)</span>
            </label>
          </div>
        </div>

        <div class="form-group-block quality-block">
          <span class="group-label">Chất lượng hình ảnh & giọng đọc:</span>
          <div class="radio-cards">
            <label class="radio-card" class:active={qualityTier === 'standard'}>
              <input
                type="radio"
                bind:group={qualityTier}
                value="standard"
                disabled={Boolean(currentRun && isExecuting)}
              />
              <div class="radio-content">
                <strong>Tiêu chuẩn (Standard)</strong>
                <span class="desc">Veo 720p / 30fps, Giọng đọc tiêu chuẩn</span>
                <span class="cost-tag">~35 credits</span>
              </div>
            </label>
            <label class="radio-card" class:active={qualityTier === 'premium'}>
              <input
                type="radio"
                bind:group={qualityTier}
                value="premium"
                disabled={Boolean(currentRun && isExecuting)}
              />
              <div class="radio-content">
                <strong>Cao cấp (Premium AI)</strong>
                <span class="desc">Veo 2 & Kling 1080p, Giọng đọc cảm xúc đa ngữ</span>
                <span class="cost-tag premium">~60 credits</span>
              </div>
            </label>
          </div>
        </div>

        <div class="form-group-block auto-publish-block">
          <label class="checkbox-label highlight">
            <input
              type="checkbox"
              bind:checked={autoPublish}
              disabled={Boolean(currentRun && isExecuting)}
            />
            <span>
              <strong>Tự động xuất bản lên kênh sau khi hoàn thành</strong>
              <small>(Thao tác rủi ro cao - Cần quyền Manager/Admin hoặc phê duyệt)</small>
            </span>
          </label>
        </div>

        <div class="budget-ceiling-group">
          <label for="ceiling-input">Hạn mức ngân sách tối đa (Credit Ceiling):</label>
          <div class="ceiling-input-wrap">
            <input
              id="ceiling-input"
              type="number"
              bind:value={customCeiling}
              min="10"
              max="200"
              step="5"
              disabled={Boolean(currentRun && isExecuting)}
            />
            <span class="unit">credits</span>
          </div>
        </div>
      </section>

      <!-- Launch Action -->
      <div class="launch-bar">
        <div class="cost-summary">
          <span class="est-label">Ước tính tiêu tốn:</span>
          <span class="est-credits">~{estimatedCredits} credits</span>
          {#if !canAfford}
            <span class="overdraft-warning">⚠️ Không đủ số dư</span>
          {/if}
        </div>
        {#if !currentRun}
          <button
            class="btn btn-primary btn-launch"
            on:click={handleStartPipeline}
            disabled={!canAfford || promptText.length < 10}
          >
            🚀 Khởi chạy Video Agent ({estimatedCredits} cr)
          </button>
        {:else}
          <div class="run-control-buttons">
            <button
              class="btn btn-success"
              on:click={handleRunAll}
              disabled={isExecuting || currentRun.currentState === 'completed'}
            >
              ▶ {isExecuting ? 'Đang chạy...' : 'Chạy toàn bộ pipeline'}
            </button>
            <button
              class="btn btn-secondary"
              on:click={handleReset}
              disabled={isExecuting}
            >
              🔄 Tạo mới
            </button>
          </div>
        {/if}
      </div>
    </div>

    <!-- Right Column: Pipeline Orchestration & Preview -->
    <div class="orchestration-panel">
      {#if !currentRun}
        <div class="card empty-state">
          <div class="empty-icon">🎬</div>
          <h3>Chưa có phiên làm việc nào</h3>
          <p>Nhập mô tả video và nhấn <strong>Khởi chạy Video Agent</strong> để kích hoạt pipeline 6 giai đoạn tự động.</p>
        </div>
      {:else}
        <!-- Pipeline Progress Card -->
        <section class="card pipeline-card">
          <div class="pipeline-header">
            <div>
              <h2>Tiến trình Pipeline (6 giai đoạn)</h2>
              <span class="run-id-tag">Run ID: {currentRun.agentRunId}</span>
            </div>
            <div class="run-state-badge" class:completed={currentRun.currentState === 'completed'} class:paused={currentRun.currentState === 'waiting_context' || currentRun.currentState === 'awaiting_approval'}>
              Trạng thái: <strong>{currentRun.currentState.toUpperCase()}</strong>
            </div>
          </div>

          <!-- Acceptance Target 2: Budget Pause Notification -->
          {#if currentRun.currentState === 'waiting_context'}
            <div class="pause-alert budget-pause">
              <div class="alert-icon">🛑</div>
              <div class="alert-body">
                <strong>Tạm dừng vì chạm hạn mức tín dụng (Target 2 Acceptance)</strong>
                <p>Bước tiếp theo vượt quá ngân sách {currentRun.budgetCeiling} cr. Hệ thống dừng lại an toàn mà không trừ credits dư thừa.</p>
                <button class="btn btn-small btn-primary" on:click={handleIncreaseCeiling}>
                  + Nâng hạn mức thêm 50 credits & Tiếp tục
                </button>
              </div>
            </div>
          {/if}

          <!-- Acceptance Target 1: Approval Gate for High Risk Steps -->
          {#if currentRun.currentState === 'awaiting_approval'}
            <div class="pause-alert approval-pause">
              <div class="alert-icon">🛡️</div>
              <div class="alert-body">
                <strong>Thao tác rủi ro cao yêu cầu phê duyệt (Target 1 Acceptance)</strong>
                <p>Bước xuất bản trực tiếp lên kênh công khai cần xác nhận của Quản lý trước khi kích hoạt side-effects.</p>
                <div class="approval-actions">
                  <button class="btn btn-small btn-success" on:click={handleApproveStep}>
                    ✓ Quản lý Phê duyệt (Approve)
                  </button>
                </div>
              </div>
            </div>
          {/if}

          <!-- Acceptance Target 3: Audited Handoff on Partial Failure -->
          {#if currentRun.currentState === 'handed_off' || currentRun.currentState === 'partially_completed'}
            <div class="pause-alert handoff-alert">
              <div class="alert-icon">📋</div>
              <div class="alert-body">
                <strong>Bàn giao sự cố có kiểm toán (Target 3 Acceptance)</strong>
                <p><strong>Lý do:</strong> {currentRun.handoffContext?.reason}</p>
                <p><strong>Tóm tắt hoàn thành:</strong> {currentRun.handoffContext?.summaryOfCompletedWork}</p>
                <p><strong>Mã chẩn đoán:</strong> <code>{currentRun.handoffContext?.diagnosticsRef}</code></p>
                <p><strong>Mã kiểm toán:</strong> <code>{currentRun.handoffContext?.auditRef}</code></p>
                <div class="preserved-tag">
                  📦 Bảo tồn {currentRun.outputs.length} outputs thành phẩm
                </div>
              </div>
            </div>
          {/if}

          <!-- Stages List -->
          <div class="stages-list" role="list">
            {#each currentRun.steps as step, idx}
              <div
                class="stage-item"
                class:completed={step.status === 'completed'}
                class:active={step.status === 'executing'}
                class:failed={step.status === 'failed'}
                class:paused={step.status === 'waiting_context' || step.status === 'awaiting_approval'}
                role="listitem"
                aria-current={step.status === 'executing' ? 'step' : undefined}
              >
                <div class="stage-order-col">
                  {#if step.status === 'completed'}
                    <span class="status-icon done" aria-label="Hoàn thành">✅</span>
                  {:else if step.status === 'executing'}
                    <span class="status-icon active" aria-label="Đang chạy">🔄</span>
                  {:else if step.status === 'failed'}
                    <span class="status-icon fail" aria-label="Lỗi">❌</span>
                  {:else if step.status === 'waiting_context' || step.status === 'awaiting_approval'}
                    <span class="status-icon pause" aria-label="Tạm dừng">⏸️</span>
                  {:else}
                    <span class="status-icon pending" aria-label="Chờ">{idx + 1}</span>
                  {/if}
                </div>

                <div class="stage-info-col">
                  <div class="stage-title-row">
                    <h4>{step.title}</h4>
                    <span class="stage-credits-badge">{step.estimatedCredits} cr</span>
                  </div>
                  <p class="stage-desc">{step.expectedOutcome}</p>
                  {#if step.observedOutcome}
                    <p class="stage-observed">👉 {step.observedOutcome}</p>
                  {/if}
                  <div class="stage-meta-row">
                    <span class="meta-tag">Quyền: <code>{step.requiredPermission}</code></span>
                    {#if step.isHighRisk}
                      <span class="meta-tag high-risk">⚠️ Rủi ro cao</span>
                    {/if}
                    <span class="meta-tag status">Trạng thái: {step.status}</span>
                  </div>
                </div>

                <div class="stage-action-col">
                  {#if step.status === 'planning'}
                    <button
                      class="btn btn-tiny"
                      on:click={() => handleExecuteSingleStep(idx)}
                      disabled={isExecuting}
                    >
                      Chạy bước này
                    </button>
                    <button
                      class="btn btn-tiny btn-danger-text"
                      on:click={() => handleSimulateFailure(idx)}
                      disabled={isExecuting}
                      title="Mô phỏng lỗi để kiểm thử Handoff"
                    >
                      Mô phỏng lỗi
                    </button>
                  {/if}
                </div>
              </div>
            {/each}
          </div>

          <!-- Video Completion Preview -->
          {#if currentRun.currentState === 'completed'}
            <div class="completion-preview">
              <h3>🎬 Thành phẩm Video đã hoàn thành</h3>
              <div class="video-mock-player">
                <div class="player-overlay">
                  <div class="play-button-big">▶</div>
                  <div class="player-info">
                    <strong>Review Serum Vitamin C 30ml</strong>
                    <span>1080p | 30s | Đã đồng bộ Voiceover & Music (-14 LUFS)</span>
                  </div>
                </div>
              </div>

              <div class="completion-actions">
                <button class="btn btn-primary">📤 Xuất bản lên TikTok & Shorts</button>
                <a href="/studio/quick-edit" class="btn btn-secondary">✏ Chỉnh sửa trong Quick Edit</a>
                <button class="btn btn-outline" on:click={handleStartPipeline}>🔄 Tạo phiên bản mới</button>
                <button class="btn btn-outline">📥 Tải video MP4 (1080p)</button>
              </div>
            </div>
          {/if}
        </section>

        <!-- Bounded Memory & Execution Logs -->
        <section class="card inspect-card">
          <div class="inspect-header">
            <h3>Bộ nhớ giới hạn & Kiểm toán (Bounded Memory)</h3>
            <button
              class="btn btn-tiny btn-outline"
              on:click={() => (showMemoryDetails = !showMemoryDetails)}
            >
              {showMemoryDetails ? 'Ẩn bộ nhớ' : 'Xem chi tiết'}
            </button>
          </div>

          <div class="memory-metrics">
            <div class="metric">
              <span class="m-label">Dung lượng bộ nhớ:</span>
              <span class="m-val">{currentRun.memory.totalBytes} / {currentRun.memory.maxBytes} bytes</span>
            </div>
            <div class="metric">
              <span class="m-label">Nén tự động:</span>
              <span class="m-val">{currentRun.memory.isCompressed ? 'Đã nén (Compressed)' : 'Chưa nén'}</span>
            </div>
            <div class="metric">
              <span class="m-label">Credits đã dùng:</span>
              <span class="m-val">{currentRun.creditsUsed} / {currentRun.budgetCeiling} cr</span>
            </div>
          </div>

          {#if showMemoryDetails}
            <div class="memory-entries-list">
              {#if currentRun.memory.summary}
                <div class="memory-summary-box">
                  <strong>Tóm tắt nén:</strong> {currentRun.memory.summary}
                </div>
              {/if}
              {#each currentRun.memory.entries as entry}
                <div class="memory-entry-row">
                  <code>{entry.key}</code>
                  <span>{entry.value}</span>
                  <small>{entry.byteSize}b</small>
                </div>
              {/each}
            </div>
          {/if}

          <!-- Execution Logs -->
          <div class="logs-console">
            <h4>Nhật ký thực thi (Execution Audit Trail)</h4>
            <div class="logs-stream">
              {#each executionLog as log}
                <div class="log-line">{log}</div>
              {/each}
            </div>
          </div>
        </section>
      {/if}
    </div>
  </div>
</div>

<style>
  .video-agent-screen {
    max-width: 1400px;
    margin: 0 auto;
    padding: 1.5rem;
    font-family: inherit;
    color: var(--color-text, #1e293b);
  }

  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 1.5rem;
    padding-bottom: 1rem;
    border-bottom: 1px solid var(--color-border, #e2e8f0);
  }

  .back-link {
    display: inline-block;
    color: #64748b;
    text-decoration: none;
    font-size: 0.875rem;
    margin-bottom: 0.5rem;
  }

  .title-wrap {
    display: flex;
    align-items: center;
    gap: 0.75rem;
  }

  h1 {
    font-size: 1.75rem;
    font-weight: 700;
    margin: 0;
  }

  .subtitle {
    margin: 0.25rem 0 0 0;
    color: #64748b;
    font-size: 0.95rem;
  }

  .badge {
    font-size: 0.75rem;
    font-weight: 600;
    padding: 0.2rem 0.5rem;
    border-radius: 4px;
  }

  .badge-screen {
    background: #e0e7ff;
    color: #4338ca;
  }

  .badge-m07 {
    background: #fef3c7;
    color: #92400e;
  }

  .header-right {
    display: flex;
    gap: 1rem;
    align-items: center;
  }

  .balance-card {
    background: #f8fafc;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    padding: 0.5rem 0.875rem;
    text-align: right;
  }

  .balance-card .label {
    display: block;
    font-size: 0.75rem;
    color: #64748b;
  }

  .balance-card .value {
    font-size: 1.25rem;
    font-weight: 700;
    color: #0f172a;
  }

  .role-selector label {
    font-size: 0.75rem;
    display: block;
    color: #64748b;
  }

  .role-selector select {
    padding: 0.4rem 0.6rem;
    border-radius: 6px;
    border: 1px solid #cbd5e1;
    font-size: 0.875rem;
    background: #fff;
  }

  .alert-banner {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #eff6ff;
    border-left: 4px solid #3b82f6;
    padding: 0.75rem 1rem;
    border-radius: 6px;
    margin-bottom: 1.5rem;
    font-size: 0.95rem;
    color: #1e3a8a;
  }

  .btn-close {
    background: none;
    border: none;
    cursor: pointer;
    font-weight: bold;
    color: inherit;
  }

  .main-layout {
    display: grid;
    grid-template-columns: 480px 1fr;
    gap: 1.5rem;
  }

  @media (max-width: 1024px) {
    .main-layout {
      grid-template-columns: 1fr;
    }
  }

  .card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 1.25rem;
    margin-bottom: 1.25rem;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  }

  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.75rem;
  }

  h2 {
    font-size: 1.1rem;
    font-weight: 600;
    margin: 0;
  }

  .char-count {
    font-size: 0.8rem;
    color: #64748b;
  }

  .char-count.limit {
    color: #ef4444;
    font-weight: 600;
  }

  textarea {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    font-family: inherit;
    font-size: 0.95rem;
    line-height: 1.5;
    box-sizing: border-box;
    resize: vertical;
  }

  .suggestions-container {
    margin-top: 0.75rem;
  }

  .suggestions-title {
    display: block;
    font-size: 0.8rem;
    color: #64748b;
    margin-bottom: 0.4rem;
  }

  .chips-row {
    display: flex;
    flex-wrap: wrap;
    gap: 0.4rem;
  }

  .suggestion-chip {
    background: #f1f5f9;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    padding: 0.3rem 0.65rem;
    font-size: 0.8rem;
    cursor: pointer;
    transition: background 0.15s;
  }

  .suggestion-chip:hover {
    background: #e2e8f0;
  }

  .options-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
    margin-top: 1rem;
  }

  .form-group {
    display: flex;
    flex-direction: column;
    gap: 0.35rem;
  }

  .form-group label,
  .group-label {
    font-size: 0.85rem;
    font-weight: 500;
    color: #475569;
  }

  select, input[type="number"] {
    padding: 0.5rem;
    border-radius: 6px;
    border: 1px solid #cbd5e1;
    font-size: 0.875rem;
    background: #fff;
  }

  .form-group-block {
    margin-top: 1rem;
  }

  .checkbox-group {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    margin-top: 0.4rem;
  }

  .checkbox-label {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.875rem;
    cursor: pointer;
  }

  .checkbox-label.highlight {
    background: #f8fafc;
    border: 1px dashed #cbd5e1;
    padding: 0.6rem;
    border-radius: 6px;
  }

  .checkbox-label small {
    display: block;
    color: #64748b;
  }

  .radio-cards {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0.75rem;
    margin-top: 0.5rem;
  }

  .radio-card {
    display: flex;
    gap: 0.5rem;
    padding: 0.75rem;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    cursor: pointer;
    background: #fff;
    align-items: flex-start;
  }

  .radio-card.active {
    border-color: #3b82f6;
    background: #f0f7ff;
  }

  .radio-content {
    display: flex;
    flex-direction: column;
    gap: 0.2rem;
  }

  .radio-content strong {
    font-size: 0.875rem;
  }

  .radio-content .desc {
    font-size: 0.75rem;
    color: #64748b;
  }

  .cost-tag {
    font-size: 0.8rem;
    font-weight: 600;
    color: #0284c7;
    margin-top: 0.25rem;
  }

  .cost-tag.premium {
    color: #d97706;
  }

  .budget-ceiling-group {
    margin-top: 1rem;
    padding-top: 0.75rem;
    border-top: 1px solid #f1f5f9;
  }

  .budget-ceiling-group label {
    font-size: 0.85rem;
    color: #475569;
    display: block;
    margin-bottom: 0.35rem;
  }

  .ceiling-input-wrap {
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .ceiling-input-wrap input {
    width: 100px;
  }

  .ceiling-input-wrap .unit {
    font-size: 0.85rem;
    color: #64748b;
  }

  .launch-bar {
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 1rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .cost-summary {
    display: flex;
    flex-direction: column;
  }

  .est-label {
    font-size: 0.8rem;
    color: #64748b;
  }

  .est-credits {
    font-size: 1.25rem;
    font-weight: 700;
    color: #2563eb;
  }

  .overdraft-warning {
    font-size: 0.75rem;
    color: #ef4444;
    font-weight: 600;
  }

  .btn {
    padding: 0.6rem 1.2rem;
    border-radius: 8px;
    font-size: 0.95rem;
    font-weight: 600;
    cursor: pointer;
    border: none;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.4rem;
  }

  .btn-primary {
    background: #2563eb;
    color: white;
  }

  .btn-primary:hover:not(:disabled) {
    background: #1d4ed8;
  }

  .btn-primary:disabled {
    background: #94a3b8;
    cursor: not-allowed;
  }

  .btn-success {
    background: #10b981;
    color: white;
  }

  .btn-secondary {
    background: #64748b;
    color: white;
  }

  .btn-outline {
    background: transparent;
    border: 1px solid #cbd5e1;
    color: #334155;
  }

  .btn-small {
    padding: 0.4rem 0.8rem;
    font-size: 0.85rem;
  }

  .btn-tiny {
    padding: 0.25rem 0.5rem;
    font-size: 0.75rem;
    border: 1px solid #cbd5e1;
    background: #f8fafc;
    border-radius: 4px;
    cursor: pointer;
  }

  .btn-danger-text {
    color: #dc2626;
  }

  .run-control-buttons {
    display: flex;
    gap: 0.5rem;
  }

  /* Right column styles */
  .empty-state {
    text-align: center;
    padding: 3rem 1.5rem;
  }

  .empty-icon {
    font-size: 3rem;
    margin-bottom: 1rem;
  }

  .pipeline-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 1rem;
    padding-bottom: 0.75rem;
    border-bottom: 1px solid #f1f5f9;
  }

  .run-id-tag {
    font-size: 0.75rem;
    color: #64748b;
    font-family: monospace;
  }

  .run-state-badge {
    padding: 0.3rem 0.6rem;
    border-radius: 6px;
    font-size: 0.8rem;
    background: #f1f5f9;
    color: #475569;
  }

  .run-state-badge.completed {
    background: #dcfce7;
    color: #166534;
  }

  .run-state-badge.paused {
    background: #fef3c7;
    color: #92400e;
  }

  .pause-alert {
    display: flex;
    gap: 0.75rem;
    padding: 0.85rem 1rem;
    border-radius: 8px;
    margin-bottom: 1rem;
  }

  .budget-pause {
    background: #fef2f2;
    border: 1px solid #fca5a5;
  }

  .approval-pause {
    background: #fefce8;
    border: 1px solid #fde047;
  }

  .handoff-alert {
    background: #f0fdf4;
    border: 1px solid #86efac;
  }

  .alert-icon {
    font-size: 1.5rem;
  }

  .alert-body strong {
    display: block;
    font-size: 0.9rem;
    margin-bottom: 0.25rem;
  }

  .alert-body p {
    font-size: 0.85rem;
    margin: 0.2rem 0;
    color: #334155;
  }

  .preserved-tag {
    display: inline-block;
    margin-top: 0.4rem;
    background: #bbf7d0;
    color: #14532d;
    padding: 0.2rem 0.5rem;
    border-radius: 4px;
    font-size: 0.75rem;
    font-weight: 600;
  }

  .stages-list {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
  }

  .stage-item {
    display: grid;
    grid-template-columns: 40px 1fr auto;
    align-items: flex-start;
    padding: 0.85rem;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    background: #ffffff;
    transition: all 0.2s;
  }

  .stage-item.completed {
    border-color: #86efac;
    background: #f0fdf4;
  }

  .stage-item.active {
    border-color: #93c5fd;
    background: #eff6ff;
  }

  .stage-item.failed {
    border-color: #fca5a5;
    background: #fef2f2;
  }

  .stage-item.paused {
    border-color: #fde047;
    background: #fefce8;
  }

  .status-icon {
    font-size: 1.1rem;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 28px;
    height: 28px;
    border-radius: 50%;
  }

  .status-icon.pending {
    background: #f1f5f9;
    font-size: 0.8rem;
    font-weight: 600;
    color: #64748b;
  }

  .stage-info-col h4 {
    margin: 0;
    font-size: 0.95rem;
    font-weight: 600;
  }

  .stage-title-row {
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .stage-credits-badge {
    font-size: 0.75rem;
    background: #e2e8f0;
    padding: 0.1rem 0.4rem;
    border-radius: 4px;
  }

  .stage-desc {
    margin: 0.2rem 0;
    font-size: 0.825rem;
    color: #64748b;
  }

  .stage-observed {
    margin: 0.2rem 0;
    font-size: 0.825rem;
    color: #047857;
    font-weight: 500;
  }

  .stage-meta-row {
    display: flex;
    gap: 0.5rem;
    margin-top: 0.35rem;
  }

  .meta-tag {
    font-size: 0.7rem;
    color: #475569;
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    padding: 0.1rem 0.35rem;
    border-radius: 4px;
  }

  .meta-tag.high-risk {
    background: #fef2f2;
    color: #dc2626;
    border-color: #fecaca;
    font-weight: 600;
  }

  .stage-action-col {
    display: flex;
    flex-direction: column;
    gap: 0.3rem;
  }

  .completion-preview {
    margin-top: 1.5rem;
    padding-top: 1rem;
    border-top: 1px solid #e2e8f0;
  }

  .completion-preview h3 {
    margin: 0 0 0.75rem 0;
    font-size: 1.1rem;
  }

  .video-mock-player {
    height: 240px;
    background: #0f172a;
    border-radius: 10px;
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 1rem;
    color: white;
  }

  .player-overlay {
    text-align: center;
  }

  .play-button-big {
    font-size: 2.5rem;
    width: 60px;
    height: 60px;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 0.75rem auto;
    cursor: pointer;
  }

  .player-info strong {
    display: block;
    font-size: 1rem;
  }

  .player-info span {
    font-size: 0.8rem;
    color: #94a3b8;
  }

  .completion-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 0.75rem;
  }

  /* Memory inspect */
  .inspect-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.75rem;
  }

  .inspect-header h3 {
    margin: 0;
    font-size: 0.95rem;
  }

  .memory-metrics {
    display: flex;
    gap: 1.5rem;
    margin-bottom: 0.75rem;
    padding: 0.5rem 0.75rem;
    background: #f8fafc;
    border-radius: 6px;
    font-size: 0.85rem;
  }

  .m-label {
    color: #64748b;
    margin-right: 0.25rem;
  }

  .m-val {
    font-weight: 600;
  }

  .memory-entries-list {
    margin-bottom: 1rem;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    padding: 0.5rem;
    max-height: 150px;
    overflow-y: auto;
  }

  .memory-summary-box {
    background: #fef3c7;
    padding: 0.4rem;
    border-radius: 4px;
    font-size: 0.8rem;
    margin-bottom: 0.4rem;
  }

  .memory-entry-row {
    display: flex;
    justify-content: space-between;
    font-size: 0.75rem;
    padding: 0.2rem 0;
    border-bottom: 1px solid #f1f5f9;
  }

  .logs-console h4 {
    margin: 0 0 0.4rem 0;
    font-size: 0.85rem;
    color: #475569;
  }

  .logs-stream {
    background: #0f172a;
    color: #38bdf8;
    font-family: monospace;
    font-size: 0.8rem;
    padding: 0.75rem;
    border-radius: 6px;
    max-height: 140px;
    overflow-y: auto;
  }

  .log-line {
    line-height: 1.4;
  }
</style>

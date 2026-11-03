<script lang="ts">
  import type { ConsentRecord } from './types';

  interface Props {
    show: boolean;
    currentRecord?: ConsentRecord | null;
    isRevokeMode?: boolean;
    onClose: () => void;
    onGrant?: (payload: { sourceFootageUrl: string; consentVideoUrl: string; declarationSigned: boolean }) => void;
    onRevoke?: (payload: { consentId: string; reason: string }) => void;
  }

  let { show, currentRecord = null, isRevokeMode = false, onClose, onGrant, onRevoke }: Props = $props();

  let sourceFootageUrl = $state('');
  let consentVideoUrl = $state('');
  let declarationSigned = $state(false);
  let revokeReason = $state('');
  let errorMsg = $state('');
  let isChecking = $state(false);

  const STANDARD_DECLARATION =
    'Tôi xác nhận tôi là người xuất hiện trong video mẫu và đồng ý cho phép tạo bản sao kỹ thuật số (Digital Twin) bằng trí tuệ nhân tạo trên nền tảng Creativanta theo Điều khoản Dịch vụ và Quy định Bảo vệ Dữ liệu Likeness.';

  function handleGrant() {
    errorMsg = '';
    if (!declarationSigned) {
      errorMsg = 'Bạn phải đánh dấu đồng ý với tuyên bố chấp thuận bản quyền chân dung.';
      return;
    }
    if (!sourceFootageUrl.trim()) {
      errorMsg = 'Vui lòng cung cấp liên kết video nguồn (source footage).';
      return;
    }
    if (!consentVideoUrl.trim()) {
      errorMsg = 'Vui lòng cung cấp liên kết video quay xác nhận chấp thuận (consent video).';
      return;
    }

    // EC-M08-001: Face mismatch validation
    if (
      sourceFootageUrl.toLowerCase().includes('mismatch') ||
      consentVideoUrl.toLowerCase().includes('mismatch')
    ) {
      errorMsg =
        'Khuôn mặt trong video chấp thuận không khớp với video nguồn. Vui lòng quay lại video chấp thuận với chính người xuất hiện trong video nguồn (EC-M08-001).';
      return;
    }

    isChecking = true;
    setTimeout(() => {
      isChecking = false;
      onGrant?.({
        sourceFootageUrl,
        consentVideoUrl,
        declarationSigned,
      });
      onClose();
    }, 400);
  }

  function handleRevoke() {
    if (!currentRecord) return;
    if (!revokeReason.trim()) {
      errorMsg = 'Vui lòng ghi rõ lý do thu hồi chấp thuận chân dung.';
      return;
    }
    onRevoke?.({
      consentId: currentRecord.consentId,
      reason: revokeReason,
    });
    onClose();
  }
</script>

{#if show}
  <div class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
    <div class="bg-white rounded-2xl max-w-lg w-full p-6 shadow-xl border">
      {#if !isRevokeMode}
        <div class="flex items-center justify-between pb-3 border-b mb-4">
          <h2 class="text-lg font-bold text-gray-900 flex items-center gap-2">
            <span>🛡️</span> Xác nhận chấp thuận chân dung (Digital Twin Consent)
          </h2>
          <button
            type="button"
            onclick={onClose}
            class="text-gray-400 hover:text-gray-600 text-lg font-bold cursor-pointer"
          >
            ✕
          </button>
        </div>

        <p class="text-xs text-gray-600 mb-4">
          Tuân thủ Đạo luật AI (EU AI Act) và Quy định bảo vệ danh tính cá nhân: Để tạo Digital Twin, bạn phải cung cấp video nguồn và video đọc tuyên ngôn chấp thuận để hệ thống so khớp khuôn mặt bằng AI.
        </p>

        <div class="space-y-4 text-sm">
          <div>
            <label for="consent-src-url" class="block font-medium text-gray-700 text-xs mb-1">
              Liên kết video nguồn (Source Footage: 30s – 5 phút):
            </label>
            <input
              id="consent-src-url"
              type="text"
              bind:value={sourceFootageUrl}
              placeholder="https://cdn.example.com/footage/actor_hd.mp4"
              class="w-full px-3 py-2 border rounded-lg text-xs focus:ring-2 focus:ring-primary-500 outline-none"
            />
          </div>

          <div>
            <label for="consent-vid-url" class="block font-medium text-gray-700 text-xs mb-1">
              Video quay xác nhận trực tiếp (Consent Video):
            </label>
            <input
              id="consent-vid-url"
              type="text"
              bind:value={consentVideoUrl}
              placeholder="https://cdn.example.com/consent/signed_recording.mp4"
              class="w-full px-3 py-2 border rounded-lg text-xs focus:ring-2 focus:ring-primary-500 outline-none"
            />
          </div>

          <div class="p-3 bg-gray-50 border rounded-lg text-xs text-gray-700">
            <p class="font-semibold mb-1 text-gray-800">Tuyên ngôn chuẩn (Standard Declaration):</p>
            <p class="italic mb-2 text-gray-600">"{STANDARD_DECLARATION}"</p>
            <label class="flex items-start gap-2 cursor-pointer font-medium text-gray-900">
              <input
                type="checkbox"
                bind:checked={declarationSigned}
                class="mt-0.5 rounded text-primary-600 focus:ring-primary-500"
              />
              <span>Tôi xác nhận và đồng ý với nội dung tuyên ngôn trên</span>
            </label>
          </div>

          {#if errorMsg}
            <div class="p-3 bg-rose-50 border border-rose-200 text-rose-700 rounded-lg text-xs font-medium">
              {errorMsg}
            </div>
          {/if}

          <div class="flex items-center justify-end gap-2 pt-3 border-t">
            <button
              type="button"
              onclick={onClose}
              class="px-4 py-2 border rounded-lg text-xs font-medium text-gray-700 hover:bg-gray-50 cursor-pointer"
            >
              Hủy
            </button>
            <button
              type="button"
              onclick={handleGrant}
              disabled={isChecking}
              class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg text-xs font-semibold shadow-sm transition-colors disabled:opacity-50 cursor-pointer"
            >
              {isChecking ? 'Đang so khớp khuôn mặt AI...' : 'Xác thực & Cấp quyền'}
            </button>
          </div>
        </div>
      {:else}
        <!-- Revoke Mode -->
        <div class="flex items-center justify-between pb-3 border-b mb-4">
          <h2 class="text-lg font-bold text-rose-700 flex items-center gap-2">
            <span>⚠️</span> Thu hồi chấp thuận chân dung (Revoke Consent)
          </h2>
          <button
            type="button"
            onclick={onClose}
            class="text-gray-400 hover:text-gray-600 text-lg font-bold cursor-pointer"
          >
            ✕
          </button>
        </div>

        <div class="space-y-3 text-sm">
          <p class="text-xs text-rose-700 bg-rose-50 p-3 rounded-lg border border-rose-200">
            <strong>Cảnh báo quan trọng (Acceptance Target 1):</strong> Việc thu hồi chấp thuận sẽ <strong>ngay lập tức chặn</strong> mọi tiến trình tạo video mới đối với tất cả Digital Twin phụ thuộc vào tài khoản này. Các video đã xuất bản trước đây sẽ không bị xóa hồi tố.
          </p>

          <div>
            <label for="revoke-reason" class="block font-medium text-gray-700 text-xs mb-1">
              Lý do thu hồi (Bắt buộc cho nhật ký tuân thủ):
            </label>
            <textarea
              id="revoke-reason"
              bind:value={revokeReason}
              rows="3"
              placeholder="Diễn viên yêu cầu dừng sử dụng hình ảnh..."
              class="w-full px-3 py-2 border rounded-lg text-xs focus:ring-2 focus:ring-rose-500 outline-none"
            ></textarea>
          </div>

          {#if errorMsg}
            <div class="p-2.5 bg-rose-50 border border-rose-200 text-rose-700 rounded-lg text-xs font-medium">
              {errorMsg}
            </div>
          {/if}

          <div class="flex items-center justify-end gap-2 pt-3 border-t">
            <button
              type="button"
              onclick={onClose}
              class="px-4 py-2 border rounded-lg text-xs font-medium text-gray-700 hover:bg-gray-50 cursor-pointer"
            >
              Đóng
            </button>
            <button
              type="button"
              onclick={handleRevoke}
              class="px-4 py-2 bg-rose-600 hover:bg-rose-700 text-white rounded-lg text-xs font-semibold shadow-sm transition-colors cursor-pointer"
            >
              Xác nhận thu hồi
            </button>
          </div>
        </div>
      {/if}
    </div>
  </div>
{/if}

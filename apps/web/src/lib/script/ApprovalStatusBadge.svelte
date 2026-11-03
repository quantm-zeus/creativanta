<script lang="ts">
  import type { ScriptLifecycleState, ScriptApprovalState } from './index';

  interface Props {
    lifecycle: ScriptLifecycleState;
    approval: ScriptApprovalState;
  }

  let { lifecycle, approval }: Props = $props();

  let badgeConfig = $derived.by(() => {
    if (lifecycle === 'ready_for_production') {
      return {
        label: 'Sẵn sàng sản xuất',
        classes: 'bg-emerald-600 text-white border-emerald-700',
        icon: '🚀'
      };
    }
    if (approval === 'approved' || lifecycle === 'approved') {
      return {
        label: 'Đã phê duyệt',
        classes: 'bg-green-100 text-green-800 border-green-300',
        icon: '✅'
      };
    }
    if (approval === 'rejected' || lifecycle === 'revision_required') {
      return {
        label: 'Cần sửa đổi',
        classes: 'bg-rose-100 text-rose-800 border-rose-300',
        icon: '⚠️'
      };
    }
    if (approval === 'pending_approval' || lifecycle === 'in_review') {
      return {
        label: 'Đang chờ duyệt',
        classes: 'bg-amber-100 text-amber-800 border-amber-300',
        icon: '⏳'
      };
    }
    if (lifecycle === 'archived') {
      return {
        label: 'Lưu trữ',
        classes: 'bg-gray-100 text-gray-700 border-gray-300',
        icon: '📦'
      };
    }
    return {
      label: 'Bản nháp',
      classes: 'bg-slate-100 text-slate-700 border-slate-300',
      icon: '📝'
    };
  });
</script>

<span
  class="inline-flex items-center gap-1.5 px-2.5 py-1 text-xs font-semibold rounded-full border {badgeConfig.classes}"
  data-testid="approval-status-badge"
>
  <span class="text-xs">{badgeConfig.icon}</span>
  <span>{badgeConfig.label}</span>
</span>

(function(){
'use strict';
const items=[['Routine 60 giây','Đang duyệt'],['Video AI cho creator','Chờ kiểm tra'],['Góc làm việc xanh','Đã xác nhận']];
let desc=false;
function esc(x){return String(x).replace(/[&<>"']/g,a=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;','\'':'&#39;'}[a]))}
function toast(msg){const e=document.getElementById('toast');e.innerHTML='<div class="toast">'+esc(msg)+'</div>';clearTimeout(window.__systemToast);window.__systemToast=setTimeout(()=>e.innerHTML='',3200)}
function renderRows(){
 const q=document.getElementById('table-filter')?.value.toLocaleLowerCase('vi')||'';
 const records=items.slice().sort((a,b)=>desc?b[0].localeCompare(a[0]):a[0].localeCompare(b[0]));
 document.getElementById('demo-rows').innerHTML=records.filter(x=>x[0].toLocaleLowerCase('vi').includes(q)).map((r,i)=>
 '<tr><td>'+esc(r[0])+'</td><td><span class="status '+(/xác nhận/i.test(r[1])?'good':'warning')+'">'+esc(r[1])+'</span></td>'+
 '<td><button data-action="record" data-index="'+i+'">Xem</button></td></tr>').join('');
}
function modal(title,content,confirmText='Đã hiểu'){
 document.getElementById('global-modal').innerHTML='<div class="modal-backdrop" data-action="close-backdrop"><div class="dialog" role="dialog" aria-modal="true" aria-label="'+esc(title)+'" data-stop>'+
 '<h3>'+esc(title)+'</h3><p>'+content+'</p>'+
 '<div class="dialog-buttons"><button class="btn secondary" data-action="close-modal">Đóng</button><button class="btn primary" data-action="confirm-modal">'+esc(confirmText)+'</button></div></div></div>';
 document.querySelector('.dialog .btn.primary')?.focus();
}
function close(){document.getElementById('global-modal').innerHTML=''}
document.addEventListener('click',e=>{
 const b=e.target.closest('[data-action]');if(!b)return;
 const action=b.dataset.action;
 if(action==='toast'){toast(b.dataset.msg||'Đã xử lý trong bản DEMO');return}
 if(action==='modal'){modal('Hộp thoại trong design system','Tương tác có nút rõ ràng, phân cấp và có thể đóng bằng phím Escape.');return}
 if(action==='sheet'){modal('Mobile bottom sheet','Trên mobile, nội dung quan trọng xuất hiện ở sheet vừa tầm ngón tay.');return}
 if(action==='confirm'){modal('Xác nhận hành động','Bước xác nhận bắt buộc cho thao tác xuất bản, hoàn tiền, xóa hoặc thay đổi quyền.','Xác nhận DEMO');return}
 if(action==='close-modal'){close();return}
 if(action==='close-backdrop'){if(e.target===b)close();return}
 if(action==='confirm-modal'){close();toast('Đã xác nhận thao tác mô phỏng');return}
 if(action==='toggle-disabled'){b.classList.toggle('active');toast('Đã đổi trạng thái thành phần DEMO');return}
 if(action==='validate'){
  const email=document.getElementById('sample-email').value.trim();const help=document.getElementById('field-help');
  const ok=/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email);help.textContent=ok?'Email hợp lệ · Không được gửi đi':'Vui lòng nhập một email hợp lệ';help.classList.toggle('invalid',!ok);toast(ok?'Đã kiểm tra email hợp lệ':'Biểu mẫu chưa hợp lệ');return;
 }
 if(action==='nav'){document.querySelectorAll('.mini-nav button').forEach(x=>x.classList.toggle('active',x===b));toast('Đã chọn '+b.textContent+' (DEMO)');return}
 if(action==='sort-table'){desc=!desc;renderRows();toast('Đã đổi thứ tự bảng');return}
 if(action==='record'){modal('Chi tiết bản ghi DEMO','Có thể xem chi tiết và các trạng thái minh họa mà không mở API thật.');return}
 if(action==='sample-state'){
  const t=document.getElementById('state-display');
  const key=b.dataset.state;
  t.innerHTML=key==='empty'?'<div style="padding:19px;color:#a1a79b;font-size:11px">Chưa có dữ liệu phù hợp với bộ lọc này.</div>':
    key==='error'?'<div style="padding:19px;color:#c65f45;font-size:11px">Không thể tải dữ liệu mẫu. Thử lại.</div>':
    '<div class="list-icon">✦</div><div><strong>Ý tưởng được lưu</strong><small>Chuẩn bị bước tiếp theo · DEMO</small></div>';
 }
});
document.getElementById('table-filter').addEventListener('input',renderRows);
document.addEventListener('keydown',e=>{if(e.key==='Escape')close()});
renderRows();
})();
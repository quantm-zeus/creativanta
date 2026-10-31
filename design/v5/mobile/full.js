/* The 61 mobile specs have distinct data-driven screens; all changes stay local. */
const V5MSPECS=(window.CREATIVANTA_FULL_SPECS||[]).filter(x=>x.platform==='mobile');
const V5MBY=new Map(V5MSPECS.map(x=>[x.id,x]));
const V5M={status:{},extra:{},period:{},tab:{},filter:{},form:{},current:null,pending:null};
const v5E=v=>escapeHTML(v);
function v5MCurrent(){return V5MBY.get(state.details?.id)}
function v5MRows(s){
 const base=(s.records||[]).map((name,i)=>({name:s.variant==='detail'&&!i?s.title:name,tag:['Chờ xử lý','Cần kiểm tra','Đã cập nhật','Mới'][i%4],owner:['Minh Anh','Hà Nguyễn','Creator Studio','Quân Trần'][i%4]}));
 return [...(V5M.extra[s.id]||[]),...base];
}
function v5MStatus(s,i){return V5M.status[s.id+'-'+i]||['Chờ xử lý','Đang xem xét','Đã hoàn tất','Bản nháp'][i%4]}
function v5MNotice(text,warning=false){return '<div class="m-v5-notice '+(warning?'warning':'')+'">'+text+'</div>'}
function v5MRelated(s){
 const related=(s.related||[]).filter(x=>V5MBY.has(x)).slice(0,4);
 return !related.length?'':'<section class="m-section"><h2 class="m-v5-sectiontitle">Tiếp tục hành trình</h2>'+
 '<div class="m-v5-rel">'+related.map(id=>'<button data-go="'+v5E(id)+'">'+v5E(V5MBY.get(id).title)+' '+icon('right',15)+'</button>').join('')+'</div></section>';
}
function v5MList(s,limit=10){
 const q=(V5M.filter[s.id]||'').trim().toLocaleLowerCase('vi');
 const rows=v5MRows(s).filter(x=>x.name.toLocaleLowerCase('vi').includes(q)).slice(0,limit);
 if(!rows.length)return '<div class="m-v5-empty">Không tìm thấy nội dung phù hợp. Thử đổi bộ lọc hoặc thêm bản ghi demo.</div>';
 return '<div class="m-v5-list">'+rows.map((x,i)=>
 '<article class="m-v5-entry"><span class="m-idea-icon '+(i%3===1?'green':i%3===2?'gold':'')+'">'+
 icon(['layers','file','target','bag'][i%4],18)+'</span>'+
 '<div class="m-v5-entry-main"><strong>'+v5E(x.name)+'</strong><small>'+v5E(x.owner)+' · DEMO</small></div>'+
 '<button data-v5m="record" data-id="'+s.id+'" data-index="'+i+'">Xem '+icon('right',13)+'</button></article>'
 ).join('')+'</div>';
}
function v5MMetrics(s){
 const labels=s.group==='insights'?['Doanh thu mẫu','Chi phí mẫu','Biên lợi nhuận','Nguồn dữ liệu']:
 s.group==='commerce'?['Đơn đang xử lý','Đang giao','Hoàn thành','Tổng giá trị']:
 ['Cần xem lại','Đang làm','Đã hoàn thành','Bản nháp'];
 return '<div class="m-v5-metrics">'+labels.map((t,i)=>
 '<div class="m-v5-metric"><small>'+t+'</small><strong>'+['24','08','91%','03'][i]+'</strong>'+
 '<span>'+['Dữ liệu minh họa','Mới cập nhật DEMO','Cần kiểm chứng','Chưa kết nối'][i]+'</span></div>').join('')+'</div>';
}
function v5MScreenHeader(s){
 return overline(v5E(s.category.toUpperCase())+' / '+v5E(s.module))+
 '<h1 class="m-title" style="font-size:27px;line-height:1.22">'+v5E(s.title)+'</h1>'+
 '<p class="m-subtitle">Làm việc với '+v5E(s.category.toLowerCase())+' theo một luồng rõ ràng, tối ưu cho thao tác trên điện thoại.</p>';
}
function v5MEditor(s){
 const fields=s.group==='insights'?['Loại chi phí','Số tiền (VND)','Ngày ghi nhận','Nguồn chứng từ']:
 s.group==='commerce'?['Tên sản phẩm','Giá trị (VND)','Số lượng','Ghi chú']:
 s.group==='publish'?['Tiêu đề bài đăng','Caption','Kênh đăng','Lịch dự kiến']:
 s.group==='create'?['Tên ý tưởng','Nội dung kịch bản','Định dạng','Ghi chú']:
 ['Tên bản ghi','Mô tả','Người phụ trách','Ghi chú'];
 return '<div class="m-v5-steps">'+['Bắt đầu','Biên tập','Kiểm tra'].map((t,i)=>'<div class="m-workflow-step '+(i===0?'current':'')+'"><span>0'+(i+1)+'</span><strong>'+t+'</strong></div>').join('')+'</div>'+
 '<section class="m-section"><h2 class="m-v5-sectiontitle">Thông tin bản nháp</h2><div class="m-v5-fields">'+
 fields.map((title,i)=>'<label class="m-form-label" for="m-v5-field-'+i+'">'+title+'</label>'+
 (i===1&&['create','publish'].includes(s.group)?'<textarea id="m-v5-field-'+i+'" class="m-form-textarea" data-v5m-field="'+s.id+'-'+i+'" placeholder="Nhập mô tả chi tiết...">'+v5E((V5M.form[s.id]||{})[i]||'')+'</textarea>':
 '<input id="m-v5-field-'+i+'" type="'+(i===1&&['insights','commerce'].includes(s.group)?'number':i===2&&s.group==='insights'?'date':'text')+'" class="m-form-input" data-v5m-field="'+s.id+'-'+i+'" value="'+v5E((V5M.form[s.id]||{})[i]||'')+'" placeholder="Nhập '+title.toLowerCase()+'..."/>')).join('')+
 '</div></section>'+
 '<div class="m-v5-actions" style="margin-top:16px"><button class="m-button primary" data-v5m="save" data-id="'+s.id+'">'+icon('check',16)+' Lưu bản nháp</button>'+
 '<button class="m-button secondary" data-v5m="preview" data-id="'+s.id+'">'+icon('play',16)+' Xem trước</button></div>';
}
function v5MCalendar(s){
 const d=Number(V5M.period[s.id]||5);
 return '<div class="m-v5-calendar">'+['T2','T3','T4','T5','T6','T7','CN'].map((name,i)=>
 '<button class="'+(i===d?'active':'')+'" data-v5m="day" data-id="'+s.id+'" data-index="'+i+'">'+name+'<strong>'+[26,27,28,29,30,31,1][i]+'</strong></button>').join('')+'</div>'+
 '<section class="m-section"><h2 class="m-v5-sectiontitle">Lịch đã lên kế hoạch</h2>'+v5MList(s,4)+'</section>'+
 '<button class="m-button full" style="margin-top:15px" data-v5m="create" data-id="'+s.id+'">'+icon('plus',16)+' Thêm lịch demo</button>';
}
function v5MChart(){
 const values=[48,52,49,68,66,75,78,71,88,90],points=values.map((x,i)=>(16+i*30)+','+(154-x)).join(' ');
 return '<div class="m-card" style="padding:18px"><div class="m-section-heading"><h2>Hiệu quả minh họa</h2><span class="m-tag">DEMO</span></div>'+
 '<div style="font-size:29px;font-weight:790;color:#26573e;letter-spacing:-.05em">+18,6%</div>'+
 '<div class="m-muted">Biến động dữ liệu theo kỳ đã chọn</div>'+
 '<div class="m-linechart"><svg viewBox="0 0 310 140" role="img" aria-label="Biểu đồ xu hướng minh họa" fill="none">'+
 '<path d="M10 108H305M10 68H305" stroke="#edf1e9" stroke-dasharray="4 5"/>'+
 '<polyline points="'+points+'" stroke="#3e8659" stroke-width="3.5" stroke-linejoin="round" fill="none"/>'+
 values.map((x,i)=>'<circle cx="'+(16+i*30)+'" cy="'+(154-x)+'" r="3.3" stroke="#3e8659" stroke-width="2" fill="#fffefa"/>').join('')+
 '</svg></div></div>';
}
function v5MAnalytics(s){
 const period=V5M.period[s.id]||'30 ngày';
 return '<div class="m-v5-tabs">'+['7 ngày','30 ngày','90 ngày'].map(x=>'<button class="'+(period===x?'active':'')+'" data-v5m="period" data-id="'+s.id+'" data-key="'+x+'">'+x+'</button>').join('')+'</div>'+
 v5MMetrics(s)+v5MChart()+'<div class="m-section"><h2 class="m-v5-sectiontitle">Dữ liệu cần đối chiếu</h2>'+v5MList(s)+'</div>'+
 '<button class="m-button secondary full" style="margin-top:16px" data-v5m="export" data-id="'+s.id+'">Xuất CSV mẫu '+icon('arrow',15)+'</button>';
}
function v5MApproval(s){
 return v5MNotice('Những quyết định có ảnh hưởng đến nội dung, thanh toán hoặc quyền tài khoản cần được kiểm tra. Thao tác ở đây chỉ là DEMO.',true)+
 '<section class="m-section"><h2 class="m-v5-sectiontitle">Hàng đợi cần xử lý</h2><div class="m-v5-list">'+
 v5MRows(s).map((x,i)=>'<article class="m-v5-entry"><span class="m-idea-icon gold">'+icon('shield',19)+'</span>'+
 '<div class="m-v5-entry-main"><strong>'+v5E(x.name)+'</strong><small>'+v5E(v5MStatus(s,i))+' · DEMO</small></div>'+
 '<button data-v5m="approve" data-id="'+s.id+'" data-index="'+i+'">Xử lý '+icon('right',13)+'</button></article>').join('')+'</div></section>';
}
function v5MWorkflow(s){
 return '<div class="m-v5-steps">'+['Kích hoạt','Phân tích','Duyệt','Kết quả'].map((x,i)=>
 '<div class="m-workflow-step '+(i===1?'current':'')+'"><span>0'+(i+1)+'</span><strong>'+x+'</strong></div>').join('')+'</div>'+
 v5MNotice('Bản mẫu không chạy công việc nền hay gửi dữ liệu ra ngoài.')+
 '<section class="m-section"><h2 class="m-v5-sectiontitle">Lịch sử và cấu hình</h2>'+v5MList(s)+'</section>'+
 '<button class="m-button full" style="margin-top:18px" data-v5m="run" data-id="'+s.id+'">'+icon('play',17)+' Mô phỏng quy trình</button>';
}
function v5MSettings(s){
 return '<div class="m-v5-list">'+
 ['Thông báo và cập nhật','Kết nối nền tảng','Quyền truy cập','Ưu tiên hiển thị'].map((name,i)=>
 '<div class="m-v5-entry"><span class="m-idea-icon '+(i%2?'green':'')+'">'+icon(i===1?'layers':'settings',18)+'</span>'+
 '<div class="m-v5-entry-main"><strong>'+name+'</strong><small>Đang sử dụng cấu hình mẫu</small></div>'+
 '<button data-v5m="toggle" data-id="'+s.id+'" data-index="'+i+'">'+(V5M.status[s.id+'-s'+i]||'Bật')+'</button></div>').join('')+'</div>'+
 '<div class="m-section"><h2 class="m-v5-sectiontitle">Thông tin có liên quan</h2>'+v5MList(s,3)+'</div>';
}
function v5MAuth(s){
 return '<div class="m-v5-fields"><label class="m-form-label">Email</label><input class="m-form-input" type="email" id="m-v5-email" placeholder="hello@example.com"/>'+
 '<label class="m-form-label">Mật khẩu</label><input class="m-form-input" type="password" id="m-v5-password" placeholder="Mật khẩu demo"/></div>'+
 '<button class="m-button full primary" style="margin-top:18px" data-v5m="auth" data-id="'+s.id+'">Kiểm tra form demo '+icon('arrow',15)+'</button>'+
 v5MNotice('Chỉ là mẫu thiết kế. Không xử lý tài khoản hoặc xác thực thật.');
}
function v5MTable(s){
 return '<label class="m-search-field" style="margin-top:15px">'+icon('search',17)+
 '<input id="m-v5-filter" data-v5m-filter="'+s.id+'" placeholder="Tìm theo tên, sản phẩm, trạng thái..." value="'+v5E(V5M.filter[s.id]||'')+'"/></label>'+
 '<div class="m-section-heading"><h2>'+v5E(s.category)+'</h2><button class="m-text-link" data-v5m="create" data-id="'+s.id+'">Thêm mới '+icon('plus',14)+'</button></div>'+
 v5MList(s)+v5MNotice('Các bản ghi, bộ lọc và hành động chỉ lưu trong bộ nhớ của bản demo.');
}
function v5MBoard(s){
 const rows=v5MRows(s);
 return '<div class="m-v5-steps">'+['Ý tưởng','Đang làm','Cần duyệt'].map((n,i)=>'<div class="m-workflow-step '+(!i?'current':'')+'"><span>0'+(i+1)+'</span><strong>'+n+'</strong></div>').join('')+'</div>'+
 '<section class="m-section"><h2 class="m-v5-sectiontitle">Thẻ công việc và nội dung</h2>'+
 v5MList(s,7)+'</section>'+
 '<button class="m-button primary full" style="margin-top:15px" data-v5m="create" data-id="'+s.id+'">'+icon('plus',15)+' Tạo bản ghi mới</button>';
}
function v5MActions(s){
 const a=(s.sourceActions||[]).slice(0,5);
 if(!a.length)return '';
 return '<section class="m-section"><h2 class="m-v5-sectiontitle">Thao tác trong luồng</h2>'+
 '<div class="m-v5-rel">'+a.map((action,i)=>'<button data-v5m="source" data-id="'+s.id+'" data-index="'+i+'">'+v5E(action.label)+' '+icon('right',15)+'</button>').join('')+
 (s.sourceActions.length>5?'<button data-v5m="more-actions" data-id="'+s.id+'">Xem đầy đủ '+s.sourceActions.length+' thao tác '+icon('right',15)+'</button>':'')+'</div></section>';
}
function fallbackView(){
 const s=v5MCurrent();
 if(!s)return renderV4Fallback();
 const HINTS={analytics:'So sánh số liệu theo kỳ và kiểm tra nguồn trước khi quyết định.',editor:'Biên tập nội dung, xem trước và lưu bản nháp theo đúng tiến trình.',form:'Nhập thông tin cốt lõi, kiểm tra và lưu bản ghi mô phỏng.',calendar:'Theo dõi lịch và các nội dung đang chờ xử lý.',approval:'Xem bằng chứng, đánh giá rủi ro và xác nhận quyết định.',workflow:'Theo dõi từng bước thực hiện, có xác nhận trước hành động.',settings:'Điều chỉnh tùy chọn, kết nối và quyền trên cùng màn hình.',auth:'Kiểm tra trường nhập và trạng thái xác thực của bản demo.',table:'Tìm, lọc và mở chi tiết từng bản ghi trong danh sách.',commerce:'Theo dõi sản phẩm và đơn hàng cần xử lý.',inbox:'Xử lý phản hồi khách hàng theo ngữ cảnh.',dashboard:'Tổng hợp các ưu tiên và trạng thái hôm nay.'};
 const hint=s.id==='M043'?'Ghi nhận chi phí khi phát sinh, bổ sung chứng từ và phân loại trước khi lưu.':HINTS[s.variant]||'Quản lý các bước và bản ghi liên quan trong cùng một luồng công việc.';
 let content='';
 const v=s.variant;
 if(v==='analytics')content=v5MAnalytics(s);
 else if(v==='editor'||v==='form'||v==='detail')content=v5MEditor(s);
 else if(v==='calendar')content=v5MCalendar(s);
 else if(v==='approval')content=v5MApproval(s);
 else if(v==='workflow')content=v5MWorkflow(s);
 else if(v==='settings')content=v5MSettings(s);
 else if(v==='auth')content=v5MAuth(s);
 else if(v==='board'||v==='workspace')content=v5MBoard(s);
 else content=v5MTable(s);
 return '<div class="m-view m-v5" data-v5-mobile="'+v5E(s.id)+'" data-v5-variant="'+v5E(v)+'">'+v5MScreenHeader(s)+
 '<div class="m-v5-lead"><span class="m-idea-icon green">'+icon('target',18)+'</span>'+
 '<div><strong>'+v5E(s.category)+'</strong><p>'+v5E(hint)+'</p></div></div>'+
 content+v5MActions(s)+v5MRelated(s)+
 '<div class="m-section">'+demoNote()+'</div></div>';
}
function v5MModal(title,inner,actions){
 state.overlay={type:'v5custom'};
 document.getElementById('mobile-overlays').innerHTML=sheet(title,inner,actions);
}
function v5MClose(){state.overlay=null;renderOverlay()}
function v5MAction(act,el){
 const id=el.dataset.id||state.details?.id,s=V5MBY.get(id);if(!s)return;
 const index=Number(el.dataset.index||0),action=s.sourceActions?.[index];
 if(act==='record'){
  const x=v5MRows(s)[index]||v5MRows(s)[0];
  v5MModal('Chi tiết · '+x.name,'<div class="m-v5-list" style="padding:17px"><strong>'+v5E(x.name)+'</strong>'+
   '<p class="m-muted">Bản ghi mô phỏng · '+v5E(x.owner)+'</p>'+
   '<div class="m-v5-notice">Trạng thái: '+v5E(v5MStatus(s,index))+'</div></div>',
   '<div class="m-sheet-actions"><button class="m-button full" data-v5m="edit" data-id="'+id+'">Chỉnh sửa DEMO</button></div>');return;
 }
 if(act==='create'||act==='edit'){
  v5MModal('Tạo bản ghi · '+s.category,'<p class="m-muted">Chỉ lưu trong phiên trải nghiệm.</p>'+
   '<label for="m-v5-new" class="m-form-label">Tên bản ghi</label><input id="m-v5-new" class="m-form-input" placeholder="Tên ý tưởng / bản ghi..."/>'+
   '<label class="m-form-label">Ghi chú</label><textarea class="m-form-textarea" placeholder="Ghi chú demo..."></textarea>',
   '<div class="m-sheet-actions"><button class="m-button secondary" data-action="overlay-close">Đóng</button>'+
   '<button class="m-button primary" data-v5m="add" data-id="'+id+'">Lưu DEMO</button></div>');
  setTimeout(()=>document.getElementById('m-v5-new')?.focus(),0);return;
 }
 if(act==='add'){
  const value=document.getElementById('m-v5-new')?.value.trim();
  if(!value){showToast('Nhập tên bản ghi');return}
  (V5M.extra[id]??=[]).unshift({name:value,tag:'Được thêm',owner:'Bạn (DEMO)'});
  v5MClose();renderContent();showToast('Đã lưu bản ghi demo');return;
 }
 if(act==='period'){V5M.period[id]=el.dataset.key;renderContent();return}
 if(act==='day'){V5M.period[id]=Number(el.dataset.index);renderContent();return}
 if(act==='toggle'){
  const key=id+'-s'+index;V5M.status[key]=V5M.status[key]==='Tắt'?'Bật':'Tắt';renderContent();return;
 }
 if(act==='preview'||act==='record-preview'){
  v5MModal('Xem trước · '+s.title,'<div class="m-v5-notice">Nội dung xem trước trong thiết kế mẫu. Chưa có AI generation, upload hay thao tác thật.</div>',
   '<div class="m-sheet-actions"><button class="m-button full" data-action="overlay-close">Đóng</button></div>');return;
 }
 if(act==='save'){
  const inputs=[...document.querySelectorAll('[data-v5m-field^="'+id+'-"]')];
  V5M.form[id]=Object.fromEntries(inputs.map((e,i)=>[i,e.value]));
  showToast('Đã lưu bản nháp trong DEMO');return;
 }
 if(act==='auth'){
  const email=document.getElementById('m-v5-email')?.value||'';
  if(!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)){showToast('Email không hợp lệ');return}
  showToast('Đã kiểm tra form DEMO — chưa đăng nhập thật');return;
 }
 if(act==='export'){
  const cols=[['Mục','Trạng thái'],...v5MRows(s).map((r,i)=>[r.name,v5MStatus(s,i)])];
  const csv='\uFEFF'+cols.map(a=>a.map(v=>'"'+String(v).replaceAll('"','""')+'"').join(',')).join('\r\n');
  const blob=new Blob([csv],{type:'text/csv;charset=utf-8'}),url=URL.createObjectURL(blob),a=document.createElement('a');
  a.href=url;a.download='creativanta-demo-'+id+'.csv';document.body.append(a);a.click();a.remove();setTimeout(()=>URL.revokeObjectURL(url),400);
  showToast('Đã tạo CSV từ dữ liệu DEMO');return;
 }
 if(act==='more-actions'){
  v5MModal('Tất cả thao tác · '+s.category,'<p class="m-muted">Từ đặc tả nghiệp vụ, tất cả được mô phỏng cục bộ.</p><div class="m-v5-rel">'+
   (s.sourceActions||[]).map((x,i)=>'<button data-v5m="source" data-id="'+s.id+'" data-index="'+i+'">'+v5E(x.label)+' '+icon('right',14)+'</button>').join('')+'</div>',
   '<div class="m-sheet-actions"><button class="m-button secondary full" data-action="overlay-close">Đóng</button></div>');return;
 }
 if(act==='source'){
  if(action?.type==='navigation'){
   const next=(s.related||[]).find(x=>V5MBY.has(x));
   v5MClose();if(next)goto(next);else v5MAction('record',el);return;
  }
  if(action?.type==='export')return v5MAction('export',el);
  if(action?.type==='filter'){V5M.period[id]='7 ngày';renderContent();showToast('Đã đổi bộ lọc DEMO');return;}
  if(action?.type==='mutate'&&!/remove|delete|suspend/i.test(action?.sourceName))return v5MAction('create',el);
 }
 if(act==='approve'||act==='run'||act==='source'){
  V5M.pending={id,index,label:action?.label||(act==='run'?'Chạy thử DEMO':'Xem xét và phê duyệt')};
  v5MModal('Xác nhận thao tác',
   '<p class="m-muted">'+v5E(V5M.pending.label)+'</p>'+
   v5MNotice('Chỉ mô phỏng kết quả. Không thay đổi tài khoản, nội dung, thanh toán hoặc quyền thực.',true),
   '<div class="m-sheet-actions"><button class="m-button secondary" data-action="overlay-close">Hủy</button>'+
   '<button class="m-button primary" data-v5m="confirm" data-id="'+id+'">Xác nhận DEMO</button></div>');return;
 }
 if(act==='confirm'){
  if(V5M.pending){V5M.status[V5M.pending.id+'-'+V5M.pending.index]='Đã xem xét DEMO';}
  V5M.pending=null;v5MClose();renderContent();showToast('Thao tác DEMO được ghi nhận');return;
 }
 showToast('Thao tác chỉ dùng cho giao diện mô phỏng');
}
document.addEventListener('click',event=>{
 const el=event.target.closest('[data-v5m]');
 if(!el)return;
 event.preventDefault();v5MAction(el.dataset.v5m,el);
});
document.addEventListener('input',event=>{
 const el=event.target;
 if(!el.dataset.v5mFilter)return;
 const id=el.dataset.v5mFilter;
 V5M.filter[id]=el.value;
 const pos=el.selectionStart;
 renderContent();
 const next=document.querySelector('[data-v5m-filter="'+id+'"]');
 next?.focus();try{next?.setSelectionRange(pos,pos)}catch(_){}
});

window.__cv5QA=(id)=>goto(id);

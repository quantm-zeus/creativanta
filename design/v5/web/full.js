/* All-screen UI blueprint engine. Lives INSIDE approved V4 Web/Admin shell.
   Source-linked actions in native prototype state. No production API calls. */
const V5_SPECS=(window.CREATIVANTA_FULL_SPECS||[]).filter(x=>x.platform===SURFACE);
const V5_BY_ID=new Map(V5_SPECS.map(x=>[x.id,x]));
const V5={extra:{},statuses:{},period:{},tab:{},query:{},selected:{},sort:{},forms:{},current:null,pending:null,modals:0};
function label(id){return V5_BY_ID.get(id)?.title||baseLabel(id)}
function renderTitle(){const s=V5_BY_ID.get(state.id);return s&&!isV5Home(s)?s.title:renderV4Title()}
function renderDescription(){
 const s=V5_BY_ID.get(state.id);
 if(s && !isV5Home(s)){return 'Theo dõi, thao tác và kiểm tra thông tin '+s.category.toLowerCase()+' trên một màn hình rõ ràng. Dữ liệu minh họa.'}
 return renderV4Description();
}
function isV5Home(s){return s.platform==='admin'?s.id==='A001':NAV.some(g=>g.ids[0]===s.id)}
function renderView(){
 const s=V5_BY_ID.get(state.id);
 if(!s)return '<div class="v5-empty">Không tìm thấy màn hình trong danh mục.</div>';
 document.body.dataset.v5Variant=s.variant;
 document.body.classList.toggle('v5-has-detail',!isV5Home(s));
 if(isV5Home(s))return renderV4View();
 return v5Screen(s);
}
const v5Esc=x=>String(x??'').replace(/[&<>"']/g,k=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[k]));
const v5Src=id=>V5_BY_ID.get(id);
const v5Text=(v)=>v5Esc(v);
function v5Btn(text,act,id,cls=''){return '<button type="button" class="v5-toolbtn '+cls+'" data-v5="'+v5Esc(act)+'" data-v5-id="'+v5Esc(id)+'">'+text+'</button>'}
function v5Chip(text,status=''){return '<span class="v5-pill '+status+'">'+v5Esc(text)+'</span>'}
function v5Status(s,row){
 return V5.statuses[s.id+'-'+row]||['Đang theo dõi','Chờ xử lý','Đang thực hiện','Đã xác nhận'][row%4];
}
function v5StatusClass(status){
 return /duyệt|chờ|đánh giá|đang thực hiện/i.test(status)?'pending':/lỗi|từ chối|khóa|cảnh báo/i.test(status)?'review':/xác nhận|hoàn tất|hoàn thành|đã lưu|đã duyệt/i.test(status)?'ready':'demo';
}
function v5Records(s){
 const custom=V5.extra[s.id]||[];
 const domain=s.records||[];
 return [...custom,...domain.map((name,i)=>({id:s.id+'-r'+i,name:s.variant==='detail'&&i===0?s.title:name,tag:['Nguồn mẫu','Ưu tiên','Chờ đối soát','Mới'][i%4],owner:['Minh Anh','Quân Trần','Hà Nguyễn','Studio Team'][i%4],value:['1.240.000đ','689.000đ','420.000đ','2.150.000đ'][i%4]}))];
}
function v5Related(s){
 const ids=(s.related||[]).filter(x=>V5_BY_ID.has(x)).slice(0,4);
 if(!ids.length)return '';
 return '<section class="v5-card"><div class="v5-card-header"><div><h3>Tiếp tục trong luồng công việc</h3><p>Các bước liên quan, không cần tìm trong menu dài</p></div></div>'+
 '<div class="v5-card-body"><div class="v5-related">'+ids.map(id=>'<button data-go="'+v5Esc(id)+'">'+v5Text(label(id))+' '+ic('right',13)+'</button>').join('')+'</div></div></section>';
}
function v5Toolbar(s,extra=''){
 const search='<input class="v5-search" placeholder="Tìm trong '+v5Esc(s.category.toLowerCase())+'..." data-v5-search="'+v5Esc(s.id)+'" aria-label="Lọc dữ liệu"/>';
 return '<div class="v5-toolbar"><div class="v5-toolbar-left">'+search+extra+
 v5Btn(ic('filter',15)+' Bộ lọc','filter',s.id)+
 '</div><div class="v5-actions">'+
 v5Btn(ic('download',15)+' Xuất CSV mẫu','export',s.id)+
 v5Btn(ic('plus',16)+' Thêm mới','create',s.id)+'</div></div>';
}
function v5FilteredRecords(s){
 const q=(V5.query[s.id]||'').trim().toLocaleLowerCase('vi');
 const items=v5Records(s).filter(item=>(item.name+' '+item.owner+' '+item.tag).toLocaleLowerCase('vi').includes(q));
 return V5.sort[s.id]?items.slice().reverse():items;
}
function v5Rows(s){
 const items=v5FilteredRecords(s);
 if(!items.length)return '<div class="v5-empty">Không tìm thấy kết quả. Bạn có thể đổi bộ lọc hoặc thêm bản ghi demo.</div>';
 return '<div class="v5-tbl-scroll" role="region" tabindex="0" aria-label="Bảng dữ liệu có thể cuộn ngang">'+
 '<table class="v5-tbl"><thead><tr><th><input type="checkbox" class="v5-checkbox" data-v5="select-all" data-v5-id="'+s.id+'" aria-label="Chọn tất cả"/></th>'+
 '<th>Nội dung</th><th>Người phụ trách</th><th>Trạng thái</th><th>Giá trị demo</th><th></th></tr></thead><tbody>'+
 items.map((x,i)=>{
 const status=v5Status(s,i);const selected=V5.selected[s.id]||new Set();
 return '<tr><td><input class="v5-checkbox" type="checkbox" data-v5="select-row" data-v5-id="'+s.id+'" data-v5-key="'+i+'" '+(selected.has(i)?'checked':'')+' aria-label="Chọn bản ghi"/></td>'+
 '<td><strong>'+v5Text(x.name)+'</strong><br><span class="v5-small">'+v5Text(x.tag)+' · DEMO</span></td>'+
 '<td>'+v5Text(x.owner)+'</td><td>'+v5Chip(status,v5StatusClass(status))+'</td><td>'+v5Text(x.value)+'</td>'+
 '<td><button class="link" data-v5="record" data-v5-id="'+s.id+'" data-v5-key="'+i+'">Chi tiết '+ic('right',14)+'</button></td></tr>'
 }).join('')+'</tbody></table></div>';
}
function v5Table(s){return v5Toolbar(s)+
 '<section class="v5-card"><div class="v5-card-header"><div><h3>Danh sách '+v5Text(s.category.toLowerCase())+'</h3><p>Dữ liệu mô phỏng có thể tìm kiếm, chọn và cập nhật trạng thái</p></div>'+
 '<span class="v5-prototag">'+v5FilteredRecords(s).length+' bản ghi</span></div>'+v5Rows(s)+
 '<div class="v5-card-footer">Bản ghi chỉ tồn tại trong phiên trải nghiệm · Các thao tác không gửi đến server.</div></section>'+
 v5Related(s);}
function v5Metrics(s){
 const names=s.group==='insights'?['Doanh thu mẫu','Chi phí dự kiến','Biên lợi nhuận','Chứng từ chờ xử lý']:
 s.group==='commerce'?['Đơn đang xử lý','Đơn mới','Đơn hoàn tất','Giá trị mẫu']:
 s.platform==='admin'?['Cần xử lý','Đang theo dõi','Hoàn thành','Cảnh báo']:
 ['Mục cần đánh giá','Công việc hôm nay','Đã hoàn tất','Tín hiệu mới'];
 return '<div class="v5-metrics">'+names.map((n,i)=>'<div class="v5-stat"><small>'+n+'</small><strong>'+['24','08','91%','03'][i]+'</strong><span>'+['Dữ liệu demo','Đang theo dõi','Đã ghi nhận mẫu','Cần xem lại'][i]+'</span></div>').join('')+'</div>';
}
function v5Chart(s){
 const values=[25,32,27,41,38,52,47,61,58,72,64,83],max=84;
 const dots=values.map((x,i)=>(18+i*44)+','+(166-x*1.55)).join(' ');
 return '<div class="v5-card"><div class="v5-card-header"><div><h3>Diễn biến '+v5Text(s.category.toLowerCase())+'</h3><p>12 giai đoạn · Chỉ là đường xu hướng minh họa</p></div>'+
 '<span class="v5-chip">+18,6% DEMO</span></div><div class="v5-card-body"><svg class="v5-chart" viewBox="0 0 530 185" role="img" aria-label="Biểu đồ biến động mô phỏng">'+
 [45,90,135].map(y=>'<path d="M10 '+y+'H520" stroke="#edf0e8" stroke-dasharray="5 5"/>').join('')+
 '<polyline points="'+dots+'" fill="none" stroke="#377c56" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round"/>'+
 values.map((v,i)=>'<circle cx="'+(18+i*44)+'" cy="'+(166-v*1.55)+'" r="3.4" stroke="#377c56" stroke-width="2" fill="#fffefa"/>').join('')+
 '</svg><div class="v5-meta" style="justify-content:space-between"><span>Đầu kỳ</span><span>Giữa kỳ</span><span>Hiện tại</span></div></div></div>';
}
function v5Analytics(s){
 const period=V5.period[s.id]||'30 ngày';
 return '<div class="v5-toolbar"><div class="v5-toolbar-left"><span class="v5-quiet">Khoảng thời gian</span>'+
 '<div class="v5-segment">'+['7 ngày','30 ngày','90 ngày'].map(x=>'<button data-v5="period" data-v5-id="'+s.id+'" data-v5-key="'+x+'" class="'+(period===x?'active':'')+'">'+x+'</button>').join('')+'</div></div>'+
 '<div class="v5-actions">'+v5Btn(ic('download',15)+' Xuất báo cáo demo','export',s.id)+v5Btn('So sánh kỳ','filter',s.id)+'</div></div>'+
 v5Metrics(s)+'<div class="v5-grid">'+v5Chart(s)+
 '<section class="v5-card"><div class="v5-card-header"><div><h3>Điểm cần chú ý</h3><p>Hành động gợi ý từ số liệu demo</p></div></div>'+
 v5Records(s).slice(0,3).map((x,i)=>'<div class="v5-item"><span class="v5-item-icon">'+ic(['chart','receipt','target'][i],17)+'</span>'+
 '<div class="v5-item-main"><strong>'+v5Text(x.name)+'</strong><small>Nguồn mô phỏng · cần bằng chứng</small></div>'+
 '<button data-v5="record" data-v5-id="'+s.id+'" data-v5-key="'+i+'">Xem '+ic('right',12)+'</button></div>').join('')+'</section></div>'+
 '<section class="v5-card"><div class="v5-card-header"><div><h3>Danh sách dữ liệu minh họa</h3><p>Lọc, mở và kiểm tra từng mục</p></div></div>'+v5Rows(s)+'</section>'+v5Related(s);
}
function v5Approval(s){
 const items=v5Records(s),category=s.platform==='admin'?'Hàng đợi kiểm soát':'Danh sách cần xem lại';
 return '<div class="v5-notice warning">'+ic('shield',18)+' <span><strong>Quy trình có kiểm soát:</strong> Phê duyệt, gỡ nội dung, hoàn tiền và thay đổi quyền đều phải xác nhận. Chỉ mô phỏng trên bản ghi DEMO.</span></div>'+
 '<div class="v5-grid"><section class="v5-card"><div class="v5-card-header"><div><h3>'+category+'</h3><p>Xem bằng chứng và ghi lại quyết định mô phỏng</p></div>'+
 '<span class="v5-prototag">'+items.length+' mục</span></div>'+
 items.map((x,i)=>'<div class="v5-item"><span class="v5-item-icon">'+ic('shield',18)+'</span>'+
 '<div class="v5-item-main"><strong>'+v5Text(x.name)+'</strong><small>'+v5Text(x.owner)+' · '+v5Text(x.tag)+'</small>'+
 '<div style="margin-top:7px">'+v5Chip(v5Status(s,i),v5StatusClass(v5Status(s,i)))+'</div></div>'+
 '<div class="v5-actions"><button class="v5-toolbtn" data-v5="decision" data-v5-id="'+s.id+'" data-v5-key="'+i+'">Duyệt</button>'+
 '<button class="v5-toolbtn" data-v5="reject" data-v5-id="'+s.id+'" data-v5-key="'+i+'">Chuyển xử lý</button></div></div>').join('')+
 '</section><div><div class="v5-inspector"><strong>Nguyên tắc phê duyệt</strong>Người phụ trách cần đối chiếu nguồn, quyền và quy trình nghiệp vụ trước khi ra quyết định. Những thao tác trên chỉ đổi trạng thái mẫu trong bộ nhớ.</div>'+
 '<div style="height:15px"></div>'+v5Related(s)+'</div></div>';
}
function v5Editor(s,isForm=false){
 const current=V5.forms[s.id]||{};
 const fields=s.group==='commerce'?['Tên sản phẩm','Giá trị (VND)','Mô tả','Kênh phân phối']:
 s.group==='insights'?['Loại chi phí','Số tiền (VND)','Ngày ghi nhận','Chứng từ']:
 s.group==='publish'?['Tiêu đề nội dung','Mô tả / Caption','Kênh đăng','Thời điểm']:
 s.group==='create'?['Tên ý tưởng','Nội dung kịch bản','Định dạng','Tông giọng']:
 ['Tên bản ghi','Mô tả','Người phụ trách','Ghi chú'];
 const f=fields.map((name,i)=>'<div class="v5-field '+(i===1?'full':'')+'"><label for="v5-field-'+i+'">'+v5Text(name)+'</label>'+
 (i===1?'<textarea class="v5-textarea" id="v5-field-'+i+'" data-v5-input="'+s.id+'-'+i+'" placeholder="Nhập nội dung demo...">'+v5Text(current[i]||'')+'</textarea>':
 '<input id="v5-field-'+i+'" class="v5-input" data-v5-input="'+s.id+'-'+i+'" value="'+v5Text(current[i]||'')+'" placeholder="Nhập '+v5Text(name.toLowerCase())+'..."/>')+
 '</div>').join('');
 return '<div class="v5-grid"><section class="v5-card"><div class="v5-card-header"><div><h3>'+v5Text(s.title)+'</h3><p>Biên tập trực tiếp · Lưu trong bộ nhớ của prototype</p></div>'+
 v5Chip('Bản nháp','pending')+'</div><div class="v5-card-body"><div class="v5-form-grid">'+f+'</div>'+
 '<div class="v5-actions" style="margin-top:20px">'+v5Btn(ic('file',15)+' Lưu bản nháp','save',s.id)+
 v5Btn('Xem trước','preview',s.id)+v5Btn('Chọn tệp mẫu','upload',s.id)+'</div></div></section>'+
 '<div><div class="v5-visual"><small>DESIGN PREVIEW · DEMO</small>'+
 '<h2>'+v5Text(s.category)+'<br>được trình bày rõ ràng.</h2>'+
 '<p>Chuyển từ ý tưởng đến bản nháp có cấu trúc và dễ kiểm tra trước bước tiếp theo.</p></div>'+
 '<div style="height:15px"></div><section class="v5-card"><div class="v5-card-header"><h3>Trạng thái xử lý</h3></div>'+
 '<div class="v5-card-body"><div class="v5-timeline">'+['Nháp','Kiểm tra','Duyệt','Sẵn sàng'].map((x,i)=>
 '<div class="v5-step '+(!i?'current':'')+'"><em>0'+(i+1)+'</em><strong>'+x+'</strong></div>').join('')+'</div></div></section></div></div>'+
 v5Related(s);
}
function v5Calendar(s){
 const selected=V5.period[s.id]||'T5';
 const days=['T2','T3','T4','T5','T6','T7','CN'];
 return '<div class="v5-toolbar"><div class="v5-toolbar-left">'+v5Btn(ic('calendar',15)+' Chọn tuần','filter',s.id)+
 '<span class="v5-quiet">Tuần đang xem · thời gian minh họa</span></div><div class="v5-actions">'+v5Btn(ic('plus',16)+' Lên lịch','create',s.id)+'</div></div>'+
 '<section class="v5-card"><div class="v5-card-header"><div><h3>Lịch '+v5Text(s.category.toLowerCase())+'</h3><p>Nhấn vào từng ngày để xem hoặc thêm một sự kiện mẫu</p></div></div>'+
 '<div class="v5-card-body"><div class="v5-calendar">'+days.map((d,i)=>'<div class="v5-day"><button class="v5-toolbtn '+(d===selected?'active':'')+'" data-v5="period" data-v5-key="'+d+'" data-v5-id="'+s.id+'">'+d+'</button>'+
 (i===0||i===3||i===5?'<div class="v5-event '+(i===3?'warm':'')+'">Nội dung #0'+(i+1)+'<br>18:30 · DEMO</div>':'')+
 '</div>').join('')+'</div></div></section>'+v5Related(s);
}
function v5Workflow(s){
 return '<div class="v5-notice">'+ic('workflow',17)+' <span>Quy trình chỉ chạy trong prototype. Không gọi API, không chạy worker, không gửi tác vụ ra bên ngoài.</span></div>'+
 '<section class="v5-card"><div class="v5-card-header"><div><h3>Trình tự xử lý</h3><p>Trực quan hóa các bước, trạng thái và điểm kiểm soát</p></div>'+
 v5Btn('Chạy thử demo','run',s.id)+'</div><div class="v5-card-body"><div class="v5-flow">'+
 ['Điều kiện bắt đầu','Phân tích tín hiệu','Người dùng duyệt','Ghi nhận kết quả'].map((x,i)=>
 (i?'<span class="v5-flow-arrow">→</span>':'')+'<div class="v5-node '+(i===1?'mid':i===3?'end':'')+'">'+x+'</div>').join('')+'</div>'+
 '<div class="v5-inspector"><strong>Kiểm soát và xử lý lỗi</strong>Các bước cần có quyền phù hợp, log rõ ràng và xác nhận trước khi thực hiện tác động bên ngoài.</div></div></section>'+
 '<div class="v5-grid"><section class="v5-card"><div class="v5-card-header"><h3>Lịch sử minh họa</h3></div>'+v5Rows(s)+'</section>'+v5Related(s)+'</div>';
}
function v5Board(s){
 const data=v5Records(s);
 return v5Toolbar(s)+'<div class="v5-kanban">'+['Ý tưởng','Đang thực hiện','Cần xem lại'].map((name,j)=>
 '<section class="v5-kanban-col"><h4>'+name+' <span>0'+(j+1)+'</span></h4>'+
 data.filter((_,i)=>i%3===j).map((x,i)=>'<div class="v5-kanban-card"><strong>'+v5Text(x.name)+'</strong>'+
 '<small>'+v5Text(x.owner)+' · DEMO</small><button data-v5="record" data-v5-id="'+s.id+'" data-v5-key="'+(j+i)+'">Chi tiết '+ic('right',13)+'</button></div>').join('')+'</section>').join('')+'</div>'+
 v5Related(s);
}
function v5Inbox(s){
 const rows=v5Records(s),sel=V5.selected[s.id]||new Set(),pos=[...sel][0]||0,active=rows[pos]||rows[0];
 return '<div class="v5-split"><div class="v5-card">'+rows.map((x,i)=>'<button style="width:100%;text-align:left;background:transparent;border:0" class="v5-item '+(i===pos?'selected':'')+'" data-v5="thread" data-v5-id="'+s.id+'" data-v5-key="'+i+'">'+
 '<span class="v5-item-icon">'+ic('messages',17)+'</span><span class="v5-item-main"><strong>'+v5Text(x.name)+'</strong><small>'+v5Text(x.owner)+' · '+v5Text(x.tag)+'</small></span>'+
 (i===0?v5Chip('Mới','orange'):'')+'</button>').join('')+'</div>'+
 '<div class="v5-card"><div class="v5-card-header"><div><h3>'+v5Text(active.name)+'</h3><p>Cuộc hội thoại minh họa · chưa gửi thật</p></div></div>'+
 '<div class="v5-card-body"><div style="display:flex;flex-direction:column;gap:12px;min-height:215px">'+
 '<p style="align-self:flex-start;background:#f1efe8;border-radius:12px;padding:12px;max-width:83%">Mình muốn hỏi thêm về sản phẩm này ạ?</p>'+
 '<p style="align-self:flex-end;background:#e9f2e6;border-radius:12px;padding:12px;max-width:83%">Bên mình đã nhận được câu hỏi, sẽ kiểm tra giúp bạn nhé!</p>'+
 '</div><div class="v5-toolbar" style="padding:7px"><input class="v5-input" placeholder="Soạn tin nhắn demo..." data-v5-compose="'+s.id+'"/>'+
 v5Btn(ic('arrow',14)+' Gửi bản nháp','send',s.id)+'</div></div></div></div>'+v5Related(s);
}
function v5Settings(s){
 const entries=v5Records(s);
 return '<div class="v5-grid"><div><section class="v5-card"><div class="v5-card-header"><div><h3>Thiết lập '+v5Text(s.category.toLowerCase())+'</h3><p>Thay đổi chỉ áp dụng trong phiên giao diện demo</p></div></div>'+
 '<div class="v5-card-body"><div class="v5-form-grid">'+
 ['Tên hiển thị','Phạm vi hoạt động','Thông báo email','Quyền chia sẻ'].map((name,i)=>
 '<div class="v5-field"><label>'+name+'</label>'+(i===2||i===3?
 '<button class="v5-toolbtn" data-v5="toggle" data-v5-id="'+s.id+'" data-v5-key="'+i+'">'+(V5.statuses[s.id+'-setting-'+i]||'Đang bật')+' '+ic('settings',15)+'</button>':
 '<input class="v5-input" data-v5-input="'+s.id+'-'+i+'" placeholder="'+name+'" value="'+v5Text((V5.forms[s.id]||{})[i]|| (i===0?'Creative Studio':'Mọi thành viên'))+'"/>')+
 '</div>').join('')+'</div><div style="margin-top:20px">'+v5Btn(ic('check',15)+' Lưu thiết lập demo','save',s.id)+'</div></div></section></div>'+
 '<div><div class="v5-inspector"><strong>Minh bạch về quyền và dữ liệu</strong>Prototype không có kết nối tài khoản thật, không lưu khóa API và không thay đổi cấu hình production.</div>'+
 '<div style="height:15px"></div>'+v5Related(s)+'</div></div>';
}
function v5Auth(s){
 const isForgot=/quên|forgot/i.test(s.title),isSignUp=/đăng ký|register/i.test(s.title);
 return '<div class="v5-card" style="max-width:530px;margin:12px auto;width:100%"><div class="v5-card-header"><div><h3>'+v5Text(s.title)+'</h3>'+
 '<p>Giao diện xác thực mẫu. Không có kết nối đăng nhập thật.</p></div></div><div class="v5-card-body">'+
 '<div class="v5-field"><label>Email</label><input class="v5-input" type="email" placeholder="hello@example.com" id="v5-auth-email"/></div>'+
 (!isForgot?'<div class="v5-field v5-spaced"><label>Mật khẩu</label><input type="password" class="v5-input" id="v5-auth-password" placeholder="Nhập mật khẩu"/></div>':'')+
 (isSignUp?'<div class="v5-field v5-spaced"><label>Tên hiển thị</label><input class="v5-input" id="v5-auth-name" placeholder="Tên của bạn"/></div>':'')+
 '<div style="margin-top:20px">'+v5Btn(isForgot?'Mô phỏng gửi email':isSignUp?'Tạo tài khoản DEMO':'Đăng nhập DEMO','auth',s.id)+'</div>'+
 '<p class="v5-quiet" style="margin-top:15px">Không gửi thông tin hoặc tạo tài khoản ngoài hệ thống.</p></div></div>'+v5Related(s);
}
function v5Screen(s){
 const v=s.variant;
 const header='<div class="v5-head"><div class="v5-kicker">'+ic('layers',14)+' '+v5Text(s.category.toUpperCase())+' · '+v5Text(s.module)+
 '</div><div class="v5-actions">'+v5Chip('DEMO','demo')+v5Btn(ic('more',15)+' Tác vụ','actions',s.id)+'</div></div>';
 let body='';
 if(v==='auth')body=v5Auth(s);
 else if(v==='analytics')body=v5Analytics(s);
 else if(v==='approval')body=v5Approval(s);
 else if(v==='editor'||v==='form')body=v5Editor(s,v==='form');
 else if(v==='calendar')body=v5Calendar(s);
 else if(v==='workflow')body=v5Workflow(s);
 else if(v==='board')body=v5Board(s);
 else if(v==='inbox')body=v5Inbox(s);
 else if(v==='settings')body=v5Settings(s);
 else if(v==='table'||v==='commerce')body=v5Table(s);
 else if(v==='dashboard')body=v5Metrics(s)+v5Analytics(s);
 else if(v==='search')body=v5Toolbar(s)+v5Table(s);
 else if(v==='detail')body=v5Editor(s);
 else body=v5Board(s);
 const srcActions=(s.sourceActions||[]).slice(0,6);
 if(srcActions.length)body+='<section class="v5-card"><div class="v5-card-header"><div><h3>Thao tác nghiệp vụ</h3><p>Các thao tác từ đặc tả được mô phỏng trong prototype</p></div></div>'+
 '<div class="v5-card-body"><div class="v5-actions">'+srcActions.map((a,i)=>'<button class="v5-toolbtn" data-v5="source-action" data-v5-key="'+i+'" data-v5-id="'+s.id+'">'+v5Text(a.label)+' '+ic('right',13)+'</button>').join('')+'</div></div></section>';
 return '<div class="v5-screen" data-full-screen="'+v5Esc(s.id)+'" data-variant="'+v5Esc(v)+'">'+header+body+'</div>';
}
function v5Toast(msg){const el=document.getElementById('toast-root');el.innerHTML='<div class="toast">'+v5Text(msg)+'</div>';clearTimeout(window.__v5t);window.__v5t=setTimeout(()=>el.innerHTML='',2900)}
function v5Modal(title,content,buttons){
 V5.modals++;
 document.getElementById('overlay-root').innerHTML='<div class="overlay-backdrop" data-v5="close-modal-backdrop">'+
 '<section role="dialog" aria-modal="true" aria-label="'+v5Esc(title)+'" class="dialog v5-dialog" data-v5-stop="true">'+
 '<div style="display:flex;align-items:center;justify-content:space-between;gap:10px"><h2 style="font-size:21px;margin:0">'+v5Text(title)+'</h2>'+
 '<button class="btn" data-v5="close-modal">Đóng</button></div>'+content+'<div class="dialog-actions">'+(buttons||'<button class="btn accent" data-v5="close-modal">Đã hiểu</button>')+'</div></section></div>';
}
function v5Refresh(){const pos=window.scrollY;renderShell();window.scrollTo({top:pos,behavior:'instant'})}
function v5Action(source,el){
 const s=v5Src(el.dataset.v5Id||state.id);if(!s)return;
 const idx=Number(el.dataset.v5Key||0);
 const id=s.id;
 if(source==='create'||source==='edit'){
  v5Modal('Tạo bản ghi · '+s.category,'<p>Dữ liệu chỉ được tạo trong phiên demo hiện tại.</p>'+
   '<div class="v5-field"><label>Tên bản ghi</label><input id="v5-modal-title" class="v5-input" placeholder="Nhập tên..."/></div>'+
   '<div class="v5-field v5-spaced"><label>Ghi chú</label><textarea id="v5-modal-note" class="v5-textarea" placeholder="Mô tả ngắn..."></textarea></div>',
   '<button class="btn" data-v5="close-modal">Hủy</button><button class="btn accent" data-v5="add-record" data-v5-id="'+id+'">Lưu bản ghi demo</button>');
  document.getElementById('v5-modal-title')?.focus();return;
 }
 if(source==='add-record'){
  const title=document.getElementById('v5-modal-title')?.value.trim();
  if(!title){v5Toast('Vui lòng nhập tên bản ghi');document.getElementById('v5-modal-title')?.focus();return}
  (V5.extra[id]??=[]).unshift({name:title,owner:'Bạn (DEMO)',tag:'Mới tạo',value:'0đ',id:Date.now()});
  document.getElementById('overlay-root').innerHTML='';v5Refresh();v5Toast('Đã thêm bản ghi demo');return;
 }
 if(source==='close-modal'){document.getElementById('overlay-root').innerHTML='';return}
 if(source==='close-modal-backdrop'){if(el===window.event?.target)document.getElementById('overlay-root').innerHTML='';return}
 if(source==='period'){V5.period[id]=el.dataset.v5Key;v5Refresh();return}
 if(source==='sort'){V5.sort[id]=!V5.sort[id];v5Refresh();return}
 if(source==='filter'){V5.sort[id]=!V5.sort[id];v5Refresh();v5Toast('Đã thay đổi bộ lọc mô phỏng');return}
 if(source==='record'||source==='preview'){
  const item=v5FilteredRecords(s)[idx]||v5Records(s)[0];
  v5Modal(source==='preview'?'Xem trước bản nháp':'Chi tiết · '+(item?.name||s.title),
   '<p>'+v5Text(s.category)+' · Thông tin minh họa, không có dữ liệu khách hàng thật.</p>'+
   '<div class="v5-inspector"><strong>Đối tượng đang xem</strong>'+v5Text(item?.name||s.title)+'<br>Trạng thái: '+v5Text(v5Status(s,idx))+'<br>Người phụ trách: '+v5Text(item?.owner||'Creator Studio')+'</div>',
   '<button class="btn" data-v5="close-modal">Đóng</button><button class="btn accent" data-v5="edit" data-v5-id="'+id+'">Chỉnh sửa demo</button>');return;
 }
 if(source==='toggle'){let key=id+'-setting-'+idx;V5.statuses[key]=V5.statuses[key]==='Đang tắt'?'Đang bật':'Đang tắt';v5Refresh();return}
 if(source==='thread'){V5.selected[id]=new Set([idx]);v5Refresh();return}
 if(source==='select-row'){
   let sel=V5.selected[id]??new Set();if(el.checked)sel.add(idx);else sel.delete(idx);V5.selected[id]=sel;return;
 }
 if(source==='select-all'){V5.selected[id]=el.checked?new Set(v5FilteredRecords(s).map((_,i)=>i)):new Set();v5Refresh();return}
 if(source==='export'){
  const records=v5Records(s),lines=[['Mục','Người phụ trách','Trạng thái','Giá trị DEMO'],...records.map((x,i)=>[x.name,x.owner,v5Status(s,i),x.value])];
  const csv='\uFEFF'+lines.map(row=>row.map(x=>'"'+String(x).replaceAll('"','""')+'"').join(',')).join('\r\n');
  const blob=new Blob([csv],{type:'text/csv;charset=utf-8'}),url=URL.createObjectURL(blob),a=document.createElement('a');
  a.href=url;a.download='creativanta-demo-'+id+'.csv';document.body.append(a);a.click();a.remove();setTimeout(()=>URL.revokeObjectURL(url),400);
  v5Toast('Đã xuất CSV dữ liệu minh họa');return;
 }
 if(source==='decision'||source==='reject'||source==='source-action'){
  const item=source==='source-action'?s.sourceActions[idx]:null;
  if(item && item.type==='export')return v5Action('export',el);
  if(item && item.type==='navigation'){
    const next=(s.related||[]).find(x=>V5_BY_ID.has(x));
    document.getElementById('overlay-root').innerHTML='';
    if(next)navigate(next);else v5Action('record',el);return;
  }
  if(item && item.type==='filter')return v5Action('filter',el);
  if(item && item.type==='upload')return v5Action('upload',el);
  if(item && item.type==='mutate'&&!/delete|remove|suspend|approve|publish/i.test(item.sourceName))return v5Action('create',el);
  const actionName=item?.label || (source==='reject'?'Chuyển xử lý':'Phê duyệt');
  V5.pending={id,idx,actionName};
  v5Modal('Xác nhận thao tác','<p><strong>'+v5Text(actionName)+'</strong> có thể thay đổi trạng thái nghiệp vụ. Trong prototype, thay đổi chỉ là mô phỏng, không gửi API.</p>'+
   '<div class="v5-notice warning">'+ic('shield',16)+' Bản DEMO không thực hiện thay đổi dữ liệu thật.</div>',
   '<button class="btn" data-v5="close-modal">Hủy</button><button class="btn accent" data-v5="confirm-decision" data-v5-id="'+id+'">Xác nhận DEMO</button>');
  return;
 }
 if(source==='confirm-decision'){
  if(V5.pending){V5.statuses[V5.pending.id+'-'+V5.pending.idx]='Đã xác nhận DEMO';}
  V5.pending=null;document.getElementById('overlay-root').innerHTML='';v5Refresh();v5Toast('Đã ghi nhận quyết định trong bộ nhớ demo');return;
 }
 if(source==='actions'){
  const arr=s.sourceActions||[];
  v5Modal('Thao tác · '+s.title,'<p>Các thao tác mô phỏng theo đặc tả nghiệp vụ.</p>'+
   (arr.length?arr.map((a,i)=>'<button class="v5-toolbtn" style="width:100%;justify-content:space-between;margin:6px 0" data-v5="source-action" data-v5-id="'+id+'" data-v5-key="'+i+'">'+v5Text(a.label)+' '+ic('right',14)+'</button>').join(''):
   '<div class="v5-inspector">Màn hình dùng các thao tác chung: xem, lọc, tạo và quản lý bản nháp.</div>'),
   '<button class="btn" data-v5="close-modal">Đóng</button>');return;
 }
 if(source==='upload'){
  v5Modal('Chọn tệp / hóa đơn','<p>Thiết kế minh họa cho quá trình đính kèm. Không có dữ liệu nào được tải lên máy chủ.</p>'+
   '<input type="file" id="v5-demo-upload" class="v5-input" accept="image/*,.pdf,.csv"/>',
   '<button class="btn" data-v5="close-modal">Hủy</button><button class="btn accent" data-v5="confirm-upload" data-v5-id="'+id+'">Gắn vào bản nháp</button>');return;
 }
 if(source==='confirm-upload'){
  const name=document.getElementById('v5-demo-upload')?.files?.[0]?.name||'Tệp mẫu';
  document.getElementById('overlay-root').innerHTML='';v5Toast('Đã chọn '+name+' (DEMO)');return;
 }
 if(source==='send'||source==='run'){
  const txt=document.querySelector('[data-v5-compose="'+id+'"]')?.value.trim();
  v5Modal(source==='send'?'Gửi phản hồi demo':'Chạy quy trình demo',
   '<p>'+(source==='send'?'Nội dung soạn: '+v5Text(txt||'Chưa nhập nội dung'):'Quy trình được mô phỏng cục bộ, không kích hoạt tác vụ thật.')+'</p>',
   '<button class="btn" data-v5="close-modal">Hủy</button><button class="btn accent" data-v5="confirm-decision" data-v5-id="'+id+'">Chạy mô phỏng</button>');
  V5.pending={id,idx:0,actionName:'Thao tác demo'};return;
 }
 if(source==='auth'){
  const email=document.getElementById('v5-auth-email')?.value||'';
  if(!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)){v5Toast('Vui lòng nhập email hợp lệ');return}
  v5Toast('Đã kiểm tra biểu mẫu DEMO — không đăng nhập thật');return;
 }
 if(source==='save'){
  const data={};
  document.querySelectorAll('[data-v5-input^="'+id+'-"]').forEach((e,i)=>data[i]=e.value);
  V5.forms[id]=data;v5Toast('Đã lưu thay đổi trong phiên DEMO');return;
 }
 v5Toast('Thao tác chỉ được mô phỏng trong prototype');
}
document.addEventListener('click',function v5OnClick(event){
 const el=event.target.closest('[data-v5]');
 if(!el)return;
 event.preventDefault();
 if(el.dataset.v5==='close-modal-backdrop'&&event.target!==el)return;
 v5Action(el.dataset.v5,el);
});
document.addEventListener('input',function v5OnInput(event){
 const el=event.target;
 if(el.dataset.v5Search){
  const sid=el.dataset.v5Search;const text=el.value;V5.query[sid]=text;
  const s=v5Src(sid);if(!s)return;
  const wrapper=document.querySelector('.v5-screen');
  if(!wrapper)return;
  const oldScroll=window.scrollY;
  renderShell();window.scrollTo({top:oldScroll,behavior:'instant'});
  const input=document.querySelector('[data-v5-search="'+sid+'"]');input?.focus();
  input?.setSelectionRange(text.length,text.length);
 }
});

window.__cv5QA=(id)=>navigate(id);

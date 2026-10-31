
function renderTitle(){
 const g=group();
 if(state.id===g.ids[0])return SURFACE==='admin'?'Tổng quan vận hành':g.id==='home'?'Tổng quan hôm nay':g.label;
 return label(state.id);
}
function renderDescription(){
 const g=group();
 const desc={
 home:'Một nơi cho những điều quan trọng nhất — và bước tiếp theo nên làm.',
 discover:'Nhận diện tín hiệu tốt, chọn đúng cơ hội, loại bỏ nhiễu.',
 create:'Từ một ý tưởng đến nội dung sẵn sàng xuất bản.',
 publish:'Mọi nội dung, lịch trình và bước phê duyệt trong một dòng chảy.',
 inbox:'Hiểu người xem, trả lời đúng lúc và chăm sóc khách hàng.',
 commerce:'Quản lý đơn hàng, sản phẩm và hiệu quả bán hàng.',
 insights:'Nhìn thấy kết quả thực, không chỉ số lượt xem.',
 automate:'Để quy trình lặp lại chạy nhẹ nhàng và có kiểm soát.',
 settings:'Không gian, kết nối và cài đặt của bạn.',
 people:'Chăm sóc tài khoản, quyền và không gian làm việc.',
 moderate:'Giữ nền tảng an toàn và có thể kiểm toán.',
 platform:'Giám sát hệ thống và các chức năng cốt lõi.',
 support:'Quản lý yêu cầu trợ giúp và lịch sử giải quyết.'
 };
 return desc[g.id]||'Các công cụ cho công việc đang thực hiện.';
}
function firstIn(name){const g=NAV.find(x=>x.id===name);return g?.ids.find(id=>BY_ID.has(id))||ROOT_ID}
function pageHeaderTag(){return '<div class="info-strip">'+ic('alert',16)+'<span><strong>Chế độ DEMO</strong> · Dữ liệu minh họa, chưa kết nối hệ thống thật.</span></div>'}
function renderMetricStrip(){
 let metrics=SURFACE==='admin'?[
 ['Yêu cầu cần xử lý','18','7 ưu tiên hôm nay'],
 ['Sức khỏe nền tảng','99,7%','minh họa, chưa live'],
 ['Cảnh báo đang mở','03','chưa phân loại tự động'],
 ['Hỗ trợ chờ phản hồi','12','4 cần theo dõi']
 ]:[
 ['Việc cần làm hôm nay','03','2 việc ưu tiên'],
 ['Nội dung đang sản xuất','08','2 chờ phê duyệt'],
 ['Lịch đăng tuần này','12','5 đã sẵn sàng'],
 ['Đơn hàng mới','24','chỉ dữ liệu DEMO']
 ];
 return '<section class="metrics" aria-label="Chỉ số minh họa">'+metrics.map(([a,b,c],i)=>'<div class="metric"><div class="m-label">'+a+' '+ic(i===0?'clock':i===1?'layers':i===2?'calendar':'bag',15)+'</div><div class="m-value">'+b+'</div><div class="m-foot">'+c+'</div></div>').join('')+'</section>';
}
function homePage(){
 const discover=firstIn('discover'),create=firstIn('create'),publish=firstIn('publish'),commerce=firstIn('commerce');
 const tasks=[
 {key:'pick',title:'Chọn một xu hướng có tiềm năng',subtitle:'3 tín hiệu mới cần đánh giá',go:discover},
 {key:'script',title:'Hoàn thiện kịch bản video tiếp theo',subtitle:'Bản nháp đang chờ chỉnh sửa',go:create},
 {key:'schedule',title:'Kiểm tra lịch xuất bản ngày mai',subtitle:'2 bài viết cần xác nhận',go:publish}
 ];
 const completed=tasks.filter(t=>state.taskDone.has(t.key)).length;
 const feature='<section class="feature"><div><small>KHÔNG GIAN SÁNG TẠO · DEMO</small>'+
 '<h2>Ý tưởng tốt hôm nay.<br/>Kết quả rõ ràng ngày mai.</h2>'+
 '<p>Khởi đầu từ một tín hiệu đáng chú ý. Creativanta giúp bạn biến nó thành nội dung, khách hàng và doanh thu có thể theo dõi.</p>'+
 '<div style="display:flex;flex-wrap:wrap;gap:10px">'+btn('Khám phá cơ hội '+ic('arrow',15),discover)+
 '<button class="btn" style="background:transparent;color:#d7d3f3;border-color:#57526a" data-go="'+create+'">Tiếp tục sáng tạo</button></div></div>'+
 '<div class="feature-art" aria-hidden="true"><div class="ring"></div><div class="ring r2"></div>'+
 '<div class="signal"><span class="signal-label">CONTENT MOMENTUM / DEMO</span>'+[40,64,53,78,70,89,68,95].map(x=>'<i style="height:'+x+'%"></i>').join('')+'</div></div></section>';
 const taskRows='<div class="focus-list">'+tasks.map((t,i)=>'<div class="focus-row '+(state.taskDone.has(t.key)?'done':'')+'">'+
 '<button class="check '+(state.taskDone.has(t.key)?'checked':'')+'" aria-label="Đánh dấu '+esc(t.title)+'" data-act="task" data-key="'+t.key+'">'+(state.taskDone.has(t.key)?ic('check',14):'')+'</button>'+
 '<div class="focus-text"><strong>'+esc(t.title)+'</strong><small>'+esc(t.subtitle)+'</small></div>'+
 '<button class="focus-arrow" data-go="'+t.go+'" aria-label="Mở công việc">'+ic('right',17)+'</button></div>').join('')+'</div>'+
 '<div class="progressline" aria-label="'+completed+' trên 3 việc hoàn thành">'+tasks.map((t,i)=>'<i class="'+(state.taskDone.has(t.key)?'filled':'')+'"></i>').join('')+'</div>';
 const pipeLabels=[
 ['Khám phá','compass',discover],['Ý tưởng','sparkles',create],['Sản xuất','play',create],['Xuất bản','calendar',publish],['Doanh thu','chart',commerce]
 ];
 const pipe='<div class="pipeline">'+pipeLabels.map(([t,icname,id],i)=>'<button class="pipe '+(i<2?'done':i===2?'active':'')+'" data-go="'+id+'" style="border:0;background:transparent;text-align:left;cursor:pointer">'+
 '<div class="p-icon">'+ic(icname,16)+'</div><strong>'+t+'</strong><small>'+(i<2?'Có dữ liệu mẫu':i===2?'Đang thực hiện':'Sắp tới')+'</small></button>').join('')+'</div>';
 return feature+renderMetricStrip()+'<div class="page-grid"><div>'+
 sectionTitle('Ưu tiên hôm nay','Hoàn thành những công việc đáng giá nhất')+
 '<section class="panel">'+taskRows+'</section>'+
 '<div style="height:23px"></div>'+sectionTitle('Dòng chảy nội dung','Từ tín hiệu đến kết quả')+
 '<section class="panel"><div class="panel-body">'+pipe+'</div><div class="panel-foot">Quy trình minh họa · Xem từng bước trong các khu vực tương ứng</div></section>'+
 '</div><div>'+sectionTitle('Mới trong workspace','Đang cần bạn chú ý',create)+
 '<section class="panel">'+
 listrow('compass','Chủ đề chăm sóc da tối giản','Có xu hướng tăng · DEMO',discover)+
 listrow('play','Video: Routine 60 giây','Bản nháp đang chờ xem lại',create,'orange')+
 listrow('messages','Khách hàng hỏi về đơn #C-209','Chưa trả lời · DEMO',firstIn('inbox'),'mint')+
 listrow('bag','24 đơn hàng mô phỏng','Xem hàng đợi xử lý',commerce,'blue')+
 '<div class="panel-foot">Các tín hiệu trên chỉ dùng để xem trước thiết kế</div></section>'+
 '<div style="height:22px"></div>'+sectionTitle('Lối tắt hữu ích')+
 '<section class="panel">'+
 listrow('sparkles','Tạo ý tưởng mới','Bắt đầu từ một cơ hội',create)+
 listrow('calendar','Lên lịch nội dung','Tránh trùng giờ xuất bản',publish,'mint')+
 listrow('chart','Xem lợi nhuận','Kết nối nội dung với kết quả',firstIn('insights'),'orange')+'</section>'+
 '</div></div>';
}
function discoverPage(){
 const options=[['all','Tất cả'],['beauty','Làm đẹp'],['home','Đời sống'],['tech','Công nghệ']];
 const selected=state.filters.discover||'all';
 const rows=[
 {cat:'beauty',title:'Skinimalism: chăm da vừa đủ',sub:'Đang có nhu cầu tìm hiểu · DEMO',badge:'Đang lên',kind:'purple',desc:'Góc nội dung: 3 bước cơ bản giúp tiết kiệm thời gian mà vẫn hiệu quả.'},
 {cat:'home',title:'Góc làm việc nhỏ, hiệu suất lớn',sub:'Tín hiệu ổn định · DEMO',badge:'Tiềm năng',kind:'green',desc:'Góc nội dung: thử thách làm mới góc làm việc chỉ với 3 món đồ.'},
 {cat:'tech',title:'AI giúp creator tiết kiệm 2 giờ/ngày',sub:'Thảo luận tăng · DEMO',badge:'Khám phá',kind:'orange',desc:'Góc nội dung: kể một quy trình trước/sau khi ứng dụng công cụ AI.'},
 {cat:'beauty',title:'Routine buổi tối cho người bận rộn',sub:'Đang được lưu nhiều · DEMO',badge:'Theo dõi',kind:'gray',desc:'Góc nội dung: biến lời khuyên dài thành video ngắn có tính thực tế.'}
 ];
 const filtered=rows.filter(x=>selected==='all'||x.cat===selected);
 const filters='<div class="controls">'+options.map(([id,l])=>'<button class="chip '+(selected===id?'active':'')+'" data-act="filter" data-filter="'+id+'">'+l+'</button>').join('')+'</div>';
 const cards=filtered.map(x=>'<article class="item-card"><div style="display:flex;justify-content:space-between;align-items:center">'+
 pill(x.badge,x.kind)+'<span style="font-size:10px;color:#a5a5af">Dữ liệu demo</span></div>'+
 '<h3>'+esc(x.title)+'</h3><p>'+esc(x.desc)+'</p>'+chartBars(2)+
 '<div class="item-foot"><small>'+esc(x.sub)+'</small><button class="link" data-go="'+firstIn('create')+'">Phát triển ý tưởng '+ic('right',13)+'</button></div></article>').join('');
 return pageHeaderTag()+
 '<div class="page-grid" style="grid-template-columns:minmax(0,1fr) 270px;margin-bottom:23px"><div>'+
 sectionTitle('Cơ hội nổi bật','Đã chọn lọc để bạn không phải đọc mọi tín hiệu')+
 filters+'<div class="card-grid">'+cards+'</div></div><div>'+sectionTitle('Gợi ý cách làm')+
 panel('Bắt đầu từ điều quan trọng','<div style="display:flex;flex-direction:column;gap:17px;padding:4px 0 6px">'+
 ['Xác định đối tượng thực sự quan tâm','Kiểm tra bằng chứng và nguồn tín hiệu','Đưa thành ý tưởng có thể sản xuất'].map((x,i)=>'<div style="display:flex;gap:11px;align-items:flex-start"><span class="pill purple">0'+(i+1)+'</span><span style="font-size:12px;color:#545464">'+x+'</span></div>').join('')+
 '</div>','Chỉ là ví dụ thiết kế')+'</div></div>'+
 sectionTitle('Tín hiệu bạn đang theo dõi','Bộ dữ liệu minh họa',firstIn('create'))+
 '<section class="panel">'+listrow('target','Danh mục làm đẹp','Các video ngắn có tăng trưởng ổn định',firstIn('create'))+
 listrow('target','Thiết bị cho góc làm việc','Đang chờ đánh giá thêm bằng chứng',firstIn('create'),'mint')+'</section>';
}
function createPage(){
 const ideas=[{title:'Routine tối giản trong 60 giây',tag:'Video ngắn',sub:'Ý tưởng · DEMO'},
 {title:'5 lỗi khi setup góc làm việc',tag:'Carousel',sub:'Nháp · DEMO'},...state.ideas.map(x=>({title:x.title,tag:'Mới',sub:'Tạo trong phiên demo'}))];
 const work=[{title:'Script: Giải pháp cho da dầu',tag:'Đang viết',sub:'Kịch bản · DEMO'},
 {title:'AI Storyboard — Sản phẩm A',tag:'Đang xử lý',sub:'Studio · DEMO'}];
 const ready=[{title:'Review phụ kiện workspace',tag:'Chờ duyệt',sub:'Đã dựng · DEMO'},
 {title:'Câu hỏi thường gặp: chăm da',tag:'Dự thảo',sub:'Có thể kiểm tra lại'}];
 const col=(title,items,kind)=>'<section class="kanban-col"><div class="kanban-title">'+title+' <small>'+items.length+'</small></div>'+
 items.map(x=>'<article class="item-card"><div>'+pill(x.tag,kind)+'</div><h3>'+esc(x.title)+'</h3><p>'+esc(x.sub)+'</p>'+
 '<div class="item-foot"><small>Chỉ bản nháp</small><button class="link" data-act="demo">Chi tiết '+ic('right',13)+'</button></div></article>').join('')+'</section>';
 return pageHeaderTag()+
 '<div class="section-title"><div><h2>Bảng ý tưởng và sản xuất</h2><p>Kéo hành trình từ ý tưởng thô đến nội dung sẵn sàng</p></div><button class="btn dark" data-act="create">'+ic('plus',16)+' Tạo ý tưởng</button></div>'+
 '<div class="kanban">'+col('Ý tưởng',ideas,'purple')+col('Đang làm',work,'orange')+col('Sẵn sàng',ready,'green')+'</div>'+
 '<div style="height:24px"></div>'+sectionTitle('Tiếp tục sáng tạo','Hai công cụ thường dùng')+
 '<div class="card-grid">'+
 '<article class="item-card"><div class="tile-icon">'+ic('file',18)+'</div><h3>Viết kịch bản</h3><p>Phát triển một thông điệp thành video có cấu trúc và nhịp kể rõ ràng.</p><div class="item-foot"><small>Mô phỏng</small>'+btn('Mở',firstIn('create'),'small')+'</div></article>'+
 '<article class="item-card"><div class="tile-icon mint">'+ic('play',18)+'</div><h3>Video Studio</h3><p>Quản lý storyboard và hàng đợi xử lý trước khi xuất bản.</p><div class="item-foot"><small>Chưa chạy AI thật</small>'+act('Xem demo','demo','small')+'</div></article>'+
 '<article class="item-card"><div class="tile-icon orange">'+ic('calendar',18)+'</div><h3>Chuẩn bị xuất bản</h3><p>Đưa nội dung đã được kiểm tra vào lịch và hệ thống quản lý.</p><div class="item-foot"><small>Lịch minh họa</small>'+btn('Mở',firstIn('publish'),'small')+'</div></article>'+
 '</div>';
}
function publishPage(){
 const days=['Hai','Ba','Tư','Năm','Sáu','Bảy','CN'];
 const events=[{d:1,text:'Video Routine 60 giây',kind:''},{d:3,text:'Review phụ kiện',kind:'mint'},{d:4,text:'Mẹo chăm da',kind:'orange'},{d:6,text:'Livestream thử nghiệm',kind:''}];
 return pageHeaderTag()+sectionTitle('Lịch nội dung tuần này','Đặt thời gian có chủ đích, không dồn vào phút cuối')+
 '<div class="calendar">'+days.map((day,i)=>'<div class="day"><span class="dlabel">Thứ '+day+'</span>'+
 events.filter(e=>e.d===i).map(e=>'<div class="event '+e.kind+'">'+esc(e.text)+'<br><span style="opacity:.75">DEMO</span></div>').join('')+'</div>').join('')+'</div>'+
 '<div style="height:25px"></div>'+sectionTitle('Cần xem lại')+
 '<section class="panel">'+listrow('file','Hai nội dung cần phê duyệt','Không có đăng bài thật',firstIn('create'),'orange')+
 listrow('clock','Kiểm tra lịch tháng tới','Xem lại khoảng cách và tần suất',firstIn('publish'),'blue')+'</section>';
}
function inboxPage(){
 const threads=[
 ['Linh N.','Còn màu xanh không?','Đang chờ trả lời · DEMO'],
 ['Ngọc H.','Có thể giao trong tuần?','Câu hỏi về đơn · DEMO'],
 ['Khánh M.','Cảm ơn bạn nhé!','Đã phản hồi · DEMO']
 ];
 const selected=threads[Math.min(state.inbox,threads.length-1)];
 return pageHeaderTag()+
 '<div class="row-layout"><div class="threadlist">'+threads.map((t,i)=>'<button class="thread '+(i===state.inbox?'active':'')+'" data-act="thread" data-index="'+i+'">'+
 '<span class="thread-avatar">'+esc(t[0][0])+'</span><span><strong>'+esc(t[0])+'</strong><p>'+esc(t[1])+'</p></span></button>').join('')+'</div>'+
 '<div class="chatbox"><div class="chathead"><span><strong>'+esc(selected[0])+'</strong><small style="display:block;color:#a2a2ad;font-size:10px">Hội thoại mô phỏng</small></span>'+
 '<span class="pill green">Đang theo dõi</span></div><div class="chatmessages"><div class="bubble">Xin chào! '+esc(selected[1])+'</div>'+
 '<div class="bubble me">Chào bạn, mình sẽ kiểm tra và phản hồi ngay nhé.</div>'+
 '<div class="bubble">Mình cảm ơn!</div></div><div class="compose"><input id="message-draft" placeholder="Soạn trả lời demo..." aria-label="Soạn tin nhắn"/>'+
 '<button class="btn accent" data-act="send">Gửi demo '+ic('arrow',14)+'</button></div></div></div>';
}
function commercePage(){
 const rows=[['C-209','Mặt nạ dưỡng ẩm','Ngọc Anh','389.000đ','Chờ xử lý','orange'],
 ['C-208','Bộ kệ bàn mini','Hải Minh','540.000đ','Đang giao','purple'],
 ['C-207','Bình nước inox','Thu Hà','230.000đ','Hoàn tất','green'],
 ['C-206','Đèn để bàn LED','An Nhiên','720.000đ','Hoàn tất','green']];
 return pageHeaderTag()+renderMetricStrip()+
 sectionTitle('Đơn hàng gần đây','Dữ liệu minh họa, không có đơn hàng thật')+
 '<section class="panel"><div class="table-wrap"><table class="data-table"><thead><tr><th>Mã đơn</th><th>Sản phẩm</th><th>Khách hàng</th><th>Giá trị</th><th>Trạng thái</th><th></th></tr></thead><tbody>'+
 rows.map(x=>'<tr><td><strong>'+x[0]+'</strong></td><td>'+x[1]+'</td><td>'+x[2]+'</td><td>'+x[3]+'</td><td>'+pill(x[4],x[5])+'</td><td><button class="link" data-act="demo">Chi tiết '+ic('right',13)+'</button></td></tr>').join('')+
 '</tbody></table></div></section>'+
 '<div style="height:24px"></div>'+sectionTitle('Đầu mối quan trọng')+
 '<div class="card-grid"><article class="item-card"><div class="tile-icon mint">'+ic('bag',18)+'</div><h3>Hàng đang bán</h3><p>Danh mục sản phẩm, tồn kho và điều kiện tiếp nhận đơn.</p>'+
 '<div class="item-foot"><small>DEMO</small>'+act('Xem demo','demo','small')+'</div></article>'+
 '<article class="item-card"><div class="tile-icon orange">'+ic('receipt',18)+'</div><h3>Chi phí</h3><p>Chi phí và chứng từ phục vụ tính lợi nhuận thực.</p>'+
 '<div class="item-foot"><small>Chưa ghi sổ thật</small>'+btn('Phân tích',firstIn('insights'),'small')+'</div></article>'+
 '<article class="item-card"><div class="tile-icon blue">'+ic('chart',18)+'</div><h3>Hiệu quả bán hàng</h3><p>Gắn kết nội dung, sản phẩm và quyết định kinh doanh.</p>'+
 '<div class="item-foot"><small>Số liệu mẫu</small>'+btn('Phân tích',firstIn('insights'),'small')+'</div></article></div>';
}
function insightsPage(){
 const values=[26,32,22,38,35,55,53,66,58,72,65,85];
 const points=values.map((n,i)=>(35+i*45)+','+(185-n*1.5)).join(' ');
 const chart='<section class="chart-panel"><div class="chart-head"><div><small>HIỆU QUẢ NỘI DUNG / DEMO</small><strong>+18,6%</strong>'+
 '<span style="font-size:11px;color:#158a72;margin-left:12px">↗ So với kỳ trước</span></div>'+pill('12 tuần','purple')+'</div>'+
 '<svg viewBox="0 0 580 195" role="img" aria-label="Biểu đồ tăng trưởng minh họa">'+
 [60,102,144].map(y=>'<path d="M20 '+y+'H570" stroke="#eeeef4" stroke-dasharray="4 5"/>').join('')+
 '<polyline points="'+points+'" fill="none" stroke="#7764de" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round"/>'+
 values.map((n,i)=>'<circle cx="'+(35+i*45)+'" cy="'+(185-n*1.5)+'" r="4" fill="#fff" stroke="#7764de" stroke-width="2"/>').join('')+
 '</svg><div style="display:flex;justify-content:space-between;color:#a2a4af;font-size:10px"><span>Đầu kỳ</span><span>Giữa kỳ</span><span>Hiện tại</span></div></section>';
 return pageHeaderTag()+renderMetricStrip()+'<div class="page-grid"><div>'+
 sectionTitle('Tín hiệu hiệu quả','Quan sát xu hướng, không suy diễn khi thiếu chứng từ')+chart+'</div><div>'+
 sectionTitle('Ý nghĩa của các con số')+
 panel('Không chỉ là lượt xem',listrow('target','Khả năng chuyển đổi','Dùng nhiều nguồn để đánh giá',firstIn('commerce'))+
 listrow('receipt','Biên lợi nhuận','Cần chứng từ và chi phí hợp lệ',firstIn('commerce'),'mint')+
 listrow('shield','Độ tin cậy của dữ liệu','Nguồn và thời điểm vẫn chỉ là DEMO',firstIn('insights'),'orange'))+
 '</div></div>';
}
function automatePage(){
 return pageHeaderTag()+sectionTitle('Luồng công việc','Bạn quyết định lúc nào máy được phép hành động')+
 '<div class="card-grid">'+[
 ['Phát hiện tín hiệu','Theo dõi chủ đề và ghi vào danh sách cần đánh giá','compass','purple'],
 ['Từ ý tưởng đến kịch bản','Tạo bản nháp để duyệt thủ công trước khi tiếp tục','sparkles','orange'],
 ['Theo dõi phản hồi','Tổng hợp cuộc hội thoại chưa được xử lý','messages','green']
 ].map(([a,b,ico,k])=>'<article class="item-card"><div class="tile-icon">'+ic(ico,19)+'</div><h3>'+a+'</h3><p>'+b+'</p>'+
 '<div class="item-foot">'+pill('Chưa kích hoạt','gray')+'<button class="link" data-act="demo">Xem quy trình '+ic('right',13)+'</button></div></article>').join('')+
 '</div><div style="height:24px"></div>'+sectionTitle('Lịch sử mô phỏng')+
 '<section class="panel">'+listrow('clock','Không có lần chạy thực tế','Cấu hình chỉ mang tính minh họa',firstIn('automate'),'blue')+'</section>';
}
function settingsPage(){
 return pageHeaderTag()+sectionTitle('Workspace của bạn','Tổ chức và quản lý quyền truy cập')+
 '<div class="card-grid">'+[
 ['Không gian làm việc','Thông tin và vai trò thành viên','users','purple'],
 ['Tài khoản kết nối','Quản lý kênh và nguồn dữ liệu','layers','mint'],
 ['Gói dịch vụ','Khả năng sử dụng và hóa đơn','receipt','orange']
 ].map(([a,b,i,k])=>'<article class="item-card"><div class="tile-icon '+k+'">'+ic(i,18)+'</div><h3>'+a+'</h3><p>'+b+'</p>'+
 '<div class="item-foot"><small>DEMO</small><button class="link" data-act="demo">Xem chi tiết '+ic('right',13)+'</button></div></article>').join('')+'</div>';
}
function adminPage(){
 return pageHeaderTag()+renderMetricStrip()+'<div class="page-grid"><div>'+
 sectionTitle('Hàng đợi cần chú ý')+
 '<section class="panel">'+listrow('shield','3 yêu cầu kiểm duyệt','Không thực hiện xử lý thật',firstIn('moderate'),'red')+
 listrow('users','Tài khoản cần xem xét','Mô phỏng phân quyền',firstIn('people'))+
 listrow('activity','Trạng thái nền tảng','Số liệu chưa kết nối live',firstIn('platform'),'mint')+'</section>'+
 '</div><div>'+sectionTitle('Lối tắt vận hành')+
 '<section class="panel">'+listrow('messages','Phiếu hỗ trợ','12 yêu cầu minh họa',firstIn('support'))+
 listrow('chart','Báo cáo sử dụng','Thống kê minh họa',firstIn('insights'),'orange')+
 listrow('settings','Cấu hình hệ thống','Tất cả thay đổi cần xác nhận',firstIn('settings'),'blue')+'</section></div></div>';
}
function genericPage(){
 const s=BY_ID.get(state.id);
 const view=group().id;
 const purpose=s?.purpose||'Giao diện cần hoàn thiện khi mở rộng prototype';
 const related=group().ids.filter(x=>BY_ID.has(x)&&x!==state.id).slice(0,3);
 return pageHeaderTag()+'<section class="panel"><div class="panel-head"><div><h3>'+esc(label(state.id))+'</h3>'+
 '<p>Cấu trúc riêng của màn hình này sẽ được hoàn thiện sau khi concept được duyệt.</p></div></div>'+
 '<div class="panel-body"><p style="font-size:13px;color:#797a8b;max-width:640px;line-height:1.7">'+esc(purpose)+'</p>'+
 '<div style="display:flex;gap:9px;flex-wrap:wrap;margin-top:24px">'+related.map(id=>btn('Mở '+label(id),id)).join('')+'</div></div></section>';
}
function renderView(){
 const grp=group().id;
 if(state.id!==group().ids[0] && !group().ids.includes(state.id))return genericPage();
 if(SURFACE==='admin'&&grp==='home')return adminPage();
 if(grp==='home')return homePage();
 if(grp==='discover')return discoverPage();
 if(grp==='create')return createPage();
 if(grp==='publish')return publishPage();
 if(grp==='inbox')return inboxPage();
 if(grp==='commerce')return commercePage();
 if(grp==='insights')return insightsPage();
 if(grp==='automate')return automatePage();
 if(grp==='settings')return settingsPage();
 if(['people','moderate','platform','support'].includes(grp))return adminPage();
 return genericPage();
}

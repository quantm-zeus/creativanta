/* Creativanta Go / true mobile V4 concept.
   All information and interaction states are local DEMO. */
(()=>{'use strict';
const SCREENS=Array.isArray(window.CREATIVANTA_MOBILE_SCREENS)?window.CREATIVANTA_MOBILE_SCREENS:[];
const ICONS={
  home:'<path d="m3 10 9-7 9 7v10H3z"/><path d="M9 20v-7h6v7"/>',
  compass:'<circle cx="12" cy="12" r="9"/><path d="m16 8-2.5 5.5L8 16l2.5-5.5z"/>',
  sparkles:'<path d="m12 2 2.3 7.7L22 12l-7.7 2.3L12 22l-2.3-7.7L2 12l7.7-2.3z"/>',
  messages:'<path d="M4 5h16v12H9l-5 4z"/><path d="M8 10h8M8 13h5"/>',
  menu:'<path d="M4 7h16M4 12h16M4 17h16"/>',
  search:'<circle cx="10.5" cy="10.5" r="6.5"/><path d="m16 16 5 5"/>',
  bell:'<path d="M18 8a6 6 0 0 0-12 0c0 8-3 8-3 10h18c0-2-3-2-3-10zM10 21h4"/>',
  plus:'<path d="M12 4v16M4 12h16"/>',
  arrow:'<path d="M4 12h16m-7-7 7 7-7 7"/>',
  right:'<path d="m9 5 7 7-7 7"/>',
  left:'<path d="m15 5-7 7 7 7"/>',
  close:'<path d="M5 5 19 19M19 5 5 19"/>',
  check:'<path d="m4 12 5 5L20 6"/>',
  clock:'<circle cx="12" cy="12" r="9"/><path d="M12 7v5l4 2"/>',
  calendar:'<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M7 3v4m10-4v4M3 10h18"/>',
  bag:'<rect x="4" y="7" width="16" height="14" rx="2"/><path d="M8 8V6a4 4 0 0 1 8 0v2"/>',
  chart:'<path d="M3 19V5M3 19h18"/><path d="m6 15 5-5 4 2 5-7"/>',
  layers:'<path d="m12 3 9 5-9 5-9-5zM3 12l9 5 9-5M3 16l9 5 9-5"/>',
  play:'<path d="m8 5 11 7-11 7z"/>',
  folder:'<path d="M3 6h7l2 3h9v12H3z"/>',
  file:'<path d="M6 2h9l4 4v16H6zM14 2v5h5M9 12h7M9 16h7"/>',
  target:'<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="5"/><circle cx="12" cy="12" r="1"/>',
  book:'<path d="M4 4h16v17H7a3 3 0 0 1-3-3zM4 18a3 3 0 0 1 3-3h13"/>',
  settings:'<circle cx="12" cy="12" r="3"/><path d="M4 7l3-3 3 1 2-2 3 2 3-1 2 3-1 3 2 2-2 3 1 3-3 2-3-1-2 2-3-2-3 1-2-3 1-3-2-2 2-3z"/>',
  zap:'<path d="M13 2 4 13h7l-1 9 10-12h-7z"/>',
  users:'<circle cx="9" cy="8" r="3"/><path d="M3 21v-3a6 6 0 0 1 12 0v3M16 5a3 3 0 0 1 0 6M17 14a5 5 0 0 1 4 5v2"/>',
  send:'<path d="m21 3-8.4 18-3.2-7-7-3.2zM9.4 14 21 3"/>',
  filter:'<path d="M4 6h16l-6 7v6l-4 2v-8z"/>',
  receipt:'<path d="M5 3h14v18l-3-2-4 2-4-2-3 2zM9 8h6M9 12h6"/>',
  shield:'<path d="m12 2 9 4v6c0 6-3.5 8-9 10-5.5-2-9-4-9-10V6z"/><path d="m8 12 3 3 5-6"/>',
  refresh:'<path d="M20 4v6h-6M4 20v-6h6"/><path d="M6 9a7 7 0 0 1 12-2l2 3M4 14l2 3a7 7 0 0 0 12-2"/>',
  more:'<circle cx="5" cy="12" r="1"/><circle cx="12" cy="12" r="1"/><circle cx="19" cy="12" r="1"/>',
  building:'<path d="M4 21V3h16v18M2 21h20M8 7h2m4 0h2M8 11h2m4 0h2M9 21v-5h6v5"/>'
};
const icon=(key,size=19)=>'<svg width="'+size+'" height="'+size+'" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round" stroke-linecap="round" aria-hidden="true">'+(ICONS[key]||ICONS.layers)+'</svg>';
const escapeHTML=v=>String(v??'').replace(/[&<>"']/g,ch=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[ch]));
const state={
  section:'home',overlay:null,filter:'all',studioTab:'ideas',day:5,
  tasks:new Set(),ideas:[],thread:null,messages:[],order:null,search:'',details:null,
  reviews:new Set(), notificationSeen:false
};
const NAV=[['home','Hôm nay','home'],['discover','Khám phá','compass'],['studio','Sáng tạo','sparkles'],['inbox','Hộp thư','messages'],['more','Thêm','menu']];
const TRENDS=[
 {id:'skin',title:'Skinimalism đang trở lại',detail:'Chăm sóc da vừa đủ, không cần 10 bước.',cat:'beauty',tag:'Đang lên',style:'skin',code:'BEAUTY / 01',growth:'+32%',desc:'Tín hiệu tăng trong nội dung demo về thói quen chăm sóc da tối giản.'},
 {id:'desk',title:'Góc làm việc nhỏ, hiệu suất lớn',detail:'Những món đồ đơn giản thay đổi trải nghiệm.',cat:'home',tag:'Tiềm năng',style:'desk',code:'LIVING / 02',growth:'+18%',desc:'Nhóm video setup tối giản được quan tâm trong dữ liệu minh họa.'},
 {id:'ai',title:'Creator làm nội dung với AI',detail:'Quy trình biến ý tưởng thành video trong ngày.',cat:'tech',tag:'Khám phá',style:'ai',code:'TECH / 03',growth:'+24%',desc:'Chủ đề năng suất sáng tạo được xem xét trong bản mẫu.'}
];
const THREADS=[
 {id:'linh',initial:'L',name:'Linh Nguyễn',last:'Shop còn màu xanh không ạ?',time:'09:42',unread:2,tone:'pink',texts:['Chào shop, mẫu này còn màu xanh không ạ?','Mình muốn đặt để tặng bạn.']},
 {id:'ngoc',initial:'N',name:'Ngọc Hà',last:'Có thể giao trong tuần này?',time:'08:15',unread:1,tone:'',texts:['Mình có thể nhận đơn trong tuần này không?']},
 {id:'khanh',initial:'K',name:'Khánh Minh',last:'Cảm ơn bạn nhiều nhé!',time:'Hôm qua',unread:0,tone:'gold',texts:['Mình nhận được hàng rồi, cảm ơn bạn!']}
];
const ORDERS=[
 {id:'#CV-209',product:'Bộ chăm sóc tối giản',name:'Ngọc Anh',cost:'389.000đ',status:'Chờ xử lý',tone:'orange'},
 {id:'#CV-208',product:'Kệ bàn mini',name:'Hải Minh',cost:'540.000đ',status:'Đang giao',tone:'green'},
 {id:'#CV-207',product:'Bình giữ nhiệt',name:'Thu Hà',cost:'230.000đ',status:'Hoàn tất',tone:'gray'}
];
const CORE={
 M001:'home',M003:'home',M002:'home',M017:'discover',M018:'discover',
 M008:'studio',M009:'studio',M010:'studio',M011:'studio',M013:'studio',M014:'studio',M015:'studio',M016:'studio',
 M023:'publish',M024:'publish',M025:'publish',M019:'inbox',M020:'inbox',M021:'inbox',M022:'inbox',
 M026:'commerce',M027:'commerce',M028:'commerce',M031:'commerce',M032:'commerce',M033:'commerce',M030:'commerce',
 M035:'analytics',M036:'analytics',M040:'analytics',M041:'analytics',M042:'analytics',M043:'analytics',M044:'analytics',
 M050:'automation',M051:'automation',M052:'automation',M053:'automation',M054:'automation',
 M057:'more',M058:'more',M059:'more',M061:'more',M005:'more',M060:'more'
};
const findScreen=id=>SCREENS.find(s=>s.id===id);
const niceScreen=s=>{
 if(!s)return'';
 const m=s.title.replace(/^Mobile\s*[—-]\s*/,'');
 return m.replace(/ Dashboard$/,'').replace(/ List$/,'').replace(/ Overview$/,'');
};
const currentNav=()=>['home','discover','studio','inbox'].includes(state.section)?state.section:'more';
function showToast(str) {
 const host=document.getElementById('mobile-toast');
 host.innerHTML='<div class="m-toast">'+escapeHTML(str)+'</div>';
 clearTimeout(window.__cGoToast);
 window.__cGoToast=setTimeout(()=>host.innerHTML='',3000);
}
function goto(section,opts={}){
 if(section.startsWith('M0')||section.startsWith('M')) {
   const id=section; const found=findScreen(id);
   if(!found){showToast('Màn hình chưa có trong catalog');return;}
   section=['M057','M058','M059','M061','M062'].includes(id)?'detail':CORE[id]||'detail';
   state.details=section==='detail'?found:null;
 }
 if(!['home','discover','studio','publish','inbox','commerce','analytics','automation','more','detail'].includes(section))section='home';
 state.section=section;state.overlay=null;state.thread=null;state.order=null;
 if(!opts.keepHash)history.pushState({section},'','#'+encodeURIComponent(section));
 render();document.getElementById('mobile-content').scrollTop=0;
}
function titleTop(){
 const detail=state.details;
 if(state.thread)return THREADS.find(x=>x.id===state.thread)?.name||'Tin nhắn';
 if(state.section==='detail')return niceScreen(detail);
 const map={home:'Creativanta',discover:'Khám phá',studio:'Studio sáng tạo',publish:'Xuất bản',inbox:'Hộp thư',commerce:'Kinh doanh',analytics:'Phân tích',automation:'Tự động hóa',more:'Khám phá thêm'};
 return map[state.section]||'Creativanta Go';
}
function renderHeader(){
 const back=!!state.thread || state.section==='detail';
 document.getElementById('mobile-topbar').innerHTML=
  (back?'<button class="m-header-back" data-action="back" aria-label="Quay lại">'+icon('left',20)+'</button><span class="m-header-title">'+escapeHTML(titleTop())+'</span>':
  '<div class="m-brand"><span class="m-brand-symbol">'+icon('layers',17)+'</span><span class="m-brand-copy"><strong>creativanta<span style="color:var(--brand)">.</span></strong><small>'+escapeHTML(state.section==='home'?'your creative companion':titleTop())+'</small></span></div>')+
 '<div class="m-header-actions"><button class="m-icon-button" data-action="search" aria-label="Tìm kiếm">'+icon('search',20)+'</button>'+
 '<button class="m-icon-button" data-action="notifications" aria-label="Thông báo">'+icon('bell',20)+(!state.notificationSeen?'<span class="m-notif-dot"></span>':'')+'</button></div>';
}
function renderNav(){
 document.getElementById('mobile-bottom-nav').innerHTML=NAV.map(([key,label,ic])=>
 '<button class="m-nav-btn '+(currentNav()===key?'active':'')+(key==='studio'?' m-nav-center':'')+'" data-go="'+key+'" aria-current="'+(currentNav()===key?'page':'false')+'" aria-label="'+label+'">'+
 (key==='studio'?'<span class="m-center-icon">'+icon('plus',21)+'</span>':icon(ic,20))+
 '<span>'+label+'</span></button>').join('');
}
function overline(text){return '<div class="m-overline">'+text+'</div>'}
function sectionHead(title,action='',target=''){return '<div class="m-section-heading"><h2>'+title+'</h2>'+
 (action?'<button class="m-text-link" data-go="'+target+'">'+action+' '+icon('right',14)+'</button>':'')+'</div>'}
function demoNote(){return '<div class="m-demo-note">Bản trình diễn tương tác · Số liệu và tác vụ đều là DEMO, không gửi hoặc ghi dữ liệu lên server.</div>'}
function homeView(){
 const tasks=[
  {id:'review',title:'Chọn xu hướng cho video mới',sub:'3 cơ hội đang chờ đánh giá',to:'discover'},
  {id:'script',title:'Tiếp tục kịch bản “Routine 60 giây”',sub:'Bản nháp chưa hoàn thiện',to:'studio'},
  {id:'queue',title:'Duyệt lịch đăng ngày mai',sub:'2 nội dung đang đợi',to:'publish'}
 ];
 return '<div class="m-view">'+
 overline('KHÔNG GIAN CỦA BẠN · HÔM NAY')+
 '<h1 class="m-title">Một ngày <span class="serif">đáng tạo.</span></h1>'+
 '<p class="m-subtitle">Tập trung vào việc quan trọng nhất. Mọi thứ khác đã được sắp xếp gọn lại.</p>'+
 '<section class="m-hero"><div><div class="m-hero-kicker">TÍN HIỆU ĐÁNG CHÚ Ý · DEMO</div>'+
 '<h2>Xu hướng tốt<br>đang chờ bạn.</h2>'+
 '<p>“Skinimalism” có thể trở thành ý tưởng video tiếp theo của bạn.</p></div>'+
 '<button class="m-hero-action" data-go="discover">Khám phá ngay '+icon('arrow',17)+'</button></section>'+
 '<div class="m-digest" aria-label="Tổng quan số liệu minh họa">'+
 '<div class="m-digest-item"><strong>03</strong><small>Việc hôm nay</small></div>'+
 '<div class="m-digest-item"><strong>12</strong><small>Lịch đăng</small></div>'+
 '<div class="m-digest-item"><strong>24</strong><small>Đơn DEMO</small></div></div>'+
 '<section class="m-section">'+sectionHead('Tiếp tục công việc','Xem tất cả','studio')+
 '<div class="m-card">'+tasks.map(t=>
 '<div class="m-task '+(state.tasks.has(t.id)?'done':'')+'">'+
 '<button class="m-task-check '+(state.tasks.has(t.id)?'done':'')+'" aria-label="Đánh dấu '+escapeHTML(t.title)+'" data-action="task" data-id="'+t.id+'">'+(state.tasks.has(t.id)?icon('check',15):'')+'</button>'+
 '<div class="m-task-main"><strong>'+escapeHTML(t.title)+'</strong><small>'+escapeHTML(t.sub)+'</small></div>'+
 '<button class="m-task-go" aria-label="Mở công việc" data-go="'+t.to+'">'+icon('right',17)+'</button></div>').join('')+'</div></section>'+
 '<section class="m-section">'+sectionHead('Gợi ý cho bạn','Xem xu hướng','discover')+
 '<div class="m-horizontal">'+
 '<article class="m-signal"><div class="m-signal-shape"></div><span class="m-signal-label">LÀM ĐẸP / DEMO</span><strong>Ít bước hơn.<br>Hiệu quả hơn.</strong><button data-action="save-trend" data-id="skin">Lưu ý tưởng '+icon('right',13)+'</button></article>'+
 '<article class="m-signal jade"><div class="m-signal-shape"></div><span class="m-signal-label">LIFESTYLE / DEMO</span><strong>Góc làm việc<br>đáng yêu thích.</strong><button data-action="save-trend" data-id="desk">Lưu ý tưởng '+icon('right',13)+'</button></article>'+
 '</div></section>'+
 '<section class="m-revenue"><div><div class="m-revenue-label">Doanh thu mẫu tuần này</div><strong>8,42 <span style="font-size:15px">triệu</span></strong><small>Chỉ minh họa · Chưa đối soát</small></div>'+
 '<div class="m-spark-bars" aria-hidden="true">'+[34,44,38,70,58,76,93,88].map(n=>'<i style="--h:'+n+'%"></i>').join('')+'</div></section>'+
 '<div style="display:flex;justify-content:flex-end;margin-top:8px"><button class="m-text-link" data-go="commerce">Mở kinh doanh '+icon('right',13)+'</button></div>'+
 '</div>';
}
function discoverView(){
 const filter=state.filter;
 const rows=TRENDS.filter(x=>filter==='all'||x.cat===filter);
 return '<div class="m-view">'+overline('DISCOVER / KHÁM PHÁ')+
 '<h1 class="m-title">Tìm được <span class="serif">điều mới.</span></h1>'+
 '<p class="m-subtitle">Khám phá tín hiệu có thể trở thành nội dung đáng làm. Không chạy theo mọi xu hướng.</p>'+
 '<div class="m-filters" role="group" aria-label="Lọc lĩnh vực">'+
 [['all','Tất cả'],['beauty','Làm đẹp'],['home','Đời sống'],['tech','Công nghệ']].map(([key,text])=>
 '<button class="m-filter '+(filter===key?'active':'')+'" data-action="trend-filter" data-id="'+key+'">'+text+'</button>').join('')+'</div>'+
 (filter==='all'||filter==='beauty'?'<section class="m-spotlight"><div class="m-overline">EDITOR\'S PICK · DEMO</div><h3>Làn sóng<br>“vừa đủ”</h3>'+
 '<p>Lối sống tối giản quay lại theo cách thực tế hơn.</p><button class="m-spotlight-action" data-action="trend-details" data-id="skin">Xem cơ hội '+icon('arrow',15)+'</button></section>':
 '<section class="m-spotlight '+(filter==='home'?'olive':'lilac')+'"><div class="m-overline">LĨNH VỰC ĐANG KHÁM PHÁ · DEMO</div>'+
 '<h3>'+(filter==='home'?'Một góc nhỏ.<br>Nhiều cảm hứng.':'AI cho<br>creator mới.')+'</h3>'+
 '<p>Tập trung vào tín hiệu có thể biến thành hành động.</p><button class="m-spotlight-action" data-action="trend-details" data-id="'+(filter==='home'?'desk':'ai')+'">Xem chi tiết '+icon('arrow',15)+'</button></section>')+
 '<section class="m-section">'+sectionHead('Cơ hội đang chú ý')+
 '<div class="m-trend-list">'+rows.map(x=>'<article class="m-trend"><div class="m-trend-art '+x.style+'"><div class="art-ring"></div><span class="art-label">'+escapeHTML(x.code)+'</span></div>'+
 '<div class="m-trend-body"><strong>'+escapeHTML(x.title)+'</strong><p>'+escapeHTML(x.detail)+'</p>'+
 '<div class="m-trend-footer"><span class="m-tag '+(x.id==='ai'?'orange':'')+'">'+escapeHTML(x.tag)+' · '+escapeHTML(x.growth)+'</span><button data-action="trend-details" data-id="'+x.id+'">Chi tiết '+icon('right',12)+'</button></div></div></article>').join('')+'</div></section>'+
 '<section class="m-section">'+sectionHead('Đã lưu để phát triển','Mở Studio','studio')+
 '<div class="m-card">'+(state.ideas.length?
 state.ideas.slice(0,3).map(x=>'<div class="m-idea-row"><div class="m-idea-icon">'+icon('sparkles',18)+'</div><div class="m-idea-info"><strong>'+escapeHTML(x.title)+'</strong><small>Đã lưu trong phiên · DEMO</small></div>'+icon('check',16)+'</div>').join(''):
 '<div class="m-empty">Bạn chưa lưu xu hướng nào.<br>Chọn một tín hiệu để phát triển thành ý tưởng.</div>')+'</div></section>'+demoNote()+'</div>';
}
function studioView(){
 const tab=state.studioTab;
 const list=tab==='ideas'?
 [...state.ideas.map(x=>({title:x.title,sub:'Vừa thêm · Ý tưởng mới',icon:'sparkles',tone:'green'})),
 {title:'Routine tối giản trong 60 giây',sub:'Video ngắn · Bản nháp',icon:'file',tone:''},
 {title:'5 cách nâng cấp góc làm việc',sub:'Carousel · Chưa sản xuất',icon:'layers',tone:'gold'}]:
 tab==='scripts'?
 [{title:'Giải pháp dành cho da dầu',sub:'Script 2/4 cảnh · DEMO',icon:'file',tone:''},
 {title:'Review đồ dùng bàn làm việc',sub:'Chờ biên tập · DEMO',icon:'play',tone:'green'}]:
 [{title:'Storyboard — Bộ sản phẩm A',sub:'Đang chuẩn bị shot list',icon:'play',tone:'green'},
 {title:'Dựng lại clip ngắn',sub:'Bản cắt cần xem lại · DEMO',icon:'layers',tone:'gold'}];
 return '<div class="m-view">'+overline('STUDIO / SÁNG TẠO')+
 '<h1 class="m-title">Từ ý tưởng<br>đến <span class="serif">tác phẩm.</span></h1>'+
 '<p class="m-subtitle">Tập trung vào bước đang làm. Không cần chuyển qua hàng chục công cụ.</p>'+
 '<div class="m-workflow" aria-label="Tiến trình sản xuất">'+
 '<div class="m-workflow-step current"><span>01 / BẮT ĐẦU</span><strong>Ý tưởng</strong></div>'+
 '<div class="m-workflow-step"><span>02 / PHÁT TRIỂN</span><strong>Kịch bản</strong></div>'+
 '<div class="m-workflow-step"><span>03 / HOÀN THIỆN</span><strong>Sản xuất</strong></div></div>'+
 '<div class="m-tabs" role="tablist">'+[['ideas','Ý tưởng'],['scripts','Kịch bản'],['production','Sản xuất']].map(([id,label])=>
 '<button class="m-tab '+(tab===id?'active':'')+'" data-action="studio-tab" data-id="'+id+'" role="tab" aria-selected="'+(tab===id)+'">'+label+'</button>').join('')+'</div>'+
 '<div class="m-section-heading"><h2>'+(tab==='ideas'?'Kho ý tưởng':tab==='scripts'?'Kịch bản đang viết':'Hàng đợi sản xuất')+'</h2>'+
 '<button class="m-text-link" data-action="create">Tạo mới '+icon('plus',15)+'</button></div>'+
 '<div class="m-card">'+list.map(x=>'<div class="m-idea-row"><div class="m-idea-icon '+x.tone+'">'+icon(x.icon,20)+'</div>'+
 '<div class="m-idea-info"><strong>'+escapeHTML(x.title)+'</strong><small>'+escapeHTML(x.sub)+'</small></div>'+
 '<button class="m-idea-action" data-action="demo-detail" aria-label="Xem bản nháp">'+icon('right',17)+'</button></div>').join('')+'</div>'+
 '<section class="m-section">'+sectionHead('Bước tiếp theo')+
 '<div class="m-card" style="padding:17px"><div style="display:flex;gap:13px;align-items:center"><span class="m-idea-icon green">'+icon('calendar',19)+'</span>'+
 '<div style="flex:1"><strong style="font-size:12px;display:block">Đưa nội dung vào lịch đăng</strong><small class="m-muted">Bạn duyệt trước khi xuất bản</small></div></div>'+
 '<button class="m-button full" style="margin-top:16px" data-go="publish">Xem lịch xuất bản '+icon('arrow',16)+'</button></div></section>'+demoNote()+'</div>';
}
function publishView(){
 const day=state.day;
 const weekdays=[['T2',26],['T3',27],['T4',28],['T5',29],['T6',30],['T7',31],['CN',1]];
 const queue=[
 {title:'Video: Routine 60 giây',at:'Ngày 31 · 18:30',tag:'Đang chờ duyệt',icon:'play'},
 {title:'Carousel: Góc làm việc',at:'Ngày 01 · 11:00',tag:'Đã lên lịch demo',icon:'layers'},
 {title:'Mẹo chăm da tối giản',at:'Ngày 02 · 19:30',tag:'Bản nháp',icon:'file'}
 ];
 return '<div class="m-view">'+overline('PUBLISH / XUẤT BẢN')+
 '<h1 class="m-title">Đúng lúc.<br><span class="serif">Đúng nội dung.</span></h1>'+
 '<p class="m-subtitle">Lên kế hoạch nhẹ nhàng. Mỗi bài đăng đều được kiểm tra trước.</p>'+
 sectionHead('Tuần này','Hàng đợi','publish')+
 '<div class="m-calendar-strip">'+weekdays.map(([l,n],i)=>
 '<button class="m-calendar-day '+(day===i?'active':'')+'" data-action="day" data-id="'+i+'"><span>'+l+'</span><strong>'+n+'</strong>'+
 (i===3||i===5?'<span class="m-calendar-dot"></span>':'')+'</button>').join('')+'</div>'+
 '<div class="m-section">'+sectionHead('Sắp đến lượt','Studio','studio')+
 '<div class="m-queue">'+queue.map((x,i)=>
 '<article class="m-queue-item"><div class="m-queue-thumbnail '+(i===1?'warm':'')+'">'+icon(x.icon,23)+'</div>'+
 '<div class="m-queue-info"><strong>'+x.title+'</strong><small>'+x.at+' · DEMO</small>'+
 '<button data-action="review" data-id="'+i+'">'+(state.reviews.has('p'+i)?'Đã xem':'Kiểm tra nội dung')+' '+icon('right',13)+'</button></div>'+
 '<span class="m-tag '+(i===0?'orange':'')+'">'+(state.reviews.has('p'+i)?'Đã xem':'Chờ')+'</span></article>').join('')+'</div></div>'+
 '<section class="m-section">'+sectionHead('An toàn trước khi đăng')+
 '<div class="m-card" style="padding:17px;display:flex;gap:13px"><div class="m-idea-icon green">'+icon('shield',20)+'</div>'+
 '<div><strong style="font-size:12px;display:block">Phê duyệt vẫn là bước bắt buộc</strong><p class="m-muted" style="margin:6px 0 0;line-height:1.65">Prototype này không xuất bản nội dung ra bất kỳ nền tảng nào.</p></div></div></section>'+
 demoNote()+'</div>';
}
function inboxView(){
 const th=THREADS.find(t=>t.id===state.thread);
 if(th){
 const local=state.messages.filter(x=>x.thread===th.id);
 return '<div class="m-view" style="padding-top:17px">'+
 '<div style="display:flex;gap:10px;align-items:center;margin-bottom:18px"><span class="m-person-avatar '+th.tone+'">'+th.initial+'</span>'+
 '<div><strong style="font-size:13px">'+escapeHTML(th.name)+'</strong><div class="m-muted">Cuộc hội thoại DEMO</div></div></div>'+
 '<div class="m-chat">'+th.texts.map(x=>'<div class="m-bubble">'+escapeHTML(x)+'</div>').join('')+
 '<div class="m-bubble out">Chào bạn, bên mình sẽ kiểm tra và phản hồi ngay nhé!</div>'+
 local.map(x=>'<div class="m-bubble out">'+escapeHTML(x.text)+'</div>').join('')+'</div>'+
 '<div class="m-compose"><input id="chat-draft" placeholder="Soạn câu trả lời demo..." aria-label="Soạn tin nhắn demo"/>'+
 '<button data-action="send" aria-label="Gửi tin nhắn demo">'+icon('send',18)+'</button></div>'+demoNote()+'</div>';
 }
 return '<div class="m-view">'+overline('INBOX / KHÁCH HÀNG')+
 '<h1 class="m-title">Những cuộc<br><span class="serif">trò chuyện.</span></h1>'+
 '<p class="m-subtitle">Khách hàng ở một nơi, câu trả lời sẵn sàng hơn.</p>'+
 '<div class="m-search-field">'+icon('search',18)+'<input id="contact-filter" placeholder="Tìm theo tên khách hàng..." aria-label="Tìm khách hàng" autocomplete="off"></div>'+
 '<div class="m-section-heading"><h2>Hộp thư</h2><span class="m-tag orange">3 hội thoại mẫu</span></div>'+
 '<div class="m-people-list">'+THREADS.map(t=>
 '<button class="m-person" data-action="thread" data-id="'+t.id+'"><span class="m-person-avatar '+t.tone+'">'+t.initial+'</span>'+
 '<span class="m-person-copy"><span class="m-person-name">'+escapeHTML(t.name)+'</span><span class="m-person-last">'+escapeHTML(t.last)+'</span></span>'+
 '<span class="m-person-time">'+t.time+(t.unread?'<span class="m-unread">'+t.unread+'</span>':'')+'</span></button>').join('')+'</div>'+
 '<section class="m-section">'+sectionHead('Chăm sóc khách hàng')+
 '<div class="m-card" style="padding:18px"><div style="display:flex;gap:12px"><div class="m-idea-icon green">'+icon('users',19)+'</div>'+
 '<div><strong style="font-size:12px;display:block">Không bỏ lỡ câu hỏi</strong><p class="m-muted" style="margin:5px 0 0;line-height:1.6">Theo dõi hội thoại đang chờ trả lời và trạng thái chăm sóc.</p></div></div></div></section>'+
 demoNote()+'</div>';
}
function commerceView(){
 return '<div class="m-view">'+overline('COMMERCE / KINH DOANH')+
 '<h1 class="m-title">Mọi đơn hàng.<br><span class="serif">Một bức tranh.</span></h1>'+
 '<p class="m-subtitle">Thấy rõ hoạt động bán hàng và những việc cần xử lý.</p>'+
 '<section class="m-money-card"><small>DOANH THU THAM KHẢO · DEMO</small>'+
 '<strong>8.420.000<span class="m-money-unit"> đ</span></strong>'+
 '<div class="m-money-foot"><span class="m-money-delta">↗ +12,4%</span><span>Con số minh họa, chưa đối soát</span></div>'+
 '<div class="m-spark-bars" style="width:150px;margin-top:24px;height:50px;position:relative;z-index:2">'+
 [35,47,41,66,54,84,72,94,80,100].map(n=>'<i style="--h:'+n+'%"></i>').join('')+'</div></section>'+
 '<div class="m-digest" style="padding-top:22px"><div class="m-digest-item"><strong>24</strong><small>Đơn mới</small></div>'+
 '<div class="m-digest-item"><strong>06</strong><small>Đang giao</small></div>'+
 '<div class="m-digest-item"><strong>02</strong><small>Cần xử lý</small></div></div>'+
 '<section class="m-section">'+sectionHead('Đơn hàng gần đây','Phân tích','analytics')+
 '<div class="m-orders">'+ORDERS.map((o,i)=>
 '<button class="m-order" data-action="order" data-id="'+i+'" style="background:transparent;border-left:0;border-right:0;border-top:0;text-align:left;width:100%">'+
 '<span class="m-order-main"><span class="m-order-symbol">'+icon('bag',18)+'</span><span><strong>'+o.id+' · '+escapeHTML(o.product)+'</strong>'+
 '<small>'+escapeHTML(o.name)+' · '+escapeHTML(o.status)+'</small></span></span>'+
 '<span class="m-order-right"><strong>'+o.cost+'</strong><small>Xem chi tiết '+icon('right',11)+'</small></span></button>').join('')+'</div></section>'+
 '<div style="margin-top:20px"><button class="m-button secondary full" data-go="analytics">Xem hiệu quả kinh doanh '+icon('arrow',15)+'</button></div>'+demoNote()+'</div>';
}
function analyticsView(){
 const values=[57,51,67,72,63,78,84,80,95,90];
 const pts=values.map((v,i)=>(15+i*31)+','+(138-v)).join(' ');
 return '<div class="m-view">'+overline('INSIGHTS / PHÂN TÍCH')+
 '<h1 class="m-title">Nhìn rõ <span class="serif">kết quả.</span></h1>'+
 '<p class="m-subtitle">Số liệu có ích khi giúp bạn đưa ra quyết định tốt hơn.</p>'+
 '<div class="m-card" style="padding:19px"><div class="m-section-heading" style="margin-bottom:6px"><h2>Tín hiệu hiệu quả</h2><span class="m-tag">DEMO</span></div>'+
 '<div style="font-size:27px;font-weight:790;letter-spacing:-.06em;color:#274d36">+18,6%</div>'+
 '<p class="m-muted" style="margin:0">Ví dụ tăng trưởng theo chu kỳ</p>'+
 '<div class="m-linechart"><svg viewBox="0 0 320 155" role="img" aria-label="Biểu đồ xu hướng mô phỏng" fill="none">'+
 '<path d="M10 125H315M10 85H315M10 45H315" stroke="#e9ede3" stroke-dasharray="4 5"/>'+
 '<polyline points="'+pts+'" fill="none" stroke="#448a61" stroke-width="3.7" stroke-linejoin="round" stroke-linecap="round"/>'+
 values.map((v,i)=>'<circle cx="'+(15+i*31)+'" cy="'+(138-v)+'" r="3.4" stroke="#448a61" stroke-width="2" fill="#fffefa"/>').join('')+
 '</svg></div><div style="display:flex;justify-content:space-between;font-size:10px;color:#9ba298"><span>Đầu kỳ</span><span>Giữa kỳ</span><span>Hiện tại</span></div></div>'+
 '<section class="m-section">'+sectionHead('Điều quan trọng hơn lượt xem')+
 '<div class="m-card">'+
 '<div class="m-idea-row"><span class="m-idea-icon green">'+icon('target',19)+'</span><div class="m-idea-info"><strong>Chất lượng chuyển đổi</strong><small>Đánh giá theo hành vi thực, cần dữ liệu kết nối</small></div></div>'+
 '<div class="m-idea-row"><span class="m-idea-icon gold">'+icon('receipt',19)+'</span><div class="m-idea-info"><strong>Biên lợi nhuận</strong><small>Cần chứng từ, chi phí và số liệu đối soát</small></div></div>'+
 '</div></section>'+demoNote()+'</div>';
}
function automationView(){
 return '<div class="m-view">'+overline('AUTOMATION / TỰ ĐỘNG HÓA')+
 '<h1 class="m-title">Ít lặp lại.<br><span class="serif">Nhiều sáng tạo.</span></h1>'+
 '<p class="m-subtitle">Các luồng xử lý chỉ được xem thử trong prototype.</p>'+
 '<div class="m-card">'+[
 ['Từ tín hiệu đến ý tưởng','Ghi nhận xu hướng mới để xem xét','compass'],
 ['Tạo bản nháp nội dung','Chuẩn bị khung kịch bản cần duyệt','sparkles'],
 ['Theo dõi câu hỏi khách hàng','Tập hợp hội thoại chưa phản hồi','messages']
 ].map(([a,b,i])=>'<div class="m-idea-row"><span class="m-idea-icon green">'+icon(i,18)+'</span>'+
 '<span class="m-idea-info"><strong>'+a+'</strong><small>'+b+'</small></span><span class="m-tag gray">Tắt</span></div>').join('')+'</div>'+
 '<div style="margin-top:20px"><button class="m-button full" data-action="demo-detail">Xem ví dụ chạy luồng '+icon('arrow',16)+'</button></div>'+demoNote()+'</div>';
}
function moreView(){
 const links=[
 ['publish','Xuất bản','Lịch nội dung','calendar'],
 ['commerce','Kinh doanh','Đơn hàng & sản phẩm','bag'],
 ['analytics','Phân tích','Hiệu quả & lợi nhuận','chart'],
 ['automation','Tự động hóa','Quy trình & Agents','zap'],
 ['M058','Tài khoản kết nối','Kênh & tích hợp','layers'],
 ['M057','Cài đặt','Không gian làm việc','settings']
 ];
 return '<div class="m-view">'+overline('WORKSPACE / TIỆN ÍCH')+
 '<h1 class="m-title">Mọi thứ<br><span class="serif">trong tay.</span></h1>'+
 '<p class="m-subtitle">Những công cụ bạn cần, được nhóm theo việc cần làm.</p>'+
 '<div class="m-more-grid">'+links.map(([to,title,sub,i])=>
 '<button class="m-more-cell" data-go="'+to+'"><span class="m-more-icon">'+icon(i,18)+'</span><strong>'+title+'</strong><small>'+sub+'</small></button>').join('')+'</div>'+
 '<section class="m-section">'+sectionHead('Tìm tính năng bất kỳ')+
 '<button class="m-search-field" style="width:100%;text-align:left" data-action="search">'+icon('search',18)+
 '<span style="font-size:12px;color:#9ca398">Tìm toàn bộ 61 màn hình mobile</span>'+icon('right',14)+'</button></section>'+
 '<div class="m-card" style="padding:17px"><strong style="font-size:12px">Creativanta Go · Design V4</strong>'+
 '<p class="m-muted" style="margin:6px 0 0">Prototype riêng cho Mobile. Không kết nối API, gửi tin nhắn hoặc thanh toán.</p></div></div>';
}
function fallbackView(){
 const item=state.details;
 return '<div class="m-view">'+overline('CREATIVANTA GO / CHỨC NĂNG')+
 '<h1 class="m-title" style="font-size:26px">'+escapeHTML(niceScreen(item)||'Màn hình bổ sung')+'</h1>'+
 '<p class="m-subtitle">Tính năng nằm trong bản đặc tả; bố cục riêng sẽ được triển khai sau khi duyệt concept Mobile.</p>'+
 '<div class="m-card" style="padding:21px"><div class="m-idea-icon green">'+icon('file',22)+'</div>'+
 '<h2 style="font-size:16px;margin:16px 0 6px">Đã liên kết màn hình</h2><p class="m-muted">Mã tham chiếu: '+escapeHTML(item?.id||'—')+'</p>'+
 '<button class="m-button full" style="margin-top:15px" data-go="home">Trở về tổng quan '+icon('arrow',15)+'</button></div>'+demoNote()+'</div>';
}
function renderContent(){
 const area=document.getElementById('mobile-content');
 area.innerHTML=state.section==='home'?homeView():
  state.section==='discover'?discoverView():
  state.section==='studio'?studioView():
  state.section==='publish'?publishView():
  state.section==='inbox'?inboxView():
  state.section==='commerce'?commerceView():
  state.section==='analytics'?analyticsView():
  state.section==='automation'?automationView():
  state.section==='more'?moreView():fallbackView();
}
function render(){
 renderHeader();renderNav();renderContent();renderOverlay();
 document.querySelectorAll('.preview-links [data-target]').forEach(b=>b.classList.toggle('current',b.dataset.target===state.section));
}
function sheet(title,body,buttons=''){
 return '<div class="m-overlay" data-action="overlay-backdrop"><div class="m-sheet" role="dialog" aria-modal="true" aria-label="'+escapeHTML(title)+'" data-noclose>'+
 '<span class="m-sheet-handle"></span><div class="m-sheet-top"><h3>'+escapeHTML(title)+'</h3>'+
 '<button class="m-sheet-close" data-action="overlay-close" aria-label="Đóng">'+icon('close',19)+'</button></div>'+body+buttons+'</div></div>';
}
function renderOverlay(){
 const root=document.getElementById('mobile-overlays');
 if(!state.overlay){root.innerHTML='';return}
 const overlay=state.overlay;
 if(overlay.type==='search'){
  const q=(state.search||'').toLowerCase().trim();
  const filtered=SCREENS.filter(s=>!q||(s.title+' '+s.id+' '+s.route).toLowerCase().includes(q)).slice(0,15);
  root.innerHTML='<div class="m-overlay search"><div class="m-search-screen" role="dialog" aria-modal="true" aria-label="Tìm tính năng">'+
  '<div class="m-search-top">'+icon('search',20)+'<input id="mobile-search" type="search" placeholder="Bạn cần làm gì?" aria-label="Tìm màn hình" value="'+escapeHTML(state.search)+'" autocomplete="off">'+
  '<button class="m-search-cancel" data-action="overlay-close">Đóng</button></div>'+
  '<div class="m-search-results"><div class="m-overline" style="margin:6px 4px 12px">'+SCREENS.length+' MÀN HÌNH TRONG THƯ VIỆN</div>'+
  (filtered.length?filtered.map(s=>'<button class="m-search-result" data-go="'+s.id+'">'+icon('layers',18)+
   '<span><strong>'+escapeHTML(niceScreen(s))+'</strong><small>'+escapeHTML(s.id)+' · '+escapeHTML(s.route||'Hệ thống')+'</small></span>'+icon('right',15)+'</button>').join(''):
   '<div class="m-empty">Không tìm thấy màn hình phù hợp</div>')+'</div></div></div>';
  return;
 }
 if(overlay.type==='create'){
  root.innerHTML=sheet('Ý tưởng mới','<p class="m-muted">Lưu vào phiên demo của Studio. Không ghi lên hệ thống thật.</p>'+
  '<label for="idea-title" class="m-form-label">Tên ý tưởng</label><input id="idea-title" class="m-form-input" placeholder="Một ý tưởng đáng thử..." maxlength="90">'+
  '<label for="idea-note" class="m-form-label">Ghi chú (tùy chọn)</label><textarea id="idea-note" class="m-form-textarea" placeholder="Dành cho ai, góc kể chuyện gì?"></textarea>'+
  '<div class="m-sheet-actions"><button class="m-button secondary" data-action="overlay-close">Để sau</button><button class="m-button primary" data-action="save-idea">Lưu ý tưởng '+icon('arrow',15)+'</button></div>');return;
 }
 if(overlay.type==='trend'){
  const t=TRENDS.find(x=>x.id===overlay.id)||TRENDS[0];
  root.innerHTML=sheet(t.title,'<div class="m-spotlight '+(t.style==='desk'?'olive':t.style==='ai'?'lilac':'')+'" style="min-height:190px;margin-bottom:15px">'+
    '<div class="m-overline">'+escapeHTML(t.code)+' · DEMO</div><h3 style="font-size:21px">'+escapeHTML(t.title)+'</h3><p>'+escapeHTML(t.detail)+'</p></div>'+
    '<p class="m-muted" style="font-size:11.5px;line-height:1.7">'+escapeHTML(t.desc)+'</p>'+
    '<div class="m-sheet-actions"><button class="m-button secondary" data-action="overlay-close">Đóng</button>'+
    '<button class="m-button primary" data-action="save-trend" data-id="'+t.id+'">Lưu vào Studio '+icon('plus',15)+'</button></div>');return;
 }
 if(overlay.type==='order'){
  const o=ORDERS[Number(overlay.id)]||ORDERS[0];
  root.innerHTML=sheet('Đơn hàng '+o.id,
   '<div class="m-card" style="padding:16px"><div class="m-section-heading"><h2>'+escapeHTML(o.product)+'</h2><span class="m-tag orange">'+escapeHTML(o.status)+'</span></div>'+
   '<div class="m-muted">Khách hàng: '+escapeHTML(o.name)+'</div><div style="font-size:25px;font-weight:750;letter-spacing:-.04em;margin:14px 0">'+o.cost+'</div>'+
   '<div class="m-demo-note">Đơn hàng minh họa. Không có dữ liệu khách hàng thật hay thao tác thanh toán.</div></div>'+
   '<div class="m-sheet-actions"><button class="m-button full" data-action="overlay-close">Đã xem '+icon('check',15)+'</button></div>');return;
 }
 if(overlay.type==='quick'){
  root.innerHTML=sheet('Tạo nhanh',[
    ['create','Ý tưởng mới','Ghi lại điều bạn vừa nghĩ ra','sparkles'],
    ['discover','Tìm xu hướng','Khám phá chủ đề có tiềm năng','compass'],
    ['publish','Lịch xuất bản','Xem những nội dung đang chờ','calendar'],
    ['commerce','Kinh doanh','Kiểm tra đơn hàng và doanh thu','bag']
   ].map(([id,title,sub,i])=>'<button class="m-action-tile" data-'+(id==='create'?'action="create"':'go="'+id+'"')+'>'+
   '<span class="m-action-icon">'+icon(i,19)+'</span><span><strong>'+title+'</strong><small>'+sub+'</small></span>'+icon('right',16)+'</button>').join(''));return;
 }
 if(overlay.type==='notifications'){
  root.innerHTML=sheet('Thông báo','<p class="m-muted">Bạn có những công việc cần kiểm tra trong bản demo.</p>'+
   '<div class="m-card">'+
   '<div class="m-idea-row"><span class="m-idea-icon green">'+icon('target',19)+'</span><span class="m-idea-info"><strong>Xu hướng cần đánh giá</strong><small>3 tín hiệu được gợi ý</small></span></div>'+
   '<div class="m-idea-row"><span class="m-idea-icon gold">'+icon('calendar',19)+'</span><span class="m-idea-info"><strong>Lịch đăng ngày mai</strong><small>2 nội dung chưa xem</small></span></div></div>'+
   '<div class="m-sheet-actions"><button class="m-button full" data-go="home">Về tổng quan '+icon('arrow',16)+'</button></div>');return;
 }
 root.innerHTML=sheet('Trình diễn tính năng','<div class="m-card" style="padding:18px"><div class="m-idea-icon green">'+icon('shield',19)+'</div>'+
 '<h3 style="margin:14px 0 7px;font-size:14px">Thao tác mẫu, không có API</h3>'+
 '<p class="m-muted" style="line-height:1.7">Đây chỉ là giao diện tương tác để đánh giá UX. Chưa có xuất bản, thanh toán, AI generation hay gửi tin nhắn thật.</p></div>'+
 '<div class="m-sheet-actions"><button class="m-button full" data-action="overlay-close">Đã hiểu</button></div>');
}
function openOverlay(type,id=null){
 state.overlay={type,id};renderOverlay();
 if(type==='search')setTimeout(()=>document.getElementById('mobile-search')?.focus(),0);
 if(type==='create')setTimeout(()=>document.getElementById('idea-title')?.focus(),0);
}
function closeOverlay(){state.overlay=null;renderOverlay()}
function action(type,element){
 const id=element.dataset.id;
 switch(type){
 case 'search':state.search='';openOverlay('search');return;
 case 'notifications':state.notificationSeen=true;renderHeader();openOverlay('notifications');return;
 case 'overlay-close':closeOverlay();return;
 case 'overlay-backdrop':if(!element.closest('[data-noclose]'))closeOverlay();return;
 case 'quick':openOverlay('quick');return;
 case 'create':openOverlay('create');return;
 case 'save-idea':{
  const text=document.getElementById('idea-title')?.value.trim();
  const note=document.getElementById('idea-note')?.value.trim();
  if(!text){showToast('Hãy nhập tên ý tưởng');document.getElementById('idea-title')?.focus();return;}
  state.ideas.unshift({title:text,note:note||'',id:Date.now()});
  state.studioTab='ideas';closeOverlay();goto('studio');showToast('Đã lưu ý tưởng trong bản demo');return;
 }
 case 'save-trend':{
  const t=TRENDS.find(x=>x.id===id);if(!t)return;
  if(!state.ideas.some(x=>x.from===id))state.ideas.unshift({title:t.title,note:t.desc,from:id,id:Date.now()});
  closeOverlay();showToast('Đã lưu xu hướng vào Studio (DEMO)');return;
 }
 case 'trend-filter':state.filter=id;renderContent();document.getElementById('mobile-content').scrollTop=0;return;
 case 'trend-details':openOverlay('trend',id);return;
 case 'task':{
  if(state.tasks.has(id))state.tasks.delete(id);else state.tasks.add(id);
  const scroll=document.getElementById('mobile-content');const pos=scroll.scrollTop;renderContent();scroll.scrollTop=pos;return;
 }
 case 'studio-tab':state.studioTab=id;renderContent();return;
 case 'review':state.reviews.add('p'+id);renderContent();showToast('Đã đánh dấu đã xem (DEMO)');return;
 case 'day':state.day=Number(id);renderContent();return;
 case 'thread':state.thread=id;renderHeader();renderContent();document.getElementById('mobile-content').scrollTop=0;return;
 case 'send':{
  const draft=document.getElementById('chat-draft');
  if(!draft?.value.trim()){draft?.focus();return}
  state.messages.push({thread:state.thread,text:draft.value.trim()});
  renderContent();document.getElementById('mobile-content').scrollTop=document.getElementById('mobile-content').scrollHeight;
  showToast('Đã thêm tin nhắn DEMO — chưa gửi thật');return;
 }
 case 'order':openOverlay('order',id);return;
 case 'demo-detail':openOverlay('demo');return;
 case 'back':if(state.overlay){closeOverlay();return;}if(state.thread){state.thread=null;renderHeader();renderContent();return;}goto('home');return;
 default:openOverlay('demo');return;
 }
}
document.addEventListener('click',event=>{
 const el=event.target.closest('[data-go],[data-action],[data-target]');
 if(!el)return;
 if(el.dataset.target){goto(el.dataset.target);return}
 if(el.dataset.go){goto(el.dataset.go);return}
 if(el.dataset.action==='overlay-backdrop'&&event.target.closest('[data-noclose]'))return;
 if(el.dataset.action)action(el.dataset.action,el);
});
document.addEventListener('keydown',event=>{
 if(event.key==='Escape'){if(state.overlay)closeOverlay();else if(state.thread){state.thread=null;renderHeader();renderContent()};return}
 if((event.ctrlKey||event.metaKey)&&event.key.toLowerCase()==='k'){event.preventDefault();state.search='';openOverlay('search');return}
 if(event.key==='Enter'&&event.target.id==='chat-draft'){event.preventDefault();action('send',event.target)}
});
document.addEventListener('input',event=>{
 if(event.target.id==='mobile-search'){
  const q=event.target.value;state.search=q;
  const selection=event.target.selectionStart;
  renderOverlay();
  const input=document.getElementById('mobile-search');
  input?.focus();try{input?.setSelectionRange(selection,selection)}catch(_){}
  return;
 }
 if(event.target.id==='contact-filter'){
  const q=event.target.value.trim().toLocaleLowerCase('vi');
  document.querySelectorAll('.m-person').forEach(el=>{el.style.display=el.textContent.toLocaleLowerCase('vi').includes(q)?'flex':'none'});
 }
});
window.addEventListener('popstate',()=>{
 const section=decodeURIComponent(location.hash.slice(1));
 if(section==='inbox'&&state.thread)state.thread=null;
 if(section&&section!=='#'&&section!==state.section)goto(section,{keepHash:true});
});
function init(){
 const deep=decodeURIComponent(location.hash.slice(1));
 if(deep?.startsWith('M')&&findScreen(deep)){goto(deep,{keepHash:true});return}
 if(deep)state.section=['home','discover','studio','publish','inbox','commerce','analytics','automation','more'].includes(deep)?deep:'home';
 render();
}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',init);
else init();
})();

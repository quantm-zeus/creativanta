/* Creativanta V4 — newly authored IA and interaction shell.
   No production mutation: everything is client-only / demo. */
(function(){
'use strict';
const SURFACE=document.body.dataset.surface||'web';
const ALL=(window.CREATIVANTA_CATALOG?.screens||[]).filter(s=>s.platform===SURFACE);
const BY_ID=new Map(ALL.map(x=>[x.id,x]));
const WEB=[
 {id:'home',label:'Tổng quan',icon:'home',ids:['W001','W009','W003']},
 {id:'discover',label:'Khám phá',icon:'compass',ids:['W038','W043','W040']},
 {id:'create',label:'Sáng tạo',icon:'sparkles',ids:['W012','W015','W021']},
 {id:'publish',label:'Xuất bản',icon:'calendar',ids:['W055','W053','W052']},
 {id:'inbox',label:'Khách hàng',icon:'messages',ids:['W046','W048','W051']},
 {id:'commerce',label:'Kinh doanh',icon:'bag',ids:['W062','W060','W066','W109']},
 {id:'insights',label:'Phân tích',icon:'chart',ids:['W075','W080','W084']},
 {id:'automate',label:'Tự động hóa',icon:'workflow',ids:['W100','W103','W106']},
 {id:'settings',label:'Cài đặt',icon:'settings',ids:['W114','W117','W119']}
];
const MOBILE=[
 {id:'home',label:'Tổng quan',icon:'home',ids:['M001','M003','M002']},
 {id:'discover',label:'Khám phá',icon:'compass',ids:['M017','M018','M035']},
 {id:'create',label:'Sáng tạo',icon:'sparkles',ids:['M008','M010','M013']},
 {id:'publish',label:'Xuất bản',icon:'calendar',ids:['M024','M025','M023']},
 {id:'inbox',label:'Khách hàng',icon:'messages',ids:['M019','M021','M020']},
 {id:'commerce',label:'Kinh doanh',icon:'bag',ids:['M027','M028','M026']},
 {id:'insights',label:'Phân tích',icon:'chart',ids:['M040','M035','M044']},
 {id:'automate',label:'Tự động hóa',icon:'workflow',ids:['M050','M052','M053']},
 {id:'settings',label:'Cài đặt',icon:'settings',ids:['M057','M058','M061']}
];
const ADMIN=[
 {id:'home',label:'Tổng quan',icon:'home',ids:['A001','A006','A031']},
 {id:'people',label:'Người dùng',icon:'users',ids:['A002','A004','A032']},
 {id:'moderate',label:'Kiểm duyệt',icon:'shield',ids:['A015','A017','A028']},
 {id:'platform',label:'Hệ thống',icon:'activity',ids:['A007','A008','A009','A011']},
 {id:'commerce',label:'Doanh thu',icon:'bag',ids:['A018','A021','A022']},
 {id:'insights',label:'Phân tích',icon:'chart',ids:['A024','A023','A025']},
 {id:'support',label:'Hỗ trợ',icon:'messages',ids:['A026','A034','A029']},
 {id:'settings',label:'Cài đặt',icon:'settings',ids:['A030','A010','A033']}
];
const NAV=SURFACE==='admin'?ADMIN:SURFACE==='mobile'?MOBILE:WEB;
const ROOT_ID=NAV[0].ids[0];
const LABELS={
 W001:'Tổng quan',W009:'Bản tin buổi sáng',W003:'Thông báo',
 W038:'Xu hướng',W043:'Cơ hội',W040:'Đối thủ',W039:'Chi tiết xu hướng',W042:'Theo dõi xu hướng',
 W012:'Kho ý tưởng',W015:'Kịch bản',W021:'Video Studio',W016:'Biên tập kịch bản',W014:'Tạo ý tưởng bằng AI',
 W055:'Lịch nội dung',W053:'Hàng đợi',W052:'Soạn bài',W056:'Kiểm tra trước đăng',W046:'Hộp thư',W048:'Danh bạ',W051:'Cần chăm sóc',
 W062:'Đơn hàng',W060:'Sản phẩm',W066:'Ưu đãi',W109:'Live Commerce',W063:'Chi tiết đơn hàng',
 W075:'Hiệu quả nội dung',W080:'Lợi nhuận',W084:'Đối soát',W085:'Bằng chứng doanh thu',
 W100:'Luồng tự động',W103:'Thư viện công thức',W106:'AI Agents',
 W114:'Không gian làm việc',W117:'Tài khoản đã kết nối',W119:'Gói và hóa đơn',
 M001:'Tổng quan',M003:'Bản tin buổi sáng',M002:'Thông báo',
 M017:'Xu hướng',M018:'Đối thủ',M035:'Phân tích',M008:'Ý tưởng',M010:'Kịch bản',
 M013:'Studio',M014:'Chỉnh sửa nhanh',M024:'Hàng đợi',M025:'Lịch đăng',M023:'Đăng nhanh',
 M019:'Hộp thư',M021:'Khách hàng',M020:'Hội thoại',M027:'Đơn hàng',M028:'Sản phẩm',
 M026:'Kinh doanh',M040:'Lợi nhuận',M044:'Đối soát',M050:'Luồng tự động',
 M052:'Công việc',M053:'AI Agents',M057:'Cài đặt',M058:'Kết nối',M061:'Gói dịch vụ',
 A001:'Tổng quan',A006:'Sức khỏe hệ thống',A031:'Sự cố',
 A002:'Người dùng',A004:'Không gian làm việc',A032:'Quản trị viên',
 A015:'Hàng đợi kiểm duyệt',A017:'Báo cáo vi phạm',A028:'Rủi ro',
 A007:'Tích hợp',A008:'Hàng đợi hệ thống',A009:'Cờ tính năng',A011:'Vận hành AI',
 A018:'Thương mại',A021:'Gói dịch vụ',A022:'Doanh thu',
 A024:'Hiệu quả kinh doanh',A023:'Sử dụng hệ thống',A025:'Lỗi và sự cố',
 A026:'Yêu cầu hỗ trợ',A034:'Tri thức',A029:'Tuân thủ',
 A030:'Cấu hình',A010:'Nhật ký hoạt động',A033:'Chẩn đoán tích hợp'
};
const ICONS={
 home:'<path d="m3 10 9-7 9 7v10H3z"/><path d="M9 20v-7h6v7"/>',
 compass:'<circle cx="12" cy="12" r="9"/><path d="m16 8-2.5 5.5L8 16l2.5-5.5z"/>',
 sparkles:'<path d="m12 2 2.3 7.7L22 12l-7.7 2.3L12 22l-2.3-7.7L2 12l7.7-2.3z"/><path d="M20 3v3M18.5 4.5h3"/>',
 calendar:'<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M7 3v4m10-4v4M3 10h18"/>',
 messages:'<path d="M4 5h16v12H9l-5 4z"/><path d="M8 10h8M8 13h5"/>',
 bag:'<rect x="4" y="7" width="16" height="14" rx="2"/><path d="M8 8V6a4 4 0 0 1 8 0v2"/>',
 chart:'<path d="M3 19V5M3 19h18"/><path d="m6 15 5-5 4 2 5-7"/>',
 workflow:'<rect x="2" y="3" width="7" height="6" rx="1"/><rect x="15" y="3" width="7" height="6" rx="1"/><rect x="8.5" y="15" width="7" height="6" rx="1"/><path d="M5.5 9v3h6.5v3m6.5-6v3H12"/>',
 settings:'<circle cx="12" cy="12" r="3"/><path d="M10 2h4l.6 2.4 2.1.9 2.2-1.2 2.9 2.9-1.2 2.2.9 2.1L24 12l-2.5.7-.9 2.1 1.2 2.2-2.9 2.9-2.2-1.2-2.1.9L14 22h-4l-.6-2.4-2.1-.9-2.2 1.2-2.9-2.9 1.2-2.2-.9-2.1L0 12l2.5-.7.9-2.1-1.2-2.2 2.9-2.9 2.2 1.2 2.1-.9z" transform="translate(2 2) scale(.83)"/>',
 search:'<circle cx="10.5" cy="10.5" r="6.5"/><path d="m16 16 5 5"/>',
 bell:'<path d="M18 8a6 6 0 0 0-12 0c0 8-3 8-3 10h18c0-2-3-2-3-10zM10 21h4"/>',
 plus:'<path d="M12 4v16M4 12h16"/>',
 down:'<path d="m6 9 6 6 6-6"/>',
 right:'<path d="m9 5 7 7-7 7"/>',
 arrow:'<path d="M4 12h16m-7-7 7 7-7 7"/>',
 external:'<path d="M7 17 17 7M9 7h8v8"/>',
 check:'<path d="m4 12 5 5L20 6"/>',
 menu:'<path d="M4 7h16M4 12h16M4 17h16"/>',
 close:'<path d="M5 5 19 19M19 5 5 19"/>',
 clock:'<circle cx="12" cy="12" r="9"/><path d="M12 7v5l4 2"/>',
 dots:'<circle cx="5" cy="12" r="1"/><circle cx="12" cy="12" r="1"/><circle cx="19" cy="12" r="1"/>',
 play:'<path d="m8 5 11 7-11 7z"/>',
 file:'<path d="M6 2h9l4 4v16H6zM14 2v5h5M9 12h7M9 16h7"/>',
 shield:'<path d="m12 2 9 4v6c0 6-3.5 8-9 10-5.5-2-9-4-9-10V6z"/><path d="m8 12 3 3 5-6"/>',
 users:'<circle cx="9" cy="8" r="3"/><path d="M3 21v-3a6 6 0 0 1 12 0v3M16 5a3 3 0 0 1 0 6M17 14a5 5 0 0 1 4 5v2"/>',
 activity:'<path d="M2 12h4l3-7 5 14 3-7h5"/>',
 bot:'<rect x="4" y="6" width="16" height="14" rx="3"/><path d="M12 2v4M8 12h.01M16 12h.01M9 16h6"/>',
 alert:'<path d="M12 3 2 21h20zM12 9v5m0 3h.01"/>',
 filter:'<path d="M4 6h16l-6 7v6l-4 2v-8z"/>',
 upload:'<path d="M12 16V3m-5 5 5-5 5 5M4 16v4h16v-4"/>',
 download:'<path d="M12 3v13m-5-5 5 5 5-5M4 18v3h16v-3"/>',
 layers:'<path d="m12 3 9 5-9 5-9-5zM3 12l9 5 9-5M3 16l9 5 9-5"/>',
 target:'<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="5"/><circle cx="12" cy="12" r="1"/>',
 box:'<path d="m12 2 9 5v10l-9 5-9-5V7zM3 7l9 5 9-5M12 12v10"/>',
 zap:'<path d="M13 2 4 13h7l-1 9 10-12h-7z"/>',
 flag:'<path d="M5 3v19M5 4c5-3 9 3 15 0v11c-6 3-10-3-15 0"/>',
 receipt:'<path d="M5 3h14v18l-3-2-4 2-4-2-3 2zM9 8h6M9 12h6"/>',
 book:'<path d="M4 4h16v17H7a3 3 0 0 1-3-3zM4 18a3 3 0 0 1 3-3h13"/>'
};
const ic=(name,size=19)=>'<svg width="'+size+'" height="'+size+'" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">'+(ICONS[name]||ICONS.layers)+'</svg>';
const esc=x=>String(x??'').replace(/[&<>"']/g,k=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[k]));
function label(id){const s=BY_ID.get(id);return LABELS[id]|| (s?s.title.replace(/^(Web|Mobile|Admin) — /,'').replace(/^Web — /,''):'Màn hình')}
function activeGroup(id){
  for(const g of NAV){if(g.ids.includes(id))return g}
  const s=BY_ID.get(id);
  if(!s)return NAV[0];
  const m=s.module||'',r=s.route||'';
  if(SURFACE==='admin'){
    if(/user|workspace|team/.test(r))return NAV.find(x=>x.id==='people');
    if(/moderation|fraud|abuse|compliance/.test(r))return NAV.find(x=>x.id==='moderate');
    if(/analytics/.test(r))return NAV.find(x=>x.id==='insights');
    if(/commerce|subscription|revenue/.test(r))return NAV.find(x=>x.id==='commerce');
    if(/support|notification|knowledge/.test(r))return NAV.find(x=>x.id==='support');
    if(/config|audit-log|debug/.test(r))return NAV.find(x=>x.id==='settings');
    return NAV.find(x=>x.id==='platform');
  }
  if(/\/analytics|\/finance|\/profit/.test(r)||m==='M19')return NAV.find(x=>x.id==='insights');
  if(['M02','M03','M04'].includes(m)||/\/intelligence|\/trends/.test(r))return NAV.find(x=>x.id==='discover');
  if(['M05','M06','M07','M08','M09','M10'].includes(m)||/\/studio|\/ideas|\/scripts|\/continuity/.test(r))return NAV.find(x=>x.id==='create');
  if(m==='M11'||/\/publish|\/calendar/.test(r))return NAV.find(x=>x.id==='publish');
  if(m==='M12'||/\/inbox|\/contact/.test(r))return NAV.find(x=>x.id==='inbox');
  if(['M13','M14','M15','M16','M17','M18','S16'].includes(m)||/\/commerce|\/orders|\/products|\/offers|\/live|\/store|\/creator-pro/.test(r))return NAV.find(x=>x.id==='commerce');
  if(['M20','M21'].includes(m)||/\/workflow|\/agent|\/tasks/.test(r))return NAV.find(x=>x.id==='automate');
  if(/\/settings|\/billing|\/credits/.test(r)||['M22','M23','auth'].includes(m))return NAV.find(x=>x.id==='settings');
  return NAV[0];
}
const URL_DEFAULT=decodeURIComponent(location.hash.slice(1));
const state={
 id:BY_ID.has(URL_DEFAULT)?URL_DEFAULT:ROOT_ID,
 taskDone:new Set(),filters:{},ideas:[],
 inbox:0,mobileMenu:false,detail:null,toast:null,
};
function group(){return activeGroup(state.id)}
function btn(text,go,variant=''){return '<button class="btn '+variant+'" data-go="'+esc(go)+'">'+text+'</button>'}
function act(text,name,variant=''){return '<button class="btn '+variant+'" data-act="'+name+'">'+text+'</button>'}
function pill(text,kind='gray'){return '<span class="pill '+kind+'">'+text+'</span>'}
function listrow(iconName,headline,sub,id,kind=''){
 return '<div class="list-row" role="button" tabindex="0" data-go="'+esc(id)+'"><div class="tile-icon '+kind+'">'+ic(iconName,18)+'</div><div class="list-core"><strong>'+esc(headline)+'</strong><small>'+esc(sub)+'</small></div><div class="list-right">'+ic('right',16)+'</div></div>'
}
function chartBars(seed=0){const a=[26,47,38,62,47,71,60,81,68,92,72,98,84,91];return '<div class="mini-chart" aria-label="Biểu đồ minh họa">'+a.map((x,i)=>'<i style="--h:'+Math.min(100,Math.max(10,x+(seed*(i%3-1))))+'%"></i>').join('')+'</div>'}
function sectionTitle(title,help='',go=null){return '<div class="section-title"><div><h2>'+title+'</h2>'+(help?'<p>'+help+'</p>':'')+'</div>'+(go?'<button class="link" data-go="'+go+'">Xem tất cả '+ic('arrow',14)+'</button>':'')+'</div>'}
function panel(title,body,subtitle='',foot=''){return '<section class="panel"><div class="panel-head"><div><h3>'+title+'</h3>'+(subtitle?'<p>'+subtitle+'</p>':'')+'</div></div><div class="panel-body">'+body+'</div>'+(foot?'<div class="panel-foot">'+foot+'</div>':'')+'</section>'}
function titleFor(){return state.id===group().ids[0]?group().label:label(state.id)}
function dateVN(){return new Intl.DateTimeFormat('vi-VN',{weekday:'long',day:'numeric',month:'long',timeZone:'Asia/Ho_Chi_Minh'}).format(new Date())}
function renderShell(){
 const g=group();
 const isAdmin=SURFACE==='admin';
 const mainNav=NAV.filter(x=>x.id!=='settings');
 const mobileTabs= isAdmin?['home','people','moderate','platform','insights']:['home','discover','create','inbox','commerce'];
 const sidebar=mainNav.map(item=>
 '<button class="nav-item '+(item.id===g.id?'active':'')+'" data-group="'+item.id+'" aria-current="'+(item.id===g.id?'page':'false')+'" title="'+esc(item.label)+'">'+
 '<span class="ni">'+ic(item.icon,19)+'</span><span class="nav-text">'+item.label+'</span>'+
 (item.id==='inbox'&&!isAdmin?'<span class="nav-count">3</span>':'')+'</button>').join('');
 const tabs=g.ids.filter(x=>BY_ID.has(x)).map(id=>'<button class="tab '+(id===state.id?'active':'')+'" data-go="'+id+'">'+esc(label(id))+'</button>').join('');
 document.getElementById('app').innerHTML='<div class="shell">'+
 '<aside class="side" aria-label="Điều hướng chính"><div class="side-head"><div class="brand"><span class="brandmark"><span></span></span><span class="brandname">creativanta<span style="color:#a69cfa">.</span></span></div>'+
 '<button class="workspace" data-act="workspace"><span class="avatar-mini">'+(isAdmin?'A':'S')+'</span><span><strong>'+(isAdmin?'Operations workspace':'Creative Studio')+'</strong><small>'+(isAdmin?'Quản trị nội bộ':'Creator workspace')+'</small></span><span class="chev">'+ic('down',14)+'</span></button></div>'+
 '<div class="side-content"><div class="nav-label">Không gian làm việc</div>'+sidebar+
 '<div class="side-divider"></div><button class="nav-item '+(g.id==='settings'?'active':'')+'" data-group="settings" title="Cài đặt"><span class="ni">'+ic('settings',19)+'</span><span class="nav-text">Cài đặt</span></button></div>'+
 '<div class="side-bottom"><button class="shortcut" data-act="search">'+ic('search',15)+' <span>Tìm mọi tính năng</span><kbd>⌘ K</kbd></button>'+
 '<button class="side-help" data-act="help">'+ic('book',18)+'<span class="label">Trợ giúp & hướng dẫn</span></button>'+
 '<div class="side-foot"><div class="profile">'+(isAdmin?'A':'C')+'</div><div class="profile-txt"><strong>'+(isAdmin?'Admin Operations':'Creator Studio')+'</strong><small>Giao diện demo</small></div></div></div></aside>'+
 '<div class="scrim" data-act="close-menu"></div>'+
 '<div class="surface"><header class="top"><button class="iconbutton menu-trigger" aria-label="Mở menu" data-act="menu">'+ic('menu',20)+'</button>'+
 '<div class="crumbs"><span>'+(isAdmin?'Operations':'Studio')+'</span><span class="sep">/</span><strong>'+esc(g.label)+'</strong></div>'+
 '<div class="top-end"><span class="demo-label">Dữ liệu minh họa</span><button class="search-trigger" data-act="search">'+ic('search',17)+'<span>Tìm màn hình, sản phẩm, tác vụ...</span><kbd>⌘ K</kbd></button>'+
 '<button class="iconbutton" title="Tìm kiếm" data-act="search" aria-label="Tìm kiếm">'+ic('search',18)+'</button>'+
 '<button class="iconbutton" data-act="notifications" aria-label="Thông báo">'+ic('bell',19)+'<span class="dot"></span></button>'+
 '<button class="tiny-user" data-act="workspace" title="Không gian làm việc">'+(isAdmin?'AO':'CS')+'</button></div></header>'+
 '<main class="content" id="content" aria-label="Nội dung chính">'+
 '<div class="page-top"><div class="page-intro"><small>'+(state.id===g.ids[0]?'WORKSPACE / '+esc(g.label).toUpperCase():'KHÔNG GIAN / '+esc(g.label).toUpperCase())+'</small>'+
 '<h1>'+renderTitle()+'</h1><p>'+renderDescription()+'</p></div>'+
 '<div class="page-actions">'+(isAdmin?act(ic('search',16)+' Tìm người dùng','search'):g.id==='create'||g.id==='settings'?'':g.id==='home'||g.id==='discover'?act(ic('plus',16)+' Tạo ý tưởng','create','dark'):act(ic('plus',16)+' Thao tác demo','demo','dark'))+'</div></div>'+
 (tabs?'<div class="tabbar" role="tablist" aria-label="Điều hướng theo ngữ cảnh">'+tabs+'</div>':'')+
 renderView()+
 '<div class="catalog-card"><span><strong>'+g.label+'</strong> · Các màn hình ít dùng được đặt trong tìm kiếm, không chiếm diện tích menu.</span><button class="link" data-act="search">'+ic('search',15)+' Tìm toàn bộ '+ALL.length+' màn hình</button></div>'+
 '</main>'+
 '<nav class="mobile-nav" aria-label="Điều hướng mobile">'+mobileTabs.map(x=>{let n=NAV.find(z=>z.id===x);return '<button class="'+(x===g.id?'current':'')+'" data-group="'+x+'" aria-label="'+n.label+'">'+ic(n.icon,20)+'<span>'+n.label+'</span></button>'}).join('')+
 '<button data-act="menu" aria-label="Thêm chức năng">'+ic('menu',20)+'<span>Thêm</span></button></nav></div></div>';
 document.body.classList.toggle('nav-open',state.mobileMenu);
}
function navigate(id){
 if(!BY_ID.has(id))return showToast('Màn hình không tồn tại trong catalog');
 state.id=id;state.mobileMenu=false;
 if(location.hash.slice(1)!==id)history.pushState(null,'','#'+encodeURIComponent(id));
 renderShell();window.scrollTo({top:0,behavior:'instant'});
 document.querySelector('.content')?.scrollTo(0,0);
 document.getElementById('overlay-root').innerHTML='';
}
function render(){renderShell()}
function showToast(message){
 const root=document.getElementById('toast-root');
 root.innerHTML='<div class="toast">'+esc(message)+'</div>';
 clearTimeout(window.__v4Toast);window.__v4Toast=setTimeout(()=>root.innerHTML='',3800);
}
function openSearch(){
 state.mobileMenu=false;document.body.classList.remove('nav-open');
 const root=document.getElementById('overlay-root');
 root.innerHTML='<div class="overlay-backdrop" data-act="close-overlay"><section class="palette" role="dialog" aria-modal="true" aria-label="Tìm tính năng">'+
 '<input class="palette-input" id="palette-input" type="search" autocomplete="off" placeholder="Bạn muốn làm gì? Tìm màn hình, tính năng..." aria-label="Tìm kiếm màn hình"/>'+
 '<div class="palette-results" id="palette-results"></div><div class="palette-foot">↑ ↓ để chọn · Enter để mở · Esc để đóng · '+ALL.length+' màn hình có thể tìm kiếm</div></section></div>';
 const input=document.getElementById('palette-input');input.focus();
 input.addEventListener('input',renderSearchResults);
 renderSearchResults();
}
function renderSearchResults(){
 const q=document.getElementById('palette-input')?.value.trim().toLowerCase()||'';
 const arr=ALL.filter(s=>!q||(s.id+' '+s.title+' '+label(s.id)+' '+s.module+' '+(s.route||'')).toLowerCase().includes(q)).slice(0,11);
 document.getElementById('palette-results').innerHTML=arr.length?arr.map((s,i)=>'<button class="palette-result '+(!i?'focused':'')+'" data-go="'+esc(s.id)+'">'+
 '<span class="tile-icon">'+ic(activeGroup(s.id).icon,17)+'</span><span style="flex:1;min-width:0"><strong>'+esc(label(s.id))+'</strong><small>'+esc(activeGroup(s.id).label)+' · '+esc(s.id)+'</small></span>'+ic('right',15)+'</button>').join(''):
 '<div style="padding:27px;color:#8a8a98;text-align:center">Không tìm thấy màn hình phù hợp</div>';
}
function openDialog(kind){
 const content={
 create:['Tạo ý tưởng mới','Lưu ý tưởng vào bảng nội dung của bản demo.','Nhập ý tưởng của bạn'],
 workspace:['Không gian làm việc','Đây là bản trình diễn, chưa kết nối dữ liệu tài khoản.',''],
 help:['Trợ giúp Creativanta','Dùng menu theo công việc hoặc nhấn ⌘K để mở tất cả màn hình. Dữ liệu và hành động đều là mô phỏng.',''],
 notification:['Thông báo gần đây','Có 3 công việc cần xử lý. Nhấn Xem công việc để quay về Tổng quan.',''],
 generic:['Thao tác trong bản demo','Dữ liệu đang chỉ lưu trong bộ nhớ của prototype. Không có API, thanh toán hay xuất bản thật.','']
 }[kind]||['Mô phỏng thao tác','Không có dữ liệu thật nào được gửi.',''];
 const root=document.getElementById('overlay-root');
 root.innerHTML='<div class="overlay-backdrop" data-act="close-overlay"><section class="dialog" role="dialog" aria-modal="true" aria-labelledby="dlg-title"><span class="pill purple">BẢN TRÌNH DIỄN</span>'+
 '<h2 id="dlg-title">'+content[0]+'</h2><p>'+content[1]+'</p>'+
 (kind==='create'?'<div class="field"><label for="new-idea">Tên ý tưởng</label><input id="new-idea" placeholder="Ví dụ: 5 điều khách hàng thường hiểu lầm"/></div>':'')+
 '<div class="dialog-actions"><button class="btn" data-act="close-overlay">Đóng</button>'+
 (kind==='create'?'<button class="btn accent" data-act="save-idea">Lưu ý tưởng demo</button>':'')+
 (kind==='notification'?'<button class="btn accent" data-go="'+ROOT_ID+'">Xem công việc</button>':'')+
 '</div></section></div>';
 if(kind==='create')setTimeout(()=>document.getElementById('new-idea')?.focus(),0);
}
function onAction(action,target){
 if(action==='menu'){state.mobileMenu=!state.mobileMenu;document.body.classList.toggle('nav-open',state.mobileMenu);return}
 if(action==='close-menu'){state.mobileMenu=false;document.body.classList.remove('nav-open');return}
 if(action==='search'){openSearch();return}
 if(action==='close-overlay'){document.getElementById('overlay-root').innerHTML='';return}
 if(action==='create'){openDialog('create');return}
 if(action==='workspace'){openDialog('workspace');return}
 if(action==='notifications'){openDialog('notification');return}
 if(action==='help'){openDialog('help');return}
 if(action==='save-idea'){
  const title=document.getElementById('new-idea')?.value.trim();
  if(!title){document.getElementById('new-idea')?.focus();showToast('Nhập tên ý tưởng để lưu');return}
  state.ideas.unshift({title,id:Date.now()});
  document.getElementById('overlay-root').innerHTML='';
  navigate(SURFACE==='mobile'?'M008':'W012');showToast('Đã thêm vào bảng ý tưởng demo');return
 }
 if(action==='task'){
  const key=target.dataset.key;state.taskDone.has(key)?state.taskDone.delete(key):state.taskDone.add(key);
  render();return
 }
 if(action==='thread'){state.inbox=Number(target.dataset.index)||0;render();return}
 if(action==='send'){
  const input=document.getElementById('message-draft');
  if(!input?.value.trim()){input?.focus();return}
  showToast('Tin nhắn chỉ được mô phỏng, chưa gửi đến khách hàng');input.value='';return
 }
 if(action==='filter'){state.filters[group().id]=target.dataset.filter||'all';render();return}
 if(action==='demo'){openDialog('generic');return}
 if(action==='back'){history.back();return}
}
document.addEventListener('click',e=>{
 const target=e.target.closest('[data-go],[data-group],[data-act]');
 if(!target)return;
 if(target.dataset.go){navigate(target.dataset.go);return}
 if(target.dataset.group){const g=NAV.find(x=>x.id===target.dataset.group);if(g)navigate(g.ids.find(id=>BY_ID.has(id))||ROOT_ID);return}
 const act=target.dataset.act;if(act)onAction(act,target);
});
document.addEventListener('keydown',e=>{
 if((e.ctrlKey||e.metaKey)&&e.key.toLowerCase()==='k'){e.preventDefault();openSearch();return}
 if(e.key==='Escape'){document.getElementById('overlay-root').innerHTML='';state.mobileMenu=false;document.body.classList.remove('nav-open');return}
 if(e.key==='Enter'){
  const a=e.target.closest('[data-go][role="button"]');
  if(a)navigate(a.dataset.go);
  const palette=document.getElementById('palette-input');
  if(document.activeElement===palette){const first=document.querySelector('.palette-result');if(first)navigate(first.dataset.go)}
 }
});
window.addEventListener('popstate',()=>{const hash=decodeURIComponent(location.hash.slice(1));if(BY_ID.has(hash)){state.id=hash;render()}});
window.addEventListener('hashchange',()=>{const hash=decodeURIComponent(location.hash.slice(1));if(BY_ID.has(hash)&&hash!==state.id){state.id=hash;render()}});
function start(){render()}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',start);else start();
/*__VIEWS__*/
})();

#!/usr/bin/env python3
"""Landing/review index for all 245 Creativanta V5 items."""
from pathlib import Path
from html.parser import HTMLParser
import json,base64,html
D=Path(__file__).resolve().parent
items=json.loads((D/'screen_specs.json').read_text(encoding='utf8'))
files={'web':'creativanta-v5-web-all.html','mobile':'creativanta-v5-mobile-all.html','admin':'creativanta-v5-admin-all.html'}
def preview(name):
 f=D/'qa/screenshots'/name
 if not f.is_file():return ''
 return 'data:image/png;base64,'+base64.b64encode(f.read_bytes()).decode('ascii')
cards=[
 ('web','135','Web workspace','Ý tưởng, Studio, xuất bản, kinh doanh, phân tích và tự động hóa.',preview('web-1440-W052.png')),
 ('mobile','61','Creativanta Go','9 luồng mobile-first và 61 màn hình chi tiết với tương tác demo.',preview('mobile-390-M043.png')),
 ('admin','37','Admin operations','Hàng đợi vận hành, kiểm duyệt, phân quyền và báo cáo.',preview('admin-1440-A015.png')),
 ('shared','12','Approved design system','12 mẫu thành phần dùng chung với các trạng thái tương tác.','')
]
style=r"""
:root{--paper:#fbf9f5;--ink:#242924;--accent:#d94a31;--forest:#274333;--edge:#e8e5dc}
*{box-sizing:border-box}html,body{margin:0;padding:0}
body{background:var(--paper);color:var(--ink);font:13px/1.6 Inter,-apple-system,BlinkMacSystemFont,"Segoe UI",system-ui,sans-serif;-webkit-font-smoothing:antialiased}
a{color:inherit;text-decoration:none}button,input{font:inherit}
header{background:#fffefa;border-bottom:1px solid var(--edge);height:72px;padding:0 clamp(18px,4vw,62px);display:flex;align-items:center;justify-content:space-between;gap:20px}
.brand{font-size:18px;font-weight:800;letter-spacing:-.055em;display:flex;align-items:center;gap:9px}.brand i{height:28px;width:28px;border-radius:9px;background:var(--accent)}
.brand span{color:var(--accent)}.header-status{font-size:10px;color:#6f8575;font-weight:760;letter-spacing:.07em;background:#eaf3e8;border-radius:9px;padding:8px 11px}
main{max-width:1510px;margin:0 auto;padding:72px clamp(18px,4vw,62px) 90px}
.eyebrow{color:#7c917d;letter-spacing:.15em;font-weight:800;font-size:10px;display:flex;align-items:center;gap:9px}
.eyebrow:before{content:"";width:8px;height:8px;background:#6ba981;border-radius:50%;box-shadow:0 0 0 4px #dfece1}
h1{font-size:clamp(37px,5.1vw,68px);font-weight:770;letter-spacing:-.075em;line-height:1.12;max-width:920px;margin:22px 0 17px}
h1 em{font-family:Georgia,serif;font-weight:500;color:#bc5337}
.lead{color:#899387;line-height:1.75;max-width:750px;font-size:13px}
.metrics{display:flex;gap:11px;flex-wrap:wrap;margin:25px 0 43px}
.metric{border:1px solid #e7e2d8;border-radius:10px;background:#fffefa;padding:9px 12px;color:#7e8b7e;font-size:11px;font-weight:700}.metric strong{color:#385d41}
.subhead{display:flex;align-items:center;justify-content:space-between;gap:15px;margin:34px 0 17px}.subhead h2{margin:0;font-size:21px;letter-spacing:-.045em}.subhead small{color:#929b90;font-size:11px}
.cards{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:13px}
.card{min-width:0;background:#fffefa;border:1px solid var(--edge);border-radius:17px;overflow:hidden;box-shadow:0 8px 27px #23312105}
.thumb{height:225px;position:relative;background:linear-gradient(140deg,#edf1e7,#f7ede4);display:flex;align-items:center;justify-content:center;overflow:hidden}
.thumb:before{content:"";position:absolute;width:220px;height:220px;border:25px solid #dce7d5;border-radius:50%;right:-70px;top:-55px}
.thumb img{position:relative;width:100%;height:100%;object-fit:cover;object-position:top}
.card:nth-child(2) .thumb img{width:140px;height:200px;object-fit:cover;border:4px solid #303d34;border-radius:18px;box-shadow:0 12px 28px #20332125}
.card:nth-child(3) .thumb img{width:100%;height:100%;object-fit:cover}
.thumb span{position:relative;font-size:48px;color:#66806b;font-family:Georgia,serif;font-weight:700}
.card-content{padding:17px}.card-top{display:flex;align-items:center;gap:7px;color:#929e94;font-size:9px;font-weight:790;letter-spacing:.1em}
.card-top b{margin-left:auto;border-radius:7px;background:#e8f3e6;color:#4e7f5d;padding:5px 7px;font-size:10px}
.card h3{font-size:15px;letter-spacing:-.035em;margin:10px 0 7px;font-weight:750}
.card p{margin:0;min-height:48px;color:#939d91;font-size:11px;line-height:1.6}
.card .go{display:block;margin-top:15px;color:#bb5339;font-size:11px;font-weight:770}
.card:hover{border-color:#e9c6b5;transform:translateY(-1px)}
.catalog-tools{display:flex;gap:10px;align-items:center;flex-wrap:wrap;margin:8px 0 13px}
.catalog-tools input{flex:1;min-width:240px;background:#fffefa;border:1px solid var(--edge);border-radius:11px;padding:12px 15px;min-height:43px;outline:0;color:#303a32}
.catalog-tools input:focus{border-color:#cf9a85;box-shadow:0 0 0 3px #ffece3}
.tabs{display:flex;gap:6px;border:1px solid var(--edge);border-radius:11px;padding:4px;background:#fffefa;max-width:100%;overflow:auto}
.tabs button{padding:9px 13px;white-space:nowrap;border:0;border-radius:8px;font-size:11px;background:transparent;color:#8d988d;font-weight:760;cursor:pointer}
.tabs button.active{background:#2e4738;color:white}
#count{font-size:11px;color:#9aa396;margin-bottom:12px}
.screen-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:9px}
.screen{display:flex;gap:12px;align-items:center;min-width:0;padding:13px 14px;border:1px solid var(--edge);border-radius:12px;background:#fffefa}
.screen:hover{background:#f0f6ee;border-color:#c8dfc7}
.screen .code{font-weight:800;font-size:10px;color:#ba6047;background:#fbece3;border-radius:8px;padding:6px;flex:0 0 auto;min-width:40px;text-align:center}
.screen .copy{flex:1;min-width:0}.screen strong{display:block;color:#39473a;font-size:11.5px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.screen small{display:block;margin-top:3px;font-size:10px;color:#a0a69c;white-space:nowrap;text-overflow:ellipsis;overflow:hidden}
.screen .arrow{color:#b0b8ad;font-size:17px}
.footer{margin:55px 0 0;padding:21px 0;border-top:1px solid var(--edge);color:#9ca499;font-size:10px}
@media(max-width:1200px){.cards{grid-template-columns:repeat(2,minmax(0,1fr))}.screen-grid{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(max-width:660px){header{padding:0 15px}.header-status{font-size:8px;padding:7px}.cards,.screen-grid{grid-template-columns:minmax(0,1fr)}main{padding-top:44px}.thumb{height:210px}.catalog-tools input{min-width:0;width:100%}.tabs{width:100%}.tabs button{flex:1;padding:9px 8px}}
"""
markup=[]
for plat,count,name,desc,img in cards:
 dest=files.get(plat,'creativanta-v5-shared-system.html')
 markup.append('<a class="card" href="./'+dest+'" target="_blank" rel="noopener"><div class="thumb">'+
   ('<img src="'+img+'" alt="Ảnh chụp '+html.escape(name)+'"/>' if img else '<span>✦</span>')+'</div>'+
   '<div class="card-content"><div class="card-top">'+plat.upper()+' / INTERACTIVE <b>'+count+'</b></div>'+
   '<h3>'+html.escape(name)+'</h3><p>'+html.escape(desc)+'</p><span class="go">Mở thiết kế ↗</span></div></a>')
doc='''<!doctype html><html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Creativanta V5 — All Product Design</title><style>'''+style+'''</style></head><body>
<header><div class="brand"><i></i>creativanta<span>.</span></div><span class="header-status">APPROVED GO DESIGN SYSTEM · V5</span></header><main>
<div class="eyebrow">COMPLETE UI/UX LIBRARY · INTERACTIVE PROTOTYPES</div>
<h1>Mọi trải nghiệm.<br><em>Cùng một ngôn ngữ thiết kế.</em></h1>
<p class="lead">Web, Mobile, Admin và Shared UI. Các màn hình được tổ chức theo công việc, có tìm kiếm và tương tác DEMO. Đây không phải backend hay sản phẩm production.</p>
<div class="metrics"><span class="metric"><strong>135</strong> Web</span><span class="metric"><strong>61</strong> Mobile</span><span class="metric"><strong>37</strong> Admin</span><span class="metric"><strong>12</strong> Shared components</span></div>
<div class="subhead"><h2>Mở bộ thiết kế</h2><small>Chọn nền tảng để xem toàn bộ màn hình</small></div><div class="cards">'''+''.join(markup)+'''</div>
<section id="catalog"><div class="subhead"><h2>Tra cứu 233 màn hình</h2><small>Click để mở thẳng tới màn hình tương ứng</small></div>
<div class="catalog-tools"><input id="search" type="search" placeholder="Tìm theo tên, mã màn hình, module, route..." aria-label="Tìm màn hình"/>
<div class="tabs" role="tablist" aria-label="Nền tảng"><button class="active" data-platform="all">Tất cả</button><button data-platform="web">Web</button><button data-platform="mobile">Mobile</button><button data-platform="admin">Admin</button></div></div>
<div id="count"></div><div class="screen-grid" id="screen-grid"></div></section>
<p class="footer">Thông tin được lấy từ danh mục màn hình trong docs/03_screens. Tương tác được mô phỏng cục bộ, không có API thật hoặc dữ liệu người dùng. V5 design system đã được product owner phê duyệt cho bản prototype.</p></main>
<script>window.CV5_SCREENS='''+json.dumps([{'id':x['id'],'title':x['title'],'platform':x['platform'],'category':x['category'],'module':x['module'],'route':x['route']} for x in items],ensure_ascii=False,separators=(',',':'))+''';</script>
<script>'''
js=r"""
let platform='all';
const grid=document.getElementById('screen-grid');
const esc=x=>String(x??'').replace(/[&<>"']/g,k=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[k]));
function render(){
 const q=document.getElementById('search').value.trim().toLocaleLowerCase('vi');
 const data=window.CV5_SCREENS.filter(s=>(platform==='all'||s.platform===platform)&&(!q||(s.id+' '+s.title+' '+s.category+' '+s.route+' '+s.module).toLocaleLowerCase('vi').includes(q)));
 document.getElementById('count').textContent='Đang hiển thị '+data.length+' / 233 màn hình · click để mở preview';
 grid.innerHTML=data.map(s=>'<a class="screen" target="_blank" rel="noopener" href="./'+({'web':'creativanta-v5-web-all.html','mobile':'creativanta-v5-mobile-all.html','admin':'creativanta-v5-admin-all.html'}[s.platform])+'#'+encodeURIComponent(s.id)+'">'+
 '<span class="code">'+esc(s.id)+'</span><span class="copy"><strong>'+esc(s.title)+'</strong><small>'+esc(s.category)+' · '+esc(s.module)+'</small></span><span class="arrow">↗</span></a>').join('');
}
document.getElementById('search').addEventListener('input',render);
document.querySelectorAll('[data-platform]').forEach(b=>b.addEventListener('click',()=>{platform=b.dataset.platform;document.querySelectorAll('[data-platform]').forEach(el=>el.classList.toggle('active',el===b));render()}));
render();
"""
doc+=js+'''</script></body></html>'''
out=D/'dist'/'creativanta-v5-start-here.html'
out.write_text(doc,encoding='utf8')
HTMLParser().feed(doc)
print('INDEX',out,'bytes',out.stat().st_size,'screens',len(items))

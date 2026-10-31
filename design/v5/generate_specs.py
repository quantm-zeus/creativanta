#!/usr/bin/env python3
"""Turn 233 source screens into interactive visual-prototype descriptors."""
from pathlib import Path
from collections import Counter
import re,json
ROOT=Path(__file__).resolve().parents[2]
OUT=Path(__file__).resolve().parent
SCREENS=json.loads((OUT/'catalog.json').read_text(encoding='utf8'))['screens']
KNOWN={x['id'] for x in SCREENS}
CORE=(OUT/'web/core.js').read_text(encoding='utf8')
LABELS=dict(re.findall(r"([WMA]\d+[a-z]?):'([^']+)'",CORE))
GLOSS=[
 ('Brand Voice & Identity','giọng thương hiệu và nhận diện'),('Platform Integration','tích hợp nền tảng'),('Workspace Members','thành viên workspace'),('Team & Roles','nhóm và phân quyền'),
 ('Connected Account','tài khoản kết nối'),('AI Credit','credit AI'),('Subscription & Billing','gói và thanh toán'),('Content Moderation','kiểm duyệt nội dung'),
 ('Revenue Per Content','doanh thu theo nội dung'),('Affiliate Links','liên kết tiếp thị'),('Asset Library','thư viện tài sản'),
 ('Opportunity Board','bảng cơ hội'),('Live War Room','phòng điều hành livestream'),('Morning Brief','bản tin buổi sáng'),
 ('Global Search','tìm kiếm toàn cục'),('Watchlist','danh sách theo dõi'),('Post Analytics','phân tích bài đăng'),
 ('Workflow Run','lần chạy quy trình'),('System Health','sức khỏe hệ thống'),('Background Job','tác vụ nền'),
 ('Brand Deal','hợp tác thương hiệu'),('Content','nội dung'),('Account','tài khoản'),('Platform','nền tảng'),
 ('Analytics','phân tích'),('Finance','tài chính'),('Revenue','doanh thu'),('Profit','lợi nhuận'),('Cost','chi phí'),
 ('Order','đơn hàng'),('Product','sản phẩm'),('Inventory','tồn kho'),('Stock','tồn kho'),('Offer','ưu đãi'),('Coupon','mã giảm giá'),
 ('Campaign','chiến dịch'),('Affiliate','tiếp thị liên kết'),('Membership','thành viên'),('Store','cửa hàng'),('Refund','hoàn tiền'),
 ('Sample','mẫu'),('Seeding','seeding'),('Creator','nhà sáng tạo'),('Sponsor','nhãn hàng'),('Deal','hợp đồng'),
 ('Contract','hợp đồng'),('Evidence','bằng chứng'),('Settlement','quyết toán'),('Reconciliation','đối soát'),
 ('Tax','thuế'),('Credit','credit'),('Billing','thanh toán'),('Report','báo cáo'),('Idea','ý tưởng'),
 ('Script','kịch bản'),('Video','video'),('Image','hình ảnh'),('Clip','clip'),('Sound','âm thanh'),
 ('Character','nhân vật'),('Thumbnail','ảnh bìa'),('Translation','dịch thuật'),('Publish','xuất bản'),
 ('Schedule','lịch'),('Queue','hàng đợi'),('Post','bài đăng'),('Channel','kênh'),('Diagnostics','chẩn đoán'),
 ('Contact','liên hệ'),('Inbox','hộp thư'),('Thread','hội thoại'),('Follow-up','chăm sóc lại'),
 ('Customer','khách hàng'),('User','người dùng'),('Workspace','workspace'),('Team','đội nhóm'),('Roles','vai trò'),
 ('Audit','kiểm toán'),('Log','nhật ký'),('Notification','thông báo'),('Support','hỗ trợ'),('Ticket','phiếu hỗ trợ'),
 ('Help','trợ giúp'),('Article','bài viết'),('Knowledge','tri thức'),('Workflow','quy trình'),('Agent','agent'),
 ('Recipe','công thức'),('Task','công việc'),('Approval','phê duyệt'),('Automation','tự động hóa'),('Monitor','giám sát'),
 ('Management','quản lý'),('Performance','hiệu quả'),('Growth','tăng trưởng'),('Competitor','đối thủ'),
 ('Opportunity','cơ hội'),('Trend','xu hướng'),('Research','nghiên cứu'),('Benchmark','đối chiếu'),
 ('Insight','phân tích sâu'),('Capability','khả năng'),('Matrix','ma trận'),('Configuration','cấu hình'),
 ('Moderation','kiểm duyệt'),('Rule','quy tắc'),('Incident','sự cố'),('Fraud','gian lận'),
 ('Compliance','tuân thủ'),('Security','bảo mật'),('Integration','tích hợp'),('Connector','kết nối'),
 ('Email','email'),('Data','dữ liệu'),('Export','xuất dữ liệu'),('Delete','xóa'),('Settings','cài đặt'),
 ('Onboarding','thiết lập ban đầu'),('Authentication','xác thực'),('Login','đăng nhập'),('Register','đăng ký'),
 ('Forgot Password','quên mật khẩu'),('Builder','trình thiết kế'),('Editor','trình biên tập'),
 ('List','danh sách'),('Detail','chi tiết'),('Overview','tổng quan'),('Dashboard','tổng quan'),
 ('Center','trung tâm'),('Manager','quản lý'),('Summary','tóm tắt'),('History','lịch sử'),
 ('Tracking','theo dõi'),('Quick','nhanh'),('Bulk','hàng loạt'),('Create','tạo mới'),('Edit','chỉnh sửa'),
 ('View','xem'),('Upload','tải lên'),('Setup','thiết lập'),('Template','mẫu'),('Templates','mẫu')
]
GLOSS.sort(key=lambda x:-len(x[0]))
MODULE_INFO={
 'M01':('Tổng quan','home'),'M02':('Xu hướng','discover'),'M03':('Nghiên cứu','discover'),'M04':('Cơ hội','discover'),
 'M05':('Ý tưởng','create'),'M06':('Kịch bản','create'),'M07':('Studio','create'),'M08':('Nhất quán','create'),
 'M09':('Tài sản','create'),'M10':('Kiểm tra nội dung','create'),'M11':('Xuất bản','publish'),
 'M12':('Khách hàng','inbox'),'M13':('Sản phẩm & đơn hàng','commerce'),'M14':('Kinh doanh','commerce'),
 'M15':('Cửa hàng','commerce'),'M16':('Tiếp thị liên kết','commerce'),'M17':('Livestream','commerce'),
 'M18':('Seeding','commerce'),'M19':('Tài chính','insights'),'M20':('Quy trình','automate'),
 'M21':('AI Agents','automate'),'M22':('Khả năng nền tảng','settings'),'M23':('Cài đặt','settings'),
 'S16':('Creator Pro','commerce'),'S26':('Vận hành nền tảng','platform'),
 'auth':('Đăng nhập','settings'),'copilot':('Trợ lý AI','home'),'help':('Hỗ trợ','settings'),
 'referral':('Giới thiệu','settings'),'gamification':('Thành tựu','home')
}
RECORDS={
 'home':['Quyết định ưu tiên hôm nay','Bản tin buổi sáng','Việc cần làm tiếp theo','Thông báo đang chờ'],
 'discover':['Skinimalism đang trở lại','Góc làm việc nhỏ','Video AI cho creator','Danh mục cần nghiên cứu'],
 'create':['Routine 60 giây','Bộ kịch bản chăm da','Storyboard sản phẩm A','Video đang chờ duyệt'],
 'publish':['Video Routine 60 giây','Review phụ kiện workspace','Carousel xu hướng','Lịch đăng ngày mai'],
 'inbox':['Linh Nguyễn · câu hỏi sản phẩm','Ngọc Hà · hỗ trợ đơn hàng','Khánh Minh · phản hồi sau mua','Danh sách chăm sóc lại'],
 'commerce':['Đơn #CV-209 · bộ chăm sóc','Kệ bàn mini','Chương trình ưu đãi tháng','Mã giảm giá CREATIVE'],
 'insights':['Doanh thu đã ghi nhận','Chi phí chưa đối soát','Nguồn dữ liệu tham khảo','Bằng chứng cần bổ sung'],
 'automate':['Luồng theo dõi xu hướng','Recipe tạo ý tưởng','Tác vụ duyệt nội dung','Lịch sử chạy thử'],
 'settings':['Workspace Creative Studio','Tài khoản TikTok mẫu','Gói Creator','Cài đặt thông báo'],
 'platform':['Tác vụ hệ thống','Tình trạng kết nối','Yêu cầu kiểm duyệt','Nhật ký giám sát']
}
def translate(s):
 s=re.sub(r'^(?:Web|Mobile|Admin)\s*[—–-]\s*','',s).strip()
 for k,v in GLOSS:s=re.sub(r'(?<!\w)'+re.escape(k)+r'(?!\w)',v,s,flags=re.I)
 s=s.replace(' / ',' · ').replace('&','và')
 return s[:1].upper()+s[1:] if s else ''
def title(s):
 if s['id']=='M043':return 'Ghi nhận chi phí'
 if s['id'] in LABELS:return LABELS[s['id']]
 v=re.sub(r'^(?:Web|Mobile|Admin)\s*[—–-]\s*','',s['title']).strip()
 for suf,pre in [(' Detail','Chi tiết'),(' Overview','Tổng quan'),(' Dashboard','Tổng quan'),(' List','Danh sách'),(' Queue','Hàng đợi'),(' Manager','Quản lý'),(' Builder','Thiết kế'),(' Editor','Biên tập'),(' Center','Trung tâm'),(' History','Lịch sử'),(' Monitor','Giám sát'),(' Setup','Thiết lập'),(' Report','Báo cáo')]:
  if v.lower().endswith(suf.lower()) and len(v)>len(suf)+2:return pre+' '+translate(v[:-len(suf)]).lower()
 return translate(v)
def variant(s):
 t=s['title'].lower();h=lambda *terms:any(q in t for q in terms);kind=s['kind']
 if s['module']=='auth' or h('login','register','forgot password','authentication'):return 'auth'
 if h('search','selector','quick action'):return 'search'
 if h('calendar','schedule calendar'):return 'calendar'
 if h('report','analytics','profit','revenue','finance','growth','stats','performance','insight'):return 'analytics'
 if h('moderation','approval','review','fraud','abuse','compliance','incident','diagnostic','dlq'):return 'approval'
 if h('workflow','agent runs','task queue','recipe','automation','queue','job monitor'):return 'workflow'
 if h('editor','composer','builder','setup','generation','create','remix','quick edit','script','caption','media kit','brand voice','studio','clip','video','image','thumbnail','translation','sound','character','continuity'):return 'editor'
 if h('inbox','thread','contact','support','ticket','follow-up','seeding'):return 'inbox'
 if h('settings','config','subscription','billing','credit','account','integration','capability','permission','members','role','team','feature flag','api key'):return 'settings'
 if h('order','product','offer','coupon','store','campaign','affiliate','sample','refund','deal','commerce','monetization'):return 'commerce'
 if h('onboarding','cost entry'):return 'form'
 if kind in ('table','editor','analytics','form','calendar','detail','dashboard'):return kind
 if h('watchlist','library','list','registry','manager','queue'):return 'table'
 if h('idea board','opportunity board','task','pipeline'):return 'board'
 return 'workspace'
def actions(spec):
 header=re.search(r'(?m)^##\s+\d+\.\s*(?:User Actions|Actions Table|Interactive Actions|Actions)\b',spec,re.I)
 if not header:return []
 segment=spec[header.end():];n=re.search(r'(?m)^##\s+',segment)
 if n:segment=segment[:n.start()]
 result=[]
 for ln in segment.splitlines():
  if not re.match(r'^\|\s*\d+\s*\|',ln):continue
  parts=[p.strip() for p in ln.strip('|').split('|')]
  if len(parts)<3:continue
  a=re.sub(r'[\x60*_]','',parts[1]);a=re.sub(r'\[(.*?)\]\(.*?\)',r'\1',a)
  if not a or len(a)>85:continue
  low=a.lower();typ='generic'
  if any(q in low for q in ('publish','send','remove','suspend','delete','refund','override','broadcast','charge','payment')):typ='critical'
  elif any(q in low for q in ('approve','reject','resolve','clear','mark','warn','escalate')):typ='decision'
  elif any(q in low for q in ('upload','scan','attach','pick from')):typ='upload'
  elif any(q in low for q in ('export','download')):typ='export'
  elif any(q in low for q in ('create','add','new','save','edit','update','config','assign','toggle','select','switch','change','run','generate')):typ='mutate'
  elif any(q in low for q in ('view','open','detail')):typ='navigation'
  elif any(q in low for q in ('filter','sort','search','compare')):typ='filter'
  result.append({'sourceName':a,'label':translate(a),'type':typ})
 return result
def sections(spec):
 names=[]
 for key in ('Component Hierarchy','Screen Layout','Layout Structure'):
  m=re.search(r'(?m)^##\s+\d+\.\s+'+re.escape(key)+r'[^\n]*',spec,re.I)
  if not m:continue
  z=spec[m.end():];n=re.search(r'(?m)^##\s+',z);z=z[:n.start()] if n else z
  for h in re.findall(r'(?m)^###\s+([^#\n]+)',z):
   h=re.sub(r'^\d+\.?\s*','',h).strip()
   if 3<len(h)<55 and h.lower() not in ('ascii wireframe','responsive behavior','responsive','component hierarchy'):names.append(translate(h))
 return list(dict.fromkeys(names))[:5]
def related(spec,s):
 refs=re.findall(r'\b(?:W|M|A)\d{3}[a-z]?\b',spec[:13000]);found=[]
 for x in refs:
  if x in KNOWN and x!=s['id'] and x[0]==s['id'][0] and x not in found:found.append(x)
 for x in SCREENS:
  if len(found)>=6:break
  if x['module']==s['module'] and x['platform']==s['platform'] and x['id']!=s['id'] and x['id'] not in found:found.append(x['id'])
 return found[:6]
items=[]
for s in SCREENS:
 doc=(ROOT/s['source']).read_text(encoding='utf8',errors='replace')
 category,grp=MODULE_INFO.get(s['module'],('Không gian','settings'))
 if s['platform']=='admin':category='Vận hành nền tảng';grp='platform'
 st=s['title'].lower()
 if any(w in st for w in ('analytics','profit','finance','revenue','reconciliation','settlement')):
  category='Phân tích';grp='insights'
 if s['platform']=='admin' and any(w in st for w in ('moderation','fraud','abuse','incident','compliance','dispute','dlq')):
  category='Kiểm duyệt';grp='platform'
 a=actions(doc)
 items.append({
  'id':s['id'],'platform':s['platform'],'title':title(s),'originalTitle':s['title'],
  'route':s['route'],'module':s['module'],'kind':s['kind'],'variant':variant(s),
  'category':category,'group':grp,'source':s['source'],
  'purpose':(s.get('purpose') or '')[:680],'sourceActions':a,'actionCount':len(a),
  'sections':sections(doc),'related':related(doc,s),'records':RECORDS.get(grp,RECORDS['settings'])
 })
OUT.joinpath('screen_specs.json').write_text(json.dumps(items,ensure_ascii=False,separators=(',',':')),encoding='utf8')
print('SPECS',len(items),'BY_TYPE',dict(Counter(x['variant'] for x in items)))
print('SOURCE_ACTION_COUNT',sum(x['actionCount'] for x in items),'SCREENS_WITH_ACTIONS',sum(bool(x['sourceActions']) for x in items))
print('EXAMPLES',[(x['id'],x['title']) for x in items[:8]])

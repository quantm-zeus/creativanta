#!/usr/bin/env python3
"""Build fully standalone V5 Mobile, approved Go V4 style with all 61 screen designs."""
from pathlib import Path
from html.parser import HTMLParser
import json,subprocess
D=Path(__file__).resolve().parent
ROOT=D.parents[1]
screens=json.loads((D/'screen_specs.json').read_text(encoding='utf8'))
mobile=[x for x in screens if x['platform']=='mobile']
assert len(mobile)==61
v4=D/'mobile'
html=(v4/'shell.html').read_text(encoding='utf8')
css=(v4/'mobile.css').read_text(encoding='utf8')+'\n'+(v4/'full.css').read_text(encoding='utf8')
js=(v4/'mobile.js').read_text(encoding='utf8')
extra=(v4/'full.js').read_text(encoding='utf8')
assert js.count('function fallbackView(){')==1
js=js.replace('function fallbackView(){','function renderV4Fallback(){')
assert "section=['M057','M058','M059','M061','M062'].includes(id)?'detail':CORE[id]||'detail';" in js
js=js.replace("section=['M057','M058','M059','M061','M062'].includes(id)?'detail':CORE[id]||'detail';","section='detail';")
assert "const overlay=state.overlay;" in js
js=js.replace("const overlay=state.overlay;","const overlay=state.overlay;\n if(overlay.type==='v5custom')return;")
assert "if(state.section==='detail')return niceScreen(detail);" in js
js=js.replace("if(state.section==='detail')return niceScreen(detail);","if(state.section==='detail')return V5MBY.get(detail?.id)?.title||niceScreen(detail);")
assert "escapeHTML(niceScreen(s))" in js
js=js.replace("escapeHTML(niceScreen(s))","escapeHTML(V5MBY.get(s.id)?.title||niceScreen(s))")
assert js.endswith("})();\n")
js=js[:-len("})();\n")]+extra+"\n})();\n"
test=subprocess.run(['node','--check','-'],input=js,text=True,capture_output=True)
if test.returncode:raise RuntimeError(test.stderr)
html=html.replace('/*__CSS__*/',css)
html=html.replace('/*__MOBILE_CATALOG__*/',json.dumps(json.loads((D/'catalog.json').read_text(encoding='utf8'))['screens'],ensure_ascii=False,separators=(',',':')))
html=html.replace('<script>/*__JS__*/</script>','<script>window.CREATIVANTA_FULL_SPECS='+json.dumps(screens,ensure_ascii=False,separators=(',',':'))+';</script><script>'+js+'</script>')
assert '/*__JS__*/' not in html and '/*__CSS__*/' not in html
HTMLParser().feed(html)
out=D/'dist'/'creativanta-v5-mobile-all.html'
out.parent.mkdir(exist_ok=True)
out.write_text(html,encoding='utf8')
print('mobile','screens',len(mobile),'bytes',out.stat().st_size,out)

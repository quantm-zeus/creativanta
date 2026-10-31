#!/usr/bin/env python3
"""Build standalone V5 Web/Admin full-screen prototypes from approved Go system."""
from pathlib import Path
from html.parser import HTMLParser
import json,subprocess
D=Path(__file__).resolve().parent
ROOT=D.parents[1]
catalog=json.loads((D/'catalog.json').read_text(encoding='utf8'))
screens=json.loads((D/'screen_specs.json').read_text(encoding='utf8'))
assert len(screens)==233
assert {x['id'] for x in screens}=={x['id'] for x in catalog['screens']}
web=D/'web';shell=(web/'shell.html').read_text(encoding='utf8')
css='\n'.join((web/name).read_text(encoding='utf8') for name in ('style.css','approved-go.css','full.css'))
core=(web/'core.js').read_text(encoding='utf8')
views=(web/'views.js').read_text(encoding='utf8')
v5=(web/'full.js').read_text(encoding='utf8')
assert core.count('function label(id){')==1
core=core.replace('function label(id){','function baseLabel(id){')
assert views.count('function renderTitle(){')==1
views=views.replace('function renderTitle(){','function renderV4Title(){')
assert views.count('function renderDescription(){')==1
views=views.replace('function renderDescription(){','function renderV4Description(){')
assert views.count('function renderView(){')==1
views=views.replace('function renderView(){','function renderV4View(){')
js=core.replace('/*__VIEWS__*/',views+'\n'+v5)
test=subprocess.run(['node','--check','-'],input=js,text=True,capture_output=True)
if test.returncode:raise RuntimeError('JS syntax: '+test.stderr)
dist=D/'dist';dist.mkdir(exist_ok=True)
for platform in ('web','admin'):
 html=shell.replace('/*__STYLES__*/',css).replace('__SURFACE__',platform)
 html=html.replace('/*__CATALOG__*/',json.dumps(catalog,ensure_ascii=False,separators=(',',':')))
 html=html.replace('<script>/*__APP__*/</script>','<script>window.CREATIVANTA_FULL_SPECS='+
 json.dumps(screens,ensure_ascii=False,separators=(',',':'))+';</script>\n<script>'+js+'</script>')
 assert '/*__APP__*/' not in html
 HTMLParser().feed(html)
 path=dist/('creativanta-v5-'+platform+'-all.html')
 path.write_text(html,encoding='utf8')
 print(platform,'screens',sum(s['platform']==platform for s in screens),'bytes',path.stat().st_size,path)

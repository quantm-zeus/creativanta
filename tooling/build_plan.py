#!/usr/bin/env python3
"""Generate/check source-linked implementation inventories; never certify runtime acceptance."""
from __future__ import annotations
import argparse
import csv
import hashlib
import io
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INDEX = Path('docs/00_index')
REQ_FIELDS = ['requirement_id','module','source','heading','start_line','end_line','sha256','delivery_task','acceptance_task','acceptance_phase','kind']
SCREEN_FIELDS = ['source','declared_module','module','delivery_task','acceptance_task','sha256']

def digest(text): return hashlib.sha256(text.encode()).hexdigest()

def sections(path):
    """Partition every nonempty Markdown section outside fences; preserve source line ranges."""
    lines=path.read_text().splitlines(keepends=True)
    starts=[]; stack=[]; fence=None
    for i,line in enumerate(lines):
        marker=re.match(r'^\s*(`{3,}|~{3,})',line)
        if marker:
            if fence is None: fence=marker[1][0]
            elif marker[1][0]==fence: fence=None
            continue
        if fence: continue
        m=re.match(r'^(#{2,6})\s+(.+?)\s*$',line)
        if m:
            level=len(m[1]);stack=[x for x in stack if x[0]<level];stack.append((level,m[2]))
            starts.append((i,' > '.join(x[1] for x in stack)))
    for idx,(start,title) in enumerate(starts):
        end=starts[idx+1][0] if idx+1<len(starts) else len(lines)
        body=''.join(lines[start+1:end]).strip()
        if not body.strip('- \n'):continue
        # Individual rules, numbered ACs, Scope bullets and Gherkin scenarios remain separately traceable.
        cuts=[start]
        for j in range(start+1,end):
            line=lines[j]
            if re.match(r'^\d+\. \*\*(?:Given|RULE-)',line) or re.match(r'^  Scenario:',line) or (('Covers' in title or title.endswith('Scope')) and line.startswith('- ')):
                cuts.append(j)
        cuts=sorted(set(cuts))
        for part,a in enumerate(cuts):
            b=cuts[part+1] if part+1<len(cuts) else end
            body=''.join(lines[a:b])
            if not body.strip('- \n'):continue
            yield title,part+1,a+1,b,body

def screen_module(path, text, modules):
    name=path.stem
    declared=re.search(r'^> \*\*Module\*\*:\s*(.+)',text,re.M)
    declared=declared[1] if declared else ''
    if path.parent.name=='admin':return declared,'S26'
    # Several historic screen headers use obsolete module numbers; functionality wins.
    patterns=[('copilot','copilot'),('referral','referral'),('gamification','gamification'),
      ('creator_pro|creator_brand|brand_deal|media_kit|rate_card|link_in_bio|tax_export|revenue_tracker','S16'),
      ('auth_|login|signup|forgot|reset_password','auth'),('support|help_center|changelog','help'),
      ('contacts|contact_detail|engagement|inbox|thread','M12'),('seeding|samples','M18'),
      ('commerce_affiliate','M16'),('commerce_products','M13'),('commerce_membership|commerce_store','M15'),
      ('studio_asset_library','M09'),('performance_coach','M07'),
      ('live_war|live_session','M17'),('ab_testing','M10'),('workflow','M20'),('recipes|agent_runs','M21')]
    for pattern,module in patterns:
        if re.search(pattern,name):return declared,module
    m=re.search(r'\b(M\d{2}|S16|S24|S26)\b',declared)
    if m and m[1] in modules:return declared,m[1]
    if path.parent.name=='shared':return declared,'M01'
    if re.search(r'auth',declared,re.I):return declared,'auth'
    # Unclassified screens must be explicitly assigned; never silently default to Home.
    overrides={'screen_mobile_onboarding':'M01','screen_web_onboarding':'M01','screen_web_monetization_os':'M14'}
    if name in overrides:return declared,overrides[name]
    raise ValueError(f'Unclassified screen: {path.name}: {declared}')

def expected(root):
    catalog=json.loads((root/INDEX/'agent_task_catalog.json').read_text())
    modules=catalog['modules']; tasks={t['id']:t for t in catalog['tasks']}; req=[]; screens=[]
    def append(module,source,title,part,start,end,body,kind):
        spec=modules[module];delivery=spec['default_task']
        for route in spec['section_routes']:
            if re.search(route['pattern'],title,re.I):delivery=route['task'];break
        rid=f'{module}-{digest(source+"#"+title)[:12]}-{part:03d}'
        req.append(dict(requirement_id=rid,module=module,source=source,heading=title,start_line=str(start),end_line=str(end),sha256=digest(body),delivery_task=delivery,acceptance_task=spec['completion_task'],acceptance_phase=tasks[spec['completion_task']]['phase'],kind=kind))
    for module,spec in sorted(modules.items()):
        source=spec['feature_ref']
        for title,part,start,end,body in sections(root/source):
            append(module,source,title,part,start,end,body,'feature_section')
    source='docs/00_index/ACCEPTANCE_TESTS.md'
    for title,part,start,end,body in sections(root/source):
        m=re.search(r'(?:^| > )(M\d{2}|S16|S24|S26)\b',title)
        if m:append(m[1],source,title,part,start,end,body,'prd_acceptance')
    for path in sorted((root/'docs/03_screens').glob('*/*.md')):
        text=path.read_text();declared,module=screen_module(path,text,modules);spec=modules[module]
        delivery=spec['default_task']
        for pattern,task in [('creator_directory|creator_contracts','P8-07'),('studio_video_agent','P7-04'),('performance_coach|ab_testing','P5-05'),('studio_style_learning','P4-07'),('studio_quick_edit','P4-02'),('studio_clip_factory','P4-03'),('studio_ai_remix|studio_multi_merge','P4-04'),('studio_product_showcase|studio_image_to_video|studio_link_to_video|studio_thumbnail','P4-05'),('studio_sound|studio_translation','P4-06')]:
            if re.search(pattern,path.stem):delivery=task;break
        screens.append(dict(source=str(path.relative_to(root)),declared_module=declared,module=module,delivery_task=delivery,acceptance_task=spec['completion_task'],sha256=digest(text)))
    return catalog,req,screens

def csv_text(rows,fields):
    out=io.StringIO(newline='');writer=csv.DictWriter(out,fieldnames=fields,lineterminator='\n');writer.writeheader();writer.writerows(rows);return out.getvalue()

def task_markdown(catalog):
    out=['---','layer: index','canonical: false','last_updated: 2026-10-30','---','','# Task cards — generated projection','','Generated from [task catalog](agent_task_catalog.json); do not edit this projection. Reading sequence and evidence contract: [Agent Build Backlog](AGENT_BUILD_BACKLOG.md). All tasks are SPECIFIED; empty implementation evidence is not acceptance.','']
    for t in catalog['tasks']:
        out.extend([f"## {t['id']} — {t['title']}",'',f"Phase: {t['phase']}. Dependencies: {', '.join(t['depends_on']) or 'none'}. Modules: {', '.join(t['modules'])}.",'',t['deliverable'],'','Read: '+', '.join(f'[{Path(p).name}]({Path("../..")/Path(p).relative_to("docs")})' for p in t['reading_refs'])+'.','','Required outcomes:',''])
        out.extend('- '+item for item in t['acceptance'])
        out.extend(['',f"Implementation packet: `{t['packet']}`. Compile current-slice messages/migrations before implementation; attach actual commands, fixtures and five-path evidence. The module completion task also reconciles downstream requirements in the requirement inventory.",''])
    # Links from docs/00_index to other docs are ../domain, not ../../domain.
    return '\n'.join(out).replace('](../../','](../').rstrip()+'\n'

def validate(root):
    errors=[]
    try:catalog,req,screens=expected(root)
    except (OSError,ValueError,KeyError) as exc:return [f'build plan: {exc}'],{}
    tasks=catalog['tasks']; byid={t['id']:t for t in tasks}
    if len(byid)!=len(tasks):errors.append('build plan: duplicate task ID')
    expected_modules={f'M{i:02}' for i in range(1,24)}|{'auth','copilot','referral','help','gamification','S16','S24','S26'}
    if set(catalog['modules'])!=expected_modules:errors.append('build plan: must preserve all 31 module assignments')
    feature_paths={str(p.relative_to(root)) for p in (root/'docs/02_features').glob('*/*.md')}
    if feature_paths!={s['feature_ref'] for s in catalog['modules'].values()}:
        errors.append('build plan: feature files and catalog coverage differ')
    phases={m:(start,end) for m,start,end in re.findall(r'^\| (M\d\d|auth|copilot|referral|help|gamification|S\d\d) \| (P\d) \| (P\d) \|',(root/INDEX/'IMPLEMENTATION_ORDER.md').read_text(),re.M)}
    for module,spec in catalog['modules'].items():
        complete=byid.get(spec['completion_task'],{}).get('phase')
        if module in phases and complete!=phases[module][1]:errors.append(f'build plan: {module} completion phase mismatch')
        for route in spec['section_routes']:
            if route['task'] not in byid:errors.append(f'build plan: unknown route task {route["task"]}')
    visiting=set();visited=set()
    def visit(id):
        if id in visiting:errors.append(f'build plan: dependency cycle at {id}');return
        if id in visited or id not in byid:return
        visiting.add(id)
        for dep in byid[id]['depends_on']:
            if dep not in byid:errors.append(f'build plan: missing dependency {dep}')
            else:
                if byid[dep]['phase']>byid[id]['phase']:errors.append(f'build plan: backward phase dependency {id}->{dep}')
                visit(dep)
        visiting.remove(id);visited.add(id)
    for t in tasks:
        visit(t['id'])
        if not t.get('deliverable') or not t.get('acceptance') or not t.get('required_outputs'):errors.append(f'build plan: incomplete task {t["id"]}')
        for ref in t['reading_refs']+t['contract_refs']:
            if not (root/ref).is_file():errors.append(f'build plan: missing task source {ref}')
        if t['status']!='SPECIFIED':errors.append(f'build plan: planning catalog cannot pre-accept runtime task {t["id"]}')
    if len({r['requirement_id'] for r in req})!=len(req):errors.append('build plan: duplicate requirement identity')
    for row in req:
        if row['delivery_task'] not in byid or row['acceptance_task'] not in byid:errors.append('build plan: unknown requirement task')
        elif byid[row['delivery_task']]['phase']>row['acceptance_phase']:errors.append('build plan: requirement delivered after acceptance')
    for row in screens:
        if row['delivery_task'] not in byid or row['acceptance_task'] not in byid:
            errors.append('build plan: unknown screen task')
        elif byid[row['delivery_task']]['phase']>byid[row['acceptance_task']]['phase']:
            errors.append('build plan: screen delivered after module acceptance')
    for filename,rows,fields in [('requirement_task_map.csv',req,REQ_FIELDS),('screen_task_map.csv',screens,SCREEN_FIELDS)]:
        path=root/INDEX/filename
        if not path.is_file() or path.read_text()!=csv_text(rows,fields):errors.append(f'build plan: stale or missing {filename}; review source changes then regenerate')
    path=root/INDEX/'AGENT_TASK_CARDS.md'
    if not path.is_file() or path.read_text()!=task_markdown(catalog):errors.append('build plan: stale or missing task cards')
    return errors,dict(build_tasks=len(tasks),requirement_units=len(req),screen_assignments=len(screens))

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--root',type=Path,default=ROOT);parser.add_argument('--write',action='store_true');args=parser.parse_args()
    root=args.root.resolve()
    if args.write:
        catalog,req,screens=expected(root)
        path=root/INDEX/'requirement_task_map.csv'
        if path.exists():
            old=list(csv.DictReader(io.StringIO(path.read_text())))
            missing={r['requirement_id'] for r in old}-{r['requirement_id'] for r in req}
            if missing:raise SystemExit(f'Refusing to drop {len(missing)} requirement IDs. Review/migrate renamed sections explicitly before regeneration; scope cannot disappear.')
        for name,rows,fields in [('requirement_task_map.csv',req,REQ_FIELDS),('screen_task_map.csv',screens,SCREEN_FIELDS)]:
            (root/INDEX/name).write_text(csv_text(rows,fields))
        (root/INDEX/'AGENT_TASK_CARDS.md').write_text(task_markdown(catalog))
    errors,counts=validate(root);print(json.dumps(dict(ok=not errors,counts=counts,errors=errors),indent=2));return bool(errors)

if __name__=='__main__':raise SystemExit(main())

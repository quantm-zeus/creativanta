#!/usr/bin/env python3
"""Build a design-only screen catalog from canonical docs."""
import csv, json, re
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
D=ROOT/"docs"
OUT=Path(__file__).resolve().parent
OUT.mkdir(exist_ok=True,parents=True)
features={p.relative_to(ROOT).as_posix():p.read_text(encoding="utf8") for p in sorted((D/"02_features").rglob("*.md"))}
def clean(s):
    s=re.sub(r"\[([^\]]+)\]\([^)]*\)",r"\1",s)
    for c in "*_>#|"+chr(96):s=s.replace(c,"")
    return " ".join(s.split()).strip()
def purpose(s):
    lines=s.splitlines()
    for i,l in enumerate(lines):
        if re.search(r"^#{2,3}\s+(?:\d+[.]\s*)?(Purpose|Overview|Description|Goal)",l,re.I):
            for x in lines[i+1:i+16]:
                if x.startswith("## "):break
                if len(clean(x))>50 and not x.startswith(("|","- ",">")):return clean(x)[:290]
    return next((clean(l)[:290] for l in lines[2:30] if len(clean(l))>80 and not l.startswith(("|",">"))),"")
def kind(s):
    s=s.lower()
    options=[
       ("login register forgot onboarding wizard setup form","form"),
       ("editor builder designer canvas composer video script","editor"),
       ("analytics report revenue profit finance ledger cost settlement","analytics"),
       ("calendar schedule","calendar"),
       ("list queue registry library inbox history orders transactions","table"),
       ("detail profile settings config management","detail"),
       ("dashboard home overview monitor radar","dashboard")]
    for terms,k in options:
        if any(t in s for t in terms.split()):return k
    return "workspace"
modules={}
for l in (D/"00_index"/"BUILD_INDEX.md").read_text(encoding="utf8").splitlines():
    if re.match(r"^\|\s*(M\d\d|auth|copilot|referral|help|gamification|S\d+)\s*\|",l):
        p=[clean(x) for x in l.strip("|").split("|")]
        if len(p)>=5:modules[p[0]]=dict(id=p[0],name=p[1],domain=p[2],feature=p[3],phase=p[4])
rows={}
with (D/"00_index"/"screen_task_map.csv").open(encoding="utf8",newline="") as f:
    for row in csv.DictReader(f):rows[row["source"]]=row
screens=[]
for platform in ("web","mobile","admin"):
    for p in sorted((D/"03_screens"/platform).glob("*.md")):
        rel=p.relative_to(ROOT).as_posix()
        s=p.read_text(encoding="utf8")
        first=next((clean(l.replace("# Screen:","")) for l in s.splitlines() if l.startswith("# Screen:")),p.stem)
        mid=re.search(r"Screen ID[*]*:\s*([A-Z]+\d+[a-z]?)",s)
        q=re.search(r"Route[*]*:\s*[\x60]([^\x60]+)[\x60]",s)
        headings=[clean(re.sub(r"^#{2,3}\s+(?:\d+[.]\s*)?","",l)) for l in s.splitlines() if l.startswith("## ")]
        screens.append(dict(id=mid.group(1) if mid else p.stem,title=first,platform=platform,
            module=rows.get(rel,{}).get("module","S26" if platform=="admin" else "unknown"),
            route=q.group(1) if q else "",purpose=purpose(s),sections=headings[:7],
            kind=kind(p.stem),source=rel))
data=dict(name="Creativanta",status="DESIGN_CONCEPT_NOT_IMPLEMENTED",modules=list(modules.values()),
    screens=screens,counts={p:sum(s["platform"]==p for s in screens) for p in ("web","mobile","admin")},
    note="Visual concepts only; fictional demo data, no API or accepted implementation.")
f=OUT/"catalog.json"
f.write_text(json.dumps(data,ensure_ascii=False,indent=2)+"\n",encoding="utf8")
print(json.dumps(dict(counts=data["counts"],modules=len(modules),bytes=f.stat().st_size)))

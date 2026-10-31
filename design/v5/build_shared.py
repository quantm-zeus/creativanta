#!/usr/bin/env python3
"""Standalone approved Go V5 design system library, interactive 12 patterns."""
from pathlib import Path
from html.parser import HTMLParser
import subprocess
D=Path(__file__).resolve().parent
src=D/'shared'
css=(src/'style.css').read_text(encoding='utf8')
js=(src/'app.js').read_text(encoding='utf8')
r=subprocess.run(['node','--check','-'],input=js,text=True,capture_output=True)
if r.returncode:raise RuntimeError(r.stderr)
html=(src/'index.html').read_text(encoding='utf8').replace('/*__CSS__*/',css).replace('/*__JS__*/',js)
assert html.count('class="pattern"')==12
HTMLParser().feed(html)
out=D/'dist'/'creativanta-v5-shared-system.html'
out.parent.mkdir(exist_ok=True)
out.write_text(html,encoding='utf8')
print('shared',12,'patterns',out.stat().st_size,out)

"""Compare file coverage and operator modes with the recorded review baseline.

This checks preservation of paths and enum values, not semantic equivalence.
"""
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[4]
EVIDENCE = Path(__file__).resolve().parent
BASELINE = json.loads((EVIDENCE / 'run_summary.json').read_text())['git_baseline']


def git(*args):
    return subprocess.check_output(['git', *args], cwd=ROOT, text=True)


def modes(value):
    body = re.search(r'CREATE TYPE operator_mode AS ENUM \((.*?)\);', value, re.S)[1]
    return re.findall(r"'([^']+)'", body)


old_features = set(git('ls-tree', '-r', '--name-only', BASELINE, '--', 'docs/02_features').splitlines())
new_features = {str(p.relative_to(ROOT)) for p in (ROOT / 'docs/02_features').rglob('*.md')}
old_screens = {p for p in git('ls-tree', '-r', '--name-only', BASELINE, '--', 'docs/03_screens').splitlines()
               if re.match(r'docs/03_screens/[^/]+/[^/]+\.md$', p)}
new_screens = {str(p.relative_to(ROOT)) for p in (ROOT / 'docs/03_screens').glob('*/*.md')}
old_schema = git('show', BASELINE + ':docs/04_contracts/database_schema.md')
new_schema = (ROOT / 'docs/04_contracts/database_schema.md').read_text()
result = {
    'operator_modes_unchanged': modes(old_schema) == modes(new_schema),
    'operator_modes': modes(new_schema),
    'all_feature_document_paths_retained': old_features <= new_features,
    'feature_spec_count': len(list((ROOT / 'docs/02_features').glob('*/*.md'))),
    'feature_status_index_retained': 'docs/02_features/_STATUS.md' in new_features,
    'original_screens_retained': old_screens <= new_screens,
    'original_screen_count': len(old_screens),
    'current_screen_count': len(new_screens),
}
result['ok'] = all(result[k] for k in ('operator_modes_unchanged', 'all_feature_document_paths_retained', 'original_screens_retained', 'feature_status_index_retained')) and result['feature_spec_count'] == 31
print(json.dumps(result, indent=2))
raise SystemExit(0 if result['ok'] else 1)

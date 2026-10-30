#!/usr/bin/env python3
"""Read-only checks for selected Creativanta documentation invariants.

This validates documentation, not application compilation, PostgreSQL runtime,
provider approval, legal sign-off, or complete semantic correctness of every RPC.
"""
from __future__ import annotations
import argparse
import csv
from collections import Counter
import json
import re
import sys
from pathlib import Path
from urllib.parse import unquote

sys.path.insert(0, str(Path(__file__).resolve().parent))
from build_plan import validate as validate_build_plan

ROOT = Path(__file__).resolve().parents[1]

def audit(root: Path) -> tuple[list[str], dict[str, int]]:
    docs = root / 'docs'
    errors: list[str] = []
    def require(ok: bool, message: str) -> None:
        if not ok:
            errors.append(message)
    def read(name: str) -> str:
        p = docs / name
        if not p.is_file():
            errors.append(f'missing canonical source: {name}')
            return ''
        return p.read_text()
    schema = read('04_contracts/database_schema.md')
    sql = '\n'.join(re.findall(r'```sql\s*\n(.*?)```', schema, re.S))
    matches = list(re.finditer(r'CREATE TABLE (\w+)\s*\(\n(.*?)\n\);', sql, re.S))
    tables = {m[1]: m[2] for m in matches}
    require(len(matches) == len(tables), 'duplicate CREATE TABLE names')
    index_counts=Counter(re.findall(r'CREATE (?:UNIQUE )?INDEX (\w+)',sql))
    for name,count in index_counts.items():require(count==1, f'duplicate index name {name}')
    columns = {t: set(re.findall(r'^  (\w+)\s+[A-Za-z]', body, re.M)) for t, body in tables.items()}
    for table,col in re.findall(r'ALTER TABLE (\w+) ADD COLUMN (\w+)',sql):columns.setdefault(table,set()).add(col)
    positions = {m[1]: m.start() for m in matches}
    tenant = {t for t, cols in columns.items() if 'workspace_id' in cols}
    for table in sorted(tenant):
        for clause in ['ENABLE', 'FORCE']:
            require(f'ALTER TABLE {table} {clause} ROW LEVEL SECURITY;' in sql,
                    f'{table}: missing {clause} RLS')
        require(bool(re.search(r'CREATE POLICY \w+ ON '+table+r'\b', sql)), f'{table}: missing direct policy')
    for m in matches:
        for col, parent, key in re.findall(r'^  (\w+) [^\n]*?REFERENCES (\w+)\((\w+)\)', m[2], re.M):
            require(parent in tables, f'{m[1]}.{col}: missing referenced table {parent}')
            require(key in columns.get(parent, set()), f'{m[1]}.{col}: missing parent key {parent}.{key}')
            require(parent == m[1] or positions.get(parent, -1) < m.start(), f'{m[1]}: forward FK to {parent}')
            if m[1] in tenant and parent in tenant and parent != 'workspaces':
                parent_pk = re.search(r'^  (\w+) \w+(?:\([^)]*\))? PRIMARY KEY', tables[parent], re.M)
                if parent_pk:
                    guard = rf'FOREIGN KEY \(workspace_id, {col}\) REFERENCES {parent}\(workspace_id, {key}\)'
                    require(bool(re.search(guard, sql)), f'{m[1]}.{col}: missing same-tenant FK')
    for field in ['tax_amount', 'tax_jurisdiction', 'tax_note', 'exchange_rate_snapshot', 'recognized_at']:
        require(field in columns.get('orders', set()), f'orders: missing {field}')
    for table in ['ai_credit_lots','ai_credit_quotes','ai_credit_reservations','ai_credit_reservation_allocations','consumer_inbox','external_effects','financial_postings','settlement_lines']:
        require(table in tables, f'missing durable contract table {table}')
    for table in ['trend_signals','opportunity_sources','idea_sources','taggables','bundle_items','support_ticket_messages']:
        require(table in tenant, f'{table}: junction/message is not directly tenant-scoped')
    require('seeding_costs' in columns.get('profit_snapshots',set()), 'profit projection omits seeding')
    require('event_id' in columns.get('event_outbox',set()), 'outbox lacks stable event identity')
    require(not re.search(r'GRANT ALL(?: PRIVILEGES)? ON (?:ALL TABLES|TABLES|\w+) TO app_user', sql), 'runtime role has blanket ALL grants')
    require("CREATE POLICY workspace_discovery ON workspaces FOR SELECT" in sql, 'missing SELECT-only membership discovery')
    require(not re.search(r'\b(?:amount|cost|price|credits|balance_after)\s+(?:REAL|FLOAT|DOUBLE PRECISION)\b', sql, re.I), 'floating point financial column')
    require(not re.search(r'^  (?:unit_price|discount|platform_fee|shipping_fee|total_fees): number;',schema,re.M), 'JSONB money must be decimal strings')

    api = read('04_contracts/api_endpoint_map.md')
    rpcs = re.findall(r'^\| `((\w+Service)/(\w+))` \|',api,re.M)
    rpc_set = {x[0] for x in rpcs}
    require(len(rpc_set) == len(rpcs), 'duplicate RPC inventory identity')
    binding_path = docs/'04_contracts/rpc_permission_bindings.csv'
    bindings=[]
    if binding_path.exists():
        with binding_path.open() as handle:bindings=list(csv.DictReader(handle))
    require({r['rpc'] for r in bindings} == rpc_set, 'RPC bindings and inventory differ')
    require(len(bindings) == len(rpc_set), 'missing/duplicate RPC binding rows')
    rbac = read('04_contracts/rbac_permission_matrix.md')
    permissions = set(re.findall(r'^\| `([^`]+)`',rbac,re.M))
    families = {'identity','query','command','generation','external','admin','public'}
    binding_by_rpc = {r['rpc']:r for r in bindings}
    for row in bindings:
        require(row['permission_key'] in permissions|{'PUBLIC'}, f"{row['rpc']}: unknown permission {row['permission_key']}")
        require(row['behavior_family'] in families, f"{row['rpc']}: unknown behavior family")
        require(not(row['permission_key']=='PUBLIC' and row['behavior_family'] not in {'identity','public'}), f"{row['rpc']}: public mutation binding")
    critical = {'PublishService/Execute':'publish:execute','PublishService/Schedule':'publish:schedule','ReconciliationService/Override':'reconciliation:override','CreditService/Purchase':'credits:top_up','BillingService/ChangePlan':'workspace:billing:manage'}
    for rpc,key in critical.items():require(binding_by_rpc.get(rpc,{}).get('permission_key')==key, f'{rpc}: sensitive permission drift')

    phases = read('00_index/IMPLEMENTATION_ORDER.md')
    phase_rows = re.findall(r'^\| (M\d\d|auth|copilot|referral|help|gamification|S\d\d) \| (P\d) \| (P\d) \|',phases,re.M)
    modules = {r[0] for r in phase_rows}
    expected = {f'M{i:02}' for i in range(1,24)}|{'auth','copilot','referral','help','gamification','S16','S24','S26'}
    require(modules==expected and len(phase_rows)==31, 'phase coverage must preserve all 31 modules/specs')
    for module,start,end in phase_rows:require('P0'<=start<=end<='P8',f'{module}: invalid phase range')
    index = read('00_index/BUILD_INDEX.md')
    for module,start,end in phase_rows:
        line = next((l for l in index.splitlines() if l.startswith('| '+module+' |')), '')
        value = start if start==end else start+'–'+end
        require(f'| {value} |' in line, f'{module}: Build Index phase mismatch')
    for p in (docs/'02_features').glob('*/*.md'):
        require(bool(re.search(r'^## (?:\d+\. )?(?:Acceptance Criteria|.*Acceptance)',p.read_text(),re.M|re.I)), f'{p.relative_to(root)}: missing acceptance section')

    env = read('06_quality_ops/docker_dev_environment.md')
    require('DATABASE_URL=postgresql://app_user:' in env, 'API sample DSN must use app_user')
    require(not re.search(r'^DATABASE_URL=postgresql://(?:creativanta|postgres):',env,re.M), 'API sample uses migration/superuser')
    require('ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL' not in env,'blanket default privileges in bootstrap')
    credit = read('04_contracts/credit_accounting_contract.md')
    require('30 minutes' in credit and 'reconciling' in credit and 'sweeper' in credit, 'credit recovery/lease contract incomplete')
    pricing = read('01_business/pricing_and_credits.md')
    require('Reservation TTL: 15' not in pricing and 'auto-release sau 15' not in pricing,'conflicting credit TTL')
    require('usd_per_credit_floor' in pricing and 'gross_margin_floor' in pricing,'cost-based quote floor missing')
    auth = read('02_features/platform/auth.md')
    require('refresh token (30d TTL)' not in auth and 'access token (JWT, 1h TTL)' not in auth,'Clerk model drift')
    examples = read('04_contracts/api_examples.md')
    require('"refresh_token"' not in examples,'login example invents application refresh token')
    for i, block in enumerate(re.findall(r'```json\s*\n(.*?)```',examples,re.S),1):
        clean = '\n'.join(l for l in block.splitlines() if not l.lstrip().startswith('//'))
        # Existing blocks group request/response objects; validate each object in sequence.
        decoder = json.JSONDecoder();pos=0
        try:
            while pos<len(clean):
                while pos<len(clean) and clean[pos].isspace():pos+=1
                if pos==len(clean):break
                _,pos=decoder.raw_decode(clean,pos)
        except ValueError as exc:errors.append(f'api_examples JSON block {i}: {exc}')

    for header in re.findall(r'^## A\.[^\n]+',examples,re.M):
        match=re.search(r'(\w+Service/\w+)',header)
        if match:require(match[1] in rpc_set,f'example references absent RPC {match[1]}')
    capability=read('02_features/platform/capability_matrix.md')
    require('| supported |' not in capability and '| unknown |' not in capability,'capability feature uses non-schema state')
    require('DEFAULT \'creating\'' in tables.get('characters',''),'character creation lifecycle default drift')
    for table in ['creator_progress','achievement_records','challenge_progress']:
        require('user_id' in columns.get(table,set()),f'{table}: per-user progress missing user identity')
    for table,field in [('sample_requests','outcome_status'),('sample_requests','follow_up_status'),('membership_plans','entitlement_config'),('membership_subscriptions','entitlement_snapshot'),('api_keys','logical_key_id')]:
        require(field in columns.get(table,set()),f'{table}: missing lifecycle/entitlement field {field}')

    # Actual local Markdown links, excluding code and external/anchor references.
    active_files = [p for p in docs.rglob('*.md') if '09_archive' not in p.parts and '_templates' not in p.parts]
    for p in active_files:
        body = re.sub(r'```.*?```','',p.read_text(),flags=re.S)
        for dest in re.findall(r'\]\((<?[^\n)]+>?)\)',body):
            dest=dest.strip().split(' "',1)[0].strip('<>')
            if not dest or dest.startswith(('#','http:','https:','mailto:','codex:','plugin:','app:')):continue
            dest=unquote(dest.split('#',1)[0])
            if not dest or any(c in dest for c in '*<>'):continue
            target=(p.parent/dest).resolve()
            require(target.exists(),f'{p.relative_to(root)}: broken local link {dest}')
    # Seed column identity must remain aligned with canonical tables.
    seed = read('06_quality_ops/seed_data.sql')
    for table,fields in re.findall(r'INSERT INTO (\w+)\s*\((.*?)\)\s*VALUES',seed,re.S):
        require(table in tables,f'seed: unknown table {table}')
        for field in fields.split(','):require(field.strip() in columns.get(table,set()),f'seed: unknown column {table}.{field.strip()}')

    # Review regressions: documentation can otherwise pass while teaching unsafe behavior.
    inventory = read('02_features/commerce/product_hub.md')
    require('SUM(delta)' not in inventory and not re.search(r'inventory_locations.{0,30}current_stock', inventory),
            'inventory feature references phantom stock columns')
    for table in ['inventory_balances','stock_reservations']:
        require(table in tenant, f'missing durable inventory table {table}')
    require('movement_key' in columns.get('stock_movements',set()), 'stock ledger lacks durable movement identity')
    require('CREATE UNIQUE INDEX idx_sm_identity ON stock_movements(workspace_id, movement_key)' in sql,
            'stock ledger lacks unique economic identity')
    require('GRANT SELECT, INSERT, UPDATE, DELETE ON stock_movements TO app_user' not in sql,
            'stock ledger runtime grant breaks immutability')
    require('onboarding_progress' in columns.get('user_preferences',set()), 'personal onboarding lacks self-scoped storage')
    require(binding_by_rpc.get('WorkspaceService/CompleteOnboarding',{}).get('permission_key')=='user:self',
            'personal onboarding permission drift')
    require("return `'unknown'` status" not in capability and 'Capability status = `unknown`' not in capability,
            'capability feature returns non-schema unknown enum')
    creator = read('02_features/commerce/creator_pro_tools.md')
    require('overrides (with AUP acknowledgment)' not in creator, 'phishing override remains in Creator Pro acceptance')
    studio = read('02_features/production/ai_video_studio.md')
    require('Block if > 70% transcript similarity' not in studio, 'conflicting remix similarity threshold')
    require('EF-07A' in studio and 'EF-11' in studio, 'retained production extension missing')
    for field in ['template_kind','template_version','template_payload']:
        require(field in columns.get('recipe_templates',set()),f'portable recipe snapshot missing {field}')
    require(not re.search(r'GRANT SELECT(?:,.*)? ON media_kits TO directory_reader',sql),
            'public directory must use column-scoped grants')
    require('CREATE POLICY public_directory_read ON media_kits FOR SELECT TO directory_reader' in sql,
            'public directory lacks explicit visibility policy')
    require('CREATE POLICY tenant_isolation ON media_kits TO app_user' in sql,
            'public directory must not inherit a permissive tenant policy')
    # Owner-authorized Go migration: historical ADR/evidence may mention Rust,
    # but current executable instructions must not send an agent to its tools.
    stack = read('05_system/tech_stack_adr.md')
    require('## ADR-015: Product-owner migration to Go' in stack and
            'net/http + ConnectRPC' in stack and 'pgx/v5 + sqlc' in stack,
            'Go backend decision missing from canonical stack')
    for path in ['04_contracts/protobuf_contracts.md', '04_contracts/rbac_permission_matrix.md',
                 '04_contracts/domain_event_catalog.md', '05_system/queue_retry_design.md',
                 '05_system/ai_provider_guide.md', '06_quality_ops/ci_cd_pipeline.md',
                 '06_quality_ops/docker_dev_environment.md']:
        text = read(path)
        require(not re.search(r'```rust\b|\bcargo\s|\b(?:Axum|Tokio|Tonic|Prost|SeaORM|SQLx|Tower)\b|rust-ffmpeg', text, re.I),
                f'{path}: legacy Rust runtime instruction after Go migration')
    proto = read('04_contracts/protobuf_contracts.md')
    for plugin in ['protoc-gen-go', 'protoc-gen-connect-go', 'protoc-gen-es', 'protoc-gen-dart']:
        require(f'local: {plugin}\n' in proto, f'Go transport generator missing: {plugin}')
    provider = read('05_system/ai_provider_guide.md')
    require(not re.search(r'\b(?:CostUSD|CostPer1MInput|CostPer1MOutput)(?:\(\))?\s+(?:float32|float64)\b', provider),
            'Go provider money must use exact decimal arithmetic')
    plan_errors,plan_counts=validate_build_plan(root)
    errors.extend(plan_errors)
    return errors, {'active_markdown':len(active_files),'tables':len(tables),'tenant_tables':len(tenant),'rpc_bindings':len(bindings),'modules':len(modules),**plan_counts}

def main() -> int:
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root',type=Path,default=ROOT)
    parser.add_argument('--json',action='store_true')
    parser.add_argument('--sql',action='store_true',help='also parse canonical SQL with optional pinned pglast')
    args=parser.parse_args();errors,counts=audit(args.root.resolve())
    if args.sql:
        try:
            from pglast import parse_sql
            schema=(args.root/'docs/04_contracts/database_schema.md').read_text()
            blocks=[b for b in re.findall(r'```sql\s*\n(.*?)```',schema,re.S) if '<table>' not in b]
            parse_sql('\n'.join(blocks))
            parse_sql((args.root/'docs/06_quality_ops/seed_data.sql').read_text())
            counts['parsed_sql_blocks']=len(blocks)
        except ImportError:errors.append('pglast missing: install tooling/requirements-docs.txt for --sql')
        except Exception as exc:errors.append(f'PostgreSQL grammar: {exc}')
    if args.json:print(json.dumps({'ok':not errors,'counts':counts,'errors':errors},indent=2))
    else:
        print('Documentation invariants: '+('PASS' if not errors else 'FAIL'))
        print(', '.join(f'{key}={value}' for key,value in counts.items()))
        for error in errors:print('ERROR: '+error)
        print('Static checks only; runtime, typed transport and external gates require separate evidence.')
    return bool(errors)

if __name__=='__main__':sys.exit(main())

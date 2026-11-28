"""Orchestrator check of the item round: reads .kritikk/ITEMS/<G>_checked.lua, reports problems, writes merged.json.

Usage: python tools/research/item_merge_check.py .kritikk/ITEMS WarcraftLore/Data.lua [groups, default ABCDEF]
"""
import json, re, sys
from pathlib import Path

import lupa.lua51 as lupa

sys.stdout.reconfigure(encoding="utf-8")
W, DATA = Path(sys.argv[1]), Path(sys.argv[2])
groups = sys.argv[3] if len(sys.argv) > 3 else "ABCDEF"
L = lupa.LuaRuntime()
ns = L.eval("{}")
L.eval("function(src,ns) assert(loadstring(src))('WarcraftLore', ns) end")(DATA.read_text(encoding="utf-8"), ns)
existing = {int(it.id): int(k) for k, e in ns.NPCS.items() for it in (e["items"] or {}).values()}
names = {int(k): e.name for k, e in ns.NPCS.items()}

HEAD = re.compile(r"^\s*--\s*\[(\d+)\]\s*(.*)$")
merged, problems = {}, []
for g in groups:
    f = W / f"{g}_checked.lua"
    if not f.exists():
        problems.append(f"{g}: no {f.name}")
        continue
    npc = None
    for n, line in enumerate(f.read_text(encoding="utf-8").splitlines(), 1):
        m = HEAD.match(line)
        if m:
            npc = int(m.group(1))
            if npc not in names:
                problems.append(f"{g}:{n} unknown NPC ID {npc}")
            continue
        s = line.strip().rstrip(",")
        if not s.startswith("{"):
            continue
        try:
            t = L.eval("(" + s + ")")
        except Exception as ex:
            problems.append(f"{g}:{n} does not parse: {ex}")
            continue
        it = {k: t[k] for k in ("id", "name", "note", "blurb", "gear")}
        it["group"] = g
        if npc is None:
            problems.append(f"{g}:{n} item before any -- [npcID] line")
            continue
        iid = it["id"]
        if not isinstance(iid, int) or (24300 <= iid < 200000):
            problems.append(f"{g}:{n} {it['name']}: id {iid} out of range (retail?)")
        if iid in existing:
            problems.append(f"{g}:{n} {it['name']} ({iid}): already in Data.lua under {names[existing[iid]]}")
        b = it["blurb"] or ""
        if len(b) > 120:
            problems.append(f"{g}:{n} {it['name']}: blurb {len(b)} chars")
        if not b or not it["note"]:
            problems.append(f"{g}:{n} {it['name']}: missing note/blurb")
        if re.search(r"\b(WC1|WC2|WC3|TFT|BTDP|FK)\b|Cataclysm|Legion|Shadowlands|Wrath|Burning Crusade", b):
            problems.append(f"{g}:{n} {it['name']}: blurb has a game code / later expansion: {b}")
        if not isinstance(it["gear"], bool):
            problems.append(f"{g}:{n} {it['name']}: gear is not true/false")
        merged.setdefault(npc, []).append(it)

# same item under several veterans (fine for e.g. Onyxia + Thrall turn-in, but look at each)
owners = {}
for npc, items in merged.items():
    for it in items:
        owners.setdefault(it["id"], []).append(npc)
for iid, ow in owners.items():
    if len(ow) > 1:
        problems.append(f"shared item {iid}: " + ", ".join(names.get(o, str(o)) for o in ow))
    dup = [o for o in set(ow) if ow.count(o) > 1]
    for o in dup:
        problems.append(f"duplicate item {iid} twice under {names.get(o)}")

total = sum(len(v) for v in merged.values())
print(f"{total} items for {len(merged)} veterans, gear {sum(i['gear'] is True for v in merged.values() for i in v)}")
for npc, items in sorted(merged.items(), key=lambda kv: -len(kv[1])):
    print(f"  {len(items):3} {names.get(npc, npc)}")
print(f"\n{len(problems)} problems")
for p in problems:
    print(" -", p)
(W / "merged.json").write_text(json.dumps({str(k): v for k, v in merged.items()}, ensure_ascii=False, indent=1),
                               encoding="utf-8")

"""Paste fixed entries over Data.lua entries by NPC ID, remove listed IDs, append new ones.
Usage: py -3 merge.py <fixed.lua> [--remove id,id] [--append-after-zone]
Entries in fixed.lua whose ID is not in Data.lua are appended at the end of ns.NPCS (before the closing brace).
"""
import re, sys
from pathlib import Path

DATA = Path(__file__).resolve().parents[2] / "WarcraftLore" / "Data.lua"


def blocks(text):
    lines = text.split("\n")
    out, cur = {}, None
    for i, l in enumerate(lines):
        m = re.match(r"^    \[(\d+)\] = \{", l)
        if m:
            cur = (int(m.group(1)), i)
            continue
        if cur and l.rstrip() == "    },":
            out[cur[0]] = (cur[1], i)
            cur = None
    return lines, out


src = DATA.read_text(encoding="utf-8")
lines, have = blocks(src)
fixed_lines, fixed = blocks(Path(sys.argv[1]).read_text(encoding="utf-8")) if sys.argv[1] != "-" else ([], {})
remove = set()
if "--remove" in sys.argv:
    remove = {int(x) for x in sys.argv[sys.argv.index("--remove") + 1].split(",") if x}

repl = {}
for nid, (a, b) in fixed.items():
    repl[nid] = fixed_lines[a:b + 1]
new = [n for n in repl if n not in have]
# rebuild bottom-up
for nid, (a, b) in sorted(have.items(), key=lambda kv: -kv[1][0]):
    if nid in remove:
        del lines[a:b + 1]
    elif nid in repl:
        lines[a:b + 1] = repl[nid]
if new:
    end = max(i for i, l in enumerate(lines) if l == "}")
    add = []
    for nid in new:
        add += repl[nid]
    lines[end:end] = add
DATA.write_text("\n".join(lines), encoding="utf-8", newline="")
print("replaced", sorted(n for n in repl if n in have), "added", new, "removed", sorted(remove & set(have)))

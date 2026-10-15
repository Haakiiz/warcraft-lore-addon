import os, sys
sys.path.insert(0, os.path.dirname(__file__))
from fonts import *
out = ["MOCK_WIDTHS = {"]
for kind in ("body", "title"):
    out.append(f'  {kind} = {{')
    for size in range(6, 31):
        parts = ",".join(f"[{cp}]={advance(kind, size, cp):.3f}" for cp in CODEPOINTS)
        out.append(f"    [{size}] = {{{parts}}},")
    out.append("  },")
out.append("}")
open(os.path.join(os.path.dirname(__file__), "widths.lua"), "w", encoding="utf8").write("\n".join(out))
print("widths.lua written")

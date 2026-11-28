"""Writes the approved item round into Data.lua (run once): .kritikk/ITEMS/merged_filtered.json + blurbs.json.
Usage: python tools/research/item_merge_apply.py
"""
import json, re
W = ".kritikk/ITEMS/"
m = json.load(open(W + "merged_filtered.json", encoding="utf-8"))
b = json.load(open(W + "blurbs.json", encoding="utf-8"))
p = "WarcraftLore/Data.lua"
s = open(p, encoding="utf-8").read()


def q(x):
    return '"' + x.replace("\\", "\\\\").replace('"', '\\"') + '"'


def line(it, bl):
    return (f'            {{ id = {it["id"]}, name = {q(it["name"])}, note = {q(it["note"])}, blurb = {q(bl)}, '
            f'gear = {"true" if it["gear"] else "false"} }},')


# veterans that had items before this round but are not in it
extra = {"3516": "In the novel Stormrage the Nightmare Lord tricks him with a vision of his dead son Valstann.",
         "2257": "Ogre warlord of the Stonemaul, whose ogres Sylvanas' banshees possessed to fight Varimathras."}
added = 0
for npc in sorted(set(m) | {"3516", "2257", "3391", "3660", "250660", "3057"}, key=int):
    m0 = re.search(r"\n    \[" + npc + r"\] = \{\n", s)
    assert m0, npc
    a = m0.end()
    e = s.index("\n    },\n", a)
    body = s[a:e]
    vb = (b.get(npc) or {}).get("blurb") or extra.get(npc)
    spec = (b.get(npc) or {}).get("items", {})
    new = [line(it, spec.get(str(it["id"])) or vb) for it in m.get(npc, [])]
    added += len(new)
    empty = re.search(r"\n        items = \{\},", body)
    full = re.search(r"\n        items = \{\n(.*?)\n        \},", body, re.S)
    if empty:
        rep = "\n        items = {\n" + "\n".join(new) + "\n        }," if new else empty.group(0)
        body = body[:empty.start()] + rep + body[empty.end():]
    elif full and "\n        sources" not in full.group(1):
        upd = []
        for l in full.group(1).splitlines():
            if "blurb =" not in l and l.strip().startswith("{ id"):
                l = l.rstrip().rstrip(",").rstrip()
                assert l.endswith("}"), l
                l = l[:-1].rstrip() + f", blurb = {q(vb)}, gear = false }},"
            upd.append(l)
        body = body[:full.start()] + "\n        items = {\n" + "\n".join(upd + new) + "\n        }," + body[full.end():]
    else:
        assert "\n        items" not in body, npc
        i = body.index("\n        sources = {")
        body = body[:i] + "\n        items = {\n" + "\n".join(new) + "\n        }," + body[i:]
    s = s[:a] + body + s[e:]
open(p, "w", encoding="utf-8").write(s)
print("added", added)

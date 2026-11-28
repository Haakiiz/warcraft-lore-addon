"""Orchestrator prep for the item round: candidate items for every veteran, from warcraft.wiki.gg.

Usage: py -3 -I tools/research/item_prep.py <workdir> <path to WarcraftLore/Data.lua>

For each veteran (Data.lua entries, merged by name) it fetches the NPC's wiki page (and "<page> (Classic)"),
every page that page links to, and for linked quest pages every item those quests link to. Item pages are
recognised by their {{#data:Itemtip ...|itemid=N}} block. Writes into <workdir>:
  _cache_pages.json         title -> [resolved title, wikitext]   (read with item_lookup.py)
  candidates.json           npcID -> {name, pages, items: [{name, id, slot, quality, variants, via}]}
Item IDs between 24300 and 199999 (Burning Crusade to Dragonflight) are dropped: retail-only.
"""
import json, re, sys, time, urllib.parse, urllib.request
from pathlib import Path

import lupa.lua51 as lupa

W, DATA = Path(sys.argv[1]), Path(sys.argv[2])
W.mkdir(parents=True, exist_ok=True)
API = "https://warcraft.wiki.gg/api.php?format=json&formatversion=2&"
UA = {"User-Agent": "WarcraftLoreAddonResearch/0.3 (personal project)"}
CACHE = W / "_cache_pages.json"
pages = json.loads(CACHE.read_text(encoding="utf-8")) if CACHE.exists() else {}


def api(q):
    for a in range(6):
        try:
            time.sleep(0.5)
            with urllib.request.urlopen(urllib.request.Request(API + q, headers=UA), timeout=60) as r:
                return json.load(r)
        except Exception as ex:
            print("retry", a, ex, file=sys.stderr)
            time.sleep(10 * (a + 1))
    raise RuntimeError(q)


def fetch(titles):
    todo = sorted({t for t in titles if t and t not in pages})
    for i in range(0, len(todo), 50):
        b = todo[i:i + 50]
        q = api("action=query&prop=revisions&rvprop=content&rvslots=main&redirects=1&titles="
                + urllib.parse.quote("|".join(b)))["query"]
        nm = {r["from"]: r["to"] for r in q.get("normalized", [])}
        rd = {r["from"]: r["to"] for r in q.get("redirects", [])}
        got = {p["title"]: p for p in q.get("pages", [])}
        for t in b:
            t3 = rd.get(nm.get(t, t), nm.get(t, t))
            p = got.get(t3)
            pages[t] = [t3, p["revisions"][0]["slots"]["main"]["content"]] if p and "revisions" in p else [None, ""]
        print(f"pages {i + len(b)}/{len(todo)}", file=sys.stderr)
        if (i // 50) % 20 == 19:
            CACHE.write_text(json.dumps(pages, ensure_ascii=False), encoding="utf-8")
    CACHE.write_text(json.dumps(pages, ensure_ascii=False), encoding="utf-8")


LINK = re.compile(r"\[\[([^\]|#<>{}]+)(?:#[^\]|]*)?(?:\|[^\]]*)?\]\]")
SKIP = re.compile(r"^(File|Image|Category|Template|User|wikipedia|wowpedia|Media|Special|Help|w|wp):", re.I)


def links(txt):
    out = []
    for m in LINK.finditer(txt):
        t = m.group(1).strip().replace("_", " ")
        if t and not SKIP.match(t):
            out.append(t[0].upper() + t[1:])
    return out


def item_info(txt):
    """Item data from an item page, or None. variants = data blocks present (base, Classic, Forever, SoD ...)."""
    if "Itemtip" not in txt:
        return None
    ids = re.findall(r"\|\s*itemid\s*=\s*(\d+)", txt)
    if not ids:
        return None
    first = re.search(r"\{\{#data:Itemtip(.*?)\n\}\}", txt, re.S)
    block = first.group(1) if first else txt

    def field(k):
        m = re.search(r"\|\s*" + k + r"\s*=\s*([^\n|]*)", block)
        return m.group(1).strip() if m else ""

    variants = ["base"] + re.findall(r"\{\{#data:#([^\n|}]+)", txt)
    return {"ids": sorted({int(i) for i in ids}), "slot": field("slot"), "quality": field("quality"),
            "qbegin": field("qbegin"), "variants": variants,
            "classic_only": "{{Classic only" in txt, "forever_tag": "Forever" in txt}


def is_quest(txt):
    return "{{Questbox" in txt


def keep_id(i):
    return i < 24300 or i >= 200000


# ---- veterans from Data.lua
L = lupa.LuaRuntime()
ns = L.eval("{}")
L.eval("function(src,ns) assert(loadstring(src))('WarcraftLore', ns) end")(DATA.read_text(encoding="utf-8"), ns)
vets = {}
for npcID, e in ns.NPCS.items():
    key = e.name
    srcs = [s for s in (e.sources or {}).values() if "warcraft.wiki.gg/wiki/" in s]
    title = urllib.parse.unquote(srcs[0].split("/wiki/", 1)[1]).replace("_", " ") if srcs else e.name
    v = vets.setdefault(key, {"name": e.name, "ids": [], "pages": [title, title + " (Classic)"],
                              "existing": []})
    v["ids"].append(int(npcID))
    for it in (e["items"] or {}).values():
        v["existing"].append(int(it.id))
print(len(vets), "veterans", file=sys.stderr)

# ---- hop 0: NPC pages
fetch([p for v in vets.values() for p in v["pages"]])
# ---- hop 1: everything those pages link to
hop1 = {}
for v in vets.values():
    ls = []
    for p in v["pages"]:
        ls += links(pages.get(p, [None, ""])[1])
    hop1[v["name"]] = sorted(set(ls))
fetch([t for ls in hop1.values() for t in ls])
# ---- hop 2: items linked from quest pages linked from the NPC page
hop2 = {}
for name, ls in hop1.items():
    q = {}
    for t in ls:
        txt = pages.get(t, [None, ""])[1]
        if is_quest(txt):
            q[t] = sorted(set(links(txt)))
    hop2[name] = q
fetch([t for q in hop2.values() for ls in q.values() for t in ls])

# ---- candidates
out = {}
total = 0
for v in vets.values():
    found = {}

    def add(title, via):
        rt, txt = pages.get(title, [None, ""])
        info = item_info(txt)
        if not info:
            return
        ids = [i for i in info["ids"] if keep_id(i)]
        if not ids:
            return
        c = found.setdefault(rt, {"name": rt, "ids": ids, "slot": info["slot"], "quality": info["quality"],
                                  "qbegin": info["qbegin"], "variants": info["variants"],
                                  "classic_only": info["classic_only"], "via": []})
        if via not in c["via"]:
            c["via"].append(via)

    for t in hop1[v["name"]]:
        add(t, "linked from NPC page")
    for qt, ls in hop2[v["name"]].items():
        qtxt = pages[qt][1]
        role = "quest"
        m_end = re.search(r"\|\s*end\s*=\s*([^\n]*)", qtxt)
        m_start = re.search(r"\|\s*start\s*=\s*([^\n]*)", qtxt)
        nm = re.escape(v["name"].split(" ")[-1])
        if m_end and re.search(nm, m_end.group(1)):
            role = "quest ends at NPC"
        elif m_start and re.search(nm, m_start.group(1)):
            role = "quest starts at NPC"
        for t in ls:
            add(t, f"{role}: {pages[qt][0]}")
    items = sorted(found.values(), key=lambda c: c["name"])
    total += len(items)
    out[str(min(v["ids"]))] = {"name": v["name"], "npc_ids": sorted(v["ids"]), "existing_item_ids": v["existing"],
                               "pages": [pages.get(p, [None])[0] for p in v["pages"] if pages.get(p, [None])[0]],
                               "items": items}
(W / "candidates.json").write_text(json.dumps(out, ensure_ascii=False, indent=1), encoding="utf-8")
print(f"{total} candidate items for {len(out)} veterans", file=sys.stderr)

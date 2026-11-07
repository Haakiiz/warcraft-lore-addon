"""Find NEW WoW Forever NPCs that may be Warcraft RTS or book veterans (orchestrator step, no AI involved).

Usage:
    python3 -I tools/research/forever_scan.py <workdir> [--seen tools/research/forever_seen.json]

What it does, in order:
 1. Reads three sources on warcraft.wiki.gg:
    - the Forever NPC datamine (page "User:Mordecay/Forever/NPCs": every new Forever NPC with its ID)
    - pages in the categories "Forever NPCs" and "Forever mobs"
    - character pages that use the templates Forever-section / Forever-inline / Forever only
 2. Drops everything listed in the seen file (already decided in earlier runs) and DNT/kill-credit helpers.
 3. Writes <workdir>/npcs_NEW.json and runs prep_candidates.py on it, which fetches the wiki pages, builds the
    book index and writes <workdir>/candidates_NEW.json (only NPCs with a lore signal).
 4. Marks candidates whose name (or name without a title) is already in Data.lua, and adds each candidate's
    Forever NPC IDs from the datamine.

After the AI workers have decided the candidates, add every decided name to the seen file:
    python3 -I tools/research/forever_scan.py <workdir> --mark-seen
so the next run only looks at what the wiki added since.
"""
import json
import re
import subprocess
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
API = "https://warcraft.wiki.gg/api.php?format=json&formatversion=2&"
UA = {"User-Agent": "WarcraftLoreAddonResearch/0.2 (personal project)"}
DATAMINE_PAGE = "User:Mordecay/Forever/NPCs"
HELPER = re.compile(r"DNT|Stalker|Kill Credit|Trigger|Bunny|Dummy|Camera|Vehicle|^\(", re.I)


def api(q):
    for attempt in range(5):
        try:
            time.sleep(0.5)
            with urllib.request.urlopen(urllib.request.Request(API + q, headers=UA), timeout=60) as r:
                return json.load(r)
        except Exception as ex:  # network hiccup: wait and retry
            print("retry", attempt, ex, file=sys.stderr)
            time.sleep(5 * (attempt + 1))
    raise RuntimeError(q)


def listing(kind, prefix, title):
    out, cont = [], ""
    while True:
        j = api(f"action=query&list={kind}&{prefix}limit=500&{prefix}namespace=0&{prefix}title="
                + urllib.parse.quote(title) + cont)
        out += [p["title"] for p in j["query"][kind]]
        if "continue" not in j:
            return out
        key = prefix + "continue"
        cont = f"&{key}=" + urllib.parse.quote(j["continue"][key])


def datamine():
    t = api("action=parse&prop=wikitext&page=" + urllib.parse.quote(DATAMINE_PAGE))["parse"]["wikitext"]
    rows = {}
    for m in re.finditer(r"^\*\s*\[\[([^\]|]+)(?:\|[^\]]*)?\]\]\s*,\s*(\d+)", t, re.M):
        name, npc_id = m.group(1).strip(), int(m.group(2))
        if not HELPER.search(name):
            rows.setdefault(name, []).append(npc_id)
    return rows


def main():
    work = Path(sys.argv[1])
    work.mkdir(parents=True, exist_ok=True)
    seen_f = Path(sys.argv[sys.argv.index("--seen") + 1]) if "--seen" in sys.argv else REPO / "tools/research/forever_seen.json"
    seen = set(json.loads(seen_f.read_text(encoding="utf-8"))) if seen_f.exists() else set()

    # Names on the watch list (a book namesake with no Forever location yet) are never marked seen,
    # so every run looks at them again until the wiki says where they stand.
    watch_f = REPO / "tools/research/forever_watch.json"
    watch = set(json.loads(watch_f.read_text(encoding="utf-8"))) if watch_f.exists() else set()

    if "--mark-seen" in sys.argv:
        new = json.loads((work / "npcs_NEW.json").read_text(encoding="utf-8"))
        seen |= {n["name"] for n in new} - watch
        seen_f.write_text(json.dumps(sorted(seen), ensure_ascii=False, indent=0), encoding="utf-8")
        print(f"seen file now holds {len(seen)} names")
        return

    ids = datamine()
    items = {name: {"id": v[0], "name": name, "tag": "datamine", "ids": v} for name, v in ids.items()}
    for cat in ("Forever NPCs", "Forever mobs"):
        for t in listing("categorymembers", "cm", "Category:" + cat):
            items.setdefault(t, {"id": 0, "name": t, "tag": "category", "ids": []})
    for tpl in ("Forever-section", "Forever-inline", "Forever only"):
        for t in listing("embeddedin", "ei", "Template:" + tpl):
            items.setdefault(t, {"id": 0, "name": t, "tag": "template", "ids": []})
    new = [v for k, v in items.items() if k not in seen]
    print(f"datamine {len(ids)} names, {len(items)} names in all, {len(new)} not seen before", file=sys.stderr)
    (work / "npcs_NEW.json").write_text(json.dumps(new, ensure_ascii=False), encoding="utf-8")
    for f in work.glob("candidates_*.json"):
        f.unlink()
    subprocess.run([sys.executable, "-I", str(REPO / "tools/research/prep_candidates.py"), str(work),
                    str(REPO / "WarcraftLore/Data.lua")], check=True)

    data = (REPO / "WarcraftLore/Data.lua").read_text(encoding="utf-8")
    have = {n.lower() for n in re.findall(r'name = "([^"]+)"', data)}

    def known(name):
        n = name.lower()
        bare = re.sub(r"\s*\(.*\)$", "", n)
        return n in have or bare in have or any(h.endswith(" " + bare) for h in have)

    cand = json.loads((work / "candidates_NEW.json").read_text(encoding="utf-8"))
    for c in cand:
        c["already_in_Data_lua"] = known(c["name"]) or bool(c.get("wiki_title") and known(c["wiki_title"]))
        c["forever_ids"] = ids.get(c["name"], [])
    (work / "candidates_NEW.json").write_text(json.dumps(cand, ensure_ascii=False, indent=1), encoding="utf-8")
    fresh = [c for c in cand if not c["already_in_Data_lua"]]
    print(f"{len(cand)} candidates, {len(fresh)} not in Data.lua yet -> {work / 'candidates_NEW.json'}")


if __name__ == "__main__":
    main()

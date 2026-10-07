"""Which zone NPCs are linked from any WC1/WC2/WC3 mission page on warcraft.wiki.gg?"""
import json
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path

HERE = Path(__file__).parent
API = "https://warcraft.wiki.gg/api.php?format=json&"
UA = {"User-Agent": "WarcraftLoreAddonResearch/0.1 (personal project)"}
CATS = [
    "Warcraft III: Reign of Chaos demo campaign", "Warcraft III: Reign of Chaos human campaign",
    "Warcraft III: Reign of Chaos night elf campaign", "Warcraft III: Reign of Chaos orc campaign",
    "Warcraft III: Reign of Chaos undead campaign", "Warcraft III: The Frozen Throne blood elf campaign",
    "Warcraft III: The Frozen Throne night elf campaign", "Warcraft III: The Frozen Throne orc campaign",
    "Warcraft III: The Frozen Throne undead campaign", "Warcraft II: Tides of Darkness orc campaign",
    "Warcraft II: Tides of Darkness human campaign", "Warcraft II: Beyond the Dark Portal orc campaign",
    "Warcraft II: Beyond the Dark Portal human campaign", "Warcraft: Orcs & Humans human campaign",
    "Warcraft: Orcs & Humans orc campaign", "Warcraft II: Tides of Darkness demo campaign",
    "Warcraft III Reforged: Forsaken Kingdom human campaign", "Warcraft III Reforged: Forsaken Kingdom undead campaign",
]


def api(q):
    for attempt in range(6):
        try:
            time.sleep(0.8)
            with urllib.request.urlopen(urllib.request.Request(API + q, headers=UA), timeout=30) as r:
                return json.load(r)
        except Exception as ex:  # 429 etc.
            print("retry", attempt, ex, file=sys.stderr)
            time.sleep(10 * (attempt + 1))
    raise RuntimeError(q)


def members(cat):
    out, cont = [], ""
    while True:
        j = api("action=query&list=categorymembers&cmlimit=500&cmtitle=" + urllib.parse.quote("Category:" + cat) + cont)
        out += [m["title"] for m in j["query"]["categorymembers"] if m["ns"] == 0]
        if "continue" not in j:
            return out
        cont = "&cmcontinue=" + urllib.parse.quote(j["continue"]["cmcontinue"])


names = {}
for z in sys.argv[1:]:
    for n in json.loads((HERE / f"npcs_{z}.json").read_text(encoding="utf-8")):
        names.setdefault(n["name"], (z, n["id"]))

resolved = {}
lst = list(names)
for i in range(0, len(lst), 50):
    batch = lst[i:i + 50]
    j = api("action=query&redirects=1&titles=" + urllib.parse.quote("|".join(batch)))
    rd = {r["from"]: r["to"] for r in j["query"].get("redirects", [])}
    nm = {r["from"]: r["to"] for r in j["query"].get("normalized", [])}
    for n in batch:
        t = nm.get(n, n)
        resolved[rd.get(t, t)] = n

missions = []
for c in CATS:
    missions += members(c)
print("missions:", len(missions), file=sys.stderr)

hits = {}
for m in missions:
    cont = ""
    while True:
        j = api("action=query&list=backlinks&bllimit=500&blnamespace=0&blredirect=1&bltitle=" + urllib.parse.quote(m) + cont)
        for b in j["query"]["backlinks"]:
            if b["title"] in resolved:
                hits.setdefault(resolved[b["title"]], set()).add(m)
            for r in b.get("redirlinks", []):
                if r["title"] in resolved:
                    hits.setdefault(resolved[r["title"]], set()).add(m)
        if "continue" not in j:
            break
        cont = "&blcontinue=" + urllib.parse.quote(j["continue"]["blcontinue"])

for name, ms in sorted(hits.items()):
    print(names[name], name, "<-", "; ".join(sorted(ms)))

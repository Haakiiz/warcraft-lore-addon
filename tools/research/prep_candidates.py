"""Orchestrator prep: fetch wikitext for every zone NPC, flag candidates, build a reverse book index.
Usage: py -3 -I prep_candidates.py <workdir with npcs_*.json> <path to WarcraftLore/Data.lua>
Writes _pages.json, _books.json and candidates_<zoneId>.json into the work dir (read them with lookup.py).
"""
import json, re, sys, time, urllib.parse, urllib.request
from pathlib import Path

W = Path(sys.argv[1])
API = "https://warcraft.wiki.gg/api.php?format=json&formatversion=2&"
UA = {"User-Agent": "WarcraftLoreAddonResearch/0.2 (personal project)"}


def api(q):
    for a in range(6):
        try:
            time.sleep(0.8)
            with urllib.request.urlopen(urllib.request.Request(API + q, headers=UA), timeout=60) as r:
                return json.load(r)
        except Exception as ex:
            print("retry", a, ex, file=sys.stderr)
            time.sleep(10 * (a + 1))
    raise RuntimeError(q)


def fetch_pages(titles):
    """title -> (resolved title, wikitext)"""
    out = {}
    for i in range(0, len(titles), 50):
        b = titles[i:i + 50]
        j = api("action=query&prop=revisions&rvprop=content&rvslots=main&redirects=1&titles="
                + urllib.parse.quote("|".join(b)))
        q = j["query"]
        nm = {r["from"]: r["to"] for r in q.get("normalized", [])}
        rd = {r["from"]: r["to"] for r in q.get("redirects", [])}
        pages = {p["title"]: p for p in q.get("pages", [])}
        for t in b:
            t2 = nm.get(t, t)
            t3 = rd.get(t2, t2)
            p = pages.get(t3)
            if p and "revisions" in p:
                out[t] = (t3, p["revisions"][0]["slots"]["main"]["content"])
        print(f"pages {i + len(b)}/{len(titles)}", file=sys.stderr)
    return out


def members(cat):
    out, cont = [], ""
    while True:
        j = api("action=query&list=categorymembers&cmlimit=500&cmtitle=" + urllib.parse.quote("Category:" + cat) + cont)
        out += [m["title"] for m in j["query"]["categorymembers"] if m["ns"] == 0]
        if "continue" not in j:
            return out
        cont = "&cmcontinue=" + urllib.parse.quote(j["continue"]["cmcontinue"])


GENERIC = ("Forsaken|Orc|Human|Tauren|Dwarf|Deceased|Goblin|Night elf|Jungle troll|Warrior|Gnome|Mage|Quilboar|Warlock|Shaman|"
           "Rogue|Priest|Druid|Hunter|Gnoll|Ratchet|Worgen|Dark Iron dwarf|Murloc|Centaur|Undead|Satyr|Kobold|Ogre|Furbolg|Paladin|"
           "Dark Iron clan|Naga|Stealthed|Partially-sighted|High elf|Visually impaired|Blind|Hidden|Oddly classified|Blood elf|"
           "Death knight|Draenei|Argent Crusade|Booty Bay|Elf|Earthen|Gadgetzan|Vulpera|Drogbar|Forest troll|Sand troll|Monk|"
           "Darkfallen|Zandalari troll|Mount Journal|Pet Journal|Smokywood Pastures|Legends|World of Warcraft: The Comic|"
           "World of Warcraft: Ashbringer|The Sunwell Trilogy|Heroes of the Storm|Warcraft Adventures|RPG|Curse of the Worgen|Dark Riders|"
           "Troll|Tauren|Ice troll|Harpy|Trogg|Bear|Wolf|Ghoul|Banshee|Skeleton")
SIG = [
    (re.compile(r"\{\{\s*(novel|short ?story|story|novella)-section", re.I), "section-template"),
    (re.compile(r"\[\[Category:(?!(?:" + GENERIC + r") characters)[^\]]*characters\]\]", re.I), "book-or-game-characters-category"),
    (re.compile(r"Warcraft II\b|Warcraft III|Tides of Darkness|Beyond the Dark Portal|Reign of Chaos|Frozen Throne|"
                r"Orcs & Humans|\(WC1|\(WC2|\(WC3|Forsaken Kingdom", re.I), "rts-words"),
    (re.compile(r"<ref[^>]*>[^<]*''\[\[[^\]]+\]\]''", re.I), "italic-ref"),
    (re.compile(r"\{\{\s*(Book|Novel|Short story)\s*\|", re.I), "book-cite-template"),
]

# 1. NPC pages
zones = {}
for f in W.glob("npcs_*.json"):
    zones[f.stem[5:]] = json.loads(f.read_text(encoding="utf-8"))
names = sorted({n["name"] for z in zones.values() for n in z})
cache_f = W / "_pages.json"
pages = json.loads(cache_f.read_text(encoding="utf-8")) if cache_f.exists() else {}
todo = [n for n in names if n not in pages]
for k, v in fetch_pages(todo).items():
    pages[k] = v
for n in todo:
    pages.setdefault(n, None)
cache_f.write_text(json.dumps(pages, ensure_ascii=False), encoding="utf-8")

# 2. Reverse book index: every novel / short story / novella page, Characters section
books_f = W / "_books.json"
if books_f.exists():
    books = json.loads(books_f.read_text(encoding="utf-8"))
else:
    titles = set()
    for c in ["Novels", "Short stories", "Novellas", "Official short stories", "Audio dramas", "Warcraft novels",
              "Short stories by Blizzard Entertainment", "Warcraft short stories"]:
        try:
            titles |= set(members(c))
        except Exception as ex:
            print("cat fail", c, ex, file=sys.stderr)
    first = fetch_pages(["Novels", "Short stories", "Novellas", "Short story"])
    for t, (_, txt) in first.items():
        titles |= {x.strip() for x in re.findall(r"\[\[([^\]|#]+)", txt) if ":" not in x}
    for v in pages.values():
        if v:
            for c in re.findall(r"\[\[Category:([^\]|]*) characters\]\]", v[1]):
                if not re.fullmatch(GENERIC, c, re.I):
                    titles.add(c)
    print("book pages:", len(titles), file=sys.stderr)
    bp = fetch_pages(sorted(titles))
    books = {t: v[1] for t, v in bp.items()}
    books_f.write_text(json.dumps(books, ensure_ascii=False), encoding="utf-8")


def char_section(txt):
    m = re.search(r"==\s*Characters\s*==(.*?)(\n==[^=]|\Z)", txt, re.S | re.I)
    return m.group(1) if m else ""


book_chars = {}
for t, txt in books.items():
    sec = char_section(txt)
    if not sec:
        continue
    cur = ""
    for line in sec.splitlines():
        h = re.match(r"\s*(=+|;|'''?)\s*([^=']+?)\s*(=+|'''?)?\s*$", line)
        if line.startswith("=") or line.startswith(";"):
            cur = line.strip("=; '")
        for link in re.findall(r"\[\[([^\]|#]+)(?:[^\]]*)\]\]", line):
            book_chars.setdefault(link.strip().lower(), []).append((t, cur, line.strip()[:200]))

# 3. Per-zone candidate files
existing = set(int(x) for x in re.findall(r"^\s*\[(\d+)\]\s*=", Path(sys.argv[2]).read_text(encoding="utf-8"), re.M))
for zid, npcs in zones.items():
    lines, seen = [], set()
    for n in npcs:
        if n["name"] in seen:
            continue
        seen.add(n["name"])
        pg = pages.get(n["name"])
        title, txt = (pg if pg else (None, ""))
        sig = [lab for rx, lab in SIG if rx.search(txt)]
        rev = book_chars.get(n["name"].lower(), []) + (book_chars.get(title.lower(), []) if title and title != n["name"] else [])
        if not sig and not rev:
            continue
        ex = []
        for rx, lab in SIG:
            for m in rx.finditer(txt):
                ex.append(f"  [{lab}] ...{txt[max(0, m.start() - 150):m.end() + 600]}...".replace("\n", " "))
                break
        lines.append({
            "id": n["id"], "name": n["name"], "tag": n["tag"], "wiki_title": title,
            "already_in_Data_lua": n["id"] in existing,
            "signals": sig, "reverse_book_hits": [f"{b} | {sec} | {l}" for b, sec, l in rev[:10]],
            "excerpts": ex,
        })
    (W / f"candidates_{zid}.json").write_text(json.dumps(lines, ensure_ascii=False, indent=1), encoding="utf-8")
    print(zid, len(npcs), "npcs ->", len(lines), "candidates;", sum(1 for x in lines if not x["already_in_Data_lua"]), "new")

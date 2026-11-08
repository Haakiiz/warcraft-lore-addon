"""Reverse check: which Warcraft RTS / book characters are named in WoW Forever content? (no AI involved)

Usage:
    python3 -I tools/research/forever_mentions.py <workdir>              # find new mentions
    python3 -I tools/research/forever_mentions.py <workdir> --mark-seen  # after the screeners decided them
Characters on tools/research/forever_mentions_seen.json were decided before and are skipped.

Needs <workdir>/_books.json from forever_scan.py / prep_candidates.py (the book index); run that first.
Builds a dictionary of character names (Warcraft II/III/Reforged campaign characters and every character linked in a
book's ==Characters== section), then searches every Forever quest page, every Forever NPC/mob page and the
==Forever== section of every page that uses the Forever-section template. Names already in Data.lua or
Memorials.lua are skipped, and only names whose wiki page is a character page are kept.
Writes <workdir>/mentions.json: [{character, sources, categories, docs, hits: [[document, snippet], ...]}].
Most hits are only MENTIONS (Arthas, Illidan ...). An AI screener decides which ones are NPCs a Forever player
meets; see .kritikk/FOREVER_SCAN_RUNBOOK.md.
"""
import collections
import json
import re
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
API = "https://warcraft.wiki.gg/api.php?format=json&formatversion=2&"
UA = {"User-Agent": "WarcraftLoreAddonResearch/0.2 (personal project)"}
GENERIC = re.compile(r"^(Human|Orc|Dwarf|Gnome|Night elf|Tauren|Troll|Undead|Forsaken|Alliance|Horde|Scourge|"
                     r"Burning Legion|Kirin Tor|Dalaran|Lordaeron|Stormwind|Ironforge|Azeroth|Elune|Light|"
                     r"Footman|Peasant|Grunt|Peon)$", re.I)


def api(q):
    for attempt in range(5):
        try:
            time.sleep(0.5)
            with urllib.request.urlopen(urllib.request.Request(API + q, headers=UA), timeout=60) as r:
                return json.load(r)
        except Exception as ex:
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


def texts(titles):
    out = {}
    for i in range(0, len(titles), 50):
        j = api("action=query&prop=revisions&rvprop=content&rvslots=main&redirects=1&titles="
                + urllib.parse.quote("|".join(titles[i:i + 50])))
        for p in j["query"].get("pages", []):
            if "revisions" in p:
                out[p["title"]] = p["revisions"][0]["slots"]["main"]["content"]
    return out


def categories(titles):
    out = {}
    for i in range(0, len(titles), 50):
        chunk = titles[i:i + 50]
        j = api("action=query&prop=categories&cllimit=max&redirects=1&titles=" + urllib.parse.quote("|".join(chunk)))
        q = j["query"]
        nm = {r["from"]: r["to"] for r in q.get("normalized", [])}
        rd = {r["from"]: r["to"] for r in q.get("redirects", [])}
        pc = {p["title"]: [c["title"][9:] for c in p.get("categories", [])] for p in q["pages"]}
        for t in chunk:
            t2 = nm.get(t, t)
            out[t] = pc.get(rd.get(t2, t2), [])
    return out


def strip(t):
    return re.sub(r"\s*\([^)]*\)$", "", t).strip()


def main():
    work = Path(sys.argv[1])
    seen_f = REPO / "tools/research/forever_mentions_seen.json"
    seen = set(json.loads(seen_f.read_text(encoding="utf-8"))) if seen_f.exists() else set()
    if "--mark-seen" in sys.argv:
        seen |= {r["character"] for r in json.loads((work / "mentions.json").read_text(encoding="utf-8"))}
        seen_f.write_text(json.dumps(sorted(seen), ensure_ascii=False, indent=0), encoding="utf-8")
        print(f"{len(seen)} characters marked as decided")
        return
    books = json.loads((work / "_books.json").read_text(encoding="utf-8"))

    # 1. Dictionary: RTS campaign characters + book Characters sections.
    names = collections.defaultdict(set)
    for cat in ("Warcraft III campaign heroes", "Warcraft III campaign human heroes", "Warcraft III campaign orc heroes",
                "Warcraft III campaign undead heroes", "Warcraft III campaign night elf heroes",
                "Warcraft III campaign naga heroes", "Warcraft III campaign neutral heroes",
                "Tides of Darkness characters", "Beyond the Dark Portal characters", "Lord of the Clans characters",
                "Day of the Dragon characters"):
        for t in listing("categorymembers", "cm", "Category:" + cat):
            names[strip(t)].add("RTS" if "Warcraft III" in cat or "Darkness" in cat or "Portal" in cat else "BOOK:" + cat)
    for title, txt in books.items():
        m = re.search(r"==\s*Characters\s*==(.*?)(\n==[^=]|\Z)", txt, re.S | re.I)
        for link in re.findall(r"\[\[([^\]|#]+)(?:\|[^\]]*)?\]\]", m.group(1) if m else ""):
            if ":" not in link:
                names[strip(link)].add("BOOK:" + title)
    names = {n: v for n, v in names.items()
             if n and n[0].isupper() and not GENERIC.match(n) and (" " in n or len(n) >= 6)}

    # 2. Corpus: Forever quests, Forever NPC/mob pages, the Forever section of template pages.
    quests = listing("categorymembers", "cm", "Category:Forever quests")
    npcs = listing("categorymembers", "cm", "Category:Forever NPCs") + listing("categorymembers", "cm", "Category:Forever mobs")
    sect = listing("embeddedin", "ei", "Template:Forever-section")
    corpus = {}
    for t, x in texts(quests).items():
        corpus["QUEST: " + t] = x
    for t, x in texts(npcs).items():
        corpus["FOREVER-NPC: " + t] = x
    for t, x in texts(sect).items():
        m = re.search(r"==\s*(?:In )?Forever\s*==(.*?)(\n==[^=]|\Z)", x, re.S | re.I)
        if m:
            corpus["FOREVER-SECTION: " + t] = m.group(1)

    # 3. Search, skip what the addon already has.
    have = set(re.findall(r'name = "([^"]+)"', (REPO / "WarcraftLore/Data.lua").read_text(encoding="utf-8")
                          + (REPO / "WarcraftLore/Memorials.lua").read_text(encoding="utf-8")))

    def known(n):
        return n in have or any(h.endswith(" " + n) or h.startswith(n + " ") for h in have)

    hits = collections.defaultdict(list)
    for n in names:
        if known(n) or n in seen:
            continue
        rx = re.compile(r"(?<![\w'])" + re.escape(n) + r"(?![\w'])")
        for doc, x in corpus.items():
            if strip(doc.split(": ", 1)[1]) == n:
                continue
            m = rx.search(x)
            if m:
                hits[n].append([doc, x[max(0, m.start() - 160):m.end() + 200].replace("\n", " ")])
    cats = categories(sorted(hits))
    rows = []
    for n, h in hits.items():
        cs = cats.get(n, [])
        if any(c.endswith("characters") for c in cs):
            rows.append({"character": n, "sources": sorted(names[n])[:6],
                         "categories": [c for c in cs if c.endswith("characters")][:8], "docs": len(h), "hits": h[:6]})
    rows.sort(key=lambda r: -r["docs"])
    (work / "mentions.json").write_text(json.dumps(rows, ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"{len(corpus)} Forever texts, {len(names)} lore names, {len(rows)} characters named but not in the addon "
          f"-> {work / 'mentions.json'}")


if __name__ == "__main__":
    main()

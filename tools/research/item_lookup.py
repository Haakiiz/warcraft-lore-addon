"""Read cached wiki pages for the item round, so nothing gets cut off.

  py -3 -I tools/research/item_lookup.py <workdir> page "<page title>" [...]   full wikitext of a page
  py -3 -I tools/research/item_lookup.py <workdir> npc <npcID>                 the veteran's candidate list
  py -3 -I tools/research/item_lookup.py <workdir> grep "<text>" "<page>"      lines of a page containing text

Pages not in the cache: fetch https://warcraft.wiki.gg/index.php?title=<Title>&action=raw
"""
import json, sys
from pathlib import Path

sys.stdout.reconfigure(encoding="utf-8")
W, cmd, args = Path(sys.argv[1]), sys.argv[2], sys.argv[3:]
pages = json.loads((W / "_cache_pages.json").read_text(encoding="utf-8"))
if cmd == "page":
    for t in args:
        p = pages.get(t) or next((v for k, v in pages.items() if v[0] == t), None)
        print(f"===== {t} -> {p[0] if p and p[0] else 'NOT CACHED / NO PAGE'}")
        if p:
            print(p[1])
elif cmd == "npc":
    c = json.loads((W / "candidates.json").read_text(encoding="utf-8"))
    print(json.dumps(c.get(args[0]), ensure_ascii=False, indent=1))
elif cmd == "grep":
    needle, t = args[0].lower(), args[1]
    p = pages.get(t) or next((v for k, v in pages.items() if v[0] == t), None)
    for line in (p[1] if p else "").splitlines():
        if needle in line.lower():
            print(line)

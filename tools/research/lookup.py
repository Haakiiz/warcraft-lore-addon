"""Read cached wiki text for workers, so nothing gets cut off by head/tail.

  py -3 -I lookup.py <workdir> page "<NPC name>"      full NPC wiki page (from _pages.json)
  py -3 -I lookup.py <workdir> books "<name>" [...]   every line in any book page (_books.json) that mentions a name
  py -3 -I lookup.py <workdir> book "<book title>"    the ==Characters== section (or whole page) of one book

Names are matched case-insensitively; for "books", also try the surname or first name on its own.
"""
import json
import re
import sys
from pathlib import Path

sys.stdout.reconfigure(encoding="utf-8")
W, cmd, args = Path(sys.argv[1]), sys.argv[2], sys.argv[3:]

if cmd == "page":
    pages = json.loads((W / "_pages.json").read_text(encoding="utf-8"))
    for name in args:
        p = pages.get(name)
        print(f"===== {name} -> {p[0] if p else 'NO WIKI PAGE'}")
        if p:
            print(p[1])
elif cmd == "books":
    books = json.loads((W / "_books.json").read_text(encoding="utf-8"))
    for name in args:
        rx = re.compile(re.escape(name), re.I)
        print(f"===== '{name}'")
        n = 0
        for title, txt in sorted(books.items()):
            for line in txt.splitlines():
                if rx.search(line):
                    print(f"[{title}] {line.strip()[:400]}")
                    n += 1
        print(f"({n} lines)")
elif cmd == "book":
    books = json.loads((W / "_books.json").read_text(encoding="utf-8"))
    for title in args:
        txt = books.get(title)
        if txt is None:
            print(f"===== {title}: not cached; fetch https://warcraft.wiki.gg/index.php?title=...&action=raw")
            continue
        m = re.search(r"==\s*Characters\s*==(.*?)(\n==[^=]|\Z)", txt, re.S | re.I)
        print(f"===== {title}")
        print(m.group(1) if m else txt)

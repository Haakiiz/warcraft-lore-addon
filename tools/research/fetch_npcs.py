import json
import sys
import urllib.request
from pathlib import Path

OUT = Path(__file__).parent
for z in map(int, sys.argv[1:]):
    req = urllib.request.Request(f"https://www.wowhead.com/classic/zone={z}", headers={"User-Agent": "Mozilla/5.0"})
    h = urllib.request.urlopen(req, timeout=30).read().decode("utf-8", "replace")
    i = h.find("id: 'npcs'")
    s = h.find("[", h.find("data:", i))
    d = 0
    for k in range(s, len(h)):
        if h[k] == "[":
            d += 1
        elif h[k] == "]":
            d -= 1
            if d == 0:
                break
    data = json.loads(h[s:k + 1])
    rows = [{"id": n["id"], "name": n["name"], "tag": n.get("tag", "")} for n in data]
    (OUT / f"npcs_{z}.json").write_text(json.dumps(rows, ensure_ascii=False, indent=0), encoding="utf-8")
    print(z, len(rows))

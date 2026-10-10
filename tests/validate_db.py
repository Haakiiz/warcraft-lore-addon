"""Validates WarcraftLore/Data.lua outside the game.

Run:  python tests/validate_db.py [path/to/Data.lua]

No Lua interpreter is needed: the script has its own small reader for Lua tables.
It understands what Data.lua uses: tables, strings ("..", '..', [[..]]), numbers,
true/false/nil, comments and .. concatenation of strings. Anything else gives a
clear error instead of being misread.

The reader also catches duplicate keys, which Lua itself would silently accept
(the last entry would overwrite the first).
"""
import re
import sys
from pathlib import Path

DATA = Path(__file__).resolve().parent.parent / "WarcraftLore" / "Data.lua"

GAMES = {"WC1", "WC2", "BTDP", "WC3", "TFT", "FK", "BOOK"}
CONFIDENCE = {"confirmed", "uncertain"}
ENTRY_FIELDS = {"name", "zone", "coords", "appearances", "story", "items", "sources", "confidence", "searched", "portrait", "alsoIn", "related"}
PORTRAITS = DATA.parent / "Portraits"
REQUIRED = {"name", "zone", "appearances", "sources", "confidence"}
APPEARANCE_FIELDS = {"game", "campaign", "missions", "role"}
ITEM_FIELDS = {"id", "name", "note"}


class LuaError(Exception):
    pass


# --------------------------------------------------------------------------- lexer
TOKEN_RE = re.compile(r"""
    (?P<ws>\s+)
  | (?P<lcomment>--\[(?P<leq>=*)\[.*?\](?P=leq)\])
  | (?P<comment>--[^\n]*)
  | (?P<lstring>\[(?P<seq>=*)\[.*?\](?P=seq)\])
  | (?P<string>"(?:\\.|[^"\\\n])*"|'(?:\\.|[^'\\\n])*')
  | (?P<number>-?\d+(?:\.\d+)?)
  | (?P<name>[A-Za-z_][A-Za-z0-9_]*)
  | (?P<op>\.\.\.|\.\.|[{}\[\]=,;.])
""", re.VERBOSE | re.DOTALL)

ESCAPES = {"n": "\n", "t": "\t", "\\": "\\", '"': '"', "'": "'"}


def unescape(body, line):
    out, i = [], 0
    while i < len(body):
        c = body[i]
        if c == "\\":
            nxt = body[i + 1]
            if nxt not in ESCAPES:
                raise LuaError(f"line {line}: unknown escape \\{nxt}")
            out.append(ESCAPES[nxt])
            i += 2
        else:
            out.append(c)
            i += 1
    return "".join(out)


def tokenize(src):
    tokens, pos, line = [], 0, 1
    while pos < len(src):
        m = TOKEN_RE.match(src, pos)
        if not m:
            raise LuaError(f"line {line}: unexpected character {src[pos]!r}")
        kind = m.lastgroup
        text = m.group(0)
        if kind in ("leq", "seq"):  # named sub-groups; find the main group
            kind = "lcomment" if m.group("lcomment") else "lstring"
        if kind == "string":
            tokens.append(("string", unescape(text[1:-1], line), line))
        elif kind == "lstring":
            eq = len(m.group("seq"))
            body = text[2 + eq:-(2 + eq)]
            if body.startswith("\n"):
                body = body[1:]
            tokens.append(("string", body, line))
        elif kind == "number":
            tokens.append(("number", float(text) if "." in text else int(text), line))
        elif kind == "name":
            tokens.append(("name", text, line))
        elif kind == "op":
            tokens.append(("op", text, line))
        line += text.count("\n")
        pos = m.end()
    tokens.append(("eof", None, line))
    return tokens


# --------------------------------------------------------------------------- parser
class Parser:
    def __init__(self, tokens, start):
        self.t, self.i = tokens, start

    def peek(self):
        return self.t[self.i]

    def take(self, kind=None, value=None):
        tok = self.t[self.i]
        if (kind and tok[0] != kind) or (value is not None and tok[1] != value):
            raise LuaError(f"line {tok[2]}: expected {value or kind}, found {tok[1]!r}")
        self.i += 1
        return tok

    def value(self):
        kind, val, line = self.peek()
        if kind == "op" and val == "{":
            return self.table()
        if kind == "string":
            parts = [self.take()[1]]
            while self.peek()[:2] == ("op", ".."):
                self.take()
                nxt = self.peek()
                if nxt[0] != "string":
                    raise LuaError(f"line {nxt[2]}: .. may only join strings in Data.lua")
                parts.append(self.take()[1])
            return "".join(parts)
        if kind == "number":
            return self.take()[1]
        if kind == "name" and val in ("true", "false", "nil"):
            self.take()
            return {"true": True, "false": False, "nil": None}[val]
        raise LuaError(f"line {line}: unexpected value {val!r} (only tables, strings, numbers and true/false/nil are allowed)")

    def table(self):
        open_line = self.take("op", "{")[2]
        keyed, array, key_lines = {}, [], {}
        while self.peek()[:2] != ("op", "}"):
            kind, val, line = self.peek()
            if kind == "op" and val == "[":
                self.take()
                key = self.value()
                self.take("op", "]")
                self.take("op", "=")
            elif kind == "name" and self.t[self.i + 1][:2] == ("op", "="):
                key = self.take()[1]
                self.take("op", "=")
            else:
                key = None
            v = self.value()
            if key is None:
                array.append(v)
            else:
                if key in keyed:
                    raise LuaError(f"line {line}: key {key!r} already exists (first on line {key_lines[key]})")
                keyed[key] = v
                key_lines[key] = line
            if self.peek()[:2] in (("op", ","), ("op", ";")):
                self.take()
            elif self.peek()[:2] != ("op", "}"):
                tok = self.peek()
                raise LuaError(f"line {tok[2]}: expected , or }}, found {tok[1]!r}")
        self.take("op", "}")
        if keyed and array:
            raise LuaError(f"line {open_line}: the table mixes list items and keys")
        return LuaTable(array if array else keyed, key_lines, open_line)


class LuaTable:
    def __init__(self, data, key_lines, line):
        self.data, self.key_lines, self.line = data, key_lines, line

    @property
    def is_list(self):
        return isinstance(self.data, list)


def load_npcs(path):
    tokens = tokenize(path.read_text(encoding="utf-8-sig"))
    for i in range(len(tokens) - 4):
        if [t[1] for t in tokens[i:i + 4]] == ["ns", ".", "NPCS", "="]:
            tbl = Parser(tokens, i + 4).table()
            return tbl
    raise LuaError("could not find 'ns.NPCS = {' in Data.lua")


# --------------------------------------------------------------------------- validation
def check_entries(npcs):
    errors, warnings = [], []
    if npcs.is_list and npcs.data:
        return ["ns.NPCS must use NPC IDs as keys: [1234] = { ... }"], warnings

    for npc_id, entry in (npcs.data.items() if not npcs.is_list else []):
        where = f"[{npc_id}] (line {npcs.key_lines[npc_id]})"

        def err(msg):
            errors.append(f"{where}: {msg}")

        if not isinstance(npc_id, int) or isinstance(npc_id, bool) or npc_id <= 0:
            err("the NPC ID must be a positive integer")
        if not isinstance(entry, LuaTable) or entry.is_list:
            err("the entry must be a table with named fields")
            continue
        e = entry.data
        for f in sorted(set(e) - ENTRY_FIELDS):
            err(f"unknown field '{f}' (typo?)")
        for f in sorted(REQUIRED - set(e)):
            err(f"missing required field '{f}'")

        for f in ("name", "zone"):
            if f in e and not (isinstance(e[f], str) and e[f].strip()):
                err(f"'{f}' must be a non-empty string")
        for f in ("coords", "story", "searched", "portrait"):
            if f in e and not isinstance(e[f], str):
                err(f"'{f}' must be a string (use \"\" if unknown)")
        if isinstance(e.get("coords"), str) and e["coords"] and not re.fullmatch(r"\d{1,2}(\.\d)?, \d{1,2}(\.\d)?", e["coords"]):
            err(f"'coords' must look like \"32.0, 37.8\", found {e['coords']!r}")

        conf = e.get("confidence")
        if "confidence" in e and conf not in CONFIDENCE:
            err(f"'confidence' must be \"confirmed\" or \"uncertain\", found {conf!r}")
        portrait = e.get("portrait")
        if isinstance(portrait, str) and portrait:
            if not any((PORTRAITS / f"{portrait}.{ext}").exists() for ext in ("tga", "blp")):
                err(f"'portrait' = {portrait!r}, but neither Portraits/{portrait}.tga nor .blp exists")
        if conf == "uncertain" and not (isinstance(e.get("searched"), str) and e["searched"].strip()):
            err("confidence = \"uncertain\" requires 'searched' (where you looked)")

        also = e.get("alsoIn")
        if also is not None and not (isinstance(also, LuaTable) and (also.is_list or not also.data)
                                     and all(isinstance(z, str) and z.strip() for z in (also.data or []))):
            err("'alsoIn' must be a list of zone names")

        related = e.get("related")
        if related is not None:
            ids = related.data if isinstance(related, LuaTable) and (related.is_list or not related.data) else None
            if ids is None or not all(isinstance(r, int) and not isinstance(r, bool) for r in ids):
                err("'related' must be a list of NPC IDs, e.g. { 4949, 3230 }")
            else:
                seen = set()
                for r in ids:
                    if r in seen:
                        continue
                    seen.add(r)
                    if r == npc_id:
                        err(f"'related' lists the entry itself ({r})")
                    elif r not in npcs.data:
                        err(f"'related' lists NPC ID {r}, which is not in the database")
                    elif ids.count(r) > 1:
                        err(f"'related' lists NPC ID {r} more than once")
                    else:
                        other = npcs.data[r]
                        back = other.data.get("related") if isinstance(other, LuaTable) and not other.is_list else None
                        if isinstance(back, LuaTable) and back.is_list and npc_id in back.data and npc_id < r:
                            warnings.append(f"{where}: {r} is related both ways; one side is enough")

        story = e.get("story")
        if isinstance(story, str) and story.strip():
            n = len(re.findall(r"[.!?](?=\s|$)", story.strip()))
            if not 3 <= n <= 6:
                err(f"'story' must have 3–6 sentences, found {n}")

        apps = e.get("appearances")
        if "appearances" in e:
            if not isinstance(apps, LuaTable) or not apps.is_list or not apps.data:
                err("'appearances' must be a list with at least one appearance")
            else:
                for n, a in enumerate(apps.data, 1):
                    if not isinstance(a, LuaTable) or a.is_list:
                        err(f"appearances[{n}] must be a table with named fields")
                        continue
                    d = a.data
                    for f in sorted(set(d) - APPEARANCE_FIELDS):
                        err(f"appearances[{n}]: unknown field '{f}'")
                    if d.get("game") not in GAMES:
                        err(f"appearances[{n}].game must be one of {sorted(GAMES)}, found {d.get('game')!r}")
                    if not (isinstance(d.get("role"), str) and d["role"].strip()):
                        err(f"appearances[{n}].role is missing")
                    if "campaign" in d and not isinstance(d["campaign"], str):
                        err(f"appearances[{n}].campaign must be a string")
                    m = d.get("missions")
                    if m is not None and not (isinstance(m, LuaTable) and (m.is_list or not m.data)
                                              and all(isinstance(x, str) and x.strip() for x in (m.data or []))):
                        err(f"appearances[{n}].missions must be a list of strings")

        items = e.get("items")
        if items is not None:
            if not isinstance(items, LuaTable) or (items.data and not items.is_list):
                err("'items' must be a list")
            else:
                seen = set()
                for n, it in enumerate(items.data or [], 1):
                    if not isinstance(it, LuaTable) or it.is_list:
                        err(f"items[{n}] must be a table")
                        continue
                    d = it.data
                    for f in sorted(set(d) - ITEM_FIELDS):
                        err(f"items[{n}]: unknown field '{f}'")
                    iid = d.get("id")
                    if not isinstance(iid, int) or isinstance(iid, bool) or iid <= 0:
                        err(f"items[{n}].id must be a positive integer")
                    elif iid in seen:
                        err(f"items[{n}]: item ID {iid} is listed twice")
                    seen.add(iid)
                    if not (isinstance(d.get("name"), str) and d["name"].strip()):
                        err(f"items[{n}].name is missing")

        src = e.get("sources")
        if "sources" in e:
            if not isinstance(src, LuaTable) or not src.is_list or not src.data:
                err("'sources' must be a list with at least one link")
            else:
                for n, url in enumerate(src.data, 1):
                    if not (isinstance(url, str) and re.match(r"https?://\S+$", url)):
                        err(f"sources[{n}] is not a valid link: {url!r}")
    return errors, warnings


def main():
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else DATA
    try:
        npcs = load_npcs(path)
    except LuaError as ex:
        print(f"ERROR in {path.name}: {ex}")
        return 1
    errors, warnings = check_entries(npcs)
    count = 0 if npcs.is_list else len(npcs.data)
    for w in warnings:
        print("WARNING:", w)
    if errors:
        for e in errors:
            print("ERROR:", e)
        print(f"\n{len(errors)} error(s) in {count} entries.")
        return 1
    zones = {}
    for entry in npcs.data.values():
        zones[entry.data["zone"]] = zones.get(entry.data["zone"], 0) + 1
    print(f"OK: {count} entries, no duplicate NPC IDs, all fields valid.")
    for z, n in sorted(zones.items()):
        print(f"  {z}: {n}")
    return 0


if __name__ == "__main__":
    sys.exit(main())

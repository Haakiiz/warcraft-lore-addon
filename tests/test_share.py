"""Loads Share.lua in Lua 5.1 (via lupa, with WoW stubs) and checks the export/import logic:
round trip, merge rules, damaged or wrong-version strings, unknown NPC IDs and an empty list.

Usage: python tests/test_share.py   (needs: pip install lupa)
"""

import sys
from pathlib import Path

import lupa.lua51 as lupa  # WoW runs Lua 5.1

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"

STUBS = """
local noop = function() end
local function stub() return setmetatable({}, { __index = function() return noop end }) end
ns = { Compat = stub(), Style = stub() }
printed = {}
ns.Compat.Print = function(msg) printed[#printed + 1] = msg end
ns.NPCS = { [100] = {}, [200] = {}, [300] = {}, [4949] = {} }
WarcraftLoreDB = { met = {} }
"""


def runtime():
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    run((ADDON / "Share.lua").read_text(encoding="utf-8"), "Share.lua")
    return lua


def check(name, cond, detail=""):
    print(("ok   " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    return cond


def main():
    r = []
    lua = runtime()
    ev, ex = lua.eval, lua.execute

    # Round trip.
    ex("""met = { [100] = { first = 1759449600, count = 3, by = 'A-B' }, [4949] = { first = 1700000000, count = 12 } }
          str = ns.Share.Encode(met)
          list = ns.Share.Decode(str)""")
    r.append(check("string starts with version", ev("str:sub(1, 5)") == "WCL1:"))
    r.append(check("round trip: 2 entries", ev("#list") == 2))
    r.append(check("round trip: values",
                   ev("list[1].id") == 100 and ev("list[1].first") == 1759449600 and ev("list[1].count") == 3
                   and ev("list[2].id") == 4949 and ev("list[2].first") == 1700000000 and ev("list[2].count") == 12))
    r.append(check("same input gives same string", ev("ns.Share.Encode(met) == str")))
    ex("spaced = '  ' .. str:sub(1, 9) .. string.char(10) .. str:sub(10) .. ' '")
    r.append(check("whitespace and line breaks are ignored", ev("#ns.Share.Decode(spaced)") == 2))

    # Empty list.
    ex("empty = ns.Share.Encode({}); elist = ns.Share.Decode(empty)")
    r.append(check("empty list: decodes to zero entries", ev("elist ~= nil and #elist") == 0))
    ex("WarcraftLoreDB.met = {}")
    r.append(check("empty list: import says 0",
                   ev("select(2, ns.Share.Import(empty))") == "Imported 0 veterans (0 new)."))

    # Damaged strings.
    ex("""function flip(s, i) local c = s:sub(i, i); return s:sub(1, i - 1) .. (c == '1' and '2' or '1') .. s:sub(i + 1) end
          function damaged(s) local l, why = ns.Share.Decode(s); return l == nil and why == 'damaged' end""")
    r.append(check("changed character rejected", ev("damaged(flip(str, 8))")))
    r.append(check("cut-off string rejected", ev("damaged(str:sub(1, #str - 6))")))
    r.append(check("wrong checksum rejected", ev("damaged(str:sub(1, #str - 4) .. 'zzzz')")))
    r.append(check("missing checksum rejected", ev("damaged(str:match('^(.*)~'))")))
    ex("""function signed(body) return body .. '~' .. ns.Share.Checksum(body) end""")
    r.append(check("garbage entry with valid checksum rejected", ev("damaged(signed('WCL1:xx;1.2.3'))")))
    r.append(check("zero count with valid checksum rejected", ev("damaged(signed('WCL1:2s.1.0'))")))
    r.append(check("valid hand-made string accepted", ev("#ns.Share.Decode(signed('WCL1:2s.1.1'))") == 1))
    r.append(check("random text is not an export string",
                   ev("select(2, ns.Share.Decode('hello world'))") == "format"))
    r.append(check("empty text", ev("select(2, ns.Share.Decode('  '))") == "empty"))
    r.append(check("damaged import changes nothing",
                   ev("(ns.Share.Import(flip(str, 8)))") is False and ev("next(WarcraftLoreDB.met)") is None))

    # Wrong version.
    r.append(check("version 2 rejected", ev("select(2, ns.Share.Decode('WCL2:' .. str:sub(6)))") == "version"))

    # Merge rules.
    ex("""WarcraftLoreDB.met = {
        [100] = { first = 2000000000, count = 7, by = 'Late-X' },
        [200] = { first = 1000, count = 1, by = 'Early-X' },
        [300] = { first = 500, count = 9 } }
        incoming = ns.Share.Encode({
            [100] = { first = 1759449600, count = 3 },
            [200] = { first = 2000, count = 4 },
            [4949] = { first = 1100000000, count = 2 } })
        ok, line = ns.Share.Import(incoming)""")
    r.append(check("merge: earliest first wins (import earlier)", ev("WarcraftLoreDB.met[100].first") == 1759449600))
    r.append(check("merge: earlier import drops unknown 'by'", ev("WarcraftLoreDB.met[100].by") is None))
    r.append(check("merge: larger count wins (local larger)", ev("WarcraftLoreDB.met[100].count") == 7))
    r.append(check("merge: first kept when local is earlier", ev("WarcraftLoreDB.met[200].first") == 1000))
    r.append(check("merge: 'by' kept when local is earlier", ev("WarcraftLoreDB.met[200].by") == "Early-X"))
    r.append(check("merge: larger count wins (import larger)", ev("WarcraftLoreDB.met[200].count") == 4))
    r.append(check("merge: new entry added",
                   ev("WarcraftLoreDB.met[4949].first") == 1100000000 and ev("WarcraftLoreDB.met[4949].count") == 2))
    r.append(check("merge: nothing deleted", ev("WarcraftLoreDB.met[300].count") == 9))
    r.append(check("merge: chat line", ev("ok") is True and ev("line") == "Imported 3 veterans (1 new)."))
    r.append(check("singular wording",
                   ev("select(2, ns.Share.Import(ns.Share.Encode({ [300] = { first = 1, count = 1 } })))")
                   == "Imported 1 veteran (0 new)."))

    # Unknown IDs.
    ex("""WarcraftLoreDB.met = {}
          ok2, line2 = ns.Share.Import(ns.Share.Encode({
              [100] = { first = 5, count = 1 }, [999999] = { first = 6, count = 1 } }))""")
    r.append(check("unknown NPC ID ignored",
                   ev("WarcraftLoreDB.met[999999]") is None and ev("WarcraftLoreDB.met[100] ~= nil")
                   and ev("line2") == "Imported 1 veteran (1 new)."))

    # Edit box width: window 440, band 20 -> 356 px, exactly the scroll frame width (400 - 32 - 12).
    r.append(check("edit box width fits scroll frame", ev("ns.Share.EditWidth(440, 20)") == 356))
    r.append(check("edit box width follows the band", ev("ns.Share.EditWidth(440, 24)") == 348))

    # Hand-edited values are clamped.
    ex("""function signed2(body) return body .. '~' .. ns.Share.Checksum(body) end
          wild = ns.Share.Decode(signed2('WCL1:2s.0.zzzzzzzz'))""")
    r.append(check("first clamped to 2004 or later", ev("wild[1].first") >= 1072915200))
    r.append(check("count clamped", ev("wild[1].count") == 99999))

    # Window guard: no edit box -> clear message, no error.
    ex("""local function obj() local o; o = setmetatable({}, { __index = function() return function() return o end end }); return o end
          ns.Compat.CreateEditBox = function() return nil end
          ns.Style.COL = setmetatable({}, { __index = function() return { 1, 1, 1 } end })
          for _, k in ipairs({ 'buildFrameArt', 'buildInner', 'buildHeader', 'text', 'box' }) do ns.Style[k] = obj end
          CreateFrame = obj
          ns.Share.Open('export')""")
    r.append(check("no edit box: says not available",
                   ev("printed[#printed]").endswith("Import and export are not available in this client.")))

    print(f"\n{sum(r)}/{len(r)} passed")
    return 0 if all(r) else 1


if __name__ == "__main__":
    sys.exit(main())

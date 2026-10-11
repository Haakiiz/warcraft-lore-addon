"""Loads Data.lua, SavedData.lua and Core.lua in Lua 5.1 (via lupa, with WoW stubs) and checks
met tracking: ns.MarkMet, ns.MeetCount and ns.MetSummary.

Usage: python tests/test_met.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa  # WoW runs Lua 5.1

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"

STUBS = """
local noop = function() end
local function stub() return setmetatable({}, { __index = function() return noop end }) end
ns = { L = setmetatable({}, { __index = function(_, k) return k end }), Compat = stub() }
ns.Compat.UnitName = function() return "Arthas" end
ns.Compat.GetRealmName = function() return "Silvermoon" end
ns.Compat.After = function(fn) fn() end
printed = {}
ns.Compat.Print = function(msg) printed[#printed + 1] = msg end
CreateFrame = function() return stub() end
SlashCmdList = {}
time = function() return 1759449600 end -- 3 Oct 2025
date = os.date
WarcraftLoreDB = { schema = 2, met = {} }
"""

PICK = """
-- The data has no character under two NPC IDs any more, so add a synthetic twin of Thrall
-- (same name and zone) before the merged veteran list is built.
local twin = {}
for k, v in pairs(ns.NPCS[4949]) do twin[k] = v end
ns.NPCS[999001] = twin
for _, g in ipairs(ns.Veterans()) do
    if #g.ids >= 2 and not multi then multi = g end
    if #g.ids == 1 and not single then single = g end
end
A, B = multi.ids[1], multi.ids[2]
S = single.ids[1]
"""


def runtime(db="{ schema = 2, met = {} }"):
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    for name in ("Data.lua", "SavedData.lua", "Core.lua"):
        run((ADDON / name).read_text(encoding="utf-8"), name)
    lua.execute("WarcraftLoreDB = " + db)
    lua.execute(PICK)
    return lua


def check(name, cond, detail=""):
    print(("ok   " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    return cond


def main():
    r = []
    lua = runtime()
    ev = lua.eval

    r.append(check("never met: MeetCount 0", ev("ns.MeetCount(S)") == 0))
    r.append(check("never met: MetSummary nil", ev("ns.MetSummary(S)") is None))
    r.append(check("first MarkMet returns true", ev("ns.MarkMet(S)") is True))
    r.append(check("count 1, by and first stored",
                   ev("WarcraftLoreDB.met[S].count") == 1
                   and ev("WarcraftLoreDB.met[S].by") == "Arthas-Silvermoon"
                   and ev("WarcraftLoreDB.met[S].first") == 1759449600))
    r.append(check("same session: counted once", ev("ns.MarkMet(S)") is False and ev("ns.MeetCount(S)") == 1))
    r.append(check("unknown NPC refused", ev("ns.MarkMet(999999999)") is False))
    r.append(check("summary once", ev("ns.MetSummary(S)") == "Met once, on 3 Oct 2025 as Arthas"))

    # New session (fresh runtime) with an existing entry: count bumped, first/by kept.
    lua2 = runtime("{ schema = 2, met = {} }")
    lua2.execute("WarcraftLoreDB.met[S] = { first = 1759449600, count = 3, by = 'Jaina-Area52' }")
    r.append(check("MeetCount reads entry", lua2.eval("ns.MeetCount(S)") == 3))
    r.append(check("existing entry: bump returns false", lua2.eval("ns.MarkMet(S)") is False))
    r.append(check("existing entry: count 4, first/by kept",
                   lua2.eval("WarcraftLoreDB.met[S].count") == 4
                   and lua2.eval("WarcraftLoreDB.met[S].by") == "Jaina-Area52"
                   and lua2.eval("WarcraftLoreDB.met[S].first") == 1759449600))
    s = lua2.eval("ns.MetSummary(S)")
    r.append(check("summary: other character keeps realm",
                   s.startswith("Met 4 times · first on ") and s.endswith(" as Jaina-Area52") and "2025" in s, s))
    lua2.execute("WarcraftLoreDB.met[S].by = 'Arthas-Silvermoon'")
    s = lua2.eval("ns.MetSummary(S)")
    r.append(check("summary: same realm drops realm", s.endswith(" as Arthas") and " 03 " not in s, s))

    # Merged veteran with two NPC IDs.
    lua2.execute("""WarcraftLoreDB.met = {
        [A] = { first = 2000000000, count = 2, by = 'Late-Silvermoon' },
        [B] = { first = 1700000000, count = 3, by = 'Early-Area52' } }""")
    s = lua2.eval("ns.MetSummary(A)")
    r.append(check("merged: counts add up, earliest wins",
                   s.startswith("Met 5 times") and s.endswith(" as Early-Area52") and "2023" in s, s))
    r.append(check("merged: same text from the other ID", lua2.eval("ns.MetSummary(B)") == s))
    r.append(check("merged: GroupMet", lua2.eval("ns.GroupMet(multi)") is True))
    lua2.execute("WarcraftLoreDB.met = { [A] = { count = 1 } }")
    r.append(check("no first time: plain summary", lua2.eval("ns.MetSummary(A)") == "Met once"))

    # db.met from a newer version (not a table): left alone.
    lua3 = runtime("{ schema = 2, met = 'newer-format' }")
    r.append(check("db.met not a table: refused",
                   lua3.eval("ns.MarkMet(S)") is False and lua3.eval("WarcraftLoreDB.met") == "newer-format"))
    r.append(check("db.met not a table: summary nil, count 0",
                   lua3.eval("ns.MetSummary(S)") is None and lua3.eval("ns.MeetCount(S)") == 0))

    print(f"\n{sum(r)}/{len(r)} passed")
    raise SystemExit(0 if all(r) else 1)


if __name__ == "__main__":
    main()

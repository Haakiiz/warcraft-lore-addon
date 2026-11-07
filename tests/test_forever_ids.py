"""WoW Forever NPC IDs: an entry's foreverIDs point at the entry itself, so targeting the Forever
version of a veteran finds the same entry, counts as the same veteran and adds no second veteran.

Usage: python tests/test_forever_ids.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"

STUBS = """
local noop = function() end
local function stub() return setmetatable({}, { __index = function() return noop end }) end
ns = { L = setmetatable({}, { __index = function(_, k) return k end }) }
CreateFrame = function() return stub() end
SlashCmdList = {}
time = function() return 1759449600 end
date = os.date
strsplit = function() end
GetBuildInfo = function() return "x", "0", "", 16001 end
"""

# A made-up veteran (999002) whose Forever version has the made-up ID 999003.
EXTRA = """
ns.NPCS[999002] = { name = "Test Twin", zone = "Durotar", foreverIDs = { 999003 }, appearances = {} }
"""


def check(name, cond, detail=""):
    print(("ok   " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    return cond


def main():
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    for name in ("Compat.lua", "Data.lua", "Memorials.lua"):
        run((ADDON / name).read_text(encoding="utf-8"), name)
    lua.execute(EXTRA)
    for name in ("SavedData.lua", "Core.lua"):
        run((ADDON / name).read_text(encoding="utf-8"), name)
    # Let ns.Lookup read a GUID for the Forever ID without a real unit.
    lua.execute("ns.Compat.NPCIDFromGUID = function(guid) return tonumber(guid), 'Creature' end")
    lookup = lua.eval("function(guid) local e, id = ns.Lookup(nil, guid); return e, id end")

    r = []
    entry, npc_id = lookup("999003")
    r.append(check("the Forever ID finds the veteran's entry", entry is not None and entry.name == "Test Twin"))
    r.append(check("the Forever ID is reported as the veteran's own ID", npc_id == 999002, f"got {npc_id}"))
    entry, npc_id = lookup("999002")
    r.append(check("the veteran's own ID still works", npc_id == 999002 and entry is not None))
    entry, npc_id = lookup("12345678")
    r.append(check("an unknown ID finds nothing", entry is None and npc_id == 12345678))
    r.append(check("the Forever ID adds no second veteran",
                   lua.eval("(function() local n = 0 for _, g in ipairs(ns.Veterans()) do "
                            "if g.entry.name == 'Test Twin' then n = n + #g.ids end end return n end)()") == 1))
    r.append(check("the Forever ID is not a database key", lua.eval("ns.NPCS[999003] == nil")))
    # Every real foreverIDs entry in Data.lua resolves to its own entry.
    bad = lua.eval("""(function()
        local bad = {}
        for id, e in pairs(ns.NPCS) do
            for _, fid in ipairs(e.foreverIDs or {}) do
                if ns.FOREVER_ALIAS[fid] ~= id then bad[#bad + 1] = tostring(fid) end
            end
        end
        return table.concat(bad, ", ")
    end)()""")
    r.append(check("every foreverIDs entry in Data.lua points at its own entry", bad == "", bad))
    print(f"{sum(r)}/{len(r)} passed")
    raise SystemExit(0 if all(r) else 1)


if __name__ == "__main__":
    main()

"""Loads Data.lua and Core.lua in Lua 5.1 (via lupa, with WoW stubs) and checks ns.Related.

Usage: python tests/test_related.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa  # WoW runs Lua 5.1

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"

STUBS = """
local noop = function() end
local function stub() return setmetatable({}, { __index = function() return noop end }) end
ns = { Compat = stub() }
CreateFrame = function() return stub() end
SlashCmdList = {}
"""


def runtime():
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    for name in ("Data.lua", "Core.lua"):
        run((ADDON / name).read_text(encoding="utf-8"), name)
    return lua


def related_names(lua, npc_id):
    return list(lua.eval(f"""(function()
        local out = {{}}
        for i, g in ipairs(ns.Related({npc_id})) do out[i] = g.entry.name end
        return out
    end)()""").values())


def check(name, cond, detail=""):
    print(("ok   " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    return cond


def main():
    lua = runtime()
    results = []

    thrall = related_names(lua, 4949)
    results.append(check("Thrall: own list", {"Nazgrel", "Vol'jin", "Cairne Bloodhoof", "Rexxar"} <= set(thrall), thrall))
    results.append(check("Thrall: sorted by name", thrall == sorted(thrall), thrall))

    nazgrel = related_names(lua, 3230)
    results.append(check("Nazgrel: link back to Thrall", nazgrel == ["Thrall"], nazgrel))

    jaina = related_names(lua, 4968)
    results.append(check("Jaina: own + incoming", {"Archmage Tervosh", "Thrall", "Rexxar"} == set(jaina), jaina))

    results.append(check("Krasus <-> Korialstrasz", related_names(lua, 232624) == ["Korialstrasz"]))
    results.append(check("no relations: empty list", related_names(lua, 3139) == []))  # Gar'Thok
    results.append(check("unknown ID: empty list", related_names(lua, 999999) == []))

    print(f"\n{sum(results)}/{len(results)} passed")
    raise SystemExit(0 if all(results) else 1)


if __name__ == "__main__":
    main()

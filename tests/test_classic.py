"""Classic Era build: the two .toc files load the same files, Compat.IsForever reads the interface,
forever-only entries are dropped on Classic and kept on Forever, and the level cap is 60 on Classic.

Usage: python tests/test_classic.py   (needs: pip install lupa)
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
"""

# Two made-up entries added after Data.lua and Memorials.lua: one forever-only NPC and memorial.
EXTRA = """
ns.NPCS[999001] = { name = "Test Hyjal NPC", zone = "Mount Hyjal", forever = true, appearances = {} }
ns.MEMORIALS.testHyjal = { name = "Test Hyjal plaque", zone = "Mount Hyjal", forever = true, appearances = {} }
"""


def runtime(interface):
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    if interface is not None:
        lua.execute(f'GetBuildInfo = function() return "x", "0", "", {interface} end')
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    for name in ("Compat.lua", "Data.lua", "Memorials.lua"):
        run((ADDON / name).read_text(encoding="utf-8"), name)
    lua.execute(EXTRA)
    for name in ("SavedData.lua", "Core.lua", "Achievements.lua"):
        run((ADDON / name).read_text(encoding="utf-8"), name)
    return lua


def toc_files(name):
    lines = (ADDON / name).read_text(encoding="utf-8-sig").splitlines()
    return [x.strip() for x in lines if x.strip() and not x.startswith("#")]


def toc_interface(name):
    for line in (ADDON / name).read_text(encoding="utf-8-sig").splitlines():
        if line.startswith("## Interface:"):
            return line.split(":", 1)[1].strip()
    return None


def check(name, cond, detail=""):
    print(("ok   " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    return cond


def main():
    r = []
    r.append(check(".toc: Forever and Classic Era load the same files in the same order",
                   toc_files("WarcraftLore.toc") == toc_files("WarcraftLore_Vanilla.toc")))
    r.append(check(".toc: Forever is interface 16xxx", (toc_interface("WarcraftLore.toc") or "").startswith("16")))
    r.append(check(".toc: Classic Era is interface 115xx", (toc_interface("WarcraftLore_Vanilla.toc") or "").startswith("115")))

    for label, interface, forever in (("Forever", 16001, True), ("Classic Era", 11509, False), ("no GetBuildInfo", None, True)):
        lua = runtime(interface)
        ev = lua.eval
        r.append(check(f"{label}: IsForever = {forever}", ev("ns.Compat.IsForever()") is forever))
        r.append(check(f"{label}: forever-only NPC {'kept' if forever else 'dropped'}",
                       (ev("ns.NPCS[999001]") is not None) is forever))
        r.append(check(f"{label}: forever-only memorial {'kept' if forever else 'dropped'}",
                       (ev("ns.MEMORIALS.testHyjal") is not None) is forever))
        r.append(check(f"{label}: other NPCs stay (Thrall)", ev("ns.NPCS[4949]") is not None))
        cap = ev("ns.Achievements.LEVEL_CAP")
        r.append(check(f"{label}: level cap {30 if forever else 60}", cap == (30 if forever else 60), cap))

    print(f"\n{sum(r)}/{len(r)} checks passed")
    raise SystemExit(0 if all(r) else 1)


if __name__ == "__main__":
    main()

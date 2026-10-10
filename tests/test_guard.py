"""Core.lua feature guards, alert batching and /wcl why (Lua 5.1 via lupa, with WoW stubs).

Usage: python tests/test_guard.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa  # WoW runs Lua 5.1

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"

STUBS = """
local noop = function() end
local function stub() return setmetatable({}, { __index = function() return noop end }) end
printed, timers, sounds, toasts = {}, {}, 0, {}
guids, targetExists, inInstance = {}, true, false
ns = { Compat = {
    Print = function(m) printed[#printed + 1] = m end,
    UnitGUID = function(u) if guids[u] == "ERROR" then error("boom") end return guids[u] end,
    UnitName = function(u) return u end,
    UnitExists = function() return targetExists end,
    NPCIDFromGUID = function(g)
        if not g then return nil, nil end
        local t, id = g:match("^(%a+)-(%d+)$")
        if t == "Creature" then return tonumber(id), t end
        return nil, g:match("^(%a+)")
    end,
    After = function(fn, s) timers[#timers + 1] = { fn = fn, s = s } end,
    PlayAlertSound = function() sounds = sounds + 1 end,
    InInstance = function() return inInstance end,
    GetPlayerMapPos = function() return nil end,
    StartTicker = function() return true end,
    RegisterEventSafe = function() return true end,
    EVENT_NAMEPLATE_ADDED = "NAME_PLATE_UNIT_ADDED",
    missing = {},
    Report = function() return {} end,
    HookUnitTooltip = function() return "stub" end,
    AddTooltipLine = noop,
} }
ns.Toast = { Show = function(id, e, who, unit, more) toasts[#toasts + 1] = { id = id, who = who, more = more } end }
ns.UI = { Init = noop, IsShown = function() return false end }
ns.Minimap = { Init = noop }
ns.SavedData = { Load = function() end }
WarcraftLoreDB = { alert = true, auto = false }
WarcraftLoreCharDB = { met = {} }
strtrim = function(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
SlashCmdList = {}
local onEvent
CreateFrame = function()
    local f = stub()
    f.SetScript = function(_, _, fn) onEvent = fn end
    return f
end
fire = function(...) return onEvent(nil, ...) end
time = os.time
"""


def runtime():
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    for name in ("Data.lua", "Core.lua"):
        run((ADDON / name).read_text(encoding="utf-8"), name)
    # Three fake veterans; Alpha has coordinates in a known zone.
    lua.execute("""
        ns.NPCS[900001] = { name = "Alpha", zone = "Orgrimmar", coords = "50.0, 50.0",
                            appearances = { { game = "WC3" } } }
        ns.NPCS[900002] = { name = "Beta", appearances = { { game = "WC2" } } }
        ns.NPCS[900003] = { name = "Gamma", appearances = { { game = "WC1" } } }
        fire("ADDON_LOADED", "WarcraftLore")
    """)
    return lua


def check(name, cond, detail=""):
    print(("ok   " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    return cond


def lines(lua):
    return [str(x) for x in lua.eval("printed").values()]


def main():
    results = []

    # 1. A feature that errors is switched off after ONE chat line, and the error does not escape.
    lua = runtime()
    lua.execute('guids.nameplate1 = "ERROR"')
    try:
        lua.execute('fire("NAME_PLATE_UNIT_ADDED", "nameplate1")')
        escaped = False
    except Exception:  # noqa: BLE001
        escaped = True
    results.append(check("error does not escape the event handler", not escaped))
    out = lines(lua)
    results.append(check("one chat line on the first error",
                         len(out) == 1 and "nearby alert" in out[0] and "/wcl debug" in out[0], out))
    lua.execute('fire("NAME_PLATE_UNIT_ADDED", "nameplate1"); fire("NAME_PLATE_UNIT_ADDED", "nameplate1")')
    results.append(check("feature stays off, no more chat lines", len(lines(lua)) == 1, lines(lua)))
    results.append(check("FeatureOff reports it", lua.eval('ns.FeatureOff("alert")') is True))
    results.append(check("other features still on", lua.eval('ns.FeatureOff("tooltip")') is False
                         and lua.eval('ns.FeatureOff("target")') is False))
    lua.execute('SlashCmdList.WARCRAFTLORE("debug")')
    results.append(check("/wcl debug shows the kept error text", any("boom" in x for x in lines(lua)), lines(lua)))

    # 2. Slash command errors are contained too.
    lua = runtime()
    lua.execute('ns.UI.ShowEntry = function() error("bad api") end; guids.target = "Creature-900001"')
    ok = True
    try:
        lua.execute('SlashCmdList.WARCRAFTLORE(""); SlashCmdList.WARCRAFTLORE("")')
    except Exception:  # noqa: BLE001
        ok = False
    results.append(check("slash command error does not escape", ok))
    results.append(check("slash command: one chat line",
                         len(lines(lua)) == 1 and "/wcl command" in lines(lua)[0], lines(lua)))

    # 3. Batching: three veterans at once give one chat line, one sound, one pill.
    lua = runtime()
    lua.execute('guids.nameplate1 = "Creature-900001"; guids.nameplate2 = "Creature-900002"; '
                'guids.nameplate3 = "Creature-900003"')
    lua.execute('for i = 1, 3 do fire("NAME_PLATE_UNIT_ADDED", "nameplate" .. i) end')
    results.append(check("nothing shown before the window ends", len(lines(lua)) == 0 and lua.eval("sounds") == 0))
    results.append(check("one timer of 1.5 s", lua.eval("#timers") == 1 and lua.eval("timers[1].s") == 1.5))
    lua.execute("timers[1].fn()")
    out = lines(lua)
    results.append(check("one chat line with +2 more nearby", len(out) == 1 and "+2 more nearby" in out[0], out))
    results.append(check("one sound, one pill", lua.eval("sounds") == 1 and lua.eval("#toasts") == 1
                         and lua.eval("toasts[1].more") == 2))

    # A lone veteran: plain line, no "more".
    lua = runtime()
    lua.execute('guids.nameplate1 = "Creature-900002"; fire("NAME_PLATE_UNIT_ADDED", "nameplate1"); timers[1].fn()')
    out = lines(lua)
    results.append(check("lone veteran: no +N", len(out) == 1 and "more nearby" not in out[0], out))

    # 4. /wcl why
    lua = runtime()
    lua.execute('targetExists = false; SlashCmdList.WARCRAFTLORE("why")')
    results.append(check("why: no target", "no target" in lines(lua)[-1]))
    for guid, needle in (("Player-1-ABC", "player"), (None, "hides"), ("Creature-12345", "not in the database")):
        target = f'"{guid}"' if guid else "nil"
        lua.execute(f"targetExists = true; guids.target = {target}; SlashCmdList.WARCRAFTLORE('why')")
        results.append(check(f"why: {needle}", needle in lines(lua)[-1], lines(lua)[-1]))
    lua.execute('guids.target = "Creature-900002"; SlashCmdList.WARCRAFTLORE("why")')
    out = lines(lua)[-2:]
    results.append(check("why: veteran without coordinates", "veteran" in out[0] and "no map position" in out[1], out))
    lua.execute('guids.target = "Creature-900001"; inInstance = true; SlashCmdList.WARCRAFTLORE("why")')
    results.append(check("why: instance", "instance" in lines(lua)[-1], lines(lua)[-1]))
    lua.execute('inInstance = false; WarcraftLoreDB.alert = false; SlashCmdList.WARCRAFTLORE("why")')
    results.append(check("why: alerts off", "alerts are off" in lines(lua)[-1], lines(lua)[-1]))
    lua.execute('SlashCmdList.WARCRAFTLORE("help")')
    results.append(check("help lists /wcl why", any("/wcl why" in x for x in lines(lua))))

    print(f"\n{sum(results)}/{len(results)} passed")
    raise SystemExit(0 if all(results) else 1)


if __name__ == "__main__":
    main()

"""Core.lua feature guards, alert batching and /wcl why (Lua 5.1 via lupa, with WoW stubs).

Usage: python tests/test_guard.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa  # WoW runs Lua 5.1

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"

STUBS = """
local noop = function() end
local function stub() return setmetatable({}, { __index = function() return noop end }) end
printed, timers, sounds, toasts, setMore = {}, {}, 0, {}, {}
guids, targetExists, inInstance = {}, true, false
ns = { L = setmetatable({}, { __index = function(_, k) return k end }), Compat = {
    Print = function(m) printed[#printed + 1] = m end,
    UnitGUID = function(u) if guids[u] == "ERROR" then error("boom") end return guids[u] end,
    UnitName = function() return nil end,
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
    HookObjectTooltip = function() return "stub" end,
    ItemTextName = function() return nil end,
    AddTooltipLine = noop,
} }
ns.Toast = { Show = function(id, e, who, unit, more) toasts[#toasts + 1] = { id = id, who = who, more = more } end,
    SetMore = function(id, n) setMore[#setMore + 1] = { id = id, n = n } end }
ns.UI = { Init = noop, IsShown = function() return false end }
ns.Minimap = { Init = noop }
ns.SavedData = { Load = function() end }
ns.Style = { theme = "wc2", ApplyTheme = function() end, ThemeLabel = function(n) return n end,
             OtherTheme = function() return "classic" end, RequestTheme = function() end }
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

    # 3. Batching: the first veteran is announced at once; the rest become ONE follow-up line.
    lua = runtime()
    lua.execute('guids.nameplate1 = "Creature-900001"; guids.nameplate2 = "Creature-900002"; '
                'guids.nameplate3 = "Creature-900003"')
    lua.execute('fire("NAME_PLATE_UNIT_ADDED", "nameplate1")')
    out = lines(lua)
    results.append(check("first alert is immediate: line, sound, pill",
                         len(out) == 1 and "Alpha" in out[0] and lua.eval("sounds") == 1
                         and lua.eval("#toasts") == 1 and lua.eval("toasts[1].more") is None, out))
    results.append(check("one timer of 1.5 s", lua.eval("#timers") == 1 and lua.eval("timers[1].s") == 1.5))
    lua.execute('fire("NAME_PLATE_UNIT_ADDED", "nameplate2"); fire("NAME_PLATE_UNIT_ADDED", "nameplate3")')
    results.append(check("later ones add nothing until the window ends",
                         len(lines(lua)) == 1 and lua.eval("sounds") == 1 and lua.eval("#timers") == 1))
    lua.execute("timers[1].fn()")
    out = lines(lua)
    results.append(check("one follow-up line naming both", len(out) == 2 and "Also nearby:" in out[1]
                         and "Beta" in out[1] and "Gamma" in out[1] and "more" not in out[1], out))
    results.append(check("no extra sound, no second pill; pill told +2",
                         lua.eval("sounds") == 1 and lua.eval("#toasts") == 1
                         and lua.eval("#setMore") == 1 and lua.eval("setMore[1].n") == 2))
    # Nobody is announced twice.
    lua.execute('for i = 1, 3 do fire("NAME_PLATE_UNIT_ADDED", "nameplate" .. i) end')
    results.append(check("already alerted veterans stay quiet", len(lines(lua)) == 2))

    # Many veterans: at most 3 named, the rest counted.
    lua = runtime()
    lua.execute("""
        for i = 1, 7 do
            ns.NPCS[910000 + i] = { name = "Vet" .. i, appearances = { { game = "TFT" } } }
            guids["np" .. i] = "Creature-" .. (910000 + i)
            fire("NAME_PLATE_UNIT_ADDED", "np" .. i)
        end
        timers[1].fn()
    """)
    out = lines(lua)
    results.append(check("7 veterans: 2 chat lines in total", len(out) == 2, out))
    results.append(check("follow-up names exactly 3 and counts +3 more",
                         "Vet2" in out[1] and "Vet3" in out[1] and "Vet4" in out[1] and "Vet5" not in out[1]
                         and "+3 more" in out[1], out))

    # A lone veteran: one line, a timer that says nothing.
    lua = runtime()
    lua.execute('guids.nameplate1 = "Creature-900002"; fire("NAME_PLATE_UNIT_ADDED", "nameplate1"); timers[1].fn()')
    out = lines(lua)
    results.append(check("lone veteran: one line, no follow-up", len(out) == 1 and "nearby" in out[0], out))

    # The whole alert path shares ONE guard key: a failing follow-up switches "alert" off and /wcl why says so.
    lua = runtime()
    lua.execute('ns.Toast.SetMore = function() error("pill broke") end; '
                'guids.nameplate1 = "Creature-900001"; guids.nameplate2 = "Creature-900002"; '
                'fire("NAME_PLATE_UNIT_ADDED", "nameplate1"); fire("NAME_PLATE_UNIT_ADDED", "nameplate2"); '
                'timers[1].fn()')
    results.append(check("flush error turns off the same 'alert' key", lua.eval('ns.FeatureOff("alert")') is True
                         and lua.eval('ns.FeatureOff("alert-batch")') is False))
    lua.execute('guids.target = "Creature-900002"; SlashCmdList.WARCRAFTLORE("why")')
    results.append(check("why reports the dead alert", "alert is off after an error" in lines(lua)[-1], lines(lua)[-1]))
    # The batch window is closed even though the flush failed, so a new veteran is announced again.
    results.append(check("batch is not stuck open", lua.eval("#timers") == 1))

    # The lore window failed to build: callers check FeatureOff("window").
    lua = runtime()
    lua.execute('ns.UI.Init = function() error("ui broke") end; fire("ADDON_LOADED", "WarcraftLore")')
    lua.execute("printed = {}")
    lua.execute('guids.target = "Creature-900001"; SlashCmdList.WARCRAFTLORE("")')
    results.append(check("window off: /wcl says so, once, no per-feature error",
                         len(lines(lua)) == 1 and "not available" in lines(lua)[0]
                         and lua.eval('ns.FeatureOff("cmd:")') is False, lines(lua)))

    # 4. /wcl why
    lua = runtime()
    lua.execute('targetExists = false; SlashCmdList.WARCRAFTLORE("why")')
    results.append(check("why: no target", "no target" in lines(lua)[-1]))
    for guid, needle in (("Player-1-ABC", "player"), (None, "not sharing"), ("Creature-12345", "not in the database")):
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
    lua.execute('guids.target = "Pet-0-1"; SlashCmdList.WARCRAFTLORE("why")')
    results.append(check("why: no GUID/secret jargon", not any(w in x for x in lines(lua) for w in ("GUID", "secret")),
                         lines(lua)))
    lua.execute('SlashCmdList.WARCRAFTLORE("help")')
    results.append(check("help lists /wcl why", any("/wcl why" in x for x in lines(lua))))

    print(f"\n{sum(results)}/{len(results)} passed")
    raise SystemExit(0 if all(results) else 1)


if __name__ == "__main__":
    main()

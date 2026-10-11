"""Loads WarcraftLore/Options.lua in Lua 5.1 (via lupa) with stubbed frames and checks that the
settings page registers, that clicks change the saved settings, and that a client without a
settings panel is left alone.

Usage: python tests/test_options.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa

ROOT = Path(__file__).resolve().parent.parent / "WarcraftLore"

STUBS = """
    local function newFrame()
        local f = { scripts = {}, shown = true }
        return setmetatable(f, { __index = function(t, k)
            if k == "SetScript" then return function(self, n, fn) self.scripts[n] = fn end end
            if k == "GetStringWidth" then return function() return 80 end end
            if k == "SetShown" then return function(self, v) self.shown = v end end
            if k == "CreateTexture" or k == "CreateFontString" then return function() return newFrame() end end
            return function() end
        end })
    end
    CreateFrame = function() local f = newFrame(); frames[#frames + 1] = f; return f end
    UIParent = newFrame()
    STANDARD_TEXT_FONT = "Fonts\\\\FRIZQT__.TTF"
"""


def run(with_settings, legacy=False):
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute("frames = {}; calls = {}; minimapToggles = 0; refreshes = 0; resets = 0; pinRefreshes = 0")
    lua.execute(STUBS)
    if with_settings:
        lua.execute("""
            Settings = {
                RegisterCanvasLayoutCategory = function(p, n) calls[#calls + 1] = "canvas:" .. n; return { GetID = function() return 7 end } end,
                RegisterAddOnCategory = function(c) calls[#calls + 1] = "addon" end,
                OpenToCategory = function(id) calls[#calls + 1] = "open:" .. id end,
            }
        """)
    if legacy:
        lua.execute("InterfaceOptions_AddCategory = function(p) calls[#calls + 1] = 'legacy' end")
    lua.execute("""
        WarcraftLoreDB = { auto = true, alert = false, minimap = {} }
        ns = {
            L = setmetatable({}, { __index = function(_, k) return k end }), 
            Compat = { RegisterClicks = function() end, SetFont = function() end,
                       FONT_BODY = "b", FONT_TITLE = "t" },
            Minimap = { Toggle = function() minimapToggles = minimapToggles + 1
                        WarcraftLoreDB.minimap.hide = not WarcraftLoreDB.minimap.hide or nil end },
            Browser = { Toggle = function() end, Refresh = function() refreshes = refreshes + 1 end,
                        ResetPosition = function() resets = resets + 1 end },
            MapPins = { Refresh = function() pinRefreshes = pinRefreshes + 1 end },
            UI = { ResetPosition = function() resets = resets + 1 end },
        }
    """)
    for name in ("Style.lua", "Options.lua"):
        src = (ROOT / name).read_text(encoding="utf-8")
        lua.eval("function(src, n) assert(loadstring(src, n))('WarcraftLore', ns) end")(src, name)
    return lua


def check(name, cond):
    print(("ok   " if cond else "FAIL ") + name)
    return cond


def main():
    results = []

    lua = run(True)
    lua.execute("loader = frames[#frames]; loader.scripts.OnEvent(loader)")
    results.append(check("registers canvas category", lua.eval("calls[1]") == "canvas:Warcraft Lore" and lua.eval("calls[2]") == "addon"))
    results.append(check("Open() opens the category", lua.eval("ns.Options.Open()") and lua.eval("calls[3]") == "open:7"))
    # Controls with an OnClick, in creation order: 5 checkboxes, then 2 buttons.
    lua.execute("""
        clickable = {}
        for _, f in ipairs(frames) do if f.scripts.OnClick then clickable[#clickable + 1] = f end end
    """)
    results.append(check("seven clickable controls", lua.eval("#clickable") == 7))
    lua.execute("clickable[1].scripts.OnClick(); clickable[2].scripts.OnClick()")
    results.append(check("checkbox toggles auto/alert", lua.eval("WarcraftLoreDB.auto") is False and lua.eval("WarcraftLoreDB.alert") is True))
    lua.execute("clickable[3].scripts.OnClick()")
    results.append(check("minimap checkbox hides the button", lua.eval("minimapToggles") == 1 and lua.eval("WarcraftLoreDB.minimap.hide") is True))
    lua.execute("clickable[3].scripts.OnClick()")
    results.append(check("minimap checkbox shows it again", lua.eval("minimapToggles") == 2 and lua.eval("WarcraftLoreDB.minimap.hide") is None))
    lua.execute("clickable[4].scripts.OnClick()")
    results.append(check("world map checkbox turns pins off and refreshes", lua.eval("WarcraftLoreDB.mapPins") is False and lua.eval("pinRefreshes") == 1))
    lua.execute("clickable[5].scripts.OnClick()")
    results.append(check("book-only toggled and list refreshed", lua.eval("WarcraftLoreDB.hideBookOnly") is True and lua.eval("refreshes") == 1))
    lua.execute("ns.ResetWindows = nil; clickable[7].scripts.OnClick()")
    results.append(check("reset button does nothing (no error) without ns.ResetWindows", lua.eval("resets") == 0))

    # Open() returns (true, true) normally, (true, false) when opening fails, false when no panel.
    results.append(check("Open() reports success as (true, true)",
                         list(lua.eval("{ ns.Options.Open() }").values()) == [True, True]))
    lua.execute("Settings.OpenToCategory = function() error('blocked in combat') end")
    results.append(check("Open() failing for another reason still reports a panel",
                         list(lua.eval("{ ns.Options.Open() }").values()) == [True, False]))

    # Refresh() ticks the boxes after a slash command changed a setting.
    lua.execute("WarcraftLoreDB.auto = true; ns.Options.Refresh()")
    results.append(check("Refresh() updates the checkbox", lua.eval("clickable[1].get(WarcraftLoreDB)") is True))

    # A failing action is contained by ns.Guard and does not reach the caller.
    lua.execute("""
        guardedKeys = {}
        ns.Guard = function(key, label, fn)
            return function(...) local ok = pcall(fn, ...); if not ok then guardedKeys[#guardedKeys + 1] = key end end
        end
        ns.Minimap.Toggle = function() error("minimap broke") end
    """)
    lua.execute("clickable[3].scripts.OnClick()")
    results.append(check("checkbox click is guarded", lua.eval("#guardedKeys") == 1))

    # "Reset window positions" goes through ns.ResetWindows (same chat line as /wcl reset).
    lua.execute("resetCalls = 0; ns.ResetWindows = function() resetCalls = resetCalls + 1 end")
    lua.execute("clickable[7].scripts.OnClick()")
    results.append(check("reset button uses ns.ResetWindows", lua.eval("resetCalls") == 1))

    lua = run(False)
    lua.execute("loader = frames[#frames]; loader.scripts.OnEvent(loader)")
    results.append(check("no Settings API: nothing registered, no error", lua.eval("#calls") == 0 and lua.eval("ns.Options.Open()") is False))

    lua = run(False, legacy=True)
    lua.execute("loader = frames[#frames]; loader.scripts.OnEvent(loader)")
    results.append(check("legacy fallback registers", lua.eval("calls[1]") == "legacy"))

    print(f"\n{sum(results)}/{len(results)} passed")
    raise SystemExit(0 if all(results) else 1)


if __name__ == "__main__":
    main()

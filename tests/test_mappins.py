"""World map pins (MapPins.lua) in Lua 5.1 via lupa with a stub WorldMapFrame and canvas: pins for
the right map at the right fractions, met styling, the on/off option, no error without a world
map, and click registration on every pin.

Usage: python tests/test_mappins.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa

ROOT = Path(__file__).resolve().parent.parent / "WarcraftLore"

STUBS = """
    local function newFrame(parent)
        local f = { scripts = {}, shown = true, parent = parent, points = {}, hooks = {}, scale = 1, events = {} }
        local methods = {
            SetScript = function(self, n, fn) self.scripts[n] = fn end,
            HookScript = function(self, n, fn) self.hooks[n] = fn end,
            SetShown = function(self, v) self.shown = v end,
            Show = function(self) self.shown = true end,
            Hide = function(self) self.shown = false end,
            IsShown = function(self) return self.shown end,
            SetPoint = function(self, p, rel, rp, x, y) self.points[#self.points + 1] = { p, rel, rp, x, y } end,
            ClearAllPoints = function(self) self.points = {} end,
            SetScale = function(self, s) self.scale = s end,
            GetScale = function(self) return self.scale end,
            GetWidth = function(self) return self.w or 0 end,
            GetHeight = function(self) return self.h or 0 end,
            SetSize = function(self, w, h) self.w, self.h = w, h end,
            GetFrameLevel = function() return 1 end,
            CreateTexture = function(self) return newFrame(self) end,
            CreateFontString = function(self) return newFrame(self) end,
            SetVertexColor = function(self, r, g, b) self.color = { r, g, b } end,
            SetAlpha = function(self, a) self.alpha = a end,
            UnregisterAllEvents = function(self) self.unregistered = true end,
            GetParent = function(self) return self.parent end,
        }
        return setmetatable(f, { __index = function(t, k) return methods[k] or function() end end })
    end
    CreateFrame = function(kind, name, parent)
        local f = newFrame(parent); f.kind = kind
        frames[#frames + 1] = f
        return f
    end
    UIParent = newFrame()
    STANDARD_TEXT_FONT = "Fonts\\\\FRIZQT__.TTF"
    hooksecurefunc = function(obj, name, fn)
        assert(type(obj[name]) == "function", "no such method " .. name)
        local orig = obj[name]
        obj[name] = function(...) local r = orig(...); fn(...); return r end
    end
"""

SETUP = """
    clicks = {}
    shownEntries = {}
    tooltips = {}
    canvas = CreateFrame("Frame"); canvas.w, canvas.h = 1000, 500
    WorldMapFrame = CreateFrame("Frame")
    WorldMapFrame.mapID = 1411
    WorldMapFrame.GetMapID = function(self) return self.mapID end
    WorldMapFrame.GetCanvas = function() return canvas end
    WorldMapFrame.OnMapChanged = function() end
    WorldMapFrame.OnCanvasScaleChanged = function() end
    WarcraftLoreDB = {}
    local G = {
        { id = 3, ids = { 3 }, codes = { "WC3", "TFT" }, entry = { name = "Thrall", zone = "Durotar", coords = "50.0, 20.0" } },
        { id = 9, ids = { 9 }, codes = { "WC1" },        entry = { name = "Grom",   zone = "Durotar", coords = "25.5, 80" } },
        { id = 7, ids = { 7 }, codes = { "WC2" },        entry = { name = "Elsewhere", zone = "Mulgore", coords = "10, 10" } },
        { id = 8, ids = { 8 }, codes = { "BOOK" },       entry = { name = "Nocoords", zone = "Durotar" } },
    }
    metIDs = { [3] = true }
    ns = {
        Compat = {
            RegisterClicks = function(b) clicks[#clicks + 1] = b; b.clicksRegistered = true end,
            FONT_BODY = "b", FONT_TITLE = "t", SetFont = function() end,
            ApplyCircleMask = function() return true end,
            RegisterEventSafe = function(f, e) f.events[e] = true; return true end,
            ShowTooltip = function(owner, anchor, lines) tooltips[#tooltips + 1] = { owner = owner, lines = lines } end,
            HideTooltip = function() tooltips.hidden = (tooltips.hidden or 0) + 1 end,
        },
        ZONE_MAPS = { Durotar = { 1411, 1 }, Mulgore = { 1412, 7 } },
        Veterans = function() return G end,
        GroupMet = function(g) return metIDs[g.id] == true end,
        MetSummary = function(id) return metIDs[id] and "Met once" or nil end,
        CodesLabel = function(codes) return table.concat(codes, "/") end,
        GameRGB = function(code) return 0.5, 0.25, 0.75 end,
        UI = { ShowEntry = function(id, entry) shownEntries[#shownEntries + 1] = id end },
    }
"""


def load(lua):
    for name in ("Style.lua", "MapPins.lua"):
        src = (ROOT / name).read_text(encoding="utf-8")
        lua.eval("function(src, n) assert(loadstring(src, n))('WarcraftLore', ns) end")(src, name)


def make(with_guard=True):
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute("frames = {}")
    lua.execute(STUBS)
    lua.execute(SETUP)
    if with_guard:
        lua.execute("""
            guardErrors = {}
            ns.Guard = function(key, label, fn)
                return function(...)
                    local ok, err = pcall(fn, ...)
                    if not ok then guardErrors[#guardErrors + 1] = key .. ": " .. tostring(err) end
                end
            end
        """)
    return lua


def check(name, cond):
    print(("ok   " if cond else "FAIL ") + name)
    return cond


def main():
    results = []

    # --- normal client: map 1411 (Durotar) is shown
    lua = make()
    load(lua)
    lua.execute("loader = frames[#frames]; loader.scripts.OnEvent(loader, 'PLAYER_LOGIN')")
    results.append(check("listens for login and the world map addon",
                         lua.eval("loader.events.PLAYER_LOGIN") is True and lua.eval("loader.events.ADDON_LOADED") is True))
    n = lua.eval("#ns.MapPins.Active()")
    results.append(check("two pins for Durotar (not Mulgore, not the one without coords)", n == 2))
    lua.execute("pin = ns.MapPins.Active()")
    results.append(check("Thrall at 50%/20% of a 1000x500 canvas",
                         lua.eval("pin[1].frame.points[1][3]") == "TOPLEFT"
                         and lua.eval("pin[1].frame.points[1][4]") == 500
                         and lua.eval("pin[1].frame.points[1][5]") == -100))
    results.append(check("Grom at 25.5%/80%",
                         abs(lua.eval("pin[2].frame.points[1][4]") - 255) < 1e-6
                         and lua.eval("pin[2].frame.points[1][5]") == -400))
    results.append(check("pins hang on the holder frame over the canvas",
                         lua.eval("pin[1].frame.points[1][2] == pin[1].frame.parent")
                         and lua.eval("pin[1].frame.parent.parent == canvas")))
    results.append(check("met pin: green dot shown and fully opaque; unmet: hidden dot, dimmer",
                         lua.eval("pin[1].met") is True and lua.eval("pin[1].frame.tick.shown") is True
                         and lua.eval("pin[1].frame.fill.alpha") == 1
                         and lua.eval("pin[2].met") is False and lua.eval("pin[2].frame.tick.shown") is False
                         and lua.eval("pin[2].frame.fill.alpha") < 1))
    results.append(check("pin color comes from the first game",
                         list(lua.eval("pin[1].frame.fill.color").values()) == [0.5, 0.25, 0.75]))

    # every pin registered for clicks
    results.append(check("every pin button registered for clicks",
                         lua.eval("#clicks") == 2 and lua.eval("clicks[1].clicksRegistered and clicks[2].clicksRegistered")))

    # tooltip and click
    lua.execute("pin[1].frame.scripts.OnEnter(); pin[2].frame.scripts.OnEnter()")
    results.append(check("tooltip: name, games and met status",
                         lua.eval("tooltips[1].lines[1][1]") == "Thrall" and lua.eval("tooltips[1].lines[2][1]") == "WC3/TFT"
                         and lua.eval("tooltips[1].lines[3][1]") == "Met once"
                         and lua.eval("tooltips[2].lines[3][1]") == "Not met yet"))
    lua.execute("pin[1].frame.scripts.OnClick(pin[1].frame, 'LeftButton')")
    results.append(check("click opens the lore window", lua.eval("shownEntries[1]") == 3))

    # map change re-lays out and hides pins
    lua.execute("WorldMapFrame.mapID = 1412; WorldMapFrame:OnMapChanged()")
    results.append(check("other map: its own pin only", lua.eval("#ns.MapPins.Active()") == 1))
    lua.execute("pinFrames = { pin[1].frame, pin[2].frame }")
    lua.execute("WorldMapFrame.mapID = 999; WorldMapFrame:OnMapChanged()")
    results.append(check("map without veterans: no pins, pool pins hidden",
                         lua.eval("#ns.MapPins.Active()") == 0 and lua.eval("not pinFrames[1].shown")))
    lua.execute("WorldMapFrame.mapID = 1411; WorldMapFrame:OnMapChanged()")
    results.append(check("back on Durotar: pins reused, not created again",
                         lua.eval("#ns.MapPins.Active()") == 2 and lua.eval("#clicks") == 2))

    # zoom: pins keep their screen size
    lua.execute("canvas.scale = 0.5; WorldMapFrame:OnCanvasScaleChanged()")
    lua.execute("pin = ns.MapPins.Active()")
    results.append(check("pin scale is 1/canvas scale, offsets compensated",
                         lua.eval("pin[1].frame.scale") == 2 and lua.eval("pin[1].frame.points[1][4]") == 250))
    lua.execute("canvas.scale = 1")

    # map closed: no layout work
    lua.execute("WorldMapFrame.shown = false; WorldMapFrame.mapID = 1412; WorldMapFrame:OnMapChanged()")
    results.append(check("hidden map is not laid out", lua.eval("#ns.MapPins.Active()") == 2))
    lua.execute("WorldMapFrame.shown = true; WorldMapFrame.hooks.OnShow()")
    results.append(check("OnShow lays out the current map", lua.eval("#ns.MapPins.Active()") == 1))
    lua.execute("WorldMapFrame.mapID = 1411; WorldMapFrame.hooks.OnShow()")

    # toggle off hides all
    lua.execute("WarcraftLoreDB.mapPins = false; ns.MapPins.Refresh()")
    results.append(check("option off: all pins hidden", lua.eval("#ns.MapPins.Active()") == 0))
    lua.execute("WorldMapFrame:OnMapChanged()")
    results.append(check("option off: map changes add nothing", lua.eval("#ns.MapPins.Active()") == 0))
    lua.execute("WarcraftLoreDB.mapPins = nil; ns.MapPins.Refresh()")
    results.append(check("option unset means on", lua.eval("#ns.MapPins.Active()") == 2))
    results.append(check("no guard errors", lua.eval("#guardErrors") == 0))

    # --- the canvas falls back to ScrollContainer.Child
    lua = make()
    lua.execute("WorldMapFrame.GetCanvas = false; WorldMapFrame.ScrollContainer = { Child = canvas }")
    load(lua)
    lua.execute("ns.MapPins.Init()")
    results.append(check("falls back to ScrollContainer.Child", lua.eval("#ns.MapPins.Active()") == 2))

    # --- no world map at all: nothing happens, no error, init is retried later
    lua = make()
    lua.execute("WorldMapFrame = nil")
    load(lua)
    ok = lua.eval("pcall(function() loader = frames[#frames]; loader.scripts.OnEvent(loader, 'PLAYER_LOGIN'); "
                  "ns.MapPins.Refresh(); ns.MapPins.Init() end)")
    results.append(check("missing WorldMapFrame: no error, no pins, no chat",
                         ok is True and lua.eval("#ns.MapPins.Active()") == 0 and lua.eval("#guardErrors") == 0))
    lua.execute("loader.scripts.OnEvent(loader, 'ADDON_LOADED', 'SomethingElse')")
    results.append(check("other addons loading are ignored", lua.eval("#guardErrors") == 0))
    lua.execute("""
        canvas = CreateFrame("Frame"); canvas.w, canvas.h = 800, 400
        WorldMapFrame = CreateFrame("Frame"); WorldMapFrame.mapID = 1411
        WorldMapFrame.GetMapID = function(self) return self.mapID end
        WorldMapFrame.GetCanvas = function() return canvas end
        WorldMapFrame.OnMapChanged = function() end
        loader.scripts.OnEvent(loader, 'ADDON_LOADED', 'Blizzard_WorldMap')
    """)
    results.append(check("world map loaded later: pins appear", lua.eval("#ns.MapPins.Active()") == 2
                         and lua.eval("loader.unregistered") is True))

    # --- a changed map API only switches the pins off (one guard report), nothing throws
    lua = make()
    lua.execute("WorldMapFrame.OnMapChanged = false; WorldMapFrame.OnCanvasScaleChanged = false; "
                "WorldMapFrame.HookScript = false; canvas.HookScript = false")
    load(lua)
    ok = lua.eval("pcall(function() ns.MapPins.Init() end)")
    results.append(check("no usable hook: one guard report, no error, no pins",
                         ok is True and lua.eval("#guardErrors") == 1 and lua.eval("#ns.MapPins.Active()") == 0))

    lua = make()
    lua.execute("WorldMapFrame.GetMapID = function() error('API changed') end")
    load(lua)
    lua.execute("ns.MapPins.Init()")
    results.append(check("GetMapID breaking is contained by the guard",
                         lua.eval("#guardErrors") >= 1 and lua.eval("#ns.MapPins.Active()") == 0))

    print(f"\n{sum(results)}/{len(results)} passed")
    raise SystemExit(0 if all(results) else 1)


if __name__ == "__main__":
    main()

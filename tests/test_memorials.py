"""Memorials (Memorials.lua + their detection, saved data, lore window, list, map pins and
achievements) in Lua 5.1 via lupa with a fake WoW client.

Usage: python tests/test_memorials.py   (needs: pip install lupa)
"""

import sys
from pathlib import Path

import lupa.lua51 as lupa

sys.path.insert(0, str(Path(__file__).resolve().parent))
from test_portrait import STUBS  # noqa: E402  (the fake client: frames, textures, a tooltip)

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"
FILES = ("Compat.lua", "Locale.lua", "Data.lua", "Memorials.lua", "SavedData.lua", "Core.lua", "Achievements.lua",
         "Style.lua", "UI.lua", "Browser.lua", "MapPins.lua")

EXTRA = """
UIParent = CreateFrame("Frame")
time = function() return 1759449600 end
date = os.date
printed, sounds, postCalls, itemTextName = {}, 0, {}, nil
chatFrame = { AddMessage = function(_, m) printed[#printed + 1] = m end }
DEFAULT_CHAT_FRAME = chatFrame
PlaySound = function() sounds = sounds + 1 end
SOUNDKIT = { MAP_PING = 1 }
ItemTextGetItem = function() return itemTextName end
Enum = { TooltipDataType = { Unit = 1, Object = 2 } }
tooltipUnit = nil
tooltipText = nil
tooltipLines = {}
GameTooltip = {
    AddLine = function(_, text) tooltipLines[#tooltipLines + 1] = text end,
    GetUnit = function() return nil, tooltipUnit end,
    NumLines = function() return #tooltipLines end,
    Show = function() end, Hide = function() end,
}
GameTooltipTextLeft1 = { GetText = function() return tooltipText end }
hooksecurefunc = function(obj, name, fn)
    local orig = obj[name]
    obj[name] = function(...) local r = orig(...); fn(...); return r end
end
"""

OLD_CLIENT = """
TooltipDataProcessor = nil
onShow = nil
GameTooltip.HookScript = function(_, name, fn) if name == "OnShow" then onShow = fn end end
"""

NEW_CLIENT = """
TooltipDataProcessor = { AddTooltipPostCall = function(kind, fn) postCalls[kind] = fn end }
"""

ACCOUNT_V3 = "{ schema = 3, auto = true, alert = true, minimap = {}, met = { [4949] = { first = 5, count = 2 } }, achievements = { milestone_1 = 1 }, achievementsSeeded = true }"


def runtime(client=NEW_CLIENT, account=ACCOUNT_V3, files=FILES, load_db=True):
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    lua.execute(EXTRA)
    lua.execute(client)
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    for name in files:
        run((ADDON / name).read_text(encoding="utf-8"), name)
        if name == "Compat.lua":
            # The fake texture never reports a path back, so SetIconTexture would always fall back.
            lua.execute("ns.Compat.SetIconTexture = function(t, path) t:SetTexture(path) return true end")
        if name == "Core.lua":
            lua.execute("coreEvents = frames[#frames]")
    lua.execute("ns.Minimap = { Init = function() end }")
    if load_db:
        lua.execute("WarcraftLoreDB = " + account + "; WarcraftLoreCharDB = { schema = 2 }")
        lua.execute("coreEvents.scripts.OnEvent(coreEvents, 'ADDON_LOADED', 'WarcraftLore')")
    return lua


def check(name, cond, detail=""):
    print(("ok   " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    return bool(cond)


def main():
    r = []
    lua = runtime()
    ev, ex = lua.eval, lua.execute

    # --- data
    n = ev("#ns.MemorialList()")
    r.append(check("30 memorials load (12 + 18 books)", n == 30, n))
    r.append(check("lookup by name ignores case and surrounding spaces",
                   ev("ns.MemorialByName('  general TURALYON ').key") == "turalyon"
                   and ev("ns.MemorialByName('Nobody') == nil") and ev("ns.MemorialByName(nil) == nil")))
    r.append(check("every memorial has games in release order",
                   ev("""(function() for _, m in ipairs(ns.MemorialList()) do if #m.codes == 0 then return false end end return true end)()""")))

    # --- saved data: migration 4 from schema 3
    r.append(check("migration 4: schema 4 with an empty visited table, old data kept",
                   ev("WarcraftLoreDB.schema") == 4 and ev("ns.SavedData.ACCOUNT_SCHEMA") == 4
                   and ev("next(WarcraftLoreDB.visited) == nil") and ev("WarcraftLoreDB.met[4949].count") == 2))
    ex("local db = { schema = 4, visited = 'broken' }; WarcraftLoreDB = db")
    ex("ns.SavedData.Load()")
    r.append(check("migration 4 leaves a schema-4 file alone", ev("WarcraftLoreDB.visited") == "broken"))
    ex("WarcraftLoreDB = " + ACCOUNT_V3)
    ex("ns.SavedData.Load()")

    # --- hover (tooltip post-call for world objects)
    r.append(check("hook: TooltipDataProcessor for objects", ev("ns.memorialHook") == "TooltipDataProcessor.Object"))
    ex("""
        function hover(name, guid, unit)
            tooltipLines, tooltipUnit, tooltipText = {}, unit, name
            postCalls[Enum.TooltipDataType.Object](GameTooltip, { guid = guid or "GameObject-0-1-2-3-25330-4", lines = { { leftText = name } } })
        end
        printed = {}
    """)
    ex("hover('General Turalyon')")
    line = ev("tooltipLines[1]") or ""
    r.append(check("hover adds the memorial line with honors and games",
                   line.startswith("Warcraft Memorial: Turalyon (") and "BtDP" in line and ev("#tooltipLines") == 1, line))
    r.append(check("hover marks it visited", ev("ns.IsVisited('turalyon')") is True
                   and ev("WarcraftLoreDB.visited.turalyon.first") == 1759449600))
    r.append(check("first visit: one chat line naming memorial and honors",
                   ev("#printed") == 1 and "Memorial visited: General Turalyon – honors Turalyon" in ev("printed[1]"), ev("printed[1]")))
    r.append(check("first visit: one sound", ev("sounds") == 1))
    ex("printed = {}; hover('General Turalyon')")
    r.append(check("second hover: line again, no new chat line or sound", ev("#tooltipLines") == 1 and ev("#printed") == 0 and ev("sounds") == 1))
    ex("hover('  king llane i of the house of wrynn ')")
    r.append(check("name match ignores case and spaces", ev("ns.IsVisited('llane')") is True and ev("#tooltipLines") == 1))
    ex("hover('Thrall')")
    r.append(check("another object name: no line", ev("#tooltipLines") == 0))
    ex("hover('Danath Trollbane', nil, 'mouseover')")
    r.append(check("with a unit on the tooltip: no line, not visited", ev("#tooltipLines") == 0 and ev("ns.IsVisited('danath')") is False))
    ex("hover('Danath Trollbane', 'Creature-0-1-2-3-12345-6')")
    r.append(check("creature GUID: no line, not visited", ev("#tooltipLines") == 0 and ev("ns.IsVisited('danath')") is False))
    ex("hover('Danath Trollbane', 'Player-1-2')")
    r.append(check("player GUID: no line", ev("#tooltipLines") == 0))
    ex("tooltipText = nil; postCalls[Enum.TooltipDataType.Object](GameTooltip, nil)")
    r.append(check("tooltip without data: no error, no line", True))
    ex("tooltipLines, tooltipText, tooltipUnit = {}, 'Kurdran Wildhammer', nil; postCalls[2](GameTooltip, {})")
    r.append(check("first line read from the tooltip text when the data has none",
                   ev("ns.IsVisited('kurdran')") is True and ev("#tooltipLines") == 1))
    ex("tooltipLines = {}; postCalls[2]({}, { lines = { { leftText = 'General Turalyon' } } })")
    r.append(check("other tooltips than GameTooltip are ignored", ev("#tooltipLines") == 0))
    r.append(check("hovering never errored the feature", ev("ns.FeatureOff('memorial-tooltip')") is False))

    # --- reading a plaque
    ex("printed = {}; itemTextName = \"Trollbane's Tomb\"; coreEvents.scripts.OnEvent(coreEvents, 'ITEM_TEXT_BEGIN')")
    r.append(check("ITEM_TEXT_BEGIN with a memorial's name marks it visited", ev("ns.IsVisited('trollbane')") is True and ev("#printed") == 1))
    ex("itemTextName = 'A Treatise on Military Ranks'; coreEvents.scripts.OnEvent(coreEvents, 'ITEM_TEXT_BEGIN')")
    r.append(check("another text marks nothing", ev("ns.IsVisited('uther')") is False))
    ex("itemTextName = nil; coreEvents.scripts.OnEvent(coreEvents, 'ITEM_TEXT_BEGIN')")
    r.append(check("no text name: no error", ev("ns.FeatureOff('memorial-text')") is False))
    ex("itemTextName = 'Uther the Lightbringer'; coreEvents.scripts.OnEvent(coreEvents, 'ITEM_TEXT_BEGIN')")
    r.append(check("reading Uther's plaque", ev("ns.IsVisited('uther')") is True))
    r.append(check("visited count", ev("(ns.VisitedCounts())") == 5 and ev("select(2, ns.VisitedCounts())") == 30))
    r.append(check("visit summary names the date", "Visited on 3 Oct 2025" in (ev("ns.VisitSummary('uther')") or "")
                   and ev("ns.VisitSummary('grom')") is None, ev("ns.VisitSummary('uther')")))

    # alerts off: no sound
    ex("WarcraftLoreDB.alert = false; sounds = 0; hover('Monument to Grom Hellscream')")
    r.append(check("alerts off: visit counted, no sound", ev("ns.IsVisited('grom')") is True and ev("sounds") == 0))
    ex("WarcraftLoreDB.alert = true")

    # --- the lore window
    ok = ev("pcall(ns.UI.ShowMemorial, 'uther')")
    r.append(check("ShowMemorial builds without errors", ok is True))
    r.append(check("window shows the memorial", ev("ns.UI.GetShownMemorial()") == "uther" and ev("ns.UI.GetShownNPC()") is None))
    icons = ev("""(function() local out = {} for _, t in ipairs(textures) do if t.path and t.path:find("Interface\\\\Icons") then out[#out + 1] = t.path end end return table.concat(out, "|") end)()""")
    r.append(check("tomb icon in the portrait ring", "INV_Misc_Bone_HumanSkull_01" in icons, icons))
    for key in ("turalyon", "mannoroth", "grom", "llane"):
        r.append(check(f"ShowMemorial('{key}') builds", ev(f"pcall(ns.UI.ShowMemorial, '{key}')") is True))
    r.append(check("unknown key shows a message instead of erroring", ev("pcall(ns.UI.ShowMemorial, 'nope')") is True
                   and ev("ns.UI.GetShownMemorial()") is None))
    ex("ns.UI.ShowMemorial('uther')")
    ex("ns.UI.RefreshVisited('uther')")
    r.append(check("RefreshVisited and RefreshOpen work on an open memorial", ev("pcall(ns.UI.RefreshOpen)") is True))
    ex("ns.UI.ShowEntry(4949, ns.NPCS[4949] or { name = 'x', appearances = {}, sources = {} })")
    r.append(check("a veteran after a memorial clears the memorial", ev("ns.UI.GetShownMemorial()") is None))

    # --- the veterans list
    ex("ns.Browser.Toggle(); ns.Browser.Refresh(true)")
    rows = lambda: ev("""(function() local n, mem = 0, 0 for _, f in ipairs(frames) do if f.item and f.shown then n = n + 1; if f.item.memorial then mem = mem + 1 end end end return n, mem end)()""")
    total, mem = rows()
    r.append(check("list starts with veterans only", total > 12 and mem == 0, (total, mem)))
    ex("ns.Browser.SetMemorials(true)")
    total, mem = rows()
    r.append(check("Memorials switch lists the 30 memorials", total == 30 and mem == 30, (total, mem)))
    chip = lambda code: ev("(function() for _, f in ipairs(frames) do if f.code == '%s' and f.scripts.OnClick then return f end end end)()" % code)
    r.append(check("WC1, WC2, BtDP and TFT chips have content in memorial mode (TFT: the books)",
                   all(chip(c).shown for c in ("WC1", "WC2", "BTDP", "TFT"))))
    chip("WC1").scripts.OnClick()
    total, mem = rows()
    r.append(check("WC1 chip: Llane's memorial and 3 books", total == 4 and mem == 4, (total, mem)))
    chip("WC1").scripts.OnClick()
    chip("BTDP").scripts.OnClick()
    total, _ = rows()
    r.append(check("BtDP chip: Daelin, Turalyon, Khadgar, Alleria, Danath, Kurdran, Grom + 2 books", total == 9, total))
    chip("BTDP").scripts.OnClick()
    ex("""(function()
        for _, f in ipairs(frames) do
            if f.item and f.item.memorial and f.shown and f.item.key == 'uther' then clickedRow = f end
        end end)()""")
    ex("clickedRow.scripts.OnClick(clickedRow)")
    r.append(check("clicking a memorial row opens its lore window", ev("ns.UI.GetShownMemorial()") == "uther"))
    ex("clickedRow.scripts.OnEnter(clickedRow)")
    r.append(check("row hover builds a tooltip without errors", True))
    ex("ns.Browser.SetMemorials(false)")
    total, mem = rows()
    r.append(check("switching back lists the veterans again", total > 12 and mem == 0, (total, mem)))
    r.append(check("a zone from the atlas leaves memorial mode", (lambda: (lua.execute("ns.Browser.SetMemorials(true); ns.Browser.ShowZone('Orgrimmar')"), ev("ns.Browser.IsShowingMemorials()"))[1])() is False))

    # --- zone, campaign and "This zone" filters on the memorials
    ex("ns.Browser.SetMemorials(true)")
    memZones = ev("(function() local s, n = {}, 0 for _, m in pairs(ns.MEMORIALS) do if not s[m.zone] then s[m.zone] = true n = n + 1 end end return n end)()")
    inZone = lambda z: ev("(function() local n = 0 for _, m in pairs(ns.MEMORIALS) do if m.zone == '%s' then n = n + 1 end end return n end)()" % z)
    btn = lambda needle: ev("""(function() for _, f in ipairs(frames) do
        if f.label and type(f.label.text) == 'string' and f.label.text:find('%s', 1, true) and f.scripts.OnClick then return f end
        end end)()""" % needle)
    pick = lambda value: ev("""(function() for _, f in ipairs(frames) do
        if f.value == '%s' and f.shown and f.scripts.OnClick and not f.item then return f end
        end end)()""" % value)
    zoneBtn = btn("All zones")
    r.append(check("Zone button is shown in memorial mode", zoneBtn is not None and zoneBtn.shown))
    zoneBtn.scripts.OnClick(zoneBtn)
    picks = ev("(function() local n = 0 for _, f in ipairs(frames) do if f.value and f.shown and f.isHeader == false then n = n + 1 end end return n end)()")
    r.append(check("memorial zone picker lists only memorial zones", picks == memZones, (picks, memZones)))
    row = pick("Stormwind City")
    row.scripts.OnClick(row)
    total, mem = rows()
    r.append(check("picking Stormwind City shows its memorials", total == inZone("Stormwind City") and mem == total, total))
    campBtn = btn("All campaigns")
    r.append(check("Campaign button is shown in memorial mode", campBtn is not None and campBtn.shown))
    campBtn.scripts.OnClick(campBtn)
    row = pick("Tides of Darkness (Human)")
    row.scripts.OnClick(row)
    total, _ = rows()
    r.append(check("zone + campaign narrow the memorials", 0 < total < inZone("Stormwind City"), total))
    ex("ns.Compat.GetZoneMapID = nil; ns.Compat.GetZoneName = function() return 'Orgrimmar' end")
    r.append(check("This zone in memorial mode stays on the memorials",
                   ev("ns.Browser.ThisZone()") is True and ev("ns.Browser.IsShowingMemorials()") is True))
    total, mem = rows()
    r.append(check("This zone filters the memorials to Orgrimmar (campaign kept)", mem == total and total <= inZone("Orgrimmar")))
    ex("ns.Browser.SetMemorials(false)")

    # --- dragging the list's scrollbar
    ex("""
        hit, sf = nil, nil
        for _, f in ipairs(frames) do
            if f.kind == 'Frame' and f.scripts.OnMouseDown and f.scripts.OnMouseUp then hit = hit or f end
            if f.kind == 'ScrollFrame' and f.scripts.OnVerticalScroll then sf = sf or f end
        end
        local track = hit.parent
        for _, t in ipairs(textures) do if t.parent == track then thumbTex = t end end
        scrolledTo = nil
        sf.GetVerticalScrollRange = function() return 200 end
        sf.SetVerticalScroll = function(_, v) scrolledTo = v end
        track.GetTop = function() return 300 end
        track.GetHeight = function() return 100 end
        thumbTex.GetTop = function() return 300 end
        thumbTex.GetHeight = function() return 20 end
        thumbTex.shown = true
        cursorY = 250
        GetCursorPosition = function() return 0, cursorY end
    """)
    r.append(check("the list has a draggable scrollbar", ev("hit ~= nil and sf ~= nil")))
    ex("hit.scripts.OnMouseDown(hit, 'LeftButton')")
    r.append(check("pressing the track beside the thumb jumps there", ev("scrolledTo") == 100, ev("scrolledTo")))
    ex("cursorY = 150; hit.scripts.OnUpdate(hit)")
    r.append(check("dragging past the end stops at the bottom", ev("scrolledTo") == 200, ev("scrolledTo")))
    ex("cursorY = 295; hit.scripts.OnMouseUp(hit); hit.scripts.OnMouseDown(hit, 'LeftButton')")
    r.append(check("grabbing the thumb does not jump it", ev("scrolledTo") == 0, ev("scrolledTo")))
    ex("cursorY = 255; hit.scripts.OnUpdate(hit)")
    r.append(check("dragging the thumb follows the mouse", ev("scrolledTo") == 100, ev("scrolledTo")))
    ex("hit.scripts.OnMouseUp(hit)")
    r.append(check("releasing the mouse stops the drag", ev("hit.scripts.OnUpdate") is None))

    # --- the world map
    ex("""
        mapId = 1453
        canvas = CreateFrame("Frame")
        WorldMapFrame = CreateFrame("Frame")
        WorldMapFrame.GetMapID = function() return mapId end
        WorldMapFrame.GetCanvas = function() return canvas end
        WorldMapFrame.OnMapChanged = function() end
        WorldMapFrame.OnCanvasScaleChanged = function() end
        ns.MapPins.Init()
    """)
    pins = ev("""(function() local m, v = 0, 0 for _, p in ipairs(ns.MapPins.Active()) do if p.group.memorial then m = m + 1 else v = v + 1 end end return m end)()""")
    r.append(check("Stormwind map: 12 memorial pins (Royal Gallery, Valley of Heroes, 5 books)", pins == 12, pins))
    visited = ev("""(function() local n = 0 for _, p in ipairs(ns.MapPins.Active()) do if p.group.memorial and p.met then n = n + 1 end end return n end)()""")
    r.append(check("visited memorial pins are marked (Turalyon, Llane, Kurdran)", visited == 3, visited))
    ex("""
        mapId = 1422
        WorldMapFrame:OnMapChanged()
    """)
    r.append(check("Western Plaguelands map: Uther's pin", ev("""(function() for _, p in ipairs(ns.MapPins.Active()) do if p.group.key == 'uther' then return p.met end end end)()""") is True))
    ex("""
        for _, p in ipairs(ns.MapPins.Active()) do if p.group.key == 'uther' then p.frame.scripts.OnEnter() p.frame.scripts.OnClick(p.frame, 'LeftButton') end end
    """)
    r.append(check("clicking a memorial pin opens its lore window", ev("ns.UI.GetShownMemorial()") == "uther"))
    ex("mapId = 1438; WorldMapFrame:OnMapChanged()")
    r.append(check("a map without memorials has none", ev("""(function() for _, p in ipairs(ns.MapPins.Active()) do if p.group.memorial then return false end end return true end)()""")))

    # --- achievements
    lua2 = runtime()
    e2, x2 = lua2.eval, lua2.execute
    x2("list = ns.Achievements.List(); by = {} for _, a in ipairs(list) do by[a.id] = a end")
    r.append(check("Pay Your Respects counts the memorials reachable at the level cap (not Uther's Tomb)",
                   e2("by.memorial_all.total") == 11 and e2("by.memorial_all.later") is False
                   and e2("by.memorial_all.category") == "memorial", e2("by.memorial_all.total")))
    r.append(check("Heroes of the Second War: the five Valley of Heroes plaques",
                   e2("by.memorial_valley.total") == 5 and e2("by.memorial_valley.title") == "Heroes of the Second War"
                   and e2("by.memorial_valley.later") is False))
    x2("WarcraftLoreDB.achievementsSeeded = true; printed = {}; sounds = 0")
    for key in ("turalyon", "khadgar", "alleria", "danath"):
        x2(f"ns.MarkVisited('{key}')")
    r.append(check("four plaques: not earned yet", e2("#ns.Achievements.Check()") == 0 and e2("(function() for _, a in ipairs(ns.Achievements.List()) do if a.id == 'memorial_valley' then return a.progress end end end)()") == 4))
    x2("printed = {}; sounds = 0; ns.MarkVisited('kurdran')")
    r.append(check("the fifth plaque earns the achievement: one achievement line, no visit line, one sound",
                   e2("WarcraftLoreDB.achievements.memorial_valley") == 1759449600
                   and e2("#printed") == 1 and "Heroes of the Second War" in e2("printed[1]") and e2("sounds") == 1,
                   (e2("#printed"), e2("sounds"))))
    for key in ("uther", "terenas", "trollbane", "llane", "daelin", "grom", "mannoroth"):
        x2(f"ns.MarkVisited('{key}')")
    r.append(check("all 11 reachable memorials earn Pay Your Respects (Uther's visit is extra)",
                   e2("WarcraftLoreDB.achievements.memorial_all") is not None))

    # Zones above the level cap make the goals wait.
    lua3 = runtime()
    lua3.execute("ns.Achievements.ZONE_LEVEL['Stormwind City'] = 99; by = {} for _, a in ipairs(ns.Achievements.List()) do by[a.id] = a end")
    r.append(check("Valley of Heroes in a zone above the cap: later; Pay Your Respects shrinks to 4",
                   lua3.eval("by.memorial_valley.later") is True and lua3.eval("by.memorial_all.total") == 4))

    # --- a client without TooltipDataProcessor: OnShow hook
    lua4 = runtime(client=OLD_CLIENT)
    e4, x4 = lua4.eval, lua4.execute
    r.append(check("old client: OnShow hook", e4("ns.memorialHook") == "OnShow" and e4("onShow ~= nil")))
    x4("tooltipLines, tooltipText, tooltipUnit = {}, 'Ranger Captain Alleria Windrunner', nil; onShow(GameTooltip)")
    r.append(check("old client: line added and visited", e4("#tooltipLines") == 1 and e4("ns.IsVisited('alleria')") is True))
    x4("tooltipLines, tooltipText, tooltipUnit = {}, 'Ranger Captain Alleria Windrunner', 'mouseover'; onShow(GameTooltip)")
    r.append(check("old client: nothing on a unit tooltip", e4("#tooltipLines") == 0))

    # --- no hook at all
    lua5 = runtime(client="TooltipDataProcessor = nil; GameTooltip.HookScript = nil")
    r.append(check("no way to hook: no hook, the memorial feature is not marked as failed",
                   lua5.eval("ns.memorialHook") is None and lua5.eval("ns.FeatureOff('memorial-hook')") is False))

    # --- guards: a failing tooltip callback turns only that feature off, once
    lua6 = runtime()
    lua6.execute("ns.MarkVisited = function() error('boom') end; printed = {}")
    lua6.execute("tooltipText = 'General Turalyon'; postCalls[2](GameTooltip, { lines = { { leftText = 'General Turalyon' } } })")
    lua6.execute("postCalls[2](GameTooltip, { lines = { { leftText = 'General Turalyon' } } })")
    r.append(check("error in the tooltip feature: off, one chat line",
                   lua6.eval("ns.FeatureOff('memorial-tooltip')") is True and lua6.eval("#printed") == 1))
    r.append(check("the reading feature stays on", lua6.eval("ns.FeatureOff('memorial-text')") is False))

    # --- static checks
    toc = [x.strip() for x in (ADDON / "WarcraftLore.toc").read_text(encoding="utf-8-sig").replace("\\", "/").splitlines()
           if x.strip().endswith(".lua")]
    r.append(check(".toc: Memorials.lua right after Data.lua", toc[toc.index("Data.lua") + 1] == "Memorials.lua"))
    r.append(check("every memorial zone has a map for pins", lua.eval(
        """(function() for _, m in ipairs(ns.MemorialList()) do if not ns.ZONE_MAPS[m.entry.zone] then return m.entry.zone end end return true end)()""") is True))
    r.append(check("Journal has a Memorials chip", 'key = "memorial"' in (ADDON / "Journal.lua").read_text(encoding="utf-8")))

    print(f"\n{sum(r)}/{len(r)} passed")
    raise SystemExit(0 if all(r) else 1)


if __name__ == "__main__":
    main()

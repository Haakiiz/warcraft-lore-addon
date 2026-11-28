"""Item tooltips (Compat.HookItemTooltip + the "Warcraft Lore: ..." lines in Core.lua) in Lua 5.1 via lupa
with a fake WoW client: the name line, the blurb, the gear rule, Shift, the view counter and the settings.

Usage: python tests/test_item_tooltip.py   (needs: pip install lupa)
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from test_memorials import runtime, check  # noqa: E402  (same fake client and loader)

NEW_CLIENT = """
Enum.TooltipDataType.Item = 3
TooltipDataProcessor = { AddTooltipPostCall = function(kind, fn) postCalls[kind] = fn end }
shiftDown, hideHooks, refreshed, shownLink = false, {}, 0, nil
IsShiftKeyDown = function() return shiftDown end
GameTooltip.HookScript = function(self, name, fn) if name == "OnHide" then hideHooks[self] = fn end end
GameTooltip.IsShown = function() return shownLink ~= nil end
GameTooltip.GetItem = function() return "x", shownLink end
GameTooltip.RefreshData = function() refreshed = refreshed + 1 end
ItemRefTooltip = { AddLine = function(_, text) tooltipLines[#tooltipLines + 1] = text end,
                   HookScript = function(self, name, fn) if name == "OnHide" then hideHooks[self] = fn end end }
ShoppingTooltip1 = { AddLine = function(_, text) tooltipLines[#tooltipLines + 1] = text end }
"""

OLD_CLIENT = """
TooltipDataProcessor = nil
itemScripts = {}
tooltipLink = nil
local function oldTooltip(t)
    t.HasScript = function(_, name) return name == "OnTooltipSetItem" end
    t.HookScript = function(self, name, fn) if name == "OnTooltipSetItem" then itemScripts[self] = fn end end
    t.GetItem = function() return "Some item", tooltipLink end
end
oldTooltip(GameTooltip)
ItemRefTooltip = { AddLine = function(_, text) tooltipLines[#tooltipLines + 1] = text end }
oldTooltip(ItemRefTooltip)
"""

HELPERS = """
    -- fill(): the tooltip is filled (again) while open; show(): it opens fresh (closed first).
    function fill(tooltip, id)
        tooltipLines = {}
        postCalls[Enum.TooltipDataType.Item](tooltip, { id = id })
    end
    function show(tooltip, id)
        if hideHooks[tooltip] then hideHooks[tooltip](tooltip) end
        fill(tooltip, id)
    end
"""

HEAD, MEATHOOK, ONYXIA_HEAD = 280438, 271204, 18422  # The Baron's quest head, his gear drop; Onyxia + Thrall


def main():
    r = []
    lua = runtime(client=NEW_CLIENT)
    ev, ex = lua.eval, lua.execute
    ex(HELPERS)

    r.append(check("hook: TooltipDataProcessor for items, OnHide hooked on both tooltips",
                   ev("ns.itemHook") == "TooltipDataProcessor.Item" and ev("hideHooks[GameTooltip] ~= nil")
                   and ev("hideHooks[ItemRefTooltip] ~= nil")))
    r.append(check("index: The Baron owns his heads and his gear", ev("ns.ItemOwners(%d)[1]" % HEAD) == 250660
                   and ev("ns.ItemOwners(%d)[1]" % MEATHOOK) == 250660))
    r.append(check("index: an unlisted item has no owner", ev("ns.ItemOwners(6948) == nil")))

    # --- a quest item: full text the first 3 views, then one line
    ex("show(GameTooltip, %d)" % HEAD)
    l1, l2 = ev("tooltipLines[1]") or "", ev("tooltipLines[2]") or ""
    r.append(check("quest item, first view: name line + blurb", ev("#tooltipLines") == 2
                   and l1.startswith("Warcraft Lore: The Baron (") and "Shift" not in l1 and "Garithos" in l2, (l1, l2)))
    ex("fill(GameTooltip, %d); fill(GameTooltip, %d)" % (HEAD, HEAD))
    r.append(check("refills while open do not count as views", ev("WarcraftLoreCharDB.itemSeen[%d]" % HEAD) == 1
                   and ev("#tooltipLines") == 2))
    ex("show(GameTooltip, %d); show(GameTooltip, %d)" % (HEAD, HEAD))
    r.append(check("views 2 and 3 still show the text", ev("#tooltipLines") == 2
                   and ev("WarcraftLoreCharDB.itemSeen[%d]" % HEAD) == 3))
    ex("show(GameTooltip, %d)" % HEAD)
    r.append(check("view 4: one line with a Shift hint", ev("#tooltipLines") == 1 and "Shift" in (ev("tooltipLines[1]") or "")))
    ex("shiftDown = true; fill(GameTooltip, %d); shiftDown = false" % HEAD)
    r.append(check("view 4 with Shift held: the text again", ev("#tooltipLines") == 2))

    # --- gear: one line from the start, Shift shows the text
    ex("show(GameTooltip, %d)" % MEATHOOK)
    r.append(check("gear, first view: one line with a Shift hint", ev("#tooltipLines") == 1
                   and "Shift" in (ev("tooltipLines[1]") or "")))
    ex("shiftDown = true; fill(GameTooltip, %d); shiftDown = false" % MEATHOOK)
    r.append(check("gear with Shift held: name line + blurb", ev("#tooltipLines") == 2))

    # --- shared item: both owners on one line
    ex("show(GameTooltip, %d)" % ONYXIA_HEAD)
    shared = ev("tooltipLines[1]") or ""
    r.append(check("Head of Onyxia names Onyxia and Thrall once each",
                   shared.count("Onyxia (") == 1 and shared.count("Thrall (") == 1, shared))

    # --- which tooltips
    ex("show(GameTooltip, 6948)")
    r.append(check("an unlisted item: no line", ev("#tooltipLines") == 0))
    ex("show(ItemRefTooltip, 268518)")
    r.append(check("chat link tooltip (ItemRefTooltip) gets the lines", ev("#tooltipLines") == 2))
    ex("fill(ShoppingTooltip1, 268518)")
    r.append(check("comparison tooltip gets nothing", ev("#tooltipLines") == 0))
    ex("tooltipLines = {}; postCalls[Enum.TooltipDataType.Item](GameTooltip, nil)")
    r.append(check("no tooltip data: nothing, no error", ev("#tooltipLines") == 0
                   and ev("ns.FeatureOff('item-tooltip')") is False))

    # --- settings
    ex("WarcraftLoreCharDB.itemSeen = nil; WarcraftLoreDB.itemShort = true; show(GameTooltip, %d)" % HEAD)
    r.append(check("'one line' setting: a fresh quest item shows only the name line", ev("#tooltipLines") == 1))
    ex("WarcraftLoreDB.itemShort = nil; WarcraftLoreDB.itemLore = false; show(GameTooltip, %d)" % HEAD)
    r.append(check("lore turned off: nothing", ev("#tooltipLines") == 0))
    ex("WarcraftLoreDB.itemLore = nil")

    # --- Shift pressed while an item tooltip is open: the tooltip is filled again
    ex("shownLink = '|Hitem:%d|h'; coreEvents.scripts.OnEvent(coreEvents, 'MODIFIER_STATE_CHANGED', 'LSHIFT', 1)" % HEAD)
    ex("coreEvents.scripts.OnEvent(coreEvents, 'MODIFIER_STATE_CHANGED', 'LCTRL', 1)")
    r.append(check("Shift change refreshes an open item tooltip (Ctrl does not)", ev("refreshed") == 1))
    ex("shownLink = nil; coreEvents.scripts.OnEvent(coreEvents, 'MODIFIER_STATE_CHANGED', 'LSHIFT', 0)")
    r.append(check("no item tooltip open: no refresh", ev("refreshed") == 1))

    # --- several owners: each name once (two IDs of the same character count once)
    lua2 = runtime(client=NEW_CLIENT, load_db=False)
    lua2.execute("""
        ns.NPCS[900001] = { name = "Alpha", appearances = { { game = "WC2" } }, items = { { id = 999999, blurb = "A." } } }
        ns.NPCS[900002] = { name = "Beta", appearances = { { game = "WC3" } }, items = { { id = 999999 } } }
        ns.NPCS[900003] = { name = "Beta", appearances = { { game = "WC3" } }, items = { { id = 999999 } } }
        WarcraftLoreDB = { schema = 3 }; WarcraftLoreCharDB = { schema = 2 }
        coreEvents.scripts.OnEvent(coreEvents, 'ADDON_LOADED', 'WarcraftLore')
        tooltipLines = {}
        postCalls[Enum.TooltipDataType.Item](GameTooltip, { id = 999999 })
    """)
    multi = lua2.eval("tooltipLines[1]") or ""
    r.append(check("two characters on one line, each once; the first blurb is shown",
                   multi.count("Alpha") == 1 and multi.count("Beta") == 1 and ", " in multi
                   and lua2.eval("tooltipLines[2]") == "A.", multi))
    lua2.execute("ns.NPCS[900004] = { name = 'Gamma', appearances = { { game = 'WC1' } }, items = { { id = 999998 } } }")
    r.append(check("the index is built once (items added later are not picked up)", lua2.eval("ns.ItemOwners(999998) == nil")))

    # --- old client: OnTooltipSetItem on both tooltips, item ID read from the link
    lua3 = runtime(client=OLD_CLIENT)
    e3, x3 = lua3.eval, lua3.execute
    r.append(check("old client: OnTooltipSetItem hook on GameTooltip and ItemRefTooltip",
                   e3("ns.itemHook") == "OnTooltipSetItem" and e3("itemScripts[GameTooltip] ~= nil")
                   and e3("itemScripts[ItemRefTooltip] ~= nil")))
    x3("tooltipLines = {}; tooltipLink = '|cffffffff|Hitem:280438::::::::17:::::::|h[Abominable Head]|h|r'; itemScripts[GameTooltip](GameTooltip)")
    r.append(check("old client: lines from the item link", e3("#tooltipLines") == 2))
    x3("tooltipLines = {}; tooltipLink = nil; itemScripts[GameTooltip](GameTooltip)")
    r.append(check("old client: no link, no line", e3("#tooltipLines") == 0))

    # --- a failing callback turns only the item lines off, with one chat line
    lua4 = runtime(client=NEW_CLIENT)
    lua4.execute("ns.ItemOwners = function() error('boom') end; printed = {}")
    lua4.execute("postCalls[3](GameTooltip, { id = 280438 }); postCalls[3](GameTooltip, { id = 280438 })")
    r.append(check("error in the item line: off, one chat line",
                   lua4.eval("ns.FeatureOff('item-tooltip')") is True and lua4.eval("#printed") == 1))
    r.append(check("the unit tooltip line stays on", lua4.eval("ns.FeatureOff('tooltip')") is False))

    # --- data: every item with a blurb, and gear marked
    lua5 = runtime(client=NEW_CLIENT, load_db=False)
    stats = lua5.eval("""(function()
        local n, blurbs, gear = 0, 0, 0
        for _, e in pairs(ns.NPCS) do for _, it in ipairs(e.items or {}) do
            n = n + 1
            if type(it.blurb) == "string" and it.blurb ~= "" then blurbs = blurbs + 1 end
            if it.gear == true then gear = gear + 1 end
        end end
        return n .. "/" .. blurbs .. "/" .. gear end)()""")
    n, blurbs, gear = (int(x) for x in stats.split("/"))
    r.append(check("data: every item has a blurb, some are gear", n > 300 and blurbs == n and 0 < gear < n, stats))

    print(f"\n{sum(r)}/{len(r)} passed")
    raise SystemExit(0 if all(r) else 1)


if __name__ == "__main__":
    main()

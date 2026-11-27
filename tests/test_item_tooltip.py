"""Item tooltips (Compat.HookItemTooltip + the "Warcraft Lore: ..." line in Core.lua) in Lua 5.1 via lupa
with a fake WoW client.

Usage: python tests/test_item_tooltip.py   (needs: pip install lupa)
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from test_memorials import runtime, check  # noqa: E402  (same fake client and loader)

NEW_CLIENT = """
Enum.TooltipDataType.Item = 3
TooltipDataProcessor = { AddTooltipPostCall = function(kind, fn) postCalls[kind] = fn end }
ItemRefTooltip = { AddLine = function(_, text) tooltipLines[#tooltipLines + 1] = text end }
ShoppingTooltip1 = { AddLine = function(_, text) tooltipLines[#tooltipLines + 1] = text end }
"""

OLD_CLIENT = """
TooltipDataProcessor = nil
itemScripts = {}
tooltipLink = nil
local function oldTooltip(t)
    t.HasScript = function(_, name) return name == "OnTooltipSetItem" end
    t.HookScript = function(self, name, fn) itemScripts[self] = fn end
    t.GetItem = function() return "Some item", tooltipLink end
end
oldTooltip(GameTooltip)
ItemRefTooltip = { AddLine = function(_, text) tooltipLines[#tooltipLines + 1] = text end }
oldTooltip(ItemRefTooltip)
"""


def main():
    r = []
    lua = runtime(client=NEW_CLIENT)
    ev, ex = lua.eval, lua.execute
    ex("""
        function hoverItem(tooltip, id)
            tooltipLines = {}
            postCalls[Enum.TooltipDataType.Item](tooltip, { id = id })
        end
    """)

    r.append(check("hook: TooltipDataProcessor for items", ev("ns.itemHook") == "TooltipDataProcessor.Item"))
    r.append(check("index: both Baron heads belong to The Baron",
                   ev("ns.ItemOwners(280438)[1]") == 250660 and ev("ns.ItemOwners(268518)[1]") == 250660))
    r.append(check("index: an unlisted item has no owner", ev("ns.ItemOwners(6948) == nil")))

    ex("hoverItem(GameTooltip, 280438)")
    line = ev("tooltipLines[1]") or ""
    r.append(check("Abominable Head: one line naming The Baron and his games",
                   ev("#tooltipLines") == 1 and line.startswith("Warcraft Lore: The Baron (") and "TFT" in line
                   and "FK" in line, line))
    ex("hoverItem(GameTooltip, 6948)")
    r.append(check("an unlisted item: no line", ev("#tooltipLines") == 0))
    ex("hoverItem(ItemRefTooltip, 268518)")
    r.append(check("chat link tooltip (ItemRefTooltip) gets the line", ev("#tooltipLines") == 1))
    ex("hoverItem(ShoppingTooltip1, 268518)")
    r.append(check("comparison tooltip gets nothing", ev("#tooltipLines") == 0))
    ex("tooltipLines = {}; postCalls[Enum.TooltipDataType.Item](GameTooltip, nil)")
    r.append(check("no tooltip data: nothing, no error", ev("#tooltipLines") == 0
                   and ev("ns.FeatureOff('item-tooltip')") is False))

    # Several owners: each name once (two IDs of the same character count once).
    lua2 = runtime(client=NEW_CLIENT, load_db=False)
    lua2.execute("""
        ns.NPCS[900001] = { name = "Alpha", appearances = { { game = "WC2" } }, items = { { id = 999999 } } }
        ns.NPCS[900002] = { name = "Beta", appearances = { { game = "WC3" } }, items = { { id = 999999 } } }
        ns.NPCS[900003] = { name = "Beta", appearances = { { game = "WC3" } }, items = { { id = 999999 } } }
        WarcraftLoreDB = { schema = 3 }; WarcraftLoreCharDB = { schema = 2 }
        coreEvents.scripts.OnEvent(coreEvents, 'ADDON_LOADED', 'WarcraftLore')
        tooltipLines = {}
        postCalls[Enum.TooltipDataType.Item](GameTooltip, { id = 999999 })
    """)
    multi = lua2.eval("tooltipLines[1]") or ""
    r.append(check("two characters on one line, each once",
                   multi.count("Alpha") == 1 and multi.count("Beta") == 1 and ", " in multi, multi))

    # Old client: OnTooltipSetItem on both tooltips, item ID read from the link.
    lua3 = runtime(client=OLD_CLIENT)
    e3, x3 = lua3.eval, lua3.execute
    r.append(check("old client: OnTooltipSetItem hook on GameTooltip and ItemRefTooltip",
                   e3("ns.itemHook") == "OnTooltipSetItem" and e3("itemScripts[GameTooltip] ~= nil")
                   and e3("itemScripts[ItemRefTooltip] ~= nil")))
    x3("tooltipLines = {}; tooltipLink = '|cffffffff|Hitem:280438::::::::17:::::::|h[Abominable Head]|h|r'; itemScripts[GameTooltip](GameTooltip)")
    r.append(check("old client: line from the item link", e3("#tooltipLines") == 1))
    x3("tooltipLines = {}; tooltipLink = nil; itemScripts[GameTooltip](GameTooltip)")
    r.append(check("old client: no link, no line", e3("#tooltipLines") == 0))

    # A failing callback turns only the item line off, with one chat line.
    lua4 = runtime(client=NEW_CLIENT)
    lua4.execute("ns.ItemOwners = function() error('boom') end; printed = {}")
    lua4.execute("postCalls[3](GameTooltip, { id = 280438 }); postCalls[3](GameTooltip, { id = 280438 })")
    r.append(check("error in the item line: off, one chat line",
                   lua4.eval("ns.FeatureOff('item-tooltip')") is True and lua4.eval("#printed") == 1))
    r.append(check("the unit tooltip line stays on", lua4.eval("ns.FeatureOff('tooltip')") is False))

    print(f"\n{sum(r)}/{len(r)} passed")
    raise SystemExit(0 if all(r) else 1)


if __name__ == "__main__":
    main()

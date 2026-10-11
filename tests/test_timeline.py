"""Checks UI.Timeline (release order of an entry's appearances) in Lua 5.1 via lupa.

Usage: python tests/test_timeline.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa  # WoW runs Lua 5.1

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"

STUBS = """
local noop = function() end
local function stub() return setmetatable({}, { __index = function() return noop end }) end
ns = { L = setmetatable({}, { __index = function(_, k) return k end }), Compat = stub(), Style = setmetatable({ BAND = 4, PAD = 10, HEADER = 30, COL = {} }, { __index = function() return noop end }) }
CreateFrame = function() return stub() end
SlashCmdList = {}
"""


def main():
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    for name in ("Core.lua", "UI.lua"):
        run((ADDON / name).read_text(encoding="utf-8"), name)
    order = lua.eval(
        """function()
            local e = { appearances = { {game="BOOK"}, {game="TFT"}, {game="WC1"}, {game="WC3", role="a"}, {game="WC3", role="b"}, {game="FK"} } }
            local t = {}
            for _, a in ipairs(ns.UI.Timeline(e)) do t[#t + 1] = a.game .. (a.role or "") end
            return table.concat(t, ",")
        end"""
    )()
    assert order == "WC1,WC3a,WC3b,TFT,FK,BOOK", order
    assert lua.eval("function() return #ns.UI.Timeline({}) end")() == 0
    print("timeline ok")


main()

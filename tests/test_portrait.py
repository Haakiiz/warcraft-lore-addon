"""Portrait model, role icons, years and icon fallback (Lua 5.1 via lupa, with a fake WoW client).

Usage: python tests/test_portrait.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa  # WoW runs Lua 5.1

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"

# A fake client: every frame/texture accepts any method call and remembers a few things.
STUBS = """
ns = {}
SlashCmdList = {}
WarcraftLoreDB = {}
UIParent = nil
local function newObj(kind)
    local o = { kind = kind, shown = true, scripts = {}, texCoord = nil }
    local methods = {
        Hide = function(self) self.shown = false end,
        Show = function(self) self.shown = true end,
        IsShown = function(self) return self.shown end,
        SetTexture = function(self, p) self.path = p; return self.setTextureResult end,
        GetTexture = function(self) return self.getTextureResult end,
        SetColorTexture = function(self) self.path = "color" end,
        SetTexCoord = function(self, ...) self.texCoord = { ... } end,
        SetScript = function(self, n, f) self.scripts[n] = f end,
        GetFrameLevel = function() return 1 end,
        GetName = function() return nil end,
        GetStringWidth = function() return 10 end,
        GetStringHeight = function() return 12 end,
        GetHeight = function() return 10 end,
        GetWidth = function() return 10 end,
        GetParent = function(self) return self.parent end,
        GetVerticalScroll = function() return 0 end,
        GetVerticalScrollRange = function() return 0 end,
        SetSize = function(self, w, h) self.w, self.h = w, h end,
        CreateTexture = function(self) local t = newObj("Texture"); t.parent = self; textures[#textures + 1] = t; return t end,
        CreateFontString = function(self) local t = newObj("FontString"); t.parent = self; return t end,
        CreateMaskTexture = function(self) return newObj("Mask") end,
        SetText = function(self, t) self.text = t end,
    }
    return setmetatable(o, { __index = function(_, k)
        return methods[k] or function() end
    end })
end
models = {}
textures = {}
modelBehavior = { create = true, setCreatureError = false, fileID = 0 }
CreateFrame = function(kind, name, parent)
    if kind == "PlayerModel" then
        if not modelBehavior.create then error("unknown frame type") end
        local m = newObj("PlayerModel")
        m.SetCreature = function(self, id)
            if modelBehavior.setCreatureError then error("bad creature") end
            self.creature = id
        end
        m.GetModelFileID = function() return modelBehavior.fileID end
        models[#models + 1] = m
        return m
    end
    local f = newObj(kind)
    f.parent = parent
    return f
end
"""


def load():
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    for name in ("Compat.lua", "Data.lua", "Core.lua", "Style.lua", "UI.lua"):
        run((ADDON / name).read_text(encoding="utf-8"), name)
    return lua


def main():
    lua = load()
    g = lua.globals()

    # --- role icons and years
    role = lua.eval("function(game, role) return ns.UI.RoleIcon({ game = game, role = role }) end")
    assert role("BOOK", "Protagonist") == "INV_Misc_Book_09"
    assert role("WC3", "Hero (playable)") == "INV_Sword_27"
    assert role("WC3", "Quest giver") == "INV_Scroll_03"
    assert role("WC3", "Mentioned in a cutscene") == "INV_Misc_Note_01"  # first matching kind wins
    assert role("WC2", "Something else") == "INV_Misc_Map_01"
    assert role("WC1", None) == "INV_Misc_Map_01"
    years = lua.eval("ns.UI.GAME_YEAR")
    assert years["WC1"] == 1994 and years["WC3"] == 2002 and years["TFT"] == 2003
    assert years["FK"] is None and years["BOOK"] is None

    # --- SetIconTexture: false return, nil GetTexture, error and success
    icon = lua.eval(
        """function(setResult, getResult, fails)
            local t = { path = nil }
            function t:SetTexture(p)
                if fails and p ~= "FALLBACK" then error("bad") end
                self.path = p
                return setResult
            end
            function t:GetTexture() return getResult end
            local ok = ns.Compat.SetIconTexture(t, "Interface\\\\Icons\\\\X", "FALLBACK")
            return ok, t.path
        end"""
    )
    assert tuple(icon(None, "file", False)) == (True, "Interface\\Icons\\X")
    assert tuple(icon(False, "file", False)) == (False, "FALLBACK"), "false return must trigger the fallback"
    assert tuple(icon(None, None, False)) == (False, "FALLBACK")
    assert tuple(icon(None, "file", True)) == (False, "FALLBACK")

    # --- setPortrait via ShowEntry
    show = lua.eval(
        """function(npcID)
            ns.UI.ShowEntry(npcID, { name = "Thrall", zone = "Orgrimmar", appearances = {} }, nil, nil)
        end"""
    )
    # 1. model works and is already loaded -> portrait becomes a dark disc, model shown
    g.modelBehavior.fileID = 123
    show(3)
    m = g.models[1]
    assert m.creature == 3 and m.shown, "model must be asked for the NPC"
    # 2. model not loaded yet -> OnModelLoaded for the same NPC swaps the portrait; a stale event does not
    g.modelBehavior.fileID = 0
    show(4)
    m = g.models[1]
    assert m.creature == 4
    loaded = m.scripts["OnModelLoaded"]
    count = lua.eval("function() local n = 0 for _, t in ipairs(textures) do if t.path == 'color' then n = n + 1 end end return n end")
    base = count()
    m.wclNPC = 99  # a load that belongs to another NPC is ignored
    loaded(m)
    assert count() == base, "stale load event must not touch the portrait"
    m.wclNPC = 4
    loaded(m)
    assert count() == base + 1, "load for the shown NPC turns the portrait into a dark disc"
    # 3. PlayerModel frames missing -> no model, window still shows
    lua2 = load_without_model()
    lua2.eval("function() ns.UI.ShowEntry(3, { name = 'Thrall', appearances = {} }) end")()
    assert lua2.eval("function() return ns.Compat.missing.PlayerModel end")() is True
    # 4. SetCreature errors -> no Lua error, noted as missing
    lua3 = load()
    lua3.globals().modelBehavior.setCreatureError = True
    lua3.eval("function() ns.UI.ShowEntry(3, { name = 'Thrall', appearances = {} }) end")()
    assert lua3.eval("function() return ns.Compat.missing.SetCreature end")() is True
    # 5. never loads (fileID stays 0): 2D portrait is kept, nothing errors
    lua4 = load()
    lua4.eval("function() ns.UI.ShowEntry(3, { name = 'Thrall', appearances = {} }) end")()
    assert lua4.eval("function() return ns.Compat.missing.SetCreature end")() is None
    # 6. window message (no NPC) hides the model
    lua4.eval("function() ns.UI.ShowMessage('hi') end")()
    assert lua4.globals().models[1].shown is False
    print("portrait ok")


def load_without_model():
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    lua.execute("modelBehavior.create = false")
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    for name in ("Compat.lua", "Data.lua", "Core.lua", "Style.lua", "UI.lua"):
        run((ADDON / name).read_text(encoding="utf-8"), name)
    return lua


main()

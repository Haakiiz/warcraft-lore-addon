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
        SetVertexColor = function(self, ...) self.vertexColor = { ... } end,
        SetScript = function(self, n, f) self.scripts[n] = f end,
        GetFrameLevel = function() return 1 end,
        GetName = function() return nil end,
        GetStringWidth = function() return 10 end,
        GetStringHeight = function() return 12 end,
        GetHeight = function(self) return self.h or 10 end,
        SetHeight = function(self, h) self.h = h end,
        SetPoint = function(self, ...) self.pt = { ... } end,
        ClearAllPoints = function(self) self.pt = nil end,
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
        if methods[k] then return methods[k] end
        if type(k) == "string" and k:match("^%u") then return function() end end  -- unknown API call
    end })
end
models = {}
textures = {}
frames = {}
tipLines = {}
GameTooltip = {
    SetOwner = function() end, ClearLines = function() tipLines = {} end, ClearAllPoints = function() end,
    SetPoint = function() end, SetMinimumWidth = function() end, Show = function() end, Hide = function() end,
    AddLine = function(_, t) tipLines[#tipLines + 1] = t end,
}
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
    frames[#frames + 1] = f
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

LAYOUT_LUA = """
function()
    -- blocks laid out in the scroll content, top to bottom, as short descriptions
    local out = {}
    for _, f in ipairs(frames) do
        local pt = f.pt
        if f.shown and pt and type(pt[2]) == "table" and pt[2].parent and pt[2].parent.kind == "ScrollFrame" then
            local desc
            if f.label and f.label.text then
                desc = f.label.text
            elseif f.title and f.title.text then
                desc = "game:" .. f.title.text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):match("^%s*(.-)%s*$")
            else
                desc = "block"
            end
            out[#out + 1] = { y = -pt[5], desc = desc, frame = f }
        end
    end
    table.sort(out, function(a, b) return a.y < b.y end)
    return out
end
"""


def layout(lua):
    items = lua.eval(LAYOUT_LUA)()
    return [(items[i + 1]["desc"], items[i + 1]["frame"]) for i in range(len(items))]


def test_layout():
    lua = load()
    g = lua.globals()
    g.modelBehavior.fileID = 123
    ents = lua.eval(
        """function()
            local role = "Quest giver in the second campaign, later seen advising the council of the Horde about a very long and winding road"
            local e = { name = "Thrall", zone = "Orgrimmar", story = "A story.", sources = { "wowpedia" },
                appearances = {
                    { game = "WC3", role = "Hero (playable)", campaign = "Chapter One", missions = { "M1", "M2" } },
                    { game = "BOOK", role = role, campaign = "Book A", missions = { "Ch 1" } },
                    { game = "WC1", role = "Mentioned", campaign = "Orcs" },
                    { game = "BOOK", role = "Protagonist", campaign = "Book B" },
                    { game = "BOOK", role = "Cameo", campaign = "Book C" },
                } }
            ns.Related = function() return {} end
            ns.UI.ShowEntry(3, e, nil, nil)
        end"""
    )
    ents()
    blocks = layout(lua)
    descs = [d for d, _ in blocks]
    assert descs[0] == "STORY", descs
    assert descs[1] == "THROUGH THE AGES", descs
    # games in release order (WC1 1994 before WC3 2002), then the books header and block
    assert descs[2].startswith("game:") and descs[3].startswith("game:"), descs
    assert len(descs) == 7, descs
    assert descs[4] == "IN THE BOOKS" and descs[5] == "block", descs
    assert descs[6:] == ["SOURCES"], descs   # no items: the Items section is hidden, no filler
    games = [f for d, f in blocks if d.startswith("game:")]
    t0, t1 = games[0].title.text, games[1].title.text
    assert "1994" in t0 and "2002" in t1, (t0, t1)
    # the books block holds exactly the three books as one-line rows
    books = blocks[5][1]
    assert books.h == 3 * 20, books.h
    rows = [f for f in g.frames.values() if f.tip and lua.eval("rawequal")(f.parent, books)]
    assert len(rows) == 3
    by_title = {}
    for r in rows:
        by_title[r.tip[1][1]] = r
        assert r.h == 20, "book rows are one line high"
    assert set(by_title) == {"Book A", "Book B", "Book C"}
    a = by_title["Book A"]
    assert "very long and winding road" in a.tip[2][1], "tooltip holds the full role"
    assert "winding" in a.label.text, "row text carries the role (cut off by the client)"
    assert a.tip[3][1] == "Chapter: Ch 1"
    assert a.hl is not None and not a.hl.shown, "book row highlight starts hidden"
    a.scripts["OnEnter"](a)
    assert a.hl.shown, "hovering a book row shows the highlight"
    a.scripts["OnLeave"](a)
    assert not a.hl.shown, "leaving a book row hides the highlight"
    a.scripts["OnEnter"](a)
    assert list(g.tipLines.values())[0] == "Book A" and "winding road" in list(g.tipLines.values())[1]

    # an entry with items shows the Items section; an empty one never prints a filler line
    lua.eval(
        """function()
            ns.UI.ShowEntry(4, { name = "Y", appearances = {}, items = { { id = 1, name = "Sword", note = "Carried" } } })
        end"""
    )()
    assert "ITEMS IN WOW" in [d for d, _ in layout(lua)]
    lua.eval("function() ns.UI.ShowEntry(4, { name = 'Y', appearances = {}, items = {} }) end")()
    assert "ITEMS IN WOW" not in [d for d, _ in layout(lua)]
    assert not any(t.text and "None recorded" in str(t.text) for t in g.textures.values())

    # a books-only entry has no THROUGH THE AGES header; the cover is shown with the model
    lua.eval(
        """function()
            ns.UI.ShowEntry(5, { name = "X", appearances = { { game = "BOOK", campaign = "Only", role = "Cameo" } } })
        end"""
    )()
    descs = [d for d, _ in layout(lua)]
    assert "THROUGH THE AGES" not in descs and "IN THE BOOKS" in descs, descs
    assert descs[0] == "IN THE BOOKS", descs
    cover = next(t for t in g.textures.values() if t.path and str(t.path).endswith("PortraitCover"))
    assert cover.shown, "cover is shown while the model is shown"
    assert cover.vertexColor is not None, "cover is white and tinted to COL.inner at runtime"
    # a message hides the model and the cover
    lua.eval("function() ns.UI.ShowMessage('hi') end")()
    assert not cover.shown and not g.models[1].shown
    # an NPC without a PlayerModel never shows the cover
    lua2 = load_without_model()
    lua2.eval("function() ns.UI.ShowEntry(3, { name = 'T', appearances = {} }) end")()
    cover2 = next(t for t in lua2.globals().textures.values() if t.path and str(t.path).endswith("PortraitCover"))
    assert not cover2.shown, "2D fallback keeps the cover hidden"
    print("layout ok")


def load_without_model():
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    lua.execute("modelBehavior.create = false")
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    for name in ("Compat.lua", "Data.lua", "Core.lua", "Style.lua", "UI.lua"):
        run((ADDON / name).read_text(encoding="utf-8"), name)
    return lua


main()
test_layout()

-- The lore window for a veteran with many items (Baron Rivendare, 24), scrolled to the end:
-- the "Items in WoW" section.
startAddon({ [10440] = 111 })
target(10440, "Baron Rivendare")
SlashCmdList.WARCRAFTLORE("")
for _, f in ipairs(MOCK.frames) do
    if f._kind == "ScrollFrame" and f:GetScrollChild() then
        f:SetVerticalScroll(f:GetVerticalScrollRange())
    end
end
MOCK.dump(SHOTDIR .. "/lore_items.json")

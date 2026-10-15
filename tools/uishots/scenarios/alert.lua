startAddon({})
target(4949, "Thrall")
target(3230, "Nazgrel")
for _, f in ipairs(MOCK.frames) do if f._scripts.OnUpdate and f.glow then f:SetAlpha(1) end end
MOCK.dump(SHOTDIR .. "/alert.json")

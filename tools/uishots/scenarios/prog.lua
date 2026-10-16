-- A player some weeks in: about a third of the veterans met, a few memorials visited.
local ns = __NS
function startProgress(theme, skip)
    WarcraftLoreDB = theme and { theme = theme } or nil
    startAddon({})
    local db = WarcraftLoreDB
    local ids = {}
    for id in pairs(ns.NPCS) do ids[#ids + 1] = id end
    table.sort(ids)
    local base = os.time() - 86400 * 24
    local want = { [4949] = true, [3230] = true, [3057] = true, [2993] = true, [10540] = true }
    for i, id in ipairs(ids) do
        if (i % 3 == 0 or want[id]) and id ~= skip then
            db.met[id] = { first = base + i * 5400, count = (i % 6) + 1, by = "Grommash-Forever" }
        end
    end
    local keys = {}
    for k in pairs(ns.MEMORIALS) do keys[#keys + 1] = k end
    table.sort(keys)
    for i = 1, 4 do db.visited[keys[i]] = { first = base + i * 86400, by = "Grommash-Forever" } end
    db.achievementsSeeded = false
    ns.Achievements.Check()            -- seeds silently
    local i = 0
    for id in pairs(db.achievements) do i = i + 1; db.achievements[id] = base + i * 40000 end
end
function showAllFading()
    for _, f in ipairs(MOCK.frames) do
        if f.head and f.title then f:SetAlpha(1) end
        if f._scripts.OnUpdate and f.glow then f:SetAlpha(1) end
    end
end

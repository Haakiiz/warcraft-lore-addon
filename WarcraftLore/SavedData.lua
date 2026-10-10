-- SavedData.lua – schema version and migrations for the saved variables.
-- WarcraftLoreDB (account) and WarcraftLoreCharDB (character) each carry a `schema` number.
-- At ADDON_LOADED every migration above the stored number runs in order, so a later change
-- of layout (account-wide met list, cleanup of old settings) only needs a new function here.

local _, ns = ...
local C = ns.Compat

local PREFIX = "|cff8b6cd6Warcraft Lore:|r "

-- migrations[n] turns schema n-1 into schema n. Data saved before v0.4 has no `schema`
-- and counts as 0. A migration may assume nothing about the types it finds.
local ACCOUNT_MIGRATIONS = {
    -- 1: the defaults that Core.lua used to fill in at every load.
    [1] = function(db)
        if db.auto == nil then
            db.auto = true
        end
        if db.alert == nil then
            db.alert = true
        end
        if type(db.minimap) ~= "table" then
            db.minimap = {}
        end
    end,
}

local CHAR_MIGRATIONS = {
    -- 1: met list; a damaged value (wrong type) is replaced rather than crashing.
    [1] = function(db)
        if type(db.met) ~= "table" then
            db.met = {}
        end
    end,
}

-- Runs the missing migrations on db. Returns false (and leaves db untouched) when the data
-- comes from a newer version of the addon, or stops at the first migration that errors so
-- the same step runs again at the next load.
local function migrate(db, migrations, label)
    local latest = #migrations
    local from = tonumber(db.schema) or 0
    if from > latest then
        C.Print(PREFIX .. ("The %s data was saved by a newer version of the addon (schema %d, this version knows %d). "
            .. "It is kept as it is; update the addon to use it fully."):format(label, from, latest))
        return false
    end
    for n = from + 1, latest do
        local ok, err = pcall(migrations[n], db)
        if not ok then
            C.Print(PREFIX .. ("Could not upgrade the %s data to schema %d: %s"):format(label, n, tostring(err)))
            return false
        end
        db.schema = n
    end
    return true
end

ns.SavedData = {
    ACCOUNT_SCHEMA = #ACCOUNT_MIGRATIONS,
    CHAR_SCHEMA = #CHAR_MIGRATIONS,
}

-- Called once from ADDON_LOADED, before anything reads the saved variables.
function ns.SavedData.Load()
    if type(WarcraftLoreDB) ~= "table" then
        WarcraftLoreDB = {}
    end
    if type(WarcraftLoreCharDB) ~= "table" then
        WarcraftLoreCharDB = {}
    end
    migrate(WarcraftLoreDB, ACCOUNT_MIGRATIONS, "account")
    migrate(WarcraftLoreCharDB, CHAR_MIGRATIONS, "character")
    -- The rest of the addon relies on these types even if a migration was skipped.
    if type(WarcraftLoreDB.minimap) ~= "table" then
        WarcraftLoreDB.minimap = {}
    end
    if type(WarcraftLoreCharDB.met) ~= "table" then
        WarcraftLoreCharDB.met = {}
    end
end

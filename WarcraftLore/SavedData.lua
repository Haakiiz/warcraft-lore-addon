-- SavedData.lua – schema version and migrations for the saved variables.
-- WarcraftLoreDB (account) and WarcraftLoreCharDB (character) each carry a `schema` number.
-- At ADDON_LOADED every migration above the stored number runs in order, so a later change
-- of layout (account-wide met list, cleanup of old settings) only needs a new function here.

local _, ns = ...
local C = ns.Compat
local L = ns.L

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
    -- 2: account-wide met list, met[npcID] = { first = time, count = n, by = "Name-Realm" }.
    -- The per-character lists are folded in by mergeCharacterMet (below).
    [2] = function(db)
        if type(db.met) ~= "table" then
            db.met = {}
        end
    end,
    -- 3: achievements, earned[id] = time earned (Achievements.lua). Existing players get their
    -- current achievements stored silently by the first Achievements.Check.
    [3] = function(db)
        if type(db.achievements) ~= "table" then
            db.achievements = {}
        end
    end,
}

-- "Name-Realm" of the current character (nil when the client does not tell).
local function characterName()
    local ok, name = pcall(function()
        local n, realm = C.UnitName("player"), C.GetRealmName()
        if n and realm and realm ~= "" then
            return n .. "-" .. (realm:gsub("%s", ""))
        end
        return n
    end)
    return ok and name or nil
end

-- Folds the per-character met list (old layout: met[npcID] = time) into the account list.
-- Keeps the earliest time and adds one meeting per merged entry to the count. The character
-- table is emptied afterwards, so running it again (or from another character) is harmless.
local function mergeCharacterMet(account, char)
    if type(account.met) ~= "table" then
        account.met = {}
    end
    if type(char.met) ~= "table" then
        return
    end
    local by = characterName()
    for id, t in pairs(char.met) do
        local first = tonumber(t)
        if type(id) == "number" and first then
            local e = account.met[id]
            if type(e) == "table" then
                local old = tonumber(e.first)
                if not old or first < old then
                    e.first = first
                    e.by = by
                end
                e.count = (tonumber(e.count) or 0) + 1
            else
                account.met[id] = { first = first, count = 1, by = by }
            end
        end
    end
    char.met = nil
end

local CHAR_MIGRATIONS = {
    -- 1: met list; a damaged value (wrong type) is replaced rather than crashing.
    [1] = function(db)
        if type(db.met) ~= "table" then
            db.met = {}
        end
    end,
    -- 2: the met list moved to the account (see mergeCharacterMet); the account is migrated first.
    [2] = function(db)
        local account = WarcraftLoreDB
        if type(account.met) ~= "table" then
            account.met = {}
        end
        mergeCharacterMet(account, db)
    end,
}

-- Runs the missing migrations on db. Returns false (and leaves db untouched) when the data
-- comes from a newer version of the addon, or stops at the first migration that errors so
-- the same step runs again at the next load.
local function migrate(db, migrations, label)
    local latest = #migrations
    local from = tonumber(db.schema) or 0
    if from > latest then
        C.Print(PREFIX .. L["The %s data was saved by a newer version of the addon (schema %d, this version knows %d). It is kept as it is; update the addon to use it fully."]:format(label, from, latest))
        return false
    end
    for n = from + 1, latest do
        local ok, err = pcall(migrations[n], db)
        if not ok then
            C.Print(PREFIX .. L["Could not upgrade the %s data to schema %d: %s"]:format(label, n, tostring(err)))
            return false
        end
        db.schema = n
    end
    return true
end

ns.SavedData = {
    ACCOUNT_SCHEMA = #ACCOUNT_MIGRATIONS,
    CHAR_SCHEMA = #CHAR_MIGRATIONS,
    CharacterName = characterName,
}

-- Called once from ADDON_LOADED, before anything reads the saved variables.
function ns.SavedData.Load()
    if type(WarcraftLoreDB) ~= "table" then
        WarcraftLoreDB = {}
    end
    if type(WarcraftLoreCharDB) ~= "table" then
        WarcraftLoreCharDB = {}
    end
    local accountOk = migrate(WarcraftLoreDB, ACCOUNT_MIGRATIONS, L["account"])
    -- Character data is merged into the account list only when the account layout is current.
    if accountOk then
        migrate(WarcraftLoreCharDB, CHAR_MIGRATIONS, L["character"])
        -- A character that was upgraded before this one logged in may still hold old data
        -- (or a new character may have an old list): merge whatever is left at every load.
        if tonumber(WarcraftLoreCharDB.schema) == #CHAR_MIGRATIONS then
            pcall(mergeCharacterMet, WarcraftLoreDB, WarcraftLoreCharDB)
        end
    end
    -- The rest of the addon relies on these types even if a migration was skipped.
    if type(WarcraftLoreDB.minimap) ~= "table" then
        WarcraftLoreDB.minimap = {}
    end
end

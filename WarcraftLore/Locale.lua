-- Locale.lua – the interface text table.
-- ns.L maps the English text to the text in the client's language. English is the key, so
-- the code stays readable: print(L["Veterans list"]). A string with no translation (or any
-- string in an English client) comes back as the key itself, so nothing is ever nil.
-- Translations live in Locales/<code>.lua and fill ns.L only when the client language matches.
-- Format strings keep their placeholders (%s, %d) in every language. Only the interface is
-- translated: the lore texts, NPC and game names, zone names and slash commands stay English.

local _, ns = ...
local C = ns.Compat

ns.Locale = C.GetLocale()

ns.L = setmetatable({}, {
    __index = function(_, key)
        return key
    end,
})

-- "3 Oct 2026" / "3. Okt. 2026" / "3 oct. 2026". Built from the numbers (day, month, year) and a
-- translated month list, because the "%b" date format is always English in the WoW client. The day has no
-- leading zero. Returns nil when the time is not a number or date() fails.
local L = ns.L

function ns.FormatDate(t)
    -- Looked up on each call: the locale files load after this file.
    local MONTHS = {
        L["Jan"], L["Feb"], L["Mar"], L["Apr"], L["May"], L["Jun"],
        L["Jul"], L["Aug"], L["Sep"], L["Oct"], L["Nov"], L["Dec"],
    }
    t = tonumber(t)
    if not t then
        return nil
    end
    local okD, day = pcall(date, "%d", t)
    local okM, month = pcall(date, "%m", t)
    local okY, year = pcall(date, "%Y", t)
    day, month, year = okD and tonumber(day), okM and tonumber(month), okY and tonumber(year)
    if not (day and month and year) or not MONTHS[month] then
        return nil
    end
    return L["%d %s %d"]:format(day, MONTHS[month], year)
end

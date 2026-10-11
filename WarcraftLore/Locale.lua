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

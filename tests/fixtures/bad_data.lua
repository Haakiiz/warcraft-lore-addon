-- Broken on purpose: validate_db.py must fail on this file. It shows that the test works.
local _, ns = ...
ns.NPCS = {
    [100] = {
        name = "Duplicate",
        zone = "Orgrimmar",
        appearances = { { game = "WC2", campaign = "", missions = {}, role = "Unit" } },
        sources = { "https://warcraft.wiki.gg/" },
        confidence = "confirmed",
    },
    [100] = {
        name = "Duplicate again",
        zone = "Orgrimmar",
        appearances = { { game = "WC4", role = "Hero" } },
        sources = { "not a link" },
        confidence = "uncertain",
        typofield = true,
    },
}

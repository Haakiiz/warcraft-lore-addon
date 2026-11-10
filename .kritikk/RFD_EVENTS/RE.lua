-- RE.lua: new entries from the Razorfen Downs review and the classic world-event review.
-- Exact Data.lua syntax. Paste each block under the zone comment shown.

    -- ===================================================================== Razorfen Downs
    [7358] = {
        name = "Amnennar the Coldbringer",
        zone = "Razorfen Downs",
        coords = "",
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Mentioned in the novel: Death Speaker Blackthorn plans to summon him by sacrificing the dryad Drella in Razorfen Downs (chapter 19)",
            },
        },
        story = "The lich Amnennar and his forces took part in the Scourge's assault on Mount Hyjal during the Third War. "
             .. "Afterwards the Lich King ordered him to stay in Kalimdor and expand the Scourge's influence there. "
             .. "He began plans for a base from which to strike at Orgrimmar and Theramore, and set out to recruit the displaced quilboar of Razorfen Downs by promising them power over death. "
             .. "In World of Warcraft he is the ruler of Razorfen Downs and leader of the undead Death's Head tribe, sitting atop the Spiral of Thorns. "
             .. "In the novel Traveler: The Spiral Path, Blackthorn of the Death's Head imprisons the dryad Drella so that she can be sacrificed to Amnennar.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Amnennar_the_Coldbringer",
            "https://warcraft.wiki.gg/wiki/Amnennar_the_Coldbringer_(Classic)",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://www.wowhead.com/classic/npc=7358/amnennar-the-coldbringer",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Stranglethorn Vale (Stranglethorn Fishing Extravaganza)
    [15077] = {
        name = "Riggle Bassbait",
        zone = "Stranglethorn Vale",
        coords = "27.4, 76.8",
        related = { 2496, 2487 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Stranglethorn Fishing Extravaganza",
                missions = {},
                role = "Asks Baron Revilgaz for a loan to fund a fishing tournament, wins him over with a plate of tastyfish, and then seeds the coast with fish for the contest (short story)",
            },
        },
        story = "Riggle Bassbait is a goblin angler who stands on a dock in Booty Bay, where he runs the Stranglethorn Fishing Extravaganza and takes the speckled tastyfish that anglers turn in to him. "
             .. "He appears only during the Stranglethorn Fishing Extravaganza, which is held every Sunday afternoon. "
             .. "In the short story Stranglethorn Fishing Extravaganza, he rows into Booty Bay and asks Baron Revilgaz for a loan to fund his plan. "
             .. "Revilgaz first refuses, but he agrees to host the tournament after tasting Riggle's tastyfish, and Riggle goes off to seed the coastal waters with fish.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Riggle_Bassbait",
            "https://warcraft.wiki.gg/wiki/Stranglethorn_Fishing_Extravaganza_(short_story)",
            "https://warcraft.wiki.gg/wiki/Stranglethorn_Fishing_Extravaganza",
            "https://www.wowhead.com/classic/npc=15077/riggle-bassbait",
        },
        confidence = "confirmed",
    },

    -- Bonus (not an event NPC; same short story): Booty Bay. Check no other worker added 2496.
    [2496] = {
        name = "Baron Revilgaz",
        zone = "Stranglethorn Vale",
        coords = "27.2, 76.8",
        related = { 2487, 15077 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Stranglethorn Fishing Extravaganza",
                missions = {},
                role = "Hears Riggle Bassbait's loan request, is won over by his tastyfish, and agrees to host the Stranglethorn fishing tournament in Booty Bay (short story)",
            },
        },
        story = "Baron Revilgaz rules the goblin port of Booty Bay as leader of the Blackwater Raiders, and he watches over the harbour from his balcony above the Salty Sailor Tavern with Fleet Master Seahorn at his side. "
             .. "After the Third War, wars in Alterac Valley and Warsong Gulch drew visitors away from Stranglethorn and slowed his business. "
             .. "In the short story Stranglethorn Fishing Extravaganza, he first refuses a loan to the angler Riggle Bassbait. "
             .. "Then he tastes Riggle's tastyfish and agrees to a fishing tournament that brings adventurers and trade back to Booty Bay.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Baron_Revilgaz",
            "https://warcraft.wiki.gg/wiki/Stranglethorn_Fishing_Extravaganza_(short_story)",
            "https://www.wowhead.com/classic/npc=2496/baron-revilgaz",
        },
        confidence = "confirmed",
    },

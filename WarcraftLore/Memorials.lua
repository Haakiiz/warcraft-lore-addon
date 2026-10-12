-- Memorials.lua – places and objects in the world that commemorate characters from the
-- Warcraft strategy games who are not NPCs you can meet in WoW: graves, tombs, plaques and monuments.
--
-- One entry per object, keyed by a short name: [key] = { ... }.
--
-- FIELDS
--   name        (required) The object's name exactly as the game shows it when you hover or read it.
--   kind        (required) "plaque", "tomb" or "monument".
--   zone        (required) The zone it is in, e.g. "Stormwind City" (same names as Data.lua).
--   coords      (required) Map coordinates as text, e.g. "63.8, 75.1".
--   objectIDs   (required) The game object IDs (Wowhead Classic).
--   honors      (required) Names of the characters it honors.
--   appearances (required) The honored character's appearances in the games, same format and
--               game codes as Data.lua (game, campaign, missions, role). missions = {} if unknown.
--   story       (required) 3–6 sentences.
--   sources     (required) List of links (http/https).
--
-- Rule: never invent mission names or IDs. Run tests/validate_db.py after changes.

local _, ns = ...

ns.MEMORIALS = {

    -- ===================================================================== Western Plaguelands
    uther = {
        name = "Uther the Lightbringer",
        kind = "tomb",
        zone = "Western Plaguelands",
        coords = "52.1, 83.2",
        objectIDs = { 2082 },
        honors = { "Uther the Lightbringer" },
        appearances = {
            {
                game = "WC2",
                campaign = "Tides of Darkness (Human)",
                missions = { "The Battle at Darrowmere" },
                role = "Paladin hero who fights for the Alliance",
            },
            {
                game = "WC3",
                campaign = "The Scourge of Lordaeron (Human)",
                missions = { "The Defense of Strahnbrad", "Blackrock and Roll" },
                role = "Paladin hero who fights beside Prince Arthas",
            },
        },
        story = "Uther the Lightbringer was the first paladin and the founder of the Order of the Silver Hand. "
            .. "His tomb lies south of Andorhal, and a stone in front of his statue carries his name. "
            .. "The marker beneath his statue reads: Here lies Uther the Lightbringer. "
            .. "Players of Warcraft II knew him as a hero of the Alliance at the Battle at Darrowmere. "
            .. "Players of Warcraft III followed him into the Scourge war at Arthas's side.",
        sources = {
            "https://www.wowhead.com/classic/object=2082",
            "https://warcraft.wiki.gg/wiki/Uther%27s_Tomb",
        },
    },

    -- ===================================================================== Undercity
    terenas = {
        name = "Here Lies King Terenas Menethil II",
        kind = "tomb",
        zone = "Undercity",
        coords = "65.9, 43.4",
        objectIDs = { 175659 },
        honors = { "Terenas Menethil II" },
        appearances = {
            {
                game = "WC2",
                campaign = "Tides of Darkness (Orc)",
                missions = { "The Fall of Lordaeron" },
                role = "King of Lordaeron and leader of the Alliance",
            },
            {
                game = "WC3",
                campaign = "The Scourge of Lordaeron (Human)",
                missions = {},
                role = "King of Lordaeron, who ignores the Prophet's warning in the opening cinematic",
            },
        },
        story = "Terenas Menethil II was the king of Lordaeron and the leader of the Alliance in Warcraft II. "
            .. "His grave plaque stands behind the throne room of the ruined capital of Lordaeron. "
            .. "It reads that he was the last true king of Lordaeron. "
            .. "Warcraft III shows the king as the father of Prince Arthas, who later brought the kingdom down.",
        sources = {
            "https://www.wowhead.com/classic/object=175659",
            "https://warcraft.wiki.gg/wiki/Terenas_Menethil_II",
        },
    },

    -- ===================================================================== Arathi Highlands
    trollbane = {
        name = "Trollbane's Tomb",
        kind = "tomb",
        zone = "Arathi Highlands",
        coords = "28.9, 59.6",
        objectIDs = { 2703 },
        honors = { "Thoras Trollbane" },
        appearances = {
            {
                game = "WC2",
                campaign = "Tides of Darkness (Orc)",
                missions = {},
                role = "Lord of Stromgarde, whose kingdom the Horde attacks",
            },
        },
        story = "Thoras Trollbane was the lord of Stromgarde and one of the leaders of the Alliance. "
            .. "His remains rest in a sanctum behind the chapel of Stromgarde Keep. "
            .. "The tomb is an object in a quest chain that sends adventurers to retrieve Trol'kalar from it. "
            .. "In Warcraft II the orc campaign includes the fall of his city.",
        sources = {
            "https://www.wowhead.com/classic/object=2703",
            "https://warcraft.wiki.gg/wiki/Trol%27kalar_(Classic)",
        },
    },

    -- ===================================================================== Stormwind City, Royal Gallery
    llane = {
        name = "King Llane I of the House of Wrynn",
        kind = "monument",
        zone = "Stormwind City",
        coords = "64.2, 6.4",
        objectIDs = { 177200 },
        honors = { "Llane Wrynn I" },
        appearances = {
            {
                game = "WC1",
                campaign = "Orcs & Humans (Human)",
                missions = {},
                role = "King of Stormwind who gives the Human campaign its orders; his murder is announced late in the campaign",
            },
        },
        story = "Llane Wrynn I was the king of Stormwind when the orcs came through the Dark Portal. "
            .. "His statue stands in the Royal Gallery of Stormwind Keep. "
            .. "The plaque calls him Liege Lord of Stormwind and Defender of Azeroth. "
            .. "In the first Warcraft game he is the king the Human campaign serves.",
        sources = {
            "https://www.wowhead.com/classic/object=177200",
            "https://warcraft.wiki.gg/wiki/Royal_Gallery",
        },
    },
    daelin = {
        name = "Grand Admiral Daelin Proudmoore",
        kind = "monument",
        zone = "Stormwind City",
        coords = "64.7, 6.8",
        objectIDs = { 177201 },
        honors = { "Daelin Proudmoore" },
        appearances = {
            {
                game = "WC2",
                campaign = "Tides of Darkness (Human)",
                missions = {},
                role = "Grand Admiral who commands the Alliance fleets",
            },
            {
                game = "BTDP",
                campaign = "Beyond the Dark Portal (Orc)",
                missions = { "Assault on Kul Tiras" },
                role = "Lord Admiral of Kul Tiras, whose island the orcs attack",
            },
        },
        story = "Daelin Proudmoore was the Grand Admiral of Kul Tiras and the commander of the Alliance fleets. "
            .. "His statue stands in the Royal Gallery of Stormwind Keep, next to the one of King Llane. "
            .. "The plaque calls him Commander of the Alliance Fleets and Friend of Stormwind. "
            .. "Warcraft II has him defend Kul Tiras against the Horde.",
        sources = {
            "https://www.wowhead.com/classic/object=177201",
            "https://warcraft.wiki.gg/wiki/Royal_Gallery",
        },
    },

    -- ===================================================================== Stormwind City, Valley of Heroes
    turalyon = {
        name = "General Turalyon",
        kind = "monument",
        zone = "Stormwind City",
        coords = "63.8, 75.1",
        objectIDs = { 25330 },
        honors = { "Turalyon" },
        appearances = {
            {
                game = "BTDP",
                campaign = "Beyond the Dark Portal (Human)",
                missions = { "Alleria's Journey", "The Bitter Taste of Victory" },
                role = "High General who leads the Alliance Expedition",
            },
        },
        story = "Turalyon was a knight of the Silver Hand and a lieutenant to Anduin Lothar. "
            .. "After the Second War he led the Alliance Expedition through the Dark Portal. "
            .. "His statue greets visitors at the end of the main road in the Valley of Heroes. "
            .. "The plaque names him High General of the Alliance Expedition and is signed by Uther the Lightbringer.",
        sources = {
            "https://www.wowhead.com/classic/object=25330",
            "https://warcraft.wiki.gg/wiki/Valley_of_Heroes",
        },
    },
    khadgar = {
        name = "Archmage Khadgar of the Kirin Tor",
        kind = "monument",
        zone = "Stormwind City",
        coords = "64.9, 78.2",
        objectIDs = { 25333 },
        honors = { "Khadgar" },
        appearances = {
            {
                game = "BTDP",
                campaign = "Beyond the Dark Portal (Human)",
                missions = { "Once More Unto the Breach", "The Bitter Taste of Victory" },
                role = "Archmage hero who must survive to seal the Dark Portal",
            },
        },
        story = "Khadgar was the apprentice of Medivh and later an archmage of the Kirin Tor. "
            .. "He served as the supreme commander of the Alliance Expedition beyond the Dark Portal. "
            .. "His statue stands on the left side of the Valley of Heroes. "
            .. "The plaque names his old master Medivh and is signed by Antonidas, Archmage of Dalaran.",
        sources = {
            "https://www.wowhead.com/classic/object=25333",
            "https://warcraft.wiki.gg/wiki/Valley_of_Heroes",
        },
    },
    alleria = {
        name = "Ranger Captain Alleria Windrunner",
        kind = "monument",
        zone = "Stormwind City",
        coords = "65.4, 77.4",
        objectIDs = { 25331 },
        honors = { "Alleria Windrunner" },
        appearances = {
            {
                game = "BTDP",
                campaign = "Beyond the Dark Portal (Human)",
                missions = { "Alleria's Journey", "Deathwing" },
                role = "Ranger hero and scout of the Alliance Expedition",
            },
        },
        story = "Alleria Windrunner was a ranger captain of Quel'Thalas and a renowned troll hunter. "
            .. "She served the Alliance Expedition as its lead scout and intelligence agent. "
            .. "Her statue stands on the right side of the Valley of Heroes. "
            .. "The plaque is signed by her sister Sylvanas.",
        sources = {
            "https://www.wowhead.com/classic/object=25331",
            "https://warcraft.wiki.gg/wiki/Valley_of_Heroes",
        },
    },
    danath = {
        name = "Danath Trollbane",
        kind = "monument",
        zone = "Stormwind City",
        coords = "67.3, 80.4",
        objectIDs = { 25332 },
        honors = { "Danath Trollbane" },
        appearances = {
            {
                game = "BTDP",
                campaign = "Beyond the Dark Portal (Human)",
                missions = { "Alleria's Journey", "The Battle for Nethergarde" },
                role = "Warrior hero from Stromgarde",
            },
        },
        story = "Danath Trollbane was the militia commander of Stromgarde. "
            .. "He served as a tactical advisor to General Turalyon on the Alliance Expedition. "
            .. "His statue stands on the right side of the Valley of Heroes. "
            .. "The plaque is signed by Thoras Trollbane, the lord of Stromgarde.",
        sources = {
            "https://www.wowhead.com/classic/object=25332",
            "https://warcraft.wiki.gg/wiki/Valley_of_Heroes",
        },
    },
    kurdran = {
        name = "Kurdran Wildhammer",
        kind = "monument",
        zone = "Stormwind City",
        coords = "66.4, 81.0",
        objectIDs = { 25329 },
        honors = { "Kurdran Wildhammer" },
        appearances = {
            {
                game = "BTDP",
                campaign = "Beyond the Dark Portal (Human)",
                missions = { "The Fall of Auchindoun", "Deathwing" },
                role = "Dwarven gryphon rider hero, with his gryphon Sky'ree",
            },
        },
        story = "Kurdran Wildhammer was a renowned dragon fighter and a gryphon master of Aerie Peak. "
            .. "He flew with his gryphon Sky'ree in the Alliance Expedition. "
            .. "His statue stands on the left side of the Valley of Heroes. "
            .. "The plaque is signed by Falstad Wildhammer, the lord of Aerie Peak.",
        sources = {
            "https://www.wowhead.com/classic/object=25329",
            "https://warcraft.wiki.gg/wiki/Valley_of_Heroes",
        },
    },

    -- ===================================================================== Ashenvale
    grom = {
        name = "Monument to Grom Hellscream",
        kind = "monument",
        zone = "Ashenvale",
        coords = "82.9, 79.1",
        objectIDs = { 21004 },
        honors = { "Grom Hellscream" },
        appearances = {
            {
                game = "BTDP",
                campaign = "Beyond the Dark Portal (Orc)",
                missions = { "Slayer of the Shadowmoon" },
                role = "Orc chieftain who is freed to fight as a hero",
            },
            {
                game = "WC3",
                campaign = "The Invasion of Kalimdor (Orc)",
                missions = { "The Hunter of Shadows", "By Demons Be Driven", "The Death of Hellscream" },
                role = "Chieftain of the Warsong Clan, a playable hero who later becomes an enemy to capture",
            },
        },
        story = "Grom Hellscream was the chieftain of the Warsong Clan. "
            .. "The monument stands in Demon Fall Canyon in Ashenvale, where he stood alone against the demon Mannoroth. "
            .. "Its inscription remembers him as the one who gave his life to break the demon's hold on the orcs. "
            .. "Warcraft III lets players lead him in The Hunter of Shadows, then makes him an enemy in By Demons Be Driven. "
            .. "Its final cinematic shows him killing Mannoroth and dying freed from the demon's curse.",
        sources = {
            "https://www.wowhead.com/classic/object=21004",
            "https://warcraft.wiki.gg/wiki/Monument_to_Grom_Hellscream",
        },
    },

    -- ===================================================================== Orgrimmar
    mannoroth = {
        name = "The Armor of Mannoroth",
        kind = "plaque",
        zone = "Orgrimmar",
        coords = "45.3, 34.9",
        objectIDs = { 175658 },
        honors = { "Grom Hellscream" },
        appearances = {
            {
                game = "WC3",
                campaign = "The Invasion of Kalimdor (Orc)",
                missions = { "The Hunter of Shadows", "By Demons Be Driven", "The Death of Hellscream" },
                role = "Chieftain of the Warsong Clan who kills Mannoroth in the final cinematic",
            },
        },
        story = "This trophy remembers how Grom Hellscream freed the orcs by slaying the pit lord Mannoroth. "
            .. "His armor and skull hang on the white tree in the Valley of Wisdom in Orgrimmar. "
            .. "The plaque says that Mannoroth is no more and that the plates shall always remind the Horde. "
            .. "Warcraft III ends its orc campaign with that fight.",
        sources = {
            "https://www.wowhead.com/classic/object=175658",
            "https://warcraft.wiki.gg/wiki/The_Armor_of_Mannoroth",
        },
    },
}

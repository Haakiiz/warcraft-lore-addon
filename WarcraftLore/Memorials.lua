-- Memorials.lua – places and objects in the world that commemorate characters from the
-- Warcraft strategy games who are not NPCs you can meet in WoW: graves, tombs, plaques and monuments.
--
-- One entry per object, keyed by a short name: [key] = { ... }.
--
-- FIELDS
--   name        (required) The object's name exactly as the game shows it when you hover or read it.
--   kind        (required) "plaque", "tomb", "monument" or "book".
--   zone        (required) The zone it is in, e.g. "Stormwind City" (same names as Data.lua).
--   coords      (required) Map coordinates as text, e.g. "63.8, 75.1".
--   objectIDs   (required) The game object IDs (Wowhead Classic).
--   honors      (required) Names of the characters it honors.
--   appearances (required) The honored character's appearances in the games, same format and
--               game codes as Data.lua (game, campaign, missions, role). missions = {} if unknown.
--   story       (required) 3–6 sentences.
--   sources     (required) List of links (http/https).
--   locations   (optional, books) Every place the object stands: { { zone = "...", coords = "x, y" }, ... }.
--               zone/coords above are the first of them. Each location gets a map pin.
--   order       (optional, books) Reading order in the series.
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
                role = "Paladin and assistant to the Archbishop whom the Alliance fleet must escort safely to Caer Darrow",
            },
            {
                game = "WC3",
                campaign = "The Scourge of Lordaeron (Human)",
                missions = { "The Defense of Strahnbrad", "Blackrock and Roll", "March of the Scourge", "The Culling" },
                role = "Paladin who fights beside Prince Arthas, brings reinforcements to Hearthglen and confronts him after the Culling of Stratholme",
            },
            {
                game = "WC3",
                campaign = "Path of the Damned (Undead)",
                missions = { "Digging up the Dead" },
                role = "Guards King Terenas's urn at Andorhal and is killed by Arthas",
            },
        },
        story = "Uther the Lightbringer was the first paladin and the founder of the Order of the Silver Hand. "
            .. "His tomb lies south of Andorhal, and a stone in front of his statue carries his name. "
            .. "The marker reads: Here lies Uther the Lightbringer, First Paladin and Founder of the Order of the Silver Hand. "
            .. "Players of Warcraft II knew him as the paladin the Alliance escorts to Caer Darrow at the Battle at Darrowmere. "
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
                role = "King of Lordaeron, who ignores the Prophet's warning in the opening cinematic and is killed by his son Arthas in the closing one",
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
                game = "BOOK",
                campaign = "Tides of Darkness",
                missions = {},
                role = "Sends half of Stromgarde's army to the Alliance and later leads his troops to cut off Horde reinforcements through the Alterac Mountains",
            },
        },
        story = "Thoras Trollbane was the king of Stromgarde and one of the leaders of the Alliance. "
            .. "His remains rest in a sanctum behind the chapel of Stromgarde Keep. "
            .. "The tomb is an object in a quest chain that sends adventurers to retrieve Trol'kalar from it. "
            .. "In Warcraft II the orc campaign includes the mission The Fall of Stromgarde, in which the Horde destroys his kingdom's capital, though he does not appear by name.",
        sources = {
            "https://www.wowhead.com/classic/object=2703",
            "https://warcraft.wiki.gg/wiki/Trol%27kalar_(Classic)",
            "https://warcraft.wiki.gg/wiki/Thoras_Trollbane",
            "https://warcraft.wiki.gg/wiki/The_Fall_of_Stromgarde_(WC2_Orc)",
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
                missions = { "Deathwing", "The Bitter Taste of Victory" },
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
                missions = { "Deathwing", "The Bitter Taste of Victory" },
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
                missions = { "The Spirits of Ashenvale", "The Hunter of Shadows", "By Demons Be Driven" },
                role = "Chieftain of the Warsong Clan, a playable hero who later becomes an enemy to capture",
            },
        },
        story = "Grom Hellscream was the chieftain of the Warsong Clan. "
            .. "The monument stands in Demon Fall Canyon in Ashenvale, where he stood alone against the demon Mannoroth. "
            .. "Its inscription, signed by Thrall, says he stood alone before Mannoroth and won the orcs' freedom with his blood. "
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
                missions = { "The Hunter of Shadows", "By Demons Be Driven" },
                role = "Chieftain of the Warsong Clan who kills Mannoroth in the final cinematic",
            },
        },
        story = "This trophy remembers how Grom Hellscream freed the orcs by slaying the pit lord Mannoroth. "
            .. "His armor and skull hang on the white tree in the Valley of Wisdom in Orgrimmar. "
            .. "The plaque, signed by Thrall, says that Mannoroth is no more and that the plates shall always remind the orcs how hard they fought to regain their honor. "
            .. "Warcraft III ends its orc campaign with that fight.",
        sources = {
            "https://www.wowhead.com/classic/object=175658",
            "https://warcraft.wiki.gg/wiki/The_Armor_of_Mannoroth",
        },
    },

    -- ===================================================================== History of Warcraft books
    -- kind = "book": the in-game History of Warcraft books that retell the strategy games. A book stands in
    -- several places (locations); reading any copy counts. order = the reading order of the series.

    last_guardian = {
        name = "The Last Guardian",
        kind = "book",
        order = 1,
        zone = "Westfall",
        coords = "52.5, 53.1",
        locations = {
            { zone = "Westfall", coords = "52.5, 53.1" },
            { zone = "Loch Modan", coords = "37.2, 47.0" },
        },
        objectIDs = { 175740 },
        honors = { "Medivh", "Aegwynn", "Llane Wrynn", "Anduin Lothar", "Nielas Aran" },
        appearances = {
            { game = "WC1", campaign = "Orcs & Humans (Human)", missions = {}, role = "Retold in this book: the background of Medivh, the Guardian whose possession leads to the First War" },
        },
        story = "This chapter tells how the Guardian Aegwynn, distrustful of the Council of Tirisfal, chose to hand her power to a son instead of to the Council's pick. She had him with the human court magician Nielas Aran, and named the boy Medivh. Unknown to her, the spirit of Sargeras had already taken hold of the child. Medivh grew up beside his friends Llane and Anduin Lothar, and when his power awoke at fourteen it clashed with the demon inside him and left him in a long coma. He woke as a grown man whose mind was being twisted toward the demon's plan.",
        sources = {
            "https://www.wowhead.com/classic/object=175740",
            "https://warcraft.wiki.gg/wiki/The_Last_Guardian_(History_of_Warcraft)",
        },
    },

    rise_of_the_horde = {
        name = "Rise of the Horde",
        kind = "book",
        order = 2,
        zone = "Ironforge",
        coords = "77.1, 13.0",
        locations = {
            { zone = "Ironforge", coords = "77.1, 13.0" },
            { zone = "Durotar", coords = "59.6, 58.2" },
            { zone = "Swamp of Sorrows", coords = "47.9, 54.9" },
        },
        objectIDs = { 175742 },
        honors = { "Gul'dan", "Durotan", "Grom Hellscream", "Mannoroth", "Blackhand", "Orgrim Doomhammer", "Kil'jaeden" },
        appearances = {
            { game = "WC1", campaign = "Orcs & Humans (Orc)", missions = {}, role = "Retold in this book: how Gul'dan and the Burning Legion forged the Horde on Draenor before the First War" },
        },
        story = "On Draenor the orcs grew more warlike under the hidden control of Gul'dan and his Shadow Council. Durotan of the Frostwolves warned against it, but Grom Hellscream and the other chieftains were won over. Gul'dan had them drink the blood of the demon Mannoroth, which bound them to the Burning Legion. Gul'dan then merged the clans into one Horde under a puppet warchief, Blackhand, and the Horde wiped out most of the draenei. The chapter ends with Kil'jaeden and Sargeras deciding the Horde is ready.",
        sources = {
            "https://www.wowhead.com/classic/object=175742",
            "https://warcraft.wiki.gg/wiki/Rise_of_the_Horde_(History_of_Warcraft)",
        },
    },

    dark_portal_fall_of_stormwind = {
        name = "The Dark Portal and the Fall of Stormwind",
        kind = "book",
        order = 3,
        zone = "Redridge Mountains",
        coords = "26.8, 45.8",
        locations = {
            { zone = "Redridge Mountains", coords = "26.8, 45.8" },
            { zone = "Blasted Lands", coords = "66.8, 18.4" },
            { zone = "Swamp of Sorrows", coords = "47.8, 55.0" },
        },
        objectIDs = { 175745 },
        honors = { "Medivh", "Llane Wrynn", "Anduin Lothar", "Khadgar", "Gul'dan", "Durotan", "Orgrim Doomhammer", "Blackhand", "Garona" },
        appearances = {
            { game = "WC1", campaign = "Orcs & Humans (Human)", missions = {}, role = "Retold in this book: the First War, from the opening of the Dark Portal to the fall of Stormwind" },
        },
        story = "Medivh, still fighting Sargeras for his soul, helps the Shadow Council open the Dark Portal. Gul'dan exiles Durotan and the Frostwolves through it, and the Horde slowly gathers in Azeroth before striking at Stormwind. Lothar breaks with King Llane, who sits tight in Stormwind, and storms Karazhan with the apprentice Khadgar and kills the possessed Medivh. The Horde keeps winning anyway, Orgrim kills Blackhand and takes the Horde, and Llane is murdered by the half-orc Garona as Stormwind falls. Lothar returns too late and swears to take back the kingdom.",
        sources = {
            "https://www.wowhead.com/classic/object=175745",
            "https://warcraft.wiki.gg/wiki/The_Dark_Portal_and_the_Fall_of_Stormwind",
        },
    },

    alliance_of_lordaeron = {
        name = "The Alliance of Lordaeron",
        kind = "book",
        order = 4,
        zone = "Stormwind City",
        coords = "73.0, 9.6",
        locations = {
            { zone = "Stormwind City", coords = "73.0, 9.6" },
            { zone = "Ironforge", coords = "76.9, 12.2" },
            { zone = "Dun Morogh", coords = "47.6, 52.0" },
            { zone = "Duskwood", coords = "72.1, 47.9" },
            { zone = "Hillsbrad Foothills", coords = "63.7, 20.8" },
        },
        objectIDs = { 175746 },
        honors = { "Anduin Lothar", "Uther the Lightbringer", "Daelin Proudmoore", "Turalyon", "Orgrim Doomhammer", "Gul'dan", "Khadgar", "Anasterian Sunstrider" },
        appearances = {
            { game = "WC2", campaign = "Tides of Darkness", missions = {}, role = "Retold in this book: the Second War and the Alliance of Lordaeron" },
        },
        story = "After Stormwind falls, Lothar leads the survivors north and the seven human kingdoms form the Alliance of Lordaeron, with dwarves and a few high elves joining. Under Warchief Doomhammer the Horde adds ogres and Amani trolls, and uses the Demon Soul to force the red dragon Alexstrasza to fight for it. The war rages across Khaz Modan, Lordaeron and the sea. Just as the Horde is about to win, Gul'dan and his followers abandon their posts to hunt for the Tomb of Sargeras, which costs Doomhammer his chance. The Alliance then rounds up the orcs in internment camps, and Khadgar has Nethergarde built to watch the Dark Portal.",
        sources = {
            "https://www.wowhead.com/classic/object=175746",
            "https://warcraft.wiki.gg/wiki/The_Alliance_of_Lordaeron",
        },
    },

    aftermath_second_war = {
        name = "Aftermath of the Second War",
        kind = "book",
        order = 5,
        zone = "Stormwind City",
        coords = "73.0, 9.4",
        locations = {
            { zone = "Stormwind City", coords = "73.0, 9.4" },
            { zone = "Darnassus", coords = "55.4, 13.0" },
            { zone = "Arathi Highlands", coords = "22.6, 24.0" },
            { zone = "Blasted Lands", coords = "64.3, 15.5" },
        },
        objectIDs = { 21581 },
        honors = { "Anduin Lothar", "Orgrim Doomhammer", "Turalyon", "Uther the Lightbringer", "Daelin Proudmoore" },
        appearances = {
            { game = "WC2", campaign = "Tides of Darkness", missions = {}, role = "Retold in this book: the last campaign of the Second War, from Blackrock Spire to the Dark Portal" },
        },
        story = "The Alliance, led by Lothar, Uther and Daelin Proudmoore, pushes the orcs out of Lordaeron and back into Azeroth. Lothar besieges Blackrock Spire, and Doomhammer breaks out and fights him in the Burning Steppes, where Doomhammer wins and Lothar dies. Turalyon picks up Lothar's shield and rallies the Alliance for a counterattack that routs most of the orcs. The survivors flee through the Swamp of Sorrows to the Dark Portal in the Blasted Lands. There the last battle is fought, Doomhammer is captured, and the orc clans are sent north to camps.",
        sources = {
            "https://www.wowhead.com/classic/object=21581",
            "https://warcraft.wiki.gg/wiki/Aftermath_of_the_Second_War",
        },
    },

    beyond_the_dark_portal = {
        name = "Beyond the Dark Portal",
        kind = "book",
        order = 7,
        zone = "Stormwind City",
        coords = "73.2, 6.2",
        locations = {
            { zone = "Stormwind City", coords = "73.2, 6.2" },
            { zone = "Stranglethorn Vale", coords = "26.9, 77.3" },
            { zone = "Arathi Highlands", coords = "22.6, 24.0" },
            { zone = "Blasted Lands", coords = "65.2, 22.8" },
        },
        objectIDs = { 21582 },
        honors = { "Ner'zhul", "Terenas Menethil II", "Turalyon", "Khadgar", "Alleria Windrunner", "Kurdran Wildhammer", "Danath Trollbane" },
        appearances = {
            { game = "BTDP", campaign = "Beyond the Dark Portal", missions = {}, role = "Retold in this book: the Alliance expedition to Draenor and the end of the Dark Portal" },
        },
        story = "Shortly after Nethergarde is finished, the Dark Portal opens again and Ner'zhul's orcs pour through to steal magical artifacts. King Terenas sends Khadgar and Turalyon into Draenor, where they get help from Alleria, Kurdran and Danath. They cannot stop Ner'zhul, and when Draenor starts to tear itself apart they choose to destroy the portal to protect Azeroth. The book says only that the heroes probably succeeded, and leaves their fate open.",
        sources = {
            "https://www.wowhead.com/classic/object=21582",
            "https://warcraft.wiki.gg/wiki/Beyond_the_Dark_Portal_(History_of_Warcraft)",
        },
    },

    birth_of_the_lich_king = {
        name = "The Birth of the Lich King",
        kind = "book",
        order = 8,
        zone = "Duskwood",
        coords = "72.0, 46.4",
        locations = {
            { zone = "Duskwood", coords = "72.0, 46.4" },
            { zone = "Hillsbrad Foothills", coords = "52.0, 58.4" },
        },
        objectIDs = { 175748 },
        honors = { "Ner'zhul", "Kil'jaeden", "Tichondrius" },
        appearances = {
            { game = "BTDP", campaign = "Beyond the Dark Portal", missions = {}, role = "Retold in this book: what happens to Ner'zhul after he flees Draenor, and how he becomes the Lich King" },
        },
        story = "Ner'zhul and his followers flee into the Twisting Nether, where Kil'jaeden is waiting to punish him for his defiance. The demon tears the old shaman's body apart but keeps his spirit alive, and Ner'zhul agrees to serve the Legion one more time. His spirit is sealed in a block of ice from the Nether, and the orc Ner'zhul is gone: the Lich King is born, while his loyal spellcasters are remade as liches. Kil'jaeden's task for him is to spread a plague over Azeroth that will wipe out humanity, with the dreadlord Tichondrius sent to keep watch over him.",
        sources = {
            "https://www.wowhead.com/classic/object=175748",
            "https://warcraft.wiki.gg/wiki/The_Birth_of_the_Lich_King",
        },
    },

    icecrown_and_the_frozen_throne = {
        name = "Icecrown and the Frozen Throne",
        kind = "book",
        order = 9,
        zone = "Elwynn Forest",
        coords = "43.8, 65.8",
        locations = {
            { zone = "Elwynn Forest", coords = "43.8, 65.8" },
            { zone = "Undercity", coords = "55.9, 50.9" },
        },
        objectIDs = { 175749 },
        honors = { "Ner'zhul", "Kil'jaeden" },
        appearances = {
            { game = "WC3", campaign = "The Scourge of Lordaeron (Human)", missions = {}, role = "Retold in this book: how the Lich King settles in Icecrown and first tests the plague of undeath, before Reign of Chaos" },
        },
        story = "Kil'jaeden hurls Ner'zhul's icy cask down to Azeroth, where it crashes into the Icecrown glacier in Northrend and takes the shape of a throne. From the Frozen Throne Ner'zhul enslaves the minds of ice trolls, wendigo and other creatures, and gathers a small army in the caverns beneath Icecrown. To test his power he sends a plague of undeath against a human village at the edge of the Dragonblight. Within three days everyone there is dead, and then they rise as zombies that he can feel and command as if they were his own limbs. Over the following months he subjugates every human in Northrend and waits for his true test.",
        sources = {
            "https://www.wowhead.com/classic/object=175749",
            "https://warcraft.wiki.gg/wiki/Icecrown_and_the_Frozen_Throne",
        },
    },

    battle_of_grim_batol = {
        name = "The Battle of Grim Batol",
        kind = "book",
        order = 10,
        zone = "Wetlands",
        coords = "10.8, 60.8",
        locations = {
            { zone = "Wetlands", coords = "10.8, 60.8" },
            { zone = "Mulgore", coords = "31.5, 49.4" },
        },
        objectIDs = { 175750 },
        honors = { "Grom Hellscream", "Kilrogg Deadeye", "Nekros Skullcrusher", "Alexstrasza", "Rhonin" },
        appearances = {
            { game = "BOOK", campaign = "Day of the Dragon", missions = {}, role = "Retold in this book: the Dragonmaw clan's last stand at Grim Batol and the freeing of Alexstrasza (events of the novel Day of the Dragon)" },
        },
        story = "After the Second War Grom Hellscream's Warsong clan slips away, while Kilrogg Deadeye's Bleeding Hollow are rounded up and sent to the internment camps. Far north in Khaz Modan the Dragonmaw clan under the warlock Nekros still holds the Dragonqueen Alexstrasza hostage with the Demon Soul, and builds a secret army in the abandoned dwarven stronghold of Grim Batol. Nekros hopes to unleash her red dragons on the Alliance and revive the Horde, but a small band of resistance fighters led by the human mage Rhonin destroys the Demon Soul and frees her. The furious dragons tear Grim Batol apart and burn most of the clan, and the survivors are sent to the camps, which ends the Horde for good.",
        sources = {
            "https://www.wowhead.com/classic/object=175750",
            "https://warcraft.wiki.gg/wiki/The_Battle_of_Grim_Batol_(History_of_Warcraft)",
        },
    },

    the_new_horde = {
        name = "The New Horde",
        kind = "book",
        order = 12,
        zone = "Stormwind City",
        coords = "72.5, 9.6",
        locations = {
            { zone = "Stormwind City", coords = "72.5, 9.6" },
            { zone = "The Barrens", coords = "61.9, 54.9" },
            { zone = "Swamp of Sorrows", coords = "47.8, 55.0" },
        },
        objectIDs = { 175752 },
        honors = { "Thrall", "Aedelas Blackmoore", "Grom Hellscream", "Durotan", "Drek'Thar", "Orgrim Doomhammer" },
        appearances = {
            { game = "BOOK", campaign = "Lord of the Clans", missions = {}, role = "Retold in this book: Thrall's rise from slave to Warchief of a new Horde (the events of the novel Lord of the Clans)" },
        },
        story = "Aedelas Blackmoore, warden of the orc internment camps, raises an orphaned orc as a slave and gladiator and names him Thrall. Thrall escapes, finds the camps full of broken, listless orcs, and meets Grom Hellscream, who is still fighting in secret. He then learns that he is the son of Durotan and is trained as a shaman by Drek'Thar. With old Orgrim Doomhammer at his side he frees the camps and ends Blackmoore's plans, and Doomhammer dies in the fighting. Thrall takes up Doomhammer's hammer and armor and becomes Warchief.",
        sources = {
            "https://www.wowhead.com/classic/object=175752",
            "https://warcraft.wiki.gg/wiki/The_New_Horde",
        },
    },

    kelthuzad_forming_of_the_scourge = {
        name = "Kel'Thuzad and the Forming of the Scourge",
        kind = "book",
        order = 14,
        zone = "Undercity",
        coords = "56.0, 51.1",
        locations = {
            { zone = "Undercity", coords = "56.0, 51.1" },
            { zone = "Hillsbrad Foothills", coords = "51.7, 58.5" },
        },
        objectIDs = { 175754 },
        honors = { "Kel'Thuzad", "Ner'zhul" },
        appearances = {
            { game = "WC3", campaign = "The Scourge of Lordaeron (Human)", missions = {}, role = "Retold in this book: how Kel'Thuzad founded the Cult of the Damned and seeded the plague before Reign of Chaos" },
        },
        story = "Kel'Thuzad, a Kirin Tor archmage long seen as a maverick for his interest in necromancy, hears the Lich King's call from Northrend and abandons Dalaran. He travels to Icecrown, kneels before the Frozen Throne, and is promised power and long life in return for obedience. His first task is to return to Lordaeron and found a new religion, which he builds in secret as the Cult of the Damned. The Lich King then gives him plague cauldrons to hide in cult villages. The plague spreads, the dead rise, and Kel'Thuzad names the growing army the Scourge.",
        sources = {
            "https://www.wowhead.com/classic/object=175754",
            "https://warcraft.wiki.gg/wiki/Kel%27Thuzad_and_the_Forming_of_the_Scourge",
        },
    },

    scourge_of_lordaeron = {
        name = "The Scourge of Lordaeron",
        kind = "book",
        order = 16,
        zone = "Westfall",
        coords = "56.9, 47.4",
        locations = {
            { zone = "Westfall", coords = "56.9, 47.4" },
            { zone = "Stranglethorn Vale", coords = "27.7, 77.1" },
            { zone = "Ashenvale", coords = "34.8, 49.8" },
        },
        objectIDs = { 175756 },
        honors = { "Arthas Menethil", "Kel'Thuzad", "Uther the Lightbringer", "Terenas Menethil II" },
        appearances = {
            { game = "WC3", campaign = "The Scourge of Lordaeron (Human)", missions = {}, role = "Retold in this book: the plague, Arthas' fall and the death of King Terenas" },
        },
        story = "Kel'Thuzad and his cult release the plague of undeath on Lordaeron, and Uther and the paladins cannot stop it. Prince Arthas fights the Scourge and kills Kel'Thuzad, but the dead keep rising and Arthas grows more ruthless, until his friends warn he is losing his humanity. He follows the plague to Northrend and takes up the cursed runeblade Frostmourne, hoping to save his people. The sword gives him great power but costs him his soul. He returns to Lordaeron as a death knight, murders his father King Terenas and crushes the kingdom.",
        sources = {
            "https://www.wowhead.com/classic/object=175756",
            "https://warcraft.wiki.gg/wiki/The_Scourge_of_Lordaeron_(History_of_Warcraft)",
        },
    },

    sunwell_fall_of_quelthalas = {
        name = "Sunwell - The Fall of Quel'Thalas",
        kind = "book",
        order = 17,
        zone = "Stranglethorn Vale",
        coords = "27.1, 77.7",
        locations = {
            { zone = "Stranglethorn Vale", coords = "27.1, 77.7" },
            { zone = "Ashenvale", coords = "34.5, 50.0" },
        },
        objectIDs = { 175757 },
        honors = { "Arthas Menethil", "Kel'Thuzad", "Sylvanas Windrunner" },
        appearances = {
            { game = "WC3", campaign = "Path of the Damned (Undead)", missions = {}, role = "Retold in this book: the Scourge's invasion of Quel'Thalas and the revival of Kel'Thuzad at the Sunwell" },
        },
        story = "The ghost of Kel'Thuzad tells Arthas that he must be revived for the next stage of the Lich King's plan, and that the Sunwell can do it. Arthas invades Quel'Thalas and destroys the high elf army despite a stubborn defense by Ranger-General Sylvanas Windrunner, whom he raises as a banshee. He lowers Kel'Thuzad's remains into the Sunwell, which fouls the waters but brings Kel'Thuzad back as a lich. By the time the Scourge turns south, no living elf is left in the kingdom.",
        sources = {
            "https://www.wowhead.com/classic/object=175757",
            "https://warcraft.wiki.gg/wiki/Sunwell_-_The_Fall_of_Quel%27Thalas",
        },
    },

    archimondes_return = {
        name = "Archimonde's Return and the Flight to Kalimdor",
        kind = "book",
        order = 18,
        zone = "The Barrens",
        coords = "62.4, 38.7",
        locations = {
            { zone = "The Barrens", coords = "62.4, 38.7" },
            { zone = "Desolace", coords = "66.3, 7.7" },
        },
        objectIDs = { 175758 },
        honors = { "Arthas Menethil", "Kel'Thuzad", "Archimonde", "Medivh", "Thrall", "Grom Hellscream", "Cairne Bloodhoof", "Cenarius", "Mannoroth", "Tyrande Whisperwind", "Malfurion Stormrage", "Illidan Stormrage" },
        appearances = {
            { game = "WC3", campaign = "Path of the Damned (Undead)", missions = {}, role = "Retold in this book: Dalaran, Medivh's spellbook and the summoning of Archimonde" },
            { game = "WC3", campaign = "The Invasion of Kalimdor (Orc)", missions = {}, role = "Retold in this book: Thrall's journey across the Barrens, Grom's fall and the death of Mannoroth" },
            { game = "WC3", campaign = "Eternity's End (Night Elf)", missions = {}, role = "Retold in this book: the night elves' fight against the Legion, up to the threat to Nordrassil" },
        },
        story = "Arthas leads the Scourge to Dalaran, where Kel'Thuzad takes Medivh's spellbook and uses it to summon Archimonde and the Legion. A mysterious prophet, who turns out to be Medivh, pushes the Horde and the Alliance across the sea to Kalimdor. Thrall's orcs meet the tauren under Cairne, but Grom Hellscream gives in to the blood curse, kills Cenarius in Ashenvale, and later redeems himself by helping Thrall destroy Mannoroth. Meanwhile Tyrande wakes Malfurion and the druids and frees Illidan from his prison, and the night elves brace for the Legion's attack on the World Tree.",
        sources = {
            "https://www.wowhead.com/classic/object=175758",
            "https://warcraft.wiki.gg/wiki/Archimonde%27s_Return_and_the_Flight_to_Kalimdor",
        },
    },

    betrayer_ascendant = {
        name = "The Betrayer Ascendant",
        kind = "book",
        order = 20,
        zone = "Darnassus",
        coords = "66.5, 76.6",
        locations = {
            { zone = "Darnassus", coords = "66.5, 76.6" },
        },
        objectIDs = { 175759 },
        honors = { "Illidan Stormrage", "Kil'jaeden", "Lady Vashj", "Maiev Shadowsong", "Malfurion Stormrage", "Tyrande Whisperwind", "Archimonde" },
        appearances = {
            { game = "TFT", campaign = "Terror of the Tides (Night Elf)", missions = {}, role = "Retold in this book: Illidan's pact with Kil'jaeden and the attack on Icecrown" },
        },
        story = "Freed from his barrow prison, Illidan absorbs the power of the Skull of Gul'dan and is changed into a demonic being. Kil'jaeden then orders him to destroy the Lich King and the Frozen Throne, promising great reward. Illidan gathers the naga under Lady Vashj, claims the Eye of Sargeras in spite of his jailor Maiev Shadowsong, and from Dalaran fires a spell at Icecrown. Malfurion and Tyrande help Maiev stop the spell before it finishes. Illidan flees to Outland with Maiev in pursuit.",
        sources = {
            "https://www.wowhead.com/classic/object=175759",
            "https://warcraft.wiki.gg/wiki/The_Betrayer_Ascendant",
        },
    },

    rise_of_the_blood_elves = {
        name = "Rise of the Blood Elves",
        kind = "book",
        order = 21,
        zone = "Elwynn Forest",
        coords = "64.6, 69.4",
        locations = {
            { zone = "Elwynn Forest", coords = "64.6, 69.4" },
            { zone = "Arathi Highlands", coords = "74.1, 32.3" },
            { zone = "Darnassus", coords = "49.2, 16.8" },
        },
        objectIDs = { 175760 },
        honors = { "Kael'thas Sunstrider", "Illidan Stormrage", "Lady Vashj", "Maiev Shadowsong" },
        appearances = {
            { game = "TFT", campaign = "Curse of the Blood Elves", missions = {}, role = "Retold in this book: Kael'thas and the blood elves join Illidan in Outland" },
        },
        story = "With Lordaeron and Quel'Thalas turned into the Plaguelands, the surviving high elves are led by Prince Kael'thas, the last Sunstrider. They rename themselves blood elves and suffer badly from being cut off from the Sunwell. Kael looks for a new source of magic and teams up with Illidan and his naga, and the Alliance commanders cast the elves out as traitors. Kael's blood elves follow Lady Vashj to Outland, where they defeat Maiev, who has recaptured Illidan, and free him to prepare a second strike on Icecrown.",
        sources = {
            "https://www.wowhead.com/classic/object=175760",
            "https://warcraft.wiki.gg/wiki/Rise_of_the_Blood_Elves",
        },
    },

    civil_war_plaguelands = {
        name = "Civil War in the Plaguelands",
        kind = "book",
        order = 22,
        zone = "Stormwind City",
        coords = "73.2, 10.0",
        locations = {
            { zone = "Stormwind City", coords = "73.2, 10.0" },
            { zone = "Ironforge", coords = "76.8, 12.3" },
            { zone = "Undercity", coords = "67.7, 37.4" },
            { zone = "Elwynn Forest", coords = "49.5, 39.6" },
            { zone = "Hillsbrad Foothills", coords = "51.3, 58.4" },
        },
        objectIDs = { 175761 },
        honors = { "Arthas Menethil", "Ner'zhul", "Sylvanas Windrunner", "Kel'Thuzad", "Illidan Stormrage" },
        appearances = {
            { game = "TFT", campaign = "Legacy of the Damned (Undead)", missions = {}, role = "Retold in this book: the undead civil war and the birth of the Forsaken" },
        },
        story = "Illidan's attack has cracked the Frozen Throne, and the weakened Lich King calls Arthas back to Northrend. Back in Lordaeron, half of the undead, led by the banshee Sylvanas Windrunner, rebel against the Scourge. Arthas leaves Kel'Thuzad in charge of the Scourge and goes north. Sylvanas and her rebels, who call themselves the Forsaken, take the ruined capital and build a stronghold beneath it. In Northrend, Arthas finds Illidan's naga and blood elves already there, and races them to Icecrown.",
        sources = {
            "https://www.wowhead.com/classic/object=175761",
            "https://warcraft.wiki.gg/wiki/Civil_War_in_the_Plaguelands",
        },
    },

    old_hatreds = {
        name = "Old Hatreds - The Colonization of Kalimdor",
        kind = "book",
        order = 24,
        zone = "Tanaris",
        coords = "51.0, 29.4",
        locations = {
            { zone = "Tanaris", coords = "51.0, 29.4" },
        },
        objectIDs = { 175763 },
        honors = { "Thrall", "Jaina Proudmoore", "Daelin Proudmoore" },
        appearances = {
            { game = "TFT", campaign = "The Founding of Durotar (Orc bonus campaign)", missions = {}, role = "Retold in this book: the settling of Durotar and Theramore, and the clash with Daelin Proudmoore" },
        },
        story = "After the war with the Legion, the surviving races start over in a ravaged world. Thrall's orcs settle Kalimdor with the tauren and Darkspear trolls and call their land Durotar, while Jaina Proudmoore's humans found Theramore off the coast of Dustwallow Marsh. The truce breaks when a large Alliance fleet under Grand Admiral Daelin Proudmoore, Jaina's father, arrives and wants to destroy the orcs. Jaina chooses to help Thrall instead, and her father dies in the battle before they can reconcile. The orcs let her people go home in peace.",
        sources = {
            "https://www.wowhead.com/classic/object=175763",
            "https://warcraft.wiki.gg/wiki/Old_Hatreds_-_The_Colonization_of_Kalimdor",
        },
    },
}

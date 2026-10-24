-- books.lua – "History of Warcraft" in-game books (Classic object IDs < 180000), for ns.MEMORIALS with kind = "book".
-- order = reading order of the series (Chapters II-V of the History of Warcraft on warcraft.wiki.gg;
-- Aftermath of the Second War and Beyond the Dark Portal are not on the old website index, their place is our choice).
-- Locations/coords: Wowhead Classic g_mapperData. Instance entries have no coordinates there (coords = "").
-- Entries marked UNCERTAIN: see books_report.md.

    -- ===================================================================== Chapter II-III
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
        story = "This chapter tells how the Guardian Aegwynn, tired of the Council of Tirisfal, chose to hand her power to a son instead of to the Council's pick. She had him with the human court magician Nielas Aran, and named the boy Medivh. Unknown to her, the spirit of Sargeras had already taken hold of the child. Medivh grew up beside his friends Llane and Anduin Lothar, and when his power awoke at fourteen it clashed with the demon inside him and left him in a long coma. He woke as a grown man whose mind was being twisted toward the demon's plan.",
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

    -- ===================================================================== Chapter IV
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
        story = "Medivh, still fighting Sargeras for his soul, helps the Shadow Council open the Dark Portal. Gul'dan exiles Durotan and the Frostwolves through it, and the Horde slowly gathers in Azeroth before striking at Stormwind. Lothar breaks with King Llane's cautious plan, storms Karazhan with the apprentice Khadgar and kills the possessed Medivh. The Horde keeps winning anyway, Orgrim kills Blackhand and takes the Horde, and Llane is murdered by the half-orc Garona as Stormwind falls. Lothar returns too late and swears to take back the kingdom.",
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

    invasion_of_draenor = {
        name = "The Invasion of Draenor",
        kind = "book",
        order = 6,
        zone = "Scholomance",
        coords = "",
        locations = {
            { zone = "Scholomance", coords = "" },
        },
        objectIDs = { 175747 },
        honors = { "Ner'zhul", "Grom Hellscream", "Kilrogg Deadeye", "Terenas Menethil II", "Turalyon", "Khadgar", "Alleria Windrunner", "Kurdran Wildhammer", "Danath Trollbane" },
        appearances = {
            { game = "BTDP", campaign = "Beyond the Dark Portal", missions = {}, role = "Retold in this book: Ner'zhul's portals and the Alliance expedition into Draenor" },
        },
        story = "With the Second War over, the captive orcs sit in internment camps while the shaman Ner'zhul plans to escape Draenor through new portals. He reopens the Dark Portal and sends orcs under Grom Hellscream and Kilrogg Deadeye to steal the artifacts he needs. King Terenas sends Turalyon and Khadgar through the portal, and they fight Ner'zhul's clans in Hellfire Peninsula with help from Alleria, Kurdran and Danath. Ner'zhul opens his portals anyway and Draenor starts to break apart. Turalyon and Khadgar destroy the Dark Portal from their side, and Hellscream and Deadeye escape back to Azeroth as it explodes.",
        sources = {
            "https://www.wowhead.com/classic/object=175747",
            "https://warcraft.wiki.gg/wiki/The_Invasion_of_Draenor",
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
        story = "A short version of the same events as The Invasion of Draenor. Shortly after Nethergarde is finished, the Dark Portal opens again and Ner'zhul's orcs pour through to steal magical artifacts. King Terenas sends Khadgar and Turalyon into Draenor, where they get help from Alleria, Kurdran and Danath. They cannot stop Ner'zhul, and when Draenor starts to tear itself apart they choose to destroy the portal to protect Azeroth. The book says only that the heroes probably succeeded, and leaves their fate open.",
        sources = {
            "https://www.wowhead.com/classic/object=21582",
            "https://warcraft.wiki.gg/wiki/Beyond_the_Dark_Portal_(History_of_Warcraft)",
        },
    },

    the_new_horde = {
        name = "The New Horde",
        kind = "book",
        order = 8,
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
            { game = "WC3", campaign = "Lord of the Clans", missions = {}, role = "Retold in this book: Thrall's rise from slave to Warchief of a new Horde (events of the novel Lord of the Clans)" },
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
        order = 9,
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
        story = "Kel'Thuzad, a Kirin Tor archmage already shunned for his interest in necromancy, hears the Lich King's call from Northrend and abandons Dalaran. He travels to Icecrown, kneels before the Frozen Throne, and is promised power and long life in return for obedience. His first task is to return to Lordaeron and found a new religion, which he builds in secret as the Cult of the Damned. The Lich King then gives him plague cauldrons to hide in cult villages. The plague spreads, the dead rise, and Kel'Thuzad names the growing army the Scourge.",
        sources = {
            "https://www.wowhead.com/classic/object=175754",
            "https://warcraft.wiki.gg/wiki/Kel%27Thuzad_and_the_Forming_of_the_Scourge",
        },
    },

    alliance_splinters = {
        name = "The Alliance Splinters",
        kind = "book",
        order = 10,
        zone = "Blackrock Depths",
        coords = "",
        locations = {
            { zone = "Blackrock Depths", coords = "" },
        },
        objectIDs = { 175755 },
        honors = { "Terenas Menethil II", "Daelin Proudmoore", "Varian Wrynn", "Antonidas", "Magni Bronzebeard", "Genn Greymane" },
        appearances = {
            { game = "WC3", campaign = "The Scourge of Lordaeron (Human)", missions = {}, role = "Retold in this book: the Alliance falling apart just before Reign of Chaos" },
        },
        story = "While the death cults grow unnoticed, the Alliance leaders quarrel over land and money. Taxes for rebuilding Stormwind and for guarding the orc camps make some rulers, Genn Greymane among them, resent the pact. The high elves of Silvermoon withdraw, blaming humans for the burning of their forests, and Gilneas and Stromgarde follow them out. King Terenas can still count on Kul Tiras under Admiral Proudmoore, Stormwind under Varian Wrynn, the Kirin Tor under Antonidas and the dwarves of Magni Bronzebeard.",
        sources = {
            "https://www.wowhead.com/classic/object=175755",
            "https://warcraft.wiki.gg/wiki/The_Alliance_Splinters",
        },
    },

    -- ===================================================================== Chapter V
    scourge_of_lordaeron = {
        name = "The Scourge of Lordaeron",
        kind = "book",
        order = 11,
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
        order = 12,
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
        order = 13,
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
        order = 14,
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
        order = 15,
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
        story = "With Lordaeron and Quel'Thalas turned into the Plaguelands, the surviving high elves are led by Prince Kael'thas, the last Sunstrider. They rename themselves blood elves and suffer badly from being cut off from the Sunwell. Kael looks for a new source of magic and teams up with Illidan and his naga, and the Alliance commanders cast the elves out as traitors. Kael and Lady Vashj follow Illidan to Outland, where they defeat Maiev and free Illidan to prepare a second strike on Icecrown.",
        sources = {
            "https://www.wowhead.com/classic/object=175760",
            "https://warcraft.wiki.gg/wiki/Rise_of_the_Blood_Elves",
        },
    },

    civil_war_plaguelands = {
        name = "Civil War in the Plaguelands",
        kind = "book",
        order = 16,
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

    lich_king_triumphant = {
        name = "The Lich King Triumphant",
        kind = "book",
        order = 17,
        zone = "Stratholme",
        coords = "",
        locations = {
            { zone = "Stratholme", coords = "" },
            { zone = "Scholomance", coords = "" },
        },
        objectIDs = { 175762 },
        honors = { "Arthas Menethil", "Ner'zhul", "Illidan Stormrage", "Kel'Thuzad", "Sylvanas Windrunner" },
        appearances = {
            { game = "TFT", campaign = "Legacy of the Damned (Undead)", missions = {}, role = "Retold in this book: Arthas reaches the Frozen Throne and becomes the Lich King" },
        },
        story = "Arthas gets to the Frozen Throne before Illidan and shatters the ice around the Lich King with Frostmourne. He puts on Ner'zhul's helm, and the two spirits merge into one being. Illidan and his army have to retreat to Outland. The chapter closes with a snapshot of the world: Arthas is in Northrend and is said to be rebuilding Icecrown, Kel'Thuzad commands the Scourge in the Plaguelands, and Sylvanas and the Forsaken hold only Tirisfal Glades.",
        sources = {
            "https://www.wowhead.com/classic/object=175762",
            "https://warcraft.wiki.gg/wiki/The_Lich_King_Triumphant",
        },
    },

    old_hatreds = {
        name = "Old Hatreds - The Colonization of Kalimdor",
        kind = "book",
        order = 18,
        zone = "Tanaris",
        coords = "51.0, 29.4",
        locations = {
            { zone = "Tanaris", coords = "51.0, 29.4" },
        },
        objectIDs = { 175763 },
        honors = { "Thrall", "Jaina Proudmoore", "Daelin Proudmoore", "Cairne Bloodhoof" },
        appearances = {
            { game = "TFT", campaign = "The Founding of Durotar (Orc bonus campaign)", missions = {}, role = "Retold in this book: the settling of Durotar and Theramore, and the clash with Daelin Proudmoore" },
        },
        story = "After the war with the Legion, the surviving races start over in a ravaged world. Thrall's orcs settle Kalimdor with the tauren and Darkspear trolls and call their land Durotar, while Jaina Proudmoore's humans found Theramore off the coast of Dustwallow Marsh. The truce breaks when a large Alliance fleet under Grand Admiral Daelin Proudmoore, Jaina's father, arrives and wants to destroy the orcs. Jaina chooses to help Thrall instead, and her father dies in the battle before they can reconcile. The orcs let her people go home in peace.",
        sources = {
            "https://www.wowhead.com/classic/object=175763",
            "https://warcraft.wiki.gg/wiki/Old_Hatreds_-_The_Colonization_of_Kalimdor",
        },
    },

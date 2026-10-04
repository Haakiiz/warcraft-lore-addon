-- Data.lua – the Warcraft Lore database
--
-- One entry per NPC, keyed by NPC ID: [NPC ID] = { ... }.
-- Find an NPC's ID in game with /wcl id (target the NPC first).
--
-- FIELDS
--   name        (required) The NPC's name in WoW (English client).
--   zone        (required) The zone the NPC stands in, e.g. "Orgrimmar".
--   coords      (optional) Map coordinates as text, e.g. "32.0, 37.8". "" if unknown.
--   alsoIn      (optional) Other zones the NPC also walks through, e.g. { "Desolace", "Feralas" }.
--   appearances (required) List of appearances in the RTS games. Each has:
--       game      "WC1"  = Warcraft: Orcs & Humans
--                 "WC2"  = Warcraft II: Tides of Darkness
--                 "BTDP" = Warcraft II: Beyond the Dark Portal
--                 "WC3"  = Warcraft III: Reign of Chaos
--                 "TFT"  = Warcraft III: The Frozen Throne
--                 "FK"   = Warcraft III Reforged: Forsaken Kingdom (the new Undead campaign)
--                 "BOOK" = Warcraft novels and books (campaign = book title, missions = chapters)
--                 Characters Reforged added to old RoC/TFT missions keep WC3/TFT;
--                 say "Reforged only" in the role. A BOOK appearance is never a game appearance:
--                 use it only for what happens in the book.
--       campaign  Campaign and side, e.g. "The Invasion of Kalimdor (Orc)". "" if unknown.
--       missions  List of mission names (original English titles). {} if unknown.
--       role      The role there: hero, unit, quest giver, mentioned in dialogue, …
--   story       (optional) 3–6 sentences on what happened between the RTS games and WoW. "" if unknown.
--   items       (optional) WoW items tied to the NPC:
--                 { id = <item ID>, name = "<name>", note = "<how it is connected>" }
--   portrait    (optional) File name (without extension) of a portrait you added yourself
--               in WarcraftLore/Portraits/, e.g. "Thrall" for Portraits/Thrall.tga.
--               Without it the window shows the NPC's normal WoW portrait.
--   sources     (required) List of links (http/https).
--   confidence  (required) "confirmed" or "uncertain".
--   searched    (required when confidence = "uncertain") Where you looked for confirmation.
--
-- Rule: never invent mission names, items or NPC IDs. If something is missing, leave the field empty.
-- Run tests/validate_db.py after changes.
--
-- NPC IDs and coordinates come from Wowhead Classic. Forever may change them,
-- so check them in game with /wcl id.

local _, ns = ...

ns.NPCS = {

    -- ===================================================================== Orgrimmar
    [4949] = {
        name = "Thrall",
        zone = "Orgrimmar",
        coords = "32.0, 37.8",
        appearances = {
            {
                game = "WC3",
                campaign = "The Invasion of Kalimdor (Orc)",
                missions = { "Landfall", "The Long March", "Cry of the Warsong",
                             "Where Wyverns Dare", "The Oracle", "By Demons Be Driven" },
                role = "Playable hero (Far Seer); absent from chapters 4–5, which belong to Grom Hellscream",
            },
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "To Tame a Land" },
                role = "Allied NPC; the Warchief who gives Rexxar his orders",
            },
        },
        story = "After the Third War, Thrall gathered the orcs and found them a new home in Kalimdor. "
             .. "He founded Durotar, named after his father Durotan, with Orgrimmar as its capital, named after Orgrim Doomhammer. "
             .. "In The Founding of Durotar, Rexxar helped him secure the young nation. "
             .. "In World of Warcraft he leads the Horde as Warchief from his hall in the Valley of Wisdom in Orgrimmar.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Thrall",
            "https://warcraft.wiki.gg/wiki/The_Invasion_of_Kalimdor",
            "https://warcraft.wiki.gg/wiki/To_Tame_a_Land",
            "https://www.wowhead.com/classic/npc=4949/thrall",
        },
        confidence = "confirmed",
    },

    [3230] = {
        name = "Nazgrel",
        zone = "Orgrimmar",
        coords = "32.4, 36.0",
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "To Tame a Land" },
                role = "Quest giver (Raider): asks Rexxar to stop the harpies raiding the supply caravans",
            },
            {
                game = "BOOK",
                campaign = "Cycle of Hatred",
                missions = {},
                role = "Minor character in the novel (not a game appearance): his men help carry the wounded orc Byrok to Thrall, and he readies the orc troops when the human army gathers at Northwatch Hold",
            },
        },
        story = "Nazgrel was freed from an internment camp by Thrall and became one of his most trusted advisors. "
             .. "When Orgrimmar was built, he was put in charge of the new city's security. "
             .. "He could not leave the city when the harpy queen Bloodfeather attacked the caravans, so he sent Rexxar instead. "
             .. "He distrusts the Alliance. "
             .. "In World of Warcraft he stands in Grommash Hold as Thrall's general and chief of security.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Nazgrel",
            "https://warcraft.wiki.gg/wiki/To_Tame_a_Land_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/Cycle_of_Hatred",
            "https://www.wowhead.com/classic/npc=3230",
        },
        confidence = "confirmed",
    },

    [10540] = {
        name = "Vol'jin",
        zone = "Orgrimmar",
        coords = "34.2, 36.4",
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "To Tame a Land", "Old Hatreds" },
                role = "Quest giver and advisor (Witch Doctor); the Darkspear chieftain turns Rexxar, Rokhan and Chen into invisible wyverns",
            },
        },
        story = "Vol'jin stayed behind on the Darkspear isles when many trolls sailed to Kalimdor with the orcs. "
             .. "Rexxar, Rokhan and Chen Stormstout helped him evacuate the tribe, and he advised Rexxar to recruit the tauren and the ogres against the humans. "
             .. "After the war he led the tribe back to the Echo Isles, but the witch doctor Zalazane enslaved many of them with dark magic. "
             .. "Vol'jin withdrew to the mainland and founded Sen'jin Village on the southern coast of Durotar. "
             .. "In World of Warcraft he lives in Thrall's fortress in Orgrimmar and advises the Warchief.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Vol'jin",
            "https://warcraft.wiki.gg/wiki/To_Tame_a_Land_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/Old_Hatreds_(WC3_Orc)",
            "https://www.wowhead.com/classic/npc=10540",
        },
        confidence = "confirmed",
    },

    [15460] = {
        name = "Grunt Maug",
        zone = "Orgrimmar",
        coords = "31.0, 65.2",
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "To Tame a Land" },
                role = "Grunt guarding a gate to Orgrimmar (Warcraft III: Reforged only)",
            },
        },
        story = "Maug guarded a gate to Orgrimmar during the invasion of Durotar. "
             .. "In World of Warcraft he collected tin bars for the Horde's war effort before the war against Ahn'Qiraj. "
             .. "He stands in the Valley of Spirits and is known for not being able to count. "
             .. "In the original game he was removed from Orgrimmar in patch 1.9.0, so he may not exist in Forever.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Grunt_Maug",
            "https://warcraft.wiki.gg/wiki/To_Tame_a_Land_(WC3_Orc)",
            "https://www.wowhead.com/classic/npc=15460",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Alterac Mountains
[2257] = {
        name = "Mug'thol",
        zone = "Alterac Mountains",
        coords = "35.2, 54.0",
        appearances = {
            {
                game = "TFT",
                campaign = "Legacy of the Damned (Undead)",
                missions = { "The Dark Lady" },
                role = "Optional unit (Ogre Warlord of the Stonemaul): Sylvanas' banshees can possess him and his ogres to fight Varimathras",
            },
        },
        story = "Mug'thol led a group of Stonemaul ogres that stayed in Lordaeron after the Second War. "
             .. "In The Dark Lady, Sylvanas Windrunner had her banshees possess him so that his ogres would fight Varimathras instead of waiting in the hills. "
             .. "Later he and his warband were sent to the ruins of Alterac to retrieve the Crown of Will for Sylvanas. "
             .. "Instead of handing it over he put it on, which freed him from the banshee's possession. "
             .. "He then settled in the ruins of Alterac as the warlord of the Crushridge ogres, and Horde adventurers were sent to take the crown back.",
        items = {
            { id = 3553, name = "Mug'thol's Head", note = "Quest item looted from him for \"The Crown of Will\"" },
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Mug%27thol",
            "https://warcraft.wiki.gg/wiki/Mug%27thol_(Warcraft_III)",
            "https://warcraft.wiki.gg/wiki/The_Dark_Lady_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=2257/mugthol",
            "https://www.wowhead.com/classic/item=3553",
        },
        confidence = "confirmed",
    },

    [2543] = {
        name = "Archmage Ansirem Runeweaver",
        zone = "Alterac Mountains",
        coords = "18.8, 78.4",
        appearances = {
            {
                game = "WC3",
                campaign = "Path of the Damned (Undead)",
                missions = { "Under the Burning Sky" },
                role = "Possible enemy archmage (random enemy hero name listed in the mission notes \"since patch 1.33\"); not a fixed story character",
            },
        },
        story = "Ansirem Runeweaver is a member of the Council of Six, the leaders of the Kirin Tor of Dalaran. "
             .. "The wiki says he fought outside Dalaran against Arthas and the Scourge while Kel'Thuzad summoned Archimonde. "
             .. "In World of Warcraft he is a human quest giver in the Dalaran Crater in the Alterac Mountains.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Archmage_Ansirem_Runeweaver",
            "https://warcraft.wiki.gg/wiki/Under_the_Burning_Sky_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=2543",
        },
        confidence = "uncertain",
        searched = "warcraft.wiki.gg Ansirem Runeweaver page and Under the Burning Sky (WC3 Undead); the mission page only lists his name among enemy random-hero names in its Notes section (\"Since patch 1.33 ...\"), so the link rests on a name alone. Whether later patches (1.36.1, 2.0) changed these names could not be verified from the wiki.",
    },

    -- ===================================================================== Darkshore
[3660] = {
        name = "Athrikus Narassin",
        zone = "Darkshore",
        coords = "56.0, 26.0",
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "A Blaze of Glory" },
                role = "Mentioned (item lore only): the history text of the artifact Athrikus' Ring of Power, found at Magic Rings and Things in the Theramore City map, tells his story; he does not appear as a unit",
            },
        },
        story = "In Warcraft III the item text of Athrikus' Ring of Power says Athrikus Narassin coveted the Well of Eternity and its arcane powers. "
             .. "When the Well exploded, his magical items were blasted from his body and scattered across Kalimdor. "
             .. "He survived, found himself imbued with demonic powers, and used them to chain the souls of lesser highborne to himself, granting him immortality. "
             .. "In World of Warcraft he leads the Cult of the Dark Strand from the Tower of Althalaxx in Darkshore, and Balthule Shadowstrike sends Alliance adventurers to kill him and bring back his head.",
        items = {
            { id = 5383, name = "Athrikus Narassin's Head", note = "Quest item dropped by him for the quest \"The Tower of Althalaxx\"" },
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Athrikus_Narassin",
            "https://warcraft.wiki.gg/wiki/Athrikus%27_Ring_of_Power",
            "https://warcraft.wiki.gg/wiki/A_Blaze_of_Glory_(WC3_Orc)",
            "https://www.wowhead.com/classic/npc=3660/athrikus-narassin",
            "https://www.wowhead.com/classic/item=5383",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Durotar
    [3139] = {
        name = "Gar'Thok",
        zone = "Durotar",
        coords = "52.0, 43.4",
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "To Tame a Land" },
                role = "Quest giver (Grunt, Nazgrel's lieutenant): sends Rexxar through the Beast Den to the observatory to survey the border; his outpost is later destroyed by the humans",
            },
        },
        story = "Gar'Thok served as Nazgrel's lieutenant at an outlying outpost in the young land of Durotar. "
             .. "He told Rexxar about the quilboar problem, but the outpost was later attacked by sailors from Kul Tiras, who killed his men. "
             .. "He survived the attack and stayed in Razor Hill to instruct young members of the Horde in dealing with Durotar's problems. "
             .. "In World of Warcraft he is a quest giver in Razor Hill.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Gar%27Thok",
            "https://warcraft.wiki.gg/wiki/Gar%27thok_(Warcraft_III)",
            "https://warcraft.wiki.gg/wiki/To_Tame_a_Land_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/Founding_of_Durotar",
            "https://www.wowhead.com/classic/npc=3139/garthok",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Mulgore and Thunder Bluff
[3057] = {
        name = "Cairne Bloodhoof",
        zone = "Thunder Bluff",
        coords = "59.4, 51.4",
        appearances = {
            {
                game = "WC3",
                campaign = "The Invasion of Kalimdor (Orc)",
                missions = { "Landfall", "The Long March", "Where Wyverns Dare", "The Oracle", "By Demons Be Driven" },
                role = "Allied hero (Tauren Chieftain) fighting beside Thrall; in Landfall and The Long March he tells Thrall about the Oracle, and in all five missions he is on the Horde side",
            },
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "Old Hatreds", "A Blaze of Glory" },
                role = "Old Hatreds: the grieving chieftain whose aid Rexxar must secure; once Baine is rescued he joins as a Warrior Hero. A Blaze of Glory: hero fighting beside Rexxar against Admiral Proudmoore",
            },
        },
        story = "Cairne was the chieftain of the Bloodhoof tauren, and he met Thrall when the orcs landed in Kalimdor and fought off centaur marauders together with them. "
             .. "He told Thrall about the Oracle in the north, and later pledged the loyalty of the tauren to the Horde. "
             .. "When Baine was kidnapped by centaur, Cairne sank into a deep lethargy until Rexxar rescued his son, and then he joined Rexxar against Admiral Proudmoore. "
             .. "Cairne led his people to Mulgore and secured it as a home for all the tauren tribes, and constructed their first city high atop Thunder Bluff. "
             .. "In World of Warcraft he is the High Chieftain of the united tauren tribes and leads Thunder Bluff.",
        items = {
            { id = 18643, name = "Cairne's Hoofprint", note = "Quest item acquired from Cairne in the Children's Week quest \"Cairne's Hoofprint\"" },
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Cairne_Bloodhoof",
            "https://warcraft.wiki.gg/wiki/Cairne_Bloodhoof_(Warcraft_III)",
            "https://warcraft.wiki.gg/wiki/Landfall_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/The_Long_March_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/Where_Wyverns_Dare_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/The_Oracle_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/By_Demons_Be_Driven_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/Old_Hatreds_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/A_Blaze_of_Glory_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/Cairne%27s_Hoofprint",
            "https://www.wowhead.com/classic/npc=3057/cairne-bloodhoof",
            "https://www.wowhead.com/classic/item=18643",
        },
        confidence = "confirmed",
    },

    [2993] = {
        name = "Baine Bloodhoof",
        zone = "Mulgore",
        coords = "47.4, 60.2",
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "Old Hatreds" },
                role = "Captive NPC (Cairne's son): kidnapped by centaur in Mulgore and rescued by Rexxar in the quest \"Rescue Cairne's Son\"",
            },
        },
        story = "After the Third War, Baine went with his father Cairne as the tauren settled in Mulgore. "
             .. "Centaur led by Khiragg attacked the tauren village and kidnapped him, which sent Cairne into a lethargy. "
             .. "Rexxar found the centaur camp with the help of Bovan Windtotem, killed Khiragg and brought Baine back to his father. "
             .. "Afterward Baine served his father as an adviser. "
             .. "In World of Warcraft he leads the tauren at Bloodhoof Village, investigating the Venture Company and campaigning against the Palemane gnolls.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Baine_Bloodhoof",
            "https://warcraft.wiki.gg/wiki/Baine_Bloodhoof_(Warcraft_III)",
            "https://warcraft.wiki.gg/wiki/Old_Hatreds_(WC3_Orc)",
            "https://www.wowhead.com/classic/npc=2993/baine-bloodhoof",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== The Barrens
    [3391] = {
        name = "Gazlowe",
        zone = "The Barrens",
        coords = "62.6, 36.2",
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "To Tame a Land" },
                role = "Quest giver (Engineer): sends Rexxar into the tunnels under Orgrimmar to seal off the kobold dens",
            },
        },
        story = "Gazlowe was chief engineer when Orgrimmar was built, and dug tunnels under the city in search of water. "
             .. "When the city was finished, Thrall paid him for the work. "
             .. "He then founded the port town of Ratchet at the mouth of the Southfury River in the Barrens. "
             .. "In World of Warcraft he runs Ratchet, a neutral trading port in the Barrens.",
        items = {
            { id = 5080, name = "Gazlowe's Ledger", note = "Quest item in \"The Missing Shipment\"" },
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Monte_Gazlowe",
            "https://warcraft.wiki.gg/wiki/To_Tame_a_Land",
            "https://warcraft.wiki.gg/wiki/The_Founding_of_Durotar",
            "https://www.wowhead.com/classic/npc=3391/gazlowe",
            "https://www.wowhead.com/classic/item=5080",
        },
        confidence = "confirmed",
    },

    [3390] = {
        name = "Apothecary Helbrim",
        zone = "The Barrens",
        coords = "51.4, 30.2",
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "A Blaze of Glory" },
                role = "Mentioned: a goblin shop on Theramore Isle is called \"Helbrim's Potions\"",
            },
        },
        story = "",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Apothecary_Helbrim",
            "https://warcraft.wiki.gg/wiki/Helbrim's_Potions",
            "https://www.wowhead.com/classic/npc=3390",
        },
        confidence = "uncertain",
        searched = "warcraft.wiki.gg (Apothecary Helbrim, Helbrim's Potions, A Blaze of Glory). The wiki itself says the shared name may be a coincidence. "
                .. "It suggests Helbrim may have been a human who followed Jaina before becoming Forsaken, but that is not confirmed.",
    },

    -- ===================================================================== Silverpine Forest
    [1938] = {
        name = "Dalar Dawnweaver",
        zone = "Silverpine Forest",
        coords = "44.2, 39.8",
        appearances = {
            {
                game = "WC3",
                campaign = "Path of the Damned (Undead)",
                missions = { "Under the Burning Sky" },
                role = "Enemy hero (Archmage), Warcraft III: Reforged only. Originally one of the random Archmage hero names; since patch 1.33 "
                    .. "one of seven named archmages defending Dalaran, so he may be missing from a given playthrough",
            },
        },
        story = "Dalar was an archmage of the Kirin Tor and was present when Kel'Thuzad summoned Archimonde at Dalaran. "
             .. "He died in the Scourge's attack on the city and was raised as one of the undead. "
             .. "Sylvanas freed him from the Lich King's control, and he joined the Forsaken. "
             .. "In World of Warcraft he works at the Sepulcher in Silverpine Forest and sends adventurers after Archmage Arugal.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Dalar_Dawnweaver",
            "https://warcraft.wiki.gg/wiki/Under_the_Burning_Sky_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/Random_hero",
            "https://www.wowhead.com/classic/npc=1938",
        },
        confidence = "uncertain",
        searched = "warcraft.wiki.gg (Dalar Dawnweaver, Under the Burning Sky, Random hero). His Warcraft III appearance is a random Archmage hero name; "
                .. "the Random hero page says such heroes \"can only be guessed at, if they exist as actual characters at all\", "
                .. "although Dalar's own page treats him as present at Archimonde's summoning. Whether later patches (1.36.1, 2.0) changed these names could not be verified from the wiki.",
    },

    [1948] = {
        name = "Snarlmane",
        zone = "Silverpine Forest",
        coords = "65.2, 24.0",
        appearances = {
            {
                game = "TFT",
                campaign = "Legacy of the Damned (Undead)",
                missions = { "The Dark Lady" },
                role = "Gnoll leader; Sylvanas has a banshee possess him and turns his gnolls against Varimathras' forces",
            },
        },
        story = "",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Snarlmane",
            "https://warcraft.wiki.gg/wiki/Snarlmane_(Warcraft_III)",
            "https://www.wowhead.com/classic/npc=1948",
        },
        confidence = "uncertain",
        searched = "warcraft.wiki.gg (Snarlmane, Snarlmane (Warcraft III)). Both pages only speculate that the WoW gnoll at Fenris Keep "
                .. "and the Warcraft III gnoll are the same or connected; no source confirms it.",
    },

    -- ===================================================================== Stonetalon Mountains
    [10182] = {
        name = "Rexxar",
        zone = "Stonetalon Mountains",
        coords = "30.2, 76.0",
        alsoIn = { "Desolace", "Feralas" },
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "To Tame a Land", "Old Hatreds", "A Blaze of Glory" },
                role = "Main playable hero (Beastmaster); the Mok'nathal who helps Thrall secure Durotar",
            },
        },
        story = "Thrall named Rexxar Champion of the Horde and let him lead the attack on Admiral Daelin Proudmoore's forces at Theramore. "
             .. "Rexxar named the ogre Mok'Morokk the new leader of the Stonemaul clan, a decision he would later regret. "
             .. "Thrall invited him to Durotar, but Rexxar said his place was still in the wild, though he would always be part of the Horde. "
             .. "In World of Warcraft he wanders the wilds of Kalimdor with his bear Misha, on a path from the Stonetalon Mountains through Desolace to Feralas.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Rexxar",
            "https://warcraft.wiki.gg/wiki/Rexxar_(Warcraft_III)",
            "https://warcraft.wiki.gg/wiki/The_Founding_of_Durotar",
            "https://www.wowhead.com/classic/npc=10182",
        },
        confidence = "confirmed",
    },

    [10204] = {
        name = "Misha",
        zone = "Stonetalon Mountains",
        coords = "30.2, 76.0",
        alsoIn = { "Desolace", "Feralas" },
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "To Tame a Land", "A Blaze of Glory" },
                role = "Rexxar's bear companion, summoned with his \"Summon Misha\" ability",
            },
        },
        story = "Misha fought at Rexxar's side in the battle against Lord Admiral Daelin Proudmoore at Theramore Isle. "
             .. "When Rexxar turned down Thrall's offer and returned to the wild, Misha went with him. "
             .. "In World of Warcraft she follows her master along the road from the Stonetalon Mountains through Desolace to Feralas.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Misha",
            "https://warcraft.wiki.gg/wiki/Misha_(Warcraft_III)",
            "https://www.wowhead.com/classic/npc=10204",
        },
        confidence = "confirmed",
    },

    [3995] = {
        name = "Witch Doctor Jin'Zil",
        zone = "Stonetalon Mountains",
        coords = "74.4, 97.8",
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "A Blaze of Glory" },
                role = "Mentioned: a voodoo shop in Theramore is called \"Jin'Zil's Magic Shack\"",
            },
        },
        story = "",
        items = {
            { id = 5594, name = "Letter to Jin'Zil", note = "Quest item addressed to him" },
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Witch_Doctor_Jin'Zil",
            "https://warcraft.wiki.gg/wiki/Jin'Zil%27s_Magic_Shack",
            "https://warcraft.wiki.gg/wiki/A_Blaze_of_Glory_(WC3_Orc)",
            "https://www.wowhead.com/classic/npc=3995",
            "https://www.wowhead.com/classic/item=5594",
        },
        confidence = "uncertain",
        searched = "warcraft.wiki.gg (Witch Doctor Jin'Zil, A Blaze of Glory). The wiki only says he might have been present "
                .. "during the first attack on Theramore, because a voodoo shop there carries his name.",
    },

    -- ===================================================================== Dustwallow Marsh
[4968] = {
        name = "Lady Jaina Proudmoore",
        zone = "Dustwallow Marsh",
        coords = "66.2, 49.0",
        appearances = {
            {
                game = "WC3",
                campaign = "The Scourge of Lordaeron (Human)",
                missions = { "Jaina's Meeting", "Ravages of the Plague", "The Cult of the Damned", "March of the Scourge", "The Culling" },
                role = "Hero (sorceress) at Arthas's side: introduced in Jaina's Meeting; \"Jaina must survive\" in Ravages of the Plague; leaves Arthas in The Culling",
            },
            {
                game = "WC3",
                campaign = "The Invasion of Kalimdor (Orc)",
                missions = { "Where Wyverns Dare", "The Oracle", "By Demons Be Driven" },
                role = "Leader of the human survivors: opposes Thrall at Stonetalon Peak, then allies with him and gives him the soul gem",
            },
            {
                game = "WC3",
                campaign = "Eternity's End (Night Elf)",
                missions = { "Twilight of the Gods" },
                role = "Allied commander (NPC) at the Battle of Mount Hyjal; teleports in and helps Thrall delay Archimonde",
            },
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "Old Hatreds", "A Blaze of Glory" },
                role = "Allied NPC: helps Rexxar discover who is behind the human incursions, then tells Thrall about the goblin shipyard",
            },
        },
        story = "After the Battle of Mount Hyjal, Jaina's expedition settled on the coast of Dustwallow Marsh and built the island citadel of Theramore to safeguard the ragtag remnants of the failing Alliance. "
             .. "She and Thrall declared that they would respect each other's territory. "
             .. "When her father Daelin Proudmoore threatened the Horde, she helped the Horde gain ships from the goblins and ordered her own troops to stand down when they assaulted Theramore. "
             .. "Daelin died in the fight, and the people of Kul Tiras nursed a bitter hatred towards Jaina for betraying her family. "
             .. "In World of Warcraft she rules Theramore from her tower.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Jaina_Proudmoore",
            "https://warcraft.wiki.gg/wiki/Theramore_Isle",
            "https://warcraft.wiki.gg/wiki/Jaina%27s_Meeting_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/Ravages_of_the_Plague_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/The_Cult_of_the_Damned_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/March_of_the_Scourge_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/The_Culling_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/Where_Wyverns_Dare_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/The_Oracle_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/By_Demons_Be_Driven_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/Twilight_of_the_Gods_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Old_Hatreds_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/A_Blaze_of_Glory_(WC3_Orc)",
            "https://www.wowhead.com/classic/npc=4968",
        },
        confidence = "confirmed",
    },

    [4967] = {
        name = "Archmage Tervosh",
        zone = "Dustwallow Marsh",
        coords = "66.4, 49.2",
        appearances = {
            {
                game = "WC3",
                campaign = "The Invasion of Kalimdor (Orc)",
                missions = { "Cry of the Warsong" },
                role = "Random enemy archmage hero name (Warcraft III: Reforged only; names added in patch 1.33; the Cry of the Warsong notes say they were reverted in 1.36.1 and restored in 2.0); only two of Xylem, Tervosh and Horace Alder appear in a playthrough",
            },
        },
        story = "During the Third War, Tervosh was part of the human forces in the Stonetalon Mountains. "
             .. "His base was attacked by the Warsong clan led by Grommash Hellscream. "
             .. "In World of Warcraft he is a close friend and advisor to Jaina Proudmoore and gives quests in the Theramore Isle tower.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Archmage_Tervosh",
            "https://warcraft.wiki.gg/wiki/Cry_of_the_Warsong_(WC3_Orc)",
            "https://www.wowhead.com/classic/npc=4967",
        },
        confidence = "uncertain",
        searched = "warcraft.wiki.gg pages Archmage Tervosh and Cry of the Warsong (WC3 Orc); the name is a random hero name restored in patch 2.0 (Cry of the Warsong notes), so no source confirms an actual character",
    },

    [8140] = {
        name = "Brother Karman",
        zone = "Dustwallow Marsh",
        coords = "67.4, 47.4",
        appearances = {
            {
                game = "WC3",
                campaign = "The Invasion of Kalimdor (Orc)",
                missions = { "Cry of the Warsong" },
                role = "Random enemy paladin hero name, Lordaeron Corps (Warcraft III: Reforged only; names added in patch 1.33; the Cry of the Warsong notes say they were reverted in 1.36.1 and restored in 2.0)",
            },
        },
        story = "During the Third War, Brother Karman was part of the Lordaeron Corps in the Stonetalon Mountains. "
             .. "His base was attacked by Grommash Hellscream and the Warsong clan. "
             .. "In World of Warcraft he is a paladin trainer on Theramore Isle, outside Foothold Citadel.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Brother_Karman",
            "https://warcraft.wiki.gg/wiki/Cry_of_the_Warsong_(WC3_Orc)",
            "https://www.wowhead.com/classic/npc=8140",
        },
        confidence = "uncertain",
        searched = "warcraft.wiki.gg pages Brother Karman and Cry of the Warsong (WC3 Orc); the name is a random hero name restored in patch 2.0 (Cry of the Warsong notes), so no source confirms an actual character",
    },

    [4889] = {
        name = "Torq Ironblast",
        zone = "Dustwallow Marsh",
        coords = "67.4, 48.0",
        appearances = {
            {
                game = "WC3",
                campaign = "The Invasion of Kalimdor (Orc)",
                missions = { "Cry of the Warsong", "Where Wyverns Dare" },
                role = "Random enemy mountain king hero name (Warcraft III: Reforged only; names added in patch 1.33; the Cry of the Warsong notes say they were reverted in 1.36.1 and restored in 2.0)",
            },
        },
        story = "During the Third War, Torq Ironblast commanded the Gilneas Brigade in the Stonetalon Mountains. "
             .. "His base was attacked by Grommash Hellscream and the Warsong clan. "
             .. "He was then guarding the entrance to Stonetalon Peak. "
             .. "In World of Warcraft he is a gunsmith in Foothold Citadel on Theramore Isle.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Torq_Ironblast",
            "https://warcraft.wiki.gg/wiki/Cry_of_the_Warsong_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/Where_Wyverns_Dare_(WC3_Orc)",
            "https://www.wowhead.com/classic/npc=4889",
        },
        confidence = "uncertain",
        searched = "warcraft.wiki.gg pages Torq Ironblast, Cry of the Warsong and Where Wyverns Dare (WC3 Orc); the name is a random hero name restored in patch 2.0 (Cry of the Warsong notes), so no source confirms an actual character",
    },

    [4501] = {
        name = "Draz'Zilb",
        zone = "Dustwallow Marsh",
        coords = "37.0, 33.0",
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "Old Hatreds" },
                role = "Stonemaul ogre present in the ogre village in Dustwallow Marsh (Warcraft III: Reforged only)",
            },
        },
        story = "Draz'Zilb was among the ogres present when Rexxar arrived at Stonemaul Village. "
             .. "Rexxar challenged the chieftain Kor'gall, who refused to aid the Horde, and Kor'gall died in the duel. "
             .. "In World of Warcraft he is an intelligent ogre mage in Brackenwall Village. "
             .. "He orchestrated the ousting of the corrupt Mok'Morokk from the Stonemaul clan with the aid of Horde adventurers.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Draz%27Zilb",
            "https://warcraft.wiki.gg/wiki/Old_Hatreds_(WC3_Orc)",
            "https://www.wowhead.com/classic/npc=4501",
        },
        confidence = "confirmed",
    },

    [4502] = {
        name = "Tharg",
        zone = "Dustwallow Marsh",
        coords = "37.2, 31.4",
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "Old Hatreds" },
                role = "Stonemaul ogre present in the ogre village in Dustwallow Marsh (Warcraft III: Reforged only)",
            },
        },
        story = "Tharg was among the ogres present when Rexxar arrived at Stonemaul Village. "
             .. "Rexxar challenged the chieftain Kor'gall, who refused to aid the Horde, and Kor'gall died in the duel. "
             .. "In World of Warcraft Tharg is a survivor of the Onyxia brood's raid on Stonemaul Village, and his wife was among the ogres the black dragons slew. "
             .. "He refuses to consider Brackenwall Village their home and wants to reclaim Stonemaul Village.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Tharg",
            "https://warcraft.wiki.gg/wiki/Old_Hatreds_(WC3_Orc)",
            "https://www.wowhead.com/classic/npc=4502",
        },
        confidence = "confirmed",
    },

    [5087] = {
        name = "Do'gol",
        zone = "Dustwallow Marsh",
        coords = "36.4, 30.8",
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "Old Hatreds" },
                role = "Stonemaul ogre present in the ogre village in Dustwallow Marsh (Warcraft III: Reforged only)",
            },
        },
        story = "",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Do%27gol",
            "https://warcraft.wiki.gg/wiki/Old_Hatreds_(WC3_Orc)",
            "https://www.wowhead.com/classic/npc=5087",
        },
        confidence = "confirmed",
    },

    [4879] = {
        name = "Ogg'marr",
        zone = "Dustwallow Marsh",
        coords = "36.6, 31.0",
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "Old Hatreds" },
                role = "Stonemaul ogre present in the ogre village in Dustwallow Marsh (Warcraft III: Reforged only)",
            },
        },
        story = "",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Ogg%27marr",
            "https://warcraft.wiki.gg/wiki/Old_Hatreds_(WC3_Orc)",
            "https://www.wowhead.com/classic/npc=4879",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Feralas
[3936] = {
        name = "Shandris Feathermoon",
        zone = "Feralas",
        coords = "30.2, 46.0",
        appearances = {
            {
                game = "WC3",
                campaign = "Eternity's End (Night Elf)",
                missions = { "Enemies at the Gate", "Daughters of the Moon", "Twilight of the Gods" },
                role = "Night elf Sentinel unit (Ranger/Archer, not a hero) with Tyrande's forces; in Daughters of the Moon she waits at the outpost and warns that the undead attacked her village, and in Twilight of the Gods she is a playable unit at Mount Hyjal",
            },
        },
        story = "Shandris Feathermoon is a night elf sentinel who serves the high priestess Tyrande Whisperwind. "
             .. "In the Third War she appears in the Warcraft III night elf campaign: she is with Tyrande when the orcs and humans enter Ashenvale, and she waits for Tyrande at an outpost when the undead attack. "
             .. "She also takes part in the defence of Mount Hyjal. "
             .. "By the time of World of Warcraft she is General of the Sentinel Army and commands Feathermoon Stronghold on Sardor Isle in Feralas, named after her. "
             .. "From there she sends Alliance adventurers to investigate the Hatecrest naga in the Ruins of Solarsal.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Shandris_Feathermoon",
            "https://warcraft.wiki.gg/wiki/Shandris_(Warcraft_III)",
            "https://warcraft.wiki.gg/wiki/Enemies_at_the_Gate_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Daughters_of_the_Moon_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Twilight_of_the_Gods_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Eternity%27s_End_(WC3_campaign)",
            "https://warcraft.wiki.gg/wiki/The_Ruins_of_Solarsal",
            "https://www.wowhead.com/classic/npc=3936/shandris-feathermoon",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Tirisfal Glades and Western Plaguelands
[232920] = {
        name = "Uther",
        zone = "Western Plaguelands",
        coords = "47.0, 69.4",
        appearances = {
            {
                game = "WC2",
                campaign = "Tides of Darkness (Human)",
                missions = { "The Battle at Darrowmere" },
                role = "Escort objective: the player must escort the Lightbringer to the Circle of Power at Caer Darrow; listed as commander on the mission page",
            },
            {
                game = "WC3",
                campaign = "The Scourge of Lordaeron (Human)",
                missions = { "Blackrock and Roll" },
                role = "Ally hero (Paladin), Chapter II",
            },
            {
                game = "WC3",
                campaign = "The Scourge of Lordaeron (Human)",
                missions = { "The Defense of Strahnbrad", "March of the Scourge", "The Culling" },
                role = "Appears in dialogue and cutscenes only; in The Culling he refuses Arthas's order to purge Stratholme",
            },
            {
                game = "WC3",
                campaign = "Path of the Damned (Undead)",
                missions = { "Digging up the Dead" },
                role = "Enemy hero (Paladin) guarding King Terenas's urn at the Silver Hand camp outside Andorhal; killed by Arthas",
            },
        },
        story = "Uther led the Knights of the Silver Hand and tutored Prince Arthas. "
             .. "When Arthas ordered the purge of Stratholme, Uther refused and informed King Terenas. "
             .. "He was later killed by Arthas at Andorhal while guarding the urn with King Terenas's ashes, and his body was buried in a tomb south of Andorhal.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Uther_the_Lightbringer",
            "https://warcraft.wiki.gg/wiki/The_Battle_at_Darrowmere_(WC2_Human)",
            "https://warcraft.wiki.gg/wiki/Scourge_of_Lordaeron",
            "https://warcraft.wiki.gg/wiki/The_Defense_of_Strahnbrad_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/Blackrock_and_Roll_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/March_of_the_Scourge_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/The_Culling_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/Digging_up_the_Dead_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=232920/uther",
        },
        confidence = "confirmed",
    },

    [231500] = {
        name = "Gregory",
        zone = "Western Plaguelands",
        coords = "69.4, 79.6",
        appearances = {
            {
                game = "WC3",
                campaign = "Path of the Damned (Undead)",
                missions = { "Digging up the Dead" },
                role = "Enemy hero (Paladin, as Sage Truthbearer; Gregory Edmunson in the game files): guards King Terenas's urn near Andorhal with Uther and is killed by Arthas",
            },
        },
        story = "In life Gregory was a paladin of the Silver Hand called Sage Truthbearer and led the Champions of Truth under Uther. "
             .. "He died protecting King Terenas's urn in Andorhal alongside Uther and Ballador the Bright. "
             .. "He was raised as a death knight of the Scourge. "
             .. "In Season of Discovery he allies with his old friend Aeonas and the paladin adventurer to destroy Echoing Orbs.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Gregory",
            "https://warcraft.wiki.gg/wiki/Sage_Truthbearer_(Warcraft_III)",
            "https://warcraft.wiki.gg/wiki/Digging_up_the_Dead_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=231500/gregory",
        },
        confidence = "confirmed",
    },

    [232932] = {
        name = "Gregory",
        zone = "Western Plaguelands",
        coords = "39.4, 67.2",
        appearances = {
            {
                game = "WC3",
                campaign = "Path of the Damned (Undead)",
                missions = { "Digging up the Dead" },
                role = "Enemy hero (Paladin, as Sage Truthbearer; Gregory Edmunson in the game files): guards King Terenas's urn near Andorhal with Uther and is killed by Arthas",
            },
        },
        story = "In life Gregory was a paladin of the Silver Hand called Sage Truthbearer and led the Champions of Truth under Uther. "
             .. "He died protecting King Terenas's urn in Andorhal alongside Uther and Ballador the Bright. "
             .. "He was raised as a death knight of the Scourge. "
             .. "In Season of Discovery he allies with his old friend Aeonas and the paladin adventurer to destroy Echoing Orbs.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Gregory",
            "https://warcraft.wiki.gg/wiki/Sage_Truthbearer_(Warcraft_III)",
            "https://warcraft.wiki.gg/wiki/Digging_up_the_Dead_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=232932/gregory",
        },
        confidence = "confirmed",
    },

    [1852] = {
        name = "Araj the Summoner",
        zone = "Western Plaguelands",
        coords = "45.4, 69.2",
        appearances = {
            {
                game = "WC3",
                campaign = "The Scourge of Lordaeron (Human)",
                missions = { "March of the Scourge" },
                role = "Reforged only: enemy Lich hero commanding the Undead Ravagers in the attack on Hearthglen (replaces a randomized Lich name)",
            },
        },
        story = "Araj served the Lich King during the Third War and became the regional Scourge commander in the Western Plaguelands, where he commanded the Undead Ravagers against Hearthglen. "
             .. "He was the former leader of Scholomance before aiding the Scourge invasion of Caer Darrow and later claiming Andorhal as his own. "
             .. "From Andorhal he spread the plague through the Plague Cauldrons and held off the Forsaken at the Bulwark and the Alliance at Chillwind Camp. "
             .. "In World of Warcraft adventurers defeat him on the orders of Commander Ashlam Valorfist and High Executor Derrington.",
        items = {
            { id = 14610, name = "Araj's Scarab", note = "Quest item contained in Araj's Phylactery, guarded by Araj; his scarab was used to create the Scholomance key" },
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Araj_the_Summoner",
            "https://warcraft.wiki.gg/wiki/March_of_the_Scourge_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/Araj%27s_Scarab",
            "https://www.wowhead.com/classic/npc=1852/araj-the-summoner",
            "https://www.wowhead.com/classic/item=14610",
        },
        confidence = "uncertain",
        searched = "warcraft.wiki.gg (Araj the Summoner, March of the Scourge (WC3 Human), Random hero, Warcraft III patch 1.36.1). "
                .. "His Warcraft III appearance rests on a former random Lich hero name that Reforged fixed in this mission; "
                .. "patch 1.36.1 rolled back changes from 1.33, and no page confirms that this change survived.",
    },

    [10666] = {
        name = "Gordo",
        zone = "Tirisfal Glades",
        coords = "39.8, 51.2",
        appearances = {
            {
                game = "FK",
                campaign = "Forsaken Kingdom (Undead)",
                missions = { "City of the Dead" },
                role = "Optional quest NPC (abomination): the player finds and frees him from a spider den and returns him to Melisara",
            },
        },
        story = "Some time after the Forsaken established the Undercity, Gordo served at a camp northwest of the Capital City Ruins. "
             .. "He wandered into the forest to collect goods and did not return, so Melisara sent Garek Bandarion and Dark Ranger Anya to find him. "
             .. "They freed him from a spider web, and he returned to camp. "
             .. "In World of Warcraft he wanders the road between Deathknell and Brill looking for gloom weed for Junior Apothecary Holland.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Gordo",
            "https://warcraft.wiki.gg/wiki/City_of_the_Dead_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=10666/gordo",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Book and novel links
    [4500] = {
        name = "Overlord Mok'Morokk",
        zone = "Dustwallow Marsh",
        coords = "36.2, 31.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Exploring Azeroth: Kalimdor",
                missions = {},
                role = "Mentioned in the book (not a game appearance): Rexxar names him the new leader of the Stonemaul clan, a choice Rexxar later regrets",
            },
        },
        story = "After the invasion of Durotar, Rexxar named the ogre Mok'Morokk the new leader of the Stonemaul clan, according to the book Exploring Azeroth: Kalimdor. "
             .. "Rexxar chose him because he had shown strength while Rexxar himself led the clan, and he later came to regret the choice. "
             .. "Soon after Rexxar left, Mok'Morokk fell prey to the temptations of power and demanded service from his people instead of leading them. "
             .. "When the black dragonflight attacked the clan's old home in Stonemaul Village, he led the clan to Brackenwall Village. "
             .. "In World of Warcraft he stays in Brackenwall Village in Dustwallow Marsh and gives the Horde quest Overlord Mok'Morokk's Concern.",
        items = {
            { id = 5834, name = "Mok'Morokk's Snuff", note = "His snuff, which he sends you to collect in Overlord Mok'Morokk's Concern" },
            { id = 5835, name = "Mok'Morokk's Grog", note = "His grog, which he sends you to collect in Overlord Mok'Morokk's Concern" },
            { id = 5836, name = "Mok'Morokk's Strongbox", note = "His strongbox, which he sends you to collect in Overlord Mok'Morokk's Concern" },
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Overlord_Mok%27Morokk",
            "https://warcraft.wiki.gg/wiki/Rexxar",
            "https://warcraft.wiki.gg/wiki/Exploring_Azeroth:_Kalimdor",
            "https://warcraft.wiki.gg/wiki/The_Brood_of_Onyxia_(2)",
            "https://warcraft.wiki.gg/wiki/Spirits_of_Stonemaul_Hold",
            "https://warcraft.wiki.gg/wiki/Overlord_Mok%27Morokk%27s_Concern",
            "https://www.wowhead.com/classic/quest=1166",
            "https://www.wowhead.com/classic/npc=4500",
        },
        confidence = "confirmed",
    },

    -- Dustwallow Marsh (Theramore Isle)
    [4965] = {
        name = "Pained",
        zone = "Dustwallow Marsh",
        coords = "66.2, 49.0",
        appearances = {
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Supporting character in the novel (not a game appearance): Jaina's night elf bodyguard, who dies when Theramore is destroyed",
            },
        },
        story = "In the novel Jaina Proudmoore: Tides of War, Pained is the night elf bodyguard whom Tyrande assigned to Jaina at the Battle of Mount Hyjal. "
             .. "She stayed with Jaina afterwards because she had never officially been relieved of her duty. "
             .. "In World of Warcraft she is Jaina Proudmoore's night elf bodyguard on Theramore Isle. "
             .. "The novel itself is set long after Classic and ends with her death when Theramore is destroyed.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Pained",
            "https://warcraft.wiki.gg/wiki/Jaina_Proudmoore:_Tides_of_War",
            "https://www.wowhead.com/classic/npc=4965",
        },
        confidence = "confirmed",
    },

    -- Hillsbrad Foothills (Southshore)
    [2263] = {
        name = "Marshal Redpath",
        zone = "Hillsbrad Foothills",
        coords = "49.6, 58.6",
        appearances = {
            {
                game = "BOOK",
                campaign = "Tides of Darkness",
                missions = { "First prologue" },
                role = "Minor character in the novel (not a game appearance): the headman of Southshore who greets Anduin Lothar and the Stormwind refugees in the first prologue",
            },
        },
        story = "In the novel Tides of Darkness (Aaron Rosenberg's retelling of the Second War), Marcus Redpath is the headman of Southshore. "
             .. "He greets Anduin Lothar, Khadgar and the refugees from the Kingdom of Stormwind. "
             .. "He sends his fastest rider, Willem, to King Terenas Menethil II to announce their arrival. "
             .. "After the Third War he is Southshore's marshal, eager to rid the region of murlocs, Crushridge ogres and naga. "
             .. "In World of Warcraft he stands in Southshore as Marshal Redpath.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Marcus_Redpath",
            "https://warcraft.wiki.gg/wiki/Tides_of_Darkness",
            "https://www.wowhead.com/classic/npc=2263",
        },
        confidence = "confirmed",
    },

    -- Alterac Mountains (Dandred's Fold)
    [2423] = {
        name = "Lord Aliden Perenolde",
        zone = "Alterac Mountains",
        coords = "39.4, 15.2",
        appearances = {
            {
                game = "BOOK",
                campaign = "Beyond the Dark Portal",
                missions = { "Chapter 7", "Chapter 10" },
                role = "Supporting character in the novel (not a game appearance; chapters 7 and 10): crown prince of Alterac and eldest son of King Aiden Perenolde, the Alterac ruler who betrays the Alliance in Warcraft II",
            },
        },
        story = "In the novel Beyond the Dark Portal, Aliden is the eldest son of King Aiden Perenolde and crown prince of Alterac. "
             .. "King Terenas of Lordaeron thought him pampered and inexperienced, but admitted that the Alliance had no right to deny him the throne if his father abdicated, since he was the legal heir. "
             .. "He spent two years trying to overcome the stigma of his father's betrayal in the Second War. "
             .. "When he saw that his father had traded the Book of Medivh to the Horde, he punched him and said he had ruined everything. "
             .. "In World of Warcraft he leads the Syndicate from Dandred's Fold, and Horde adventurers kill him on Krusk's orders.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Aliden_Perenolde",
            "https://warcraft.wiki.gg/wiki/Beyond_the_Dark_Portal",
            "https://warcraft.wiki.gg/wiki/Aiden_Perenolde",
            "https://warcraft.wiki.gg/wiki/Lord_Aliden_Perenolde_(quest)",
            "https://www.wowhead.com/classic/npc=2423",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Undercity
    [10181] = {
        name = "Lady Sylvanas Windrunner",
        zone = "Undercity",
        coords = "57.8, 91.4",
        appearances = {
            {
                game = "WC3",
                campaign = "Path of the Damned (Undead)",
                missions = { "The Fall of Silvermoon" },
                role = "Enemy hero (Ranger) defending Quel'Thalas; turned into a banshee",
            },
            {
                game = "TFT",
                campaign = "Legacy of the Damned (Undead)",
                missions = { "King Arthas", "The Dark Lady", "Dreadlord's Fall", "A New Power in Lordaeron" },
                role = "Playable hero (Dark Ranger)",
            },
            {
                game = "FK",
                campaign = "Forsaken Kingdom (Undead)",
                missions = { "City of the Dead" },
                role = "Leader of the Forsaken; gives the player orders",
            },
        },
        story = "When the Lich King's power waned, Sylvanas regained her free will and turned against Arthas. "
             .. "She took Lordaeron from the three dreadlords and gathered the freed undead as the Forsaken. "
             .. "Beneath the ruins of the capital, the Forsaken built the Undercity. "
             .. "With tauren leaders as mediators, the Forsaken joined the Horde. "
             .. "In World of Warcraft she holds court as the Banshee Queen in the Royal Quarter.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Sylvanas_Windrunner",
            "https://warcraft.wiki.gg/wiki/Path_of_the_Damned",
            "https://warcraft.wiki.gg/wiki/Legacy_of_the_Damned",
            "https://warcraft.wiki.gg/wiki/City_of_the_Dead_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=10181",
        },
        confidence = "confirmed",
    },

    [2425] = {
        name = "Varimathras",
        zone = "Undercity",
        coords = "56.4, 92.4",
        appearances = {
            {
                game = "TFT",
                campaign = "Legacy of the Damned (Undead)",
                missions = { "Dreadlord's Fall", "A New Power in Lordaeron" },
                role = "Playable hero (Dreadlord)",
            },
            {
                game = "FK",
                campaign = "Forsaken Kingdom (Undead)",
                missions = { "City of the Dead" },
                role = "Quest NPC: the player reports to him",
            },
        },
        story = "Varimathras was one of three dreadlords who ruled Lordaeron after Arthas left for Northrend. "
             .. "He secretly made a deal with Sylvanas to overthrow Arthas, and put his own life above the nathrezim code by attacking his brother Balnazzar. "
             .. "On Sylvanas' order he killed Lord Garithos, securing his place among the Forsaken. "
             .. "After the Undercity was founded, he formed the city guard that became the basis of the Deathguard. "
             .. "In World of Warcraft he stands at Sylvanas' side in the Royal Quarter.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Varimathras",
            "https://warcraft.wiki.gg/wiki/Legacy_of_the_Damned",
            "https://warcraft.wiki.gg/wiki/City_of_the_Dead_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=2425",
        },
        confidence = "confirmed",
    },

    [2227] = {
        name = "Sharlindra",
        zone = "Undercity",
        coords = "57.4, 93.4",
        appearances = {
            {
                game = "TFT",
                campaign = "Legacy of the Damned (Undead)",
                missions = { "The Dark Lady", "Dreadlord's Fall" },
                role = "Playable banshee unit in Sylvanas' forces (Warcraft III: Reforged only)",
            },
        },
        story = "Sharlindra is one of the banshees in Sylvanas' forces when Sylvanas breaks free of Arthas and turns on the dreadlords. "
             .. "After the Forsaken took Lordaeron, she stayed at Sylvanas' side. "
             .. "In World of Warcraft she stands in the Royal Quarter of the Undercity, where her lieutenant Melisara sends adventurers after the Crown of Will.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Sharlindra",
            "https://warcraft.wiki.gg/wiki/The_Dark_Lady_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/Dreadlord's_Fall_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=2227",
        },
        confidence = "confirmed",
    },

    [5734] = {
        name = "Apothecary Keever",
        zone = "Undercity",
        coords = "52.6, 73.4",
        appearances = {
            {
                game = "FK",
                campaign = "Forsaken Kingdom (Undead)",
                missions = { "City of the Dead" },
                role = "Quest NPC: needs parts to assemble a new abomination (optional quest \"From Many, One\")",
            },
        },
        story = "While the Forsaken kingdom was being founded, Grand Apothecary Putress had Garek Bandarion and Dark Ranger Anya bring corpses to Keever. "
             .. "They delivered the body of Othmar Garithos, which Keever turned into an abomination. "
             .. "In World of Warcraft he works in the Apothecarium of the Undercity, experimenting on caged prisoners under Master Apothecary Faranell.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Apothecary_Keever",
            "https://warcraft.wiki.gg/wiki/City_of_the_Dead_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=5734",
        },
        confidence = "confirmed",
    },

    [2492] = {
        name = "Lexington Mortaim",
        zone = "Undercity",
        coords = "84.2, 16.0",
        appearances = {
            {
                game = "FK",
                campaign = "Forsaken Kingdom (Undead)",
                missions = { "City of the Dead" },
                role = "Quest NPC: the optional quest \"Relic Raiders\" ends with returning an artifact to him",
            },
        },
        story = "",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/City_of_the_Dead_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/Lexington_Mortaim",
            "https://www.wowhead.com/classic/npc=2492",
        },
        confidence = "uncertain",
        searched = "warcraft.wiki.gg (Lexington Mortaim, City of the Dead). The mission's quest text names him and the name is unique, "
                .. "but his own wiki page does not mention the mission.",
    },
}

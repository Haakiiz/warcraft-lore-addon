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
            {
                game = "BOOK",
                campaign = "Lord of the Clans",
                missions = {},
                role = "Protagonist: Go'el's life in the internment camps, his escape from Durnholde Keep, and his rise to Warchief (novel, not a game appearance)",
            },
            {
                game = "BOOK",
                campaign = "Cycle of Hatred",
                missions = {},
                role = "Tries to keep the peace with Theramore while his chief warrior Burx attacks Northwatch Hold (novel, not a game appearance)",
            },
            {
                game = "BOOK",
                campaign = "Of Blood and Honor",
                missions = {},
                role = "Leads an attack on Stratholme that saves Eitrigg from execution and lets him join the New Horde (chapter 7; novel, not a game appearance)",
            },
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Appoints Garrosh Hellscream acting warchief and travels to Nagrand to speak with the Furies (novel, not a game appearance)",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Leader of the Earthen Ring; meets Jaina in secret and refuses to return to the Horde to rein in Garrosh (novel, not a game appearance)",
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
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Leads the Darkspear at Northwatch Hold and in Garrosh's attack on Theramore, and questions the plan to drive out the night elves (novel, not a game appearance)",
            },
            {
                game = "BOOK",
                campaign = "Vol'jin: Shadows of the Horde",
                missions = {},
                role = "Poisoned by Garrosh's assassins, recovers at the Shado-Pan Monastery with Chen Stormstout's help, and receives Shado-Pan monk training (novel, not a game appearance)",
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

    -- ===================================================================== Darnassus
    [7999] = {
        name = "Tyrande Whisperwind",
        zone = "Darnassus",
        coords = "38.4, 80.6",
        appearances = {
            {
                game = "WC3",
                campaign = "Eternity's End (Night Elf)",
                missions = { "Enemies at the Gate", "Daughters of the Moon", "The Awakening of Stormrage",
                             "The Druids Arise", "Brothers in Blood", "Twilight of the Gods" },
                role = "Playable hero (Priestess of the Moon)",
            },
            {
                game = "WC3",
                campaign = "Eternity's End (Night Elf)",
                missions = { "A Destiny of Flame and Sorrow", "The Last Guardian" },
                role = "Cutscenes only: the closing scene with Furion, and a speaking part in the interlude",
            },
            {
                game = "TFT",
                campaign = "Terror of the Tides (Night Elf)",
                missions = { "Balancing the Scales", "Shards of the Alliance" },
                role = "Playable hero (Priestess of the Moon)",
            },
            {
                game = "TFT",
                campaign = "Terror of the Tides (Night Elf)",
                missions = { "Unfinished Business", "A Parting of Ways" },
                role = "Speaking character in the cutscenes",
            },
            {
                game = "TFT",
                campaign = "Terror of the Tides (Night Elf)",
                missions = { "The Ruins of Dalaran" },
                role = "Mentioned only: Maiev says she saw her \"torn apart\"",
            },
            {
                game = "TFT",
                campaign = "Terror of the Tides (Night Elf)",
                missions = { "The Brothers Stormrage" },
                role = "Rescue target: the swept-away priestess whom Illidan and Malfurion save",
            },
            {
                game = "BOOK",
                campaign = "The Well of Eternity",
                missions = {},
                role = "Major character in the novel (not a game appearance), set about 10,000 years before the First War (War of the Ancients): listed as Sister Tyrande Whisperwind",
            },
            {
                game = "BOOK",
                campaign = "The Demon Soul",
                missions = {},
                role = "Major character in the novel (not a game appearance), set about 10,000 years before the First War (War of the Ancients): listed as High Priestess Tyrande Whisperwind",
            },
            {
                game = "BOOK",
                campaign = "The Sundering",
                missions = {},
                role = "Major character in the novel (not a game appearance), set about 10,000 years before the First War (War of the Ancients): High Priestess Tyrande Whisperwind in the events leading to the Great Sundering",
            },
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Major character in the novel (not a game appearance; it is set long after Classic): she learns through nightmares that Malfurion is dying, asks Broll Bearmantle to search the Emerald Dream and goes with him",
            },
        },
        story = "After the Battle of Mount Hyjal, Tyrande and Malfurion stayed on Hyjal to rebuild and later took their people back to Ashenvale to heal the damage done by the Burning Legion. "
             .. "Malfurion and Tyrande helped their people rebuild their shattered villages and ruled them for a time. "
             .. "Afterwards Malfurion's spirit was lost in the Emerald Dream, and Fandral Staghelm became Arch-Druid and planted Teldrassil. "
             .. "With Malfurion gone, Tyrande became the sole leader of the night elves, priestesses and Sentinels, and she often quarrelled with Fandral. "
             .. "In World of Warcraft she is High Priestess of Elune in Darnassus.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Tyrande_Whisperwind",
            "https://warcraft.wiki.gg/wiki/Eternity%27s_End_(WC3_campaign)",
            "https://warcraft.wiki.gg/wiki/Terror_of_the_Tides",
            "https://warcraft.wiki.gg/wiki/Enemies_at_the_Gate_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Daughters_of_the_Moon_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/The_Awakening_of_Stormrage_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/The_Druids_Arise_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Brothers_in_Blood_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/A_Destiny_of_Flame_and_Sorrow_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/The_Last_Guardian_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Twilight_of_the_Gods_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Unfinished_Business_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Balancing_the_Scales_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Shards_of_the_Alliance_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/The_Ruins_of_Dalaran_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/The_Brothers_Stormrage_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/A_Parting_of_Ways_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/War_of_the_Ancients",
            "https://warcraft.wiki.gg/wiki/The_Well_of_Eternity",
            "https://warcraft.wiki.gg/wiki/The_Demon_Soul",
            "https://warcraft.wiki.gg/wiki/The_Sundering",
            "https://warcraft.wiki.gg/wiki/Stormrage",
            "https://www.wowhead.com/classic/npc=7999/tyrande-whisperwind",
        },
        confidence = "confirmed",
    },

    [3516] = {
        name = "Arch Druid Fandral Staghelm",
        zone = "Darnassus",
        coords = "34.4, 8.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Supporting character in the novel (not a game appearance; it is set long after Classic): calls a convocation of druids on Teldrassil and insists on healing the tree, and the Nightmare Lord has tricked him with a vision of his dead son Valstann",
            },
        },
        story = "After the Third War the night elves lost Nordrassil and their immortality, and Malfurion fell into a deep coma. "
             .. "His absence left the leadership of the druids to Fandral Staghelm, who became the new archdruid. "
             .. "Fandral convinced the other druids to create a new World Tree, and together they planted Teldrassil off the coast of northern Kalimdor. "
             .. "The tree was not blessed by the Dragon Aspects and the night elves did not regain their immortality, while corruption began to spread through Teldrassil. "
             .. "In World of Warcraft he leads the Cenarion Circle from the Cenarion Enclave in Darnassus.",
        items = {
            { id = 5390, name = "Fandral's Message", note = "Quest item in \"Grove of the Ancients\", which he starts" },
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Fandral_Staghelm",
            "https://www.wowhead.com/classic/item=5390",
            "https://warcraft.wiki.gg/wiki/Stormrage",
            "https://www.wowhead.com/classic/npc=3516/arch-druid-fandral-staghelm",
        },
        confidence = "confirmed",
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
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Supporting character: among the first tauren to fall under the Nightmare's sway and into slumber",
            },
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Main character: killed by Garrosh Hellscream in a mak'gora to the death in the Orgrimmar arena, after Magatha Grimtotem poisoned Garrosh's axe Gorehowl",
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
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Main character: leads the tauren in Cairne's place during his father's absences, and after Cairne's death leads the assault that retakes Thunder Bluff from the Grimtotem tribe",
            },
            {
                game = "BOOK",
                campaign = "As Our Fathers Before Us",
                missions = {},
                role = "Main character: as high chieftain he agrees to send Mulgore's water to Orgrimmar, and with Hamuul he investigates the quilboar raids on the caravans",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Supporting character: co-leads the tauren and Darkspear army at Northwatch, confronts Garrosh over the molten giants and the Theramore attack, and has Perith Stormhoof warn Jaina Proudmoore of the attack",
            },
            {
                game = "BOOK",
                campaign = "War Crimes",
                missions = {},
                role = "Supporting character: chosen by Vol'jin as Garrosh Hellscream's defender at his trial in the Temple of the White Tiger, opposite Tyrande Whisperwind",
            },
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Supporting character: Sylvanas Windrunner tasks him with organizing the Horde's healing efforts and orders him to cut off contact with King Anduin Wrynn",
            },
            {
                game = "BOOK",
                campaign = "A Good War",
                missions = {},
                role = "Supporting character: questions Varok Saurfang about the Horde's march through the Northern Barrens; Saurfang realizes Baine knows something of the real plan to invade Ashenvale",
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
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Supporting character: Thrall hires him to rebuild Orgrimmar after rogue fire elementals devastated the city",
            },
            {
                game = "BOOK",
                campaign = "The Goblin Way",
                missions = {},
                role = "Supporting character: on his \"factfinding\" tours he strong-arms Marin Noggenfogger into letting him inspect his mine, and the two agree to align their cartels",
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
            {
                game = "BOOK",
                campaign = "Cycle of Hatred",
                missions = {},
                role = "Beastmaster who finds the wounded orc Byrok with his bear Misha and brings him to Thrall in Orgrimmar, where Byrok tells Thrall about the Burning Blade clan (novel, not a game appearance)",
            },
            {
                game = "BOOK",
                campaign = "Beyond the Dark Portal",
                missions = {},
                role = "Horde beastmaster; the novel describes him as a half-ogre (chapter 14; novel, not the Beyond the Dark Portal game)",
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
            {
                game = "BOOK",
                campaign = "Cycle of Hatred",
                missions = {},
                role = "Rexxar's bear, who helps him find the wounded orc Byrok and carry him to Orgrimmar (novel, not a game appearance)",
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
            {
                game = "BOOK",
                campaign = "Arthas: Rise of the Lich King",
                missions = {},
                role = "Ranger-General of Silvermoon (not a game appearance; pg. 217-224): fights Arthas' Scourge at the elfgates of Quel'Thalas and falls back with her surviving rangers to the second gate",
            },
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Not a game appearance (Emerald Nightmare dream): tormented by the Lich King and betrayed by Varimathras in her dream",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Not a game appearance: attends Garrosh Hellscream's Horde leader meeting, opposes his plan to attack Theramore, and gets no support from Lor'themar Theron",
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
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Minor character in the novel (not a game appearance; chapter 18): in the Battle for the Undercity he fights with his summoned Legion minions and is defeated by Sylvanas herself",
            },
            {
                game = "BOOK",
                campaign = "World of Warcraft: Sylvanas",
                missions = {},
                role = "Minor character in the novel (not a game appearance; chapter 15): named by Sylvanas as the one who must supply Putress with whatever he needs for the New Plague",
            },
            {
                game = "BOOK",
                campaign = "Arthas: Rise of the Lich King",
                missions = {},
                role = "Minor character in the novel (not a game appearance; epilogue): Sylvanas tells him that something has happened with the Lich King and that their plans must be stepped up",
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
            {
                game = "BOOK",
                campaign = "World of Warcraft: Sylvanas",
                missions = {},
                role = "Minor character in the novel (not a game appearance; chapter 14): witnesses Sylvanas refuse Varimathras' invitation to join his new order and wonders whether it would have been prudent to accept",
            },
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Minor character in the novel (not a game appearance; chapter 18): the first of Sylvanas' trusted counsel to fall in Sylvanas' Emerald Nightmare dream",
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
            {
                game = "BOOK",
                campaign = "Arthas: Rise of the Lich King",
                missions = {},
                role = "Minor character in the novel (not a game appearance; pg. 200): assisted Faranell in showing the effects of the Forsaken Blight to Sylvanas shortly before the War against the Lich King",
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

    -- Level 1-30 zones and dungeons (2026-10-08, Haiku workers + Haiku critics, checked by the orchestrator)
    -- ===================================================================== Stormwind City
    [1747] = {
        name = "Anduin Wrynn",
        zone = "Stormwind City",
        coords = "77.4, 18.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Thirteen-year-old prince during the Shattering; while he stays in Ironforge, King Magni Bronzebeard asks him to call him \"uncle\" (chapter 11)",
            },
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Attends the memorial service for King Varian Wrynn, where he is unable to speak formally (chapter 1)",
            },
            {
                game = "BOOK",
                campaign = "Blood Ties",
                missions = {},
                role = "Returns to Stormwind after the fighting in Khaz Algar but does not reclaim his throne, leaving Turalyon in charge for now (chapter 2)",
            },
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Suffers nightmares from the Emerald Nightmare in the weeks after the Lich King is killed (chapter 10)",
            },
        },
        story = "Anduin Llane Wrynn is the son of King Varian Wrynn and Queen Tiffin Ellerian Wrynn, named after Anduin Lothar and his grandfather King Llane Wrynn. "
             .. "He was thirteen during the Shattering, when he stayed in Ironforge. "
             .. "In Stormrage he suffered nightmares from the Emerald Nightmare, and in Blood Ties he returned to Stormwind without reclaiming his throne. "
             .. "In World of Warcraft Classic he is the young king of Stormwind, with Highlord Bolvar Fordragon acting as regent.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Anduin_Wrynn",
            "https://www.wowhead.com/classic/npc=1747/anduin-wrynn",
        },
        confidence = "confirmed",
    },

    [332] = {
        name = "Master Mathias Shaw",
        zone = "Stormwind City",
        coords = "75.8, 59.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Leader of SI:7; briefs King Anduin Wrynn's advisers on the Azerite information SI:7 gathered, and remains neutral when Anduin proposes the Gathering",
            },
        },
        story = "Mathias Shaw is the leader of Stormwind's intelligence service, SI:7, and a master of spies. "
             .. "In Before the Storm he reports SI:7's findings about Azerite to King Anduin Wrynn's advisers. "
             .. "He remained neutral when Anduin proposed the Gathering. "
             .. "In World of Warcraft he heads SI:7 from its barracks in Old Town.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Mathias_Shaw",
            "https://www.wowhead.com/classic/npc=332/master-mathias-shaw",
        },
        confidence = "confirmed",
    },

    [3520] = {
        name = "Ol' Emma",
        zone = "Stormwind City",
        coords = "52.4, 41.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Emma Felstone, searching among the Forsaken at the Gathering in the Arathi Highlands for her sons; when Sylvanas's dark rangers fire on the Forsaken, Anduin Wrynn sends her to safety on his gryphon",
            },
        },
        story = "Emma Felstone, known as Ol' Emma, came from the Felstone Field farm in the Eastweald of Lordaeron. "
             .. "She was married to Jem, who died in the First War, and had three sons: Jem, Jack and Jake. "
             .. "In Before the Storm she attends the Gathering in the Arathi Highlands, and afterwards returns there to bury her sons. "
             .. "In World of Warcraft she lives in the Canal District and carries water in Stormwind City.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Ol%27_Emma",
            "https://www.wowhead.com/classic/npc=3520/ol-emma",
        },
        confidence = "confirmed",
    },

    [14394] = {
        name = "Major Mattingly",
        zone = "Stormwind City",
        coords = "61.4, 78.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Stormwind Army veteran in the Valley of Heroes, serving under General Hammond Clay; during the Emerald Nightmare attack on Stormwind, King Varian Wrynn orders him to escort Tyrande Whisperwind and others (chapter 21)",
            },
        },
        story = "Major Mattingly is a veteran of the Stormwind Army in the Valley of Heroes, serving under General Hammond Clay. "
             .. "When the Emerald Nightmare assaulted Stormwind, he went to Stormwind Keep to assemble reinforcements, but the valley was already enshrouded by the Nightmare. "
             .. "King Varian Wrynn then ordered him to escort Tyrande Whisperwind and others.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Major_Mattingly",
            "https://www.wowhead.com/classic/npc=14394/major-mattingly",
        },
        confidence = "confirmed",
    },

    [466] = {
        name = "General Marcus Jonathan",
        zone = "Stormwind City",
        coords = "63.4, 75.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "High Commander of Stormwind Defense; during the War Against the Nightmare he sends Major Mattingly to King Varian Wrynn for reinforcements as the mists seize the Valley of Heroes",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "First to accept King Wrynn's call to support Theramore Isle; he is the main organizer of its defense and is killed when the Horde detonates a mana bomb (Year 30 ADP)",
            },
        },
        story = "General Marcus Jonathan was the high commander of Stormwind Defense. "
             .. "During the War Against the Nightmare in Stormrage he sent Major Mattingly for reinforcements. "
             .. "In Jaina Proudmoore: Tides of War he organized the defense of Theramore Isle and was killed when the Horde detonated a mana bomb to destroy the city.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/General_Marcus_Jonathan",
            "https://www.wowhead.com/classic/npc=466/general-marcus-jonathan",
        },
        confidence = "confirmed",
    },

    [928] = {
        name = "Lord Grayson Shadowbreaker",
        zone = "Stormwind City",
        coords = "37.2, 33.0",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Silver Hand paladin at the ceremony for the fallen Alliance members of Northrend; at the request of King Varian Wrynn he fetches food and drink for the night elf women who had arrived with news",
            },
            {
                game = "BOOK",
                campaign = "Blood Ties",
                missions = {},
                role = "Gains a new squire, Winthrop, in Year 42 ADP; at Light's Hope Chapel, Winthrop and Arator the Redeemer clean his armor while he speaks with other paladins",
            },
        },
        story = "Lord Grayson Shadowbreaker is one of Stormwind's foremost paladins and one of the lords of the Order of the Silver Hand, where he trains young paladins. "
             .. "After the war against the Lich King he took part in the ceremony for the fallen Alliance members in The Shattering. "
             .. "In Blood Ties he took on a new squire, Winthrop. "
             .. "He once lost his right eye in battle.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Lord_Grayson_Shadowbreaker",
            "https://www.wowhead.com/classic/npc=928/lord-grayson-shadowbreaker",
        },
        confidence = "confirmed",
    },

    [1284] = {
        name = "Archbishop Benedictus",
        zone = "Stormwind City",
        coords = "39.4, 27.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Leader of the Church of the Holy Light in Stormwind and secretly a member of the Twilight's Hammer; after Deathwing's attack, many citizens seek his counsel",
            },
        },
        story = "Archbishop Benedictus was the leader of the Church of the Holy Light and succeeded Archbishop Alonsus Faol before the Third War. "
             .. "The fall of Lordaeron and the appearance of the Scourge pushed his faith to the breaking point. "
             .. "In The Shattering, many of Stormwind's fearful citizens sought his counsel after Deathwing burned parts of the city, unaware that he was secretly a member of the Twilight's Hammer.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Archbishop_Benedictus",
            "https://www.wowhead.com/classic/npc=1284/archbishop-benedictus",
        },
        confidence = "confirmed",
    },

    [2285] = {
        name = "Count Remington Ridgewell",
        zone = "Stormwind City",
        coords = "74.0, 30.0",
        appearances = {
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Member of the House of Nobles; greets Fredrik Farley when King Anduin Wrynn summons him to Stormwind Keep after the Argus Campaign, and serves them drinks during the meeting",
            },
        },
        story = "Count Remington Ridgewell is a member of the House of Nobles, located in the Petitioner's Chamber in Stormwind Keep. "
             .. "His family's house runs a museum that exhibits valuable objects and artworks. "
             .. "In Before the Storm he greets Fredrik Farley when King Anduin Wrynn summons him to Stormwind Keep after the Argus Campaign, and he serves them drinks during the meeting.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Count_Remington_Ridgewell",
            "https://www.wowhead.com/classic/npc=2285/count-remington-ridgewell",
        },
        confidence = "confirmed",
    },

    [7917] = {
        name = "Brother Sarno",
        zone = "Stormwind City",
        coords = "40.4, 30.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Cathedral of Light priest; when Anduin Wrynn arrives at the cathedral's ceremony for the fallen of the war against the Lich King, they exchange smiles and nods",
            },
        },
        story = "Brother Sarno is a member of the Church of the Holy Light located in the Cathedral of Light in Stormwind City, where he is the first to greet those who enter. "
             .. "After the war against the Lich King, the cathedral held a ceremony for the fallen. "
             .. "In The Shattering he exchanged smiles and nods with Prince Anduin Wrynn at that ceremony.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Brother_Sarno",
            "https://www.wowhead.com/classic/npc=7917/brother-sarno",
        },
        confidence = "confirmed",
    },

    [1323] = {
        name = "Osric Strang",
        zone = "Stormwind City",
        coords = "74.2, 47.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Attends the Gathering with a helm he made for his friend Tomas Gray, with whom he used to argue over who made the best armor when they served as guards; walks with Emma Felstone",
            },
        },
        story = "Osric Strang is a human heavy armor vendor located at Limited Immunity in Old Town, Stormwind. "
             .. "In Before the Storm he recalls arguing over armor-making with his friend Tomas Gray, who served as a guard in Lordaeron while Osric served in Stormwind. "
             .. "He attended the Gathering with a helm he had made for Tomas.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Osric_Strang",
            "https://www.wowhead.com/classic/npc=1323/osric-strang",
        },
        confidence = "confirmed",
    },

    [376] = {
        name = "High Priestess Laurena",
        zone = "Stormwind City",
        coords = "38.4, 26.2",
        appearances = {
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Blesses King Anduin Wrynn at the Lion's Rest ceremony after the Argus Campaign; later asks him to return to Stormwind as his servant Wyll Benton is dying, and tends to Wyll's body for the funeral",
            },
        },
        story = "High Priestess Laurena is a priest trainer located behind the altar in the Cathedral of Light in Stormwind City. "
             .. "In Before the Storm she blessed King Anduin Wrynn at the Lion's Rest ceremony after the Argus Campaign. "
             .. "She later tended to the body of Anduin's servant Wyll Benton for his funeral. "
             .. "The wiki notes that she seems to have taken over Archbishop Benedictus's role of giving such speeches.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/High_Priestess_Laurena",
            "https://www.wowhead.com/classic/npc=376/high-priestess-laurena",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Elwynn Forest
    [240] = {
        name = "Marshal Dughan",
        zone = "Elwynn Forest",
        coords = "42.2, 65.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Stormwind Army leader in Goldshire; during the Emerald Nightmare he dreams of a mission against kobolds in Jasperlode Mine with Zaldimar Wefhellt, where he fails his men and himself (chapter 4)",
            },
        },
        story = "Marshal Dughan is a human located in Goldshire and part of the Stormwind Army, in charge of security in Goldshire and the surrounding area. "
             .. "He is the elected ruler of Elwynn Forest. "
             .. "In Stormrage the Emerald Nightmare traps the minds of Goldshire, and Dughan dreams of a mission against kobolds in Jasperlode Mine with Zaldimar Wefhellt, where he fails his men and himself.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Marshal_Dughan",
            "https://www.wowhead.com/classic/npc=240/marshal-dughan",
        },
        confidence = "confirmed",
    },

    [328] = {
        name = "Zaldimar Wefhellt",
        zone = "Elwynn Forest",
        coords = "43.2, 66.2",
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Accompanies Marshal Dughan on the Jasperlode Mine mission in Dughan's nightmare, and betrays him after revealing he is a necromancer",
            },
        },
        story = "Zaldimar Wefhellt is a human mage trainer located in the Lion's Pride Inn in Goldshire, Elwynn Forest. "
             .. "During the War Against the Nightmare, the town of Goldshire had its minds trapped in the Emerald Nightmare. "
             .. "In Marshal Dughan's nightmare, Zaldimar accompanied Dughan on a mission in Jasperlode Mine and betrayed him after revealing he was a necromancer.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Zaldimar_Wefhellt",
            "https://www.wowhead.com/classic/npc=328/zaldimar-wefhellt",
        },
        confidence = "confirmed",
    },

    [295] = {
        name = "Innkeeper Farley",
        zone = "Elwynn Forest",
        coords = "43.8, 65.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Innkeeper Fredrik Farley; his brother Frandis, a caravan guard, dies of plague in Lordaeron, and Fredrik only learns years later that Frandis became Forsaken. Summoned to Stormwind Keep by King Anduin Wrynn after the Argus Campaign (chapter 23)",
            },
        },
        story = "Innkeeper Fredrik Farley runs the Lion's Pride Inn in Goldshire, Elwynn Forest. "
             .. "In Before the Storm his brother Frandis, a caravan guard, traveled to Lordaeron, where he died of plague. "
             .. "Fredrik was devastated and was unaware until years later that Frandis had become Forsaken. "
             .. "After the Argus Campaign King Anduin Wrynn summoned him to Stormwind Keep.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Innkeeper_Farley",
            "https://warcraft.wiki.gg/wiki/Count_Remington_Ridgewell",
            "https://www.wowhead.com/classic/npc=295/innkeeper-farley",
        },
        confidence = "confirmed",
    },

    [1748] = {
        name = "Highlord Bolvar Fordragon",
        zone = "Stormwind City",
        coords = "77.4, 18.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "We Ride Forth",
                missions = {},
                role = "Minor character in the short story (not a game appearance): as the Lich King, he is confronted by the Four Horsemen over his increasingly militant actions",
            },
        },
        story = "Bolvar Fordragon served as Highlord and Regent of Stormwind while King Varian Wrynn was missing. "
             .. "In World of Warcraft Classic he rules Stormwind Keep as regent for the young Anduin Wrynn. "
             .. "In the later short story We Ride Forth, the Four Horsemen confront him in his role as the Lich King.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Bolvar_Fordragon",
            "https://warcraft.wiki.gg/wiki/We_Ride_Forth",
            "https://www.wowhead.com/classic/npc=1748",
        },
        confidence = "confirmed",
    },

    [6946] = {
        name = "Renzik \"The Shiv\"",
        zone = "Stormwind City",
        coords = "75.8, 60.2",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Tipping Point",
                missions = {},
                role = "Major character in the short story (not a game appearance): enforcer of Trade Prince Mozzy Gloxscorn in Undermine, who fights Mathias Shaw and lets him go",
            },
        },
        story = "Renzik is a goblin from Undermine who became the right hand of Trade Prince Mozzy Gloxscorn in the Krackslagger Cartel. "
             .. "In the short story The Tipping Point he fights Mathias Shaw, lets him go, and later leaves Undermine behind. "
             .. "In World of Warcraft he works for SI:7 in the Old Town of Stormwind City.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Renzik_%22The_Shiv%22",
            "https://warcraft.wiki.gg/wiki/The_Tipping_Point_(short_story)",
            "https://www.wowhead.com/classic/npc=6946",
        },
        confidence = "confirmed",
    },

    [2784] = {
        name = "King Magni Bronzebeard",
        zone = "Ironforge",
        coords = "39.4, 55.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "Tides of Darkness",
                missions = {},
                role = "Dwarf king who defends Ironforge during the Siege of Ironforge in the Second War and pledges the kingdom's support to the Alliance of Lordaeron after its liberation (not a game appearance)",
            },
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Former king and Herald of Azeroth who recruits Alliance and Horde leaders to help restore Azeroth after Sargeras's destruction, meeting Warchief Sylvanas Windrunner and Baine Bloodhoof in Thunder Bluff (not a game appearance)",
            },
            {
                game = "BOOK",
                campaign = "Blood Ties",
                missions = {},
                role = "Attends the wedding of Turalyon and Alleria Windrunner with his family in chapter 17 (not a game appearance)",
            },
        },
        story = "During the Second War Magni defended Ironforge from the orcs and joined the Alliance of Lordaeron. "
             .. "He was a founding member of the Explorers' League, led by his brother Brann. "
             .. "In The Shattering: Prelude to Cataclysm, Magni performed a ritual in Old Ironforge to commune with the earth and was turned into diamond.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Magni_Bronzebeard",
            "https://warcraft.wiki.gg/wiki/Tides_of_Darkness",
            "https://warcraft.wiki.gg/wiki/Before_the_Storm",
            "https://warcraft.wiki.gg/wiki/Blood_Ties",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://www.wowhead.com/classic/npc=2784",
        },
        confidence = "confirmed",
    },

    [5137] = {
        name = "Reyna Stonebranch",
        zone = "Ironforge",
        coords = "55.4, 58.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Herbalism trainer in the Great Forge who follows instructions from a tablet from Ulduar to make a liquid meant for Magni to communicate with Azeroth (not a game appearance)",
            },
        },
        story = "Reyna Stonebranch is a dwarf herbalism trainer in the Great Forge in Ironforge. "
             .. "In The Shattering: Prelude to Cataclysm she followed the instructions from a tablet from Ulduar and created a liquid meant for Magni to communicate with Azeroth. "
             .. "Instead of communicating, Magni was turned into diamond.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Reyna_Stonebranch",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://www.wowhead.com/classic/npc=5137",
        },
        confidence = "confirmed",
    },

    [5144] = {
        name = "Bink",
        zone = "Ironforge",
        coords = "26.8, 8.6",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Gnome mage, sister of Dink, who is caught by Dark Iron guards when Moira Thaurissan arrives in Ironforge and is released when Ironforge dwarves attack them (not a game appearance)",
            },
        },
        story = "Bink is a gnome mage trainer in the Hall of Mysteries in Ironforge, and the sister of the mage trainer Dink. "
             .. "In The Shattering: Prelude to Cataclysm, Dark Iron guards catch Bink and Dink when Moira Thaurissan arrives in Ironforge. "
             .. "They are released when Ironforge dwarves attack the guards.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Bink",
            "https://warcraft.wiki.gg/wiki/Dink",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://www.wowhead.com/classic/npc=5144",
        },
        confidence = "confirmed",
    },

    [7312] = {
        name = "Dink",
        zone = "Ironforge",
        coords = "26.8, 8.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Gnome mage, brother of Bink, who is caught by Dark Iron guards when Moira Thaurissan arrives in Ironforge and is released when Ironforge dwarves attack them (not a game appearance)",
            },
        },
        story = "Dink is a gnome mage trainer in the Hall of Mysteries in Ironforge, and the brother of the mage trainer Bink. "
             .. "In The Shattering: Prelude to Cataclysm, Dark Iron guards catch Dink and Bink when Moira Thaurissan arrives in Ironforge. "
             .. "They are released when Ironforge dwarves attack the guards.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Dink",
            "https://warcraft.wiki.gg/wiki/Bink",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://www.wowhead.com/classic/npc=7312",
        },
        confidence = "confirmed",
    },

    [7937] = {
        name = "High Tinker Mekkatorque",
        zone = "Ironforge",
        coords = "69.0, 49.0",
        appearances = {
            {
                game = "BOOK",
                campaign = "Wolfheart",
                missions = {},
                role = "High Tinker of Gnomeregan who represents the gnomes at a meeting in Darnassus, makes peace with Drukan and votes to accept Gilneas into the Alliance (chapters 9, 10 and 29; not a game appearance)",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Alliance leader who plans a counterattack against the Horde blockade of Kalimdor in Stormwind after the Attack on Theramore Isle (chapter 23; not a game appearance)",
            },
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Gnome engineer who studies Azerite samples and sends Sapphronetta Flivvers to Silithus, and meets Magni Bronzebeard in Ironforge (chapters 8 and 14; not a game appearance)",
            },
        },
        story = "Gelbin Mekkatorque is the High Tinker of Gnomeregan and a brilliant gnomish inventor. "
             .. "After the Second War, King Magni asked him for a faster solution to the slow travel to and from the north, and he prepared the schematics for the Deeprun Tram. "
             .. "The gnomish electorate later chose him as High Tinker, and his friend Sicco Thermaplugg became his chief advisor, though Thermaplugg coveted the role of High Tinker. "
             .. "In the novels he takes part in Alliance politics, including the vote on Gilneas and the planning after the Attack on Theramore Isle.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Gelbin_Mekkatorque",
            "https://warcraft.wiki.gg/wiki/Wolfheart",
            "https://warcraft.wiki.gg/wiki/Jaina_Proudmoore:_Tides_of_War",
            "https://warcraft.wiki.gg/wiki/Before_the_Storm",
            "https://www.wowhead.com/classic/npc=7937",
        },
        confidence = "confirmed",
    },

    [11406] = {
        name = "High Priest Rohan",
        zone = "Ironforge",
        coords = "23.4, 6.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "High priest of Ironforge and priest trainer in the Hall of Mysteries; heals Anduin Wrynn, witnesses Magni's petrification, and backs Moira Thaurissan as heir (chapters 11, 14, 15 and 31; not a game appearance)",
            },
        },
        story = "In The Shattering: Prelude to Cataclysm, Rohan meets Anduin Wrynn in the Hall of Mysteries and heals him after he bumps into the gnome mages Dink and Bink. "
             .. "Shortly before the Cataclysm he witnesses Magni's petrification in Old Ironforge and casts healing spells to save the king, but it is too late. "
             .. "After the earthquakes he travels to Kharanos to heal the injured. "
             .. "When Moira Thaurissan claims the throne of Ironforge, he accepts her as the new queen, and when Anduin stops his father from killing her, he declares that she remains the future queen.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/High_Priest_Rohan",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://www.wowhead.com/classic/npc=11406",
        },
        confidence = "confirmed",
    },

    [344] = {
        name = "Magistrate Solomon",
        zone = "Redridge Mountains",
        coords = "29.8, 44.6",
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler",
                missions = {},
                role = "Minor character in the novel (not a game appearance), chapter 12: the judge who declares Greydon Thorne dead two years after he leaves his family, so that Ceya Northbrooke can marry Robb Glade",
            },
        },
        story = "Magistrate Solomon is the judge of the Court of Lakeshire in the Redridge Mountains. "
             .. "In the novel Traveler he declares Greydon Thorne dead two years after Greydon abandons his family, so Ceya Northbrooke can marry Robb Glade. "
             .. "In World of Warcraft he is a quest giver in Lakeshire.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Magistrate_Solomon",
            "https://warcraft.wiki.gg/wiki/Traveler",
            "https://warcraft.wiki.gg/wiki/Ceya_Northbrooke_Thorne_Glade",
            "https://www.wowhead.com/classic/npc=344",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Duskwood
    [576] = {
        name = "Watcher Ladimore",
        zone = "Duskwood",
        coords = "73.4, 46.6",
        appearances = {
            {
                game = "BOOK",
                campaign = "Terror by Torchlight",
                missions = {},
                role = "Commander of the Night Watch in the short story (not a game appearance): found mortally wounded after confronting the Necromancer who stole the Torch of Holy Flame in the Forlorn Rowe; later thanks Shaw and Fairwind at the Scarlet Raven Tavern",
            },
        },
        story = "Sarah Ladimore is the daughter of Morgan Ladimore and the only survivor of her family. "
             .. "She became a Watcher of the Night Watch and succeeded Althea Ebonlocke as Commander of the Watch. "
             .. "In Terror by Torchlight she was found mortally wounded after confronting the Necromancer, and Mathias Shaw and Flynn Fairwind recovered the Torch of Holy Flame.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Sarah_Ladimore",
            "https://warcraft.wiki.gg/wiki/Terror_by_Torchlight",
            "https://www.wowhead.com/classic/npc=576",
        },
        confidence = "confirmed",
    },

    [1436] = {
        name = "Watcher Cutford",
        zone = "Duskwood",
        coords = "45.0, 67.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Terror by Torchlight",
                missions = {},
                role = "Night Watch member (not a game appearance): watches over the ailing Commander Ladimore while Shaw and Fairwind retrieve the torch and defeat the necromancer",
            },
        },
        story = "Watcher Cutford patrols the main road from Darkshire to the Twilight Grove. "
             .. "In Terror by Torchlight, in the aftermath of the Fourth War, he is still alive and a member of the Night Watch. "
             .. "In the short story he helped Mathias Shaw and Flynn Fairwind carry the wounded Commander Ladimore back to the Night Watch office in Darkshire.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Watcher_Cutford",
            "https://warcraft.wiki.gg/wiki/Terror_by_Torchlight",
            "https://www.wowhead.com/classic/npc=1436",
        },
        confidence = "confirmed",
    },

    [1200] = {
        name = "Morbent Fel",
        zone = "Duskwood",
        coords = "17.2, 33.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Terror by Torchlight",
                missions = {},
                role = "Mentioned in the short story (not a game appearance) as a lich who is deceased in the story's lore",
            },
        },
        story = "Morbent Fel was a human necromancer who ruled over the undead of Duskwood from his house atop the Forlorn Rowe in Raven Hill Cemetery. "
             .. "He was an ally of the Dark Riders and was responsible for raising the undead in Duskwood. "
             .. "In World of Warcraft Classic he was guarded by his undead minions and a magical barrier, which had to be removed with Morbent's Bane before he could be defeated.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Morbent_Fel",
            "https://warcraft.wiki.gg/wiki/Terror_by_Torchlight",
            "https://www.wowhead.com/classic/npc=1200",
        },
        confidence = "confirmed",
    },

    -- ================================================================ Thousand Needles
    [4706] = {
        name = "Razzeric",
        zone = "Thousand Needles",
        coords = "80.2, 76.0",
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Sponsor, engineer and pilot of the speedboat Guzzler (not a game appearance): second place in the Annual Fizzle and Pozzik's Speedbarge Boat Race, then led the protest against the result with Fizzle Brassbolts",
            },
        },
        story = "Before the Cataclysm, Razzeric was an independent goblin pilot at the Mirage Raceway in the Shimmering Flats in Thousand Needles. "
             .. "In the novel Traveler: The Spiral Path, he registers for the Annual Fizzle and Pozzik's Speedbarge Boat Race as sponsor, engineer and pilot of his speedboat, the Guzzler. "
             .. "He finishes second in the race. "
             .. "Afterwards he leads a protest with Fizzle Brassbolts, claiming that Steamwhistle should be disqualified for switching pilots.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Razzeric",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://www.wowhead.com/classic/npc=4706",
        },
        confidence = "confirmed",
    },

    [4720] = {
        name = "Rizzle Brassbolts",
        zone = "Thousand Needles",
        coords = "77.2, 77.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Pilot of the Annihilator in the Annual Fizzle and Pozzik's Speedbarge Boat Race (chapter 28; not a game appearance)",
            },
        },
        story = "Rizzle Brassbolts and his brothers were at the Mirage Raceway, working for the gnomish crew against the goblins there. "
             .. "His brothers are Fizzle and Wizzle Brassbolts. "
             .. "In the novel Traveler: The Spiral Path he was the pilot of the Annihilator in the Annual Speedbarge Boat Race.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Rizzle_Brassbolts",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://www.wowhead.com/classic/npc=4720",
        },
        confidence = "confirmed",
    },

    [6730] = {
        name = "Jinky Twizzlefixxit",
        zone = "Thousand Needles",
        coords = "77.6, 77.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Engineer of the Freebooters' Fire in the Annual Speedbarge Boat Race, with teammates Tony Two-Tusk and Rugfizzle (not a game appearance)",
            },
        },
        story = "Before the Cataclysm, Jinky was a neutral vendor at the Mirage Raceway in Thousand Needles. "
             .. "In the novel Traveler: The Spiral Path she took part in the Annual Speedbarge Boat Race as part of the Mechanical Engineers' Guild of Azeroth (MEGA) team with Tony Two-Tusk and Rugfizzle. "
             .. "She acted as the engineer of the Freebooters' Fire.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Jinky_Twizzlefixxit",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://www.wowhead.com/classic/npc=6730",
        },
        confidence = "confirmed",
    },

    [4454] = {
        name = "Fizzle Brassbolts",
        zone = "Thousand Needles",
        coords = "78.0, 77.0",
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Avid MEGA member (page 236) who led the protest with Razzeric after the Annual Speedbarge Boat Race (not a game appearance)",
            },
        },
        story = "Fizzle Brassbolts is a gnome and an avid member of the Mechanical Engineers' Guild of Azeroth (MEGA). "
             .. "He and the goblin Pozzik built the Mirage Raceway in Thousand Needles to prove the superiority of their respective races, and built rocket cars together. "
             .. "In the novel Traveler: The Spiral Path he led a protest with Razzeric after the Annual Speedbarge Boat Race.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Fizzle_Brassbolts",
            "https://warcraft.wiki.gg/wiki/Razzeric",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://www.wowhead.com/classic/npc=4454",
        },
        confidence = "confirmed",
    },

    [4507] = {
        name = "Daisy",
        zone = "Thousand Needles",
        coords = "78.8, 75.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Singer and friend of Rendow (chapter 24; not a game appearance)",
            },
        },
        story = "Daisy was originally the race starter girl at the Mirage Raceway in the Shimmering Flats in Thousand Needles. "
             .. "She can also be seen on Darkmoon Island when the Darkmoon Faire is in season. "
             .. "In Traveler: The Spiral Path she is a singer and friends with Rendow.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Daisy",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://www.wowhead.com/classic/npc=4507",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Loch Modan
    [1156] = {
        name = "Vyrin Swiftwind",
        zone = "Loch Modan",
        coords = "81.8, 64.2",
        appearances = {
            {
                game = "BOOK",
                campaign = "Quest for Pandaria",
                missions = {},
                role = "Minor character in the novella (not a game appearance): Talithar Swiftwind's estranged wife, to whom Baenan delivers the wedding rings and Talithar's message",
            },
        },
        story = "Vyrin Swiftwind is a high elf married to Talithar Swiftwind, though the two became estranged after the fall of the high elves following the Third War. "
             .. "Talithar embraced the teachings of Prince Kael'thas for the sake of his people, while Vyrin chose her integrity and went to live at the Farstrider Lodge. "
             .. "In the novella Quest for Pandaria, Talithar helps the dwarf Baenan escape the Horde destroyer Warchief's Fist and asks him to give Vyrin their wedding rings with the message that he never stopped loving her. "
             .. "Talithar later sacrificed himself to save Baenan and Chen Stormstout, and Baenan chose to name him a hero. "
             .. "In World of Warcraft Classic she is a quest giver at the Farstrider Lodge in Loch Modan.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Vyrin_Swiftwind",
            "https://warcraft.wiki.gg/wiki/Quest_for_Pandaria",
            "https://www.wowhead.com/classic/npc=1156",
        },
        confidence = "confirmed",
    },

    [639] = {
        name = "Edwin VanCleef",
        zone = "The Deadmines",
        appearances = {
            {
                game = "BOOK",
                campaign = "Beyond the Dark Portal",
                missions = {},
                role = "Supporting Alliance character in the novel (not a game appearance), listed in the novel's cast table; the wiki article credits him with supervising the Stonemasons who built Nethergarde Keep (chapter not verified)",
            },
        },
        story = "VanCleef was the Stonemasons' Guildmaster and one of the architects who rebuilt Stormwind City after the Second War. "
             .. "He supervised the construction of Nethergarde Keep, which was commissioned to keep watch over the Dark Portal. "
             .. "When the House of Nobles refused to pay the Stonemasons properly, VanCleef led them in rioting in Stormwind and out of the city. "
             .. "In World of Warcraft he took over gold mines in Westfall and led the Defias Brotherhood from a ship deep in the Deadmines until adventurers defeated him there.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Edwin_VanCleef",
            "https://warcraft.wiki.gg/wiki/Beyond_the_Dark_Portal",
            "https://warcraft.wiki.gg/wiki/Nethergarde_Keep",
            "https://warcraft.wiki.gg/wiki/Report_on_the_Defias_Brotherhood",
            "https://www.wowhead.com/classic/npc=639/edwin-vancleef",
        },
        confidence = "uncertain",
        searched = "warcraft.wiki.gg article Edwin VanCleef (novel and WoW sections of the same character page), Beyond the Dark Portal cast table (Edwin VanCleef is in the Alliance column of the Supporting block, checked in the wikitext), Nethergarde Keep, Report on the Defias Brotherhood. The novel text itself was not read, so the chapter is unknown. No RTS game appearance found.",
    },

    [3679] = {
        name = "Naralex",
        zone = "Wailing Caverns",
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Minor character in the novel (not a game appearance; set after the War Against the Nightmare): a druid who discovers Fandral Staghelm's corruption, is silenced with Hamuul Runetotem and Shandris Feathermoon, and is later freed by Malfurion; chapter 2 is cited by the wiki",
            },
        },
        story = "In World of Warcraft, Naralex tried to bring life back to the Barrens through the Wailing Caverns, but the Emerald Dream corrupted the caverns and trapped him in sleep until adventurers and his disciple Muyoh woke him. "
             .. "In the novel Stormrage, he was healed after the War Against the Nightmare and witnessed the wedding of Tyrande Whisperwind and Malfurion. "
             .. "At the start of the War Against the Nightmare he worked with other druids to heal Teldrassil, unknowingly corrupting it further. "
             .. "He discovered Fandral's corruption and told Hamuul Runetotem, and together they went to Darnassus to warn Shandris Feathermoon, but the trio was silenced by Fandral. "
             .. "Malfurion Stormrage later found them and set them free, though Naralex was more badly wounded than the others.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Naralex",
            "https://warcraft.wiki.gg/wiki/Stormrage",
            "https://www.wowhead.com/classic/npc=3679/naralex",
        },
        confidence = "confirmed",
    },

    [4275] = {
        name = "Archmage Arugal",
        zone = "Shadowfang Keep",
        appearances = {
            {
                game = "BOOK",
                campaign = "Lord of His Pack",
                missions = {},
                role = "Minor character in the short story (not a game appearance; Leaders of Azeroth series, centred on Genn Greymane): named in the text as \"the infamous royal archmage known as Arugal\"",
            },
        },
        story = "",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Arugal",
            "https://warcraft.wiki.gg/wiki/Lord_of_His_Pack",
            "https://worldofwarcraft.blizzard.com/en-us/media/short-story/genn-greymane-lord-of-his-pack",
            "https://www.wowhead.com/classic/npc=4275/archmage-arugal",
        },
        confidence = "uncertain",
        searched = "Official story text at worldofwarcraft.blizzard.com (Genn Greymane, Lord of His Pack) checked: it names Arugal. Lord of His Pack wiki article cast table lists him under Minor. The Arugal article cites this story for its Gilneas background; that background was not checked line by line against the story text, so no story is written. No RTS game appearance found.",
    },
    -- ===================================================================== Scarlet Monastery
    [3976] = {
        name = "Scarlet Commander Mograine",
        zone = "Scarlet Monastery",
        appearances = {
            {
                game = "FK",
                campaign = "Forsaken Kingdom (Undead)",
                missions = { "A Scarlet Flame" },
                role = "Scarlet Crusade commander who leads the assault on the Forsaken with High Inquisitor Whitemane; the player must defeat him in the quest \"The Dark Lady's Scalpel\"",
            },
        },
        story = "Renault Mograine killed his father, Alexandros Mograine, with the Ashbringer near Stratholme, after Saidan Dathrohan promised him power and prestige in the Scarlet Crusade. "
             .. "He was made Scarlet Commander and sent to the Scarlet Monastery in Tirisfal as commander of operations. "
             .. "Nearly one year after the Forsaken secured the Undercity, he led the Scarlet Crusade in an all-out assault on the Forsaken and invaded the Undercity itself. "
             .. "He and Sally Whitemane were forced to pull back by Garek Bandarion, Dark Ranger Anya and, in Whitemane's case, Leonid Barthalomew, and the crusaders retreated to the Scarlet Monastery. "
             .. "In World of Warcraft he is the Scarlet Commander, a boss in the Scarlet Monastery.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Renault_Mograine",
            "https://warcraft.wiki.gg/wiki/A_Scarlet_Flame_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=3976",
        },
        confidence = "confirmed",
    },

    [3977] = {
        name = "High Inquisitor Whitemane",
        zone = "Scarlet Monastery",
        appearances = {
            {
                game = "FK",
                campaign = "Forsaken Kingdom (Undead)",
                missions = { "A Scarlet Flame" },
                role = "Scarlet Crusade commander and enemy of the Forsaken; the player must defeat her in the quests \"Our Home, Our Land\" and \"The Dark Lady's Scalpel\"",
            },
            {
                game = "BOOK",
                campaign = "We Ride Forth",
                missions = {},
                role = "Four Horsemen member in the short story (not a game appearance): Darion Mograine orders her and Nazgrim to rescue Bolvar Fordragon after the Scourge slips out of control",
            },
        },
        story = "Sally Whitemane was a human priestess of the Light who became High Inquisitor of the Scarlet Crusade, directing its activities from the Scarlet Monastery's Cathedral. "
             .. "Nearly one year after the Forsaken secured the Undercity, she and Renault Mograine launched an all-out assault on the Forsaken, and Whitemane attacked the Forsaken settlements in Tirisfal Glades. "
             .. "She and Renault were forced to pull back by Garek Bandarion, Dark Ranger Anya and, in Whitemane's case, Leonid Barthalomew, and the crusaders retreated to the Scarlet Monastery. "
             .. "In World of Warcraft Classic she is the final boss of the Scarlet Monastery.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Sally_Whitemane",
            "https://warcraft.wiki.gg/wiki/A_Scarlet_Flame_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/Renault_Mograine",
            "https://warcraft.wiki.gg/wiki/We_Ride_Forth",
            "https://www.wowhead.com/classic/npc=3977",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Gnomeregan
    [7800] = {
        name = "Mekgineer Thermaplugg",
        zone = "Gnomeregan",
        appearances = {
            {
                game = "BOOK",
                campaign = "Cut Short",
                missions = {},
                role = "Major character and antagonist in the short story (not a game appearance): Gelbin Mekkatorque's former closest friend, the betrayer the gnomes must face",
            },
        },
        story = "In his youth, Sicco Thermaplugg was the closest friend of Gelbin Mekkatorque, and Gelbin later employed him at his foundry. "
             .. "Sicco resented Gelbin for being elected High Tinker of Gnomeregan and believed the gnomes should use their inventions to expand their power instead of trading them to allies. "
             .. "Gelbin kept Sicco in a prominent role in the Tinkers' Court despite his flawed work, and Sicco went on to serve as Gelbin's chief advisor for many years. "
             .. "In Cut Short the gnomes must face him as a betrayer who is obsessed with ruling the gnomish race or destroying it. "
             .. "In World of Warcraft he is a boss in Gnomeregan.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Sicco_Thermaplugg",
            "https://warcraft.wiki.gg/wiki/Cut_Short",
            "https://www.wowhead.com/classic/npc=7800",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Razorfen Kraul
    [4421] = {
        name = "Charlga Razorflank",
        zone = "Razorfen Kraul",
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Mentioned character in the novel (not a game appearance; listed under Mentioned in the cast table): the wiki cites page 178 for her shaping most of the thorn dome of Razorfen Downs and training Chugara Razorflank to maintain it",
            },
        },
        story = "In Traveler: The Spiral Path, Charlga Razorflank shaped most of the thorn dome of Razorfen Downs. "
             .. "She trained Chugara Razorflank to maintain the dome. "
             .. "The novel states that Chugara later surrendered Razorfen to the Death's Head tribe, which adds to the unclear story of how that tribe was created.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Charlga_Razorflank",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://www.wowhead.com/classic/npc=4421",
        },
        confidence = "confirmed",
    },

    -- Book rescan of Undercity and Thunder Bluff areas (2026-10-08, Haiku workers + Haiku critics)
    -- ===================================================================== Undercity (BOOK)
    [2055] = {
        name = "Master Apothecary Faranell",
        zone = "Undercity",
        coords = "48.4, 69.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Arthas: Rise of the Lich King",
                missions = {},
                role = "Minor character in the novel (not a game appearance): Grand Apothecary Putress' apothecary who demonstrates the New Plague to Sylvanas with two prisoners",
            },
            {
                game = "BOOK",
                campaign = "World of Warcraft: Sylvanas",
                missions = {},
                role = "Minor character in the novel (not a game appearance): subordinate of Grand Apothecary Putress",
            },
        },
        story = "Before the Scourge, Faranell was an alchemist of great renown who studied with the wizards of Dalaran, and he rose as one of the Forsaken. "
             .. "In Sylvanas he served as a subordinate of Grand Apothecary Putress and became one of the foremost experts on the undead plague. "
             .. "In Arthas: Rise of the Lich King, on Putress' orders, he showed the effects of the New Plague by having two prisoners drink it, and Sylvanas was pleased but warned that the blight must never fall into the wrong hands. "
             .. "In World of Warcraft he is the Master of the Apothecarium in the Undercity.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Master_Apothecary_Faranell",
            "https://warcraft.wiki.gg/wiki/Arthas:_Rise_of_the_Lich_King",
            "https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Sylvanas",
            "https://www.wowhead.com/classic/npc=2055",
        },
        confidence = "confirmed",
    },

    [4488] = {
        name = "Parqual Fintallas",
        zone = "Undercity",
        coords = "57.4, 65.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Minor character in the novel (not a game appearance; chapters 12, 19, 22, 29, 32, 33 and 34): Forsaken former historian of Lordaeron, titled Governor in chapter 19 and a member of the Desolate Council; reunited with his daughter Philia at the Gathering and killed in chapter 34",
            },
        },
        story = "Before the Plague, Parqual Fintallas was a human historian in Capital City, living with his wife Mina and daughter Philia. "
             .. "As an undead Forsaken he was unsure what had become of his family, and Philia's teddy bear Brownie was one of the few remnants of his old life. "
             .. "In Before the Storm he smuggled books from his former home into the Undercity with the help of Horde adventurers, and he joined the Desolate Council founded by his friend Vellcinda Benton. "
             .. "At the Gathering in the Arathi Highlands he was reunited with his daughter. "
             .. "He then tried to defect to the Alliance at Stromgarde Keep, and he was killed by Sylvanas' dark rangers as he ran toward Stromgarde. "
             .. "In World of Warcraft he works in the Apothecarium of the Undercity.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Parqual_Fintallas",
            "https://warcraft.wiki.gg/wiki/Before_the_Storm",
            "https://www.wowhead.com/classic/npc=4488",
        },
        confidence = "confirmed",
    },

    [4611] = {
        name = "Doctor Herbert Halsey",
        zone = "Undercity",
        coords = "47.4, 73.0",
        appearances = {
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Minor character named in the novel (not a game appearance): listed as Herbert Halsey in the character list; Vellcinda Benton compares herself to Doctor Halsey in chapter 19",
            },
        },
        story = "",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Doctor_Herbert_Halsey",
            "https://warcraft.wiki.gg/wiki/Before_the_Storm",
            "https://www.wowhead.com/classic/npc=4611",
        },
        confidence = "uncertain",
        searched = "Read the wiki NPC page and the Before the Storm page. The novel's character list links 'Herbert Halsey' (undead male) to this NPC page; that link is the only identity link. The novel text only mentions 'Doctor Halsey' in chapter 19, as a comparison. The NPC page's trivia says the name is borrowed from Lovecraft's Herbert West. The identity is therefore an inference from the wiki link, not an explicit statement in the text.",
    },

-- Checked by critic: book_thunderbluff. PASS and FIX entries only.

    [4046] = {
        name = "Magatha Grimtotem",
        zone = "Thunder Bluff",
        coords = "70.2, 30.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Antagonist: Grimtotem matriarch who poisons the blade of Garrosh's axe Gorehowl so that Garrosh can kill Cairne Bloodhoof; then orders her tribe to attack Thunder Bluff",
            },
        },
        story = "Magatha Grimtotem became matriarch of her tribe after her husband's accidental death. "
             .. "In the book, she offered the support of the Grimtotem tribe to the new Warchief Garrosh Hellscream as a way to dispose of Cairne Bloodhoof. "
             .. "When Cairne challenged Garrosh to mak'gora, she applied poison to the blade of Gorehowl, and Garrosh killed him. "
             .. "Her tribe then attacked Thunder Bluff and the other tauren towns to kill everyone in them, Cairne's son Baine included.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Magatha_Grimtotem",
            "https://warcraft.wiki.gg/wiki/Rahauro",
            "https://warcraft.wiki.gg/wiki/Narm_Skychaser",
            "https://www.wowhead.com/classic/npc=4046",
        },
        confidence = "confirmed",
    },

    [5769] = {
        name = "Hamuul Runetotem",
        zone = "Thunder Bluff",
        coords = "78.4, 28.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Supporting character: archdruid who becomes a close friend of Broll and is among the archdruids summoned to Teldrassil",
            },
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Supporting character: archdruid in Orgrimmar; sends messages to the Cenarion Circle and discusses Garrosh's rebuilt Orgrimmar with Cairne Bloodhoof at Red Rocks",
            },
            {
                game = "BOOK",
                campaign = "As Our Fathers Before Us",
                missions = {},
                role = "Supporting character: Baine Bloodhoof asks him about the Quilboar attacks on the water caravans to Orgrimmar",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Supporting character: steps in to aid Baine Bloodhoof when Baine and Garrosh confront each other over the attack on Theramore, until both are ordered to stand down",
            },
        },
        story = "Hamuul Runetotem is the archdruid of the tauren and the leader of the Horde druids. "
             .. "In the novel Stormrage, he became a close friend of Broll, who considers him his closest friend apart from Varian and Valeera. "
             .. "In The Shattering: Prelude to Cataclysm, he met Cairne Bloodhoof at Red Rocks to discuss how Garrosh had rebuilt Orgrimmar, and he was sending messages to the Cenarion Circle. "
             .. "In Tides of War, he stepped forward to aid Baine Bloodhoof when Baine and Garrosh Hellscream confronted each other over the planned attack on Theramore, until both were ordered to stand down.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Hamuul_Runetotem",
            "https://warcraft.wiki.gg/wiki/Stormrage",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://warcraft.wiki.gg/wiki/As_Our_Fathers_Before_Us",
            "https://warcraft.wiki.gg/wiki/Jaina_Proudmoore:_Tides_of_War",
            "https://www.wowhead.com/classic/npc=5769",
        },
        confidence = "confirmed",
    },

    [4310] = {
        name = "Cor Grimtotem",
        zone = "Thunder Bluff",
        coords = "",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Grimtotem agent: sabotages the Thunder Bluff lifts during Baine's counterattack",
            },
        },
        story = "Cor Grimtotem was a tauren once found in Thunder Bluff, and he has since been removed from the game. "
             .. "In The Shattering: Prelude to Cataclysm, he loyally helped Magatha Grimtotem secure Thunder Bluff for the Grimtotem tribe. "
             .. "Expecting Baine Bloodhoof to try to retake the town, he planned to make the lifts explode so that Baine's troops would camp at the base, but he managed to explode only one of them. "
             .. "His fate after the battle is unknown.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Cor_Grimtotem",
            "https://www.wowhead.com/classic/npc=4310",
        },
        confidence = "confirmed",
    },

    [4309] = {
        name = "Gorm Grimtotem",
        zone = "Thunder Bluff",
        coords = "",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Grimtotem bodyguard: stays at Magatha's side during Baine's counterattack on Thunder Bluff",
            },
        },
        story = "Gorm Grimtotem was a tauren originally found on the Elder Rise of Thunder Bluff, and he has since been removed from the game. "
             .. "In The Shattering: Prelude to Cataclysm, he loyally assisted Magatha Grimtotem in securing Thunder Bluff for the Grimtotem tribe. "
             .. "When Baine Bloodhoof launched a counterattack to retake the town, Gorm stayed at Magatha's side and saved her life by keeping her from falling. "
             .. "His fate after Baine's forces retook Thunder Bluff is unknown.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Gorm_Grimtotem",
            "https://www.wowhead.com/classic/npc=4309",
        },
        confidence = "confirmed",
    },

    [11833] = {
        name = "Rahauro",
        zone = "Thunder Bluff",
        coords = "",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Servant of Magatha Grimtotem: helps her secure Thunder Bluff for the Grimtotem tribe",
            },
        },
        story = "Rahauro was the servant of Magatha Grimtotem in Thunder Bluff. "
             .. "In The Shattering: Prelude to Cataclysm, he loyally aided Magatha in securing Thunder Bluff for the Grimtotem tribe. "
             .. "He grew worried when Magatha told him that Garrosh Hellscream refused to aid the Grimtotem.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Rahauro",
            "https://www.wowhead.com/classic/npc=11833",
        },
        confidence = "confirmed",
    },

    [3066] = {
        name = "Narm Skychaser",
        zone = "Mulgore",
        coords = "48.4, 59.2",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Victim: killed by the Grimtotem tribe after Cairne Bloodhoof's death (pg. 209)",
            },
        },
        story = "Narm Skychaser is a tauren shaman trainer in Bloodhoof Village in Mulgore, and he directs shaman adventurers to Kranal Fiss. "
             .. "In The Shattering: Prelude to Cataclysm, he was killed by the Grimtotem tribe following Cairne Bloodhoof's death. "
             .. "After Cairne was killed, Magatha Grimtotem ordered her tribe to attack Thunder Bluff and the other tauren towns.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Narm_Skychaser",
            "https://www.wowhead.com/classic/npc=3066",
        },
        confidence = "confirmed",
    },

    -- Book rescan of Orgrimmar and Durotar (2026-10-08, Haiku worker + Haiku critic)
    [3144] = {
        name = "Eitrigg",
        zone = "Orgrimmar",
        coords = "34.2, 39.0",
        appearances = {
            {
                game = "BOOK",
                campaign = "Of Blood and Honor",
                missions = {},
                role = "Blackrock orc who meets Thrall and leaves with his people to return to their shamanistic roots (novel, not a game appearance)",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Opposes Garrosh Hellscream's plan to conquer Kalimdor at the Horde leaders' meeting, with Baine Bloodhoof's support (novel, not a game appearance)",
            },
        },
        story = "Eitrigg was born into the Blackrock clan on Draenor. "
             .. "In the novel The Shattering: Prelude to Cataclysm he was in his late fifties by the time the Lich King was defeated. "
             .. "In the novel Of Blood and Honor, after meeting Thrall he found that his people had rediscovered their shamanistic roots, and he returned to life among his own kind. "
             .. "In the novel Jaina Proudmoore: Tides of War, he was against Garrosh's plan to conquer Kalimdor, and Baine Bloodhoof supported him. "
             .. "In World of Warcraft he serves the Horde as an advisor and supporter to Thrall, and can be found in Thrall's throne room in Orgrimmar.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Eitrigg",
            "https://warcraft.wiki.gg/wiki/Of_Blood_and_Honor",
            "https://warcraft.wiki.gg/wiki/Jaina_Proudmoore:_Tides_of_War",
            "https://www.wowhead.com/classic/npc=3144",
        },
        confidence = "confirmed",
    },

    [14720] = {
        name = "High Overlord Saurfang",
        zone = "Orgrimmar",
        coords = "50.4, 76.0",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Remains at Warsong Hold as leader of the Warsong Offensive and the Horde Expedition after Cairne Bloodhoof visits Garrosh (novel, not a game appearance)",
            },
        },
        story = "Varok Saurfang was a renowned Blackrock orc warrior, the younger brother of Broxigar, and second-in-command to Warchief Orgrim Doomhammer. "
             .. "In the novel The Shattering: Prelude to Cataclysm, Cairne Bloodhoof traveled to Warsong Hold to meet Garrosh, and Saurfang was to stay there as leader of the Warsong Offensive and the Horde Expedition. "
             .. "In World of Warcraft he is High Overlord of the Horde and High Overlord of the Kor'kron Guard.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Varok_Saurfang",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://www.wowhead.com/classic/npc=14720",
        },
        confidence = "confirmed",
    },

    [3355] = {
        name = "Saru Steelfury",
        zone = "Orgrimmar",
        coords = "82.2, 23.0",
        appearances = {
            {
                game = "BOOK",
                campaign = "A Good War",
                missions = {},
                role = "Smith at the Burning Anvil in Orgrimmar; keeps High Overlord Saurfang's letter promising replacement Azerite after an explosion (novella, not a game appearance)",
            },
        },
        story = "In the novella A Good War, a few weeks before the War of the Thorns an explosion rocked the Burning Anvil in Orgrimmar, where Saru Steelfury worked. "
             .. "Saru came out unscathed and blamed an apprentice's overcooked felslate, while High Overlord Saurfang promised him in writing that the lost Azerite would be replaced. "
             .. "In World of Warcraft he is a Blacksmithing Trainer at the Burning Anvil in the Valley of Honor, Orgrimmar.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Saru_Steelfury",
            "https://warcraft.wiki.gg/wiki/A_Good_War",
            "https://www.wowhead.com/classic/npc=3355",
        },
        confidence = "confirmed",
    },

    [3329] = {
        name = "Kor'jus",
        zone = "Orgrimmar",
        coords = "49.0, 54.0",
        appearances = {
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Shopkeeper arrested and beaten by Malkorok and Kor'kron soldiers for not fully supporting Garrosh Hellscream (novel, not a game appearance)",
            },
        },
        story = "In the novel Jaina Proudmoore: Tides of War, Malkorok and a few Kor'kron soldiers attacked Kor'jus when his shop was closed, because he was not fully supportive of Garrosh Hellscream. "
             .. "They arrested and beat him, and he returned to his shop after a few days. "
             .. "In World of Warcraft he is a Mushroom Vendor in Orgrimmar.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Kor%27jus",
            "https://warcraft.wiki.gg/wiki/Jaina_Proudmoore:_Tides_of_War",
            "https://www.wowhead.com/classic/npc=3329",
        },
        confidence = "confirmed",
    },

    [6928] = {
        name = "Innkeeper Grosk",
        zone = "Durotar",
        coords = "51.4, 41.6",
        appearances = {
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Innkeeper of the inn in Razor Hill who serves Malkorok and his Kor'kron soldiers, vanishes during their visit, and the inn explodes after they leave (novel, not a game appearance)",
            },
        },
        story = "In the novel Jaina Proudmoore: Tides of War, Grosk served drinks to Malkorok and his Kor'kron soldiers, then disappeared. "
             .. "Kelantir Bloodblade and Frandis Farley were killed when Kor'kron grenades blew up the inn, and Grosk claimed he knew nothing about it. "
             .. "In World of Warcraft he is an innkeeper in Razor Hill, Durotar.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Innkeeper_Grosk",
            "https://warcraft.wiki.gg/wiki/Jaina_Proudmoore:_Tides_of_War",
            "https://www.wowhead.com/classic/npc=6928",
        },
        confidence = "confirmed",
    },

    [3205] = {
        name = "Zalazane",
        zone = "Durotar",
        coords = "66.4, 87.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Vol'jin: Shadows of the Horde",
                missions = {},
                role = "Vol'jin's best friend in childhood, shown in the novel's account of their youth (novel, not a game appearance)",
            },
        },
        story = "In the novel Vol'jin: Shadows of the Horde, Zalazane grew up as the best friend of Vol'jin, who was the son of the Darkspear chieftain Sen'jin. "
             .. "In World of Warcraft he became the Hexmaster and Traitor of the Darkspears, and used dark voodoo to rob most of the Darkspear trolls of their free will. "
             .. "He declared himself ruler of the Echo Isles, and the Darkspears and their allies often struck at his holdings there.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Zalazane",
            "https://warcraft.wiki.gg/wiki/Vol%27jin:_Shadows_of_the_Horde",
            "https://www.wowhead.com/classic/npc=3205",
        },
        confidence = "confirmed",
    },

    [4047] = {
        name = "Zor Lonetree",
        zone = "Orgrimmar",
        coords = "39.0, 38.0",
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Ally whom Malfurion Stormrage contacts for help against the Nightmare Lord when the Emerald Nightmare attacks Azeroth (novel, not a game appearance)",
            },
        },
        story = "In the novel Stormrage, when the Emerald Nightmare attacked Azeroth, Malfurion Stormrage contacted Zor to gather allies against the Nightmare Lord. "
             .. "In World of Warcraft he stands in Grommash Hold in Orgrimmar and is well schooled in Alliance politics. "
             .. "He sends adventurers to help the spirits of the Stonetalon Mountains.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Zor_Lonetree",
            "https://warcraft.wiki.gg/wiki/Stormrage",
            "https://www.wowhead.com/classic/npc=4047",
        },
        confidence = "confirmed",
    },

    [3173] = {
        name = "Swart",
        zone = "Durotar",
        coords = "54.4, 42.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "As Our Fathers Before Us",
                missions = {},
                role = "Explains the reasons for quilboar aggression to Baine Bloodhoof (short story, not a game appearance)",
            },
        },
        story = "In the short story As Our Fathers Before Us, some time after the Cataclysm, Swart explained the reasons behind the quilboar aggression to Baine Bloodhoof. "
             .. "In World of Warcraft he is an orc shaman trainer. "
             .. "He trains shamans in the Razor Hill Barracks in Durotar.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Swart",
            "https://warcraft.wiki.gg/wiki/As_Our_Fathers_Before_Us",
            "https://www.wowhead.com/classic/npc=3173",
        },
        confidence = "confirmed",
    },

    -- Book rescan of Ashenvale and Hillsbrad (2026-10-08, Haiku worker + Haiku critic)
-- Checked by critic (book_ashenvale): PASS and FIX entries only.
-- ===================================================================== Ashenvale
    [14753] = {
        name = "Illiyana Moonblaze",
        zone = "Ashenvale",
        coords = "61.4, 83.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "Wolfheart",
                missions = {},
                role = "Silverwing Sentinel scout under Su'ura Swiftarrow who survives the Horde invasion of Ashenvale, saves Su'ura from Garrosh Hellscream, and turns down a commission afterwards (novel, not a game appearance)",
            },
        },
        story = "Illiyana Moonblaze is a night elf tracker and PvP vendor in Silverwing Grove in Ashenvale. "
             .. "In the novel Wolfheart, set in the aftermath of the Cataclysm, she is one of Su'ura Swiftarrow's scouts when the Horde pushes into Ashenvale. "
             .. "She is the only scout to make it back to Silverwing Outpost alive, and she saves Su'ura when Garrosh Hellscream finds her injured. "
             .. "With her saber distracting Garrosh, she rescues Su'ura and retreats with the surviving Silverwing Sentinels to safer territory. "
             .. "After the battle for Ashenvale she is offered a commission, but she turns it down because it would mean more responsibility and less independence.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Illiyana_Moonblaze",
            "https://warcraft.wiki.gg/wiki/Wolfheart",
            "https://warcraft.wiki.gg/wiki/Silverwing_Outpost",
            "https://www.wowhead.com/classic/npc=14753",
        },
        confidence = "confirmed",
    },

    [14889] = {
        name = "Emeriss",
        zone = "Ashenvale",
        coords = "",
        alsoIn = { "Duskwood", "Feralas", "The Hinterlands" },
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Corrupted green dragon and servant of the Nightmare; one of the major antagonists of the War Against the Nightmare, who is disintegrated when Tyrande tries to cleanse her (novel, not a game appearance)",
            },
        },
        story = "Emeriss is a green dragon of Ysera's flight who was turned into a servant of the Nightmare. "
             .. "In the novel Stormrage she is one of the major antagonists of the War Against the Nightmare. "
             .. "She and Lethon attack Eranikus to corrupt him, but Alexstrasza forces the corrupted dragons to retreat. "
             .. "Later she attacks Tyrande Whisperwind and Malfurion Stormrage, and when Tyrande tries to remove her corruption with the power of Elune, Emeriss is disintegrated. "
             .. "Her tainted essence remains tied to the Nightmare and to Xavius.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Emeriss",
            "https://warcraft.wiki.gg/wiki/Stormrage",
            "https://www.wowhead.com/classic/npc=14889",
        },
        confidence = "confirmed",
    },

    [14888] = {
        name = "Lethon",
        zone = "Ashenvale",
        coords = "",
        alsoIn = { "Duskwood", "Feralas", "The Hinterlands" },
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "One of Ysera's wayward dragons and a strong servant of the Nightmare; attacks Ysera, Tyrande, Broll Bearmantle, Eranikus and Gnarl, and is torn apart when he is pulled into the boundary between the Emerald Dream and Azeroth (novel, not a game appearance)",
            },
        },
        story = "Lethon is one of Ysera's wayward dragon lieutenants and was among the strongest servants of the Nightmare. "
             .. "In the novel Stormrage he attacks Ysera, Tyrande Whisperwind, Broll Bearmantle, Eranikus and Gnarl during the War Against the Nightmare. "
             .. "He tries to corrupt Eranikus alongside Emeriss, and is forced to retreat when Alexstrasza arrives. "
             .. "Later he ambushes Malfurion Stormrage and Eranikus as they try to free Ysera from the Eye, and attempts to corrupt Eranikus. "
             .. "When Eranikus shifts them both into the unstable boundary between the Emerald Dream and Azeroth, the chaotic energies tear both dragons apart.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Lethon",
            "https://warcraft.wiki.gg/wiki/Stormrage",
            "https://www.wowhead.com/classic/npc=14888",
        },
        confidence = "confirmed",
    },

    [3916] = {
        name = "Shael'dryn",
        zone = "Ashenvale",
        coords = "53.4, 46.2",
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Dryad guardian who warns the other guardians about the shadow attackers of the Emerald Nightmare, then falls asleep herself (chapter 11; novel, not a game appearance)",
            },
        },
        story = "Shael'dryn is a dryad quest giver in Ashenvale who considers herself a comedian; Broll Bearmantle calls her a jester of words and a lover of puns. "
             .. "In the novel Stormrage, when the Emerald Nightmare attacks Azeroth, she warns the other guardians about shadow attackers. "
             .. "She then becomes a sleeping victim of the attack herself.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Shael%27dryn",
            "https://warcraft.wiki.gg/wiki/Stormrage",
            "https://www.wowhead.com/classic/npc=3916",
        },
        confidence = "confirmed",
    },

-- ===================================================================== Hillsbrad Foothills (Tarren Mill)
    [2216] = {
        name = "Apothecary Lydon",
        zone = "Hillsbrad Foothills",
        coords = "61.4, 19.2",
        appearances = {
            {
                game = "BOOK",
                campaign = "Edge of Night",
                missions = {},
                role = "Supporting character in the official short story (not a game appearance): a former young human alchemist who serves Sylvanas and oversees the attack on Gilneas alongside Garrosh Hellscream",
            },
        },
        story = "In the short story Edge of Night, Lydon is a former young human alchemist who fought during Sylvanas' liberation. "
             .. "He has already embraced his fate and speaks of humans as another race, and Sylvanas answers that they will only serve in the battle. "
             .. "The story has him oversee the attack on Gilneas alongside Warchief Garrosh Hellscream, and he tries to persuade Garrosh not to use the Forsaken as a ramp of bodies. "
             .. "In World of Warcraft he is Apothecary Lydon, a quest giver in Tarren Mill who tests his poisons on his frog Umpi.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Master_Apothecary_Lydon",
            "https://warcraft.wiki.gg/wiki/Edge_of_Night",
            "https://www.wowhead.com/classic/npc=2216",
        },
        confidence = "confirmed",
    },
}

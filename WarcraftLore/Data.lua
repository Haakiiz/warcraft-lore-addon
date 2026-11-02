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
--   related     (optional) NPC IDs of other entries tied to this one (family, allies, rivals), e.g. { 3230, 10540 }.
--               One side is enough: the lore window shows the link on both entries.
--   forever     (optional) true for an NPC that only WoW Forever has (its new zones: Mount Hyjal, Dalaran,
--               Riverglades ...). The Classic Era build drops these entries when it loads.
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
--   confidence  (required) "confirmed". Only confirmed veterans ship; leave out anything you cannot
--               confirm from a source (tests/validate_db.py rejects "uncertain").
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
        related = { 3230, 10540, 3057, 4968, 10182, 3391 },
        appearances = {
            {
                game = "WC3",
                campaign = "The Invasion of Kalimdor (Orc)",
                missions = { "Landfall", "The Long March", "Cry of the Warsong",
                             "Where Wyverns Dare", "The Oracle", "By Demons Be Driven", "The Death of Hellscream" },
                role = "Playable hero (Far Seer); absent from chapters 4–5, which belong to Grom Hellscream; in the closing cinematic he faces Mannoroth with Grom",
            },
            {
                game = "WC3",
                campaign = "Eternity's End (Night Elf)",
                missions = { "The Last Guardian", "Twilight of the Gods" },
                role = "Allied commander (Far Seer): arrives with Jaina in The Last Guardian to hear the Prophet's warning, then fortifies the Horde base on Mount Hyjal against Archimonde's army in Twilight of the Gods",
            },
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "To Tame a Land", "Old Hatreds", "A Blaze of Glory" },
                role = "Allied NPC; the Warchief who gives Rexxar his orders and commands the Horde against Admiral Proudmoore",
            },
            {
                game = "BOOK",
                campaign = "Lord of the Clans",
                missions = {},
                role = "Protagonist: Go'el's life in the internment camps, his escape from Durnholde Keep, and his rise to Warchief",
            },
            {
                game = "BOOK",
                campaign = "Cycle of Hatred",
                missions = {},
                role = "Tries to keep the peace with Theramore while his chief warrior Burx attacks Northwatch Hold",
            },
            {
                game = "BOOK",
                campaign = "Of Blood and Honor",
                missions = {},
                role = "Leads an attack on Stratholme that saves Eitrigg from execution and lets him join the New Horde (chapter 7)",
            },
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Appoints Garrosh Hellscream acting warchief and travels to Nagrand to speak with the Furies",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Leader of the Earthen Ring; meets Jaina in secret and refuses to return to the Horde to rein in Garrosh",
            },
            {
                game = "BOOK",
                campaign = "Thrall: Twilight of the Aspects",
                missions = {},
                role = "Protagonist: sent by Ysera through the Caverns of Time into an alternate timeline, where he relives the murder of his parents",
            },
            {
                game = "BOOK",
                campaign = "War Crimes",
                missions = {},
                role = "Suggests Baine Bloodhoof as Garrosh's defender and is called as Tyrande's witness at Garrosh's trial",
            },
        },
        story = "After the Third War, Thrall gathered the orcs and found them a new home in Kalimdor. "
             .. "He founded Durotar, named after his father Durotan, with Orgrimmar as its capital, named after Orgrim Doomhammer. "
             .. "In The Founding of Durotar, Rexxar helped him secure the young nation. "
             .. "In World of Warcraft he leads the Horde as Warchief from his hall in the Valley of Wisdom in Orgrimmar.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/The_Last_Guardian_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Thrall",
            "https://warcraft.wiki.gg/wiki/The_Invasion_of_Kalimdor",
            "https://warcraft.wiki.gg/wiki/To_Tame_a_Land",
            "https://warcraft.wiki.gg/wiki/Old_Hatreds_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/A_Blaze_of_Glory_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/Twilight_of_the_Gods_(WC3_Night_Elf)",
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
                role = "His men help carry the wounded orc Byrok to Thrall, and he readies the orc troops when the human army gathers at Northwatch Hold",
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
        related = { 3205 },
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "To Tame a Land", "Old Hatreds" },
                role = "Quest giver and advisor (Witch Doctor); the Darkspear chieftain turns Rexxar, Rokhan and Chen into spirit wyverns",
            },
            {
                game = "BOOK",
                campaign = "The Judgment",
                missions = {},
                role = "Protagonist: sent into First Home with his best friend Zalazane to be tested by the loa and become a shadow hunter",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Leads the Darkspear at Northwatch Hold and in Garrosh's attack on Theramore, and questions the plan to drive out the night elves",
            },
            {
                game = "BOOK",
                campaign = "Vol'jin: Shadows of the Horde",
                missions = {},
                role = "Poisoned by Garrosh's assassins, recovers at the Shado-Pan Monastery with Chen Stormstout's help, and receives Shado-Pan monk training",
            },
            {
                game = "BOOK",
                campaign = "War Crimes",
                missions = {},
                role = "As Warchief he offers Baine Bloodhoof the role of Garrosh's defender, vetoes the Alliance's choice of Varian as accuser, and later testifies as Tyrande's witness",
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
            "https://warcraft.wiki.gg/wiki/The_Judgment",
            "https://www.wowhead.com/classic/npc=10540",
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
        coords = "18.8, 78.5",
        appearances = {
            {
                game = "WC3",
                campaign = "Path of the Damned (Undead)",
                missions = { "Under the Burning Sky" },
                role = "One of seven randomly named enemy archmage heroes (six on normal difficulty, all seven on hard) who oppose Arthas outside Dalaran while Kel'Thuzad summons Archimonde (Warcraft III: Reforged only)",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Attends Council of Six meetings where Jaina asks for help defending Theramore and attacking Orgrimmar",
            },
            {
                game = "BOOK",
                campaign = "Quest for Pandaria",
                missions = {},
                role = "Arrives near Booty Bay with other magi to save his daughter Catelyn when the Bloodsail Buccaneers attack her crew",
            },
        },
        story = "Archmage Ansirem Runeweaver is a human quest giver located at Dalaran Crater in the Alterac Mountains. "
             .. "He is a member of the Council of Six, the leaders of the Kirin Tor of Dalaran. "
             .. "In Warcraft III: Reforged his name is one of the random enemy archmage heroes who oppose Arthas outside Dalaran while Kel'Thuzad summons Archimonde. "
             .. "In the game he offers the quest Ansirem's Key and completes Magical Analysis. "
             .. "The novel Jaina Proudmoore: Tides of War tells that he stayed at the crater until the Cataclysm and kept serving the Kirin Tor. "
             .. "In the novella Quest for Pandaria he arrives near Booty Bay with other magi to save his daughter Catelyn from the Bloodsail Buccaneers.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Archmage_Ansirem_Runeweaver",
            "https://warcraft.wiki.gg/wiki/Under_the_Burning_Sky_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/Jaina_Proudmoore:_Tides_of_War",
            "https://warcraft.wiki.gg/wiki/Quest_for_Pandaria",
            "https://www.wowhead.com/classic/npc=2543",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Darnassus
    [7999] = {
        name = "Tyrande Whisperwind",
        zone = "Darnassus",
        coords = "38.4, 80.6",
        related = { 3936, 3516 },
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
                role = "In the novel, set about 10,000 years before the First War, she is Sister Tyrande, a novice priestess in Suramar who is kind to the captive orc Broxigar and later frees him with Krasus and Rhonin",
            },
            {
                game = "BOOK",
                campaign = "The Demon Soul",
                missions = {},
                role = "In the novel, set about 10,000 years before the First War, she appears as High Priestess Tyrande Whisperwind",
            },
            {
                game = "BOOK",
                campaign = "The Sundering",
                missions = {},
                role = "In the novel, set about 10,000 years before the First War, High Priestess Tyrande is abducted by Xavius and held in Queen Azshara's palace, where she refuses to join the queen's handmaidens",
            },
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "She learns through nightmares that Malfurion is dying, asks Broll Bearmantle to search the Emerald Dream and goes with him",
            },
            {
                game = "BOOK",
                campaign = "Wolfheart",
                missions = {},
                role = "Leads Alliance reinforcements into the battle for Ashenvale, blinds the invading Horde with Elune's light and is struck down by orc archers",
            },
            {
                game = "BOOK",
                campaign = "War Crimes",
                missions = {},
                role = "Accuser at Garrosh Hellscream's trial in the Temple of the White Tiger, opposite the defender Baine Bloodhoof",
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
            "https://warcraft.wiki.gg/wiki/Wolfheart",
            "https://warcraft.wiki.gg/wiki/War_Crimes",
            "https://warcraft.wiki.gg/wiki/Broxigar",
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
                role = "Calls a convocation of druids on Teldrassil and insists on healing the tree, and the Nightmare Lord has tricked him with a vision of his dead son Valstann",
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
                role = "Item lore only: the history text of the artifact Athrikus' Ring of Power tells his story; he does not appear as a unit",
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
        related = { 3230 },
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
        related = { 2993, 4046, 5769 },
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
                role = "Among the first tauren to fall under the Nightmare's sway and into slumber",
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
                campaign = "Stormrage",
                missions = {},
                role = "Guides the tauren in their resistance to the Nightmare and is forced to kill his friend Gam, whose vision the Nightmare twisted so that Baine looked like a centaur",
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
                role = "Co-leads the tauren and Darkspear army at Northwatch, confronts Garrosh over the molten giants and the Theramore attack, and has Perith Stormhoof warn Jaina Proudmoore of the attack",
            },
            {
                game = "BOOK",
                campaign = "War Crimes",
                missions = {},
                role = "Chosen by Vol'jin as Garrosh Hellscream's defender at his trial in the Temple of the White Tiger, opposite Tyrande Whisperwind",
            },
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Sylvanas Windrunner tasks him with organizing the Horde's healing efforts and orders him to cut off contact with King Anduin Wrynn",
            },
            {
                game = "BOOK",
                campaign = "A Good War",
                missions = {},
                role = "Questions Varok Saurfang about the Horde's march through the Barrens; Saurfang realizes Baine knows something of the real plan to invade Ashenvale",
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
            "https://warcraft.wiki.gg/wiki/Stormrage",
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
                role = "Thrall hires him to rebuild Orgrimmar after rogue fire elementals devastated the city",
            },
            {
                game = "BOOK",
                campaign = "The Goblin Way",
                missions = {},
                role = "On his \"factfinding\" tours he strong-arms Marin Noggenfogger into letting him inspect his mine, and the two agree to align their cartels",
            },
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Sponsors the Speedbarge boat race, lets Aram pilot for him, and helps the travelers into Gadgetzan and out again aboard his zeppelin Cloudkicker",
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
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://www.wowhead.com/classic/npc=3391/gazlowe",
            "https://www.wowhead.com/classic/item=5080",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Stonetalon Mountains
    [10182] = {
        name = "Rexxar",
        zone = "Stonetalon Mountains",
        coords = "30.2, 76.0",
        alsoIn = { "Desolace", "Feralas" },
        related = { 10204, 4968 },
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
                role = "Beastmaster who finds the wounded orc Byrok with his bear Misha and brings him to Thrall in Orgrimmar, where Byrok tells Thrall about the Burning Blade clan",
            },
            {
                game = "BOOK",
                campaign = "Beyond the Dark Portal",
                missions = {},
                role = "Horde beastmaster; the novel describes him as a half-ogre (chapter 14)",
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
                role = "Rexxar's bear, who helps him find the wounded orc Byrok and carry him to Orgrimmar",
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

    -- ===================================================================== Dustwallow Marsh
    [4968] = {
        name = "Lady Jaina Proudmoore",
        zone = "Dustwallow Marsh",
        coords = "66.2, 49.0",
        appearances = {
            {
                game = "WC3",
                campaign = "The Scourge of Lordaeron (Human)",
                missions = { "Jaina's Meeting", "Ravages of the Plague", "The Cult of the Damned", "March of the Scourge", "The Prince and the Prophet", "The Culling", "Divergent Courses" },
                role = "Hero (sorceress) at Arthas's side: joins him in Jaina's Meeting, urges him to spare her people in Ravages of the Plague, follows him after the Prophet's warning, leaves him in The Culling and tells Uther in Divergent Courses that he has sailed for Northrend",
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
                missions = { "The Last Guardian", "Twilight of the Gods" },
                role = "Allied commander (NPC) at the Battle of Mount Hyjal; arrives with Thrall in The Last Guardian to hear the Prophet's warning, then teleports in and helps Thrall delay Archimonde in Twilight of the Gods",
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
            "https://warcraft.wiki.gg/wiki/The_Prince_and_the_Prophet_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/The_Culling_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/Divergent_Courses_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/Where_Wyverns_Dare_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/The_Oracle_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/By_Demons_Be_Driven_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/The_Last_Guardian_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Twilight_of_the_Gods_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Old_Hatreds_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/A_Blaze_of_Glory_(WC3_Orc)",
            "https://www.wowhead.com/classic/npc=4968",
        },
        confidence = "confirmed",
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
        story = "Do'gol is an ogre of the Stonemaul clan. "
             .. "In Warcraft III: Reforged he appears in the ogre village in Dustwallow Marsh during Old Hatreds, the mission in which Rexxar seeks the ogres' help. "
             .. "In World of Warcraft he is a quest giver in Brackenwall Village, Dustwallow Marsh. "
             .. "There he takes part in parts two to four of the Black Shield quest chain.",
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
        story = "Ogg'marr is an ogre butcher of the Stonemaul clan. "
             .. "In Warcraft III: Reforged he appears in the ogre village in Dustwallow Marsh during Old Hatreds, the mission in which Rexxar seeks the ogres' help. "
             .. "In World of Warcraft he is a vendor in Brackenwall Village, Dustwallow Marsh. "
             .. "He sells meat, drink and cooking recipes.",
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
            {
                game = "BOOK",
                campaign = "The Demon Soul",
                missions = {},
                role = "Young girl who secretly follows Tyrande into battle and shoots the arrow that wounds Xavius, giving Malfurion the opening to confront him (chapters 9, 17, 18, 23)",
            },
            {
                game = "BOOK",
                campaign = "The Sundering",
                missions = {},
                role = "Joins the Sisterhood of Elune under Jarod Shadowsong and drops demons with her arrows in the final battle against Archimonde (chapters 3, 20)",
            },
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Left in charge of Darnassus while Tyrande follows Broll into the Emerald Dream, and gives Tyrande her hippogryph Jai'alator for the journey",
            },
            {
                game = "BOOK",
                campaign = "Wolfheart",
                missions = {},
                role = "Reunites with Jarod Shadowsong in Darnassus, then rallies an army with Tyrande to drive the Horde out of Ashenvale",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Brings a force of Sentinels to defend Theramore, then leads them north into Dustwallow Marsh to find the traitor Thalen Songweaver",
            },
        },
        story = "Shandris Feathermoon is a night elf sentinel who serves the high priestess Tyrande Whisperwind. "
             .. "In the Third War she appears in the Warcraft III night elf campaign: she is with Tyrande when the orcs and humans enter Ashenvale, and she waits for Tyrande at an outpost when the undead attack. "
             .. "She also takes part in the defence of Mount Hyjal. "
             .. "By the time of World of Warcraft she is General of the Sentinel Army and commands Feathermoon Stronghold on Sardor Isle in Feralas, named after her. "
             .. "From there she sends Alliance adventurers to investigate the Hatecrest naga in the Ruins of Solarsal. "
             .. "In the novel Jaina Proudmoore: Tides of War she brings Sentinels to help defend Theramore, then leads them north into Dustwallow Marsh to look for the traitor Thalen Songweaver.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Shandris_Feathermoon",
            "https://warcraft.wiki.gg/wiki/Shandris_(Warcraft_III)",
            "https://warcraft.wiki.gg/wiki/Enemies_at_the_Gate_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Daughters_of_the_Moon_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Twilight_of_the_Gods_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Eternity%27s_End_(WC3_campaign)",
            "https://warcraft.wiki.gg/wiki/The_Ruins_of_Solarsal",
            "https://warcraft.wiki.gg/wiki/The_Demon_Soul",
            "https://warcraft.wiki.gg/wiki/The_Sundering",
            "https://warcraft.wiki.gg/wiki/Stormrage",
            "https://warcraft.wiki.gg/wiki/Wolfheart",
            "https://warcraft.wiki.gg/wiki/Jaina_Proudmoore:_Tides_of_War",
            "https://www.wowhead.com/classic/npc=3936/shandris-feathermoon",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Tirisfal Glades and Western Plaguelands
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

    -- Dustwallow Marsh (Theramore Isle)
    [4965] = {
        name = "Pained",
        zone = "Dustwallow Marsh",
        coords = "66.2, 49.0",
        related = { 4968 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Jaina's night elf bodyguard, who dies when Theramore is destroyed",
            },
        },
        story = "In the novel Jaina Proudmoore: Tides of War, Pained is the night elf bodyguard whom Tyrande assigned to Jaina at the Battle of Mount Hyjal. "
             .. "She stayed with Jaina afterwards because she had never officially been relieved of her duty. "
             .. "In World of Warcraft she is Jaina Proudmoore's night elf bodyguard on Theramore Isle. "
             .. "The novel is set many years later and ends with her death when Theramore is destroyed.",
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
                role = "The headman of Southshore who greets Anduin Lothar and the Stormwind refugees in the first prologue",
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
                role = "Crown prince of Alterac whom the Alliance leaders discuss as heir in chapter 7; in chapter 10 he punches his father Aiden for trading the Book of Medivh to the Horde",
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
        related = { 2425, 2227 },
        appearances = {
            {
                game = "WC3",
                campaign = "Path of the Damned (Undead)",
                missions = { "Into the Realm Eternal", "Key of the Three Moons", "The Fall of Silvermoon" },
                role = "Enemy hero (Ranger) defending Quel'Thalas; turned into a banshee",
            },
            {
                game = "TFT",
                campaign = "Legacy of the Damned (Undead)",
                missions = { "King Arthas", "The Dark Lady", "Dreadlord's Fall", "A New Power in Lordaeron" },
                role = "Playable hero (Dark Ranger)",
            },
            {
                game = "TFT",
                campaign = "Legacy of the Damned (Undead)",
                missions = { "A Kingdom Divided", "Sylvanas' Farewell" },
                role = "Banshee in the story interludes: meets the dreadlords in secret, then ambushes Arthas with a poisoned arrow",
            },
            {
                game = "FK",
                campaign = "Forsaken Kingdom (Undead)",
                missions = { "City of the Dead", "A Scarlet Flame" },
                role = "Leader of the Forsaken; gives the player orders",
            },
            {
                game = "BOOK",
                campaign = "Arthas: Rise of the Lich King",
                missions = {},
                role = "Ranger-General of Silvermoon: fights Arthas' Scourge at the elfgates of Quel'Thalas and falls back with her surviving rangers to the second gate",
            },
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Tormented by the Lich King and betrayed by Varimathras in her Emerald Nightmare dream",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Attends Garrosh Hellscream's Horde leader meeting, opposes his plan to attack Theramore, and gets no support from Lor'themar Theron",
            },
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Warchief of the Horde and queen of the Forsaken, whose trust Anduin must win while she pursues her own schemes",
            },
            {
                game = "BOOK",
                campaign = "A Good War",
                missions = {},
                role = "Leads a Horde army into Darkshore and later duels Malfurion after the two Horde armies rejoin",
            },
            {
                game = "BOOK",
                campaign = "In the Shadow of the Sun",
                missions = {},
                role = "Travels to Sunfury Spire to gain the blood elves' support for the war effort",
            },
            {
                game = "BOOK",
                campaign = "World of Warcraft: Sylvanas",
                missions = {},
                role = "Protagonist: her story from Ranger-General of Silvermoon through her death at Arthas' hands to the founding of the Forsaken",
            },
            {
                game = "BOOK",
                campaign = "War Crimes",
                missions = {},
                role = "Offers to defend Garrosh but is told she would serve better as an accuser, opposes Baine Bloodhoof as defender, and quarrels with him over his defense",
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
            "https://warcraft.wiki.gg/wiki/Into_the_Realm_Eternal_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/Key_of_the_Three_Moons_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/A_Kingdom_Divided_(WC3_Undead)",
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
                missions = { "The Dark Lady" },
                role = "Enemy hero (Dreadlord): offers Sylvanas a place in the dreadlords' new order, then begs for his life and defects to her",
            },
            {
                game = "TFT",
                campaign = "Legacy of the Damned (Undead)",
                missions = { "Dreadlord's Fall", "A New Power in Lordaeron" },
                role = "Playable hero (Dreadlord)",
            },
            {
                game = "FK",
                campaign = "Forsaken Kingdom (Undead)",
                missions = { "City of the Dead", "A Scarlet Flame" },
                role = "Quest NPC: the player reports to him",
            },
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Appears in Sylvanas' Emerald Nightmare dream, where he torments her alongside Arthas (chapter 18)",
            },
            {
                game = "BOOK",
                campaign = "World of Warcraft: Sylvanas",
                missions = {},
                role = "Named by Sylvanas as the one who must supply Putress with whatever he needs for the New Plague (chapter 15)",
            },
            {
                game = "BOOK",
                campaign = "Arthas: Rise of the Lich King",
                missions = {},
                role = "Sylvanas tells him that something has happened with the Lich King and that their plans must be stepped up",
            },
        },
        story = "Varimathras was one of three dreadlords who ruled Lordaeron after Arthas left for Northrend. "
             .. "He secretly made a deal with Sylvanas to overthrow Arthas, and put his own life above the nathrezim code by attacking his brother Balnazzar. "
             .. "On Sylvanas' order he killed Lord Garithos, securing his place among the Forsaken. "
             .. "After the Undercity was founded, he tasked Garek Bandarion and Dark Ranger Anya with putting together a city guard that later became the basis of the Deathguard. "
             .. "In World of Warcraft he stands at Sylvanas' side in the Royal Quarter.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Varimathras",
            "https://warcraft.wiki.gg/wiki/Legacy_of_the_Damned",
            "https://warcraft.wiki.gg/wiki/The_Dark_Lady_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/City_of_the_Dead_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/A_Scarlet_Flame_(WC3_Undead)",
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
                role = "Witnesses Sylvanas refuse Varimathras' invitation to join his new order and wonders whether it would have been prudent to accept (chapter 14)",
            },
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "The first of Sylvanas' trusted counsel to fall in Sylvanas' Emerald Nightmare dream (chapter 18)",
            },
        },
        story = "Sharlindra is one of the banshees in Sylvanas' forces when Sylvanas breaks free of Arthas and turns on the dreadlords. "
             .. "She went with Sylvanas' forces to attack the stronghold of the dreadlord Detheroc. "
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
        related = { 2055 },
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
                role = "Assisted Faranell in showing the effects of the Forsaken Blight to Sylvanas shortly before the War against the Lich King",
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

    -- ===================================================================== Stormwind City
    [1747] = {
        name = "Anduin Wrynn",
        zone = "Stormwind City",
        coords = "77.4, 18.4",
        related = { 1748, 1749 },
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Thirteen-year-old prince staying in Ironforge as a Stormwind diplomat; witnesses King Magni Bronzebeard's petrification and persuades his father Varian to spare Moira Thaurissan (chapter 11)",
            },
            {
                game = "BOOK",
                campaign = "Wolfheart",
                missions = {},
                role = "Declines Varian's suggestion to study under Archbishop Benedictus and chooses to study the Light with the prophet Velen, leaving Stormwind to follow him",
            },
            {
                game = "BOOK",
                campaign = "Prophet's Lesson",
                missions = {},
                role = "Heals the sick among the human refugees outside the Exodar after the Cataclysm and begs Velen to stop the riot between the refugees and the draenei guards",
            },
            {
                game = "BOOK",
                campaign = "Blood of Our Fathers",
                missions = {},
                role = "Reunited with Varian at Queen Tiffin's grave on Remembrance Day; shields his father from Twilight's Hammer assassins and heals him with the Light when a drakonid nearly kills him",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Returns to Stormwind after the attack on Theramore Isle and cries out against Jaina's call to slaughter all orcs",
            },
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "As King of Stormwind, leads the Alliance's debate on Azerite and organizes the Gathering between the Forsaken and their living families in the Arathi Highlands",
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
             .. "In Wolfheart he chose to study the Light with the prophet Velen, and in Blood of Our Fathers he healed his dying father Varian. "
             .. "In Stormrage he suffered nightmares from the Emerald Nightmare, and in Blood Ties he returned to Stormwind without reclaiming his throne. "
             .. "In World of Warcraft he is the young king of Stormwind, with Highlord Bolvar Fordragon acting as regent.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Anduin_Wrynn",
            "https://warcraft.wiki.gg/wiki/Prophet%27s_Lesson",
            "https://warcraft.wiki.gg/wiki/Blood_of_Our_Fathers",
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
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Handpicks Owynn Graddock to accompany Varian and other SI:7 assassins through the Deeprun Tram into Ironforge to liberate it (chapter 30)",
            },
            {
                game = "BOOK",
                campaign = "Blood of Our Fathers",
                missions = {},
                role = "Worries when King Varian is missing before his Remembrance Day speech and joins Marcus Jonathan and Jaina Proudmoore in searching for the king and the prince",
            },
            {
                game = "BOOK",
                campaign = "The Tipping Point",
                missions = {},
                role = "Protects his goblin informants in Undermine, fights Renzik and is let go by him, and gives him a coin to show to Elling Trias, the master of cheese in Stormwind",
            },
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Leader of SI:7; briefs King Anduin Wrynn's advisers on the Azerite information SI:7 gathered, and remains neutral when Anduin proposes the Gathering",
            },
            {
                game = "BOOK",
                campaign = "Elegy",
                missions = {},
                role = "Oversees the SI:7 operation that saturates Orgrimmar with agents and reports the quarrel between Nathanos Blightcaller and Varok Saurfang to Anduin and Genn Greymane",
            },
            {
                game = "BOOK",
                campaign = "Shadows Rising",
                missions = {},
                role = "Travels to Zandalar with Flynn Fairwind to gather intelligence, is captured by the Zandalari, and later brings the prisoner Sira Moonwarden to Stormwind",
            },
            {
                game = "BOOK",
                campaign = "Terror by Torchlight",
                missions = {},
                role = "With Flynn Fairwind, tracks down the necromancer who stole the Torch of Holy Flame in Duskwood and retrieves the torch",
            },
        },
        story = "Mathias Shaw is the leader of Stormwind's intelligence service, SI:7, and a master of spies. "
             .. "In Before the Storm he reports SI:7's findings about Azerite to King Anduin Wrynn's advisers, and he remained neutral when Anduin proposed the Gathering. "
             .. "In the audio short story The Tipping Point he fights the goblin enforcer Renzik in Undermine and gives him a coin to show the master of cheese in Stormwind. "
             .. "In Terror by Torchlight he and Flynn Fairwind recover the Torch of Holy Flame from a necromancer in Duskwood. "
             .. "In World of Warcraft he heads SI:7 from its barracks in Old Town.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Mathias_Shaw",
            "https://warcraft.wiki.gg/wiki/The_Tipping_Point_(short_story)",
            "https://warcraft.wiki.gg/wiki/Terror_by_Torchlight",
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
                campaign = "Blood of Our Fathers",
                missions = {},
                role = "Orders Field Marshal Afrasiabi to stall the crowds while he organizes a search for the missing King Varian, then helps Jaina Proudmoore find the king dying and sees Anduin heal him",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "First to accept King Wrynn's call to support Theramore Isle; he is the main organizer of its defense and is killed when the Horde detonates a mana bomb about 30 years after the Dark Portal opened",
            },
        },
        story = "General Marcus Jonathan was the high commander of Stormwind Defense. "
             .. "During the War Against the Nightmare in Stormrage he sent Major Mattingly for reinforcements. "
             .. "In the short story Blood of Our Fathers he organized the search for King Varian when the king went missing before his Remembrance Day speech. "
             .. "In Jaina Proudmoore: Tides of War he organized the defense of Theramore Isle and was killed when the Horde detonated a mana bomb to destroy the city.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/General_Marcus_Jonathan",
            "https://warcraft.wiki.gg/wiki/Blood_of_Our_Fathers",
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
                role = "Gains a new squire, Winthrop, about 42 years after the Dark Portal opened; at Light's Hope Chapel, Winthrop and Arator the Redeemer clean his armor while he speaks with other paladins",
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
                role = "Leader of the Church of the Holy Light in Stormwind; leads the memorial service at the Cathedral of Light for the fallen of the war against the Lich King (chapter 6)",
            },
            {
                game = "BOOK",
                campaign = "Blood of Our Fathers",
                missions = {},
                role = "Counsels King Varian on Remembrance Day and gives him the key to Queen Tiffin's locket at her grave, shortly before Twilight's Hammer assassins attack",
            },
            {
                game = "BOOK",
                campaign = "Thrall: Twilight of the Aspects",
                missions = {},
                role = "As the Twilight Father, leads the Twilight's Hammer at Wyrmrest Temple, captures the blue dragon Kirygosa, and is cast down when Chromatus falls",
            },
        },
        story = "Archbishop Benedictus was the leader of the Church of the Holy Light and succeeded Archbishop Alonsus Faol before the Third War. "
             .. "The fall of Lordaeron and the appearance of the Scourge pushed his faith to the breaking point. "
             .. "In The Shattering he led the memorial service at the Cathedral of Light for the fallen of the war against the Lich King. "
             .. "In the short story Blood of Our Fathers he counsels King Varian and gives him the key to Queen Tiffin's locket, shortly before Twilight's Hammer assassins attack. "
             .. "In the novel Thrall: Twilight of the Aspects he is the Twilight Father, the leader of the Twilight's Hammer.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Archbishop_Benedictus",
            "https://warcraft.wiki.gg/wiki/Blood_of_Our_Fathers",
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
             .. "She later tended to the body of Anduin's servant Wyll Benton for his funeral.",
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
             .. "He is very concerned about the kobolds to the north and the gnolls and thieves to the west. "
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
        related = { 1749 },
        appearances = {
            {
                game = "BOOK",
                campaign = "We Ride Forth",
                missions = {},
                role = "As the Lich King, he is confronted by the Four Horsemen over his increasingly militant actions",
            },
        },
        story = "Bolvar Fordragon served as Highlord and Regent of Stormwind while King Varian Wrynn was missing. "
             .. "In World of Warcraft he rules Stormwind Keep as regent for the young Anduin Wrynn. "
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
                role = "Enforcer of Trade Prince Mozzy Gloxscorn in Undermine, who fights Mathias Shaw and lets him go",
            },
            {
                game = "BOOK",
                campaign = "Elegy",
                missions = {},
                role = "SI:7's chief spy in Orgrimmar, watching the Horde disguised as a merchant near Grommash Hold",
            },
        },
        story = "Renzik is a goblin from Undermine who became the right hand of Trade Prince Mozzy Gloxscorn in the Krackslagger Cartel. "
             .. "In the short story The Tipping Point he fights Mathias Shaw and lets him go. "
             .. "He later left Undermine behind for Stormwind, and in the novella Elegy he is SI:7's spy in Orgrimmar. "
             .. "In World of Warcraft he works for SI:7 in the Old Town of Stormwind City.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Renzik_%22The_Shiv%22",
            "https://warcraft.wiki.gg/wiki/The_Tipping_Point_(short_story)",
            "https://warcraft.wiki.gg/wiki/Elegy",
            "https://www.wowhead.com/classic/npc=6946",
        },
        confidence = "confirmed",
    },

    [2784] = {
        name = "King Magni Bronzebeard",
        zone = "Ironforge",
        coords = "39.4, 55.8",
        related = { 7937 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Tides of Darkness",
                missions = {},
                role = "Dwarf king who defends Ironforge during the Siege of Ironforge in the Second War and pledges the kingdom's support to the Alliance of Lordaeron after its liberation",
            },
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "King of Ironforge who performs a ritual from a tablet from Ulduar in Old Ironforge to commune with Azeroth and is turned into diamond",
            },
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Former king and Herald of Azeroth who recruits Alliance and Horde leaders to help restore Azeroth after Sargeras's destruction, meeting Warchief Sylvanas Windrunner and Baine Bloodhoof in Thunder Bluff",
            },
            {
                game = "BOOK",
                campaign = "Blood Ties",
                missions = {},
                role = "Attends the wedding of Turalyon and Alleria Windrunner with his family in chapter 17",
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
        related = { 2784 },
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Herbalism trainer in the Great Forge who follows instructions from a tablet from Ulduar to make a liquid meant for Magni to communicate with Azeroth",
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
        related = { 7312 },
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Gnome mage, sister of Dink, who is caught by Dark Iron guards when Moira Thaurissan arrives in Ironforge and is released when Ironforge dwarves attack them",
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
                role = "Gnome mage, brother of Bink, who is caught by Dark Iron guards when Moira Thaurissan arrives in Ironforge and is released when Ironforge dwarves attack them",
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
        related = { 7800 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Beyond the Dark Portal",
                missions = { "Chapter 5" },
                role = "Gnome engineer who keeps General Turalyon informed about the Deeprun Tram project and a problem with rats",
            },
            {
                game = "BOOK",
                campaign = "Cut Short",
                missions = {},
                role = "High Tinker who leads the gnomes' push to retake Gnomeregan, survives Sicco Thermaplugg's trap in his old quarters in Sector 17 and turns his trap so that it cuts Thermaplugg in half",
            },
            {
                game = "BOOK",
                campaign = "Wolfheart",
                missions = {},
                role = "High Tinker of Gnomeregan who represents the gnomes at a meeting in Darnassus, makes peace with Drukan and votes to accept Gilneas into the Alliance (chapters 9, 10 and 29)",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Alliance leader who plans a counterattack against the Horde blockade of Kalimdor in Stormwind after the Attack on Theramore Isle (chapter 23)",
            },
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Gnome engineer who studies Azerite samples and sends Sapphronetta Flivvers to Silithus, and meets Magni Bronzebeard in Ironforge (chapters 8 and 14)",
            },
            {
                game = "BOOK",
                campaign = "War Crimes",
                missions = { "Chapter 2" },
                role = "Joins the Horde and Alliance leaders who meet before Garrosh Hellscream's trial and mocks Jastor Gallywix's call for compensation",
            },
        },
        story = "Gelbin Mekkatorque is the High Tinker of Gnomeregan and a brilliant gnomish inventor. "
             .. "After the Second War, King Magni asked him for a faster solution to the slow travel to and from the north, and he prepared the schematics for the Deeprun Tram. "
             .. "The gnomish electorate later chose him as High Tinker, and his friend Sicco Thermaplugg became his chief advisor, though Thermaplugg coveted the role of High Tinker. "
             .. "In the short story Cut Short he leads the gnomes' push to retake Gnomeregan and survives Thermaplugg's trap in his old quarters. "
             .. "In the novels he takes part in Alliance politics, including the vote on Gilneas and the planning after the Attack on Theramore Isle.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Gelbin_Mekkatorque",
            "https://warcraft.wiki.gg/wiki/Beyond_the_Dark_Portal",
            "https://warcraft.wiki.gg/wiki/Cut_Short",
            "https://warcraft.wiki.gg/wiki/Wolfheart",
            "https://warcraft.wiki.gg/wiki/Jaina_Proudmoore:_Tides_of_War",
            "https://warcraft.wiki.gg/wiki/Before_the_Storm",
            "https://warcraft.wiki.gg/wiki/War_Crimes",
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
                role = "High priest of Ironforge and priest trainer in the Hall of Mysteries; heals Anduin Wrynn, witnesses Magni's petrification, and backs Moira Thaurissan as heir (chapters 11, 14, 15 and 31)",
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
                role = "The judge who declares Greydon Thorne dead two years after he leaves his family, so that Ceya Northbrooke can marry Robb Glade (chapter 12)",
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
                role = "Commander of the Night Watch in the short story: found mortally wounded after confronting the Necromancer who stole the Torch of Holy Flame in the Forlorn Rowe; later thanks Shaw and Fairwind at the Scarlet Raven Tavern",
            },
        },
        story = "Sarah Ladimore is the daughter of Morgan Ladimore and the only survivor of her family. "
             .. "She became a Watcher of the Night Watch. "
             .. "In Terror by Torchlight, by which time she had succeeded Althea Ebonlocke as Commander of the Watch, she was found mortally wounded after confronting the Necromancer, and Mathias Shaw and Flynn Fairwind recovered the Torch of Holy Flame.",
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
                role = "Night Watch member: watches over the ailing Commander Ladimore while Shaw and Fairwind retrieve the torch and defeat the necromancer",
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
                role = "Remembered as the dead lich of the Forlorn Rowe; the stolen Torch of Holy Flame is placed outside his old house",
            },
        },
        story = "Morbent Fel was a human necromancer who ruled over the undead of Duskwood from his house atop the Forlorn Rowe in Raven Hill Cemetery. "
             .. "He was an ally of the Dark Riders and was responsible for raising the undead in Duskwood. "
             .. "In World of Warcraft he is guarded by his undead minions and a magical barrier, which had to be removed with Morbent's Bane before he could be defeated.",
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
                role = "Sponsor, engineer and pilot of the speedboat Guzzler: second place in the Annual Fizzle and Pozzik's Speedbarge Boat Race, then led the protest against the result with Fizzle Brassbolts",
            },
        },
        story = "Razzeric is an independent goblin pilot at the Mirage Raceway in the Shimmering Flats in Thousand Needles. "
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
        related = { 4454 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Pilot of the Annihilator in the Annual Fizzle and Pozzik's Speedbarge Boat Race (chapter 28)",
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
                role = "Engineer of the Freebooters' Fire in the Annual Speedbarge Boat Race, with teammates Tony Two-Tusk and Rugfizzle",
            },
        },
        story = "Jinky is a neutral vendor at the Mirage Raceway in Thousand Needles. "
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
        related = { 4706 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Avid MEGA member who led the protest with Razzeric after the Annual Speedbarge Boat Race",
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
                role = "Racer, boat pilot and singer at the Speedbarge and a friend of Rendow; Aram meets her in chapter 24 and learns that winning the annual boat race earns salvage rights",
            },
        },
        story = "Daisy was originally the race starter girl at the Mirage Raceway in the Shimmering Flats in Thousand Needles. "
             .. "In the novel Traveler: The Spiral Path, set after the Cataclysm, Aram meets her at the Speedbarge and learns that winning the Annual Fizzle and Pozzik's Speedbarge Boat Race earns permission to salvage the flooded wrecks. "
             .. "She is a singer and a friend of Rendow, and she also races and pilots boats at the Speedbarge.",
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
                role = "Talithar Swiftwind's estranged wife, who tells the dwarf Baenan of her longing for her husband; Talithar asks Baenan to bring her their wedding rings",
            },
        },
        story = "Vyrin Swiftwind is a high elf married to Talithar Swiftwind, though the two became estranged after the fall of the high elves following the Third War. "
             .. "Talithar embraced the teachings of Prince Kael'thas for the sake of his people, while Vyrin chose her integrity and went to live at the Farstrider Lodge. "
             .. "In the novella Quest for Pandaria, Talithar helps the dwarf Baenan escape the Horde destroyer Warchief's Fist and asks him to give Vyrin their wedding rings with the message that he never stopped loving her. "
             .. "Talithar later sacrificed himself to save Baenan and Chen Stormstout, and Baenan chose to name him a hero. "
             .. "In World of Warcraft she is a quest giver at the Farstrider Lodge in Loch Modan.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Vyrin_Swiftwind",
            "https://warcraft.wiki.gg/wiki/Quest_for_Pandaria",
            "https://www.wowhead.com/classic/npc=1156",
        },
        confidence = "confirmed",
    },

    [3679] = {
        name = "Naralex",
        zone = "Wailing Caverns",
        related = { 5769, 3516 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "A druid who discovers Fandral Staghelm's corruption, is silenced with Hamuul Runetotem and Shandris Feathermoon, and is later freed by Malfurion",
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

    -- ===================================================================== Scarlet Monastery
    [3976] = {
        name = "Scarlet Commander Mograine",
        zone = "Scarlet Monastery",
        related = { 3977 },
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
                role = "Four Horsemen member in the short story: Darion Mograine orders her and Nazgrim to rescue Bolvar Fordragon after the Scourge slips out of control",
            },
        },
        story = "Sally Whitemane was a human priestess of the Light who became High Inquisitor of the Scarlet Crusade, directing its activities from the Scarlet Monastery's Cathedral. "
             .. "Nearly one year after the Forsaken secured the Undercity, she and Renault Mograine launched an all-out assault on the Forsaken, and Whitemane attacked the Forsaken settlements in Tirisfal Glades. "
             .. "She and Renault were forced to pull back by Garek Bandarion, Dark Ranger Anya and, in Whitemane's case, Leonid Barthalomew, and the crusaders retreated to the Scarlet Monastery. "
             .. "In World of Warcraft she is the final boss of the Scarlet Monastery.",
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
                role = "Self-styled king of Gnomeregan who traps Gelbin Mekkatorque in his old quarters and attacks him in a battle suit until Gelbin's trap cuts Thermaplugg in half",
            },
        },
        story = "In his youth, Sicco Thermaplugg was the closest friend of Gelbin Mekkatorque, and Gelbin later employed him at his foundry. "
             .. "Sicco resented Gelbin for being elected High Tinker of Gnomeregan and believed the gnomes should use their inventions to expand their power instead of trading them to allies. "
             .. "Gelbin kept Sicco in a prominent role in the Tinkers' Court despite his flawed work, and Sicco went on to serve as Gelbin's chief advisor for many years. "
             .. "In the short story Cut Short he sets a trap for Gelbin in his old quarters in Sector 17 and attacks him in a battle suit, but Gelbin's trap cuts him in half, his battle suit saves his life, and Gelbin leaves him for dead. "
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
                role = "Mentioned in the novel: she shaped most of the thorn dome of Razorfen Downs and trained Chugara Razorflank to maintain it",
            },
        },
        story = "Charlga Razorflank is the quilboar shaman who leads the Razorfen tribe from Razorfen Kraul. "
             .. "She is the public figurehead of the Death's Head tribe, although Amnennar the Coldbringer ultimately controls it. "
             .. "Under her rule the quilboar drove the tauren out of the southern Barrens. "
             .. "The novel Traveler: The Spiral Path says she shaped most of the thorn dome of Razorfen Downs and trained Chugara Razorflank to maintain it. "
             .. "The novel also states that Chugara later surrendered Razorfen to the Death's Head tribe.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Charlga_Razorflank",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://www.wowhead.com/classic/npc=4421",
        },
        confidence = "confirmed",
    },

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
                role = "Grand Apothecary Putress' apothecary who demonstrates the New Plague to Sylvanas with two prisoners",
            },
            {
                game = "BOOK",
                campaign = "World of Warcraft: Sylvanas",
                missions = {},
                role = "Subordinate of Grand Apothecary Putress",
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
                role = "Forsaken former historian of Lordaeron, titled Governor in chapter 19 and a member of the Desolate Council; reunited with his daughter Philia at the Gathering and killed in chapter 34",
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

    [4046] = {
        name = "Magatha Grimtotem",
        zone = "Thunder Bluff",
        coords = "70.2, 30.8",
        related = { 11833 },
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
        related = { 2993 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Archdruid who becomes a close friend of Broll and is among the archdruids summoned to Teldrassil",
            },
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Archdruid in Orgrimmar; sends messages to the Cenarion Circle and discusses Garrosh's rebuilt Orgrimmar with Cairne Bloodhoof at Red Rocks",
            },
            {
                game = "BOOK",
                campaign = "As Our Fathers Before Us",
                missions = {},
                role = "Baine Bloodhoof asks him about the Quilboar attacks on the water caravans to Orgrimmar",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Steps in to aid Baine Bloodhoof when Baine and Garrosh confront each other over the attack on Theramore, until both are ordered to stand down",
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

    [11833] = {
        name = "Rahauro",
        zone = "Thunder Bluff",
        coords = "70.0, 29.2",
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
                role = "Victim: killed by the Grimtotem tribe after Cairne Bloodhoof's death",
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

    [3144] = {
        name = "Eitrigg",
        zone = "Orgrimmar",
        coords = "34.2, 39.0",
        related = { 4949 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Of Blood and Honor",
                missions = {},
                role = "Blackrock orc who meets Thrall and leaves with his people to return to their shamanistic roots",
            },
            {
                game = "BOOK",
                campaign = "Jaina Proudmoore: Tides of War",
                missions = {},
                role = "Opposes Garrosh Hellscream's plan to conquer Kalimdor at the Horde leaders' meeting, with Baine Bloodhoof's support",
            },
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Accompanies Thrall to Dustwallow Marsh, becomes one of Garrosh's advisers and warns Garrosh that Magatha has staged a coup",
            },
            {
                game = "BOOK",
                campaign = "War Crimes",
                missions = {},
                role = "Goes with Go'el and Varok to Garrosh's trial, where he declines to be Garrosh's defender and backs the choice of Baine instead",
            },
            {
                game = "BOOK",
                campaign = "Heartlands",
                missions = {},
                role = "Advises Overlord Geya'rah to stand down during a clash with Stromgarde, and later joins the allied armies before Stromgarde Keep",
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
                role = "Remains at Warsong Hold as leader of the Warsong Offensive and the Horde Expedition after Cairne Bloodhoof visits Garrosh",
            },
            {
                game = "BOOK",
                campaign = "War Crimes",
                missions = {},
                role = "Goes with Go'el and Eitrigg to Garrosh's trial, agrees with Baine as defender, and testifies as Tyrande's third witness about his conflicts with Garrosh in Northrend",
            },
            {
                game = "BOOK",
                campaign = "A Good War",
                missions = {},
                role = "Leads the Horde's attack on Darnassus in the War of the Thorns, lets Malfurion and Tyrande go, and watches Sylvanas burn Teldrassil",
            },
        },
        story = "Varok Saurfang was a renowned Blackrock orc warrior, the younger brother of Broxigar, and second-in-command to Warchief Orgrim Doomhammer. "
             .. "In the novel The Shattering: Prelude to Cataclysm, Cairne Bloodhoof traveled to Warsong Hold to meet Garrosh, and Saurfang was to stay there as leader of the Warsong Offensive and the Horde Expedition. "
             .. "In World of Warcraft he is High Overlord Saurfang, leader of the Kor'kron Guard, and during the war against Ahn'Qiraj he is Supreme Commander of the Might of Kalimdor.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Varok_Saurfang",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://warcraft.wiki.gg/wiki/War_Crimes",
            "https://warcraft.wiki.gg/wiki/A_Good_War",
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
                role = "Smith at the Burning Anvil in Orgrimmar; keeps High Overlord Saurfang's letter promising replacement Azerite after an explosion",
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
                role = "Shopkeeper arrested and beaten by Malkorok and Kor'kron soldiers for not fully supporting Garrosh Hellscream",
            },
            {
                game = "BOOK",
                campaign = "War Crimes",
                missions = {},
                role = "Called as the second witness at Garrosh's trial, where the court sees Malkorok's attack on him in a vision",
            },
        },
        story = "In the novel Jaina Proudmoore: Tides of War, Malkorok and a few Kor'kron soldiers attacked Kor'jus when his shop was closed, because he was not fully supportive of Garrosh Hellscream. "
             .. "They arrested and beat him, and he returned to his shop after a few days. "
             .. "In the novel War Crimes, he was called as the second witness at Garrosh's trial. "
             .. "In World of Warcraft he is a Mushroom Vendor in Orgrimmar.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Kor%27jus",
            "https://warcraft.wiki.gg/wiki/Jaina_Proudmoore:_Tides_of_War",
            "https://warcraft.wiki.gg/wiki/War_Crimes",
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
                role = "Innkeeper of the inn in Razor Hill who serves Malkorok and his Kor'kron soldiers, vanishes during their visit, and the inn explodes after they leave",
            },
            {
                game = "BOOK",
                campaign = "War Crimes",
                missions = {},
                role = "Shown in a vision at Garrosh's trial, where he maintains that he knew nothing about the inn explosion",
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
                campaign = "The Judgment",
                missions = {},
                role = "Vol'jin's childhood best friend; he joins Vol'jin in First Home to be tested by the loa and emerges a witch doctor",
            },
        },
        story = "In the short story The Judgment, Zalazane grew up as the best friend of Vol'jin, who was the son of the Darkspear chieftain Sen'jin. "
             .. "The two young trolls were tested by the loa at First Home, and Zalazane became a witch doctor under Master Gadrin. "
             .. "In World of Warcraft he became the Hexmaster and Traitor of the Darkspears, and used dark voodoo to rob most of the Darkspear trolls of their free will. "
             .. "He declared himself ruler of the Echo Isles, and the Darkspears and their allies often struck at his holdings there.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Zalazane",
            "https://warcraft.wiki.gg/wiki/The_Judgment",
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
                role = "Ally whom Malfurion Stormrage contacts for help against the Nightmare Lord when the Emerald Nightmare attacks Azeroth",
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
                role = "Explains the reasons for quilboar aggression to Baine Bloodhoof",
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
                role = "Silverwing Sentinel scout under Su'ura Swiftarrow who survives the Horde invasion of Ashenvale, saves Su'ura from Garrosh Hellscream, and turns down a commission afterwards",
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
        coords = "90.3, 40.1",
        alsoIn = { "Duskwood", "Feralas", "The Hinterlands" },
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Corrupted green dragon and servant of the Nightmare; one of the major antagonists of the War Against the Nightmare, who is disintegrated when Tyrande tries to cleanse her",
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
        coords = "90.3, 40.1",
        alsoIn = { "Duskwood", "Feralas", "The Hinterlands" },
        related = { 14889 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "One of Ysera's wayward dragons and a strong servant of the Nightmare; attacks Ysera, Tyrande, Broll Bearmantle, Eranikus and Gnarl, and is torn apart when he is pulled into the boundary between the Emerald Dream and Azeroth",
            },
        },
        story = "Lethon is one of Ysera's wayward dragon lieutenants and was among the strongest servants of the Nightmare. "
             .. "In the novel Stormrage he attacks Ysera, Tyrande Whisperwind, Broll Bearmantle, Eranikus and Gnarl during the War Against the Nightmare. "
             .. "He tries to corrupt Eranikus alongside Emeriss, and is forced to retreat when Alexstrasza arrives. "
             .. "Later he ambushes Malfurion Stormrage and Eranikus as they try to free Ysera from the Eye. "
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
                role = "Dryad guardian who warns the other guardians about the shadow attackers of the Emerald Nightmare, then falls asleep herself (chapter 11)",
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
                role = "A former young human alchemist who serves Sylvanas and oversees the attack on Gilneas alongside Garrosh Hellscream",
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

    [1749] = {
        name = "Lady Katrana Prestor",
        zone = "Stormwind City",
        coords = "77.6, 18.6",
        appearances = {
            {
                game = "BOOK",
                campaign = "Beyond the Dark Portal",
                missions = { "Chapter 8" },
                role = "As the dragon Onyxia, ordered by Deathwing to win over the Blackrock orcs",
            },
            {
                game = "BOOK",
                campaign = "Visage Day",
                missions = {},
                role = "As the dragon Onyxia, receives the bronze dragon Chronormu in the Obsidian Dragonshrine, tells him a visage is only a tool for hunting mortals, and later attends his Visage Day ceremony at Wyrmrest Temple",
            },
        },
        story = "Lady Katrana Prestor is the black dragon Onyxia, daughter of Deathwing, in human form. "
             .. "In the novel Beyond the Dark Portal, Deathwing orders Onyxia and her brother Nefarian to secure the orcs of Blackrock Spire as their new force. "
             .. "As Lady Prestor she rose to be one of Stormwind's highest nobles and kept aid from reaching the lands near the Burning Steppes, where Nefarian held power. "
             .. "When King Varian vanished, she had the boy Anduin crowned and steered the regent Bolvar Fordragon with the Dragon's Eye. "
             .. "In the short story Visage Day she tells the bronze dragon Chronormu that a mortal form is only a tool for taking what a dragon wants. "
             .. "In World of Warcraft she is the royal councilor in Stormwind Keep and advises Bolvar against sending troops to Lakeshire.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Onyxia",
            "https://warcraft.wiki.gg/wiki/Beyond_the_Dark_Portal",
            "https://warcraft.wiki.gg/wiki/Visage_Day_(short_story)",
            "https://warcraft.wiki.gg/wiki/The_True_Masters_(3)",
            "https://www.wowhead.com/classic/npc=1749",
        },
        confidence = "confirmed",
    },

    [482] = {
        name = "Elling Trias",
        zone = "Stormwind City",
        coords = "60.0, 64.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Tipping Point",
                missions = {},
                role = "Meets Mathias Shaw in the cellar beneath Trias' Cheese to plan the protection of SI:7's informants in Undermine; Shaw tells Renzik to show a coin to him as the \"master of cheese\"",
            },
        },
        story = "Elling Trias runs Trias' Cheese in the Trade District with his wife Elaine and son Ben, but he is more than a cheesemaker and has contacts from SI:7 to Hearthglen. "
             .. "In the audio short story The Tipping Point, Mathias Shaw meets him in the cellar beneath his shop to plan how to protect SI:7's informants in Undermine, and later gives Renzik a coin to show the master of cheese if he ever comes to Stormwind. "
             .. "In World of Warcraft he is a contact in quest chains such as The Missing Diplomat, and he orders the killing of the traitor Lord Gregor Lescovar.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Elling_Trias",
            "https://warcraft.wiki.gg/wiki/The_Tipping_Point_(short_story)",
            "https://warcraft.wiki.gg/wiki/Renzik_%22The_Shiv%22",
            "https://warcraft.wiki.gg/wiki/Lord_Gregor_Lescovar",
            "https://www.wowhead.com/classic/npc=482",
        },
        confidence = "confirmed",
    },

    [1646] = {
        name = "Baros Alexston",
        zone = "Stormwind City",
        coords = "49.0, 30.2",
        appearances = {
            {
                game = "BOOK",
                campaign = "Blood of Our Fathers",
                missions = {},
                role = "The architect rebuilding Stormwind after Deathwing's attack",
            },
        },
        story = "Baros Alexston grew up on the Alexston Farmstead in Westfall and worked with Edwin VanCleef in the Stonemasons' Guild to rebuild Stormwind after the First War. "
             .. "When the House of Nobles refused to pay the guild and VanCleef led the stonemasons out in rebellion, Baros took the post of city architect instead and made an enemy of his old friend. "
             .. "In World of Warcraft he works in Stormwind's City Hall in Cathedral Square. "
             .. "In the short story Blood of Our Fathers, set after Deathwing's attack on Stormwind, he oversees the rebuilding of the city and keeps King Varian informed of its progress and price.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Baros_Alexston",
            "https://warcraft.wiki.gg/wiki/Blood_of_Our_Fathers",
            "https://www.wowhead.com/classic/npc=1646",
        },
        confidence = "confirmed",
    },

    [2708] = {
        name = "Archmage Malin",
        zone = "Stormwind City",
        coords = "39.8, 80.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Elegy",
                missions = {},
                role = "Holds portals open for night elf refugees from Teldrassil",
            },
        },
        story = "Archmage Malin stands outside the Wizard's Sanctum in Stormwind's Mage Quarter, and Archmage Trelane was his first master. "
             .. "In World of Warcraft he sends agents to the Arathi Highlands to gather reagents and recover Trelane's belongings. "
             .. "In the novella Elegy, set during the War of the Thorns, he holds portals open at the Wizard's Sanctum for night elf refugees fleeing to Stormwind. "
             .. "King Anduin has him send word to Dalaran asking its mages to help speed up the evacuation.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Archmage_Malin",
            "https://warcraft.wiki.gg/wiki/Elegy",
            "https://www.wowhead.com/classic/npc=2708",
        },
        confidence = "confirmed",
    },


    -- ===================================================================== Ironforge
    [1573] = {
        name = "Gryth Thurden",
        zone = "Ironforge",
        coords = "55.5, 47.7",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Ironforge gryphon master who tells Anduin Wrynn about Moira's gryphon quarantine",
            },
        },
        story = "Gryth Thurden is a dwarf gryphon flight master at the Great Forge in Ironforge. "
             .. "In The Shattering, Moira Thaurissan claims the gryphons are sick and has them quarantined outside the city. "
             .. "Gryth has no choice but to obey, since one of his gryphons had already been injured by a Dark Iron. "
             .. "He explains all of this to Prince Anduin Wrynn, who realizes that Moira is isolating Ironforge.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Gryth_Thurden",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://www.wowhead.com/classic/npc=1573",
        },
        confidence = "confirmed",
    },

    [2918] = {
        name = "Advisor Belgrum",
        zone = "Ironforge",
        coords = "76.8, 10.4",
        related = { 2784 },
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Explorers' League dwarf who helps Muninn Magellas decipher the tablet from Ulduar, speaks at Magni's ritual and fills in as head of Ironforge's government after Magni is petrified",
            },
        },
        story = "Advisor Belgrum is a dwarf and a member of the Explorers' League. "
             .. "As an advisor to Magni Bronzebeard, he gives orders on the King's authority. "
             .. "In World of Warcraft he stands in the Library of the Hall of Explorers, where he acts on Historian Karnik's warning about the Shadowforge dwarves in Uldaman and sends adventurers back for the Tablet of Will. "
             .. "In the novel The Shattering, he fills in as head of Ironforge's government for a while after Magni turns to stone.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Advisor_Belgrum",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://www.wowhead.com/classic/npc=2918",
        },
        confidence = "confirmed",
    },

    [5387] = {
        name = "High Explorer Magellas",
        zone = "Ironforge",
        coords = "69.9, 18.2",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Head of the Explorers' League who tries to decipher the tablet from Ulduar and translates the unknown language of Magni's ritual for Anduin Wrynn",
            },
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Meets Magni Bronzebeard in the Hall of Explorers and agrees to send an Explorers' League team to Silithus to study Azerite (chapter 8)",
            },
        },
        story = "High Explorer Muninn Magellas leads the Explorers' League from the Library of the Hall of Explorers in Ironforge. "
             .. "He maps the world and catalogues its relics for the dwarves, and he is excited when an adventurer brings him platinum discs from Uldaman. "
             .. "In the novel The Shattering, he tries to decipher the phrases of a tablet from Ulduar and translates the unknown language of Magni's ritual in Old Ironforge for Anduin Wrynn. "
             .. "In the novel Before the Storm, he agrees to send a team from the Explorers' League to Silithus after Magni speaks about Azerite.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/High_Explorer_Muninn_Magellas",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://warcraft.wiki.gg/wiki/Before_the_Storm",
            "https://www.wowhead.com/classic/npc=5387",
        },
        confidence = "confirmed",
    },

    [5159] = {
        name = "Daryl Riknussun",
        zone = "Ironforge",
        coords = "60.2, 37.1",
        appearances = {
            {
                game = "BOOK",
                campaign = "The War Effort",
                missions = {},
                role = "Helps Saegan clean and cook fish supplies for the Ahn'Qiraj War",
            },
        },
        story = "Daryl Riknussun is a dwarf cooking trainer in Ironforge. "
             .. "In The War Effort, he helps Saegan clean and cook fish supplies for the Ahn'Qiraj War. "
             .. "The supplies are to be delivered to Huntress Swiftriver.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Daryl_Riknussun",
            "https://warcraft.wiki.gg/wiki/The_War_Effort",
            "https://www.wowhead.com/classic/npc=5159",
        },
        confidence = "confirmed",
    },
    [15457] = {
        name = "Huntress Swiftriver",
        zone = "Ironforge",
        coords = "71.2, 69.7",
        appearances = {
            {
                game = "BOOK",
                campaign = "The War Effort",
                missions = {},
                role = "Waits for the fish that Saegan and Daryl Riknussun prepare for the Ahn'Qiraj war effort, which Saegan carries to the Military Ward",
            },
        },
        story = "Huntress Swiftriver is a night elf quest giver in the Military Ward of Ironforge. "
             .. "During the war effort before the Ahn'Qiraj War she gathers spotted yellowtail fish, aiming for 17,000, to feed the soldiers. "
             .. "In the short story The War Effort, the fish that Saegan and Daryl Riknussun prepare are meant for her.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Huntress_Swiftriver",
            "https://warcraft.wiki.gg/wiki/The_War_Effort",
            "https://www.wowhead.com/classic/npc=15457",
        },
        confidence = "confirmed",
    },


    -- ===================================================================== Durotar
    [3188] = {
        name = "Master Gadrin",
        zone = "Durotar",
        coords = "56.0, 74.6",
        related = { 10540, 3205 },
        appearances = {
            {
                game = "BOOK",
                campaign = "The Judgment",
                missions = {},
                role = "Mentor of Vol'jin and Zalazane: after their return from First Home he tells them they were gone three months, confirms the death of Sen'jin and takes over the evacuation",
            },
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Present at Spirit Rise in Thunder Bluff beside Baine Bloodhoof when Magni Bronzebeard arrives to speak about healing Azeroth (chapter 12)",
            },
        },
        story = "Master Gadrin is an elderly jungle troll and the chief witch doctor of the Darkspear tribe, based in Sen'jin Village in Durotar. "
             .. "He was the mentor of Vol'jin and Zalazane, and after they returned from First Home he told them about the death of Sen'jin. "
             .. "In World of Warcraft he sends adventurers to retrieve Minshina's skull in the Echo Isles and to fight Zalazane's minions. "
             .. "In the novel Before the Storm he stood beside Baine Bloodhoof at Spirit Rise in Thunder Bluff.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Master_Gadrin",
            "https://warcraft.wiki.gg/wiki/The_Judgment",
            "https://warcraft.wiki.gg/wiki/Before_the_Storm",
            "https://www.wowhead.com/classic/npc=3188/master-gadrin",
        },
        confidence = "confirmed",
    },

-- ===================================================================== The Barrens
    [3387] = {
        name = "Jorn Skyseer",
        zone = "The Barrens",
        coords = "44.8, 59.0",
        related = { 2993 },
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Gives shelter to Baine Bloodhoof and his loyal forces in Thunder Bluff after Magatha Grimtotem takes control of the city (chapter 22)",
            },
        },
        story = "Jorn Skyseer is a tauren hunter at Camp Taurajo in the Barrens. "
             .. "There he serves as a guide and mentor to Horde adventurers as they train in the wilds of the Barrens. "
             .. "In the novel The Shattering: Prelude to Cataclysm, he gives shelter and help to Baine Bloodhoof and his loyal forces when Magatha Grimtotem seizes Thunder Bluff.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Jorn_Skyseer",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://www.wowhead.com/classic/npc=3387/jorn-skyseer",
        },
        confidence = "confirmed",
    },

    [3453] = {
        name = "Wharfmaster Dizzywig",
        zone = "The Barrens",
        coords = "63.2, 38.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Night of the Dragon",
                missions = {},
                role = "Provides boat transport to the night elf Velinde Starsong, and later to the draenei Iridi when she comes through Ratchet to buy a boat",
            },
        },
        story = "Wharfmaster Dizzywig is a goblin dockmaster in Ratchet in the Barrens. "
             .. "In the novel Night of the Dragon he provided transport for Velinde Starsong, and later for Iridi when she came through Ratchet to purchase a boat. "
             .. "In World of Warcraft he runs the docks of Ratchet and gives quests such as Southsea Freebooters and Passage to Booty Bay.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Wharfmaster_Dizzywig",
            "https://warcraft.wiki.gg/wiki/Night_of_the_Dragon",
            "https://www.wowhead.com/classic/npc=3453/wharfmaster-dizzywig",
        },
        confidence = "confirmed",
    },



    -- ===================================================================== Thunder Bluff
    [3032] = {
        name = "Beram Skychaser",
        zone = "Thunder Bluff",
        coords = "22.2, 19.0",
        related = { 3057 },
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Killed by the Grimtotem tribe after Cairne Bloodhoof's death",
            },
        },
        story = "In World of Warcraft Beram Skychaser is a tauren shaman trainer on Spirit Rise in Thunder Bluff. "
             .. "Years later, in the time of the novel The Shattering: Prelude to Cataclysm, he blesses Cairne Bloodhoof's runespear for the mak'gora duel against Garrosh Hellscream. "
             .. "After Cairne's death he is killed by the Grimtotem tribe.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Beram_Skychaser",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://www.wowhead.com/classic/npc=3032",
        },
        confidence = "confirmed",
    },

    [3030] = {
        name = "Siln Skychaser",
        zone = "Thunder Bluff",
        coords = "23.0, 20.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Mentioned: killed by the Grimtotem tribe after Cairne Bloodhoof's death",
            },
        },
        story = "In World of Warcraft Siln Skychaser is a tauren shaman trainer on Spirit Rise in Thunder Bluff. "
             .. "She belongs to the Skychaser tribe, the spiritual leaders of the tauren. "
             .. "In the novel The Shattering: Prelude to Cataclysm, set years later, she is killed by the Grimtotem tribe after Cairne Bloodhoof's death.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Siln_Skychaser",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://www.wowhead.com/classic/npc=3030",
        },
        confidence = "confirmed",
    },

    [3031] = {
        name = "Tigor Skychaser",
        zone = "Thunder Bluff",
        coords = "23.4, 19.2",
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Mentioned: killed by the Grimtotem tribe after Cairne Bloodhoof's death",
            },
        },
        story = "In World of Warcraft Tigor Skychaser is a tauren shaman trainer on Spirit Rise in Thunder Bluff. "
             .. "He belongs to the Skychaser tribe, the spiritual leaders of the tauren. "
             .. "In the novel The Shattering: Prelude to Cataclysm, set years later, he is killed by the Grimtotem tribe after Cairne Bloodhoof's death.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Tigor_Skychaser",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://www.wowhead.com/classic/npc=3031",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Thousand Needles
    [4630] = {
        name = "Pozzik",
        zone = "Thousand Needles",
        coords = "80.0, 75.8",
        related = { 4454 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Cofounder of the Speedbarge who registers and officiates the Annual Boat Race; Gazlowe pays him to verify that Aram and Hotfix switched pilots only after the race; a member of the Mechanical Engineers' Guild of Azeroth (MEGA)",
            },
        },
        story = "In World of Warcraft Pozzik is a goblin tinker at the Mirage Raceway in Thousand Needles, which he built with his long-time rival Fizzle Brassbolts to prove the superiority of their races' engineering. "
             .. "Both of them then built rocket cars and enlisted teams to drive them. "
             .. "The novel Traveler: The Spiral Path, set much later, records him as a member of MEGA, the Mechanical Engineers' Guild of Azeroth. "
             .. "There he registers and officiates the Annual Fizzle and Pozzik's Speedbarge Boat Race, and Gazlowe pays him to confirm that the pilots switched only after the race.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Pozzik",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://www.wowhead.com/classic/npc=4630",
        },
        confidence = "confirmed",
    },

    -- ===================================================================== Arathi Highlands

    -- ===================================================================== Eastern Plaguelands
    [1855] = {
        name = "Tirion Fordring",
        zone = "Eastern Plaguelands",
        coords = "7.5, 43.5",
        appearances = {
            {
                game = "BOOK",
                campaign = "Tides of Darkness",
                missions = {},
                role = "Studies under Archbishop Alonsus Faol and is chosen with Uther, Saidan, Turalyon and Gavinrad as one of the first knights of the Silver Hand (chapter 5)",
            },
            {
                game = "BOOK",
                campaign = "Of Blood and Honor",
                missions = {},
                role = "Rides to Stratholme to free Eitrigg from execution and flees with him into the wilds (chapters 6-7)",
            },
            {
                game = "BOOK",
                campaign = "Arthas: Rise of the Lich King",
                missions = {},
                role = "Attends Arthas's induction as a paladin in Stormwind",
            },
        },
        story = "Tirion Fordring was governor of Hearthglen and a hero of the Second War until he was stripped of his titles and excommunicated from the Knights of the Silver Hand. "
             .. "In Of Blood and Honor he rides to Stratholme to save the orc Eitrigg from execution, and the two escape together into the wilds. "
             .. "Years later he lives in exile in a cottage on the shores of the Thondroril River in the Eastern Plaguelands, with his horse Mirador. "
             .. "In the novel Arthas: Rise of the Lich King he is present when Arthas becomes a paladin in Stormwind.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Tirion_Fordring",
            "https://warcraft.wiki.gg/wiki/Of_Blood_and_Honor",
            "https://warcraft.wiki.gg/wiki/Arthas:_Rise_of_the_Lich_King",
            "https://warcraft.wiki.gg/wiki/Tides_of_Darkness",
            "https://www.wowhead.com/classic/npc=1855",
        },
        confidence = "confirmed",
    },

    [10304] = {
        name = "Aurora Skycaller",
        zone = "Eastern Plaguelands",
        coords = "53.5, 22.0",
        appearances = {
            {
                game = "BOOK",
                campaign = "In the Shadow of the Sun",
                missions = {},
                role = "Joins Renthar Hawkspear in turning down Lor'themar Theron's offer of supplies at Quel'Lithien Lodge",
            },
        },
        story = "Aurora Skycaller is a high elf priestess who helped Alliance adventurers recreate the Crystal of Zin-Malor at Northpass Tower. "
             .. "When the tower became a battlefield she moved to a spot just outside it, below Quel'Lithien Lodge, where she still gives quests in the Eastern Plaguelands. "
             .. "In the short story In the Shadow of the Sun she and Renthar Hawkspear reject the Regent Lord's offer of supplies.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Aurora_Skycaller",
            "https://warcraft.wiki.gg/wiki/In_the_Shadow_of_the_Sun",
            "https://www.wowhead.com/classic/npc=10304",
        },
        confidence = "confirmed",
    },

    [10824] = {
        name = "Ranger Lord Hawkspear",
        zone = "Eastern Plaguelands",
        coords = "52.8, 18.2",
        appearances = {
            {
                game = "BOOK",
                campaign = "World of Warcraft: Sylvanas",
                missions = {},
                role = "Leads the hunters of Quel'Lithien Lodge and investigates the slaying of Lireesa and Verath Windrunner with the Farstriders",
            },
            {
                game = "BOOK",
                campaign = "In the Shadow of the Sun",
                missions = {},
                role = "Refuses Lor'themar Theron's aid and reveals that the Regent Lord banished the lodge's quel'dorei",
            },
        },
        story = "Renthar Hawkspear led the hunters of Quel'Lithien Lodge in the Eastern Plaguelands as a high elf ranger lord. "
             .. "In World of Warcraft he is a rare ranger found south of the lodge. "
             .. "In the novel World of Warcraft: Sylvanas he and the other Farstriders investigate the deaths of Lireesa and Verath Windrunner. "
             .. "In the short story In the Shadow of the Sun he turns down Lor'themar Theron's offer of aid and tells him the lodge's quel'dorei were banished from Quel'Thalas.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Death-Hunter_Hawkspear",
            "https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Sylvanas",
            "https://warcraft.wiki.gg/wiki/In_the_Shadow_of_the_Sun",
            "https://www.wowhead.com/classic/npc=10824",
        },
        confidence = "confirmed",
    },

    [11034] = {
        name = "Lord Maxwell Tyrosus",
        zone = "Eastern Plaguelands",
        coords = "81.6, 58.0",
        appearances = {
            {
                game = "FK",
                campaign = "Forsaken Kingdom (Undead)",
                missions = { "A Scarlet Flame" },
                role = "Leads the Argent Dawn forces at Dawn's Watch, which the Crushridge clan attacks until Garek, Anya and Leonid liberate it",
            },
            {
                game = "BOOK",
                campaign = "Blood Ties",
                missions = {},
                role = "Turns down Arator the Redeemer's request for promotion at Light's Hope Chapel, then inducts three new paladins into the order",
            },
        },
        story = "Lord Maxwell Tyrosus leads the Argent Dawn from Light's Hope Chapel in the Eastern Plaguelands. "
             .. "He plans with Duke Nicholas Zverenhoff an offensive on Stratholme to eliminate Baron Rivendare. "
             .. "In the novel Blood Ties he turns down Arator the Redeemer's bid for promotion, but later inducts three new paladins into the Silver Hand. "
             .. "In the Forsaken Kingdom campaign of Warcraft III Reforged he leads the Argent Dawn forces at Dawn's Watch when the Crushridge clan attacks.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Lord_Maxwell_Tyrosus",
            "https://warcraft.wiki.gg/wiki/A_Scarlet_Flame_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/Blood_Ties",
            "https://www.wowhead.com/classic/npc=11034",
        },
        confidence = "confirmed",
    },

    [11036] = {
        name = "Leonid Barthalomew the Revered",
        zone = "Eastern Plaguelands",
        coords = "81.6, 57.8",
        appearances = {
            {
                game = "FK",
                campaign = "Forsaken Kingdom (Undead)",
                missions = { "A Scarlet Flame", "War of the Damned" },
                role = "Helps Garek Bandarion and Dark Ranger Anya take Dawn's Watch from the Crushridge clan, then destroys the central crystal of Naxxramas with them",
            },
        },
        story = "Leonid Barthalomew the Revered is an undead member of the Argent Dawn who was raised as a mindless thrall of the Scourge before Sylvanas Windrunner freed him. "
             .. "In World of Warcraft he stands at Light's Hope Chapel in the Eastern Plaguelands and helps adventurers deal with Ras Frostwhisper. "
             .. "Later he tricks Tinkee Steamboil into sending the adventurers back to him with frozen black dragon eggs, then has them deliver the eggs to Betina Bigglezink. "
             .. "In the Forsaken Kingdom campaign of Warcraft III Reforged he helps Garek Bandarion and Dark Ranger Anya destroy the central crystal of Naxxramas.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Leonid_Barthalomew",
            "https://warcraft.wiki.gg/wiki/A_Scarlet_Flame_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/War_of_the_Damned_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=11036",
        },
        confidence = "confirmed",
    },

    [11710] = {
        name = "Mirador",
        zone = "Eastern Plaguelands",
        coords = "7.5, 43.5",
        appearances = {
            {
                game = "BOOK",
                campaign = "Of Blood and Honor",
                missions = {},
                role = "Carries the wounded Tirion Fordring back to Mardenholde after his duel with Eitrigg, then carries him to Stratholme to save Eitrigg from execution (chapters 2 and 6-7)",
            },
        },
        story = "Mirador is the faithful stallion of Tirion Fordring. "
             .. "In World of Warcraft he stands outside Tirion's cottage beside the Thondroril River in the Eastern Plaguelands. "
             .. "In the novella Of Blood and Honor he carries the wounded Tirion home after his duel with Eitrigg, and later carries him to Stratholme to save the orc.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Mirador",
            "https://warcraft.wiki.gg/wiki/Of_Blood_and_Honor",
            "https://www.wowhead.com/classic/npc=11710",
        },
        confidence = "confirmed",
    },

    [11878] = {
        name = "Nathanos Blightcaller",
        zone = "Eastern Plaguelands",
        coords = "26.5, 74.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "A Good War",
                missions = {},
                role = "Accompanies Varok Saurfang on the trip to Felwood",
            },
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Serves as Sylvanas's champion and bodyguard and reports on the Undercity to her",
            },
            {
                game = "BOOK",
                campaign = "Shadows Rising",
                missions = {},
                role = "Sent by Sylvanas to kill the loa Bwonsamdi, fails, and returns to the Marris Stead to await orders",
            },
            {
                game = "BOOK",
                campaign = "Dark Mirror",
                missions = {},
                role = "Agrees to a ritual Sylvanas calls him to, in which the Val'kyr sacrifice his cousin Stephon Marris to make him stronger",
            },
            {
                game = "BOOK",
                campaign = "World of Warcraft: Sylvanas",
                missions = {},
                role = "Saves Sylvanas and Lor'themar from an Amani ambush, is inducted into the Farstriders at her command, and after Garrosh's trial promises to stand by her side (chapter 23)",
            },
        },
        story = "Nathanos Blightcaller was the first and only human ranger lord trained by the high elves of Quel'Thalas, and he joined Sylvanas's rogue Forsaken after dying in the Third War. "
             .. "In World of Warcraft he returns to the Marris Stead in the Eastern Plaguelands with his blighthounds, recruiting Horde soldiers against plaguebats, the Scourge and the Scarlet Crusaders of Tyr's Hand. "
             .. "In the novel Before the Storm he serves as Sylvanas's champion and bodyguard and reports on the Undercity to her. "
             .. "In the novel Shadows Rising he is sent to kill the loa Bwonsamdi, and the attempt fails.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Nathanos_Blightcaller",
            "https://warcraft.wiki.gg/wiki/A_Good_War",
            "https://warcraft.wiki.gg/wiki/Before_the_Storm",
            "https://warcraft.wiki.gg/wiki/Shadows_Rising",
            "https://warcraft.wiki.gg/wiki/Dark_Mirror",
            "https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Sylvanas",
            "https://www.wowhead.com/classic/npc=11878",
        },
        confidence = "confirmed",
    },

    [16376] = {
        name = "Craftsman Wilhelm",
        zone = "Eastern Plaguelands",
        coords = "81.0, 59.5",
        appearances = {
            {
                game = "BOOK",
                campaign = "Blood Ties",
                missions = {},
                role = "Works at his forge at Light's Hope Chapel while Arator the Redeemer visits him",
            },
        },
        story = "Craftsman Wilhelm is a dwarf blacksmith vendor at Light's Hope Chapel in the Eastern Plaguelands, affiliated with the Brotherhood of the Light. "
             .. "In the novel Blood Ties he usually repairs the weapons and armor of the paladins of the Order of the Silver Hand. "
             .. "In the same book he keeps working at his forge and drinks Thunderbrew lager while Arator the Redeemer visits him.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Master_Craftsman_Wilhelm",
            "https://warcraft.wiki.gg/wiki/Blood_Ties",
            "https://www.wowhead.com/classic/npc=16376",
        },
        confidence = "confirmed",
    },


    -- ===================================================================== Felwood
    [9598] = {
        name = "Arei",
        zone = "Felwood",
        coords = "48.2, 28.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Ancient of War who fights the Emerald Nightmare from inside the Emerald Dream, finds Broll Bearmantle there and leads him to Zaetar",
            },
        },
        story = "In World of Warcraft Arei appears in Irontree Woods in Felwood when you play the Flute of the Ancients. "
             .. "You then escort his spirit through the corrupted woods. "
             .. "In the novel Stormrage he battles the Emerald Nightmare from within the Emerald Dream alongside Zaetar and other guardians of nature.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Arei",
            "https://warcraft.wiki.gg/wiki/Stormrage",
            "https://www.wowhead.com/classic/npc=9598/arei",
        },
        confidence = "confirmed",
    },


    -- ===================================================================== Moonglade
    [11832] = {
        name = "Keeper Remulos",
        zone = "Moonglade",
        coords = "36.2, 41.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Turns on Malfurion after Xavius uses him as a pawn to lure Malfurion into a trap, until he is cleansed of his corruption",
            },
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Refuses to let Hamuul Runetotem and Elerethe Renferal meet in Moonglade, but allows a second meeting there if the first goes well",
            },
        },
        story = "Keeper Remulos is a keeper of the grove and one of the sons of Cenarius. "
             .. "A few years after the Third War, Moonglade was opened to all druid races and Keeper Remulos became its new guardian. "
             .. "In the novel Stormrage, Xavius uses Remulos as a pawn to lure Malfurion Stormrage into a trap, and Remulos is defeated and cleansed of his corruption. "
             .. "At the end of the novel he is one of many who witness the marriage of Tyrande and Malfurion. "
             .. "In the novel The Shattering: Prelude to Cataclysm, he refuses to let Hamuul Runetotem and Elerethe Renferal meet in Moonglade, but allows a second meeting there if the first goes well.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Keeper_Remulos",
            "https://warcraft.wiki.gg/wiki/Moonglade",
            "https://warcraft.wiki.gg/wiki/Stormrage",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://www.wowhead.com/classic/npc=11832",
        },
        confidence = "confirmed",
    },


    -- ===================================================================== Stranglethorn Vale
    [2487] = {
        name = "Fleet Master Seahorn",
        zone = "Stranglethorn Vale",
        coords = "27.2, 77.0",
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Gives the ship Sea King to the new captain Adashe Flintwill (chapter 32)",
            },
        },
        story = "Fleet Master Seahorn is a tauren pirate of the Blackwater Raiders, located on the top floor of the Salty Sailor Tavern in Booty Bay. "
             .. "He is Baron Revilgaz's most trusted advisor. "
             .. "In the book Traveler: The Spiral Path he gives the ship Sea King to the new captain Adashe Flintwill.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Fleet_Master_Seahorn",
            "https://warcraft.wiki.gg/wiki/Baron_Revilgaz",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://www.wowhead.com/classic/npc=2487",
        },
        confidence = "confirmed",
    },

    [2542] = {
        name = "Catelyn the Blade",
        zone = "Stranglethorn Vale",
        coords = "27.2, 77.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Quest for Pandaria",
                missions = {},
                role = "Steals the Pearl of Pandaria from Li Li Stormstout to pay her debt to the Steamwheedle Cartel, then gives it back",
            },
        },
        story = "Catelyn Runeweaver, known as Catelyn the Blade, is a human quest giver in the Salty Sailor Tavern in Booty Bay. "
             .. "She is the best knife fighter in Booty Bay and the daughter of Archmage Ansirem Runeweaver. "
             .. "She joined the Blackwater Raiders as a pirate and became captain of the raider ship Neptulon's Bride. "
             .. "In the book Quest for Pandaria she owes a debt to the Steamwheedle Cartel, steals the Pearl of Pandaria from Li Li Stormstout, and later gives it back.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Catelyn_the_Blade",
            "https://warcraft.wiki.gg/wiki/Quest_for_Pandaria",
            "https://www.wowhead.com/classic/npc=2542",
        },
        confidence = "confirmed",
    },

    [2547] = {
        name = "Ironpatch",
        zone = "Stranglethorn Vale",
        coords = "30.4, 90.2",
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Attacks the Sea King with the Killmonger and executes its captain, Adashe Flintwill",
            },
        },
        story = "Ironpatch is an orc member of the Bloodsail Buccaneers, found on the pirate ship The Crimson Veil off the southern coast of Stranglethorn Vale. "
             .. "Killing him earns reputation with Booty Bay and costs reputation with the Bloodsail Buccaneers. "
             .. "In the book Traveler: The Spiral Path he is the captain of the Killmonger and attacks the Sea King of the Blackwater Raiders. "
             .. "He executes its captain, Adashe Flintwill, and is finally killed by Makasa Flintwill with Adashe's harpoon.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Ironpatch",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://www.wowhead.com/classic/npc=2547",
        },
        confidence = "confirmed",
    },

    [6807] = {
        name = "Innkeeper Skindle",
        zone = "Stranglethorn Vale",
        coords = "27.0, 77.2",
        appearances = {
            {
                game = "BOOK",
                campaign = "Quest for Pandaria",
                missions = {},
                role = "Tells Chen Stormstout everything about Catelyn after Chen pays him",
            },
        },
        story = "Innkeeper Skindle is a goblin innkeeper in the Salty Sailor Tavern in Booty Bay. "
             .. "He sells food and drink to travelers in the inn. "
             .. "In the book Quest for Pandaria, Chen Stormstout pays him some coins and Skindle tells him everything about Catelyn.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Innkeeper_Skindle",
            "https://warcraft.wiki.gg/wiki/Quest_for_Pandaria",
            "https://www.wowhead.com/classic/npc=6807",
        },
        confidence = "confirmed",
    },


    -- ===================================================================== Sunken Temple
    [5709] = {
        name = "Shade of Eranikus",
        zone = "Sunken Temple",
        coords = "",
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Refuses at first to help for fear of being corrupted again, then carries Tyrande and Broll to Bough Shadow and later sacrifices himself so Ysera can escape",
            },
        },
        story = "Eranikus, former consort of Ysera the Dreamer, was sent to guard the ruins of Atal'Hakkar and prevent Hakkar's emergence. "
             .. "Once inside the temple he and his retinue were corrupted, and he became a shade pulled between the Emerald Dream and the physical world. "
             .. "In the novel Stormrage he is despondent about the growing corruption and reluctant to help, but he later carries Tyrande and Broll to Bough Shadow, and he sacrifices himself so that Ysera can escape. "
             .. "In World of Warcraft the Shade of Eranikus is an elite boss in the Temple of Atal'Hakkar, and you must defeat Jammal'an the Prophet before you can fight him.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Shade_of_Eranikus",
            "https://warcraft.wiki.gg/wiki/Stormrage",
            "https://www.wowhead.com/classic/npc=5709/shade-of-eranikus",
        },
        confidence = "confirmed",
    },

    [15362] = {
        name = "Malfurion Stormrage",
        zone = "Sunken Temple",
        coords = "",
        appearances = {
            {
                game = "WC3",
                campaign = "Eternity's End (Night Elf)",
                missions = { "The Awakening of Stormrage", "The Druids Arise", "Brothers in Blood", "Twilight of the Gods" },
                role = "Keeper of the Grove hero, called Furion in these missions, who is woken by Tyrande and rouses the druids against the Burning Legion",
            },
            {
                game = "WC3",
                campaign = "Eternity's End (Night Elf)",
                missions = { "A Destiny of Flame and Sorrow", "The Last Guardian", "Eternity's End" },
                role = "Cutscenes only, as Furion: he and Tyrande confront the transformed Illidan in Felwood and meet Medivh on Mount Hyjal; in the final cinematic he unleashes Nordrassil's power to destroy Archimonde",
            },
            {
                game = "TFT",
                campaign = "Terror of the Tides (Night Elf)",
                missions = { "Balancing the Scales", "The Ruins of Dalaran", "The Brothers Stormrage" },
                role = "Archdruid hero who joins Tyrande and Maiev against Illidan and his naga",
            },
            {
                game = "TFT",
                campaign = "Terror of the Tides (Night Elf)",
                missions = { "Shards of the Alliance", "Unfinished Business", "Malfurion's Vision", "A Parting of Ways" },
                role = "Speaking character in the cutscenes: he learns of Illidan's naga from Maiev's messenger, sees the Eye of Sargeras plan in a vision and lets Illidan go",
            },
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Held captive in the Emerald Dream by the Nightmare Lord until Thura frees him, then heals Teldrassil and marries Tyrande",
            },
        },
        story = "Malfurion Stormrage is the first of the druids and the Keeper of the Grove. "
             .. "In World of Warcraft he appears as an apparition, once in Moonglade and once in the Temple of Atal'Hakkar during the Scepter of the Shifting Sands quest chain. "
             .. "In the Temple of Atal'Hakkar he confirms that an Old God is corrupting the Emerald Dream. "
             .. "In Warcraft III he is called Furion Stormrage in Eternity's End, and Tyrande wakes him to fight the Burning Legion. "
             .. "In the novel Stormrage he is held captive in the Emerald Dream by the Nightmare Lord until he is freed, and he later marries Tyrande.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Malfurion_Stormrage",
            "https://warcraft.wiki.gg/wiki/Brothers_in_Blood_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Balancing_the_Scales_(WC3_Night_Elf)",
            "https://warcraft.wiki.gg/wiki/Terror_of_the_Tides",
            "https://warcraft.wiki.gg/wiki/Stormrage",
            "https://www.wowhead.com/classic/npc=15362/malfurion-stormrage",
        },
        confidence = "confirmed",
    },


    -- ===================================================================== Tanaris
    [7564] = {
        name = "Marin Noggenfogger",
        zone = "Tanaris",
        coords = "51.8, 28.6",
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Under Malus's blackmail, tips him off that Aramar Thorne booked passage on the Crustacean, which sends Malus out of Gadgetzan",
            },
            {
                game = "BOOK",
                campaign = "The Goblin Way",
                missions = {},
                role = "Agrees to align his Steamwheedle Cartel with Gazlowe's after Gazlowe demands an inspection of his mine",
            },
        },
        story = "In World of Warcraft, Marin Noggenfogger sends adventurers into the desert to collect Laden Dew Glands for his new elixir. "
             .. "He sends them to his friend Sprinkle, a Gadgetzan chef, who turns a Violet Tragan mushroom into a powder that makes the elixir palatable. "
             .. "In Traveler: The Spiral Path, he supervises the Thunderdrome bets, and Malus blackmails him into revealing the Crustacean booking. "
             .. "In the short story The Goblin Way, he agrees to align his cartel with Gazlowe's after Gazlowe demands an inspection of his mine.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Marin_Noggenfogger",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://warcraft.wiki.gg/wiki/The_Goblin_Way",
            "https://www.wowhead.com/classic/npc=7564",
        },
        confidence = "confirmed",
    },

    [7583] = {
        name = "Sprinkle",
        zone = "Tanaris",
        coords = "51.0, 26.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Smuggles Aramar Thorne's companions into Gadgetzan hidden in her caravan during a staged picnic, and suggests Winifred's home as a safe house",
            },
        },
        story = "In World of Warcraft, Sprinkle is a Gadgetzan chef whose secret ingredient is the Violet Tragan mushroom from the Hinterlands. "
             .. "She has adventurers gather the mushroom, turns it into a powder, and hands it back to them with a message that Marin owes her a favor. "
             .. "In Traveler: The Spiral Path, she meets Gazlowe and Aramar Thorne on a staged picnic and hides the children in her caravan to bring them into Gadgetzan unseen. "
             .. "Later she tells her husband that the Crustacean is where the travelers have booked passage, and he passes this on to Malus.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Sprinkle_Noggenfogger",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://www.wowhead.com/classic/npc=7583",
        },
        confidence = "confirmed",
    },

    [7804] = {
        name = "Trenton Lighthammer",
        zone = "Tanaris",
        coords = "51.4, 28.6",
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Lets Aramar Thorne and his companions sleep in his tower, and forges a harpoon with Aram for Makasa Flintwill",
            },
        },
        story = "In World of Warcraft, Trenton Lighthammer is a night elf blacksmith of the Mithril Order near Gadgetzan's southern gate, where he trains armorsmiths and asks adventurers for troll temper from Zul'Farrak. "
             .. "In Traveler: The Spiral Path, he lets Aramar Thorne and his companions sleep in his tower. "
             .. "Aram and Trenton forge a new harpoon for Makasa, and Trenton gives Aram a new iron chain for his compass.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Trenton_Lighthammer",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://www.wowhead.com/classic/npc=7804",
        },
        confidence = "confirmed",
    },

    [8197] = {
        name = "Chronalis",
        zone = "Tanaris",
        coords = "64.5, 50.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Thrall: Twilight of the Aspects",
                missions = {},
                role = "Denies Thrall and Desharin entry to the Caverns of Time, then escorts them in once they are shown to be acting under Ysera's direction",
            },
        },
        story = "In World of Warcraft, Chronalis is an elite bronze drake that guards the entrance to the Caverns of Time in eastern Tanaris, together with Tick. "
             .. "In Thrall: Twilight of the Aspects, he at first refuses Thrall and Desharin entry to the Caverns of Time. "
             .. "He lets them through only after learning they were acting under Ysera's direction.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Chronalis",
            "https://warcraft.wiki.gg/wiki/Thrall:_Twilight_of_the_Aspects",
            "https://www.wowhead.com/classic/npc=8197",
        },
        confidence = "confirmed",
    },

    [8198] = {
        name = "Tick",
        zone = "Tanaris",
        coords = "63.2, 50.4",
        appearances = {
            {
                game = "BOOK",
                campaign = "Thrall: Twilight of the Aspects",
                missions = {},
                role = "Takes Thrall to meet the other dragonflights and carries him in the battle to retake Wyrmrest Temple, then returns him to the Maelstrom",
            },
            {
                game = "BOOK",
                campaign = "Charge of the Aspects",
                missions = {},
                role = "Carries the badly wounded Zirion, the only survivor of Nozdormu's twelve agents sent into the past, and tells Nozdormu the Infinite Dragonflight attacked him",
            },
        },
        story = "In World of Warcraft, Tick is a bronze drake that guards the entrance to the Caverns of Time in eastern Tanaris, together with Chronalis. "
             .. "In Thrall: Twilight of the Aspects, she takes Thrall to meet the other dragonflights. "
             .. "She later carries him in the battle to retake Wyrmrest Temple from the Twilight's Hammer and returns him to the Maelstrom. "
             .. "In the short story Charge of the Aspects, she carries the badly wounded Zirion to Nozdormu and tells him the Infinite Dragonflight and its leader attacked Zirion.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Tick_(drake)",
            "https://warcraft.wiki.gg/wiki/Thrall:_Twilight_of_the_Aspects",
            "https://warcraft.wiki.gg/wiki/Charge_of_the_Aspects",
            "https://www.wowhead.com/classic/npc=8198",
        },
        confidence = "confirmed",
    },

    [15192] = {
        name = "Anachronos",
        zone = "Tanaris",
        coords = "65.2, 50.0",
        appearances = {
            {
                game = "BOOK",
                campaign = "The War of the Shifting Sands",
                missions = {},
                role = "Calls the bronze dragonflight and the other dragon flights to fight the qiraji, and summons the barrier at Ahn'Qiraj",
            },
            {
                game = "BOOK",
                campaign = "Thrall: Twilight of the Aspects",
                missions = {},
                role = "Is present when Thrall returns Nozdormu to the Caverns of Time after the Cataclysm",
            },
        },
        story = "In World of Warcraft, Anachronos is the heir of Nozdormu and guards the Caverns of Time in Tanaris. "
             .. "In the short story The War of the Shifting Sands, he calls the other dragonflights to fight the qiraji. "
             .. "In Thrall: Twilight of the Aspects, he is present when Nozdormu is brought back to the Caverns of Time after the Cataclysm.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Anachronos",
            "https://warcraft.wiki.gg/wiki/The_War_of_the_Shifting_Sands_(short_story)",
            "https://warcraft.wiki.gg/wiki/Thrall:_Twilight_of_the_Aspects",
            "https://www.wowhead.com/classic/npc=15192",
        },
        confidence = "confirmed",
    },


    -- ===================================================================== Temple of Ahn'Qiraj
    [15378] = {
        name = "Merithra of the Dream",
        zone = "Temple of Ahn'Qiraj",
        coords = "",
        appearances = {
            {
                game = "BOOK",
                campaign = "The War of the Shifting Sands",
                missions = {},
                role = "Charges into Ahn'Qiraj with Caelestrasz and Arygos to hold the qiraji back while the barrier is raised, and is overwhelmed",
            },
        },
        story = "In World of Warcraft, Merithra waits in the Temple of Ahn'Qiraj, where adventurers bring her Imperial Qiraji Regalia and Elementium Ore. "
             .. "In the short story The War of the Shifting Sands, Anachronos calls her, the child of Ysera, to join the fight against the qiraji. "
             .. "She and the other dragon progeny fly into the city to hold the qiraji back while the magical barrier is raised.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Merithra",
            "https://warcraft.wiki.gg/wiki/The_War_of_the_Shifting_Sands_(short_story)",
            "https://www.wowhead.com/classic/npc=15378",
        },
        confidence = "confirmed",
    },

    [15379] = {
        name = "Caelestrasz",
        zone = "Temple of Ahn'Qiraj",
        coords = "",
        appearances = {
            {
                game = "BOOK",
                campaign = "The War of the Shifting Sands",
                missions = {},
                role = "Charges into Ahn'Qiraj with Merithra and Arygos to hold the qiraji back while the barrier is raised, and is overwhelmed",
            },
        },
        story = "In World of Warcraft, Caelestrasz waits in the Temple of Ahn'Qiraj and gives the quest The Savior of Kalimdor. "
             .. "In the short story The War of the Shifting Sands, Anachronos calls on the red dragonflight's progeny, Caelestrasz, to fight the qiraji. "
             .. "He, Merithra and Arygos fly into the city to hold the qiraji back while the barrier is raised, and are overwhelmed when the qiraji surge forth.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Caelestrasz",
            "https://warcraft.wiki.gg/wiki/The_War_of_the_Shifting_Sands_(short_story)",
            "https://www.wowhead.com/classic/npc=15379",
        },
        confidence = "confirmed",
    },

    [15380] = {
        name = "Arygos",
        zone = "Temple of Ahn'Qiraj",
        coords = "",
        appearances = {
            {
                game = "BOOK",
                campaign = "The War of the Shifting Sands",
                missions = {},
                role = "Charges into Ahn'Qiraj with Merithra and Caelestrasz to hold the qiraji back while the barrier is raised",
            },
            {
                game = "BOOK",
                campaign = "Thrall: Twilight of the Aspects",
                missions = {},
                role = "Orders his guards to kill Thrall when he arrives at the Nexus, until Kalecgos intervenes",
            },
        },
        story = "In World of Warcraft, Arygos, in the form of a gnome, offers the quest Imperial Qiraji Armaments in the Temple of Ahn'Qiraj. "
             .. "In the short story The War of the Shifting Sands, he is one of the dragon progeny who fly into Ahn'Qiraj to hold the qiraji back. "
             .. "In Thrall: Twilight of the Aspects, he orders his guards to kill Thrall when Thrall comes to the Nexus, until Kalecgos intervenes.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Arygos",
            "https://warcraft.wiki.gg/wiki/The_War_of_the_Shifting_Sands_(short_story)",
            "https://warcraft.wiki.gg/wiki/Thrall:_Twilight_of_the_Aspects",
            "https://www.wowhead.com/classic/npc=15380",
        },
        confidence = "confirmed",
    },


    -- ===================================================================== The Hinterlands
    [2707] = {
        name = "Shadra",
        zone = "The Hinterlands",
        coords = "33.4, 72.6",
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = { "Chapter 34" },
                role = "Spider loa Elortha no Shadra who refuses to claim the captive Taryndrella and Murky when the Sandfury trolls prepare to sacrifice them at Zul'Farrak",
            },
            {
                game = "BOOK",
                campaign = "Vol'jin: Shadows of the Horde",
                missions = {},
                role = "Communicates with Vol'jin through visions shortly after the Landfall",
            },
        },
        story = "Elortha no Shadra, the spider loa, is worshipped by the Witherbark and Vilebranch tribes in the Hinterlands. "
             .. "In World of Warcraft Horde adventurers summon her at an altar, where she is killed and her venom is sent to the Undercity. "
             .. "In the novel Traveler: The Spiral Path the Sandfury trolls call on her at Zul'Farrak to judge their captives, but she refuses to claim the dryad Taryndrella and Murky. "
             .. "In the novel Vol'jin: Shadows of the Horde she communicates with Vol'jin through visions shortly after the Landfall.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Shadra",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://warcraft.wiki.gg/wiki/Vol%27jin:_Shadows_of_the_Horde",
            "https://www.wowhead.com/classic/npc=2707",
        },
        confidence = "confirmed",
    },

    [5635] = {
        name = "Falstad Wildhammer",
        zone = "The Hinterlands",
        coords = "11.8, 46.8",
        appearances = {
            {
                game = "BOOK",
                campaign = "Day of the Dragon",
                missions = {},
                role = "Leads a flight of gryphon riders that protects Hasic, then transports Rhonin and his companions across the Great Sea to Khaz Modan",
            },
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = { "Chapter 3" },
                role = "Attends the wedding of Malfurion Stormrage and Tyrande Whisperwind after the War Against the Nightmare",
            },
            {
                game = "BOOK",
                campaign = "Quest for Pandaria",
                missions = {},
                role = "Sits on the Council of Three Hammers that cannot help Li Li Stormstout find Magni, and laughs at how rude she is",
            },
            {
                game = "BOOK",
                campaign = "War Crimes",
                missions = { "Chapter 1" },
                role = "Attends the trial of Garrosh Hellscream in the Temple of the White Tiger with his fellow Council of Three Hammers members",
            },
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Welcomes King Anduin Wrynn to Ironforge as a member of the Council of Three Hammers",
            },
        },
        story = "Falstad Wildhammer is the High Thane of the Wildhammer clan at Aerie Peak in the Hinterlands. "
             .. "In World of Warcraft he was a quest giver at Aerie Peak, where he dealt with the encroaching forest trolls. "
             .. "In the novel Day of the Dragon he leads gryphon riders who protect Hasic and carry Rhonin's group across the Great Sea to Khaz Modan. "
             .. "In the novel Stormrage he attends the wedding of Malfurion and Tyrande, and in War Crimes he attends Garrosh's trial. "
             .. "In the novel Before the Storm he welcomes King Anduin Wrynn to Ironforge as a member of the Council of Three Hammers.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Falstad_Wildhammer",
            "https://warcraft.wiki.gg/wiki/Day_of_the_Dragon",
            "https://warcraft.wiki.gg/wiki/Stormrage",
            "https://warcraft.wiki.gg/wiki/Quest_for_Pandaria",
            "https://warcraft.wiki.gg/wiki/War_Crimes",
            "https://warcraft.wiki.gg/wiki/Before_the_Storm",
            "https://www.wowhead.com/classic/npc=5635",
        },
        confidence = "confirmed",
    },


    -- ===================================================================== Winterspring
    [11186] = {
        name = "Lunnix Sprocketslip",
        zone = "Winterspring",
        coords = "61.7, 38.5",
        related = { 11753 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Ends her relationship with Kezzig Klackwhistle after she catches him hanging around Gogo",
            },
        },
        story = "Lunnix Sprocketslip, nicknamed Lunny, is a goblin mining vendor in Everlook in Winterspring. "
             .. "In the novel Before the Storm, Kezzig Klackwhistle works for her in her mining supply shop, and the two enter a relationship. "
             .. "She ends it once she catches Kezzig hanging around Gogo, and her anger drives Kezzig to leave Everlook for Silithus. "
             .. "In World of Warcraft she sells mining supplies in Everlook.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Lunnix_Sprocketslip",
            "https://warcraft.wiki.gg/wiki/Gogo",
            "https://warcraft.wiki.gg/wiki/Before_the_Storm",
            "https://www.wowhead.com/classic/npc=11186",
        },
        confidence = "confirmed",
    },

    [11753] = {
        name = "Gogo",
        zone = "Winterspring",
        coords = "61.2, 38.5",
        appearances = {
            {
                game = "BOOK",
                campaign = "Before the Storm",
                missions = {},
                role = "Kezzig Klackwhistle hangs around her while he is in a relationship with Lunnix Sprocketslip",
            },
        },
        story = "Gogo is a goblin located in Everlook in Winterspring. "
             .. "In the novel Before the Storm, Kezzig Klackwhistle hangs around her while he is in a relationship with Lunnix Sprocketslip. "
             .. "When Lunnix caught them, her ire caused Kezzig to leave Everlook for Silithus.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Gogo",
            "https://warcraft.wiki.gg/wiki/Lunnix_Sprocketslip",
            "https://warcraft.wiki.gg/wiki/Before_the_Storm",
            "https://www.wowhead.com/classic/npc=11753",
        },
        confidence = "confirmed",
    },


    -- ===================================================================== Zul'Farrak
    [7267] = {
        name = "Chief Ukorz Sandscalp",
        zone = "Zul'Farrak",
        coords = "",
        appearances = {
            {
                game = "BOOK",
                campaign = "Traveler: The Spiral Path",
                missions = {},
                role = "Joins the sand trolls in summoning the loa Kimbul, Shadra and Mueh'zala with the blood of his prisoners (chapters 33-34)",
            },
        },
        story = "Chief Ukorz Sandscalp is the leader of the Sandfury tribe and the ruler of Zul'Farrak, and he is accompanied by his right hand Ruuzlu. "
             .. "He is obsessed with restoring his tribe to its former glory. "
             .. "In the novel Traveler: The Spiral Path, Aramar Thorne and his group of friends are captured in Zul'Farrak and set to be sacrificed to the loa. "
             .. "In World of Warcraft he is the end boss of Zul'Farrak, and you can reach him by talking to Weegli Blastfuse or by starting the optional fight with Sergeant Bly.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Chief_Ukorz_Sandscalp",
            "https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path",
            "https://www.wowhead.com/classic/npc=7267/chief-ukorz-sandscalp",
        },
        confidence = "confirmed",
    },
    -- ===================================================================== Alterac Valley
    [11946] = {
        name = "Drek'Thar",
        zone = "Alterac Valley",
        coords = "",
        related = { 4949 },
        appearances = {
            {
                game = "TFT",
                campaign = "The Founding of Durotar (Orc bonus campaign)",
                missions = { "To Tame a Land" },
                role = "Quest giver and ally: sends Rexxar for shimmerweed in Thunder Ridge, then joins him to find out why the thunder lizards turned hostile",
            },
            {
                game = "BOOK",
                campaign = "Rise of the Horde",
                missions = {},
                role = "Frostwolf shaman who accepts Ner'zhul's word that the draenei are plotting against the orcs, and later shares the Frostwolves' exile into the Alterac Mountains",
            },
            {
                game = "BOOK",
                campaign = "Lord of the Clans",
                missions = {},
                role = "Farseer who takes Thrall under his wing, trains him as a shaman and sets up his meeting with Orgrim Doomhammer",
            },
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Elderly and increasingly senile, he has visions of an attack on a peace meeting of druids and of the world breaking apart, and pleads with Palkar to send warnings",
            },
        },
        story = "Drek'Thar was a shaman of the Frostwolf clan who followed the warlocks for a time on Draenor, then renounced them and led the clan after Durotan's death. "
             .. "In the novel Lord of the Clans he discovers that Thrall is Durotan's heir and trains him in the ways of the shaman. "
             .. "After the Third War he crossed the sea to help Thrall found Durotar, and in The Founding of Durotar he sends Rexxar to gather shimmerweed. "
             .. "In World of Warcraft he leads the Frostwolf clan from Frostwolf Keep in Alterac Valley and commands the Horde in the battle against the Stormpike Guard. "
             .. "He still carries guilt over the early days of the Horde.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Drek%27Thar",
            "https://warcraft.wiki.gg/wiki/To_Tame_a_Land_(WC3_Orc)",
            "https://warcraft.wiki.gg/wiki/Lord_of_the_Clans",
            "https://warcraft.wiki.gg/wiki/Rise_of_the_Horde",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://www.wowhead.com/classic/npc=11946/drekthar",
        },
        confidence = "confirmed",
    },
    [13442] = {
        name = "Arch Druid Renferal",
        zone = "Alterac Valley",
        coords = "",
        appearances = {
            {
                game = "BOOK",
                campaign = "Stormrage",
                missions = {},
                role = "Attends the Cenarion Circle convocation Fandral Staghelm calls in Teldrassil, where Broll Bearmantle sees her speaking with Naralex (chapter 2)",
            },
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Meets Hamuul Runetotem in southern Ashenvale to mend relations after an attack on the Sentinels, criticizes Thrall's choice of Garrosh but agrees to work toward peace",
            },
        },
        story = "Elerethe Renferal is a night elf archdruid of the Cenarion Circle and a close friend of Malfurion Stormrage. "
             .. "She was sent from Darnassus with Druids of the Grove to help the Stormpike Guard in their war with the Frostwolf clan. "
             .. "From the Dun Baldar North Bunker she asks Alliance adventurers for storm crystals to summon Ivus the Forest Lord, an Ancient of War who will judge the Horde's destruction of the valley. "
             .. "She deeply loves the lands of Alterac and wants to save its plants and animals. "
             .. "In the novel The Shattering: Prelude to Cataclysm she meets Hamuul Runetotem in Ashenvale just before the Cataclysm, and the meeting is broken up by an attack.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Elerethe_Renferal",
            "https://warcraft.wiki.gg/wiki/Stormrage",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://www.wowhead.com/classic/npc=13442",
        },
        confidence = "confirmed",
    },
    -- ===================================================================== Naxxramas
    [15990] = {
        name = "Kel'Thuzad",
        zone = "Naxxramas",
        coords = "",
        related = { 10440, 10813 },
        appearances = {
            {
                game = "WC3",
                campaign = "The Scourge of Lordaeron (Human)",
                missions = { "Ravages of the Plague", "The Cult of the Damned" },
                role = "Necromancer behind the plague who flees from the cultists' camp in Ravages of the Plague, then admits to Arthas and Jaina in Andorhal that his cult spread the plagued grain, points them to Mal'Ganis in Stratholme and is hunted down and killed",
            },
            {
                game = "WC3",
                campaign = "Path of the Damned (Undead)",
                missions = { "Digging up the Dead", "Into the Realm Eternal", "Key of the Three Moons", "The Fall of Silvermoon", "The Revelation", "Blackrock & Roll, Too!", "The Siege of Dalaran", "Under the Burning Sky" },
                role = "Ghost advising Arthas while his remains are carried to the Sunwell, reborn as a lich in The Fall of Silvermoon, then guides the Scourge army, opens the Demon Gate, takes the Book of Medivh in Dalaran and summons Archimonde",
            },
            {
                game = "TFT",
                campaign = "Legacy of the Damned (Undead)",
                missions = { "King Arthas", "The Flight from Lordaeron", "Sylvanas' Farewell" },
                role = "Arthas's majordomo in Lordaeron: warns of the fleeing humans, helps him escape the assassins and drives off Sylvanas's banshees before Arthas sails for Northrend",
            },
            {
                game = "FK",
                campaign = "Forsaken Kingdom (Undead)",
                missions = { "War of the Damned" },
                role = "Commands the Scourge assault on the Undercity from Naxxramas; Garek, Anya and Leonid defeat him and Baron Rivendare and he teleports away (Warcraft III: Reforged only)",
            },
            {
                game = "BOOK",
                campaign = "Road to Damnation",
                missions = {},
                role = "Protagonist: Antonidas threatens to strip him of his rank over his necromancy, and he leaves Dalaran for Northrend to offer his service to the Lich King",
            },
            {
                game = "BOOK",
                campaign = "Cycle of Hatred",
                missions = {},
                role = "Antonidas introduces him to Jaina Proudmoore as one of the finest mages in the Kirin Tor (chapter 8)",
            },
        },
        story = "Kel'Thuzad was once a member of the Council of Six of the Kirin Tor in Dalaran. "
             .. "Antonidas threatened him with exile over his necromancy, so he left for Northrend, answered the Lich King's call and founded the Cult of the Damned in Lordaeron. "
             .. "In The Cult of the Damned Arthas and Jaina hunt him down in Andorhal, and later he is reborn as a lich. "
             .. "After the Third War he ruled the Eastern Plaguelands from the flying necropolis Naxxramas. "
             .. "In World of Warcraft he waits for adventurers in his chamber at the heart of Naxxramas, guarded by the Four Horsemen and the frost wyrm Sapphiron.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Kel%27Thuzad",
            "https://warcraft.wiki.gg/wiki/Ravages_of_the_Plague_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/The_Cult_of_the_Damned_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/The_Fall_of_Silvermoon_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/The_Flight_from_Lordaeron_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/War_of_the_Damned_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/Road_to_Damnation",
            "https://warcraft.wiki.gg/wiki/Cycle_of_Hatred",
            "https://www.wowhead.com/classic/npc=15990",
        },
        confidence = "confirmed",
    },
    [15989] = {
        name = "Sapphiron",
        zone = "Naxxramas",
        coords = "",
        related = { 15990 },
        appearances = {
            {
                game = "TFT",
                campaign = "Legacy of the Damned (Undead)",
                missions = { "The Return to Northrend", "Into the Shadow Web Caverns" },
                role = "Blue dragon who guards a hoard of artifacts and fights Arthas and Anub'arak, then is raised as a frost wyrm and breaks the dwarves' gate to Azjol-Nerub",
            },
        },
        story = "Sapphiron was an ancient blue dragon who lived with his brood near the entrance to Azjol-Nerub in Northrend, guarding a hoard of artifacts. "
             .. "When Arthas and Anub'arak came to take the hoard, he fought them and was killed. "
             .. "Arthas raised him as a frost wyrm to serve the Scourge. "
             .. "In World of Warcraft he guards the Frostwyrm Lair in Naxxramas, the approach to the chamber of Kel'Thuzad. "
             .. "His frost magic, strengthened when Arthas raised him, defends Kel'Thuzad at all costs.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Sapphiron",
            "https://warcraft.wiki.gg/wiki/The_Return_to_Northrend_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/Into_the_Shadow_Web_Caverns_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=15989",
        },
        confidence = "confirmed",
    },
    [16063] = {
        name = "Sir Zeliek",
        zone = "Naxxramas",
        coords = "",
        related = { 15990 },
        appearances = {
            {
                game = "FK",
                campaign = "Forsaken Kingdom (Undead)",
                missions = { "War of the Damned" },
                role = "Scourge death knight and former paladin who fights Garek, Anya and Leonid inside Naxxramas and prays for the Light to destroy him so he is freed from his master (Warcraft III: Reforged only)",
            },
        },
        story = "Sir Zeliek is one of the Four Horsemen of Naxxramas and was a paladin of the Order of the Silver Hand in life. "
             .. "Even in undeath the power of the Light still answers his call. "
             .. "Kel'Thuzad forces his body to obey, but Zeliek keeps his sanity and morals, which makes him a tragic figure forced to slay what he once held dear. "
             .. "In World of Warcraft he stands in Naxxramas above Stratholme with the other horsemen, overseeing the Military Quarter. "
             .. "In Forsaken Kingdom the Forsaken strike team kills him, but Leonid notes that the Scourge will simply resurrect him.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/Sir_Zeliek",
            "https://warcraft.wiki.gg/wiki/War_of_the_Damned_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=16063",
        },
        confidence = "confirmed",
    },
    -- ===================================================================== Ruins of Ahn'Qiraj
    [15341] = {
        name = "General Rajaxx",
        zone = "Ruins of Ahn'Qiraj",
        coords = "",
        appearances = {
            {
                game = "BOOK",
                campaign = "The War of the Shifting Sands",
                missions = {},
                role = "Commands the qiraji and silithid against the night elves, clashes with Fandral and Valstann Staghelm and personally kills Valstann",
            },
        },
        story = "General Rajaxx is a primary militant commander of the qiraji. "
             .. "In the short story The War of the Shifting Sands, he leads the qiraji and silithid in battle against the night elves and tears Valstann Staghelm in two with his claws. "
             .. "In World of Warcraft he is the second boss of the Ruins of Ahn'Qiraj. "
             .. "Adventurers must first defeat seven waves of his officers and their swarms before they reach him.",
        items = {
        },
        sources = {
            "https://warcraft.wiki.gg/wiki/General_Rajaxx",
            "https://warcraft.wiki.gg/wiki/The_War_of_the_Shifting_Sands_(short_story)",
            "https://www.wowhead.com/classic/npc=15341",
        },
        confidence = "confirmed",
    },
    -- ===================================================================== Upper Blackrock Spire
    [10429] = {
        name = "Warchief Rend Blackhand",
        zone = "Upper Blackrock Spire",
        coords = "",
        related = { 11583, 10162 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Tides of Darkness",
                missions = { "Chapter 11" },
                role = "Lieutenant to Warchief Orgrim Doomhammer; he and his brother Maim question Orgrim's orders but never disobey them",
            },
            {
                game = "BOOK",
                campaign = "Beyond the Dark Portal",
                missions = { "Chapter 8" },
                role = "Laughs off Teron Gorefiend's request to rejoin Ner'zhul's Horde, then falls under Nefarian's command when the dragon arrives at Blackrock Spire",
            },
        },
        story = "At the end of the Second War, Rend and his brother Maim took control of Blackrock Mountain, and Rend declared himself Warchief of the weakened Blackrock clan. "
             .. "They blamed Orgrim Doomhammer for the Horde's defeat and planned to reforge the Horde as they saw fit. "
             .. "In the novel Beyond the Dark Portal Rend refused to rejoin Ner'zhul's Horde, and Nefarian then took command of the Blackhand brothers and their forces. "
             .. "In World of Warcraft he rules the Dark Horde from the arena of Upper Blackrock Spire, rides the chromatic drake Gyth and wants to overthrow Thrall.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Dal%27rend_Blackhand",
            "https://warcraft.wiki.gg/wiki/Tides_of_Darkness",
            "https://warcraft.wiki.gg/wiki/Beyond_the_Dark_Portal",
            "https://www.wowhead.com/classic/npc=10429/warchief-rend-blackhand",
        },
        confidence = "confirmed",
    },
    [10162] = {
        name = "Lord Victor Nefarius",
        zone = "Upper Blackrock Spire",
        coords = "",
        alsoIn = { "Blackwing Lair" },
        related = { 10184 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Beyond the Dark Portal",
                missions = { "Chapter 8" },
                role = "Human guise of the dragon Nefarian, who is sent by Deathwing to Blackrock Spire and takes command of the Blackhand brothers",
            },
        },
        story = "Lord Victor Nefarius is the human guise of the black dragon Nefarian, eldest son of Deathwing. "
             .. "In the novel Beyond the Dark Portal, Deathwing orders Nefarian and his sister Onyxia to secure the Blackrock orcs as their new force. "
             .. "Nefarian then comes to Blackrock Spire and takes command of Rend and Maim Blackhand and their forces. "
             .. "In World of Warcraft this guise is known as the Lord of Blackrock, who holds the Blackrock clan and various clans of ogres under his control.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Nefarian",
            "https://warcraft.wiki.gg/wiki/Beyond_the_Dark_Portal",
            "https://www.wowhead.com/classic/npc=10162/lord-victor-nefarius",
        },
        confidence = "confirmed",
    },
    -- ===================================================================== Blackwing Lair
    [11583] = {
        name = "Nefarian",
        zone = "Blackwing Lair",
        coords = "",
        alsoIn = { "Upper Blackrock Spire" },
        related = { 10162, 10184 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Beyond the Dark Portal",
                missions = { "Chapter 8" },
                role = "Sent by Deathwing with his sister Onyxia to secure the Blackrock orcs as a new force; he arrives at Blackrock Spire and takes command of the Blackhand brothers",
            },
        },
        story = "Nefarian is the eldest son of Deathwing and a black dragon who can also take a human guise. "
             .. "In the novel Beyond the Dark Portal, Deathwing orders Nefarian and his sister Onyxia to secure the Blackrock orcs as their new force, and Nefarian takes command of Rend and Maim Blackhand. "
             .. "He allied the Dark Horde with the black dragonflight and experimented with the blood of every dragonflight to create the chromatic dragonflight. "
             .. "In World of Warcraft he rules from the top of Blackrock Spire and from Blackwing Lair, where he has enslaved the red dragon Vaelastrasz and commands him to kill the heroes of Azeroth.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Nefarian",
            "https://warcraft.wiki.gg/wiki/Beyond_the_Dark_Portal",
            "https://www.wowhead.com/classic/npc=11583/nefarian",
        },
        confidence = "confirmed",
    },
    -- ===================================================================== Onyxia's Lair
    [10184] = {
        name = "Onyxia",
        zone = "Onyxia's Lair",
        coords = "",
        related = { 1749 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Beyond the Dark Portal",
                missions = { "Chapter 8" },
                role = "Ordered by Deathwing, together with her brother Nefarian, to secure the Blackrock orcs of Blackrock Spire as their new force",
            },
            {
                game = "BOOK",
                campaign = "Visage Day",
                missions = {},
                role = "Tells the young bronze dragon Chronormu that a mortal visage is a tool to control mortals, then attends his Visage Day ceremony at Wyrmrest Temple",
            },
        },
        story = "Onyxia is the daughter of Deathwing and the broodmother of the black dragonflight, and she appears as the Stormwind noblewoman Lady Katrana Prestor. "
             .. "In the novel Beyond the Dark Portal, Deathwing orders her and her brother Nefarian to secure the Blackrock orcs as their new force. "
             .. "She has been seen traveling to and from Blackrock Mountain, but her main lair is a fiery cave below the Dragonmurk. "
             .. "In the short story Visage Day she scorns the bronze dragon Chronormu for choosing a visage to relate to mortals. "
             .. "In World of Warcraft she guards the eggs of her new brood in that lair and will answer any threat with terrible wrath.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Onyxia",
            "https://warcraft.wiki.gg/wiki/Beyond_the_Dark_Portal",
            "https://warcraft.wiki.gg/wiki/Visage_Day_(short_story)",
            "https://www.wowhead.com/classic/npc=10184/onyxia",
        },
        confidence = "confirmed",
    },
    -- ===================================================================== Blackrock Depths
    [8929] = {
        name = "Princess Moira Bronzebeard",
        zone = "Blackrock Depths",
        coords = "",
        related = { 2784 },
        appearances = {
            {
                game = "BOOK",
                campaign = "The Shattering: Prelude to Cataclysm",
                missions = {},
                role = "Returns to Ironforge with her infant son to claim the throne, and is spared by Varian Wrynn when Anduin pleads for her life",
            },
            {
                game = "BOOK",
                campaign = "Fire and Iron",
                missions = {},
                role = "Plans to reforge the Hammer of the High King as a symbol of dwarven unity, but is outmaneuvered when Kurdran Wildhammer smashes the Wildhammer piece",
            },
            {
                game = "BOOK",
                campaign = "War Crimes",
                missions = { "Chapter 1", "Chapter 30" },
                role = "Travels to Pandaria for Garrosh Hellscream's trial, where a vision shows how Varian almost executed her",
            },
            {
                game = "BOOK",
                campaign = "The Lilac and the Stone",
                missions = {},
                role = "Broods over dwarven politics and her son Dagran's future in Shadowforge City, and tells him the time for learning is over",
            },
        },
        story = "Moira Bronzebeard is the daughter of King Magni of Ironforge. "
             .. "While riding to help Lakeshire, she was captured by Dark Iron dwarves in the Burning Steppes and brought to Emperor Dagran Thaurissan in Shadowforge City. "
             .. "She fell in love with him, and when Magni sent a team that killed Dagran she refused to come home and announced that she was pregnant. "
             .. "In the novel The Shattering: Prelude to Cataclysm she returns to Ironforge with her son to claim the throne, and Varian Wrynn spares her at Anduin's plea. "
             .. "In World of Warcraft you meet her in Shadowforge City, in Blackrock Depths.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Moira_Thaurissan",
            "https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm",
            "https://warcraft.wiki.gg/wiki/Fire_and_Iron",
            "https://warcraft.wiki.gg/wiki/War_Crimes",
            "https://warcraft.wiki.gg/wiki/The_Lilac_and_the_Stone",
            "https://www.wowhead.com/classic/npc=8929/princess-moira-bronzebeard",
        },
        confidence = "confirmed",
    },
    -- ===================================================================== Scholomance
    [10508] = {
        name = "Ras Frostwhisper",
        zone = "Scholomance",
        coords = "",
        appearances = {
            {
                game = "FK",
                campaign = "The Last Days of Lordaeron (Human)",
                missions = { "Siege" },
                role = "Boss: leads cultists out of Andorhal against the Lordaeron bases and is cornered by Garek Bandarion and the Silver Hand before he teleports away to Stratholme",
            },
            {
                game = "FK",
                campaign = "The Last Days of Lordaeron (Human)",
                missions = { "Vengeance" },
                role = "Boss: raised as a lich in the Stratholme slaughterhouse, then defeated by Garek Bandarion and Ilastar Songbreeze",
            },
        },
        story = "Ras Frostwhisper was a hedge mage from Stromgarde who joined the Cult of the Damned early and rose through its ranks. "
             .. "In Siege he led cultists out of Andorhal and fought Garek Bandarion before teleporting away to Stratholme. "
             .. "There he cut his own throat and was raised as a lich by the Lich King, then was attacked by Garek and Ilastar Songbreeze, though he swore he would meet them again. "
             .. "In World of Warcraft he is the favored pupil of Kel'Thuzad and oversees everything that happens in the necromancy school of Scholomance.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Ras_Frostwhisper",
            "https://warcraft.wiki.gg/wiki/Siege_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/Vengeance_(WC3_Human)",
            "https://www.wowhead.com/classic/npc=10508/ras-frostwhisper",
        },
        confidence = "confirmed",
    },
    -- ===================================================================== Stratholme
    [10440] = {
        name = "Baron Rivendare",
        zone = "Stratholme",
        coords = "",
        related = { 10508 },
        appearances = {
            {
                game = "FK",
                campaign = "The Last Days of Lordaeron (Human)",
                missions = { "Treachery", "Vengeance" },
                role = "Boss: reveals himself as a Cult of the Damned traitor in the Capital City sewers and raises captives as ghouls (Treachery); is killed by Garek Bandarion in his Stratholme slaughterhouse (Vengeance)",
            },
            {
                game = "FK",
                campaign = "Forsaken Kingdom (Undead)",
                missions = { "War of the Damned" },
                role = "Boss: Kel'Thuzad's champion in Naxxramas, who fights Garek Bandarion, Anya and Leonid Barthalomew and is raised again",
            },
        },
        story = "Baron Titus Rivendare was a rich landowner in Stratholme and a friend of Kel'Thuzad, who convinced him to join the Cult of the Damned, where he became a high-ranking member. "
             .. "In Treachery he oversaw the torture of caged soldiers in the sewers beneath Capital City, and in Vengeance Garek Bandarion killed him in his slaughterhouse. "
             .. "He was raised as a death knight and given control of the burning remains of Stratholme. "
             .. "In World of Warcraft he holds Stratholme against the Scarlet Crusade and coordinates the Lich King's efforts in the Plaguelands.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Baron_Rivendare",
            "https://warcraft.wiki.gg/wiki/Treachery_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/Vengeance_(WC3_Human)",
            "https://warcraft.wiki.gg/wiki/War_of_the_Damned_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=10440/baron-rivendare",
        },
        confidence = "confirmed",
    },
    [10813] = {
        name = "Balnazzar",
        zone = "Stratholme",
        coords = "",
        related = { 2425, 10181 },
        appearances = {
            {
                game = "TFT",
                campaign = "Legacy of the Damned (Undead)",
                missions = { "King Arthas", "The Flight from Lordaeron", "A Kingdom Divided", "A New Power in Lordaeron" },
                role = "Dreadlord villain: with his brothers he seizes the Capital City from Arthas and asks Sylvanas to join the coup; is the final enemy commander in A New Power in Lordaeron",
            },
        },
        story = "Balnazzar was one of three dreadlords left in Lordaeron to oversee the Burning Legion's conquest. "
             .. "After Arthas returned from Kalimdor, he and his brothers took the Capital City from him. "
             .. "Sylvanas laid siege to his forces and had Varimathras execute him, but the execution was faked. "
             .. "He then took the body of Saidan Dathrohan and became Grand Crusader of the Scarlet Crusade. "
             .. "In World of Warcraft he is in Stratholme, using that disguise to manipulate the Scarlet Crusade.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Balnazzar",
            "https://warcraft.wiki.gg/wiki/King_Arthas_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/The_Flight_from_Lordaeron_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/A_Kingdom_Divided_(WC3_Undead)",
            "https://warcraft.wiki.gg/wiki/A_New_Power_in_Lordaeron_(WC3_Undead)",
            "https://www.wowhead.com/classic/npc=10813/balnazzar",
        },
        confidence = "confirmed",
    },
    [10812] = {
        name = "Grand Crusader Dathrohan",
        zone = "Stratholme",
        coords = "",
        related = { 10813, 10435, 1855 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Tides of Darkness",
                missions = {},
                role = "Lordaeron knight chosen by Archbishop Faol, with Uther, Tirion, Turalyon and Gavinrad, as one of the first Knights of the Silver Hand",
            },
            {
                game = "BOOK",
                campaign = "Of Blood and Honor",
                missions = { "Chapter 5", "Chapter 7" },
                role = "As Lord Commander he has his friend Tirion Fordring tried for treason after the orc Eitrigg is captured, and watches the planned execution in Stratholme",
            },
        },
        story = "Saidan Dathrohan was a knight of Lordaeron and one of the first Knights of the Silver Hand. "
             .. "In the novel Of Blood and Honor he made Stratholme his seat as Lord Commander, and sent his old friend Tirion Fordring to trial for treason. "
             .. "After the Third War the dreadlord Balnazzar possessed his body and used it to lead the Scarlet Crusade as Grand Crusader. "
             .. "In World of Warcraft the possessed Saidan leads the Crimson Legion from the Scarlet Bastion in the ruins of Stratholme.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Saidan_Dathrohan",
            "https://warcraft.wiki.gg/wiki/Of_Blood_and_Honor",
            "https://warcraft.wiki.gg/wiki/Tides_of_Darkness",
            "https://www.wowhead.com/classic/npc=10812/grand-crusader-dathrohan",
        },
        confidence = "confirmed",
    },
    [10435] = {
        name = "Magistrate Barthilas",
        zone = "Stratholme",
        coords = "",
        related = { 3144 },
        appearances = {
            {
                game = "BOOK",
                campaign = "Of Blood and Honor",
                missions = { "Chapter 5", "Chapter 7" },
                role = "Tirion Fordring's second at Mardenholde Keep: finds and captures the orc Eitrigg together with Saidan Dathrohan, oversees Tirion's prosecution and plans Eitrigg's torture and execution",
            },
        },
        story = "Barthilas was a young paladin who served under Tirion Fordring at Mardenholde Keep, and the Second War had killed his parents and left him hating orcs. "
             .. "In the novel Of Blood and Honor he oversaw Tirion's prosecution for defending the orc Eitrigg and planned Eitrigg's torture and execution. "
             .. "When Thrall's New Horde attacked Stratholme, an orc speared him in the chest, but he survived and took over Mardenholde after Tirion's exile. "
             .. "He later became Magistrate of Stratholme until Arthas killed him and his people during the Culling. "
             .. "In World of Warcraft he haunts Stratholme as an undead wight in the service of the Scourge.",
        items = {},
        sources = {
            "https://warcraft.wiki.gg/wiki/Magistrate_Barthilas",
            "https://warcraft.wiki.gg/wiki/Of_Blood_and_Honor",
            "https://www.wowhead.com/classic/npc=10435/magistrate-barthilas",
        },
        confidence = "confirmed",
    },
}

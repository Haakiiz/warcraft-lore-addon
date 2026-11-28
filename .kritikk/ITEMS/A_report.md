# Group A report: veterans and their items (round 2026-11-28)

Output: `.kritikk/ITEMS/A_items.lua` (104 items, 15 veteran blocks; Data.lua syntax).
Sources: `candidates.json` via `item_lookup.py npc`, wiki pages via the cache, and missing pages fetched with the raw URL (UA WarcraftLoreAddonResearch/0.3, 1 s apart). Classic IDs used; SoD-only and Retail-only items rejected.
Already in the database: none (all 25 veterans have empty `existing_item_ids`).

Rule applied to turn-ins: an objective delivered to the veteran is KEPT when it is their own quest item or memento. Generic commodities (food, mithril, ore, venom, meat, shards of a generic chain) are REJECTED even when delivered to them.

---

## 11036 Leonid Barthalomew the Revered (199 candidates)

KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Crown of the Penitent | 13216 | quest reward (Houses of the Holy, starts and ends at Leonid) | "rewards = Crown of the Penitent or Band of the Penitent" | Houses of the Holy |
| Band of the Penitent | 13217 | quest reward (same) | "Band of the Penitent" | Houses of the Holy |
| Stratholme Holy Water | 13180 | turn-in to Leonid | "Return to Leonid Barthalomew the Revered when you have collected enough of the blessed fluid." | Houses of the Holy |
| Frozen Eggs | 13761 | objective, delivered to him | "Bring the Frozen Eggs to Leonid Barthalomew in the Eastern Plaguelands." | Leonid Barthalomew (quest) |
| Keepsake of Remembrance | 13585 | objective, shown to him | "Show him the Keepsake of Remembrance and tell him all that you have discovered." | The Dying, Ras Frostwhisper |
| Soulbound Keepsake | 13624 | objective, taken to him | "Take the Soulbound Keepsake to Leonid Barthalomew in Eastern Plaguelands." | Menethil's Gift (2) |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Dawnstalker, Duskwraith, Fireleaf, Heretic, Inquisition, Lightbreaker, Soulcrusher, Waywatcher, Revelation sets (about 185 items, IDs 239512-240153 and similar) | various | vendor goods bought with Consecrated tokens; SoD-era | "Sells" table, e.g. "Dawnstalker Belt / Consecrated Waistguard" |
| Misplaced Shooter 277255, Mug of Muddled Memories 277247, Tim's Lost Rib 282064 | 277255, 277247, 282064 | generic rewards of Leonid's Letter, which ends with Glix Xizzix (delivery job) | "rewards = Tim's Lost Rib or Mug of Muddled Memories or Misplaced Shooter" |
| Greater Mana Potion 6149, Superior Healing Potion 3928 | 6149, 3928 | generic consumable rewards of Houses of the Holy | "5 Superior Healing Potion, 5 Greater Mana Potion" |
| Dawn's Gambit | 12368 | provided item of the Betina Bigglezink chain, not his | "provided as an objective for Dawn's Gambit (quest)" |
| Drinkable Stratholme Holy Water 227888, Orders from the High General 237143, Research Notes (SoD) 242258, Emergency items | 227888, 237143, 242258 | SoD-only items (IDs above 200000, no Classic version) | SoD-only sections |
| Soulbound Keepsake quest-only copy 13752 | 13752 | second ID of the same item; Classic ID 13624 kept | "Soulbound Keepsake [13624, 13752]" |

Already in database: none.

---

## 7564 Marin Noggenfogger (24 candidates)

KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Noggenfogger Elixir | 8529 | quest item Marin creates | "Marin Noggenfogger wants you to speak to him again after he creates his elixir." | Noggenfogger Elixir (quest) |
| Violet Powder | 8528 | turn-in to Marin | "Sprinkle wants you to take the Violet Powder to Marin Noggenfogger in Gadgetzan." | Delivery for Marin |
| Laden Dew Gland | 8428 | turn-in to Marin | "Collect a Laden Dew Gland and bring it to Marin Noggenfogger in Gadgetzan." | The Thirsty Goblin |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Violet Tragan | 8526 | ingredient for Sprinkle's quest, not his | "Sprinkle in Gadgetzan wants you to collect a Violet Tragan" |
| Thistleshrub Dew | 8603 | not tied to his quest objectives | "quest starts at NPC: In Good Taste" |
| Hearthstone | 6948 | generic quest reward | "quest starts at NPC: A Particularly Potent Potion" |
| Noggenfogger Deluxe with Lime 226372, Semi-Deluxe Noggenfogger Elixirs 226157, Sliced Lime 226203, Noggenfogger's Recommendation 227663 | as listed | ID above 200000 (SoD copy), not checked page by page | Potion Commotion / Been Savin' This One |
| Undermine items: Undermine Revolutionary set 232356-232408, Trigger-Sniffer set 232768-232786, Public Defender's Coat 234125, The Severance Package 235516, Zirdo's Ledger 224797, Void-Touched Valorstone 225896, Enchanted Runed Undermine Crest 224072 | as listed | Undermine is a Retail zone | "We Own the Streets" etc. |
| Emergency Healthstone 228417 | 228417 | SoD-only | "quest: Urgent Recovery" |

---

## 1749 Lady Katrana Prestor (Onyxia) (19 candidates)

KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Head of Onyxia (Classic) | 18423 | drop | "Onyxia (Classic) ... Loot: the Head of Onyxia (Classic)" | Onyxia (Classic) |
| Dragonslayer's Signet | 18403 | reward of the chain started by her head | "The quest chain starts from Head of Onyxia (Classic) after you loot it from Onyxia's corpse." | Onyxia (Classic) |
| Onyxia Tooth Pendant | 18404 | reward (same chain) | same | Onyxia (Classic) |
| Onyxia Blood Talisman | 18406 | reward (same chain) | same | Onyxia (Classic) |
| Onyxia Hide Backpack | 17966 | drop | "one Onyxia Hide Backpack" | Onyxia (Classic) |
| Mature Black Dragon Sinew | 18705 | drop | "Onyxia drops a Mature Black Dragon Sinew in about one of every four kills" | Onyxia (Classic) |
| Draconic for Dummies (6) | 21108 | drop | "Onyxia drops Draconic for Dummies (6) for this chain." | Onyxia (Classic) |
| Scale of Onyxia | 15410 | skinning drop | "skin Onyxia to obtain two to four Scale of Onyxia" | Onyxia (Classic) |
| Tier 2 heads: Bloodfang Hood 16908, Dragonstalker's Helm 16939, Halo of Transcendence 16921, Helmet of Ten Storms 16947, Helm of Wrath 16963, Judgment Crown 16955, Nemesis Skullcap 16929, Netherwind Crown 16914, Stormrage Cover 16900 | as listed | drop (two per kill) | "Onyxia will drop two Tier 2 headpieces" | Onyxia (Classic); Tier 2 Head itembox |
| Ancient Cornerstone Grimoire 17067, Deathbringer 17068, Eskhandar's Collar 18205, Ring of Binding 18813, Sapphiron Drape 17078, Shard of the Scale 17064, Vis'kag the Bloodletter 17075 | as listed | drop (non-set loot) | "Onyxia non-set loot" itembox | Onyxia (Classic) |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Lok'delar, Stave of the Ancient Keepers 18715; Rhok'delar, Longbow of the Ancient Keepers 18713 | 18715, 18713 | hunter chain started by the Ancient Petrified Leaf, not her | "The hunter quest chain for Rhok'delar ... starts from the Ancient Petrified Leaf" |
| Ancient Petrified Leaf 18703 | 18703 | quest starter from the Cache of the Firelord | "linked from NPC page" (quest context) |
| Nostro's Compendium of Dragon Slaying 18401 | 18401 | warrior/paladin chain item from Dire Maul | "a rare drop from Dire Maul bosses" |
| Drakefire Amulet 16309 and Drakefire Amulet (quest item) 204214 | 16309, 204214 | lore mention; quest item of Will to Survive | "Onyxia manipulated a conflict..." |
| Shaw's Report 1353; Report on the Defias Brotherhood 2956; Seal of Wrynn 2933 | as listed | quest items of Baros Alexston / King Varian's audience, not hers | "Deliver Baros Alexston's report ... to King Varian Wrynn" |
| Tabard of Stormwind 11364, Bolvar's Decree 11368 | as listed | generic rewards of The True Masters | "quest: The True Masters (4)" |
| The Scepter of the Shifting Sands 21175 | 21175 | AQ chain item from Baristolth | "What Tomorrow Brings (Gates of Ahn'Qiraj)" |

---

## 11832 Keeper Remulos (15 candidates)

KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Blue Scepter Shard 21137, Red Scepter Shard 21138, Green Scepter Shard 21139 | as listed | quest item he hands out | "quest starts at NPC: The Champion Returns" / "Green Scepter Shard (provided)" | The Champion Returns |
| Fragment of the Nightmare's Corruption (Ashenvale) 21147, (Duskwood) 21149, (Feralas) 21148, (Hinterlands) 21146 | as listed | turn-in to him | "collect a Fragment of the Nightmare's Corruption from each" (start and end: Keeper Remulos) | The Nightmare's Corruption |
| Nightmare Engulfed Object | 20644 | quest object that ends at him | "end = Keeper Remulos" | Shrouded in Nightmare |
| Seed of Life | 17760 | turn-in to him | "Seek out Remulos in Moonglade and give him the Seed of Life." | Seeds of Life |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Malfurion's Signet Ring | 20600 | reward of Waking Legends; about Malfurion (borderline, see Open questions) | "quest starts at NPC: Waking Legends" |
| Drake Tooth Necklace 21531, Drudge Boots 21532 | as listed | epic rewards of The Nightmare Manifests; borderline | "Do not let Keeper Remulos perish" |
| Anaya's Pendant 5382 | 5382 | Something Worth Celebrating ends with Merithra, not him | "quest: Something Worth Celebrating" |
| Mark of Remulos 21515 | 21515 | reward of Logistics Task Briefing XI / The Ultimate Deception, not him | "starts from [[Logistics Task Briefing XI]]" |
| The Scepter of the Shifting Sands 21175 | 21175 | final AQ reward from Anachronos | "The Champion Returns ... Anachronos" |

---

## 7800 Mekgineer Thermaplugg (13 candidates)

KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Electromagnetic Gigaflux Reactivator | 9492 | drop | "drops from Mekgineer Thermaplugg in Gnomeregan" | Electromagnetic Gigaflux Reactivator |
| Thermaplugg's Safe Combination | 9299 | objective of Rig Wars, carried to Nogg | "Retrieve the Rig Blueprints and Thermaplugg's Safe Combination from Gnomeregan and bring them to Nogg" | Rig Wars |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Civinad Robes 9623, Dual Reinforced Leggings 9625, Triprunner Dungarees 9624 | as listed | generic rewards of Rig Wars (starts with Nogg) | "quest: Rig Wars" |
| Rig Blueprints 9153 | 9153 | generic objective | "Retrieve the Rig Blueprints" |
| Fairywing Mantle 9536, Fire-welded Bracers 9535, Technician's Bracers 270042 | as listed | rewards of A Fine Mess (starts with Kernobee) | "Escort Kernobee..." |
| Whirring Bronze Gizmo 4375, Handful of Copper Bolts 4359, Dirty Trogg Cloth 2591 | as listed | Operation: Gnomeregan, given by High Tinker Mekkatorque | "Help King Mekkatorque with the assault on Gnomeregan" |
| Mithril Ore 3858 | 3858 | commodity | linked from NPC page |

---

## 7804 Trenton Lighthammer (11 candidates)

none found as veteran items (checked: Trenton Lighthammer, The World At Your Feet, The Mithril Kid, A Good Head On Your Shoulders)

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Ornate Mithril Boots 7936, Ornate Mithril Pants 7926, Ornate Mithril Breastplate 7935, Ornate Mithril Gloves 7927, Ornate Mithril Shoulder 7928, Ornate Mithril Helm 7937, Mithril Coif 7931, Heavy Mithril Boots 7933, Heavy Mithril Breastplate 7930 | as listed | generic Mithril quest items and rewards, generic blacksmith quests | "Bring two Heavy Mithril Boots and one Ornate Mithril Pants to Trenton Lighthammer" |
| Glimmering Mithril Insignia 10418 | 10418 | generic reward (Did You Lose This? page not in the cache) | "quest starts at NPC: Did You Lose This?" |
| Sul'thraze the Lasher 9372 | 9372 | the sword he hunts, not in his possession (lore only) | "is searching for the legendary sword known as Sul'thraze the Lasher" |

---

## 1855 Tirion Fordring (10 candidates)

KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Fordring's Seal | 16058 | reward of In Dreams, which ends with him | "end = Tirion Fordring" | In Dreams |
| Mark of Fordring | 15411 | reward of In Dreams | same | In Dreams |
| Of Love and Family | 14679 | painting turned in to him | "Travel to Stratholme ... find the painting 'Of Love and Family'" (end: Tirion Fordring) | Of Love and Family (2) |
| Symbol of Lost Honor | 14625 | quest item he hands out | "quest starts at NPC: Of Lost Honor" | Tirion Fordring |
| Taelan's Hammer | 14613 | quest item he hands out | "quest starts at NPC: Of Forgotten Memories" | Tirion Fordring |
| Tirion's Gift | 14872 | memento he hands out, shown to Myranda | "Travel to Uther's Tomb ... Show Myranda Tirion's Gift" (start: Tirion Fordring) | Find Myranda |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Ornate Adamantium Breastplate 15413, Shimmering Platinum Warhammer 15418, Shroud of the Exile 15421 | as listed | generic rare rewards of In Dreams (borderline, see Open questions) | "quest ends at NPC: In Dreams" |
| Slab of Carrion Worm Meat 13853 | 13853 | commodity, 15 slabs turned in | "Return to Tirion Fordring when you have gathered 15 Slabs of Carrion Worm Meat." |

---

## 10508 Ras Frostwhisper (8 candidates; plus Scholomance loot table)

KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Human Head of Ras Frostwhisper | 13626 | drop | "Loot ... *[[Human Head of Ras Frostwhisper]]" | Ras Frostwhisper |
| Soulbound Keepsake | 13624 | used on him in the quest | "Using the Soulbound Keepsake for the quest can be tricky" | Ras Frostwhisper |
| Keepsake of Remembrance | 13585 | keepsake used on him in the Menethil's Gift chain | "Show him the Keepsake of Remembrance" | The Dying, Ras Frostwhisper |
| Alanna's Embrace 13314, Bonechill Hammer 14487, Boneclenched Gauntlets 14525, Death's Clutch 14503, Freezing Lich Robes 14340, Frostbite Girdle 14502, Iceblade Hacker 13952, Intricately Runed Shield 18696, Maelstrom Leggings 14522, Magister's Mantle 16689, Shadowy Mail Greaves 18694, Shivery Handwraps 18693, Spellbound Tome 18695 | as listed | drop (loot table) | "Loot" lootbox listing these names | Ras Frostwhisper |
| Recipe: Flask of Supreme Power | 13521 | drop (loot table) | "Recipe: Flask of Supreme Power#Classic" | Ras Frostwhisper |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Crown of Caer Darrow 13986, Darrowdirk 206478, Darrowshire Strongguard 14002, Darrowspike 13984, Warblade of Caer Darrow 13982 | as listed | rewards of The Lich, Ras Frostwhisper, started by Magistrate Marduke (not him) | "quest: The Lich, Ras Frostwhisper (Classic)" |
| Corruptor's Scourgestone 206375 | 206375 | WotLK-era Naxxramas token (Wards of the Dread Citadel) | "This item drops from bosses in Naxxramas after completing the Wards of the Dread Citadel achievement." |

---

## 15990 Kel'Thuzad (7 candidates; plus Naxxramas 40-man loot table)

KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| The Phylactery of Kel'Thuzad | 22520 | drop | "quest item dropped by Kel'Thuzad" / 40-man Loot | Kel'Thuzad (Classic) |
| Staff Head of Atiesh | 22733 | drop (40-man loot) | "Loot: Staff Head of Atiesh" | Kel'Thuzad (Classic) |
| Doomfinger 22821, Gressil, Dawn of Ruin 23054, Hammer of the Twisting Nether 23056, Gem of Trapped Innocents 23057, Kingsfall 22802, Might of Menethil 22798, Nerubian Slavemaker 22812, Shield of Condemnation 22819, Soulseeker 22799, Stormrage's Talisman of Seething 23053, The Hungering Cold 23577 | as listed | drop (40-man loot) | "Loot (40 man)" lootbox | Kel'Thuzad (Classic) |
| Bonescythe Ring 23060, Frostfire Ring 23062, Ring of Faith 23061, Ring of Redemption 23066, Ring of the Cryptstalker 23067, Ring of the Dreadnaught 23059, Ring of the Dreamwalker 23064, Ring of the Earthshatterer 23065 | as listed | tier ring drop | "drops from Kel'Thuzad (Classic)" | item pages |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Base of Atiesh | 22734 | quest item from Anachronos (Caverns of Time), not his loot | "Anachronos ... wants the Staff Head of Atiesh and the Base of Atiesh" |
| Corrupted Ashbringer | 22691 | lore mention only | "Destroyed... by... Kel'Thuzad" (Ashbringer section) |
| Mark of the Champion (caster) 23207, (physical) 23206 | as listed | reward of The Fall of Kel'Thuzad, ended by Father Inigo Montoy, not him | "end = Father Inigo Montoy" |
| Compendium of the Fallen 5535 | 5535 | quest book, lore; not on his loot table | "Classic only" / quest objective |

---

## 246748 Archmage Modera (7 candidates)

none found as veteran items (checked: Archmage Modera, Heart of Disruption (Horde), The Harbinger)

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Battle Spaulders 279842, Enchanted Sandals 279843, Striking Staff 279844 | as listed | rewards of Heart of Disruption (Horde), ended by Magus Wordeen Voidglare | "end = Magus Wordeen Voidglare" |
| Bow of the Ranger Captain 213269, Dalaran Hearthstone (quest item) 223988, Winding Slitherdrake: Void Scales 213561 | as listed | The Harbinger starts with Khadgar's Summons and ends with Khadgar | "end = Archmage Khadgar" |
| White Stallion Bridle 12353 | 12353 | linked on the page, but no tie to Modera found in the page text | (not in page text) |

---

## 4454 Fizzle Brassbolts (6 candidates)

KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Fizzle Brassbolts' Letter | 5827 | handed out by him, delivered to Martek | "Bring Fizzle Brassbolts' Letter to Martek the Exiled in the Badlands." | Martek the Exiled (quest) |
| Fizzle's Zippy Lighter | 6729 | reward of News for Fizzle, which ends with him | "Speak with Fizzle Brassbolts in the Shimmering Flats." | News for Fizzle |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Gnomish Mechanic's Gloves | 6732 | generic reward of News for Fizzle | "quest ends at NPC: News for Fizzle" |
| Delicate Car Parts 5802, Salty Scorpid Venom 5794, Indurium Ore 5833 | as listed | commodities from Fizzle's/Kravel's quests | "Bring 6 Salty Scorpid Venoms to Fizzle Brassbolts" |

---

## 10429 Warchief Rend Blackhand (6 candidates)

KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Head of Rend Blackhand | 12630 | drop | "drops from Warchief Rend Blackhand in Blackrock Spire" | Head of Rend Blackhand |
| Blackhand Doomsaw | 12583 | drop | "drops from Warchief Rend Blackhand in Upper Blackrock Spire" | Blackhand Doomsaw |
| Dal'Rend's Sacred Charge | 12940 | drop (set piece) | "Both items drop from Warchief Rend Blackhand in Upper Blackrock Spire." | Dal'Rend's Arms |
| Dal'Rend's Tribal Guardian | 12939 | drop (set piece) | same | Dal'Rend's Arms |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Blackhand's Breadth 13965, Eye of the Beast 13968, Mark of Tyranny 13966 | as listed | rewards of For The Horde!, which starts with Thrall | "start = Thrall" |
| Blackhand's Command 18987 | 18987 | quest objective, lore | "Classic only (patch 6.2.2)" |

---

## 466 General Marcus Jonathan (5 candidates)

KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Commendation - Elwynn Forest | 1356 | quest item he hands out | "General Marcus Jonathan ... will accept a commendation from Elwynn Forest." | Stormwind Commendation |
| The State of Lakeshire | 1293 | turn-in to him (Messenger to Stormwind) | "quest ends at NPC: Messenger to Stormwind" | Messenger to Stormwind |
| The General's Response | 1294 | letter he hands out | "Take General Marcus Jonathan's letter of response to Magistrate Solomon" | Messenger to Stormwind (2) |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Duty Bound Leggings 279868, Remembrance Armor 279869 | as listed | rewards of Bloodied Insignia (quest about the insignias, not him) (borderline) | "quest ends at NPC: Bloodied Insignia (quest)" |

---

## 4706 Razzeric (4 candidates)

KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Seaforium Booster | 5862 | quest item he hands out | "Retrieve the Seaforium Booster for Razzeric in the Shimmering Flats." | Razzeric's Tweaking |
| Modified Seaforium Booster | 5865 | turn-in to him | "Return the Modified Seaforium Booster to Razzeric on the Shimmering Flats." | Safety First (2) |
| Razzeric's Customized Seatbelt | 6726 | reward of Safety First (2), which ends with him | "end = Razzeric" | Safety First (2) |
| Razzeric's Racing Grips | 6727 | reward of Safety First (2) | same | Safety First (2) |

REJECT: none.

---

## 12939 Doctor Gustaf VanHowzen (4 candidates)

KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Triage Bandage | 16991 | quest item he hands out | "Save patients by using Triage Bandages to tend to their wounds." | Triage (Alliance) |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Runecloth Bandage 14529, Heavy Runecloth Bandage 14530, Heavy Mageweave Bandage 8545 | as listed | vendor goods | "linked from NPC page" (Sells) |

---

## 4967 Archmage Tervosh (3 candidates)

none found as veteran items (checked: Archmage Tervosh, Shadowshard Fragments (Alliance))

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Shadowshard Fragment 17756 | 17756 | commodity collected in Maraudon | "Collect 10 Shadowshard Fragments from Maraudon" |
| Prodigious Shadowshard Pendant 17773, Zealous Shadowshard Pendant 17772 | as listed | generic rewards of the Alliance Shadowshard quest | "quest starts at NPC: Shadowshard Fragments (Alliance)" |

---

## 272526 Glix Xizzix (3 candidates)

none found as veteran items (checked: Glix Xizzix, Leonid's Letter)

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Misplaced Shooter 277255, Mug of Muddled Memories 277247, Tim's Lost Rib 282064 | as listed | generic rewards of Leonid's Letter (delivery to Glix) | "quest ends at NPC: Leonid's Letter" |

---

## 14889 Emeriss (2 candidates)

none found (checked: Emeriss, Emeriss (Classic))

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Ultra-Flash Shadow Reflector 18639 | 18639 | lore mention: counter to her spell, not a drop | "it was possible to counter Emeriss' Corruption of the Earth-spell with the device Ultra-Flash Shadow Reflector" |
| Greater Nature Protection Potion 13458 | 13458 | lore mention | "Greater Nature Protection Potions seemed to absorb damage" |

---

## 13442 Arch Druid Renferal (1 candidate)

KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Storm Crystal | 17423 | turn-in to her (Ivus the Forest Lord) | "Slay Horde and loot a Storm Crystal and return it to Archdruid Renferal in Alterac Valley." | Ivus the Forest Lord (Alterac Valley) |

---

## 5087 Do'gol (1 candidate)

KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Blackened Iron Shield | 5919 | turn-in to him (The Black Shield, Horde 2) | "Show the Blackened Iron Shield to Do'gol in Brackenwall Village." | The Black Shield (Horde 2) |

---

## Veterans with no candidates and nothing found

- 6928 Innkeeper Grosk: 17 candidates, all food, drink or vendor goods (REJECT), or quest rewards. Ukor's Burden 7629 (turn-in) rejected as a generic commodity. Checked: Innkeeper Grosk, A Peon's Burden.
- 3355 Saru Steelfury: none found (checked: Saru Steelfury; quest pages only).
- 4965 Pained: none found (checked: Pained).
- 3679 Naralex: none found (checked: Naralex; quest pages only).
- 2547 Ironpatch: none found (checked: Ironpatch; Cata quests only).

---

## Open questions

1. Houses of the Holy rewards (Crown and Band of the Penitent) are kept: the quest is started and ended by Leonid and its text is his own speech about his undeath. Drop them if you want quest rewards limited to named items.
2. Onyxia's Dragonslayer's Signet, Tooth Pendant and Blood Talisman are rewards of quests started by the Head of Onyxia (an item), not by an NPC. Kept as "about her".
3. Onyxia's tier 2 heads: the Classic Onyxia page says she drops them; the Bloodfang Hood page says Nefarian in Blackwing Lair since 3.2.2. Kept, both are Classic. The non-set loot (Deathbringer, Vis'kag etc.) is taken from the Onyxia (Classic) itembox.
4. Ras Frostwhisper's 13 gear items and the recipe are kept from the "Loot" lootbox on his page. Confirm they belong to him and not to a dungeon trash list.
5. Kel'Thuzad: 40-man loot only (the wiki lists 40-man; 10/25-man not checked). The Staff Head of Atiesh is kept as a Naxx drop, the Base of Atiesh is rejected.
6. Rejected borderline quest rewards that name the veteran: Malfurion's Signet Ring and the Nightmare Manifests gear (Remulos), Ornate Adamantium Breastplate, Shimmering Platinum Warhammer, Shroud of the Exile (Tirion), Mark of the Champion (Kel'Thuzad), Duty Bound Leggings and Remembrance Armor (Marcus), Blackhand's Breadth, Eye of the Beast, Mark of Tyranny (Rend). Tell me if you want any of these in.
7. Turn-in commodities rejected: Ukor's Burden (Grosk), Carrion Worm Meat (Tirion), Shadowshard Fragment (Tervosh), Salty Scorpid Venom, Indurium Ore, Delicate Car Parts (Fizzle), Mithril Ore (Thermaplugg).
8. Marin's SoD and Undermine items (IDs 224xxx-235xxx) were rejected by ID range and the Undermine zone without opening each page.
9. Rig Wars and Leonid's Letter rewards rejected as generic.
10. Leonid's Letter rewards (Misplaced Shooter, Mug of Muddled Memories, Tim's Lost Rib) are rejected for both Leonid and Glix Xizzix. The quest is his courier job, but the rewards are generic.

# Item round, group B (veterans), report

28 veterans. 35 items kept in `B_items.lua`. Wiki pages were read from the cache with `item_lookup.py`; uncached item pages `Mograine's Might`, `Aegis of the Scarlet Commander` were fetched raw (1 s pause, UA WarcraftLoreAddonResearch/0.3). Season of Discovery and retail-only (Undermine, Forever/retail 2xxxxx) items were rejected unless a Classic ID exists.

## Per veteran

### 3391 Gazlowe (Monte Gazlowe)
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Baron Longshore's Head | 5084 | turn-in | "Bring the head of [[Baron Longshore]] to [[Gazlowe]] in [[Ratchet]]." (quest end: Gazlowe) | WANTED: Baron Longshore |

REJECT (summary, 98 candidates)
| item | id | reason | quoted line |
|---|---|---|---|
| All Undermine/Forever quest rewards (Boreal x9, Guardbreaker x4, Grateful Goblin x8, Zirdo's x4, Trigger-Sniffer x4, Smuggled Nerubian x4, Desperate Goblin x4, Earthen Traveler x4, Undermine Revolutionary x3, Liberator x4, Casino/Specific Personages etc.) | 2xxxxx | retail-only, or generic reward | "...is a quest reward from [[...]]" |
| Flameflow 7000, Bilgewater Auto-Grappler, Anti-Darkfuse Pamphlets, Handful of B.I.R.D. Parts, Sputtering Taserblade, Zirdo's Ledger, Employee Schedule | 219392, 226823, 228196, 226824, 226391, 224797, 226380 | retail-only (Undermine) even though Gazlowe hands out or asks for them | "'''Flameflow 7000''' is provided by [[Monte Gazlowe]] for [[Burn It With Fire]]." |
| 99-Year-Old Port | 5334 | quest starts at Crane Operator Bigglefuzz, not Gazlowe | "...retrieve the bottle of 99-Year-Old Port from [[Mad Magglish]]" (Trouble at the Docks) |
| Blemished Wooden Staff, Harpy Wing Clipper, Hickory Shortbow, Padded Lamellar Boots, Wayfaring Gloves | 4938, 4932, 4931, 5320, 5337 | generic green quest rewards (Securing the Lines / Stolen Booty) | "'''Padded Lamellar Boots''' are a [[quest reward]] from [[Stolen Booty]]." |
| Fuel Regulator Blueprints, Telescopic Lens, Sack of Supplies, Fragile crate items | 5852, 5077, 4918 | not Gazlowe's: Cozzle's Footlocker, Stolen Supply Sack | "'''Sack of Supplies''' is contained in [[Stolen Supply Sack]] in [[Durotar]]." |
| Reagents / vendor goods / Ratchet items (Coal, Mining Pick, Flux, Thorium Bar, Runecloth, Ironweb Silk, Telescopic) | various | vendor goods or generic world drops | — |
| Dirk Greasedealer / Faerin Lothar items, Old Copy of Undermine Weekly, Renzik's Journal, Well-Worn Throwing Knives, Pristine Fishing Gear, Spare Uncrowned Vest, Zev'kall's Pheromone Emitter | various | retail-only or other NPC | — |

Already in the database: Gazlowe's Ledger 5080 (not repeated).
Open question: Shipment of Boots 5076 and Telescopic Lens 5077 are objectives of Stolen Booty ("Retrieve ... for [[Gazlowe]]", quest start Gazlowe). The quest infobox has no end NPC on the cached page, so these were not kept. If the end is confirmed as Gazlowe, add them as turn-ins.

### 16376 Craftsman Wilhelm
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Omarion's Handbook | 22719 | turn-in | "Non-crafters can take this book to [[Craftsman Wilhelm]]" (quest Omarion's Handbook ends at Wilhelm) | Omarion's Handbook |
| Frozen Rune | 22682 | turn-in | "Craftsman Wilhelm ... wants you to bring him 2 Frozen Runes, 2 Essence of Water, 2 Blue Sapphires" | The Only Song I Know... |
| Essence of Water | 7080 | turn-in | same | The Only Song I Know... |
| Blue Sapphire | 12361 | turn-in | same | The Only Song I Know... |
| Glacial / Icebane / Icy Scale / Polar Leggings (Classic) | 22700, 22699, 22702, 22701 | quest reward, borderline | "...rewards: Glacial Leggings (Classic) or Icebane Leggings (Classic) or Icy Scale Leggings (Classic) or Polar Leggings (Classic)" (quest start Wilhelm, his own recipe quest) | The Only Song I Know... |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Frosty Gloves/Leggings/Vest/Wrists | 236705, 237277, 236706, 236704 | SoD-only | "...crafted with Tailoring (300)..." |
| Ruined Lightforged Blade | 239196 | SoD-only | "...drops from [[High Commander Beatrix]] in the {{Sod|Scarlet Enclave}}." |
| Icebane/Glacial/Icy Scale/Polar sets (Bracers, Breastplate, Gauntlets, Vest, Gloves, Wrists, Tunic) and the crafted leggings | 22671 etc. | crafted or bought from Wilhelm after Exalted: vendor/crafted goods | "...can also be purchased from [[Craftsman Wilhelm]] after completing..." |
| Arcanite Bar, Thorium Bar, Enchanted Leather, Cured Rugged Hide, Heavy Scorpid Scale, Bolt of Runecloth, Strong/Weak Flux, Coal, Blacksmith Hammer, Mining Pick, Elemental Flux, Ironweb Spider Silk | various | reagents or vendor goods | — |
| Glacial Cloak/Gloves/Vest/Wrists recipes | — | crafted, not an NPC drop or turn-in | — |

No "Already in the database" entries.
Open question: the four Classic leggings are quest rewards from Wilhelm's own quest (Revered rep, the quest text is about his recipe). They are kept as borderline; drop them if rule 4 is read strictly.

### 14753 Illiyana Moonblaze
none kept.
REJECT: Warsong Gulch PvP rewards (Berserker Bracers, Caretaker's Cape, Dryad's Wrist Bindings, Forest Stalker's Bracers, Lorekeeper's Ring/Staff, Outrunner's Bow, Protector's Band/Sword, Rune of Duty/Perfection, Sentinel's Blade/Medallion, Sentinel's Chain/Lamellar/Leather/Lizardhide/Plate/Silk legs, Windtalker's Wristguards, Silverwing Battle Tabard): "...is a {{quality|rare}} [[Warsong Gulch]] [[PvP]] reward" (not her quests or drops). Vendor goods: Draughts, Rations, Bandages. Sentinel Basic/Standard/Advanced Care Package (19150-19152): quest reward from her quest, generic consumable (rejected; see open questions).
Open question: the three Sentinel Care Packages come from her own quests (quest start Illiyana). Rejected as generic consumable rewards.

### 928 Lord Grayson Shadowbreaker
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Azerothian Diamond | 12800 | turn-in | "Bring an Azerothian Diamond and a Pristine Black Diamond to [[Lord Grayson Shadowbreaker]]" | The Divination Scryer |
| Pristine Black Diamond | 18335 | turn-in | same | The Divination Scryer |
| Blessed Arcanite Barding | 18792 | turn-in | "Return with the Blessed Arcanite Barding to [[Lord Grayson Shadowbreaker]]" (quest end: Grayson) | Blessed Arcanite Barding (quest) |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Charger's Redeemed Soul | 18799 | objective of Judgment and Redemption, which ends at Darkreaver's Fallen Charger, not Grayson | "Give the [[Charger's Redeemed Soul]] ... to [[Darkreaver's Fallen Charger]]." |
| Arcanite Barding, Arcane Crystal, Arcanite Bar, Arthas' Tears, Runecloth, Stratholme Holy Water, Thorium Bar/Ore | 18753, 12363, 12360, 8836, 14047, 13180, 12359, 10620 | objectives of Collection of Goods (ends at Grimand Elmore) or generic | "Bring 40 Runecloth, 6 Arcanite Bars ... to [[Grimand Elmore]]" |
| Exorcism Censer | 18752 | Rohan's item, kept under 11406 | — |
| Manna-Enriched Horse Feed, Enriched Manna Biscuit | 18775, 13724 | turn-in for the Ancient Equine Spirit / Merideth Carlson, not Grayson | — |
| Divination Scryer | 18746 | quest starts with Grayson, but the item is made from the censer. Not kept, see open questions | "The Divination Scryer starts the Scryer segment..." |
| Menethil Statuette | 2625 | objective of Return the Statuette, not Grayson | "...provided as an objective for [[Return the Statuette]]." |
| Knight's Lance, Royal Dagger | 281296, 281297 | Forever quest rewards from A Friend of the Family (2) (generic choice) | "...rewards: Knight's Lance or Royal Dagger" |
| Gloves/Hands/Touch/Wraps of Renewal | 251274, 251277, 251276, 251275 | Forever rewards from Renewal for the Weary (Alonsus Faol's quest) | — |
| Faol's Benediction | 237811 | provided by Alonsus Faol, not Grayson | — |
| Blood of the Lightbringer | 231452 | SoD-only | — |

Open questions: Judgment and Redemption (quest start Grayson) rewards the Charger mount ("Able to summon Charger"). It is a spell, not an item, so nothing was added. Divination Scryer 18746 (quest item for the Scryer chain): probably a quest item he gives, but the wiki text says it is made from the censer, so it is not kept. Knight's Lance and Royal Dagger (Forever rewards) rejected as generic.

### 4047 Zor Lonetree
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Jeweled Pendant | 5942 | turn-in | "It is an objective of [[Marg Speaks]] and then provided for [[Report to Zor]]." (Report to Zor ends at Zor) | Jeweled Pendant / Report to Zor |
| Band of Allegiance | 18585 | quest reward, Zor's own quest (Service to the Horde, start and end Zor) | "You will be able to choose one of these rewards: [[Band of Allegiance]] [[Lonetree's Circle]]" | Service to the Horde |
| Lonetree's Circle | 18586 | same | same | Service to the Horde |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Grimoire of Fel Armor/Portal of Summoning/Soul Harvesting, Handbook of Commanding Shout/Meathook, Leaflets, Manuals, Revelations, Scrolls, Tomes, Treatises | 228797, 216748, 216747, 216746, 226403, 216764, 216771, 226394-226397, 216738, 226402, 216769, 216744, 216745, 216740, 216770, 226401 | Season of Discovery spell books only | "...teaches the [[Fel Armor (Season of Discovery)]] ability..." |

No "Already in the database" entries.

### 10184 Onyxia
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Head of Onyxia (Classic) | 18423 | drop | "'''Head of Onyxia''' drops from [[Onyxia (Classic)|Onyxia]] in [[Onyxia's Lair (Classic)|Onyxia's Lair]]." | Head of Onyxia (Classic) |
| Onyxia Hide Backpack | 17966 | drop | "'''Onyxia Hide Backpack''' drops from {{C|Onyxia}} in {{C|Onyxia's Lair}}." | Onyxia Hide Backpack |
| Mature Black Dragon Sinew | 18705 | drop | "...was a drop from [[Onyxia (Classic)]] in [[Onyxia's Lair (Classic)]]..." | Mature Black Dragon Sinew |
| Draconic for Dummies (6) | 21108 | drop | "'''Draconic for Dummies''' drops from [[Onyxia (tactics)|Onyxia]] in [[Onyxia's Lair]]." | Draconic for Dummies (6) |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Onyxia Tooth Pendant, Onyxia Blood Talisman | 18404, 18406 | quest rewards from Celebrating Good Times and For All To See, given by Varian and Thrall, not Onyxia | "...given by [[King Varian Wrynn]]..." |
| Dragonslayer's Signet | 18403 | quest rewards from Varian and Thrall quests | "This item was obtained from the following quests..." |
| Onyxia Scale Cloak | 15138 | leatherworking craft, not a drop | "...is a [[leatherworking]]-crafted item..." |
| Drakefire Amulet (16309 Classic key; 204214 quest item) | 16309, 204214 | attunement key, not her drop; 204214 is a retail item | — |
| Ancient Petrified Leaf, Lok'delar, Rhok'delar | 18703, 18715, 18713 | Hunter epic quest chain, not Onyxia | — |
| Nostro's Compendium, Scepter of Shifting Sands | 18401, 21175 | quest-chain items | — |
| Seal of Wrynn, Report on the Defias, Shaw's Report, Bolvar's Decree, Tabard of Stormwind | 2933, 2956, 1353, 11368, 11364 | other NPCs' quests | — |

### 11583 Nefarian
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Head of Nefarian | 19002 | drop | "The '''Head of Nefarian''' is dropped by [[Nefarian (tactics)|Nefarian]] in [[Blackwing Lair]]." | Nefarian |
| Red Scepter Shard | 21138 | drop | "The Red Scepter Shard drops from Nefarian in Blackwing Lair if he is killed within five hours of starting the raid." | Red Scepter Shard |
| From the Desk of Lord Victor Nefarius | 21142 | drop (late kill) | "...a note that players receive from Nefarian if they kill him more than five hours after activating the quest" | From the Desk of Lord Victor Nefarius |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Amulet of Shadow Shielding, Onyx Embedded Leggings | 21529, 21530 | quest rewards from Nefarius's Corruption, which is ended by Anachronos | "Players must also complete ... before {{NPC|Anachronos}} will offer the conclusion..." |
| Amulet of Draconic Subversion | 16787 | objective of Emberstrife, not Nefarian | "...provided as an objective for [[Emberstrife (quest)]]." |
| Crown of Destruction | 18817 | Ragnaros drop; Nefarius only wears it | "...drops from [[Ragnaros (tactics)|Ragnaros]] in the Molten Core." |
| Blue Scepter Shard | 21137 | drops from Maws | "...dropped from [[Maws]]..." |
| Green Scepter Shard | 21139 | quest chain item, not a drop | "...quest item, part of the Scepter of the Shifting Sands..." |
| Scepter of the Shifting Sands | 21175 | quest chain (crafted) | — |
| Onyxia Scale Cloak | 15138 | craft | — |

### 10162 Lord Victor Nefarius
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| From the Desk of Lord Victor Nefarius | 21142 | own thing (his desk note) | "'''From the Desk of Lord Victor Nefarius''' is a note..." | From the Desk of Lord Victor Nefarius |

REJECT: all other candidates are Nefarian's or other NPCs' (see 11583 above). Amulet of Shadow Shielding and Onyx Embedded Leggings are Nefarius's Corruption rewards ended by Anachronos.
Open question: is "the human guise of Nefarian" the same entity in the wiki? Both 10162 and 11583 point to the same wiki page; the note is kept under both.

### 3976 Scarlet Commander Mograine
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Mograine's Might | 7723 | drop (Two-Hand) | "'''Mograine's Might''' drops from [[Scarlet Commander Mograine]] in the [[Scarlet Monastery]]." | Mograine's Might (fetched) |
| Aegis of the Scarlet Commander | 7726 | drop (Off Hand shield) | "'''Aegis of the Scarlet Commander''' drops from [[Scarlet Commander Mograine]]..." | Aegis of the Scarlet Commander (fetched) |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Black Menace, Bonebiter, Orb of Lorica, Sword of Serenity | 6831, 6830, 11262, 6829 | quest rewards from In the Name of the Light (start Raleigh the Devout / Mograine only an objective) | "One of: Sword of Serenity, Bonebiter, Black Menace, Orb of Lorica." |
| Sword of Omen, Prophetic Cane, Dragon's Blood Necklace | 6802, 6803, 10711 | quest rewards from Into the Scarlet Monastery (start Bragor Bloodfist / Varimathras) | "...start = [[Bragor Bloodfist]]..." |
| Corrupted Ashbringer (Classic) and SoD copy | 22691, 239301 | Naxxramas loot, not Mograine; SoD copy rejected | — |

### 269127 Image of Archmage Modera (Forever)
none kept.
REJECT: all eight Forever quest rewards (Arcane Infused Rod 279838, Fallen Guard's Pendant 279837, Battle Spaulders 279842, Defender of Dalaran 279841, Enchanted Sandals 279843, Renewing Footpads 279840, Spellguard Pauldrons 279839, Striking Staff 279844). Reason: generic choice rewards from her quests (Starving Arcane, Heart of Disruption); the quest text is about the Dalaran tasks, not her.
Open question: the Modera quests name her as the giver and as the quest recipient ("for [[Archmage Modera]]"). If rule 4 is read loosely, these eight could be kept.

### 3139 Gar'Thok
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Admiral Proudmoore's Orders | 4883 | turn-in | "'''Admiral Proudmoore's Orders''' is provided as an objective for [[The Admiral's Orders]]." (Gar'Thok ends The Admiral's Orders) | The Admiral's Orders |

REJECT
| item | id | reason | quoted line |
|---|---|---|---|
| Dirt-Trodden Boots, Sandrunner Wristguards, Wide Metal Girdle | 4936, 4928, 4935 | generic green quest rewards (From The Wreckage) | "...quest reward from [[From The Wreckage....]]" |
| Benedict's Key, Aged Envelope | 4882, 4881 | Lieutenant Benedict's loot / Benedict's Chest, not Gar'Thok | "Benedict's Key drops from [[Lieutenant Benedict]]..." |
| Gnomish Tools | 4863 | world drop | — |

### 3205 Zalazane
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Zalazane's Head | 4866 | drop | "'''Zalazane's Head''' drops from [[Zalazane]] on [[Echo Isles]] in [[Durotar]]." | Zalazane's Head |

REJECT: Ley Orb, Ley Staff, Veiled Grips, Lightweight Boots (generic quest rewards); Faintly Glowing Skull (Minshina's Skull quest); Minshina's Skull (Imprisoned Darkspear chest).

### 11186 Lunnix Sprocketslip
none found (checked: Lunnix Sprocketslip page, 6 candidates).
REJECT: Coal, Mining Pick, Strong and Weak Flux (vendor/reagent), Jeweler's Toolset (vendor), Simple Grinder (crafting tool).

### 1646 Baros Alexston
none kept.
REJECT: An Unsent Letter (Edwin VanCleef drop), Report on the Defias Brotherhood (objective of An Audience with the King), Seal of Wrynn (quest reward, not his), Sealed Description of Thredd's Visitor (objectives elsewhere).
Open question: A Simple Compass (2998) is found in Alexston's Chest in Westfall. A chest is not an NPC drop, so it was rejected. Add it if chests count.

### 1284 Archbishop Benedictus
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Cursed Eye of Paleth | 2944 | turn-in | "The '''Cursed Eye of Paleth''' is provided as an objective for the following quests: [[Cleansing the Eye]]" (quest finish: Benedictus) | Cursed Eye of Paleth / Archbishop Benedictus |

REJECT: Eye of Paleth 2943 (not the cursed one), Amberglow Talisman 10824 (reward from Bring the Light), Vanquisher's Sword 10823 (generic), Forsaken Heart 18147 (Alterac Valley drop).

### 11833 Rahauro
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Grimtotem Satchel | 14381 | turn-in | "'''Grimtotem Satchel''' is provided as an objective for [[Returning the Lost Satchel]]." (quest finish: Rahauro) | Rahauro |

REJECT: Featherbead Bracers 15452, Savannah Bracers 15453, Garrison Cuffs 270003 (generic quest rewards from Returning the Lost Satchel).

### 576 Watcher Ladimore (Sarah Ladimore)
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Archeus | 2000 | quest reward, borderline | "'''Archeus''' is a quest reward [[A Daughter's Love]], which starts with [[Sarah Ladimore|Watcher Ladimore]]" | Archeus |

REJECT: Sarah's Ring 2162 (objective of A Daughter's Love, not turned in to him per the page), The Story of Morgan Ladimore 2154 (reward from Morgan Ladimore quest), Torch of Holy Flame 7344 (not his).
Open question: Archeus is kept as a quest reward from his own quest (A Daughter's Love). Drop it under a strict rule 4.

### 2542 Catelyn the Blade
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Catelyn's Blade | 4027 | own thing | "'''Catelyn's Blade''' is actually a troll relic ... He gave the blade to his daughter [[Catelyn the Blade]]" | Catelyn's Blade |

REJECT: Robe of Crystal Waters 4120 (reward from the deprecated Alliance quest The Curse of the Tides, generic), Stone of the Tides 4034 (looted by quest players, not handed over by her).

### 11406 High Priest Rohan
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Exorcism Censer | 18752 | own thing | "The Exorcism Censer was originally owned by [[High Priest Rohan]]..." | Exorcism Censer |
| Rohan's Exorcism Censer | 18819 | own thing | "'''Rohan's Exorcism Censer''' was originally owned by [[High Priest Rohan]]..." (quest To Show Due Judgment) | Rohan's Exorcism Censer |

REJECT: none further. Rohan's page has no loot section.

### 1852 Araj the Summoner
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Araj's Scarab | 14610 | own thing (phylactery content) | "'''Araj's Scarab''' is contained in [[Araj's Phylactery]], guarded by [[Araj the Summoner]]..." | Araj's Scarab |

REJECT: Attuned Dampener 12650 (quest rewards from quests not given by Araj).

### 10435 Magistrate Barthilas
KEEP
| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Idol of Brutality | 23198 | drop (Relic) | "'''Idol of Brutality''' drops from [[Magistrate Barthilas]] in Stratholme." | Magistrate Barthilas (loot) |

### 8198 Tick (drake)
none found (checked: Tick (drake) page, 0 candidates; no Loot or Quests items).

### 14888 Lethon
none found (checked: Lethon and Lethon (Classic) pages, 0 candidates).

### 5734 Apothecary Keever
none found (checked: Apothecary Keever page, 0 candidates; quests are Arms and Armor / Warfronts only).

### 3173 Swart
none found (checked: Swart page, 0 candidates; quests Call of Fire / Call of Water only).

### 7917 Brother Sarno
none found (checked: Brother Sarno page, 0 candidates; quest Tinkmaster Overspark only).

### 1570 Executor Arren
none kept.
REJECT: Executor Staff 3277 and Deathguard Buckler 3276 (rewards from The Red Messenger, generic); Forsaken Bastard Sword/Dagger/Maul/Shortsword (rewards from The Scarlet Crusade quest); Flax Bracers, Flax Vest, Old Leather Belt, Zombie Skin Leggings, Rugged Plate Vest (generic Night Web's Hollow / Damned rewards); Scarlet Armband 3266 (drops from Scarlet Crusade members, not him); Duskbat Wing, Scavenger Paw (reagents); Scarlet Crusade Documents 2885 (carried by Meven Korgal).

### 6807 Innkeeper Skindle
none kept.
REJECT: all 15 candidates are vendor goods, drinks, food or recipes (Cologne Bottle, Perfume Bottle, Love Token, Ice Cold Milk, Melon Juice, Moonberry Juice, Morning Glory Dew, Sweet Nectar, Longjaw Mud Snapper, Bristle Whisker Catfish, Rockscale Cod, Spinefin Halibut, Striped Yellowtail, Slitherskin Mackerel, Refreshing Spring Water). Innkeeper rule: vendor goods REJECT.

## Already in the database
- Gazlowe's Ledger 5080 (3391, not repeated).

## Open questions
1. Gazlowe: Shipment of Boots 5076 and Telescopic Lens 5077 are objectives of Stolen Booty ("for Gazlowe"), but the cached wiki infobox does not name the end NPC. Not kept until confirmed.
2. Wilhelm: four Classic leggings are quest rewards from his own quest (kept, borderline under rule 4).
3. Illiyana: Sentinel Care Packages (19150-19152) are rewards from her quests; rejected as generic.
4. Grayson: Judgment and Redemption rewards the Charger mount (a spell, not an item). Divination Scryer 18746 is not kept (made from the censer). Knight's Lance 281296 and Royal Dagger 281297 (Forever, A Friend of the Family (2) ends at Grayson) rejected as generic.
5. Zor: Band of Allegiance and Lonetree's Circle are kept as rewards from his own quest Service to the Horde (borderline).
6. Onyxia Hide Backpack (17966): kept as gear=true (bags equip into a bag slot). Change if the addon treats bags as non-gear.
7. Nefarian: Head of Nefarian has a Horde ID 19002 and an Alliance ID 19003 (both Classic); 19002 is used.
8. Modera: eight Forever quest rewards rejected; a loose reading of rule 4 would keep them.
9. Baros Alexston: A Simple Compass (2998) is in Alexston's Chest, a chest and not an NPC drop; not kept.
10. Archeus (2000) is kept as a quest reward from Ladimore's own quest; strict rule 4 would drop it.
11. Mograine: Mograine's Might and Aegis were not in the cache and were fetched raw from warcraft.wiki.gg. The critic should confirm.

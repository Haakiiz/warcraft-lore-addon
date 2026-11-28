# Group D (veterans) item report, 2026-11-28

Worker: item round, group D. Inputs: candidates.json, veterans.json, cached wiki pages (item_lookup). Missed items were added from the veterans' own pages (Rajaxx loot table fetched from warcraft.wiki.gg, one request per second). Output: D_items.lua (81 entries across 19 veterans).

## Already in the database
- Cairne Bloodhoof (3057): Cairne's Hoofprint (18643), already in the database, not repeated.

## Open questions
- Revilgaz (2496): Robe of Crystal Waters (4120) is a reward from The Curse of the Tides, which ends with Revilgaz, but the wiki calls it a deprecated quest. Left out.
- Revilgaz (2496): Bloodsail Charts (3920) and Bloodsail Orders (3921) are objectives of Details of the Attack, which starts with Revilgaz. The quest header names no end NPC. Left out.
- King Magni (2784): Songstone of Ironforge (12543) is from the same quest as Magni's Will (The Princess's Surprise). Kept Magni's Will only, because it is named after him. Add the Songstone if you want the whole quest.
- Anachronos (15192): Atiesh items (Frame of Atiesh 22727, Splinter of Atiesh 22726, Atiesh greatstaff 22589-22632, Atiesh quest item 22737) belong to the Atiesh quest chain that he starts and ends. The staff is not his own, so left out. Bronze Scepter Shard was not in the candidate list and was not checked.
- Nathanos (11878): Quel'Thalas Registry (15847) is a book about him that he sends you to recover, with no turn-in NPC on the page. Left out. Royal Seal of Alexis (18022) and Elemental Circle (17001) are rewards from the Ramstein quest, which is about Ramstein. Left out.
- Morbent Fel (1200): Torch of Holy Flame (7344) is a reward from the Morbent Fel quest, which Sven starts. The quest is about killing Morbent, so it is borderline. Left out. No other Morbent Fel items qualify.
- Pozzik (4630): Indurium Ore (5833) is the objective of Indurium Ore (quest), which Pozzik starts. The page does not name the turn-in NPC. Left out.
- Cairne (3057): Kodo Hunter's Leggings (4909) is a reward from Rites of the Earthmother (3), which Cairne starts. The quest is about the Earthmother rites, not Cairne. Left out.
- Muln (253957) and Arei (9598): their quest rewards are kept under rule 4 (the quest is ended by or started with them and is about them). These are borderline, so review them if you want a stricter rule.
- General Rajaxx (15341): the four Cenarion Circle tokens (20884, 20885, 20888, 20889) are kept because Rajaxx's loot table lists them. Two of them drop from all Ahn'Qiraj bosses, so they are weak links.
- Fleet Master Seahorn (2487): none found. The Stranglethorn Fishing Extravaganza quest starts with Riggle Bassbait, not Seahorn.
- Mordent Evenshade (253471), Chronalis (8197), Kor'jus (3329): none found. Their pages list no loot or turn-in items.
- Ogg'marr (4879), Misha (10204), Rizzle Brassbolts (4720), Daryl Riknussun (5159), Lord Aliden Perenolde (2423): candidates are vendor goods, Dragonflight/retail items, or quest rewards of other NPCs. Nothing kept.

### Anduin Wrynn (1747)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Head of Nefarian | 19002 | turn-in | Nefarian's head may be delivered either to King Anduin Wrynn in Stormwind for the Alliance | The Lord of Blackrock |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| A Round of Drinks | 217708 | Retail-only (no Classic ID; not from this veteran) | A Round of Drinks is sold by Nalina Ironsong, the innkeeper of Mereldar for . Players are tasked ordering a round in The Bastion of Hallowfall. |
| Anduin's Lucky Hearthstone Card | 206022 | Retail-only (no Classic ID; not from this veteran) | Anduin's Lucky Hearthstone Card drops from Enchanted Card Swarm at Algeth'ar Academy in Thaldraszus. |
| Arathi Demolition Charge | 220118 | Retail-only (no Classic ID; not from this veteran) | Arathi Demolition Charge is a trinket rewarded from Siege Weapon Sabotage. |
| Bolvar's Decree | 11368 | Objective of Solomon's The True Masters (4), not Anduin's | Bolvar's Decree was provided as an objective for The True Masters (4). |
| Breastplate of the Reckoning's Vengeance | 220132 | Retail-only (no Classic ID; not from this veteran) | Breastplate of the Reckoning's Vengeance is a quest reward from The Rise of the Reckoning. |
| Breeches of the Reckoning's Vengeance | 220129 | Retail-only (no Classic ID; not from this veteran) | Breeches of the Reckoning's Vengeance are a quest reward from The Rise of the Reckoning. |
| Chainmail of Sina's Stalwarts | 220109 | Retail-only (no Classic ID; not from this veteran) | Chainmail of Sina's Stalwarts is a quest reward from Rekindled Memories. |
| Charred Nerubian Helm | 219749 | Retail-only (no Classic ID; not from this veteran) | Charred Nerubian Helm is a quest reward from Impossible Odds. |
| Charred Nerubian Leggings | 219747 | Retail-only (no Classic ID; not from this veteran) | Charred Nerubian Leggings are a quest reward from Impossible Odds. |
| Charred Nerubian Robes | 219746 | Retail-only (no Classic ID; not from this veteran) | Charred Nerubian Robes is a quest reward from Impossible Odds, part of the Isle of Dorn storyline in Dornogal. |
| Charred Nerubian Warplate | 219748 | Retail-only (no Classic ID; not from this veteran) | Charred Nerubian Warplate is a quest reward from Impossible Odds. |
| City Guard's Chainmail | 224455 | Retail-only (no Classic ID; not from this veteran) | City Guard's Chainmail is a quest reward from Departure. |
| City Guard's Coronet | 224453 | Retail-only (no Classic ID; not from this veteran) | City Guard's Coronet is a quest reward from Departure. |
| City Guard's Greaves | 224456 | Retail-only (no Classic ID; not from this veteran) | City Guard's Greaves are a quest reward from Departure. |
| City Guard's Mask | 224454 | Retail-only (no Classic ID; not from this veteran) | City Guard's Mask is a quest reward from Departure. |
| Coif of the Reckoning's Vengeance | 220131 | Retail-only (no Classic ID; not from this veteran) | Coif of the Reckoning's Vengeance is a quest reward from The Rise of the Reckoning. |
| Councilward's Signet | 216697 | Retail-only (no Classic ID; not from this veteran) | Councilward's Signet is provided by Merrix for Stones of Dornogal. |
| Cowl of Sina's Stalwarts | 220112 | Retail-only (no Classic ID; not from this veteran) | Cowl of Sina's Stalwarts is a quest reward from Rekindled Memories. |
| Drape of the Lamplighter | 223472 | Retail-only (no Classic ID; not from this veteran) | Drape of the Lamplighter is a quest reward from A Light in the Dark. |
| Faol's Benediction | 237811 | Retail-only (no Classic ID; not from this veteran) | Faol's Benediction is provided by Alonsus Faol for Renewal for the Weary. |
| Finduin | 258419 | BlizzCon 2019 companion (Retail-era) | Finduin is the Alliance murloc companion given out to attendees for BlizzCon 2019. It is modeled after Anduin Wrynn. It occasionally summons Genji. |
| Flameguard's Band | 220133 | Retail-only (no Classic ID; not from this veteran) | Flameguard's Band is a quest reward from A Candle in the Dark. |
| Game Piece | 211960 | Quest item of Lost Pieces (not Anduin's) | Game Piece... |
| Gasping Fish | 217352 | Retail-only (no Classic ID; not from this veteran) | Gasping Fish drops from Kobyss Shadeshapers at the Sunless Strand of Hallowfall. It starts Gasping Plea, beginning an optional chapter of the Hallowfall storyline. |
| Gloves of Renewal | 251274 | Retail-only (no Classic ID; not from this veteran) | Gloves of Renewal are a quest reward from Renewal for the Weary. |
| Greaves of Sina's Stalwarts | 220110 | Retail-only (no Classic ID; not from this veteran) | Greaves of Sina's Stalwarts are a quest reward from Rekindled Memories. |
| Hands of Renewal | 251277 | Retail-only (no Classic ID; not from this veteran) | Hands of Renewal are a quest reward from Renewal for the Weary. |
| Helm of Sina's Stalwarts | 220108 | Retail-only (no Classic ID; not from this veteran) | Helm of Sina's Stalwarts is a quest reward from Rekindled Memories. |
| Invisibility Potion | 9172 | Generic consumable linked from NPC page, not his | Invisibility Potion makes the drinker invisible for 18 seconds. Opening chests, attacking, shifting forms, or taking damage will break invisibility. The smell and taste of this potion is ... |
| Keg of Black Powder | 213630 | Retail-only (no Classic ID; not from this veteran) | Keg of Black Powder are looted from Blackpowder Barrels in Tenir's Ascent in Hallowfall. |
| Lamplighter's Torch | 220507 | Retail-only (no Classic ID; not from this veteran) | Lamplighter's Torch is a quest reward from Blades of the Arathi. It is also sold by Aeden Braesmeld in Mereldar in Hallowfall for . |
| Lamplighter's Unlit Torch | 220508 | Retail-only (no Classic ID; not from this veteran) | Lamplighter's Unlit Torch is a quest reward from Blades of the Arathi. It is also sold by Aeden Braesmeld in Mereldar in Hallowfall for . |
| Legends of the Gurubashi, Volume 3 | 3899 | Generic Stormwind Library reward | Legends of the Gurubashi, Volume 3 is a reward from Stormwind Library. It can also be looted from the Historic Lore Books in the relaxing areas at Southfury River in the Northern Barrens ... |
| Library Scrip | 3898 | Generic Stormwind Library reward | Library Scrip is provided for The Stone of the Tides (quest). It is not necessary to complete the quest, and will not disappear after the quest is done. |
| Lost Belongings | 211959 | Quest item of Lost Pieces (not Anduin's) | Lost Belongings are looted from mobs in the Harrowing Depths in Hallowfall. |
| Nizrek's Holographic Manipulator | 225970 | Retail-only (no Classic ID; not from this veteran) | Nizrek's Holographic Manipulator is a quest reward from Rewriting the Rewritten. |
| Order of Night Propaganda | 217990,217993,217995 | Retail-only (no Classic ID; not from this veteran) | Order of Night Propaganda is found all over Mereldar for Nightwatch and comes in three varieties. |
| Peridot Dragonhawk | 257143 | Retail-only (no Classic ID; not from this veteran) | The Peridot Dragonhawk is a dragonhawk mount rewarded by the quest From Darkness, Light, the final quest in the Midnight campaign. |
| Profaned Tinderbox | 221758 | Retail-only (no Classic ID; not from this veteran) | Profaned Tinderbox is a crafting reagent used in Khaz Algar Blacksmithing, Khaz Algar Enchanting, and Khaz Algar Leatherworking. They can be obtained from treasures. Notably, the Sturdy C... |
| Queensfang Choker | 225561 | Retail-only (no Classic ID; not from this veteran) | Queensfang Choker is a quest reward from Kaheti Hospitality. |
| Remembrance of the Fallen City | 219754 | Retail-only (no Classic ID; not from this veteran) | Remembrance of the Fallen City is a quest reward from Secure the Beach at the Tranquil Strand on the Isle of Dorn. |
| Rubble-Salvaged Grips | 219761 | Retail-only (no Classic ID; not from this veteran) | Rubble-Salvaged Grips are a quest reward from Recompense (quest). |
| Rubble-Salvaged Shoulderpads | 219763 | Retail-only (no Classic ID; not from this veteran) | Rubble-Salvaged Shoulderpads are a quest reward from Recompense (quest). |
| Rubble-Salvaged Slippers | 219760 | Retail-only (no Classic ID; not from this veteran) | Rubble-Salvaged Slippers are a quest reward from Recompense (quest). |
| Rubble-Salvaged Waistguard | 219762 | Retail-only (no Classic ID; not from this veteran) | Rubble-Salvaged Waistguard is a quest reward from Recompense (quest). |
| Swarm-Maven's Amulet | 225562 | Retail-only (no Classic ID; not from this veteran) | Swarm-Maven's Amulet is a quest reward from Kaheti Hospitality. |
| Swift White Steed | 18778 | Vendor-bought mount, not from Anduin | The Swift White Steed is a horse mount that can be purchased for from the following vendors: |
| Tabard of Stormwind | 11364 | Beta-only reward, removed before launch | The Tabard of Stormwind was a quest reward from The True Masters (4) during the beta version of World of Warcraft, but was removed before going live. |
| The Story of Morgan Ladimore | 2154 | Generic Stormwind Library reward | The Story of Morgan Ladimore is a quest reward from Morgan Ladimore (quest) and Stormwind Library. |
| Threadmaestro's Collar | 225563 | Retail-only (no Classic ID; not from this veteran) | Threadmaestro's Collar is a quest reward from Kaheti Hospitality. |
| Touch of Renewal | 251276 | Retail-only (no Classic ID; not from this veteran) | Touch of Renewal is a quest reward from Renewal for the Weary. |
| Tower-Keeper's Grips | 220111 | Retail-only (no Classic ID; not from this veteran) | Tower-Keeper's Grips are a quest reward from The Light of the Dawntower. |
| Tower-Keeper's Shoes | 220107 | Retail-only (no Classic ID; not from this veteran) | Tower-Keeper's Shoes are a quest reward from The Light of the Dawntower. |
| Tower-Keeper's Shoulderguards | 220113 | Retail-only (no Classic ID; not from this veteran) | Tower-Keeper's Shoulderguards are a quest reward from The Light of the Dawntower. |
| Tower-Keeper's Waistguard | 220114 | Retail-only (no Classic ID; not from this veteran) | Tower-Keeper's Waistguard is a quest reward from The Light of the Dawntower. |
| Vestment of the Reckoning's Vengeance | 220128 | Retail-only (no Classic ID; not from this veteran) | Vestment of the Reckoning's Vengeance is a quest reward from The Rise of the Reckoning. |
| Wraps of Renewal | 251275 | Retail-only (no Classic ID; not from this veteran) | Wraps of Renewal are a quest reward from Renewal for the Weary. |
| Xal'atath's Rusty Coin | 228911 | Retail-only (no Classic ID; not from this veteran) | Xal'atath's Rusty Coin is fished from the fountain in Dalaran during the nerubian attack as part of The War Within campaign intro scenario during Departure. |

### Baron Revilgaz (2496)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Fuel Regulator Blueprints | 5852 | turn-in | Bring the Fuel Regulator Blueprints to Baron Revilgaz in Booty Bay. | Goblin Sponsorship (4) |
| Stone of the Tides | 4034 | turn-in | bring the Stone of the Tides and Catelyn's Blade back to Baron Revilgaz. | The Curse of the Tides |
| Catelyn's Blade | 4027 | turn-in | bring the Stone of the Tides and Catelyn's Blade back to Baron Revilgaz. | The Curse of the Tides |
| Bag of Water Elemental Bracers | 3960 | quest item he hands you | Bring the water elemental bracers to Archmage Ansirem Runeweaver in Dalaran Crater. | Magical Analysis |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| 99-Year-Old Port | 5334 | Drink for Gazlowe that Mad Magglish stole; not a turn-in to Revilgaz | Retrieve the 99-Year-Old Port drink from him as the objective of Trouble at the Docks. Mad Magglish is not inside the actual instance, but is in the caves leading up to the instance. He c... |
| Blackwater Cannonball | 228975 | Retail-only (Backyard Navy, Undermine) | Blackwater Cannonballs drop from Darkfuse Mariners and are obtained from the Blackwater Ordinance. Baron Revilgaz wants 6 of them for the cannon and fire at the Darkfuse Joyriders for Bac... |
| Bloodsail Admiral's Hat | 12185 | Reward from Bloodsail Buccaneers quest (Firallon) | Bloodsail Admiral's Hat is a cloth headpiece that gives a bonus to stamina. It is part of the coveted Bloodsail "set". It also summons and dismisses a Blood Parrot, Companion, which will ... |
| Bloodsail Charts | 3920 | Objective of Details of the Attack; turn-in NPC not on page (open question) | The Bloodsail Charts can be found in the Bloodsail Buccaneer camp at the Wild Shore in the Cape of Stranglethorn. |
| Bloodsail Orders | 3921 | Objective of Details of the Attack; turn-in NPC not on page (open question) | The Bloodsail Orders can be found at the Wild Shore in the Cape of Stranglethorn. |
| Bloodscalp Ear | 1519 | Drops from Bloodscalp tribe; not Revilgaz's | Bloodscalp Ears drop from members of the Bloodscalp tribe in Stranglethorn Vale. |
| Boots of the Undermine Revolutionary | 232407 | Retail-only (no Classic ID; not from this veteran) | Boots of the Undermine Revolutionary are a quest reward from We Own the Streets. |
| Chainmail of the Undermine Revolutionary | 232356 | Retail-only (no Classic ID; not from this veteran) | Chainmail of the Undermine Revolutionary is a quest reward from We Own the Streets. |
| Cinch of the Liberator | 232405 | Retail-only (no Classic ID; not from this veteran) | Cinch of the Liberator are a quest reward from Get Our People Out. |
| Crocolisk Skin | 201986 | Drops from Sandy Crocolisk (Information is King) | Crocolisk Skin drops from Sandy Crocolisks at Janeiro's Point in the Cape of Stranglethorn. |
| Desperate Goblin's Belt | 232761 | Retail-only (no Classic ID; not from this veteran) | Desperate Goblin's Belt is a quest reward from Eye Sores for Sore Eyes. |
| Desperate Goblin's Boots | 232748 | Retail-only (no Classic ID; not from this veteran) | Desperate Goblin's Boots are a quest reward from Eye Sores for Sore Eyes. |
| Desperate Goblin's Gloves | 232740 | Retail-only (no Classic ID; not from this veteran) | Desperate Goblin's Gloves are a quest reward from Eye Sores for Sore Eyes. |
| Desperate Goblin's Spaulders | 232750 | Retail-only (no Classic ID; not from this veteran) | Desperate Goblin's Spaulders are a quest reward from Eye Sores for Sore Eyes. |
| Drape of the Lamplighter | 223472 | Retail-only (no Classic ID; not from this veteran) | Drape of the Lamplighter is a quest reward from A Light in the Dark. |
| Enchanted Runed Undermine Crest | 224072 | Retail-only (Liberation of Undermine) | Enchanted Runed Undermine Crest is available from the following vendors for 45x Runed Undermine Crest: |
| Ethereal Warning Letter | 232944 | Retail-only (no Classic ID; not from this veteran) | Ethereal Warning Letter is collected at Hovel Hill in the Undermine. It was given to Renzik "The Shiv" during A Trail of Black Blood. |
| Gemmed Gloves | 4121 | Reward from Hostile Takeover (Kebok) | Gemmed Gloves are a quest reward from Hostile Takeover. |
| Goblin Fishing Pole | 4598 | Reward from Bloodscalp Ears | Goblin Fishing Pole is a explosive item. |
| Gold Coins (item) | 204705 | Retail-only (Money, Money, Money!) | Gold Coins drop from Dreadcut Corsairs, Grubby Deckhands, and Seaspray Blasters on a ship in the Southern Savage Coast in the Cape of Stranglethorn. They were given to Baron Revilgaz. |
| Gold Ingot | 202281 | Retail-only (Crystals Shmystals, Undermine) | Gold Ingot is looted from the Treasure Chest on a ship in the Southern Savage Coast in the Cape of Stranglethorn. It is given to Baron Revilgaz. |
| Headgear of the Undermine Revolutionary | 232406 | Retail-only (no Classic ID; not from this veteran) | Headgear of the Undermine Revolutionary is a quest reward from We Own the Streets. |
| Legends of the Gurubashi, Volume 3 | 3899 | Not tied to this veteran (quest: Stormwind Library; quest ends at NPC: The Haunted Isle; quest starts at NPC: The Stone of the Tides (quest); quest starts at NPC: Water Elementals (Classic)) | Legends of the Gurubashi, Volume 3 is a reward from Stormwind Library. It can also be looted from the Historic Lore Books in the relaxing areas at Southfury River in the Northern Barrens ... |
| Legguards of the Undermine Revolutionary | 232408 | Retail-only (no Classic ID; not from this veteran) | Legguards of the Undermine Revolutionary are a quest reward from We Own the Streets. |
| Library Scrip | 3898 | Not tied to this veteran (quest: Stormwind Library; quest starts at NPC: The Stone of the Tides (quest)) | Library Scrip is provided for The Stone of the Tides (quest). It is not necessary to complete the quest, and will not disappear after the quest is done. |
| Miscellaneous Goblin Supplies | 2252 | Objective of Supplies to Private Thorsen, delivered to Thorsen | The Miscellaneous Goblin Supplies was provided as an objective for Supplies to Private Thorsen. |
| Pouch of Gold Coins | 202271 | Retail-only (Anyway, I Started Bribing) | Pouch of Gold Coins is provided by Zeros to bribe Hired Bodyguards for Anyway, I Started Bribing. |
| Public Defender's Coat | 234125 | Retail-only (no Classic ID; not from this veteran) | Public Defender's Coat is a quest reward from Oh, That Casino!. |
| Robe of Crystal Waters | 4120 | Reward from The Curse of the Tides; deprecated quest (open question) | The Robe of Crystal Waters was a quest reward from the now deprecated Alliance-only quest, The Curse of the Tides. |
| Robe of the Liberator | 232354 | Retail-only (no Classic ID; not from this veteran) | Robe of the Liberator is a quest reward from Get Our People Out. |
| Sabatons of the Liberator | 232403 | Retail-only (no Classic ID; not from this veteran) | Sabatons of the Liberator are a quest reward from Get Our People Out. |
| Shoulderguards of the Liberator | 232401 | Retail-only (no Classic ID; not from this veteran) | Shoulderguards of the Liberator are a quest reward from Get Our People Out. |
| Speckled Tastyfish | 19807 | Fishing Extravaganza item (Riggle Bassbait), not Revilgaz | Speckled Tastyfish are caught from all pools (inland or open ocean) on Northern Stranglethorn and the Cape of Stranglethorn during the Stranglethorn Fishing Extravaganza on realms set in ... |
| The Severance Package | 235516 | Retail-only (no Classic ID; not from this veteran) | The Severance Package is a quest reward from My Top Gal, part of the Undermine(d) campaign. This gun shares an appearance with the weapon Nikki the Fixer uses in End of the Day. |
| The Story of Morgan Ladimore | 2154 | Not tied to this veteran (quest: Stormwind Library; quest starts at NPC: The Stone of the Tides (quest)) | The Story of Morgan Ladimore is a quest reward from Morgan Ladimore (quest) and Stormwind Library. |
| Trigger-Sniffer's Greaves | 232782 | Retail-only (no Classic ID; not from this veteran) | Trigger-Sniffer's Greaves are a quest reward from Casino Court. |
| Trigger-Sniffer's Handwraps | 232786 | Retail-only (no Classic ID; not from this veteran) | Trigger-Sniffer's Handwraps are a quest reward from Casino Court. |
| Trigger-Sniffer's Hood | 232768 | Retail-only (no Classic ID; not from this veteran) | Trigger-Sniffer's Hood is a quest reward from Casino Court. |
| Trigger-Sniffer's Spaulders | 232773 | Retail-only (no Classic ID; not from this veteran) | Trigger-Sniffer's Spaulders are a quest reward from Casino Court. |
| Tumbled Crystal | 4106 | Drops from Venture Co. Geologist | Tumbled Crystal drops from Venture Co. Geologist in Stranglethorn Vale. |
| Void-Touched Valorstone | 225896 | Retail-only (no Classic ID; not from this veteran) | Void-Touched Valorstone is a quest reward from To Kill a Queen, part of the Nerub-ar Palace storyline & Liberation of Undermine: The House Loses. It contains 250 Valorstones. |
| Water Elemental Bracers | 3923 | Drops from Lesser Water Elementals (not Revilgaz) | Water Elemental Bracers drop from Lesser Water Elementals at the Haunted isle in Northern Stranglethorn. |
| Worn Brass Key | 202284 | Retail-only (Crystals Shmystals) | Worn Brass Key drops from Captain Grub Redcut on a ship in the Southern Savage Coast in the Cape of Stranglethorn. It is used to open the Treasure Chest. |

### King Magni Bronzebeard (2784)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Sara Balloo's Plea | 4514 | turn-in | Take Sara Balloo's note to King Magni Bronzebeard of Ironforge. | Sara Balloo's Plea (quest) |
| A Letter to Grelin Whitebeard | 2188 | letter from him | I will allow you to use my authority in dealing with the trolls | A Letter to Grelin Whitebeard |
| Magni's Will | 12548 | quest reward | end = King Magni Bronzebeard | The Princess's Surprise |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Bear Shawl | 6185 | Not tied to this veteran (quest: A New Threat (Dun Morogh)) | Bear Shawl is a quest reward from A New Threat (Dun Morogh). |
| Black Lotus | 13468 | Herb from Magni's ritual book (reagent) | A Black Lotus is a rare herb that can be gathered with Herbalism (300). |
| Calibrated Blunderbuss | 279894 | Retail-only (Old Ironforge Incursion) | The Calibrated Blunderbuss is a quest reward from Old Ironforge Incursion. |
| Cask of Shimmer Stout | 3086 | Objective of Stout to Kadrell (Mountaineer Kadrell) | The Cask of Shimmer Stout is provided as an objective for Stout to Kadrell. |
| Chunk of Boar Meat | 769 | Drops from boars (food reagent) | A Chunk of Boar Meat can often be sliced off a dead boar. Though the meat is very tough, when simmered for long enough it can be used to make tasty Pork Belly Pies. |
| City Guard's Chainmail | 224455 | Retail-only (no Classic ID; not from this veteran) | City Guard's Chainmail is a quest reward from Departure. |
| City Guard's Coronet | 224453 | Retail-only (no Classic ID; not from this veteran) | City Guard's Coronet is a quest reward from Departure. |
| City Guard's Greaves | 224456 | Retail-only (no Classic ID; not from this veteran) | City Guard's Greaves are a quest reward from Departure. |
| City Guard's Mask | 224454 | Retail-only (no Classic ID; not from this veteran) | City Guard's Mask is a quest reward from Departure. |
| Councilward's Signet | 216697 | Retail-only (no Classic ID; not from this veteran) | Councilward's Signet is provided by Merrix for Stones of Dornogal. |
| Deepblaze | 279896 | Retail-only (Old Ironforge Incursion) | Deepblaze is a quest reward from Old Ironforge Incursion. |
| Delver's Dirigible | 220786 | Retail-only (Urban Odyssey) | The Delver's Dirigible is a customizable flying machine mount that can be purchased from Reno Jackson for 10,000 Resonance Crystals. |
| Earthen Traveler's Breastplate | 219373 | Retail-only (no Classic ID; not from this veteran) | Earthen Traveler's Breastplate is a quest reward from We Don't Go to Taelloch. |
| Earthen Traveler's Breeches | 219364 | Retail-only (no Classic ID; not from this veteran) | Earthen Traveler's Breeches are a quest reward from We Don't Go to Taelloch. |
| Earthen Traveler's Coif | 219369 | Retail-only (no Classic ID; not from this veteran) | Earthen Traveler's Coif is a quest reward from We Don't Go to Taelloch. |
| Earthen Traveler's Greaves | 219370 | Retail-only (no Classic ID; not from this veteran) | Earthen Traveler's Greaves are a quest reward from Battle of the Earthenworks. |
| Earthen Traveler's Helm | 219372 | Retail-only (no Classic ID; not from this veteran) | Earthen Traveler's Helm is a quest reward from Battle of the Earthenworks. |
| Earthen Traveler's Leggings | 219360 | Retail-only (no Classic ID; not from this veteran) | Earthen Traveler's Leggings are a quest reward from Battle of the Earthenworks. |
| Earthen Traveler's Vest | 219377 | Retail-only (no Classic ID; not from this veteran) | Earthen Traveler's Vest is a quest reward from Battle of the Earthenworks. |
| Earthen Traveler's Vestment | 219359 | Retail-only (no Classic ID; not from this veteran) | Earthen Traveler's Vestment is a quest reward from We Don't Go to Taelloch. |
| Esteemed Earthen Emblem | 219018 | Retail-only (Into the Machine) | Esteemed Earthen Emblem is a quest reward from the Into the Machine. |
| Fearbreaker's Echo | 224449 | Retail-only (no Classic ID; not from this veteran) | Fearbreaker's Echo is a quest reward from The Bronzebeard Legacy. |
| Ghost Mushroom | 8845 | Herb from Magni's ritual book (reagent) | Ghost Mushroom is an herb that can be gathered with Herbalism (245). |
| Ironforge Greathammer | 279895 | Retail-only (Old Ironforge Incursion) | The Ironforge Greathammer is a quest reward from Old Ironforge Incursion. |
| Ironforge Memorial Ring | 4535 | Reward from A King's Tribute, a memorial for Sully Balloo, not Magni | The Ironforge Memorial Ring is a quest reward from A King's Tribute (3). |
| Mountain Silversage | 13465 | Herb from Magni's ritual book (reagent) | Mountain Silversage is an Herb that can be gathered with Herbalism (280). |
| Remembrance of the Fallen City | 219754 | Retail-only (no Classic ID; not from this veteran) | Remembrance of the Fallen City is a quest reward from Secure the Beach at the Tranquil Strand on the Isle of Dorn. |
| Rustic Belt | 2172 | Not tied to this veteran (quest: A New Threat (Dun Morogh)) | Rustic Belt is a quest reward from A New Threat (Dun Morogh). |
| Snow Boots | 6173 | Not tied to this veteran (quest: A New Threat (Dun Morogh)) | Snow Boots are a quest reward from A New Threat (Dun Morogh). |
| Songstone of Ironforge | 12543 | Same quest as Magni's Will; open question | Songstone of Ironforge is a quest reward from The Princess's Surprise. |
| Thick Bear Fur | 6952 | Drops from Dun Morogh bears | Thick Bear Fur drops from Young Black Bears and Ice Claw Bear in Dun Morogh. |
| Timbermaw Offering of Peace | 21155 | Objective of The Brokering of Peace (Alliance), not Magni | Timbermaw Offering of Peace is provided as an objective for The Brokering of Peace. |
| Winding Slitherdrake: Void Scales | 213561 | Retail-only (Radiant Warnings) | Winding Slitherdrake: Void Scales is a quest reward from Radiant Warnings, the final quest of the Hunt for the Harbinger chapter of the Dark Heart campaign added in patch 10.2.7. |
| Xal'atath's Rusty Coin | 228911 | Retail-only (no Classic ID; not from this veteran) | Xal'atath's Rusty Coin is fished from the fountain in Dalaran during the nerubian attack as part of The War Within campaign intro scenario during Departure. |

### Master Mathias Shaw (332)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Head of Rend Blackhand | 12630 | turn-in | Take the Head of Rend Blackhand to Master Mathias Shaw in Stormwind. | End of the Dark Horde |
| Delivery to Mathias | 7674 | turn-in | Deliver Keryn Sylvius's package to Master Mathias Shaw at the Stormwind Barracks. | Seek out SI: 7 |
| Kearnen's Journal | 8046 | turn-in | Take whatever information you find back to Mathias Shaw in Stormwind | Klaven's Tower (quest) |
| Klaven Mortwake's Journal | 7908 | turn-in | Take whatever information you find back to Mathias Shaw in Stormwind | Klaven's Tower (quest) |
| Sealed Description of Thredd's Visitor | 8687 | turn-in | Bring the Sealed Description of Thredd's Visitor to Master Mathias Shaw in Stormwind. | Shadow of the Past (quest) |
| Shipping Schedule | 7675 | quest item | recover the Shipping Schedule for Master Mathias Shaw. | Snatch and Grab |
| Shaw's Report | 1353 | letter from him | Written by Master Mathias Shaw for Gryan Stoutmantle | Shaw's Report |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Blade of Cunning | 7298 | Generic rogue weapon reward from Snatch and Grab | The Blade of Cunning was a reward from the following quests: |
| Defias Tower Key | 7923 | Pickpocketed from Defias drones, not Shaw | The Defias Tower Key is from Malformed Defias Drone. |
| Drakefire Amulet | 16309 | Heritage quest reward; Will to Survive ends with Vanessa VanCleef, not Shaw | The Drakefire Amulet was once the key to Onyxia's Lair, until the attunement requirement was removed in patch 3.0.2. See Onyxia's Lair Attunement for details on the old attunement process. |
| Drakefire Amulet (quest item) | 204214 | Will to Survive ends with Vanessa VanCleef, not Shaw | Drakefire Amulet is found next to the body of Count Clessington in the Main Hall of Northshire Abbey in Elwynn Forest. |
| Enforcer Grant's Signet | 202238 | Drops from Enforcer Grant (not Shaw) | Enforcer Grant's Signet drops from Enforcer Grant in front of Northshire Abbey in Northshire Valley. |
| Enforcer Horb's Signet | 204173 | Drops from Enforcer Horb (not Shaw) | Enforcer Horb's Signet drops from Enforcer Horb near the entrance of Echo Ridge Mine in Northshire Valley. |
| Enforcer Jennive's Signet | 204171 | Drops from Enforcer Jennive (not Shaw) | Enforcer Jennive's Signet drops from Enforcer Jennive by the bridge leading to the Northshire Vineyards in Northshire Valley. |
| Enforcer Tera's Signet | 204172 | Drops from Enforcer Tera (not Shaw) | Enforcer Tera's Signet drops from Enforcer Tera behind Northshire Abbey in Northshire Valley. |
| Fragment of the Dragon's Eye | 16662 | Provided by Highlord Bolvar for The Dragon's Eye (quest) | Fragment of the Dragon's Eye is provided by Highlord Bolvar Fordragon for The Dragon's Eye (quest). |
| Old Copy of "Undermine Weekly" | 233657 | Retail-only (Cut After Cut, Undermine) | Old Copy of "Undermine Weekly" is located at the Westfall Lighthouse in Westfall. It belonged to Renzik "The Shiv" and Mathias Shaw in the Undermine wants it collected for Cut After Cut. |
| Pristine Fishing Gear | 233656 | Retail-only (Cut After Cut, Undermine) | Pristine Fishing Gear is looted from the Unused Fishing Gear at the Westfall Lighthouse in Westfall. It belonged to Renzik "The Shiv", and Mathias Shaw in the Undermine wants it collected... |
| Recipe: Thistle Tea | 18160 | Generic rogue recipe reward | Recipe: Thistle Tea is a rogue-only Bind on Pickup cooking recipe. |
| Renzik's Journal | 235629 | Retail-only (Cut After Cut, Undermine) | Renzik's Journal is found in Renzik's Lockbox at the Westfall Lighthouse for rogues who are on Cut After Cut, part of the final chapter of the Undermine(d) campaign. |
| SI:7 Insignia (Fredo) | 16001 | Returned to Flint Shadowmore (The Eastern Plagues), not Shaw | SI:7 Insignia (Fredo) is contained in one of the Mangled Human Remains in Eastern Plaguelands. |
| SI:7 Insignia (Rutger) | 16003 | Returned to Flint Shadowmore (The Eastern Plagues), not Shaw | SI:7 Insignia (Rutger) is contained in one of the Mangled Human Remains in Eastern Plaguelands. |
| SI:7 Insignia (Turyen) | 16002 | Returned to Flint Shadowmore (The Eastern Plagues), not Shaw | SI:7 Insignia (Turyen) is contained in one of the Mangled Human Remains in Eastern Plaguelands. |
| Spare Uncrowned Vest | 237267 | Retail-only (Cut After Cut, Undermine) | Spare Uncrowned Vest is looted from Renzik's Lockbox at the the Westfall Lighthouse in Westfall for rogues who are on Cut After Cut, part of the final chapter of the Undermine(d) campaign. |
| Torch of Holy Flame | 7344 | Reward from Morbent Fel (quest), not Shaw | Torch of Holy Flame is a off-hand item. It gives bonuses to spirit and spell power. Sven Yorgen sends adventurers to forge a weapon capable of defeating Morbent Fel. Lightforge Ingots sal... |
| Urgent Stormwind Summons | 203475 | Given by Agent Render; retail-only | Urgent Stormwind Summons are provided by Agent Render for An Urgent Matter. |
| Well-Worn Throwing Knives | 233655 | Retail-only (Cut After Cut, Undermine) | Well-Worn Throwing Knives are found at the Westfall Lighthouse in Westfall. They belonged to Renzik "The Shiv" and Mathias Shaw in the Undermine wants them collected for Cut After Cut. |
| Wiley's Note | 1327 | Written by Wiley the Black for Gryan Stoutmantle, not Shaw | Wiley's Note is a quest item provided for The Defias Brotherhood (2) and The Defias Brotherhood (3). It was written by Wiley the Black for Gryan Stoutmantle as repayment for a favor. The ... |
| Windsor's Journal | 204063 | Retail-only (added in patch 10.0.7) | Windsor's Journal is provided by Ragged John to be delivered to Master Mathias Shaw for Looking for Something Specific. |

### Nathanos Blightcaller (11878)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Head of Ramstein the Gorger | 15880 | turn-in | Take his head as a souvenir for Nathanos. | Ramstein (quest) |
| Patch of Duskwing's Fur | 15850 | turn-in | return it to Nathanos Blightcaller. | Duskwing, Oh How I Hate Thee... (Classic) |
| Nathanos' Chest | 15876 | his own item | was provided as an objective for Nathanos' Ruse. | Nathanos' Chest |
| Rotten Apple | 15875 | quest item he hands you | is looted from Nathanos' Chest. | Rotten Apple (old) |
| The Grand Crusader's Command | 15868 | turn-in | Kill the Courier and recover the Grand Crusader's Command. | The Crimson Courier |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Coagulated Rot | 15448 | Crafted reagent for To Kill With Purpose | Coagulated Rot is made with seven Living Rot in the Mortar and Pestle. |
| Davil's Libram | 12954 | Heroes of Darrowshire objective (Chromie quest) | Davil's Libram can be found in the first floor fireplace of the house at Marris Stead in Eastern Plaguelands. |
| Duskwing Gloves | 16994 | Quest reward from Duskwing quest; quest is about Duskwing | Duskwing Gloves are a quest reward from Duskwing, Oh How I Hate Thee... (Classic) |
| Duskwing Mantle | 16995 | Quest reward from Duskwing quest; quest is about Duskwing | Duskwing Mantle is a quest reward from Duskwing, Oh How I Hate Thee... (Classic) |
| Elemental Circle | 17001 | Reward from Ramstein quest; quest is about Ramstein (open question) | Elemental Circle is a quest reward from Ramstein (quest) which starts at Nathanos Blightcaller in the Eastern Plaguelands. |
| Extended Annals of Darrowshire | 13202 | Heroes of Darrowshire objective (Brother Carlin) | The Extended Annals of Darrowshire are provided as an objective for Brother Carlin. |
| Gorewood Bow | 16996 | Reward from The Scarlet Oracle / Order Must Be Restored, not Nathanos's | Gorewood Bow is a quest reward from The Scarlet Oracle, Demetria and Order Must Be Restored. |
| Hearthstone | 6948 | Most Loyal quest (Dark Ranger Lenara), not Nathanos | A hearthstone is an enchanted stone that can teleport the wielder to the location it is bound to, such as an inn. All characters receive a Hearthstone upon creation that returns them to t... |
| Living Rot | 15447 | Undead drop reagent for To Kill With Purpose | Living Rot drops from the following undead in Eastern Plaguelands: |
| Mortar and Pestle | 15454 | Tool for To Kill With Purpose (reagent chain) | The Mortar and Pestle is provided as an objective for To Kill With Purpose. With seven Living Rot a Coagulated Rot can be made. |
| Quel'Thalas Registry | 15847 | Book about him, objective of The Ranger Lord's Behest (open question) | The Quel'Thalas Registry is a book with information pertaining to Nathanos Marris, the human ranger lord now known as the Blightcaller. The book is held by survivors of Quel'Thalas who op... |
| Redpath's Shield | 12955 | Heroes of Darrowshire objective (Chromie quest) | Redpath's Shield rests near the barn of Gahrron's Withering in Western Plaguelands. |
| Rotten Apple (old) | 15875 | Not tied to this veteran (quest starts at NPC: Nathanos' Ruse) | Rotten Apple is looted from Nathanos' Chest. It applied the appearance of a Crimson Rifleman. |
| Royal Seal of Alexis | 18022 | Reward from Ramstein quest; quest is about Ramstein (open question) | Royal Seal of Alexis is a quest reward from Ramstein (quest). |
| SI:7 Insignia (Fredo) | 16001 | SI:7 insignia from The Eastern Plagues, not Nathanos | SI:7 Insignia (Fredo) is contained in one of the Mangled Human Remains in Eastern Plaguelands. |
| SI:7 Insignia (Rutger) | 16003 | SI:7 insignia from The Eastern Plagues, not Nathanos | SI:7 Insignia (Rutger) is contained in one of the Mangled Human Remains in Eastern Plaguelands. |
| SI:7 Insignia (Turyen) | 16002 | SI:7 insignia from The Eastern Plagues, not Nathanos | SI:7 Insignia (Turyen) is contained in one of the Mangled Human Remains in Eastern Plaguelands. |
| Sacred Protector | 16998 | Reward from The Scarlet Oracle / Order Must Be Restored, not Nathanos's | Sacred Protector is a quest reward from The Scarlet Oracle, Demetria and Order Must Be Restored. |
| Skullstone Hammer | 17003 | Reward from The Corpulent One (Borelgore quest) | Skullstone Hammer is a quest reward from The Corpulent One (Classic). |
| Stormrager | 16997 | Reward from The Scarlet Oracle / Order Must Be Restored, not Nathanos's | Stormrager is a quest reward from The Scarlet Oracle, Demetria and Order Must Be Restored. |

### Anachronos (15192)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Green Scepter Shard | 21139 | turn-in | Take the Green Scepter Shard to Anachronos at the Caverns of Time in Tanaris. | The Champion Returns |
| Blue Scepter Shard | 21137 | turn-in | was an objective of The Wrath of Neptulon. | Blue Scepter Shard |
| Red Scepter Shard | 21138 | turn-in | drops from Nefarian (tactics) in Blackwing Lair if he is killed within five hours | Red Scepter Shard |
| The Scepter of the Shifting Sands | 21175 | NPC's own item | After the conflict, Anachronos created the Scarab Gong and the Scepter of the Shifting Sands. | Anachronos |
| The War of the Shifting Sands | 20415 | book for him | is provided for Anachronos (quest). | The War of the Shifting Sands |
| Staff Head of Atiesh | 22733 | turn-in | Anachronos at the Caverns of Time in Tanaris wants the Staff Head of Atiesh and the Base of Atiesh. | Atiesh, the Befouled Greatstaff |
| Base of Atiesh | 22734 | turn-in | Anachronos at the Caverns of Time in Tanaris wants the Staff Head of Atiesh and the Base of Atiesh. | Atiesh, the Befouled Greatstaff |
| Signet Ring of the Bronze Dragonflight (Conqueror) | 21201 | turn-in | present me with your signet ring and a mountain of scarabs | The Changing of Paths - Conqueror No More |
| Signet Ring of the Bronze Dragonflight (Invoker) | 21206 | turn-in | present me with your signet ring and a mountain of scarabs | The Changing of Paths - Conqueror No More |
| Signet Ring of the Bronze Dragonflight (Protector) | 21196 | turn-in | present me with your signet ring and a mountain of scarabs | The Changing of Paths - Conqueror No More |
| Ivory Scarab | 20865 | turn-in | a mountain of scarabs from our enemies in Ahn'Qiraj | The Changing of Paths - Conqueror No More |
| Bone Scarab | 20864 | turn-in | a mountain of scarabs from our enemies in Ahn'Qiraj | The Changing of Paths - Conqueror No More |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Amulet of Shadow Shielding | 21529,234130 | Reward from Nefarius's Corruption (not Anachronos) | Amulet of Shadow Shielding is a quest reward from Nefarius's Corruption. |
| Arcanite Buoy | 21136 | Used at the Maelstrom for The Wrath of Neptulon, not turned in | The Arcanite Buoy is provided as an objective for The Wrath of Neptulon. |
| Atiesh, Greatstaff of the Guardian (item) | 22589,22630,22631,22632 | The finished Guardian's staff, not his item (open question) | Atiesh, Greatstaff of the Guardian is a legendary staff obtained by completing Atiesh, Greatstaff of the Guardian (quest). It can summon a Portal to Karazhan on use. |
| Atiesh, Greatstaff of the Guardian (quest item) | 22737 | Quest item for the Atiesh quest (open question) | This quest item version of Atiesh, Greatstaff of the Guardian is provided for Atiesh, Greatstaff of the Guardian (quest). |
| Band of Icy Depths | 21526,234135 | Reward from The Wrath of Neptulon (not Anachronos's) | Band of Icy Depths is a quest reward from The Wrath of Neptulon. |
| Darkwater Robes | 21527,234136 | Reward from The Wrath of Neptulon (not Anachronos's) | Darkwater Robes are a quest reward from The Wrath of Neptulon. |
| Drake Tooth Necklace | 21531,234132 | Reward from The Nightmare Manifests | Drake Tooth Necklace is a quest reward from The Nightmare Manifests. |
| Drudge Boots | 21532,234133 | Reward from The Nightmare Manifests | Drudge Boots are a quest reward from The Nightmare Manifests. |
| Frame of Atiesh | 22727 | Made from Splinters for the Atiesh quest (open question) | The Frame of Atiesh, Greatstaff of the Guardian, is one of the three essential pieces of the staff (the others being the head and base). |
| From the Desk of Lord Victor Nefarius | 21142 | Note from Nefarian, not Anachronos | From the Desk of Lord Victor Nefarius is a note that players receive from if they kill him more than five hours after activating the quest Nefarius's Corruption, part of The Scepter of th... |
| Onyx Embedded Leggings | 21530,234129 | Reward from Nefarius's Corruption | Onyx Embedded Leggings are a quest reward from Nefarius's Corruption. |
| Splinter of Atiesh | 22726 | Naxxramas boss drop for the Frame of Atiesh (open question) | A Splinter of Atiesh is a common drop from all bosses in Naxxramas except Sapphiron and Kel'Thuzad. Forty splinters combine into the Frame of Atiesh, which begins the first quest in a cha... |

### Magistrate Solomon (344)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Solomon's Plea to King Wrynn | 11367 | letter from him | is provided by Magistrate Solomon for The True Masters (2). | Solomon's Plea to King Wrynn |
| Solomon's Plea to Darkshire | 1409 | letter from him | take a letter to Lord Ello Ebonlocke in Darkshire. | Messenger to Darkshire |
| Solomon's Plea to Westfall | 1407 | letter from him | take his written plea to Gryan Stoutmantle in Westfall. | Messenger to Westfall |
| Ebonlocke's Response to Solomon | 1410 | turn-in | Return to Magistrate Solomon with Lord Ello Ebonlocke's letter of response. | Messenger to Darkshire (2) |
| Stoutmantle's Response to Solomon | 1408 | turn-in | Return to Magistrate Solomon with Gryan Stoutmantle's response. | Messenger to Westfall (2) |
| The General's Response | 1294 | letter from him | provided by Magistrate Solomon to be delivered to General Marcus Jonathan | The General's Response |
| The State of Lakeshire | 1293 | report from him | Magistrate Solomon has given you a report which must be delivered to General Marcus Jonathan | Messenger to Stormwind |
| Helendis Riverhorn's Letter | 11366 | turn-in | deliver Helendis Riverhorn's Letter to Magistrate Solomon. | The True Masters |
| Bolvar's Decree | 11368 | turn-in | Take Bolvar's Decree to Magistrate Solomon in Lakeshire. | The True Masters (4) |
| Head of Gath'Ilzogg | 3633 | turn-in | bring his head to Magistrate Solomon in Lakeshire for the reward. | Wanted: Gath'Ilzogg (quest) |
| Fangore's Paw | 3632 | turn-in | return to Magistrate Solomon in Lakeshire with his paw. | Wanted: Lieutenant Fangore (quest) |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Fire Hardened Buckler | 1276 | Reward from Tharil'zun quest (Marshal Marris) | Fire Hardened Buckler is a quest reward from Tharil'zun (quest). |
| Gold Militia Boots | 2910 | Reward from Howling in the Hills (Verner Osgood) | Gold Militia Boots are a quest reward from Howling in the Hills. |
| Orc Crusher | 6093 | Reward from Tharil'zun quest (Marshal Marris) | Orc Crusher is a quest reward from Tharil'zun (quest). |
| Ring of Iron Will | 1319 | Reward from Howling in the Hills (Verner Osgood) | Ring of Iron Will is a quest reward from Howling in the Hills. |
| Tabard of Stormwind | 11364 | Beta-only reward, removed before launch | The Tabard of Stormwind was a quest reward from The True Masters (4) during the beta version of World of Warcraft, but was removed before going live. |
| Tharil'zun's Head | 1260 | Turn-in to Marshal Marris (Tharil'zun quest), not Solomon | Tharil'zun's Head drops from Tharil'zun in Redridge Mountains. |
| Yowler's Paw | 3614 | Turn-in to Verner Osgood (Howling in the Hills) | Yowler's Paw drops from Yowler in Redridge Mountains. |

### Ogg'marr (4879)

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Cured Ham Steak | 4599 | Vendor food (Ogg'marr sells meat and drink) | via: linked from NPC page |
| Haunch of Meat | 2287 | Vendor food (Ogg'marr sells meat and drink) | Haunch of Meat is preserved meat eaten by adventurers. |
| Ice Cold Milk | 1179 | Vendor drink (Ogg'marr sells meat and drink) | Ice Cold Milk: |
| Melon Juice | 1205 | Vendor drink (Ogg'marr sells meat and drink) | Melon Juice can be purchased for from: |
| Moonberry Juice | 1645 | Vendor drink (Ogg'marr sells meat and drink) | Moonberry Juice can be purchased for from many drink vendors and innkeepers, primarily those in Kalimdor and the Eastern Kingdoms. It is also a Kalimdor and Eastern Kingdoms world drop. |
| Morning Glory Dew | 8766 | Vendor drink (Ogg'marr sells meat and drink) | Morning Glory Dew can be purchased for from: |
| Mutton Chop | 3770 | Vendor food (Ogg'marr sells meat and drink) | Mutton Chops are preserved meat eaten by adventurers. |
| Recipe: Carrion Surprise | 12232 | Vendor recipe (Ogg'marr sells recipes) | via: linked from NPC page |
| Recipe: Dragonbreath Chili | 12239 | Vendor recipe (Ogg'marr sells recipes) | via: linked from NPC page |
| Recipe: Heavy Crocolisk Stew | 20075 | Vendor recipe (Ogg'marr sells recipes) | via: linked from NPC page |
| Recipe: Roast Raptor | 12228 | Vendor recipe (Ogg'marr sells recipes) | The Recipe: Roast Raptor can be purchased for from: |
| Refreshing Spring Water | 159 | Vendor drink (Ogg'marr sells meat and drink) | Refreshing Spring Water is the lowest-level drink item available. |
| Roasted Quail | 8952 | Vendor food (Ogg'marr sells meat and drink) | Roasted Quail is sold by food vendors throughout the world. |
| Sweet Nectar | 1708 | Vendor drink (Ogg'marr sells meat and drink) | Sweet Nectar is a drink that can be purchased for from many innkeepers and other vendors in Kalimdor and the Eastern Kingdoms. |
| Tough Jerky | 117 | Vendor food (Ogg'marr sells meat and drink) | Tough Jerky is preserved meat eaten by adventurers. |
| Wild Hog Shank | 3771 | Vendor food (Ogg'marr sells meat and drink) | Wild Hog Shanks are preserved meat eaten by adventurers. |

No KEEP for this veteran.

### Sprinkle (7583)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Violet Tragan | 8526 | turn-in | collect a Violet Tragan and return it to her. | Sprinkle's Secret Ingredient |
| Thistleshrub Dew | 8603 | turn-in | Thistleshrub Dew is provided as an objective for In Good Taste. | In Good Taste |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Boots of the Undermine Revolutionary | 232407 | Retail-only (We Own the Streets) | Boots of the Undermine Revolutionary are a quest reward from We Own the Streets. |
| Chainmail of the Undermine Revolutionary | 232356 | Retail-only (We Own the Streets) | Chainmail of the Undermine Revolutionary is a quest reward from We Own the Streets. |
| Cinch of the Liberator | 232405 | Retail-only (Get Our People Out) | Cinch of the Liberator are a quest reward from Get Our People Out. |
| Headgear of the Undermine Revolutionary | 232406 | Retail-only (We Own the Streets) | Headgear of the Undermine Revolutionary is a quest reward from We Own the Streets. |
| Legguards of the Undermine Revolutionary | 232408 | Retail-only (We Own the Streets) | Legguards of the Undermine Revolutionary are a quest reward from We Own the Streets. |
| Noggenfogger Elixir | 8529 | Vendor product sold by Sprinkle | Noggenfogger Elixir is a consumable potion purchasable from Sprinkle Noggenfogger in Gadgetzan in stacks of 5 for . Invented by Marin Noggenfogger, the green potion is made from dew from ... |
| Noggenfogger's Recommendation | 227663 | Given by Marin for Work the Line (Jojo Gobdre) | Noggenfogger's Recommendation is provided by Marin Noggenfogger. It must be sent to Jojo Gobdre in Work the Line. |
| Robe of the Liberator | 232354 | Retail-only (Get Our People Out) | Robe of the Liberator is a quest reward from Get Our People Out. |
| Sabatons of the Liberator | 232403 | Retail-only (Get Our People Out) | Sabatons of the Liberator are a quest reward from Get Our People Out. |
| Shoulderguards of the Liberator | 232401 | Retail-only (Get Our People Out) | Shoulderguards of the Liberator are a quest reward from Get Our People Out. |
| Thick Yeti Fur | 12366 | Drops from Ice Thistle yetis; objective of Are We There, Yeti? | Thick Yeti Fur drops from the following Ice Thistle yetis in Winterspring: |
| Umi's Mechanical Yeti | 12928 | Objective of Yetiphobia / Are We There, Yeti? (Umi) | Umi's Mechanical Yeti is provided as an objective for the following quests: |
| Violet Powder | 8528 | Delivered to Marin in Delivery for Marin, not Sprinkle | Violet Powder is provided as an objective for Delivery for Marin. |

### Dalar Dawnweaver (1938)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Head of Arugal | 5442 | turn-in | Kill Arugal and bring his head to Dalar Dawnweaver at the Sepulcher. | Arugal Must Die |
| Head of Grimson | 3634 | turn-in | Kill Grimson the Pale and bring his head to Dalar Dawnweaver at the Sepulcher. | Arugal's Folly (3) |
| Darksoul Shackle | 3157 | turn-in | Bring 6 Glutton Shackles and 3 Darksoul Shackles to Dalar Dawnweaver | Arugal's Folly (2) |
| Glutton Shackle | 3156 | turn-in | Bring 6 Glutton Shackles and 3 Darksoul Shackles to Dalar Dawnweaver | Arugal's Folly (2) |
| Pyrewood Shackle | 3218 | turn-in | Bring 6 Pyrewood Shackles to Dalar Dawnweaver at the Sepulcher. | Arugal's Folly (4) |
| Rune-inscribed Pendant | 3353 | turn-in | Take the rune-inscribed pendant to Dalar Dawnweaver at the Sepulcher. | Dalar's Analysis |
| Remedy of Arugal | 3155 | quest item | Retrieve the Remedy of Arugal for Dalar Dawnweaver at the Sepulcher. | Arugal's Folly |
| Worgen Bits | 280375 | turn-in | Bring 6 Worgen Bits to Dalar Dawnweaver in The Sepulcher. | Arugal's Folly (5) |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Bonegrinding Pestle | 3570 | Reward from Arugal's Folly (4); quest is about Arugal, not Dalar | The Bonegrinding Pestle is a quest reward from Arugal's Folly (4) which starts with Dalar Dawnweaver at the Sepulcher in Silverpine Forest. |
| Cinder Wand | 5242 | Reward from Arugal's Folly (4); quest is about Arugal, not Dalar | The Cinder Wand is a quest reward from Arugal's Folly (4). |
| Foulfur Gloves | 281315 | Reward from Arugal's Folly (5); Forever-only, quest is about Arugal | Foulfur Gloves are a quest reward from Arugal's Folly (5) in . |
| Logsplitter | 3586 | Reward from Arugal's Folly (4); quest is about Arugal, not Dalar | The Logsplitter is a quest reward from Arugal's Folly (4). |
| Seal of Sylvanas | 6414 | Reward from Arugal Must Die; quest is about Arugal | The Seal of Sylvanas is a ring that gives good bonuses to strength and stamina. |

### Morbent Fel (1200)

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Ambassador's Boots | 2033 | Reward from Crime and Punishment (Councilman Millstipe) | Ambassador's Boots are a quest reward from Crime and Punishment (Classic) which begins with Councilman Millstipe in the Darkshire Town Hall in Duskwood. |
| Darkshire Mail Leggings | 2906 | Reward from Crime and Punishment (Councilman Millstipe) | Darkshire Mail Leggings are a quest reward from Crime and Punishment (Classic). |
| Hand of Dextren Ward | 3628 | Drops from Dextren Ward (Crime and Punishment quest) | The Hand of Dextren Ward was a quest item that dropped from Dextren Ward in The Stockade. |
| Jitters' Completed Journal | 2560 | Turned in to Sven (Return to Sven), not Morbent | Jitters' Completed Journal is provided as an objective for the following quests: |
| Morbent's Bane (Classic) | 7297 | Sven's quest item, returned to Sven | Morbent's Bane is a off-hand item. Sven Yorgen sends adventurers to forge a weapon capable of defeating Morbent Fel. Lightforge Ingots salvaged from the sunken elven destroyer, the Flying... |
| Night Watch Pantaloons | 2954 | Generic reward from Morbent Fel quest | Night Watch Pantaloons were a quest reward from Morbent Fel (quest). |
| Sparkmetal Coif | 1282 | Generic reward from Morbent Fel quest | Sparkmetal Coif was a quest reward from Morbent Fel (quest). |
| Torch of Holy Flame | 7344 | Reward from Morbent Fel quest, which Sven starts (open question) | Torch of Holy Flame is a off-hand item. It gives bonuses to spirit and spell power. Sven Yorgen sends adventurers to forge a weapon capable of defeating Morbent Fel. Lightforge Ingots sal... |
| Town Clerk's Mittens | 270029 | Retail-only (Crime and Punishment) | The Town Clerk's Mittens are a quest reward from Crime and Punishment (Classic). |
| Watch Master's Cloak | 2953 | Generic reward from Morbent Fel quest | Watch Master's Cloak was a quest reward from Morbent Fel (quest). |

No KEEP for this veteran.

### Marshal Dughan (240)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Marshal McBride's Documents | 745 | turn-in | Take Marshal McBride's Documents to Marshal Dughan at Goldshire in Elwynn Forest. | Report to Goldshire |
| The Collector's Ring | 2239 | turn-in | return to Marshal Dughan with The Collector's Ring. | Manhunt (Classic) |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Elastic Wristguards | 1183 | Generic reward from Manhunt | Elastic Wristguards are a quest reward from . |
| Gold Pickup Schedule | 1307 | Starts The Collector quest, not Dughan's | Gold Pickup Schedule begins the quest . |
| Patched Pants | 2237 | Generic reward from Cloth and Leather Armor | Patched Pants are a quest reward from Cloth and Leather Armor. |
| Pikeman Shield | 6078 | Reward from Report to Goldshire; quest is about McBride's documents | Pikeman Shield is a quest reward from Report to Goldshire. |
| Stormwind Armor Marker | 748 | Objective of Cloth and Leather Armor, not Dughan | The Stormwind Armor Marker is provided as an objective for Cloth and Leather Armor. |
| Stormwind Chain Gloves | 1360 | Generic reward from Manhunt | Stormwind Chain Gloves are a quest reward from Manhunt (Classic). |
| Well-Stitched Robe | 1171 | Generic reward from Cloth and Leather Armor | Well-Stitched Robe is a quest reward from Cloth and Leather Armor. |

### Lord Aliden Perenolde (2423)

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Brigand's Pauldrons | 3765 | Reward from Taretha's Gift (Krusk) | Brigand's Pauldrons are a quest reward from Taretha's Gift. |
| Burnished Gold Key | 3499 | Dropped by Jailor Marlgen (Durnholde) | The Burnished Gold Key dropped from Jailor Marlgen at Durnholde Keep in Hillsbrad Foothills. |
| Dull Iron Key | 3467 | Dropped by Jailor Eston (Durnholde) | The Dull Iron Key drops from Jailor Eston at Durnholde Keep in Hillsbrad Foothills. |
| Grunt Vest | 3752 | Reward from The Rescue (Krusk) | Grunt Vest is a quest reward from The Rescue. |
| Mantis Boots | 3764 | Reward from Taretha's Gift (Krusk) | Mantis Boots are a quest reward from Taretha's Gift. |
| Orcish War Chain | 3733 | Reward from The Rescue (Krusk) | Orcish War Chain is one of two possible rewards from the quest The Rescue. |
| Recipe: Big Bear Steak | 3734 | Reward from The Rescue; sold by Kiatke | The Recipe: Big Bear Steak is sold by Kiatke in Stormwind City and Orgrimmar for . |
| Taretha's Necklace | 3498 | Pendant for Krusk's quests (Taretha's Gift), not Aliden | Taretha's Necklace once belonged to Taretha Foxton, the foster sister of Thrall. It has a dent, a slight misshaping of the bottom horn of the crescent. |

No KEEP for this veteran.

### Draz'Zilb (4501)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Searing Heart | 5841 | turn-in | bring him 7 Searing Tongues and 7 Searing Hearts. | Identifying the Brood |
| Searing Tongue | 5840 | turn-in | bring him 7 Searing Tongues and 7 Searing Hearts. | Identifying the Brood |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Mok'Morokk's Grog | 5835 | Objective of Overlord Mok'Morokk's Concern (Mok'Morokk's quest) | The Mok'Morokk's Grog is located in Dustwallow Marsh. |
| Mok'Morokk's Snuff | 5834 | Objective of Overlord Mok'Morokk's Concern (Mok'Morokk's quest) | Mok'Morokk's Snuff is located in Dustwallow Marsh. |
| Mok'Morokk's Strongbox | 5836 | Objective of Overlord Mok'Morokk's Concern (Mok'Morokk's quest) | Mok'Morokk's Strongbox is located in Dustwallow Marsh. |
| Rustler Gloves | 9704 | Generic reward from Identifying the Brood | Rustler Gloves are a quest reward from Identifying the Brood. |
| Scorched Cape | 9703 | Generic reward from Identifying the Brood | Scorched Cape is a quest reward from Identifying the Brood. |

### Pozzik (4630)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Fuel Regulator Blueprints | 5852 | turn-in | Deliver the Fuel Regulator Blueprints to Pozzik on the Shimmering Flats. | Goblin Sponsorship (5) |
| Hollow Vulture Bone | 5848 | turn-in | Get 10 Hollow Vulture Bone for Pozzik in the Shimmering Flats. | Load Lightening |
| Sample of Indurium Ore | 5866 | turn-in | Bring the Sample of Indurium Ore to Pozzik on the Shimmering Flats. | Rizzle's Schematics |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Indurium Ore | 5833 | Objective of Indurium Ore (quest) started by Pozzik; turn-in NPC not on page (open question) | Indurium Ore was mined from Indurium Mineral Veins with Mining (150). These veins could only be found inside Uldaman. |
| Seaforium Booster | 5862 | Objective for Razzeric and Shreev, not Pozzik | Seaforium Booster was a quest item only lootable by players on the quest Razzeric's Tweaking. It was also provided for the quest Safety First (Thousand Needles). |
| The Pozzik Standard | 232982 | Retail-only (Undermine race reward) | The Pozzik Standard is a customization for the G-99 Breakneck, awarded from Undermine Breaknecking: Bronze by completing the four race courses in Undermine. |

### Rizzle Brassbolts (4720)

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Blacksmith Hammer | 5956 | Vendor goods, not Rizzle's | A Blacksmith Hammer is a tool used in a wide variety of blacksmithing recipes. It's also required for some engineering recipes. |
| Coal | 3857 | Vendor reagent | Coal is a dark, stony substance used for smelting steel. It is also used for gaining Thorium Brotherhood reputation. |
| Elemental Flux | 18567 | Crafting reagent (vendor) | Elemental Flux is flux crafting reagent used in the smelting of Enchanted Elementium Bar in Mining and in several recipes in Blacksmithing. It is sold by most blacksmith supplies vendors ... |
| Mining Pick | 2901 | Generic mining tool | The Mining Pick item is the definitive and original mining pick. |
| Strong Flux | 3466 | Crafting reagent, objective of War at Sea | Strong Flux can be purchased for from various profession vendors. |
| Weak Flux | 2880 | Crafting reagent (vendor) | Weak Flux is used by Blacksmiths to purge metals of impurities while they are forged into an item. The most common type of flux in iron and steel furnaces is limestone. |

No KEEP for this veteran.

### Wharfmaster Dizzywig (3453)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Kravel's Parts Order | 5799 | turn-in | Bring Kravel's Parts Order to Wharfmaster Dizzywig in Ratchet. | Wharfmaster Dizzywig (quest) |
| Secure Crate | 6462 | turn-in | Bring the Secure Crate to Wharfmaster Dizzywig in Ratchet. | Wharfmaster Dizzywig (Barrens) |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| A Sack of Coins | 5335 | Reward from Miner's Fortune (Classic), not Dizzywig | A Sack of Coins is a quest reward from Miner's Fortune (Classic). |
| Cats Eye Emerald | 5097 | Drops from Venture Co. members | The Cats Eye Emerald drops from the following members of the Venture Company in the Northern Barrens: |
| Gazlowe's Ledger | 5080 | Objective of The Missing Shipment (Gazlowe) | Gazlowe's Ledger is provided as an objective for The Missing Shipment and The Missing Shipment (2). |
| Kravel's Parts | 5800 | Objective of Delivery to the Gnomes, delivered to the gnomes | Kravel's Parts are provided as an objective for Delivery to the Gnomes. |

### Misha (10204)

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Chartreuse Champion's Shoulderplates | 209900 | Retail-only (Dragonflight, Forlorn Hope) | Chartreuse Champion's Shoulderplates are a quest reward from Forlorn Hope and The Age of Mortals. |
| Fearless Faerie's Shoulderpads | 209899 | Retail-only (Dragonflight, Forlorn Hope) | Fearless Faerie's Shoulderpads are a quest reward from Forlorn Hope and The Age of Mortals. |
| Horn of Cenarius (Dragonflight) | 208752 | Retail-only (Dragonflight) | Horn of Cenarius is provided as an objective for The Age of Mortals. |
| Spirited Stag's Epaulets | 209902 | Retail-only (Dragonflight, Forlorn Hope) | Spirited Stag's Epaulets are a quest reward from Forlorn Hope and The Age of Mortals. |
| Summer Soother's Shoulders | 209901 | Retail-only (Dragonflight, Forlorn Hope) | Summer Soother's Shoulders are a quest reward from Forlorn Hope and The Age of Mortals. |

No KEEP for this veteran.

### Cairne Bloodhoof (3057)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Horn of Arra'chea | 4841 | turn-in | Cairne Bloodhoof in Thunder Bluff wants you to bring him the Horn of Arra'chea. | Rites of the Earthmother (3) |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Kodo Hunter's Leggings | 4909 | Reward from Rites of the Earthmother (3); quest is about the Earthmother rites (open question) | Kodo Hunter's Leggings are the sign of a great hunter. The leather leggings provide a bonus to agility. |
| Stormpike Soldier's Blood | 17306 | Not tied to this veteran (quest: Lokholar the Ice Lord (quest)) | Stormpike Soldier's Blood drops to the Horde from Alliance players (and in low quantities from NPCs) killed in Alterac Valley. It disappears on leaving Alterac Valley. |

### Arygos (15380)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Imperial Qiraji Armaments | 21232 | turn-in | will create Elementium Infused Armaments for you should you bring him Imperial Qiraji Armaments | Imperial Qiraji Armaments (quest) |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Elementium Ingot | 18562 | Blackwing Lair drop, reagent for Elementium armaments; not turned in to Arygos | Elementium Ingot is a rare and difficult metal to process. Although the Cataclysm and the resulting exposure of Azeroth to the Elemental Planes has made Elementium Ore more common, this p... |
| The War of the Shifting Sands | 20415 | Book for Anachronos's quest, not Arygos's item | The War of the Shifting Sands is provided for Anachronos (quest). |

### Muln Earthfury (253957)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Titan Relic | 270866 | turn-in | Bring the Titan Relic to Muln Earthfury at the Skywatcher Plateau in northwest Mulgore. | Earthen Echo |
| Furs of the Earthen Ring | 271719 | quest reward | are a quest reward from Earthen Echo. | Furs of the Earthen Ring |
| Healer's Staff | 271767 | quest reward | is a quest reward from Earthen Echo and Prehistoric Prism. | Healer's Staff |
| Heavehammer | 271766 | quest reward | is a quest reward from Earthen Echo and Prehistoric Prism. | Heavehammer |

### Arei (9598)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Clouddrift Mantle | 11874 | quest reward | was a quest reward from Ancient Spirit (quest), which started with Arei | Clouddrift Mantle |
| Ethereal Mist Cape | 11873 | quest reward | was a quest reward from Ancient Spirit (quest), which started with Arei | Ethereal Mist Cape |

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Flute of the Ancients | 11445 | Reward from Purified! quest, not Arei | Flute of the Ancients is a quest reward from Purified!. |

### Daryl Riknussun (5159)

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Mild Spices | 2678 | Cooking ingredient, sold by vendors | Mild Spices are a component used in very early cooking skillups. They were formerly used for a lot of creations before being later replaced by Hot Spices#Classic but were removed from alm... |

No KEEP for this veteran.

### Fleet Master Seahorn (2487)

REJECT

| item | id | reason | quoted line |
|---|---|---|---|
| Lucky Fishing Hat | 19972 | Reward from the Rare Fish quest (Fishbot 5000), not Seahorn | The Lucky Fishing Hat is an uncommon cloth hat with a bonus to stamina and fishing. It is a quest reward from the Stranglethorn Fishing Extravaganza quest Rare Fish - Keefer's Angelfish, ... |

No KEEP for this veteran.

### Ranger Lord Hawkspear (10824)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Ranger Lord's Longsword | 284157 | drop | is dropped by Ranger Lord Hawkspear in the Eastern Plaguelands. | Ranger Lord's Longsword |

### Mordent Evenshade (253471)
none found (checked: Mordent Evenshade)

No KEEP for this veteran.

### Chronalis (8197)
none found (checked: Chronalis)

No KEEP for this veteran.

### General Rajaxx (15341)

KEEP

| item | id | kind | quoted line | page |
|---|---|---|---|---|
| Manslayer of the Qiraji | 21492 | drop | drops from General Rajaxx in the Ruins of Ahn'Qiraj. | Manslayer of the Qiraji |
| Boots of the Vanguard | 21493 | drop | drops from General Rajaxx in the Ruins of Ahn'Qiraj. | Boots of the Vanguard |
| Boots of the Qiraji General | 21497 | drop | drops from General Rajaxx in the Ruins of Ahn'Qiraj. | Boots of the Qiraji General |
| Legplates of the Qiraji Command | 21495 | drop | drops from General Rajaxx in the Ruins of Ahn'Qiraj. | Legplates of the Qiraji Command |
| Bracers of Qiraji Command | 21496 | drop | drops from General Rajaxx in the Ruins of Ahn'Qiraj. | Bracers of Qiraji Command |
| Southwind's Grasp | 21494 | drop | drops from General Rajaxx in the Ruins of Ahn'Qiraj. | Southwind's Grasp |
| Qiraji Ceremonial Ring | 20888 | token from him (shared) | This item drops from all bosses in the Ruins of Ahn'Qiraj. | Qiraji Ceremonial Ring |
| Qiraji Magisterial Ring | 20884 | token from him (shared) | This item drops from all bosses in the Ruins of Ahn'Qiraj. | Qiraji Magisterial Ring |
| Qiraji Martial Drape | 20885 | token from him (shared) | This item drops from Kurinnaxx, General Rajaxx, Buru the Gorger, and Ayamiss the Hunter. | Qiraji Martial Drape |
| Qiraji Regal Drape | 20889 | token from him (shared) | This item drops from Kurinnaxx, General Rajaxx, Buru the Gorger, and Ayamiss the Hunter. | Qiraji Regal Drape |

### Kor'jus (3329)
none found (checked: Kor'jus)

No KEEP for this veteran.


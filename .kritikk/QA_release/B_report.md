# QA report, group B (23 entries)

Method: every NPC ID fetched from Wowhead Classic (title, g_mapperData zone/coords), every listed wiki page fetched as raw wikitext, Characters tables read with column/colspan logic, backlinks of the NPC pages checked for missing book appearances. ID, name, zone and coords PASS for all 23 (all IDs <= 200000; Scarlet Monastery / Gnomeregan bosses have no map coords, which is expected for instances). Helper scripts and cached pages are in `B_tmp/`.

Fixed entries are in `B_fixed.lua`.

## 2257 Mug'thol: PASS
Wowhead "Mug'thol", Alterac 35.2/54.0 matches. https://warcraft.wiki.gg/wiki/The_Dark_Lady_(WC3_Undead): "Possess the warlord Ogre Mug'thol"; Mug'thol (Warcraft III) page "Like other leaders, Mug'thol and his ogres helped Sylvanas defeat Varimathras". WoW part (Crown of Will, Crushridge) matches Mug'thol page. Item 3553 "Mug'thol's Head" is a real quest item for The Crown of Will.

## 2543 Archmage Ansirem Runeweaver: FIX
- WC3 role overclaims. https://warcraft.wiki.gg/wiki/Under_the_Burning_Sky_(WC3_Undead) Notes: "the enemy random heroes have unique names referring mostly to World of Warcraft NPCs: Karlain, Ansirem Runeweaver, Ericon... Only 6 archmage heroes are active on normal difficulty, so one will be missing at each playthrough." Role and story reworded to "one of seven randomly named enemy archmage heroes".
- Removed "In the Shadow of the Sun" appearance: Ansirem sits in the Mentioned column and the only content is Rommath's contempt for him ("Does nothing while..."), no action by him.
- Tides of War (Minor, council meetings) and Quest for Pandaria (Minor, rescues Catelyn) kept; verified on his NPC page. Quests "Ansirem's Key" (starts) and "Magical Analysis" (finishes) verified. Coords 18.8/78.5 OK.

## 10666 Gordo: PASS
Wowhead "Gordo", Tirisfal 39.8/51.2 is a listed point. City_of_the_Dead optional quest "Gordo: Find Gordo / Free Gordo / Return to Melisara"; Gordo page: "found him in a spider den, trapped in a web", Classic part "gloom weed for Junior Apothecary Holland". Cataclysm relocation not used.

## 2263 Marshal Redpath: PASS
Wowhead "Marshal Redpath", 49.6/58.6 OK. Marcus Redpath page: headman who "greeted Anduin Lothar, Khadgar" (Tides of Darkness, first prologue; he is in the Minor column). Post-Third War marshal text matches. Cataclysm/comic parts not used.

## 2423 Lord Aliden Perenolde: FIX (role)
Coords 39.4/15.2 OK. Beyond the Dark Portal: Supporting column. Role was an identity description, not an action, and chapter 7 is only a discussion of him by Terenas/Thoras. Role reworded: chapter 7 discussed as heir, chapter 10 punches his father. Story unchanged (all sentences on https://warcraft.wiki.gg/wiki/Aliden_Perenolde: "punched him in the face, saying that he had ruined Aliden's efforts").

## 2784 King Magni Bronzebeard: FIX (missing appearance)
Added BOOK "The Shattering: Prelude to Cataclysm" (Major column; the story already describes it). https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm Characters: Magni under Major. Other appearances verified (Tides of Darkness pg. 335, though he is in the Mentioned column there, NIT; Before the Storm; Blood Ties ch 17). Optional extras not added: The Vow Eternal (Supporting), Pearl of Pandaria (Minor).

## 5137 Reyna Stonebranch: PASS
Wowhead coords 55.4/58.8. Her page: "Following the instructions from the tablet from Ulduar, Reyna created the liquid that was intended for Magni" (Shattering pg. 141; Minor).

## 5144 Bink: PASS
Wowhead 26.8/8.6. Bink page (female, Dink's sister): "had Bink and her brother Dink caught by Dark Iron dwarves but were released when Ironforge dwarves attacked them".

## 7312 Dink: PASS
Wowhead 26.8/8.4. Same source, Dink is male, Bink his sister.

## 7937 High Tinker Mekkatorque: FIX (missing appearances)
Existing four book appearances verified (Wolfheart ch 9/10/29, Tides of War ch 23, Before the Storm ch 8/14). Missing and added:
- Cut Short (Major) https://warcraft.wiki.gg/wiki/Cut_Short: "Leading this desperate charge is High Tinker Gelbin Mekkatorque"; Sicco page "Cut Short" section for the trap fight. Story sentence added.
- Beyond the Dark Portal ch 5 (Supporting column; Gelbin page: "He kept General Turalyon informed... a problem of rats", ref BtDP chapter 5).
- War Crimes ch 2 (Minor column; Gelbin page: "The high tinker laughed humorlessly and retorted that Gallywix meant monetary compensation").

## 11406 High Priest Rohan: PASS
Wowhead 23.4/6.4. Chapters 11, 14, 15, 31 verified on his page. NIT: story sentence 2 starts "Shortly before the Cataclysm" but follows a sentence naming the novel, so it is tied to the book; left unchanged.

## 1156 Vyrin Swiftwind: FIX (role)
Coords 81.8/64.2 OK. Role said Baenan "delivers" the rings; the Vyrin page says "Baenan resolves to do so". Role reworded (she speaks of her longing to Baenan; Talithar asks Baenan to bring the rings). Story verified (Quest for Pandaria Part 4 pg. 9-10, 13-14; she is in the Mentioned column but speaks with Baenan per her page).

## 3976 Scarlet Commander Mograine: PASS
Wowhead zone Scarlet Monastery. https://warcraft.wiki.gg/wiki/A_Scarlet_Flame_(WC3_Undead): "Defeat Scarlet Commander Mograine and High Inquisitor Whitemane" in "The Dark Lady's Scalpel"; Renault page FK section matches sentences 3-4. NIT: story sentences 1-2 (killing Alexandros, becoming Scarlet Commander) come from the Ashbringer comic section of the Renault page; the facts are canon pre-Classic, kept.

## 3977 High Inquisitor Whitemane: PASS
Quests "Our Home, Our Land" (defeat Whitemane) and "The Dark Lady's Scalpel" verified. We Ride Forth (Major): "Darion ordered Nazgrim and Sally Whitemane to rescue Bolvar". Story is not wrong; it could also mention the short story but that is optional.

## 7800 Mekgineer Thermaplugg: FIX (role/story)
Role "the betrayer the gnomes must face" had no concrete action. Replaced by what happens in Cut Short (Sicco page: traps Gelbin with a tripwire on his spectacles, attacks in a battle suit, Gelbin "cutting Thermaplugg's suit in half... Gelbin decided to leave him for dead"). Story sentence 4 rewritten with that; other sentences verified. Wowhead zone Gnomeregan.

## 2216 Apothecary Lydon: PASS
Wowhead 61.4/19.2. Edge of Night (Supporting column): "Lydon oversaw the attack on Gilneas alongside Warchief Garrosh Hellscream", page "Master Apothecary Lydon" states the identity. Tarren Mill quest-giver and Umpi verified.

## 1573 Gryth Thurden: PASS
Wowhead 55.4/47.4 (0.1 off). The Shattering (Minor): "He explained all of this to Prince Anduin Wrynn".

## 2918 Advisor Belgrum: FIX
- Story sentence 1 wrote "a dwarf of Old Ironforge", a Cataclysm location written as his current place (the known lesson "Belgrum/Tablets"). Now "a dwarf and a member of the Explorers' League". Wowhead position 76.8/10.4 is the Hall of Explorers.
- Shattering role described his WoW quest behaviour ("gives orders on the King's authority"), not the book. Replaced with book actions from his page: tries with Muninn Magellas to decipher the tablet, speaks at the ritual, fills in as head of government (pg. 148).
- Removed the Before the Storm appearance and story sentence: Belgrum is only in the Mentioned column there and the only claim is Moira asking him to take Dagran away; role started with "Mentioned in chapter 7".

## 5387 High Explorer Magellas: FIX
- Shattering role "In chapter 12 Anduin recognizes him..." is not in the sources; the High Explorer Muninn Magellas page says he "tried to decipher the phrases from Tablets of the Earth and was present at the ritual... translated the unknown language spoken by Magni and Belgrum to Anduin". Role and story rewritten.
- Story contained a meta sentence ("The World of Warcraft game manual names him...") and the Before the Storm page was a listed source but not an appearance. Added BOOK Before the Storm ch 8 (Minor): "Muninn immediately agreed to send a team from the Explorers' League to Silithus". Source link changed to the correct page https://warcraft.wiki.gg/wiki/High_Explorer_Muninn_Magellas (the old title is a disambiguation page that also covers the RPG-only Tomli Magellas).
- Platinum Discs quest content verified on the Muninn page.

## 5159 Daryl Riknussun: PASS
Wowhead 60.2/36.4. The War Effort: he is on the Characters list and "Daryl helped Saegan wrap and pack them in a crate".

## 15457 Huntress Swiftriver: REMOVE
- Event-only: her page says "As part of the Gates of Ahn'Qiraj event, Classic only" (the one-time war-effort event), so players cannot meet her normally.
- The only appearance is a name drop. The War Effort text: "Huntress Swiftriver would have plenty of food to provide for the soldiers today"; she never appears, and the role is literally "Mentioned: the intended recipient...". The brief rejects Mentioned-only appearances.
(If the orchestrator keeps her anyway, nothing in her coords/story is factually wrong.)

## 2707 Shadra: FIX (missing appearance)
Coords 33.4/72.6 is a listed point. Vol'jin: Shadows of the Horde (Minor) verified (ch 10, 20, 34). Added BOOK "Traveler: The Spiral Path" ch 34: https://warcraft.wiki.gg/wiki/Traveler:_The_Spiral_Path "At Zul'Farrak, the trolls prepare to sacrifice the captives to Eraka no Kimbul, Elortha no Shadra, and Ueetay no Mueh'zala. Kimbul honors Makasa and Hackle, Shadra refuses to claim Drella or Murky". Shadra page identifies Elortha no Shadra as the Hinterlands loa. Story sentence added.

## 5635 Falstad Wildhammer: FIX (missing appearances)
Wowhead 11.8/46.8. Day of the Dragon (Major) and Before the Storm (Minor) verified. Added, all with concrete actions on https://warcraft.wiki.gg/wiki/Falstad_Wildhammer: Stormrage ch 3 (Minor; attends the Malfurion/Tyrande wedding), Quest for Pandaria (Minor; Council cannot help Li Li, Falstad laughs), War Crimes ch 1 (Minor; attends Garrosh's trial). Not added: The Jade Hunters (Mentioned column), The Shattering ch 31 (only named as representative).

## Counts
23 entries: PASS 12 (2257, 10666, 2263, 5137, 5144, 7312, 11406, 3976, 3977, 2216, 1573, 5159), FIX 10 (2543, 2423, 2784, 7937, 1156, 7800, 2918, 5387, 2707, 5635), BLOCKER 0, REMOVE 1 (15457).
Of the FIXes: 2 content errors (5387 unsupported chapter-12 claim and meta sentence; 2918 Old Ironforge/wrong role), 6 missing appearances or wrong mission/role wording, 2 role wording.

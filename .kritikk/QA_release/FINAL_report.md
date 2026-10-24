# FINAL release critic: diff v0.8.1..HEAD (Data.lua + Memorials.lua, History of Warcraft books excluded)

Checked: whole diff read; related ids scripted (all exist, 0 dangling; removed 4500 is referenced nowhere); story length 3-6 sentences scripted (0 violations); banned-word grep (0 hits in player text); tests/validate_db.py passes; ~30 claims checked against warcraft.wiki.gg raw wikitext (Zeliek, Rend, Ras, Rivendare, Barthilas, Balnazzar, Varimathras, Sharlindra, Onyxia/Visage Day, Moira/Fire and Iron, Aliden, Falstad, Tyrande/Shandris/Wolfheart/Stormrage, Rajaxx, Thoras, KT/Cycle of Hatred, Sylvanas' Farewell, A Kingdom Divided, Gadrin/Judgment, Gelbin/Cut Short, Spiral Path, Drek'Thar, Elerethe, Benedictus, Uther/Darrowmere, ...). All of those hold. Consistency across Onyxia/Prestor, Nefarian/Nefarius, Balnazzar/Dathrohan, KT/Rivendare/Zeliek, game codes (WC3/TFT/FK), "The Shattering: Prelude to Cataclysm", "Jaina Proudmoore: Tides of War": no contradictions found.

Result: 1 BLOCKER, 4 FIX, 6 NIT.

---

## BLOCKER

### 1. [15989] Sapphiron, field `story` (last sentence): post-Classic loot written as WoW state
Current:
`.. "Even in undeath he keeps his key to the Focusing Iris.",`
Replace with:
`.. "His frost magic, strengthened when Arthas raised him, defends Kel'Thuzad at all costs.",`
Why: the Key to the Focusing Iris is a Wrath-era Naxxramas item (Eye of Eternity). Wiki, Sapphiron: "Even in undeath, he continued to hold onto his key to the Focusing Iris, which was retrieved by adventurers when they defeated the frost wyrm" (cites The Key to the Focusing Iris / The Heroic Key to the Focusing Iris). The replacement is from the same page: "Sapphiron used his frost magic to defend Kel'Thuzad at all costs" (Classic Naxxramas launch post). https://warcraft.wiki.gg/index.php?title=Sapphiron&action=raw
Sentence count stays 5.

---

## FIX

### 2. [10540] Vol'jin, TFT appearance, field `role`: wrong class
Current:
`role = "Quest giver and advisor (Shadow Hunter); the Darkspear chieftain turns Rexxar, Rokhan and Chen into spirit wyverns",`
Replace with:
`role = "Quest giver and advisor (Witch Doctor); the Darkspear chieftain turns Rexxar, Rokhan and Chen into spirit wyverns",`
Why: in the TFT bonus campaign Vol'jin is a Witch Doctor unit. Wiki To_Tame_a_Land_(WC3_Orc) transcript uses the Witch Doctor icon for every Vol'jin line (`[[File:BTNWitchDoctor.png|18px]] '''Vol'jin:'''`), and the Vol'jin infobox reads "{{WC3FT-inline}} [[Witch doctor]]". The "spirit wyverns" fix is correct (wiki: "turning the three into spirit wyverns"); only the class change was wrong. The Judgment appearance ("become a shadow hunter") is correct and stays.

### 3. [4949] Thrall, Eternity's End appearance: missing The Last Guardian, and role wording differs from Jaina's entry
Current:
```
missions = { "Twilight of the Gods" },
role = "Allied hero (Far Seer) who fortifies the Horde base on Mount Hyjal against Archimonde's army",
```
Replace with:
```
missions = { "The Last Guardian", "Twilight of the Gods" },
role = "Allied commander (Far Seer): arrives with Jaina in The Last Guardian to hear the Prophet's warning, then fortifies the Horde base on Mount Hyjal against Archimonde's army in Twilight of the Gods",
```
Why: [4968] Jaina lists The Last Guardian "arrives with Thrall"; the wiki page has Thrall in it (`''Thrall and Jaina arrive in the glade.''` / `Thrall: I am Thrall, son of Durotan, Warchief of the Horde.`, https://warcraft.wiki.gg/index.php?title=The_Last_Guardian_(WC3_Night_Elf)&action=raw). Thrall is an AI ally in Twilight of the Gods, so Jaina's "Allied commander (NPC)" is the matching wording. Also add to `sources`: `"https://warcraft.wiki.gg/wiki/The_Last_Guardian_(WC3_Night_Elf)",`.

### 4. [2543] Archmage Ansirem Runeweaver, WC3 appearance, field `role`: "six appear per game" is only true on normal
Current:
`role = "One of seven randomly named enemy archmage heroes (six appear per game) who oppose Arthas outside Dalaran while Kel'Thuzad summons Archimonde (Warcraft III: Reforged only)",`
Replace with:
`role = "One of seven randomly named enemy archmage heroes (six on normal difficulty, all seven on hard) who oppose Arthas outside Dalaran while Kel'Thuzad summons Archimonde (Warcraft III: Reforged only)",`
Why: wiki Under_the_Burning_Sky_(WC3_Undead): "Only 6 archmage heroes are active on normal difficulty, so one will be missing at each playthrough. On hard difficulty, 7 heroes are present."

### 5. [4507] Daisy, field `story` (last sentence): research/meta wording
Current:
`.. "She is a singer and a friend of Rendow, and the book also lists her as a racer and boat pilot at the Speedbarge.",`
Replace with:
`.. "She is a singer and a friend of Rendow, and she also races and pilots boats at the Speedbarge.",`
Why: "the book also lists" is how a researcher talks (banned-wording spirit: "listed"); players should get the fact, not the source. Role field already says "Racer, boat pilot and singer at the Speedbarge".

---

## NIT

### 6. Memorials `trollbane` (Thoras Trollbane), field `story` (last sentence): meta clause
Current:
`.. "In Warcraft II the orc campaign includes the mission The Fall of Stromgarde, in which the Horde destroys his kingdom's capital, though he does not appear by name.",`
Replace with:
`.. "In Warcraft II the orc campaign includes the mission The Fall of Stromgarde, in which the Horde destroys his kingdom's capital.",`
Why: mission exists (https://warcraft.wiki.gg/index.php?title=The_Fall_of_Stromgarde_(WC2_Orc)&action=raw, place Stromgarde Keep); "does not appear by name" is a research aside. The BOOK appearance already carries his actual role.

### 7. [10812] Grand Crusader Dathrohan, BOOK Tides of Darkness, field `role`: "first four" clashes with Tirion's entry
Current:
`role = "Lordaeron knight chosen by Archbishop Faol as one of the first four candidates for the Knights of the Silver Hand",`
Replace with:
`role = "Lordaeron knight chosen by Archbishop Faol, with Uther, Tirion, Turalyon and Gavinrad, as one of the first Knights of the Silver Hand",`
Why: [1855] Tirion's entry says he was chosen "with Uther, Saidan, Turalyon and Gavinrad" (five). The wiki page says "one of the first five paladins" and, for Tides of Darkness pg. 86-87, "one of the four candidates from Lordaeron", which readers will see as a contradiction. https://warcraft.wiki.gg/index.php?title=Saidan_Dathrohan&action=raw

### 8. [7800] Mekgineer Thermaplugg, BOOK Cut Short, field `role`, and [7937] Mekkatorque (story/role) : who gets cut in half
Current [7800] role: `... attacks him in a battle suit until Gelbin's trap cuts the suit in half",`; [7800] story: `... but Gelbin cuts the suit in half and leaves him for dead. `; [7937] role: `... cuts Thermaplugg's battle suit in half`.
Replace [7800] role tail with: `... attacks him in a battle suit until Gelbin's trap cuts Thermaplugg in half`
Replace [7800] story clause with: `but Gelbin's trap cuts him in half, his battle suit saves his life, and Gelbin leaves him for dead. `
Replace [7937] role tail with: `... and turns his trap so that it cuts Thermaplugg in half`
Why: wiki Gelbin_Mekkatorque, Cut Short: "which resulted in Thermaplugg being cut in half, losing his legs in the process. Thermaplug did survive, though, due to his destroyed battle suit cauterizing his wounds". https://warcraft.wiki.gg/index.php?title=Gelbin_Mekkatorque&action=raw

### 9. [3453] Wharfmaster Dizzywig, field `story` (last sentence): he does not start The Missing Shipment
Current: `.. "In World of Warcraft he runs the docks of Ratchet and gives quests such as Passage to Booty Bay and The Missing Shipment.",`
Replace with: `.. "In World of Warcraft he runs the docks of Ratchet and gives quests such as Southsea Freebooters and Passage to Booty Bay.",`
Why: wiki quest list for Dizzywig marks Southsea Freebooters and Passage to Booty Bay as `queststart`; The Missing Shipment is `questfinish` (he starts "The Missing Shipment (2)"). https://warcraft.wiki.gg/index.php?title=Wharfmaster_Dizzywig&action=raw

### 10. [10435] Magistrate Barthilas, BOOK Of Blood and Honor, field `role`: Barthilas did not "alert" Saidan
Current: `role = "Tirion Fordring's second at Mardenholde Keep: alerts Saidan Dathrohan to the orc Eitrigg, oversees Tirion's prosecution and plans Eitrigg's torture and execution",`
Replace with: `role = "Tirion Fordring's second at Mardenholde Keep: finds and captures the orc Eitrigg together with Saidan Dathrohan, oversees Tirion's prosecution and plans Eitrigg's torture and execution",`
Why: wiki Magistrate_Barthilas: "Along Saidan Dathrohan and his men, Barthilas found the orc named Eitrigg and attempted to capture him, however, Tirion tried to defend Eitrigg but was arrested for treason."

### 11. Over-long `role` clauses (readability, "one concrete clause")
- [4968] Jaina, WC3 Scourge of Lordaeron (320 chars). Replace with:
  `role = "Hero (sorceress) at Arthas's side: joins him in Jaina's Meeting, urges him to spare her people in Ravages of the Plague, follows him after the Prophet's warning, leaves him in The Culling and tells Uther in Divergent Courses that he has sailed for Northrend",`
- [15990] Kel'Thuzad, WC3 Scourge of Lordaeron (274 chars). Replace with:
  `role = "Necromancer behind the plague: flees the cultists' camp in Ravages of the Plague, then in Andorhal points Arthas and Jaina to Mal'Ganis in Stratholme before he is hunted down and killed",`
Why: the originals chain five or six clauses; both versions keep every checked fact (Jaina's Meeting/Divergent Courses/Prince and the Prophet pages verified). Note the first replacement drops the quoted "Jaina must survive" objective, which was a game-text quote rather than a role.

---

## Not issues (checked, left alone)
- [10162]/[11583]/[10184]/[1749]: all say Deathwing orders Onyxia and Nefarian in Beyond the Dark Portal ch. 8; Visage Day wording matches between Onyxia and Prestor. Rend, Nefarian, Nefarius state the same takeover of the Blackhand brothers (wiki Dal'rend_Blackhand ch. 8).
- [10813] Balnazzar "execution was faked" matches wiki; [2425] Varimathras garrison/guard sentence matches City of the Dead footnote.
- Timeline: all Cataclysm-or-later plot (Anduin, Shaw, Tick, Falstad, Moira, Drek'Thar's Shattering visions, Tyrande/Baine/Shandris Stormrage and Wolfheart) is confined to BOOK appearances or "In the novel ..." sentences; WoW-state sentences are Classic-era. "Northern Barrens" is gone from player text.
- New raid/dungeon entries (Kel'Thuzad, Sapphiron, Zeliek, Rajaxx, Rend, Nefarius, Nefarian, Onyxia, Moira, Ras, Rivendare, Balnazzar, Dathrohan, Barthilas) all end with a Classic "In World of Warcraft he/she ..." sentence placing the NPC in the dungeon. Only Nefarius [10162] says where the guise is found only generically ("known as the Lord of Blackrock"), which is acceptable.

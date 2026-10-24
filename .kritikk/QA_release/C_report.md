# QA release report, group C (24 entries), 2026-10-24

Method: Wowhead Classic page for every ID (title, `g_mapperData`, no removed/unused flag found), raw wikitext for every NPC page, book page (`==Characters==` column = Major/Supporting/Minor/Mentioned), campaign and mission page. Helper scripts and cached pages are in `C_tmp/`.
`C_fixed.lua` passes `tests/validate_db.py` (only "related ID not in the database" errors, because only 12 entries are in the test file).

All 24 IDs: name matches Wowhead exactly, zone matches, coords are within 0.2 of a `g_mapperData` point (Naralex 3679 and Charlga 4421 are dungeon bosses with no map coords, which is correct). All IDs are below 200000. `related` IDs checked: 3057 Cairne, 4968 Jaina, 10182 Rexxar, 5769 Hamuul, 3516 Fandral, 2993 Baine are all correct.

## Verdicts

### 4949 Thrall: FIX
- Trap checked: Thrall is NOT in "The Hunter of Shadows" (chapter 5) and the entry correctly does not list it. https://warcraft.wiki.gg/wiki/Invasion_of_Kalimdor: "Thrall ... All chapters except 4-5" (4 = The Spirits of Ashenvale, 5 = The Hunter of Shadows). Existing six missions are correct.
- Missing appearances (FIX): he speaks and commands in "Old Hatreds" and "A Blaze of Glory" (Founding of Durotar, `commanders1=Thrall`), and is an allied hero in "Twilight of the Gods" (Eternity's End (Night Elf); campaign page "Thrall (Orc Far seer)" under major ally heroes, mission page: "Thrall fortifies the Horde base"). Added.
- Missing books (FIX): Thrall: Twilight of the Aspects (Major), War Crimes (Major; Thrall page: "Thrall suggested Baine should be Garrosh's defender"; called as Tyrande's witness). Added.
- Story verified (named after father, `Rise of the Horde` quote; Valley of Wisdom per Thrall page).

### 3230 Nazgrel: PASS
- To Tame a Land: "Nazgrel ... captain of the warchief's security force ... harpies ... ransacking our supply caravans". Cycle of Hatred is Minor on the book page, role matches the wiki text. Story matches the Nazgrel page.
- NIT (not changed): Reforged trivia says Nazgrel and Gar'thok stand in the orc base in "Twilight of the Gods"; a passive unit, not added.

### 10540 Vol'jin: FIX
- Role "(Witch Doctor)" and "invisible wyverns" are wrong. Founding of Durotar page lists "Vol'jin (Shadow Hunter)"; mission/Vol'jin page: "turning the three into spirit wyverns". Fixed.
- Missing: "The Judgment" (short story by Brian Kindregan, character table: Major). https://warcraft.wiki.gg/wiki/The_Judgment. Added.
- Tides of War (Major), Shadows of the Horde (Major), War Crimes (Major) roles verified against the Vol'jin page.

### 3139 Gar'Thok: PASS
- To Tame a Land: "meet with my lieutenant, Gar'thok ... observatory nearby". Story matches https://warcraft.wiki.gg/wiki/Gar%27Thok. "Commander of Razor Hill" is a later title, not used.

### 3391 Gazlowe: FIX (missing appearance)
- Missing: Traveler: The Spiral Path (Greg Weisman, Scholastic, WoW novel). Book page: "Gazlowe - a goblin engineer who helps the travelers enter Gadgetzan and leave aboard the Cloudkicker"; chapter 25: "Aram offers to pilot in the race, and Gazlowe accepts ...". Added.
- Item 5080 "Gazlowe's Ledger": Wowhead item page exists, tied to Gazlowe and "The Missing Shipment". OK.

### 10181 Lady Sylvanas Windrunner: FIX (missing appearances)
- Path of the Damned: she also commands the defense in "Into the Realm Eternal" (`commanders2=Sylvanas`, "I am Sylvanas Windrunner, Ranger-General of Silvermoon") and "Key of the Three Moons" (`commanders2`, "Fall back to the trees!"). Added to the first appearance.
- Legacy of the Damned interludes: "A Kingdom Divided" (secret meeting with the dreadlords) and "Sylvanas' Farewell" (poisoned arrow at Arthas), both listed as interludes of the campaign. Added as a second TFT appearance.
- Forsaken Kingdom: "A Scarlet Flame" ("Report to Sylvanas", "convince Lady Sylvanas to commit to the siege"). Added.
- Books: World of Warcraft: Sylvanas (Major) and War Crimes (Major; Vol'jin text: "Sylvanas offered to serve as his defender ... Vol'jin declined ... better as an accuser"). Added.
- Existing roles verified (Arthas pg. 217-224, Stormrage dream, Tides of War, In the Shadow of the Sun = short story, Sunfury Spire; Before the Storm Main).

### 2425 Varimathras: FIX
- Missing "The Dark Lady": enemy hero ("Varimathras defects to Sylvanas", "spare my life"). Added as its own appearance. Missing "A Scarlet Flame" for FK ("Return to Varimathras"). Added.
- Stormrage role was wrong: the Varimathras page attaches "Battle for the Undercity ... defeated by Sylvanas" to Stormrage ch. 18, but the Sylvanas page says "Sylvanas dreamt ... Varimathras betrayed her once again in her dream" and the Varimathras trivia says "In Stormrage, Varimathras and Arthas act as Sylvanas' torturers in her nightmare". Role rewritten to the dream. (Battle for the Undercity is a Wrath event.)
- Story: "he formed the city guard" -> source says he "tasked Garek Bandarion and Dark Ranger Anya with putting together a city guard, which would later form the basis of the Deathguard" (City of the Dead). Reworded.
- Book table check: he is not in Before the Storm's relevant tables as an actor (Mentioned only), so no addition.

### 2227 Sharlindra: FIX (minor)
- Story sentence "After the Forsaken took Lordaeron, she stayed at Sylvanas' side" has no source. Replaced with the sourced "accompanied Sylvanas and her forces to attack Detheroc's stronghold" (Dreadlord's Fall, Reforged note: "Sharlindra continues to appear in this mission as a playable unit"). Mission/book roles verified (WoW: Sylvanas ch. 14, Stormrage ch. 18).

### 5734 Apothecary Keever: PASS
- City of the Dead optional quest "From Many, One" ("Keever needs parts to assemble a new abomination"), Arthas pg. 200. Story verified word for word on the Keever page.

### 3679 Naralex: PASS
- Stormrage (Minor). All claims in role and story match https://warcraft.wiki.gg/wiki/Naralex (ch. 2, Fandral, Hamuul, Shandris, Malfurion). Cataclysm "Overgrowth" content is not used.

### 4421 Charlga Razorflank: PASS (NIT)
- Wowhead 4421 = Razorfen Kraul boss. Book page lists her as "Razorfen's leader, whose orders govern the quilboar's response" and the Charlga page cites pg. 178 for "shaped most of the thorn dome ... trained Chugara". Thin ("Mentioned" in the role text), but the only book tie and it carries a concrete fact. Left unchanged. Note the sources list the modern Charlga page; the Classic boss page is `Charlga_Razorflank_(Classic)` (same character per the "For" hatnotes).

### 2055 Master Apothecary Faranell: PASS (NIT)
- Arthas: "Faranell showed a New Plague's effect as two prisoners ... drank it", Sylvanas "pleased ... warned that the blight should never fall into the wrong hands". WoW: Sylvanas ch. 20 / pg. 260 only says he was Putress' subordinate; the role is weak but concrete. Left.

### 4488 Parqual Fintallas: PASS
- Before the Storm Supporting; chapters 12, 19, 22, 29, 32, 34 on the Parqual page match role and story.

### 3144 Eitrigg: PASS
- Of Blood and Honor (Major), Tides of War (Minor, "Eitrigg was against the plan and even Baine supported him"), Shattering (Supporting), War Crimes (Supporting, "Baine suggested him to be Garrosh's defender, but Eitrigg declined"), Heartlands (Supporting). Story verified; "Valley of Wisdom/throne room" wording is Classic-safe.

### 14720 High Overlord Saurfang: FIX
- Timeline slip: story ended "In World of Warcraft he is High Overlord of the Horde". The Varok page sources that title to "Old Soldier (quest)" (Battle for Azeroth). Classic state: "High Overlord of the Kor'kron Guard" and "Supreme Commander of the Might of Kalimdor" during the Ahn'Qiraj War. Rewritten.
- Missing books: A Good War (Major) and War Crimes (Supporting, "called upon by Tyrande as the third witness"). Added.

### 3355 Saru Steelfury: PASS
- A Good War (Minor); the A Good War paragraph on the Saru page matches role and story. A Good War is a novella, BOOK is correct. BfA events are labelled as plot.

### 3329 Kor'jus: FIX (missing appearance)
- Missing War Crimes: Kor'jus page "called as the second witness to Garrosh's trial ... the court witnessed Malkorok's attack"; War Crimes lists him under Minor. Added with a story sentence.

### 6928 Innkeeper Grosk: FIX
- War Crimes role "Appears in a vision" is too bare. Grosk is in the "Visions" column; Grosk page: "Grosk maintained that he knew nothing and that his departure was just a coincidence (War Crimes)". Role made concrete. Tides of War role verified.

### 3205 Zalazane: BLOCKER (wrong source for the claim)
- Role/story say the Vol'jin youth is "shown in the novel's account" of Vol'jin: Shadows of the Horde. The Shadows character table has Zalazane only under Mentioned (https://warcraft.wiki.gg/wiki/Vol%27jin:_Shadows_of_the_Horde). The childhood and the First Home trials are in the short story "The Judgment" (Zalazane = Major). Replaced the BOOK entry, reworded the story, source list updated. Whole entry rewritten in `C_fixed.lua`.

### 4047 Zor Lonetree: PASS
- Stormrage, character table "Mentioned", wiki text: "Malfurion Stormrage contacted Zor in order to get allies against the Nightmare Lord". Role states that action. Story WoW parts verified (Grommash Hold, Spirits of Stonetalon).

### 3173 Swart: PASS
- As Our Fathers Before Us is a Leaders of Azeroth short story (Supporting). Story labels the post-Cataclysm timing as plot.

### 3188 Master Gadrin: FIX (missing appearance)
- Open question from LESSONS_LEARNED answered: "The Judgment" is an official short story (Leaders of Azeroth no. 5) with Gadrin as Supporting. Added a BOOK appearance. Before the Storm ch. 12 verified (Minor).

### 3387 Jorn Skyseer: PASS
- Shattering ch. 22 (Minor). In War Crimes he is only in the "Visions" column, not added. Story verified.

### 3453 Wharfmaster Dizzywig: FIX
- Story named the quests "Southsea Freebooters" and "Mutiny, Mon!". Those are in the Cataclysm part of his wiki quest list and are not on his Wowhead Classic page. Replaced with "Passage to Booty Bay" and "The Missing Shipment" (both on Wowhead Classic npc=3453 and in the wiki's Classic-only quest list). Night of the Dragon role verified.

## Counts
- PASS: 12 (Nazgrel, Gar'Thok, Keever, Naralex, Charlga, Faranell, Parqual, Eitrigg, Saru, Zor, Swart, Jorn; Charlga and Faranell with NITs)
- FIX: 11 (Thrall, Vol'jin, Gazlowe, Sylvanas, Varimathras, Sharlindra, Saurfang, Kor'jus, Grosk, Gadrin, Dizzywig)
- BLOCKER: 1 (Zalazane, fixed in `C_fixed.lua`)
- REMOVE: 0
- Total 24 = 12 PASS + 11 FIX + 1 BLOCKER. Entries changed in `C_fixed.lua`: 12.

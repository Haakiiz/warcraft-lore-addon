# Group F verdict (critic, 2026-11-28)

Checked against the cached wiki pages (`item_lookup.py page`) and raw wiki pages fetched in this round (marked "fetched"). Blurbs checked against `veterans.json`. Output: `F_checked.lua` (47 rows: 45 worker items + 2 ADDED).

## Items in F_items.lua (45)

### Thrall (4949) and Eitrigg (3144)
- 18422 Head of Onyxia (Horde) - PASS. Head of Onyxia (Classic) page: `itemid=18423` (Alliance), `addids=18422` (Horde). Quest Victory for the Horde (id 7490) starts at the head and ends at [[Thrall]] (fetched infobox: `end = [[Thrall]]`).
- 12630 Head of Rend Blackhand - FIX (note only). Quest For The Horde! (Classic, id 4974, fetched) is started by Thrall; the infobox has no `end`, but the text says "present it to your Warchief" and "my chambers", and the head is set on a spike by Thrall's throne. Kept as a turn-in to Thrall. Note now says so.
- 19002 Head of Nefarian (Horde) - PASS under Eitrigg. Quest The Lord of Blackrock (Horde) (id 7783) ends at Eitrigg. Under Thrall it is a REJECT (see below).

### Princess Moira Bronzebeard (8929)
- 12545 Eye of Orgrimmar - FIX (blurb). Quest The Princess Saved? (id 4004) starts at Moira, ends at Thrall. Quest text is hers ("You have slain my husband"). Slot Finger, gear true. Blurb said "his son"; veterans.json says "her infant son".
- 12548 Magni's Will - FIX (blurb, same as above). Slot Finger.
- 12543 Songstone of Ironforge - FIX (blurb, same as above). Slot Finger.
- Princess's Surprise decision: KEEP. It is given by Moira (start) and about her (her child, her declaration). It ends at King Magni, which does not change the rule (rule 4 needs given or ended by the NPC AND about them).

### Athrikus Narassin (3660)
- 5839 Journal Page - PASS. "Journal Page dropped from Athrikus Narassin in Darkshore."
- 282406 Azsharan Key - PASS. WoW Forever only, which the brief allows. Found on his corpse.
- 5383 Athrikus Narassin's Head is already in the database: no duplicate added.

### Master Gadrin (3188)
- 4864 Minshina's Skull - PASS. Objective of Minshina's Skull (quest id 808), which Gadrin starts and ends.
- 4945 Faintly Glowing Skull - FIX (note). The item is the quest REWARD of Minshina's Skull (quest id 808, start Gadrin, fetched item page "is a quest reward from"). The worker's note "Starts the quest" was wrong. Kept as a reward from his own quest.
- 9323 Gadrin's Parchment - PASS. Provided by Gadrin for Summoning Shadra (start Gadrin).

### Riggle Bassbait (15077)
- 19807 Speckled Tastyfish - PASS. Turn-in to Riggle (Grand Prize, start Riggle).
- 19970 Arcanite Fishing Pole (Classic) - PASS. Grand Prize reward. Slot Two-Hand, gear true.
- 19971 High Test Eternium Fishing Line (Classic) - PASS. Grand Prize reward, gear false.
- 19979 Hook of the Master Angler (Classic) - PASS. Grand Prize reward. Slot Trinket, gear true.
- Grand Prize's other rewards (Dread Pirate Ring, Boots of the Bay) are Wrath/Mists items, excluded.

### Bink (5144)
- 7226 Mage-Tastic Gizmonitor - PASS. Brought to Bink; the quest starts with her (start = Bink).

### High Tinker Mekkatorque (7937)
- 9623 Civinad Robes, 9625 Dual Reinforced Leggings, 9624 Triprunner Dungarees - PASS. Rewards of The Grand Betrayal (start Mekkatorque, id 2929), which is about his betrayal by Thermaplugg. Gear true.

### Magatha Grimtotem (4046)
- 10678 Magatha's Note - PASS. Magatha's Payment to Jediga starts with her; the item is handed to you.
- 12785 Incendia Powder - PASS. Provided by Magatha for Arikara (start Magatha).

### Baron Rivendare (10440): 24 items
Verified on the wiki Classic page "Baron Rivendare (Classic)" (fetched and cached). Its `Loot` box lists the 14 Classic named items, the Head, and the 9 Dungeon Set 1 pieces. Each item's page says "In Classic, it drops from Baron Rivendare" (or, for Dungeon Set 1, "drops from Baron Rivendare in Stratholme"). Every ID below is the Classic ID (first `itemid` on the page); the 228xxx/226xxx IDs are SoD and are not used. The Lord Aurius Rivendare text on the pages is the retail boss and does not apply to Classic.
- 13335 Deathcharger's Reins - PASS for the drop. Classic ID 13335. Mount (rule 5).
- 13505 Runeblade of Baron Rivendare - FIX (blurb). Classic ID 13505. Drops from Rivendare in Classic.
- 13251 Head of Baron Rivendare - FIX (blurb). Drops from Rivendare (page), objective of Above and Beyond.
- 13368 Bonescraper, 13340 Cape of the Black Baron, 13344 Dracorian Gauntlets, 22411 Helm of the Executioner, 22410 Gauntlets of Deftness, 22408 Ritssyn's Wand of Bad Mojo, 13346 Robes of the Exalted, 13349 Scepter of the Unholy, 13345 Seal of Rivendare, 13361 Skullforge Reaver, 22412 Thuzadin Mantle, 22409 Tunic of the Crescent Moon - all FIX (blurb). Each page: "In Classic, it drops from Baron Rivendare instead" (fetched). Classic IDs verified.
- 16678 Beaststalker's Pants, 16694 Devout Skirt, 16699 Dreadmist Leggings, 16668 Kilt of Elements, 16732 Legplates of Valor, 16728 Lightforge Legplates, 16687 Magister's Leggings, 16709 Shadowcraft Pants, 16719 Wildheart Kilt - all FIX (blurb). Each page: "drops from Baron Rivendare in Stratholme" (Dungeon Set 1, fetched). Classic IDs verified.
- Blurb FIX for all 24: the phrase "for the Lich King" is not in veterans.json for Rivendare. New blurb: "The death knight who ruled the burning remains of Stratholme after joining the Cult of the Damned." (veterans.json: joined the Cult of the Damned, raised as a death knight, given control of the burning remains of Stratholme.)
- Verified: all 24 items are in the loot table of Rivendare himself. None comes from trash or other Stratholme bosses.
- Corruptor's Scourgestone (206375) is NOT added: see REJECT below.

### Varimathras (2425)
No kept items in the worker file. Two were missed, now ADDED (see below).

### Lariia (4092), Tigor Skychaser (3031)
- Tigor Skychaser: NPC page has no Loot or Quests section. "none found" stands.
- Lariia: NPC page lists Crown of the Earth (7) (questfinish) and (8) (queststart). Neither page is cached, and the raw fetch returned empty. Not verified. "none found" stands, with this open item.

### Other "none kept" veterans
Not re-checked in full. Spot-checked the quest pages behind the rejects (see below). Renzik, Apothecary Lydon, Varok Saurfang, Grunt Maug, Beram Skychaser, Huntress Swiftriver, Sharlindra, Fandral, Gordo, Tharg, Torq, Innkeeper Farley, Laurena, Malfurion, Daisy: rejects as in the worker report, no contrary evidence found in the spot checks.

## ADDED (2)

- 17008 Small Scroll - ADDED under Varimathras (2425). The quest An Unholy Alliance (Classic, id 6522) starts with the scroll and its objective is "Take the Small Scroll to Varimathras in the Undercity" (end = Varimathras). Turn-in to him (rule 3). Note: the scroll drops from Charlga Razorflank.
- 17009 Ambassador Malcin's Head - ADDED under Varimathras (2425). Objective of An Unholy Alliance (Classic 2, id 6521, start Varimathras): "Bring Ambassador Malcin's Head to Varimathras in the Undercity." Turn-in (rule 3). Malcin is not a veteran, but the rule is about the turn-in, as with the Onyxia head to Thrall.

## REJECT (decisions and corrections)

- Head of Nefarian (Horde) 19002 under **Thrall**: REJECT. Quest ends at Eitrigg (The Lord of Blackrock (Horde), end = Eitrigg, fetched).
- Corruptor's Scourgestone 206375 (Rivendare's Classic loot box lists it): REJECT. It is one of several Scourge-boss drops in Classic (Western/Eastern Plaguelands, Scholomance, Stratholme). The item page has only the ID 206375, which is a retail-era ID. Generic, not his own. See open questions.
- Varimathras rejects: the worker's start/end data for several quests was wrong. Corrected facts (all fetched or cached):
  - The Power to Destroy... (Classic, id 5725): **start Varimathras** (not Bragor). Generic rewards (Ghastly Trousers, Dredgemire Leggings, Gargoyle Leggings) on a quest about Sylvanas's spell books. REJECT stands.
  - Into The Scarlet Monastery (Classic, id 1048): **start Varimathras**. Generic rewards (Sword of Omen, Prophetic Cane, Dragon's Blood Necklace). REJECT stands.
  - An Unholy Alliance (Classic 2, id 6521): **start Varimathras**. Rewards Skullbreaker, Nail Spitter, Zealot's Robe (generic). REJECT stands for the rewards.
  - Battle of Hillsbrad (Classic, id 550): **end Varimathras** (start Darthalia). Generic rewards, and the quest is a commendation. REJECT stands.
  - The Deathstalkers (Classic, id 1978): **end Varimathras** (start Mennet Carkad). Generic rewards (Blade of Cunning, Andron's Ledger). REJECT stands.
  - The Crimson Courier (id 6145): start Varimathras, end Nathanos. No item of his.
  - Head of Balnazzar 13250: quest ends at Zverenhoff. REJECT stands.
- Letter Sealed by Sylvanas, Lydon's Toxin, Gyromatic Micro-Adjustor, war-effort supplies, Arcane Staff / Arcane Orb, Brute Hammer / Clink Shield / Stingshot Wand, Ethereal Talisman: REJECT stands.
- Ambassador Malcin's Head and Small Scroll, see ADDED.

## Spot-checks of worker rejects

- Gadrin: Shadra's Venom (9324): Summoning Shadra ends at Lydon, not Gadrin. REJECT stands.
- Mekkatorque: Gyromatic Micro-Adjustor (10498): REJECT stands.
- Malfurion: Nightmare Engulfed Object (20644): REJECT stands (see open questions).

## Open questions, decided

1. Nightmare Engulfed Object (20644, Malfurion): REJECT. It drops from the Dragons of Nightmare, the quest ends at Remulos, and Malfurion only appears in a vision. Not his own, not his loot.
2. Head of Rend Blackhand (12630): KEEP. Quest For The Horde! (Classic) is started by Thrall and the text says to present the head to the Warchief. Infobox has no `end`, but the head ends with Thrall.
3. Princess's Surprise (Magni's Will 12548, Songstone 12543): KEEP. The quest is given by Moira and is about her (her child, her declaration). It ends at King Magni. Rule 4 is met.
4. Generic uncommon rewards: REJECT stays (Arcane Staff / Orb, Brute Hammer, Clink Shield, Stingshot Wand, Ethereal Talisman). They are quest rewards from quests that are not about the NPC.
5. Azsharan Key (282406, WoW Forever only): KEEP. The brief allows WoW Forever items.
6. Letter Sealed by Sylvanas (23930): REJECT. Sylvanas's letter.
7. War-effort turn-ins (Grunt Maug, Huntress Swiftriver): REJECT. Generic supplies.
8. Gyromatic Micro-Adjustor (10498): REJECT. Generic tool.
9. Lydon's Toxin (5588): REJECT. Reagent.
10. Varimathras: two turn-ins ADDED (Small Scroll, Ambassador Malcin's Head). The other rejects stand.
11. Head of Nefarian (19002): KEEP under Eitrigg. Not under Thrall.

## Counts

- Worker items checked: 45. PASS 16, FIX 29, REJECT 0 (in the worker list).
- ADDED: 2 (Small Scroll 17008, Ambassador Malcin's Head 17009).
- Total in F_checked.lua: 47 rows. Max blurb length 118 characters.
- Thrall extra: 18422 PASS, 12630 KEEP (FIX note), 19002 REJECT under Thrall.
- Athrikus extra: 5383 already in the database, no duplicate.
- Rivendare extra: 24 items verified as drops from Rivendare, Classic IDs. Corruptor's Scourgestone REJECTED.
- Moira extra: Princess's Surprise KEEP.

## Not verified

- Lariia's Crown of the Earth (7) and (8) quest pages: not retrievable (raw fetch empty).
- The rest of the "none kept" veterans (Renzik, Lydon, Varok, etc.) were not re-checked in full. The worker's reject tables for them were only spot-checked.

# Group E verdict (critic, 2026-11-28)

Checked: `E_items.lua` (50 items, 16 veterans) and `E_report.md`. Output: `E_checked.lua` (47 items).
Sources: wiki pages in `_cache_pages.json` and fresh fetches (Jaina's Autograph, Rokaro's Letter, Head of Balnazzar, Whitemane's Chapeau, Ukorz and Eranikus loot items, Hand of Righteousness, Triune Amulet, Totem, Admiral's Orders, Rudolph Gelhardt). Blurbs checked against `veterans.json`.

## One line per item

### [4968] Lady Jaina Proudmoore
- 18642 Jaina's Autograph: PASS. Hand-out from Jaina for Children's Week (item page, Classic, added 1.4.0, removed 4.1.0).
- 6757 Jaina's Signet Ring: PASS. Item page: "This is Lady Jaina Proudmoore's ring" (own item). Quest reward from The Missing Diplomat (17), which Jaina starts and ends.
- 6075 Vimes' Report: PASS. Turn-in: quest Vimes's Report ends with Jaina and the report is its objective.

### [3936] Shandris Feathermoon
- 11856 Ceremonial Elven Blade: REJECT. Quest reward from A Hero's Welcome (Classic). Started by Ginro Hearthkindle and about the player's welcome; Shandris only debriefs. Fails the "about the veteran" rule.
- 11857 Sanctimonial Rod: REJECT. Same quest, same reason.

### [2055] Master Apothecary Faranell
- 9436 Faranell's Parcel: PASS. Turn-in: provided by Apothecary Lydon, delivered to Faranell for Venom to the Undercity (ends with Faranell).

### [10182] Rexxar
- 16785 Rokaro's Letter: PASS. The letter is Rexxar's testament (wiki: renamed from "Rexxar's Testament" in 2.0.1). Mistress of Deception starts with Rexxar in Classic (`Wow-inline`). Name note: see open questions.

### [10813] Balnazzar
All 14 Classic loot-box items match the wiki's Balnazzar (Classic) loot list. The blurb was changed for all 14: the story text in `veterans.json` says "dreadlord", not "nathrezim".
- 13348 Demonshear: FIX (blurb only).
- 13359 Crown of Tyranny: FIX (blurb only).
- 13353 Book of the Dead: FIX (blurb only).
- 13360 Gift of the Elven Magi: FIX (blurb only).
- 18718 Grand Crusader's Helm: FIX (blurb only).
- 18717 Hammer of the Grand Crusader: FIX (blurb only).
- 18720 Shroud of the Nathrezim: FIX (blurb only).
- 12103 Star of Mystaria: FIX (blurb only). Classic drop confirmed by the Balnazzar (Classic) loot list and its page ("In Classic, it drops from Balnazzar").
- 13358 Wyrmtongue Shoulders: FIX (blurb only).
- 13369 Fire Striders: FIX (blurb only).
- 16725 Lightforge Boots: FIX (blurb only).
- 14512 Pattern: Truefaith Vestments: FIX (blurb only).
- 13520 Recipe: Flask of Distilled Wisdom: FIX (blurb only). Page confirms the non-soulbound copy drops from Balnazzar.
- 13250 Head of Balnazzar: FIX (note). Drop confirmed (Classic loot list). The note now reads "starts the quest The Truth Comes Crashing Down"; the old "delivers it to Zverenhoff" wording is not on the item page.

### [1156] Vyrin Swiftwind
- 2713 Ol' Sooty's Head: PASS. Dropped by Ol' Sooty (page) and provided for Vyrin's Revenge (2), which ends with Vyrin.

### [3977] High Inquisitor Whitemane
Loot box on the Classic page lists exactly these three. Classic IDs used (7720, 7721, 7722); SoD copies 217300/217301 not used.
- 7720 Whitemane's Chapeau: PASS.
- 7721 Hand of Righteousness: PASS.
- 7722 Triune Amulet: PASS.

### [2543] Archmage Ansirem Runeweaver
- 3960 Bag of Water Elemental Bracers: PASS. Turn-in: provided for Magical Analysis, which ends with Ansirem (Classic).

### [3520] Ol' Emma
- 12724 Janice's Parcel: PASS. Turn-in: provided in Good Natured Emma, which ends with Ol' Emma.

### [2707] Shadra
- 9324 Shadra's Venom: PASS. Drops from Shadra for Summoning Shadra (Classic), per the item page.

### [2918] Advisor Belgrum
- 4622 Sealed Note to Advisor Belgrum: PASS. Turn-in: provided for Passing Word of a Threat, which ends with Belgrum.
- 4621 Ambassador Infernus' Bracer: PASS. Turn-in: An Ambassador of Evil ends with Belgrum.
- 5824 Tablet of Will: PASS. Turn-in: The Lost Tablets of Will starts with Belgrum and returns the tablet to him.

### [14394] Major Mattingly
- 18403 Dragonslayer's Signet: REJECT. Quest reward from Celebrating Good Times. Mattingly only hosts the celebration; the quest is about the Onyxia victory, not him (strict rule 4). See open questions.
- 18404 Onyxia Tooth Pendant: REJECT. Same quest, same reason.
- 18406 Onyxia Blood Talisman: REJECT. Same quest, same reason.

### [482] Elling Trias
- 5946 Sealed Note to Elling: PASS. Provided for The Missing Diplomat (3), which ends with Elling.
- 5947 Defias Docket: PASS. Turn-in: The Missing Diplomat (6) ends with Elling.
- 5960 Sealed Note to Watcher Backus: PASS. Quest item Elling hands out in The Missing Diplomat (4), which he starts.

### [4488] Parqual Fintallas
- 5861 Beginnings of the Undead Threat: PASS. Turn-in: Test of Lore (5) returns it to Parqual (Classic, removed 5.0.4).

### [7267] Chief Ukorz Sandscalp
Loot box on the Classic page lists the five items below.
- 9477 The Chief's Enforcer: PASS.
- 11086 Jang'thraze the Protector: PASS.
- 9478 Ripsaw: PASS.
- 9479 Embrace of the Lycan: PASS.
- 9476 Big Bad Pauldrons: PASS.

### [5709] Shade of Eranikus
Loot box on the Classic page lists the seven items below; all have Classic blocks.
- 10828 Dire Nail: PASS.
- 10847 Dragon's Call: PASS.
- 10837 Tooth of Eranikus: PASS.
- 10836 Rod of Corrosion: PASS.
- 10835 Crest of Supremacy: PASS.
- 10833 Horns of Eranikus: PASS.
- 10829 The Dragon's Eye: PASS.

### ADDED (missed by the worker)
- 4783 Totem of Hawkwind, [2993] Baine Bloodhoof: ADDED. Turn-in. Rites of the Earthmother (2) starts with Chief Hawkwind and ends with Baine. Objective: "Take the Totem of Hawkwind to Baine Bloodhoof" (Classic, removed 4.0.3a). The worker rejected it as "quest reward, not Baine", which is wrong. Candidates for Baine were empty, so the mechanical search missed it.
- 4883 Admiral Proudmoore's Orders, [10540] Vol'jin: ADDED. Turn-in. The Admiral's Orders (2) starts with Gar'Thok and ends with Vol'jin ("Deliver Admiral Proudmoore's Orders to Vol'jin in Orgrimmar", Classic). The worker's reject was wrong for the same reason. Candidates for Vol'jin were empty.

## Counts
- Worker kept items: 50. PASS 31, FIX 14, REJECT 5 (Shandris 2, Mattingly 3).
- ADDED 2 (Totem of Hawkwind, Admiral Proudmoore's Orders).
- Final `E_checked.lua`: 47 items (31 PASS + 14 FIX + 2 ADDED). All blurbs at most 120 characters.

## Brief checks
- Jaina's Autograph 18642: confirmed KEEP (Classic, hand-out by Jaina, Children's Week).
- Rokaro's Letter 16785 (Rexxar): confirmed KEEP (letter of Rexxar's testament; quest starts with Rexxar in Classic).
- Head of Balnazzar 13250: confirmed KEEP (on Balnazzar (Classic) loot list, Classic ID).
- Whitemane's Chapeau 7720: confirmed KEEP (Classic ID 7720; SoD 217300 not used).
- Boss drops on their own loot tables, Classic IDs: Balnazzar 14/14, Whitemane 3/3, Ukorz 5/5, Eranikus 7/7. All verified against the Classic loot boxes.
- Ukorz's Farraki Ceremonial Robes 151460 and Ukorz's Chain Leggings 151461: not Classic (added 7.3.5). REJECT. Both are on the Classic loot box, but the IDs are retail-only.
- Sylvanas, The Lady's Necklace 22597: REJECT. Journey to Undercity was added in 2.0.3 (Burning Crusade).
- Sylvanas, missed turn-ins: none valid in Classic. Checked every quest ending with her:
  - Wisdom of the Banshee Queen (Scourgestone Fragments 30700): added 2.0.3, REJECT.
  - Envoy to the Horde (Letter from Lor'themar Theron): added 2.0.3, REJECT.
  - Andorhal, Once and For All: added 4.0.3a, no item, REJECT.
  - Dark Lady, Watch Over Us, All to Ash, A Royal Audience: retail/Cata, no Classic item, REJECT.
  - A Token of Good Faith (Forever-only quest 95803): turns in Rudolph Gelhardt's Head to Sylvanas. No item page or ID on the wiki, so NOT ADDED (see open questions).
- Quest rewards: strict application. Kept only Jaina's Signet Ring, because the item page calls it Jaina's own ring (rule 1). Rejected Shandris, Mattingly, Faranell's Venom rewards, Vyrin's Revenge (2) rewards.
- Blurb facts: all checked against `veterans.json`. Only the Balnazzar "nathrezim" wording was not in the source (now "dreadlord").

## Spot checks (rejects and "none found")
- Crystal of Zin-Malor 13347 (Aurora): REJECT confirmed. The wiki says Aurora helped recreate it; no page says she hands it out.
- Peeling the Onion 19483 (Drek'Thar): REJECT confirmed. Quest reward from Proving Grounds (Alterac Valley), sold by Frostwolf Supply Officers. Drek'Thar wrote it, but that is not a drop, turn-in or hand-out.
- Farraki Ceremonial Robes 151460 / Ukorz's Chain Leggings 151461: REJECT confirmed (retail).
- "None found" NPC pages: Dink (quests Report to Jennea, Magecraft, no items), Narm Skychaser (quests Call of Fire (Horde), Call of Water, no items), Lexington Mortaim (no quests on the page, BfA section only). Confirmed.

## Open questions (decisions)
1. Rexxar, Onyxia attunement: Blood of the Black Dragon Champion 16663 and Drakefire Amulet 16309. DECISION: REJECT. The Blood drops from General Drakkisath, not Rexxar. Rexxar was the Classic quest giver (the 2.0.1 note), but the quest is about Drakkisath and Blackrock Spire, not Rexxar. Fails strict rule 4.
2. Quest rewards that end at the veteran (Shandris, Mattingly): DECISION: REJECT (strict). A Hero's Welcome is about the player's welcome, and Celebrating Good Times is about the Onyxia victory. Neither is about the veteran.
3. Faranell, Venom to the Undercity rewards 9649, 9650, 10686: DECISION: REJECT. The quest is about the venom parcel, which Faranell only receives. Parcel 9436 stays as the turn-in.
4. Jaina, Vimes' Report 6075: DECISION: KEEP as turn-in (rule 3). The quest ends with Jaina and the report is its objective.
5. Aurora, Crystal of Zin-Malor 13347: DECISION: REJECT (see spot checks).
6. Vyrin's Revenge (2) rewards (Swiftwind Blade 59010, Vyrin's Belt 59009, Unsanitary Gloves 59008, Vyrin's Waistband 131633): DECISION: REJECT. The wiki says Classic rewards were Hunting Ammo Sack and Hunting Quiver (changed 4.0.3a); the listed items came in 7.0.3 or later.
7. Ukorz, Farraki Ceremonial Robes 151460 and Ukorz's Chain Leggings 151461: DECISION: REJECT (retail-only, added 7.3.5).
8. Drek'Thar, Peeling the Onion 19483: DECISION: REJECT (see spot checks).
9. Balnazzar, Star of Mystaria 12103: DECISION: KEEP. It is on the Balnazzar (Classic) loot list; the Hearthsinger Forresten drop is post-Classic.
10. Whitemane and other SoD copies: DECISION: Classic IDs used throughout. Nathrezim Heart 241018 is SoD-only, REJECT.
11. Faranell's Classic turn-ins that are reagents or quest drops (not in the worker's KEEP): Lake Skulker Moss 3256, Lake Creeper Moss 3257, Hardened Tumor 3258 (A Recipe For Death (3), ends with Faranell); Grizzled Bear Heart 3253, Skittering Blood 3254 (A Recipe For Death, ends with Faranell); Mudsnout Composite 3506 (Elixir of Agony (2), ends with Faranell). DECISION: REJECT under the "reagents" rule. They are alchemy reagents collected in the world, not items Faranell hands out or the veteran's own. The team may choose to keep them as turn-ins.
12. Sylvanas, A Token of Good Faith (Forever-only): Rudolph Gelhardt's Head is a turn-in to Sylvanas, but the wiki has no item page or ID for it. DECISION: NOT ADDED. Add it once the ID is confirmed on a Forever item page.
13. Rokaro's Letter name: the wiki title is "Rokaro's Letter", but the item page says it was renamed from "Rexxar's Testament" in 2.0.1, so the Classic-era in-game name may be "Rexxar's Testament". DECISION: keep "Rokaro's Letter" (matches the wiki title and ID). Check the in-game name before release.

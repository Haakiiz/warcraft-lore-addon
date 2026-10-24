# QA report, GROUP A (Stormwind City, Elwynn Forest, Redridge Mountains, Duskwood), 2026-10-24

Method: every NPC ID fetched from Wowhead Classic (UA Mozilla/5.0): title name, zone and `g_mapperData` coords
checked for all 24; all wiki pages fetched as raw wikitext (warcraft.wiki.gg `action=raw`), including the book pages'
`==Characters==` tables. Result for IDs/coords: **all 24 IDs exist, names match exactly, zones match, every coord is
within 0.2 of a g_mapperData point, all IDs < 200000**. Cutford (1436) is "Removed in 4.0.3a" on the wiki but is a normal
Classic NPC on Wowhead Classic, so it stays. Marcus Jonathan and Bolvar are likewise Classic-era NPCs (fine).
Corrected entries are in `A_fixed.lua`.

## 1747 Anduin Wrynn: FIX
- Appearances present are true (Shattering ch.11 "uncle"/age 13, BtS ch.1, Blood Ties ch.2, Stormrage ch.10), but the
  roles for Shattering and Before the Storm are trivia while he is a Major character there; and clearly missing
  appearances (task 8): Wolfheart (Major: studies with Velen, declines Benedictus), Prophet's Lesson (Major, short story
  by Marc Hutcheson, Leaders of Azeroth), Blood of Our Fathers (heals Varian), Tides of War (returns after Theramore).
  Source: https://warcraft.wiki.gg/wiki/Anduin_Wrynn sections Wolfheart / Prophet's Lesson / Blood of Our Fathers / Tides of War;
  Prophet's Lesson page: "short story by Marc Hutcheson ... twelfth and last in the Leaders of Azeroth series".
- Fixed: roles for Shattering and BtS rewritten to concrete actions; four appearances added; one story sentence added.
- Identity/story/related otherwise OK.

## 332 Master Mathias Shaw: FIX
- Only Before the Storm listed. Wiki Mathias_Shaw has novel sections for: The Shattering ch.30 ("Mathias handpicked Owynn
  Graddock to accompany Varian... through Deeprun Tram"), Blood of Our Fathers, The Tipping Point (Major), Elegy
  (Supporting; "Shaw interrupted their training to report..."), Shadows Rising (captured in Dazar'alor), Terror by
  Torchlight (Major). The Characters tables of Tipping Point / Terror by Torchlight / Elegy / Blood of Our Fathers list him.
- Fixed: six appearances added, story extended (5 sentences). BtS role unchanged (correct).

## 3520 Ol' Emma: PASS
- BtS ch.28/32/34/epilogue support role and story. WoW sentence (Canal District, carries water) matches the NPC page.

## 14394 Major Mattingly: PASS
- Stormrage ch.21-22 matches ("Instead of returning to his squad... King Varian ordered him to escort Tyrande...").

## 466 General Marcus Jonathan: FIX
- Existing two appearances correct (Stormrage ch.21; Tides of War pg.219).
- Missing: Blood of Our Fathers (Supporting in the Characters table): "Marcus Jonathan ordered Field Marshal Afrasiabi to
  stall the crowds while he organized a search for the king. He and Jaina later found the king dying..."
  (https://warcraft.wiki.gg/wiki/General_Marcus_Jonathan, section Blood of Our Fathers). Added with one story sentence.

## 928 Lord Grayson Shadowbreaker: PASS
- Shattering (Minor, fetches food/drink for the night elf Sentinels) and Blood Ties ch.1 (squire Winthrop, Year 42 ADP,
  Light's Hope Chapel) both match. "Lost his right eye" is on the page.

## 1284 Archbishop Benedictus: FIX
- Role and story attribute "After Deathwing's attack many citizens seek his counsel... secretly a member of the
  Twilight's Hammer" to The Shattering. The wiki cites that to the *Chronicle* guide ({{Ref WoWCV3|200}}), not the novel.
  The Shattering only gives: "He later led a memorial service for the victims of the war against the Lich King in the
  Cathedral of Light" (chapter 6). So an invalid book claim (guide-sourced) -> FIX.
- Missing: Blood of Our Fathers (counsels Varian, gives him the key to Tiffin's locket), Thrall: Twilight of the Aspects
  (the Twilight Father, "Benedictus ... assumed his true name: the Twilight Father").
- Fixed role/story; two appearances added. (Wolfheart lists him only as Mentioned, not added.)

## 2285 Count Remington Ridgewell: PASS
- BtS ch.23: "Remington greeted Fredrik Farley ... The king asked Remington to serve them drinks". Matches.

## 7917 Brother Sarno: PASS
- Shattering ch.6: "the Stormwind Prince exchanged smiles and nods with Brother Sarno". Minor but an action; accepted.

## 1323 Osric Strang: PASS
- BtS ch.31 text matches role and story.

## 376 High Priestess Laurena: PASS
- BtS ch.1, 15, 16, 17 match. Story contains no Season of Discovery material.

## 240 Marshal Dughan: FIX
- Story sentence 2 "He is the elected ruler of Elwynn Forest" comes from *Lands of Conflict* (RPG book, pg. 48; wiki "In the
  RPG" section). RPG books are banned sources. Replaced with the WoW-section sentence ("very concerned about the kobolds to
  the north and the gnolls and thieves to the west"), keeping story at 3 sentences. Role (Stormrage ch.4) is correct.

## 328 Zaldimar Wefhellt: PASS
- Stormrage: "Zaldimar accompanied Dughan on a mission in Jasperlode Mine and betrayed him after revealing he was a necromancer."

## 295 Innkeeper Farley: PASS
- BtS ch.23 supports all of role and story. (He is also named Fredrik Farley on the NPC page.)

## 1748 Highlord Bolvar Fordragon: PASS
- We Ride Forth role matches the short story blurb. NIT only: the plot is Bolvar's gambit (feigns corruption, fights
  Sylvanas); the blurb version in the entry is still correct, so left as is. No RTS appearance in the wiki. Timeline fine.

## 6946 Renzik "The Shiv": FIX
- Tipping Point role correct. Story attributes "later leaves Undermine behind" to the short story, but the wiki cites a
  quest (Down Undermine) for that, not the story: reworded. Missing: Elegy (Supporting): "Renzik was the leader of the spies
  in Orgrimmar, and the only one out in the open, disguised as a merchant near Grommash Hold." Added.

## 344 Magistrate Solomon: PASS
- Traveler ch.12 (https://warcraft.wiki.gg/wiki/Magistrate_Solomon: "Solomon once declared Greydon Thorne dead two years after
  he left his family, so Ceya Northbrooke could marry Robb Glade"). Novel by Blizzard, OK.

## 576 Watcher Ladimore: FIX
- Identity explicit (Sarah Ladimore, "known in-game simply as Watcher Ladimore"). Story says she "succeeded Althea Ebonlocke as
  Commander", but the wiki puts that succession after the Veiled Hand events of the Legion invasion: a timeline slip when written as
  background. Reworded to "in Terror by Torchlight, by which time she had succeeded...". Role correct.

## 1436 Watcher Cutford: PASS
- Terror by Torchlight (Supporting): "assisted Mathias Shaw and Flynn Fairwind to carry Commander Ladimore back ... watched over
  the ailing commander". Role and story match.

## 1200 Morbent Fel: REMOVE
- The only appearance is "Mentioned in the short story as a deceased lich". Terror by Torchlight lists him in the
  *Mentioned* column and the wiki gives no action by him in the story (the Torch is merely placed outside his old house).
  Brief rule 8 / v4: a name in a Mentioned column with no action is rejected, leaving the entry with no valid appearance.
  If the orchestrator prefers to keep him: the Duskwood story is accurate, but the role would have to be a concrete clause, e.g.
  "Dead lich whose old house in the Forlorn Rowe is where the Torch of Holy Flame is kept, the artifact the necromancer steals",
  which is stretching the source.

## 1749 Lady Katrana Prestor: FIX
- Identity explicit (Onyxia = Lady Katrana Prestor). Beyond the Dark Portal ch.8 correct.
- Wolfheart appearance "Mentioned in the novel: Varian recalls..." is in the *Mentioned* column and she does nothing in the
  book: removed. Missing, with action: Visage Day (short story in Folk & Fairy Tales of Azeroth, official site 2022):
  "Chronormu asks for an audience with Onyxia in the Obsidian Dragonshrine ... Onyxia and her entourage attended Visage Day".
  Added (role + story sentence).

## 482 Elling Trias: FIX
- Role "master of cheese to whom Shaw sends Renzik" is the weaker of two actions; the Tipping Point Supporting role is that
  Shaw meets him in the cellar beneath Trias' Cheese to plan the protection of the informants ("Mathias went to the basement
  beneath the Trias' Cheese shop and met with Elling Trias"). Role and story sentence updated. WoW sentence verified
  (Lescovar killed "on the orders of Elling Trias"; Lescovar Incident chain: "Trias ... agrees that any justice ... will be
  by less than legal means").

## 1646 Baros Alexston: PASS
- Blood of Our Fathers (Supporting): "Baros was later put in charge of rebuilding Stormwind after Deathwing's attack, and kept
  King Varian informed of the progress and price." Story fully supported (Alexston Farmstead, Stonemasons' Guild, City Hall).

## 2708 Archmage Malin: PASS
- Elegy (Minor): "Malin was present at the Wizard's Sanctum, holding open portals ... King Anduin instructed Malin to send a message
  to Dalaran". Story matches; Arathi sentence from the NPC page.

## Counts
24 entries: **PASS 14**, **FIX 9** (1747, 332, 466, 1284, 240, 6946, 576, 1749, 482), **REMOVE 1** (1200), BLOCKER 0.
IDs, names, zones and coords: 24/24 correct, no coord fills needed.
Output: `A_fixed.lua` contains the 9 FIX entries (complete). Morbent Fel (1200) is a report-only removal.

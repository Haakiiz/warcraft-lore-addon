# RAV_B verdict (critic), Alterac Mountains

## Per entry
- 2543 Archmage Ansirem Runeweaver: FIX. Name, zone and ID confirmed, coords filled, story rewritten, one role reworded, WC3 appearance dropped (details below).

## Changes made
- **Identity:** Wowhead title "Archmage Ansirem Runeweaver - NPC"; g_mapperData zone 36 = Alterac Mountains (uiMapId 1416), 2 points at (18.8, 78.4) and (18.8, 78.6). Coords set to "18.8, 78.5". Wiki NPC page: "was a human quest giver located at Dalaran Crater in the Alterac Mountains".
- **Story (worker's version had 4 sentences; the 3rd was the muddled one):**
  - Old sentence 2 "By the time of the Third War..." removed. Its only source is the WC3 citation, which is not used.
  - Old sentence 3 "In Jaina Proudmoore: Tides of War he stayed at the crater ... until the Cataclysm" rewritten and tied to the novel. Source: "Ansirem Runeweaver remained at the site of the crater ... until the Cataclysm of the world" (ToW section), and "still served the Kirin Tor".
  - New in-game sentence from the Quests list: "In the game he offers the quest Ansirem's Key and completes Magical Analysis" (queststart / questfinish, Classic-only section). "Classic" is a banned word, so it is written as "In the game".
  - "He is a member of the Council of Six, the leaders of the Kirin Tor of Dalaran" from the NPC intro.
  - Old sentence 4 kept, changed to "novella" and "arrives near Booty Bay with other magi ... when the Bloodsail Buccaneers attack her crew" (Quest for Pandaria page: "arrived near Booty Bay to save his daughter Catelyn when she and her crew were under attack").
  - Final story: 5 sentences.
- **Roles:**
  - Quest for Pandaria: "Rushes to Booty Bay" changed to "Arrives near Booty Bay ..." to match the source wording.
  - Tides of War and In the Shadow of the Sun roles kept.
- **WC3 appearance dropped:** "Under the Burning Sky (WC3 Undead)" is Chapter 8 of the RoC Path of the Damned campaign. Ansirem appears only in the mission-failed cutscene ("an archmage and his forces killing Arthas"), and the mission page says the opening-cinematic units "are later removed when the mission begins". This is a one-time event that players cannot meet in play, so it is left out.

## Book checks (raw wiki)
- Jaina Proudmoore: Tides of War: novel by Christie Golden. Ansirem in Characters table, Minor. Title correct.
- Quest for Pandaria: four-part novella by Sarah Pine. Ansirem in Characters table, Minor. Title correct; role source is the NPC page citation.
- In the Shadow of the Sun: a short story by Sarah Pine (not a novella). Ansirem in Characters table, Mentioned. Exact title "In the Shadow of the Sun" is correct. The action line ("doing nothing when Grand Marshal Garithos locked Prince Kael'thas...") comes from the NPC page, which cites the story; the story page itself has only the Characters entry.

## REJECT spot-checks (closest to a hit)
- Warden Belamoore (2415): REJECT stands. The page is Classic-only and says "now nowhere to be seen" (removed NPC). No book or RTS Characters hit.
- Kegan Darkmar (2414): REJECT stands. The only book hit is a Forsaken article sentence ("Others that have left include Kegan Darkmar"), not a Characters entry.
- Elysa (2317) and Gol'dir (2316): REJECT stands. Book hits are only in Blackmoore and Thrall article text.

## Existing entries
- Mug'thol (2257) and Lord Aliden Perenolde (2423): no change.

## Validation
- Copy with entry merged: Data_merged_RAV_B.lua in the work dir. `python -I tests/validate_db.py <copy>` returns "OK: 131 entries, no duplicate NPC IDs, all fields valid."

## Summary
- PASS: 0. FIX: 1 (2543). REJECT: 0 for this group's entry (WC3 appearance dropped, not a new NPC).

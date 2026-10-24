# H1 verdict

validate_db.py on a temp copy of Data.lua + H1_checked.lua: OK (144 entries, no duplicate IDs, no related errors/warnings).
Coords: Wowhead classic pages load (names confirmed) but g_mapperData is empty / [0,0] for all 11 (instance NPCs), so coords = "" is correct.

- 10429 Warchief Rend Blackhand: PASS. Tides of Darkness ch 11 and Beyond the Dark Portal ch 8 are on the Dal'rend page. WC3 link correctly dropped: page says the WC3 blademasters Rend/Maim "were retconned into different characters". Only change: related kept {11583, 10162}.
- 10162 Lord Victor Nefarius: FIX. Zone changed to "Upper Blackrock Spire" + alsoIn "Blackwing Lair" (Wowhead location = 1583 only). Story rewritten so it no longer duplicates Nefarian's (dropped the Vaelastrasz sentence, added the supported "Lord of Blackrock, holds the Blackrock clan and ogre clans" line). related = {10184}.
- 11583 Nefarian: PASS. Same character as 10162 (wiki: "appearing as Victor Nefarius"); appearance Beyond the Dark Portal ch 8 is explicit. related fixed to {10162, 10184}. Night of the Dragon not used (he is only mentioned there, after Classic).
- 10184 Onyxia: PASS. Beyond the Dark Portal ch 8 + Visage Day (short story by Steve Danuser, Blizzard) both on the Onyxia page; same character as Katrana Prestor 1749 but a different NPC, stories differ (1749 = Stormwind court). related = {1749} only (1749 would need a back-link; one side is enough).
- 8929 Princess Moira Bronzebeard: FIX. Shattering (pg 227), Fire and Iron, War Crimes ch 1 and 30, Lilac and the Stone (short story, Moira POV) all verified on the Moira Thaurissan page, which also says the BRD princess is her. Changed: last story sentence "stands at the Emperor's side" (unsupported) -> "you meet her in Shadowforge City, in Blackrock Depths"; Lilac role reworded from "Main character: ..." to a concrete action.
- 10508 Ras Frostwhisper: PASS. Siege: "Defeat Ras Frostwhisper" quest, Ras page cites Siege and Vengeance for the actions. Campaign string "The Last Days of Lordaeron (Human)" is the FK prologue campaign. WC3 original not used (correct).
- 10440 Baron Rivendare: PASS. Treachery has dialogue and a boss quest, Vengeance quest "Find and defeat baron Rivendare", War of the Damned lists him as Scourge force and the Rivendare page describes the fight. related trimmed to {10508} (10439 rejected).
- 10439 Ramstein the Gorger: REJECT. Vengeance mentions him only in the "Forces" list (RaceIcon Abomination); the sole text is the NPC page sentence "was present at Stratholme". No action, no dialogue, no quest = name/unit only. (Shadows Rising: Characters table only.)
- 10813 Balnazzar: FIX. WC3 TFT campaign "Legacy of the Damned": all 4 missions checked, he speaks / commands in each: King Arthas (dialogue with Detheroc), The Flight from Lordaeron (commander, "You should never have returned, human"), A Kingdom Divided (meets Sylvanas, 4 lines), A New Power in Lordaeron (enemy commander, Varimathras kills him). "The Dark Lady" only mentions him, correctly left out. Role reworded: "tries to win Sylvanas over" -> "asks Sylvanas to join the coup" (what the mission shows). related = {2425, 10181} (10812 back-link removed, covered by 10812). Added the missing A New Power / King Arthas wiki pages to sources.
- 10812 Grand Crusader Dathrohan: FIX. Identity ok: wiki Saidan page = "mortal disguise of the dreadlord Balnazzar", Tides of Darkness pg 86-87 and Of Blood and Honor ch 5/7 are about Saidan (the real man, before the possession), so no overlap with Balnazzar's TFT story. Last story sentence ("leads the Crimson Legion guarding Crusaders' Square") was not in the sources -> "the possessed Saidan leads the Crimson Legion from the Scarlet Bastion in the ruins of Stratholme" (Saidan page).
- 10435 Magistrate Barthilas: FIX only for related ({3144}; 10812 and 1855 are covered from Dathrohan's side). Book link is explicit and has action (ch 5 prosecution, ch 7 attack on Stratholme); story all traceable.

Counts: 10 accepted (5 PASS: 10429, 11583, 10184, 10508, 10440; 5 FIX: 10162, 8929, 10813, 10812, 10435), 1 REJECT (10439). No ADDED entries.

Spot-check of worker rejects (closest to a hit): Ramstein is the only one that was accepted and now rejected. Rejects Vaelastrasz / Pip Quickwit / Gandling rest on guide-only sources per the report; not re-opened beyond that.

## Additions to existing entries (verified)
None needed in Data.lua:
- 1749 Visage Day: already present in Data.lua (role + story). `related = { 10184 }` NOT to be added: Onyxia 10184 already lists 1749 (the validator warns on two-way related).
- 2425 Varimathras related {10813}: not needed, Balnazzar (10813) lists 2425.
- 10181 Sylvanas "A Kingdom Divided": already in her TFT missions in Data.lua.
- 1855 Tirion / 3144 Eitrigg related {10812, 10435}: facts true (Of Blood and Honor), but Dathrohan lists 1855 and Barthilas lists 3144, so no change.

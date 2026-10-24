# H2 verdict (critic)
- 11946 Drek'Thar: FIX - TFT role "controllable ally" not in source, now "ally"; TFT To Tame a Land (Founding of Durotar), Rise of the Horde, Lord of the Clans, The Shattering all verified. Coords "" (Wowhead g_mapperData empty).
- 13442 Arch Druid Renferal: FIX - coords set to "" (Wowhead has no mapper data; wiki-only value not accepted). Stormrage ch. 2 and The Shattering verified. Zone Alterac Valley OK.
- 15990 Kel'Thuzad: FIX - missions were incomplete. Added WC3 Human "Ravages of the Plague" (he speaks and flees); WC3 Undead "Path of the Damned": Digging up the Dead, Into the Realm Eternal, Key of the Three Moons, The Fall of Silvermoon, The Revelation, Blackrock & Roll, Too!, The Siege of Dalaran, Under the Burning Sky; TFT "Legacy of the Damned": King Arthas, The Flight from Lordaeron, Sylvanas' Farewell (worker wrongly thought TFT unverified). Skipped Trudging through the Ashes and A Kingdom Divided (name only, he is not present). Reordered story sentence 2 to match the sources; dropped two-way related (validator warning). Cult of the Damned, FK War of the Damned, Road to Damnation (short story, protagonist), Cycle of Hatred ch. 8 verified.
- 15989 Sapphiron: PASS - Legacy of the Damned: The Return to Northrend / Into the Shadow Web Caverns verified; same dragon per wiki page (frost wyrm in Naxxramas). related to KT kept.
- 16063 Sir Zeliek: FIX - role "paladin" changed to "death knight and former paladin"; FK (Reforged) War of the Damned is Act Three of Forsaken Kingdom and lists Zeliek; same NPC per wiki page. Ashbringer comic not used.
- 15341 General Rajaxx: PASS - short story by Micky Neilson on the official site; page names Rajaxx killing Valstann. Zone Ruins of Ahn'Qiraj.
- 11501 King Gordok: REJECT - "Gordok" is a title passed by killing the king; wiki says Ulrok overthrew the earlier king, and in Traveler Malus kills the king and becomes the new Gordok. No source says the Traveler king is the same individual as the Dire Maul boss.

Spot-check of rejects (Mograine 16062, Tortheldrin, Korth'azz/Blaumeux, Ossirian, Kurinnaxx): no book hit with action; rejects stand.
Validator (Data.lua copy + H2_checked.lua): OK, 134 entries, no warnings after removing double related.
Counts: PASS 2, FIX 4, REJECT 1 (6 entries in H2_checked.lua). Additions to existing entries: none.

# RAV_A report: Ravenholdt Manor (Alterac Mountains, zone 36)

## Summary
- NPCs in scope: 14 (10 requested + 4 checked for location). Accepted: **0**.
- Candidates decided (already_in_Data_lua = false): 5 in candidates_36.json (Deer, Sheep, Warden Belamoore, Archmage Ansirem Runeweaver, Lord Jorach Ravenholdt). Jorach is decided below; the other four are out of the Ravenholdt-only scope and are listed for the zone-wide pass.
- Books checked by lookup.py `books`: Ravenholdt, Jorach Ravenholdt, Fahrad, Winstone Wolfe, Simone Cantrell, Master Kang, Carlo Aurelius, Zan Shivsproket, Smudge Thunderwood, Gravis Slipknot, Jimmy the Bleeder, Salome, Ravenholdt Assassin, Ravenholdt Guard. Raw search of all 372 cached book pages for each name: only Ravenholdt/Jorach hits (Defias, Stormwind Assassins, assassin list), all non-fiction.
- Result: no Ravenholdt NPC in this group is in a novel or in a Warcraft II/III mission per the sources available.

## Ravenholdt NPC decisions

| ID | Name | Decision | Reason (quoted line) |
|---|---|---|---|
| 6707 | Fahrad | REJECT | No book hit. Cited sources are WoW quests ("[[To Catch a Thief]]", "[[Patricide#Notes]]"). Source: https://warcraft.wiki.gg/wiki/Fahrad |
| 6766 | Ravenholdt Guard | REJECT | No book hit. Only WoW quest and gossip content. "Ravenholdt Guards are human quest givers located in and around Ravenholdt Manor." Source: https://warcraft.wiki.gg/wiki/Ravenholdt_Guard |
| 6768 | Lord Jorach Ravenholdt | REJECT | Section template is `{{novel-section}}`, but the text under it cites the guide: "Following the Argus Campaign ... Jorach Ravenholdt" with `<ref name="Exploring Azeroth">''World of Warcraft: Exploring Azeroth: The Eastern Kingdoms'', pg. 71</ref>`. Exploring Azeroth is a guide, so it does not count. The Legion and Cataclysm content is WoW (class hall, quests), not a book. Source: https://warcraft.wiki.gg/wiki/Lord_Jorach_Ravenholdt |
| 6771 | Ravenholdt Assassin | REJECT | No book hit. Only appearance outside WoW is the Hearthstone card (not a book). "Ravenholdt Assassins are humans found near Ravenholdt Manor." Source: https://warcraft.wiki.gg/wiki/Ravenholdt_Assassin |
| 6777 | Zan Shivsproket | REJECT | No book hit. Gnome engineering vendor: "Zan Shivsproket is a gnome engineering vendor found in the basement of Ravenholdt Manor." Source: https://warcraft.wiki.gg/wiki/Zan_Shivsproket |
| 6779 | Smudge Thunderwood | REJECT | No book hit. Poison vendor: "Smudge Thunderwood is a dwarf poison vendor located in the Ravenholdt Manor basement." Source: https://warcraft.wiki.gg/wiki/Smudge_Thunderwood |
| 7323 | Winstone Wolfe | REJECT | No book hit. Film reference only: "Winston 'The Wolf' Wolfe" in *Pulp Fiction* (trivia). Source: https://warcraft.wiki.gg/wiki/Winstone_Wolfe |
| 7324 | Simone Cantrell | REJECT | No book hit. Quest/reputation NPC only: "Killing Simone causes an increase of Syndicate reputation and a decrease of Ravenholdt reputation." Source: https://warcraft.wiki.gg/wiki/Simone_Cantrell |
| 7325 | Master Kang | REJECT | No book hit. Trainer: "He is training Ravenholdt Sentries." Name references are speculative ("Might be a reference to Taekwondo master Shin Chul Kang"). Source: https://warcraft.wiki.gg/wiki/Master_Kang |
| 8309 | Carlo Aurelius | REJECT | Listed only in the Assassins "Notable" list (a WoW-only index, not a book). The NPC page has no book or RTS line: "Carlo Aurelius is a human found near Ravenholdt Manor in Hillsbrad Foothills." Source: https://warcraft.wiki.gg/wiki/Carlo_Aurelius |
| 11776 | Salome | REJECT | Not at Ravenholdt only: "Salome is a house cat located at Ravenholdt Manor in the Hillsbrad Foothills" (also Hall of Shadows). No book hit. Its page labels the owner question "Speculation". Source: https://warcraft.wiki.gg/wiki/Salome |

Location-only checks (one line each, not written as entries):
- 14221 Gravis Slipknot: NOT at Ravenholdt. "Gravis Slipknot is a rare mob human found at Strahnbrad, in the Alterac Mountains." Source: https://warcraft.wiki.gg/wiki/Gravis_Slipknot
- 14222 Araga: NOT at Ravenholdt. "Araga is a rare mob mountain lion found in the Hillsbrad Foothills." Source: https://warcraft.wiki.gg/wiki/Araga
- 14223 Cranky Benj: NOT at Ravenholdt. "Cranky Benj is a rare turtle in Hillsbrad Foothills." Source: https://warcraft.wiki.gg/wiki/Cranky_Benj
- 14281 Jimmy the Bleeder: NOT at Ravenholdt. "Jimmy the Bleeder is a rare mob human found in the Hillsbrad Foothills." Ravenholdt is mentioned only for standing. Source: https://warcraft.wiki.gg/wiki/Jimmy_the_Bleeder

## Other candidates in candidates_36.json (already_in_Data_lua = false, outside the Ravenholdt scope)
- 883 Deer: REJECT, generic creature. "Deer appear as critters in Warcraft III: Reign of Chaos." Source: https://warcraft.wiki.gg/wiki/Deer
- 1933 Sheep: REJECT, generic creature. "In Warcraft II, if annoyed, sheep will say 'Baa-ram-ewe'" is a unit-type note, not a character. Source: https://warcraft.wiki.gg/wiki/Sheep
- 2415 Warden Belamoore: REJECT. Only source is a guide: "Lands of Conflict, pg. 87". Source: https://warcraft.wiki.gg/wiki/Warden_Belamoore
- 2543 Archmage Ansirem Runeweaver: NOT decided here (out of scope). He has a novel-section citing *Jaina Proudmoore: Tides of War* (novel) and *Lands of Conflict* (guide). He is at Dalaran Crater, not Ravenholdt. Flag for the zone-wide run. Source: https://warcraft.wiki.gg/wiki/Archmage_Ansirem_Runeweaver

## Reverse check (step 4), names checked
Ravenholdt, Jorach Ravenholdt, Fahrad, Winstone Wolfe, Simone Cantrell, Master Kang, Carlo Aurelius, Zan Shivsproket, Smudge Thunderwood, Gravis Slipknot, Jimmy the Bleeder, Salome, Ravenholdt Assassin, Ravenholdt Guard. Surnames checked too: Wolfe, Cantrell, Kang, Aurelius, Thunderwood, Shivsproket, Slipknot. Raw search of `_books.json` found no novel mention of any of them. "Kang" hits are unrelated (Kang Bramblestaff, Bernie Kang artist, the pandaren Kang). "Benj" hits are unrelated (Benjamin Gibb).

## Open questions
1. Ravenholdt and Warcraft II: no cached WC2 mission page mentions Ravenholdt. Tides of Darkness, Day of the Dragon and Lord of the Clans cached pages have 0 Ravenholdt/Jorach/assassin hits. A live wiki search (small-model summary, not verified line by line) listed Ravenholdt on the Alterac (kingdom) and Blackrock clan pages under Warcraft II sections. That is not an NPC-level appearance, so it does not change any decision here. Verify against the actual WC2 mission pages before closing this.
2. Ravenholdt Guard page says "Patch 4.0.3a: Removed" but also lists it as a current quest giver. Not used for any decision.
3. Ansirem (2543) needs a decision in the zone-wide run.

## Interesting facts
- Fahrad is the only Grand Master trainer outside Northrend, per his page trivia. Source: https://warcraft.wiki.gg/wiki/Fahrad
- Fahrad was a black dragon in disguise who saved Wrathion when Wrathion was still in his egg. Source: https://warcraft.wiki.gg/wiki/Fahrad
- Winstone Wolfe took over from Fahrad as the only repeatable Ravenholdt reputation quest-giver (Junkboxes Needed) during Cataclysm. Source: https://warcraft.wiki.gg/wiki/Winstone_Wolfe
- Winstone Wolfe was patrolling the manor entrance when the rogue adventurer sneaked in during To Catch a Thief. Source: https://warcraft.wiki.gg/wiki/Winstone_Wolfe
- Winstone's name matches "Winston 'The Wolf' Wolfe", a character Harvey Keitel plays in Pulp Fiction (page trivia). Source: https://warcraft.wiki.gg/wiki/Winstone_Wolfe
- Smudge Thunderwood's brother Dirk ran the poison operations in Cenarion Hold. Source: https://warcraft.wiki.gg/wiki/Smudge_Thunderwood
- Killing Simone Cantrell raises Syndicate reputation and lowers Ravenholdt reputation. Source: https://warcraft.wiki.gg/wiki/Simone_Cantrell
- Master Kang's name may reference Taekwondo master Shin Chul Kang or Dahar Master Kang from Star Trek; the page marks these as possibilities only. Source: https://warcraft.wiki.gg/wiki/Master_Kang

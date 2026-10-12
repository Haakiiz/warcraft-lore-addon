# WC1 / WC2 / BTDP characters as WoW Classic NPCs: research report (2026-10-12)

## Method

- Pulled every mission page in the six campaign categories from the warcraft.wiki.gg MediaWiki API (12 WC1 Human, 14 WC1 Orc incl. demo, 14 + 14 WC2 ToD, 12 + 12 BTDP), plus the three game pages and the three "… missions" overview pages. That is 83 pages.
- Collected all 665 link targets from those pages and kept the ones that are character pages (Npcbox). Added the WC2/BTDP hero and manual characters that the mission pages do not link (Kilrogg Deadeye, Zuluhed, Nekros, Thoras Trollbane, Rend/Maim, Galen, Falconcrest, Aliden, Onyxia/Nefarian and others).
- Cross-check: all 174 wiki pages that use `{{WC1-section}}` or `{{WC2-section}}`. The only character pages among them that also have a WoW section are Dal'rend Blackhand, Maim Blackhand, Khadgar and Uther. All four are rejected below.
- Read each character page's RTS lines and its `===World of Warcraft===` section, and checked for `{{Classic only}}` tags.
- Existing Data.lua entries: fetched the first wiki source of all ~150 entries and searched for WC1/WC2/BTDP references (`Warcraft II` but not III, `Orcs & Humans`, `{{WC1/WC2`, `(WC1`/`(WC2` mission links). The only hits were a manual footnote on Marshal Redpath and a trivia line on Thrall. Neither is a game appearance.
- Characters checked: **76**.

## Result

**No ACCEPTs.** None of the 76 characters is both (a) present in one of the three games as a unit, hero, commander or concrete objective and (b) a classic-era WoW NPC.

**No additions to existing entries.** No existing Data.lua NPC appears in WC1, WC2 or BTDP.

The reason is structural. Almost every RTS character from 1994–96 was dead by WoW 1.x (Lothar, Llane, Blackhand, Doomhammer, Gul'dan, Terenas, Uther, Daelin, Aiden Perenolde). Others first appear in WoW in The Burning Crusade or later (the whole Sons of Lothar expedition, Teron Gorefiend, Kargath, Kilrogg, Zul'jin, Mogor, Tagar, Zuluhed, Medivh, Cho'gall, Nekros). The classic NPCs with WC2 ties (Rend Blackhand, Onyxia/Katrana, Aliden Perenolde, Tirion, Mograine) are tied only through the manual, the novels or lore battle summaries, never through the game itself.

## Full character list

Abbreviations: H = Human campaign, O = Orc campaign. "Lore commander" means the wiki lists the character in the mission's Conflictbox from the novels or Chronicle account of the battle, but the character is not in the game mission.

| Name | Game | Missions (source) | WoW Classic NPC? | NPC ID | Zone | Evidence / reason |
|---|---|---|---|---|---|---|
| Anduin Lothar | WC1, WC2 | WC1 H/O most missions; WC2 H 1–13 (briefings, hero in some) | no | – | – | Dead in WC2 H13. Wiki WoW section is only Legion (Return to Karazhan). Classic has just his sword Ashkandi as an item |
| Llane Wrynn I | WC1 | WC1 H/O | no | – | – | Dead. WoW section is Legion only |
| Medivh | WC1 | Medivh (WC1 Human) | no | – | – | No WoW section; first in WoW in TBC (Black Morass) |
| Garona Halforcen | WC1 | WC1 O (Stormwind Keep etc.) | no | – | – | "During the World of Warcraft beta, she was seen in Ravenholdt Manor… She was removed before the game's release" |
| Griselda Blackhand | WC1 | The Deadmines (WC1 Orc) | no | – | – | Dead, no WoW section |
| Turok | WC1 | The Deadmines (WC1 Orc/Human) | no | – | – | "Deceased"; only "likely meant to be the unnamed Ogre unit" |
| Blackhand | WC1 | WC1 O (Warchief), WC1 H Blackrock Spire | no | – | – | Dead, no WoW section |
| Orgrim Doomhammer | WC1, WC2 | WC1 O; WC2 O all missions (briefings), H13 commander | no | – | – | Dead before WoW, no WoW section |
| Gul'dan | WC1, WC2 | WC2 O12 Tomb of Sargeras etc. | no | – | – | WoW section is `{{Bc-section}}` only |
| Cho'gall | WC1, WC2 | The Badlands (WC2 Orc) target, Tomb of Sargeras | no | – | – | WoW appearances are Cataclysm (Bastion of Twilight) |
| Abbot of Northshire Abbey | WC1 | Northshire missions | no | – | – | "a character mentioned in Warcraft: Orcs & Humans" |
| Utok Scratcher / Milan | WC2 | All WC2 O / WC2 H missions | no | – | – | Strategy-guide narrators, no WoW presence |
| Obris | BTDP | Dance of the Laughing Skull (H) | no | – | – | Speculated narrator only, novel character |
| Aiden Perenolde | WC2 | Betrayal and the Destruction of Alterac (H11), commander; The Prisoners | no | – | – | Dead before WoW, no WoW section. His son Aliden (2423) is a different person, see existing entries |
| Terenas Menethil II | WC2 | The Fall of Lordaeron (O14) commander; H briefings | no | – | – | Dead; WoW section is WotLK only |
| Daelin Proudmoore | WC2, BTDP | H3/H4/H12/H13 briefings; Assault on Kul Tiras (BTDP O8) commander | no | – | – | Dead; WoW section is BfA only |
| Uther the Lightbringer | WC2 | The Battle at Darrowmere (H9) commander | no | – | – | WoW section covers only Uther's Tomb (no NPC in classic; his spirit NPC came with TBC paladins) |
| Alonsus Faol | WC2 | Briefing mention (H9) | no | – | – | Mentioned only, no WoW section |
| Turalyon | WC2, BTDP | H13 survivor; BTDP H hero | no | – | – | WoW section is Legion only |
| Khadgar | WC2, BTDP | BTDP H hero | no | – | – | `{{Classic only-section|tbc…}}`: TBC (Shattrath) |
| Alleria Windrunner | WC2, BTDP | BTDP H hero (Alleria's Journey etc.) | no | – | – | No WoW (classic) section; WoW from Legion |
| Danath Trollbane | BTDP | BTDP H hero | no | – | – | `{{Classic only-section|tbc}}`: Honor Hold, TBC |
| Kurdran Wildhammer / Sky'ree | BTDP | BTDP H hero | no | – | – | Sky'ree's WoW section is `{{bc-section}}` (Shadowmoon Valley) |
| Zul'jin | WC2 | Raid at Hillsbrad (O2), rescue objective; Southshore (O3) | no | – | – | No classic WoW section; Zul'Aman is TBC |
| Deathwing | BTDP | Deathwing (H7), killable boss; Alterac, Eye of Dalaran, Dark Portal (O) hero | no | – | – | WoW section: "In the absence of their father, Onyxia and Nefarian…". No Deathwing NPC in classic |
| Teron Gorefiend | BTDP | BTDP O hero (Eye of Dalaran, Dark Portal) | no | – | – | No WoW section; Black Temple is TBC |
| Kargath Bladefist | BTDP | BTDP O hero | no | – | – | No WoW section; TBC Shattered Halls |
| Grommash Hellscream | WC2, BTDP | BTDP O hero | no | – | – | No WoW section |
| Dentarg | BTDP | BTDP O hero | no | – | – | No WoW section (TCG only) |
| Ner'zhul | BTDP | BTDP O briefings | no | – | – | WoW section is Legion only |
| Kilrogg Deadeye | BTDP | BTDP H/O briefings | no | – | – | No WoW section |
| Hurkan Skullsplinter | BTDP | Slayer of the Shadowmoon / Skull of Gul'dan (O) | no | – | – | No WoW section |
| Fenris Wolfbrother | BTDP | Thunderlord and Bonechewer (O) | no | – | – | No WoW section |
| Tagar Spinebreaker | BTDP | Thunderlord and Bonechewer (O); Tomb of Sargeras (WC2x, Remastered) | no | (TBC NPC) | Hellfire Peninsula | TBC NPC, not classic |
| Mogor | BTDP | Dance of the Laughing Skull (H) | no | (TBC NPC) | Nagrand | "final encounter of the Ring of Blood in Nagrand", TBC |
| Ragnok Bloodreaver | BTDP | Tomb of Sargeras (WC2x, Remastered only) | no | – | – | No WoW section |
| Zuluhed the Whacked | WC2 (manual) | – | no | – | – | No WoW section; TBC |
| Nekros Skullcrusher | WC2 (manual/novel) | – | no | – | – | No WoW section |
| Thoras Trollbane | WC2 | Fall of Stromgarde (O7) target nation | no | – | – | WoW section is Legion only |
| Alexstrasza | BTDP | Briefing mention (O5) | no | – | – | No classic WoW section |
| Torgus | WC2 | Notes on Tomb of Sargeras (O12), novel | no | – | – | Novel character, no WoW |
| Urluk Cloud-killer | WC2 | Tomb of Sargeras (O12), lore commander | no | – | – | Novel character, no WoW |
| Maim Blackhand | WC2 (manual) | Tomb of Sargeras (O12), lore commander | no | (17028 unused TBC ID) | – | "Deceased"; "Maim has an unused The Burning Crusade ID" |
| Dal'rend (Rend) Blackhand | WC2 (manual only) | Named only in a speculative note on The Great Portal (H14) | **yes, but not in the game** | 10429 (wiki; not checked on Wowhead) | Upper Blackrock Spire (UBRS, lvl 55–60) | WC2 section cites only the manual: "Dal'rend and Maim ultimately became leaders of the Black Tooth Grin clan…" (WC2 ToD manual). The Great Portal note: "its possible the Blackha[nds]…" is speculation. The Black Tooth Grin clan appears as an AI colour, but Rend is never a unit or objective. REJECT |
| Tirion Fordring | (WC2 lore) | Assault on Blackrock Spire (H13), lore commander | **yes, but not in the game** | 1855 (existing entry) | Eastern Plaguelands | Listed only in the Conflictbox of the Siege of Blackrock Spire; page cleanup tag says the commanders are battle lore. Tirion's page has no WC1/WC2 game line. REJECT |
| Alexandros Mograine | (WC2 lore) | Assault on Blackrock Spire (H13), lore commander ("took a dark crystal…") | yes (Naxx 40, Four Horsemen; replaced in 3.0.2) | 16062 | Naxxramas (lvl 60 raid) | Lore account of the battle, not the game mission. REJECT |
| High General Abbendis | (WC2 lore) | Assault on Blackrock Spire (H13), lore commander | no (WotLK) | – | – | Lore commander only |
| Muradin Bronzebeard | (WC2 lore) | H13 lore commander | no | – | – | `{{Classic only-section|cata}}`, no classic NPC |
| Brann Bronzebeard | (WC2 lore) | H13 lore commander | no (classic WoW section is a story only; NPC came later) | – | – | Lore commander only |
| Tharbek | (WC2 lore) | H13 lore commander | no | – | – | No WoW section |
| Kel'Thuzad | (BTDP lore) | The Eye of Dalaran (O11) background ("Kel'Thuzad had witnessed what the death knights did…", Chronicle ref) | yes (Naxx 40) | 15990 | Naxxramas | Background lore from Chronicle, not in the game. REJECT |
| Antonidas / Krasus (Korialstrasz) / Kael'thas / Sathera | (BTDP lore) | The Eye of Dalaran (O11) background | no | – | – | Novel/Chronicle background only; none is a classic NPC |
| Illidan / Magtheridon / Archimonde / Kil'jaeden / Sargeras / Lich King / Maiev | (BTDP lore) | Epilogue and lore notes | no | – | – | Not in the games, not classic NPCs |
| Aegwynn, Christoph Faral, Drak'thul | – | Trivia links | no | – | – | Not game characters |
| Lord Aliden Perenolde | none | – (BTDP novel only) | yes | 2423 (existing) | Alterac Mountains | Wiki RTS refs are all "Beyond the Dark Portal, chapter 10" (the novel). Absent from the games |
| Lady Katrana Prestor / Onyxia | none | – (BTDP novel only) | yes | 1749 (existing) | Stormwind | "===Beyond the Dark Portal===" section is the novel (chapter 8 refs) |
| Lord Falconcrest, Galen Trollbane | none | – | yes (classic Arathi/Alterac) | – | – | No WC1/WC2 line on either page |
| Varimathras, Sylvanas, Nazgrel, Cairne, Thrall, Magni, Mekkatorque, Bolvar, Falstad, Eitrigg, Saurfang, Ansirem Runeweaver, Nefarian | none | – | yes | existing / various | – | No WC1/WC2/BTDP game reference on any of their pages (Mekkatorque: BTDP **novel** category only) |

## ACCEPT

(none)

## REJECT (classic-era NPCs that were the closest candidates)

1. **Warchief Rend Blackhand (10429, UBRS).** WC2 tie is the Tides of Darkness manual (Black Tooth Grin chieftain) plus a speculative note on The Great Portal. He is not a unit, commander or objective in any WC2/BTDP mission.
2. **Tirion Fordring (1855).** Listed only as a lore commander of the Siege of Blackrock Spire on the WC2 H13 page. He is not in the game.
3. **Highlord Mograine / Alexandros Mograine (16062, Naxxramas 40).** Same lore-commander list as Tirion. He was also removed in 3.0.2.
4. **Kel'Thuzad (15990, Naxxramas 40).** Chronicle background on the Eye of Dalaran page only.
5. **Lord Aliden Perenolde (2423).** BTDP *novel* only. In the game the Alterac ruler is his father Aiden, who is dead by WoW.
6. **Lady Katrana Prestor (1749) and Nefarian.** BTDP *novel* only. Their father Deathwing is the BTDP game character, and he has no classic NPC.
7. **Maim Blackhand.** Dead; only an unused TBC ID (17028).
8. **Tagar Spinebreaker, Mogor, Danath, Khadgar, Kurdran/Sky'ree, Teron, Kargath, Zul'jin.** All real game characters, but their WoW NPCs are TBC or later.
9. **Garona.** Classic beta only; "removed before the game's release".

## Additions to existing entries

(none) No existing Data.lua NPC has a WC1, WC2 or BTDP game appearance. The BTDP links on Aliden Perenolde, Katrana Prestor/Onyxia and Mekkatorque are all to the novel *Beyond the Dark Portal*. Those can be BOOK appearances if they are not in Data.lua already, but they are outside this task.

## Sources

- https://warcraft.wiki.gg/wiki/Warcraft_II:_Tides_of_Darkness_missions
- https://warcraft.wiki.gg/wiki/Warcraft_II:_Beyond_the_Dark_Portal_missions
- https://warcraft.wiki.gg/wiki/Warcraft:_Orcs_%26_Humans_missions
- https://warcraft.wiki.gg/wiki/Assault_on_Blackrock_Spire_(WC2_Human)
- https://warcraft.wiki.gg/wiki/The_Great_Portal_(WC2_Human)
- https://warcraft.wiki.gg/wiki/Dal%27rend_Blackhand
- https://warcraft.wiki.gg/wiki/Maim_Blackhand
- https://warcraft.wiki.gg/wiki/Aliden_Perenolde
- https://warcraft.wiki.gg/wiki/Garona_Halforcen
- https://warcraft.wiki.gg/wiki/Mogor
- https://warcraft.wiki.gg/wiki/Tagar_Spinebreaker

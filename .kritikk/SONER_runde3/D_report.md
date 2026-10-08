# Group D report: Thunder Bluff, Mulgore, Thousand Needles, Razorfen Kraul, Wailing Caverns

## Counts
| Zone | ID | NPCs in zone | Candidates not in Data.lua | ACCEPT (new) | Additions to existing |
|---|---|---|---|---|---|
| Thunder Bluff | 1638 | 161 | 9 | 3 (Beram confirmed; Siln and Tigor uncertain) | none found |
| Mulgore | 215 | 166 | 5 | 0 | none found |
| Thousand Needles | 400 | 163 | 13 | 1 (Pozzik) + 1 uncertain (Thalia Amberhide) | none found |
| Razorfen Kraul | 491 | 44 | 0 (only Charlga, in Data) | 0 | none found |
| Wailing Caverns | 718 | 29 | 3 | 0 | none found |

Coordinates: Wowhead was not fetched in this run, so all new entries have `coords = ""` for the orchestrator to fill.

## Output files
- `D.lua`: 5 new entries (3032, 3030, 3031, 4630, 10645).
- `D_report.md`: this file.

## Thunder Bluff (1638)
Candidates not in Data (decided):
- ACCEPT Beram Skychaser (3032): Characters section, Shattering, "Minor" column: "*{{RaceIcon|Tauren|Male}} [[Beram Skychaser]]". Page: "killed by the [[Grimtotem tribe]]" with cite pg. 209.
- ACCEPT (uncertain) Siln Skychaser (3030) and Tigor Skychaser (3031): wiki page cites The Shattering pg. 209 for "Following [[Cairne]]'s death, she/he was killed by the [[Grimtotem tribe]]". Neither name is in the Characters section. Same basis as Narm Skychaser (3066) already in Data.
- REJECT Bena Winterhoof (3009): "{{Comic-section}} Bena once offered to help [[Kova Broadhorn]]... <ref>''[[Legends Volume 2]]'', ''[[Miles to Go]]''</ref>". Comic.
- REJECT Siln/Tigor are accepted above (not rejected).
- REJECT Turak Runetotem (3033): no book reference; only in-game mail "{{Book||content=...}}" and quest text.
- REJECT Nara Wildmane (5770): "==In the RPG== ... ''[[Lands of Mystery]]'', pg. 186". RPG.
- REJECT Hesuwa Thunderhorn (10086): "''[[World of Warcraft: Exploring Azeroth: Kalimdor]]'', pg. 88". Guide.
- REJECT Elder Bloodhoof (15575): cites ''Ultimate Visual Guide'' only; "The Fallen Chieftain" is an in-game event.
- REJECT Spirit Healer (6491): generic NPC type.

## Mulgore (215)
- REJECT Battleboar (2966): generic RTS unit type ("Kalimdor's [[quilboar]]s specially train battleboars"); RPG cite.
- REJECT Swoop/Vulture (2970): generic RTS unit type (WC3 manual).
- REJECT Yaw Sharpmane (3065): "{{Book|Survival Weapon Change|...}}" is an in-game mail, not a book.
- REJECT Kar Stormsinger (3690): "{{Book|Journeyman Riding in Mulgore|...}}" is an in-game mail.
- REJECT Sayge (14822): "[[Warcraft: Legends Volume 4]], ''[[Blood Runs Thicker]]''". Comic.
- REJECT Kerri Hicks (14832): "==Legends: Blood Runs Thicker== {{comic-section}}". Comic.
- REJECT Elder Bloodhoof (15575): see Thunder Bluff.
- REJECT Spirit Healer (6491): generic.

## Thousand Needles (400)
- ACCEPT Pozzik (4630): Characters section of Traveler: The Spiral Path lists "Pozzik" under the "Other" group (group heading inferred by the worker, not confirmed). Page: "a member of MEGA ... ''[[Traveler: The Spiral Path]]'', pg. 236". Role: Minor.
- ACCEPT (uncertain) Thalia Amberhide (10645): listed in the same Traveler Characters section ("Other"), and her page is in "Traveler characters". Her scenes in the novel were not read. Story left blank.
- REJECT Cloud Serpent (4117): generic creature.
- REJECT Grenka Bloodscreech (4490): "==In the RPG== ... ''[[Lands of Mystery]]'', pg. 60". RPG.
- REJECT Rau Cliffrunner (4722): "==In the RPG== ... ''[[Lands of Mystery]]'', pg. 60". RPG.
- REJECT Dog (10582): generic RTS unit type.
- REJECT Arikara (10882): "''[[World of Warcraft: Exploring Azeroth: Kalimdor]]'', pg. 126". The section headed "Exploring Azeroth" is marked Novel-section, but the source is a guide.
- REJECT Arnak Grimtotem (10896): cites ''[[Horde Player's Guide]]'' pg. 163-164 and Ultimate Visual Guide. Guide.
- REJECT Pao'ka Swiftmountain (10427): quest chain only; no book citation.
- REJECT Spirit Healer (6491): generic.

## Razorfen Kraul (491)
- Only candidate is Charlga Razorflank (4421), already in Data.lua. Her wiki page cites Ultimate Visual Guide and "A Vengeful Fate" / "An Unholy Alliance (Classic)" for her role. No book Characters-section hit. No addition.
- All other NPCs in the zone are generic (Razorfen mobs, Death's Head types, Agam'ar, Kraul Bat, Boar Spirit). Named ones: Overlord Ramtusk, Agathelos the Raging, Aggem Thorncurse, Death Speaker Jargba, Willix the Importer, Heralath Fallowbrook, Earthcaller Halmgar, Roogug. Their only book-text hits are in the Adventure Guide (Agathelos) and quilboar pages, not in book Characters sections. Not accepted.

## Wailing Caverns (718)
- REJECT Snake (2914): generic RTS unit (WC3 manual, Wyvern Rider).
- REJECT Mutanus the Devourer (3654): "''[[World of Warcraft: Exploring Azeroth: Kalimdor]]'', pg. 142". Guide.
- REJECT Druid of the Fang (3840): generic faction ("Druids of the Fang" page cites Alliance Player's Guide).
- Naralex (3679) is already in Data.lua.
- Fanglords (Cobrahn, Pythas, Anacondra, Serpentis), Skum, Kresh, Verdan: no book Characters hits. Not decided individually (no signal in candidates).

## Reverse check (step 4)
Names checked: 337 (every named non-generic NPC in the five zones, including trainers and vendors, plus a few extras). Method: word-boundary match in `_books.json`. This is not the helper's substring match, because short names like "Tal", "Mak" and "Una" flood the output. Hits were then read against the `==Characters==` sections of the book pages:
- The Shattering: Prelude to Cataclysm, Characters (Minor column): Beram Skychaser (accepted), Cor Grimtotem (4310, already in Data), Gorm Grimtotem (4309, already in Data), Rahauro (11833, already in Data).
- Traveler: The Spiral Path, Characters ("Other"): Pozzik (accepted), Thalia Amberhide (accepted, uncertain), Fizzle Brassbolts, Razzeric, Rizzle Brassbolts, Jinky Twizzlefixxit, Daisy (all already in Data).
- Other hits came from non-book wiki pages (Thunder Bluff, quilboar, Grimtotem, goblin pages, Dragonflight-era pages) and were not Characters-section entries. Examples: Bena Winterhoof (Earth Mother / Forsaken pages), Bashana Runetotem (Blackfathom quote), Charlga (Scourge page). Not accepted.
- Stormrage, Dawn of the Aspects, Rise of the Horde and Short stories: no zone NPC was named in their Characters sections, apart from Naralex (already in Data).

## Additions to existing entries
None found in this group. Cor Grimtotem, Gorm Grimtotem, Rahauro, Narm Skychaser and the Thousand Needles Traveler set (Fizzle, Razzeric, Rizzle, Jinky, Daisy) already have their BOOK appearances.

## Open questions for the orchestrator
1. Coordinates for all new entries are `""`. Wowhead was not fetched.
2. Siln Skychaser (3030), Tigor Skychaser (3031) and Thalia Amberhide (10645) are "uncertain". Siln and Tigor are not in the Shattering Characters section; Thalia's scenes in Traveler were not read. A check against the book text would settle them.
3. The Pozzik and Thalia Characters-section group ("Other") was taken from a WebFetch summary of the wiki page, not from the raw wikitext. The group heading for both was inferred, not confirmed.
4. Beram Skychaser's story sentence "blessed Cairne's runespear" comes from the wiki intro, uncited. It is kept because the page is one I read, but it is not from the novel.

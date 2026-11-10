# FV report (Forever zones)

Wowhead Forever pages return 403 to scripts (curl with Mozilla UA): all coords left "" (orchestrator fills). IDs sourced to forever_npcs.txt + https://www.wowhead.com/forever/npc=<id>.

## ACCEPT (4)
| ID | Name | Zone | Evidence |
|---|---|---|---|
| 256621 | Archmage Ansirem Runeweaver | Zephras Isle | Wiki page has `==Forever==`: "Ansirem and several Kirin Tor forces traveled to Skywall to help the skyborne fight Rohash." Same character as 2543 (WC3 Reforged, Tides of War, Quest for Pandaria). related = {2543}. |
| 256620 | Muln Earthfury | Zephras Isle (+Mulgore) | Wiki `==Forever==`: "Muln is present at Camp Gev'rek ... northwestern Mulgore"; "Muln and several Earthen Ring forces traveled to Skywall". Books: Charge of the Aspects, Jaina Proudmoore: Tides of War ("he has stepped down as the leader of the Earthen Ring, being replaced with Thrall"). |
| 40833 | Tiala Whitemane | Mount Hyjal | Same NPC id as the Cataclysm Hyjal NPC at Nordrassil. Shadows Rising: "Tiala assured the shaman that the passage would remain open." (Characters table, Minor/Mentioned columns; prose shows her acting.) |
| 253471 | Mordent Evenshade | Shen'dralas | Wiki `==Forever==`: "Mordent is located at Evenshade's Overlook in Shen'dralas, located north of Dire Maul." Wolfheart: "the Highborne fell prey to Maiev's trap". |

Muln also named in Thrall: Twilight of the Aspects (category only; book page not cached, not used as an appearance). Muln's manga appearance (Shaman) excluded.

## REJECT
| ID | Name | Reason |
|---|---|---|
| 254131 | Skylord Omnuron | No RTS/book: "Omnuron and his Druids of the Talon were watching over ... Mount Hyjal" (quest/Aviana page only; Aviana is not a book). |
| 254915 | Thisalee Crow | "a young night elf druid and a member of the Druids of the Talon" - quests only, no book/RTS hit in any book text except the Aviana (non-book) page. |
| 260626 | Bluebell | Different character: "Bluebell is a human stationed in Westguard Keep in the Howling Fjord" (War Crimes); Hyjal Flight Mistress is no proven match. |
| 267097 | Maerion Thaelemaches | "Maerion Thaelemaches is a night elf located in Forever Mount Hyjal." Forever-only, no source. |
| 256655 | Gorg | Different character/RPG: "ogre magus ... Crushridge ... Lands of Conflict" (RPG, not book); Forever Gorg is a cook. |
| 257591 | Ashe Amberhall | Forever-only; no RTS/book. |
| 257558 | Demar Brant | Forever-only: "leader of the Brotherhood of the Horse". |
| 250660 | The Baron | Forever abomination boss, "Affiliation Scourge"; book hits are Baron Revilgaz only. |
| 256028 | The Lost One | "nerubian sage depicted by a statue"; book hits in Unbroken are the phrase "Lost Ones". |
| 248419 | Mirt | Book hit is the word "mirth" (Unbroken). No character. |
| 255895 | Grizzek | Not Grizzek Fizzwrench (Before the Storm); different name. |
| 250631 | The Abandoned | Instance boss; hits are generic word. |
| 265701 | Captain Truman | Forever-only Forsaken: "used to serve Othmar Garithos" - Truman himself in no source. |
| 251890 | Tyrus Blackhorn | "imprisoned ... since Archimonde's defeat at the Battle of Mount Hyjal" but no appearance in WC3 itself, TCG/quest character. |
| 255833 | Rohash | "one of the djinn lords making up the Conclave of Wind" - WoW boss, no RTS/book. |
| 251966..274907 | Skyborne of Zephras Isle (Yala Windwatcher, Rorian, Aetheen, Falorne, Cyclas, Ayessa Dawnsinger, Aanders, Elaadrin Evengale, Belguilos, Dondallion, Haalien, Sirocca, "Badwind" Bennic, Belathaan, Malduko, Zaal, Tel'daeor, Delanea, Faladiel, Zendraas, Culli, Belarysa) | Flagged only by `[[Category:Skyborne characters]]`; e.g. "Elaadrin Evengale is a Skyborne located in Valanaar on Zephras Isle" - Forever-only, no book/RTS line. |
| 252076 | High Priestess Lorthuna | "leaders to the Twilight's Hammer stationed in Deepholm" - no RTS/book. |
| 261306/261311/261316/261319 | Hall of Thanes bosses (Faldrim Anvilmar, Plunder, Magmatus, Durgen Dirgehammer) | Instance bosses, Forever-only; "Plunder" is a Plunderstorm currency. |
| 250483/256035/250657/256097 | Witherfang, Viktor the Vile, Rath'mael, Bjork | Ruins of Lordaeron bosses, Forever-only. |
| 260325 | Shadetooth | Excavation Site boss, Forever-only. |
| 257087 etc. | Remaining names with pages (Fayran Elthas, Sebelia, Toron Rockhoof, Jereman, Marrosis, Yashiro, Grimroot [SoD boss], Hyacinth [cloud serpent], Glop [pet ability], Kor'gar [outpost]) | No book/RTS line. |

## Reverse book check
Ran full-name substring search of all ~250 names in forever_npcs.txt across _books.json; only real Characters-list hits: Muln Earthfury, Ansirem Runeweaver (Tides of War), Tiala Whitemane (Shadows Rising), Mordent Evenshade (Wolfheart). No hits at all for Goma Barkskin, Johun "Punchy" Dillas, Rohash. All other hits were substring noise (race/place words). Surnames not individually searched for the hundreds of generic vendors.

## Open questions
- Coordinates empty for all four (403).
- Muln spawns on Zephras Isle (finale, wiki 75.2, 53.2) and Mulgore (Camp Gev'rek); zone set to Zephras Isle per forever_npcs.txt.
- Tiala's column in Shadows Rising is Minor or Mentioned (could not tell from the flattened table).

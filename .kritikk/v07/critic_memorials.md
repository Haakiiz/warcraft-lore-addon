# Critic: Memorials (v0.7, commit 9ff41ca), 2026-10-12

Independent strict review against the yardstick in `.kritikk/v05/HANDOFF.md`. Diff reviewed: `e8b1d96..9ff41ca`.
Lore checked against warcraft.wiki.gg (MediaWiki API): the WC1, ToD and BTDP mission lists, the individual mission pages
(conflictbox commanders and briefings), The Warning (WC3), The Blood of Mannoroth, The Death of Hellscream, By Demons Be
Driven, The Hunter of Shadows, The Defense of Strahnbrad, Blackrock and Roll, Valley of Heroes (full plaque texts), Royal
Gallery, Monument to Grom Hellscream, The Armor of Mannoroth, Uther's Tomb, Trollbane's Tomb, Thoras Trollbane,
Turalyon (Warcraft II) and Uther the Lightbringer.

## Tests
`python tests/validate_db.py`: OK, 12 memorials valid. All 16 `tests/test_*.py` scripts pass (memorials 66/66,
achievements 59/59, mappins 31/31, saved_data 28/28, widths 201/201, guard 30/30 and the rest).

## Blind A/B
- **A** = e8b1d96 (no memorials). **B** = 9ff41ca (memorials).
- **Preferred: B**, confidence medium (about 65 %). The feature fits the addon well. The code is clean, guarded and tested,
  and the UI reuses the existing patterns. B is not ready yet because of the lore faults below. A has no such faults
  because it has no memorial data at all.

## Scores (B)
| # | Yardstick point | Score |
|---|---|---|
| 1 | Polished, consistent with Style.lua | 8 |
| 2 | Short, clear player text | 7 (status filter says "Met"/"Not met" in memorial mode, the French "avec", the changelog wording) |
| 3 | Nothing unfinished | 8 |
| 4 | No Lua errors, Compat/pcall | 9 |
| 5 | Cheap at runtime | 9 |
| 6 | Lore accuracy, no invented missions | **4** |
| 7 | Tests cover the logic and pass | 9 |

## Per memorial
| Key | Verdict | Exact fix |
|---|---|---|
| uther | **FIX** | Memorials.lua:36 should be `missions = { "The Battle at Darrowmere" }`. Uther is not in "Betrayal and the Destruction of Alterac" (commander unknown, he is not named in the briefing or on the page). Memorials.lua:42: the mission name is **"The Defense of Strahnbrad"** (Uther speaks in its closing scene). Optional: sentences 1 and 3 both say "first paladin / founder of the Silver Hand". Change sentence 3 to "The marker beneath his statue reads: Here lies Uther the Lightbringer." |
| terenas | **FIX** (minor) | "The Warning" is the **opening cinematic** of The Scourge of Lordaeron, not a mission. Terenas is in it, so it can stay, but Memorials.lua:76 role should read "King of Lordaeron, who ignores the Prophet's warning in the opening cinematic". WC2 "The Fall of Lordaeron" is correct (Terenas is the enemy commander). |
| trollbane | **FIX** | Thoras is neither a unit nor named in the Tol Barad, The Badlands or The Fall of Stromgarde briefings (the commanders are "Unknown Alliance commander"). Memorials.lua:101 should be `missions = {}` with role "Lord of Stromgarde, whose kingdom the Horde attacks". The story is fine. |
| llane | OK | The WC1 role is correct: the Human mission 11 briefing announces his assassination. |
| daelin | OK | "Assault on Kul Tiras" is BTDP Orc mission 8, and Daelin commands there. Optional: ToD Human missions "Attack on Zul'dare", "The Battle at Crestfall" and "Assault on Blackrock Spire" name him in the briefing. |
| turalyon | **FIX** | Turalyon is not in "The Great Portal" (no commander listed, and he does not appear in any ToD mission). Remove the WC2 row, or use `missions = {}` with role "Knight of the Silver Hand in the game manual". BTDP "Alleria's Journey" and "The Bitter Taste of Victory" are correct. Memorials.lua:196 should be "The plaque names him High General of the Alliance Expedition and is signed by Uther the Lightbringer." (Uther signed it. Lothar is only named.) |
| khadgar | **FIX** | **"Khadgar's Sacrifice" is the BTDP epilogue text, not a mission.** Memorials.lua:213 should be `missions = { "Alleria's Journey", "The Bitter Taste of Victory" }`. Strictly, "Once More Unto the Breach" is better for his first appearance, since Alleria's Journey only names him in the briefing. Memorials.lua:220 should be "The plaque names his old master Medivh and is signed by Antonidas, Archmage of Dalaran." Antonidas signed it and is not remembered on it. |
| alleria | OK | Correct: right side, signed by Sylvanas, H1 and H7. |
| danath | OK | Correct: right side, signed by Thoras, H1 and H2. |
| kurdran | OK | Correct: left side, the original Classic signature, H6 (briefing) and H7 (captive rescued). |
| grom | **FIX** | Grom is not in "The Blood of Mannoroth". That interlude has only Mannoroth and Tichondrius. Memorials.lua:317 should be `missions = { "The Hunter of Shadows", "By Demons Be Driven", "The Death of Hellscream" }`. Memorials.lua:324 is wrong: in "By Demons Be Driven" Grom is the enemy, and the kill is a cinematic. Replace it with "Warcraft III lets players lead him in Ashenvale, where he drinks Mannoroth's blood, and ends with his death as he slays the demon." |
| mannoroth | **FIX** | The object does not *honor* Mannoroth. The plaque celebrates his defeat and praises "one brave orc" (Grom). It is wrong to show "Warcraft Memorial: Mannoroth the Destructor" and to count it toward "Visit every memorial to a **hero**". Set `honors = { "Grom Hellscream" }` with Grom's WC3 rows. Story sentence 1 becomes "This trophy remembers how Grom Hellscream freed the orcs by slaying the pit lord Mannoroth." Keep sentences 2 and 3, and change the last to "Warcraft III ends its orc campaign with that fight." If the team prefers not to have two Grom entries, remove it. |

## Blocking faults
1. **Invented or wrong missions** (yardstick 6, "no invented missions"): Memorials.lua:213 "Khadgar's Sacrifice" (not a mission),
   :183 Turalyon "The Great Portal", :36 Uther "Betrayal and the Destruction of Alterac", :101 Trollbane's three missions,
   :317 Grom "The Blood of Mannoroth", :42 misspelled "Defense of Strahnbrad". Fixes are in the table.
2. **Factual errors in stories:** :196 and :220 (signatory mixed up with the person remembered) and :324 (Grom is not played through the hunt).
3. **Mannoroth framed as an honored hero** (:338 and the achievement text Achievements.lua:222). Fix as in the table.
4. **CHANGELOG.md:5** "heroes of Warcraft I and II who are no longer around" is wrong. The list includes WC3's Grom and
   Mannoroth, and five of the honored heroes are alive. Change it to "graves, tombs and monuments for heroes of the strategy
   games you can't meet in WoW".

## Non-blocking (polish)
- Browser.lua:864: in memorial mode the Show filter still says "Met" / "Not met". Use "Visited" / "Not visited" while
  `state.memorials` is set.
- frFR.lua:271 should be `"Visité le %s (%s)"`, which matches the existing "Rencontré … le %s (%s)" ("avec" reads as "with").
- deDE: "Erweise deinen Respekt" is fine. "Das Lesen von Gedenkstätten" is a little stiff ("Das Lesen von Gedenktafeln"
  would be better), but it follows the existing "Die Tooltip-Zeile" pattern.
- The achievement "Heroes of the Second War": the Valley statues honor the Alliance Expedition (BTDP). "Sons of Lothar" or
  "Heroes of the Expedition" would be exact. The current title is loosely defensible.
- Terenas pin: the throne room plotted on the Undercity map at 65.9, 43.4 may look odd. Check it in game.
- The tomb icon is a human skull. That is a bit grim for Uther's Tomb. A statue or tombstone icon would suit it better.

## Detection (point 2): OK
- `TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Object, …)` is the right hook for world objects on the
  modern (10.0.2+) API that Forever 1.60.1 uses. The line is added before the tooltip is laid out, the GameTooltip-only
  filter is in place, and the GUID must start with `GameObject`. Units, creature GUIDs, player GUIDs and secret values are
  refused, so an NPC with a memorial's name cannot trigger it. Items take a different tooltip type.
- `ITEM_TEXT_BEGIN` + `ItemTextGetItem()` is correct for type-9 readable plaques, and it goes through `safeCall`.
  False-positive risk is a book item with the exact same title. None exists in classic-era data.
- The OnShow fallback calls Show() to re-layout. Both paths use pcall and guard(), the error turns off only that feature with
  one line, and there is no new global (`ns.memorialHook` is on the namespace).
- One gap to check in game: if the client has TooltipDataProcessor but never fires the Object type for some objects (for
  example the Trollbane quest object), hover does nothing. Reading still works for the plaques, but not for the tomb or the
  Grom monument unless they are readable.

## Saved data (point 4): OK
Migration 4 only adds `visited = {}` when it is missing and leaves other data alone. It is tested for schema 3 to 4 and
for an already-4 file. MarkVisited refuses a non-table `visited` (a newer schema). v0.6.1 and v0.7-beta users are safe.

## Verdict: **AVVIST**
The code, UX and tests are at GODKJENT level. Lore accuracy fails: one invented mission, five unsupported mission
appearances, three wrong story sentences and a demon labelled as an honored hero. After the fixes above (all data and text
only), this should pass.

# v0.5 critic, round 1 (independent, blind A/B against session/v0.4-related)

Method: read HANDOFF.md, diffed each part `session/v0.4-related...session/v0.5`, read the full
UI.lua / Compat.lua / Options.lua and the changed parts of Core.lua, SavedData.lua, Toast.lua,
Browser.lua, Data.lua. Ran all six test scripts: all pass (validate_db OK 110 entries, saved_data
28/28, related 7/7, timeline ok, options 10/10, guard 21/21). For P5 I scanned all 110 stories
by script (sentence count 3–6: all pass; hedge words) and read 16 random entries in full plus
every entry the diff touched.

Layout numbers used below (from tools/make_textures.py + UI.lua): RingThin drawn at 66 px has
outer radius ~30.9 px and inner radius ~27.3 px; the masked portrait disc (58 px, mask margin
6/128) has radius ~26.3 px; the 3D model is a 44 x 44 square (half-side 22 px, corner radius
31.1 px). The lore window scroll area is about 580 - 30 - 8 - 96 - 6 - 12 = ~428 px tall.

---------------------------------------------------------------------------------------------

## P1 Portrait: 3D model + "Through the ages" (UI.lua, Compat.lua, tests/test_timeline.py)

### 1. Which version is better
B meets the yardstick better, about 60 % sure. The live model (when it loads) and release
ordering are real gains, but the model is presented poorly and the timeline still buries the story.

### 2. Scores (v0.5)
| # | Point | Score |
|---|---|---|
| 1 | Polished look | 6 |
| 2 | Player-facing text | 8 |
| 3 | Nothing unfinished | 7 |
| 4 | No Lua errors | 8 |
| 5 | Cheap at runtime | 9 |
| 6 | Lore accuracy | 7 |
| 7 | Tests | 5 |

### 3. Blocking faults
1. **The model reads as a small square stamp inside a round ring.** UI.lua:87-89. A 44 x 44
   PlayerModel inside a 52 px dark disc: models cannot be masked, so the head and shoulders are cut
   by four straight edges 22 px from the centre. That leaves visible dark crescents on each side,
   and the corners (31 px) poke past the ring's inner edge. The face is also smaller than the old
   58 px portrait, which goes against "main image = live 3D model". Fix: draw an
   inverse-circle overlay (a square texture in COL.inner with a transparent hole at r ≈ 26 px) on a
   frame between the model and the ring. Move the RingGlow parts onto ringFrame so the overlay does
   not hide them. Then the model can be 58-62 px and get a true round crop. The other way is a
   bigger RING/disc with the model inscribed. Either way, back it with an offline render for the
   next critic.
2. **Through the ages buries the story.** UI.lua:529-556. Every appearance gets a full box of
   ~60-75 px before Story. Thrall (2 games + 5 books), Sylvanas (≈14 rows) and Vol'jin (7 rows)
   push Story several screens down a ~428 px viewport. P5 also left 26 rows that only say
   "Major character" / "Mentioned in the book" (Data.lua:174, 180, 1199-1229 …), and each still
   costs a full box. Fix: put Story first, right under the header. Make BOOK rows compact
   one-liners (book icon, title, role), or fold them into one "In the books" box.
3. **Icon fallback does not work.** Compat.lua:359-373. `pcall(texture.SetTexture, ...)` drops
   SetTexture's own return value. On Mainline a bad path gives `false` and GetTexture can still be
   non-nil, so the question-mark fallback never triggers and a missing icon shows as a green or
   empty square. The six icon names (UI.lua:317-332) are unverified on Forever, by the worker's own
   note. Fix: `local ok, res = pcall(...)`, treat `res == false` as a failure, and check each icon
   once in game (or use FileDataIDs).
4. **Tests do not cover the new logic** (yardstick 7). test_timeline.py only checks sort order.
   No test covers roleIcon, GAME_YEAR, setPortrait's fallback (no PlayerModel / SetCreature
   errors / model never loads), or the box heights. Add lupa tests with a stub PlayerModel.

### Non-blocking
- UI.lua:314 `FK = 2020`: verify that "Forsaken Kingdom" content really shipped with Reforged in
  2020. If it did not, drop the year for FK.
- UI.lua:82-86: OnModelLoaded swaps the 2D portrait for a dark disc without checking which NPC
  the load belongs to. Store the expected npcID and compare.
- UI.lua:511-513 and 551-553 still build an "UNCERTAIN" badge and a "Why uncertain" section.
  validate_db.py rejects uncertain entries, so this is dead code for a state the product no
  longer has. Remove it, together with Core.lua:299-300 and Browser.lua:483/554/600-611.
- INV_Misc_Bell_01 for "cutscene" is an odd choice even if it exists.

### 4. Verdict: **AVVIST**
(Labels: A = v0.4, B = v0.5.)

---------------------------------------------------------------------------------------------

## P2 Robustness: guards, batched alerts, /wcl why (Core.lua, Compat.lua, Toast.lua, tests/test_guard.py)

### 1. Which version is better
A meets the yardstick better, about 80 % sure. The guards are well designed and well tested.

### 2. Scores (v0.5)
| # | Point | Score |
|---|---|---|
| 1 | Polished look | 7 |
| 2 | Player-facing text | 7 |
| 3 | Nothing unfinished | 7 |
| 4 | No Lua errors | 9 |
| 5 | Cheap at runtime | 9 |
| 6 | Lore accuracy | n/a (10) |
| 7 | Tests | 9 |

### 3. Blocking faults
1. **Batched veterans are silently swallowed.** Core.lua:404-417. Every veteran after the first
   gets `alerted[npcID] = true` and only adds to "+N more nearby". The player never learns who
   they were, and they are never announced again this session. Entering Orgrimmar (9 veterans)
   gives "Thrall … +8 more nearby" and nothing else. Fix: name up to 2-3 in the same single line
   ("Veteran nearby: Thrall (WC3), Vol'jin (TFT) +6 more"). Make the pill (or a click on the "+N")
   open the Veterans list filtered to the current zone. Also follow the worker's own open point:
   show the first alert at once, and keep at most one extra follow-up line for the batch. The
   1.5 s delay makes the lone alert lag the nameplate.
2. **Jargon in /wcl why.** Core.lua:577 "(GUID type Pet)", and Core.lua:579 "the client hides
   this unit's ID right now (a secret value …)". Players do not know GUIDs or secret values.
   Suggested wording: "Pet is not an NPC." / "The game is not sharing this NPC's details right now
   (often in combat). Try again out of combat."
3. **The "+N more nearby" text can overflow the pill.** Toast.lua:181 sets no width on `t.games`,
   and Toast.lua:240-241 appends to it. In a 236 px pill there is ~160 px between the portrait and
   the chevron. "WC3 · TFT · Book  +8 more nearby" at 10 pt runs under the chevron or past the
   edge. Fix: SetWidth and SetWordWrap(false), or put "+N" on its own short line.
4. **/wcl why can report "all active" while alerts are dead.** The alert pipeline has two guard
   keys, "alert" (Core.lua:447) and "alert-batch" (Core.lua:420), with the same label. If the
   flush errors once, `announce` keeps marking veterans as alerted and scheduling a flush that
   silently returns. cmdWhy (Core.lua:589-594) only checks `disabled.alert`. Fix: use one key for
   the whole nearby-alert path.

### Non-blocking
- Core.lua:657-658: if UI.Init errors halfway, `frame` exists but is half built. Later
  ShowEntry calls then error inside other guards ("target", "cmd:list"), which gives one chat line
  per feature for one root cause. Mark the window as off and have callers check
  `ns.FeatureOff("window")`.

### 4. Verdict: **AVVIST**
(Labels: A = v0.5, B = v0.4.)

---------------------------------------------------------------------------------------------

## P3 Account-wide met + meet counts, migration 2 (SavedData.lua, Core.lua met, tests/test_saved_data.py)

### 1. Which version is better
A meets the yardstick better, about 85 % sure. The migration is careful: newer-schema data is
left alone, the merge can run twice safely, and leftovers are merged at load.

### 2. Scores (v0.5)
| # | Point | Score |
|---|---|---|
| 1 | Polished look | 8 |
| 2 | Player-facing text | 8 |
| 3 | Nothing unfinished | 6 |
| 4 | No Lua errors / API rules | 7 |
| 5 | Cheap at runtime | 10 |
| 6 | Lore accuracy | n/a (10) |
| 7 | Tests | 7 |

### 3. Blocking faults
1. **"Meet counts" is collected but never shown.** Core.lua:205 `ns.MeetCount` has no caller,
   and `by` / `first` are not shown anywhere. The Browser tooltip went from "Met on this
   character" to plain "Met" (Browser.lua:495), so the player sees less than before. Either show
   it (Browser row tooltip / lore window MET badge tooltip: "Met 4 times · first on 3 Oct by
   Name-Realm") or drop count/by from the part. Half a feature should not ship.
2. **Client API read outside Compat without a secret guard.** SavedData.lua:36-45 calls
   `UnitName("player")` and `GetRealmName()` directly. That breaks yardstick 4 ("every client API
   goes through Compat.lua") and the Avoid rule about issecretvalue. Fix: use `C.UnitName("player")`
   and add `C.GetRealmName` in Compat with `C.IsSecret`.
3. **New MarkMet logic is untested.** No test calls ns.MarkMet or ns.MeetCount. Nothing covers
   once-per-session counting, the count bump on an existing entry, `db.met` from a newer version
   (Core.lua:252-254), or the stored `by`. Add a lupa test that loads SavedData + Core.

### 4. Verdict: **AVVIST**
(Labels: A = v0.5, B = v0.4.)

---------------------------------------------------------------------------------------------

## P4 Options panel + mouse-wheel lists (Options.lua, .toc, Browser.lua, tests/test_options.py)

### 1. Which version is better
B meets the yardstick better, about 85 % sure. v0.4 had no settings page. This one is small and
calm, uses Style.lua colours and fonts, applies changes at once, and is pcall-guarded with a
legacy fallback.

### 2. Scores (v0.5)
| # | Point | Score |
|---|---|---|
| 1 | Polished look | 8 |
| 2 | Player-facing text | 8 |
| 3 | Nothing unfinished | 8 |
| 4 | No Lua errors | 8 |
| 5 | Cheap at runtime | 10 |
| 6 | Lore accuracy | n/a (10) |
| 7 | Tests | 8 |

### 3. Blocking faults
None.

### Non-blocking (fix in passing)
- Options.lua:185-187 returns the pcall's `ok`. When OpenToCategory fails (for example blocked
  in combat), Core.lua:625-628 prints "This client has no settings panel for Warcraft Lore",
  which is wrong. Return false only when no panel exists; otherwise say "Could not open the
  settings right now."
- Options.lua:82-89: the checkbox OnClick is not guarded. An error in Minimap.Toggle or
  Browser.Refresh reaches the error frame. Wrap it with ns.Guard.
- "Reset window positions" gives no feedback. The slash version prints a line; do the same or
  flash the button.
- The checkboxes only refresh OnShow. A `/wcl alert` typed while the page is open leaves the box
  stale.
- The "mouse-wheel lists" part is a single constant change (Browser.lua:329). That is fine, but
  it should not be sold as a feature in the changelog.
- Settings.OpenToCategory(category:GetID()) is correct for 11.x+/12.x. It still needs one
  in-game check on Forever.

### 4. Verdict: **GODKJENT**
(Labels: A = v0.4, B = v0.5.)

---------------------------------------------------------------------------------------------

## P5 Data quality audit (Data.lua, README test table, tests/test_related.py)

### 1. Which version is better
B meets the yardstick better, only about 55 % sure. Removing the research-note tags ("listed in
the novel's Characters section; novel, not a game appearance", "pg. 217") is a clear win, and so
are the new related links and the filled-in empty stories (Do'gol, Ogg'marr, Charlga). But in
several places the audit deleted the honest caveat while keeping the uncertain entry. That goes
against "remove anything uncertain rather than ship it".

### 2. Scores (v0.5)
| # | Point | Score |
|---|---|---|
| 1 | Polished look (data as shown) | 7 |
| 2 | Player-facing text | 7 |
| 3 | Nothing unfinished / uncertain | 5 |
| 4 | n/a | 10 |
| 5 | n/a | 10 |
| 6 | Lore accuracy | 6 |
| 7 | Tests | 8 |

### 3. Blocking faults
1. **Caveats removed, uncertainty kept.** These entries may not exist in the Forever world at
   all. That makes them unmeetable, and the "X of 110 met" progress can never complete:
   - Grunt Maug, Data.lua:210-232. v0.4 said he "was removed from Orgrimmar in patch 1.9.0, so he
     may not exist in Forever". That line is gone and the entry stays. He is a Gates of Ahn'Qiraj
     event NPC.
   - Uther 232920 (Data.lua:906), Gregory 231500 (:954) and Gregory 232932 (:981) are Season of
     Discovery-only NPC IDs. Uther's story does not even say where he is in WoW.
   - Korialstrasz 233382 (Data.lua:3245ff) and Krasus 232624 (:3270ff). v0.4 said "may not exist
     in every Classic version". That is now stated flatly as "In Season of Discovery …".
   - Cor Grimtotem (Data.lua:2526) and Gorm Grimtotem (:2550) open with "he has since been
     removed from the game", which contradicts the addon listing him in Thunder Bluff. Gorm has
     `coords = ""`.
   Fix: confirm each against the Forever build, or remove them (as was done with Smythe and
   Whessan). Make validate_db.py reject IDs above the Classic range unless an entry is
   whitelisted after an in-game check.
2. **Dev and research wording is still in player text:**
   - "Gregory Edmunson in the game files" (Data.lua:964, 991)
   - "(Year 30 ADP)" (:1505) and "Year 42 ADP" (:1534); ADP is jargon
   - "set long after Classic" (:1086, :3088); "Classic" means nothing to a Forever player
   - "His fate after the battle is unknown." (Cor, Gorm): filler
   - 26 roles that only say "Major character" / "Minor character" / "Supporting character" /
     "Mentioned in the book" (e.g. :174-192, :1199-1229, :2631-2655). These came from a cast list,
     not from a story, and each shows up as a near-empty row.
   Fix: rewrite the roles with one concrete clause, or drop the appearance.
3. **validate_db.py does not catch any of the above.** Add a banned-phrase check ("game files",
   "removed from the game", "Classic", "ADP", "wiki", "listed", "pg.", "Season of Discovery" unless
   whitelisted) so the next audit cannot regress.

### Non-blocking
- Lethon, Data.lua:2925-2928: "tries to corrupt Eranikus" and then "attempts to corrupt
  Eranikus" again in the next sentence.
- Siln Skychaser, Data.lua:3469 "She belongs to …": verify the gender. I believe the NPC is male.
- Maug's story is now 5 sentences that are mostly a quest list. It meets the length rule but
  reads like a database dump.

### 4. Verdict: **AVVIST**
(Labels: A = v0.4, B = v0.5.)

---------------------------------------------------------------------------------------------

## Summary
| Part | Preferred | Verdict |
|---|---|---|
| P1 Portrait + Through the ages | v0.5 (60 %) | AVVIST: square 44 px model in a round ring; story buried; icon fallback broken; thin tests |
| P2 Robustness | v0.5 (80 %) | AVVIST: batched veterans swallowed; GUID/secret jargon; pill text overflow; split guard keys |
| P3 Account-wide met | v0.5 (85 %) | AVVIST: meet counts never shown; UnitName/GetRealmName outside Compat; MarkMet untested |
| P4 Options | v0.5 (85 %) | GODKJENT (minor notes) |
| P5 Data audit | v0.5 (55 %) | AVVIST: caveats deleted but SoD/removed NPCs kept; dev wording left; no phrase checks |

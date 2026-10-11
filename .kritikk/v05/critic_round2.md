# v0.5 critic, round 2 (independent, blind A/B against session/v0.4-related)

Method: read HANDOFF.md and critic_round1.md. Read `git diff 549d4b6..session/v0.5` (round 2) in full
for UI.lua, Compat.lua, Core.lua, Toast.lua, Options.lua, Browser.lua, SavedData.lua,
validate_db.py, make_textures.py and the new tests. Opened PortraitCover.tga and RingGlow.tga with PIL
to measure the hole and the glow. For P5 I scanned all 100 entries by script (hedge words, roles under
4 words, duplicate game/campaign rows), read 20 random entries in full (seed 7311) and checked three
entries on warcraft.wiki.gg.

Tests (all pass): validate_db OK (100 entries), test_saved_data 28/28, test_related 7/7,
test_timeline ok, test_options 15/15, test_guard 30/30, test_met 18/18, test_portrait ok.

Wiki spot checks:
- Sylvanas, "A Good War" (Data.lua:1033-1035): "leads a Horde army into Darkshore and later duels
  Malfurion after the two Horde armies rejoin". This is correct. The wiki puts the final duel
  (Sylvanas vs Malfurion) right after the armies rejoin.
- Eitrigg, "Heartlands" (Data.lua:2375-2377): correct. Geya'rah uses him as an adviser and he tells her
  to stand down after a skirmish. Later he joins the armies before Stromgarde Keep.
- Siln Skychaser: female on the wiki. "She" is right, so the round-1 doubt is cleared.

---------------------------------------------------------------------------------------------

## P1 Portrait: 3D model + "Through the ages" (UI.lua, Compat.lua, PortraitCover.tga, tests/test_portrait.py)

### Round-1 blocking faults
1. **Square stamp in a round ring: FIXED.** The model is now 60 x 60 (UI.lua:21, 97). Above it at
   frame level +2 sits a 64 x 64 cover in COL.inner (100d18, the same as the opaque inner background)
   with a transparent hole. The hole measures r = 54/128 in the TGA, which is 27 px at 64 px. The model's
   ±30 px square lies fully inside the cover's ±32 px, so only a 54 px round window of the model shows.
   That is a little smaller than the old 58 px disc, but the round crop is clean. RingThin (66 px, inner
   radius ~27.3) sits on ringFrame at +3 and hides the hole's edge. The RingGlow parts moved to ringFrame
   (UI.lua:105-112), so the glow draws above the cover and still shows. The glow's soft inner halo
   (alpha ≤ 24/255 at r 21-27 px) now tints the edge of the model faintly. That looks intended rather
   than wrong. The cover is hidden for messages and for NPC-less views (UI.lua:208-216).
2. **Story buried: FIXED.** ShowEntry now runs Story → THROUGH THE AGES (games only) → IN THE BOOKS
   (one 20 px row per book) → Related (UI.lua:625-650). Book rows use one line with SetWordWrap(false)
   and a LEFT/RIGHT anchor, so long roles end in "…". Hover gives a tooltip with the title, the wrapped
   role and the chapters (UI.lua:435-480).
3. **Icon fallback: FIXED in code.** `local ok, res = pcall(...)` and `res == false` now count as a
   failure (Compat.lua:361-364). It is tested. Whether Mainline really returns false for a missing path
   still needs one in-game check, but the code handles both cases.
4. **Tests: PARTLY.** test_portrait.py covers roleIcon, GAME_YEAR (FK dropped), SetIconTexture
   (false / nil / error / success), and setPortrait with these cases: loaded, late load, stale load
   ignored, no PlayerModel, SetCreature errors, never loads, message hides the model. Not covered: the
   new round-2 layout (block order, games/books split, book-row height and tooltip, cover show/hide).
   The box heights asked for in round 1 are not covered either.

### New faults found
- Untested layout (above). This is the main change of round 2, and no test covers it.
- PortraitCover.tga has COL.inner baked into its pixels (make_textures.py:144). That is a colour fixed
  outside Style.lua (Avoid list). If Style.COL.inner ever changes, a dark square appears around the
  portrait. Better: make the texture white with a transparent hole and call
  `portraitCover:SetVertexColor(unpack(COL.inner))`. Non-blocking.
- fillGameBox still has an `isBook` branch (UI.lua:398-411) that can no longer run, because books never
  reach gameBox. Dead code. Non-blocking.
- Book rows have no hover highlight, so nothing tells the player the cut-off text has a tooltip.
  Related rows do highlight. Add the same 0.14 violet highlight. Non-blocking.
- "cutscene" now maps to INV_Misc_Map_01, which is the same as the default, so that table row does
  nothing. Non-blocking.

### Blind A/B
A: round model crop, Story first, books as one-liners. B: 58 px masked 2D portrait, Story at the
bottom. **A preferred, ~80 % sure.**

### Scores (v0.5)
| # | Point | Score |
|---|---|---|
| 1 | Polished look | 8 |
| 2 | Player-facing text | 8 |
| 3 | Nothing unfinished | 8 |
| 4 | No Lua errors | 8 |
| 5 | Cheap at runtime | 9 |
| 6 | Lore accuracy | 8 |
| 7 | Tests | 7 |

### Blocking faults
1. **The new layout has no tests** (yardstick 7). Extend test_portrait.py (its stubs already load
   UI.lua) with these cases:
   - An entry with a story, 2 games and 3 books gives the content blocks in the order Story,
     THROUGH THE AGES, 2 game boxes, IN THE BOOKS, books block.
   - booksBlock height = 3 × 20, each row's tooltip has the title and the role, and a row with chapters
     gets the "Chapter(s):" line.
   - A books-only entry has no THROUGH THE AGES header.
   - The cover is shown with the model and hidden by ShowMessage.

### Verdict: **AVVIST** (one small fix: the tests above)
(Labels: A = v0.5, B = v0.4.)

---------------------------------------------------------------------------------------------

## P2 Robustness: guards, batched alerts, /wcl why (Core.lua, Toast.lua, tests/test_guard.py)

### Round-1 blocking faults
1. **Batched veterans swallowed: FIXED (chat).** The first veteran is announced at once (line, sound,
   pill) in Core.lua:483-485. Others within 1.5 s go into one follow-up line,
   "Also nearby: A (WC3), B (TFT), C (BOOK) +N more", with no sound (Core.lua:445-460). Tested
   (test_guard: 7 veterans give exactly 2 chat lines; a lone veteran gives no follow-up).
2. **/wcl why jargon: FIXED.** "is not an NPC." / "the game is not sharing this NPC's details right
   now (often in combat). Try again out of combat." The same wording is used in /wcl, /wcl id and
   /wcl why. A test checks that "GUID" and "secret" never appear.
3. **Pill overflow: FIXED.** t.games has width 152 and no word wrap (Toast.lua:175-177). The suffix is
   now the short "+N more".
4. **Split guard keys: FIXED.** The flush uses the "alert" key (Core.lua:488). The batch is cleared
   before the flush, so it cannot stay stuck open. /wcl why reports the dead alert. All of this is
   tested.

### New faults found
- **The "+N more" pill click is broken by design** (Toast.lua:191-193). Once SetMore runs, a left-click
  anywhere on the pill:
  (a) calls `ns.Browser.Toggle()`, which closes the Veterans list if it is already open (Browser.lua:1131);
  (b) no longer opens the veteran named on the pill, the pill's main action until now;
  (c) opens the unfiltered list of 100, so "+N more" does not show who is nearby. The code comment
  ("the Veterans list shows who else is around") is not true.
  README:16 still says "Click the pill for the story".
- Toast.SetMore only looks in `active` (Toast.lua:281-289). If the nearby pill is still queued behind
  a target pill, the "+N" is lost.
- options: a new ns.Guard wrapper is built on every checkbox click (Options.lua:90-94). The cost is tiny,
  but build it once. Non-blocking.
- The pill click path has no test.

### Blind A/B
A: one chat line + pill per nearby veteran, "+N more nearby" swallowed the rest, jargon in /wcl why.
B: immediate first alert, named follow-up, plain /wcl why, a shared guard key. **B preferred, ~80 %
sure.**

### Scores (v0.5)
| # | Point | Score |
|---|---|---|
| 1 | Polished look | 7 |
| 2 | Player-facing text | 8 |
| 3 | Nothing unfinished | 7 |
| 4 | No Lua errors | 9 |
| 5 | Cheap at runtime | 9 |
| 6 | Lore accuracy | n/a (10) |
| 7 | Tests | 8 |

### Blocking faults
1. **Pill "+N more" click** (Toast.lua:186-197, 281-289). Fix:
   - Left-click on the pill opens the named veteran, as before.
   - Make "+N more" its own small Button laid over the end of t.games, or show it on a second short line.
     That button calls a new `Browser.ShowZone(zone)`, which uses Show (not Toggle) and sets state.zone
     to the veteran's zone (entry.zone). A filtered list then really shows who is around.
   - SetMore must also update queued pills.
   - Add a lupa test with stub Browser and Toast: the pill click opens the entry, the "+N" click calls
     ShowZone, and the list is not closed when already open.

### Verdict: **AVVIST**
(Labels: A = v0.4, B = v0.5.)

---------------------------------------------------------------------------------------------

## P3 Account-wide met + meet counts (SavedData.lua, Core.lua, Browser.lua, UI.lua, tests/test_met.py)

### Round-1 blocking faults
1. **Meet counts not shown: FIXED.** ns.MetSummary (Core.lua:210-245) appears in the Browser row
   tooltip (Browser.lua:491) and in a new MET badge tooltip (UI.lua:141-148). It adds up the counts over
   a merged group, takes the earliest first-met, and drops the realm when it matches yours. The date call
   is in a pcall.
2. **UnitName/GetRealmName outside Compat: FIXED.** SavedData.lua:38 uses C.UnitName and the new
   C.GetRealmName (safeCall, which has the secret guard) at Compat.lua:528-531. MetSummary uses
   C.GetRealmName too.
3. **MarkMet untested: FIXED.** test_met.py (18 checks) covers: first meeting, counted once per session,
   count bump on an old entry with first/by kept, unknown NPC, the realm on and off, merged groups,
   no-first summary, and db.met from a newer version.

### New faults found (non-blocking)
- The date format "%d %b %Y" gives "03 Oct 2026". Strip the leading zero:
  `d:gsub("^0", "")`.
- "Met once · first on 3 Oct 2026 by X" is awkward English ("first" after "once"). Use "Met once ·
  3 Oct 2026 by X" for count 1.
- ns.MeetCount (Core.lua:205) now has no caller in the addon, only in tests. Keep it or drop it.
- "Met 4 times" really means 4 sessions. That is acceptable.

### Blind A/B
A: account-wide met, a count and first-met in the tooltips. B: per-character met, "Met on this
character". **A preferred, ~85 % sure.**

### Scores (v0.5)
| # | Point | Score |
|---|---|---|
| 1 | Polished look | 8 |
| 2 | Player-facing text | 8 |
| 3 | Nothing unfinished | 9 |
| 4 | No Lua errors / API rules | 9 |
| 5 | Cheap at runtime | 10 |
| 6 | Lore accuracy | n/a (10) |
| 7 | Tests | 9 |

### Blocking faults
None.

### Verdict: **GODKJENT** (fix the two wording points in passing)
(Labels: A = v0.5, B = v0.4.)

---------------------------------------------------------------------------------------------

## P4 Options panel (re-check of round-2 changes only)

Round 2 fixed all the round-1 notes:
- Open() returns (hasPanel, opened), so Core now says "Could not open the settings right now."
  when the panel exists but did not open.
- Checkbox clicks are guarded.
- Reset goes through ns.ResetWindows, with a chat line.
- Options.Refresh keeps the boxes in step after /wcl minimap/auto/alert.

Nothing broke: test_options passes 15/15, the panel build is unchanged, and the slash command handles
both return values. One small note: the guard wrapper is built on every click (see P2). Blind A/B:
A = v0.4 (no panel), B = v0.5. **B preferred, ~85 % sure.**
Scores 8/8/8/8/10/10/8. **GODKJENT (still).**

---------------------------------------------------------------------------------------------

## P5 Data quality audit (Data.lua, validate_db.py, README table)

### Round-1 blocking faults
1. **Unmeetable entries: FIXED.** These are removed:
   - Grunt Maug
   - Uther 232920, Gregory 231500/232932, Korialstrasz 233382, Krasus 232624
   - Cor and Gorm Grimtotem

   validate_db now rejects IDs above 200000. That leaves 100 entries.
2. **Dev wording: FIXED.**
   - "game files", "ADP", "Classic", "Season of Discovery", "removed from the game" and "may not exist"
     are gone.
   - The roles that only said "Major character" etc. were rewritten as clauses. Only one role is under
     4 words: "Playable hero (Dreadlord)", which is fine.
   - Lethon's repeated phrase is fixed.
3. **No phrase check: FIXED.** BANNED_PHRASES, matched on whole words and ignoring case, covers name,
   story, role and campaign (validate_db.py:27-34, 190-228).

### Sample (20 entries, seed 7311)
Huntress Swiftriver, Mok'Morokk, Magellas, Gryth Thurden, Mug'thol, Dink, Vol'jin, Zor Lonetree,
Rizzle Brassbolts, Beram Skychaser, Saru Steelfury, Watcher Cutford, Advisor Belgrum, Gazlowe,
Draz'Zilb, Razzeric, Tyrande, Gar'Thok, Osric Strang, Shael'dryn. All roles read as player-facing
clauses ("Gnome mage, brother of Bink, who is caught by Dark Iron guards…"). Stories are 3-6
sentences, written as fact, with no speculation. A hedge scan of all 100 found only "believed the
gnomes should…" (Thermaplugg's own belief), which is fine.

### New faults found (non-blocking)
- "Before the Cataclysm, Razzeric was …" (Data.lua:1883) and "Before the Cataclysm, Jinky was …"
  (:1933). A Forever player is in the pre-Cataclysm world, so this reads as if the NPC is gone. Use
  present tense: "Razzeric is an independent goblin pilot at the Mirage Raceway…".
- Tyrande (Data.lua:225ff) has 6 game rows: 2 for Eternity's End and 4 for Terror of the Tides
  (playable / cutscenes / "Mentioned only" / "Rescue target"). Each is a full box in the window. Merge
  them into one row per campaign with a combined role.
- Saru Steelfury, "at the Burning Anvil in the Valley of Honor": the wiki gives only his current
  location. Check that the Burning Anvil exists in the Forever Orgrimmar. If it does not, say "in the
  Valley of Honor".

### Blind A/B
A: 100 entries with clean roles and phrase checks. B: 110 entries with SoD/removed NPCs and
research-note roles. **A preferred, ~85 % sure.**

### Scores (v0.5)
| # | Point | Score |
|---|---|---|
| 1 | Polished look (data as shown) | 8 |
| 2 | Player-facing text | 8 |
| 3 | Nothing unfinished / uncertain | 9 |
| 4 | n/a | 10 |
| 5 | n/a | 10 |
| 6 | Lore accuracy | 8 |
| 7 | Tests | 9 |

### Blocking faults
None.

### Verdict: **GODKJENT** (fix the two "Before the Cataclysm" stories and merge Tyrande's rows in passing)
(Labels: A = v0.5, B = v0.4.)

---------------------------------------------------------------------------------------------

## Whole addon

**Fit:** the parts share their wording well. The same "not sharing this NPC's details" line appears in
/wcl, /wcl id and /wcl why. Chat lines use the same colours and keep to one line per event. The window
checks FeatureOff("window") throughout. I found no duplicated helpers: Options now reuses
ns.ResetWindows and ns.Guard.

**Dead code from the uncertain era** (remove):
- Style.lua:28 `COL.uncertain`, Style.lua:37 `HEX_AMBER` and `COL.amber`: all unused now.
- UI.lua:398-411: the isBook branch in fillGameBox.
- Core.lua:205: ns.MeetCount has no addon caller.

**CHANGELOG:** contrary to the brief, a v0.5.0 entry already exists (commit 69fdf8a, an ancestor of
session/v0.5). It matches the code: 3D portraits, Story first, account-wide met, calmer alerts,
settings, /wcl why, guards, 100 veterans / 42 related links (the related count is verified: 42). Two
changes needed:
- the "+N more" sentence must follow the P2 fix ("click +N more to see the veterans in that zone");
- do not sell the mouse-wheel constant as a feature (it is not, so that is fine).

**README / CurseForge description are stale. These must be fixed before release:**
- README:15, README:37 and curseforge-description.md:18 say met is "per character" / "on each
  character". It is now account-wide.
- The Commands table (README:52-64) lacks `/wcl why` and `/wcl options`.
- README:14, README:16 and description:16, 19 do not mention the live 3D portrait, Story first or the
  batched "Also nearby" line. README:16 "Click the pill for the story" must match the P2 fix.
- README "What's new in 0.3" (README:34) is two versions old. Replace it with 0.5 or drop it.
- README:166 still says some NPCs "use Season of Discovery NPC IDs and may not exist in Forever". This
  is now false, so delete it.
- The README test table lists 92 of the 100 IDs. Missing: 3679, 3976, 3977, 4421, 7800, 11833, 14888,
  14889 (dungeon/raid NPCs). Add them or say the table lists only open-world NPCs.

## Summary
| Part | Preferred | Verdict |
|---|---|---|
| P1 Portrait | v0.5 (80 %) | AVVIST: all round-1 faults fixed; only blocker is missing tests for the new Story-first / book-row layout and the cover |
| P2 Robustness | v0.5 (80 %) | AVVIST: "+N more" pill click toggles the list closed, loses the main click and opens an unfiltered list |
| P3 Account-wide met | v0.5 (85 %) | GODKJENT (date "03 Oct" / "Met once · first" wording nits) |
| P4 Options | v0.5 (85 %) | GODKJENT (still) |
| P5 Data audit | v0.5 (85 %) | GODKJENT ("Before the Cataclysm" ×2, Tyrande's 6 rows, Saru's Burning Anvil to verify) |
| Whole addon | — | README/description stale (per-character met, missing commands, SoD line, 92/100 table); dead uncertain-era colours |

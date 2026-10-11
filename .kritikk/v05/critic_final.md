# v0.5.0 final critic: whole addon, blind A/B

Method: read HANDOFF.md, critic_round1.md and critic_round2.md. Read every WarcraftLore/*.lua file in
full: Compat, Data (all 100 entries), SavedData, Core, Style, UI, Browser, Toast, Minimap and Options.
Also read the .toc, README.md, CHANGELOG.md, media/curseforge-description.md, .pkgmeta, both workflows,
test_toast.py and test_portrait.py.

Ran a lupa script that loads every file in .toc order inside a logging environment:
- no file errors at load
- the only global written at load is `SLASH_WARCRAFTLORE1`
- the only unknown globals read at load are CreateFrame, STANDARD_TEXT_FONT and SlashCmdList

A grep of every non-local assignment found no new runtime globals. Every name is a declared local or a
table field; WarcraftLoreDB and WarcraftLoreCharDB are the saved variables.

I counted the related links by script: 42 unique pairs over 100 entries. That matches the CHANGELOG,
README and description.

## Tests (all pass, exit code 0)
| Script | Result |
|---|---|
| validate_db.py | OK, 100 entries |
| test_saved_data.py | 28/28 |
| test_related.py | 7/7 |
| test_timeline.py | ok |
| test_options.py | 15/15 |
| test_guard.py | 30/30 |
| test_met.py | 18/18 |
| test_portrait.py | portrait ok + layout ok |
| test_toast.py | 7/7 |

Both tests.yml and release.yml run all nine scripts.

## 1. Round-2 blockers

**P1 layout tests: FIXED.** `test_layout()` (tests/test_portrait.py:198-266) covers:
- the block order Story → THROUGH THE AGES → 2 game boxes in release order (1994 before 2002) →
  IN THE BOOKS → books block → Items → Sources
- booksBlock height = 3 × 20, each row 20 px high
- tooltip title, full role and "Chapter: Ch 1"
- no THROUGH THE AGES header for a books-only entry
- the cover shown together with the model, hidden by ShowMessage, and never shown without a PlayerModel

The dead isBook branch and the uncertain-era colours (COL.uncertain, amber) are gone.

**P2 pill click: FIXED in logic, but not working in game (see blocker 1).**
- Toast.lua:186-196: a left-click always opens the named veteran.
- Toast.lua:199-213: "+N more" is its own Button that calls `Browser.ShowZone(C.GetZoneName())`.
- Browser.lua:1141-1156: ShowZone uses Show/Refresh and never Toggle. An unknown zone leaves the list
  unfiltered.
- Toast.lua:314-318: SetMore also reaches queued pills.

All of this is tested. However, the new button never calls `C.RegisterClicks`. Every other Button in
the addon does: 14 call sites, plus the Compat.lua:123-124 rule, *"on Forever, OnClick never fires until
the button has registered click types"*. That rule has held since the first release. The test stub sets
RegisterClicks to a no-op, so the tests cannot catch this.

**P3 MetSummary wording: FIXED.** Core.lua:229-245 now gives "Met once, on 3 Oct 2026 with X" and
"Met 4 times · first on 3 Oct 2026 with X". The leading zero is built away by hand, the date call is in
a pcall, and the realm is dropped when it is your own.

## 2. Whole-addon review

**Load order.** The .toc order works: Compat → Data → SavedData → Core → Style → UI → Browser → Toast →
Minimap → Options.
- At load time, every file only uses ns.Compat or ns.Style, and both are defined earlier.
- Core uses ns.UI, ns.Minimap and ns.Toast only at runtime. ADDON_LOADED fires after all files have
  loaded.
- Options registers at PLAYER_LOGIN.

**Saved-data migrations.**
- v0.3 data has no schema and per-character `met[id] = time`. It goes account 0→2 and character 0→2,
  and is merged with the earliest time and a count.
- v0.4 data (schema 1/1) goes to 2/2 and is merged the same way.
- Leftover character lists are merged at every load, and a second run is harmless.
- Data from a newer schema is left untouched, with one chat line.
- test_saved_data and test_met cover all of this. **Safe.**

**API discipline.**
- Client-version calls go through Compat with pcall and the secret guard: UnitName, GetRealmName, map,
  model, icons, tooltips, timers.
- A few direct calls remain, all harmless:
  - `date`/`time` (the date call is in a pcall)
  - the Settings API in Options.lua (in pcall)
  - plain frame methods
- No per-frame work at rest:
  - The Toast OnUpdate runs only while a pill is shown.
  - The Minimap OnUpdate runs only while dragging.
  - The 2 s position ticker is cheap.
  - Indexes (veterans, related, byMap, browser items) are built lazily.

**Fit.**
- The same player-facing sentences appear in /wcl, /wcl id and /wcl why.
- Option labels match the /wcl help wording.
- There are no duplicated helpers: Options reuses ns.Guard and ns.ResetWindows.
- `ns.MeetCount` is only used by tests. That is acceptable as a test helper.

**Docs.**
- README, CHANGELOG v0.5.0 and the CurseForge description agree with the code on these points:
  - 100 veterans and 42 links
  - account-wide met
  - live 3D portrait, with Story first
  - /wcl why and /wcl options in the command lists
  - "+N more"
- The README test table now says that entries without coordinates are left out.
- The "Season of Discovery" README line is gone.

## 3. Blind A/B (whole addon)
A: a 2D masked portrait with Story at the bottom, per-character met, one chat line per nearby veteran,
112 entries with some unmeetable or SoD NPCs, no settings page, jargon in errors.

B: a live 3D model with a clean round crop and Story first, compact book rows, account-wide met with
counts, a calm batched alert, guards around every feature, a settings page, /wcl why, 100 clean
entries, nine test scripts.

**B preferred, about 85 % sure.** Labels: A = v0.4 (session/v0.4-related), B = v0.5 (session/v0.5).

## 4. Scores (v0.5 as a whole)
| # | Point | Score | Why |
|---|---|---|---|
| 1 | Polished look | 8 | Round model crop, Story first, consistent palette. Nits below |
| 2 | Player-facing text | 8 | Plain and consistent. "with X" and the two different "+N" counts are the nits |
| 3 | Nothing unfinished | 7 | The "+N more" button will not respond in game (blocker 1) |
| 4 | No Lua errors / API rules | 8 | Guards are well done. Click handlers outside the guards are a small gap |
| 5 | Cheap at runtime | 9 | Nothing runs per frame at rest; indexes are lazy |
| 6 | Lore accuracy | 8 | 100 sourced entries, stories 3–6 sentences, timeline handled ("set years later") |
| 7 | Tests | 8 | Broad coverage. The Toast stub hides the RegisterClicks gap |

## 5. Blocking faults

1. **"+N more" can never be clicked on Forever.** Toast.lua:199-202 creates `t.moreBtn` but never calls
   `C.RegisterClicks(t.moreBtn)`.
   - On Forever the OnClick at Toast.lua:206 then never fires.
   - Because the child button takes the mouse, a click on "+N more" also does not reach the pill.
   - So the button looks clickable (it highlights on hover) and does nothing. That is the main round-3
     fix, and it is half-working (yardstick 3).

   **Fix:**
   - Add `C.RegisterClicks(t.moreBtn)` after Toast.lua:202.
   - In tests/test_toast.py, make the stub `RegisterClicks` record the frame, and assert that the pill and
     `moreBtn` are both registered.
   - Better still, assert that every `Button` with an OnClick in Toast.lua is registered.

That is the only blocker. It is a one-line fix plus a test.

## 6. Non-blocking polish
- Count mismatch: with 7 veterans, the chat says "Also nearby: A, B, C +3 more" while the pill says
  "+6 more". Use the same meaning, or label the pill "+6 nearby".
- MetSummary "… with Arthas" reads as if you met the NPC together with Arthas. "as Arthas" is clearer.
  Change the comment at Core.lua:210 too.
- Click handlers run outside the guards, so an error there would reach the error frame instead of
  turning the window off with one line:
  - Toast.lua:186
  - Minimap.lua:114
  - Browser.lua:570
  - UI.lua:293

  Wrap them in `ns.Guard("window", "the lore window", …)`.
- Options.lua:92 builds a new guard on every click. Build it once per checkbox.
- PortraitCover.tga has COL.inner baked into its pixels. Make it white and call
  `SetVertexColor(unpack(COL.inner))`.
- Book rows (UI.lua:441-458) have no hover highlight. Add the same 0.14 violet `hl` that Related rows
  use.
- "Items in WoW: None recorded." appears on most entries. Hide the section when there are no items.
  The "· item ID n" text is also dev-flavoured.
- Tyrande has 6 game rows, 4 of them for Terror of the Tides. Merge them into one row per campaign.
- A custom `portrait` is hidden once the 3D model loads (UI.lua:217-220 and the onLoaded callback).
  README "Your own portraits" implies otherwise. Either fix the README wording or let a custom portrait
  win over the model.
- Leftover comments in shipped files:
  - Toast.lua:4 has ",," in its header comment.
  - Core.lua:101 and :152 still mention Season of Discovery IDs.
  - Data.lua has worker/critic notes at 1180, 2159, 2220, 2342, 2569-2570 and 2704, and an empty
    "Wetlands" header at 2954.
- The .toc `## Notes` lists only WC1/WC2/WC3. Add "and the Warcraft novels".
- Thin roles: Grosk "Appears in a vision", Faranell "Subordinate of Grand Apothecary Putress", Pozzik
  "A member of … (MEGA)".
- The Toast background colour `0.071, 0.059, 0.110` is hard-coded at Toast.lua:151 (from v0.4). Move it
  into Style.COL.

## 7. Must be checked in game before release (no offline test can prove these)
1. After the fix, clicking "+N more" opens the Veterans list filtered to the current zone. Also check:
   - a click on the pill body still opens the named veteran
   - right-click dismisses the pill
   - shift-drag still moves the pills
2. **3D model:**
   - SetCreature (by ID) and SetUnit (target) render the NPC.
   - OnModelLoaded fires, and GetModelFileID behaves as expected.
   - SetPortraitZoom(1) frames the face at 60 px.
   - The cover hole lines up with RingThin, with no square edges and no dark halo.
   - The 2D fallback shows when the model fails.
3. **Role icons exist in Forever:** INV_Misc_Note_01, INV_Sword_27, INV_Scroll_03, INV_Misc_Map_01 and
   INV_Misc_Book_09. Also check that the question-mark fallback triggers on a bad path.
4. **Settings page:** it appears under AddOns, `/wcl options` opens it (Settings.OpenToCategory with
   category:GetID()), the checkboxes stay in step with /wcl auto/alert/minimap, and Reset works.
5. **Migration with real data:** log in with a v0.4 SavedVariables file on two characters. Check that
   the met lists merge, the counter is unchanged or higher, and the MET tooltip shows a plausible
   "first … with/as Name".
6. **Entering Orgrimmar or Thunder Bluff:**
   - one immediate alert with sound
   - one "Also nearby" line, with no extra sound
   - "+N" on the pill
   - no chat spam
7. **Date and realm:** `date("%b %Y")` gives an English month on the client, and your own realm is
   dropped from the name.
8. **Combat and secret values:** `/wcl`, `/wcl why` and mouseover in combat give the plain "not sharing"
   line, with no Lua errors.
9. **Data spot checks:** run `/wcl id` on a few entries (Thrall, Saru Steelfury, Varimathras). Confirm
   that the Burning Anvil exists in Forever Orgrimmar, or change it to "in the Valley of Honor".
10. **Window layout:**
    - the book-row tooltip shows
    - the mouse wheel works in both lists and in the popup
    - MORPHEUS renders in the pill and the headers

## Verdict: **AVVIST**
v0.5 is clearly preferred (about 85 %), and every round-2 blocker is resolved in code. One blocker
remains: the new "+N more" button lacks `C.RegisterClicks`, so the round-3 feature is dead on Forever.
Fix that line and add the registration assert to test_toast.py. That lifts yardstick 3 to 8, and the
build is then GODKJENT without another full review.

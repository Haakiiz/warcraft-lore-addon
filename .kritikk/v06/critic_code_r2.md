# v0.6 code critic, round 2 (parts A, B, C)

Round-2 changes: `git diff 4a588c8..session/v0.6`. I read every changed file and the code around each change, and ran every test.
Blind A/B: each part has "Version 1" and "Version 2". Which one is the baseline is shown at the end.

## Tests (all green)
validate_db OK (exit 0), atlas 21/21, guard 30/30, mappins 29/29, met 18/18, options 16/16, portrait ok + layout ok,
related 7/7, saved_data 28/28, share 34/34, timeline ok, toast 10/10.

Text widths below are estimated at about 5.5 px per character for Friz at 11 px. These estimates are on the kind side.

---

## A Zone atlas (Browser.lua, tests/test_atlas.py)
**Preferred: Version 1 (confidence 65 %).** It has zone progress, the "This zone" shortcut and a filter row that fits again.

**Round-1 faults**
1. Campaign button cut off: **fixed.** Zone is 168 and Status 104 again (Browser.lua:32), and campaign = 456 − 168 − 104 − 16 =
   168, which leaves 137 px for its label. "Campaign All campaigns" (about 120 px) fits.
2. Zone button cuts off long zones: **fixed.** The label has 137 px. "Zone Stonetalon Mountains" (about 134 px) just fits.
3. "This zone" did not fit its button: **fixed.** It is now a text link in the count row, and its width comes from
   GetStringWidth (Browser.lua:1084-1104).
4. Layout test: **added** (test_atlas.py:105-127).

**New fault from the fix (blocking)**
1. **The zone progress line is now cut off for long zones.** Moving "This zone" into the count row shrank countText from
   280 px to CountRowWidth = 456 − book (about 93) − here (about 50) − clear (about 66) − 42 ≈ 205 px
   (Browser.lua:1033, :1126). The 6 px estimate in the test gives 182 px. Whenever a zone filter is combined with any
   other filter (Not met, a campaign, search, Hide book-only), the line gets "  -  showing N" (Browser.lua:796-798).
   Example: "Hillsbrad Foothills: 1 of 6 met  -  showing 5" is 45 characters, about 248 px, so it ends as "…met  -  sh…".
   The same happens for Stonetalon Mountains, Redridge Mountains, Alterac Mountains, Scarlet Monastery and, after part E,
   the Plaguelands zones. "Clear filters" is always visible in this state, so the narrowest case is the common one.
   The test only asserts `150 <= count_w` and never measures the strings that go in the space.
   - **Fix:** drop the zone name from the line, since the Zone button already shows it ("1 of 6 met here  -  showing 5"),
     or shorten it ("1/6 met · 5 shown"). Alternatively, hide "This zone" while it is dimmed because the list is already
     filtered to that zone, and give the text the space.
   - **Test:** assert that px(longest zone line with "showing NN") <= CountRowWidth, using the longest zone in Data.lua.

**Non-blocking**
- Nothing listens for ZONE_CHANGED, so the "This zone" dim state still goes stale while the list stays open.
- A dimmed "This zone" gives no tooltip or feedback when clicked.

| 1 Look | 2 Text | 3 Finished | 4 No errors | 5 Cheap | 6 Lore | 7 Tests |
|---|---|---|---|---|---|---|
| 7 | 9 | 8 | 9 | 9 | 10 | 7 |

**Verdict: AVVIST**

---

## B Export/import (Share.lua, Style.lua buildHeader, tests/test_share.py)
**Preferred: Version 2 (confidence 90 %).** The other version has no export or import.

**Round-1 fault**
1. Edit box wider than its scroll frame: **fixed.** `Share.EditWidth(WIDTH, S.BAND)` = 440 − 40 − 32 − 12 = 356 px, which equals
   the scroll width. It is tested (test_share.py:115-117).

**Round-1 polish that was done**
- buildHeader now returns `close, title`. Other callers keep only the first value, so they are unaffected. The fragile
  region scan is gone.
- Wheel scrolling works over the box.
- OnCursorChanged keeps the cursor in view.
- Exporting an empty list shows a hint.
- `first` is clamped to 2004–2100 and `count` to 99999, and both are tested.

**New faults (none blocking)**
- **Dead call (Share.lua:264):** `ns.UI.RefreshOpen` does not exist anywhere in the addon, so an open lore window still
  goes stale after an import. Either add the function or remove the call. As it stands it looks like a fix that does
  nothing.
- **Box height ignores the band again (Share.lua:215):** `HEIGHT − 64 − 48 − 12` = 126, but the view is
  250 − 2·20 − 64 − 48 − 12 = 86. A short string can still be wheel-scrolled about 40 px into empty space. Use
  `HEIGHT − 2 * S.BAND − 124`.
- **The export highlight fix rarely fires:** the box already has focus when it opens (Share.lua:292), so a click does not
  trigger OnEditFocusGained and still drops the highlight. Add OnMouseUp → HighlightText in export mode.
- **Empty-export wording:** "The string below is empty but valid." reads like developer wording. Suggest "You have not
  met any veterans yet, so there is nothing to export."
- **Clamping `first` up to 2004 lets a forged 0 win "earliest first".** It is harmless, but rejecting the entry
  would be cleaner.

| 1 Look | 2 Text | 3 Finished | 4 No errors | 5 Cheap | 6 Lore | 7 Tests |
|---|---|---|---|---|---|---|
| 8 | 8 | 8 | 9 | 10 | 10 | 8 |

**Verdict: GODKJENT.** Clean up the dead RefreshOpen call and the height before release.

---

## C World map pins (MapPins.lua, UI.ShowEntry `raised`, Core MarkMet, tests/test_mappins.py)
**Preferred: Version 1 (confidence 85 %).**

**Round-1 fault**
1. Lore window behind the map: **fixed.** A pin click calls `UI.ShowEntry(..., raised = true)`, which sets the frame to
   FULLSCREEN_DIALOG (UI.lua:600-605). That is above FULLSCREEN (Classic map) and HIGH/FULLSCREEN (Mainline windowed or
   maximised). The portrait/cover/ring children use only relative SetFrameLevel and no strata of their own, so they
   follow the parent. The tooltip is hidden before the window opens. A Related link (keepPlace) keeps the raised level,
   and any other open goes back to DIALOG.

**Round-1 polish that was done**
- A right-click no longer opens the story.
- MarkMet calls MapPins.Refresh, which does nothing until the map is hooked and returns early while the map is hidden.
  It is guarded by pcall and ns.Guard, and tested.

**Non-blocking**
- The pin still eats the right-click, so the map does not zoom out over a pin. In Mainline, use
  `pin:SetPassThroughButtons("RightButton")` (pcall), or `RegisterForClicks("LeftButtonUp")` plus pass-through.
- After the map closes, the lore window stays at FULLSCREEN_DIALOG until the next normal open. It then sits above the
  Esc menu and other DIALOG windows. Reset to DIALOG in OnHide (UI.lua:501) or when the map hides.
- The test checks that the `raised` flag is passed, not that UI.ShowEntry really changes the strata. Add a small
  UI test.

| 1 Look | 2 Text | 3 Finished | 4 No errors | 5 Cheap | 6 Lore | 7 Tests |
|---|---|---|---|---|---|---|
| 8 | 9 | 8 | 9 | 8 | 10 | 8 |

**Verdict: GODKJENT**

---

## In-game checks
1. Veterans list: pick Hillsbrad Foothills and Not met, and check the count line (expected to be cut off until A is fixed).
   Also check the "This zone" link colour, hover and dim state.
2. /wcl export: no clipped right edge, the wheel does not scroll into empty space, and the highlight stays after a click.
3. Click a map pin with the map open, both windowed and maximised: the lore window must be on top. Close the map and
   press Esc to check the window order.

## Blind labels revealed
- A: Version 1 = v0.6, Version 2 = v0.5 baseline
- B: Version 1 = v0.5 baseline (no feature), Version 2 = v0.6
- C: Version 1 = v0.6, Version 2 = v0.5 baseline (no feature)

In every part the new v0.6 version was preferred. B and C pass. A is rejected on one new truncation fault.

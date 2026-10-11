# v0.6 code critic, round 1 (parts A–D)

Branch session/v0.6 compared with session/v0.5 (`git diff session/v0.5...session/v0.6`). I read all the code and ran every test.
Blind A/B: each part has "Version 1" and "Version 2". Which one is the baseline is shown at the end.

## Tests (all green)
validate_db OK, saved_data 28/28, related 7/7, timeline OK, options 16/16, guard 30/30, met 18/18,
portrait ok + layout ok, toast 10/10, atlas 13/13, share 30/30, mappins 26/26.

Text widths below are estimated from Friz/Arial-class advance widths at 11 px. That works out to about 5.5 px per lowercase letter.
FRIZQT tends to be a little wider than Arial, so the estimates are on the kind side.

---

## A Zone atlas (Browser.lua, tests/test_atlas.py)
**Preferred: Version 2 (confidence 60 %).** It adds useful zone progress: counts in the zone popup, the
"Orgrimmar: 3 of 8 met" line, and a "This zone" shortcut. To make room for "This zone", it makes the
filter row visibly worse.

| 1 Look | 2 Text | 3 Finished | 4 No errors | 5 Cheap | 6 Lore | 7 Tests |
|---|---|---|---|---|---|---|
| 6 | 9 | 8 | 9 | 9 | 10 | 8 |

**Blocking faults**
1. **Campaign button is cut off by default.** In Browser.lua:32 and :992, campaignW = 456-150-62-96-24 = 124, which leaves
   about 93 px for the label. "Campaign All campaigns" is about 120 px wide, so the default, unfiltered state already shows
   "Campaign All ca…". A picked campaign shows only about 40 px of its name ("Campaign The I…" for
   The Invasion of Kalimdor (Orc)). The v0.5 version had about 137 px for this label.
2. **Zone button now cuts off long zones.** The label gets 150-31 = 119 px. "Zone Stonetalon Mountains" is about 134 px and
   "Zone Western Plaguelands" about 133 px, so both are cut off. Both fitted in v0.5's 137 px. Part E adds more long names:
   Eastern Plaguelands, Stranglethorn Vale, Swamp of Sorrows.
3. **"This zone" probably does not fit its own button.** At Browser.lua:1010, a 62 px button has 44 px for the label, and
   "This zone" is about 47–48 px.
   - **Fix (one of these):** move "This zone" out of the filter row, either as a text link in the count row next to
     "Clear filters" or as a 22 px icon button with a tooltip, and restore Zone 168 / Status 104. Alternatively, drop the
     muted prefix ("Zone "/"Campaign ") when a value is picked and add a hover tooltip with the full value.
   - **Test needed:** add a layout test that fails if CONTENT_W − sum(widths) − gaps leaves the campaign label under
     about 130 px.

**Non-blocking**
- The "This zone" dim state is only recomputed in updateFilterButtons. Nothing listens for ZONE_CHANGED, so the state goes
  stale if the player changes zone while the list is open.
- The same dim colour means two things: "already filtered to this zone" and "nothing here".
- A click on a dimmed button gives no feedback.
- countText (Browser.lua:1045) is fixed at 280 px. "Eastern Plaguelands: 10 of 12 met  -  showing 10" will be close to
  that limit after part E.
- zoneCounts is dropped on every Refresh, including every search keystroke, and then recounted. That is O(n) and cheap,
  but the comment says "built on demand".

**Verdict: AVVIST**

---

## B Export/import (Share.lua, Core.lua COMMANDS, tests/test_share.py)
**Preferred: Version 1 (confidence 85 %).** The other version has no export or import at all.

The string format is sound:
- It has a version prefix and a checksum.
- Whitespace and line breaks are stripped before reading.
- A cut-off or damaged string is rejected before anything is written.
- The merge rules are right: the earliest `first` wins and drops `by`, the larger count wins, nothing is deleted, and
  unknown IDs are skipped. Importing the same string twice changes nothing more.
- No new globals: only the named frame WarcraftLoreShare.
- Esc works both ways: UISpecialFrames handles it when the box is not focused, and OnEscapePressed when it is.

| 1 Look | 2 Text | 3 Finished | 4 No errors | 5 Cheap | 6 Lore | 7 Tests |
|---|---|---|---|---|---|---|
| 7 | 9 | 9 | 9 | 10 | 10 | 8 |

**Blocking fault**
1. **Edit box is wider than its scroll frame.** At Share.lua:209, `b:SetWidth(WIDTH - 2 * 24 - 12 - 16)` gives 364 px. That
   formula assumes the band is 24 px, but Style.BAND is 20. The real width is
   inner 400 − holder insets 32 − scroll insets 12 = 356 px. The ScrollFrame clips its child, so about 8 px (one
   character) at the right end of every wrapped line is hidden, both in the export text and in pasted text.
   - **Fix:** `b:SetWidth(WIDTH - 2 * S.BAND - 32 - 12)` or `b:SetWidth(scroll:GetWidth())` after anchoring.

**Non-blocking polish**
- The fixed `SetHeight(400)` lets the mouse wheel scroll about 270 px into empty space for short strings.
  Use a small height and let the multi-line box grow.
- There is no OnCursorChanged handler, so a long paste does not scroll to the cursor.
- In export mode the highlight is lost after one click into the box. Add OnEditFocusGained → HighlightText in export mode.
- Exporting an empty met list gives "WCL1:~xxxx" without any hint. Say "You have not met any veterans yet."
- The title is found by scanning `inner:GetRegions()` for the export title. It works, but it is fragile.
- A hand-edited string with a valid checksum can set first = 0 (shown as 1970) or a huge count. Clamp first to at
  least 2004 and count to a sane maximum.
- "Imported N veterans" counts NPC IDs, not merged veterans.
- After an import, only the Browser refreshes. An open lore window or the minimap counter stays stale until it is reopened.
- No test covers the window itself: the title switch, the Import button hidden on export, and Esc.

**Verdict: AVVIST** (one-line fix)

---

## C World map pins (MapPins.lua, Options.lua, Core ns.ZONE_MAPS, tests/test_mappins.py)
**Preferred: Version 2 (confidence 80 %).**

**API check against the Blizzard_MapCanvas code shared by Mainline 11.x/12.x and the Classic-family clients:**
- `MapCanvasMixin:OnMapChanged` and `MapCanvasMixin:OnCanvasScaleChanged` both exist as methods on WorldMapFrame, so
  `hooksecurefunc(WorldMapFrame, ...)` is valid. The ScrollContainer calls `GetMap():OnCanvasScaleChanged()` after
  `Child:SetScale()`. Mainline's WorldMapMixin overrides OnMapChanged but still defines it.
- Hooking runs after the original, so the canvas size is already set when layout runs.
- Parenting to `GetCanvas()` (= ScrollContainer.Child) and using `SetScale(1/canvasScale)` with offsets of `x*w/s` matches
  exactly what Blizzard's own `MapCanvasPinMixin` does (`ApplyCurrentScale` / `SetPosition`). Panning is free because the
  pins move with the canvas.
- Taint risk is low:
  - hooksecurefunc and HookScript are taint-safe.
  - Plain child frames do not go through AcquirePin or the pin pools (the HereBeDragons-style taint source).
  - No protected calls.
- Maps that are not in ZONE_MAPS get no pins at all, so there are no wrong positions on continent, city-sub or dungeon maps.
- alsoIn zones correctly get no pin, because the coordinates belong to the main zone.
- The Mainline IDs in ZONE_MAPS (10 Northern Barrens, 64 flooded Thousand Needles, 62 rebuilt Darkshore, and others) would
  place Classic coordinates wrongly. In practice they are dead code, because the .toc is Interface 16001 only.
  Note this if Mainline is ever targeted.

| 1 Look | 2 Text | 3 Finished | 4 No errors | 5 Cheap | 6 Lore | 7 Tests |
|---|---|---|---|---|---|---|
| 8 | 9 | 7 | 9 | 8 | 10 | 9 |

**Blocking fault (verify in game; fix cheaply anyway)**
1. **The lore window may open behind the world map.** "Click to read the story" (MapPins.lua:89-94) calls
   `UI.ShowEntry`, whose frame is DIALOG strata (UI.lua:491). The Classic-family WorldMapFrame (and Mainline when it is
   maximised) runs at FULLSCREEN strata, which is above DIALOG. The window would then open behind the map, invisible
   until the map is closed, which makes this a half-working feature.
   - **Fix:** in the pin OnClick, open the lore window above the map. For example, set the lore frame's strata to
     FULLSCREEN_DIALOG when `WorldMapFrame:GetFrameStrata()` is FULLSCREEN or higher, and restore it on hide.
     Another option is to close the map first.

**Non-blocking**
- `C.RegisterClicks` registers "AnyUp" (MapPins.lua:71), so a right-click on a pin opens the story instead of zooming the
  map out. Register only "LeftButtonUp" for pins.
- During the smooth zoom animation, OnCanvasScaleChanged fires every frame. Each time, layout hides every pin, restyles it,
  calls GroupMet and shows it again. It is cheap for fewer than 20 pins, but a scale-only path (SetScale + SetPoint)
  would be cleaner.
- Hiding a hovered pin each frame can make the tooltip flicker.
- Pins are not refreshed when a veteran is met while the map is open.
- Holder level is canvas + 100, so pins may sit over quest POIs and flight points. Check in game.

**Verdict: AVVIST** (pending the strata fix, or proof in game that the lore window opens on top of the map)

---

## D Polish (UI.lua, Toast.lua, .toc Notes, Data.lua comments, PortraitCover tint)
**Preferred: Version 1 (confidence 85 %).**
- The "None recorded." filler is gone, and the Items section is hidden when it is empty.
- Book rows get a hover highlight.
- Related-row clicks and pill clicks are now guarded.
- Dev comments are gone from Data.lua, and the duplicate Wetlands/Durotar header is fixed.
- The ",," in the Toast comment is fixed.
- The .toc Notes are better.
- PortraitCover.tga is verified white with an alpha hole, and the `SetVertexColor(COL.inner)` tint gives the same 100d18
  as before while keeping the colour in Style.lua.
- Tests cover all of it.

| 1 Look | 2 Text | 3 Finished | 4 No errors | 5 Cheap | 6 Lore | 7 Tests |
|---|---|---|---|---|---|---|
| 9 | 9 | 9 | 9 | 10 | 10 | 9 |

No blocking faults. Minor: an error in a pill click now turns off the whole "alert" feature, because it shares the guard
key with the batch flush. That is acceptable and matches the design.

**Verdict: GODKJENT**

---

## In-game checks needed
1. Veterans list: check that "Campaign All campaigns", "This zone", "Zone Stonetalon Mountains" and a picked long campaign
   are not cut off (after the A fix).
2. Zone popup: the right-hand "3/8" column lines up and does not touch long zone names.
3. "This zone" in Orgrimmar (filters), in a zone with no veterans (dim, no action), and after walking to another zone with
   the list open.
4. /wcl export: the whole string is visible with no clipped right edge. Ctrl+C, then /wcl import on a second
   account/character merges correctly and shows the right chat line. Esc closes the window both while focused and
   while unfocused.
5. World map: pins in Durotar and Orgrimmar at the right spots; size stays constant while zooming; maximise/minimise
   works; no pins on the continent map.
6. Click a map pin with the map open: the lore window must be visible on top. Right-click on a pin should not steal the
   map zoom-out.
7. Turn the option off and on with the map open and closed. Watch for any taint or "blocked action" message after combat
   with the map open. Run /wcl debug afterwards.
8. 3D portrait: the round crop colour matches the window background (tint).

## Blind labels revealed
- A: Version 1 = v0.5 baseline, Version 2 = v0.6
- B: Version 1 = v0.6, Version 2 = v0.5 baseline (no feature)
- C: Version 1 = v0.5 baseline (no feature), Version 2 = v0.6
- D: Version 1 = v0.6, Version 2 = v0.5 baseline

In every part the new v0.6 version was preferred. Only D passes this round.

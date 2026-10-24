# Code QA report: WarcraftLore (interface 16001)

Scope: every Lua file in `WarcraftLore/` except the data tables in `Data.lua` and `Memorials.lua`. No repo file was edited.

## Verdict

I found no CRASH-level bug that a player would hit in a normal first session. I found no WRONG-level bug either. I found 3 MINOR robustness gaps, all of which need an earlier failure to trigger.

## Tests

- `py -3 -I tests/validate_db.py` passes: 131 entries, 12 memorials, no duplicate NPC IDs, all fields valid.
- All 17 `tests/test_*.py` pass: achievements 59/59, atlas 24/24, guard 30/30, journal OK, locale 36/36, mappins 31/31, memorials 79/79, met 18/18, options 16/16, portrait OK, related 7/7, saved_data 28/28, share 38/38, theme 33/33, timeline OK, toast 13/13, widths 201/201.
- The `-I` flag breaks the tests on this machine. `lupa` is installed in the user site-packages, and `-I` (isolated mode) ignores that directory. With `py -3 -I` every `test_*.py` fails with `ModuleNotFoundError: No module named 'lupa'`. Without `-I` they all pass. `validate_db.py` needs no lupa, so it passes either way. Nothing needs installing. Run the tests as `py -3 tests/test_x.py`.

## What I checked, all clean

- **Locale keys:** 267 distinct `L["..."]` keys are used in code. deDE and frFR each define all 267, with no extras and no `%s` / `%d` placeholder mismatches. A missing key would also be harmless, because `ns.L` has an `__index` that returns the key itself.
- **`string.format` arguments:** a script checked every `L["..."]:format(...)` call for placeholder count against argument count. There are no mismatches.
- **Texture paths:**
  - All paths use `\\` and are built from `ADDON_NAME` (`Interface\\AddOns\\WarcraftLore\\Textures\\`).
  - All 16 referenced `.tga` files exist. Each is uncompressed, with power-of-two dimensions, at 24 or 32 bits.
  - `Portraits/` holds only a README. No `Data.lua` entry sets `portrait`, so no missing-texture path is used.
- **Load order against the TOC:**
  - Every file is listed in the TOC.
  - `Compat`, `Locale` and the locale files load first.
  - `Core` only touches `ns.Style`, `ns.UI`, `ns.Minimap` and the like at ADDON_LOADED, so loading it before Style is safe.
  - File-level uses of `ns.Guard` (in Toast, MapPins, Options and Share) come after Core.
- **SavedVariables:**
  - `SavedData.Load` runs first at ADDON_LOADED.
  - Every reader (`metEntry`, `visitEntry`, `stored`, `hideBookOnly`, `settings()`, `ApplyTheme`) type-checks.
  - `db.schema` values from newer versions are left alone.
  - Old per-character `met` data is merged safely and idempotently.
  - Position tables are type-checked (only a hand-corrupted `x` or `point` could still break `SetPoint`).
- **Midnight secret values and nil-prone APIs:**
  - `UnitGUID`, `UnitName`, `UnitExists`, `GetRealmName`, `GetLocale`, `GetBestMapForUnit`, `GetMapInfo` and `GetPlayerMapPosition` all go through `pcall`, a type check and `issecretvalue`.
  - `GetPlayerMapPosition` returns nil in instances, and that is handled.
  - Tooltip post-calls are wrapped in `pcall`, and `data.guid` is secret-checked.
  - `ITEM_TEXT_BEGIN`, `NAME_PLATE_UNIT_ADDED` and `PLAYER_TARGET_CHANGED` handlers assume nothing about their arguments.
  - `GetItemInfo` is not used anywhere.
- **Combat lockdown:** there are no `SecureActionButton`, `SetAttribute`, `RegisterStateDriver` or `InCombatLockdown` uses. No protected frames are created, so none are touched in combat.
- **Lua 5.1 syntax:** the grep for `goto`, `<const>`, `utf8`, `table.unpack`, `//`, `math.pow` and `unpack` found nothing.

## Findings

### 1. MINOR: Browser row click does not check that the lore window is available

**Where:** `WarcraftLore/Browser.lua:834-845`, together with `WarcraftLore/UI.lua:489-528` and `UI.lua:493`.

**Scenario:** `UI.Init` assigns `frame` on its first statement, then builds the rest. If any later step errors on a client quirk, the guard turns the "window" feature off and the error is reported once. `frame` stays non-nil, though, so the `if frame then return end` check in later `UI.Init()` calls makes them return early. After that, a click on a Browser row calls `ns.UI.ShowEntry(...)` unguarded. `ShowEntry` indexes `nameText`, `scroll` and `content`, which are all nil. That throws a Lua error to the client's error frame on every click.

Core and Toast already check `ns.FeatureOff("window")` before calling the UI; the Browser row click does not.

**Fix:**
```diff
 r:SetScript("OnClick", function(self)
     closePopup()
-    if self.item then
+    if self.item and not ns.FeatureOff("window") then
```
The same check belongs in `Browser.lua:840-842`, where both `ShowMemorial` and `ShowEntry` are called.

### 2. MINOR: Entry points outside the guard

**Where:**
- `Minimap.lua:122-132`: the button's OnClick calls `ns.ShowTarget()` (the raw `cmdShow`), `ns.Journal.Toggle()` and `ns.Browser.Toggle()` directly.
- `Toast.lua:339-352`: the banner OnClick.
- `Toast.lua:75-106`: the toast `onUpdate` runs every frame and is unguarded.
- The Browser, Journal and Share widget handlers.

**Scenario:** these entry points are not wrapped in `ns.Guard`, unlike the tooltip, alert, slash-command and options paths. If Browser or Journal construction ever errors on an unexpected client difference, every minimap click raises a new error. An error in the toast `onUpdate` would repeat every frame, which would be much worse than the one-time chat line the guard gives.

I did not find a concrete error in any of these paths, and the mock-client tests cover them. This is defence in depth only.

**Fix for the minimap:**
```diff
-    button:SetScript("OnClick", function(_, mouseButton)
+    button:SetScript("OnClick", ns.Guard("minimap", L["the minimap button"], function(_, mouseButton)
         ...
-    end)
+    end))
```

**Fix for the toast:** wrap `onUpdate` the same way. Since it can disable the feature, use something like `t:SetScript("OnUpdate", ns.Guard("alert", L["the nearby alert"], onUpdate))`.

### 3. MINOR: `Share.lua` leaves a named frame behind if building the edit box fails

**Where:** `WarcraftLore/Share.lua:225-290`.

**Scenario:** `build()` creates the named frame `WarcraftLoreShare` and adds it to `UISpecialFrames`. It then returns nil if `C.CreateEditBox` or the setup `pcall` fails. `frame` stays nil, so every later `/wcl export` or `/wcl import` creates another frame with the same global name and registers the name in `UISpecialFrames` again.

This needs the EditBox API to fail, which is not expected on this client. The result is leaked frames only, with no error.

**Fix:** on those two failure paths, `f:Hide()` and `f:SetParent(nil)`, or create the EditBox before the named frame.

## Things worth knowing (not bugs)

- `MapPins.lua:305-316` does its setup on `PLAYER_LOGIN` and on `ADDON_LOADED` for `Blizzard_WorldMap`. If the world map loads before WarcraftLore's own ADDON_LOADED, `WarcraftLoreDB` is still nil. I traced that path: `MP.Enabled`, `isMet`, `GroupMet` and `metEntry` all tolerate a nil db. The palette tables are updated in place by `ApplyTheme`, so no stale colours result. No change is needed.
- `Style.RequestTheme` writes to `StaticPopupDialogs["WARCRAFTLORE_THEME"]`. That is a normal pattern and not a taint risk for `ReloadUI`.
- `Compat.C.After(fn, seconds)` swaps the argument order of `C_Timer.After`, and all three callers use it correctly.

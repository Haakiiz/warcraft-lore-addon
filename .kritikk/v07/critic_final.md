# Critic v0.7 – final, whole addon (achievements, Lore Journal, localisation)

Reviewed: `git diff origin/main...session/v0.7` (37 files): Achievements.lua, Journal.lua,
Toast.ShowAchievement and banner click, Minimap shift-click, SavedData migration 3, Locale.lua,
Locales/deDE.lua, Locales/frFR.lua, L[] lookups in every file, .toc, CHANGELOG, tests and workflows.
Yardstick: .kritikk/v05/HANDOFF.md. Round-1 report: .kritikk/v07/critic_ach_r1.md.

## Tests (all green)
validate_db OK (130 entries) · achievements 59/59 · atlas 22/22 · guard 30/30 · journal ALL OK ·
locale 28/28 · mappins 31/31 · met 18/18 · options 16/16 · portrait ok/layout ok · related 7/7 ·
saved_data 28/28 · share 38/38 · timeline ok · toast 13/13. All scripts are listed in tests.yml and
release.yml.

## Round-1 blocking faults
| # | Status | Evidence |
|---|---|---|
| B1 unreachable at the cap | FIXED | `LEVEL_CAP = 30` + `ZONE_LEVEL` table (Achievements.lua:19-45); a veteran is reachable when any of its zones is open; zones/circles/milestones get `later`; games count only reachable veterans; Journal sorts later rows last, dims them (alpha 0.55), adds the tooltip line, summary shows "· N later" and leaves them out of the total. 97/130 reachable, 10/39 later. Tested. |
| B2 possessive | FIXED | Achievements.lua:220 (`%s' Circle` / `%s's Circle`), test "no s's Circle anywhere". |
| B3 earned turns grey | FIXED | Achievements.lua:286 `done = progress >= total or earned ~= nil`; Journal fills the bar and shows the date; test "earned but progress short". |
| B4 raw IsShiftKeyDown | FIXED | Minimap.lua:122 uses `C.IsShiftDown()`; tooltip has a "Shift-click  Lore Journal" line. |

Round-1 polish also done: book steps kept together, warmer titles, "Across the Ages" text matches its
rule, one line + one sound when a meet earns an achievement, no sound with alerts off, Journal refreshes
on every meet, banner left-click opens the Journal, capitalised first-run line.

## Blind A/B
A = session/v0.7, B = origin/main (labels picked at random, revealed here).
Preferred: **A**, confidence ~80 %. A adds a fair, data-driven achievement system, a calm Journal in the
addon's own style and a clean localisation framework (English keys, safe fallback, Compat.GetLocale)
with no regressions for English players. It loses on how the German and French text fits the
fixed-width UI and on a handful of wrong or clumsy translations, not on its base.

## Scores
| # | Point | Score | Why |
|---|---|---|---|
| 1 | Polished look, Style.lua | 7 | English UI is fine. In deDE/frFR, labels overflow fixed widths: the Options buttons (text spills past the 170 px frame), the Show filter button, the count row and the campaign button (blocking B1, B2). Banner still unclamped. |
| 2 | Clear text | 7 | English is now clean. Translations are mostly natural and use WoW client terms (Erfolg errungen, anvisieren, Namensplakette, Minikarte, PNJ, haut fait, Maj-clic, barre de nom), but several lines are wrong or mixed-language (B3), and every date shows an English month (B4). |
| 3 | Nothing unfinished | 8 | Features are complete and degrade cleanly. CHANGELOG still says "(in progress)" and lists only the translation (B5). |
| 4 | No Lua errors, Compat | 9 | GetLocale through Compat with enUS fallback; pcall around every cross-module call; IsShiftDown fixed; DB type checks. |
| 5 | Cheap at runtime | 9 | Defs built once; List only on show/meet; banner OnUpdate only while shown; locale lookups are one table index. |
| 6 | Lore accuracy | 8 | Built only from validated data and Related links; lore stays English by design. |
| 7 | Tests | 8 | Locale test checks keys, stray keys, placeholders, colour codes and that the strings format. The width checks in test_atlas only cover English, and test_journal fakes GetStringWidth = 40, so none of the overflows below are caught. |

## Blocking faults

**B1. Options buttons overflow in deDE/frFR.** Options.lua:110-118 builds 170x24 buttons with a
centred FontString that has no width. At 12 pt, "Fensterpositionen zurücksetzen" (~190 px) and
"Réinitialiser les positions des fenêtres" (~250 px) spill past the button border; "Ouvrir la liste des
vétérans" is borderline. Fix: `b:SetWidth(math.max(170, math.ceil(fs:GetStringWidth()) + 24))` after
SetText, and/or shorter text: de "Fenster zurücksetzen", fr "Recentrer les fenêtres".

**B2. Veterans list filter and count row overflow in deDE/frFR** (by the project's own 6 px/char
metric in tests/test_atlas.py).
- Show button (Browser.lua:33, `STATUS_BTN_W = 104`, room 86 px = 14 chars): "Zeige Nicht getroffen"
  (21), "Zeige Getroffen" (15), "Afficher Non rencontrés" (23), "Afficher Rencontrés" (19) are cut
  off with an ellipsis. English "Show Not met" is 12.
- Campaign button (room 137 px = 22 chars): "Campagne Toutes les campagnes" (29) is cut off, and
  "Kampagne Alle Kampagnen" (23) is borderline.
- Count row (Browser.lua:1063): German book toggle + "Diese Zone" + "Filter löschen" leave ~92 px for
  the count text, French leaves ~80 px (the test requires ≥ 150). "Alle 130 Veteranen angezeigt" and
  "Les 130 vétérans sont affichés" are cut off.
Fix: shorter strings (de: Show "Zeige" → drop the prefix or use "Nur", status "Alle / Begegnet /
Offen", "Nur-Buch-Figuren ausblenden" → "Ohne Buchfiguren"; fr: "Afficher" → "Voir", status
"Tous / Rencontrés / Restants", "Toutes les campagnes" → "Toutes", "Effacer les filtres" → "Effacer",
"Masquer les livres seuls" → "Sans les livres"), or measure the labels and size the buttons. Extend
test_atlas so the width checks run for deDE and frFR as well.

**B3. Wrong or mixed-language translations** (corrected text):
- frFR `Hide book-only` = "Masquer les livres seuls" means "hide the lone books". Use "Sans les livres".
  `Hide book-only veterans in the list` → "Masquer les vétérans présents uniquement dans les livres".
- frFR `Met once, on %s as %s` "… le %s avec %s" reads as "met together with <character>". Use
  "Rencontré une fois, le %s (%s)" and `Met %d times · first on %s as %s` → "Rencontré %d fois · la
  première fois le %s (%s)". Also `· first on %s` → "· la première fois le %s".
- frFR `Veterans of the Frozen Throne` "Vétérans de The Frozen Throne" → "Vétérans du Trône de glace";
  deDE "Veteranen des Frozen Throne" → "Veteranen des Frostthrons".
- `The Forsaken Kingdom`: the Forsaken are "Verlassene"/"Réprouvés" in the clients. deDE → "Das Reich der
  Verlassenen", frFR → "Le royaume des Réprouvés".
- deDE `Journal` = "Chronik" while the window title is "Lore-Journal": the button and the window it opens
  must have the same name. Use "Journal" (or "Chronik" + "Lore-Chronik" everywhere).
- deDE `/wcl test – … (small pill, …)` "kleine Pille" reads as medication. Use "kleiner Hinweis".

**B4. English month names in every date.** Journal.lua:53 and Core.lua:234 use `date("%b %Y")`. In WoW
that is always the C locale ("Oct"), so German players see "Errungen am 3 Oct 2026" and French players see
"Accompli le 3 Oct 2026", in every earned row and in the met tooltip. Fix: one shared helper that uses
`date("%d.%m.%Y")` for deDE, `date("%d/%m/%Y")` for frFR, and the current format for English, or a
translated month table (`L["Oct"]` …). Add a test.

**B5. CHANGELOG v0.7.0 is unfinished.** It still says "(in progress)" and lists only the translation. It
must contain:
- Achievements: 39 of the addon's own achievements, generated from the data (milestones, games with book
  steps, zones, circles, Across the Ages), stored account-wide.
- Achievements that need zones above level 30 wait as "later" and open up when the cap rises.
- Lore Journal: `/wcl journal`, the Journal button in the Veterans list, Shift-click on the minimap
  button, category filters, progress bars and earned dates.
- The gold banner: left-click opens the Journal, right-click closes it. One chat line and one sound,
  and no sound when alerts are off.
- Existing players get their achievements silently on first login (one line pointing to /wcl journal).
- German and French interface; the stories, names and zones stay English.
- `/wcl reset` also resets the Journal.

## Polish (non-blocking)
- **"This zone" is dead in deDE/frFR for most zones.** C.GetZoneName (Compat.lua:284) returns the
  localised map name ("Wald von Elwynn", "Les Tarides"), so it does not match the English names in
  Data.lua (Browser.lua:1291). The bug is older than v0.7, but v0.7 is what brings German and French
  players in. Fix: look the zone up by uiMapID through the zone → uiMapID table in Core.lua:545.
- A later achievement that is done by progress (for example after `/wcl import`) shows a full bar but
  is dimmed with "Needs zones above level 30". Award it, or at least drop that line when progress is
  full.
- Game achievements count only reachable veterans, but the text says "Meet every veteran from …". Add a
  tooltip line such as "Counts the N veterans you can reach at level 30."
- The banner (Toast.lua ShowAchievement) still has no `SetClampedToScreen(true)`. Check it near the
  bottom of the screen.
- Journal chip "Meilensteine" (~64 px at 10 pt) in a 62 px chip: it may touch the edges. Consider
  "Etappen".
- The "GETROFFEN" / "RENCONTRÉ" badge is ~2.5x wider than "MET" and sits after up to 6 game badges
  (UI.lua:538). Check that a 6-game veteran's header still fits.
- frFR: `|cff40ff40ON|r` = "ACTIVÉE" is feminine singular but also goes into "Les alertes de proximité
  sont maintenant %s". Use separate keys or "activées". `%s is off after an error…` "%s : désactivé…"
  gets a feminine subject: use "Désactivé après une erreur jusqu'au /reload : %s. …".
- frFR minor: "Aucun moyen d'ajouter des infobulles" → "Impossible de se greffer aux infobulles dans ce
  client"; "AUCUN DOSSIER" → "PAS ENCORE DE FICHE"; "Étapes" → "Jalons"; "Journal du lore" is OK, but
  "Journal des légendes" reads better.
- deDE minor: "Getroffen" can read as "hit" in a combat game; "Begegnet / Nicht begegnet / VETERANEN
  BEGEGNET" is clearer. "Stufengrenze" → "Maximalstufe" ("kommt, wenn die Maximalstufe steigt"). Use
  "Account" consistently (the client says accountweit; the file mixes Konto and Account). `Meet %s and
  everyone tied to them.` → "Triff %s und den ganzen Kreis." "Zeige" → "Anzeigen".
- On a meet that earns an achievement the Journal refreshes twice (Check + MarkMet). This is trivial.
- Locale.lua says zone and NPC names stay English. Mention that on the CurseForge page so German and
  French players expect English stories.

## Checked and fine
- .toc order: Compat → Locale → Locales/deDE → Locales/frFR → Data → SavedData → Core → Achievements →
  Style → UI → Browser → Journal → Toast → Minimap → MapPins → Options → Share. Each file only uses
  members defined earlier while it loads (L at load in Core/Browser/Achievements/Journal; Style before
  Journal/Toast; Achievements only touches Core/Data functions lazily).
- No new globals besides the named frame WarcraftLoreJournal. Locale files return early in the wrong
  client.
- All placeholders and colour codes match (test_locale), and no translated key is unused or missing.
- Migration 3 only adds `achievements = {}`. Met data is untouched, and newer or odd data is left alone.
  It is safe for v0.6.1 users (schema 2 → 3). The first run is silent apart from one line.
- No per-frame work when idle.

## Must check in game
1. A German and a French client (Battle.net language): Options page buttons, Veterans list filter row
   and count row with "Clear filters" showing, Journal chips, banner, met badge on a 6-game veteran.
2. Earned dates once B4 is fixed.
3. Icons Achievement_Level_10 / Achievement_Reputation_01 / INV_Misc_Spyglass_03 in Forever.
4. Banner position when the alert anchor is near the bottom of the screen; left/right click.
5. Shift-click on the minimap button opens the Journal; plain click still opens the list.
6. First login on a v0.6.1 account: one "You already have N achievements" line, no banner, no sound.

## Verdict: **AVVIST**
All four round-1 blocking faults are fixed, and the English build is good and preferred over main. The
new localisation brings five blocking faults: UI overflow in deDE/frFR (B1, B2), wrong or mixed-language
lines (B3), English month names (B4) and an unfinished CHANGELOG (B5). Scores 1 and 2 are 7. All five
are small, local fixes; test_atlas's width checks should cover the translations so this stays fixed.

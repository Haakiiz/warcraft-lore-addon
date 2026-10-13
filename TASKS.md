# TASKS – WarcraftLore-addon

Status: [x] ferdig · [ ] gjenstår. Etter hvert checkpoint: STOPP og vent på godkjenning fra Håkon (bare han kan kjøre addonen i spillet).

## Checkpoint 1: fungerende prototype
- [x] Undersøke API: hva er interface 16001 / WoW Forever (Classic-API?), med kilde
- [x] Compat-lag: alle versjonsavhengige kall samlet i én fil
- [x] TOC med `## Interface: 16001`
- [x] Tooltip-linje «Warcraft-veteran: WCx» bare for NPC-er i databasen
- [x] Vindu: auto-åpning ved target, lukkbart, flyttbart, husker posisjon
- [x] Standardtekst for ukjente NPC-er
- [x] Kommandoer: /wcl, /wcl id, /wcl auto
- [x] Database (egen datafil) med 3–5 kildebelagte NPC-er, minst én i Orgrimmar
- [x] Testskript utenfor spillet (format + unike ID-er), kjørt og bestått
- [x] README.md: installasjon + test-NPC-er med sone og koordinater
- [x] Oppsummering: Venter på meg / Laget / Usikkert → STOPP
- [x] **Godkjent av Håkon i spillet** (debug: build 1.60.1, interface 16001, issecretvalue/TooltipDataProcessor/BackdropTemplate finnes, ingenting mangler)

## Checkpoint 2: Orgrimmar og The Barrens
- [x] Gå gjennom Orgrimmar (260 NPC-er fra Wowhead Classic; lagt til Nazgrel, Vol'jin, Grunt Maug)
- [x] Gå gjennom The Barrens (374 NPC-er; lagt til Apothecary Helbrim som usikker)
- [x] Testskript passerer (8 oppføringer); røyktest i fengari OK; telling + bortvalgte rapportert
- [x] Godkjent av Håkon («gå til neste checkpoint»)

## Mellomsteg: nytt UI (fiolett ramme med turkise bladranker, slide 8 i mockup-decket)
- [x] Teksturer generert med tools/make_textures.py → WarcraftLore/Textures/*.tga
- [x] UI.lua skrevet om: rund portrettramme med glød i spillfarge (delt ring), ett felt per spill, seksjoner
- [x] All tekst i addonen + Data.lua på engelsk; confidence = "confirmed"/"uncertain"; valgfritt felt portrait
- [x] Testskript + røyktest OK
- [ ] Håkon tester utseendet i spillet

## Checkpoint 3: Undercity og Silverpine Forest
- [x] Gå gjennom Undercity (237 NPC-er; lagt til Sharlindra, Apothecary Keever, Lexington Mortaim (uncertain); FK-opptredener for Sylvanas/Varimathras)
- [x] Gå gjennom Silverpine Forest (143 NPC-er; lagt til Dalar Dawnweaver, Snarlmane (uncertain))
- [x] Ny spillkode FK = Warcraft III Reforged: Forsaken Kingdom (farge 9bd46a)
- [x] Testskript passerer (13 oppføringer); røyktest OK
- [x] Håkon: «Forsaken Kingdom er med», gå videre til CP4 (tolket som godkjent; UI-test i spillet ikke bekreftet ennå)
- Metodenotat: Wowhead-sonelister kan hentes med scratchpad/fetch_npcs.py (urllib virket for meg, men ga 403 for en subagent);
  tilbakelenkesjekk: scratchpad/backlinks.py <soneId…>.

## Checkpoint 4: Stonetalon Mountains og avslutning
- [x] Gå gjennom Stonetalon Mountains (132 NPC-er; Rexxar, Misha, Witch Doctor Jin'Zil (uncertain))
- [x] README på ENGELSK: hvordan legge til NPC selv + test-NPC-er (mangler fortsatt Stonetalon-radene)
- [x] Liste over alle navn gitt til Håkon; TODO.md med alle soner (inkl. Forever-sonene) laget
- [x] Stonetalon-radene lagt i README-tabellen
- [x] Røyktest kjørt på nytt: grønn med 16 NPC-er
- [ ] Håkon tester CP4 i spillet (Rexxar, Misha, Jin'Zil + nytt UI)
- [ ] Testskript passerer; telling + bortvalgte per sone → STOPP

## Gauntlet-løkke: flere soner (startet 2026-10-03, ukesgrense 80 % → stopp ved ~90 %)
Målestokk: .kritikk/referanse/malestokk.md. Arbeidere skriver til scratchpad/gauntlet/<sone>.lua + <sone>_report.md.
Kritiker = ny subagent hver runde, blindtest mot referanse_gazlowe.lua. Maks 3 runder per deloppgave.
Sjekk get_usage mellom hver runde.
- [x] D1 Durotar – GODKJENT runde 1 (Gar'Thok 3139, min. poeng 9). Lagt inn.
      Funn: Reforged 1.33-tilleggene i Twilight of the Gods ble fjernet i 1.36.1 (bekreftet selv) → fjernet fra Nazgrel.
      Kritikeren gjettet referansen fra malestokk.md → referansenavnet fjernet fra målestokken.
- [ ] D2 Dustwallow Marsh – runde 1 AVVIST (Jaina-setning uten kilde, Jaina-rolle, Tervosh WWD, tilfeldige heltenavn). Runde 2: arbeider retter.
      Funn: heltenavn reversert 1.36.1, gjenopprettet 2.0 (Cry of the Warsong-noten). Beslutning: tilfeldige heltenavn = "uncertain" (også Dalar).
      Blindtest lekket (kritiker så Data.lua) → referansefil synket med Data.lua.
- [x] D3 Mulgore + Thunder Bluff – GODKJENT runde 1 (Cairne 3057, Baine 2993). Lagt inn.
- [x] D4 Desolace + Feralas – GODKJENT runde 1 (Shandris Feathermoon 3936, min. 9). Lagt inn (rolle strammet inn).
- [x] D2 Dustwallow – GODKJENT runde 2 (min. 9): Jaina, Tervosh*, Karman*, Torq*, Draz'Zilb, Tharg, Do'gol, Ogg'marr. Lagt inn
      (Jaina-historiens rekkefølge rettet etter kritikerens punkt c; revert-noten henvist til Cry of the Warsong).
- [ ] D5 Ashenvale + Darkshore – arbeider: Athrikus Narassin (3660, item-lore i A Blaze of Glory). 8 SoD-NPC-er med bare
      heltenavn-likhet droppet av orkestratoren (SoD-ID-er >212000, ingen oppdrag). GODKJENT runde 1 (min. 9). Lagt inn.
      Gazlowe's Charm (13088) fjernet fra Gazlowe: to kritikere påpekte at ren navnelikhet ikke er en «riktig kobling».
- [ ] D6 Hillsbrad + Alterac – arbeider: Mug'thol (2257), Ansirem Runeweaver* (2543). Mugthol's Helm (navnelikhet) fjernet.
      GODKJENT runde 1 (Mug'thol rent; Ansirem 7 på krit. 1 = iboende for "uncertain", formulering rettet). Lagt inn.
- [ ] D7 Tirisfal + W. Plaguelands – arbeider: Uther (232920, SoD-ID), Gregory (231500/232932, SoD-ID), Araj (1852), Gordo (10666).
      Runde 1 AVVIST (Araj skulle vært uncertain; Uther-rolle slått sammen for 4 oppdrag). Rettet av orkestratoren
      (kvote 88 %): Araj → uncertain+searched; Uther delt (Blackrock and Roll = helt, resten dialog); SoD-setning fjernet. Lagt inn.
      Rettelsene sjekkes av sluttkritikeren. SoD-ID-er beholdt: sterk kobling, og en NPC som ikke finnes gir ingen støy.
- [x] Sluttkritiker: AVVIST (Thrall's Resolve og Seal of Sylvanas var navnelikhet; inkonsekvent Reforged-/kampanjenavn).
      Rettet av orkestratoren: begge items fjernet, navn og merking samkjørt, Dalar fikk samme forbehold, Jin'Zil fikk kilde.
      Ikke kjørt ny sluttkritiker (ukesgrense 88 %). Testskript + røyktest grønne med 36 NPC-er.
- 2026-10-04: GitHub-repo laget: https://github.com/Haakiiz/warcraft-lore-addon (privat). Håkon: bruk opptil 100 % ukesgrense.
  Ferdig og pushet: BOOK-kode, alsoIn (Rexxar/Misha), nærhetsvarsel via navneskilt (/wcl alert).
  Bok-koblinger: arbeider → kritiker (Pained AVVIST: Tides of War-handling presentert som bakgrunn) → rettet av orkestratoren → lagt inn på PR #1 (40 NPC-er).
  Darnassus: Tyrande + Fandral (AVVIST runde 1 → rettet av orkestratoren → lagt inn på PR #1). Teldrassil: 0. Totalt 42 NPC-er.
  STOPPET ved 97 % ukesgrense (2026-10-04). PR #1 merget til main 2026-10-04; grenen er slettet.
- STOPPET ved 88 % ukesgrense (2026-10-03). Neste: Teldrassil/Darnassus, Thousand Needles, Alterac Valley (Drek'Thar), Forever-sonene.
- [ ] Sluttkritiker for helheten + røyktest

## Notater (for å overleve oppsummering av samtalen)
- BESLUTNING 2026-10-03: All tekst i addonen (UI-tekst og lore i Data.lua) skal være på ENGELSK fremover,
  så andre kan bruke den. De eksisterende norske oppføringene må oversettes. Samtalen med Håkon er fortsatt på norsk.
- UI-redesign planlagt: rundt portrett (egen .tga hvis den finnes, ellers WoW-portrettet), glød i spillets farge
  (WC1 #c9a46a, WC2 #e0533f, BtDP #b07cf0, WC3 #f0a24a, TFT #7cc7ef), delt ring for flere spill.
  Utkast: https://claude.ai/artifact/JuLGDNSXMV4aR93MhM9Rjq. Håkon lager mockups i slides i en annen chat.
- Forever 16001 = build 1.60.1, bygger på **Mainline/Midnight 12.x-API-et**, IKKE Classic.
  Kilder: wowforeverguides.com/addons/developers, github.com/RestedXP/RXPGuides/pull/390,
  classicwowforever.com/guides/wow-forever-addons-api-compatibility/.
  Følger: secret values (issecretvalue), TooltipDataProcessor, RegisterForClicks må kalles, GetItemInfo mangler.
- Ingen Lua-tolk på maskinen. tests/validate_db.py (Python) har egen Lua-tabell-leser.
  Røyktest av Lua-koden: fengari i nettleserpanelet med WoW-stubber (scratchpad/harness.lua + harness.html, servert med python http.server).
- NPC-ID-er/koordinater: Wowhead Classic. g_mapperData på npc-siden har koordinatene (hent via JS i nettleserpanelet).
  Item-søk: wowhead.com/classic/items/name:<navn>. Lore: warcraft.wiki.gg.
- Metode per sone (gjenbruk i CP3/CP4), i nettleserpanelet på wowhead.com:
  1. NPC-liste: `g_listviews.npcs.data` på wowhead.com/classic/zone=<id> (Undercity 1497, Silverpine 130, Stonetalon 406).
  2. Wiki-API (origin=*): hent wikitekst for alle NPC-navn, og søk etter WC-termer.
  3. Sammenlign navn mot kategoriene «Warcraft III campaign …», «Warcraft II units» osv. (rekursivt).
  4. Tilbakelenker fra alle 186 oppdragssider (kategoriene «Warcraft III: Reign of Chaos orc campaign» osv.).
     Maks ca. 1 forespørsel per 0,7 s, ellers gir wikien 429.
  5. Les oppdragssidene (`index.php?title=<X>_(WC3_Orc)&action=raw`) for navngitte karakterer.
- Lore-feller: Thrall er IKKE med i «The Hunter of Shadows» (Groms kapittel). Rehgar Earthfury: fant ikke bevis for at han er med i TFT, så han er utelatt.
- 2026-10-04: Coordinate-based nearby alert added (Compat.GetPlayerMapPos/InInstance/StartTicker, Core.lua ticker). Branch session/coord-alert. Not tested in game; Classic and Mainline uiMapIDs both listed.
- 2026-10-05: Nearby alert now shows an on-screen toast (Toast.lua, max 3, click/right-click/shift-drag) plus RaidNotice center text; /wcl test added. Branch session/alert-toast. Not tested in game.

## Gauntlet 2026-10-09: Veterans-vindu (/wcl list) + met-telling
Referanse: lore-vinduet (UI.lua), rendret til PNG. Målestokk: .kritikk/referanse/malestokk_ui.md. Harness/renderer: scratchpad/harness.
- [x] D0 Renderer: mock-UI -> PNG (fengari + PIL), scratchpad/harness/shoot.py. Ferdig.
- [x] D1 Design (skisse https://claude.ai/artifact/MbntNB3SBpgSvBQVs1gq5j): runde 1 AVVIST (tooltip, glød, duplikat-Gregory), runde 2 GODKJENT (alle >= 8, blindtest likeverdig).
- [x] D2 Robusthet/korrekthet: GODKJENT runde 1 (8/8/8/9/8). Småfeil N1 (søk holder fokus), N2 (catcher sluker klikk), N6, N11 tas i D1.
- [x] D3 Docs + helhet: sluttkritiker runde 1 AVVIST, runde 2 GODKJENT (9/9/8/8/8). Merget som PR #7, v0.3.0 lastet opp til GitHub + CurseForge 2026-10-09.

## Gauntlet-løkke: «Sagaen om Warcraft Lore» – simulert suksess-tidslinje (startet 2026-10-09, grense 80 % av 5-timersvinduet)
Målestokk: .kritikk/referanse/malestokk_simulering.md · kontrakt: simulering/CONTRACT.md · kritikkfiler: .kritikk/SIM_*/
- [x] T1 story.js – 3 runder: AVVIST (6/6/7), AVVIST (8/8/8, telleren motsa ekte tall første dager), rettet av orkestratoren (anchors + småfeil)
- [~] T2 chart.js – runde 1 AVVIST (graf 6: fylte ikke flaten, nedtur usynlig, lite endepunkt). Rettet av orkestratoren, ikke kritisert på nytt
- [~] T3 index.html – runde 1 AVVIST (mobil: kort over graf; hero 7). Mobil + metric per kapittel rettet; hero ikke endret
- [~] Sluttkritiker: AVVIST knapt (hero 7, polish 7, resten 8–9; leveransen likeverdig/bedre i blindtest). Rettet: HUD skjules etter
      tidslinjen, HUD viser månedstall i nedturskapitler, mini-kurven sier 2,1 mill. Ikke kritisert på nytt (92 % av 5-timersvinduet).
      Gjenstår: hero (tom høyre halvdel, tooltip ved ringkanten). Publisert v2: https://claude.ai/artifact/2hq7XRetf3PKrCvDYLs2WC

## WC2-UI eksempelbilde (gauntlet-loop, 2026-10-12)
Målestokk: .kritikk/referanse/malestokk_wc2.md · arbeidsmappe: .kritikk/wc2ui/ · maks 3 kritikerrunder per del
- [x] D1 Stilsett — r1 AVVIST, r2 GODKJENT (min 8/10). Igjen: synlig 256px-flis i lær, FK-grønn ~ MET-grønn
- [x] D2 Veterans-vinduet — r1 AVVIST, r2 AVVIST (avkuttet navn), r3 GODKJENT (min 8/10)
- [x] D3 Lore-vinduet (lore.html) — r1 GODKJENT (min 8/10); finpuss + ny render etter kit-endring
- [x] Helhet — r1 AVVIST (ulik tittelhøyde/knapper), r2 GODKJENT; publisert på Design-canvas, venter på Håkons godkjenning

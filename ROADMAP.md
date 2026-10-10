# ROADMAP – Warcraft Lore

Funksjoner som den simulerte tidslinjen «Sagaen om Warcraft Lore» antar at addonen får
(se `simulering/story.js` og https://claude.ai/artifact/2hq7XRetf3PKrCvDYLs2WC),
med forslag til hvordan de kan bygges. Laget 2026-10-10.

Status: [x] finnes allerede · [ ] gjenstår.
Versjonsnummeret i parentes er der simuleringen legger funksjonen, ikke et løfte.

> Viktig: WoW Forever (interface 16001) bygger på **Mainline/Midnight 12.x-API-et**, ikke Classic
> (se notatene i TASKS.md). Forslagene under bruker derfor Retail-API der ikke noe annet står.
> API-navnene er forslag og må sjekkes med `/wcl debug` eller i spillet før de tas i bruk.

## Finnes allerede (v0.1.0–v0.3.0)

- [x] Tooltip-linje «Warcraft Veteran: WC3 · TFT», én farge per spill
- [x] Lore-vindu med rundt portrett og glød i spillets farge
- [x] Nærhetsvarsel (navneskilt + kartkoordinater), toast og `/wcl test`
- [x] BOOK-koblinger, og filter for å skjule rene bokoppføringer
- [x] Veteranliste `/wcl list` med søk og filtre for spill, sone og kampanje
- [x] Møtt-teller per karakter (`WarcraftLoreCharDB`), f.eks. «WC3: 12/40»
- [x] Minimapknapp (`/wcl minimap`)
- [x] `/wcl auto`, `/wcl alert`, `/wcl reset`, `/wcl id`, `/wcl debug`
- [x] Vern mot «secret values» (`issecretvalue` + `pcall` i Compat.lua)
- [x] Validering av databasen utenfor spillet (`tests/validate_db.py`)
- [x] Automatisk pakking til CurseForge (`.github/workflows/release.yml`)

## 1. Data og kjerne

- [x] **Relaterte NPC-er** (0.3): følg tråden Thrall → Nazgrel → …
      Feltet `related = { 3230, ... }` i Data.lua, vist som klikkbare rader («Related») i lore-vinduet.
      Det holder å skrive koblingen på én side. `validate_db.py` sjekker at ID-ene finnes, og `tests/test_related.py` tester oppslaget.
      15 koblinger er lagt inn så langt. Flere kan legges til etter hvert som sonene fylles.
- [x] **Schema-versjon for lagrede data** (`SavedData.lua`, testet av `tests/test_saved_data.py`).
      `schema` i både `WarcraftLoreDB` og `WarcraftLoreCharDB`, og en liste med migreringer som kjøres ved `ADDON_LOADED`.
      Data fra en nyere versjon blir ikke rørt. En migrering som feiler, prøves igjen ved neste innlasting.
- [ ] **Kontodekkende møtt-teller** (1.3): det du har møtt på én karakter teller på alle.
      *Forslag:* flytt tellingen til `WarcraftLoreDB`, og migrer eksisterende `WarcraftLoreCharDB` inn ved første innlogging.
- [ ] **Telle antall møter**, ikke bare møtt/ikke møtt. Gir grunnlag for statistikk som «mest møtte veteraner» (3.2).
- [ ] **Eksport og import av møtt-listen** som tekststreng (1.3).
      *Forslag:* LibSerialize + LibDeflate (`EncodeForPrint`), vist i en tekstboks man kan kopiere fra.
- [ ] **Bedre søk** med apostrofer og delvis treff, f.eks. «mugthol» → Mug'thol (1.3).
      *Forslag:* normaliser både søkeord og navn (fjern `'`, `-` og mellomrom, gjør alt til små bokstaver).
- [ ] **Fulltekstsøk** i lore-tekstene (3.0).
      *Forslag:* bygg en enkel ordindeks første gang søket brukes, ikke ved innlasting.

## 2. Kart og navigasjon

- [ ] **Kartnåler på verdenskartet**, farget etter spill (0.4), med filter per spill (ønske i simuleringen).
      *Forslag:* biblioteket **HereBeDragons-2.0 + HereBeDragons-Pins**. Koordinatene finnes allerede i Data.lua.
- [ ] **Sone-atlas**: sjekkliste over veteraner per sone (1.1).
      *Forslag:* gjenbruk veteranlisten med fast sonefilter, og vis «3/8 møtt» per sone.
- [ ] **Spor en veteran med pil** ved høyreklikk på en nål (1.1).
      *Forslag:* bruk **TomTom** hvis det er installert (`TomTom:AddWaypoint`), i stedet for å lage egen pil.
- [ ] **Lore-stier**: guidede tråder som «Thrall til Orgrimmar», med en kort fortelling per stopp (2.1).
      *Forslag:* en ordnet liste `{ npcId, tekst }` per sti, og TomTom-waypoints mellom stegene.

## 3. Samling og belønning

- [ ] **Achievements** per spill, per sone og totalt, med toast (0.6).
      *Merk:* addons kan ikke lage ekte Blizzard-achievements. Lag et eget system og gjenbruk Toast.lua.
- [ ] **Lore Journal**: egen fane med sider som låses opp når du møter veteraner (1.0), senere med søk (3.0).
- [ ] **Lore Week**: dobbel møtt-teller i en bestemt uke (3.1).
      *Forslag:* datosjekk med `C_DateAndTime.GetCurrentCalendarTime()`.
- [ ] **Delbare veterankort i chatten** (3.1).
      *Forslag:* egen lenke `|Hwclvet:ID|h[Thrall]|h`, håndtert ved å hooke `SetItemRef`.
      Spillere uten addonen ser bare teksten.

## 4. Språk og klienter

- [ ] **Oversettelser**: deDE og frFR (0.5), esES og ruRU (0.7), ptBR, koKR og zhCN (2.2). Språkvalg uten omstart.
      *Forslag:* en `L`-tabell for UI-tekst. Lore-tekstene legges i egne **LoadOnDemand**-addons per språk
      (`WarcraftLore_deDE`, med `## LoadOnDemand: 1`), lastet med `C_AddOns.LoadAddOn`. Da ligger bare valgt språk i minnet.
- [ ] **Fontstøtte for koreansk og kinesisk** (2.2).
      *Forslag:* bruk klientens standardfont (`STANDARD_TEXT_FONT`) i stedet for en fast font.
- [ ] **Bygg for Classic Era og Retail** ved siden av Forever (1.2).
      *Forslag:* flere `.toc`-filer (`WarcraftLore_Vanilla.toc`, `WarcraftLore_Mainline.toc`) med felles kode.
      Compat.lua har allerede samlet versjonsavhengige kall. Classic har andre uiMapID-er og mangler `issecretvalue`.

## 5. Ytelse og robusthet

- [ ] **Samle varsler** når mange veteraner står i samme by (1.2).
      *Forslag:* buffre `NAME_PLATE_UNIT_ADDED` i 1–2 sekunder med `C_Timer.After`, og vis én samlet toast.
- [ ] **Raskere lister** med 350+ oppføringer, og ingen hakking i atlas eller Dalaran (1.1, 3.1).
      *Forslag:* bygg lister først når de åpnes, gjenbruk rader og cache oppslag på NPC-ID.
- [ ] **Tåle at en patch endrer API-et** (1.3.1, 2.0). *Dette er det viktigste punktet i simuleringen.*
      Der knakk navneskilt-API-et i en patch, og addonen kastet Lua-feil.
      *Forslag:* slå av bare funksjonen som feiler (f.eks. nærhetsvarselet) og skriv én melding i chatten,
      i stedet for å kaste feil hver gang. Utvid mønsteret som allerede finnes i Compat.lua.
- [ ] **Portretter fra spillet** også når NPC-en ikke er target (2.0).
      *Forslag:* `SetPortraitTexture` når enheten finnes, ellers en 3D-modell med `PlayerModel:SetCreature(npcId)`.
- [ ] **Innstillingsside** i spillets meny (1.0).
      *Forslag:* `Settings.RegisterCanvasLayoutCategory` (Mainline-API).
- [ ] **Rydde gamle innstillinger** fra 0.x (3.2). Løses av schema-versjonen i del 1.

## 6. Fellesskap

- [ ] **Bidragsformat for lore-rettelser** (3.0): fast format for nye NPC-er og rettelser.
      *Forslag:* en GitHub-mal (issue/PR template), og kjør `tests/validate_db.py` automatisk i GitHub Actions på hver PR.
- [ ] **Sone-dekning** følger level cap i Forever: 40 (1.0), 50 (2.0), 60 (3.0). Se TODO.md for sonelisten.

## Små ting fra spillersitatene i simuleringen

- [ ] Forklar `/wcl auto` på CurseForge-siden, så folk vet at auto-åpning kan slås av
- [ ] Musehjul-scroll i lange lister (står også som test i TODO.md)
- [ ] Behold titler uoversatt der det er naturlig (Thrall = «Warchief»)
- [ ] Debug-hjelp for «veteraner jeg ikke finner»: vis hvorfor en NPC ikke registreres (feil ID, mangler koordinater, i instans)

## Anbefalt rekkefølge

1. Schema-versjon + robusthet ved API-endringer. Billig nå, dyrt senere.
2. Relaterte NPC-er og kontoteller (bygger på møtt-telleren som finnes).
3. Kartnåler + TomTom + sone-atlas.
4. Achievements og Lore Journal.
5. Oversettelser og flere klienter.

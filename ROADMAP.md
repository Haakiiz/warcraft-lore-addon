# ROADMAP – Warcraft Lore

**Mål: 1000 downloads på CurseForge.**
Nå: **59** (2026-10-15, v0.8.0). Siden: https://www.curseforge.com/wow/addons/rts-veterans

Status: [x] ferdig · [~] delvis · [ ] gjenstår · ★ = størst effekt på downloads.

> Addonen har allerede mer innhold enn de fleste lore-addons (130 veteraner, journal, 41 achievements,
> kartnåler, minnesmerker, to temaer, tre språk). Det som stopper veksten nå er **synlighet og publikum**,
> ikke funksjoner. Derfor kommer markedsføring og flere spillklienter før nye funksjoner i denne planen.
>
> Merk: CurseForge teller hver nedlasting av en fil, også når appen oppdaterer addonen for en eksisterende
> bruker. Jevne, ekte oppdateringer (f.eks. annenhver uke) gir derfor både flere tellinger og plass på
> «Recently updated». Ikke lag tomme versjoner bare for tellingens skyld.

## Måling

Skriv inn tallet fra CurseForge-siden hver mandag.

| Dato       | Downloads | Versjon | Hva skjedde siden sist |
|------------|----------:|---------|------------------------|
| 2026-10-15 |        59 | v0.8.0  | Utgangspunkt           |

## Milepæl 1 – Butikkvinduet (59 → 100)

Folk som finner siden skal forstå addonen på fem sekunder. Billig, og må gjøres først.

- [~] ★ **Oppdater CurseForge-beskrivelsen** (`media/curseforge-description.md`): skrevet om 2026-10-15 med
      v0.7 og v0.8 (Journal, achievements, minnesmerker, tysk/fransk, WC2-temaet). Gjenstår: lime den inn på CurseForge.
- [ ] ★ **Nye skjermbilder i WC2-temaet** + én kort GIF (target Thrall → tooltip → lore-vindu → achievement-banner).
      Hovedbildet er det første folk ser i søket. De seks bildene i galleriet viser det gamle utseendet.
- [ ] **Kategorier og tagger på CurseForge**: legg til «Achievements», «Map & Minimap», «Roleplay» og «Quests & Leveling»
      i tillegg til dagens, så addonen dukker opp i flere lister.
- [x] **Forklar `/wcl auto`** og hvordan man slår av alerts på siden (avsnittet «Too chatty?» i beskrivelsen).
- [ ] **Spilltest-gjelden** (se TODO.md og TASKS.md): alert-pill, minimapknapp, toast-teksturer, `/wcl list`, WC2-temaet.
      Én Lua-feil i første økt gir avinstallasjon og en dårlig kommentar.

## Milepæl 2 – Bli funnet (100 → 250)

- [ ] ★ **Lore-innlegg der Forever-spillerne er**: Forever-subreddit og Discord.
      Ikke «sjekk ut addonen min», men «Visste du at denne NPC-en i Barrens var med i et Warcraft III-oppdrag?»
      med et skjermbilde, og lenken nederst. Én historie per innlegg; 130 veteraner = mange innlegg.
- [ ] **Last opp til Wago Addons og WoWInterface** i tillegg til CurseForge.
      Packageren støtter begge (`WAGO_API_TOKEN`, `WOWI_API_TOKEN` + `X-Wago-ID`/`X-WoWI-ID` i .toc).
      Teller ikke mot CurseForge-målet, men gir nye brukere og ryktespredning.
- [ ] **Gjør GitHub-repoet offentlig** og lenk til det fra CurseForge (Source/Issues). Gir tillit og bidragsytere.
- [ ] **Svar på hver kommentar** på CurseForge innen et døgn, og nevn rettelsen i changelogen.

## Milepæl 3 – Større publikum (250 → 1000)

Forever er en liten klient. De store publikumene er Classic Era/Anniversary og Retail.

- [ ] ★★ **Classic Era-bygg** (`WarcraftLore_Vanilla.toc`). Det meste av databasen er hentet fra Wowhead Classic,
      så NPC-ID-ene og koordinatene passer allerede. Compat.lua samler de versjonsavhengige kallene.
      *Gjenstår:* Classic har andre uiMapID-er, mangler `issecretvalue`, har ikke `Settings.RegisterCanvasLayoutCategory`
      på alle klienter, og Season of Discovery-ID-ene (Uther, Gregory) finnes bare der.
      Krever at du (eller en tester) kan logge inn på Classic. Dette er det enkeltpunktet som kan gi flest downloads.
- [ ] ★ **Retail-bygg** (`WarcraftLore_Mainline.toc`). Samme API som Forever, men mange NPC-er har ny ID, nytt sted
      eller er borte etter Cataclysm. Krever en egen gjennomgang av dataene, sone for sone. Gjør Classic Era først.
- [ ] **Delbare veterankort i chatten** (`|Hwclvet:ID|h[Thrall]|h`, hook på `SetItemRef`). Andre spillere ser lenken
      og spør hva det er – gratis reklame inne i spillet.
- [ ] **Flere språk**: esES og ruRU (store CurseForge-publikum), senere ptBR, koKR, zhCN.
      `L`-tabellen fra v0.7 finnes; koreansk og kinesisk trenger `STANDARD_TEXT_FONT`.

## Milepæl 4 – Folk kommer tilbake (holder tallet oppe)

- [ ] **Nye soner når level cap stiger** i Forever: Mount Hyjal (Renewed), Dalaran, Shen'dralas, Riverglades,
      Zephras Isle (se TODO.md). Hver sone = en oppdatering med en nyhet å poste om.
- [ ] **Spor en veteran med pil** via TomTom (`TomTom:AddWaypoint`) ved høyreklikk på en kartnål.
- [ ] **Lore-stier**: guidede tråder som «Thrall til Orgrimmar», en kort tekst per stopp, TomTom mellom stegene.
- [ ] **Lore Week**: dobbel møtt-teller én uke (`C_DateAndTime.GetCurrentCalendarTime()`) – en grunn til å poste.
- [ ] **Fulltekstsøk** i lore-tekstene (ordindeks bygget første gang søket brukes).
- [ ] **Raskere lister** med 350+ oppføringer: bygg ved åpning, gjenbruk rader, cache på NPC-ID.
- [ ] **Bidragsformat** for nye NPC-er og rettelser: GitHub issue-mal + `tests/validate_db.py` i Actions på hver PR.

## Ferdig (v0.1–v0.8)

- [x] Tooltip-linje, lore-vindu med 3D-portrett, «Through the ages» og «Related» (v0.1–v0.5)
- [x] Nærhetsvarsel med samlede varsler i byer, `/wcl test`, `/wcl why` (v0.1–v0.5)
- [x] Veteranliste med søk (ignorerer apostrof), filtre og sone-atlas (v0.3–v0.6)
- [x] Kontodekkende møtt-teller med antall og første møte; eksport/import (v0.5–v0.6)
- [x] Kartnåler på verdenskartet (v0.6)
- [x] Innstillingsside, schema-versjon med migreringer, vern mot API-endringer i patcher (v0.4–v0.5)
- [x] Lore Journal med 41 achievements og banner (v0.7)
- [x] Minnesmerker: 12 graver, plaketter og monumenter (v0.7)
- [x] Tysk og fransk grensesnitt (v0.7)
- [x] Warcraft II-tema som standard, med bryter til klassisk utseende (v0.8)
- [x] Automatisk utgivelse til CurseForge ved tag (`.github/workflows/release.yml`)

## Anbefalt rekkefølge

1. Milepæl 1 i sin helhet (en kveld eller to): beskrivelse, bilder, GIF, tagger, spilltest.
2. Første lore-innlegg på Reddit/Discord samme uke som de nye bildene er oppe.
3. Classic Era-bygget. Størst effekt, men mest arbeid og krever testing på en Classic-klient.
4. Deretter én synlig nyhet per oppdatering (chatlenker, språk, nye soner), hver med et eget innlegg.

Bakgrunn: den simulerte tidslinjen «Sagaen om Warcraft Lore» (`simulering/story.js`,
https://claude.ai/artifact/2hq7XRetf3PKrCvDYLs2WC) var kilden til mange av funksjonsønskene over.
API-navn i forslagene må sjekkes med `/wcl debug` eller i spillet før de tas i bruk.

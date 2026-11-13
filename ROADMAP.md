# ROADMAP – Warcraft Lore

**Mål: 2000 downloads på CurseForge** (første delmål 1000).
Nå: **ca. 170** (2026-11-13, v1.1.0). Siden: https://www.curseforge.com/wow/addons/rts-veterans

Status: [x] ferdig · [~] delvis · [ ] gjenstår · ★ = størst effekt på downloads.

> **Strategi (Håkon, 2026-11-13): ingen aktiv markedsføring.** Ingen Reddit- eller Discord-innlegg.
> Veksten skal komme av seg selv: en side folk forstår på fem sekunder, en addon som ikke gir feil,
> flere språk, spillere som deler veteraner i chatten, og jevne, ekte oppdateringer.
> Uten markedsføring og uten Retail er 1000–2000 et realistisk mål. 10 000 krever Retail (se «Senere»).
>
> Merk: CurseForge teller hver nedlasting av en fil, også når appen oppdaterer addonen for en eksisterende
> bruker. Jevne, ekte oppdateringer (f.eks. annenhver uke) gir derfor både flere tellinger og plass på
> «Recently updated». Ikke lag tomme versjoner bare for tellingens skyld.

## Måling

Skriv inn tallet fra CurseForge-siden hver mandag.

| Dato       | Downloads | Versjon | Hva skjedde siden sist |
|------------|----------:|---------|------------------------|
| 2026-10-15 |        59 | v0.8.0  | Utgangspunkt           |
| 2026-10-20 |        69 | v0.8.1  | Ny beskrivelse og nye skjermbilder; v0.8.1 (minnesmerke-filtre, Ansirem) |
| 2026-11-13 |  ca. 170  | v1.1.0  | v0.9–v1.1: bibliotek, Classic Era-bygg, Forever-lansering, færre falske varsler |

## Milepæl 1 – Butikkvinduet

Folk som finner siden skal forstå addonen på fem sekunder.

- [x] ★ **CurseForge-beskrivelsen** (`media/curseforge-description.md`) holdes lik siste versjon. Må limes inn på
      CurseForge av Håkon etter hver større utgivelse.
- [~] ★ **Skjermbilder i WC2-temaet** lages med `tools/uishots`. En kort GIF gjenstår (krever opptak i spillet).
- [ ] **Kategorier og tagger på CurseForge**: legg til «Achievements», «Map & Minimap», «Roleplay» og
      «Quests & Leveling», så addonen dukker opp i flere lister. (Gjøres av Håkon på CurseForge-siden.)
- [ ] **Lenk til GitHub fra CurseForge** (Source og Issues). Repoet er offentlig.
- [ ] **Spilltest-gjelden** (se TODO.md og TASKS.md): én Lua-feil i første økt gir avinstallasjon.

## Milepæl 2 – Addonen sprer seg selv

- [ ] ★ **Delbare veteraner i chatten**: Share-knapp og `/wcl share`. Spillere uten addonen ser en lesbar tekst,
      spillere med addonen får en klikkbar lenke.
- [ ] ★ **Flere språk**: spansk, russisk og brasiliansk portugisisk (store CurseForge-publikum).
      Senere koKR og zhCN, som trenger `STANDARD_TEXT_FONT`.
- [ ] **Velkomst ved første innlogging**: én chatlinje som forteller hva addonen gjør og hvor nærmeste veteran er,
      så nye brukere ser noe med en gang.
- [ ] **Bidragsformat**: GitHub issue-maler for rettelser og nye NPC-er. Testene kjører allerede på hver PR.
- [ ] **Svar på hver kommentar** på CurseForge, og nevn rettelsen i changelogen.

## Milepæl 3 – Folk kommer tilbake

- [~] ★★ **Classic Era-bygg** (`WarcraftLore_Vanilla.toc`) er utgitt. Gjenstår: test i Classic-klienten.
- [ ] **Nye soner og NPC-er i Forever** etter hver patch: kjør `tools/research/forever_scan.py` (se TODO.md).
      Hver runde er en ekte oppdatering.
- [ ] **Lore-stier**: guidede tråder som «Thrall til Orgrimmar», en kort tekst per stopp.
- [ ] **Lore Week**: dobbel møtt-teller én uke (`C_DateAndTime.GetCurrentCalendarTime()`).
- [ ] **Fulltekstsøk** i lore-tekstene (ordindeks bygget første gang søket brukes).
- [ ] **Raskere lister** med 350+ oppføringer: bygg ved åpning, gjenbruk rader, cache på NPC-ID.

## Senere (forslag, ikke besluttet)

- [ ] ★★ **Retail-bygg** (`WarcraftLore_Mainline.toc`). Det klart største publikummet på CurseForge, og det som
      skal til for å nå 10 000. Samme API som Forever, men mange NPC-er har ny ID, nytt sted eller er borte etter
      Cataclysm. Krever en egen gjennomgang av dataene, sone for sone, og testing i en Retail-klient.
      Første steg: en rapport over hvilke veteraner som finnes i Retail med samme ID.
- [ ] **Wago Addons og WoWInterface** i tillegg til CurseForge. Packageren støtter begge
      (`WAGO_API_TOKEN`, `WOWI_API_TOKEN` + `X-Wago-ID`/`X-WoWI-ID` i .toc). Teller ikke mot CurseForge-målet,
      men gir nye brukere. Utsatt av Håkon 2026-11-13.

## Valgt bort

- **Markedsføring** (Reddit, Discord, lore-innlegg): Håkon vil ikke markedsføre (2026-11-13).
- **TomTom-pil** til veteraner: ikke ønsket (2026-11-13).

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
- [x] Bibliotek: 18 History of Warcraft-bøker, 16 veteraner i høynivå-dungeons/raids/AV, full kvalitetssjekk (v0.9)

Bakgrunn: den simulerte tidslinjen «Sagaen om Warcraft Lore» (`simulering/story.js`,
https://claude.ai/artifact/2hq7XRetf3PKrCvDYLs2WC) var kilden til mange av funksjonsønskene over.
API-navn i forslagene må sjekkes med `/wcl debug` eller i spillet før de tas i bruk.
